#!/bin/bash

cd /mnt/ssd
source backup.env

B2_ACCOUNT_ID=$B2_ACCOUNT_ID B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY restic -r $REPO --password-file backup.key restore latest --target /mnt/ssd

export RESTORE_DIR=/mnt/ssd/apps-backup

# restore our proxy first, so we have the shared network
pushd /mnt/ssd/apps/base
docker compose up -d
popd

for dir in /mnt/ssd/apps/*/
do
  pushd $dir
  if [ -f $dir/restore.sh ]; then
    echo "Restoring $dir"
    bash restore.sh
  else
    docker compose up -d
  fi
  popd
done

rm -rf $RESTORE_DIR
