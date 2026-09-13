# 📱 Conexión desde Móvil - Guía Completa

## ✅ Requisitos Previos

1. **PC y móvil en la MISMA RED WiFi**
   - No funcionará si el móvil está en "Red de invitados"
   - Ambos deben estar en el mismo router

2. **Docker corriendo en el PC**
   ```powershell
   .\start.ps1  # Windows
   # o
   ./start.sh   # Linux/Mac
   ```

3. **Ambos dispositivos conectados a la red**

---

## 🚀 Pasos para Conectar desde Móvil

### 1️⃣ Obtén la IP de tu PC

**Windows (PowerShell):**
```powershell
ipconfig
```

**Linux/Mac (Terminal):**
```bash
hostname -I
# o
ifconfig
```

Busca la dirección **IPv4** (no loopback). Ejemplo: `192.168.1.100`

### 2️⃣ En el móvil, abre el navegador

- Chrome
- Firefox
- Safari
- Edge
- Cualquier navegador

### 3️⃣ Escribe en la barra de direcciones

```
https://192.168.1.100:8443
```

**Reemplaza `192.168.1.100` con TU IP real**

### 4️⃣ Acepta el certificado de seguridad

Verás una advertencia "Este sitio no es seguro":

- **Android**: Toca "Continuar" o "Aceptar riesgo"
- **iOS**: Toca "Continuar de todas formas"
- **Otros**: Busca opción de continuar/aceptar

### 5️⃣ ¡Usa la aplicación!

- Dale permiso de cámara si lo solicita
- Captura tu cara
- ¡Prueba el sistema anti-deepfake!

---

## ⚠️ Problemas Comunes

### 1. "Este sitio no es seguro" (Certificado SSL)

**¿Qué es?**
- Advertencia normal para certificados autofirmados

**Solución:**
- Acepta el riesgo/continúa de todas formas
- Es seguro para desarrollo local

---

### 2. "Permiso de cámara denegado"

**Android:**
```
Ajustes → Aplicaciones → [Tu Navegador] → Permisos → Cámara → Habilitar
```

**iOS:**
```
Ajustes → Privacidad → Cámara → Habilita el navegador
```

---

### 3. "No se puede conectar" / "Connection refused"

**Causas posibles:**
- Móvil y PC en redes diferentes
- Docker no está corriendo en el PC
- Firewall bloqueando

**Soluciones:**
```bash
# En el PC, verifica que Docker corre:
docker-compose ps

# Verifica conectividad desde móvil:
# Abre: http://192.168.1.100:8000/docs
# (sin HTTPS, solo para verificar conectividad)

# Si no funciona, comprueba:
# 1. ¿Same WiFi network?
# 2. ¿Docker running? (docker-compose ps)
# 3. ¿Firewall bloqueando? (desactiva temporalmente)
```

---

### 4. "Página en blanco" / "Cannot GET /"

**Causa:**
- Frontend aún no está listo (tarda 30-60s primera vez)

**Solución:**
- Espera 1-2 minutos
- Recarga la página (⟳ en móvil)
- Verifica logs: `docker-compose logs frontend`

---

### 5. "Cámara no aparece pero la página carga"

**Causas posibles:**
- Navegador no tiene permiso
- JavaScript no cargó correctamente

**Soluciones:**
```
1. Recarga la página (⟳)
2. Espera 5 segundos
3. Verifica permisos de cámara
4. Prueba en otro navegador
```

---

### 6. "No puedo acceder pero PC sí"

**Probable causa:**
- Router tiene "AP Isolation" activado

**Solución:**
```
Accede al router (192.168.1.1 o 192.168.0.1)
Busca: Inalámbrico → AP Isolation
Desactívalo
```

---

## 🔍 Verificación Rápida

### Desde el PC, verifica que todo funciona:

```powershell
# Ver si puedes acceder localmente
curl https://localhost:8443 -k

# Ver si Docker corre
docker-compose ps

# Ver logs
docker-compose logs -f
```

### Desde el móvil:

```
1. Abre: https://192.168.1.100:8443
2. Si carga la página = ✅ Conectividad OK
3. Si muestra cámara = ✅ Permisos OK
4. Si captura foto = ✅ Todo funciona!
```

---

## 📊 Tabla de Solución Rápida

| Problema | Causa | Solución |
|----------|-------|----------|
| No carga página | PC/móvil diferentes redes | Verifica WiFi |
| Connection refused | Docker no corre | Ejecuta `start.ps1` |
| SSL warning | Certificado autofirmado | Acepta el riesgo |
| Sin cámara | Sin permisos | Habilita permisos |
| "Cannot GET /" | Frontend no listo | Espera 60 segundos |
| Black screen | JS error | Recarga la página |

---

## 🎓 Ejemplo Completo

### En el PC:
```powershell
cd C:\Users\Hugo\Desktop\TFG\PROTOTIPO-TFG
.\start.ps1
```

### En el móvil (después de 60 segundos):
```
Abre navegador
Escribe: https://192.168.1.100:8443
Acepta certificado SSL
¡Dale permiso de cámara!
¡Prueba el sistema!
```

---

## 💡 Tips Útiles

1. **Guarda el URL en favoritos**
   - Para no tener que escribir la IP cada vez

2. **Detecta IP automáticamente**
   - La terminal de `start.ps1` te muestra la IP

3. **Usa QR Code**
   - Generador QR online → https://192.168.1.100:8443
   - Escanea desde móvil

4. **Problemas persistentes?**
   - Reinicia Docker: `docker-compose restart`
   - Reinicia la app: `docker-compose down && docker-compose up`
   - Limpia todo: `cleanup.ps1` o `cleanup.sh`

---

## 📞 Soporte

Si sigues teniendo problemas:

1. Verifica README.md (setup manual original)
2. Consulta DOCKER_README.md (troubleshooting completo)
3. Revisa logs: `docker-compose logs`

---

**¡Disfruta usando el Anti-Deepfake System desde tu móvil! 📱**
