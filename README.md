# TechCorp Solutions – Web Programming II Homework

[![CI - Build and Test](https://github.com/MI804-png/webprogramming_with_lilla/actions/workflows/ci.yml/badge.svg)](https://github.com/MI804-png/webprogramming_with_lilla/actions/workflows/ci.yml)
[![CodeQL](https://github.com/MI804-png/webprogramming_with_lilla/actions/workflows/codeql.yml/badge.svg)](https://github.com/MI804-png/webprogramming_with_lilla/actions/workflows/codeql.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org/)

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
- DB_PORT (3306)
- DB_USER (root)
- DB_PASS (empty)
- DB_NAME (company_db)
- SESSION_SECRET (webprogramming2_secret_key_2025)

Import database once:
- Import `company_db.sql` into MySQL.

## Deploy to Linux server
Target path: `/home/<username>/webprogramming_with_lilla`

### Quick Deploy Steps
1) Copy project to server (scp/git). 2) `npm ci` 3) Import SQL 4) `node start.js`.

### Deployment with PM2 (Recommended)

```bash
# Clone repository
git clone https://github.com/MI804-png/webprogramming_with_lilla.git
cd webprogramming_with_lilla

# Install dependencies
npm ci --production

# Configure environment
cp .env.example .env
nano .env  # Edit with your database credentials

# Import database
mysql -u your_user -p company_db < company_db.sql
# Or use the script:
export DB_HOST=localhost DB_USER=root DB_PASS=password DB_NAME=company_db
./scripts/import-db.sh

# Start with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup  # Follow instructions to enable on boot
```

### GitHub Actions Deployment

This repository includes automated deployment workflow. To use it:

1. **Configure Secrets** in GitHub repository settings (Settings → Secrets and variables → Actions):

   | Secret | Description | Example |
   |--------|-------------|---------|
   | `SSH_HOST` | Server IP or domain | `192.168.1.100` |
   | `SSH_USER` | SSH username | `ubuntu` |
   | `SSH_PORT` | SSH port | `22` |
   | `SSH_KEY` | Private SSH key | `-----BEGIN RSA...` |
   | `DB_HOST` | Database host | `localhost` |
   | `DB_PORT` | Database port | `3306` |
   | `DB_USER` | Database user | `techcorp` |
   | `DB_PASS` | Database password | `your_password` |
   | `DB_NAME` | Database name | `company_db` |

2. **Run Deployment**:
   - Go to Actions tab in GitHub
   - Select "Deploy to Linux Server" workflow
   - Click "Run workflow"
   - Select branch (main)
   - Click "Run workflow" button

The workflow will automatically:
- SSH into your server
- Pull latest code from main branch
- Install dependencies with `npm ci`
- Import database schema
- Restart application with PM2

### Alternative: systemd service
Optional process managers:
- PM2: `pm2 start ecosystem.config.js`
- systemd: see `docs/systemd-techcorp.service` (templated for user instance)

## Project work + GitHub
- Make >=5 commits showing progress.
- Use GitHub Projects/Issues to attribute tasks per member.
- Repo must be public for evaluation.

## Structure
- `start.js`, `routes/`, `views/`, `public/`, `company_db.sql`
- `.github/workflows/` - CI/CD pipelines (build, test, deploy, security)
- `scripts/` - Deployment scripts
- `docs/` - Full documentation (15+ pages)

## CI/CD Workflows

This project includes automated workflows:

- **CI (Continuous Integration)**: Runs on every push/PR
  - Builds application
  - Runs smoke tests
  - Validates database connectivity
  
- **Deploy**: Manual deployment to Linux server
  - Triggered via workflow_dispatch
  - Deploys to production server via SSH
  
- **CodeQL**: Security scanning
  - Automated code security analysis
  - Runs on push/PR and weekly
  
- **Dependabot**: Dependency updates
  - Weekly automated updates
  - Security vulnerability patches
  
- **Docs PDF**: Generate documentation PDF
  - Converts markdown to PDF with Pandoc
  - Available as artifact download

## Documentation

- **README.md** - This file, quick start guide
- **docs/Documentation-Full.md** - Complete 15+ page documentation
- **docs/Documentation-Outline.md** - Documentation structure
- **SECURITY.md** - Security policy and vulnerability reporting

## Security

- CodeQL scanning enabled for JavaScript/Node.js
- Dependabot automated dependency updates
- See SECURITY.md for vulnerability reporting

## License

MIT License - See LICENSE file for details
