#!/usr/bin/env bash
set -euo pipefail

# TechCorp Solutions - Linux Deployment (Following NodeJS Homework Method)
# This follows the exact methodology from "Using Linux for NodeJS Homework"

echo "============================================"
echo "TechCorp Solutions - Linux Deployment"
echo "Following NodeJS Homework Methodology"
echo "============================================"

# Configuration (you need to set these based on your assignment)
STUDENT_USER=${STUDENT_USER:-"student001"}
DB_USER=${DB_USER:-"studb001"}
DB_NAME=${DB_NAME:-"db001"}
INTERNAL_PORT=${INTERNAL_PORT:-"4001"}
ROUTE=${ROUTE:-"app001"}

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_status "Step 1: Updating system packages..."
sudo apt-get update -y

print_status "Step 2: Installing Node.js and required packages..."
# Install Node.js if not present
if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

print_status "Step 3: Installing PM2 process manager..."
sudo npm install -g pm2

print_status "Step 4: Installing MySQL client..."
sudo apt-get install -y mysql-client

print_status "Step 5: Creating exercise directory..."
mkdir -p ~/exercise
cd ~/exercise

print_status "Step 6: Setting up application files..."
# Create package.json for dependencies
cat > package.json << 'EOF'
{
  "name": "techcorp-solutions-linux",
  "version": "1.0.0",
  "description": "TechCorp Solutions - Linux Deployment",
  "main": "start.js",
  "scripts": {
    "start": "node start.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "mysql": "^2.18.1",
    "body-parser": "^1.20.2",
    "express-session": "^1.17.3",
    "ejs": "^3.1.9",
    "express-ejs-layouts": "^2.5.1",
    "passport": "^0.6.0",
    "passport-local": "^1.0.0",
    "crypto": "^1.0.1"
  }
}
EOF

print_status "Step 7: Installing npm dependencies..."
npm install

print_status "Step 8: Creating main application file adapted for reverse proxy..."
# Create the main application file following the homework methodology
cat > start.js << EOF
const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const session = require('express-session');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const crypto = require('crypto');
const path = require('path');
const expressLayouts = require('express-ejs-layouts');

const app = express();

// Configuration for reverse proxy setup (following homework methodology)
const INTERNAL_PORT = process.env.INTERNAL_PORT || ${INTERNAL_PORT};
const BASE_PATH = process.env.BASE_PATH || '/${ROUTE}';

// Database configuration (following homework methodology)
const DB_CONFIG = {
    host: 'localhost',
    user: process.env.DB_USER || '${DB_USER}',
    password: process.env.DB_PASS || 'abc123',
    database: process.env.DB_NAME || '${DB_NAME}',
    multipleStatements: true
};

// MySQL connection
const connection = mysql.createConnection(DB_CONFIG);

connection.connect((err) => {
    if (!err) {
        console.log("Database is connected ...");
        // Ensure required tables exist
        ensureTablesExist();
    } else {
        console.log("Error connecting database:", err);
    }
});

// Middleware setup
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
    secret: 'techcorp_session_secret_2025',
    resave: false,
    saveUninitialized: false,
    cookie: { maxAge: 1000 * 60 * 60 * 24 }
}));

app.use(passport.initialize());
app.use(passport.session());

// View engine setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(expressLayouts);
app.set('layout', 'layout');

// Static files (with base path for reverse proxy)
app.use(BASE_PATH, express.static('public'));

// Helper functions
function genPassword(password) {
    return crypto.createHash('sha256').update(password).digest('hex');
}

function validPassword(password, hash) {
    return hash === crypto.createHash('sha256').update(password).digest('hex');
}

// Ensure required tables exist
function ensureTablesExist() {
    const createUsersTable = \`
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            password_hash VARCHAR(255) NOT NULL,
            role ENUM('visitor', 'registered', 'admin') DEFAULT 'registered',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    \`;
    
    const createEmployeeTable = \`
        CREATE TABLE IF NOT EXISTS employee (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(45) NOT NULL,
            address VARCHAR(70) NOT NULL,
            age INT NOT NULL
        )
    \`;
    
    connection.query(createUsersTable, (err) => {
        if (err) console.log("Error creating users table:", err);
    });
    
    connection.query(createEmployeeTable, (err) => {
        if (err) console.log("Error creating employee table:", err);
        else {
            // Insert sample data if table is empty
            connection.query("SELECT COUNT(*) as count FROM employee", (err, result) => {
                if (!err && result[0].count === 0) {
                    const insertSampleData = \`
                        INSERT INTO employee (name, address, age) VALUES 
                        ('Mark Smith', 'Budapest', 35),
                        ('Julia Brown', 'Szeged', 20),
                        ('Peter Cooper', 'Debrecen', 23),
                        ('TechCorp Admin', 'Headquarters', 30),
                        ('System User', 'Remote', 25)
                    \`;
                    connection.query(insertSampleData);
                }
            });
        }
    });
    
    // Create default admin user
    const adminHash = genPassword('admin123');
    const insertAdmin = \`
        INSERT IGNORE INTO users (username, email, password_hash, role) 
        VALUES ('admin', 'admin@techcorp.com', '\${adminHash}', 'admin')
    \`;
    connection.query(insertAdmin);
}

// Passport configuration
passport.use(new LocalStrategy((username, password, done) => {
    connection.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
        if (err) return done(err);
        if (results.length === 0) return done(null, false);
        
        const user = results[0];
        const isValid = validPassword(password, user.password_hash);
        
        if (isValid) return done(null, user);
        else return done(null, false);
    });
}));

passport.serializeUser((user, done) => done(null, user.id));
passport.deserializeUser((userId, done) => {
    connection.query('SELECT * FROM users WHERE id = ?', [userId], (err, results) => {
        if (err) return done(err);
        done(null, results[0]);
    });
});

// Routes (following homework URL structure)
app.get(BASE_PATH + '/', (req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write('<h1>TechCorp Solutions</h1>');
    res.write('<p>Request URL: ' + req.url + '</p>');
    res.write('<p>Welcome to TechCorp Solutions!</p>');
    res.write('<p><a href="' + BASE_PATH + '/employees">View Employees</a></p>');
    res.write('<p><a href="' + BASE_PATH + '/login">Login</a></p>');
    res.write('<p><a href="' + BASE_PATH + '/health">Health Check</a></p>');
    res.end();
});

// Employee list (following homework database display methodology)
app.get(BASE_PATH + '/employees', (req, res) => {
    connection.query("SELECT * FROM employee", (err, result) => {
        if (err) {
            res.writeHead(500, {'Content-Type': 'text/html; charset=utf-8'});
            res.end('Database error: ' + err);
            return;
        }
        
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Employees</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        
        let text = '<table border="1"><tr><th>ID</th><th>Name</th><th>Address</th><th>Age</th></tr>';
        for(let i = 0; i < result.length; i++) {
            text += '<tr>';
            for(let j in result[i]) {
                text += '<td>' + result[i][j] + '</td>';
            }
            text += '</tr>';
        }
        text += '</table>';
        
        res.write(text);
        res.write('<p><a href="' + BASE_PATH + '/">Back to Home</a></p>');
        res.end();
    });
});

// Simple login page
app.get(BASE_PATH + '/login', (req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write('<h1>TechCorp Login</h1>');
    res.write('<form method="post" action="' + BASE_PATH + '/login">');
    res.write('Username: <input type="text" name="username" required><br><br>');
    res.write('Password: <input type="password" name="password" required><br><br>');
    res.write('<input type="submit" value="Login">');
    res.write('</form>');
    res.write('<p>Default: admin / admin123</p>');
    res.write('<p><a href="' + BASE_PATH + '/">Back to Home</a></p>');
    res.end();
});

// Login handler
app.post(BASE_PATH + '/login', passport.authenticate('local', {
    successRedirect: BASE_PATH + '/',
    failureRedirect: BASE_PATH + '/login'
}));

// Health check (following homework methodology)
app.get(BASE_PATH + '/health', (req, res) => {
    connection.query('SELECT 1 as ok', (err) => {
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Health Check</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        if (err) {
            res.write('<p style="color: red;">Database: ERROR - ' + err + '</p>');
        } else {
            res.write('<p style="color: green;">Database: Connected</p>');
        }
        res.write('<p style="color: green;">Application: Running</p>');
        res.write('<p>Port: ' + INTERNAL_PORT + '</p>');
        res.write('<p>Base Path: ' + BASE_PATH + '</p>');
        res.write('<p><a href="' + BASE_PATH + '/">Back to Home</a></p>');
        res.end();
    });
});

// Catch all route for demo purposes (following homework req.url display)
app.get(BASE_PATH + '/*', (req, res) => {
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write('<h1>TechCorp Solutions</h1>');
    res.write('<p>Request URL: ' + req.url + '</p>');
    res.write('<p>Multi-level route example</p>');
    res.write('<p><a href="' + BASE_PATH + '/">Back to Home</a></p>');
    res.end();
});

// Start server (following homework methodology)
const server = app.listen(INTERNAL_PORT, () => {
    console.log('TechCorp Solutions app listening on internal port ' + INTERNAL_PORT);
    console.log('Access via reverse proxy: http://IP-ADDRESS/${ROUTE}/');
    console.log('Health check: http://IP-ADDRESS/${ROUTE}/health');
});

module.exports = app;
EOF

print_status "Step 9: Creating environment configuration..."
cat > .env << EOF
# Database configuration (following homework methodology)
DB_USER=${DB_USER}
DB_PASS=abc123
DB_NAME=${DB_NAME}

# Application configuration
INTERNAL_PORT=${INTERNAL_PORT}
BASE_PATH=/${ROUTE}
EOF

print_warning "IMPORTANT: Update your database password!"
print_warning "1. Login to MySQL: mysql -u ${DB_USER} -p"
print_warning "2. Change password: SET PASSWORD = PASSWORD('your_new_password');"
print_warning "3. Update .env file with new password"

print_status "Step 10: Starting application with PM2 (following homework methodology)..."
pm2 delete techcorp 2>/dev/null || true
pm2 start start.js --name techcorp
pm2 save

print_status "============================================"
print_status "Deployment completed successfully!"
print_status "============================================"

echo ""
print_status "Application Details (Following NodeJS Homework Method):"
echo "  - Internal Port: ${INTERNAL_PORT}"
echo "  - Route: ${ROUTE}"
echo "  - Access URL: http://IP-ADDRESS/${ROUTE}/"
echo "  - Health Check: http://IP-ADDRESS/${ROUTE}/health"
echo "  - Employees: http://IP-ADDRESS/${ROUTE}/employees"
echo ""
print_status "PM2 Management Commands:"
echo "  - Check status: pm2 list"
echo "  - View logs: pm2 logs techcorp"
echo "  - Restart: pm2 restart techcorp"
echo "  - Stop: pm2 stop techcorp"
echo "  - Delete: pm2 delete techcorp"
echo ""
print_status "Database Commands:"
echo "  - Connect: mysql -u ${DB_USER} -p"
echo "  - Use database: use ${DB_NAME};"
echo "  - Check tables: show tables;"
echo "  - View employees: select * from employee;"

# Test the deployment
print_status "Testing deployment..."
sleep 3
if curl -s http://localhost:${INTERNAL_PORT}/${ROUTE}/ > /dev/null; then
    print_status "✅ Application is running successfully!"
    print_status "Access it via: http://IP-ADDRESS/${ROUTE}/"
else
    print_warning "❌ Application test failed. Check logs with: pm2 logs techcorp"
fi