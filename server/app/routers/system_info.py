# app/routers/system_info.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
import httpx
from app.core.db import get_db
from app.core.deps import get_current_user

router = APIRouter(prefix="/api/admin/system/info", tags=["system-info"])  # 系统信息

# 当前系统版本
CURRENT_VERSION = "v1.0.0"

# 远程版本检查URL（实际项目中可从配置文件获取）
REMOTE_VERSION_CHECK_URL = "https://version.www.foadmin.com/api/version/check"

# 模拟本地版本信息 - 在实际项目中可以从配置文件或数据库获取
VERSION_INFO = {
    "current_version": CURRENT_VERSION,
    "build_time": "2025-11-02 10:00:00",
    "release_notes": [
        "新增系统信息展示页面",
        "优化权限管理模块",
        "修复已知bug若干",
        "提升系统性能"
    ]
}

@router.get("/version")
def get_version_info(user=Depends(get_current_user), db: Session = Depends(get_db)):
    """获取系统版本信息"""
    return {
        "code": 200,
        "data": VERSION_INFO
    }

@router.get("/check-update")
async def check_for_updates(user=Depends(get_current_user), db: Session = Depends(get_db)):
    """检查系统更新 - 请求远程接口检测是否有版本升级"""
    try:
        async with httpx.AsyncClient() as client:
            # 向远程服务器发送当前版本号
            response = await client.get(
                REMOTE_VERSION_CHECK_URL,
                params={"current_version": CURRENT_VERSION},
                timeout=10.0
            )
            
            if response.status_code == 200:
                remote_data = response.json()
                return {
                    "code": 200,
                    "data": {
                        "has_update": remote_data.get("has_update", False),
                        "current_version": CURRENT_VERSION,
                        "latest_version": remote_data.get("latest_version", CURRENT_VERSION),
                        "release_notes": remote_data.get("release_notes", []),
                        "download_url": remote_data.get("download_url", "")
                    }
                }
            else:
                raise HTTPException(status_code=502, detail="无法连接到版本检查服务器")
                
    except httpx.RequestError as e:
        raise HTTPException(status_code=502, detail=f"网络请求错误: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"检查更新时发生错误: {str(e)}")