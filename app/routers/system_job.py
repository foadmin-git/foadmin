# app/routers/system_job.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import select, func, desc
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from app.core.db import get_db
from app.core.deps import require_perm
from app.core.scheduler import (
    add_job_to_scheduler,
    remove_job_from_scheduler,
    pause_job,
    resume_job,
    run_job_now,
    get_scheduler
)

router = APIRouter(prefix="/api/admin/system/job", tags=["job"])


# ====================== Schemas ======================

class JobCreate(BaseModel):
    name: str
    job_id: str
    job_type: str  # cron/interval/date
    func_name: str
    func_args: str | None = None
    func_kwargs: str | None = None
    cron_expression: str | None = None
    interval_seconds: int | None = None
    run_date: datetime | None = None
    status: int = 1
    description: str | None = None
    remark: str | None = None


class JobUpdate(BaseModel):
    name: str | None = None
    func_name: str | None = None
    func_args: str | None = None
    func_kwargs: str | None = None
    cron_expression: str | None = None
    interval_seconds: int | None = None
    run_date: datetime | None = None
    status: int | None = None
    description: str | None = None
    remark: str | None = None


class JobOut(BaseModel):
    id: int
    name: str
    job_id: str
    job_type: str
    func_name: str
    func_args: str | None = None
    func_kwargs: str | None = None
    cron_expression: str | None = None
    interval_seconds: int | None = None
    run_date: datetime | None = None
    status: int
    description: str | None = None
    remark: str | None = None
    last_run_time: datetime | None = None
    next_run_time: datetime | None = None
    run_count: int
    fail_count: int
    created_at: datetime
    updated_at: datetime


class JobLogOut(BaseModel):
    id: int
    job_id: str
    job_name: str
    start_time: datetime
    end_time: datetime | None = None
    duration: int | None = None
    status: int
    result: str | None = None
    error: str | None = None
    traceback: str | None = None
    created_at: datetime


# ====================== 任务管理接口 ======================

@router.get("/list", dependencies=[Depends(require_perm("job:list"))])
def list_jobs(
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    name: str | None = None,
    job_type: str | None = None,
    status: int | None = None,
    db: Session = Depends(get_db)
):
    """获取定时任务列表（分页）"""
    from app.models.job import Job
    
    query = select(Job)
    
    # 筛选条件
    if name:
        query = query.where(Job.name.like(f"%{name}%"))
    if job_type:
        query = query.where(Job.job_type == job_type)
    if status is not None:
        query = query.where(Job.status == status)
    
    # 排序
    query = query.order_by(desc(Job.id))
    
    # 总数
    total = db.scalar(select(func.count()).select_from(query.subquery()))
    
    # 分页
    items = db.scalars(query.offset((page - 1) * size).limit(size)).all()
    
    # 更新调度器中的next_run_time
    scheduler = get_scheduler()
    for item in items:
        ap_job = scheduler.get_job(item.job_id)
        if ap_job and ap_job.next_run_time:
            item.next_run_time = ap_job.next_run_time
    
    return {
        "items": [JobOut.model_validate(item, from_attributes=True) for item in items],
        "total": total,
        "page": page,
        "size": size
    }


@router.post("/create", dependencies=[Depends(require_perm("job:create"))])
def create_job(body: JobCreate, db: Session = Depends(get_db)):
    """创建定时任务"""
    from app.models.job import Job
    
    # 检查job_id是否已存在
    exists = db.scalar(select(Job).where(Job.job_id == body.job_id))
    if exists:
        raise HTTPException(400, f"任务ID {body.job_id} 已存在")
    
    # 验证任务类型和配置
    if body.job_type == 'cron' and not body.cron_expression:
        raise HTTPException(400, "cron类型任务必须提供cron表达式")
    elif body.job_type == 'interval' and not body.interval_seconds:
        raise HTTPException(400, "interval类型任务必须提供间隔秒数")
    elif body.job_type == 'date' and not body.run_date:
        raise HTTPException(400, "date类型任务必须提供执行时间")
    
    job = Job(**body.model_dump())
    db.add(job)
    db.commit()
    db.refresh(job)
    
    # 如果启用，添加到调度器
    if job.status == 1:
        try:
            add_job_to_scheduler(job)
        except Exception as e:
            raise HTTPException(500, f"添加任务到调度器失败: {str(e)}")
    
    return JobOut.model_validate(job, from_attributes=True)


@router.put("/update/{job_id}", dependencies=[Depends(require_perm("job:update"))])
def update_job(job_id: int, body: JobUpdate, db: Session = Depends(get_db)):
    """更新定时任务"""
    from app.models.job import Job
    
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(404, "任务不存在")
    
    # 更新字段
    for k, v in body.model_dump(exclude_unset=True).items():
        setattr(job, k, v)
    
    db.commit()
    db.refresh(job)
    
    # 重新加载到调度器
    remove_job_from_scheduler(job.job_id)
    if job.status == 1:
        try:
            add_job_to_scheduler(job)
        except Exception as e:
            raise HTTPException(500, f"更新调度器失败: {str(e)}")
    
    return JobOut.model_validate(job, from_attributes=True)


@router.delete("/delete/{job_id}", dependencies=[Depends(require_perm("job:del"))])
def delete_job(job_id: int, db: Session = Depends(get_db)):
    """删除定时任务"""
    from app.models.job import Job
    
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(404, "任务不存在")
    
    # 从调度器移除
    remove_job_from_scheduler(job.job_id)
    
    db.delete(job)
    db.commit()
    
    return {"message": "删除成功"}


@router.post("/pause/{job_id}", dependencies=[Depends(require_perm("job:pause"))])
def pause_job_api(job_id: int, db: Session = Depends(get_db)):
    """暂停任务"""
    from app.models.job import Job
    
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(404, "任务不存在")
    
    job.status = 0
    db.commit()
    
    try:
        pause_job(job.job_id)
    except Exception as e:
        # 任务可能未加载到调度器
        pass
    
    return {"message": "任务已暂停"}


@router.post("/resume/{job_id}", dependencies=[Depends(require_perm("job:resume"))])
def resume_job_api(job_id: int, db: Session = Depends(get_db)):
    """恢复任务"""
    from app.models.job import Job
    
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(404, "任务不存在")
    
    job.status = 1
    db.commit()
    
    try:
        add_job_to_scheduler(job)
    except Exception as e:
        raise HTTPException(500, f"恢复任务失败: {str(e)}")
    
    return {"message": "任务已恢复"}


@router.post("/run/{job_id}", dependencies=[Depends(require_perm("job:exec"))])
def run_job_api(job_id: int, db: Session = Depends(get_db)):
    """立即执行任务"""
    from app.models.job import Job
    
    job = db.get(Job, job_id)
    if not job:
        raise HTTPException(404, "任务不存在")
    
    try:
        run_job_now(job.job_id)
        return {"message": "任务已提交执行"}
    except Exception as e:
        raise HTTPException(500, f"执行任务失败: {str(e)}")


# ====================== 任务日志接口 ======================

@router.get("/logs", dependencies=[Depends(require_perm("job:log:list"))])
def list_job_logs(
    page: int = Query(1, ge=1),
    size: int = Query(50, ge=1, le=200),
    job_id: str | None = None,
    status: int | None = None,
    db: Session = Depends(get_db)
):
    """获取任务执行日志（分页）"""
    from app.models.job import JobLog
    
    query = select(JobLog)
    
    # 筛选条件
    if job_id:
        query = query.where(JobLog.job_id == job_id)
    if status is not None:
        query = query.where(JobLog.status == status)
    
    # 排序
    query = query.order_by(desc(JobLog.id))
    
    # 总数
    total = db.scalar(select(func.count()).select_from(query.subquery()))
    
    # 分页
    items = db.scalars(query.offset((page - 1) * size).limit(size)).all()
    
    return {
        "items": [JobLogOut.model_validate(item, from_attributes=True) for item in items],
        "total": total,
        "page": page,
        "size": size
    }


@router.delete("/logs/clear", dependencies=[Depends(require_perm("job:log:clear"))])
def clear_job_logs(
    days: int = Query(30, ge=1),
    db: Session = Depends(get_db)
):
    """清理指定天数前的日志"""
    from app.models.job import JobLog
    from datetime import datetime, timedelta
    
    cutoff_date = datetime.now() - timedelta(days=days)
    deleted = db.query(JobLog).filter(JobLog.created_at < cutoff_date).delete()
    db.commit()
    
    return {"message": f"已清理 {deleted} 条日志"}
