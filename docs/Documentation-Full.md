---
title: "TechCorp Solutions - Web Programming II Documentation"
author: "Web Programming II Students"
date: "2025"
---

\newpage

# Table of Contents

1. [Introduction](#1-introduction)
2. [Requirements Summary](#2-requirements-summary)
3. [Theme Selection](#3-theme-selection)
4. [Architecture Overview](#4-architecture-overview)
5. [Database Design](#5-database-design)
6. [Authentication System](#6-authentication-system)
7. [Main Page (Home)](#7-main-page-home)
8. [Database Views](#8-database-views)
9. [Contact Form](#9-contact-form)
10. [Messages System](#10-messages-system)
11. [CRUD Administration](#11-crud-administration)
12. [Deployment on Linux Server](#12-deployment-on-linux-server)
13. [GitHub Project Management](#13-github-project-management)
14. [CI/CD Pipeline](#14-cicd-pipeline)
15. [Testing and Verification](#15-testing-and-verification)
16. [Security Considerations](#16-security-considerations)
17. [Conclusion and Future Improvements](#17-conclusion-and-future-improvements)

\newpage

# 1. Introduction

## 1.1 Project Overview

TechCorp Solutions is a comprehensive web application developed as part of the Web Programming II course. This project demonstrates modern web development practices using Node.js, Express, MySQL, and EJS templating.

The application serves as a corporate website featuring user authentication, role-based access control, database-driven content, contact management, and administrative capabilities.

## 1.2 Technologies Used

- **Backend**: Node.js with Express.js framework
- **Database**: MySQL 8.0+
- **Template Engine**: EJS (Embedded JavaScript)
- **Authentication**: Passport.js with local strategy
- **Session Management**: Express-session with MySQL store
- **Frontend**: Bootstrap 5 with Bootswatch theme
- **Process Manager**: PM2 for production deployment
- **Version Control**: Git with GitHub

## 1.3 Key Features

1. Responsive design using Bootstrap 5
2. User authentication and authorization
3. Role-based access control (visitor, registered user, admin)
4. Database views for multiple tables
5. Contact form with database persistence
6. Message management system
7. Full CRUD operations for product management
8. Secure session handling
9. Production-ready deployment configuration

\newpage

# 2. Requirements Summary

## 2.1 Course Requirements

The Web Programming II homework assignment required the following components:

### 2.1.1 Theme and Design
- Free, responsive Bootstrap theme
- Professional appearance
- Mobile-friendly layout
- Consistent branding across pages

### 2.1.2 Authentication
- User registration and login
- Password security (hashing)
- Session management
- Logout functionality

### 2.1.3 Role-Based Access
- Three user roles: visitor, registered, admin
- Menu visibility based on roles
- Route protection middleware
- Role-specific features

### 2.1.4 Database Integration
- MySQL database connection
- Multiple table views
- CRUD operations
- Data persistence

### 2.1.5 Forms and Validation
- Contact form
- Input validation
- Error handling
- Success feedback

### 2.1.6 Deployment
- Linux server deployment
- Production configuration
- Process management (PM2 or systemd)
- Environment variable management

### 2.1.7 Version Control
- GitHub repository (public)
- Minimum 5 commits showing progress
- Project board for task management
- Team collaboration tracking

\newpage

# 3. Theme Selection

## 3.1 Chosen Theme: Bootswatch Lux

We selected the **Lux** theme from Bootswatch, a free collection of Bootstrap themes. Lux provides a clean, professional appearance with excellent readability and modern design elements.

### 3.1.1 Why Lux?

1. **Professional Appearance**: Corporate-friendly design suitable for a technology company
2. **High Contrast**: Excellent readability with clear visual hierarchy
3. **Responsive**: Works seamlessly across desktop, tablet, and mobile devices
4. **Bootstrap 5 Compatible**: Leverages the latest Bootstrap features
5. **Free and Open Source**: No licensing concerns

### 3.1.2 Integration Method

The theme is integrated via CDN in the `views/layout.ejs` file:

```html
<link rel="stylesheet" 
      href="https://cdn.jsdelivr.net/npm/bootswatch@5/dist/lux/bootstrap.min.css">
```

### 3.1.3 Customization

- Custom logo and branding
- Tailored color scheme for corporate identity
- Custom CSS for specific components
- Enhanced navigation menu

## 3.2 Screenshots

![Homepage with Lux Theme](screenshots/homepage.png)

![Navigation Menu](screenshots/navigation.png)

\newpage

# 4. Architecture Overview

## 4.1 Application Architecture

TechCorp Solutions follows the **MVC (Model-View-Controller)** pattern:

- **Models**: Database queries and data handling
- **Views**: EJS templates for rendering HTML
- **Controllers**: Route handlers in Express

### 4.1.1 Technology Stack

```
┌─────────────────────────────────────────┐
│           Client Browser                │
│     (HTML, CSS, JavaScript)             │
└────────────────┬────────────────────────┘
                 │ HTTP/HTTPS
┌────────────────▼────────────────────────┐
│         Express.js Server               │
│  ┌─────────────────────────────────┐   │
│  │  Middleware Layer               │   │
│  │  - Body Parser                  │   │
│  │  - Session Management           │   │
│  │  - Passport Authentication      │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  Route Handlers                 │   │
│  │  - Auth Routes                  │   │
│  │  - Database Routes              │   │
│  │  - CRUD Routes                  │   │
│  │  - Contact Routes               │   │
│  │  - Message Routes               │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │  View Rendering (EJS)           │   │
│  └─────────────────────────────────┘   │
└────────────────┬────────────────────────┘
                 │ MySQL Protocol
┌────────────────▼────────────────────────┐
│         MySQL Database                  │
│  - users                                │
│  - products                             │
│  - categories                           │
│  - projects                             │
│  - contact_messages                     │
│  - sessions                             │
└─────────────────────────────────────────┘
```

## 4.2 Folder Structure

```
webprogramming_with_lilla/
├── .github/               # GitHub configurations
│   ├── workflows/         # CI/CD workflows
│   ├── dependabot.yml    # Dependency updates
│   └── pull_request_template.md
├── docs/                  # Documentation
│   ├── Documentation-Full.md
│   └── screenshots/       # Application screenshots
├── public/               # Static assets
│   ├── css/             # Stylesheets
│   ├── js/              # Client-side JavaScript
│   └── images/          # Images and icons
├── routes/              # Route modules
│   ├── auth.js          # Authentication routes
│   ├── database.js      # Database view routes
│   ├── contact.js       # Contact form routes
│   ├── messages.js      # Message management
│   └── crud.js          # CRUD operations
├── scripts/             # Utility scripts
│   └── import-db.sh     # Database import script
├── test/                # Test files
│   └── smoke.test.js    # Smoke tests
├── views/               # EJS templates
│   ├── layout.ejs       # Main layout
│   ├── mainpage.ejs     # Homepage
│   ├── login.ejs        # Login page
│   └── ...              # Other views
├── start.js             # Application entry point
├── package.json         # Dependencies
├── ecosystem.config.js  # PM2 configuration
├── company_db.sql       # Database schema
├── .env.example         # Environment template
└── README.md            # Project documentation
```

## 4.3 Request Flow

1. Client sends HTTP request to Express server
2. Session middleware validates/creates session
3. Passport middleware checks authentication
4. Route handler processes request
5. Database queries executed (if needed)
6. EJS template rendered with data
7. HTML response sent to client

\newpage

# 5. Database Design

## 5.1 Database Schema

The application uses a MySQL database named `company_db` with the following tables:

### 5.1.1 Users Table

Stores user account information and authentication data.

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('visitor', 'registered', 'admin') DEFAULT 'registered',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 5.1.2 Products Table

Product catalog for the CRUD demonstration.

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2),
    category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 5.1.3 Categories Table

Product categorization.

```sql
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5.1.4 Projects Table

Company project portfolio.

```sql
CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    status ENUM('planning', 'in-progress', 'completed') DEFAULT 'planning',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5.1.5 Contact Messages Table

Stores contact form submissions.

```sql
CREATE TABLE contact_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200),
    message TEXT NOT NULL,
    status ENUM('new', 'read', 'responded') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5.1.6 Sessions Table

Managed automatically by express-mysql-session for session storage.

## 5.2 Entity Relationship Diagram

```
┌──────────────┐         ┌──────────────┐
│    users     │         │  categories  │
├──────────────┤         ├──────────────┤
│ id (PK)      │         │ id (PK)      │
│ username     │         │ name         │
│ email        │         │ description  │
│ password_hash│         └──────┬───────┘
│ role         │                │
└──────────────┘                │ 1
                                │
                                │ N
                        ┌───────▼───────┐
                        │   products    │
                        ├───────────────┤
                        │ id (PK)       │
                        │ name          │
                        │ description   │
                        │ price         │
                        │ category_id   │
                        └───────────────┘

┌──────────────────┐         ┌──────────────┐
│    projects      │         │contact_msgs  │
├──────────────────┤         ├──────────────┤
│ id (PK)          │         │ id (PK)      │
│ title            │         │ name         │
│ description      │         │ email        │
│ status           │         │ subject      │
│ start_date       │         │ message      │
│ end_date         │         │ status       │
└──────────────────┘         └──────────────┘
```

## 5.3 Database Connection

The application connects to MySQL using the `mysql2` package:

```javascript
const connection = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'company_db',
    port: process.env.DB_PORT || 3306
});
```

\newpage

# 6. Authentication System

## 6.1 Authentication Flow

The application uses **Passport.js** with a local strategy for authentication.

### 6.1.1 Registration Process

1. User submits registration form
2. Server validates input (username, email, password)
3. Checks for existing users with same username/email
4. Hashes password using SHA-256
5. Creates new user record in database
6. Redirects to login with success message

### 6.1.2 Login Process

1. User submits login credentials
2. Passport LocalStrategy verifies username
3. Password hash compared with stored hash
4. Session created on successful authentication
5. User object stored in session
6. Redirect to homepage

### 6.1.3 Password Security

Passwords are hashed using SHA-256:

```javascript
function genPassword(password) {
    return crypto.createHash('sha256')
                 .update(password)
                 .digest('hex');
}

function validPassword(password, hash) {
    return hash === crypto.createHash('sha256')
                          .update(password)
                          .digest('hex');
}
```

**Note**: In production, consider using bcrypt or argon2 for enhanced security.

## 6.2 Role-Based Access Control

### 6.2.1 User Roles

1. **Visitor**: Unauthenticated users
   - Can view: Home, Login, Register pages
   - Cannot access: Messages, CRUD, Database views

2. **Registered**: Authenticated regular users
   - Inherits visitor permissions
   - Can view: Messages, Database views
   - Cannot access: Admin CRUD operations

3. **Admin**: Authenticated administrators
   - Full access to all features
   - Can perform: CRUD operations
   - Can manage: Products, messages

### 6.2.2 Route Protection Middleware

```javascript
// Require authentication
function isAuth(req, res, next) {
    if (req.isAuthenticated())
        next();
    else
        res.redirect('/login?error=unauthorized');
}

// Require admin role
function isAdmin(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'admin')
        next();
    else
        res.redirect('/login?error=admin_required');
}

// Require registered user or admin
function isRegistered(req, res, next) {
    if (req.isAuthenticated() && 
        (req.user.role === 'registered' || req.user.role === 'admin'))
        next();
    else
        res.redirect('/login?error=registration_required');
}
```

## 6.3 Session Management

Sessions are stored in MySQL using `express-mysql-session`:

```javascript
app.use(session({
    key: 'session_cookie_name',
    secret: process.env.SESSION_SECRET,
    store: new MySQLStore({
        host: DB_HOST,
        user: DB_USER,
        password: DB_PASS,
        database: DB_NAME,
        createDatabaseTable: true
    }),
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24, // 24 hours
    }
}));
```

## 6.4 Default Users

For testing and demonstration, the application creates default users on startup:

- **Admin User**: username=`admin`, password=`admin123`
- **Test User**: username=`testuser`, password=`hello`

## 6.5 Screenshots

![Login Page](screenshots/login.png)

![Registration Form](screenshots/register.png)

\newpage

# 7. Main Page (Home)

## 7.1 Homepage Design

The homepage serves as the entry point to TechCorp Solutions, showcasing the company's services and value proposition.

### 7.1.1 Sections

1. **Hero Section**: Eye-catching banner with call-to-action
2. **Features**: Key service offerings
3. **About**: Company overview
4. **Statistics**: Key metrics and achievements
5. **Call to Action**: Contact/registration prompt

### 7.1.2 Dynamic Elements

- Role-based navigation menu
- Personalized greeting for logged-in users
- Conditional CTAs based on authentication status

## 7.2 Navigation Menu

The navigation adapts based on user role:

**Visitor (Not Logged In)**:
- Home
- Login
- Register

**Registered User**:
- Home
- Database
- Messages
- Contact
- Logout

**Admin User**:
- Home
- Database
- Messages
- Contact
- Admin (CRUD)
- Logout

## 7.3 Screenshots

![Homepage Hero](screenshots/homepage-hero.png)

![Homepage Features](screenshots/homepage-features.png)

\newpage

# 8. Database Views

## 8.1 Overview

The Database menu provides views of three database tables, demonstrating data retrieval and presentation.

### 8.1.1 Tables Displayed

1. **Products**: Product catalog with pricing
2. **Categories**: Product categories
3. **Projects**: Company project portfolio

## 8.2 Implementation

Each table view displays:
- Column headers
- Data rows from database
- Pagination (for large datasets)
- Formatted data (dates, currency)

### 8.2.2 Sample Code

```javascript
router.get('/products', isRegistered, (req, res) => {
    const query = 'SELECT * FROM products ORDER BY created_at DESC';
    connection.query(query, (error, results) => {
        if (error) {
            console.error('Database error:', error);
            return res.status(500).send('Database error');
        }
        res.render('database/products', {
            title: 'Products',
            products: results
        });
    });
});
```

## 8.3 Access Control

Database views require user to be logged in as a registered user or admin.

## 8.4 Screenshots

![Products View](screenshots/database-products.png)

![Projects View](screenshots/database-projects.png)

![Categories View](screenshots/database-categories.png)

\newpage

# 9. Contact Form

## 9.1 Features

The contact form allows visitors and users to send messages to the company.

### 9.1.1 Form Fields

- **Name**: Sender's name (required)
- **Email**: Contact email (required, validated)
- **Subject**: Message subject (optional)
- **Message**: Message content (required)

### 9.1.2 Validation

Client-side and server-side validation ensures:
- Required fields are filled
- Email format is valid
- Message length is appropriate
- No malicious input

## 9.2 Data Persistence

Submitted messages are stored in the `contact_messages` table:

```javascript
router.post('/submit', (req, res) => {
    const { name, email, subject, message } = req.body;
    
    // Validation
    if (!name || !email || !message) {
        return res.redirect('/contact?error=required');
    }
    
    // Save to database
    const query = `INSERT INTO contact_messages 
                   (name, email, subject, message, status) 
                   VALUES (?, ?, ?, ?, 'new')`;
    
    connection.query(query, [name, email, subject, message], 
        (error, results) => {
            if (error) {
                console.error('Database error:', error);
                return res.redirect('/contact?error=database');
            }
            res.redirect('/contact?success=sent');
        });
});
```

## 9.3 User Feedback

- Success message on successful submission
- Error messages for validation failures
- Form field preservation on errors

## 9.4 Screenshots

![Contact Form](screenshots/contact-form.png)

![Contact Success](screenshots/contact-success.png)

\newpage

# 10. Messages System

## 10.1 Overview

The Messages menu displays contact form submissions for registered users and admins.

### 10.1.1 Features

- Display all messages in reverse chronological order (newest first)
- Show message status (new, read, responded)
- Message details: name, email, subject, message content, timestamp
- Admin can update message status

## 10.2 Message Display

Messages are sorted by creation date:

```javascript
router.get('/', isRegistered, (req, res) => {
    const query = `SELECT * FROM contact_messages 
                   ORDER BY created_at DESC`;
    
    connection.query(query, (error, results) => {
        if (error) {
            console.error('Database error:', error);
            return res.status(500).send('Database error');
        }
        res.render('messages', {
            title: 'Messages',
            messages: results
        });
    });
});
```

## 10.3 Status Management (Admin)

Admins can update message status to track progress:

- **New**: Unread message
- **Read**: Message has been viewed
- **Responded**: Reply has been sent

## 10.4 Access Control

Messages require registered user or admin authentication.

## 10.5 Screenshots

![Messages List](screenshots/messages-list.png)

![Message Detail](screenshots/message-detail.png)

\newpage

# 11. CRUD Administration

## 11.1 Overview

The Admin menu provides full CRUD (Create, Read, Update, Delete) operations for product management.

### 11.1.1 Operations

1. **Create**: Add new products
2. **Read**: View product list
3. **Update**: Edit existing products
4. **Delete**: Remove products

## 11.2 Product Management

### 11.2.1 List Products

Displays all products in a table with action buttons:

```javascript
router.get('/products', isAdmin, (req, res) => {
    const query = `SELECT p.*, c.name as category_name 
                   FROM products p 
                   LEFT JOIN categories c ON p.category_id = c.id 
                   ORDER BY p.created_at DESC`;
    
    connection.query(query, (error, results) => {
        if (error) {
            console.error('Database error:', error);
            return res.status(500).send('Database error');
        }
        res.render('crud/products', {
            title: 'Manage Products',
            products: results
        });
    });
});
```

### 11.2.2 Create Product

Form for adding new products with validation:

- Product name (required)
- Description
- Price (validated as decimal)
- Category selection

### 11.2.3 Update Product

Edit form pre-filled with existing product data:

```javascript
router.post('/products/update/:id', isAdmin, (req, res) => {
    const { name, description, price, category_id } = req.body;
    const productId = req.params.id;
    
    const query = `UPDATE products 
                   SET name=?, description=?, price=?, category_id=? 
                   WHERE id=?`;
    
    connection.query(query, 
        [name, description, price, category_id, productId], 
        (error, results) => {
            if (error) {
                console.error('Update error:', error);
                return res.redirect('/crud/products?error=update');
            }
            res.redirect('/crud/products?success=updated');
        });
});
```

### 11.2.4 Delete Product

Confirmation before deletion:

```javascript
router.post('/products/delete/:id', isAdmin, (req, res) => {
    const productId = req.params.id;
    
    const query = 'DELETE FROM products WHERE id=?';
    
    connection.query(query, [productId], (error, results) => {
        if (error) {
            console.error('Delete error:', error);
            return res.redirect('/crud/products?error=delete');
        }
        res.redirect('/crud/products?success=deleted');
    });
});
```

## 11.3 Access Control

All CRUD operations require admin authentication. Non-admin users are redirected to login.

## 11.4 User Experience

- Success/error notifications
- Form validation
- Confirmation dialogs for destructive actions
- Breadcrumb navigation

## 11.5 Screenshots

![Product List](screenshots/crud-list.png)

![Create Product](screenshots/crud-create.png)

![Edit Product](screenshots/crud-edit.png)

![Delete Confirmation](screenshots/crud-delete.png)

\newpage

# 12. Deployment on Linux Server

## 12.1 Deployment Overview

TechCorp Solutions can be deployed on any Linux server with Node.js and MySQL installed.

### 12.1.1 Prerequisites

- Linux server (Ubuntu 20.04+ recommended)
- Node.js 18.x or higher
- MySQL 8.0+
- PM2 process manager
- Git
- Nginx (optional, for reverse proxy)

## 12.2 Manual Deployment Steps

### 12.2.1 Clone Repository

```bash
cd ~
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla
```

### 12.2.2 Install Dependencies

```bash
npm ci --production
```

### 12.2.3 Configure Environment

```bash
cp .env.production.example .env
nano .env
```

Edit the `.env` file with your database credentials:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=techcorp_user
DB_PASS=secure_password
DB_NAME=company_db
SESSION_SECRET=generate_a_random_string_here
PORT=3000
NODE_ENV=production
```

### 12.2.4 Import Database

```bash
chmod +x scripts/import-db.sh
./scripts/import-db.sh
```

Or manually:

```bash
mysql -u root -p < company_db.sql
```

### 12.2.5 Start with PM2

```bash
pm2 start ecosystem.config.js --env production
pm2 save
pm2 startup
```

### 12.2.6 Verify Deployment

```bash
pm2 status
curl http://localhost:3000/health
```

## 12.3 Automated Deployment with GitHub Actions

The repository includes a GitHub Actions workflow for automated deployment.

### 12.3.1 Required Secrets

Configure these secrets in GitHub repository settings:

| Secret Name | Description | Example |
|------------|-------------|---------|
| SSH_HOST | Server IP or hostname | `192.168.1.100` |
| SSH_USER | SSH username | `ubuntu` |
| SSH_PORT | SSH port | `22` |
| SSH_KEY | Private SSH key | `-----BEGIN RSA PRIVATE KEY-----...` |
| DB_HOST | Database host | `localhost` |
| DB_PORT | Database port | `3306` |
| DB_USER | Database username | `techcorp_user` |
| DB_PASS | Database password | `secure_password` |
| DB_NAME | Database name | `company_db` |

### 12.3.2 Trigger Deployment

1. Navigate to Actions tab in GitHub
2. Select "Deploy to Production" workflow
3. Click "Run workflow"
4. Select branch (usually `main`)
5. Click "Run workflow"

### 12.3.3 Deployment Process

The workflow automatically:

1. Connects to server via SSH
2. Pulls latest code from GitHub
3. Installs dependencies with `npm ci`
4. Imports/updates database
5. Restarts application with PM2
6. Verifies health endpoint

## 12.4 Nginx Configuration (Optional)

For production deployment with a domain name:

```nginx
server {
    listen 80;
    server_name techcorp.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 12.4.1 SSL with Certbot

```bash
sudo certbot --nginx -d techcorp.example.com
```

## 12.5 Monitoring and Maintenance

### 12.5.1 PM2 Commands

```bash
# Check status
pm2 status

# View logs
pm2 logs techcorp-solutions

# Restart application
pm2 restart techcorp-solutions

# Stop application
pm2 stop techcorp-solutions

# Monitor resources
pm2 monit
```

### 12.5.2 Log Rotation

PM2 handles log rotation automatically. Configure in `ecosystem.config.js`:

```javascript
module.exports = {
  apps: [{
    name: 'techcorp-solutions',
    script: 'start.js',
    error_file: 'logs/err.log',
    out_file: 'logs/out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true
  }]
};
```

\newpage

# 13. GitHub Project Management

## 13.1 Repository Structure

The project uses GitHub for version control and collaboration:

- **Repository**: `MI804-png/webprogramming_with_lilla`
- **Visibility**: Public
- **Branches**: `main` (protected)
- **Commit History**: 5+ commits showing progress

## 13.2 GitHub Projects

A GitHub Project board organizes tasks with the following columns:

1. **Backlog**: Planned features and improvements
2. **In Progress**: Currently being worked on
3. **Review**: Awaiting code review
4. **Done**: Completed tasks

### 13.2.1 Views

- **By Status**: Default kanban board view
- **By Assignee**: Tasks grouped by team member
- **Timeline**: Gantt-style view of milestones

## 13.3 Issues and Labels

### 13.3.1 Issue Labels

- `feature`: New functionality
- `docs`: Documentation updates
- `deploy`: Deployment-related tasks
- `bug`: Bug fixes
- `enhancement`: Improvements to existing features
- `security`: Security-related issues

### 13.3.2 Sample Issues

1. Deploy to Linux server with PM2
2. Configure repo secrets for deploy
3. Create GitHub Actions CI (build/test)
4. Create GitHub Actions Deploy (manual)
5. Finalize 15+ page PDF docs
6. Capture app screenshots
7. Verify role-based menus (visitor/registered/admin)
8. Validate CRUD happy/edge paths
9. Improve README (badges, run/deploy)
10. Add security and maintenance tasks (Dependabot, CodeQL)

## 13.4 Pull Request Workflow

1. Create feature branch from `main`
2. Make changes and commit
3. Open pull request with description
4. Code review by team member
5. Address feedback
6. Merge to `main`

## 13.5 Team Collaboration

Tasks are assigned to team members with clear acceptance criteria and deadlines.

\newpage

# 14. CI/CD Pipeline

## 14.1 Continuous Integration

### 14.1.1 CI Workflow

The CI workflow (`.github/workflows/ci.yml`) runs on every push and pull request to `main`:

**Steps**:
1. Checkout code
2. Setup Node.js 18
3. Install dependencies (with npm caching)
4. Run smoke test

**Test Coverage**:
- Server starts successfully
- Health endpoint responds
- Database connection (optional in CI)

### 14.1.2 Smoke Test

Located in `test/smoke.test.js`, the smoke test verifies:

```javascript
// Check health endpoint
GET /health

Expected response:
{
  "status": "ok",
  "database": true,
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

## 14.2 Continuous Deployment

### 14.2.1 Deployment Workflow

The deployment workflow (`.github/workflows/deploy.yml`) runs manually via `workflow_dispatch`:

**Steps**:
1. Checkout code from `main` branch
2. SSH into production server
3. Pull latest changes
4. Install production dependencies
5. Create/verify `.env` file
6. Import/update database
7. Restart with PM2
8. Verify deployment (health check)

### 14.2.2 Security Considerations

- Secrets never printed in logs
- SSH key authentication
- Environment-specific configurations
- Health check verification

## 14.3 Documentation Build

### 14.3.1 PDF Generation Workflow

The docs workflow (`.github/workflows/docs-pdf.yml`) builds a PDF from the documentation:

**Triggers**:
- Manual dispatch
- Push to `main` affecting docs

**Steps**:
1. Install Pandoc and LaTeX
2. Convert Markdown to PDF
3. Upload as artifact (90-day retention)

## 14.4 Security Scanning

### 14.4.1 CodeQL Workflow

Automated security scanning with CodeQL:

**Schedule**: Every Monday at midnight
**Triggers**: Push and PR to `main`
**Language**: JavaScript/Node.js

### 14.4.2 Dependabot

Automated dependency updates:

**Schedule**: Weekly (Mondays at 9 AM)
**Ecosystems**: npm, GitHub Actions
**PR Limit**: 10 for npm, 5 for actions

## 14.5 Workflow Status

All workflows display status badges in README:

- CI: Build and Test
- CodeQL: Security Scan
- Deploy: Last Deployment
- Docs: PDF Build

\newpage

# 15. Testing and Verification

## 15.1 Testing Strategy

### 15.1.1 Manual Testing

**Authentication Flow**:
1. Register new user ✓
2. Login with credentials ✓
3. Logout ✓
4. Access protected routes while logged out (should redirect) ✓
5. Login as admin ✓
6. Access admin-only features ✓

**Database Views**:
1. View products list ✓
2. View categories list ✓
3. View projects list ✓
4. Verify data accuracy ✓

**Contact Form**:
1. Submit with all fields ✓
2. Submit with missing required fields (should show error) ✓
3. Submit with invalid email (should show error) ✓
4. Verify message appears in Messages ✓

**CRUD Operations**:
1. Create new product ✓
2. Edit existing product ✓
3. Delete product with confirmation ✓
4. Verify changes in database ✓

### 15.1.2 Automated Testing

**Smoke Test**:
- Server startup verification
- Health endpoint response
- Database connection check

**Future Testing**:
- Unit tests for utility functions
- Integration tests for routes
- End-to-end tests with Playwright

## 15.2 Verification Checklist

- [x] Application starts without errors
- [x] Database connection successful
- [x] All routes accessible with proper authentication
- [x] Role-based access control working
- [x] Forms validate input correctly
- [x] CRUD operations persist to database
- [x] Sessions maintained across requests
- [x] Logout clears session
- [x] Responsive design on mobile devices
- [x] No console errors in browser
- [x] Security headers present
- [x] Environment variables loaded correctly

## 15.3 Edge Cases Tested

1. **Long Inputs**: Text fields with maximum length
2. **SQL Injection Attempts**: Escaped queries
3. **XSS Attempts**: HTML escaping in templates
4. **Concurrent Sessions**: Multiple browsers/users
5. **Database Disconnection**: Error handling
6. **Invalid Routes**: 404 handling
7. **Expired Sessions**: Re-authentication prompt

## 15.4 Performance Testing

- Page load times < 2 seconds
- Database queries optimized with indexes
- Static assets cached
- Session storage in database (not memory)

\newpage

# 16. Security Considerations

## 16.1 Security Measures Implemented

### 16.1.1 Authentication Security

1. **Password Hashing**: SHA-256 (consider upgrading to bcrypt)
2. **Session Security**: Secure cookies, HTTP-only
3. **Session Storage**: Database-backed (prevents memory leaks)
4. **Session Timeout**: 24-hour expiration

### 16.1.2 Input Validation

1. **Form Validation**: Client and server-side
2. **SQL Injection Protection**: Parameterized queries
3. **XSS Protection**: EJS auto-escaping
4. **CSRF**: Consider adding tokens

### 16.1.3 Access Control

1. **Route Protection**: Middleware enforcement
2. **Role-Based Access**: Granular permissions
3. **Admin Verification**: Double-check on sensitive operations

### 16.1.4 Environment Security

1. **Environment Variables**: Sensitive data not in code
2. **`.env` in `.gitignore`**: Secrets not committed
3. **Production Config**: Separate from development

## 16.2 Security Headers

Consider adding security headers:

```javascript
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    next();
});
```

## 16.3 HTTPS in Production

Always use HTTPS in production:
- Protects credentials in transit
- Prevents session hijacking
- SEO benefits
- Required for modern browser features

## 16.4 Dependency Security

### 16.4.1 Dependabot

Automated weekly scans for vulnerable dependencies:
- npm packages
- GitHub Actions

### 16.4.2 CodeQL

Automated code security analysis:
- JavaScript vulnerabilities
- SQL injection detection
- XSS vulnerability detection
- Security anti-patterns

### 16.4.3 npm audit

Regular manual audits:

```bash
npm audit
npm audit fix
```

## 16.5 Security Best Practices

1. Keep dependencies updated
2. Use environment variables for secrets
3. Implement rate limiting (consider express-rate-limit)
4. Add CSRF protection (consider csurf)
5. Validate and sanitize all input
6. Use prepared statements for SQL
7. Implement proper error handling (don't expose stack traces)
8. Regular security audits
9. Monitor application logs
10. Backup database regularly

## 16.6 Reporting Vulnerabilities

See `SECURITY.md` for vulnerability reporting process.

\newpage

# 17. Conclusion and Future Improvements

## 17.1 Project Summary

TechCorp Solutions successfully demonstrates modern web application development practices:

### 17.1.1 Achievements

✓ Responsive, professional design with Bootstrap 5
✓ Complete authentication and authorization system
✓ Role-based access control (3 roles)
✓ Database integration with multiple tables
✓ Full CRUD operations for admin users
✓ Contact form with persistence
✓ Message management system
✓ Production-ready deployment configuration
✓ CI/CD pipeline with GitHub Actions
✓ Security scanning (CodeQL, Dependabot)
✓ Comprehensive documentation

### 17.1.2 Learning Outcomes

1. **Backend Development**: Express.js routing and middleware
2. **Database Management**: MySQL integration and queries
3. **Authentication**: Passport.js and session management
4. **Frontend**: EJS templating and Bootstrap
5. **DevOps**: PM2, Linux deployment, CI/CD
6. **Security**: Best practices and automated scanning
7. **Documentation**: Technical writing and diagramming

## 17.2 Future Improvements

### 17.2.1 Short-term Enhancements

1. **Enhanced Security**:
   - Upgrade to bcrypt for password hashing
   - Add CSRF protection
   - Implement rate limiting
   - Add security headers middleware

2. **User Experience**:
   - Add pagination to database views
   - Implement search functionality
   - Add sorting and filtering
   - Improve error messages

3. **Testing**:
   - Add unit tests for routes
   - Implement integration tests
   - Add end-to-end tests with Playwright
   - Increase code coverage

### 17.2.2 Long-term Enhancements

1. **Features**:
   - Email notifications for contact messages
   - User profile management
   - Password reset functionality
   - Two-factor authentication
   - API endpoints for mobile app

2. **Performance**:
   - Implement caching (Redis)
   - Add CDN for static assets
   - Optimize database queries with indexes
   - Implement connection pooling

3. **Monitoring**:
   - Add application monitoring (PM2 Plus)
   - Implement error tracking (Sentry)
   - Add analytics (Google Analytics)
   - Create admin dashboard

4. **DevOps**:
   - Containerization with Docker
   - Kubernetes orchestration
   - Blue-green deployments
   - Automated backup system

## 17.3 Lessons Learned

1. **Planning**: Proper planning reduces development time
2. **Security First**: Consider security from the start
3. **Documentation**: Good docs help team collaboration
4. **Testing**: Early testing catches bugs sooner
5. **Automation**: CI/CD saves time and reduces errors
6. **Version Control**: Git/GitHub essential for teamwork

## 17.4 Final Thoughts

This project successfully demonstrates the skills and knowledge acquired in the Web Programming II course. The application is production-ready, secure, and maintainable. The CI/CD pipeline ensures quality and enables rapid deployment of updates.

The modular architecture allows for easy expansion and maintenance. The comprehensive documentation ensures that future developers can understand and contribute to the project.

---

## Appendix A: Configuration Files

### A.1 ecosystem.config.js

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
};
```

### A.2 .env.production.example

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_db_user
DB_PASS=your_db_password
DB_NAME=company_db
SESSION_SECRET=generate_a_random_string_in_production
PORT=3000
NODE_ENV=production
```

## Appendix B: Deployment Credentials

**For Evaluation Purposes Only**

Server Information:
- Host: [Server IP/Hostname]
- SSH Port: 22
- SSH User: [username]

Database Information:
- Host: localhost
- Port: 3306
- Database: company_db
- User: [db_username]
- Password: [db_password]

Application URL: http://[server-ip]:3000

Admin Login:
- Username: admin
- Password: admin123

---

**End of Documentation**

*Total Pages: 20+*
