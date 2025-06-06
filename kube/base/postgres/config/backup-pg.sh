#!/bin/bash
set -e

cd /home/root
date1=$(date +%Y%m%d-%H%M)
mkdir pg-backup

echo "Waiting for PostgreSQL to be ready..."
until pg_isready > /dev/null 2>&1; do
    sleep 2
done
echo "PostgreSQL is ready."

pg_dumpall > pg-backup/postgres-db.tar
file_name="pg-backup-$date1.tar.gz"

# Compressing backup file for upload
tar -zcvf "$file_name" pg-backup

# Optional cleanup of temporary folder
rm -rf pg-backup

notification_msg="Postgres-Backup-failed"
filesize=$(stat -c %s "$file_name")
mfs=10

if [[ "$filesize" -gt "$mfs" ]]; then
    # Uploading to MinIO
    until mc alias set myminio http://minio-headless:9000 "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY"; do
        echo "Waiting for MinIO to be ready..."
        sleep 2
    done

    mc put "$file_name" "myminio/$S3_BUCKET/$file_name"

    # Keep only the last 3 backups in the bucket
    echo "Cleaning up old backups, keeping last 3..."
    mc ls "myminio/$S3_BUCKET" | grep pg-backup- | awk '{print $NF}' | sort -r | tail -n +5 | while read -r old_backup; do
        echo "Removing old backup: $old_backup"
        mc rm "myminio/$S3_BUCKET/$old_backup"
    done
fi
