# TechCorp Solutions – Web Programming II Homework Documentation

Date: 2025-10-19

This document describes the architecture, features, database schema, authentication and authorization model, deployment steps, and testing procedures for the TechCorp Solutions Node.js application.

## 1. Introduction

Purpose: Implement a server-side web application with authentication, roles, a responsive theme, database-backed features (3+ tables), messaging and contact forms, CRUD for admin, and deploy it to a Linux server. The project uses GitHub with visible incremental progress and proper documentation.

## 2. Technology Stack

- Runtime: Node.js 18+
- Framework: Express 4
- View Engine: EJS with express-ejs-layouts, Bootstrap 5 (Bootswatch Lux)
- Auth: Passport Local + express-session + express-mysql-session
- Database: MySQL/MariaDB via mysql2
- Styles/JS: Bootstrap, Font Awesome, custom CSS/JS under `public/`

## 3. Features Overview

- Public pages: Home, Database overview, Contact
- Auth pages: Register, Login, Logout
- Roles and menus:
  - Visitor: sees Home, Database, Contact, Login/Register
  - Registered: also sees Messages
  - Admin: sees Admin dropdown (CRUD, Messages)
- Database menu uses data from 3 tables (Products, Categories, Projects)
- Contact form persists messages to DB
- Messages listing (protected): newest-first, status changes by Admin
- CRUD for Products (Admin-only)

## 4. UI/UX and Theme

- Bootswatch Lux theme applied globally via `views/layout.ejs`
- Responsive navbar with active menu highlighting via `res.locals.currentPath`
- Shared layout with EJS content injection

## 5. Architecture

- Entry point: `start.js`
- Routes: `routes/auth.js`, `routes/database.js`, `routes/contact.js`, `routes/messages.js`, `routes/crud.js`
- Views: under `views/` with layout and specific templates
- Static assets: `public/`
- Helpers exposed via `app.locals` and middleware locals

## 6. Database Schema

Schema file: `company_db.sql` creates and populates tables including:
- users(id, username, email, password_hash, role, created_at)
- categories(id, name)
- products(id, name, price, category_id)
- projects(id, name, description)
- contact_messages(id, name, email, subject, message, created_at, status)

Foreign keys:
- products.category_id -> categories.id

Seed/demo:
- On startup, `ensureDefaultUsers()` upserts demo admin and registered users

## 7. Authentication and Authorization

- Passport Local strategy checks `users` by username and compares SHA-256 hash
- Session persisted in MySQL via express-mysql-session
- Middlewares:
  - `isAuth`: requires logged-in
  - `isRegistered`: logged-in and role in [registered, admin]
  - `isAdmin`: role is admin
- Navbar renders menu items conditionally based on the locals

## 8. Routes and Pages

- `/` Home
- `/login`, `/register`, `/logout`
- `/database` overview; subpages for products, categories, projects
- `/contact` GET (form), POST (save to DB)
- `/messages` GET protected list; `/messages/:id` detail; admin can update status
- `/crud` Admin product CRUD (list/add/edit/delete/view)
- `/health` health probe

## 9. Input Validation and Errors

- Basic server-side validation for required fields
- Login error messages via `?error=` query param
- Global error page `views/error.ejs`

## 10. Security Considerations

- Passwords stored as SHA-256 hashes (educational; recommend bcrypt in production)
- Session secret configurable via `.env`
- Parameterized queries to prevent SQL injection
- Role checks on protected routes and admin-only operations

## 11. Deployment

- See `docs/deploy-linux.md` for complete steps using PM2 or systemd
- Environment configuration via `.env`
- Optional Nginx reverse proxy

## 12. Testing and Verification

Manual test plan:
- Registration flow (duplicate user/email handling)
- Login/logout; role-based menu visibility
- Database pages render and paginate (if applicable)
- Contact form persists and appears in Messages
- Admin Messages: status changes
- CRUD operations for Products: add/edit/delete validations
- `/health` returns JSON `{ status: 'ok', db: true }`

## 13. Git/GitHub Project Work

- Public repository: https://github.com/MI804-png/webprogramming_with_lilla
- Multiple commits across feature milestones
- Recommended: GitHub Project board with issues assigned per member

## 14. Screenshots (placeholders)

Add images under `docs/screenshots/` and reference them here:
- Home page: `docs/screenshots/home.png`
- Login/Register: `docs/screenshots/auth.png`
- Database pages: `docs/screenshots/database.png`
- Contact form: `docs/screenshots/contact.png`
- Messages: `docs/screenshots/messages.png`
- CRUD list/form: `docs/screenshots/crud.png`
- Deployed site: `docs/screenshots/deploy.png`

## 15. Future Improvements

- Switch to bcrypt for password hashing
- Add CSRF protection for form posts
- Add input sanitization and richer validation
- Add automated tests (Jest/Mocha) and linting (ESLint)
- Add pagination and search for large datasets

## 16. Appendix: Environment Variables

See `.env.example` and `.env.production.example` for reference.
