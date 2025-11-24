#!/bin/bash

###############################################################################
# Automated Deployment Script with Logging
# This script can be scheduled via cron for automatic deployments
###############################################################################

# Configuration
PROJECT_DIR="/var/www/book-shopping-website"
REPO_URL="https://github.com/MithunKrishna2008/Book_Shop.git"
BRANCH="main"
LOG_DIR="/var/log/book-shopping"
LOG_FILE="$LOG_DIR/automated-deploy-$(date +%Y%m%d).log"
DEPLOY_USER="deploy"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Ensure log directory exists
mkdir -p "$LOG_DIR"

###############################################################################
# Logging Functions
###############################################################################

log() {
    local level=$1
    shift
    local message="$@"
    echo "[$TIMESTAMP] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    log "INFO" "$@"
}

log_error() {
    log "ERROR" "$@"
}

log_warn() {
    log "WARN" "$@"
}

###############################################################################
# Main Deployment Steps
###############################################################################

main() {
    log_info "=========================================="
    log_info "Starting automated deployment"
    log_info "=========================================="
    
    # Change to project directory
    cd "$PROJECT_DIR" || {
        log_error "Failed to change to project directory: $PROJECT_DIR"
        exit 1
    }
    
    # Step 1: Pull latest code
    log_info "Step 1: Pulling latest code from $BRANCH..."
    git fetch origin "$BRANCH" >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to fetch from repository"
        exit 1
    }
    
    # Check if there are updates
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/$BRANCH)
    
    if [ "$LOCAL" = "$REMOTE" ]; then
        log_info "No updates available. Already up to date."
        exit 0
    fi
    
    log_info "Updates detected. Pulling changes..."
    git pull origin "$BRANCH" >> "$LOG_FILE" 2>&1 || {
        log_error "Failed to pull latest code"
        exit 1
    }
    
    log_info "Code updated successfully"
    log_info "Previous commit: $LOCAL"
    log_info "New commit: $REMOTE"
    
    # Step 2: Install dependencies
    log_info "Step 2: Installing dependencies..."
    if command -v pnpm &> /dev/null; then
        pnpm install --frozen-lockfile >> "$LOG_FILE" 2>&1 || {
            log_error "Failed to install dependencies"
            exit 1
        }
    elif command -v npm &> /dev/null; then
        npm ci >> "$LOG_FILE" 2>&1 || {
            log_error "Failed to install dependencies"
            exit 1
        }
    else
        log_error "Neither pnpm nor npm is available"
        exit 1
    fi
    log_info "Dependencies installed"
    
    # Step 3: Build project
    log_info "Step 3: Building project..."
    export NODE_ENV=production
    
    if command -v pnpm &> /dev/null; then
        pnpm build >> "$LOG_FILE" 2>&1 || {
            log_error "Build failed"
            exit 1
        }
    elif command -v npm &> /dev/null; then
        npm run build >> "$LOG_FILE" 2>&1 || {
            log_error "Build failed"
            exit 1
        }
    fi
    log_info "Build completed successfully"
    
    # Step 4: Restart services (if systemd service exists)
    log_info "Step 4: Checking for services to restart..."
    SERVICE_NAME="book-shopping-app"
    if systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
        log_info "Restarting service: $SERVICE_NAME"
        sudo systemctl restart "$SERVICE_NAME" >> "$LOG_FILE" 2>&1 || {
            log_error "Failed to restart service"
            exit 1
        }
        log_info "Service restarted successfully"
    else
        log_warn "Service $SERVICE_NAME not found. Manual restart may be required."
    fi
    
    # Step 5: Log operations summary
    log_info "Step 5: Deployment summary"
    log_info "Deployment completed at: $TIMESTAMP"
    log_info "Deployed commit: $(git rev-parse --short HEAD)"
    log_info "Commit message: $(git log -1 --pretty=%B)"
    
    log_info "=========================================="
    log_info "Automated deployment completed successfully!"
    log_info "=========================================="
}

# Run main function
main "$@"

