# app/core/security.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from datetime import datetime, timedelta
from passlib.context import CryptContext
from jose import jwt
from app.core.config import settings
from app.core.config_loader import get_config
from fastapi import HTTPException
import bcrypt
import re

def _truncate_password_for_bcrypt(password: str) -> str:
    """安全地截断密码以适应 bcrypt 72 字节限制"""
    password_bytes = password.encode('utf-8')
    if len(password_bytes) <= 72:
        return password
    
    truncated_bytes = password_bytes[:72]
    try:
        return truncated_bytes.decode('utf-8')
    except UnicodeDecodeError:
        for i in range(71, 60, -1):
            try:
                return password_bytes[:i].decode('utf-8')
            except UnicodeDecodeError:
                continue
        return truncated_bytes.decode('utf-8', errors='ignore')

# 只使用 pbkdf2_sha256 来避免初始化问题
pwd = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")

def validate_password_complexity(password: str, db=None) -> None:
    """
    验证密码复杂度（根据系统配置）
    
    如果密码不符合复杂度要求，抛出 HTTPException
    """
    from app.core.config_loader import get_config
    
    # 从系统配置读取是否启用密码复杂度要求
    enable_complexity = get_config('password_complexity_enabled', 'boolean', False, db)
    
    if not enable_complexity:
        # 未启用密码复杂度要求，直接返回
        return
    
    # 从系统配置读取密码复杂度要求
    min_length = int(get_config('password_min_length', 'number', 8, db) or 8)
    require_uppercase = get_config('password_require_uppercase', 'boolean', True, db)
    require_lowercase = get_config('password_require_lowercase', 'boolean', True, db)
    require_digit = get_config('password_require_digit', 'boolean', True, db)
    require_special = get_config('password_require_special', 'boolean', True, db)
    
    # 验证密码长度
    if len(password) < min_length:
        raise HTTPException(400, f"密码长度不能少于{min_length}位")
    
    # 验证是否包含大写字母
    if require_uppercase and not re.search(r'[A-Z]', password):
        raise HTTPException(400, "密码必须包含至少一个大写字母")
    
    # 验证是否包含小写字母
    if require_lowercase and not re.search(r'[a-z]', password):
        raise HTTPException(400, "密码必须包含至少一个小写字母")
    
    # 验证是否包含数字
    if require_digit and not re.search(r'[0-9]', password):
        raise HTTPException(400, "密码必须包含至少一个数字")
    
    # 验证是否包含特殊字符
    if require_special and not re.search(r'[!@#$%^&*(),.?":{}|<>]', password):
        raise HTTPException(400, "密码必须包含至少一个特殊字符(!@#$%^&*(),.?\":{}|<>)")


def hash_password(p: str) -> str:
    return pwd.hash(p)

def verify_password(plain: str, hashed: str) -> bool:
    # 检查是否是 bcrypt 格式
    if hashed.startswith('$2b$') or hashed.startswith('$2a$') or hashed.startswith('$2y$'):
        # 直接使用 bcrypt 库验证，避免 passlib 的初始化问题
        try:
            truncated_plain = _truncate_password_for_bcrypt(plain)
            return bcrypt.checkpw(
                truncated_plain.encode('utf-8'), 
                hashed.encode('utf-8')
            )
        except Exception:
            return False
    else:
        # 使用 passlib 验证其他格式
        return pwd.verify(plain, hashed)

def create_token(sub: str, roles: list[str], perms: list[str], username: str = None):
    """
    创建JWT Token，过期时间从系统配置读取
    """
    # 从系统配置读取Session过期时间（分钟），默认120分钟
    expire_minutes = get_config('session_expire_minutes', 'number', 120)
    
    payload = {
        "sub": sub,
        "roles": roles,
        "perms": perms,
        "username": username,
        "exp": datetime.now() + timedelta(minutes=int(expire_minutes)),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGO)
