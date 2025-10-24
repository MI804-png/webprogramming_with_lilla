# TechCorp Solutions - Linux Deployment Guide

This comprehensive guide will help you deploy the TechCorp Solutions application on a Linux server (Ubuntu/Debian) from start to finish.

## 🎯 Overview

This deployment guide covers:
- Automated one-click deployment using our deployment script
- Manual step-by-step deployment process
- Post-deployment configuration and management
- Troubleshooting common issues

## 📋 Prerequisites

### Server Requirements
- **OS**: Ubuntu 18.04+ or Debian 10+ (64-bit)
- **RAM**: Minimum 1GB, recommended 2GB+
- **Storage**: Minimum 2GB free space
- **Network**: Public IP address and internet connectivity

### Access Requirements
- SSH access to the server with sudo privileges
- Non-root user account (recommended for security)

### Software Dependencies
- Node.js 18+ 
- MySQL/MariaDB 10.3+
- Git
- PM2 (for process management)

## 🚀 Quick Deployment (Recommended)

### Option 1: One-Click Automated Deployment

The easiest way to deploy is using our automated deployment script:

1. **Connect to your server:**
   ```bash
   ssh your-username@your-server-ip
   ```

2. **Download and run the deployment script:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/MI804-png/webprogramming_with_lilla/main/exercise/deploy-linux.sh -o deploy-linux.sh
   chmod +x deploy-linux.sh
   ./deploy-linux.sh
   ```

3. **Follow the prompts:**
   - Enter MySQL root password when requested
   - The script will handle everything automatically

4. **Access your application:**
   - Visit `http://YOUR_SERVER_IP:3000`
   - Login with admin credentials: `admin / admin123`

That's it! Your application should now be running.

---

## 🔧 Manual Deployment Process

If you prefer to deploy manually or need to customize the process:

### Step 1: Prepare the Server

Update system packages:
```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git curl build-essential ca-certificates gnupg
```

### Step 2: Install Node.js

Install Node.js 18.x (LTS):
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node -v  # Should show v18.x.x
npm -v   # Should show 9.x.x or higher
```

### Step 3: Install PM2 Process Manager

```bash
sudo npm install -g pm2
pm2 -v  # Verify installation
```

### Step 4: Install and Configure MySQL/MariaDB

Install MariaDB:
```bash
sudo apt-get install -y mariadb-server mariadb-client

# Start and enable MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation
```

### Step 5: Clone the Application

Clone the repository:
```bash
cd ~
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla/exercise
```

For private repositories, use SSH or configure Git credentials:
```bash
git clone git@github.com:MI804-png/webprogramming_with_lilla.git
```

### Step 6: Install Application Dependencies

```bash
npm ci  # Use ci for production (faster and more reliable)
```

### Step 7: Configure Environment

Create environment configuration:
```bash
cp .env.production.example .env
nano .env  # or use your preferred editor
```

Update these critical values in `.env`:
```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=techcorp_user
DB_PASS=your_secure_password_here
DB_NAME=company_db

# Generate a secure session secret
SESSION_SECRET=$(openssl rand -base64 32)

# Application Port
PORT=3000
```

### Step 8: Set Up Database

#### Option A: Use Our Database Setup Script
```bash
chmod +x setup-database.sh
./setup-database.sh
```

#### Option B: Manual Database Setup
```bash
# Login to MySQL as root
mysql -u root -p

# Create database and user
CREATE DATABASE company_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'techcorp_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON company_db.* TO 'techcorp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Import database schema
mysql -u techcorp_user -p company_db < company_db.sql
```

### Step 9: Start the Application

#### Using PM2 (Recommended)
```bash
# Start the application
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Set up auto-startup
pm2 startup
# Follow the instructions shown to enable auto-start on boot
```

#### Direct Start (for testing)
```bash
node start.js
# Application will be available at http://your-server-ip:3000
```

### Step 10: Configure Firewall

```bash
# Allow SSH, HTTP, HTTPS, and application port
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3000/tcp
sudo ufw --force enable
```

---

## 🔄 Post-Deployment Configuration

### Default Login Credentials
- **Admin**: username=`admin`, password=`admin123`
- **Test User**: username=`testuser`, password=`hello`

**⚠️ Important**: Change these default passwords immediately after deployment!

### Health Check
Visit `http://your-server-ip:3000/health` to verify the application is running correctly.

---

## 🌐 Setting Up Reverse Proxy (Optional)

### Install and Configure Nginx

```bash
sudo apt-get install -y nginx

# Create site configuration
sudo nano /etc/nginx/sites-available/techcorp
```

Add this configuration:
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

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/techcorp /etc/nginx/sites-enabled/
sudo nginx -t  # Test configuration
sudo systemctl reload nginx
```

### SSL with Let's Encrypt (Optional)
```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

---

## 📊 Management and Monitoring

### PM2 Commands
```bash
# Check application status
pm2 status

# View logs
pm2 logs techcorp-solutions

# Restart application
pm2 restart techcorp-solutions

# Stop application
pm2 stop techcorp-solutions

# Monitor resources
pm2 monit
```

### Application Logs
Logs are stored in `./logs/` directory:
- `combined.log` - All logs
- `out.log` - Standard output
- `error.log` - Error logs

### Database Management
```bash
# Backup database
mysqldump -u techcorp_user -p company_db > backup_$(date +%Y%m%d).sql

# Monitor database
mysql -u techcorp_user -p -e "SHOW PROCESSLIST;"
```

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. Application Won't Start
```bash
# Check PM2 logs
pm2 logs techcorp-solutions

# Check if port is in use
sudo netstat -tlnp | grep :3000

# Restart application
pm2 restart techcorp-solutions
```

#### 2. Database Connection Issues
```bash
# Test database connection
mysql -u techcorp_user -p -h localhost company_db

# Check database service
sudo systemctl status mariadb

# Restart database service
sudo systemctl restart mariadb
```

#### 3. Permission Issues
```bash
# Fix file permissions
chmod -R 755 ~/webprogramming_with_lilla/exercise
chown -R $USER:$USER ~/webprogramming_with_lilla/exercise
```

#### 4. Memory Issues
```bash
# Check memory usage
free -h
pm2 monit

# Restart application if needed
pm2 restart techcorp-solutions
```

### Log Locations
- Application logs: `~/webprogramming_with_lilla/exercise/logs/`
- PM2 logs: `~/.pm2/logs/`
- System logs: `/var/log/syslog`
- MariaDB logs: `/var/log/mysql/`

---

## 🔄 Updates and Maintenance

### Updating the Application
```bash
cd ~/webprogramming_with_lilla
git pull origin main
cd exercise
npm ci
pm2 restart techcorp-solutions
```

### Regular Maintenance Tasks
1. **Update system packages** (monthly)
2. **Backup database** (daily/weekly)
3. **Monitor disk space and memory**
4. **Review application logs**
5. **Update Node.js and dependencies** (quarterly)

---

## 🛡️ Security Recommendations

1. **Change default passwords** immediately
2. **Use strong database passwords**
3. **Enable firewall** (UFW)
4. **Set up SSL certificates** for production
5. **Regular security updates**
6. **Monitor access logs**
7. **Use SSH keys** instead of passwords

---

## 📞 Support

If you encounter issues during deployment:

1. Check the troubleshooting section above
2. Review application logs: `pm2 logs techcorp-solutions`
3. Verify all prerequisites are installed
4. Ensure database is properly configured
5. Check firewall settings

For additional help, please check the project repository or contact the development team.
