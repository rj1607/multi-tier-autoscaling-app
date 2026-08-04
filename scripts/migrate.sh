#!/bin/bash

set -euo pipefail

PROJECT_DIR="/home/ubuntu/multi-tier-autoscaling-app"

cd "$PROJECT_DIR"

#########################################
# Check backend/.env
#########################################

ENV_FILE="backend/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: backend/.env not found."
    exit 1
fi

set -a
source "$ENV_FILE"
set +a

#########################################
# Validate Variables
#########################################

if [ -z "$DB_HOST" ] || \
   [ -z "$DB_USER" ] || \
   [ -z "$DB_PASSWORD" ] || \
   [ -z "$DB_NAME" ]; then

    echo "Database configuration is incomplete."

    exit 1

fi

#########################################
# Wait For Amazon RDS
#########################################

echo "Waiting for Amazon RDS..."

./scripts/wait-for-rds.sh "$DB_HOST" "$DB_PORT"

#########################################
# Create Database
#########################################

echo ""
echo "Creating Database..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

#########################################
# Import Schema
#########################################

echo ""
echo "Importing Schema..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" \
< database/schema.sql

#########################################
# Import Seed
#########################################

echo ""
echo "Importing Sample Data..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" \
< database/seed.sql

#########################################
# Verify Tables
#########################################

echo ""
echo "Database Tables"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "USE $DB_NAME; SHOW TABLES;"

#########################################
# Count Products
#########################################

echo ""
echo "Product Count"

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
-e "USE $DB_NAME; SELECT COUNT(*) AS total_products FROM products;"

#########################################
# Finished
#########################################

echo ""
echo "========================================="
echo "Database Migration Completed Successfully"
echo "========================================="