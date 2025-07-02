# Self-Hosted Customized N8N Automation Server

**Deployment time:** ~45-60 minutes | **Monthly cost:** ~$5 (Contabo.com VPS) | **Tested on:** Ubuntu 24.04 LTS

A production-ready Docker setup for self-hosting Customized N8N with custom extensions, community nodes, and automatic SSL certificates.

## Features

- Customized N8N Docker image with pre-installed npm packages (lodash, winston, duck-duck-scrape)
- Community nodes for extended functionality (MCP, text manipulation, PDF generation)
- Automatic SSL certificates via Let's Encrypt and Traefik
- PostgreSQL database for persistent storage
- Production-ready configuration with security headers
- Easy deployment on budget VPS ($5/month)

## Prerequisites

- **VPS with Ubuntu 22.04+** (tested on Contabo $4.96/month plan)
- **Domain name** pointing to your VPS IP
- **Basic command line familiarity**
- **Git installed** on your VPS

## Quick Start

### 1. VPS Setup

```bash
# Clone this repository
git clone git@github.com:your-username/your-repo-name.git
cd your-repo-name/automation-01

# Make scripts executable
chmod +x setup-server.sh reset.sh n8n-docker/init.sh

# Run server setup (installs Docker, creates directories)
./setup-server.sh

# Reload environment
source ~/.bashrc
```

### 2. Configure Environment

```bash
# Copy and edit environment variables
cp .env.example .env
nano .env
```

**Required changes in .env:**
- `N8N_HOST=your-domain.com` - Your actual domain
- `ACME_EMAIL=your-email@example.com` - For Let's Encrypt certificates  
- `POSTGRES_PASSWORD=your_secure_password` - Strong database password
- `TIMEZONE=Your/Timezone` - Your timezone (e.g., America/New_York)

### 3. Deploy

```bash
# Start all services
docker-compose up -d --build

# Monitor logs
docker-compose logs -f
```

### 4. Access Your Customized N8N

- Navigate to `https://your-domain.com`
- Complete the setup wizard
- Create your admin account

## Project Structure

```
automation-01/
├── docker-compose.yml      # Main orchestration file
├── .env.example           # Environment variables template
├── setup-server.sh        # VPS setup script
├── reset.sh              # Reset script for clean restart
└── n8n-docker/
    ├── dockerfile         # Customized N8N image with npm packages
    └── init.sh           # Community nodes installation
```

## Customization

### Add More npm Packages

Edit `n8n-docker/dockerfile`:
```dockerfile
RUN npm install -g \
    duck-duck-scrape \
    lodash \
    winston \
    your-new-package
```

### Add Community Nodes

Edit `n8n-docker/init.sh`:
```bash
npm install \
    n8n-nodes-mcp \
    n8n-nodes-text-manipulation \
    your-new-community-node
```

## Management Commands

```bash
# View logs
docker-compose logs -f n8n
docker-compose logs -f traefik

# Restart services
docker-compose restart n8n
docker-compose restart traefik

# Stop all services
docker-compose down

# Update n8n version
# 1. Edit dockerfile version
# 2. Rebuild: docker-compose up -d --build

# Pull repository updates
git pull origin main
```

## Troubleshooting

### Common Issues

**n8n container restarting:**
```bash
# Fix permissions
sudo chown -R 1000:1000 /docker-vol
sudo chmod -R 755 /docker-vol
docker-compose restart n8n
```

**HTTPS not working:**
```bash
# Check Traefik logs and fix certificate permissions
docker-compose logs traefik
sudo chmod 600 /docker-vol/letsencrypt/acme.json
docker-compose restart traefik
```

**Permission denied on init.sh:**
```bash
chmod +x n8n-docker/init.sh
docker-compose down && docker-compose up -d --build
```

### Verification Checklist

- **All containers running:** `docker-compose ps`
- **HTTPS working:** Visit your domain securely
- **Community nodes installed:** Check logs for "Community nodes installed successfully!"
- **Database connected:** Customized N8N loads without errors

## Complete Reset

If you need to start fresh:

```bash
# WARNING: This deletes all data
./reset.sh
```

## Tech Stack

- **Customized N8N** - Enhanced workflow automation platform with custom community nodes and npm packages
- **PostgreSQL 15** - Database
- **Traefik** - Reverse proxy with automatic SSL
- **Docker & Docker Compose** - Containerization
- **Let's Encrypt** - Free SSL certificates

## Resources

- **n8n Documentation:** https://docs.n8n.io/
- **Community Nodes:** https://www.npmjs.com/search?q=n8n-nodes
- **Traefik Documentation:** https://doc.traefik.io/traefik/
- **Budget VPS Provider:** https://contabo.com/en/vps/

## Support

For issues with this setup:
1. Check the troubleshooting section above
2. Review Docker logs for specific error messages
3. Ensure DNS is properly configured
4. Verify all environment variables are set correctly
