from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy.orm import Session

from app.core.deepface_engine import analyze_liveness
from app.core.image_processor import decode_image_from_bytes
from app.db.logger import AttemptLog, get_db

router = APIRouter()


@router.post("/autenticar")
async def autenticar(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """Authenticates a face image without writing files to disk.

    Adds lightweight logging of the received payload size and any decoding
    errors to help diagnose empty/invalid uploads (returns the same HTTP
    errors as before).
    """
    import logging

    logger = logging.getLogger(__name__)

    bytes_data = await file.read()
    logger.info("/autenticar received file: filename=%s, size=%d", getattr(file, 'filename', None), len(bytes_data) if bytes_data is not None else 0)

    if not bytes_data:
        # Keep original behavior but provide a clearer log entry
        logger.warning("No image bytes received in /autenticar request (empty upload)")
        raise HTTPException(status_code=400, detail="No se recibió ninguna imagen")

    try:
        image_rgb = decode_image_from_bytes(bytes_data)
        analysis = analyze_liveness(image_rgb)
    except ValueError as exc:
        msg = str(exc)
        logger.warning("Image processing error: %s", msg)
        # For any image decoding/liveness ValueError, return a friendly response so the frontend
        # can prompt the user to retry instead of receiving an HTTP 400 error.
        return {
            "autenticado": False,
            "detalles": {
                "confianza": 0.0,
                "mensaje": "Por favor, enfoca mejor la cara y asegúrate de que esté claramente visible."
            },
        }
    except Exception as exc:  # pragma: no cover - defensive
        logger.exception("Unexpected error during liveness analysis")
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