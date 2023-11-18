docker build -t docker-ubuntu docker-ubuntu || exit 1
curl -L https://setup.runtipi.io | /mnt/ssd/setup-runtipi.sh
docker run -it --rm --network host -v /mnt/ssd:/mnt/ssd -v /var/run/docker.sock:/var/run/docker.sock --workdir /mnt/ssd docker-ubuntu bash setup-runtipi.sh
mv /mnt/ssd/runtipi/runtipi-cli /mnt/ssd/runtipi/runtipi-cli-internal
cp runtipi-cli.sh /mnt/ssd/runtipi/
