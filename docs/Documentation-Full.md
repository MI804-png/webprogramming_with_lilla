---
title: "TechCorp Solutions - Full Documentation"
subtitle: "Web Programming II Project"
author: "Web Programming II Students"
date: "2025-10-18"
---

\newpage

# Table of Contents

1. Introduction
2. Project Overview and Requirements
3. Theme Selection
4. Architecture Overview
5. Database Design
6. Authentication and Authorization
7. Application Features
8. Deployment on Linux Server
9. CI/CD and DevOps
10. GitHub Project Management
11. Testing and Verification
12. Security Considerations
13. Conclusion and Future Improvements

\newpage

# 1. Introduction

TechCorp Solutions is a comprehensive web application developed as a Web Programming II homework project. This application demonstrates modern web development practices using Node.js, Express.js, MySQL, and EJS templating.

## Project Goals

- Implement a responsive web application with a free theme
- Provide user authentication with role-based access control
- Display database information through multiple views
- Implement a contact form with message storage
- Create an administrative CRUD interface for data management
- Deploy the application to a Linux server

## Technologies Used

- **Backend**: Node.js v18+, Express.js
- **Database**: MySQL 8.0
- **Template Engine**: EJS (Embedded JavaScript)
- **Authentication**: Passport.js with Local Strategy
- **Session Management**: express-session with MySQL store
- **Styling**: Bootstrap 5 with Bootswatch Lux theme
- **Process Management**: PM2 for production deployment

\newpage

# 2. Project Overview and Requirements

## Functional Requirements

### Authentication System
- User registration with email validation
- Secure login/logout functionality
- Role-based access control (visitor, registered, admin)

### Database Views
- Display data from at least 3 database tables
- Implement proper data relationships
- Show meaningful business data

### Contact Form
- Validate user input
- Store messages in database
- Prevent SQL injection and XSS attacks

### Messages System
- Display contact messages for registered users
- Show newest messages first with timestamps
- Allow admins to update message status

### Admin CRUD
- Complete Create, Read, Update, Delete operations
- Product management interface
- File upload support for product images
- Admin-only access control

## Non-Functional Requirements

- **Responsive Design**: Mobile-first approach using Bootstrap
- **Security**: Input validation, parameterized queries, secure session management
- **Performance**: Connection pooling, efficient database queries
- **Maintainability**: Modular code structure, clear documentation
- **Deployment**: Production-ready with PM2 process management

\newpage

# 3. Theme Selection

## Chosen Theme: Bootswatch Lux

We selected the **Lux** theme from Bootswatch, a free and open-source Bootstrap theme collection.

### Why Lux?

1. **Professional Appearance**: Clean, corporate design suitable for a technology company
2. **Modern UI**: Updated Bootstrap 5 components with smooth animations
3. **Responsive**: Mobile-first design that works on all screen sizes
4. **Free License**: MIT licensed, suitable for academic and commercial use
5. **Easy Integration**: CDN delivery, no build process required

### Theme Integration

The theme is integrated via CDN in the main layout template (`views/layout.ejs`):

```html
<link rel="stylesheet" 
      href="https://cdn.jsdelivr.net/npm/bootswatch@5/dist/lux/bootstrap.min.css">
```

### Color Scheme

- **Primary**: Blue (#1a1a2e)
- **Secondary**: Light gray (#f8f9fa)
- **Accent**: Orange/coral highlights
- **Text**: Dark gray (#212529)

\newpage

# 4. Architecture Overview

## System Architecture

TechCorp Solutions follows a traditional MVC (Model-View-Controller) pattern adapted for Express.js.

## Project Structure

```
webprogramming_with_lilla/
├── .github/
│   ├── workflows/          # GitHub Actions CI/CD
│   ├── dependabot.yml      # Dependency updates
│   └── pull_request_template.md
├── docs/
│   ├── Documentation-Full.md
│   └── screenshots/
├── public/
│   ├── css/                # Custom styles
│   ├── js/                 # Client-side JavaScript
│   └── uploads/            # User-uploaded files
├── routes/
│   ├── auth.js             # Authentication routes
│   ├── database.js         # Database view routes
│   ├── contact.js          # Contact form routes
│   ├── messages.js         # Messages routes
│   └── crud.js             # Admin CRUD routes
├── scripts/
│   └── import-db.sh        # Database import script
├── views/                  # EJS templates
├── company_db.sql          # Database schema
├── ecosystem.config.js     # PM2 configuration
├── start.js                # Application entry point
└── test-smoke.js           # Smoke test for CI/CD
```

\newpage

# 5. Database Design

## Database Schema

### Users Table
Stores user accounts with authentication credentials and roles.

### Products Table
Manages product catalog for CRUD operations with foreign key to categories.

### Categories Table
Organizes products into categories.

### Projects Table
Displays company projects in database views.

### Contact Messages Table
Stores messages submitted through the contact form.

## Database Queries

All database queries use parameterized statements to prevent SQL injection:

```javascript
connection.query(
    'SELECT * FROM users WHERE username = ?',
    [username],
    callback
);
```

\newpage

# 6. Authentication and Authorization

## Authentication Flow

### Registration Process

1. User submits registration form
2. Server validates input (all fields required, passwords match, unique username/email)
3. Password hashed using SHA-256
4. User record created with 'registered' role
5. Redirect to login

### Login Process

1. User submits credentials
2. Passport.js verifies credentials
3. Session created on success
4. Redirect to home page

### Session Management

- Sessions stored in MySQL
- 24-hour session lifetime
- Secure cookie configuration

## Authorization (Role-Based Access Control)

### Roles

1. **Visitor** (not logged in): Home, Database views, Contact form
2. **Registered** (logged-in user): All visitor pages + Messages
3. **Admin** (administrator): All pages including Admin CRUD

### Default Users

- **Admin**: username `admin`, password `admin123`
- **Test User**: username `testuser`, password `hello`

\newpage

# 7. Application Features

## Main Page (Home)

Landing page with hero section, features overview, and call-to-action buttons.

## Database Views

Displays information from multiple tables:
- Users table with role filtering
- Products table with category display
- Projects table with status indicators

## Contact Form

- Validates user input
- Stores messages in database
- Provides user feedback

## Messages Module

- Displays contact messages (registered users only)
- Shows newest messages first
- Admin can update message status (new/read/replied)

## Admin CRUD Interface

Complete product management:
- **Create**: Add new products with image upload
- **Read**: List all products
- **Update**: Edit product details
- **Delete**: Remove products

\newpage

# 8. Deployment on Linux Server

## Server Requirements

- **OS**: Ubuntu 20.04 LTS or newer
- **Node.js**: v18.x or newer
- **MySQL**: 8.0 or newer
- **Process Manager**: PM2
- **RAM**: Minimum 1GB, recommended 2GB+

## Deployment Steps

### 1. Server Preparation

```bash
# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install MySQL
sudo apt install -y mysql-server

# Install PM2
sudo npm install -g pm2
```

### 2. Application Deployment

```bash
# Clone repository
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla

# Install dependencies
npm ci --production

# Configure environment
cp .env.example .env
nano .env
```

### 3. Database Import

```bash
# Using the import script
export DB_HOST=localhost
export DB_USER=techcorp
export DB_PASS=password
export DB_NAME=company_db
./scripts/import-db.sh
```

### 4. Start with PM2

```bash
pm2 start ecosystem.config.js
pm2 save
pm2 startup
```

## GitHub Actions Deployment

### Required Secrets

Configure in GitHub repository settings:

| Secret Name | Description |
|------------|-------------|
| SSH_HOST | Server IP or domain |
| SSH_USER | SSH username |
| SSH_PORT | SSH port (22) |
| SSH_KEY | Private SSH key |
| DB_HOST | Database host |
| DB_PORT | Database port (3306) |
| DB_USER | Database username |
| DB_PASS | Database password |
| DB_NAME | Database name |

### Manual Deployment

1. Go to GitHub Actions tab
2. Select "Deploy to Linux Server"
3. Click "Run workflow"
4. Select branch (main)
5. Confirm

\newpage

# 9. CI/CD and DevOps

## Continuous Integration

### CI Workflow (.github/workflows/ci.yml)

Runs automatically on push and pull requests:
- Checkout code
- Setup Node.js 18
- Install dependencies with npm ci
- Start MySQL test database
- Import database schema
- Start application
- Run smoke test
- Report results

### Smoke Test

Health check endpoint verification:
```bash
npm run test:smoke
```

Tests:
- Server starts successfully
- /health endpoint responds
- Database connectivity
- Response format validation

## Continuous Deployment

### Deploy Workflow (.github/workflows/deploy.yml)

Manual deployment via workflow_dispatch:
- SSH into server
- Git pull latest changes
- Install/update dependencies
- Import database
- Restart PM2 process
- Verify deployment

## Security Scanning

### Dependabot Configuration

- Weekly npm dependency updates
- Automated pull requests for vulnerabilities
- GitHub Actions version updates

### CodeQL Analysis

- JavaScript/Node.js security scanning
- Runs on push, PR, and weekly schedule
- Security-extended query suite
- Results in Security tab

## Documentation PDF

### Docs PDF Workflow

Generates PDF from Documentation-Full.md:
- Uses Pandoc with XeLaTeX
- Includes table of contents
- Numbered sections
- Professional formatting
- Uploaded as artifact

\newpage

# 10. GitHub Project Management

## Repository Organization

**Repository URL**: https://github.com/MI804-png/webprogramming_with_lilla

### Commit History

Minimum 5+ commits showing project progress with conventional commit messages.

## GitHub Project Board

### Board Structure

**Columns:**
1. Backlog - Tasks not yet started
2. In Progress - Currently being worked on
3. Review - Awaiting code review
4. Done - Completed tasks

### Example Issues

1. **Deploy to Linux Server with PM2** - Configure production deployment
2. **Configure Repo Secrets for Deploy** - Add GitHub Actions secrets
3. **Create GitHub Actions CI** - Implement build and test workflow
4. **Create GitHub Actions Deploy** - Manual deployment workflow
5. **Finalize 15+ Page PDF Docs** - Complete documentation
6. **Capture App Screenshots** - Document UI features
7. **Verify Role-Based Menus** - Test access control
8. **Validate CRUD Operations** - Test all CRUD paths
9. **Improve README** - Add badges and instructions
10. **Add Security and Maintenance** - Dependabot and CodeQL

All issues include:
- Clear titles
- Detailed descriptions
- Acceptance criteria checklists
- Appropriate labels (feature, docs, deploy, bug)
- Assignees

\newpage

# 11. Testing and Verification

## Testing Strategy

### Manual Testing

#### Authentication Testing
- Registration with valid/invalid data
- Login with correct/incorrect credentials
- Logout functionality
- Session persistence

#### Role-Based Access Testing
- Visitor restrictions verified
- Registered user access confirmed
- Admin privileges tested
- Menu visibility correct per role

#### Database Views Testing
- All tables display correctly
- Sorting and filtering work
- Data relationships shown

#### Contact Form Testing
- Field validation working
- Messages saved to database
- Success/error feedback shown

#### CRUD Operations Testing
- Create product with/without image
- Read product list
- Update product details
- Delete product
- Validation errors handled

### Automated Testing

#### Smoke Test
```bash
npm run test:smoke
```

Verifies:
- Server starts successfully
- /health endpoint responds
- Database connection status

#### CI/CD Testing

GitHub Actions runs tests automatically on:
- Every push to main
- Every pull request
- Scheduled weekly runs

### Security Testing

#### CodeQL Analysis
- Scans for security vulnerabilities
- Runs automatically on push/PR
- Weekly scheduled scans

#### Manual Security Checks
- SQL injection prevention verified
- XSS prevention confirmed
- Secure session management
- Password hashing implemented

### Browser Compatibility

Tested on:
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers

### Responsive Design Testing

- Mobile (320px - 767px)
- Tablet (768px - 1023px)
- Desktop (1024px+)

\newpage

# 12. Security Considerations

## Current Security Measures

### Authentication Security

#### Password Hashing
Using SHA-256 for password hashing. **Recommendation**: Migrate to bcrypt or argon2 for production.

#### Session Security
- Sessions stored in MySQL (server-side)
- Secure session cookies
- 24-hour expiration

### Input Validation

#### SQL Injection Prevention
All queries use parameterized statements.

#### XSS Prevention
EJS automatically escapes output.

### File Upload Security

- File size limit (5MB)
- File type validation (images only)
- Random filename generation
- Separate upload directory

### Environment Variables

Sensitive data in `.env` (not committed):
- Database credentials
- Session secret

### Dependency Security

- Dependabot for automated updates
- Weekly vulnerability scans
- npm audit integration

### Code Security

- CodeQL automated scanning
- Security-extended query suite
- Weekly scheduled scans

## Known Security Issues

1. **Password Hashing**: SHA-256 without salt
   - **Mitigation**: Plan to migrate to bcrypt

2. **Missing CSRF Protection**
   - **Mitigation**: Add CSRF tokens in future

3. **Rate Limiting Not Implemented**
   - **Mitigation**: Add express-rate-limit

## Security Best Practices

### Deployment Security

1. Use HTTPS in production
2. Restrict database access
3. Strong session secret (32+ characters)
4. Regular backups
5. Log monitoring
6. Keep dependencies updated

\newpage

# 13. Conclusion and Future Improvements

## Project Summary

TechCorp Solutions successfully fulfills all Web Programming II homework requirements:

### Requirements Met ✓

1. Free Responsive Theme (Bootswatch Lux)
2. Authentication (Registration, login, logout)
3. Role-Based Access (Visitor, registered, admin)
4. Database Views (Users, products, projects)
5. Contact Form (Validation and storage)
6. Messages System (View and manage)
7. Admin CRUD (Complete product management)
8. Linux Deployment (PM2, documented)
9. GitHub Requirements (5+ commits, organized)
10. Documentation (15+ pages)

### Technical Achievements

- Modular architecture
- Security best practices
- Responsive design
- CI/CD pipelines
- Automated testing
- Comprehensive documentation

## Lessons Learned

### Development Process

1. **Planning First**: Project board helped organize work
2. **Incremental Development**: Step-by-step prevented bugs
3. **Version Control**: Regular commits tracked progress
4. **Documentation**: Writing alongside code improved clarity

### Technical Insights

1. Express.js is powerful and flexible
2. EJS templating is simple and effective
3. Passport.js simplifies authentication
4. PM2 essential for production
5. GitHub Actions automates workflows

## Future Improvements

### Short-Term

1. Migrate to bcrypt password hashing
2. Add CSRF protection
3. Implement rate limiting
4. Enhance error handling
5. Add pagination

### Medium-Term

1. User profile management
2. Advanced search and filtering
3. Email notifications
4. Activity logging
5. Data export functionality

### Long-Term

1. RESTful API development
2. Advanced features (shopping cart)
3. Analytics dashboard
4. Internationalization
5. Mobile application

## Final Thoughts

TechCorp Solutions demonstrates solid web development fundamentals. The application successfully implements required features while maintaining security, usability, and code quality.

The project serves as:
- Portfolio piece for full-stack skills
- Learning experience in modern web tech
- Foundation for future enhancements
- Evidence of proper development methodology

**Project Status**: ✅ Complete  
**Documentation Version**: 1.0  
**Last Updated**: 2025-10-18

---

# Appendices

## Appendix A: Environment Variables

```bash
DB_HOST=localhost          # MySQL server host
DB_PORT=3306              # MySQL server port
DB_USER=root              # Database username
DB_PASS=                  # Database password
DB_NAME=company_db        # Database name
PORT=3000                 # Application port
SESSION_SECRET=change_me  # Session encryption key
NODE_ENV=production       # Environment
```

## Appendix B: PM2 Configuration

```javascript
module.exports = {
  apps: [{
    name: 'techcorp-solutions',
    script: 'start.js',
    env: {
      PORT: 3000,
      DB_HOST: 'localhost',
      DB_PORT: 3306,
      DB_USER: 'root',
      DB_PASS: '',
      DB_NAME: 'company_db',
      SESSION_SECRET: 'change_me'
    }
  }]
}
```

## Appendix C: Useful Commands

### Git
```bash
git status
git add .
git commit -m "message"
git push origin main
```

### npm
```bash
npm install
npm ci
npm start
npm run test:smoke
npm audit
```

### PM2
```bash
pm2 start ecosystem.config.js
pm2 restart techcorp-solutions
pm2 logs techcorp-solutions
pm2 list
pm2 save
```

---

**End of Documentation**
