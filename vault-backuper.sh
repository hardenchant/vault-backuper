#!/bin/bash

set -a

VAULT_ADDR="${VAULT_ADDR:?Need to set VAULT_ADDR}"
VAULT_TOKEN="${VAULT_TOKEN:?Need to set VAULT_TOKEN}"
# VAULT_SKIP_VERIFY=1

BACKUP_FILE_PATH=/tmp
BACKUP_FILE_NAME=primary.snap

AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:?Need to set AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:?Need to set AWS_SECRET_ACCESS_KEY}"
AWS_HOST="${AWS_HOST:?Need to set AWS_HOST}"
AWS_S3_BUCKET="${AWS_S3_BUCKET:?Need to set AWS_S3_BUCKET}"

PERIOD=1d

set +a

while true
do
    DATE=$(date "+%F-%H-%M-%S")

    echo "$DATE creating backup"
    vault operator raft snapshot save $BACKUP_FILE_PATH/$DATE-$BACKUP_FILE_NAME

    echo "$DATE uploading backup"
    s3cmd --host $AWS_HOST --host-bucket $AWS_HOST put $BACKUP_FILE_PATH/$DATE-$BACKUP_FILE_NAME s3://vault-backup/$DATE-$BACKUP_FILE_NAME

    echo "$DATE renew token"
    vault token renew > /dev/null

    echo "$DATE sleeping for $PERIOD"
    sleep $PERIOD
done
