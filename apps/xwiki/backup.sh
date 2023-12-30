#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/xwiki
docker compose exec -i db /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/xwiki/db.sql.gz || exit 1
touch backup.marker
