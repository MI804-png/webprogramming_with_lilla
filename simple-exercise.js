// Simple homework-style application for Nabil Salama Rezk Mikhael
// Following the exact methodology from "Using Linux for NodeJS Homework"
// Assignment: student206/studb206 - port 4206 - route app206

const http = require('http'); 

const server = http.createServer((req, res) => { 
    res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
    res.write(req.url + '\n');
    res.write('<h1>TechCorp Solutions</h1>');
    res.write('<p>Student: Nabil Salama Rezk Mikhael (IHUTSC)</p>');
    res.write('<p>Assignment: student206/studb206 - port 4206 - route app206</p>');
    res.write('<p>Hello World!</p>');
    res.end();
}).listen(4206);

console.log('TechCorp Solutions listening on port 4206');
console.log('Access via: http://IP-ADDRESS/app206/');