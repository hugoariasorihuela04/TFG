# Script para actualizar el Anti-Deepfake System
# Rebuilds Docker images and restarts services

Write-Host ""
Write-Host "Actualizando Anti-Deepfake System" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Deteniendo servicios..." -ForegroundColor Yellow
docker-compose down
Write-Host "   [OK] Servicios detenidos" -ForegroundColor Green
Write-Host ""

Write-Host "2. Reconstruyendo imagenes (sin cache)..." -ForegroundColor Yellow
docker-compose build --no-cache
Write-Host "   [OK] Imagenes reconstruidas" -ForegroundColor Green
Write-Host ""

Write-Host "3. Iniciando servicios..." -ForegroundColor Yellow
docker-compose up -d
Write-Host "   [OK] Servicios iniciados" -ForegroundColor Green
Write-Host ""

Write-Host "4. Esperando a que este listo..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
docker-compose ps
Write-Host ""

# Obtener IP
$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred | 
         Where-Object {$_.InterfaceAlias -notmatch 'Loopback'} | 
         Select-Object -First 1 -ExpandProperty IPAddress)

if (!$ipv4) {
    $ipv4 = "localhost"
}

Write-Host "Actualizacion completada" -ForegroundColor Green
Write-Host ""
Write-Host "Acceso:" -ForegroundColor Yellow
Write-Host "  - Frontend: https://$ipv4:8443" -ForegroundColor Cyan
Write-Host "  - Backend:  http://$ipv4:8000/docs" -ForegroundColor Cyan
Write-Host ""
