#!/usr/bin/env bash
set -euo pipefail

# TechCorp Solutions - Database Setup Script
# This script sets up the MySQL/MariaDB database for the application

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

# Configuration
DB_NAME="${DB_NAME:-company_db}"
DB_USER="${DB_USER:-techcorp_user}"
DB_PASS="${DB_PASS:-techcorp_secure_password_2025}"
SQL_FILE="${SQL_FILE:-company_db.sql}"

echo "============================================"
echo "TechCorp Solutions - Database Setup"
echo "============================================"

# Check if MySQL/MariaDB is installed
if ! command -v mysql >/dev/null 2>&1; then
    print_error "MySQL/MariaDB client not found. Please install it first:"
    print_error "  Ubuntu/Debian: sudo apt-get install mariadb-client"
    print_error "  CentOS/RHEL: sudo yum install mariadb"
    exit 1
fi

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
    print_error "SQL file '$SQL_FILE' not found in current directory"
    print_error "Please ensure you're running this script from the exercise directory"
    exit 1
fi

# Function to test database connection
test_connection() {
    local user=$1
    local password=$2
    local database=${3:-""}
    
    if [ -n "$database" ]; then
        mysql -u "$user" -p"$password" -e "USE $database;" 2>/dev/null
    else
        mysql -u "$user" -p"$password" -e "SELECT 1;" 2>/dev/null
    fi
}

# Get MySQL root password
echo ""
print_status "Please enter MySQL/MariaDB root password:"
print_warning "(Press Enter if no password is set)"
read -s ROOT_PASS

# Test root connection
print_status "Testing root connection..."
if [ -z "$ROOT_PASS" ]; then
    MYSQL_ROOT_CMD="mysql -u root"
else
    MYSQL_ROOT_CMD="mysql -u root -p$ROOT_PASS"
fi

if ! $MYSQL_ROOT_CMD -e "SELECT 1;" 2>/dev/null; then
    print_error "Failed to connect to MySQL/MariaDB with root credentials"
    print_error "Please check your root password and try again"
    exit 1
fi

print_status "Root connection successful!"

# Create database and user
print_status "Creating database and user..."
cat > /tmp/create_db.sql << EOF
-- Create database
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
DROP USER IF EXISTS '$DB_USER'@'localhost';
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';

-- Grant privileges
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;

-- Show created database and user
SHOW DATABASES LIKE '$DB_NAME';
SELECT User, Host FROM mysql.user WHERE User = '$DB_USER';
EOF

if $MYSQL_ROOT_CMD < /tmp/create_db.sql; then
    print_status "Database '$DB_NAME' and user '$DB_USER' created successfully!"
else
    print_error "Failed to create database and user"
    exit 1
fi

# Test new user connection
print_status "Testing new user connection..."
if test_connection "$DB_USER" "$DB_PASS" "$DB_NAME"; then
    print_status "User connection test successful!"
else
    print_error "Failed to connect with new user credentials"
    exit 1
fi

# Import database schema
print_status "Importing database schema from '$SQL_FILE'..."
if mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"; then
    print_status "Database schema imported successfully!"
else
    print_error "Failed to import database schema"
    exit 1
fi

# Verify tables were created
print_status "Verifying database setup..."
TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SHOW TABLES;" | wc -l)
if [ "$TABLES" -gt 1 ]; then  # More than 1 (header line)
    print_status "Database setup verified - $((TABLES-1)) tables created"
    
    # Show table list
    print_status "Created tables:"
    mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SHOW TABLES;"
else
    print_warning "No tables found - please check the SQL file"
fi

# Clean up temporary files
rm -f /tmp/create_db.sql

print_status "============================================"
print_status "Database setup completed successfully!"
print_status "============================================"

echo ""
print_status "Database Configuration:"
echo "  - Database: $DB_NAME"
echo "  - User: $DB_USER"
echo "  - Password: $DB_PASS"
echo "  - Host: localhost"
echo ""

print_status "Connection string for application:"
echo "  DB_HOST=localhost"
echo "  DB_PORT=3306"
echo "  DB_USER=$DB_USER"
echo "  DB_PASS=$DB_PASS"
echo "  DB_NAME=$DB_NAME"
echo ""

print_warning "Next steps:"
echo "  1. Update your .env file with the database credentials above"
echo "  2. Restart your application to use the new database"
echo "  3. Test the database connection in your application"

print_status "Database setup script completed successfully!"