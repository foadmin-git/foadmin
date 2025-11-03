# app/schemas/menu.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from pydantic import BaseModel
from typing import List, Optional

class MenuNode(BaseModel):
    id: int
    title: str
    name: str | None = None
    icon: str | None = None
    path: str | None = None
    route_component: str | None = None
    children: List["MenuNode"] = []

MenuNode.model_rebuild()