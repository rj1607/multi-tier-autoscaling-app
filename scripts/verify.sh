#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Application Verification"
echo "========================================="

echo ""
docker ps

echo ""
echo "Backend"
curl -f http://localhost:5000/app-status

echo ""
echo "Products"
curl -f http://localhost:5000/products

echo ""
echo "Frontend"
curl -f http://localhost

echo ""
echo "========================================="
echo "Verification Successful"
echo "========================================="