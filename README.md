# TechCorp Solutions – Web Programming II Homework

This Node.js + Express app fulfills the homework requirements: free responsive theme, authentication with roles, database views, contact/messages, and an admin CRUD.

## Theme
- Bootswatch (Lux) + Bootstrap 5
- Integrated in `views/layout.ejs` via CDN

## Roles
- visitor (not logged-in)
- registered (sees Messages menu)
- admin (sees Admin menu + CRUD)

Demo users (auto-seeded on startup):
- Admin: admin / admin123
- Registered: testuser / hello

## Run locally (Windows PowerShell)
```powershell
cd c:\webprogramming2_homework\exercise
npm install
npm start
# Open http://localhost:3000
```

Optional environment variables (defaults in parentheses):
- DB_HOST (localhost)
- DB_USER (root)
- DB_PASS (empty)
- DB_NAME (company_db)
- SESSION_SECRET (webprogramming2_secret_key_2025)

Import database once:
- Import `company_db.sql` into MySQL.

## Deploy to Linux server
Target path: `/home/<username>/exercise/start.js`
1) Copy project to server (scp/git). 2) `npm ci` 3) Import SQL 4) `node start.js`.

## Project work + GitHub
- Make >=5 commits showing progress.
- Use GitHub Projects/Issues to attribute tasks per member.
- Repo must be public for evaluation.

## Structure
- `start.js`, `routes/`, `views/`, `public/`, `company_db.sql`
