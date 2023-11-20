#!/bin/bash

read -p "Domain name: " APP_DOMAIN

APP_DIR=/mnt/ssd/apps/mstream
MEDIA_FOLDER=/mnt/ssd/media
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
TZ=`uci get system.@system[0].zonename`

mkdir -p $APP_DIR
echo "TZ=$TZ" >> $APP_DIR/.env
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "MEDIA_FOLDER=$MEDIA_FOLDER" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
