#!/usr/bin/env bash
set -euo pipefail

# Import company_db.sql into a MySQL/MariaDB server

DB_HOST=${DB_HOST:-127.0.0.1}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASS=${DB_PASS:-}
DB_NAME=${DB_NAME:-company_db}

SQL_FILE=${1:-company_db.sql}

if [ ! -f "$SQL_FILE" ]; then
  echo "SQL file not found: $SQL_FILE" >&2
  exit 1
fi

echo "Importing $SQL_FILE into $DB_USER@$DB_HOST:$DB_PORT/$DB_NAME"
if [ -n "$DB_PASS" ]; then
  MYSQL_PWD="$DB_PASS" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" < "$SQL_FILE"
else
  mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "$DB_NAME" < "$SQL_FILE"
fi

echo "Import complete."
