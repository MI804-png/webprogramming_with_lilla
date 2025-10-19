/**
 * Smoke test - verifies the server starts and responds to basic requests
 * This test can run without a real database connection
 */
const http = require('http');
const { spawn } = require('child_process');
const path = require('path');

const TEST_PORT = process.env.PORT || '3001';
const TEST_TIMEOUT = 10000; // 10 seconds

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
console.log('Port:', TEST_PORT);

// Start the server as a subprocess to isolate it
const serverProcess = spawn('node', ['start.js'], {
  cwd: path.join(__dirname, '..'),
  env: {
    ...process.env,
    PORT: TEST_PORT,
    NODE_ENV: 'test',
    DB_HOST: 'localhost',
    DB_PORT: '3306',
    DB_USER: 'test',
    DB_PASS: 'test',
    DB_NAME: 'test_db',
    SESSION_SECRET: 'test_secret'
  },
  stdio: ['ignore', 'pipe', 'pipe']
});

let serverReady = false;
let testPassed = false;

// Capture server output
serverProcess.stdout.on('data', (data) => {
  const output = data.toString();
  console.log('Server output:', output.trim());
  
  // Check if server is ready
  if (output.includes('listening on port')) {
    serverReady = true;
    
    // Wait a bit for server to fully initialize
    setTimeout(() => {
      console.log('Checking health endpoint...');
      checkHealth(TEST_PORT, (err, data, statusCode) => {
        if (err) {
          console.error('❌ Health check failed:', err.message);
          serverProcess.kill();
          process.exit(1);
        }
        
        if (statusCode !== 200) {
          console.error(`❌ Health check returned status ${statusCode}`);
          serverProcess.kill();
          process.exit(1);
        }
        
        if (data.status !== 'ok' && data.status !== 'error') {
          console.error('❌ Health check status is unexpected:', data);
          serverProcess.kill();
          process.exit(1);
        }
        
        console.log('✓ Server started successfully');
        console.log('✓ Health endpoint responding correctly');
        console.log('✓ Health status:', data.status);
        console.log('✓ Database connection:', data.database ? 'connected' : 'not connected (expected in test)');
        console.log('✅ Smoke test passed!');
        
        testPassed = true;
        serverProcess.kill();
        process.exit(0);
      });
    }, 1000);
  }
});

serverProcess.stderr.on('data', (data) => {
  const output = data.toString();
  // Only log non-database connection errors
  if (!output.includes('Database Connection Failed') && !output.includes('ECONNREFUSED')) {
    console.error('Server error:', output.trim());
  }
});

serverProcess.on('error', (error) => {
  console.error('❌ Failed to start server:', error.message);
  process.exit(1);
});

serverProcess.on('exit', (code) => {
  if (!testPassed) {
    console.error('❌ Server exited before test completed with code:', code);
    process.exit(1);
  }
});

// Timeout the test after TEST_TIMEOUT
setTimeout(() => {
  if (!testPassed) {
    console.error('❌ Test timeout - server did not become ready');
    serverProcess.kill();
    process.exit(1);
  }
}, TEST_TIMEOUT);

// Handle process termination
process.on('SIGINT', () => {
  serverProcess.kill();
  process.exit(1);
});

process.on('SIGTERM', () => {
  serverProcess.kill();
  process.exit(1);
});
