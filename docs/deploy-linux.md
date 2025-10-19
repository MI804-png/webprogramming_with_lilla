# Linux Server Deployment Guide

## Prerequisites

- Linux server (Ubuntu 20.04+ or similar)
- Node.js 18.x or higher
- MySQL 8.0+
- PM2 (for process management)
- Git
- Nginx (optional, for reverse proxy)

## Installation Steps

### 1. Install Node.js

```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### 2. Install MySQL

```bash
sudo apt update
sudo apt install mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Create database and user
sudo mysql -u root -p
```

In MySQL:
```sql
CREATE DATABASE company_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'techcorp_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON company_db.* TO 'techcorp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3. Install PM2

```bash
sudo npm install -g pm2
```

### 4. Clone Repository

```bash
cd ~
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla
```

### 5. Install Dependencies

```bash
npm ci --production
```

### 6. Configure Environment

```bash
cp .env.production.example .env
nano .env
```

Edit `.env` with your actual values:
```
DB_HOST=localhost
DB_PORT=3306
DB_USER=techcorp_user
DB_PASS=secure_password
DB_NAME=company_db
SESSION_SECRET=generate_random_string_here
PORT=3000
NODE_ENV=production
```

To generate a secure SESSION_SECRET:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 7. Import Database

```bash
chmod +x scripts/import-db.sh
./scripts/import-db.sh
```

Or manually:
```bash
mysql -u techcorp_user -p company_db < company_db.sql
```

### 8. Start Application

```bash
pm2 start ecosystem.config.js --env production
pm2 save
pm2 startup
```

The last command will output a command to run with sudo - execute it to enable PM2 to start on boot.

### 9. Verify Deployment

```bash
# Check PM2 status
pm2 status

# Check logs
pm2 logs techcorp-solutions

# Test health endpoint
curl http://localhost:3000/health
```

## Nginx Reverse Proxy (Optional but Recommended)

### Install Nginx

```bash
sudo apt update
sudo apt install nginx
```

### Configure Nginx

Create configuration file:
```bash
sudo nano /etc/nginx/sites-available/techcorp
```

Add the following configuration:

```nginx
server {
    listen 80;
    server_name techcorp.example.com;  # Replace with your domain

    # Redirect HTTP to HTTPS (after SSL is configured)
    # return 301 https://$server_name$request_uri;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Logging
    access_log /var/log/nginx/techcorp_access.log;
    error_log /var/log/nginx/techcorp_error.log;
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/techcorp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Configure Firewall

```bash
# Allow Nginx
sudo ufw allow 'Nginx Full'

# Or if using specific port for Node.js directly
sudo ufw allow 3000/tcp

# Enable firewall
sudo ufw enable
```

## SSL Certificate with Certbot (Recommended for Production)

### Install Certbot

```bash
sudo apt install certbot python3-certbot-nginx
```

### Obtain Certificate

```bash
sudo certbot --nginx -d techcorp.example.com
```

Follow the prompts to:
1. Enter your email
2. Agree to terms
3. Choose to redirect HTTP to HTTPS

Certbot will automatically:
- Obtain SSL certificate
- Configure Nginx
- Set up automatic renewal

### Verify Auto-Renewal

```bash
sudo certbot renew --dry-run
```

## PM2 Management Commands

```bash
# View status
pm2 status

# View logs (all)
pm2 logs

# View logs for specific app
pm2 logs techcorp-solutions

# Restart
pm2 restart techcorp-solutions

# Stop
pm2 stop techcorp-solutions

# Start
pm2 start ecosystem.config.js --env production

# Monitor resources
pm2 monit

# Delete from PM2
pm2 delete techcorp-solutions
```

## Updating the Application

### Manual Update

```bash
cd ~/webprogramming_with_lilla
git pull origin main
npm ci --production
pm2 restart techcorp-solutions
```

### Using GitHub Actions

See the main README for instructions on using the automated deployment workflow.

## Troubleshooting

### Application won't start

1. Check logs:
   ```bash
   pm2 logs techcorp-solutions --lines 100
   ```

2. Verify environment variables:
   ```bash
   cat .env
   ```

3. Test database connection:
   ```bash
   mysql -u techcorp_user -p company_db -e "SELECT 1;"
   ```

### Database connection errors

1. Check MySQL is running:
   ```bash
   sudo systemctl status mysql
   ```

2. Verify user permissions:
   ```sql
   SHOW GRANTS FOR 'techcorp_user'@'localhost';
   ```

3. Check firewall:
   ```bash
   sudo ufw status
   ```

### Port already in use

1. Find process using port:
   ```bash
   sudo lsof -i :3000
   ```

2. Kill process or change PORT in .env

### Nginx errors

1. Check configuration:
   ```bash
   sudo nginx -t
   ```

2. Check logs:
   ```bash
   sudo tail -f /var/log/nginx/techcorp_error.log
   ```

3. Verify upstream is running:
   ```bash
   curl http://localhost:3000/health
   ```

## Security Best Practices

1. **Keep system updated**:
   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. **Use strong passwords** for database and SSH

3. **Enable firewall** with only necessary ports

4. **Use HTTPS** with valid SSL certificate

5. **Regular backups**:
   ```bash
   # Database backup
   mysqldump -u techcorp_user -p company_db > backup-$(date +%Y%m%d).sql
   ```

6. **Monitor logs** regularly:
   ```bash
   pm2 logs
   sudo tail -f /var/log/nginx/techcorp_error.log
   ```

7. **Keep dependencies updated**:
   ```bash
   npm audit
   npm audit fix
   ```

## Systemd Service (Alternative to PM2)

If you prefer systemd over PM2, see `docs/systemd-techcorp.service` for a template.

Create service file:
```bash
sudo nano /etc/systemd/system/techcorp.service
```

Enable and start:
```bash
sudo systemctl enable techcorp
sudo systemctl start techcorp
sudo systemctl status techcorp
```

## Monitoring and Maintenance

### Set up log rotation

PM2 handles log rotation automatically. For nginx:

```bash
sudo nano /etc/logrotate.d/nginx
```

### Database maintenance

```bash
# Optimize tables
mysqlcheck -u techcorp_user -p --optimize company_db

# Check tables
mysqlcheck -u techcorp_user -p --check company_db
```

### Disk space monitoring

```bash
# Check disk usage
df -h

# Find large files
du -sh /* | sort -h
```

## Support

For issues or questions:
- Open an issue: https://github.com/MI804-png/webprogramming_with_lilla/issues
- See documentation: `docs/Documentation-Full.md`
- Security issues: See SECURITY.md
