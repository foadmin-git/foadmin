# app/models/media.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, Integer, String, DateTime, Text
from datetime import datetime
from app.core.db import Base

class MediaDir(Base):
    __tablename__ = "foadmin_media_dir"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    parent_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    name: Mapped[str] = mapped_column(String(128), nullable=False)
    sort: Mapped[int] = mapped_column(Integer, default=0)

class MediaFile(Base):
    __tablename__ = "foadmin_media_file"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    dir_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    filename: Mapped[str] = mapped_column(String(255), nullable=False)   # 原始文件名
    ext: Mapped[str | None] = mapped_column(String(20))
    mime: Mapped[str | None] = mapped_column(String(100))
    size: Mapped[int] = mapped_column(BigInteger, nullable=False)
    sha256: Mapped[str] = mapped_column(String(64), nullable=False)
    width: Mapped[int | None] = mapped_column(Integer)
    height: Mapped[int | None] = mapped_column(Integer)
    duration: Mapped[int | None] = mapped_column(Integer)
    storage: Mapped[str] = mapped_column(String(20), default="local")
    path: Mapped[str] = mapped_column(String(512), nullable=False)       # 相对路径/对象键
    url: Mapped[str | None] = mapped_column(String(512))
    uploader_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    remark: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)

class MediaTag(Base):
    __tablename__ = "foadmin_media_tag"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)

class RelMediaFileTag(Base):
    __tablename__ = "foadmin_rel_media_file_tag"
    file_id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    tag_id: Mapped[int] = mapped_column(BigInteger, primary_key=True)

class MediaAudit(Base):
    __tablename__ = "foadmin_media_audit"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    file_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    action: Mapped[str] = mapped_column(String(32), nullable=False)  # upload/delete/restore/rename/download
    actor_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    ip: Mapped[str | None] = mapped_column(String(64))
    ua: Mapped[str | None] = mapped_column(String(255))
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)


# 缓存转换结果（去重）
class MediaConvertCache(Base):
    __tablename__ = "foadmin_media_convert_cache"
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    # 'pdf' | 'pptx' | 'docx'
    kind: Mapped[str] = mapped_column(String(16), nullable=False)
    # 源文件 sha256
    src_sha256: Mapped[str] = mapped_column(String(64), nullable=False)
    # 对于 docx-mammoth，直接存 HTML；对于 pdf/pptx 或 docx-soffice，存图片 file_id 列表（逗号分隔）
    html: Mapped[str | None] = mapped_column(Text)
    file_ids: Mapped[str | None] = mapped_column(Text)  # "12,13,14"
    pages: Mapped[int | None] = mapped_column(Integer)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # 你也可以加联合唯一索引（如用 Alembic）；若没用迁移，这里先靠逻辑防重
