# app/routers/system_level.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
from app.core.db import get_db
from app.core.deps import require_perm
from app.models.level import SysLevel  # 下面给出模型

router = APIRouter(prefix="/api/admin/system/levels", tags=["admin-system-levels"])

class LevelIn(BaseModel):
  name: str
  code: str
  weight: int = 0

@router.get("", dependencies=[Depends(require_perm("central-auth-org-level:view"))])
def list_levels(db: Session = Depends(get_db)):
  items = db.query(SysLevel).order_by(SysLevel.weight.desc(), SysLevel.id.asc()).all()
  return {"items": [ {"id":i.id,"name":i.name,"code":i.code,"weight":i.weight} for i in items ]}

@router.post("", dependencies=[Depends(require_perm("central-auth-org-level:view"))])
def create_level(body: LevelIn, db: Session = Depends(get_db)):
  if db.query(SysLevel).filter(SysLevel.code==body.code).first():
    raise HTTPException(400, "层级编码已存在")
  lv = SysLevel(name=body.name, code=body.code, weight=body.weight)
  db.add(lv); db.commit()
  return {"id": lv.id}

@router.put("/{id}", dependencies=[Depends(require_perm("central-auth-org-level:view"))])
def update_level(id: int, body: LevelIn, db: Session = Depends(get_db)):
  lv = db.get(SysLevel, id)
  if not lv: raise HTTPException(404, "层级不存在")
  lv.name = body.name; lv.code = body.code; lv.weight = body.weight
  db.commit(); return {"ok": True}

@router.delete("/{id}", dependencies=[Depends(require_perm("central-auth-org-level:view"))])
def delete_level(id: int, db: Session = Depends(get_db)):
  lv = db.get(SysLevel, id)
  if not lv: raise HTTPException(404, "层级不存在")
  db.delete(lv); db.commit(); return {"ok": True}
