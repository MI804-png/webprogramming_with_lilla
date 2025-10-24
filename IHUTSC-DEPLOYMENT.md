# IHUTSC Server Deployment Commands
# Server IP: 143.47.98.96
# Nabil Salama Rezk Mikhael - IHUTSC Deployment

## Step 1: Upload files to server
# From your Windows PowerShell in the exercise directory:

# Option A: Using SCP (if available)
scp -r . student206@143.47.98.96:~/exercise/

# Option B: Using Git (recommended)
# First push your changes to GitHub, then clone on server

## Step 2: Connect to server and deploy
ssh student206@143.47.98.96

# Once connected to the server:
cd ~/exercise
chmod +x deploy-linux.sh
./deploy-linux.sh

## Step 3: Access your application
# URL: http://143.47.98.96:4206/app206
# Health Check: http://143.47.98.96:4206/app206/health
# Admin Login: admin / admin123

## Alternative Manual Deployment (if script fails):
# 1. Install Node.js and PM2
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g pm2

# 2. Install dependencies
npm ci

# 3. Setup database (if needed)
chmod +x setup-database.sh
./setup-database.sh

# 4. Start application
pm2 start ecosystem.config.js
pm2 save
pm2 startup

## Management Commands:
pm2 status          # Check status
pm2 logs app206      # View logs
pm2 restart app206   # Restart app
pm2 stop app206      # Stop app