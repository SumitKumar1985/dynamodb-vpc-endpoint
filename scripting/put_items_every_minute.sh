#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$0"
REGION="$1"

if [ $# -ne 1 ]
then
    echo "Usage: ${SCRIPT_NAME} aws-region"
    exit 1
fi

table_name="items_every_minute"
HOSTNAME=$(hostname)

DESCRIBE_TABLE=$(aws dynamodb describe-table \
    --table-name ${table_name} \
    --query "Table.[TableName]" --output text || hostname )

if [ "$DESCRIBE_TABLE" = "$table_name" ]
then
    echo "Table exists: ${DESCRIBE_TABLE}"

else
    # create table

    echo "Creating table: ${table_name}"
    aws --region ${REGION} dynamodb create-table \
        --table-name ${table_name} \
        --cli-input-json file://table_definition.json

    sleep 30

    # update TTL
    aws --region ${REGION} dynamodb update-time-to-live \
        --table-name ${table_name} \
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
    --table-name ${table_name} \
    --item file://item.json