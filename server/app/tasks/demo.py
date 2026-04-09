# app/tasks/demo.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com
"""
示例定时任务
"""
import logging
from datetime import datetime

logger = logging.getLogger(__name__)


def hello_task(name: str = "World"):
    """简单的示例任务"""
    msg = f"Hello, {name}! Current time: {datetime.now()}"
    logger.info(msg)
    print(msg)
    return msg


def cleanup_old_logs():
    """清理旧日志示例"""
    from app.core.db import SessionLocal
    from app.models.job import JobLog
    from datetime import datetime, timedelta
    
    db = SessionLocal()
    try:
        # 删除30天前的日志
        cutoff_date = datetime.now() - timedelta(days=30)
        deleted = db.query(JobLog).filter(JobLog.created_at < cutoff_date).delete()
        db.commit()
        
        msg = f"Cleaned up {deleted} old job logs"
        logger.info(msg)
        return msg
    finally:
        db.close()


def database_backup():
    """数据库备份示例（仅占位）"""
    msg = "Database backup task executed"
    logger.info(msg)
    return msg


def send_daily_report():
    """发送日报示例（仅占位）"""
    msg = "Daily report sent"
    logger.info(msg)
    return msg
