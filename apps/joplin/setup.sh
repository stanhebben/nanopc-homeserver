#!/bin/bash

read -p "Domain name: " APP_DOMAIN
DB_PASSWORD=`openssl rand -base64 16`

APP_DIR=/mnt/ssd/apps/joplin
LOCAL_DATA_DIR=/mnt/ssd/apps-local/joplin
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}

mkdir -p $APP_DIR
echo APP_DOMAIN=$APP_DOMAIN >> $APP_DIR/.env
echo DB_PASSWORD=$DB_PASSWORD >> $APP_DIR/.env
echo LOCAL_DATA_DIR=$LOCAL_DATA_DIR >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/
cp backup.sh $APP_DIR/
cp restore.sh $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
