#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Running Health Check"
echo "========================================="

echo ""
docker ps

echo ""
echo "Checking Backend..."

BACKEND=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/app-status)

if [ "$BACKEND" != "200" ]; then
    echo "Backend Failed"
    exit 1
fi

echo "Backend OK"

echo ""
echo "Checking Frontend..."

FRONTEND=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)

if [ "$FRONTEND" != "200" ]; then
    echo "Frontend Failed"
    exit 1
fi

echo "Frontend OK"

echo ""
echo "========================================="
echo "Health Check Passed"
echo "========================================="