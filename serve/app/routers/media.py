# app/routers/media.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
import os
import io
import hashlib
import time
import urllib.parse
from datetime import datetime
from typing import Optional, Any, List


from fastapi import (
    APIRouter, Depends, UploadFile, File, Form, HTTPException,
    Header, Request, Query
)
from fastapi.responses import FileResponse, StreamingResponse, Response
from sqlalchemy.orm import Session
from sqlalchemy import func

from app.core.db import get_db
from app.core.deps import require_perm, get_current_user
from app.core.config_loader import get_config
from app.models.media import MediaDir, MediaFile, MediaTag, RelMediaFileTag, MediaAudit
from app.schemas.media import DirCreate, DirUpdate, RenameBody, FileTagsBody

# 如果你项目已内置 settings.SECRET_KEY / ALGORITHM，可使用它们；否则 fallback 为不校验
try:
    from app.core.config import settings
    HAS_SETTINGS = bool(getattr(settings, "SECRET_KEY", None)) and bool(getattr(settings, "ALGORITHM", None))
except Exception:
    settings = None  # type: ignore
    HAS_SETTINGS = False

try:
    from jose import jwt  # pip install python-jose
except Exception:
    jwt = None  # type: ignore

router = APIRouter(prefix="/api/admin/media", tags=["admin-media"])

# === 默认上传根目录（已弃用，现在从系统配置读取）===
# UPLOAD_ROOT = os.getenv("FOADMIN_UPLOAD_ROOT", "./runtime/uploads")
# os.makedirs(UPLOAD_ROOT, exist_ok=True)


def get_upload_root(db: Session | None = None) -> str:
    """
    从系统配置获取上传根目录（动态读取，支持热更新）
    """
    upload_path = get_config('upload_path', 'string', './runtime/uploads', db)
    upload_root = os.path.abspath(upload_path)
    ensure_dir(upload_root)
    return upload_root


def ensure_dir(p: str) -> None:
    os.makedirs(p, exist_ok=True)


def get_actor_id(user: Any) -> int:
    """
    兼容 get_current_user 返回 dict 或 ORM 对象：
    - 可能包含 id/sub/user_id 等
    """
    if user is None:
        raise HTTPException(401, "未登录")
    if isinstance(user, dict):
        val = user.get("id") or user.get("sub") or user.get("user_id")
        if val is None:
            raise HTTPException(401, "无效的用户信息")
        try:
            return int(val)
        except Exception:
            raise HTTPException(401, "无效的用户信息")
    if hasattr(user, "id"):
        return int(getattr(user, "id"))
    raise HTTPException(401, "无效的用户信息")


def record_audit(db: Session, file_id: int, action: str, actor_id: int, ip: str | None = None, ua: str | None = None):
    db.add(MediaAudit(file_id=file_id, action=action, actor_id=actor_id, ip=ip, ua=ua))
    db.commit()


# ---------------- 目录 CRUD ----------------

@router.get("/dirs", dependencies=[Depends(require_perm("media:dir"))])
def list_dirs(db: Session = Depends(get_db)):
    rows = db.query(MediaDir).all()

    def to_tree(items):
        mp = {
            d.id: {
                "id": d.id,
                "parent_id": d.parent_id,
                "name": d.name,
                "sort": d.sort,
                "children": []
            } for d in items
        }
        roots = []
        for d in items:
            node = mp[d.id]
            if d.parent_id and d.parent_id in mp:
                mp[d.parent_id]["children"].append(node)
            else:
                roots.append(node)

        def sort_rec(ns):
            ns.sort(key=lambda x: (x["sort"], x["id"]))
            for c in ns:
                sort_rec(c["children"])
        sort_rec(roots)
        return roots

    return {"items": to_tree(rows)}


@router.post("/dirs", dependencies=[Depends(require_perm("media:dir"))])
def create_dir(
    payload: DirCreate,
    db: Session = Depends(get_db),
):
    d = MediaDir(name=payload.name, parent_id=payload.parent_id, sort=payload.sort)
    db.add(d)
    db.commit()
    db.refresh(d)
    return {"id": d.id}


@router.put("/dirs/{id}", dependencies=[Depends(require_perm("media:dir"))])
def update_dir(
    id: int,
    payload: DirUpdate,
    db: Session = Depends(get_db),
):
    d = db.get(MediaDir, id)
    if not d:
        raise HTTPException(404, "目录不存在")
    if payload.name is not None:
        d.name = payload.name
    if payload.parent_id is not None:
        d.parent_id = payload.parent_id
    if payload.sort is not None:
        d.sort = payload.sort
    db.commit()
    return {"ok": True}


@router.delete("/dirs/{id}", dependencies=[Depends(require_perm("media:dir"))])
def delete_dir(id: int, db: Session = Depends(get_db)):
    if db.query(MediaDir).filter(MediaDir.parent_id == id).count():
        raise HTTPException(400, "请先删除子目录")
    if db.query(MediaFile).filter(MediaFile.dir_id == id, MediaFile.deleted_at.is_(None)).count():
        raise HTTPException(400, "目录下存在文件")
    d = db.get(MediaDir, id)
    if not d:
        raise HTTPException(404, "目录不存在")
    db.delete(d)
    db.commit()
    return {"ok": True}


# ---------------- 标签 APIs ----------------

@router.get("/tags", dependencies=[Depends(require_perm("media:view"))])
def list_tags(db: Session = Depends(get_db)):
    """
    列出所有标签（带文件数）
    """
    rows = (
        db.query(MediaTag.id, MediaTag.name, func.count(RelMediaFileTag.file_id).label("count"))
        .outerjoin(RelMediaFileTag, RelMediaFileTag.tag_id == MediaTag.id)
        .group_by(MediaTag.id)
        .order_by(MediaTag.name.asc())
        .all()
    )
    return {"items": [{"id": r.id, "name": r.name, "count": int(r.count or 0)} for r in rows]}


@router.post("/tags", dependencies=[Depends(require_perm("media:upload"))])
def create_tag(
    name: str,
    db: Session = Depends(get_db)
):
    """创建标签"""
    if not name or not name.strip():
        raise HTTPException(400, "标签名不能为空")
    
    name = name.strip()
    existing = db.query(MediaTag).filter_by(name=name).first()
    if existing:
        raise HTTPException(400, "标签已存在")
    
    tag = MediaTag(name=name)
    db.add(tag)
    db.commit()
    db.refresh(tag)
    return {"id": tag.id, "name": tag.name}


@router.delete("/tags/{tid}", dependencies=[Depends(require_perm("media:upload"))])
def delete_tag(
    tid: int,
    db: Session = Depends(get_db)
):
    """删除标签（只能删除未使用的标签）"""
    tag = db.get(MediaTag, tid)
    if not tag:
        raise HTTPException(404, "标签不存在")
    
    # 检查是否有文件使用此标签
    count = db.query(RelMediaFileTag).filter_by(tag_id=tid).count()
    if count > 0:
        raise HTTPException(400, f"标签正在被 {count} 个文件使用，无法删除")
    
    db.delete(tag)
    db.commit()
    return {"ok": True}


@router.put("/{fid}/tags", dependencies=[Depends(require_perm("media:upload"))])
def set_file_tags(
    fid: int,
    payload: FileTagsBody,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user),
):
    """
    覆盖设置文件标签（传标签名数组），不存在的标签会自动创建
    优化：批量查询和创建，减少数据库交互
    """
    f = db.get(MediaFile, fid)
    if not f:
        raise HTTPException(404, "文件不存在")

    names = [t.strip() for t in payload.tags if t and t.strip()]
    
    # 清空旧关系
    db.query(RelMediaFileTag).filter(RelMediaFileTag.file_id == fid).delete()

    # 批量查询已存在的标签
    existing_tags = db.query(MediaTag).filter(MediaTag.name.in_(names)).all()
    existing_map = {tag.name: tag.id for tag in existing_tags}
    
    # 找出不存在的标签名
    new_names = [name for name in names if name not in existing_map]
    
    # 批量创建新标签
    new_tags = []
    for name in new_names:
        tag = MediaTag(name=name)
        db.add(tag)
        new_tags.append(tag)
    
    # 提交以获取新标签的ID
    if new_tags:
        db.flush()  # 获取ID但不提交事务
        for tag in new_tags:
            existing_map[tag.name] = tag.id
    
    # 批量创建关联关系
    for name in names:
        tag_id = existing_map.get(name)
        if tag_id:
            db.add(RelMediaFileTag(file_id=fid, tag_id=tag_id))
    
    db.commit()

    record_audit(db, fid, "set_tags", get_actor_id(user))
    return {"ok": True, "tag_ids": list(existing_map.values())}


# ---------------- 文件 上传/列表/删除/重命名/下载 ----------------

@router.post("/upload", dependencies=[Depends(require_perm("media:upload"))])
async def upload_file(
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user),
    file: UploadFile = File(...),
    dir_id: Optional[int] = Form(None),
    remark: Optional[str] = Form(None),
    tags: Optional[str] = Form(None),
):
    """
    上传媒体文件，从系统配置读取上传参数
    - upload_max_size: 最大文件大小(MB)
    - upload_allowed_exts: 允许的文件后缀（逗号分隔）
    - upload_path: 本地上传路径
    - upload_storage: 存储方式（local/oss/cos）
    """
    try:
        # 从系统配置读取上传参数
        max_size_mb = get_config('upload_max_size', 'number', 10, db)  # 默认 10MB
        allowed_exts_str = get_config('upload_allowed_exts', 'string', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip', db)
        upload_storage = get_config('upload_storage', 'string', 'local', db)
        upload_path = get_config('upload_path', 'string', './runtime/uploads', db)
        
        # 解析允许的文件后缀
        allowed_exts = [ext.strip().lower() for ext in allowed_exts_str.split(',') if ext.strip()]
        
        buf = await file.read()
        if not buf:
            raise HTTPException(400, "空文件")

        ext = os.path.splitext(file.filename)[1].lower().strip(".")
        mime = file.content_type or ""
        size = len(buf)
        
        # 检查文件大小
        max_size_bytes = int(max_size_mb) * 1024 * 1024
        if size > max_size_bytes:
            raise HTTPException(400, f"文件大小超过限制（最大{max_size_mb}MB）")
        
        # 检查文件后缀
        if allowed_exts and ext and ext not in allowed_exts:
            raise HTTPException(400, f"不支持的文件类型，允许的后缀：{allowed_exts_str}")
        
        sha256 = hashlib.sha256(buf).hexdigest()

        # 检查是否存在相同的文件，且文件已被软删除
        existing_file = db.query(MediaFile).filter_by(sha256=sha256, size=size).filter(MediaFile.deleted_at.isnot(None)).first()
        
        if existing_file:
            # 如果存在软删除的相同文件，则恢复文件
            existing_file.deleted_at = None  # 恢复删除标记
            existing_file.uploader_id = get_actor_id(user)
            existing_file.remark = remark
            db.commit()
            db.refresh(existing_file)
            record_audit(db, existing_file.id, "restore", get_actor_id(user))  # 记录恢复操作
            return {"id": existing_file.id, "sha256": existing_file.sha256}

        # 使用配置的上传路径（动态获取，支持热更新）
        upload_root = get_upload_root(db)
        
        # 存储目录：media/YYYY/MM/DD
        ymd = datetime.now().strftime("%Y/%m/%d")
        rel_dir = os.path.join("media", ymd)
        abs_dir = os.path.normpath(os.path.join(upload_root, rel_dir))
        if not os.path.abspath(abs_dir).startswith(upload_root):
            raise HTTPException(400, "非法路径")
        ensure_dir(abs_dir)

        safe_name = f"{sha256[:16]}{('.' + ext) if ext else ''}"
        abs_path = os.path.join(abs_dir, safe_name)

        # 写文件
        with open(abs_path, "wb") as f:
            f.write(buf)

        # 图片宽高（可选）
        width = height = duration = None
        if mime.startswith("image/"):
            try:
                from PIL import Image  # pillow
                im = Image.open(io.BytesIO(buf))
                width, height = im.size
            except Exception:
                pass

        mf = MediaFile(
            dir_id=dir_id,
            filename=file.filename,
            ext=ext,
            mime=mime,
            size=size,
            sha256=sha256,
            width=width,
            height=height,
            duration=duration,
            storage=upload_storage,  # 使用配置的存储方式
            path=os.path.join(rel_dir, safe_name),
            url=None,
            uploader_id=get_actor_id(user),
            remark=remark,
        )
        db.add(mf)
        db.commit()
        db.refresh(mf)

        # 标签（可选）- 优化：批量处理
        if tags:
            tag_names = [t.strip() for t in tags.split(",") if t.strip()]
            
            # 批量查询已存在的标签
            existing_tags = db.query(MediaTag).filter(MediaTag.name.in_(tag_names)).all()
            existing_map = {tag.name: tag.id for tag in existing_tags}
            
            # 批量创建新标签
            new_names = [name for name in tag_names if name not in existing_map]
            new_tags = []
            for name in new_names:
                tag = MediaTag(name=name)
                db.add(tag)
                new_tags.append(tag)
            
            # 获取新标签ID
            if new_tags:
                db.flush()
                for tag in new_tags:
                    existing_map[tag.name] = tag.id
            
            # 批量创建关联
            for name in tag_names:
                tag_id = existing_map.get(name)
                if tag_id:
                    db.add(RelMediaFileTag(file_id=mf.id, tag_id=tag_id))
            
            db.commit()

        record_audit(db, mf.id, "upload", get_actor_id(user))
        # 返回 ID + SHA256，供前端使用
        return {"id": mf.id, "sha256": mf.sha256}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(500, f"保存失败：{e}")



@router.get("/list", dependencies=[Depends(require_perm("media:view"))])
def list_files(
    db: Session = Depends(get_db),
    kw: Optional[str] = None,
    dir_id: Optional[int] = None,
    page: int = 1,
    size: int = 20,
    with_deleted: int = 0,
    tag: Optional[str] = None,                 # 单个标签名
    tag_id: Optional[int] = None,              # 单个标签ID
    tags: Optional[str] = None,                # 多个标签名，逗号分隔；满足任意一个
):
    """
    支持按标签过滤：
    - ?tag=logo           按标签名
    - ?tag_id=3           按标签ID
    - ?tags=logo,banner   多标签名，任意匹配（OR）
    """
    q = db.query(MediaFile)
    if kw:
        q = q.filter(MediaFile.filename.like(f"%{kw}%"))
    if dir_id is not None:
        q = q.filter(MediaFile.dir_id == dir_id)
    if not with_deleted:
        q = q.filter(MediaFile.deleted_at.is_(None))

    # 标签过滤
    if tag or tag_id or (tags and tags.strip()):
        q = q.join(RelMediaFileTag, RelMediaFileTag.file_id == MediaFile.id)\
             .join(MediaTag, MediaTag.id == RelMediaFileTag.tag_id)
        if tag:
            q = q.filter(MediaTag.name == tag)
        if tag_id:
            q = q.filter(MediaTag.id == tag_id)
        if tags and tags.strip():
            names = [x.strip() for x in tags.split(",") if x.strip()]
            if names:
                q = q.filter(MediaTag.name.in_(names))

    total = q.count()
    rows = (
        q.order_by(MediaFile.id.desc())
         .offset((page - 1) * size).limit(size)
         .all()
    )

    # 批量查出每个文件的标签
    file_ids = [r.id for r in rows]
    tag_map = {}
    if file_ids:
        pairs = (
            db.query(RelMediaFileTag.file_id, MediaTag.name)
              .join(MediaTag, MediaTag.id == RelMediaFileTag.tag_id)
              .filter(RelMediaFileTag.file_id.in_(file_ids))
              .all()
        )
        for fid2, name in pairs:
            tag_map.setdefault(fid2, []).append(name)

    items = [
        {
            "id": r.id,
            "sha256": r.sha256,  # 新增：供前端使用
            "filename": r.filename,
            "mime": r.mime,
            "size": r.size,
            "ext": r.ext,
            "dir_id": r.dir_id,
            "path": r.path,
            "url": r.url,
            "uploader_id": r.uploader_id,
            "created_at": r.created_at,
            "width": r.width,
            "height": r.height,
            "deleted_at": r.deleted_at,
            "tags": tag_map.get(r.id, []),
        }
        for r in rows
    ]
    return {"items": items, "total": total}


@router.delete("/{fid}", dependencies=[Depends(require_perm("media:delete"))])
def soft_delete(
    fid: int,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    软删除媒体文件：仅标记 deleted_at，不删除物理文件
    """
    f = db.get(MediaFile, fid)
    if not f:
        raise HTTPException(404, "文件不存在")
    if f.deleted_at:
        return {"ok": True}
    
    # 仅标记软删除，不删除物理文件
    f.deleted_at = datetime.utcnow()
    db.commit()
    
    record_audit(db, fid, "soft_delete", get_actor_id(user))
    return {"ok": True}


@router.delete("/{fid}/permanent", dependencies=[Depends(require_perm("media:delete"))])
def hard_delete(
    fid: int,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    硬删除媒体文件：同时删除数据库记录和物理文件
    """
    f = db.get(MediaFile, fid)
    if not f:
        raise HTTPException(404, "文件不存在")
    
    # 删除服务器上的物理文件
    if f.storage == "local" and f.path:
        # 动态获取上传根目录
        upload_root = get_upload_root(db)
        abs_path = os.path.join(upload_root, f.path)
        try:
            if os.path.exists(abs_path):
                os.remove(abs_path)
                record_audit(db, fid, "delete_physical", get_actor_id(user))
        except Exception as e:
            # 物理文件删除失败记录日志，但继续删除数据库记录
            print(f"删除物理文件失败 {abs_path}: {e}")
    
    # 删除文件标签关联
    db.query(RelMediaFileTag).filter(RelMediaFileTag.file_id == fid).delete()
    
    # 删除数据库记录
    db.delete(f)
    db.commit()
    
    record_audit(db, fid, "hard_delete", get_actor_id(user))
    return {"ok": True}


@router.put("/{fid}/restore", dependencies=[Depends(require_perm("media:delete"))])
def restore(
    fid: int,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    恢复已删除的媒体文件（仅恢复数据库记录，物理文件已被删除则无法恢复）
    """
    f = db.get(MediaFile, fid)
    if not f:
        raise HTTPException(404, "文件不存在")
    
    # 检查物理文件是否存在
    if f.storage == "local" and f.path:
        # 动态获取上传根目录
        upload_root = get_upload_root(db)
        abs_path = os.path.join(upload_root, f.path)
        if not os.path.exists(abs_path):
            raise HTTPException(400, "物理文件已被删除，无法恢复")
    
    f.deleted_at = None
    db.commit()
    record_audit(db, fid, "restore", get_actor_id(user))
    return {"ok": True}


@router.put("/{fid}/rename", dependencies=[Depends(require_perm("media:rename"))])
def rename(
    fid: int,
    payload: RenameBody,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    f = db.get(MediaFile, fid)
    if not f:
        raise HTTPException(404, "文件不存在")
    f.filename = payload.name
    db.commit()
    record_audit(db, fid, "rename", get_actor_id(user))
    return {"ok": True}


# ---------------- 批量操作 ----------------

@router.post("/batch/soft-delete", dependencies=[Depends(require_perm("media:delete"))])
def batch_soft_delete(
    file_ids: list[int],
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """批量软删除文件"""
    if not file_ids:
        raise HTTPException(400, "文件ID列表不能为空")
    
    files = db.query(MediaFile).filter(MediaFile.id.in_(file_ids)).all()
    if not files:
        raise HTTPException(404, "文件不存在")
    
    actor_id = get_actor_id(user)
    for f in files:
        if not f.deleted_at:
            f.deleted_at = datetime.utcnow()
            record_audit(db, f.id, "soft_delete", actor_id)
    
    db.commit()
    return {"ok": True, "count": len(files)}


@router.post("/batch/hard-delete", dependencies=[Depends(require_perm("media:delete"))])
def batch_hard_delete(
    file_ids: list[int],
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """批量硬删除文件"""
    if not file_ids:
        raise HTTPException(400, "文件ID列表不能为空")
    
    files = db.query(MediaFile).filter(MediaFile.id.in_(file_ids)).all()
    if not files:
        raise HTTPException(404, "文件不存在")
    
    upload_root = get_upload_root(db)
    actor_id = get_actor_id(user)
    deleted_count = 0
    
    for f in files:
        # 删除物理文件
        if f.storage == "local" and f.path:
            abs_path = os.path.join(upload_root, f.path)
            try:
                if os.path.exists(abs_path):
                    os.remove(abs_path)
            except Exception as e:
                print(f"删除物理文件失败 {abs_path}: {e}")
        
        # 删除标签关联
        db.query(RelMediaFileTag).filter(RelMediaFileTag.file_id == f.id).delete()
        
        # 删除数据库记录
        db.delete(f)
        record_audit(db, f.id, "hard_delete", actor_id)
        deleted_count += 1
    
    db.commit()
    return {"ok": True, "count": deleted_count}


@router.post("/batch/restore", dependencies=[Depends(require_perm("media:delete"))])
def batch_restore(
    file_ids: list[int],
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """批量恢复文件"""
    if not file_ids:
        raise HTTPException(400, "文件ID列表不能为空")
    
    files = db.query(MediaFile).filter(MediaFile.id.in_(file_ids)).all()
    if not files:
        raise HTTPException(404, "文件不存在")
    
    upload_root = get_upload_root(db)
    actor_id = get_actor_id(user)
    restored_count = 0
    
    for f in files:
        # 检查物理文件是否存在
        if f.storage == "local" and f.path:
            abs_path = os.path.join(upload_root, f.path)
            if not os.path.exists(abs_path):
                continue  # 跳过物理文件不存在的
        
        f.deleted_at = None
        record_audit(db, f.id, "restore", actor_id)
        restored_count += 1
    
    db.commit()
    return {"ok": True, "count": restored_count}


@router.post("/batch/move", dependencies=[Depends(require_perm("media:upload"))])
def batch_move(
    file_ids: list[int],
    dir_id: int | None,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """批量移动文件到指定目录"""
    if not file_ids:
        raise HTTPException(400, "文件ID列表不能为空")
    
    # 验证目录是否存在（如果dir_id不为None）
    if dir_id is not None:
        dir = db.get(MediaDir, dir_id)
        if not dir:
            raise HTTPException(404, "目录不存在")
    
    files = db.query(MediaFile).filter(MediaFile.id.in_(file_ids)).all()
    if not files:
        raise HTTPException(404, "文件不存在")
    
    actor_id = get_actor_id(user)
    for f in files:
        f.dir_id = dir_id
        record_audit(db, f.id, "move", actor_id)
    
    db.commit()
    return {"ok": True, "count": len(files)}


@router.get("/download/{sha256}")
def download(
    sha256: str,
    db: Session = Depends(get_db)
):
    """
    下载文件（使用SHA256防止ID遍历）
    - 使用 SHA256 哈希值作为标识符，已提供足够安全性，无需额外鉴权
    - 支持新窗口打开/直接下载
    - 适合公开分享场景
    """
    f = db.query(MediaFile).filter(
        MediaFile.sha256 == sha256,
        MediaFile.deleted_at.is_(None)
    ).first()
    if not f:
        raise HTTPException(404, "文件不存在或已删除")
    # 动态获取上传根目录
    upload_root = get_upload_root(db)
    abs_path = os.path.join(upload_root, f.path)
    if not os.path.exists(abs_path):
        raise HTTPException(404, "物理文件不存在")
    
    # 下载操作不记录审计日志（因为无法获取用户信息）
    # 如果需要记录，可以记录 IP 和 UA
    
    # 对包含非ASCII字符的文件名进行编码
    ascii_filename = f.filename.encode('ascii', 'ignore').decode('ascii')
    if ascii_filename != f.filename:
        # 包含非ASCII字符，需要编码
        encoded_filename = urllib.parse.quote(f.filename.encode('utf-8'))
        content_disposition = f'attachment; filename="{ascii_filename}"; filename*=UTF-8\'\'{encoded_filename}'
    else:
        # 纯ASCII文件名
        content_disposition = f'attachment; filename="{f.filename}"'
    
    return FileResponse(
        abs_path, 
        filename=f.filename, 
        media_type=f.mime or "application/octet-stream",
        headers={
            "Content-Disposition": content_disposition,
            "Cache-Control": "public, max-age=3600"
        }
    )




# ---------------- 预览（全局可用于 <img>/<video>） ----------------

def _decode_user_from_token(token: Optional[str]) -> Optional[int]:
    """尽量校验 query token；失败则返回 None（可按需改为强制 401）"""
    if not token:
        return None
    if not (HAS_SETTINGS and jwt):
        # 未配置解密能力时，放行（或改成 raise HTTPException(401, "...")）
        return None
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])  # type: ignore
        sub = payload.get("sub") or payload.get("id") or payload.get("user_id")
        return int(sub) if sub is not None else None
    except Exception:
        return None


@router.get("/preview/{sha256}")
def preview(
    sha256: str,
    request: Request,
    range_header: Optional[str] = Header(None, alias="Range"),
    db: Session = Depends(get_db),
):
    """
    预览文件（inline）。特性：
    - 使用 SHA256 防止 ID 遍历攻击（SHA256 已足够安全，无需额外签名验证）
    - 支持视频/音频 Range 分段
    - 强缓存/协商缓存：ETag / Last-Modified / If-None-Match / If-Modified-Since
    - 适合公开分享，简单易用
    """
    f = db.query(MediaFile).filter(
        MediaFile.sha256 == sha256,
        MediaFile.deleted_at.is_(None)
    ).first()
    if not f:
        raise HTTPException(404, "文件不存在或已删除")
    # 动态获取上传根目录
    upload_root = get_upload_root(db)
    abs_path = os.path.join(upload_root, f.path)
    if not os.path.exists(abs_path):
        raise HTTPException(404, "物理文件不存在")

    stat = os.stat(abs_path)
    last_modified = datetime.utcfromtimestamp(int(stat.st_mtime))
    etag = f'W/"{f.sha256[:16]}-{stat.st_size}"'
    mime = f.mime or "application/octet-stream"

    # 缓存命中
    inm = request.headers.get("If-None-Match")
    ims = request.headers.get("If-Modified-Since")
    last_mod_str = last_modified.strftime("%a, %d %b %Y %H:%M:%S GMT")
    if (inm and inm == etag) or (ims and ims == last_mod_str):
        return Response(status_code=304, headers={
            "ETag": etag,
            "Last-Modified": last_mod_str,
            "Cache-Control": "public, max-age=31536000, immutable",
        })

    file_size = stat.st_size
    # 对包含非ASCII字符的文件名进行编码
    ascii_filename = f.filename.encode('ascii', 'ignore').decode('ascii')
    if ascii_filename != f.filename:
        # 包含非ASCII字符，需要编码
        encoded_filename = urllib.parse.quote(f.filename.encode('utf-8'))
        content_disposition = f'inline; filename="{ascii_filename}"; filename*=UTF-8\'\'{encoded_filename}'
    else:
        # 纯ASCII文件名
        content_disposition = f'inline; filename="{f.filename}"'
    
    headers = {
        "Accept-Ranges": "bytes",
        "ETag": etag,
        "Last-Modified": last_mod_str,
        "Cache-Control": "public, max-age=31536000, immutable",
        "Content-Disposition": content_disposition,
    }

    # Range
    if range_header and range_header.startswith("bytes="):
        rng = range_header.replace("bytes=", "")
        try:
            start_s, end_s = rng.split("-", 1)
            start = int(start_s) if start_s else 0
            end = int(end_s) if end_s else file_size - 1
            end = min(end, file_size - 1)
            if start > end:
                raise ValueError()
        except Exception:
            raise HTTPException(416, "Range 无效")

        def _file_iter(s: int, e: int, chunk: int = 1024 * 256):
            with open(abs_path, "rb") as fp:
                fp.seek(s)
                remain = e - s + 1
                while remain > 0:
                    data = fp.read(min(chunk, remain))
                    if not data:
                        break
                    remain -= len(data)
                    yield data

        headers.update({
            "Content-Range": f"bytes {start}-{end}/{file_size}",
            "Content-Length": str(end - start + 1),
        })
        return StreamingResponse(_file_iter(start, end), status_code=206, media_type=mime, headers=headers)

    # 非 Range：整体文件
    headers["Content-Length"] = str(file_size)
    return FileResponse(abs_path, media_type=mime, filename=f.filename, headers=headers)

