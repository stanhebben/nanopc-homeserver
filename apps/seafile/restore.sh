#!/bin/bash

if [ ! -f "$RESTORE_DIR/seafile/db.sql.gz" ]; then
  echo "ERROR: $RESTORE_DIR/seafile/db.sql.gz not found"
  exit 1
fi

source .env
docker compose down
rm -rf $LOCAL_DATA_DIR
mkdir $LOCAL_DATA_DIR
docker compose up -d seafile-db --wait || exit 1
gunzip < $RESTORE_DIR/seafile/db.sql.gz | docker compose exec -T seafile-db mysql -u root -p"$MYSQL_ROOT_PASSWORD" || exit 1
docker compose up -d
