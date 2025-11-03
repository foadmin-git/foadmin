# app/core/config_loader.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
"""
动态配置加载器 - 从数据库读取配置
用法:
    from app.core.config_loader import get_config
    
    site_name = get_config('site_name', default='Foadmin')
    max_upload = get_config('upload_max_size', value_type='int', default=10)
"""
from typing import Any, Optional
from sqlalchemy.orm import Session
from app.core.db import SessionLocal
from app.models.config import SysConfig
import json

# 配置缓存（避免频繁查询数据库）
_config_cache = {}


def get_config(
    key: str,
    value_type: str = 'string',
    default: Any = None,
    db: Optional[Session] = None
) -> Any:
    """
    从数据库获取配置值
    
    Args:
        key: 配置键名
        value_type: 值类型 string/int/float/bool/json
        default: 默认值
        db: 数据库会话（可选）
    
    Returns:
        配置值（已转换类型）
    """
    # 优先从缓存读取
    if key in _config_cache:
        return _parse_value(_config_cache[key], value_type, default)
    
    # 从数据库读取
    should_close = False
    if db is None:
        db = SessionLocal()
        should_close = True
    
    try:
        config = db.query(SysConfig).filter(SysConfig.key == key).first()
        if config:
            value = config.value if config.value is not None else config.default_value
            _config_cache[key] = value
            return _parse_value(value, value_type, default)
        return default
    finally:
        if should_close:
            db.close()


def _parse_value(value: str, value_type: str, default: Any) -> Any:
    """解析配置值类型"""
    if value is None or value == '':
        return default
    
    try:
        if value_type == 'int' or value_type == 'number':
            return int(value)
        elif value_type == 'float':
            return float(value)
        elif value_type == 'bool' or value_type == 'boolean':  # 兼容 'bool' 和 'boolean'
            # 处理布尔值：true/1/yes/on 为 True，false/0/no/off 为 False
            return value.lower() in ('true', '1', 'yes', 'on')
        elif value_type == 'json':
            return json.loads(value)
        else:
            return value
    except Exception:
        return default


def refresh_config_cache():
    """刷新配置缓存（配置更新后调用）"""
    global _config_cache
    _config_cache.clear()


def get_all_configs(db: Optional[Session] = None) -> dict:
    """获取所有配置（字典格式）"""
    should_close = False
    if db is None:
        db = SessionLocal()
        should_close = True
    
    try:
        configs = db.query(SysConfig).all()
        result = {}
        for cfg in configs:
            value = cfg.value if cfg.value is not None else cfg.default_value
            result[cfg.key] = _parse_value(value, cfg.value_type, None)
        return result
    finally:
        if should_close:
            db.close()


def get_public_configs(db: Optional[Session] = None) -> dict:
    """获取所有公开配置"""
    should_close = False
    if db is None:
        db = SessionLocal()
        should_close = True
    
    try:
        configs = db.query(SysConfig).filter(SysConfig.is_public == 1).all()
        result = {}
        for cfg in configs:
            value = cfg.value if cfg.value is not None else cfg.default_value
            result[cfg.key] = _parse_value(value, cfg.value_type, None)
        return result
    finally:
        if should_close:
            db.close()
