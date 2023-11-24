#!/bin/bash

for app in apps/*; do
  if [ -d "$app/restore.sh" ]; then
    cp $app/restore.sh /mnt/ssd/apps/$app/restore.sh
  fi
done
