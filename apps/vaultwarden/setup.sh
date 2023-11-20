#!/bin/bash

read -p "Domain name: " APP_DOMAIN
echo "Choose your admin password:"
docker run -it vaultwarden/server:latest ./vaultwarden hash
echo "Copy and paste the admin token:"
read -p "ADMIN_TOKEN=" ADMIN_TOKEN

APP_DIR=/mnt/ssd/apps/vaultwarden
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}

mkdir -p $APP_DIR
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
