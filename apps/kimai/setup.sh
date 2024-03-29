#!/bin/bash

read -p "Domain name: " APP_DOMAIN
read -p "Admin email: " KIMAI_ADMIN_EMAIL
read -p "Admin password: " KIMAI_ADMIN_PASS

APP_DIR=/mnt/ssd/apps/kimai
LOCAL_DATA_DIR=/mnt/ssd/apps-local/kimai
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
MYSQL_ROOT_PASSWORD=`openssl rand -base64 16`
MYSQL_PASSWORD=`openssl rand -base64 16`

mkdir -p $APP_DIR
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "LOCAL_DATA_DIR=$LOCAL_DATA_DIR" >> $APP_DIR/.env
echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> $APP_DIR/.env
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> $APP_DIR/.env
echo "KIMAI_ADMIN_EMAIL=$KIMAI_ADMIN_EMAIL" >> $APP_DIR/.env
echo "KIMAI_ADMIN_PASS=$KIMAI_ADMIN_PASS" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/
cp backup.sh $APP_DIR/
cp restore.sh $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
