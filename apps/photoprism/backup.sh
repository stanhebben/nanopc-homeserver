#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/photoprism
docker compose exec -i photoprism-db /usr/bin/mysqldump -u root --password=$DB_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/photoprism/db.sql.gz || exit 1
