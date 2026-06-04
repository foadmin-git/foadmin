# app/models/dept.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy import Column, BigInteger, Integer, String
from app.core.db import Base

class SysDept(Base):
    __tablename__ = "foadmin_sys_dept"
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    parent_id = Column(BigInteger, nullable=True)
    name = Column(String(100), nullable=False)
    code = Column(String(64), nullable=True)
    sort = Column(Integer, default=0)
    status = Column(Integer, default=1)
