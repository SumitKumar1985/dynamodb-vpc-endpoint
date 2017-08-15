#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
    echo "Error: missing argument(s)"
    echo "Usage: ${SCRIPT_NAME} aws-region table-name"
    exit 1
fi
REGION="$1"
TABLE_NAME="$2"


HOSTNAME=$(hostname)
DESCRIBE_TABLE=$(aws dynamodb describe-table \
    --table-name ${TABLE_NAME} \
    --query "Table.[TableName]" --output text || hostname)

if [ "$DESCRIBE_TABLE" = "$TABLE_NAME" ]
then
    echo "Table exists: ${DESCRIBE_TABLE}"

else
    # create table
    echo "Creating table: ${TABLE_NAME}"
    aws --region ${REGION} dynamodb create-table \
        --table-name ${TABLE_NAME} \
        --cli-input-json file://table_definition.json

    sleep 30

    # update TTL
    aws --region ${REGION} dynamodb update-time-to-live \
        --table-name ${TABLE_NAME} \
        --time-to-live-specification Enabled=true,AttributeName=expireAt

fi

NOW_IN_MINUTES=$(date +"%Y%m%dT%H%M%z")
EPOCH_TIME=$(date +%s)
ONE_DAY_LATER=$(($EPOCH_TIME+86400))

item="{
    \"id\": {\"S\":\"${NOW_IN_MINUTES}\"},
    \"expireAt\": {\"N\": \"${ONE_DAY_LATER}\"},
    \"hostname\": {\"S\":\"${HOSTNAME}\"}
}"

echo "${item}" > item.json

aws --region ${REGION} dynamodb put-item \
    --table-name ${TABLE_NAME} \
    --item file://item.json