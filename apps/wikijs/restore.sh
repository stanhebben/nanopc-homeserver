#!/bin/bash

if [ ! -f "$RESTORE_DIR/wikijs/db.sql.gz" ]; then
  echo "ERROR: $RESTORE_DIR/wikijs/db.sql.gz not found"
  exit 1
fi

source .env
docker compose down
rm -rf $LOCAL_DATA_DIR
mkdir $LOCAL_DATA_DIR
docker compose up -d wikijs-db --wait || exit 1
gunzip < $RESTORE_DIR/wikijs/db.sql.gz | docker compose exec -T wikijs-db psql -U wikijs || exit 1
docker compose up -d

if ! grep -q "$APP_DOMAIN" /etc/hosts; then
  LOCAL_IPV4=`uci get network.lan.ipaddr`
  LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
  LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
  echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
  echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
  service dnsmasq restart
fi
