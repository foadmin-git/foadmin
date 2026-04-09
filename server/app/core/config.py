# app/core/config.py
from pathlib import Path
from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import field_validator
import secrets
import string

ROOT_DIR = Path(__file__).resolve().parents[2] 
ENV_FILE = ROOT_DIR / ".env"

class Settings(BaseSettings):
    MYSQL_DSN: str
    JWT_SECRET: str = ""  # 默认为空，将在 validator 中生成随机值
    JWT_ALGO: str = "HS256"
    # 缩短访问令牌过期时间，默认为 60 分钟，可通过环境变量覆盖
    ACCESS_EXPIRE_MINUTES: int = 60
    CORS_ORIGINS: List[str] = ["http://localhost:5173", "http://127.0.0.1:5173"]

    # v2 正确写法
    model_config = SettingsConfigDict(
        env_file=str(ENV_FILE),         
        env_file_encoding="utf-8",
        extra="ignore",                 
    )

    # 为 JWT_SECRET 生成随机值
    @field_validator("JWT_SECRET", mode="before")
    @classmethod
    def _generate_jwt_secret(cls, v):
        # 如果没有提供值或者值为空，则生成随机密钥
        if not v:
            alphabet = string.ascii_letters + string.digits
            return ''.join(secrets.choice(alphabet) for _ in range(32))
        return v

    # 允许 .env 用逗号分隔或 JSON 数组两种写法
    @field_validator("CORS_ORIGINS", mode="before")
    @classmethod
    def _normalize_cors(cls, v):
        if isinstance(v, str):
            s = v.strip()
            # 如果是 JSON 数组，交给 pydantic 解析
            if s.startswith("[") and s.endswith("]"):
                return v
            # 否则按逗号切
            return [item.strip() for item in s.split(",") if item.strip()]
        return v

settings = Settings()