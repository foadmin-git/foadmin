# app/routers/auth.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from pydantic import BaseModel

from app.core.db import get_db
from app.core.config_loader import get_config
from app.models.user import User
from app.models.rbac import Role, Permission, RolePerm, UserRole
from app.core.security import verify_password, create_token, hash_password
from app.schemas.auth import LoginReq, LoginResp
from app.core.deps import get_current_user

router = APIRouter(prefix="/api/common", tags=["common-auth"])  # 公共登录，不区分平台

# -----------------------
#  防护相关配置（从系统配置动态读取）
# -----------------------
# 失败次数与锁定信息，存放于内存中。因为 FastAPI 默认以多进程/多线程运行，
# 若部署在多实例环境，应改用 Redis 等集中式存储。
from time import time
import string
import random
from uuid import uuid4

# 内存表：用户名 -> (失败次数, 最后失败时间)
FAILED_ATTEMPTS: dict[str, tuple[int, float]] = {}
# 被锁定的用户：用户名 -> 解锁时间戳
LOCKED_USERS: dict[str, float] = {}
# IP 限流：IP -> (请求次数, 窗口开始时间)
RATE_LIMIT: dict[str, tuple[int, float]] = {}

# 验证码逻辑将由前端库 vue3-slide-verify 完成


'''
def load_user_perms(db: Session, user_id: int):
    role_ids = [r.role_id for r in db.query(UserRole).filter(UserRole.user_id == user_id).all()]
    roles = [r.code for r in db.query(Role).filter(Role.id.in_(role_ids)).all()] if role_ids else []
    perm_ids = [rp.perm_id for rp in db.query(RolePerm).filter(RolePerm.role_id.in_(role_ids)).all()] if role_ids else []
    perms: list[str] = []
    if perm_ids:
        for p in db.query(Permission).filter(Permission.id.in_(perm_ids)).all():
            if p.type in ("menu", "button") and p.code:
                perms.append(p.code)
            if p.type == "api" and p.method and p.path:
                perms.append(f"{p.method}:{p.path}")
    return roles, perms '''

def load_user_perms(db: Session, user_id: int):
    role_ids = [r.role_id for r in db.query(UserRole).filter(UserRole.user_id == user_id).all()]
    roles = [r.code for r in db.query(Role).filter(Role.id.in_(role_ids)).all()] if role_ids else []
    perm_ids = [rp.perm_id for rp in db.query(RolePerm).filter(RolePerm.role_id.in_(role_ids)).all()] if role_ids else []
    perms: list[str] = []
    if perm_ids:
        for p in db.query(Permission).filter(Permission.id.in_(perm_ids)).all():
            if p.code:  # 加载所有 code
                perms.append(p.code)
            if p.type == "api" and p.method and p.path:  # 加载 API 路径
                perms.append(f"{p.method}:{p.path}")
    return roles, perms


@router.post("/login", response_model=LoginResp)
def login(body: LoginReq, request: Request, db: Session = Depends(get_db)):
    
    # 从系统配置读取速率限制参数（确保转换为数字类型）
    rate_limit_requests = int(get_config('login_rate_limit_requests', 'number', 20, db) or 20)
    rate_limit_window = int(get_config('login_rate_limit_window', 'number', 60, db) or 60)
    
    # 限流逻辑
    client_ip = request.client.host or "unknown"
    now = time()
    # 获取当前 IP 的记录
    req_count, start = RATE_LIMIT.get(client_ip, (0, now))
    # 如果窗口过期，重置
    if now - start > rate_limit_window:
        req_count, start = 0, now
    req_count += 1
    RATE_LIMIT[client_ip] = (req_count, start)
    if req_count > rate_limit_requests:
        # 返回 429 Too Many Requests
        raise HTTPException(status_code=429, detail="请求过于频繁，请稍后再试")

    # 从系统配置读取安全参数（确保转换为正确类型）
    max_login_fails = int(get_config('login_max_fails', 'number', 5, db) or 5)
    lock_seconds = int(get_config('login_lock_seconds', 'number', 600, db) or 600)
    enable_captcha = get_config('enable_captcha', 'boolean', True, db)

    # 滑动验证码由客户端完成，无需在后端校验（如果启用验证码，前端会处理）

    # 检查是否锁定
    lock_until = LOCKED_USERS.get(body.username)
    if lock_until and lock_until > now:
        raise HTTPException(status_code=403, detail="该账号已被锁定，请稍后再试")

    u = db.query(User).filter(User.username == body.username).first()
    # 判断用户名密码
    if not u or not verify_password(body.password, u.password_hash):
        # 更新失败次数
        fail_count, last_fail = FAILED_ATTEMPTS.get(body.username, (0, now))
        # 如果距离上次失败超过锁定周期，则重置
        if now - last_fail > lock_seconds:
            fail_count = 0
        fail_count += 1
        FAILED_ATTEMPTS[body.username] = (fail_count, now)
        # 超过阈值锁定
        if fail_count >= max_login_fails:
            LOCKED_USERS[body.username] = now + lock_seconds
            FAILED_ATTEMPTS.pop(body.username, None)
            raise HTTPException(status_code=403, detail="密码错误次数过多，账号已锁定，请稍后再试")
        raise HTTPException(status_code=400, detail="用户名或密码错误")

    # 登录成功，清除失败记录和锁定
    FAILED_ATTEMPTS.pop(body.username, None)
    LOCKED_USERS.pop(body.username, None)

    roles, perms = load_user_perms(db, u.id)
    token = create_token(str(u.id), roles, perms, u.username)
    
    # 获取头像 SHA256
    avatar_sha256 = None
    if u.avatar_file_id:
        from app.models.media import MediaFile
        media = db.get(MediaFile, u.avatar_file_id)
        if media:
            avatar_sha256 = media.sha256
    
    return LoginResp(
        token=token,
        user={
            "id": u.id,
            "username": u.username,
            "nick_name": u.nick_name,
            "avatar_file_id": u.avatar_file_id,
            "avatar_url": u.avatar_url,
            "avatar_sha256": avatar_sha256,  # 新增
        },
        roles=roles,
        perms=perms,
    )


@router.get("/me")
def me(user=Depends(get_current_user)):
    return user


# ---------- 刷新令牌 ----------
@router.post("/refresh", response_model=LoginResp)
def refresh_token(user=Depends(get_current_user), db: Session = Depends(get_db)):
    """
    刷新访问令牌。
    
    客户端在 access token 即将过期时调用此接口，根据当前已认证用户信息生成新的 token。
    """
    # user 来自 get_current_user，包含 sub、roles、perms、username
    # 获取最新的角色和权限
    user_id = int(user.get("sub"))
    u = db.get(User, user_id)
    if not u:
        raise HTTPException(404, "用户不存在")
    # 重新加载角色权限，防止角色变更后仍旧使用旧权限
    roles, perms = load_user_perms(db, u.id)
    token = create_token(str(u.id), roles, perms, u.username)
    
    # 获取头像 SHA256
    avatar_sha256 = None
    if u.avatar_file_id:
        from app.models.media import MediaFile
        media = db.get(MediaFile, u.avatar_file_id)
        if media:
            avatar_sha256 = media.sha256
    
    return LoginResp(
        token=token,
        user={
            "id": u.id,
            "username": u.username,
            "nick_name": u.nick_name,
            "avatar_file_id": u.avatar_file_id,
            "avatar_url": u.avatar_url,
            "avatar_sha256": avatar_sha256,  # 新增
        },
        roles=roles,
        perms=perms,
    )


# ---------- 个人资料（新增） ----------

class ProfileOut(BaseModel):
    id: int
    username: str
    nick_name: str | None = None
    # 新增头像字段
    avatar_file_id: int | None = None
    avatar_url: str | None = None
    avatar_sha256: str | None = None  # 新增：用于前端预览


class ProfileIn(BaseModel):
    nick_name: str | None = None
    old_password: str | None = None
    new_password: str | None = None
    avatar_file_id: int | None = None
    avatar_url: str | None = None


@router.get("/profile", response_model=ProfileOut)
def profile(user=Depends(get_current_user), db: Session = Depends(get_db)):
    # SQLAlchemy 2.x 推荐用 Session.get(Model, pk)
    u = db.get(User, int(user["sub"]))
    if not u:
        raise HTTPException(404, "用户不存在")
    
    # 获取头像的SHA256
    avatar_sha256 = None
    if u.avatar_file_id:
        from app.models.media import MediaFile
        media = db.get(MediaFile, u.avatar_file_id)
        if media:
            avatar_sha256 = media.sha256
    
    return ProfileOut(
        id=u.id,
        username=u.username,
        nick_name=u.nick_name,
        avatar_file_id=u.avatar_file_id,
        avatar_url=u.avatar_url,
        avatar_sha256=avatar_sha256,  # 新增
    )


@router.put("/profile", response_model=ProfileOut)
def update_profile(body: ProfileIn, user=Depends(get_current_user), db: Session = Depends(get_db)):
    u = db.get(User, int(user["sub"]))
    if not u:
        raise HTTPException(404, "用户不存在")

    # 昵称更新（允许空字符串 -> 置空）
    if body.nick_name is not None:
        u.nick_name = body.nick_name.strip() or None
    # 更新头像信息
    # 如果提供 file_id，则优先使用媒体库头像；若提供空字符串则置空
    if body.avatar_file_id is not None:
        u.avatar_file_id = body.avatar_file_id
        # 清空 avatar_url，以避免优先级混淆
        u.avatar_url = None
    if body.avatar_url is not None:
        u.avatar_url = body.avatar_url.strip() or None
        # 如果提交 url，则清空 file_id
        if u.avatar_url:
            u.avatar_file_id = None

    # 可选改密：两个字段必须同时提供
    if body.old_password or body.new_password:
        if not body.old_password or not body.new_password:
            raise HTTPException(400, "修改密码需要同时提供旧密码与新密码")
        if not verify_password(body.old_password, u.password_hash):
            raise HTTPException(400, "旧密码不正确")
        
        # 验证新密码的复杂度（如果启用了密码复杂度要求）
        from app.core.security import validate_password_complexity
        validate_password_complexity(body.new_password, db)
        
        u.password_hash = hash_password(body.new_password)

    db.commit()
    
    # 获取头像的SHA256并返回完整用户信息
    avatar_sha256 = None
    if u.avatar_file_id:
        from app.models.media import MediaFile
        media = db.get(MediaFile, u.avatar_file_id)
        if media:
            avatar_sha256 = media.sha256
    
    return ProfileOut(
        id=u.id,
        username=u.username,
        nick_name=u.nick_name,
        avatar_file_id=u.avatar_file_id,
        avatar_url=u.avatar_url,
        avatar_sha256=avatar_sha256,
    )
