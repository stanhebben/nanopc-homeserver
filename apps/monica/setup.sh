#!/bin/bash

read -p "Domain name: " APP_DOMAIN

APP_DIR=/mnt/ssd/apps/monica
LOCAL_DATA_DIR=/mnt/ssd/apps-local/monica
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
MYSQL_ROOT_PASSWORD=`openssl rand -base64 16`
MONICA_APP_KEY=`openssl rand -base64 16`
MONICA_DB_PASS=`openssl rand -base64 16`
TZ=`uci get system.@system[0].zonename`

mkdir -p $APP_DIR
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "LOCAL_DATA_DIR=$LOCAL_DATA_DIR" >> $APP_DIR/.env
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> $APP_DIR/.env
echo "MONICA_APP_KEY=$MONICA_APP_KEY" >> $APP_DIR/.env
echo "MONICA_DB_PASS=$MONICA_DB_PASS" >> $APP_DIR/.env
echo "TZ=$TZ" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/
cp backup.sh $APP_DIR/
cp restore.sh $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
