# initialize restic + automatic backups
read -p "B2 Application Key ID: " B2_ACCOUNT_ID
read -p "B2 Application Key: " B2_ACCOUNT_KEY
read -p "B2 Bucket name: " B2_BUCKET_NAME

echo "Choose a password for your backups. DO NOT LOSE THAT PASSWORD OR YOU CANNOT ACCESS YOUR BACKUPS."
read -p "Backup password: " BACKUP_PASSWORD
echo $BACKUP_PASSWORD > /mnt/ssd/backup.key
B2_ACCOUNT_ID=$B2_ACCOUNT_ID B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY restic -r b2:${B2_BUCKET_NAME} --password-file /mnt/ssd/backup.key init

echo "B2_ACCOUNT_ID=$B2_ACCOUNT_ID" >> /mnt/ssd/backup.env
echo "B2_ACCOUNT_KEY=$B2_ACCOUNT_KEY" >> /mnt/ssd/backup.env
echo "REPO=b2:${B2_BUCKET_NAME}" >> /mnt/ssd/backup.env

cp backup-scripts/backblaze.sh /mnt/ssd/backup.sh
echo "0 2 * * * /bin/bash /mnt/ssd/backup.sh" >> /etc/crontabs/root
service cron restart
