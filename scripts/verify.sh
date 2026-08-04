#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Application Deployment Verification"
echo "========================================="

#########################################
# Docker Containers
#########################################

echo ""
echo "Docker Containers"

docker ps

#########################################
# Backend Status
#########################################

echo ""
echo "Backend Status"

curl -f http://localhost:5000/status

#########################################
# Application Status
#########################################

echo ""
echo "Application Status"

curl -f http://localhost:5000/app-status

#########################################
# Products API
#########################################

echo ""
echo "Products API"

curl -f http://localhost:5000/products

#########################################
# Frontend
#########################################

echo ""
echo "Frontend"

curl -f http://localhost

#########################################
# Verification Complete
#########################################

echo ""
echo "========================================="
echo "Deployment Verified Successfully"
echo "========================================="