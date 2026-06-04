# app/schemas/audit.py
from typing import Optional, Any, List
from pydantic import BaseModel
from datetime import datetime

class AuditLogOut(BaseModel):
    id: int
    trace_id: str
    level: str
    actor_id: Optional[int] = None
    actor_name: Optional[str] = None
    actor_roles: Optional[Any] = None
    ip: Optional[str] = None
    user_agent: Optional[str] = None
    method: Optional[str] = None
    path: Optional[str] = None
    action: str
    resource_type: str
    resource_id: Optional[str] = None
    status: str
    http_status: Optional[int] = None
    latency_ms: Optional[int] = None
    message: Optional[str] = None
    diff_before: Optional[Any] = None
    diff_after: Optional[Any] = None
    extra: Optional[Any] = None
    created_at: datetime

    class Config:
        orm_mode = True

class PageOut(BaseModel):
    items: List[AuditLogOut]
    total: int

class DetailOut(BaseModel):
    data: AuditLogOut
