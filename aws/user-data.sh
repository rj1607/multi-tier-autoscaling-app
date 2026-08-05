#!/bin/bash

set -e

exec > /var/log/user-data.log 2>&1

echo "========================================="
echo "Starting EC2 Bootstrap"
echo "========================================="

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y -qq docker.io docker-compose-v2 git default-mysql-client netcat-openbsd

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

cd /home/ubuntu

if [ ! -d "multi-tier-autoscaling-app" ]; then
    git clone https://github.com/rj1607/multi-tier-autoscaling-app.git
fi

cd multi-tier-autoscaling-app

git pull origin main

cp -f backend/.env.example backend/.env

chmod +x scripts/*.sh

./scripts/deploy.sh

./scripts/healthcheck.sh || true
./scripts/status.sh || true

echo "========================================="
echo "Bootstrap Finished Successfully"
echo "========================================="