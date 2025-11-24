# Deployment Guide

## Quick Start

### 1. Initial Setup on Linux Server

```bash
# Clone the repository
git clone https://github.com/MithunKrishna2008/Book_Shop.git /var/www/book-shopping-website

# Run setup script (as root)
sudo bash scripts/setup-deployment-user.sh

# Switch to deployment user
sudo su - deploy

# Navigate to project directory
cd /var/www/book-shopping-website
```

### 2. Manual Deployment

```bash
# Make script executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

### 3. Automated Deployment with Cron

```bash
# Edit crontab as deploy user
crontab -e

# Add this line for daily deployment at 2 AM
0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

## Detailed Steps

### Step 1: Server Preparation

1. **Install Required Software**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Node.js and pnpm
   curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
   sudo apt install -y nodejs
   sudo npm install -g pnpm
   
   # Install Git
   sudo apt install -y git
   ```

2. **Create Project Directory**
   ```bash
   sudo mkdir -p /var/www/book-shopping-website
   ```

### Step 2: User Setup

Run the setup script:
```bash
sudo bash scripts/setup-deployment-user.sh
```

This script will:
- Create `deploy` user
- Create `deployers` group
- Set up proper permissions
- Create log and backup directories

### Step 3: Repository Setup

```bash
# As deploy user
sudo su - deploy
cd /var/www/book-shopping-website

# Initialize git (if not already cloned)
git init
git remote add origin https://github.com/MithunKrishna2008/Book_Shop.git
git pull origin main
```

### Step 4: Configure Environment

```bash
# Create .env file
nano .env

# Add your environment variables
NODE_ENV=production
PORT=3000
# ... other variables
```

### Step 5: First Deployment

```bash
# Run deployment script
./scripts/deploy.sh
```

### Step 6: Set Up Systemd Service (Optional)

Create `/etc/systemd/system/book-shopping-app.service`:

```ini
[Unit]
Description=Book Shopping Website
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/var/www/book-shopping-website
Environment=NODE_ENV=production
ExecStart=/usr/bin/pnpm start
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable book-shopping-app
sudo systemctl start book-shopping-app
```

## GitHub Actions Configuration

### Required Secrets

Add these secrets in GitHub repository settings:

1. `SERVER_HOST` - Your server IP or hostname
2. `SERVER_USER` - SSH username (usually `deploy`)
3. `SSH_PRIVATE_KEY` - Private SSH key for server access

### Setting Up SSH Key

```bash
# On your local machine
ssh-keygen -t ed25519 -C "github-actions"

# Copy public key to server
ssh-copy-id deploy@your-server-ip

# Copy private key content
cat ~/.ssh/id_ed25519
# Add this to GitHub Secrets as SSH_PRIVATE_KEY
```

## Monitoring

### View Deployment Logs

```bash
# Real-time log viewing
tail -f /var/log/book-shopping-deploy.log

# View automated deployment logs
tail -f /var/log/book-shopping/automated-deploy-$(date +%Y%m%d).log

# View cron logs
tail -f /var/log/book-shopping/cron-deploy.log
```

### Check Service Status

```bash
# Check if service is running
sudo systemctl status book-shopping-app

# View service logs
sudo journalctl -u book-shopping-app -f
```

## Troubleshooting

### Permission Denied

```bash
# Fix script permissions
chmod +x scripts/*.sh

# Fix directory permissions
sudo chown -R deploy:deployers /var/www/book-shopping-website
```

### Build Fails

```bash
# Clear node_modules and reinstall
rm -rf node_modules .next
pnpm install
pnpm build
```

### Service Won't Start

```bash
# Check service logs
sudo journalctl -u book-shopping-app -n 50

# Test manual start
cd /var/www/book-shopping-website
pnpm start
```

## Rollback Procedure

```bash
# View deployment history
cd /var/www/book-shopping-website
git log --oneline -10

# Rollback to previous commit
git checkout <previous-commit-hash>
pnpm install
pnpm build
sudo systemctl restart book-shopping-app
```

## Backup and Recovery

Backups are automatically created in `/var/backups/book-shopping-website/`

To restore from backup:
```bash
# List available backups
ls -la /var/backups/book-shopping-website/

# Restore from backup
cp -r /var/backups/book-shopping-website/backup-YYYYMMDD-HHMMSS/.next /var/www/book-shopping-website/
sudo systemctl restart book-shopping-app
```

