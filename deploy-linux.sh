#!/usr/bin/env bash
set -euo pipefail

# TechCorp Solutions - One-Click Linux Deployment Script
# This script will deploy the application on Ubuntu/Debian systems

echo "============================================"
echo "TechCorp Solutions - Linux Deployment"
echo "============================================"

# Configuration - IHUTSC Server specific settings for Nabil Salama Rezk Mikhael
REPO_URL="${REPO_URL:-https://github.com/MI804-png/webprogramming_with_lilla.git}"
APP_NAME="${APP_NAME:-app206}"
APP_DIR="${APP_DIR:-$HOME/exercise}"
PORT="${PORT:-4206}"
BASE_ROUTE="${BASE_ROUTE:-/app206}"
DB_NAME="${DB_NAME:-db206}"
DB_USER="${DB_USER:-studb206}"
DB_PASS="${DB_PASS:-mikha@2001}"
LINUX_USER="${LINUX_USER:-student206}"
NEPTUN_CODE="${NEPTUN_CODE:-IHUTSC}"
DOMAIN="${DOMAIN:-}"  # Optional domain for SSL setup

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Step 1: Update system and install prerequisites
print_status "Step 1: Installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y git curl build-essential ca-certificates gnupg

# Step 2: Install Node.js if not present
if ! command_exists node; then
    print_status "Step 2: Installing Node.js 18..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    print_status "Step 2: Node.js already installed: $(node -v)"
fi

# Step 3: Install PM2 if not present
if ! command_exists pm2; then
    print_status "Step 3: Installing PM2..."
    sudo npm install -g pm2
else
    print_status "Step 3: PM2 already installed: $(pm2 -v)"
fi

# Step 4: Install and configure MariaDB
print_status "Step 4: Installing MariaDB..."
if ! command_exists mysql; then
    sudo apt-get install -y mariadb-server mariadb-client
    
    # Secure MariaDB installation
    print_warning "MariaDB installed. Please run 'sudo mysql_secure_installation' after deployment."
    
    # Start MariaDB
    sudo systemctl enable mariadb
    sudo systemctl start mariadb
else
    print_status "MariaDB already installed"
fi

# Step 5: Clone or update repository
print_status "Step 5: Setting up application code..."
if [ -d "$APP_DIR" ]; then
    print_status "Updating existing repository..."
    cd "$APP_DIR"
    git pull
else
    print_status "Cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
fi

cd "$APP_DIR/exercise"

# Step 6: Install dependencies
print_status "Step 6: Installing application dependencies..."
npm ci

# Step 7: Create environment configuration
print_status "Step 7: Setting up environment configuration..."
if [ ! -f .env ]; then
    cp .env.production.example .env
    
    # Generate a random session secret
    SESSION_SECRET=$(openssl rand -base64 32)
    sed -i "s/please_change_this_long_random_string/$SESSION_SECRET/" .env
    
    print_warning "Environment file created. Please update database credentials in .env"
    print_warning "Edit the file: nano $APP_DIR/exercise/.env"
fi

# Step 8: Setup database
print_status "Step 8: Setting up database..."

# Function to setup database
setup_database() {
    local root_password
    echo ""
    print_warning "Database setup required."
    print_status "Please enter MySQL/MariaDB root password (or press Enter if no password):"
    read -s root_password
    
    local mysql_cmd="mysql -u root"
    if [ -n "$root_password" ]; then
        mysql_cmd="mysql -u root -p$root_password"
    fi
    
    print_status "Creating database and user..."
    
    # Create database setup SQL
    cat > /tmp/setup_db.sql << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF
    
    # Execute database setup
    if $mysql_cmd < /tmp/setup_db.sql; then
        print_status "Database and user created successfully!"
        
        # Import database schema
        print_status "Importing database schema..."
        if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < company_db.sql; then
            print_status "Database schema imported successfully!"
        else
            print_error "Failed to import database schema"
            exit 1
        fi
    else
        print_error "Failed to create database and user"
        print_warning "Please create the database manually:"
        print_warning "1. Login to MySQL: mysql -u root -p"
        print_warning "2. Run the commands in /tmp/setup_db.sql"
        print_warning "3. Import schema: mysql -u $DB_USER -p$DB_PASS $DB_NAME < company_db.sql"
        exit 1
    fi
    
    # Clean up
    rm -f /tmp/setup_db.sql
}

# Check if database already exists
if mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
    print_status "Database already exists and is accessible"
else
    setup_database
fi

# Step 9: Update environment file with database credentials
print_status "Step 9: Updating environment configuration..."
if [ -f .env ]; then
    # Update database credentials in .env file
    sed -i "s/DB_USER=.*/DB_USER=$DB_USER/" .env
    sed -i "s/DB_PASS=.*/DB_PASS=$DB_PASS/" .env
    sed -i "s/DB_NAME=.*/DB_NAME=$DB_NAME/" .env
    sed -i "s/PORT=.*/PORT=$PORT/" .env
    
    # Generate a secure session secret if it's still the default
    if grep -q "please_change_this_long_random_string" .env; then
        SESSION_SECRET=$(openssl rand -base64 32)
        sed -i "s/SESSION_SECRET=.*/SESSION_SECRET=$SESSION_SECRET/" .env
        print_status "Generated secure session secret"
    fi
fi

# Step 10: Start application with PM2
print_status "Step 10: Starting application..."
pm2 delete "$APP_NAME" 2>/dev/null || true

# Update PM2 ecosystem config with IHUTSC server environment
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: '$APP_NAME',
      script: 'start-homework-style.js',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '512M',
      env: {
        NODE_ENV: 'production',
        INTERNAL_PORT: $PORT,
        BASE_ROUTE: '$BASE_ROUTE',
        DB_HOST: 'localhost',
        DB_PORT: 3306,
        DB_USER: '$DB_USER',
        DB_PASS: '$DB_PASS',
        DB_NAME: '$DB_NAME',
        LINUX_USER: '$LINUX_USER',
        NEPTUN_CODE: '$NEPTUN_CODE'
      },
      log_file: './logs/$APP_NAME-combined.log',
      out_file: './logs/$APP_NAME-out.log',
      error_file: './logs/$APP_NAME-error.log'
    }
  ]
}
EOF

pm2 start ecosystem.config.js
pm2 save

# Enable PM2 startup
print_status "Setting up PM2 auto-startup..."
pm2 startup | tail -n 1 | bash || true

# Step 11: Setup firewall (optional)
print_status "Step 11: Configuring firewall..."
if command_exists ufw; then
    print_status "Configuring UFW firewall..."
    sudo ufw allow 22/tcp  # SSH
    sudo ufw allow $PORT/tcp  # Application port
    sudo ufw allow 80/tcp   # HTTP (for reverse proxy)
    sudo ufw allow 443/tcp  # HTTPS (for reverse proxy)
    sudo ufw --force enable
    print_status "Firewall configured and enabled"
else
    print_warning "UFW not available. Please configure firewall manually."
fi

# Step 12: Test the deployment
print_status "Step 12: Testing deployment..."
sleep 5

# Function to test application health
test_application() {
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        print_status "Testing application (attempt $attempt/$max_attempts)..."
        
        if curl -s --max-time 10 http://localhost:$PORT/ > /dev/null; then
            print_status "✅ Application is responding!"
            return 0
        fi
        
        if [ $attempt -lt $max_attempts ]; then
            print_warning "Application not ready yet, waiting 3 seconds..."
            sleep 3
        fi
        
        attempt=$((attempt + 1))
    done
    
    print_error "❌ Application failed to start properly"
    print_error "Check logs with: pm2 logs $APP_NAME"
    return 1
}

# Run the test
if test_application; then
    APPLICATION_STATUS="✅ RUNNING"
else
    APPLICATION_STATUS="❌ FAILED"
fi

print_status "============================================"
print_status "🚀 DEPLOYMENT COMPLETED!"
print_status "============================================"

echo ""
print_status "📊 DEPLOYMENT SUMMARY:"
echo "  Status: $APPLICATION_STATUS"
echo "  App Name: $APP_NAME"
echo "  Directory: $APP_DIR/exercise"
echo "  Port: $PORT"
echo "  Database: $DB_NAME"
echo ""

print_status "🌐 ACCESS URLS:"
# Get server IP (try multiple methods)
SERVER_IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null || curl -s --max-time 5 ipinfo.io/ip 2>/dev/null || echo "YOUR_SERVER_IP")
echo "  - External: http://$SERVER_IP:$PORT"
echo "  - Local: http://localhost:$PORT"
echo "  - Health Check: http://localhost:$PORT/health"
echo ""

print_status "🔐 DEFAULT LOGIN CREDENTIALS:"
echo "  - Admin: username=admin, password=admin123"
echo "  - Test User: username=testuser, password=hello"
echo ""

print_status "⚙️  MANAGEMENT COMMANDS:"
echo "  - Check status: pm2 status"
echo "  - View logs: pm2 logs $APP_NAME"
echo "  - Restart app: pm2 restart $APP_NAME"
echo "  - Stop app: pm2 stop $APP_NAME"
echo "  - Update code: cd $APP_DIR && git pull && npm ci && pm2 restart $APP_NAME"
echo ""

print_status "📁 IMPORTANT FILES:"
echo "  - App config: $APP_DIR/exercise/.env"
echo "  - PM2 config: $APP_DIR/exercise/ecosystem.config.js"
echo "  - Database: /etc/mysql/ or /var/lib/mysql/"
echo ""

print_warning "🔧 NEXT STEPS:"
echo "  1. Change default passwords in the application"
echo "  2. Configure domain name and SSL certificate if needed"
echo "  3. Set up regular backups for the database"
echo "  4. Monitor application logs regularly"
echo "  5. Update firewall rules if using different ports"

echo ""
print_status "🎉 Your TechCorp Solutions application is now deployed!"
print_status "Visit http://$SERVER_IP:$PORT to access your application."