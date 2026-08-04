#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Restarting Backend Container"
echo "========================================="

cd "$PROJECT_DIR"

#########################################
# Verify backend/.env
#########################################

if [ ! -f backend/.env ]; then
    echo "ERROR: backend/.env not found."
    exit 1
fi

#########################################
# Restart Backend Container
#########################################

echo "Restarting backend..."

docker compose -f docker-compose.aws.yml restart backend

#########################################
# Wait
#########################################

echo "Waiting for backend..."

sleep 10

#########################################
# Show Container
#########################################

docker ps

#########################################
# Backend Health
#########################################

echo ""
echo "Checking Backend..."

curl http://localhost:5000/status

echo ""
echo "========================================="
echo "Backend Restart Completed Successfully"
echo "========================================="