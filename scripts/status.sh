#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Application Status"
echo "========================================="

#########################################
# Docker Containers
#########################################

echo ""
echo "Docker Containers"
echo "-----------------------------------------"

docker ps

#########################################
# Backend Status
#########################################

echo ""
echo "Backend Status"
echo "-----------------------------------------"

curl -f http://localhost:5000/status

#########################################
# Application Status
#########################################

echo ""
echo "Application Information"
echo "-----------------------------------------"

curl -f http://localhost:5000/app-status

#########################################
# Frontend
#########################################

echo ""
echo "Frontend"
echo "-----------------------------------------"

curl -f http://localhost

echo ""
echo "========================================="
echo "Status Check Completed"
echo "========================================="