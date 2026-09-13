## COMO INICIAR EN DOCKER
### Paso 1: Clonar el repositorio y entrar en la carpeta del proyecto
```bash
git clone https://github.com/hugoariasorihuela04/TFG.git
cd TFG
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

#3. Elimina los contenedores existentes para que se creen de nuevo
docker rm -f anti-deepfake-frontend anti-deepfake-backend

# 3. Vuelve a lanzar el script de inicio
./start.ps1
```

Cuando te aparezca en consola:
```bash
anti-deepfake-frontend  | 2026/09/13 21:37:59 [notice] 1#1: start worker process 31     
anti-deepfake-frontend  | 2026/09/13 21:37:59 [notice] 1#1: start worker process 32     
anti-deepfake-backend   | INFO:     127.0.0.1:47072 - "GET /docs HTTP/1.1" 200 OK       
anti-deepfake-backend   | INFO:     127.0.0.1:34782 - "GET /docs HTTP/1.1" 200 OK
anti-deepfake-backend   | INFO:     127.0.0.1:38132 - "GET /docs HTTP/1.1" 200 OK
anti-deepfake-backend   | INFO:     127.0.0.1:60386 - "GET /docs HTTP/1.1" 200 OK
```
Puedes pasar al paso 3

### Paso 3: Acceder a la aplicación
- Frontend: https://localhost:8443
- Backend: http://localhost:8000/docs

-----

## MODIFICAR CUAN ESTRICTO ES EL MODELO DE LENGUAJE
Para modificar la estricticidad del modelo de lenguaje, puedes cambiar el valor de la variable MIN_PUNTAJE_ANTI_SPOOF en el archivo `app/core/deepface_engine.py`.

### COMO ACCEDER DESDE TU TELEFONO
Para acceder a la aplicación desde tu teléfono, primero asegúrate de que tu teléfono y tu ordenador estén conectados a la misma red Wi-Fi. Luego, sigue estos pasos:
1. Encuentra la dirección IP de tu ordenador. Puedes hacerlo ejecutando el siguiente comando en la terminal:
   - **Windows:** `ipconfig`
     - **Linux/Mac:** `ifconfig` o `ip addr show`
     Busca la dirección IPv4 de tu adaptador de red (por ejemplo, `192.168.1.127).
     - **Linux/Mac:** `ifconfig` o `ip addr show`
2. Abre un navegador web en tu teléfono y escribe la dirección IP de tu ordenador seguida del puerto correspondiente. Por ejemplo, si la dirección IP de tu ordenador es `192.168.1.127`, escribe `https://192.168.1.127:8443` en el navegador.
3. Si todo está configurado correctamente, deberías poder acceder a la aplicación desde tu teléfono.

Es normal que te ponga a la hora de accerder que el sitio no es fiable, ya que el certificado SSL es autofirmado. Puedes ignorar la advertencia y continuar al sitio.

4. Si tienes problemas para acceder a la aplicación desde tu teléfono, asegúrate de que no haya ningún firewall o configuración de red que esté bloqueando el acceso.
5. Para quitar los problemas de firewall en Windows, puedes ejecutar el siguiente comando en PowerShell como administrador:
```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

