#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Deploying Multi-Tier Application"
echo "========================================="

#########################################
# Go To Project
#########################################

cd "$PROJECT_DIR"

#########################################
# Stop Existing Containers
#########################################

echo "Stopping old containers..."

docker compose -f docker-compose.aws.yml down || true

#########################################
# Clean Docker
#########################################

echo "Cleaning unused Docker images..."

docker image prune -f

#########################################
# Build Images
#########################################

echo "Building Docker images..."

docker compose -f docker-compose.aws.yml build

#########################################
# Start Containers
#########################################

echo "Starting Docker containers..."

docker compose -f docker-compose.aws.yml up -d

#########################################
# Wait
#########################################

echo "Waiting for containers..."

sleep 20

#########################################
# Show Running Containers
#########################################

echo ""
echo "Running Containers"

docker ps

#########################################
# Backend Status
#########################################

echo ""
echo "Checking Backend..."

curl http://localhost:5000/status || true

#########################################
# Frontend Status
#########################################

echo ""
echo "Checking Frontend..."

curl http://localhost || true

#########################################
# Deployment Finished
#########################################

echo ""
echo "========================================="
echo "Deployment Completed Successfully"
echo "========================================="