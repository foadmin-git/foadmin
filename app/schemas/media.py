# app/schemas/media.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from typing import Optional, List
from pydantic import BaseModel

# ---------- Dirs ----------
class DirCreate(BaseModel):
    name: str
    parent_id: Optional[int] = None
    sort: int = 0

class DirUpdate(BaseModel):
    name: Optional[str] = None
    parent_id: Optional[int] = None
    sort: Optional[int] = None

# ---------- Files ----------
class RenameBody(BaseModel):
    name: str

class FileTagsBody(BaseModel):
    # 覆盖设置该文件的标签（标签名数组），若不存在自动创建
    tags: List[str]

# 列表项（如果你想让 list 接口也走 schema，可以引用）
class MediaFileItem(BaseModel):
    id: int
    filename: str
    mime: Optional[str] = None
    size: int
    ext: Optional[str] = None
    dir_id: Optional[int] = None
    path: str
    url: Optional[str] = None
    uploader_id: int
    created_at: str
    width: Optional[int] = None
    height: Optional[int] = None
    deleted_at: Optional[str] = None
    tags: List[str] = []

class MediaListResp(BaseModel):
    items: List[MediaFileItem]
    total: int
