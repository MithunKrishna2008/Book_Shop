#!/bin/bash

###############################################################################
# Deployment Script for Book Shopping Website
# This script automates the deployment process on a Linux server
###############################################################################

# Configuration
PROJECT_DIR="/var/www/book-shopping-website"
REPO_URL="https://github.com/MithunKrishna2008/Book_Shop.git"
BRANCH="main"
LOG_FILE="/var/log/book-shopping-deploy.log"
SERVICE_NAME="book-shopping-app"
BACKUP_DIR="/var/backups/book-shopping-website"
MAX_BACKUPS=5

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

###############################################################################
# Logging Functions
###############################################################################

log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    log "INFO" "$@"
    echo -e "${GREEN}[INFO]${NC} $@"
}

log_warn() {
    log "WARN" "$@"
    echo -e "${YELLOW}[WARN]${NC} $@"
}

log_error() {
    log "ERROR" "$@"
    echo -e "${RED}[ERROR]${NC} $@"
}

###############################################################################
# Error Handling
###############################################################################

set -e  # Exit on error
trap 'error_handler $? $LINENO' ERR

error_handler() {
    local exit_code=$1
    local line_number=$2
    log_error "Script failed at line $line_number with exit code $exit_code"
    log_error "Deployment aborted. Please check the logs: $LOG_FILE"
    exit $exit_code
}

###############################################################################
# Pre-deployment Checks
###############################################################################

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if running as correct user
    if [ "$EUID" -eq 0 ]; then
        log_warn "Running as root. Consider using a dedicated deployment user."
    fi
    
    # Check if project directory exists
    if [ ! -d "$PROJECT_DIR" ]; then
        log_error "Project directory $PROJECT_DIR does not exist"
        exit 1
    fi
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed"
        exit 1
    fi
    
    # Check if node/npm/pnpm is installed
    if ! command -v pnpm &> /dev/null; then
        log_error "pnpm is not installed"
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

###############################################################################
# Backup Current Deployment
###############################################################################

create_backup() {
    log_info "Creating backup of current deployment..."
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    # Create timestamped backup
    local backup_name="backup-$(date +%Y%m%d-%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [ -d "$PROJECT_DIR/.next" ]; then
        log_info "Backing up build files..."
        cp -r "$PROJECT_DIR/.next" "$backup_path" 2>/dev/null || true
    fi
    
    # Clean up old backups (keep only MAX_BACKUPS)
    local backup_count=$(ls -1 "$BACKUP_DIR" | wc -l)
    if [ "$backup_count" -gt "$MAX_BACKUPS" ]; then
        log_info "Cleaning up old backups..."
        ls -t "$BACKUP_DIR" | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -rf "$BACKUP_DIR/{}"
    fi
    
    log_info "Backup created: $backup_path"
}

###############################################################################
# Pull Latest Code
###############################################################################

pull_latest_code() {
    log_info "Pulling latest code from $BRANCH branch..."
    
    cd "$PROJECT_DIR"
    
    # Fetch latest changes
    git fetch origin "$BRANCH" || {
        log_error "Failed to fetch from repository"
        exit 1
    }
    
    # Check if there are local changes
    if ! git diff-index --quiet HEAD --; then
        log_warn "Local changes detected. Stashing them..."
        git stash save "Auto-stash before deployment $(date +%Y%m%d-%H%M%S)"
    fi
    
    # Pull latest code
    git pull origin "$BRANCH" || {
        log_error "Failed to pull latest code"
        exit 1
    }
    
    log_info "Successfully pulled latest code"
    log_info "Current commit: $(git rev-parse --short HEAD)"
    log_info "Commit message: $(git log -1 --pretty=%B)"
}

###############################################################################
# Install Dependencies
###############################################################################

install_dependencies() {
    log_info "Installing dependencies..."
    
    cd "$PROJECT_DIR"
    
    # Install dependencies using pnpm
    pnpm install --frozen-lockfile --production=false || {
        log_error "Failed to install dependencies"
        exit 1
    }
    
    log_info "Dependencies installed successfully"
}

###############################################################################
# Build Application
###############################################################################

build_application() {
    log_info "Building application..."
    
    cd "$PROJECT_DIR"
    
    # Set production environment
    export NODE_ENV=production
    
    # Build the application
    pnpm build || {
        log_error "Build failed"
        exit 1
    }
    
    log_info "Application built successfully"
}

###############################################################################
# Restart Services
###############################################################################

restart_services() {
    log_info "Restarting services..."
    
    # Check if service exists and restart it
    if systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
        log_info "Restarting systemd service: $SERVICE_NAME"
        sudo systemctl restart "$SERVICE_NAME" || {
            log_error "Failed to restart service"
            exit 1
        }
        
        # Wait a moment and check service status
        sleep 2
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            log_info "Service $SERVICE_NAME is running"
        else
            log_error "Service $SERVICE_NAME failed to start"
            systemctl status "$SERVICE_NAME" | tee -a "$LOG_FILE"
            exit 1
        fi
    else
        log_warn "Service $SERVICE_NAME not found. Skipping service restart."
        log_info "You may need to manually restart your application server"
    fi
}

###############################################################################
# Manage Logs
###############################################################################

manage_logs() {
    log_info "Managing log files..."
    
    # Rotate deployment log if it's too large (>10MB)
    if [ -f "$LOG_FILE" ]; then
        local log_size=$(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
        local max_size=$((10 * 1024 * 1024))  # 10MB
        
        if [ "$log_size" -gt "$max_size" ]; then
            log_info "Rotating log file (size: $log_size bytes)"
            mv "$LOG_FILE" "${LOG_FILE}.old"
            touch "$LOG_FILE"
        fi
    fi
    
    # Clean up old log files (older than 30 days)
    find /var/log -name "book-shopping-deploy*.log*" -type f -mtime +30 -delete 2>/dev/null || true
    
    log_info "Log management completed"
}

###############################################################################
# Health Check
###############################################################################

health_check() {
    log_info "Performing health check..."
    
    # Wait a bit for service to fully start
    sleep 3
    
    # Check if service is running
    if systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            log_info "Health check passed: Service is running"
        else
            log_error "Health check failed: Service is not running"
            exit 1
        fi
    else
        log_warn "Skipping health check (service not configured)"
    fi
}

###############################################################################
# Main Deployment Function
###############################################################################

main() {
    log_info "=========================================="
    log_info "Starting deployment process"
    log_info "=========================================="
    
    check_prerequisites
    create_backup
    pull_latest_code
    install_dependencies
    build_application
    restart_services
    manage_logs
    health_check
    
    log_info "=========================================="
    log_info "Deployment completed successfully!"
    log_info "=========================================="
    log_info "Deployment time: $(date)"
    log_info "Commit: $(cd $PROJECT_DIR && git rev-parse --short HEAD)"
}

# Run main function
main "$@"

