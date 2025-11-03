# app/models/dict.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, String, Integer, Text
from app.core.db import Base

class DictType(Base):
    """数据字典类型表"""
    __tablename__ = "foadmin_sys_dict_type"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True, comment='字典类型ID')
    name: Mapped[str] = mapped_column(String(128), nullable=False, comment='字典名称')
    code: Mapped[str] = mapped_column(String(128), nullable=False, unique=True, comment='字典编码，唯一标识')
    description: Mapped[str | None] = mapped_column(String(512), nullable=True, comment='字典描述')
    status: Mapped[int] = mapped_column(Integer, default=1, comment='状态：1-启用，0-禁用')
    sort: Mapped[int] = mapped_column(Integer, default=0, comment='排序')


class DictData(Base):
    """数据字典数据表"""
    __tablename__ = "foadmin_sys_dict_data"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True, comment='字典数据ID')
    type_code: Mapped[str] = mapped_column(String(128), nullable=False, comment='字典类型编码')
    label: Mapped[str] = mapped_column(String(128), nullable=False, comment='字典标签（显示值）')
    value: Mapped[str] = mapped_column(String(128), nullable=False, comment='字典键值（实际值）')
    tag_type: Mapped[str | None] = mapped_column(String(32), nullable=True, comment='标签类型：success/info/warning/danger/primary')
    css_class: Mapped[str | None] = mapped_column(String(128), nullable=True, comment='自定义CSS类')
    remark: Mapped[str | None] = mapped_column(Text, nullable=True, comment='备注')
    status: Mapped[int] = mapped_column(Integer, default=1, comment='状态：1-启用，0-禁用')
    sort: Mapped[int] = mapped_column(Integer, default=0, comment='排序')
