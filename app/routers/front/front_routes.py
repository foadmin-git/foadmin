# app/routers/front/front_routes.py
from .front_demo import router as front_demo_router


# 集中引入所有前台路由
front_routers = [
    front_demo_router,

]
