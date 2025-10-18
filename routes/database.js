const express = require('express');
const router = express.Router();

// Database menu routes - displays data from 3 tables
router.get('/', (req, res) => {
    const db = req.app.locals.db;
    
    // Get data from 3 tables: products, categories, and projects
    const queries = [
        'SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id ORDER BY p.created_at DESC',
        'SELECT * FROM categories ORDER BY name',
        'SELECT * FROM projects ORDER BY created_at DESC LIMIT 10'
    ];
    
    Promise.all(queries.map(query => {
        return new Promise((resolve, reject) => {
            db.query(query, (error, results) => {
                if (error) reject(error);
                else resolve(results);
            });
        });
    }))
    .then(([products, categories, projects]) => {
        res.render('database', {
            title: 'Database - TechCorp Solutions',
            products: products,
            categories: categories,
            projects: projects
        });
    })
    .catch(error => {
        console.error('Database query error:', error);
        res.status(500).render('error', {
            title: 'Database Error',
            message: 'Unable to fetch database information'
        });
    });
});

// Individual table views
router.get('/products', (req, res) => {
    const db = req.app.locals.db;
    
    db.query('SELECT p.*, c.name as category_name FROM products p LEFT JOIN categories c ON p.category_id = c.id ORDER BY p.name', (error, results) => {
        if (error) {
            console.error('Products query error:', error);
            return res.status(500).render('error', {
                title: 'Database Error',
                message: 'Unable to fetch products'
            });
        }
        
        res.render('database_products', {
            title: 'Products & Services - TechCorp Solutions',
            products: results
        });
    });
});

router.get('/categories', (req, res) => {
    const db = req.app.locals.db;
    
    db.query('SELECT c.*, COUNT(p.id) as product_count FROM categories c LEFT JOIN products p ON c.id = p.category_id GROUP BY c.id ORDER BY c.name', (error, results) => {
        if (error) {
            console.error('Categories query error:', error);
            return res.status(500).render('error', {
                title: 'Database Error',
                message: 'Unable to fetch categories'
            });
        }
        
        res.render('database_categories', {
            title: 'Service Categories - TechCorp Solutions',
            categories: results
        });
    });
});

router.get('/projects', (req, res) => {
    const db = req.app.locals.db;
    
    db.query('SELECT * FROM projects ORDER BY created_at DESC', (error, results) => {
        if (error) {
            console.error('Projects query error:', error);
            return res.status(500).render('error', {
                title: 'Database Error',
                message: 'Unable to fetch projects'
            });
        }
        
        res.render('database_projects', {
            title: 'Our Projects - TechCorp Solutions',
            projects: results
        });
    });
});

module.exports = router;