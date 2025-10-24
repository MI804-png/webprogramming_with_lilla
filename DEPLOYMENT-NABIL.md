# TechCorp Solutions - Deployment Instructions for Nabil Salama Rezk Mikhael

## Assignment Details
- **Name:** Nabil Salama Rezk Mikhael
- **Neptun Code:** IHUTSC
- **Linux Username:** student206
- **Database Username:** studb206
- **Internal Port:** 4206
- **Route:** app206

## Quick Linux Deployment

### 1. Connect to Linux Server
```bash
ssh student206@IP-ADDRESS
# Password: abc123 (change on first login)
```

### 2. Create Exercise Directory
```bash
cd ~
mkdir exercise
cd exercise
```

### 3. Initialize Node.js Project
```bash
npm init -y
npm install mysql
```

### 4. Create Simple Test Application
```bash
nano exercise.js
```

Copy this content:
```javascript
const http = require('http');
const mysql = require('mysql');

// Your assignment configuration
const INTERNAL_PORT = 4206;
const BASE_ROUTE = '/app206';

// Database connection
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'studb206',
    password: 'abc123',
    database: 'db206'
});

// Test database connection
connection.connect(function(err) {
    if (!err) {
        console.log("Database is connected ...");
    } else {
        console.log("Error connecting database ...");
    }
});

// Create HTTP server
const server = http.createServer((req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write(req.url + '\n');
    res.write('<h1>TechCorp Solutions</h1>');
    res.write('<p>Student: Nabil Salama Rezk Mikhael (IHUTSC)</p>');
    res.write('<p>Route: app206 => Internal Port: 4206</p>');
    res.write('<p><a href="/app206/test">Test Page</a></p>');
    res.end();
});

server.listen(4206, function() {
    console.log('Server listening on port 4206');
    console.log('Access via: http://IP-ADDRESS/app206/');
});
```

### 5. Test the Application
```bash
# Test locally first
node exercise.js

# In another terminal, test:
curl http://localhost:4206/app206/
```

### 6. Use PM2 for Production
```bash
# Install PM2 globally
sudo npm install -g pm2

# Start with PM2
pm2 start exercise.js --name techcorp-app206

# Save PM2 configuration
pm2 save

# Enable auto-start on boot
pm2 startup
```

### 7. Database Setup
```bash
# Connect to MySQL
mysql -u studb206 -p
# Password: abc123

# Change password (recommended)
SET PASSWORD = PASSWORD('your_new_password');

# Create/use your database
CREATE DATABASE IF NOT EXISTS db206;
USE db206;

# Create employee table (from homework)
CREATE TABLE IF NOT EXISTS employee (
    id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL DEFAULT '',
    address VARCHAR(70) NOT NULL DEFAULT '',
    age INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci;

# Insert sample data
INSERT INTO employee (id, name, address, age) VALUES 
(1, 'Mark Smith', 'Budapest', 35),
(2, 'Julia Brown', 'Szeged', 20),
(3, 'Peter Cooper', 'Debrecen', 23);
```

## Access URLs

After deployment, your application will be accessible at:

- **Main Page:** `http://IP-ADDRESS/app206/`
- **Any Sub-route:** `http://IP-ADDRESS/app206/test`
- **Multi-level:** `http://IP-ADDRESS/app206/aaa/bbb`

## PM2 Management Commands

```bash
# Check status
pm2 list

# View logs
pm2 logs techcorp-app206

# Restart application
pm2 restart techcorp-app206

# Stop application
pm2 stop techcorp-app206

# Delete application
pm2 delete techcorp-app206
```

## File Transfer (WinSCP)

1. Download WinSCP: https://winscp.net/eng/downloads.php
2. Connect with:
   - Host: IP-ADDRESS
   - Username: student206
   - Password: abc123
3. Navigate to `/home/student206/exercise/`
4. Upload/edit files as needed

## Troubleshooting

**If port 4206 is already in use:**
```bash
sudo netstat -tlnp | grep :4206
# Kill the process using the port if needed
```

**If database connection fails:**
```bash
# Check if MySQL is running
sudo systemctl status mysql
sudo systemctl start mysql

# Test database connection
mysql -u studb206 -p -e "SELECT 1;"
```

**View application logs:**
```bash
pm2 logs techcorp-app206 --lines 50
```

## Success Verification

Your application is working correctly when:
1. PM2 shows status "online": `pm2 list`
2. You can access: `http://IP-ADDRESS/app206/`
3. The page shows your name and assignment details
4. Database connection works (if configured)

## Final Checklist

- [ ] Application starts with `node exercise.js`
- [ ] PM2 manages the process: `pm2 start exercise.js`
- [ ] Accessible via reverse proxy: `http://IP-ADDRESS/app206/`
- [ ] Database connection established
- [ ] Multi-level routes work
- [ ] Password changed from default "abc123"

Your TechCorp Solutions application is now deployed following the NodeJS homework methodology!