# app/routers/system_dict.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import select, func
from pydantic import BaseModel
from typing import List, Optional

from app.core.db import get_db
from app.core.deps import require_perm

router = APIRouter(prefix="/api/admin/system/dict", tags=["dict"])


# ====================== Schemas ======================

class DictTypeCreate(BaseModel):
    name: str
    code: str
    description: str | None = None
    status: int = 1
    sort: int = 0


class DictTypeUpdate(BaseModel):
    name: str | None = None
    code: str | None = None
    description: str | None = None
    status: int | None = None
    sort: int | None = None


class DictTypeOut(BaseModel):
    id: int
    name: str
    code: str
    description: str | None = None
    status: int
    sort: int


class DictDataCreate(BaseModel):
    type_code: str
    label: str
    value: str
    tag_type: str | None = None
    css_class: str | None = None
    remark: str | None = None
    status: int = 1
    sort: int = 0


class DictDataUpdate(BaseModel):
    label: str | None = None
    value: str | None = None
    tag_type: str | None = None
    css_class: str | None = None
    remark: str | None = None
    status: int | None = None
    sort: int | None = None


class DictDataOut(BaseModel):
    id: int
    type_code: str
    label: str
    value: str
    tag_type: str | None = None
    css_class: str | None = None
    remark: str | None = None
    status: int
    sort: int


# ====================== 字典类型接口 ======================

@router.get("/types", dependencies=[Depends(require_perm("dict:type:view"))])
def list_dict_types(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    name: str | None = None,
    code: str | None = None,
    status: int | None = None,
    db: Session = Depends(get_db)
):
    """获取字典类型列表（分页）"""
    from app.models.dict import DictType
    
    query = select(DictType)
    
    # 筛选条件
    if name:
        query = query.where(DictType.name.like(f"%{name}%"))
    if code:
        query = query.where(DictType.code.like(f"%{code}%"))
    if status is not None:
        query = query.where(DictType.status == status)
    
    # 排序
    query = query.order_by(DictType.sort.asc(), DictType.id.desc())
    
    # 总数
    total = db.scalar(select(func.count()).select_from(query.subquery()))
    
    # 分页
    items = db.scalars(query.offset((page - 1) * size).limit(size)).all()
    
    return {
        "items": [DictTypeOut.model_validate(item, from_attributes=True) for item in items],
        "total": total,
        "page": page,
        "size": size
    }


@router.post("/types", dependencies=[Depends(require_perm("dict:type:add"))])
def create_dict_type(body: DictTypeCreate, db: Session = Depends(get_db)):
    """创建字典类型"""
    from app.models.dict import DictType
    
    # 检查编码是否已存在
    exists = db.scalar(select(DictType).where(DictType.code == body.code))
    if exists:
        raise HTTPException(400, f"字典编码 {body.code} 已存在")
    
    dt = DictType(**body.model_dump())
    db.add(dt)
    db.commit()
    db.refresh(dt)
    
    return DictTypeOut.model_validate(dt, from_attributes=True)


@router.put("/types/{type_id}", dependencies=[Depends(require_perm("dict:type:edit"))])
def update_dict_type(type_id: int, body: DictTypeUpdate, db: Session = Depends(get_db)):
    """更新字典类型"""
    from app.models.dict import DictType
    
    dt = db.get(DictType, type_id)
    if not dt:
        raise HTTPException(404, "字典类型不存在")
    
    # 检查编码冲突
    if body.code and body.code != dt.code:
        exists = db.scalar(select(DictType).where(DictType.code == body.code))
        if exists:
            raise HTTPException(400, f"字典编码 {body.code} 已存在")
    
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(dt, k, v)
    
    db.commit()
    db.refresh(dt)
    
    return DictTypeOut.model_validate(dt, from_attributes=True)


@router.delete("/types/{type_id}", dependencies=[Depends(require_perm("dict:type:delete"))])
def delete_dict_type(type_id: int, db: Session = Depends(get_db)):
    """删除字典类型（同时删除关联的字典数据）"""
    from app.models.dict import DictType, DictData
    
    dt = db.get(DictType, type_id)
    if not dt:
        raise HTTPException(404, "字典类型不存在")
    
    # 删除关联的字典数据
    db.execute(select(DictData).where(DictData.type_code == dt.code))
    for item in db.scalars(select(DictData).where(DictData.type_code == dt.code)).all():
        db.delete(item)
    
    db.delete(dt)
    db.commit()
    
    return {"message": "删除成功"}


# ====================== 字典数据接口 ======================

@router.get("/data", dependencies=[Depends(require_perm("dict:data:view"))])
def list_dict_data(
    type_code: str,
    page: int = Query(1, ge=1),
    size: int = Query(50, ge=1, le=200),
    label: str | None = None,
    status: int | None = None,
    db: Session = Depends(get_db)
):
    """获取指定字典类型的数据列表（分页）"""
    from app.models.dict import DictData
    
    query = select(DictData).where(DictData.type_code == type_code)
    
    # 筛选条件
    if label:
        query = query.where(DictData.label.like(f"%{label}%"))
    if status is not None:
        query = query.where(DictData.status == status)
    
    # 排序
    query = query.order_by(DictData.sort.asc(), DictData.id.asc())
    
    # 总数
    total = db.scalar(select(func.count()).select_from(query.subquery()))
    
    # 分页
    items = db.scalars(query.offset((page - 1) * size).limit(size)).all()
    
    return {
        "items": [DictDataOut.model_validate(item, from_attributes=True) for item in items],
        "total": total,
        "page": page,
        "size": size
    }


@router.get("/data/by-code/{type_code}")
def get_dict_by_code(type_code: str, db: Session = Depends(get_db)):
    """根据字典类型编码获取所有启用的字典数据（不分页，供前端下拉框使用）"""
    from app.models.dict import DictData
    
    items = db.scalars(
        select(DictData)
        .where(DictData.type_code == type_code, DictData.status == 1)
        .order_by(DictData.sort.asc(), DictData.id.asc())
    ).all()
    
    return [DictDataOut.model_validate(item, from_attributes=True) for item in items]


@router.post("/data", dependencies=[Depends(require_perm("dict:data:add"))])
def create_dict_data(body: DictDataCreate, db: Session = Depends(get_db)):
    """创建字典数据"""
    from app.models.dict import DictType, DictData
    
    # 检查字典类型是否存在
    dt = db.scalar(select(DictType).where(DictType.code == body.type_code))
    if not dt:
        raise HTTPException(400, f"字典类型 {body.type_code} 不存在")
    
    # 检查同一类型下value是否重复
    exists = db.scalar(
        select(DictData).where(
            DictData.type_code == body.type_code,
            DictData.value == body.value
        )
    )
    if exists:
        raise HTTPException(400, f"字典值 {body.value} 已存在")
    
    dd = DictData(**body.model_dump())
    db.add(dd)
    db.commit()
    db.refresh(dd)
    
    return DictDataOut.model_validate(dd, from_attributes=True)


@router.put("/data/{data_id}", dependencies=[Depends(require_perm("dict:data:edit"))])
def update_dict_data(data_id: int, body: DictDataUpdate, db: Session = Depends(get_db)):
    """更新字典数据"""
    from app.models.dict import DictData
    
    dd = db.get(DictData, data_id)
    if not dd:
        raise HTTPException(404, "字典数据不存在")
    
    # 检查值冲突
    if body.value and body.value != dd.value:
        exists = db.scalar(
            select(DictData).where(
                DictData.type_code == dd.type_code,
                DictData.value == body.value
            )
        )
        if exists:
            raise HTTPException(400, f"字典值 {body.value} 已存在")
    
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(dd, k, v)
    
    db.commit()
    db.refresh(dd)
    
    return DictDataOut.model_validate(dd, from_attributes=True)


@router.delete("/data/{data_id}", dependencies=[Depends(require_perm("dict:data:delete"))])
def delete_dict_data(data_id: int, db: Session = Depends(get_db)):
    """删除字典数据"""
    from app.models.dict import DictData
    
    dd = db.get(DictData, data_id)
    if not dd:
        raise HTTPException(404, "字典数据不存在")
    
    db.delete(dd)
    db.commit()
    
    return {"message": "删除成功"}
