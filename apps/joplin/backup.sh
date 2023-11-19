#!/bin/bash

mkdir -p $BACKUP_DIR/joplin
docker compose exec -i joplin-db /usr/bin/pg_dumpall -U joplin | gzip > $BACKUP_DIR/joplin/db.sql.gz || exit 1
