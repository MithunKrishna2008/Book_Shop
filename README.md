# Book shopping website

*Automatically synced with your [v0.app](https://v0.app) deployments*

[![Deployed on Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?style=for-the-badge&logo=vercel)](https://vercel.com/prassanths-projects/v0-book-shopping-website)
[![Built with v0](https://img.shields.io/badge/Built%20with-v0.app-black?style=for-the-badge)](https://v0.app/chat/p5DQBTz1kCo)

## Overview

This repository will stay in sync with your deployed chats on [v0.app](https://v0.app).
Any changes you make to your deployed app will be automatically pushed to this repository from [v0.app](https://v0.app).

## Deployment

Your project is live at:

**[https://vercel.com/prassanths-projects/v0-book-shopping-website](https://vercel.com/prassanths-projects/v0-book-shopping-website)**

## Build your app

Continue building your app on:

**[https://v0.app/chat/p5DQBTz1kCo](https://v0.app/chat/p5DQBTz1kCo)**

## How It Works

1. Create and modify your project using [v0.app](https://v0.app)
2. Deploy your chats from the v0 interface
3. Changes are automatically pushed to this repository
4. Vercel deploys the latest version from this repository

## Deployment Automation

This project includes comprehensive deployment automation using Git, GitHub Actions, and Linux shell scripting.

### Quick Links

- **[Assignment Report](./ASSIGNMENT_REPORT.md)** - Complete assignment documentation
- **[Deployment Guide](./docs/DEPLOYMENT_GUIDE.md)** - Step-by-step deployment instructions
- **[Git Workflow Guide](./docs/GIT_WORKFLOW.md)** - Git branching and workflow practices

### Features

- ✅ **Git Flow Branching Strategy** - Structured branch management
- ✅ **GitHub Actions CI/CD** - Automated testing, building, and deployment
- ✅ **Linux Deployment Scripts** - Automated server deployment
- ✅ **User/Group Management** - Secure deployment user setup
- ✅ **Cron Automation** - Scheduled automatic deployments
- ✅ **Log Management** - Comprehensive logging and monitoring

### Scripts

- `scripts/deploy.sh` - Main deployment script
- `scripts/setup-deployment-user.sh` - User/group setup
- `scripts/automated-deploy.sh` - Automated deployment for cron

### GitHub Actions

The CI/CD pipeline (`.github/workflows/ci-cd.yml`) includes:
- Dependency installation
- Code linting
- Application building
- Automated testing
- Production deployment

See [ASSIGNMENT_REPORT.md](./ASSIGNMENT_REPORT.md) for complete documentation.