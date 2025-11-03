#app/models/level.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy import Column, BigInteger, Integer, String
from app.core.db import Base

class SysLevel(Base):
    __tablename__ = "foadmin_sys_level"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(64), nullable=False)
    code = Column(String(64), nullable=False)
    weight = Column(Integer, default=0)
