# app/models/job.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy import BigInteger, String, Integer, Text, DateTime
from datetime import datetime
from app.core.db import Base


class Job(Base):
    """定时任务表"""
    __tablename__ = "foadmin_sys_job"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True, comment='任务ID')
    name: Mapped[str] = mapped_column(String(128), nullable=False, comment='任务名称')
    job_id: Mapped[str] = mapped_column(String(128), nullable=False, unique=True, comment='任务唯一标识')
    job_type: Mapped[str] = mapped_column(String(32), nullable=False, comment='任务类型：cron/interval/date')
    
    # 任务执行配置
    func_name: Mapped[str] = mapped_column(String(256), nullable=False, comment='执行函数路径，如：app.tasks.demo.hello_task')
    func_args: Mapped[str | None] = mapped_column(Text, nullable=True, comment='函数参数，JSON格式')
    func_kwargs: Mapped[str | None] = mapped_column(Text, nullable=True, comment='函数关键字参数，JSON格式')
    
    # 调度配置（根据job_type不同，使用不同字段）
    cron_expression: Mapped[str | None] = mapped_column(String(128), nullable=True, comment='cron表达式，如：0 0 * * *')
    interval_seconds: Mapped[int | None] = mapped_column(Integer, nullable=True, comment='interval类型：间隔秒数')
    run_date: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment='date类型：单次执行时间')
    
    # 状态和元信息
    status: Mapped[int] = mapped_column(Integer, default=1, comment='状态：1-启用，0-暂停')
    description: Mapped[str | None] = mapped_column(String(512), nullable=True, comment='任务描述')
    remark: Mapped[str | None] = mapped_column(Text, nullable=True, comment='备注')
    
    # 执行统计
    last_run_time: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment='最后执行时间')
    next_run_time: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment='下次执行时间')
    run_count: Mapped[int] = mapped_column(Integer, default=0, comment='执行次数')
    fail_count: Mapped[int] = mapped_column(Integer, default=0, comment='失败次数')
    
    # 时间戳
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, comment='创建时间')
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, onupdate=datetime.now, comment='更新时间')


class JobLog(Base):
    """任务执行日志表"""
    __tablename__ = "foadmin_sys_job_log"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True, comment='日志ID')
    job_id: Mapped[str] = mapped_column(String(128), nullable=False, comment='任务ID')
    job_name: Mapped[str] = mapped_column(String(128), nullable=False, comment='任务名称')
    
    start_time: Mapped[datetime] = mapped_column(DateTime, nullable=False, comment='开始时间')
    end_time: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment='结束时间')
    duration: Mapped[int | None] = mapped_column(Integer, nullable=True, comment='执行耗时（毫秒）')
    
    status: Mapped[int] = mapped_column(Integer, nullable=False, comment='状态：1-成功，0-失败')
    result: Mapped[str | None] = mapped_column(Text, nullable=True, comment='执行结果')
    error: Mapped[str | None] = mapped_column(Text, nullable=True, comment='错误信息')
    traceback: Mapped[str | None] = mapped_column(Text, nullable=True, comment='异常堆栈')
    
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, comment='创建时间')
