docker build -t docker-ubuntu docker-ubuntu || exit 1
mkdir -p /mnt/ssd/runtipi
docker run -it --rm --network host -v /mnt/ssd/runtipi:/mnt/ssd/runtipi -v /var/run/docker.sock:/var/run/docker.sock --workdir /mnt/ssd/runtipi docker-ubuntu curl -L https://setup.runtipi.io | bash
