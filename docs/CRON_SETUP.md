# Cron Job Setup Guide

## Overview

Cron is a time-based job scheduler in Linux that allows you to run scripts automatically at specified intervals.

## Setting Up Automated Deployment

### Step 1: Make Script Executable

```bash
chmod +x /var/www/book-shopping-website/scripts/automated-deploy.sh
```

### Step 2: Edit Crontab

```bash
# As the deploy user
crontab -e
```

### Step 3: Add Cron Job Entry

Choose one of the following schedules:

#### Daily Deployment at 2 AM
```cron
0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

#### Every 6 Hours
```cron
0 */6 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

#### Weekdays Only (Monday-Friday at 3 AM)
```cron
0 3 * * 1-5 /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

#### Every Hour
```cron
0 * * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1
```

## Cron Syntax

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Examples

| Schedule | Cron Expression | Description |
|----------|----------------|-------------|
| Every minute | `* * * * *` | Runs every minute |
| Every hour | `0 * * * *` | Runs at the top of every hour |
| Daily at midnight | `0 0 * * *` | Runs at 00:00 every day |
| Daily at 2 AM | `0 2 * * *` | Runs at 02:00 every day |
| Weekly (Sunday) | `0 0 * * 0` | Runs at 00:00 every Sunday |
| Monthly (1st) | `0 0 1 * *` | Runs at 00:00 on the 1st of every month |
| Weekdays at 9 AM | `0 9 * * 1-5` | Runs at 09:00 Monday-Friday |
| Every 15 minutes | `*/15 * * * *` | Runs every 15 minutes |
| Every 6 hours | `0 */6 * * *` | Runs at 00:00, 06:00, 12:00, 18:00 |

## Managing Cron Jobs

### List Current Cron Jobs
```bash
crontab -l
```

### Edit Cron Jobs
```bash
crontab -e
```

### Remove All Cron Jobs
```bash
crontab -r
```

### Remove Specific Cron Job
```bash
crontab -e
# Then delete the line you want to remove
```

## Verify Cron Service

### Check Cron Status
```bash
sudo systemctl status cron
# or on some systems:
sudo systemctl status crond
```

### Start Cron Service
```bash
sudo systemctl start cron
```

### Enable Cron on Boot
```bash
sudo systemctl enable cron
```

## Viewing Cron Logs

### System Cron Logs
```bash
# On Ubuntu/Debian
sudo tail -f /var/log/syslog | grep CRON

# On CentOS/RHEL
sudo tail -f /var/log/cron
```

### Application-Specific Logs
```bash
# View deployment logs
tail -f /var/log/book-shopping/cron-deploy.log

# View specific date's log
cat /var/log/book-shopping/automated-deploy-20241123.log
```

## Troubleshooting

### Cron Job Not Running

1. **Check cron service is running**
   ```bash
   sudo systemctl status cron
   ```

2. **Check script permissions**
   ```bash
   ls -l /var/www/book-shopping-website/scripts/automated-deploy.sh
   # Should show: -rwxr-xr-x
   ```

3. **Check script path is absolute**
   - Always use full paths in cron jobs
   - Don't use `~` or relative paths

4. **Check environment variables**
   - Cron runs with minimal environment
   - Add environment variables in crontab:
   ```cron
   PATH=/usr/local/bin:/usr/bin:/bin
   SHELL=/bin/bash
   0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh
   ```

5. **Check user permissions**
   - Ensure the user running cron has necessary permissions
   - Check file ownership:
   ```bash
   ls -la /var/www/book-shopping-website
   ```

### Debugging Cron Jobs

#### Test Script Manually
```bash
# Run the script manually to check for errors
/var/www/book-shopping-website/scripts/automated-deploy.sh
```

#### Add Debugging to Cron
```cron
0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1 && echo "Deployment completed at $(date)" >> /var/log/book-shopping/cron-deploy.log
```

#### Capture All Output
```cron
0 2 * * * /bin/bash -c '/var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1'
```

## Best Practices

1. **Use absolute paths** - Never use relative paths or `~`
2. **Redirect output** - Always redirect stdout and stderr to log files
3. **Set PATH** - Explicitly set PATH in crontab if needed
4. **Test first** - Always test scripts manually before adding to cron
5. **Log everything** - Keep comprehensive logs for debugging
6. **Use appropriate user** - Run cron jobs as the deployment user, not root
7. **Handle errors** - Scripts should handle errors gracefully
8. **Avoid overlapping** - Ensure jobs don't overlap if they take time

## Example Complete Crontab

```cron
# Set environment
SHELL=/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
HOME=/home/deploy

# Daily deployment at 2 AM
0 2 * * * /var/www/book-shopping-website/scripts/automated-deploy.sh >> /var/log/book-shopping/cron-deploy.log 2>&1

# Clean old logs weekly (Sunday at 3 AM)
0 3 * * 0 find /var/log/book-shopping -name "*.log" -mtime +30 -delete >> /var/log/book-shopping/cleanup.log 2>&1
```

## Security Considerations

1. **File Permissions** - Ensure scripts are not world-writable
2. **User Isolation** - Run cron jobs as non-root user when possible
3. **Secure Logs** - Protect log files from unauthorized access
4. **Input Validation** - Validate all inputs in scripts
5. **Error Handling** - Don't expose sensitive information in logs

