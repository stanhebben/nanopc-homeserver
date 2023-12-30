#!/bin/bash

mkdir -p $BACKUP_DIR/wikijs
docker compose exec -i wikijs-db /usr/bin/pg_dumpall -U wikijs | gzip > $BACKUP_DIR/wikijs/db.sql.gz || exit 1
touch backup.marker
