#!/bin/bash

if [ ! -d "$RESTORE_DIR/syncthing" ]; then
  echo "ERROR: $RESTORE_DIR/syncthing not found"
  exit 1
fi

source .env

docker compose down
rm -rf ./data
mkdir -p ./data
cp -r $RESTORE_DIR/syncthing/* ./data/
docker compose up -d

if ! grep -q "$APP_DOMAIN" /etc/hosts; then
  LOCAL_IPV4=`uci get network.lan.ipaddr`
  LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
  LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
  echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
  echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
  service dnsmasq restart
fi
