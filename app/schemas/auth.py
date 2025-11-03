# app/schemas/auth.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from pydantic import BaseModel

class LoginReq(BaseModel):
    """
    登录请求体。
    
    使用滑动拼图验证码后不再需要携带验证码字段。
    """
    username: str
    password: str

class LoginResp(BaseModel):
    token: str
    user: dict
    roles: list[str]
    perms: list[str]