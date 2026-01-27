#!/bin/sh

# Create permanent directories
mkdir -p ~/.clawdbot ~/clawd
sudo chown -R 1000:1000 ~/.clawdbot ~/clawd

# Add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Install dependencies
npm install

# Build and onboard
cd clawdbot
docker compose build
docker compose run --rm clawdbot-cli onboard
