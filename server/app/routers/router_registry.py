# app/routers/router_registry.py
"""
路由注册中心
将所有路由集中在此文件中注册，便于统一管理和维护
"""

from app.routers import (
    auth as auth_router,
    admin_menu as admin_menu_router,
    system_user as system_user_router,
    system_user,
    system_role,
    system_perm,
    system_level,
    system_org,
    system_dict,
    system_job,
    system_info as system_info_router,
    media as media_router,
    convert as convert_router,
    admin_loginlog,
    admin_audit,
    system_config,
    email as email_router
)


def register_routers(app):
    """注册所有路由"""
    # 公共鉴权
    app.include_router(auth_router.router)
    
    # 后台管理 API
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
    app.include_router(system_info_router.router)