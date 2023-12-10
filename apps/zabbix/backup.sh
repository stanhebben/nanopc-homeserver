#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/zabbix
docker compose exec -i zabbix-db /usr/bin/mysqldump -u root --password=$MARIADB_ROOT_PASSWORD --all-databases --ignore-table=mysql.user | gzip > $BACKUP_DIR/zabbix/db.sql.gz || exit 1
touch backup.marker
