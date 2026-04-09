# app/routers/system_perm.py  权限（菜单/按钮/API）管理
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional
from pydantic import BaseModel
from app.core.db import get_db
from app.core.deps import require_perm
from app.models.rbac import Permission

router = APIRouter(prefix="/api/admin/system/perms", tags=["admin-system-perms"])

class PermIn(BaseModel):
    type: str          # 'menu' | 'button' | 'api'
    platform: str      # 'admin' | 'front'
    name: str
    code: str | None = None
    method: str | None = None
    path: str | None = None
    parent_id: int | None = None
    icon: str | None = None
    route_name: str | None = None
    route_path: str | None = None
    route_component: str | None = None
    route_cache: int = 0
    visible: int = 1
    sort: int = 0

@router.get("", dependencies=[Depends(require_perm("central-auth-org-catalog:view"))])
def list_perms(db: Session = Depends(get_db), platform: Optional[str] = "admin"):
    q = db.query(Permission)
    if platform: q = q.filter(Permission.platform==platform)
    items = q.order_by(Permission.type, Permission.sort).all()
    def to_dict(p: Permission):
        return {
            "id": p.id, "type": p.type, "platform": p.platform, "name": p.name, "code": p.code,
            "method": p.method, "path": p.path, "parent_id": p.parent_id, "icon": p.icon,
            "route_name": p.route_name, "route_path": p.route_path, "route_component": p.route_component,
            "route_cache": p.route_cache, "visible": p.visible, "sort": p.sort
        }
    return {"items": [to_dict(p) for p in items]}

@router.post("", dependencies=[Depends(require_perm("central-auth-org-catalog:view"))])
def create_perm(body: PermIn, db: Session = Depends(get_db)):
    p = Permission(**body.dict())
    db.add(p); db.commit(); return {"id": p.id}

@router.put("/{pid}", dependencies=[Depends(require_perm("central-auth-org-catalog:view"))])
def update_perm(pid: int, body: PermIn, db: Session = Depends(get_db)):
    p = db.get(Permission, pid)
    if not p: raise HTTPException(404, "权限不存在")
    for k, v in body.dict().items(): setattr(p, k, v)
    db.commit(); return {"ok": True}

@router.delete("/{pid}", dependencies=[Depends(require_perm("central-auth-org-catalog:view"))])
def delete_perm(pid: int, db: Session = Depends(get_db)):
    p = db.get(Permission, pid)
    if not p: raise HTTPException(404, "权限不存在")
    db.delete(p); db.commit(); return {"ok": True}
