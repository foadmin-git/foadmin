# app/routers/convert.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
import os, io, base64, shutil, subprocess, tempfile, urllib.parse, hashlib
from typing import Optional, List
from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Depends, Request
from sqlalchemy.orm import Session
from sqlalchemy import and_
from app.core.deps import require_perm
import fitz  # PyMuPDF
import mammoth

from app.core.db import get_db
from app.core.deps import get_current_user
from app.routers.media import ensure_dir, get_actor_id, get_upload_root
from app.models.media import MediaFile
from app.models.media import MediaConvertCache  # ✅ 新增缓存模型

router = APIRouter(prefix="/api/convert", tags=["convert"])

# -------- 公共工具：生成绝对预览URL + token --------
def _extract_bearer_token(request: Request) -> str | None:
    auth = request.headers.get("Authorization") or ""
    if auth.lower().startswith("bearer "):
        return auth[7:].strip()
    return None

def _preview_url(sha256: str, request: Request, token: str | None) -> str:
    """生成媒体预览URL（使用SHA256而非ID，防止遍历攻击）"""
    base = str(request.base_url).rstrip("/")
    return f"{base}/api/admin/media/preview/{sha256}"

def _img_tag(src: str) -> str:
    style = 'style="max-width:100%;display:block;margin:8px 0;"'
    return f'<p><img src="{src}" {style} /></p>'

def _data_url(mime: str, buf: bytes) -> str:
    return f"data:{mime};base64,{base64.b64encode(buf).decode()}"

def _ensure_soffice():
    path = shutil.which("soffice") or shutil.which("libreoffice")
    if not path:
        raise HTTPException(500, "后端未安装 LibreOffice（soffice），无法转换 PPTX/PDF/HTML")
    return path

def _save_bytes_as_media(db: Session, user, buf: bytes, filename: str, mime: str, dir_hint="convert") -> int:
    from datetime import datetime
    sha256 = hashlib.sha256(buf).hexdigest()
    ext = os.path.splitext(filename)[1].lstrip(".").lower()
    ymd = datetime.now().strftime("%Y/%m/%d")
    rel_dir = os.path.join(dir_hint, ymd)
    # 动态获取上传根目录（支持热更新）
    upload_root = get_upload_root(db)
    abs_dir = os.path.normpath(os.path.join(upload_root, rel_dir))
    ensure_dir(abs_dir)
    safe_name = f"{sha256[:16]}{('.'+ext) if ext else ''}"
    abs_path = os.path.join(abs_dir, safe_name)
    with open(abs_path, "wb") as f: f.write(buf)

    mf = MediaFile(
        dir_id=None, filename=filename, ext=ext, mime=mime, size=len(buf), sha256=sha256,
        width=None, height=None, duration=None, storage="local",
        path=os.path.join(rel_dir, safe_name), url=None,
        uploader_id=get_actor_id(user), remark="convert",
    )
    db.add(mf); db.commit(); db.refresh(mf)
    return mf.id

# -------- 缓存相关 --------
def _get_src_sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def _get_cache(db: Session, kind: str, sha: str) -> MediaConvertCache | None:
    return db.query(MediaConvertCache).filter(
        and_(MediaConvertCache.kind == kind, MediaConvertCache.src_sha256 == sha)
    ).first()

def _save_cache(db: Session, kind: str, sha: str, *, html: str | None, file_ids: List[int] | None, pages: int | None):
    rec = _get_cache(db, kind, sha)
    if rec is None:
        rec = MediaConvertCache(kind=kind, src_sha256=sha)
        db.add(rec)
    rec.html = html
    rec.file_ids = ",".join(map(str, file_ids)) if file_ids else None
    rec.pages = pages
    db.commit()
    return rec

def _html_from_file_ids(ids: List[int], *, inline: int, request: Request, token: Optional[str], db: Session) -> str:
    """
    用缓存的图片 file_ids 生成 HTML：inline=1 走 dataURL；否则走预览 URL（绝对地址+SHA256）
    """
    parts: List[str] = []
    if inline:
        # 读取磁盘，转 base64
        # 动态获取上传根目录（支持热更新）
        upload_root = get_upload_root(db)
        for fid in ids:
            mf: MediaFile | None = db.get(MediaFile, fid)
            if not mf: 
                continue
            abs_path = os.path.join(upload_root, mf.path)
            if not os.path.exists(abs_path):
                continue
            try:
                buf = open(abs_path, "rb").read()
                mime = mf.mime or "image/png"
                parts.append(_img_tag(_data_url(mime, buf)))
            except Exception:
                continue
    else:
        # 直接拼预览 URL（使用SHA256）
        for fid in ids:
            media: MediaFile | None = db.get(MediaFile, fid)
            if not media or not media.sha256:
                continue
            parts.append(_img_tag(_preview_url(media.sha256, request, token)))
    return "\n".join(parts)

# ================= DOCX =================
@router.post("/docx", dependencies=[Depends(require_perm("docx:import"))])
async def convert_docx(
    request: Request,
    file: UploadFile = File(...),
    inline: int = Form(1),
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user),
):
    data = await file.read()
    if not data:
        raise HTTPException(400, "空文件")
    sha = _get_src_sha256(data)

    # 命中缓存？
    cache = _get_cache(db, "docx", sha)
    if cache:
        # 优先 html（mammoth/soffice 已渲染的富文本）
        if cache.html:
            return {"html": cache.html, "pages": cache.pages or None}
        # 否则用 file_ids 组装（soffice 走图片）
        if cache.file_ids:
            token = _extract_bearer_token(request)
            ids = [int(x) for x in cache.file_ids.split(",") if x.strip()]
            html = _html_from_file_ids(ids, inline=inline, request=request, token=token, db=db)
            return {"html": html, "pages": cache.pages or len(ids)}
        # 缓存异常则继续转换

    # 1) 优先 mammoth：结构化 HTML（不带内嵌图；但文字保真度高）
    try:
        res = mammoth.convert_to_html(io.BytesIO(data))
        html = res.value or ""
        if html.strip():
            _save_cache(db, "docx", sha, html=html, file_ids=None, pages=None)
            return {"html": html}
    except Exception:
        pass

    # 2) 回退 soffice -> HTML（带图片目录），把图片落盘到媒体库，缓存 file_ids；下次复用
    soffice = _ensure_soffice()
    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, "in.docx")
        with open(src, "wb") as f: f.write(data)
        cmd = [soffice, "--headless", "--convert-to", "html", "--outdir", tmp, src]
        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        html_path = os.path.join(tmp, "in.html")
        if not os.path.exists(html_path):
            raise HTTPException(500, "DOCX 转换 HTML 失败")

        # 替换图片为 dataURL 或 预览 URL（若想缓存成 file_ids，可把它们也入库）
        html = open(html_path, "r", encoding="utf-8", errors="ignore").read()
        media_dir = os.path.join(tmp, "media")
        created_ids: List[int] = []
        token = _extract_bearer_token(request)
        if os.path.isdir(media_dir):
            for name in os.listdir(media_dir):
                p = os.path.join(media_dir, name)
                try:
                    buf = open(p, "rb").read()
                    mime = "image/png"
                    if name.lower().endswith((".jpg", ".jpeg")): mime = "image/jpeg"
                    # 图片进媒体库 -> 记录 id，方便下次复用
                    fid = _save_bytes_as_media(db, user, buf, name, mime, dir_hint="convert")
                    created_ids.append(fid)
                    # 获取SHA256用于生成预览URL
                    mf = db.get(MediaFile, fid)
                    url = _data_url(mime, buf) if inline else (_preview_url(mf.sha256, request, token) if mf else "")
                    html = html.replace(f'src="media/{name}"', f'src="{url}"')
                except Exception:
                    continue

        # 缓存：这里既可存最终 html，也可存 file_ids（两者都存也行）
        _save_cache(db, "docx", sha, html=html, file_ids=created_ids, pages=None)
        return {"html": html}

# ================= PDF =================
@router.post("/pdf", dependencies=[Depends(require_perm("pdf:import"))])
async def convert_pdf(
    request: Request,
    file: UploadFile = File(...),
    inline: int = Form(1),
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user),
    dpi: int = Form(144)
):
    data = await file.read()
    if not data:
        raise HTTPException(400, "空文件")
    sha = _get_src_sha256(data)

    # 命中缓存？
    cache = _get_cache(db, "pdf", sha)
    if cache and cache.file_ids:
        token = _extract_bearer_token(request)
        ids = [int(x) for x in cache.file_ids.split(",") if x.strip()]
        html = _html_from_file_ids(ids, inline=inline, request=request, token=token, db=db)
        return {"html": html, "pages": cache.pages or len(ids)}

    # 未命中 -> 渲染成图片并入库
    doc = fitz.open(stream=data, filetype="pdf")
    if doc.page_count == 0:
        raise HTTPException(400, "PDF 无页面")

    token = _extract_bearer_token(request)
    ids: List[int] = []
    parts: List[str] = []
    for i in range(doc.page_count):
        page = doc.load_page(i)
        zoom = dpi / 72.0
        mat = fitz.Matrix(zoom, zoom)
        pix = page.get_pixmap(matrix=mat, alpha=False)
        img_buf = pix.tobytes("png")
        fid = _save_bytes_as_media(db, user, img_buf, f"pdf_{i+1}.png", "image/png", dir_hint="convert")
        ids.append(fid)
        # 获取SHA256用于生成预览URL
        mf = db.get(MediaFile, fid)
        src = _data_url("image/png", img_buf) if inline else (_preview_url(mf.sha256, request, token) if mf else "")
        parts.append(_img_tag(src))
    html = "\n".join(parts)

    _save_cache(db, "pdf", sha, html=None, file_ids=ids, pages=doc.page_count)
    return {"html": html, "pages": doc.page_count}

# ================= PPTX =================
@router.post("/pptx", dependencies=[Depends(require_perm("pptx:import"))])
async def convert_pptx(
    request: Request,
    file: UploadFile = File(...),
    inline: int = Form(1),
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user),
    dpi: int = Form(144),
):
    data = await file.read()
    if not data:
        raise HTTPException(400, "空文件")
    sha = _get_src_sha256(data)

    # 命中缓存？
    cache = _get_cache(db, "pptx", sha)
    if cache and cache.file_ids:
        token = _extract_bearer_token(request)
        ids = [int(x) for x in cache.file_ids.split(",") if x.strip()]
        html = _html_from_file_ids(ids, inline=inline, request=request, token=token, db=db)
        return {"html": html, "pages": cache.pages or len(ids)}

    # 未命中 -> 先用 soffice 转 PDF，再渲染为图片并入库
    soffice = _ensure_soffice()
    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, "in.pptx")
        with open(src, "wb") as f: f.write(data)
        r = subprocess.run([soffice, "--headless", "--convert-to", "pdf", "--outdir", tmp, src],
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if r.returncode != 0:
            raise HTTPException(500, f"PPTX 转 PDF 失败：{r.stderr.decode(errors='ignore')[:200]}")
        pdf_path = os.path.join(tmp, "in.pdf")
        if not os.path.exists(pdf_path):
            raise HTTPException(500, "PPTX 转 PDF 失败（未生成文件）")

        pdf_bytes = open(pdf_path, "rb").read()
        doc = fitz.open(stream=pdf_bytes, filetype="pdf")
        token = _extract_bearer_token(request)

        ids: List[int] = []
        parts: List[str] = []
        zoom = dpi / 72.0
        mat = fitz.Matrix(zoom, zoom)
        for i in range(doc.page_count):
            pix = doc.load_page(i).get_pixmap(matrix=mat, alpha=False)
            img_buf = pix.tobytes("png")
            fid = _save_bytes_as_media(db, user, img_buf, f"ppt_{i+1}.png", "image/png", dir_hint="convert")
            ids.append(fid)
            # 获取SHA256用于生成预览URL
            mf = db.get(MediaFile, fid)
            src = _data_url("image/png", img_buf) if inline else (_preview_url(mf.sha256, request, token) if mf else "")
            parts.append(_img_tag(src))
        html = "\n".join(parts)

        _save_cache(db, "pptx", sha, html=None, file_ids=ids, pages=doc.page_count)
        return {"html": html, "pages": doc.page_count}

