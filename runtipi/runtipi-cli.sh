#!/bin/bash

docker run -it --rm --network host -v /mnt/ssd/runtipi:/mnt/ssd/runtipi -v /var/run/docker.sock:/var/run/docker.sock --workdir /mnt/ssd/runtipi ubuntu:22.04 ./runtipi-cli-internal "$@"
