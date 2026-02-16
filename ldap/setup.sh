#!/bin/bash

# Script de despliegue manual para LDAP
# Ejecutar en la máquina del servidor LDAP

# 0. Comprobar requisitos
if ! command -v docker &> /dev/null; then
    echo "Error: Docker no está instalado."
    exit 1
fi

# 1. Crear estructura de directorios
echo "Creating directory structure..."
mkdir -p data/database
mkdir -p data/config
mkdir -p certs
mkdir -p bootstrap

# Asegurar que data.ldif está en bootstrap (si se copió la carpeta bootstrap, ya estará)
if [ ! -f bootstrap/data.ldif ]; then
    echo "Warning: bootstrap/data.ldif not found. Users won't be created automatically."
fi

# 2. Generar certificados SSL autofirmados
echo "Generating self-signed SSL certificates..."
if [ ! -f certs/fullchain.pem ]; then
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout certs/privkey.pem \
        -out certs/fullchain.pem \
        -subj "/CN=ldap.hector.local"
    
    # Copiar fullchain a chain (necesario para la config de osixia/openldap)
    cp certs/fullchain.pem certs/chain.pem
    
    # Ajustar permisos (lectura para todos, escritura solo owner)
    chmod 644 certs/*.pem
    chmod 600 certs/privkey.pem
else
    echo "Certificates already exist in certs/"
fi

# 3. Levantar el servicio
echo "Starting LDAP container..."
docker compose down
docker compose up -d

echo "LDAP deployed successfully!"
echo "---------------------------------------------------"
echo "Host: ldap.hector.local (o IP de la máquina)"
echo "Port: 636 (SSL)"
echo "Base DN: dc=hector,dc=local"
echo "Admin DN: cn=admin,dc=hector,dc=local"
echo "Admin Check status with: docker compose ps"
