#!/bin/bash

# Script para iniciar la aplicación Anti-Deepfake con Docker
# Este script simplifica el arranque y acceso a la aplicación

echo "================================"
echo "Anti-Deepfake System - Docker"
echo "================================"
echo ""

# Verificar que Docker está instalado
echo "Verificando Docker..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado o no está en PATH"
    echo "Descarga Docker Desktop: https://www.docker.com/products/docker-desktop"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está disponible"
    exit 1
fi

echo "✓ Docker y Docker Compose encontrados"
echo ""

# Obtener IP local
echo "Obteniendo IP local..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ipv4=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
else
    # Linux
    ipv4=$(hostname -I | awk '{print $1}')
fi

if [ -z "$ipv4" ]; then
    echo "⚠ No se pudo detectar IP, usando localhost"
    ipv4="localhost"
else
    echo "✓ IP detectada: $ipv4"
fi

echo ""
echo "Iniciando contenedores..."
echo ""

# Iniciar docker-compose
docker-compose up --build

echo ""
echo "================================"
echo "Aplicación iniciada!"
echo "================================"
echo ""
echo "Acceso desde este dispositivo:"
echo "  Frontend: https://localhost:8443"
echo "  Backend:  http://localhost:8000/docs"
echo ""
echo "Acceso desde otros dispositivos (misma red):"
echo "  Frontend: https://$ipv4:8443"
echo "  Backend:  http://$ipv4:8000/docs"
echo ""
echo "Presiona Ctrl+C para detener los contenedores"
