# app/routers/admin_loginlog.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from datetime import datetime
from app.core.db import get_db
from app.models.login_log import LoginLog
from app.schemas.login_log import PageOut, DetailOut
from app.core.deps import require_perm

router = APIRouter(prefix="/api/admin/logs/login", tags=["login-log"])

def _parse_dt(s: Optional[str]) -> Optional[datetime]:
    if not s: return None
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d"):
        try: return datetime.strptime(s, fmt)
        except Exception: ...
    try:
        return datetime.fromisoformat(s.replace("Z",""))
    except Exception:
        return None


@router.get("",response_model=PageOut, dependencies=[Depends(require_perm("login:log:list"))])  # 权限验证

def list_login_logs(
    db: Session = Depends(get_db),
    page: int = Query(1, ge=1),
    size: int = Query(10, ge=1, le=200),
    kw: Optional[str] = Query(None, description="关键字：用户名/IP/UA/trace"),
    status: Optional[str] = None,
    actor_id: Optional[int] = None,
    ip: Optional[str] = None,
    trace_id: Optional[str] = None,
    start: Optional[str] = None,
    end: Optional[str] = None,
):
    q = db.query(LoginLog)
    if status: q = q.filter(LoginLog.status == status)
    if actor_id is not None: q = q.filter(LoginLog.actor_id == actor_id)
    if ip: q = q.filter(LoginLog.ip == ip)
    if trace_id: q = q.filter(LoginLog.trace_id == trace_id)
    sdt = _parse_dt(start); edt = _parse_dt(end)
    if sdt: q = q.filter(LoginLog.created_at >= sdt)
    if edt: q = q.filter(LoginLog.created_at <= edt)
    if kw:
        like = f"%{kw}%"
        q = q.filter(
            (LoginLog.actor_name.ilike(like)) |
            (LoginLog.ip.ilike(like)) |
            (LoginLog.user_agent.ilike(like)) |
            (LoginLog.trace_id.ilike(like))
        )
    total = q.count()
    items = q.order_by(LoginLog.id.desc()).offset((page-1)*size).limit(size).all()
    return {"items": items, "total": total}






from fastapi.responses import StreamingResponse
import csv, io

@router.get("/export", dependencies=[Depends(require_perm("login:log:exportApi"))])  # 权限验证
def export_login_logs(
    db: Session = Depends(get_db),
    kw: Optional[str] = Query(None, description="关键字：用户名/IP/UA/trace"),
    status: Optional[str] = Query(None),
    actor_id: Optional[int] = Query(None),
    ip: Optional[str] = Query(None),
    trace_id: Optional[str] = Query(None),
    start: Optional[str] = Query(None),
    end: Optional[str] = Query(None),
):
    # 复用 list 的过滤逻辑
    page_out = list_login_logs(
        db=db,
        page=1, 
        size=200000,
        kw=kw,
        status=status,
        actor_id=actor_id,
        ip=ip,
        trace_id=trace_id,
        start=start,
        end=end
    )
    
    def iter_csv():
        header = ["id", "created_at", "status", "actor_id", "actor_name", "ip", "user_agent", "trace_id", "message"]
        buf = io.StringIO()
        w = csv.writer(buf)
        w.writerow(header)
        yield buf.getvalue()
        buf.seek(0)
        buf.truncate(0)
        
        for item in page_out["items"]:
            w.writerow([
                item.id, 
                item.created_at, 
                item.status, 
                item.actor_id, 
                item.actor_name, 
                item.ip, 
                item.user_agent, 
                item.trace_id, 
                item.message or ""
            ])
            yield buf.getvalue()
            buf.seek(0)
            buf.truncate(0)
    
    filename = f"login_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    return StreamingResponse(
        iter_csv(), 
        media_type="text/csv; charset=utf-8",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'}
    )



@router.delete("", dependencies=[Depends(require_perm("login:log:purgeApi"))])  # 权限验证
def purge_login_logs(db: Session = Depends(get_db), before: Optional[str] = None, days: Optional[int] = Query(None, ge=0)):
    from datetime import timedelta
    cutoff = None
    if days and days > 0:
        cutoff = datetime.now() - timedelta(days=days)
    if before:
        cutoff = _parse_dt(before) or cutoff
    if not cutoff:
        from fastapi import HTTPException
        raise HTTPException(status_code=422, detail="必须提供 days 或 before")
    q = db.query(LoginLog).filter(LoginLog.created_at < cutoff)
    cnt = q.count()
    q.delete(synchronize_session=False); db.commit()
    return {"ok": True, "deleted": cnt, "message": f"已清理 {cnt} 条"}


@router.get("/{log_id}", response_model=DetailOut, dependencies=[Depends(require_perm("login:log:detailApi"))])  # 权限验证
def login_log_detail(log_id: int, db: Session = Depends(get_db)):
    row = db.query(LoginLog).get(log_id)
    if not row:
        raise HTTPException(status_code=404, detail="Not found")
    return {"data": row}