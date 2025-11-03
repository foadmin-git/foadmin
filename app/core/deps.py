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