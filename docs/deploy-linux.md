# Deployment Guide for TechCorp Solutions

This guide provides step-by-step instructions for deploying TechCorp Solutions to a Linux server.

## Prerequisites

- Linux server (Ubuntu 20.04 LTS or newer recommended)
- Root or sudo access
- Domain name (optional, for production with SSL)
- MySQL 8.0 or compatible database

## Server Preparation

### 1. Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Install Node.js 18.x

```bash
# Install Node.js from NodeSource
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version  # Should show v18.x.x
npm --version
```

### 3. Install MySQL

```bash
# Install MySQL server
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql_secure_installation
# Follow prompts to set root password and secure installation
```

### 4. Install PM2

```bash
# Install PM2 globally
sudo npm install -g pm2

# Verify installation
pm2 --version
```

### 5. Install Git

```bash
sudo apt install -y git
```

## Database Setup

### 1. Create Database and User

```bash
# Login to MySQL
sudo mysql -u root -p

# Create database
CREATE DATABASE company_db;

# Create user (replace 'password' with a strong password)
CREATE USER 'techcorp'@'localhost' IDENTIFIED BY 'your_secure_password';

# Grant privileges
GRANT ALL PRIVILEGES ON company_db.* TO 'techcorp'@'localhost';
FLUSH PRIVILEGES;

# Exit MySQL
EXIT;
```

### 2. Test Database Connection

```bash
mysql -u techcorp -p company_db
# Enter password when prompted
# If successful, you'll see mysql> prompt
EXIT;
```

## Application Deployment

### 1. Clone Repository

```bash
# Navigate to home directory
cd ~

# Clone the repository
git clone https://github.com/MI804-png/webprogramming_with_lilla.git

# Navigate to project directory
cd webprogramming_with_lilla
```

### 2. Install Dependencies

```bash
# Install production dependencies
npm ci --production
```

### 3. Configure Environment

```bash
# Copy example environment file
cp .env.production.example .env

# Edit environment file
nano .env
```

Set the following variables in `.env`:

```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=techcorp
DB_PASS=your_secure_password
DB_NAME=company_db

SESSION_SECRET=generate_random_secret_here
# Generate with: openssl rand -base64 32

PORT=3000
NODE_ENV=production
```

Save and exit (Ctrl+X, Y, Enter in nano).

### 4. Import Database Schema

```bash
# Method 1: Direct import
mysql -u techcorp -p company_db < company_db.sql

# Method 2: Using the import script
export DB_HOST=localhost
export DB_PORT=3306
export DB_USER=techcorp
export DB_PASS=your_secure_password
export DB_NAME=company_db
chmod +x scripts/import-db.sh
./scripts/import-db.sh
```

### 5. Test Application

```bash
# Start application manually for testing
node start.js

# In another terminal, test the health endpoint
curl http://localhost:3000/health

# Should return: {"status":"ok","timestamp":"...","uptime":...,"db":true}

# Stop the test (Ctrl+C)
```

## PM2 Process Management

### 1. Start Application with PM2

```bash
# Start application using ecosystem config
pm2 start ecosystem.config.js

# Check status
pm2 list
```

### 2. Configure PM2 Startup

```bash
# Generate startup script
pm2 startup

# The command will output a command to run with sudo
# Copy and run that command, it will look like:
# sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u username --hp /home/username

# Save PM2 process list
pm2 save
```

### 3. PM2 Management Commands

```bash
# View logs
pm2 logs techcorp-solutions

# Restart application
pm2 restart techcorp-solutions

# Stop application
pm2 stop techcorp-solutions

# Monitor resources
pm2 monit

# View detailed info
pm2 info techcorp-solutions
```

## Nginx Reverse Proxy (Optional)

### 1. Install Nginx

```bash
sudo apt install -y nginx
```

### 2. Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/techcorp
```

Add the following configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### 3. Enable Site

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/techcorp /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

## SSL/TLS with Let's Encrypt (Optional)

### 1. Install Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
```

### 2. Obtain SSL Certificate

```bash
# Obtain and install certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Follow prompts to configure SSL
```

### 3. Auto-Renewal

```bash
# Test auto-renewal
sudo certbot renew --dry-run

# Certbot automatically sets up a cron job for renewal
```

## Firewall Configuration

```bash
# Enable UFW firewall
sudo ufw enable

# Allow SSH (important!)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Check status
sudo ufw status
```

## Automated Deployment with GitHub Actions

### 1. Generate SSH Key

```bash
# On your server, generate SSH key
ssh-keygen -t rsa -b 4096 -C "github-actions"

# Display public key
cat ~/.ssh/id_rsa.pub

# Add this public key to ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Display private key (for GitHub secret)
cat ~/.ssh/id_rsa
# Copy the entire private key including BEGIN and END lines
```

### 2. Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:

| Secret Name | Value |
|------------|-------|
| SSH_HOST | Your server IP or domain |
| SSH_USER | Your username (e.g., ubuntu) |
| SSH_PORT | 22 |
| SSH_KEY | Your private SSH key (entire content) |
| DB_HOST | localhost |
| DB_PORT | 3306 |
| DB_USER | techcorp |
| DB_PASS | your_database_password |
| DB_NAME | company_db |

### 3. Deploy from GitHub

1. Go to Actions tab
2. Select "Deploy to Linux Server"
3. Click "Run workflow"
4. Select branch (main)
5. Click "Run workflow"

The workflow will automatically deploy your application.

## Monitoring and Maintenance

### View Logs

```bash
# PM2 logs
pm2 logs techcorp-solutions

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# System logs
sudo journalctl -u nginx -f
```

### Database Backup

```bash
# Create backup script
cat > ~/backup-db.sh << 'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

mysqldump -u techcorp -p'your_password' company_db > $BACKUP_DIR/company_db_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "company_db_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/company_db_$DATE.sql"
EOF

chmod +x ~/backup-db.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * ~/backup-db.sh") | crontab -
```

### Update Application

```bash
# Navigate to project directory
cd ~/webprogramming_with_lilla

# Pull latest changes
git pull origin main

# Install/update dependencies
npm ci --production

# Restart PM2
pm2 restart techcorp-solutions
```

## Troubleshooting

### Application Won't Start

```bash
# Check PM2 logs
pm2 logs techcorp-solutions --err

# Check if port is in use
sudo lsof -i :3000

# Verify environment variables
pm2 env techcorp-solutions
```

### Database Connection Issues

```bash
# Test database connection
mysql -h localhost -u techcorp -p company_db

# Check MySQL status
sudo systemctl status mysql

# Restart MySQL
sudo systemctl restart mysql
```

### Nginx Issues

```bash
# Test Nginx configuration
sudo nginx -t

# Check Nginx status
sudo systemctl status nginx

# Restart Nginx
sudo systemctl restart nginx
```

### Permission Issues

```bash
# Fix file permissions
chmod -R 755 ~/webprogramming_with_lilla
chmod -R 777 ~/webprogramming_with_lilla/public/uploads
```

## Security Checklist

- [ ] Firewall configured (UFW)
- [ ] SSH key authentication enabled
- [ ] Password authentication disabled (optional)
- [ ] MySQL secured with strong passwords
- [ ] SSL/TLS certificate installed
- [ ] Environment variables secured
- [ ] Regular backups configured
- [ ] Log monitoring enabled
- [ ] Dependencies up to date

## Support

For issues and questions:
- Check the [Documentation](docs/Documentation-Full.md)
- Review [SECURITY.md](SECURITY.md)
- Open an issue on GitHub
- Contact: admin@techcorp.com

---

Last Updated: 2025-10-18
