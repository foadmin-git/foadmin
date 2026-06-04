# app/models/login_log.py
from sqlalchemy import Column, BigInteger, String, Enum, Integer, DateTime
from sqlalchemy.sql import func
from app.core.db import Base  

class LoginLog(Base):
    __tablename__ = "foadmin_login_log"

    id = Column(BigInteger, primary_key=True, autoincrement=True, comment="主键ID")
    trace_id = Column(String(64), nullable=False, comment="请求关联ID")
    actor_id = Column(BigInteger, nullable=True, comment="登录用户ID（失败可为空）")
    actor_name = Column(String(128), nullable=True, comment="登录用户名/姓名快照")
    ip = Column(String(64), nullable=True, comment="来源IP")
    user_agent = Column(String(255), nullable=True, comment="UA")
    status = Column(Enum("SUCCESS", "FAIL"), nullable=False, comment="登录是否成功")
    message = Column(String(255), nullable=True, comment="失败原因或补充说明")
    created_at = Column(DateTime, nullable=False, server_default=func.now(), comment="创建时间")
