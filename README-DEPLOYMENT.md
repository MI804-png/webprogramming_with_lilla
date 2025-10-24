# 🚀 TechCorp Solutions - Complete Linux Deployment Package

## 📋 Your Assignment Details
- **Student:** Nabil Salama Rezk Mikhael
- **Neptun:** IHUTSC  
- **Linux User:** student206
- **Database User:** studb206
- **Internal Port:** 4206
- **Route:** app206

## 📦 Deployment Files Created

### 1. **Simple Version** (Recommended for Quick Start)
- `simple-exercise.js` - Basic homework-style application
- Just displays "Hello World" with your assignment info

### 2. **Full TechCorp Version**
- `start-homework-style.js` - Complete application with database
- Includes employee table, routing, and TechCorp features

### 3. **Deployment Scripts**
- `deploy-nabil-assignment.sh` - Automated deployment script
- `DEPLOYMENT-NABIL.md` - Step-by-step manual instructions

## 🎯 Quick Deployment Commands

### On Linux Server:

```bash
# 1. Connect to your Linux server
ssh student206@IP-ADDRESS

# 2. Create exercise directory
mkdir ~/exercise && cd ~/exercise

# 3. Create simple test application
cat > exercise.js << 'EOF'
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
console.log('Server listening on port 4206');
EOF

# 4. Test the application
node exercise.js

# 5. Use PM2 for production
sudo npm install -g pm2
pm2 start exercise.js --name techcorp-app206
pm2 save
```

## 🌐 Access Your Application

After deployment, access at:
- **Main URL:** `http://IP-ADDRESS/app206/`
- **Test Routes:** `http://IP-ADDRESS/app206/test`
- **Multi-level:** `http://IP-ADDRESS/app206/aaa/bbb`

## 📚 Available Files for Upload

1. **`simple-exercise.js`** - Basic version (easiest to start)
2. **`start-homework-style.js`** - Full TechCorp application
3. **`deploy-nabil-assignment.sh`** - Automated deployment
4. **`DEPLOYMENT-NABIL.md`** - Complete instructions

## 🔧 Management Commands

```bash
# Check PM2 status
pm2 list

# View logs
pm2 logs techcorp-app206

# Restart application
pm2 restart techcorp-app206

# Stop application
pm2 stop techcorp-app206
```

## ✅ Success Checklist

- [ ] SSH connection to student206@IP-ADDRESS works
- [ ] Node.js is installed (`node --version`)
- [ ] Application starts with `node exercise.js`
- [ ] PM2 manages the process
- [ ] Accessible via `http://IP-ADDRESS/app206/`
- [ ] Shows your name and assignment details

## 🆘 Quick Troubleshooting

**Port already in use:**
```bash
sudo netstat -tlnp | grep :4206
```

**Application not accessible:**
- Check PM2 status: `pm2 list`
- Check logs: `pm2 logs techcorp-app206`
- Verify port: `curl http://localhost:4206/app206/`

## 📄 Files Ready for Transfer

All deployment files are ready in your exercise folder. You can:

1. **Upload via WinSCP** to your Linux server
2. **Copy-paste** the code directly
3. **Use the automated deployment script**

Your TechCorp Solutions application is ready for deployment! 🎉