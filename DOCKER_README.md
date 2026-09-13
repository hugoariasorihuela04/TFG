# Docker Setup - PROTOTIPO-TFG

## Introducción

Esta guía simplifica el arranque del proyecto usando Docker y Docker Compose. No necesitas instalar Python, dependencias ni configurar certificados SSL manualmente.

## Requisitos

- **Docker Desktop** instalado ([Descargar aquí](https://www.docker.com/products/docker-desktop))
- **Docker Compose** (incluido en Docker Desktop)
- Puertos 8000 y 8443 disponibles en tu PC

## Inicio rápido

### 1. Construir y arrancar los contenedores

```powershell
cd C:\ruta\a\PROTOTIPO-TFG
docker-compose up --build
```

Esto:
- Descarga las imágenes base (Python, Nginx)
- Instala todas las dependencias de `requirements.txt`
- Genera los certificados HTTPS automáticamente
- Inicia el backend (puerto 8000) y el frontend (puerto 8443)

### 2. Acceder a la aplicación

Una vez que veas `anti-deepfake-backend` healthy:

**En tu PC:**
- Frontend: `https://localhost:8443`
- Backend Docs: `http://localhost:8000/docs`

**Desde otros dispositivos (misma red):**
- Frontend: `https://[TU_IP]:8443`
- Backend Docs: `http://[TU_IP]:8000/docs`

> Para obtener tu IP: `ipconfig` (busca IPv4 bajo tu adaptador de red)

### 3. Detener los contenedores

```powershell
docker-compose down
```

Esto detiene ambos servicios y libera los puertos.

## Características

✅ **Plug and Play**: Solo ejecuta `docker-compose up` y funciona  
✅ **Sincronización de volúmenes**: Los cambios en `frontend/app.js` se reflejan automáticamente  
✅ **Configuración automática**: Los certificados HTTPS se generan en la primera ejecución  
✅ **Health checks**: El frontend espera a que el backend esté listo  
✅ **Red integrada**: Backend y frontend se comunican sin problemas  
✅ **Base de datos persistente**: `audit.db` se guarda en tu PC  

## Estructura de servicios

| Servicio | Puerto | Descripción |
|----------|--------|-------------|
| Backend | 8000 | API FastAPI con análisis de deepfake |
| Frontend | 8443 | Interfaz HTTPS con Nginx |

## Comandos útiles

```powershell
# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f backend

# Reiniciar un servicio
docker-compose restart backend

# Eliminar volúmenes (elimina audit.db)
docker-compose down -v

# Reconstruir sin usar caché
docker-compose build --no-cache
```

## Solución de problemas

### "Cannot connect to Docker daemon"
→ Abre **Docker Desktop** antes de ejecutar docker-compose

### "Port 8000/8443 already in use"
```powershell
# Encontrar qué proceso usa el puerto
netstat -ano | findstr :8000

# Matar el proceso (reemplaza PID)
taskkill /PID <PID> /F
```

### Frontend muestra "Cannot GET /"
→ Espera a que el backend esté **healthy** (tarda 30-60s en la primera ejecución)

### Base de datos no persiste
→ Asegúrate de que `audit.db` existe en la carpeta raíz del proyecto

## Configuración avanzada

### Cambiar puertos

Edita `docker-compose.yml`:

```yaml
backend:
  ports:
    - "9000:8000"  # Accede en http://localhost:9000

frontend:
  ports:
    - "9443:8443"  # Accede en https://localhost:9443
```

### Variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
CORS_ORIGINS=*
DATABASE_URL=sqlite:///./audit.db
```

## Comparativa: Manual vs Docker

| Tarea | Manual (README.md) | Docker |
|-------|-------------------|--------|
| Instalar Python 3.10 | ✓ Manual | ✗ Automático |
| Crear venv | ✓ Manual | ✗ Automático |
| Instalar deps | ✓ Manual | ✗ Automático |
| Generar certificados | ✓ Manual + mkcert | ✗ Automático |
| Abrir puertos firewall | ✓ Manual (PowerShell admin) | ✗ No necesario |
| Arrancar 2 terminales | ✓ Sí | ✗ Un comando |
| Tiempo total setup | ~30 minutos | ~3 minutos (1era vez) |

---

## Desarrollo

Para hacer cambios en el código mientras Docker está corriendo:

### Backend (Python)
Los cambios en `app/` se recargan automáticamente si quitas `reload: True` en `app/main.py` y usas un volumen con `reload=False`. Para desarrollo rápido, edita y reinicia:

```powershell
docker-compose restart backend
```

### Frontend (JavaScript)
Los cambios en `frontend/app.js` se reflejan automáticamente en el navegador. Solo recarga la página.

---

¡Disfruta! 🚀
