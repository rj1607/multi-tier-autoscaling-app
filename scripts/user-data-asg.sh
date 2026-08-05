#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/user-data.log"

exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "========================================="
echo "Starting Auto Scaling Bootstrap"
echo "========================================="

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

systemctl start docker

cd "$PROJECT_DIR"

git config --global --add safe.directory "$PROJECT_DIR"

git pull origin main

if [ ! -f backend/.env ]; then
    cp backend/.env.example backend/.env
fi

chmod +x scripts/*.sh

./scripts/deploy.sh

./scripts/healthcheck.sh || true

./scripts/status.sh || true

echo "========================================="
echo "Auto Scaling Bootstrap Completed"
echo "========================================="