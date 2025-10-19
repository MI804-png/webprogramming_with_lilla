# Security Policy

## Supported Versions

We currently support the following versions of TechCorp Solutions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of TechCorp Solutions seriously. If you discover a security vulnerability, please follow these steps:

### How to Report

1. **Do NOT** open a public issue on GitHub
2. Email your findings to: **security@techcorp.com** (or your university email)
3. Include the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Initial Response**: We aim to respond within 48 hours
- **Status Updates**: We'll keep you informed about our progress
- **Resolution Timeline**: We'll work to address critical vulnerabilities within 7-14 days
- **Credit**: We'll acknowledge your contribution in our release notes (if desired)

### Security Best Practices

When deploying this application:

1. **Environment Variables**: Never commit `.env` files or secrets to the repository
2. **Database Credentials**: Use strong passwords and limit database user permissions
3. **Session Secret**: Generate a strong, random SESSION_SECRET for production
4. **HTTPS**: Always use HTTPS in production environments
5. **Dependencies**: Keep npm packages up-to-date using Dependabot
6. **Access Control**: Properly configure firewall rules and SSH access

## Security Features

- Password hashing using SHA-256
- Session management with MySQL session store
- Role-based access control (visitor, registered, admin)
- CSRF protection (consider adding express-csrf for enhanced security)
- Input validation on forms

## Maintenance

- We use Dependabot to monitor dependencies for known vulnerabilities
- CodeQL scans run automatically on each push and pull request
- Regular security audits should be performed using `npm audit`

Thank you for helping keep TechCorp Solutions secure!
