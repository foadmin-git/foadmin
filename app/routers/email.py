# app/routers/email.py
# 版权所有：厦门市知序技术服务工作室
# 网站: www.sslphp.com, www.foadmin.com
# BUG反馈邮箱: 1032904660@qq.com

"""
邮件管理接口

提供邮件发送、测试连接等功能
需要管理员权限才能访问
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, field_validator
from typing import List, Optional, Dict, Any
import re

from app.core.db import get_db
from app.core.deps import require_perm, get_current_user
from app.services.email_service import EmailService, EmailServiceException

router = APIRouter(prefix="/api/admin/email", tags=["admin-email"])


# Pydantic Schemas
class EmailTestRequest(BaseModel):
    """测试邮件连接请求"""
    pass


class EmailSendRequest(BaseModel):
    """发送邮件请求"""
    to_email: str | List[str]
    subject: str
    content: str
    content_type: str = 'html'
    cc: Optional[List[str]] = None
    bcc: Optional[List[str]] = None


class EmailTemplateRequest(BaseModel):
    """模板邮件发送请求"""
    to_email: str | List[str]
    template_type: str
    context: Dict[str, Any]


class EmailTestSendRequest(BaseModel):
    """测试发送邮件请求"""
    test_email: str
    
    @field_validator('test_email')
    @classmethod
    def validate_email(cls, v):
        """验证邮箱格式"""
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        if not re.match(pattern, v):
            raise ValueError('请输入有效的邮箱地址')
        return v


# API接口
@router.post("/test-connection", dependencies=[Depends(require_perm("system:config:edit"))])
def test_smtp_connection(db: Session = Depends(get_db)):
    """
    测试SMTP连接配置
    
    权限: system:config:edit
    """
    try:
        service = EmailService(db)
        result = service.test_connection()
        return result
    except Exception as e:
        raise HTTPException(500, f"测试连接失败: {str(e)}")


@router.post("/test-send", dependencies=[Depends(require_perm("system:config:edit"))])
def test_send_email(
    body: EmailTestSendRequest,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    发送测试邮件
    
    权限: system:config:edit
    发送一封测试邮件到指定邮箱，验证邮件服务配置是否正确
    """
    try:
        service = EmailService(db)
        
        # 获取当前用户名
        username = user.get('username', '管理员')
        
        # 发送测试邮件
        success = service.send_template_email(
            to_email=body.test_email,
            template_type='notification',
            context={
                'username': username,
                'message': '这是一封测试邮件。如果您收到此邮件，说明邮件服务配置正确。'
            },
            check_rate_limit=False  # 测试邮件不检查速率限制
        )
        
        if success:
            return {
                'ok': True,
                'message': f'测试邮件已发送到 {body.test_email}'
            }
        else:
            raise HTTPException(500, "发送测试邮件失败")
            
    except EmailServiceException as e:
        raise HTTPException(400, str(e))
    except Exception as e:
        raise HTTPException(500, f"发送测试邮件失败: {str(e)}")


@router.post("/send", dependencies=[Depends(require_perm("system:email:send"))])
def send_email(
    body: EmailSendRequest,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    发送邮件
    
    权限: system:email:send
    允许管理员发送自定义邮件
    """
    try:
        service = EmailService(db)
        
        success = service.send_email(
            to_email=body.to_email,
            subject=body.subject,
            content=body.content,
            content_type=body.content_type,
            cc=body.cc,
            bcc=body.bcc
        )
        
        if success:
            return {
                'ok': True,
                'message': '邮件发送成功'
            }
        else:
            raise HTTPException(500, "邮件发送失败")
            
    except EmailServiceException as e:
        raise HTTPException(400, str(e))
    except Exception as e:
        raise HTTPException(500, f"邮件发送失败: {str(e)}")


@router.post("/send-template", dependencies=[Depends(require_perm("system:email:send"))])
def send_template_email_api(
    body: EmailTemplateRequest,
    db: Session = Depends(get_db),
    user: Any = Depends(get_current_user)
):
    """
    使用模板发送邮件
    
    权限: system:email:send
    支持的模板类型:
    - reset_password: 重置密码邮件
    - welcome: 欢迎邮件
    - notification: 通知邮件
    - verification: 验证码邮件
    """
    try:
        service = EmailService(db)
        
        success = service.send_template_email(
            to_email=body.to_email,
            template_type=body.template_type,
            context=body.context
        )
        
        if success:
            return {
                'ok': True,
                'message': '邮件发送成功'
            }
        else:
            raise HTTPException(500, "邮件发送失败")
            
    except EmailServiceException as e:
        raise HTTPException(400, str(e))
    except Exception as e:
        raise HTTPException(500, f"邮件发送失败: {str(e)}")


@router.get("/templates")
def get_email_templates():
    """
    获取可用的邮件模板列表
    
    返回所有支持的邮件模板类型和说明
    """
    templates = [
        {
            'type': 'reset_password',
            'name': '重置密码',
            'description': '用户重置密码时发送',
            'required_context': ['username', 'reset_url', 'expire_hours']
        },
        {
            'type': 'welcome',
            'name': '欢迎邮件',
            'description': '新用户注册时发送',
            'required_context': ['username', 'email', 'login_url']
        },
        {
            'type': 'notification',
            'name': '系统通知',
            'description': '发送系统通知消息',
            'required_context': ['username', 'message']
        },
        {
            'type': 'verification',
            'name': '验证码',
            'description': '发送邮箱验证码',
            'required_context': ['code', 'expire_minutes']
        }
    ]
    
    return {
        'templates': templates
    }
