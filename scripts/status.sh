#!/bin/bash

echo "========== Docker =========="

docker ps

echo ""

echo "========== Backend =========="

curl http://localhost:5000/status || true

echo ""

echo "========== Frontend =========="

curl http://localhost || true