#!/bin/bash

set -e

source backend/.env

echo "Waiting for RDS..."

./scripts/wait-for-rds.sh $DB_HOST $DB_PORT

echo "Creating Database Tables..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" \
< database/schema.sql

echo "Importing Sample Data..."

mysql \
-h "$DB_HOST" \
-P "$DB_PORT" \
-u "$DB_USER" \
-p"$DB_PASSWORD" \
"$DB_NAME" \
< database/seed.sql

echo "Migration Completed Successfully."