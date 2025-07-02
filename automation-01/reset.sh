#!/bin/bash
# reset.sh - Complete reset of n8n installation

echo "⚠️  WARNING: This will delete all n8n data!"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted."
    exit 1
fi

# Stop all services
docker-compose down -v

# Remove all data
sudo rm -rf /docker-vol/{.n8n,postgres_data,letsencrypt}

# Recreate directories
sudo mkdir -p /docker-vol/{.n8n,postgres_data,letsencrypt}
sudo chown -R 1000:1000 /docker-vol
sudo chmod -R 755 /docker-vol

# Start fresh
docker-compose up -d --build

echo "✅ Reset complete. n8n is starting fresh."