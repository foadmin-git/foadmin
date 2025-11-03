# app/routers/front_demo.py  （前台示例 API，与后台隔离）
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter

router = APIRouter(prefix="/api/front", tags=["front-demo"])  # 前台 API

@router.get("/hello")
def hello():
    return {"ok": True, "msg": "hello from front"}