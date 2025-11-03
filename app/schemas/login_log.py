# app/schemas/login_log.py
from typing import Optional, List
from pydantic import BaseModel
from datetime import datetime

class LoginLogOut(BaseModel):
    id: int
    trace_id: str
    actor_id: Optional[int]
    actor_name: Optional[str]
    ip: Optional[str]
    user_agent: Optional[str]
    status: str
    message: Optional[str]
    created_at: datetime

    class Config:
        orm_mode = True

class PageOut(BaseModel):
    items: List[LoginLogOut]
    total: int

class DetailOut(BaseModel):
    data: LoginLogOut
