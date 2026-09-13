from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from sqlalchemy.orm import Session

from app.core.deepface_engine import analizar_vivacidad
from app.core.image_processor import decodificar_imagen_desde_bytes
from app.db.logger import RegistroIntento, obtener_db

router = APIRouter()


@router.post("/autenticar")
async def autenticar(file: UploadFile = File(...), db: Session = Depends(obtener_db)):
    """Autentica imagen facial sin escribir en disco."""
    import logging

    logger = logging.getLogger(__name__)

    datos_bytes = await file.read()
    logger.info("/autenticar archivo recibido: filename=%s, size=%d", getattr(file, 'filename', None), len(datos_bytes) if datos_bytes is not None else 0)

    if not datos_bytes:
        # Mantener comportamiento original con log claro
        logger.warning("No se recibieron bytes de imagen en /autenticar (upload vacío)")
        raise HTTPException(status_code=400, detail="No se recibió ninguna imagen")

    try:
        imagen_rgb = decodificar_imagen_desde_bytes(datos_bytes)
        analisis = analizar_vivacidad(imagen_rgb)
    except ValueError as exc:
        msg = str(exc)
        logger.warning("Error procesando imagen: %s", msg)
        return {
            "autenticado": False,
            "detalles": {
                "confianza": 0.0,
                "mensaje": "Por favor, enfoca mejor la cara y asegúrate de que esté claramente visible."
            },
        }
    except Exception as exc:  # pragma: no cover - defensivo
        logger.exception("Error inesperado durante análisis de vivacidad")
        raise HTTPException(status_code=500, detail="Error interno en la inferencia") from exc

    log = RegistroIntento(resultado=analisis["autenticado"], confianza=analisis["confianza"])
    db.add(log)
    db.commit()

    return {
        "autenticado": analisis["autenticado"],
        "detalles": {
            "confianza": analisis["confianza"],
        },
    }