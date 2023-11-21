#!/bin/bash

read -p "Domain name: " APP_DOMAIN

APP_DIR=/mnt/ssd/apps/jellyfin
MEDIA_FOLDER=/mnt/ssd/media
LOCAL_DATA_DIR=/mnt/ssd/apps-local/jellyfin
LOCAL_IPV4=`uci get network.lan.ipaddr`
LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
TZ=`uci get system.@system[0].zonename`

mkdir -p $APP_DIR
echo "APP_DOMAIN=$APP_DOMAIN" >> $APP_DIR/.env
echo "MEDIA_FOLDER=$MEDIA_FOLDER" >> $APP_DIR/.env
echo "LOCAL_DATA_DIR=$LOCAL_DATA_DIR" >> $APP_DIR/.env

cp docker-compose.yml $APP_DIR/

udp1900=`uci add firewall redirect`
uci set firewall.$udp1900.dest='docker'
uci set firewall.$udp1900.target='DNAT'
uci set firewall.$udp1900.name='Allow UDP 1900 for Jellyfin'
uci set firewall.$udp1900.proto='udp'
uci set firewall.$udp1900.src='lan'
uci set firewall.$udp1900.src_dport='1900'
uci set firewall.$udp1900.dest_port='1900'

udp7359=`uci add firewall redirect`
uci set firewall.$udp7359.dest='docker'
uci set firewall.$udp7359.target='DNAT'
uci set firewall.$udp7359.name='Allow UDP 7359 for Jellyfin'
uci set firewall.$udp7359.proto='udp'
uci set firewall.$udp7359.src='lan'
uci set firewall.$udp7359.src_dport='7359'
uci set firewall.$udp7359.dest_port='7359'

uci commit firewall

echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
service dnsmasq restart

pushd $APP_DIR
docker compose up -d
popd
