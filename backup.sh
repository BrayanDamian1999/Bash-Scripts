#!/bin/bash
# backup.sh
# This script creates a compressed backup of one or more specified directories.
# It generates a timestamped .tar.gz file and stores it in /home/usuario/backups.
# Usage: ./backup.sh <directory1> [directory2 ...]
# Example: ./backup.sh /etc /var/log
#
# AUTHOR:
# Brayan Noel Espinosa Damián

set -euo pipefail


SRC_DIR="$*"
DEST_DIR="/home/usuario/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="backup_$DATE.tar.gz"

mkdir -p "$DEST_DIR"
tar -czf "$DEST_DIR/$FILENAME" "$SRC_DIR"

echo "Backup completado: $DEST_DIR/$FILENAME"