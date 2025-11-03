# app/core/static_file_middleware.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com

"""
静态文件访问中间件

功能特性:
1. 支持配置开关，动态启用/禁用静态文件访问
2. 防止路径穿越攻击
3. 支持自定义URL前缀
4. 配置热更新，无需重启服务
"""

from pathlib import Path
from fastapi import Request
from fastapi.responses import FileResponse
from starlette.middleware.base import BaseHTTPMiddleware
from app.core.db import SessionLocal
from app.core.config_loader import get_config
import logging

logger = logging.getLogger(__name__)


class StaticFileMiddleware(BaseHTTPMiddleware):
    """
    静态文件访问中间件
    
    根据系统配置动态决定是否允许直接URL访问上传的文件
    
    配置项：
    - enable_static_access: 是否启用静态文件访问（默认false）
    - static_url_prefix: 静态文件URL前缀（默认 /runtime/uploads）
    - upload_path: 文件存储路径（默认 ./runtime/uploads）
    - static_allowed_types: 允许访问的文件类型（可选，逗号分隔）
    
    安全机制：
    - 路径穿越防护：自动检测并阻止 ../ 等攻击
    - 路径验证：确保只能访问上传目录内的文件
    - 文件类型限制：可配置允许访问的文件扩展名
    """
    
    async def dispatch(self, request: Request, call_next):
        """
        处理静态文件请求
        
        Args:
            request: HTTP请求对象
            call_next: 下一个中间件或路由处理器
            
        Returns:
            FileResponse 或继续传递给下一个处理器
        """
        path = request.url.path
        
        # 从数据库读取配置（每次请求都读取，支持热更新）
        db = SessionLocal()
        try:
            # 检查是否启用静态文件访问
            enable_static = get_config('enable_static_access', 'bool', False, db)
            
            # 如果未启用，直接跳过
            if not enable_static:
                return await call_next(request)
            
            # 获取配置
            static_prefix = get_config('static_url_prefix', 'string', '/runtime/uploads', db)
            upload_path = get_config('upload_path', 'string', './runtime/uploads', db)
            allowed_types_str = get_config('static_allowed_types', 'string', '', db)
            
            # 检查路径是否匹配静态文件前缀
            if not path.startswith(static_prefix):
                return await call_next(request)
            
            # 提取文件相对路径
            relative_path = path[len(static_prefix):].lstrip('/')
            
            # 如果路径为空，返回404
            if not relative_path:
                return await call_next(request)
            
            # 拼接完整文件路径
            file_path = Path(upload_path) / relative_path
            
            # 安全检查：防止路径穿越攻击
            try:
                # 解析真实路径
                file_path = file_path.resolve()
                upload_root = Path(upload_path).resolve()
                
                # 检查解析后的路径是否在上传目录内
                if not str(file_path).startswith(str(upload_root)):
                    logger.warning(f"路径穿越尝试: {path} -> {file_path}")
                    return await call_next(request)
                
                # 检查文件是否存在
                if not file_path.exists() or not file_path.is_file():
                    return await call_next(request)
                
                # 文件类型检查（如果配置了允许的类型）
                if allowed_types_str:
                    allowed_types = [ext.strip().lower() for ext in allowed_types_str.split(',') if ext.strip()]
                    file_ext = file_path.suffix.lstrip('.').lower()
                    
                    if allowed_types and file_ext not in allowed_types:
                        logger.warning(f"文件类型不允许访问: {file_ext}, 文件: {path}")
                        return await call_next(request)
                
                # 返回文件
                logger.info(f"静态文件访问: {path}")
                return FileResponse(
                    file_path,
                    media_type=self._get_mime_type(file_path)
                )
                
            except Exception as e:
                logger.error(f"静态文件访问错误: {path}, 错误: {e}")
                return await call_next(request)
                
        finally:
            db.close()
        
        # 非静态文件请求，继续正常处理
        return await call_next(request)
    
    def _get_mime_type(self, file_path: Path) -> str:
        """
        根据文件扩展名获取MIME类型
        
        Args:
            file_path: 文件路径
            
        Returns:
            MIME类型字符串
        """
        import mimetypes
        mime_type, _ = mimetypes.guess_type(str(file_path))
        return mime_type or 'application/octet-stream'
