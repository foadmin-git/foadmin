# app/core/scheduler.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
import logging
import sys
import os
from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger
from apscheduler.triggers.date import DateTrigger
from apscheduler.events import EVENT_JOB_EXECUTED, EVENT_JOB_ERROR
from sqlalchemy.orm import Session
from app.core.db import SessionLocal
import json
import importlib
import traceback as tb

# 确保app模块可以被导入
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(os.path.dirname(CURRENT_DIR))
SERVE_DIR = os.path.join(PROJECT_ROOT, 'serve')

# 添加serve目录到Python路径，确保app模块可以被导入
if SERVE_DIR not in sys.path:
    sys.path.insert(0, SERVE_DIR)
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

logger = logging.getLogger(__name__)

# 全局调度器实例
scheduler: BackgroundScheduler | None = None


def get_scheduler() -> BackgroundScheduler:
    """获取调度器实例"""
    global scheduler
    if scheduler is None:
        scheduler = BackgroundScheduler(timezone='Asia/Shanghai')
        # 添加事件监听器
        scheduler.add_listener(job_listener, EVENT_JOB_EXECUTED | EVENT_JOB_ERROR)
    return scheduler


def start_scheduler():
    """启动调度器"""
    s = get_scheduler()
    if not s.running:
        s.start()
        logger.info("✅ APScheduler started successfully")
    load_jobs_from_db()


def shutdown_scheduler():
    """关闭调度器"""
    s = get_scheduler()
    if s.running:
        s.shutdown()
        logger.info("❌ APScheduler shutdown")


def load_jobs_from_db():
    """从数据库加载所有启用的任务"""
    from app.models.job import Job
    
    db = SessionLocal()
    try:
        jobs = db.query(Job).filter(Job.status == 1).all()
        for job in jobs:
            try:
                add_job_to_scheduler(job)
                logger.info(f"✅ Loaded job: {job.job_id} - {job.name}")
            except Exception as e:
                logger.error(f"❌ Failed to load job {job.job_id}: {e}")
    finally:
        db.close()


def add_job_to_scheduler(job):
    """添加任务到调度器"""
    from app.models.job import Job
    
    s = get_scheduler()
    
    # 移除旧任务（如果存在）
    if s.get_job(job.job_id):
        s.remove_job(job.job_id)
    
    # 解析函数
    func = _import_function(job.func_name)
    args = json.loads(job.func_args) if job.func_args else []
    kwargs = json.loads(job.func_kwargs) if job.func_kwargs else {}
    
    # 根据类型创建触发器
    trigger = None
    if job.job_type == 'cron':
        # cron表达式格式：秒 分 时 日 月 周
        parts = job.cron_expression.split()
        if len(parts) == 5:  # 标准cron（无秒）
            trigger = CronTrigger(
                minute=parts[0],
                hour=parts[1],
                day=parts[2],
                month=parts[3],
                day_of_week=parts[4]
            )
        elif len(parts) == 6:  # 扩展cron（含秒）
            trigger = CronTrigger(
                second=parts[0],
                minute=parts[1],
                hour=parts[2],
                day=parts[3],
                month=parts[4],
                day_of_week=parts[5]
            )
    elif job.job_type == 'interval':
        trigger = IntervalTrigger(seconds=job.interval_seconds)
    elif job.job_type == 'date':
        trigger = DateTrigger(run_date=job.run_date)
    
    if trigger is None:
        raise ValueError(f"Invalid job type: {job.job_type}")
    
    # 添加任务
    s.add_job(
        func=func,
        trigger=trigger,
        args=args,
        kwargs=kwargs,
        id=job.job_id,
        name=job.name,
        replace_existing=True
    )
    
    # 更新下次执行时间
    ap_job = s.get_job(job.job_id)
    if ap_job and ap_job.next_run_time:
        db = SessionLocal()
        try:
            db_job = db.query(Job).filter(Job.job_id == job.job_id).first()
            if db_job:
                db_job.next_run_time = ap_job.next_run_time
                db.commit()
        finally:
            db.close()


def remove_job_from_scheduler(job_id: str):
    """从调度器移除任务"""
    s = get_scheduler()
    if s.get_job(job_id):
        s.remove_job(job_id)


def pause_job(job_id: str):
    """暂停任务"""
    s = get_scheduler()
    s.pause_job(job_id)


def resume_job(job_id: str):
    """恢复任务"""
    s = get_scheduler()
    s.resume_job(job_id)


def run_job_now(job_id: str):
    """立即执行任务"""
    from app.models.job import Job
    
    db = SessionLocal()
    try:
        job = db.query(Job).filter(Job.job_id == job_id).first()
        if not job:
            raise ValueError(f"Job {job_id} not found")
        
        func = _import_function(job.func_name)
        args = json.loads(job.func_args) if job.func_args else []
        kwargs = json.loads(job.func_kwargs) if job.func_kwargs else {}
        
        # 记录执行日志
        _execute_with_log(job_id, job.name, func, args, kwargs)
    finally:
        db.close()


def _import_function(func_path: str):
    """动态导入函数"""
    try:
        module_path, func_name = func_path.rsplit('.', 1)
        logger.debug(f"Attempting to import module: {module_path}")
        module = importlib.import_module(module_path)
        logger.debug(f"Successfully imported module: {module_path}")
        return getattr(module, func_name)
    except ImportError as e:
        logger.error(f"❌ Failed to import function {func_path}: {e}")
        # 添加更多调试信息
        logger.error(f"Current sys.path: {sys.path}")
        logger.error(f"PROJECT_ROOT: {PROJECT_ROOT}")
        logger.error(f"SERVE_DIR: {SERVE_DIR}")
        logger.error(f"CURRENT_DIR: {CURRENT_DIR}")
        # 尝试列出serve目录下的文件
        try:
            import os
            serve_contents = os.listdir(SERVE_DIR)
            logger.error(f"Contents of serve directory: {serve_contents}")
            if 'app' in serve_contents:
                app_contents = os.listdir(os.path.join(SERVE_DIR, 'app'))
                logger.error(f"Contents of serve/app directory: {app_contents}")
        except Exception as list_err:
            logger.error(f"Failed to list directory contents: {list_err}")
        raise e


def _execute_with_log(job_id: str, job_name: str, func, args, kwargs):
    """执行任务并记录日志"""
    from app.models.job import Job, JobLog
    
    db = SessionLocal()
    start_time = datetime.now()
    status = 1
    result = None
    error = None
    traceback = None
    
    try:
        result = func(*args, **kwargs)
        result = str(result) if result else "执行成功"
    except Exception as e:
        status = 0
        error = str(e)
        traceback = tb.format_exc()
        logger.error(f"❌ Job {job_id} failed: {error}\n{traceback}")
    finally:
        end_time = datetime.now()
        duration = int((end_time - start_time).total_seconds() * 1000)
        
        # 记录日志
        log = JobLog(
            job_id=job_id,
            job_name=job_name,
            start_time=start_time,
            end_time=end_time,
            duration=duration,
            status=status,
            result=result,
            error=error,
            traceback=traceback
        )
        db.add(log)
        
        # 更新任务统计
        job = db.query(Job).filter(Job.job_id == job_id).first()
        if job:
            job.last_run_time = start_time
            job.run_count += 1
            if status == 0:
                job.fail_count += 1
        
        db.commit()
        db.close()


def job_listener(event):
    """任务执行监听器"""
    if event.exception:
        logger.error(f"❌ Job {event.job_id} crashed: {event.exception}")
    else:
        logger.info(f"✅ Job {event.job_id} executed successfully")
