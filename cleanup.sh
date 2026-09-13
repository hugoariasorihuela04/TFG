#!/bin/bash

# Script para limpiar volúmenes y contenedores del Anti-Deepfake System
# Uso: ./cleanup.sh

set -e

echo "🧹 Limpieza del Anti-Deepfake System"
echo ""

# Detener contenedores
echo "1. Deteniendo contenedores..."
docker-compose down 2>/dev/null || true
echo "   ✓ Contenedores detenidos"

# Preguntar si eliminar volúmenes
read -p "¿Deseas eliminar la base de datos (audit.db)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "2. Eliminando volúmenes..."
    docker-compose down -v 2>/dev/null || true
    rm -f audit.db
    echo "   ✓ Volúmenes eliminados"
fi

# Preguntar si eliminar imágenes
read -p "¿Deseas eliminar las imágenes Docker? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "3. Eliminando imágenes..."
    docker rmi -f anti-deepfake-backend:latest 2>/dev/null || true
    docker rmi -f anti-deepfake-frontend:latest 2>/dev/null || true
    docker image prune -f 2>/dev/null || true
    echo "   ✓ Imágenes eliminadas"
fi

echo ""
echo "✅ Limpieza completada"
echo ""
echo "Para reiniciar: ./start.sh"
