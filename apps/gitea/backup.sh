#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/gitea
docker compose exec -i gitea-db /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/gitea/db.sql.gz || exit 1
touch backup.marker
