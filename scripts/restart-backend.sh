#!/bin/bash

set -e

cd /home/ubuntu/multi-tier-autoscaling-app

docker compose -f docker-compose.aws.yml restart backend

echo "Backend restarted successfully."