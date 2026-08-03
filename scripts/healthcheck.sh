#!/bin/bash

echo "Backend"

curl http://localhost:5000/status

echo ""

echo "Frontend"

curl http://localhost

echo ""

echo "Health Check Finished."