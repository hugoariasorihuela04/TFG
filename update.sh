#!/bin/bash

# Script para actualizar el Anti-Deepfake System
# Rebuilds Docker images and restarts services

set -e

echo ""
echo "🔄 Actualizando Anti-Deepfake System"
echo ""

echo "1. Deteniendo servicios..."
docker-compose down
echo "   ✓ Servicios detenidos"
echo ""

echo "2. Reconstruyendo imágenes (sin caché)..."
docker-compose build --no-cache
echo "   ✓ Imágenes reconstruidas"
echo ""

echo "3. Iniciando servicios..."
docker-compose up -d
echo "   ✓ Servicios iniciados"
echo ""

echo "4. Esperando a que esté listo..."
sleep 10
docker-compose ps
echo ""

# Obtener IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    ipv4=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
else
    ipv4=$(hostname -I | awk '{print $1}')
fi

if [ -z "$ipv4" ]; then
    ipv4="localhost"
fi

echo "✅ Actualización completada"
echo ""
echo "Acceso:"
echo "  • Frontend: https://$ipv4:8443"
echo "  • Backend:  http://$ipv4:8000/docs"
echo ""
