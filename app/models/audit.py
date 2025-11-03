# app/models/audit.py
from sqlalchemy import Column, BigInteger, String, Enum, Integer, DateTime, JSON
from sqlalchemy.sql import func
from app.core.db import Base  

class AuditLog(Base):
    __tablename__ = "foadmin_audit_log"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    trace_id = Column(String(64), nullable=False)
    level = Column(Enum("SECURITY", "BUSINESS", "SYSTEM"), nullable=False)
    actor_id = Column(BigInteger)
    actor_name = Column(String(128))
    actor_roles = Column(JSON)
    ip = Column(String(64))
    user_agent = Column(String(255))
    method = Column(String(16))
    path = Column(String(255))
    action = Column(String(64), nullable=False)
    resource_type = Column(String(64), nullable=False)
    resource_id = Column(String(64))
    status = Column(Enum("SUCCESS", "FAIL"), nullable=False)
    http_status = Column(Integer)
    latency_ms = Column(Integer)
    message = Column(String(512))
    diff_before = Column(JSON)
    diff_after = Column(JSON)
    extra = Column(JSON)
    created_at = Column(DateTime, nullable=False, server_default=func.now())
