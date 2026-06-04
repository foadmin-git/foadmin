#app/routers/system_role.py  角色+权限绑定
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from app.core.db import get_db
from app.core.deps import require_perm
from app.models.rbac import Role, Permission, RolePerm

router = APIRouter(prefix="/api/admin/system/roles", tags=["admin-system-roles"])

class RoleIn(BaseModel):
    code: str
    name: str
    sort: int = 0

@router.get("", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def list_roles(db: Session = Depends(get_db)):
    items = db.query(Role).order_by(Role.sort, Role.id).all()
    return {"items": [{"id": r.id, "code": r.code, "name": r.name, "sort": r.sort} for r in items]}

@router.post("", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def create_role(body: RoleIn, db: Session = Depends(get_db)):
    if db.query(Role).filter(Role.code==body.code).first():
        raise HTTPException(400, "角色编码已存在")
    r = Role(code=body.code, name=body.name, sort=body.sort)
    db.add(r); db.commit(); return {"id": r.id}

@router.put("/{rid}", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def update_role(rid: int, body: RoleIn, db: Session = Depends(get_db)):
    r = db.get(Role, rid)
    if not r: raise HTTPException(404, "角色不存在")
    r.name = body.name; r.sort = body.sort
    db.commit(); return {"ok": True}

@router.delete("/{rid}", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def delete_role(rid: int, db: Session = Depends(get_db)):
    r = db.get(Role, rid)
    if not r: raise HTTPException(404, "角色不存在")
    db.query(RolePerm).filter(RolePerm.role_id==rid).delete()
    db.delete(r); db.commit(); return {"ok": True}

@router.get("/{rid}/perms", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def get_role_perms(rid: int, db: Session = Depends(get_db)):
    if not db.get(Role, rid): raise HTTPException(404, "角色不存在")
    selected = [rp.perm_id for rp in db.query(RolePerm).filter(RolePerm.role_id==rid).all()]
    # 仅开放 platform='admin' 的权限选择（菜单/按钮/API）
    all_perms = db.query(Permission).filter(Permission.platform=="admin").order_by(Permission.type, Permission.sort).all()
    return {
        "all": [{"id": p.id, "type": p.type, "name": p.name, "code": p.code, "parent_id": p.parent_id} for p in all_perms],
        "selected": selected
    }

class BindPermsIn(BaseModel):
    perm_ids: List[int]

@router.put("/{rid}/perms", dependencies=[Depends(require_perm("central-auth-org-role:view"))])
def bind_role_perms(rid: int, body: BindPermsIn, db: Session = Depends(get_db)):
    if not db.get(Role, rid): raise HTTPException(404, "角色不存在")
    db.query(RolePerm).filter(RolePerm.role_id==rid).delete()
    for pid in set(body.perm_ids or []):
        db.add(RolePerm(role_id=rid, perm_id=pid))
    db.commit(); return {"ok": True}

