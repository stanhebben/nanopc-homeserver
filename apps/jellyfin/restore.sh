#!/bin/bash

source .env

docker compose up -d

if [ -z $(grep "$APP_DOMAIN" /etc/hosts) ]; then
  LOCAL_IPV4=`uci get network.lan.ipaddr`
  LOCAL_IPV6_PREFIX=`uci get network.globals.ula_prefix`
  LOCAL_IPV6=${LOCAL_IPV6_PREFIX/::\/48/::1}
  echo "$LOCAL_IPV4 $APP_DOMAIN" >> /etc/hosts
  echo "$LOCAL_IPV6 $APP_DOMAIN" >> /etc/hosts
  service dnsmasq restart
fi

if [ -z $(uci show firewall | grep "Allow UDP 1900 for Jellyfin") ]; then
  $udp1900 = `uci add firewall redirect`
  uci set firewall.@redirect[$udp1900].dest='docker'
  uci set firewall.@redirect[$udp1900].target='DNAT'
  uci set firewall.@redirect[$udp1900].name='Allow UDP 1900 for Jellyfin'
  uci set firewall.@redirect[$udp1900].proto='udp'
  uci set firewall.@redirect[$udp1900].src='lan'
  uci set firewall.@redirect[$udp1900].src_dport='1900'
  uci set firewall.@redirect[$udp1900].dest_port='1900'

  $udp7359 = `uci add firewall redirect`
  uci set firewall.@redirect[$udp7359].dest='docker'
  uci set firewall.@redirect[$udp7359].target='DNAT'
  uci set firewall.@redirect[$udp7359].name='Allow UDP 7359 for Jellyfin'
  uci set firewall.@redirect[$udp7359].proto='udp'
  uci set firewall.@redirect[$udp7359].src='lan'
  uci set firewall.@redirect[$udp7359].src_dport='7359'
  uci set firewall.@redirect[$udp7359].dest_port='7359'

  uci commit firewall
fi
