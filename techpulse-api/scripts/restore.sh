#!/bin/bash
# TechPulse API - Database Restore Script
# Usage: ./scripts/restore.sh <backup-file>
#
# Restores a custom-format pg_dump backup into the current database.
# WARNING: This will DROP existing tables before restoring.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Error: Backup file not found: $BACKUP_FILE"
  exit 1
fi

# Load environment variables
if [ -f "$PROJECT_DIR/.env" ]; then
  export $(grep -v '^#' "$PROJECT_DIR/.env" | xargs)
fi

echo "Restoring from: $BACKUP_FILE"
pg_restore \
  --no-owner \
  --no-acl \
  --clean \
  --if-exists \
  --verbose \
  -d "$DATABASE_URL" \
  "$BACKUP_FILE"

echo "Restore complete."
