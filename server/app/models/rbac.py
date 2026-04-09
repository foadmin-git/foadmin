# app/models/rbac.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, String, Integer, Enum, ForeignKey
from app.core.db import Base

class Role(Base):
    __tablename__ = "foadmin_sys_role"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    code: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    name: Mapped[str] = mapped_column(String(64), nullable=False)
    status: Mapped[int] = mapped_column(Integer, default=1)
    sort: Mapped[int] = mapped_column(Integer, default=0)

class Permission(Base):
    __tablename__ = "foadmin_sys_permission"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    type: Mapped[str] = mapped_column(Enum("menu","api","button"), nullable=False)
    platform: Mapped[str | None] = mapped_column(String(10), nullable=True)  # 'admin' | 'front'
    name: Mapped[str] = mapped_column(String(128), nullable=False)
    code: Mapped[str | None] = mapped_column(String(128), unique=True, nullable=True)  # 菜单或按钮权限码，如 'dashboard:view'
    method: Mapped[str | None] = mapped_column(String(10), nullable=True)             # API 权限：GET/POST...
    path: Mapped[str | None] = mapped_column(String(255), nullable=True)               # API 权限：/api/admin/...
    parent_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)           # 菜单树
    icon: Mapped[str | None] = mapped_column(String(64), nullable=True)
    route_name: Mapped[str | None] = mapped_column(String(64), nullable=True)
    route_path: Mapped[str | None] = mapped_column(String(255), nullable=True)
    route_component: Mapped[str | None] = mapped_column(String(128), nullable=True)    # 前端组件路径（相对 src/views）
    route_cache: Mapped[int] = mapped_column(Integer, default=0)
    visible: Mapped[int] = mapped_column(Integer, default=1)
    sort: Mapped[int] = mapped_column(Integer, default=0)

class RolePerm(Base):
    __tablename__ = "foadmin_rel_role_perm"
    role_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("foadmin_sys_role.id"), primary_key=True)
    perm_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("foadmin_sys_permission.id"), primary_key=True)

class UserRole(Base):
    __tablename__ = "foadmin_rel_user_role"
    user_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("foadmin_sys_user.id"), primary_key=True)
    role_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("foadmin_sys_role.id"), primary_key=True)