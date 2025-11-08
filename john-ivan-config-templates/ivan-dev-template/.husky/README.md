# Husky Git Hooks Template

This directory contains Git hooks managed by Husky.

## Setup

1. Install Husky:
   ```bash
   npm install --save-dev husky
   npx husky install
   ```

2. Make hooks executable:
   ```bash
   chmod +x .husky/*
   ```

3. Configure package.json:
   ```json
   {
     "scripts": {
       "prepare": "husky install"
     }
   }
   ```

## Available Hooks

### pre-commit

Runs before every commit:

- Lints and formats staged files (lint-staged)
- Runs type checking (mypy, pyright, etc.)
- Scans for security issues (bandit, safety)
- Checks for secrets in code
- Validates repository organization

### pre-push

Runs before pushing to remote:

- Runs unit tests
- Runs linting
- Validates build
- Prevents broken code from being pushed

### commit-msg

Validates commit message format:

- Enforces Conventional Commits format
- Checks message length
- Validates commit types

## Conventional Commits Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `perf`: Performance improvements

**Example:**
```
feat(auth): add JWT token validation

Implements JWT token validation middleware for API endpoints.
Includes token expiration and refresh logic.

Closes #123
```

## Bypassing Hooks

To skip hooks (not recommended):

```bash
git commit --no-verify
git push --no-verify
```

## Customization

Edit individual hook files to add project-specific checks:

- Add custom linting rules
- Configure test suites
- Add database migration checks
- Validate documentation
- Check code coverage thresholds

## Troubleshooting

### Hooks not running

```bash
# Reinstall hooks
npx husky install

# Make hooks executable
chmod +x .husky/*
```

### Permission denied

```bash
# On Windows, use Git Bash
# On Unix, ensure execute permission
chmod +x .husky/pre-commit
```

## Template Version

**Version:** 1.0.0
**Last Updated:** 2025-11-07
