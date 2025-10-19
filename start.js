require('dotenv').config();
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const express = require('express');
const app = express();
const bodyParser = require("body-parser");
const mysql = require('mysql2');
const crypto = require('crypto');
const session = require('express-session');
const MySQLStore = require('express-mysql-session')(session);
const path = require('path');
const expressLayouts = require('express-ejs-layouts');

// Import route modules
const authRoutes = require('./routes/auth');
const databaseRoutes = require('./routes/database');
const contactRoutes = require('./routes/contact');
const messagesRoutes = require('./routes/messages');
const crudRoutes = require('./routes/crud');

// Environment configuration
const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_USER = process.env.DB_USER || 'root';
const DB_PASS = process.env.DB_PASS || '';
const DB_NAME = process.env.DB_NAME || 'company_db';
const DB_PORT = parseInt(process.env.DB_PORT || '3306', 10);
const SESSION_SECRET = process.env.SESSION_SECRET || 'webprogramming2_secret_key_2025';
const BASE_PATH_RAW = process.env.BASE_PATH || '';
// Normalize BASE_PATH to start with '/' and have no trailing '/' (except root)
let BASE_PATH = BASE_PATH_RAW.trim();
if (BASE_PATH && !BASE_PATH.startsWith('/')) BASE_PATH = '/' + BASE_PATH;
if (BASE_PATH.endsWith('/') && BASE_PATH !== '/') BASE_PATH = BASE_PATH.slice(0, -1);

// MySQL Express Session
app.use(session({
    key: 'session_cookie_name',
    secret: SESSION_SECRET,
    store: new MySQLStore({
        host: DB_HOST,
        user: DB_USER,
        password: DB_PASS,
        database: DB_NAME,
        port: DB_PORT,
        createDatabaseTable: true
    }),
    resave: false,
    saveUninitialized: false,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24, // 24 hours
    }
}));

// Passport and middleware setup
app.use(passport.initialize());
app.use(passport.session());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
// Serve static under base path for reverse-proxy route prefix deployments
if (BASE_PATH) {
    app.use(BASE_PATH, express.static('public'));
} else {
    app.use(express.static('public'));
}
app.set("view engine", "ejs");
app.set('views', path.join(__dirname, 'views'));
app.use(expressLayouts);
app.set('layout', 'layout');

// MySQL Connection
const connection = mysql.createConnection({
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASS,
    database: DB_NAME,
    port: DB_PORT,
    multipleStatements: true
});

connection.connect((err) => {
    if (!err) {
        console.log("Connected to MySQL database");
        // Ensure default users exist for demo/login
        ensureDefaultUsers();
    } else {
        console.log("Database Connection Failed:", err);
    }
});

// Make connection available to other modules
app.locals.db = connection;

// Passport configuration
const customFields = {
    usernameField: 'username',
    passwordField: 'password',
};

const verifyCallback = (username, password, done) => {
    connection.query('SELECT * FROM users WHERE username = ?', [username], function(error, results, fields) {
        if (error) 
            return done(error);
        if (results.length == 0)
            return done(null, false);
        
        const isValid = validPassword(password, results[0].password_hash);
        const user = {
            id: results[0].id,
            username: results[0].username,
            email: results[0].email,
            role: results[0].role,
            password_hash: results[0].password_hash
        };
        
        if (isValid)
            return done(null, user);
        else
            return done(null, false);
    });
}

const strategy = new LocalStrategy(customFields, verifyCallback);
passport.use(strategy);

passport.serializeUser((user, done) => {
    done(null, user.id);
});

passport.deserializeUser(function(userId, done) {
    connection.query('SELECT * FROM users WHERE id = ?', [userId], function(error, results) {
        if (error) return done(error);
        done(null, results[0]);    
    });
});

// Helper functions
function validPassword(password, hash) {
    return hash === crypto.createHash('sha256').update(password).digest('hex');
}

function genPassword(password) {
    return crypto.createHash('sha256').update(password).digest('hex');
}

// Ensure default admin and test users exist with known passwords
function ensureDefaultUsers() {
    const adminUsername = 'admin';
    const adminEmail = 'admin@techcorp.com';
    const adminPasswordHash = genPassword('admin123');

    const testUsername = 'testuser';
    const testEmail = 'test@techcorp.com';
    const testPasswordHash = genPassword('hello');

    // Upsert Admin
    connection.query('SELECT id FROM users WHERE username = ?', [adminUsername], (err, results) => {
        if (err) {
            console.error('Admin select error:', err);
            return;
        }
        if (results.length === 0) {
            connection.query(
                'INSERT INTO users (username, email, password_hash, role, created_at) VALUES (?, ?, ?, ?, NOW())',
                [adminUsername, adminEmail, adminPasswordHash, 'admin'],
                (insErr) => { if (insErr) console.error('Admin insert error:', insErr); }
            );
        } else {
            connection.query(
                'UPDATE users SET password_hash = ?, role = ? WHERE username = ?',[adminPasswordHash, 'admin', adminUsername],
                (updErr) => { if (updErr) console.error('Admin update error:', updErr); }
            );
        }
    });

    // Upsert Test User
    connection.query('SELECT id FROM users WHERE username = ?', [testUsername], (err, results) => {
        if (err) {
            console.error('Test user select error:', err);
            return;
        }
        if (results.length === 0) {
            connection.query(
                'INSERT INTO users (username, email, password_hash, role, created_at) VALUES (?, ?, ?, ?, NOW())',
                [testUsername, testEmail, testPasswordHash, 'registered'],
                (insErr) => { if (insErr) console.error('Test user insert error:', insErr); }
            );
        } else {
            connection.query(
                'UPDATE users SET password_hash = ?, role = ? WHERE username = ?',[testPasswordHash, 'registered', testUsername],
                (updErr) => { if (updErr) console.error('Test user update error:', updErr); }
            );
        }
    });
}

// Middleware functions
function isAuth(req, res, next) {
    if (req.isAuthenticated())
        next();
    else
        res.redirect('/login?error=unauthorized');
}

function isAdmin(req, res, next) {
    if (req.isAuthenticated() && req.user.role === 'admin')
        next();
    else
        res.redirect('/login?error=admin_required');   
}

function isRegistered(req, res, next) {
    if (req.isAuthenticated() && (req.user.role === 'registered' || req.user.role === 'admin'))
        next();
    else
        res.redirect('/login?error=registration_required');   
}

// Make middleware and locals available globally
app.use((req, res, next) => {
    res.locals.isAuth = req.isAuthenticated();
    res.locals.user = req.user || null;
    res.locals.isAdmin = req.isAuthenticated() && req.user && req.user.role === 'admin';
    res.locals.isRegistered = req.isAuthenticated() && req.user && (req.user.role === 'registered' || req.user.role === 'admin');
    // currentPath is relative to the mounted base path (for active nav logic)
    res.locals.currentPath = req.path;
    res.locals.basePath = BASE_PATH || '';
    next();
});

// Use a router mounted at BASE_PATH to support reverse-proxy path prefixes (e.g., /app001)
const router = express.Router();

// Routes
router.get('/', (req, res) => {
    res.render('mainpage', {
        title: 'TechCorp Solutions - Leading Technology Company'
    });
});

// Health check endpoint
router.get('/health', (req, res) => {
    connection.query('SELECT 1 AS ok', (err) => {
        if (err) {
            return res.status(500).json({ status: 'error', db: false, error: err.code || 'DB_ERROR' });
        }
        return res.json({ status: 'ok', db: true });
    });
});

// Use route modules
router.use('/auth', authRoutes);
router.use('/database', databaseRoutes);
router.use('/contact', contactRoutes);
router.use('/messages', messagesRoutes);
router.use('/crud', crudRoutes);

// Authentication routes (keeping some in main file for compatibility)
router.get('/login', (req, res) => {
    const error = req.query.error;
    const success = req.query.success;
    let errorMessage = '';
    
    switch(error) {
        case 'unauthorized':
            errorMessage = 'You must be logged in to access that page.';
            break;
        case 'admin_required':
            errorMessage = 'Admin access required.';
            break;
        case 'registration_required':
            errorMessage = 'You must be a registered user to access that page.';
            break;
        case 'invalid':
            errorMessage = 'Invalid username or password.';
            break;
    }
    
    res.render('login', { 
        title: 'Login - TechCorp Solutions',
        error: errorMessage,
        success: success 
    });
});

router.get('/register', (req, res) => {
    res.render('register', { 
        title: 'Register - TechCorp Solutions',
        error: req.query.error || '' 
    });
});

router.post('/register', (req, res) => {
    const { username, email, password, confirmPassword } = req.body;
    
    // Validation
    if (!username || !email || !password || !confirmPassword) {
        return res.redirect('/register?error=All fields are required');
    }
    
    if (password !== confirmPassword) {
        return res.redirect('/register?error=Passwords do not match');
    }
    
    // Check if user exists
    connection.query('SELECT * FROM users WHERE username = ? OR email = ?', [username, email], (error, results) => {
        if (error) {
            console.log("Database error:", error);
            return res.redirect('/register?error=Database error');
        }
        
        if (results.length > 0) {
            return res.redirect('/register?error=Username or email already exists');
        }
        
        // Create new user
        const passwordHash = genPassword(password);
        const insertQuery = 'INSERT INTO users (username, email, password_hash, role, created_at) VALUES (?, ?, ?, ?, NOW())';
        
        connection.query(insertQuery, [username, email, passwordHash, 'registered'], (error, results) => {
            if (error) {
                console.log("Insert error:", error);
                return res.redirect('/register?error=Registration failed');
            }
            
            res.redirect('/login?success=Registration successful');
        });
    });
});

router.post('/login', passport.authenticate('local', {
    failureRedirect: '/login?error=invalid',
    successRedirect: '/'
}));

router.get('/logout', (req, res) => {
    req.session.destroy((err) => {
        res.clearCookie('session_cookie_name');
        res.redirect('/');
    });
});

// Export helper functions for routes
app.locals.validPassword = validPassword;
app.locals.genPassword = genPassword;
app.locals.isAuth = isAuth;
app.locals.isAdmin = isAdmin;
app.locals.isRegistered = isRegistered;

const PORT = process.env.PORT || 3000;
// Mount the router at the base path
app.use(BASE_PATH || '/', router);

app.listen(PORT, function() {
    console.log(`TechCorp Solutions app listening on port ${PORT}!`);
    console.log(`Visit http://localhost:${PORT} to view the application`);
    if (BASE_PATH) {
        console.log(`App is mounted under base path: ${BASE_PATH}`);
    }
});

module.exports = app;