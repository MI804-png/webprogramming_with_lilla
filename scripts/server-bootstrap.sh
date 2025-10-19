#!/usr/bin/env bash
set -euo pipefail

# Idempotent bootstrap for Ubuntu/Debian hosts
# - Installs Node.js 18, git, curl, build tools, and PM2
# - Clones or updates the repository
# - Creates .env if missing (from .env.production.example)
# - Installs dependencies and starts app via PM2

REPO_URL=${REPO_URL:-"https://github.com/MI804-png/webprogramming_with_lilla.git"}
BRANCH=${BRANCH:-"main"}
APP_BASE=${APP_BASE:-"$HOME/webprogramming_with_lilla"}
APP_DIR="$APP_BASE/exercise"

echo "[1/6] Installing prerequisites (git, curl, build-essential)"
sudo apt-get update -y
sudo apt-get install -y git curl build-essential ca-certificates gnupg

echo "[2/6] Installing Node.js 18"
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "Node already installed: $(node -v)"
fi

echo "[3/6] Installing PM2 globally"
sudo npm install -g pm2

echo "[4/6] Cloning or updating repository"
if [ ! -d "$APP_BASE/.git" ]; then
  git clone "$REPO_URL" "$APP_BASE"
fi
cd "$APP_BASE"
git fetch --all --prune
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

echo "[5/6] Preparing app environment"
cd "$APP_DIR"
if [ ! -f .env ]; then
  if [ -f .env.production.example ]; then
    cp .env.production.example .env
    echo "Created .env from .env.production.example. Update DB credentials and SESSION_SECRET."
  else
    echo "Missing .env and .env.production.example. Please create .env."
  fi
fi

echo "Installing dependencies"
npm ci || npm install

echo "[6/6] Starting app with PM2"
pm2 start ecosystem.config.js --update-env || pm2 start start.js --name techcorp
pm2 save

echo "Done. App should be running. Check with: pm2 status"
echo "Health check: curl http://127.0.0.1:${PORT:-3000}/health"
