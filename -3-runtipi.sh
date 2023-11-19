docker build -t docker-ubuntu docker-ubuntu || exit 1
curl -L https://setup.runtipi.io > /mnt/ssd/setup-runtipi.sh || exit 1
docker run -it --rm --network host -v /mnt/ssd:/mnt/ssd -v /var/run/docker.sock:/var/run/docker.sock --workdir /mnt/ssd docker-ubuntu bash setup-runtipi.sh
rm /mnt/ssd/setup-runtipi.sh
mv /mnt/ssd/runtipi/runtipi-cli /mnt/ssd/runtipi/runtipi-cli-internal
cp runtipi/runtipi-cli.sh /mnt/ssd/runtipi/runtipi-cli

pushd /mnt/ssd/runtipi
chmod a+x /mnt/ssd/runtipi/runtipi-cli

cp .env .env.old
sed -i '/^INTERNAL_IP/s/=.*$/=192.168.2.1/' .env

echo "Enter your base domain here:"
echo "What is your base domain? All services will be installed as subdomains on this base domain. The base domain must not contain subdomains unless you have a paid version of Cloudflare:"
read -p "Base domain: " BASE_DOMAIN
read -p "Your e-mail address: " EMAIL_ADDRESS
echo "If you haven't done so already, create the 
sed -i "/^DOMAIN/s/=.*$/=$BASE_DOMAIN/" .env
sed -i "/^LOCAL_DOMAIN/s/=.*$/=$BASE_DOMAIN/" .env
sed -i "/^      email: /s/.*$/$EMAIL_ADDRESS traefik/traefik.yml

popd
