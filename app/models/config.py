# app/models/config.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, String, Text, Integer, DateTime
from sqlalchemy.sql import func
from app.core.db import Base

class SysConfig(Base):
    """系统配置表 - 支持可视化配置管理"""
    __tablename__ = "foadmin_sys_config"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True, comment="配置ID")
    category: Mapped[str] = mapped_column(String(64), nullable=False, comment="配置分类：system/upload/security/email等")
    key: Mapped[str] = mapped_column(String(128), nullable=False, unique=True, comment="配置键名（唯一）")
    value: Mapped[str | None] = mapped_column(Text, nullable=True, comment="配置值（支持JSON）")
    value_type: Mapped[str] = mapped_column(String(32), default="string", comment="值类型：string/number/boolean/json/file")
    name: Mapped[str] = mapped_column(String(128), nullable=False, comment="配置名称（显示用）")
    description: Mapped[str | None] = mapped_column(String(512), nullable=True, comment="配置说明")
    options: Mapped[str | None] = mapped_column(Text, nullable=True, comment="可选项（JSON数组，用于下拉选择）")
    default_value: Mapped[str | None] = mapped_column(Text, nullable=True, comment="默认值")
    is_public: Mapped[int] = mapped_column(Integer, default=0, comment="是否公开：1-前端可读，0-仅后端")
    is_encrypted: Mapped[int] = mapped_column(Integer, default=0, comment="是否加密存储：1-是，0-否")
    sort: Mapped[int] = mapped_column(Integer, default=0, comment="排序")
    updated_at: Mapped[DateTime | None] = mapped_column(DateTime, onupdate=func.now(), comment="更新时间")
    updated_by: Mapped[int | None] = mapped_column(BigInteger, nullable=True, comment="更新人ID")
