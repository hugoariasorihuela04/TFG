# 🚀 Quick Start - Anti-Deepfake System

> ⚡ **Ultra-rápido**: 3 comandos, listo para usar

## 1️⃣ Requisitos
- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado

## 2️⃣ Ejecutar

### Windows (PowerShell)
```powershell
.\start.ps1
```

### Linux/Mac (Bash)
```bash
chmod +x start.sh
./start.sh
```

### O directamente con Docker Compose
```bash
docker-compose up --build
```

## 3️⃣ Acceder

| Dispositivo | URL |
|---|---|
| **Este PC** | https://localhost:8443 |
| **Otro dispositivo (red)** | https://[TU_IP]:8443 |

## Detener
```
Presiona Ctrl+C
```

---

## ¿Más información?

- 📖 [Guía Completa de Docker](./DOCKER_README.md)
- 📚 [Setup Original (sin Docker)](./README.md)
- 🔧 [Comandos útiles con Makefile](./Makefile)

---

## ¿Problemas?

1. **Docker no abre**
   - Descarga [Docker Desktop](https://www.docker.com/products/docker-desktop)

2. **Puertos ocupados**
   ```powershell
   netstat -ano | findstr :8000
   taskkill /PID <PID> /F
   ```

3. **Certificados HTTPS no válidos**
   - Es normal en la primera ejecución (autofirmados)
   - Acepta el riesgo en el navegador

---

¡Disfruta! 🎉
