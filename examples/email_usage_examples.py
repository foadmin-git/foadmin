# 邮件服务使用示例
# 本文件展示如何在系统的各个模块中使用邮件服务

from app.services.email_service import EmailService, send_email, send_template_email, EmailServiceException
from sqlalchemy.orm import Session
from datetime import datetime


# ============================================
# 示例1：发送简单的文本邮件
# ============================================
def example_send_simple_email(db: Session):
    """发送简单的文本邮件"""
    try:
        success = send_email(
            to_email="user@example.com",
            subject="系统通知",
            content="这是一封测试邮件",
            content_type="plain",
            db=db
        )
        if success:
            print("邮件发送成功")
    except EmailServiceException as e:
        print(f"邮件发送失败: {e}")


# ============================================
# 示例2：发送HTML格式邮件
# ============================================
def example_send_html_email(db: Session):
    """发送HTML格式邮件"""
    html_content = """
    <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; }
                .header { background-color: #4CAF50; color: white; padding: 20px; }
                .content { padding: 20px; }
            </style>
        </head>
        <body>
            <div class="header">
                <h1>欢迎使用Foadmin</h1>
            </div>
            <div class="content">
                <p>这是一封HTML格式的邮件</p>
                <a href="https://www.foadmin.com">访问官网</a>
            </div>
        </body>
    </html>
    """
    
    send_email(
        to_email="user@example.com",
        subject="HTML邮件示例",
        content=html_content,
        content_type="html",
        db=db
    )


# ============================================
# 示例3：发送带抄送和密送的邮件
# ============================================
def example_send_with_cc_bcc(db: Session):
    """发送带抄送和密送的邮件"""
    service = EmailService(db)
    
    service.send_email(
        to_email=["user1@example.com", "user2@example.com"],
        subject="项目更新通知",
        content="<h1>项目已更新</h1><p>请查看最新版本。</p>",
        cc=["manager@example.com"],  # 抄送给经理
        bcc=["admin@example.com"],   # 密送给管理员
        content_type="html"
    )


# ============================================
# 示例4：发送带附件的邮件
# ============================================
def example_send_with_attachments(db: Session):
    """发送带附件的邮件"""
    service = EmailService(db)
    
    service.send_email(
        to_email="user@example.com",
        subject="月度报告",
        content="<p>请查收附件中的月度报告</p>",
        attachments=[
            "/path/to/report.pdf",
            "/path/to/data.xlsx"
        ]
    )


# ============================================
# 示例5：使用重置密码模板
# ============================================
def example_send_reset_password_email(user_email: str, username: str, reset_token: str, db: Session):
    """发送重置密码邮件"""
    reset_url = f"https://yourdomain.com/reset-password?token={reset_token}"
    
    send_template_email(
        to_email=user_email,
        template_type="reset_password",
        context={
            'username': username,
            'reset_url': reset_url,
            'expire_hours': 24
        },
        db=db
    )


# ============================================
# 示例6：使用欢迎邮件模板
# ============================================
def example_send_welcome_email(user_email: str, username: str, db: Session):
    """新用户注册后发送欢迎邮件"""
    send_template_email(
        to_email=user_email,
        template_type="welcome",
        context={
            'username': username,
            'email': user_email,
            'login_url': 'https://yourdomain.com/login'
        },
        db=db
    )


# ============================================
# 示例7：发送验证码邮件
# ============================================
def example_send_verification_code(user_email: str, code: str, db: Session):
    """发送邮箱验证码"""
    send_template_email(
        to_email=user_email,
        template_type="verification",
        context={
            'code': code,
            'expire_minutes': 10
        },
        db=db
    )


# ============================================
# 示例8：发送系统通知邮件
# ============================================
def example_send_notification(user_email: str, username: str, message: str, db: Session):
    """发送系统通知"""
    send_template_email(
        to_email=user_email,
        template_type="notification",
        context={
            'username': username,
            'message': message
        },
        db=db
    )


# ============================================
# 示例9：批量发送邮件（带错误处理）
# ============================================
def example_send_bulk_emails(users: list, db: Session):
    """批量发送邮件给多个用户"""
    service = EmailService(db)
    
    success_count = 0
    failed_count = 0
    
    for user in users:
        try:
            service.send_template_email(
                to_email=user['email'],
                template_type="notification",
                context={
                    'username': user['username'],
                    'message': '这是一条重要通知'
                },
                check_rate_limit=False  # 批量发送时可能需要跳过速率限制
            )
            success_count += 1
        except EmailServiceException as e:
            print(f"发送给 {user['email']} 失败: {e}")
            failed_count += 1
    
    print(f"批量发送完成：成功 {success_count} 封，失败 {failed_count} 封")


# ============================================
# 示例10：异步发送邮件（不阻塞主流程）
# ============================================
def example_async_send_email(user_email: str, db: Session):
    """异步发送邮件，不影响主业务流程"""
    import threading
    
    def send_in_background():
        try:
            send_template_email(
                to_email=user_email,
                template_type="welcome",
                context={
                    'username': '新用户',
                    'email': user_email,
                    'login_url': 'https://yourdomain.com/login'
                },
                db=db
            )
            print("后台邮件发送成功")
        except Exception as e:
            print(f"后台邮件发送失败: {e}")
    
    # 在后台线程中发送邮件
    thread = threading.Thread(target=send_in_background)
    thread.daemon = True
    thread.start()
    
    # 主流程继续执行
    print("主流程继续...")


# ============================================
# 示例11：测试SMTP连接
# ============================================
def example_test_smtp_connection(db: Session):
    """测试SMTP服务器连接"""
    service = EmailService(db)
    result = service.test_connection()
    
    if result['success']:
        print("SMTP连接测试成功")
        print(f"服务器: {result['details']['host']}")
        print(f"端口: {result['details']['port']}")
    else:
        print(f"SMTP连接测试失败: {result['message']}")


# ============================================
# 示例12：自定义速率限制
# ============================================
def example_custom_rate_limit(db: Session):
    """自定义邮件发送速率限制"""
    service = EmailService(db)
    
    # 检查是否可以发送（自定义限制：5分钟内最多3封）
    can_send = service.check_rate_limit(
        recipient="user@example.com",
        max_count=3,
        window_seconds=300  # 5分钟
    )
    
    if can_send:
        service.send_email(
            to_email="user@example.com",
            subject="测试",
            content="测试内容"
        )
    else:
        print("发送过于频繁，请稍后再试")


# ============================================
# 示例13：在用户注册流程中集成邮件发送
# ============================================
def example_user_registration_with_email(username: str, email: str, password: str, db: Session):
    """用户注册流程中发送欢迎邮件"""
    from app.models.user import User
    from app.core.security import hash_password
    
    # 1. 创建用户
    user = User(
        username=username,
        password_hash=hash_password(password)
    )
    db.add(user)
    db.commit()
    
    # 2. 发送欢迎邮件（即使失败也不影响注册）
    try:
        send_template_email(
            to_email=email,
            template_type="welcome",
            context={
                'username': username,
                'email': email,
                'login_url': 'https://yourdomain.com/login'
            },
            db=db
        )
        print("欢迎邮件已发送")
    except Exception as e:
        # 记录错误但不影响注册流程
        print(f"发送欢迎邮件失败（不影响注册）: {e}")
    
    return user


# ============================================
# 示例14：密码重置完整流程
# ============================================
def example_password_reset_flow(email: str, db: Session):
    """密码重置完整流程"""
    from app.models.user import User
    import secrets
    from datetime import datetime, timedelta
    
    # 1. 查找用户
    user = db.query(User).filter(User.email == email).first()
    if not user:
        return {"error": "用户不存在"}
    
    # 2. 生成重置令牌（实际应用中应保存到数据库）
    reset_token = secrets.token_urlsafe(32)
    reset_url = f"https://yourdomain.com/reset-password?token={reset_token}"
    
    # 3. 发送重置密码邮件
    try:
        send_template_email(
            to_email=email,
            template_type="reset_password",
            context={
                'username': user.username,
                'reset_url': reset_url,
                'expire_hours': 24
            },
            db=db
        )
        return {"ok": True, "message": "重置链接已发送到您的邮箱"}
    except EmailServiceException as e:
        return {"error": f"发送邮件失败: {str(e)}"}


# ============================================
# 示例15：安全警告通知
# ============================================
def example_security_alert(user_id: int, ip_address: str, location: str, db: Session):
    """发送安全警告邮件"""
    from app.models.user import User
    
    user = db.get(User, user_id)
    if not user:
        return
    
    message = f"""
    检测到您的账号于 {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} 在异地登录：
    
    IP地址: {ip_address}
    登录地点: {location}
    
    如果这不是您本人的操作，请立即修改密码并联系管理员。
    """
    
    send_template_email(
        to_email=user.email,
        template_type="notification",
        context={
            'username': user.username,
            'message': message
        },
        db=db,
        check_rate_limit=False  # 安全警告不受速率限制
    )
