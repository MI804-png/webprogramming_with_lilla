# TechCorp Solutions – Web Programming II Homework

![CI](https://github.com/MI804-png/webprogramming_with_lilla/workflows/CI%20-%20Build%20and%20Test/badge.svg)
![CodeQL](https://github.com/MI804-png/webprogramming_with_lilla/workflows/CodeQL%20Security%20Scan/badge.svg)
![Node Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

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

### Manual Deployment

Target path: `/home/<username>/webprogramming_with_lilla`

1. **Clone or copy project to server**:
   ```bash
   git clone https://github.com/MI804-png/webprogramming_with_lilla.git
   cd webprogramming_with_lilla
   ```

2. **Install dependencies**:
   ```bash
   npm ci --production
   ```

3. **Configure environment**:
   ```bash
   cp .env.production.example .env
   nano .env  # Edit with your database credentials
   ```

4. **Import database**:
   ```bash
   chmod +x scripts/import-db.sh
   ./scripts/import-db.sh
   ```
   Or manually: `mysql -u root -p < company_db.sql`

5. **Start with PM2**:
   ```bash
   pm2 start ecosystem.config.js --env production
   pm2 save
   pm2 startup
   ```

### Automated Deployment with GitHub Actions

This repository includes a GitHub Actions workflow for automated deployment.

#### Required Secrets

Configure these secrets in GitHub repository settings (Settings → Secrets and variables → Actions):

| Secret Name | Description | Example |
|------------|-------------|---------|
| `SSH_HOST` | Server IP or hostname | `192.168.1.100` |
| `SSH_USER` | SSH username | `ubuntu` |
| `SSH_PORT` | SSH port | `22` |
| `SSH_KEY` | Private SSH key | Your private key content |
| `DB_HOST` | Database host | `localhost` |
| `DB_PORT` | Database port | `3306` |
| `DB_USER` | Database username | `techcorp_user` |
| `DB_PASS` | Database password | `your_password` |
| `DB_NAME` | Database name | `company_db` |

#### Running the Deployment

1. Go to the **Actions** tab in GitHub
2. Select **"Deploy to Production"** workflow
3. Click **"Run workflow"**
4. Select the `main` branch
5. Click **"Run workflow"** button

The workflow will:
- Connect to your server via SSH
- Pull the latest code
- Install dependencies
- Import/update the database
- Restart the application with PM2
- Verify the deployment via health check

#### Process Managers

- **PM2** (recommended): `pm2 start ecosystem.config.js`
- **systemd**: see `docs/systemd-techcorp.service` (templated for user instance)

## Project work + GitHub
- Make >=5 commits showing progress.
- Use GitHub Projects/Issues to attribute tasks per member.
- Repo must be public for evaluation.

## Testing

Run the smoke test to verify the application:

```bash
npm run test:smoke
```

The smoke test verifies:
- Server starts successfully
- Health endpoint (`/health`) responds correctly
- Database connection is working

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment:

- **CI Workflow**: Runs on every push/PR to `main`
  - Installs dependencies
  - Runs smoke tests
  - Verifies build

- **Deploy Workflow**: Manual trigger for production deployment
  - SSH deployment to Linux server
  - Database import/update
  - PM2 restart
  - Health verification

- **CodeQL**: Automated security scanning
- **Dependabot**: Automated dependency updates

## Documentation

Full documentation is available in `docs/Documentation-Full.md` (15+ pages) covering:
- Architecture and design
- Database schema
- Authentication flow
- Deployment guide
- Security considerations

Build PDF documentation:
- Go to Actions → "Build Documentation PDF"
- Click "Run workflow"
- Download artifact after build completes

## Security

See [SECURITY.md](SECURITY.md) for security policy and vulnerability reporting.

Security features:
- Dependabot for dependency updates
- CodeQL security scanning
- Password hashing
- Session management
- Role-based access control

## Structure
- `start.js`, `routes/`, `views/`, `public/`, `company_db.sql`
- `.github/workflows/` - CI/CD pipelines
- `docs/` - Full documentation
- `scripts/` - Deployment and utility scripts
- `test/` - Test files
