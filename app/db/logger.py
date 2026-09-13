from datetime import datetime

from sqlalchemy import Boolean, Column, DateTime, Float, Integer, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

from app.config import settings


engine = create_engine(settings.db_url, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


class AttemptLog(Base):
    """Audit table for authentication attempts (without image storage)."""

    __tablename__ = "attempt_logs"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, default=datetime.utcnow, nullable=False)
    result = Column(Boolean, nullable=False)
    confidence = Column(Float, nullable=False, default=0.0)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
