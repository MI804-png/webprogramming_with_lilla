#!/usr/bin/env bash
set -euo pipefail

# TechCorp Solutions - Linux Deployment for Nabil Salama Rezk Mikhael
# Assignment Details: IHUTSC - student206/studb206 - port 4206 - route app206

echo "============================================"
echo "TechCorp Solutions - Linux Deployment"
echo "Student: Nabil Salama Rezk Mikhael (IHUTSC)"
echo "============================================"

# Your specific assignment configuration
STUDENT_USER="student206"
DB_USER="studb206"
DB_NAME="db206"
INTERNAL_PORT="4206"
ROUTE="app206"

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

print_status "Assignment Details:"
echo "  - Linux username: ${STUDENT_USER}"
echo "  - Database username: ${DB_USER}"
echo "  - Database name: ${DB_NAME}"
echo "  - Internal port: ${INTERNAL_PORT}"
echo "  - Route: ${ROUTE}"
echo ""

print_status "Step 1: Installing Node.js (if not present)..."
if ! command -v node >/dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js already installed: $(node -v)"
fi

print_status "Step 2: Installing MySQL module..."
# Initialize npm if package.json doesn't exist
if [ ! -f package.json ]; then
    npm init -y
fi
npm install mysql

print_status "Step 3: Creating the homework-style application..."
cat > exercise.js << EOF
// TechCorp Solutions - Following NodeJS Homework Methodology
// Student: Nabil Salama Rezk Mikhael (IHUTSC)
// Configuration: student206/studb206 - port 4206 - route app206

const http = require('http');
const mysql = require('mysql');
const url = require('url');

// Your specific assignment configuration
const INTERNAL_PORT = 4206;
const BASE_ROUTE = '/app206';

// Database configuration (following homework methodology)
const connection = mysql.createConnection({
    host: 'localhost',
    user: '${DB_USER}',
    password: 'abc123', // Change this after first login
    database: '${DB_NAME}'
});

// Connect to database
connection.connect(function(err) {
    if (!err) {
        console.log("Database is connected ...");
        setupTables();
    } else {
        console.log("Error connecting database ...");
        console.log(err);
    }
});

// Setup required tables (following homework methodology)
function setupTables() {
    // Create employee table (from homework)
    const createEmployeeTable = \`
        CREATE TABLE IF NOT EXISTS employee (
            id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
            name VARCHAR(45) NOT NULL DEFAULT '',
            address VARCHAR(70) NOT NULL DEFAULT '',
            age INT NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci
    \`;
    
    connection.query(createEmployeeTable, function(err) {
        if (err) {
            console.log("Error creating employee table:", err);
        } else {
            // Insert sample data (from homework)
            connection.query("SELECT COUNT(*) as count FROM employee", function(err, result) {
                if (!err && result[0].count === 0) {
                    const insertData = \`
                        INSERT INTO employee (id, name, address, age) VALUES 
                        (1, 'Mark Smith', 'Budapest', 35),
                        (2, 'Julia Brown', 'Szeged', 20),
                        (3, 'Peter Cooper', 'Debrecen', 23),
                        (4, 'Nabil Mikhael', 'TechCorp HQ', 25),
                        (5, 'System Admin', 'Remote', 30)
                    \`;
                    connection.query(insertData, function(err) {
                        if (err) console.log("Error inserting sample data:", err);
                        else console.log("Sample employee data inserted");
                    });
                }
            });
        }
    });
}

// Main server (following homework methodology)
const server = http.createServer((req, res) => {
    // Display req.url as shown in homework examples
    console.log("Request URL:", req.url);
    
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    
    // Route handling (following homework req.url display pattern)
    if (pathname === BASE_ROUTE + '/' || pathname === BASE_ROUTE) {
        // Main page (following homework style)
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write(req.url + '\\n');
        res.write('<h1>TechCorp Solutions</h1>');
        res.write('<p>Student: Nabil Salama Rezk Mikhael (IHUTSC)</p>');
        res.write('<p>Assignment: ${STUDENT_USER}/${DB_USER} - port ${INTERNAL_PORT} - route ${ROUTE}</p>');
        res.write('<h3>Available Pages:</h3>');
        res.write('<ul>');
        res.write('<li><a href="' + BASE_ROUTE + '/employees">View Employees (Database Table)</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/database">Database Connection Test</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/aaa">Multi-level Route Example</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/aaa/bbb">Deep Route Example</a></li>');
        res.write('</ul>');
        res.end();
        
    } else if (pathname === BASE_ROUTE + '/employees') {
        // Display employees table (following homework table display methodology)
        displayEmployeesTable(req, res);
        
    } else if (pathname === BASE_ROUTE + '/database') {
        // Database connection test (following homework methodology)
        testDatabaseConnection(req, res);
        
    } else if (pathname.startsWith(BASE_ROUTE + '/')) {
        // Multi-level route demo (following homework methodology)
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write(req.url + '\\n');
        res.write('<h1>TechCorp Solutions</h1>');
        res.write('<p>Multi-level route example</p>');
        res.write('<p>This demonstrates: http://IP-ADDRESS${BASE_ROUTE}/aaa/bbb</p>');
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
        
    } else {
        // Default response for any other route
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write(req.url + '\\n');
        res.write('<h1>Hello World!</h1>');
        res.write('<p><a href="' + BASE_ROUTE + '/">Go to TechCorp Home</a></p>');
        res.end();
    }
});

// Database connection test (following homework methodology)
function testDatabaseConnection(req, res) {
    const con = mysql.createConnection({
        host: 'localhost',
        user: '${DB_USER}',
        password: 'abc123',
        database: '${DB_NAME}'
    });
    
    con.connect(function(err) {
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write(req.url + '\\n');
        res.write('<h1>Database Connection Test</h1>');
        
        if (!err) {
            res.write('<p style="color: green;">Database is connected ...</p>');
        } else {
            res.write('<p style="color: red;">Error connecting database ...</p>');
        }
        
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
    });
}

// Display employees table (following homework methodology exactly)
function displayEmployeesTable(req, res) {
    const con = mysql.createConnection({
        host: 'localhost',
        user: '${DB_USER}',
        password: 'abc123',
        database: '${DB_NAME}'
    });
    
    con.connect(function(err) {
        if (err) {
            res.writeHead(500, {'Content-Type': 'text/html; charset=utf-8'});
            res.end('Database connection error');
            return;
        }
        
        con.query("SELECT * FROM employee;", function(err, result, fields) {
            if (err) {
                res.writeHead(500, {'Content-Type': 'text/html; charset=utf-8'});
                res.end('Database query error: ' + err);
                return;
            }
            
            // Log to console (as shown in homework)
            console.log(fields);
            console.log(result);
            
            res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
            res.write(req.url + '\\n');
            res.write('<h1>Employee Table</h1>');
            
            // Display table following homework methodology
            let text = "";
            res.write('<table border="1"><tr><th>ID</th><th>Name</th><th>Address</th><th>Age</th></tr>');
            
            for (let i = 0; i < result.length; i++) {
                res.write('<tr>');
                for (let j in result[i]) {
                    text += result[i][j] + " ";
                    res.write('<td>' + result[i][j] + '</td>');
                }
                text += "<br>";
                res.write('</tr>');
            }
            res.write('</table>');
            
            res.write('<h3>Raw Output (Console Style):</h3>');
            res.write('<pre>' + text + '</pre>');
            res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
            res.end();
        });
    });
}

// Start server (following homework methodology)
server.listen(INTERNAL_PORT, function() {
    console.log('TechCorp Solutions listening on internal port ' + INTERNAL_PORT);
    console.log('Access via: http://IP-ADDRESS${BASE_ROUTE}/');
    console.log('Route: ${ROUTE} => Internal Port: ${INTERNAL_PORT}');
});
EOF

print_status "Step 4: Creating environment configuration..."
cat > .env << EOF
# Assignment configuration for Nabil Salama Rezk Mikhael (IHUTSC)
STUDENT_USER=${STUDENT_USER}
DB_USER=${DB_USER}
DB_PASS=abc123
DB_NAME=${DB_NAME}
INTERNAL_PORT=${INTERNAL_PORT}
BASE_ROUTE=/${ROUTE}
EOF

print_status "Step 5: Installing PM2 if not present..."
if ! command -v pm2 >/dev/null 2>&1; then
    sudo npm install -g pm2
fi

print_status "Step 6: Starting application with PM2..."
pm2 delete techcorp-${ROUTE} 2>/dev/null || true
pm2 start exercise.js --name techcorp-${ROUTE}
pm2 save

print_status "============================================"
print_status "Deployment completed successfully!"
print_status "============================================"

echo ""
print_status "Your Assignment Details:"
echo "  - Student: Nabil Salama Rezk Mikhael"
echo "  - Neptun: IHUTSC"
echo "  - Linux user: ${STUDENT_USER}"
echo "  - Database user: ${DB_USER}"
echo "  - Internal port: ${INTERNAL_PORT}"
echo "  - Route: ${ROUTE}"
echo ""
print_status "Access URLs:"
echo "  - Main: http://IP-ADDRESS/${ROUTE}/"
echo "  - Employees: http://IP-ADDRESS/${ROUTE}/employees"
echo "  - Database Test: http://IP-ADDRESS/${ROUTE}/database"
echo "  - Multi-level: http://IP-ADDRESS/${ROUTE}/aaa/bbb"
echo ""
print_status "PM2 Commands:"
echo "  - Status: pm2 list"
echo "  - Logs: pm2 logs techcorp-${ROUTE}"
echo "  - Restart: pm2 restart techcorp-${ROUTE}"
echo "  - Stop: pm2 stop techcorp-${ROUTE}"
echo ""
print_warning "Remember to:"
echo "  1. Change database password: mysql -u ${DB_USER} -p"
echo "  2. SET PASSWORD = PASSWORD('new_password');"
echo "  3. Update .env file with new password"

# Test the deployment
print_status "Testing deployment..."
sleep 2
if curl -s http://localhost:${INTERNAL_PORT}/${ROUTE}/ >/dev/null 2>&1; then
    print_status "✅ Application is running!"
    print_status "Access it at: http://IP-ADDRESS/${ROUTE}/"
else
    print_warning "❌ Test failed. Check: pm2 logs techcorp-${ROUTE}"
fi