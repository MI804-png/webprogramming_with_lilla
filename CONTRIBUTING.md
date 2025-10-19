# Contributing to TechCorp Solutions

Thank you for your interest in contributing to TechCorp Solutions! This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and encourage learning
- Focus on constructive feedback
- Respect differing viewpoints

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/MI804-png/webprogramming_with_lilla/issues)
2. If not, create a new issue using the Bug Report template
3. Include detailed steps to reproduce the bug
4. Provide your environment details (OS, Node.js version, browser)

### Suggesting Features

1. Check if the feature has already been suggested
2. Create a new issue using the Feature Request template
3. Clearly describe the feature and its benefits
4. Provide examples or mockups if possible

### Pull Requests

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes following the coding standards
4. Test your changes thoroughly
5. Commit with meaningful messages (use Conventional Commits)
6. Push to your fork: `git push origin feature/your-feature-name`
7. Open a Pull Request using the PR template

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/webprogramming_with_lilla.git
cd webprogramming_with_lilla

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env

# Import database
mysql -u root -p company_db < company_db.sql

# Start development server
npm run dev
```

## Coding Standards

### JavaScript/Node.js

- Use ES6+ features where appropriate
- Follow existing code style and patterns
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Database Queries

- Always use parameterized queries
- Never concatenate user input into SQL
- Handle errors appropriately
- Close connections properly

### Security

- Never commit secrets or credentials
- Validate all user input
- Escape output to prevent XSS
- Use HTTPS in production
- Follow OWASP security best practices

## Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add user profile page
fix: resolve login redirect issue
docs: update deployment guide
style: format code with prettier
refactor: simplify authentication logic
test: add tests for CRUD operations
chore: update dependencies
```

## Testing

- Test your changes manually before submitting
- Run smoke tests: `npm run test:smoke`
- Ensure CI passes before requesting review
- Test on multiple browsers if UI changes

## Documentation

- Update README.md if adding features
- Update Documentation-Full.md for significant changes
- Add code comments for complex logic
- Update API documentation if applicable

## Review Process

1. Pull requests require at least one approval
2. All CI checks must pass
3. Code must follow project standards
4. Documentation must be updated if needed
5. No merge conflicts

## Questions?

If you have questions:
- Open an issue with your question
- Check existing documentation
- Review closed issues for similar questions

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to TechCorp Solutions! 🚀
