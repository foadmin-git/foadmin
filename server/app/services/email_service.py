# app/services/email_service.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com

"""
邮件发送服务模块

功能特性:
1. 从系统配置动态读取SMTP设置
2. 支持HTML和纯文本邮件
3. 支持附件发送
4. 完善的错误处理和日志记录
5. 防止邮件滥用的安全机制
"""

import smtplib
import ssl
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from typing import List, Optional, Dict, Any
from pathlib import Path
import logging
from datetime import datetime, timedelta
from sqlalchemy.orm import Session

from app.core.config_loader import get_config

# 配置日志
logger = logging.getLogger(__name__)

# 邮件发送限流缓存 {email: (count, start_time)}
# 用于防止邮件滥用
EMAIL_RATE_LIMIT: Dict[str, tuple[int, float]] = {}


class EmailServiceException(Exception):
    """邮件服务异常"""
    pass


class EmailService:
    """邮件发送服务类"""
    
    def __init__(self, db: Session = None):
        """
        初始化邮件服务
        
        Args:
            db: 数据库会话，用于读取配置
        """
        self.db = db
        self._load_config()
    
    def _load_config(self):
        """从系统配置加载SMTP设置"""
        try:
            self.smtp_host = get_config('smtp_host', 'string', '', self.db)
            self.smtp_port = int(get_config('smtp_port', 'number', 465, self.db) or 465)
            self.smtp_user = get_config('smtp_user', 'string', '', self.db)
            self.smtp_password = get_config('smtp_password', 'string', '', self.db)
            self.smtp_from = get_config('smtp_from', 'string', '', self.db)
            self.smtp_ssl = get_config('smtp_ssl', 'boolean', True, self.db)
            # 新增：SSL证书验证配置（默认不验证，避免 Windows 环境证书问题）
            self.smtp_ssl_verify = get_config('smtp_ssl_verify', 'boolean', False, self.db)
            
            # 验证必要配置是否完整
            if not all([self.smtp_host, self.smtp_user, self.smtp_password]):
                logger.warning("SMTP配置不完整，邮件发送功能将不可用")
                self.is_configured = False
            else:
                self.is_configured = True
                
        except Exception as e:
            logger.error(f"加载SMTP配置失败: {e}")
            self.is_configured = False
    
    def check_rate_limit(self, recipient: str, max_count: int = 10, window_seconds: int = 3600) -> bool:
        """
        检查邮件发送速率限制（防止滥用）
        
        Args:
            recipient: 收件人邮箱
            max_count: 时间窗口内最大发送次数
            window_seconds: 时间窗口（秒）
            
        Returns:
            True: 允许发送
            False: 超过速率限制
        """
        from time import time
        now = time()
        
        if recipient in EMAIL_RATE_LIMIT:
            count, start_time = EMAIL_RATE_LIMIT[recipient]
            
            # 如果时间窗口已过，重置计数
            if now - start_time > window_seconds:
                EMAIL_RATE_LIMIT[recipient] = (1, now)
                return True
            
            # 检查是否超过限制
            if count >= max_count:
                logger.warning(f"邮件发送速率限制: {recipient} 在 {window_seconds}秒内已发送 {count} 封邮件")
                return False
            
            # 增加计数
            EMAIL_RATE_LIMIT[recipient] = (count + 1, start_time)
        else:
            EMAIL_RATE_LIMIT[recipient] = (1, now)
        
        return True
    
    def validate_email(self, email: str) -> bool:
        """
        验证邮箱地址格式
        
        Args:
            email: 邮箱地址
            
        Returns:
            True: 有效的邮箱地址
            False: 无效的邮箱地址
        """
        import re
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))
    
    def send_email(
        self,
        to_email: str | List[str],
        subject: str,
        content: str,
        content_type: str = 'html',
        cc: Optional[List[str]] = None,
        bcc: Optional[List[str]] = None,
        attachments: Optional[List[str]] = None,
        check_rate_limit: bool = True
    ) -> bool:
        """
        发送邮件
        
        Args:
            to_email: 收件人邮箱（单个字符串或列表）
            subject: 邮件主题
            content: 邮件内容
            content_type: 内容类型 ('html' 或 'plain')
            cc: 抄送列表
            bcc: 密送列表
            attachments: 附件文件路径列表
            check_rate_limit: 是否检查速率限制
            
        Returns:
            True: 发送成功
            False: 发送失败
            
        Raises:
            EmailServiceException: 邮件服务异常
        """
        # 检查配置是否完整
        if not self.is_configured:
            raise EmailServiceException("SMTP配置不完整，请先在系统配置中设置邮件服务器信息")
        
        # 统一处理收件人格式
        recipients = [to_email] if isinstance(to_email, str) else to_email
        
        # 验证收件人邮箱格式
        for email in recipients:
            if not self.validate_email(email):
                raise EmailServiceException(f"无效的邮箱地址: {email}")
        
        # 检查速率限制（防止滥用）
        if check_rate_limit:
            for email in recipients:
                if not self.check_rate_limit(email):
                    raise EmailServiceException(f"邮件发送过于频繁，请稍后再试")
        
        try:
            # 创建邮件消息
            message = MIMEMultipart()
            message['From'] = self.smtp_from or self.smtp_user
            message['To'] = ', '.join(recipients)
            message['Subject'] = subject
            
            # 添加抄送
            if cc:
                message['Cc'] = ', '.join(cc)
                recipients.extend(cc)
            
            # 添加密送（不在邮件头中显示）
            if bcc:
                recipients.extend(bcc)
            
            # 添加邮件内容
            if content_type.lower() == 'html':
                message.attach(MIMEText(content, 'html', 'utf-8'))
            else:
                message.attach(MIMEText(content, 'plain', 'utf-8'))
            
            # 添加附件
            if attachments:
                for file_path in attachments:
                    self._attach_file(message, file_path)
            
            # 发送邮件
            if self.smtp_ssl:
                # 使用SSL连接（端口通常为465）
                if self.smtp_ssl_verify:
                    context = ssl.create_default_context()
                else:
                    context = ssl.create_default_context()
                    context.check_hostname = False
                    context.verify_mode = ssl.CERT_NONE
                
                logger.info(f"尝试通过 SSL 连接到 {self.smtp_host}:{self.smtp_port}")
                try:
                    server = smtplib.SMTP_SSL(self.smtp_host, self.smtp_port, context=context, timeout=30)
                    logger.info("SSL 连接已建立")
                    
                    # EHLO 握手
                    logger.info("发送 EHLO 命令...")
                    server.ehlo()
                    logger.info("EHLO 握手成功")
                    
                    # 认证
                    logger.info(f"开始认证，用户: {self.smtp_user}")
                    server.login(self.smtp_user, self.smtp_password)
                    logger.info("认证成功")
                    
                    # 发送邮件
                    logger.info(f"发送邮件: {self.smtp_from or self.smtp_user} -> {recipients}")
                    result = server.sendmail(self.smtp_from or self.smtp_user, recipients, message.as_string())
                    logger.info(f"sendmail 返回结果: {result}")
                    
                    server.quit()
                    logger.info("邮件发送成功，连接已关闭")
                    
                except Exception as e:
                    logger.error(f"发送过程出错: {type(e).__name__}: {e}")
                    import traceback
                    logger.error(f"详细错误: {traceback.format_exc()}")
                    raise
                    
            else:
                # 使用TLS连接（端口通常为587或25）
                logger.info(f"尝试通过 STARTTLS 连接到 {self.smtp_host}:{self.smtp_port}")
                server = smtplib.SMTP(self.smtp_host, self.smtp_port, timeout=30)
                logger.info("SMTP 连接已建立")
                
                server.ehlo()
                logger.info("EHLO 握手成功")
                
                logger.info("开始 STARTTLS 握手...")
                if not self.smtp_ssl_verify:
                    context = ssl.create_default_context()
                    context.check_hostname = False
                    context.verify_mode = ssl.CERT_NONE
                    server.starttls(context=context)
                else:
                    server.starttls()
                server.ehlo()
                logger.info("STARTTLS 握手成功")
                
                logger.info(f"开始认证，用户: {self.smtp_user}")
                server.login(self.smtp_user, self.smtp_password)
                logger.info("认证成功")
                
                logger.info(f"发送邮件: {self.smtp_from or self.smtp_user} -> {recipients}")
                result = server.sendmail(self.smtp_from or self.smtp_user, recipients, message.as_string())
                logger.info(f"sendmail 返回结果: {result}")
                
                server.quit()
                logger.info("邮件发送成功，连接已关闭")
            
            logger.info(f"邮件发送成功: {subject} -> {', '.join(recipients)}")
            return True
            
        except smtplib.SMTPAuthenticationError as e:
            logger.error(f"SMTP认证失败: {e}")
            raise EmailServiceException("邮件服务器认证失败，请检查用户名和密码")
        except smtplib.SMTPServerDisconnected as e:
            logger.error(f"SMTP服务器断开连接: {e}")
            raise EmailServiceException(f"邮件服务器连接断开: {str(e)}")
        except smtplib.SMTPConnectError as e:
            logger.error(f"SMTP连接错误: {e}")
            raise EmailServiceException(f"无法连接到邮件服务器: {str(e)}")
        except smtplib.SMTPException as e:
            logger.error(f"SMTP错误: {e}")
            raise EmailServiceException(f"邮件发送失败: {str(e)}")
        except ssl.SSLError as e:
            logger.error(f"SSL错误: {e}")
            raise EmailServiceException(f"SSL连接失败: {str(e)}，建议检查端口配置或禁用SSL证书验证")
        except Exception as e:
            logger.error(f"发送邮件时出错: {type(e).__name__}: {e}")
            raise EmailServiceException(f"邮件发送失败: {str(e)}")
    
    def _attach_file(self, message: MIMEMultipart, file_path: str):
        """
        添加附件到邮件
        
        Args:
            message: 邮件消息对象
            file_path: 附件文件路径
        """
        try:
            path = Path(file_path)
            if not path.exists():
                raise FileNotFoundError(f"附件文件不存在: {file_path}")
            
            with open(file_path, 'rb') as f:
                part = MIMEBase('application', 'octet-stream')
                part.set_payload(f.read())
                encoders.encode_base64(part)
                part.add_header(
                    'Content-Disposition',
                    f'attachment; filename= {path.name}'
                )
                message.attach(part)
                
        except Exception as e:
            logger.error(f"添加附件失败: {e}")
            raise EmailServiceException(f"添加附件失败: {str(e)}")
    
    def send_template_email(
        self,
        to_email: str | List[str],
        template_type: str,
        context: Dict[str, Any],
        **kwargs
    ) -> bool:
        """
        使用模板发送邮件
        
        Args:
            to_email: 收件人邮箱
            template_type: 模板类型 (如: 'reset_password', 'welcome', 'notification')
            context: 模板变量上下文
            **kwargs: 其他参数传递给send_email
            
        Returns:
            True: 发送成功
            False: 发送失败
        """
        # 根据模板类型生成邮件内容
        templates = {
            'reset_password': {
                'subject': '【{site_name}】重置密码',
                'content': '''
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                        <h2>重置密码</h2>
                        <p>您好，{username}！</p>
                        <p>您请求重置密码。请点击下面的链接重置您的密码：</p>
                        <p><a href="{reset_url}" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">重置密码</a></p>
                        <p>此链接将在 {expire_hours} 小时后失效。</p>
                        <p>如果您没有请求重置密码，请忽略此邮件。</p>
                        <hr>
                        <p style="color: #888; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
                    </div>
                '''
            },
            'welcome': {
                'subject': '欢迎加入【{site_name}】',
                'content': '''
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                        <h2>欢迎加入！</h2>
                        <p>您好，{username}！</p>
                        <p>感谢您注册 {site_name}。</p>
                        <p>您的账号信息：</p>
                        <ul>
                            <li>用户名: {username}</li>
                            <li>邮箱: {email}</li>
                        </ul>
                        <p><a href="{login_url}" style="background-color: #2196F3; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">立即登录</a></p>
                        <hr>
                        <p style="color: #888; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
                    </div>
                '''
            },
            'notification': {
                'subject': '【{site_name}】系统通知',
                'content': '''
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                        <h2>系统通知</h2>
                        <p>您好，{username}！</p>
                        <p>{message}</p>
                        <hr>
                        <p style="color: #888; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
                    </div>
                '''
            },
            'verification': {
                'subject': '【{site_name}】邮箱验证',
                'content': '''
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                        <h2>邮箱验证</h2>
                        <p>您好！</p>
                        <p>您的验证码是：</p>
                        <h1 style="color: #4CAF50; letter-spacing: 5px;">{code}</h1>
                        <p>验证码将在 {expire_minutes} 分钟后失效。</p>
                        <hr>
                        <p style="color: #888; font-size: 12px;">此邮件由系统自动发送，请勿回复。</p>
                    </div>
                '''
            }
        }
        
        if template_type not in templates:
            raise EmailServiceException(f"未知的邮件模板类型: {template_type}")
        
        template = templates[template_type]
        
        # 添加系统配置的网站名称
        if 'site_name' not in context:
            context['site_name'] = get_config('site_name', 'string', 'Foadmin', self.db)
        
        # 格式化主题和内容
        subject = template['subject'].format(**context)
        content = template['content'].format(**context)
        
        return self.send_email(to_email, subject, content, **kwargs)
    
    def test_connection(self) -> Dict[str, Any]:
        """
        测试SMTP连接
        
        Returns:
            包含测试结果的字典
        """
        if not self.is_configured:
            return {
                'success': False,
                'message': 'SMTP配置不完整',
                'details': {
                    'smtp_host': bool(self.smtp_host),
                    'smtp_user': bool(self.smtp_user),
                    'smtp_password': bool(self.smtp_password)
                }
            }
        
        try:
            if self.smtp_ssl:
                # 创建 SSL 上下文
                if self.smtp_ssl_verify:
                    context = ssl.create_default_context()
                else:
                    # 不验证证书（适用于 Windows 环境）
                    context = ssl.create_default_context()
                    context.check_hostname = False
                    context.verify_mode = ssl.CERT_NONE
                    
                with smtplib.SMTP_SSL(self.smtp_host, self.smtp_port, context=context, timeout=10) as server:
                    # 重要：先进行 EHLO 握手
                    server.ehlo()
                    server.login(self.smtp_user, self.smtp_password)
            else:
                with smtplib.SMTP(self.smtp_host, self.smtp_port, timeout=10) as server:
                    server.ehlo()
                    if not self.smtp_ssl_verify:
                        context = ssl.create_default_context()
                        context.check_hostname = False
                        context.verify_mode = ssl.CERT_NONE
                        server.starttls(context=context)
                    else:
                        server.starttls()
                    server.ehlo()
                    server.login(self.smtp_user, self.smtp_password)
            
            return {
                'success': True,
                'message': 'SMTP连接测试成功',
                'details': {
                    'host': self.smtp_host,
                    'port': self.smtp_port,
                    'user': self.smtp_user,
                    'ssl': self.smtp_ssl
                }
            }
            
        except smtplib.SMTPAuthenticationError:
            return {
                'success': False,
                'message': 'SMTP认证失败，用户名或密码错误',
                'details': None
            }
        except Exception as e:
            return {
                'success': False,
                'message': f'连接失败: {str(e)}',
                'details': None
            }


# 便捷函数：快速发送邮件
def send_email(
    to_email: str | List[str],
    subject: str,
    content: str,
    db: Session = None,
    **kwargs
) -> bool:
    """
    快速发送邮件的便捷函数
    
    Args:
        to_email: 收件人邮箱
        subject: 邮件主题
        content: 邮件内容
        db: 数据库会话
        **kwargs: 其他参数
        
    Returns:
        True: 发送成功
        False: 发送失败
    """
    service = EmailService(db)
    return service.send_email(to_email, subject, content, **kwargs)


# 便捷函数：发送模板邮件
def send_template_email(
    to_email: str | List[str],
    template_type: str,
    context: Dict[str, Any],
    db: Session = None,
    **kwargs
) -> bool:
    """
    使用模板发送邮件的便捷函数
    
    Args:
        to_email: 收件人邮箱
        template_type: 模板类型
        context: 模板变量
        db: 数据库会话
        **kwargs: 其他参数
        
    Returns:
        True: 发送成功
        False: 发送失败
    """
    service = EmailService(db)
    return service.send_template_email(to_email, template_type, context, **kwargs)
