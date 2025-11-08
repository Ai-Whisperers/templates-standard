# Configuration Template

This directory contains standardized configuration templates for quality assurance, development workflows, and AI assistant integration. These templates are designed to be project-agnostic and can be customized for any software project.

## Overview

This template collection provides configurations for:

- **.claude/** - Claude Code AI assistant integration
- **.github/** - GitHub workflows and automation
- **.devcontainer/** - VS Code dev container setup
- **.husky/** - Git hooks for quality checks
- **.mcp/** - Model Context Protocol for AI agents

## Quick Start

### 1. Copy Templates to Your Project

```bash
# Copy entire template directory
cp -r template/.claude ./.claude
cp -r template/.github ./.github
cp -r template/.devcontainer ./.devcontainer
cp -r template/.husky ./.husky
cp -r template/.mcp ./.mcp
```

### 2. Customize Each Configuration

Look for customization notes in each file:

```
# CUSTOMIZATION NOTES:
# - Update PROJECT_NAME
# - Configure environment variables
```

### 3. Install Dependencies

```bash
# Install Husky
npm install --save-dev husky
npx husky install

# Make scripts executable
chmod +x .husky/*
chmod +x .devcontainer/post-create.sh
```

### 4. Update .gitignore

```
.claude/settings.local.json
.devcontainer/.env
.env
.env.*
```

## Configuration Components

### .claude/ - Claude Code Configuration

**Purpose**: Configure Claude Code AI assistant

**Key Files**:
- settings.local.json - Permissions, hooks, environment
- commands/ - Custom slash commands
- README.md - Documentation

**Customization**:
- [ ] Update environment variables
- [ ] Add project-specific permissions
- [ ] Create custom slash commands
- [ ] Configure pre-commit hooks

### .github/ - GitHub Workflows

**Purpose**: CI/CD pipelines and automation

**Key Files**:
- workflows/test.yml - Test automation
- workflows/code-quality.yml - Linting and security
- PULL_REQUEST_TEMPLATE.md - PR template
- dependabot.yml - Dependency updates

**Customization**:
- [ ] Update language versions
- [ ] Configure test commands
- [ ] Add required secrets
- [ ] Set up branch protection

### .devcontainer/ - Dev Container

**Purpose**: Consistent development environment

**Key Files**:
- devcontainer.json - VS Code config
- docker-compose.yml - Services
- Dockerfile - Base image
- post-create.sh - Setup script

**Customization**:
- [ ] Update project name
- [ ] Configure services
- [ ] Install VS Code extensions
- [ ] Configure port forwarding

### .husky/ - Git Hooks

**Purpose**: Pre-commit/push quality checks

**Key Files**:
- pre-commit - Runs before commit
- pre-push - Runs before push
- commit-msg - Validates messages

**Customization**:
- [ ] Configure linting tools
- [ ] Set up test commands
- [ ] Add security scanning
- [ ] Configure commit format

### .mcp/ - Model Context Protocol

**Purpose**: AI agent integration

**Key Files**:
- configs/gordon-mcp.yml - Docker AI
- configs/docker-compose.mcp-gateway.yml - Gateway
- configs/mcp-catalog.yaml - Server registry

**Customization**:
- [ ] Configure file extensions
- [ ] Set allowed API hosts
- [ ] Add custom servers
- [ ] Update security settings

## Complete Setup Example

### Python Project

1. Copy templates:
   ```bash
   cp -r template/{.claude,.github,.husky} ./
   ```

2. Customize .claude/settings.local.json:
   ```json
   {
     "env": {
       "PYTHONPATH": ".:./api"
     }
   }
   ```

3. Setup git hooks:
   ```bash
   npm install --save-dev husky
   npx husky install
   ```

4. Create CLAUDE.md in project root

### JavaScript/TypeScript Project

1. Copy templates:
   ```bash
   cp -r template/{.claude,.github,.husky} ./
   ```

2. Customize for Node.js:
   - Remove Python-specific configs
   - Add npm permissions
   - Configure ESLint/Prettier

## Security Best Practices

1. **Never commit secrets**:
   - Add .claude/settings.local.json to .gitignore
   - Use environment variables
   - Enable secret scanning

2. **Restrict permissions**:
   - Use read-only for MCP filesystem
   - Limit allowed hosts
   - Configure minimal permissions

3. **Enable security checks**:
   - Add security scanners (bandit, npm audit)
   - Enable Dependabot
   - Validate inputs

## Maintenance

**Monthly**:
- Review Dependabot PRs
- Update workflow versions

**Quarterly**:
- Review permissions
- Update language versions
- Security audit

## Troubleshooting

### Claude Code

**Commands not found**: Restart Claude Code

**Permission denied**: Update allow patterns in settings.local.json

### Git Hooks

**Hooks not running**: 
```bash
npx husky install
chmod +x .husky/*
```

### Dev Container

**Container won't start**: Check Docker, rebuild container

## Resources

- [Claude Code Docs](https://docs.claude.com/en/docs/claude-code/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Husky](https://typicode.github.io/husky/)
- [MCP Spec](https://github.com/anthropics/mcp)

## Template Version

**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

These templates provide standardized QA guardrails for development workflows. Customize as needed for your projects.
