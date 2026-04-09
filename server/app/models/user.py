# app/models/user.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, String, Integer
from app.core.db import Base

class User(Base):
    __tablename__ = "foadmin_sys_user"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    username: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    nick_name: Mapped[str | None] = mapped_column(String(64), nullable=True)
    dept_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    level_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True) 
    # 新增头像字段：允许关联媒体文件或自定义外链
    avatar_file_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    avatar_url: Mapped[str | None] = mapped_column(String(255), nullable=True)
    status: Mapped[int] = mapped_column(Integer, default=1)