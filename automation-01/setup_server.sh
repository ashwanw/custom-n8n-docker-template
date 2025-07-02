#!/bin/bash

set -e

echo "🔧 Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "🐳 Installing Docker..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🚀 Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

echo "🔧 Installing Docker Compose binary..."
DOCKER_COMPOSE_VERSION="2.24.6"
sudo curl -L "https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "📁 Creating /docker-vol folder structure..."

sudo mkdir -p /docker-vol/{n8n,.n8n,postgres_data,letsencrypt,shared}

# Set permissions for UID 1000 inside containers
sudo chown -R 1000:1000 /docker-vol

# Optional: also allow current user (root here) access
sudo chmod -R 755 /docker-vol

echo "🌍 Exporting DATA_FOLDER=/docker-vol"

if ! grep -q "export DATA_FOLDER=/docker-vol" ~/.bashrc; then
  echo 'export DATA_FOLDER=/docker-vol' >> ~/.bashrc
fi

export DATA_FOLDER=/docker-vol

echo "✅ Setup complete. Run 'source ~/.bashrc' or reopen your terminal session."