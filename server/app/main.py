# app/main.py
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.db import Base, engine
from app.core.middlewares import RequestAuditMiddleware, LoginLogMiddleware
from app.core.static_file_middleware import StaticFileMiddleware  # 静态文件访问中间件
from app.core.scheduler import start_scheduler, shutdown_scheduler
from app.routers.router_registry import register_routers
#前台
from app.routers.front.front_routes import front_routers

Base.metadata.create_all(bind=engine)
app = FastAPI(title="Foadmin API")


# 中间件（顺序建议：登录日志 -> 审计）
app.add_middleware(StaticFileMiddleware)  # 静态文件访问中间件
app.add_middleware(LoginLogMiddleware)
app.add_middleware(RequestAuditMiddleware)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册所有后台管理路由
register_routers(app)

# 注册前台所有路由
for router in front_routers:
    app.include_router(router)


# 启动和关闭事件
@app.on_event("startup")
def on_startup():
    """应用启动时启动调度器"""
    start_scheduler()


@app.on_event("shutdown")
def on_shutdown():
    """应用关闭时停止调度器"""
    shutdown_scheduler()