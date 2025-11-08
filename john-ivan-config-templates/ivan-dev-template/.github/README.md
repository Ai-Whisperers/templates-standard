# GitHub Configuration Template

This directory contains GitHub-specific configuration files for CI/CD, issue management, and collaboration.

## Structure

```
.github/
├── workflows/                  # GitHub Actions workflows
│   ├── test.yml               # Test suite
│   └── code-quality.yml       # Code quality checks
├── ISSUE_TEMPLATE/            # Issue templates
│   ├── bug_report.yml        # Bug report template
│   └── feature_request.yml   # Feature request template
├── PULL_REQUEST_TEMPLATE.md  # PR template
├── dependabot.yml            # Dependency updates
└── README.md                 # This file
```

## Customization

### Workflows

1. **test.yml**: Update with your test commands and services
2. **code-quality.yml**: Configure your linting and security tools

### Issue Templates

1. Customize fields in `bug_report.yml` and `feature_request.yml`
2. Add more templates for different issue types (e.g., documentation, security)

### Dependabot

Update `dependabot.yml` with your package ecosystems and update schedules.

## Best Practices

- Keep workflows fast (use caching, parallel jobs)
- Add status badges to README
- Use branch protection rules
- Configure CODEOWNERS for automatic review assignments
- Set up required status checks before merge

## Template Version

**Version:** 1.0.0
**Last Updated:** 2025-11-07
