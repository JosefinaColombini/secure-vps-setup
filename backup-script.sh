#!/bin/bash

exec >> /var/log/cron_backup.log 2>&1
echo "Cron triggered at $(date)"

# === Daily Full Server Backup Script ===

BACKUP_DIR="/home/admin/backups/daily"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)
DEST="$BACKUP_DIR/server_backup_$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

# Create compressed archive of key system directories
tar -czpf "$DEST" \
  --exclude='/home/admin/backups' \    #Choose the directories/files you want to backup, this is just an example
  /etc \
  /home \
  /root \
  /var \
  2>/dev/null

# Upload the archive to Google Drive
rclone --config=/home/admin/.config/rclone/rclone.conf copy "$DEST" gdrive-backup:server-backups/daily -v

# Optional: delete local backup files older than 4 days
find "$BACKUP_DIR" -type f -mtime +4 -delete
