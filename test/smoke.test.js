/**
 * Smoke test - verifies the server starts and responds to basic requests
 */
const http = require('http');

// Mock database connection for testing
const originalEnv = process.env;

function checkHealth(port, callback) {
  const options = {
    hostname: 'localhost',
    port: port,
    path: '/health',
    method: 'GET',
    timeout: 5000
  };

  const req = http.request(options, (res) => {
    let data = '';
    
    res.on('data', (chunk) => {
      data += chunk;
    });
    
    res.on('end', () => {
      try {
        const response = JSON.parse(data);
        callback(null, response, res.statusCode);
      } catch (e) {
        callback(e);
      }
    });
  });

  req.on('error', (err) => {
    callback(err);
  });

  req.on('timeout', () => {
    req.destroy();
    callback(new Error('Request timeout'));
  });

  req.end();
}

// Main test
console.log('Starting smoke test...');

// Set test environment
process.env.PORT = process.env.PORT || '3001';
process.env.DB_HOST = process.env.DB_HOST || 'localhost';
process.env.NODE_ENV = 'test';

// Start the server
let server;
try {
  // Import and start the app
  const app = require('../start.js');
  
  // Wait for server to be ready
  setTimeout(() => {
    console.log('Checking health endpoint...');
    checkHealth(process.env.PORT, (err, data, statusCode) => {
      if (err) {
        console.error('❌ Health check failed:', err.message);
        process.exit(1);
      }
      
      if (statusCode !== 200) {
        console.error(`❌ Health check returned status ${statusCode}`);
        process.exit(1);
      }
      
      if (data.status !== 'ok') {
        console.error('❌ Health check status is not ok:', data);
        process.exit(1);
      }
      
      console.log('✓ Server started successfully');
      console.log('✓ Health endpoint responding correctly');
      console.log('✓ Database connection:', data.database ? 'connected' : 'not connected (expected in test)');
      console.log('✅ Smoke test passed!');
      
      // Restore environment and exit
      process.env = originalEnv;
      process.exit(0);
    });
  }, 3000); // Give server 3 seconds to start
  
} catch (error) {
  console.error('❌ Failed to start server:', error.message);
  process.exit(1);
}

// Handle uncaught errors
process.on('uncaughtException', (err) => {
  console.error('❌ Uncaught exception:', err.message);
  process.exit(1);
});
