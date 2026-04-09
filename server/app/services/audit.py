# app/services/audit.py
from typing import Any, Optional, Dict, Callable
from sqlalchemy.orm import Session
from functools import wraps
from app.models.audit import AuditLog

def write_audit(
    db: Session, *,
    trace_id: str,
    level: str,
    status: str,
    action: str,
    resource_type: str,
    resource_id: Optional[str] = None,
    actor_id: Optional[int] = None,
    actor_name: Optional[str] = None,
    actor_roles: Optional[Any] = None,
    ip: Optional[str] = None,
    user_agent: Optional[str] = None,
    method: Optional[str] = None,
    path: Optional[str] = None,
    http_status: Optional[int] = None,
    latency_ms: Optional[int] = None,
    message: Optional[str] = None,
    diff_before: Optional[Any] = None,
    diff_after: Optional[Any] = None,
    extra: Optional[Any] = None,
):
    row = AuditLog(
        trace_id=trace_id, level=level, status=status,
        action=action, resource_type=resource_type, resource_id=resource_id,
        actor_id=actor_id, actor_name=actor_name, actor_roles=actor_roles,
        ip=ip, user_agent=user_agent, method=method, path=path,
        http_status=http_status, latency_ms=latency_ms, message=message,
        diff_before=diff_before, diff_after=diff_after, extra=extra
    )
    db.add(row)
    db.commit()

def audited(action: str, resource_type: str, level: str = "BUSINESS"):
    """
    用在具体业务接口上，记录一次业务事件。
    例：
    @router.post("/users")
    @audited("create", "user")
    def create_user(...):
        ...
    """
    def deco(func: Callable):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            from fastapi import Request
            from app.core.db import SessionLocal
            # 透传 request（FastAPI 约定：通常叫 request）
            request: Request = None
            for a in args:
                if getattr(a, "headers", None):
                    request = a; break
            if request is None:
                request = kwargs.get("request")
            # 执行业务
            import time
            start = time.perf_counter()
            http_status = 200
            status = "SUCCESS"
            message = None
            try:
                resp = await func(*args, **kwargs)
                try:
                    http_status = getattr(resp, "status_code", 200) or 200
                except Exception:
                    pass
                return resp
            except Exception as e:
                status = "FAIL"
                message = str(e)[:500]
                http_status = getattr(e, "status_code", 500) or 500
                raise
            finally:
                latency_ms = int((time.perf_counter() - start) * 1000)
                # 收集上下文
                from app.core.trace import get_or_create_trace_id
                trace_id = get_or_create_trace_id(request) if request else "-"
                ip = request.client.host if request and request.client else None
                ua = request.headers.get("user-agent") if request else None
                method = request.method if request else None
                path = request.url.path if request else None
                # 取用户
                actor_id = getattr(request.state, "user_id", None) if request else None
                actor_name = getattr(request.state, "user_name", None) if request else None
                #actor_roles = getattr(request.state, "user_roles", None) if request else None
                actor_roles = getattr(request.state, "user_roles", None) if request else None
                actor_roles = getattr(request.state, "roles", None) if request else None
                if (not actor_roles) and request:
                    actor_id = getattr(request.state, "user_id", None)
                    if actor_id:
                        with SessionLocal() as _db:
                            try:
                                rows = _db.execute(
                                    text("""
                                    SELECT r.code FROM foadmin_sys_role r
                                    JOIN foadmin_rel_user_role ur ON r.id = ur.role_id
                                    WHERE ur.user_id = :uid AND r.status = 1
                                    """),
                                    {"uid": int(actor_id)}
                                ).mappings().all()
                                actor_roles = [row["code"] for row in rows]
                            except Exception:
                                actor_roles = None

                resource_id = None
                try:
                    path_params = (request.scope or {}).get("path_params", {}) if request else {}
                except Exception:
                     path_params = {}
                # 常见主键命名兜底：id / rid / pid / uid / file_id / user_id ...
                for k in ("id", "rid", "pid", "uid", "file_id", "user_id"):
                    if k in path_params and path_params[k] is not None:
                        resource_id = str(path_params[k])
                        break   
                # 持久化
                db = SessionLocal()
                try:
                    write_audit(
                        db,
                        trace_id=trace_id, level=level, status=status,
                        #action=action, resource_type=resource_type,
                        action=action, resource_type=resource_type, resource_id=resource_id,
                        actor_id=actor_id, actor_name=actor_name, actor_roles=actor_roles,
                        ip=ip, user_agent=ua, method=method, path=path,
                        http_status=http_status, latency_ms=latency_ms, message=message
                    )
                finally:
                    db.close()
        return wrapper
    return deco
