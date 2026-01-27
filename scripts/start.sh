#!/bin/sh

# Change user permissions
sudo chown -R 1000:1000 ~/.clawdbot ~/clawd

# Start the gateway
docker compose up -d clawdbot-gateway
