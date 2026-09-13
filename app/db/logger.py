from datetime import datetime

from sqlalchemy import Boolean, Column, DateTime, Float, Integer, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.config import settings


engine = create_engine(settings.db_url, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


class RegistroIntento(Base):
    """Registro de intentos de autenticación."""

    __tablename__ = "attempt_logs"

    id = Column(Integer, primary_key=True, index=True)
    fecha = Column('timestamp', DateTime, default=datetime.utcnow, nullable=False)
    resultado = Column('result', Boolean, nullable=False)
    confianza = Column('confidence', Float, nullable=False, default=0.0)


def obtener_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
