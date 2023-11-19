#!/bin/bash

echo "For the cloudflare tunnel to work, you'll need to set it up from Cloudflare Zero Trust. Follow the instructions in the README."
read -p "Tunnel token: " CLOUDFLARED_TOKEN

APP_DIR=/mnt/ssd/apps/cloudflared
mkdir -p $APP_DIR

echo "CLOUDFLARED_TOKEN=$CLOUDFLARED_TOKEN" >> $APP_DIR/.env
cp docker-compose.yml $APP_DIR/

pushd $APP_DIR
docker compose up -d
popd
