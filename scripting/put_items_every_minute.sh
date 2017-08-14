#!/usr/bin/env bash

set -euxo pipefail

SCRIPT_NAME="$0"
REGION="$1"

if [ $# -ne 1 ]
then
    echo "Usage: ${SCRIPT_NAME} aws-region"
    exit 1
fi

table_name="test_items_every_minute"

# create table
aws --region ${REGION} dynamodb create-table \
    --table-name ${table_name} \
    --cli-input-json file://table_definition.json

sleep 30

# update TTL
aws --region ${REGION} dynamodb update-time-to-live \
    --table-name ${table_name} \
    --time-to-live-specification Enabled=true,AttributeName=expireAt

NOW_IN_MINUTES=$(date +"%Y%m%dT%H%M%z")
EPOCH_TIME=$(date +%s)
ONE_DAY_LATER=$(($EPOCH_TIME+86400))
HOSTNAME=$(hostname)

item="{
    \"id\": {\"S\":\"${NOW_IN_MINUTES}\"},
    \"expireAt\": {\"N\": \"${ONE_DAY_LATER}\"},
    \"hostname\": {\"S\":\"${HOSTNAME}\"}
}"

echo "${item}" > item.json

aws --region ${REGION} dynamodb put-item \
    --table-name ${table_name} \
    --item file://item.json