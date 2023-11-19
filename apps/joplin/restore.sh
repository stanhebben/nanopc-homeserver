#!/bin/bash

if [ ! -f "$RESTORE_DIR/joplin/db.sql.gz" ]; then
  echo "ERROR: $RESTORE_DIR/joplin/db.sql.gz not found"
  exit 1
fi

source .env
docker compose down
rm -rf $LOCAL_DATA_DIR
mkdir $LOCAL_DATA_DIR
docker compose up -d joplin-db --wait || exit 1
gunzip < $RESTORE_DIR/joplin/db.sql.gz | docker compose exec -T joplin-db psql -U joplin || exit 1
docker compose up -d
