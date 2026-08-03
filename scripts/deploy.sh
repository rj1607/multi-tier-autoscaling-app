#!/bin/bash

set -e

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Deploying Application"
echo "========================================="

cd "$PROJECT_DIR"

echo "Stopping old containers..."
docker compose -f docker-compose.aws.yml down || true

echo "Removing unused images..."
docker image prune -f

echo "Building containers..."
docker compose -f docker-compose.aws.yml build --no-cache

echo "Starting containers..."
docker compose -f docker-compose.aws.yml up -d

echo "Waiting for services..."
sleep 15

echo "Running Containers"
docker ps

echo "========================================="
echo "Deployment Successful"
echo "=========================================