#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/seafile
docker compose exec -i seafile-db /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/seafile/db.sql.gz || exit 1
touch backup.marker
