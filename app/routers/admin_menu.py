# app/routers/admin_menu.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.core.db import get_db
from app.core.deps import get_current_user
from app.models.rbac import Permission

router = APIRouter(prefix="/api/admin/menus", tags=["admin-menu"])  # 后台菜单


def build_tree(items: list[dict]):
    by_id = {x["id"]: {**x, "children": []} for x in items}
    roots = []
    for x in by_id.values():
        pid = x.get("parent_id")
        if pid and pid in by_id:
            by_id[pid]["children"].append(x)
        else:
            roots.append(x)
    # sort by sort
    def sort_children(node):
        node["children"].sort(key=lambda n: n.get("sort", 0))
        for c in node["children"]:
            sort_children(c)
    for r in roots:
        sort_children(r)
    roots.sort(key=lambda n: n.get("sort", 0))
    return roots


@router.get("")
def my_menus(user=Depends(get_current_user), db: Session = Depends(get_db)):
    # 过滤平台=admin 且 type=menu
    rows = db.query(Permission).filter(Permission.type=="menu", Permission.platform=="admin").all()
    # 根据用户权限码过滤可见菜单（若菜单声明 code 则用户必须拥有）
    user_perms: list[str] = user.get("perms", [])
    items = []
    for p in rows:
        if p.code and p.code not in user_perms:
            continue
        items.append({
            "id": p.id,
            "title": p.name,
            "name": p.route_name,
            "icon": p.icon,
            "path": p.route_path,
            "route_component": p.route_component,
            "parent_id": p.parent_id,
            "sort": p.sort
        })
    return {"items": build_tree(items)}