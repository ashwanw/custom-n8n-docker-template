#!/bin/sh
set -e

N8N_DIR="/home/node/.n8n"
NODE_DIR="$N8N_DIR/nodes"

echo "📦 Initializing community node install..."

mkdir -p "$NODE_DIR"
cd "$NODE_DIR"

# Only install if not already there
if [ ! -d "$NODE_DIR/node_modules" ]; then
  echo "📁 node_modules missing, installing community nodes..."
  npm init -y
  npm install \
    n8n-nodes-mcp \
    n8n-nodes-text-manipulation \
    n8n-nodes-globals \
    n8n-nodes-pdfkit
else
  echo "✅ Community nodes already present. Skipping install."
fi

chown -R node:node "$N8N_DIR"