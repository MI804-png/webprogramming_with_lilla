#!/bin/bash
# Database import script for TechCorp Solutions deployment
# Usage: DB_HOST=... DB_PORT=... DB_USER=... DB_PASS=... DB_NAME=... ./scripts/import-db.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== TechCorp Solutions Database Import ===${NC}"

# Check required environment variables
if [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] || [ -z "$DB_USER" ] || [ -z "$DB_NAME" ]; then
    echo -e "${RED}Error: Missing required environment variables${NC}"
    echo "Required: DB_HOST, DB_PORT, DB_USER, DB_NAME"
    echo "Optional: DB_PASS (can be empty)"
    exit 1
fi

# Set default values
DB_PORT=${DB_PORT:-3306}
DB_PASS=${DB_PASS:-""}

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SQL_FILE="$PROJECT_DIR/company_db.sql"

echo -e "${YELLOW}Configuration:${NC}"
echo "  Host: $DB_HOST"
echo "  Port: $DB_PORT"
echo "  User: $DB_USER"
echo "  Database: $DB_NAME"
echo "  SQL File: $SQL_FILE"
echo ""

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
    echo -e "${RED}Error: SQL file not found at $SQL_FILE${NC}"
    exit 1
fi

# Import the database
echo -e "${YELLOW}Importing database...${NC}"

if [ -z "$DB_PASS" ]; then
    # No password
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" < "$SQL_FILE"
else
    # With password
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database imported successfully!${NC}"
else
    echo -e "${RED}✗ Database import failed${NC}"
    exit 1
fi

echo -e "${GREEN}=== Import Complete ===${NC}"
