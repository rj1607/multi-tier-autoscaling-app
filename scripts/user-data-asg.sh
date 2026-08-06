#!/bin/bash
set -euo pipefail

LOG_FILE="/var/log/asg-user-data.log"

exec > >(tee -a "$LOG_FILE")
exec 2>&1

echo "========================================="
echo "Starting ASG Bootstrap"
echo "========================================="

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

# Ensure Docker is running
sudo systemctl enable docker
sudo systemctl start docker

# Ensure ubuntu can use Docker
sudo usermod -aG docker ubuntu || true

# Wait until Docker is ready
until docker info >/dev/null 2>&1
do
    sleep 2
done

# Go to project
cd "$PROJECT_DIR"

# Ensure scripts are executable
chmod +x scripts/*.sh

# Stop any old containers
docker compose -f docker-compose.aws.yml down || true

# Start application using images already stored in the AMI
docker compose -f docker-compose.aws.yml up -d

# Wait for startup
sleep 20

echo "========================================="
echo "Running Verification"
echo "========================================="

docker ps || true

curl -f http://localhost:5000/app-status || true
curl -f http://localhost || true

echo "========================================="
echo "ASG Bootstrap Complete"
echo "========================================="