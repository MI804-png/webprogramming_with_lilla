# TechCorp Solutions - Linux Deployment Guide

This guide will help you deploy the TechCorp Solutions application on a Linux server (Ubuntu/Debian).

## Option 1: Automated Deployment (Recommended)

### Quick Deploy with Bootstrap Script

1. **Copy the repository to your Linux server:**
```bash
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla/exercise
```

2. **Run the automated bootstrap script:**
```bash
chmod +x scripts/server-bootstrap.sh
./scripts/server-bootstrap.sh
```

This script will:
- Install Node.js 18, git, curl, and build tools
- Install PM2 process manager
- Install application dependencies
- Create environment configuration
- Start the application

3. **Configure database credentials:**
```bash
nano .env
```

Update the database settings:
```bash
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=your_db_user
DB_PASS=your_db_password
DB_NAME=company_db
SESSION_SECRET=your_unique_session_secret
```

4. **Import the database:**
```bash
# Install MySQL client if not installed
sudo apt-get install -y mariadb-client

# Import the database schema
chmod +x scripts/import-db.sh
DB_USER=your_db_user DB_PASS=your_db_password ./scripts/import-db.sh
```

5. **Restart the application:**
```bash
pm2 restart techcorp-solutions
```

## Option 2: Manual Deployment

### Prerequisites
```bash
# Update system
sudo apt-get update -y
sudo apt-get install -y git curl build-essential

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Install MySQL/MariaDB
sudo apt-get install -y mariadb-server mariadb-client
```

### Deploy Application
```bash
# Clone repository
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla/exercise

# Install dependencies
npm ci

# Create environment file
cp .env.production.example .env
nano .env  # Edit database credentials

# Import database
mysql -u root -p < company_db.sql

# Start with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

## Option 3: Systemd Service

1. **Create systemd service file:**
```bash
sudo nano /etc/systemd/system/techcorp.service
```

Add the following content:
```ini
[Unit]
Description=TechCorp Solutions Web Application
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/webprogramming_with_lilla/exercise
ExecStart=/usr/bin/node start.js
Restart=on-failure
RestartSec=10
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
```

2. **Enable and start service:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable techcorp
sudo systemctl start techcorp
sudo systemctl status techcorp
```

## Post-Deployment

### 1. Verify Installation
```bash
# Check application status
pm2 status
# or for systemd
sudo systemctl status techcorp

# Health check
curl http://localhost:3000/health

# View logs
pm2 logs techcorp-solutions
# or for systemd
sudo journalctl -u techcorp -f
```

### 2. Configure Nginx (Optional)
```bash
sudo apt-get install -y nginx

# Create Nginx configuration
sudo nano /etc/nginx/sites-available/techcorp
```

Add:
```nginx
server {
    listen 80;
    server_name your-domain.com;

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
sudo nginx -t
sudo systemctl reload nginx
```

### 3. SSL with Let's Encrypt (Optional)
```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## Default Credentials

After deployment, you can login with:
- **Admin:** username: `admin`, password: `admin123`
- **Test User:** username: `testuser`, password: `hello`

## Troubleshooting

### Database Connection Issues
```bash
# Test database connection
mysql -h 127.0.0.1 -P 3306 -u your_user -p

# Check if MariaDB is running
sudo systemctl status mariadb
sudo systemctl start mariadb
```

### Port Issues
```bash
# Check if port 3000 is in use
sudo netstat -tlnp | grep :3000

# Change port in .env file
nano .env
# Set PORT=3001 or another available port
```

### View Application Logs
```bash
# PM2 logs
pm2 logs techcorp-solutions --lines 50

# Systemd logs
sudo journalctl -u techcorp --lines 50 -f
```

## Security Recommendations

1. **Change default passwords** in the database
2. **Use strong SESSION_SECRET** in .env
3. **Configure firewall** to only allow necessary ports
4. **Use HTTPS** in production
5. **Regular database backups**
6. **Keep system and dependencies updated**

## Application URLs

- **Main Application:** http://your-server:3000
- **Health Check:** http://your-server:3000/health
- **Login:** http://your-server:3000/login
- **Admin Panel:** Available after admin login

Success! Your TechCorp Solutions application should now be running on your Linux server.