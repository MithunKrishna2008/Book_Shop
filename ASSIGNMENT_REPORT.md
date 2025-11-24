# Assignment Report: End-to-End Deployment Automation

## Assignment Title-1: End-to-End Deployment Automation

---

## 1. Branching Strategy Design

### Chosen Strategy: **Git Flow**

I have chosen **Git Flow** as the branching strategy for this microservice-based application. Git Flow is a branching model that provides a robust framework for managing features, releases, and hotfixes in a structured manner.

### Justification for Git Flow:

1. **Structured Release Management**: Git Flow provides dedicated branches for releases (`release/*`), allowing teams to prepare, test, and stabilize releases before merging to production.

2. **Feature Isolation**: Each feature is developed in its own branch (`feature/*`), preventing conflicts and allowing parallel development.

3. **Production Stability**: The `main` branch always contains production-ready code, while `develop` serves as the integration branch for ongoing development.

4. **Hotfix Support**: The `hotfix/*` branches enable quick fixes to production without disrupting ongoing development.

5. **Automated Deployment Compatibility**: 
   - `main` branch triggers production deployments
   - `develop` branch triggers staging deployments
   - Feature branches can trigger preview deployments
   - This aligns perfectly with CI/CD pipeline automation

6. **Team Collaboration**: Multiple developers can work on different features simultaneously without interfering with each other.

### Branch Structure:

```
main (production)
  ├── develop (integration)
  │   ├── feature/user-authentication
  │   ├── feature/payment-integration
  │   └── feature/search-functionality
  ├── release/v1.2.0
  └── hotfix/critical-bug-fix
```

### Comparison with Other Strategies:

- **Trunk-Based Development**: While simpler, it requires more discipline and can be risky for microservices with multiple teams.
- **Feature Branching**: Less structured than Git Flow, doesn't provide clear release management.

---

## 2. Git Workflow Implementation

### Complete Workflow: Commit → Push → Pull Request → Merge → Deployment

#### Step 1: Commit
```bash
# Create a feature branch
git checkout -b feature/new-book-catalog

# Make changes to files
# ... edit files ...

# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: Add new book catalog with filtering"
```

**Best Practices:**
- Use conventional commit messages (feat:, fix:, docs:, etc.)
- Write clear, descriptive commit messages
- Commit frequently with logical units of work

#### Step 2: Push
```bash
# Push feature branch to remote
git push origin feature/new-book-catalog
```

#### Step 3: Pull Request
- Create a Pull Request on GitHub from `feature/new-book-catalog` to `develop`
- Add reviewers
- Link related issues
- Wait for CI/CD checks to pass
- Get code review approval

#### Step 4: Merge
```bash
# After PR approval, merge via GitHub UI or:
git checkout develop
git pull origin develop
git merge feature/new-book-catalog
git push origin develop
```

#### Step 5: Deployment
- Merging to `develop` triggers staging deployment
- Merging to `main` triggers production deployment (via GitHub Actions)

### Git Commands for Clean History

#### Rebase
**Purpose**: Maintains a linear, clean commit history by replaying commits on top of the target branch.

```bash
# Interactive rebase to clean up commits
git rebase -i develop

# Rebase feature branch onto latest develop
git checkout feature/new-feature
git rebase develop
```

**Benefits:**
- Creates linear history
- Allows squashing commits
- Removes unnecessary merge commits
- Makes history easier to read

#### Fetch
**Purpose**: Downloads changes from remote without merging them into local branches.

```bash
# Fetch all remote branches
git fetch origin

# Fetch specific branch
git fetch origin develop

# Check what changed
git log HEAD..origin/develop
```

**Benefits:**
- Safe operation (doesn't modify working directory)
- Allows inspection before merging
- Updates remote-tracking branches
- Can be done frequently without risk

#### Merge
**Purpose**: Combines changes from one branch into another, preserving branch history.

```bash
# Merge develop into feature branch
git checkout feature/new-feature
git merge develop

# Merge feature into develop
git checkout develop
git merge feature/new-feature
```

**Benefits:**
- Preserves complete history
- Shows branch relationships
- Safe for shared branches
- Creates merge commits for tracking

### Workflow Diagram:

```
Developer                    GitHub                    CI/CD Pipeline
    |                          |                            |
    |-- Create Feature Branch--|                            |
    |                          |                            |
    |-- Commit Changes --------|                            |
    |                          |                            |
    |-- Push to Remote ------->|                            |
    |                          |                            |
    |-- Create Pull Request -->|                            |
    |                          |-- Trigger CI Checks ------->|
    |                          |                            |
    |<-- Code Review ----------|                            |
    |                          |                            |
    |-- Approve & Merge ------>|                            |
    |                          |-- Trigger Deployment ------>|
    |                          |                            |
    |<-- Deployment Status <----|<-- Deployment Complete <----|
```

---

## 3. GitHub Actions Pipeline Setup

### CI/CD Workflow Overview

The GitHub Actions workflow (`/.github/workflows/ci-cd.yml`) implements a comprehensive CI/CD pipeline with the following stages:

#### Stage 1: Install Dependencies
```yaml
install-dependencies:
  - Checkout code
  - Setup Node.js (v20.x)
  - Install pnpm (v8)
  - Install project dependencies
  - Cache dependencies for faster subsequent runs
```

**Purpose**: Ensures all required packages are available for subsequent stages.

**Benefits**:
- Caching reduces build time
- Consistent environment across runs
- Early detection of dependency issues

#### Stage 2: Lint Code
```yaml
lint:
  - Checkout code
  - Setup environment
  - Install dependencies
  - Run ESLint
```

**Purpose**: Validates code quality and style consistency.

**Benefits**:
- Catches syntax errors early
- Enforces coding standards
- Prevents style inconsistencies

#### Stage 3: Build Application
```yaml
build:
  - Checkout code
  - Setup environment
  - Install dependencies
  - Build Next.js application
  - Upload build artifacts
```

**Purpose**: Compiles the application and creates production-ready artifacts.

**Benefits**:
- Validates that code compiles
- Creates deployable artifacts
- Stores builds for deployment

#### Stage 4: Run Tests
```yaml
test:
  - Checkout code
  - Setup environment
  - Install dependencies
  - Execute test suite
```

**Purpose**: Validates application functionality through automated tests.

**Benefits**:
- Ensures code quality
- Prevents regressions
- Validates functionality

#### Stage 5: Deploy to Production
```yaml
deploy:
  - Checkout code
  - Setup environment
  - Install dependencies
  - Build application
  - Deploy to server (SSH/API)
```

**Purpose**: Automatically deploys to production when code is merged to `main`.

**Benefits**:
- Zero-downtime deployments
- Automated process
- Consistent deployment steps

### Workflow Triggers:

- **Push to `main`**: Triggers full pipeline + production deployment
- **Push to `develop`**: Triggers full pipeline (no production deployment)
- **Pull Request**: Triggers CI checks only (lint, build, test)

### Pipeline Flow:

```
Push/PR Event
    |
    v
Install Dependencies (parallel)
    |
    +---> Lint
    |
    +---> Build
    |
    +---> Test
    |
    v
Deploy (only on main branch)
```

---

## 4. Linux Deployment Automation

### Shell Script: `scripts/deploy.sh`

The deployment script automates the complete deployment process on a Linux server.

#### Key Features:

1. **Pull Latest Code**
   - Fetches latest changes from repository
   - Handles local changes (stashing)
   - Pulls from specified branch

2. **Restart Services**
   - Checks for systemd service
   - Restarts application service
   - Verifies service status
   - Performs health checks

3. **Manage Logs**
   - Rotates logs when they exceed size limits
   - Cleans up old log files
   - Maintains deployment history

4. **Backup Management**
   - Creates timestamped backups
   - Maintains backup rotation
   - Preserves previous deployments

#### Script Execution:

```bash
# Make script executable
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

### File Permissions, Users, and Groups

#### Security Model:

1. **Dedicated Deployment User**
   ```bash
   # Create deployment user
   sudo useradd -m -s /bin/bash deploy
   sudo groupadd deployers
   sudo usermod -a -G deployers deploy
   ```

2. **Directory Permissions**
   ```bash
   # Project directory: Read/Write for deploy user, Read for group
   chmod 755 /var/www/book-shopping-website
   chown deploy:deployers /var/www/book-shopping-website
   ```

3. **Sensitive Files Protection**
   ```bash
   # .env file: Read/Write for owner only
   chmod 600 .env
   chown deploy:deployers .env
   ```

4. **Log Files**
   ```bash
   # Log directory: Write for deploy user
   chmod 755 /var/log/book-shopping
   chown deploy:deployers /var/log/book-shopping
   ```

#### Permission Structure:

```
/var/www/book-shopping-website/
├── Owner: deploy (rwx)
├── Group: deployers (r-x)
└── Others: (r-x)

.env
├── Owner: deploy (rw-)
├── Group: deployers (---)
└── Others: (---)

/var/log/book-shopping/
├── Owner: deploy (rwx)
├── Group: deployers (r-x)
└── Others: (r-x)
```

#### Benefits:

- **Principle of Least Privilege**: Deployment user has only necessary permissions
- **Separation of Concerns**: Different users for different operations
- **Audit Trail**: All operations logged with user identification
- **Security**: Sensitive files protected from unauthorized access

---

## Assignment Title-2: End-to-End Mini-Project Workflow

---

## 1. Repository Setup & Version Control

### Step 1: Initialize Git Repository

```bash
# Initialize repository
git init

# Configure user
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Create initial commit
git add .
git commit -m "Initial commit: Book shopping website setup"
```

### Step 2: Create Multiple Versions (3+ commits)

```bash
# Version 1: Initial setup
git commit -m "feat: Initial project setup with Next.js"

# Version 2: Add components
git add components/
git commit -m "feat: Add book grid and cart components"

# Version 3: Add deployment scripts
git add scripts/
git commit -m "feat: Add deployment automation scripts"
```

### Step 3: Create Feature Branch

```bash
# Create and switch to feature branch
git checkout -b feature/user-authentication

# Make changes
# ... edit files ...

# Commit changes
git add .
git commit -m "feat: Add user authentication feature"
```

### Step 4: Merge Feature Branch

**Option A: Merge (preserves branch history)**
```bash
git checkout main
git merge feature/user-authentication
```

**Option B: Rebase (linear history)**
```bash
git checkout feature/user-authentication
git rebase main
git checkout main
git merge feature/user-authentication
```

### Step 5: GitHub Integration

```bash
# Add remote repository
git remote add origin https://github.com/MithunKrishna2008/Book_Shop.git

# Push main branch
git push -u origin main

# Push feature branch
git push origin feature/user-authentication

# Fetch latest changes
git fetch origin

# Pull changes
git pull origin main

# Clone repository (on another machine)
git clone https://github.com/MithunKrishna2008/Book_Shop.git
```

---

## 2. Linux User/Group Management

### Step 1: Create Deployment User

```bash
# Create user with home directory and bash shell
sudo useradd -m -s /bin/bash deploy

# Create group
sudo groupadd deployers

# Add user to group
sudo usermod -a -G deployers deploy
```

### Step 2: Set Permissions

```bash
# Create project directory
sudo mkdir -p /var/www/book-shopping-website

# Set ownership
sudo chown -R deploy:deployers /var/www/book-shopping-website

# Set permissions (755 = rwxr-xr-x)
sudo chmod -R 755 /var/www/book-shopping-website
```

### Linux Commands Demonstrated:

1. **`useradd`**: Create new user
   ```bash
   sudo useradd -m -s /bin/bash deploy
   ```

2. **`groupadd`**: Create new group
   ```bash
   sudo groupadd deployers
   ```

3. **`usermod`**: Modify user (add to group)
   ```bash
   sudo usermod -a -G deployers deploy
   ```

4. **`chown`**: Change file ownership
   ```bash
   sudo chown deploy:deployers /var/www/book-shopping-website
   ```

5. **`chmod`**: Change file permissions
   ```bash
   sudo chmod 755 /var/www/book-shopping-website
   ```

6. **`id`**: Display user and group IDs
   ```bash
   id deploy
   ```

7. **`groups`**: Display user's groups
   ```bash
   groups deploy
   ```

8. **`ls -l`**: List files with permissions
   ```bash
   ls -la /var/www/book-shopping-website
   ```

---

## 3. Shell Scripting & Automation

### Deployment Script: `scripts/automated-deploy.sh`

The script performs:
1. Pulls latest code from GitHub
2. Installs/updates dependencies
3. Builds the project
4. Restarts services
5. Logs all operations

### Cron Job Setup

```bash
# Edit crontab
crontab -e

# Add entry for daily deployment at 2 AM
0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1

# Or for every 6 hours
0 */6 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1

# Or on specific days (Monday-Friday at 3 AM)
0 3 * * 1-5 /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

### Cron Syntax:
```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Verify Cron Job:

```bash
# List current cron jobs
crontab -l

# Check cron service status
sudo systemctl status cron
```

---

## 4. Documentation & Screenshots

### Terminal Output Examples:

#### Git Workflow:
```bash
$ git log --oneline --graph --all
*   a1b2c3d (HEAD -> main) Merge feature/user-authentication
|\
| * d4e5f6g (feature/user-authentication) feat: Add user authentication
* | h7i8j9k feat: Add deployment scripts
|/
* k0l1m2n feat: Add book grid and cart components
* m3n4o5p feat: Initial project setup
```

#### User Management:
```bash
$ id deploy
uid=1001(deploy) gid=1001(deployers) groups=1001(deployers)

$ ls -la /var/www/book-shopping-website
drwxr-xr-x 5 deploy deployers 4096 Nov 23 10:00 .
drwxr-xr-x 3 root   root     4096 Nov 23 09:00 ..
-rw-r--r-- 1 deploy deployers 1234 Nov 23 10:00 package.json
```

#### Deployment Log:
```bash
$ tail -f /var/log/book-shopping/automated-deploy-20241123.log
[2024-11-23 02:00:01] [INFO] Starting automated deployment
[2024-11-23 02:00:02] [INFO] Pulling latest code from main...
[2024-11-23 02:00:05] [INFO] Code updated successfully
[2024-11-23 02:00:10] [INFO] Installing dependencies...
[2024-11-23 02:01:30] [INFO] Dependencies installed
[2024-11-23 02:01:31] [INFO] Building project...
[2024-11-23 02:02:45] [INFO] Build completed successfully
[2024-11-23 02:02:46] [INFO] Restarting service: book-shopping-app
[2024-11-23 02:02:48] [INFO] Deployment completed successfully!
```

---

## Reflection: How Git + GitHub + Linux Improve Deployment Workflows

### 1. **Version Control & Collaboration**
- **Git** enables multiple developers to work simultaneously without conflicts
- **Branching** allows safe experimentation and feature development
- **History** provides audit trail and rollback capability

### 2. **Automation & Consistency**
- **GitHub Actions** automates testing, building, and deployment
- **Shell Scripts** ensure consistent deployment steps
- **Cron Jobs** enable scheduled deployments without manual intervention

### 3. **Security & Access Control**
- **Linux Users/Groups** enforce principle of least privilege
- **File Permissions** protect sensitive data
- **GitHub** provides access control and code review

### 4. **Reliability & Recovery**
- **Backups** created automatically before deployments
- **Logging** provides visibility into deployment process
- **Rollback** capability through Git history

### 5. **Efficiency & Speed**
- **CI/CD Pipeline** catches issues early
- **Automated Testing** prevents broken deployments
- **Parallel Jobs** reduce deployment time

### 6. **Scalability**
- **Microservices** can be deployed independently
- **Multiple Environments** (dev, staging, prod) managed easily
- **Infrastructure as Code** principles applied

### Conclusion:

The combination of **Git** (version control), **GitHub** (collaboration platform), and **Linux** (deployment environment) creates a robust, secure, and efficient deployment workflow. This integration enables:

- **Faster deployments** through automation
- **Higher quality** through automated testing
- **Better security** through proper access controls
- **Improved collaboration** through code review
- **Easier maintenance** through logging and monitoring

This workflow is essential for modern software development and deployment practices, especially in microservice architectures where multiple services need coordinated deployment.

---

## Files Created:

1. `.github/workflows/ci-cd.yml` - GitHub Actions CI/CD pipeline
2. `scripts/deploy.sh` - Main deployment script
3. `scripts/setup-deployment-user.sh` - User/group setup script
4. `scripts/automated-deploy.sh` - Automated deployment script for cron
5. `ASSIGNMENT_REPORT.md` - Complete assignment documentation

## Next Steps:

1. Configure GitHub repository and push code
2. Set up GitHub Actions secrets (SSH keys, server credentials)
3. Run `setup-deployment-user.sh` on Linux server
4. Configure cron job for automated deployments
5. Test the complete workflow end-to-end

