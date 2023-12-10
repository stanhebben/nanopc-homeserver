#!/bin/bash

read -p "Domain name: " APP_DOMAIN

APP_DIR=/mnt/ssd/apps/zabbix
LOCAL_DATA_DIR=/mnt/ssd/apps-local/zabbix
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
MARIADB_ROOT_PASSWORD=`openssl rand -base64 16`
MARIADB_USER_PASSWORD=`openssl rand -base64 16`

mkdir -p $APP_DIR
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "LOCAL_DATA_DIR=$LOCAL_DATA_DIR" >> $APP_DIR/.env
echo "MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD" >> $APP_DIR/.env
echo "MARIADB_USER_PASSWORD=$MARIADB_USER_PASSWORD" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/
cp backup.sh $APP_DIR/
cp restore.sh $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
