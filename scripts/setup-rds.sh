#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

echo "========================================="
echo "Amazon RDS Setup Wizard"
echo "========================================="

cd "$PROJECT_DIR"

#########################################
# Fix Permissions
#########################################

sudo chown -R ubuntu:ubuntu "$PROJECT_DIR" || true

chmod +x scripts/*.sh

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

echo ""
echo "backend/.env updated successfully."

#########################################
# Wait For Amazon RDS
#########################################

./scripts/wait-for-rds.sh "$RDS_ENDPOINT" 3306

#########################################
# Run Migration
#########################################

./scripts/migrate.sh

#########################################
# Restart Backend Only
#########################################

./scripts/restart-backend.sh

#########################################
# Wait Backend
#########################################

sleep 15

#########################################
# Health Check
#########################################

./scripts/healthcheck.sh

#########################################
# Verification
#########################################

./scripts/verify.sh

echo ""
echo "========================================="
echo "Amazon RDS Configuration Complete"
echo "========================================="

echo ""
echo "Backend Status"

curl http://localhost:5000/status

echo ""

echo "Products"

curl http://localhost:5000/products