import cv2
import numpy as np


def decode_image_from_bytes(bytes_data: bytes) -> np.ndarray:
    """Decodes image bytes from RAM into an RGB NumPy matrix in RAM."""
    np_bytes = np.frombuffer(bytes_data, np.uint8)
    bgr_image = cv2.imdecode(np_bytes, cv2.IMREAD_COLOR)

    if bgr_image is None:
        raise ValueError("No se pudo decodificar la imagen")

    return cv2.cvtColor(bgr_image, cv2.COLOR_BGR2RGB)
