#!/bin/bash

set -euxo pipefail

exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "========================================="
echo "Starting EC2 Bootstrap"
echo "========================================="

#########################################
# Update Packages
#########################################

apt update -y

#########################################
# Install Required Packages
#########################################

apt install -y \
docker.io \
docker-compose-v2 \
git \
default-mysql-client \
netcat-openbsd

#########################################
# Enable Docker
#########################################

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

#########################################
# Clone Repository
#########################################

cd /home/ubuntu

if [ ! -d "multi-tier-autoscaling-app" ]; then
    git clone https://github.com/rj1607/multi-tier-autoscaling-app.git
fi

cd multi-tier-autoscaling-app

git pull origin main

#########################################
# Create Backend Environment
#########################################

cp -f backend/.env.example backend/.env

#########################################
# Make Scripts Executable
#########################################

chmod +x scripts/*.sh

#########################################
# Deploy Application
#########################################

./scripts/deploy.sh

#########################################
# Verify Application
#########################################

./scripts/healthcheck.sh || true

./scripts/status.sh || true

#########################################
# Finished
#########################################

echo ""
echo "========================================="
echo "Bootstrap Finished Successfully"
echo "========================================="