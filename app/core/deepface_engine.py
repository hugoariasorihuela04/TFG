from deepface import DeepFace
SPOOF_MIN_SCORE = 0.99

def _to_jsonable(value):
    if isinstance(value, dict):
        return {str(k): _to_jsonable(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return [_to_jsonable(v) for v in value]
    if isinstance(value, (str, int, float, bool)) or value is None:
        return value
    return str(value)


def analyze_liveness(image_rgb):
    """Runs DeepFace anti-spoofing inference and normalizes the output."""
    result = DeepFace.extract_faces(img_path=image_rgb, detector_backend="opencv", anti_spoofing=True)

    if not result:
        raise ValueError("No se detectó ninguna cara")

    face = result[0]

    # Different deepface versions may expose different liveness keys.
    is_real = face.get("is_real")
    if is_real is None:
        spoof_flag = face.get("spoof")
        if spoof_flag is not None:
            is_real = not bool(spoof_flag)

    if is_real is None:
        raise ValueError("No se pudo determinar la vivacidad del rostro")

    confidence = (
        face.get("antispoof_score")
        or face.get("anti_spoofing_score")
        or face.get("confidence")
        or face.get("face_confidence")
        or 0.0
    )

    return {
        "autenticado": bool(is_real) and float(confidence) >= SPOOF_MIN_SCORE,
        "confianza": float(confidence),
        "raw": _to_jsonable(face),
    }
