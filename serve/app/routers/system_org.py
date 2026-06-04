# app/routers/system_org.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from app.core.db import get_db
from app.core.deps import require_perm
from app.models.dept import SysDept  # 下面给出模型

router = APIRouter(prefix="/api/admin/system/orgs", tags=["admin-system-orgs"])

class OrgIn(BaseModel):
  parent_id: Optional[int] = None
  name: str
  code: Optional[str] = None
  sort: int = 0
  status: int = 1

def build_tree(rows):
  mp = { r.id: { "id":r.id,"name":r.name,"code":r.code,"sort":r.sort,"status":r.status,"parent_id":r.parent_id,"children":[] } for r in rows }
  roots = []
  for r in rows:
    node = mp[r.id]
    if r.parent_id and r.parent_id in mp:
      mp[r.parent_id]["children"].append(node)
    else:
      roots.append(node)
  # sort children
  def sort_rec(ns):
    ns.sort(key=lambda x:(x["sort"], x["id"]))
    for c in ns: sort_rec(c["children"])
  sort_rec(roots)
  return roots

@router.get("/tree", dependencies=[Depends(require_perm("central-auth-org-orgmgmt:view"))])
def tree(db: Session = Depends(get_db)):
  rows = db.query(SysDept).all()
  return {"items": build_tree(rows)}

@router.post("", dependencies=[Depends(require_perm("central-auth-org-orgmgmt:view"))])
def create(body: OrgIn, db: Session = Depends(get_db)):
  d = SysDept(parent_id=body.parent_id, name=body.name, code=body.code, sort=body.sort, status=body.status)
  db.add(d); db.commit(); return {"id": d.id}

@router.put("/{id}", dependencies=[Depends(require_perm("central-auth-org-orgmgmt:view"))])
def update(id: int, body: OrgIn, db: Session = Depends(get_db)):
  d = db.get(SysDept, id)
  if not d: raise HTTPException(404, "组织不存在")
  d.name=body.name; d.code=body.code; d.sort=body.sort; d.status=body.status; d.parent_id=body.parent_id
  db.commit(); return {"ok": True}

@router.delete("/{id}", dependencies=[Depends(require_perm("central-auth-org-orgmgmt:view"))])
def delete(id: int, db: Session = Depends(get_db)):
  # 简单保护：如果有子节点拒绝删除
  has_child = db.query(SysDept).filter(SysDept.parent_id==id).first()
  if has_child: raise HTTPException(400, "请先删除子节点")
  d = db.get(SysDept, id)
  if not d: raise HTTPException(404, "组织不存在")
  db.delete(d); db.commit(); return {"ok": True}
