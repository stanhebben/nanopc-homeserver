#!/bin/bash

source .env
mkdir -p $BACKUP_DIR/syncthing
cp -r ./data/* $BACKUP_DIR/syncthing/
touch backup.marker
