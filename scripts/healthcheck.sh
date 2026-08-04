#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Running Application Health Check"
echo "========================================="

#########################################
# Docker Containers
#########################################

echo ""
echo "Docker Containers"

docker ps

#########################################
# Backend Health
#########################################

echo ""
echo "Checking Backend..."

BACKEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/status || true)

if [ "$BACKEND_STATUS" = "200" ]; then
    echo "✓ Backend is Healthy"
else
    echo "✗ Backend is Unhealthy (HTTP $BACKEND_STATUS)"
    exit 1
fi

#########################################
# Frontend Health
#########################################

echo ""
echo "Checking Frontend..."

FRONTEND_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost || true)

if [ "$FRONTEND_STATUS" = "200" ]; then
    echo "✓ Frontend is Healthy"
else
    echo "✗ Frontend is Unhealthy (HTTP $FRONTEND_STATUS)"
    exit 1
fi

#########################################
# Finished
#########################################

echo ""
echo "========================================="
echo "Health Check Passed Successfully"
echo "========================================="