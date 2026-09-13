# 🏗️ Arquitectura - Anti-Deepfake System en Docker

## Overview

La aplicación está dockerizada en 2 contenedores independientes que se comunican a través de una red Docker:

```
┌─────────────────────────────────────────────────┐
│         Docker Compose Network                   │
├─────────────────────────────────────────────────┤
│                                                   │
│  ┌──────────────────┐      ┌──────────────────┐ │
│  │    Frontend      │      │    Backend       │ │
│  │   (Nginx)        │      │  (FastAPI)       │ │
│  │   :8443 HTTPS    │◄────►│   :8000 HTTP    │ │
│  │                  │      │   SQLite DB      │ │
│  └──────────────────┘      └──────────────────┘ │
│         │                          │             │
│         │                          │             │
│    (HTTPS)                    (Health Check)     │
│                                                   │
└─────────────────────────────────────────────────┘
         │                         │
         ▼                         ▼
    Usuario/Browser          API Endpoints
  https://localhost:8443    http://localhost:8000
```

## 📦 Servicios

### 1. Backend (Python + FastAPI)
- **Imagen Base**: `python:3.10-slim`
- **Puerto**: 8000
- **Función**: 
  - Procesa imágenes enviadas desde el frontend
  - Ejecuta análisis de deepfake con DeepFace
  - Almacena logs de intentos en SQLite
  - Expone API REST en `/api/autenticar`
- **Volúmenes**:
  - `./app` → código Python (para desarrollo)
  - `./audit.db` → base de datos persistente
- **Health Check**: Verifica que `/docs` esté disponible

### 2. Frontend (Nginx + HTML/JS)
- **Imagen Base**: `nginx:alpine`
- **Puerto**: 8443 (HTTPS)
- **Función**:
  - Interfaz web moderna y responsiva
  - Acceso a cámara del dispositivo
  - Envía imágenes al backend para análisis
- **Certificados**:
  - Auto-generados en tiempo de ejecución con OpenSSL
  - Autofirmados (válidos por 365 días)
  - Se crean en `/app/localhost+2.pem` y `/app/localhost+2-key.pem`

## 🔄 Flujo de Comunicación

```
1. Usuario abre https://localhost:8443
2. Nginx sirve index.html + app.js
3. app.js detecta IP automáticamente:
   API_BASE = "http://<mismo_host>:8000"
4. Usuario toma foto desde cámara
5. Front-end envía blob al backend:
   POST http://localhost:8000/api/autenticar
6. Backend procesa con DeepFace
7. Backend responde con análisis
8. Front-end muestra resultado
9. Backend almacena log en audit.db
```

## 🛠️ Configuración Automática

### Certificados HTTPS
El script `entrypoint.sh` se ejecuta en el contenedor del frontend:
1. Verifica si existen certificados
2. Si no existen, genera nuevos con OpenSSL
3. Inicia Nginx con los certificados

```bash
# Generación automática
openssl genrsa -out localhost+2-key.pem 2048
openssl req -new -x509 -key localhost+2-key.pem -out localhost+2.pem \
  -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=TFG/CN=localhost"
```

### Detección de IP
El frontend detecta automáticamente la IP desde donde se sirve:
```javascript
const API_BASE = `http://${window.location.hostname}:8000`;
```

Esto funciona tanto en:
- `localhost` → `http://localhost:8000`
- `192.168.1.100` → `http://192.168.1.100:8000`
- Cualquier hostname → se detecta automáticamente

## 📁 Estructura de Archivos

```
PROTOTIPO-TFG/
├── Dockerfile                 # Backend (Python 3.10)
├── Dockerfile.frontend        # Frontend (Nginx Alpine)
├── docker-compose.yml         # Orquestación
├── entrypoint.sh             # Init script para frontend
├── .dockerignore             # Optimización de build
├── .env.example              # Variables de entorno
│
├── app/                       # Backend
│   ├── main.py              # FastAPI app
│   ├── config.py            # Configuración
│   ├── api/
│   │   └── routes.py        # Endpoints
│   ├── core/
│   │   ├── deepface_engine.py
│   │   └── image_processor.py
│   └── db/
│       └── logger.py        # Base de datos
│
├── frontend/                  # Frontend
│   ├── index.html           # UI (mejorada con CSS)
│   ├── app.js               # Lógica (auto-detección de IP)
│   ├── localhost+2.pem      # Certificado (auto-generado)
│   └── localhost+2-key.pem  # Clave privada (auto-generada)
│
├── requirements.txt          # Dependencias Python
├── audit.db                 # SQLite (persistente)
│
├── QUICKSTART.md            # Guía rápida ⭐
├── DOCKER_README.md         # Guía completa
└── README.md                # Setup original (sin Docker)
```

## 🔒 Seguridad

### Volúmenes
- `audit.db` es persistente en el host
- Cambios en `app/` se reflejan en contenedor (desarrollo)
- Certificados HTTPS se generan automáticamente

### CORS
- Configurado en backend para acepar `*` (desarrollo)
- Modificable en `docker-compose.yml` o `.env`

### Base de Datos
- SQLite en `/app/audit.db`
- Tabla `attempt_logs` almacena:
  - Timestamp
  - Resultado (True/False)
  - Confianza del análisis

## 🚀 Mejoras respecto a Setup Manual

| Aspecto | Manual | Docker |
|---|---|---|
| Python 3.10 | ✓ Manual | ✗ Automático |
| Dependencias | ✓ Manual | ✗ Automático |
| Certificados SSL | ✓ Manual (mkcert) | ✗ Automático (OpenSSL) |
| Detección de IP | ✓ Manual en app.js | ✗ Automática |
| Firewall Windows | ✓ Manual (PowerShell admin) | ✗ No necesario |
| 2 terminales | ✓ Sí | ✗ Un comando |
| **Tiempo setup** | ~30 min | ~3 min (1era vez) |
| **Reproducibilidad** | ⚠️ Depende de sistema | ✅ Idéntico en todas partes |

## 📊 Performance

- **Imagen Backend**: ~800-900 MB (Python + DeepFace + TensorFlow)
- **Imagen Frontend**: ~20 MB (Nginx Alpine)
- **Tiempo build 1ª vez**: 5-10 minutos
- **Tiempo startup**: 30-60 segundos (DeepFace descarga modelos)
- **RAM requerida**: ~1.5-2 GB mínimo

## 🔧 Desarrollo

### Cambios en Backend
Los cambios en `app/` se reflejan automáticamente gracias al volumen.
Para recargar:
```bash
docker-compose restart backend
```

### Cambios en Frontend
Los cambios en `frontend/` se reflejan automáticamente en el navegador.
Solo recarga la página (F5).

## 📝 Logs

```bash
# Todos los logs
docker-compose logs -f

# Solo backend
docker-compose logs -f backend

# Solo frontend
docker-compose logs -f frontend
```

## 🧹 Limpieza

```bash
# Detener contenedores
docker-compose down

# Eliminar volúmenes (incluye audit.db)
docker-compose down -v

# Eliminar imágenes
docker rmi anti-deepfake-backend:latest anti-deepfake-frontend:latest

# Limpieza completa
docker-compose down -v --rmi all
```

---

¡Arquitectura simple, escalable y reproducible! 🎯
