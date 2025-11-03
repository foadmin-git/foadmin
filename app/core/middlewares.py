# app/core/middlewares.py
import json, time
from typing import Callable
from starlette.middleware.base import BaseHTTPMiddleware
from fastapi import Request
from app.core.db import SessionLocal
from app.core.trace import get_or_create_trace_id
from app.models.audit import AuditLog
from app.models.login_log import LoginLog
from app.models.user import User
from sqlalchemy import text

WRITE_METHODS = {"POST", "PUT", "PATCH", "DELETE"}
AUDIT_EXCLUDE_PATH_PREFIX = ("/docs", "/redoc", "/openapi", "/static")

class LoginLogMiddleware(BaseHTTPMiddleware):
    LOGIN_PATH = "/api/common/login"

    async def dispatch(self, request: Request, call_next: Callable):
        if request.url.path != self.LOGIN_PATH or request.method not in {"POST"}:
            return await call_next(request)

        start = time.perf_counter()
        body_bytes = await request.body()
        username = None
        try:
            data = json.loads(body_bytes.decode("utf-8") or "{}")
            username = data.get("username") or data.get("account") or data.get("user")
        except Exception:
            pass

        async def receive():
            return {"type": "http.request", "body": body_bytes, "more_body": False}
        request._receive = receive

        status = "SUCCESS"; message = None; http_status = 200
        try:
            response = await call_next(request)
            http_status = getattr(response, "status_code", 200) or 200
            if http_status >= 400:
                status = "FAIL"
                message = f"HTTP {http_status}"
            return response
        except Exception as e:
            status = "FAIL"
            http_status = getattr(e, "status_code", 500) or 500
            message = str(e)[:250]
            raise
        finally:
            db = SessionLocal()
            try:
                # 查询用户ID
                user = None
                if username:
                    user = db.query(User).filter(User.username == username).first()
                actor_id = user.id if user else getattr(request.state, "user_id", None)
                actor_name = getattr(request.state, "user_name", username)

                row = LoginLog(
                    trace_id=get_or_create_trace_id(request),
                    actor_id=actor_id,
                    actor_name=actor_name,
                    ip=request.client.host if request.client else None,
                    user_agent=request.headers.get("user-agent"),
                    status=status,
                    message=message
                )
                db.add(row)
                db.commit()
            finally:
                db.close()

class RequestAuditMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next: Callable):
        # 排除不需要审计的路径
        if (request.method == "GET" or 
            any(request.url.path.startswith(prefix) for prefix in AUDIT_EXCLUDE_PATH_PREFIX) or
            request.url.path == "/api/common/login"):  # 排除登录路径
            return await call_next(request)
        start = time.perf_counter()
        http_status = 200
        status = "SUCCESS"
        message = None
        try:
            response = await call_next(request)
            http_status = getattr(response, "status_code", 200) or 200
            return response
        except Exception as e:
            status = "FAIL"
            message = str(e)[:500]
            http_status = getattr(e, "status_code", 500) or 500
            raise
        finally:
            latency_ms = int((time.perf_counter() - start) * 1000)

            # 获取用户名 (不再记录 ID)
            actor_name = getattr(request.state, "user_name", None)  # 获取用户名
            actor_id = getattr(request.state, "user_id", None)

            trace_id = get_or_create_trace_id(request)
            ip = request.client.host if request.client else None
            ua = request.headers.get("user-agent")
            method = request.method
            path = request.url.path

            # 1) 尝试从路由参数取 resource_id
            try:
                path_params = (request.scope or {}).get("path_params", {})
            except Exception:
                path_params = {}
            resource_id = None
            for k in ("id", "rid", "pid", "uid", "file_id", "user_id"):
                if k in path_params and path_params[k] is not None:
                    resource_id = str(path_params[k])
                    break
            # 2) 若路由参数没有，再从查询串兜底
            if resource_id is None:
                qp = request.query_params
                for k in ("id", "rid", "pid", "uid", "file_id", "user_id"):
                    if k in qp and qp[k]:
                        resource_id = qp[k]
                        break

            # 3) 记录操作者角色快照（对齐 get_current_user）
            actor_roles = getattr(request.state, "roles", None)

            db = SessionLocal()
            try:
                
                row = AuditLog(
                    trace_id=trace_id,
                    level="BUSINESS",
                    status=status,
                    action="operate",  # 操作类型
                    resource_type="system",  # 资源类型
                    actor_id=actor_id,
                    actor_name=actor_name, 
                    actor_roles=actor_roles,
                    ip=ip,
                    user_agent=ua,
                    method=method,
                    path=path,
                    resource_id=resource_id,
                    http_status=http_status,
                    latency_ms=latency_ms,
                    message=message
                )
                db.add(row)
                db.commit()
            finally:
                db.close()
