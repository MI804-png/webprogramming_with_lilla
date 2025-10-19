#!/bin/bash
# Database import script for TechCorp Solutions
# This script imports the company_db.sql file into MySQL

set -e  # Exit on error

# Load environment variables from .env if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Database configuration from environment or defaults
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-}"
DB_NAME="${DB_NAME:-company_db}"

echo "========================================="
echo "Database Import Script"
echo "========================================="
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "User: $DB_USER"
echo "Database: $DB_NAME"
echo "========================================="

# Check if SQL file exists
if [ ! -f "company_db.sql" ]; then
    echo "Error: company_db.sql not found!"
    exit 1
fi

# Build mysql command
MYSQL_CMD="mysql -h $DB_HOST -P $DB_PORT -u $DB_USER"

# Add password if provided
if [ -n "$DB_PASS" ]; then
    MYSQL_CMD="$MYSQL_CMD -p$DB_PASS"
fi

# Create database if it doesn't exist
echo "Creating database if it doesn't exist..."
echo "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | $MYSQL_CMD

# Import the SQL file
echo "Importing company_db.sql into $DB_NAME..."
$MYSQL_CMD $DB_NAME < company_db.sql

echo "========================================="
echo "Database import completed successfully!"
echo "========================================="
