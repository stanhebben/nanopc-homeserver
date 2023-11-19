#!/bin/bash

cd /mnt/ssd
source backup.env

export BACKUP_DIR=/mnt/ssd/apps-backup

for dir in /mnt/ssd/apps/*/
do
  if [ -f $dir/backup.sh ]; then
    echo "Generating backup of $dir"
    pushd $dir
    bash backup.sh
    popd
  fi
done

B2_ACCOUNT_ID=$B2_ACCOUNT_ID B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY restic -r $REPO --password-file backup.key backup apps apps-backup media
B2_ACCOUNT_ID=$B2_ACCOUNT_ID B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY restic -r $REPO --password-file backup.key forget --keep-weekly 8 --keep-daily 14 --keep-last 10 --prune
rm -rf $BACKUP_DIR
touch backup.marker
