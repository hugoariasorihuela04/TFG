# Script para limpiar volumenes y contenedores del Anti-Deepfake System
# Uso: .\cleanup.ps1

Write-Host ""
Write-Host "Limpieza del Anti-Deepfake System" -ForegroundColor Yellow
Write-Host ""

# Detener contenedores
Write-Host "1. Deteniendo contenedores..." -ForegroundColor Cyan
docker-compose down 2>$null
Write-Host "   [OK] Contenedores detenidos" -ForegroundColor Green
Write-Host ""

# Preguntar si eliminar volumenes
$response = Read-Host "Deseas eliminar la base de datos (audit.db)? (s/n)"
if ($response -eq "s" -or $response -eq "S") {
    Write-Host "2. Eliminando volumenes..." -ForegroundColor Cyan
    docker-compose down -v 2>$null
    Remove-Item -Force -ErrorAction SilentlyContinue "audit.db"
    Write-Host "   [OK] Volumenes eliminados" -ForegroundColor Green
    Write-Host ""
}

# Preguntar si eliminar imagenes
$response = Read-Host "Deseas eliminar las imagenes Docker? (s/n)"
if ($response -eq "s" -or $response -eq "S") {
    Write-Host "3. Eliminando imagenes..." -ForegroundColor Cyan
    docker rmi -f anti-deepfake-backend:latest 2>$null
    docker rmi -f anti-deepfake-frontend:latest 2>$null
    docker image prune -f 2>$null
    Write-Host "   [OK] Imagenes eliminadas" -ForegroundColor Green
    Write-Host ""
}

Write-Host "Limpieza completada" -ForegroundColor Green
Write-Host ""
Write-Host "Para reiniciar: .\start.ps1" -ForegroundColor Yellow
Write-Host ""
