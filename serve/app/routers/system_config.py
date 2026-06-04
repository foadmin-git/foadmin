# app/routers/system_config.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import or_
from typing import List, Optional, Any
from pydantic import BaseModel
import json

from app.core.db import get_db
from app.core.deps import require_perm, get_current_user
from app.core.config_loader import refresh_config_cache
from app.models.config import SysConfig

router = APIRouter(prefix="/api/admin/system/config", tags=["admin-system-config"])


# ---------------------------
# Pydantic Schemas
# ---------------------------
class ConfigOut(BaseModel):
    id: int
    category: str
    key: str
    value: Optional[str] = None
    value_type: str
    name: str
    description: Optional[str] = None
    options: Optional[str] = None
    default_value: Optional[str] = None
    is_public: int
    sort: int
    
    class Config:
        from_attributes = True


class ConfigBatchUpdate(BaseModel):
    """批量更新配置"""
    configs: List[dict]  # [{"key": "site_name", "value": "新站点名"}, ...]


class ConfigCreate(BaseModel):
    category: str
    key: str
    value: Optional[str] = None
    value_type: str = "string"
    name: str
    description: Optional[str] = None
    options: Optional[str] = None
    default_value: Optional[str] = None
    is_public: int = 0
    sort: int = 0


class ConfigUpdate(BaseModel):
    category: Optional[str] = None
    value: Optional[str] = None
    value_type: Optional[str] = None
    name: Optional[str] = None
    description: Optional[str] = None
    options: Optional[str] = None
    default_value: Optional[str] = None
    is_public: Optional[int] = None
    sort: Optional[int] = None


# ---------------------------
# Routes
# ---------------------------
@router.get("", dependencies=[Depends(require_perm("system:config:view"))])
def list_configs(
    db: Session = Depends(get_db),
    category: Optional[str] = None,
    kw: Optional[str] = None,
):
    """获取配置列表（按分类分组）"""
    q = db.query(SysConfig)
    
    if category:
        q = q.filter(SysConfig.category == category)
    
    if kw:
        like = f"%{kw}%"
        q = q.filter(or_(SysConfig.name.like(like), SysConfig.key.like(like)))
    
    rows = q.order_by(SysConfig.category, SysConfig.sort, SysConfig.id).all()
    
    # 按分类分组
    grouped = {}
    for r in rows:
        cat = r.category
        if cat not in grouped:
            grouped[cat] = []
        grouped[cat].append(ConfigOut.from_orm(r))
    
    return {"grouped": grouped}


@router.get("/public")
def list_public_configs(db: Session = Depends(get_db)):
    """获取公开配置（前端可用，无需权限）"""
    rows = db.query(SysConfig).filter(SysConfig.is_public == 1).all()
    result = {}
    for r in rows:
        result[r.key] = r.value
    return result


@router.get("/{key}")
def get_config_by_key(
    key: str,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """根据key获取单个配置值"""
    cfg = db.query(SysConfig).filter(SysConfig.key == key).first()
    if not cfg:
        raise HTTPException(404, "配置不存在")
    return {"key": cfg.key, "value": cfg.value}


@router.post("", dependencies=[Depends(require_perm("system:config:edit"))])
def create_config(
    body: ConfigCreate,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """新增配置项"""
    if db.query(SysConfig).filter(SysConfig.key == body.key).first():
        raise HTTPException(400, "配置键名已存在")
    
    cfg = SysConfig(
        category=body.category,
        key=body.key,
        value=body.value,
        value_type=body.value_type,
        name=body.name,
        description=body.description,
        options=body.options,
        default_value=body.default_value,
        is_public=body.is_public,
        sort=body.sort,
        updated_by=int(user.get("sub"))
    )
    db.add(cfg)
    db.commit()
    db.refresh(cfg)
    return {"id": cfg.id}


@router.put("/{cid}", dependencies=[Depends(require_perm("system:config:edit"))])
def update_config(
    cid: int,
    body: ConfigUpdate,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """更新配置项"""
    cfg = db.get(SysConfig, cid)
    if not cfg:
        raise HTTPException(404, "配置不存在")
    
    if body.category is not None:
        cfg.category = body.category
    if body.value is not None:
        cfg.value = body.value
    if body.value_type is not None:
        cfg.value_type = body.value_type
    if body.name is not None:
        cfg.name = body.name
    if body.description is not None:
        cfg.description = body.description
    if body.options is not None:
        cfg.options = body.options
    if body.default_value is not None:
        cfg.default_value = body.default_value
    if body.is_public is not None:
        cfg.is_public = body.is_public
    if body.sort is not None:
        cfg.sort = body.sort
    
    cfg.updated_by = int(user.get("sub"))
    db.commit()
    
    # 刷新配置缓存，使配置立即生效
    refresh_config_cache()
    
    return {"ok": True}


@router.delete("/{cid}", dependencies=[Depends(require_perm("system:config:edit"))])
def delete_config(
    cid: int,
    db: Session = Depends(get_db)
):
    """删除配置项"""
    cfg = db.get(SysConfig, cid)
    if not cfg:
        raise HTTPException(404, "配置不存在")
    db.delete(cfg)
    db.commit()
    return {"ok": True}


@router.post("/batch", dependencies=[Depends(require_perm("system:config:edit"))])
def batch_update_configs(
    body: ConfigBatchUpdate,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """批量更新配置值（用于保存表单）"""
    user_id = int(user.get("sub"))
    
    for item in body.configs:
        key = item.get("key")
        value = item.get("value")
        
        if not key:
            continue
        
        cfg = db.query(SysConfig).filter(SysConfig.key == key).first()
        if cfg:
            cfg.value = value
            cfg.updated_by = user_id
    
    db.commit()
    
    # 刷新配置缓存，使配置立即生效
    refresh_config_cache()
    
    return {"ok": True, "count": len(body.configs)}
