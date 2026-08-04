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

apt-get update -y

#########################################
# Install Required Packages
#########################################

apt-get install -y \
git \
curl \
wget \
zip \
unzip \
ca-certificates \
gnupg \
lsb-release \
netcat-openbsd \
default-mysql-client

#########################################
# Install Docker
#########################################

if ! command -v docker >/dev/null 2>&1
then
    curl -fsSL https://get.docker.com | sh
fi

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

#########################################
# Install Docker Compose Plugin
#########################################

mkdir -p /home/ubuntu/.docker/cli-plugins

curl -SL \
https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
-o /home/ubuntu/.docker/cli-plugins/docker-compose

chmod +x /home/ubuntu/.docker/cli-plugins/docker-compose

chown -R ubuntu:ubuntu /home/ubuntu/.docker

#########################################
# Clone Repository
#########################################

cd /home/ubuntu

if [ ! -d "multi-tier-autoscaling-app" ]
then
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

echo ""
echo "========================================="
echo "Bootstrap Finished Successfully"
echo "========================================="