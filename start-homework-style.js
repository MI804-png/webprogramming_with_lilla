// TechCorp Solutions - Following NodeJS Homework Methodology
// This follows the exact structure from "Using Linux for NodeJS Homework"

const http = require('http');
const mysql = require('mysql');
const url = require('url');

// Configuration (set these based on your assignment)
// Nabil Salama Rezk Mikhael - IHUTSC - student206/studb206 - port 4206 - route app206
const INTERNAL_PORT = process.env.INTERNAL_PORT || 4206;
const BASE_ROUTE = process.env.BASE_ROUTE || '/app206';

// Database configuration (following homework methodology)
const connection = mysql.createConnection({
    host: 'localhost',
    user: process.env.DB_USER || 'studb206',
    password: process.env.DB_PASS || 'mikha@2001',
    database: process.env.DB_NAME || 'db206'
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
    // Create employee table if not exists (from homework)
    const createEmployeeTable = `
        CREATE TABLE IF NOT EXISTS employee (
            id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
            name VARCHAR(45) NOT NULL DEFAULT '',
            address VARCHAR(70) NOT NULL DEFAULT '',
            age INT NOT NULL,
            PRIMARY KEY (id)
        ) ENGINE = MYISAM CHARACTER SET utf8 COLLATE utf8_general_ci
    `;
    
    connection.query(createEmployeeTable, function(err) {
        if (err) {
            console.log("Error creating employee table:", err);
        } else {
            // Insert sample data if table is empty
            connection.query("SELECT COUNT(*) as count FROM employee", function(err, result) {
                if (!err && result[0].count === 0) {
                    const insertData = `
                        INSERT INTO employee (id, name, address, age) VALUES 
                        (1, 'Mark Smith', 'Budapest', 35),
                        (2, 'Julia Brown', 'Szeged', 20),
                        (3, 'Peter Cooper', 'Debrecen', 23),
                        (4, 'TechCorp Admin', 'Headquarters', 30),
                        (5, 'System Manager', 'Remote Office', 28)
                    `;
                    connection.query(insertData, function(err) {
                        if (err) console.log("Error inserting sample data:", err);
                        else console.log("Sample employee data inserted");
                    });
                }
            });
        }
    });
    
    // Create users table for TechCorp
    const createUsersTable = `
        CREATE TABLE IF NOT EXISTS users (
            id INT AUTO_INCREMENT PRIMARY KEY,
            username VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(255) NOT NULL,
            role VARCHAR(20) DEFAULT 'user',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    `;
    
    connection.query(createUsersTable, function(err) {
        if (err) {
            console.log("Error creating users table:", err);
        } else {
            // Insert admin user if not exists
            connection.query("SELECT COUNT(*) as count FROM users WHERE username = 'admin'", function(err, result) {
                if (!err && result[0].count === 0) {
                    const insertAdmin = "INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'admin')";
                    connection.query(insertAdmin, function(err) {
                        if (err) console.log("Error creating admin user:", err);
                        else console.log("Admin user created (admin/admin123)");
                    });
                }
            });
        }
    });
}

// Main server (following homework methodology)
const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    
    // Route handling (following homework req.url display pattern)
    if (pathname === BASE_ROUTE + '/' || pathname === BASE_ROUTE) {
        // Main page
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Solutions</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        res.write('<p>Welcome to TechCorp Solutions!</p>');
        res.write('<h3>Available Pages:</h3>');
        res.write('<ul>');
        res.write('<li><a href="' + BASE_ROUTE + '/employees">View Employees</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/database">Database Test</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/health">Health Check</a></li>');
        res.write('<li><a href="' + BASE_ROUTE + '/demo/test">Multi-level Route Demo</a></li>');
        res.write('</ul>');
        res.end();
        
    } else if (pathname === BASE_ROUTE + '/employees') {
        // Display employees table (following homework table display methodology)
        displayEmployees(req, res);
        
    } else if (pathname === BASE_ROUTE + '/database') {
        // Database connection test (following homework methodology)
        testDatabase(req, res);
        
    } else if (pathname === BASE_ROUTE + '/health') {
        // Health check
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Health Check</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        res.write('<p style="color: green;">✅ Application is running</p>');
        res.write('<p style="color: green;">✅ Server port: ' + INTERNAL_PORT + '</p>');
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
        
    } else if (pathname.startsWith(BASE_ROUTE + '/')) {
        // Multi-level route demo (following homework methodology)
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Solutions</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        res.write('<p>Multi-level route example</p>');
        res.write('<p>This demonstrates the reverse proxy routing capability.</p>');
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
        
    } else {
        // 404 - Not found
        res.writeHead(404, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>404 - Not Found</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        res.write('<p><a href="' + BASE_ROUTE + '/">Go to TechCorp Home</a></p>');
        res.end();
    }
});

// Database test function (following homework methodology)
function testDatabase(req, res) {
    connection.connect(function(err) {
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Database Test</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        
        if (!err) {
            res.write('<p style="color: green;">✅ Database is connected ...</p>');
        } else {
            res.write('<p style="color: red;">❌ Error connecting database ...</p>');
        }
        
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
    });
}

// Display employees function (following homework table display methodology)
function displayEmployees(req, res) {
    connection.query("SELECT * FROM employee", function(err, result, fields) {
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.write('<h1>TechCorp Employees</h1>');
        res.write('<p>Request URL: ' + req.url + '</p>');
        
        if (err) {
            res.write('<p style="color: red;">Database error: ' + err + '</p>');
        } else {
            console.log(fields);
            console.log(result);
            
            // Display table (following homework methodology)
            res.write('<table border="1" cellpadding="5" cellspacing="0">');
            res.write('<tr><th>ID</th><th>Name</th><th>Address</th><th>Age</th></tr>');
            
            let text = "";
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
            
            res.write('<h3>Raw Data (Console Format):</h3>');
            res.write('<pre>' + text + '</pre>');
        }
        
        res.write('<p><a href="' + BASE_ROUTE + '/">Back to Home</a></p>');
        res.end();
    });
}

// Start server (following homework methodology)
server.listen(INTERNAL_PORT, function() {
    console.log('TechCorp Solutions app listening on internal port ' + INTERNAL_PORT);
    console.log('Base route: ' + BASE_ROUTE);
    console.log('Access via reverse proxy at: http://IP-ADDRESS' + BASE_ROUTE + '/');
    console.log('');
    console.log('Available endpoints:');
    console.log('  - Home: http://IP-ADDRESS' + BASE_ROUTE + '/');
    console.log('  - Employees: http://IP-ADDRESS' + BASE_ROUTE + '/employees');
    console.log('  - Database Test: http://IP-ADDRESS' + BASE_ROUTE + '/database');
    console.log('  - Health: http://IP-ADDRESS' + BASE_ROUTE + '/health');
    console.log('  - Multi-level: http://IP-ADDRESS' + BASE_ROUTE + '/demo/test');
});

module.exports = server;