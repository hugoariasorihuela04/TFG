from pydantic_settings import BaseSettings, SettingsConfigDict


class Configuracion(BaseSettings):
    """Configuración desde variables de entorno."""

    app_name: str = "Anti Deepfake System"
    api_prefix: str = "/api"
    db_url: str = "sqlite:///./audit.db"
    cors_origins: list[str] = ["*"]

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")


settings = Configuracion()
