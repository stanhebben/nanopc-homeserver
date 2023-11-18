#!/bin/bash

parted /dev/nvme0n1 mklabel gpt
parted -a opt /dev/nvme0n1 mkpart primary ext4 0% 100%
mkfs.ext4 /dev/nvme0n1p1
