# app/routers/admin_audit.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, Query, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from typing import Optional
from datetime import datetime, timedelta
import csv, io, json

from app.core.db import get_db
from app.models.audit import AuditLog
from app.schemas.audit import PageOut, DetailOut, AuditLogOut
from app.core.deps import require_perm

router = APIRouter(prefix="/api/admin/audit", tags=["audit"])

def _parse_dt(s: Optional[str]) -> Optional[datetime]:
    if not s: return None
    for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d", "%Y/%m/%d %H:%M:%S"):
        try:
            return datetime.strptime(s, fmt)
        except Exception:
            continue
    try:
        return datetime.fromisoformat(s.replace("Z",""))
    except Exception:
        return None

@router.get("/logs", response_model=PageOut, dependencies=[Depends(require_perm("audit:log:list"))])
def list_logs(
    db: Session = Depends(get_db),
    page: int = Query(1, ge=1),
    size: int = Query(10, ge=1, le=200),
    kw: Optional[str] = None,
    level: Optional[str] = None,
    status: Optional[str] = None,
    method: Optional[str] = None,
    action: Optional[str] = None,
    resource_type: Optional[str] = None,
    resource_id: Optional[str] = None,
    actor_id: Optional[int] = None,
    http_status: Optional[int] = None,
    ip: Optional[str] = None,
    trace_id: Optional[str] = None,
    start: Optional[str] = None,
    end: Optional[str] = None,
):
    q = db.query(AuditLog)

    if level: q = q.filter(AuditLog.level == level)
    if status: q = q.filter(AuditLog.status == status)
    if method: q = q.filter(AuditLog.method == method)
    if action: q = q.filter(AuditLog.action == action)
    if resource_type: q = q.filter(AuditLog.resource_type == resource_type)
    if resource_id: q = q.filter(AuditLog.resource_id == resource_id)
    if actor_id is not None: q = q.filter(AuditLog.actor_id == actor_id)
    if http_status is not None: q = q.filter(AuditLog.http_status == http_status)
    if ip: q = q.filter(AuditLog.ip == ip)
    if trace_id: q = q.filter(AuditLog.trace_id == trace_id)

    sdt = _parse_dt(start); edt = _parse_dt(end)
    if sdt: q = q.filter(AuditLog.created_at >= sdt)
    if edt: q = q.filter(AuditLog.created_at <= edt)

    if kw:
        like = f"%{kw}%"
        q = q.filter(
            (AuditLog.actor_name.ilike(like)) |
            (AuditLog.action.ilike(like)) |
            (AuditLog.resource_type.ilike(like)) |
            (AuditLog.resource_id.ilike(like)) |
            (AuditLog.trace_id.ilike(like)) |
            (AuditLog.message.ilike(like)) |
            (AuditLog.path.ilike(like)) |
            (AuditLog.ip.ilike(like)) |
            (AuditLog.user_agent.ilike(like))
        )

    total = q.count()
    items = q.order_by(AuditLog.id.desc()).offset((page-1)*size).limit(size).all()
    return {"items": items, "total": total}

@router.get("/logs/{log_id}", response_model=DetailOut, dependencies=[Depends(require_perm("audit:log:detailApi"))])
def log_detail(log_id: int, db: Session = Depends(get_db)):
    row = db.query(AuditLog).get(log_id)
    if not row:
        raise HTTPException(status_code=404, detail="Not found")
    return {"data": row}

@router.get("/export", dependencies=[Depends(require_perm("audit:log:exportApi"))])
def export_logs(
    db: Session = Depends(get_db),
    kw: Optional[str] = None,
    level: Optional[str] = None,
    status: Optional[str] = None,
    method: Optional[str] = None,
    action: Optional[str] = None,
    resource_type: Optional[str] = None,
    resource_id: Optional[str] = None,
    actor_id: Optional[int] = None,
    http_status: Optional[int] = None,
    ip: Optional[str] = None,
    trace_id: Optional[str] = None,
    start: Optional[str] = None,
    end: Optional[str] = None,
):
    # 复用 list 的筛选
    q = db.query(AuditLog)
    if level: q = q.filter(AuditLog.level == level)
    if status: q = q.filter(AuditLog.status == status)
    if method: q = q.filter(AuditLog.method == method)
    if action: q = q.filter(AuditLog.action == action)
    if resource_type: q = q.filter(AuditLog.resource_type == resource_type)
    if resource_id: q = q.filter(AuditLog.resource_id == resource_id)
    if actor_id is not None: q = q.filter(AuditLog.actor_id == actor_id)
    if http_status is not None: q = q.filter(AuditLog.http_status == http_status)
    if ip: q = q.filter(AuditLog.ip == ip)
    if trace_id: q = q.filter(AuditLog.trace_id == trace_id)
    sdt = _parse_dt(start); edt = _parse_dt(end)
    if sdt: q = q.filter(AuditLog.created_at >= sdt)
    if edt: q = q.filter(AuditLog.created_at <= edt)
    if kw:
        like = f"%{kw}%"
        q = q.filter(
            (AuditLog.actor_name.ilike(like)) |
            (AuditLog.action.ilike(like)) |
            (AuditLog.resource_type.ilike(like)) |
            (AuditLog.resource_id.ilike(like)) |
            (AuditLog.trace_id.ilike(like)) |
            (AuditLog.message.ilike(like)) |
            (AuditLog.path.ilike(like)) |
            (AuditLog.ip.ilike(like)) |
            (AuditLog.user_agent.ilike(like))
        )

    def iter_csv():
        header = ["id","created_at","level","status","action","resource_type","resource_id",
                  "actor_id","actor_name","ip","method","path","http_status","latency_ms",
                  "trace_id","message","diff_before","diff_after","extra"]
        buf = io.StringIO()
        writer = csv.writer(buf)
        writer.writerow(header)
        yield buf.getvalue(); buf.seek(0); buf.truncate(0)

        batch = 1000
        offset = 0
        while True:
          rows = q.order_by(AuditLog.id.desc()).offset(offset).limit(batch).all()
          if not rows: break
          for r in rows:
              def j(x):
                  try: return json.dumps(x, ensure_ascii=False)
                  except: return str(x) if x is not None else ""
              writer.writerow([
                  r.id, r.created_at, r.level, r.status, r.action, r.resource_type, r.resource_id,
                  r.actor_id, r.actor_name, r.ip, r.method, r.path, r.http_status, r.latency_ms,
                  r.trace_id, r.message, j(r.diff_before), j(r.diff_after), j(r.extra),
              ])
          yield buf.getvalue(); buf.seek(0); buf.truncate(0)
          offset += batch

    filename = f"audit_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv"
    return StreamingResponse(iter_csv(),
                             media_type="text/csv; charset=utf-8",
                             headers={"Content-Disposition": f'attachment; filename="{filename}"'})

@router.delete("/logs", dependencies=[Depends(require_perm("audit:log:purgeApi"))])
def purge_logs(
    db: Session = Depends(get_db),
    days: Optional[int] = Query(None, ge=0, description="清理days天前"),
    before: Optional[str] = Query(None, description="清理该时间点之前，格式 ISO 或 'YYYY-MM-DD HH:mm:ss'")
):
    cutoff: Optional[datetime] = None
    if days and days > 0:
        cutoff = datetime.now() - timedelta(days=days)
    if before:
        dt = _parse_dt(before)
        if dt: cutoff = dt
    if not cutoff:
        raise HTTPException(status_code=422, detail="必须提供 days 或 before")
    q = db.query(AuditLog).filter(AuditLog.created_at < cutoff)
    count = q.count()
    q.delete(synchronize_session=False)
    db.commit()
    return {"ok": True, "deleted": count, "message": f"已清理 {count} 条"}
