#!/bin/bash

echo "Stopping Containers..."

docker compose -f docker-compose.aws.yml down

docker system prune -f

echo "Cleanup Complete."