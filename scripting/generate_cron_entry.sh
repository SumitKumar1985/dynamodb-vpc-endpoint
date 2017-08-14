#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$0"
if [ $# -ne 1 ]
then
    echo "Error: missing argument"
    echo "Usage: ${SCRIPT_NAME} aws-region"
    exit 1
fi

REGION="$1"

echo "* * * * * /home/ec2-user/put_items_every_minute.sh ${REGION}" > /tmp/mycron
crontab /tmp/mycron