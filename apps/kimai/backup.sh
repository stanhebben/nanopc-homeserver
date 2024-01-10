#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/kimai
docker compose exec -i kimai_db /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/kimai/db.sql.gz || exit 1
touch backup.marker
