# app/routers/system_user.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import or_
from typing import List, Optional, Tuple
from pydantic import BaseModel

from app.core.db import get_db
from app.core.deps import require_perm
from app.models.user import User
from app.models.rbac import Role, UserRole
from app.models.dept import SysDept
from app.models.level import SysLevel

router = APIRouter(prefix="/api/admin/system/users", tags=["admin-system-users"])


# ---------------------------
# Pydantic Schemas
# ---------------------------
class UserOut(BaseModel):
    id: int
    username: str
    nick_name: Optional[str] = None
    dept_id: Optional[int] = None
    dept_name: Optional[str] = None
    level_id: Optional[int] = None
    level_name: Optional[str] = None
    status: int
    avatar_file_id: Optional[int] = None
    avatar_url: Optional[str] = None

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    username: str
    nick_name: Optional[str] = None
    password: Optional[str] = None
    dept_id: Optional[int] = None
    level_id: Optional[int] = None
    status: Optional[int] = 1
    # 新增头像字段，创建用户时可选
    avatar_file_id: Optional[int] = None
    avatar_url: Optional[str] = None


class UserUpdate(BaseModel):
    # 若不允许修改用户名，可将该字段删除
    username: Optional[str] = None
    nick_name: Optional[str] = None
    password: Optional[str] = None
    dept_id: Optional[int] = None
    level_id: Optional[int] = None
    status: Optional[int] = None
    # 新增头像字段，更新用户时可选
    avatar_file_id: Optional[int] = None
    avatar_url: Optional[str] = None


class BindRolesIn(BaseModel):
    role_ids: List[int]


# ---------------------------
# Helpers
# ---------------------------
def collect_dept_ids(db: Session, root_id: int) -> List[int]:
    """收集某组织及其所有子组织的 id 列表。"""
    rows: List[SysDept] = db.query(SysDept).all()
    children_map: dict[Optional[int], List[int]] = {}
    for r in rows:
        children_map.setdefault(r.parent_id, []).append(r.id)

    out: List[int] = []
    stack: List[int] = [root_id]
    while stack:
        cur = stack.pop()
        out.append(cur)
        stack.extend(children_map.get(cur, []))
    return out


def pack_user(u: User, d: Optional[SysDept], l: Optional[SysLevel]) -> UserOut:
    return UserOut(
        id=u.id,
        username=u.username,
        nick_name=u.nick_name,
        dept_id=u.dept_id,
        dept_name=(d.name if d else None),
        level_id=u.level_id,
        level_name=(l.name if l else None),
        status=u.status,
        avatar_file_id=u.avatar_file_id,
        avatar_url=u.avatar_url,
    )


# ---------------------------
# Routes
# ---------------------------
@router.get("", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def list_users(
    db: Session = Depends(get_db),
    kw: Optional[str] = None,
    page: int = 1,
    size: int = 10,
    dept_id: Optional[int] = None,
    include_child: int = 1,  # 1=包含子级, 0=仅本级
    level_id: Optional[int] = None,
    status: Optional[int] = None,
):
    q = (
        db.query(User, SysDept, SysLevel)
        .outerjoin(SysDept, SysDept.id == User.dept_id)
        .outerjoin(SysLevel, SysLevel.id == User.level_id)
    )

    if kw:
        like = f"%{kw}%"
        q = q.filter(or_(User.username.like(like), User.nick_name.like(like)))

    if level_id is not None:
        q = q.filter(User.level_id == level_id)

    if status is not None:
        q = q.filter(User.status == int(status))

    if dept_id is not None:
        if include_child:
            ids = collect_dept_ids(db, int(dept_id))
            if ids:
                q = q.filter(User.dept_id.in_(ids))
            else:
                q = q.filter(User.dept_id == dept_id)
        else:
            q = q.filter(User.dept_id == dept_id)

    total = q.count()
    rows: List[Tuple[User, Optional[SysDept], Optional[SysLevel]]] = (
        q.order_by(User.id.desc()).offset((page - 1) * size).limit(size).all()
    )
    items = [pack_user(u, d, l) for (u, d, l) in rows]
    return {"items": items, "total": total}


@router.post("", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def create_user(body: UserCreate, db: Session = Depends(get_db)):
    if db.query(User).filter(User.username == body.username).first():
        raise HTTPException(400, "用户名已存在")
    from app.core.security import hash_password, validate_password_complexity

    # 获取密码（默认为 "123456"）
    password = body.password or "123456"
    
    # 验证密码复杂度（如果启用了密码复杂度要求）
    validate_password_complexity(password, db)

    u = User(
        username=body.username,
        nick_name=body.nick_name or body.username,
        password_hash=hash_password(password),
        dept_id=body.dept_id,
        level_id=body.level_id,
        status=body.status if body.status is not None else 1,
        avatar_file_id=body.avatar_file_id,
        avatar_url=body.avatar_url,
    )
    db.add(u)
    db.commit()
    return {"id": u.id}


@router.put("/{uid}", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def update_user(uid: int, body: UserUpdate, db: Session = Depends(get_db)):
    u = db.get(User, uid)
    if not u:
        raise HTTPException(404, "用户不存在")

    # 允许修改用户名则做唯一性校验
    if body.username is not None:
        exists = db.query(User).filter(User.username == body.username, User.id != uid).first()
        if exists:
            raise HTTPException(400, "用户名已被占用")
        u.username = body.username

    if body.nick_name is not None:
        u.nick_name = body.nick_name
    if body.dept_id is not None:
        u.dept_id = body.dept_id
    if body.level_id is not None:
        u.level_id = body.level_id
    if body.status is not None:
        u.status = int(body.status)
    if body.password:
        from app.core.security import hash_password, validate_password_complexity
        
        # 验证密码复杂度（如果启用了密码复杂度要求）
        validate_password_complexity(body.password, db)

        u.password_hash = hash_password(body.password)

    # 更新头像字段：file_id 与 url 二选一
    if body.avatar_file_id is not None:
        u.avatar_file_id = body.avatar_file_id
    if body.avatar_url is not None:
        # 清空 file_id，如果仅更新 avatar_url
        u.avatar_url = body.avatar_url
        # 若传入空字符串则置空
        if not body.avatar_url:
            u.avatar_url = None

    db.commit()
    return {"ok": True}


@router.delete("/{uid}", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def delete_user(uid: int, db: Session = Depends(get_db)):
    u = db.get(User, uid)
    if not u:
        raise HTTPException(404, "用户不存在")
    db.query(UserRole).filter(UserRole.user_id == uid).delete()
    db.delete(u)
    db.commit()
    return {"ok": True}


@router.get("/{uid}/roles", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def get_user_roles(uid: int, db: Session = Depends(get_db)):
    role_ids = [r.role_id for r in db.query(UserRole).where(UserRole.user_id == uid).all()]
    roles = db.query(Role).all()
    return {
        "all": [{"id": r.id, "code": r.code, "name": r.name} for r in roles],
        "selected": role_ids,
    }


@router.put("/{uid}/roles", dependencies=[Depends(require_perm("central-auth-org-user:view"))])
def bind_user_roles(uid: int, body: BindRolesIn, db: Session = Depends(get_db)):
    if not db.get(User, uid):
        raise HTTPException(404, "用户不存在")
    db.query(UserRole).filter(UserRole.user_id == uid).delete()
    for rid in set(body.role_ids or []):
        db.add(UserRole(user_id=uid, role_id=rid))
    db.commit()
    return {"ok": True}
