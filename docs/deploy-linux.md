# Deploy to Linux (Ubuntu/Debian)

This guide takes you from a clean server to a running TechCorp Solutions app using either PM2 or systemd.

Requirements
- A Linux user with SSH access (non-root recommended)
- Node.js 18+ (via NodeSource, nvm, or distro packages)
- Git
- MySQL/MariaDB server reachable from the app

## 1) Prepare the server

Update and install base tools:

```bash
sudo apt-get update -y
sudo apt-get install -y git curl build-essential
```

Install Node.js (NodeSource example):

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
```

Install PM2 (optional but recommended):

```bash
sudo npm install -g pm2
pm2 -v
```

Install MySQL/MariaDB client if needed (for importing SQL):

```bash
sudo apt-get install -y mariadb-client
```

## 2) Get the application code

```bash
cd ~
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla/exercise
```

If cloning a fork/private repo, configure authentication or use SSH:

```bash
git clone git@github.com:MI804-png/webprogramming_with_lilla.git
```

## 3) Install dependencies

```bash
npm ci || npm install
```

## 4) Configure environment

Copy the example and edit values:

```bash
cp .env.production.example .env
nano .env
```

Key variables:
- DB_HOST, DB_PORT, DB_USER, DB_PASS, DB_NAME
- SESSION_SECRET (set a unique random value)
- PORT (e.g., 3000)

## 5) Create the database schema and demo data

Import `company_db.sql` into your database (replace values accordingly):

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p < company_db.sql
```

On first app start, two demo users are ensured in `users` table:
- admin / admin123 (role: admin)
- testuser / hello (role: registered)

## 6) Run the app

Direct (for testing):

```bash
node start.js
# Visit http://<server-ip>:3000
```

Using PM2:

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup  # follow on-screen instructions to enable auto-start
```

Using systemd (user service example):

```bash
mkdir -p ~/.config/systemd/user
cp docs/systemd-techcorp.service ~/.config/systemd/user/techcorp.service
systemctl --user daemon-reload
systemctl --user enable --now techcorp.service
systemctl --user status techcorp.service
```

If running a system-wide service instead, adapt the service unit paths and Environment variables accordingly.

## 7) Reverse proxy (optional)

Use Nginx to expose on port 80/443:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Reload Nginx:

```bash
sudo systemctl reload nginx
```

## 8) Health check and logs

- Health: http://<server-ip>:3000/health
- PM2 logs: `pm2 logs`
- systemd logs: `journalctl --user -u techcorp.service -f`

## 9) Troubleshooting

- DB connection refused: verify host/port, firewall, and credentials. Test with `mysql -h <host> -P <port> -u <user> -p`.
- Port in use: change PORT in `.env` or stop the process using the port.
- 502 via Nginx: verify upstream app is running and reachable at configured port.
