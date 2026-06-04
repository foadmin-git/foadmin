# app/main.py
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.db import Base, engine
from app.routers import auth as auth_router
from app.routers import admin_menu as admin_menu_router
from app.routers import system_user as system_user_router
from app.routers import system_user, system_role, system_perm
from app.routers import system_level, system_org, system_perm
from app.routers import media as media_router 
from app.routers import convert as convert_router
from app.core.middlewares import RequestAuditMiddleware, LoginLogMiddleware
from app.core.static_file_middleware import StaticFileMiddleware  # 静态文件访问中间件
from app.routers import admin_loginlog
from app.routers import admin_audit
from app.routers import system_config
from app.routers import email as email_router
from app.routers import system_dict, system_job
from app.core.scheduler import start_scheduler, shutdown_scheduler
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

# 公共鉴权
app.include_router(auth_router.router)
# 后台菜单/后台 API
app.include_router(admin_menu_router.router)
app.include_router(system_user_router.router)
app.include_router(system_user.router)
app.include_router(system_role.router)
app.include_router(system_perm.router)
app.include_router(system_level.router)
app.include_router(system_org.router)
app.include_router(media_router.router)
app.include_router(convert_router.router)
app.include_router(admin_audit.router)
app.include_router(admin_loginlog.router)
app.include_router(system_config.router)
app.include_router(email_router.router)
app.include_router(system_dict.router)
app.include_router(system_job.router)


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


