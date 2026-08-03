#!/bin/bash

echo "===================================="

echo "Running Verification..."

echo "===================================="

docker ps

echo ""

curl http://localhost/status

echo ""

curl http://localhost:5000/products

echo ""

echo "Verification Completed."