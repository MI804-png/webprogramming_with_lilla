# TechCorp Solutions - Quick Deployment Reference

## 🚀 One-Click Deployment (Easiest)

**On your Linux server, run:**

```bash
# Download and run the deployment script
wget https://raw.githubusercontent.com/MI804-png/webprogramming_with_lilla/main/exercise/deploy-linux.sh
chmod +x deploy-linux.sh
./deploy-linux.sh
```

## 📋 Manual Deployment Steps

### 1. Prerequisites
```bash
sudo apt update && sudo apt install -y git curl build-essential
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs mariadb-server
sudo npm install -g pm2
```

### 2. Get the Code
```bash
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla/exercise
npm install
```

### 3. Database Setup
```bash
sudo mysql
```
```sql
CREATE DATABASE company_db;
CREATE USER 'techcorp'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL ON company_db.* TO 'techcorp'@'localhost';
exit
```
```bash
mysql -u techcorp -p company_db < company_db.sql
```

### 4. Configure Environment
```bash
cp .env.production.example .env
nano .env  # Update DB credentials
```

### 5. Start Application
```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

## 🔧 Management Commands

```bash
# Check status
pm2 status

# View logs
pm2 logs techcorp-solutions

# Restart application
pm2 restart techcorp-solutions

# Stop application
pm2 stop techcorp-solutions

# Health check
curl http://localhost:3000/health
```

## 🌐 Access Your Application

- **Application URL:** `http://your-server-ip:3000`
- **Login Page:** `http://your-server-ip:3000/login`
- **Health Check:** `http://your-server-ip:3000/health`

## 👤 Default Credentials

- **Admin:** username: `admin`, password: `admin123`
- **User:** username: `testuser`, password: `hello`

## 🔒 Security Checklist

- [ ] Change default admin password
- [ ] Update SESSION_SECRET in .env
- [ ] Configure firewall (UFW)
- [ ] Set up SSL/HTTPS
- [ ] Regular backups
- [ ] Update system packages

## 🆘 Troubleshooting

**Database connection failed:**
```bash
sudo systemctl start mariadb
mysql -u root -p  # Test connection
```

**Port already in use:**
```bash
sudo netstat -tlnp | grep :3000
# Change PORT in .env if needed
```

**Application not starting:**
```bash
pm2 logs techcorp-solutions
# Check logs for errors
```

## 📁 Important Files

- `start.js` - Main application file
- `.env` - Environment configuration
- `company_db.sql` - Database schema
- `ecosystem.config.js` - PM2 configuration
- `deploy-linux.sh` - Automated deployment script