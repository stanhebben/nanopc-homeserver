#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/monica
docker compose exec -i monica-db /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/monica/db.sql.gz || exit 1
touch backup.marker
