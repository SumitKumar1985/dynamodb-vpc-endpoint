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

echo "* * * * * /home/ec2-user/put_items_every_minute.sh ${REGION} ${TABLE_NAME}" > mycron
crontab mycron