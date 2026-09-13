# README

## COMO INICIAR EN DOCKER
### Paso 1: Clonar el repositorio y entrar en la carpeta del proyecto
```bash
git clone https://github.com/hugoariasorihuela04/TFG.git
cd TFG\PROTOTIPO-TFG
```

### Paso 2: Ejecutar el script de inicio en docker
**Windows:**
```powershell
.\start.ps1
``` 

**Linux/Mac:**
```bash
chmod +x start.sh
./start.sh
``` 

Si tienes fallo al ejecutar el script, puedes:


O habilitar la ejecución de scripts en PowerShell con el siguiente comando:
```powershell
powershell -ExecutionPolicy Bypass -File start.ps1 -NoExit
```

O directamente ejecutar el comando de docker-compose:
```bash
# 1. Apaga lo que se haya quedado a medias
docker compose down

# 2. Reconstruye las imágenes ignorando la caché para que instalen las dependencias correctamente
docker compose build --no-cache

# 3. Vuelve a lanzar el script de inicio
./start.ps1
```


### Paso 3: Acceder a la aplicación
- Frontend: https://localhost:8443
- Backend: http://localhost:8000/docs

---
---

# MODIFICAR CUAN ESTRICTO ES EL MODELO DE LENGUAJE
Para modificar la estricticidad del modelo de lenguaje, puedes cambiar el valor de la variable SPOOF_MIN_SCORE en el archivo `app/core/deepface_engine.py`.