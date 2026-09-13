import cv2
import numpy as np


def decodificar_imagen_desde_bytes(datos_bytes: bytes) -> np.ndarray:
    """Decodifica bytes a imagen RGB (NumPy)."""
    np_bytes = np.frombuffer(datos_bytes, np.uint8)
    bgr_image = cv2.imdecode(np_bytes, cv2.IMREAD_COLOR)

    if bgr_image is None:
        raise ValueError("No se pudo decodificar la imagen")

    return cv2.cvtColor(bgr_image, cv2.COLOR_BGR2RGB)
