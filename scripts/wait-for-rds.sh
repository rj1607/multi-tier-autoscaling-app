#!/bin/bash

set -euo pipefail

HOST=${1:?Missing RDS host}
PORT=${2:-3306}

MAX_RETRIES=60
SLEEP_SECONDS=5

echo "========================================="
echo "Waiting for Amazon RDS"
echo "========================================="
echo "Host : $HOST"
echo "Port : $PORT"
echo ""

COUNTER=0

until nc -z "$HOST" "$PORT"
do
    COUNTER=$((COUNTER+1))

    echo "Attempt $COUNTER/$MAX_RETRIES : RDS not ready..."

    if [ "$COUNTER" -ge "$MAX_RETRIES" ]; then
        echo ""
        echo "ERROR: Timed out waiting for Amazon RDS."
        exit 1
    fi

    sleep "$SLEEP_SECONDS"
done

echo ""
echo "========================================="
echo "Amazon RDS is Available"
echo "========================================="