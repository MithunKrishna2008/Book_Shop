#!/bin/bash

###############################################################################
# Linux User/Group Management Script
# Creates a dedicated deployment user and sets up proper permissions
###############################################################################

# Configuration
DEPLOY_USER="deploy"
DEPLOY_GROUP="deployers"
PROJECT_DIR="/var/www/book-shopping-website"
LOG_FILE="/var/log/setup-deployment-user.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $@" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $@" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $@"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $@" >> "$LOG_FILE"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

log_info "=========================================="
log_info "Setting up deployment user and permissions"
log_info "=========================================="

# Step 1: Create deployment group
log_info "Step 1: Creating deployment group '$DEPLOY_GROUP'..."
if getent group "$DEPLOY_GROUP" > /dev/null 2>&1; then
    log_warn "Group '$DEPLOY_GROUP' already exists"
else
    groupadd "$DEPLOY_GROUP"
    log_info "Group '$DEPLOY_GROUP' created successfully"
fi

# Step 2: Create deployment user
log_info "Step 2: Creating deployment user '$DEPLOY_USER'..."
if id "$DEPLOY_USER" &>/dev/null; then
    log_warn "User '$DEPLOY_USER' already exists"
else
    useradd -m -s /bin/bash -g "$DEPLOY_GROUP" "$DEPLOY_USER"
    log_info "User '$DEPLOY_USER' created successfully"
fi

# Step 3: Add user to deployers group (if not already)
log_info "Step 3: Adding user to group..."
usermod -a -G "$DEPLOY_GROUP" "$DEPLOY_USER"
log_info "User '$DEPLOY_USER' added to group '$DEPLOY_GROUP'"

# Step 4: Create project directory if it doesn't exist
log_info "Step 4: Setting up project directory..."
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
    log_info "Project directory created: $PROJECT_DIR"
else
    log_info "Project directory already exists: $PROJECT_DIR"
fi

# Step 5: Set ownership and permissions
log_info "Step 5: Setting file permissions..."
chown -R "$DEPLOY_USER:$DEPLOY_GROUP" "$PROJECT_DIR"
chmod -R 755 "$PROJECT_DIR"

# Set specific permissions for sensitive files
if [ -f "$PROJECT_DIR/.env" ]; then
    chmod 600 "$PROJECT_DIR/.env"
    log_info "Set secure permissions for .env file"
fi

# Step 6: Create log directory with proper permissions
log_info "Step 6: Setting up log directory..."
LOG_DIR="/var/log/book-shopping"
mkdir -p "$LOG_DIR"
chown "$DEPLOY_USER:$DEPLOY_GROUP" "$LOG_DIR"
chmod 755 "$LOG_DIR"
log_info "Log directory created: $LOG_DIR"

# Step 7: Create backup directory
log_info "Step 7: Setting up backup directory..."
BACKUP_DIR="/var/backups/book-shopping-website"
mkdir -p "$BACKUP_DIR"
chown "$DEPLOY_USER:$DEPLOY_GROUP" "$BACKUP_DIR"
chmod 755 "$BACKUP_DIR"
log_info "Backup directory created: $BACKUP_DIR"

# Step 8: Configure sudo permissions (optional - for service restart)
log_info "Step 8: Configuring sudo permissions..."
SUDOERS_FILE="/etc/sudoers.d/deploy-user"
cat > "$SUDOERS_FILE" << EOF
# Allow deploy user to restart services without password
$DEPLOY_USER ALL=(ALL) NOPASSWD: /bin/systemctl restart $DEPLOY_USER-*, /bin/systemctl status $DEPLOY_USER-*
EOF
chmod 440 "$SUDOERS_FILE"
log_info "Sudo permissions configured"

# Step 9: Display user information
log_info "Step 9: User information:"
echo "----------------------------------------"
id "$DEPLOY_USER"
echo "----------------------------------------"
groups "$DEPLOY_USER"
echo "----------------------------------------"

# Step 10: Display directory permissions
log_info "Step 10: Directory permissions:"
ls -ld "$PROJECT_DIR"
ls -ld "$LOG_DIR"
ls -ld "$BACKUP_DIR"

log_info "=========================================="
log_info "Setup completed successfully!"
log_info "=========================================="
log_info "Deployment user: $DEPLOY_USER"
log_info "Deployment group: $DEPLOY_GROUP"
log_info "Project directory: $PROJECT_DIR"
log_info ""
log_info "To switch to the deployment user, run:"
log_info "  sudo su - $DEPLOY_USER"
log_info ""
log_info "To verify permissions, run:"
log_info "  ls -la $PROJECT_DIR"

