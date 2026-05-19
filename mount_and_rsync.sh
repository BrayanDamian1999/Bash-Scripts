#!/bin/bash
#
# AUTHOR:
# Brayan Noel Espinosa Damián
set -e

# =========================
# VARIABLES
# =========================
SMB_IP="10.52.1.206"
SMB_SHARE="Cession"
MOUNT_POINT="/mnt/windows_share"
DESTINO="/data/mons"
USUARIO_SMB="bespinosa"
LOG_FILE="$HOME/rsync.log"

# =========================
# VALIDACIONES
# =========================
if [ "$EUID" -ne 0 ]; then
  echo "❌ Este script debe ejecutarse con sudo"
  exit 1
fi

if [ -z "$1" ]; then
  echo "❌ Uso: sudo bash mount_and_rsync.sh <nombre_carpeta>"
  exit 1
fi

CARPETA="$1"

# =========================
# CREAR MOUNT POINT
# =========================
if [ ! -d "$MOUNT_POINT" ]; then
  mkdir -p "$MOUNT_POINT"
fi

# =========================
# MONTAR SMB SI NO ESTÁ MONTADO
# =========================
if ! mountpoint -q "$MOUNT_POINT"; then
  echo "🔗 Montando recurso SMB..."
  mount -t cifs "//$SMB_IP/$SMB_SHARE" "$MOUNT_POINT" \
    -o username="$USUARIO_SMB",rw,iocharset=utf8,vers=3.0
else
  echo "El recurso SMB ya está montado"
fi

# =========================
# VALIDAR CARPETA ORIGEN
# =========================
ORIGEN="$MOUNT_POINT/$CARPETA"

if [ ! -d "$ORIGEN" ]; then
  echo "❌ La carpeta $ORIGEN no existe"
  exit 1
fi

# =========================
# EJECUTAR RSYNC EN BACKGROUND
# =========================
echo "🚀 Iniciando rsync en background..."
nohup rsync -avh --progress \
  "$ORIGEN/" \
  "$DESTINO/" \
  > "$LOG_FILE" 2>&1 &

echo "✅ Rsync iniciado correctamente"
echo "📄 Log: $LOG_FILE"
echo "🆔 PID: $!"