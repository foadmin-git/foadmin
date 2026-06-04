# app/core/deps.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import Depends, HTTPException, status, Request
from jose import jwt, JWTError
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.db import get_db

def get_current_user(request: Request, db: Session = Depends(get_db)):
    auth = request.headers.get("Authorization", "")
    if not auth.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No token")
    
    token = auth.split(" ", 1)[1]
    try:
        # 解码 token
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGO])
        print(f"Decoded payload roles: {payload.get('roles')}")  # 调试日志
        # 将用户信息注入到 request.state 中
        request.state.user_id = payload.get("sub")  
        request.state.user_name = payload.get("username")
        request.state.roles = payload.get("roles", [])
        request.state.perms = payload.get("perms", [])
        request.state.is_demo = payload.get("is_demo", False)  # 演示账号标识
        request.state.user_roles = request.state.roles
        request.state.user_perms  = request.state.perms
        
        return payload  # 返回 payload，包含 sub、roles、perms 等信息
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")


def require_perm(code: str):
    def checker(user = Depends(get_current_user)):
        if code not in user.get("perms", []):
            raise HTTPException(status_code=403, detail="No permission")
        return user
    return checker


def check_demo_user(request: Request):
    """
    检查是否为演示账号，如果是则禁止写操作
    用于 POST/PUT/DELETE 等修改数据的接口
    """
    is_demo = getattr(request.state, "is_demo", False)
    if is_demo:
        raise HTTPException(status_code=403, detail="演示账号无操作权限")
    return True


def require_not_demo():
    """
    依赖项：禁止演示账号执行操作
    用法: @router.post("/xxx", dependencies=[Depends(require_not_demo())])
    """
    def checker(request: Request):
        is_demo = getattr(request.state, "is_demo", False)
        if is_demo:
            raise HTTPException(status_code=403, detail="演示账号无操作权限")
        return True
    return checker