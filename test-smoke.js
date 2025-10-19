#!/usr/bin/env node
/**
 * Smoke test for TechCorp Solutions application
 * Verifies that the server starts and responds to health check
 */

const http = require('http');

// Configuration
const HOST = process.env.HOST || 'localhost';
const PORT = process.env.PORT || 3000;
const MAX_RETRIES = 10;
const RETRY_DELAY = 1000; // ms

let retries = 0;

function checkHealth() {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: HOST,
            port: PORT,
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
                if (res.statusCode === 200) {
                    try {
                        const health = JSON.parse(data);
                        console.log('✓ Health check passed:', health);
                        
                        if (health.status === 'ok') {
                            console.log('✓ Application status: OK');
                            resolve(true);
                        } else {
                            reject(new Error('Application status not OK'));
                        }
                    } catch (error) {
                        reject(new Error('Invalid health check response: ' + error.message));
                    }
                } else {
                    reject(new Error(`Health check failed with status ${res.statusCode}`));
                }
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.on('timeout', () => {
            req.destroy();
            reject(new Error('Health check request timed out'));
        });

        req.end();
    });
}

async function runSmokeTest() {
    console.log(`Starting smoke test for http://${HOST}:${PORT}/health`);
    
    while (retries < MAX_RETRIES) {
        try {
            await checkHealth();
            console.log('\n✓ Smoke test PASSED');
            process.exit(0);
        } catch (error) {
            retries++;
            console.log(`✗ Attempt ${retries}/${MAX_RETRIES} failed: ${error.message}`);
            
            if (retries < MAX_RETRIES) {
                console.log(`  Retrying in ${RETRY_DELAY}ms...`);
                await new Promise(resolve => setTimeout(resolve, RETRY_DELAY));
            }
        }
    }
    
    console.error('\n✗ Smoke test FAILED after', MAX_RETRIES, 'attempts');
    process.exit(1);
}

runSmokeTest();
