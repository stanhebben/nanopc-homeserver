#!/bin/bash

if [ ! -f "$RESTORE_DIR/photoprism/db.sql.gz" ]; then
  echo "ERROR: $RESTORE_DIR/photoprism/db.sql.gz not found"
  exit 1
fi

source .env
docker compose down
rm -rf $LOCAL_DATA_DIR
mkdir $LOCAL_DATA_DIR
docker compose up -d photoprism-db --wait || exit 1
gunzip < $RESTORE_DIR/photoprism/db.sql.gz | docker compose exec -T photoprism-db mysql -u root -p"$DB_ROOT_PASSWORD" || exit 1
docker compose up -d
