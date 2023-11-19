#!/bin/bash

read -p "Domain name: " APP_DOMAIN
DB_PASSWORD=`openssl rand -base64 16`

APP_DIR=/mnt/ssd/apps/joplin
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6='fd00:ab:cd::1'

mkdir -p $APP_DIR
echo APP_DOMAIN=$APP_DOMAIN >> $APP_DIR/.env
echo DB_PASSWORD=$DB_PASSWORD >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service 

pushd $APP_DIR
docker compose up -d
popd
