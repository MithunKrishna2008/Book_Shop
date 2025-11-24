# Quick Start Guide

## For Assignment Submission

This guide provides quick commands and steps to demonstrate the assignment requirements.

## Assignment 1: End-to-End Deployment Automation

### 1. Branching Strategy

**Chosen Strategy**: Git Flow

**Justification**: See [ASSIGNMENT_REPORT.md](./ASSIGNMENT_REPORT.md#1-branching-strategy-design)

### 2. Git Workflow Demonstration

```bash
# Initialize repository (if not already done)
git init
git add .
git commit -m "Initial commit"

# Create feature branch
git checkout -b feature/demo-feature

# Make changes and commit
echo "# New Feature" >> FEATURE.md
git add FEATURE.md
git commit -m "feat: Add demo feature"

# Push to remote
git push origin feature/demo-feature

# Merge back to main
git checkout main
git merge feature/demo-feature
git push origin main
```

### 3. GitHub Actions Pipeline

The CI/CD pipeline is configured in `.github/workflows/ci-cd.yml`

**Stages**:
1. Install Dependencies
2. Lint Code
3. Build Application
4. Run Tests
5. Deploy to Production

**To trigger**: Push to `main` or `develop` branch, or create a Pull Request

### 4. Linux Deployment Script

```bash
# Make executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

**What it does**:
- Pulls latest code
- Installs dependencies
- Builds application
- Restarts services
- Manages logs
- Creates backups

## Assignment 2: End-to-End Mini-Project

### 1. Repository Setup

```bash
# Initialize repository
git init

# Create 3+ commits
git add .
git commit -m "feat: Initial setup"
git add components/
git commit -m "feat: Add components"
git add scripts/
git commit -m "feat: Add deployment scripts"

# Create feature branch
git checkout -b feature/user-auth
git add .
git commit -m "feat: Add user authentication"

# Merge feature branch
git checkout main
git merge feature/user-auth

# Push to GitHub
git remote add origin https://github.com/MithunKrishna2008/Book_Shop.git
git push -u origin main
```

### 2. Linux User/Group Management

```bash
# Run setup script (as root)
sudo bash scripts/setup-deployment-user.sh
```

**Commands demonstrated**:
1. `useradd` - Create user
2. `groupadd` - Create group
3. `usermod` - Add user to group
4. `chown` - Change ownership
5. `chmod` - Change permissions
6. `id` - Show user info
7. `groups` - Show user groups
8. `ls -l` - List with permissions

### 3. Shell Scripting & Automation

```bash
# Make script executable
chmod +x scripts/automated-deploy.sh

# Test manually
./scripts/automated-deploy.sh

# Set up cron job
crontab -e
# Add: 0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

### 4. Documentation

All documentation is available in:
- [ASSIGNMENT_REPORT.md](./ASSIGNMENT_REPORT.md) - Complete assignment report
- [docs/DEPLOYMENT_GUIDE.md](./docs/DEPLOYMENT_GUIDE.md) - Deployment instructions
- [docs/GIT_WORKFLOW.md](./docs/GIT_WORKFLOW.md) - Git workflow guide
- [docs/CRON_SETUP.md](./docs/CRON_SETUP.md) - Cron job setup

## Screenshot Checklist

For assignment submission, capture screenshots of:

1. ✅ Git repository initialization
2. ✅ Multiple commits (git log)
3. ✅ Feature branch creation
4. ✅ Merge/rebase operation
5. ✅ Push to GitHub
6. ✅ User/group creation (id, groups commands)
7. ✅ File permissions (ls -l output)
8. ✅ Deployment script execution
9. ✅ Cron job entry (crontab -l)
10. ✅ GitHub Actions workflow run
11. ✅ Deployment logs

## Terminal Commands Summary

### Git Commands
```bash
git init                    # Initialize repository
git add .                   # Stage changes
git commit -m "message"     # Commit changes
git checkout -b branch      # Create and switch branch
git merge branch            # Merge branch
git rebase branch           # Rebase branch
git push origin branch      # Push to remote
git pull origin branch      # Pull from remote
git fetch origin            # Fetch from remote
git clone <url>             # Clone repository
git log --oneline --graph   # View commit history
```

### Linux User/Group Commands
```bash
sudo useradd -m user        # Create user
sudo groupadd group         # Create group
sudo usermod -a -G group user  # Add user to group
sudo chown user:group file  # Change ownership
sudo chmod 755 file         # Change permissions
id user                     # Show user info
groups user                 # Show user groups
ls -la                      # List with permissions
```

### Deployment Commands
```bash
chmod +x script.sh          # Make executable
./script.sh                 # Run script
sudo systemctl restart service  # Restart service
tail -f logfile.log         # View logs
crontab -e                  # Edit cron jobs
crontab -l                  # List cron jobs
```

## File Structure

```
v0-book-shopping-website/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # GitHub Actions CI/CD
├── scripts/
│   ├── deploy.sh                  # Main deployment script
│   ├── setup-deployment-user.sh   # User/group setup
│   └── automated-deploy.sh        # Automated deployment
├── docs/
│   ├── DEPLOYMENT_GUIDE.md        # Deployment guide
│   ├── GIT_WORKFLOW.md            # Git workflow
│   └── CRON_SETUP.md              # Cron setup
├── ASSIGNMENT_REPORT.md           # Complete assignment report
├── QUICK_START.md                 # This file
└── README.md                      # Project README
```

## Next Steps

1. Review [ASSIGNMENT_REPORT.md](./ASSIGNMENT_REPORT.md) for complete documentation
2. Follow [docs/DEPLOYMENT_GUIDE.md](./docs/DEPLOYMENT_GUIDE.md) for server setup
3. Test the deployment scripts on a Linux server
4. Configure GitHub Actions with your repository
5. Set up cron jobs for automated deployment
6. Capture screenshots for submission

