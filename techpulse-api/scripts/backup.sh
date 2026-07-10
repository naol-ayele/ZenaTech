#!/bin/bash
# TechPulse API - Database Backup Script
# Usage: ./scripts/backup.sh [output-dir]
#
# For Neon serverless PostgreSQL, enable point-in-time recovery in the
# Neon console: https://console.neon.tech > Project > Settings > Backups
#
# This script creates a logical backup using pg_dump for manual
# restore or migration purposes.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Load environment variables
if [ -f "$PROJECT_DIR/.env" ]; then
  export $(grep -v '^#' "$PROJECT_DIR/.env" | xargs)
fi

BACKUP_DIR="${1:-$PROJECT_DIR/backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/techpulse_backup_$TIMESTAMP.sql"

mkdir -p "$BACKUP_DIR"

echo "Starting backup to: $BACKUP_FILE"
pg_dump "$DATABASE_URL" \
  --no-owner \
  --no-acl \
  --clean \
  --if-exists \
  --format=custom \
  --file="$BACKUP_FILE"

echo "Backup complete: $BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"

# Restore command (for reference):
# pg_restore --no-owner --no-acl --clean --if-exists -d "$DATABASE_URL" "$BACKUP_FILE"
