#!/bin/bash

echo "========== BACKEND =========="

docker logs backend --tail 50

echo ""

echo "========== FRONTEND =========="

docker logs frontend --tail 50