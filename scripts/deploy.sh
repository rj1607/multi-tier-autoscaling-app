#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Deploying Multi-Tier Application"
echo "========================================="

cd "$PROJECT_DIR"

echo "Stopping old containers..."
docker compose -f docker-compose.aws.yml down || true

echo "Cleaning Docker..."
docker image prune -f

echo "Building images..."
docker compose -f docker-compose.aws.yml build

echo "Starting containers..."
docker compose -f docker-compose.aws.yml up -d

echo "Waiting for application..."
sleep 20

echo ""
echo "Running Containers"
docker ps

echo ""
echo "Backend"
curl -f http://localhost:5000/app-status

echo ""
echo "Frontend"
curl -f http://localhost

echo ""
echo "========================================="
echo "Deployment Completed Successfully"
echo "========================================="