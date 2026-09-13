from deepface import DeepFace
MIN_PUNTAJE_ANTI_SPOOF = 0.99

def _a_json(value):
    if isinstance(value, dict):
        return {str(k): _a_json(v) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return [_a_json(v) for v in value]
    if isinstance(value, (str, int, float, bool)) or value is None:
        return value
    return str(value)


def analizar_vivacidad(imagen_rgb):
    """Analiza vivacidad y normaliza la salida."""
    result = DeepFace.extract_faces(img_path=imagen_rgb, detector_backend="opencv", anti_spoofing=True)

    if not result:
        raise ValueError("No se detectó ninguna cara")

    face = result[0]

    # Distintas versiones de deepface usan claves distintas.
    is_real = face.get("is_real")
    if is_real is None:
        spoof_flag = face.get("spoof")
        if spoof_flag is not None:
            is_real = not bool(spoof_flag)

    if is_real is None:
        raise ValueError("No se pudo determinar la vivacidad del rostro")

    confianza = (
        face.get("antispoof_score")
        or face.get("anti_spoofing_score")
        or face.get("confidence")
        or face.get("face_confidence")
        or 0.0
    )

    return {
        "autenticado": bool(is_real) and float(confianza) >= MIN_PUNTAJE_ANTI_SPOOF,
        "confianza": float(confianza),
        "raw": _a_json(face),
    }
