#!/bin/bash
# Script para instalar Node Exporter de Prometheus en un sistema Linux (ARMv7 o AMD64)
# Este script descarga, instala y configura Node Exporter como un servicio systemd.
# Variables
#
# AUTHOR:
# Brayan Noel Espinosa Damián
VERSION="1.9.1"
ARCH="linux-amd64" #linux-armv7" # Cambiar a "linux-amd64" para sistemas x86_64
USER="nodeusr"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

echo "=== Instalando Node Exporter v$VERSION para $ARCH ==="

# Descargar
wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.$ARCH.tar.gz

# Descomprimir
tar xvfz node_exporter-$VERSION.$ARCH.tar.gz

# Entrar al directorio y mover binario
cd node_exporter-$VERSION.$ARCH
sudo mv node_exporter /usr/local/bin/

# Crear usuario dedicado (si no existe)
if id "$USER" &>/dev/null; then
    echo "Usuario $USER ya existe, continuando..."
else
    echo "Creando usuario $USER..."
    sudo useradd -rs /bin/false $USER
fi

# Crear servicio systemd
echo "Creando servicio systemd en $SERVICE_FILE..."
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=$USER
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=default.target
EOL

# Recargar systemd y habilitar servicio
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "=== Node Exporter instalado y corriendo en puerto 9100 ==="
systemctl status node_exporter --no-pager
