#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Amazon RDS Setup Wizard"
echo "========================================="
echo ""

#########################################
# Fix Ownership
#########################################

if [ -d "$PROJECT_DIR" ]; then

    OWNER=$(stat -c "%U" "$PROJECT_DIR")

    if [ "$OWNER" != "ubuntu" ]; then

        echo "Fixing project ownership..."

        sudo chown -R ubuntu:ubuntu "$PROJECT_DIR"

    fi

fi

chmod +x "$PROJECT_DIR"/scripts/*.sh || true

#########################################
# Go Project
#########################################

cd "$PROJECT_DIR"

#########################################
# Ask RDS Details
#########################################

read -rp "Enter RDS Endpoint: " RDS_ENDPOINT

read -rp "Enter Database Username [admin]: " DB_USER

DB_USER=${DB_USER:-admin}

read -rsp "Enter Database Password: " DB_PASSWORD

echo ""

#########################################
# Update backend/.env
#########################################

echo "Updating backend/.env..."

cat > backend/.env <<EOF
FLASK_APP=app.py
FLASK_ENV=production

APP_HOST=0.0.0.0
APP_PORT=5000

DB_HOST=$RDS_ENDPOINT
DB_PORT=3306
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_NAME=autoscaling_app
EOF

echo "backend/.env updated."

#########################################
# Wait For RDS
#########################################

echo ""
echo "Waiting for Amazon RDS..."

./scripts/wait-for-rds.sh "$RDS_ENDPOINT" 3306

#########################################
# Create Database (if missing)
#########################################

echo ""
echo "Checking Database..."

mysql \
-h "$RDS_ENDPOINT" \
-P 3306 \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "CREATE DATABASE IF NOT EXISTS autoscaling_app;"

#########################################
# Import Schema + Seed
#########################################

echo ""
echo "Running Database Migration..."

./scripts/migrate.sh

#########################################
# Verify Tables
#########################################

echo ""
echo "========================================="
echo "Verifying Database"
echo "========================================="

mysql \
-h "$RDS_ENDPOINT" \
-P 3306 \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "USE autoscaling_app; SHOW TABLES;"

#########################################
# Restart Backend
#########################################

echo ""
echo "Restarting Backend..."

docker compose -f docker-compose.aws.yml down

docker compose -f docker-compose.aws.yml up -d --build

#########################################
# Wait
#########################################

echo ""
echo "Waiting for Backend..."

sleep 20

#########################################
# Health Check
#########################################

./scripts/healthcheck.sh

#########################################
# Verify Deployment
#########################################

./scripts/verify.sh

#########################################
# Finished
#########################################

echo ""
echo "========================================="
echo "RDS Setup Completed Successfully"
echo "========================================="
echo ""

echo "Backend Status:"
curl http://localhost:5000/status

echo ""
echo "Products:"
curl http://localhost:5000/products

echo ""
echo "Application Ready."