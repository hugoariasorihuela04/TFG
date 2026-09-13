#!/bin/bash

# Script para generar certificados SSL autofirmados en Docker
CERT_DIR="/app"

echo "Verificando certificados SSL..."

if [ ! -f "$CERT_DIR/localhost+2.pem" ] || [ ! -f "$CERT_DIR/localhost+2-key.pem" ]; then
    echo "Certificados no encontrados. Generando..."
    
    # Generar clave privada
    openssl genrsa -out "$CERT_DIR/localhost+2-key.pem" 2048
    
    # Generar certificado autofirmado (válido por 365 días)
    openssl req -new -x509 -key "$CERT_DIR/localhost+2-key.pem" -out "$CERT_DIR/localhost+2.pem" -days 365 \
        -subj "/C=ES/ST=Madrid/L=Madrid/O=TFG/CN=localhost" \
        -addext "subjectAltName=DNS:localhost,DNS:127.0.0.1,IP:127.0.0.1"
    
    echo "✓ Certificados generados exitosamente"
else
    echo "✓ Certificados encontrados"
fi

echo "Iniciando Nginx..."
exec nginx -g "daemon off;"
