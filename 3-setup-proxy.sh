read -p "Administrator e-mail address: " ADMIN_EMAIL

echo "For the Letsencrypt certificates, you'll need the DNS to be Cloudflare and you'll need to setup two API keys as described in the README. Enter the corresponding API keys here."
read -p "DNS API Token (with write access to the domain): " CF_DNS_API_TOKEN
read -p "Zone API Token (with read access to all zones): " CF_ZONE_API_TOKEN

mkdir -p /mnt/ssd/apps/base
cp apps/base/docker-compose.yml /mnt/ssd/apps/base/

echo "ADMIN_EMAIL=$ADMIN_EMAIL" >> /mnt/ssd/apps/base/.env
echo "CF_DNS_API_TOKEN=$CF_DNS_API_TOKEN" >> /mnt/ssd/apps/base/.env
echo "CF_ZONE_API_TOKEN=$CF_ZONE_API_TOKEN" >> /mnt/ssd/apps/base/.env

pushd apps/cloudflared
bash setup.sh
popd
