# app/core/trace.py
import uuid
from fastapi import Request

TRACE_HEADER = "X-Trace-Id"

def get_or_create_trace_id(request: Request) -> str:
    tid = request.headers.get(TRACE_HEADER)
    if not tid:
        tid = uuid.uuid4().hex
    return tid
