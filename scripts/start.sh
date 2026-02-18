#!/bin/bash

# Switch build to skills/Dockerfile
sed -i 's|build: ./openclaw|build:\n      context: .\n      dockerfile: skills/Dockerfile|g' docker-compose.yaml

# Build
npx dotenvx run -- docker compose build

# Start server
npx dotenvx run -- docker compose up -d --force-recreate openclaw-gateway

# Restore docker-compose.yaml
sed -i 's|build:\n      context: .\n      dockerfile: skills/Dockerfile|build: ./openclaw|g' docker-compose.yaml
