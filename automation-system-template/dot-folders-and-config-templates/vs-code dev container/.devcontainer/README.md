# Dev Container Configuration Template

This directory contains configuration for VS Code Dev Containers.

## Quick Start

1. Install VS Code and the "Dev Containers" extension
2. Open project in VS Code
3. Press F1 and select "Dev Containers: Reopen in Container"
4. Wait for container to build and start

## What's Included

- **Python 3.11** with common development tools
- **Node.js 20** for frontend development
- **Docker-in-Docker** for container management
- **Git** and GitHub CLI
- **VS Code extensions** for Python, Docker, and more
- **Auto-configured services** (Redis, PostgreSQL, etc.)

## Configuration Files

- `devcontainer.json` - VS Code dev container configuration
- `docker-compose.yml` - Service orchestration
- `Dockerfile` - Base container image
- `post-create.sh` - Post-creation setup script

## Customization

### Add Services

Edit `docker-compose.yml` to add databases, caches, queues:

```yaml
postgres:
  image: postgres:15-alpine
  environment:
    POSTGRES_DB: mydb
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
  ports:
    - "5432:5432"
```

### Add VS Code Extensions

Edit `devcontainer.json`:

```json
"extensions": [
  "ms-python.python",
  "your-extension-id"
]
```

### Configure Environment

Add environment variables in `docker-compose.yml` or `devcontainer.json`.

## Port Forwarding

Ports are automatically forwarded:

- 5173 - Frontend (Vite/React)
- 8000 - Backend API
- 6379 - Redis

## Tips

- Use the integrated terminal for commands
- Extensions are pre-installed and configured
- Services start automatically
- Changes to devcontainer.json require rebuild

## Rebuild Container

Press F1 and select "Dev Containers: Rebuild Container" after configuration changes.

## Template Version

**Version:** 1.0.0
**Last Updated:** 2025-11-07
