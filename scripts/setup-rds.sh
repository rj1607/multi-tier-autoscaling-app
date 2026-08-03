#!/bin/bash

set -e

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

cd "$PROJECT_DIR"

echo "========================================="
echo "Amazon RDS Setup Wizard"
echo "========================================="
echo ""

read -p "Enter Amazon RDS Endpoint: " RDS_ENDPOINT

read -p "Enter Database Username [admin]: " DB_USER
DB_USER=${DB_USER:-admin}

read -s -p "Enter Database Password: " DB_PASSWORD
echo

read -p "Enter Database Name [autoscaling_app]: " DB_NAME
DB_NAME=${DB_NAME:-autoscaling_app}

echo ""
echo "========================================="
echo "Updating backend/.env"
echo "========================================="

cat > backend/.env <<EOF
FLASK_APP=app.py
FLASK_ENV=production

APP_HOST=0.0.0.0
APP_PORT=5000

DB_HOST=${RDS_ENDPOINT}
DB_PORT=3306
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME}
EOF

echo "backend/.env updated."

echo ""
echo "========================================="
echo "Waiting for Amazon RDS..."
echo "========================================="

chmod +x scripts/wait-for-rds.sh
./scripts/wait-for-rds.sh "$RDS_ENDPOINT" "3306"

echo ""
echo "========================================="
echo "Running Database Migration"
echo "========================================="

chmod +x scripts/migrate.sh
./scripts/migrate.sh

echo ""
echo "========================================="
echo "Restarting Backend"
echo "========================================="

chmod +x scripts/restart-backend.sh
./scripts/restart-backend.sh

echo ""
echo "========================================="
echo "Running Health Check"
echo "========================================="

chmod +x scripts/healthcheck.sh
./scripts/healthcheck.sh

echo ""
echo "========================================="
echo "Running Verification"
echo "========================================="

chmod +x scripts/verify.sh
./scripts/verify.sh

echo ""
echo "========================================="
echo "Amazon RDS Setup Completed Successfully"
echo "========================================="
echo ""
echo "Backend URL:"
echo "http://localhost:5000/status"
echo ""
echo "Products API:"
echo "http://localhost:5000/products"
echo ""