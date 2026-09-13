from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy.orm import Session

from app.core.deepface_engine import analyze_liveness
from app.core.image_processor import decode_image_from_bytes
from app.db.logger import AttemptLog, get_db

router = APIRouter()


@router.post("/autenticar")
async def autenticar(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """Authenticates a face image without writing files to disk."""
    bytes_data = await file.read()
    if not bytes_data:
        raise HTTPException(status_code=400, detail="No se recibió ninguna imagen")

    try:
        image_rgb = decode_image_from_bytes(bytes_data)
        analysis = analyze_liveness(image_rgb)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:  # pragma: no cover - defensive
        raise HTTPException(status_code=500, detail="Error interno en la inferencia") from exc

    log = AttemptLog(result=analysis["autenticado"], confidence=analysis["confianza"])
    db.add(log)
    db.commit()

    return {
        "autenticado": analysis["autenticado"],
        "detalles": {
            "confianza": analysis["confianza"],
        },
    }