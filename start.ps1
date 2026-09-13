# Script para iniciar la aplicacion Anti-Deepfake con Docker
# Este script simplifica el arranque y acceso a la aplicacion

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Anti-Deepfake System - Docker" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que Docker esta instalado
Write-Host "Verificando Docker..." -ForegroundColor Yellow
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Docker no esta instalado o no esta en PATH" -ForegroundColor Red
    Write-Host "Descarga Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Docker Compose no esta disponible" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Docker y Docker Compose encontrados" -ForegroundColor Green
Write-Host ""

# Obtener IP local
Write-Host "Obteniendo IP local..." -ForegroundColor Yellow
$ipv4 = (Get-NetIPAddress -AddressFamily IPv4 -AddressState Preferred | 
         Where-Object {$_.InterfaceAlias -notmatch 'Loopback'} | 
         Select-Object -First 1 -ExpandProperty IPAddress)

if ($ipv4) {
    Write-Host "[OK] IP detectada: $ipv4" -ForegroundColor Green
} else {
    Write-Host "[WARN] No se pudo detectar IP, usando localhost" -ForegroundColor Yellow
    $ipv4 = "localhost"
}

Write-Host ""
Write-Host "Iniciando contenedores..." -ForegroundColor Yellow
Write-Host ""

# Iniciar docker-compose
docker-compose up --build

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Aplicacion iniciada!" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Acceso desde este PC:" -ForegroundColor Green
Write-Host "  Frontend: https://localhost:8443" -ForegroundColor Cyan
Write-Host "  Backend:  http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host ""
Write-Host "Acceso desde otros dispositivos (misma red):" -ForegroundColor Green
Write-Host "  Frontend: https://$ipv4:8443" -ForegroundColor Cyan
Write-Host "  Backend:  http://$ipv4:8000/docs" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Ctrl+C para detener los contenedores" -ForegroundColor Yellow
