# MCP Setup Guide - AI Whisperers Standards Repository

Comprehensive setup instructions for Model Context Protocol servers in the AI Whisperers standardization repository.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Verification](#verification)
5. [Usage Examples](#usage-examples)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Configuration](#advanced-configuration)

## Prerequisites

### Required Software

- **Docker Desktop** (version 4.23+)
  - Windows: [Download](https://www.docker.com/products/docker-desktop)
  - macOS: [Download](https://www.docker.com/products/docker-desktop)
  - Linux: Install via package manager

- **Git** (for cloning repository)
  - [Download Git](https://git-scm.com/downloads)

### Optional Tools

- **Docker AI CLI** (for Docker AI integration)
  - Included with Docker Desktop 4.25+

- **Claude Desktop** (for Claude integration)
  - [Download](https://claude.ai/download)

- **Cursor IDE** or **VSCode** (for IDE integration)

### System Requirements

- **RAM:** 4 GB minimum, 8 GB recommended
- **Disk:** 2 GB free space
- **OS:** Windows 10+, macOS 10.15+, or modern Linux

## Installation

### Step 1: Clone Repository

```bash
# Navigate to your projects directory
cd ~/projects  # or your preferred location

# Clone the repository
git clone <repository-url> ai-whisperers-standards
cd ai-whisperers-standards
```

### Step 2: Start Docker Desktop

Ensure Docker Desktop is running before proceeding.

**Windows:**
```bash
"C:\Program Files\Docker\Docker\Docker Desktop.exe"
```

**macOS:**
```bash
open -a Docker
```

**Linux:**
```bash
sudo systemctl start docker
```

Wait for Docker to fully start (whale icon in system tray should be active).

### Step 3: Choose Setup Method

#### Option A: Docker AI Setup (Recommended for Development)

```bash
# 1. Copy gordon-mcp.yml to project root
cp .mcp/configs/gordon-mcp.yml ./gordon-mcp.yml

# 2. Pull built-in MCP servers
docker pull mcp/filesystem

# 3. Test the setup
docker ai "List markdown files in documentation-template/"
```

#### Option B: MCP Gateway Setup (Recommended for Teams/CI)

```bash
# 1. Copy gateway config to project root
cp .mcp/configs/docker-compose.mcp-gateway.yml ./docker-compose.mcp-gateway.yml

# 2. Build and start services
docker-compose -f docker-compose.mcp-gateway.yml up -d --build

# 3. Verify services are running
docker-compose -f docker-compose.mcp-gateway.yml ps

# 4. Check gateway health
curl http://localhost:8080/health
```

## Configuration

### Gordon MCP (Docker AI)

The `gordon-mcp.yml` file defines services for Docker AI:

```yaml
version: "3.8"
services:
  filesystem:
    image: mcp/filesystem
    volumes:
      - .:/data:ro
    environment:
      - ALLOWED_PATHS=/data
      - ALLOWED_EXTENSIONS=.md,.json,.yml,.yaml,.py,.js,.ts

  # Future: custom validator (when implemented)
  # standards-validator:
  #   build:
  #     context: .mcp/servers/standards-validator
  #   volumes:
  #     - .:/workspace:ro
```

**Customization:**
- Modify `ALLOWED_EXTENSIONS` to control accessible file types
- Add more services as needed

### MCP Gateway

The `docker-compose.mcp-gateway.yml` defines the full MCP Gateway:

```yaml
version: "3.8"
services:
  mcp-gateway:
    image: docker/mcp-gateway:latest
    ports:
      - "8080:8080"
    volumes:
      - ./.mcp/configs:/configs:ro
    networks:
      - mcp-network

  filesystem:
    image: mcp/filesystem
    volumes:
      - .:/data:ro
    environment:
      - ALLOWED_PATHS=/data
      - ALLOWED_EXTENSIONS=.md,.json,.yml,.yaml,.py,.js,.ts
    networks:
      - mcp-network

networks:
  mcp-network:
    driver: bridge
```

**Customization:**
- Change port `8080` if needed (update both places)
- Add additional MCP servers as services
- Configure network settings

### Claude Desktop Integration

**Windows:**
Edit `%APPDATA%\Claude\claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ai-whisperers-standards": {
      "url": "http://localhost:8080",
      "transport": "sse"
    }
  }
}
```

**macOS/Linux:**
Edit `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ai-whisperers-standards": {
      "url": "http://localhost:8080",
      "transport": "sse"
    }
  }
}
```

### Cursor/VSCode Integration

Install MCP extension and add to settings:

**VSCode** (`.vscode/settings.json`):
```json
{
  "mcp.servers": [
    {
      "name": "AI Whisperers Standards",
      "url": "http://localhost:8080"
    }
  ]
}
```

**Cursor** (Cursor Settings → MCP):
```json
{
  "mcp": {
    "servers": [
      {
        "name": "AI Whisperers Standards",
        "url": "http://localhost:8080"
      }
    ]
  }
}
```

## Verification

### Test Docker AI

```bash
# Basic filesystem access
docker ai "List all files in the project root"

# Documentation reading
docker ai "Show the contents of README.md"

# Directory exploration
docker ai "What folders exist in automation-system-template?"

# File search
docker ai "Find all JSON files in .claude folders"
```

### Test MCP Gateway

```bash
# Check gateway is responding
curl http://localhost:8080/health

# List available tools (if endpoint exists)
curl http://localhost:8080/tools

# Check container logs
docker-compose -f docker-compose.mcp-gateway.yml logs

# Verify all containers running
docker-compose -f docker-compose.mcp-gateway.yml ps
```

### Test AI Client Integration

**Claude Desktop:**
1. Open Claude Desktop
2. Start new conversation
3. Ask: "List files in the AI Whisperers standards repository"
4. Should see file listing

**Cursor IDE:**
1. Open project in Cursor
2. Open AI chat panel
3. Ask: "What markdown files are in documentation-template?"
4. Should access repository files

## Usage Examples

### Documentation Validation

```bash
# Check main README structure
docker ai "Does README.md follow AI Whisperers documentation standards?"

# Analyze hierarchy
docker ai "Check if documentation-template/documentation-format.md has proper heading hierarchy"

# Verify metadata
docker ai "Does the main README have the required metadata line?"
```

### Template Inspection

```bash
# Compare templates
docker ai "What are the differences between .claude folders in different templates?"

# Check completeness
docker ai "List all files in automation-system-template/dot-folders-and-config-templates/.claude/"

# Find inconsistencies
docker ai "Are the .mcp README files consistent across templates?"
```

### File Discovery

```bash
# Find specific files
docker ai "Where are all the settings.local.json files?"

# Search content
docker ai "Which files mention 'Toon format'?"

# Get file counts
docker ai "How many markdown files are in the documentation-template?"
```

### Batch Operations

```bash
# List all documentation
docker ai "Create a list of all documentation files with their purposes"

# Find missing files
docker ai "Check if all template folders have README.md files"

# Generate inventory
docker ai "Generate an inventory of all configuration files in the project"
```

## Troubleshooting

### Docker Desktop Issues

**Problem:** Docker Desktop won't start

**Solutions:**
```bash
# Windows: Check Hyper-V is enabled
# Run in PowerShell as Administrator:
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# Reset Docker Desktop
# Windows: Settings → Troubleshoot → Reset to factory defaults
# macOS: Troubleshoot → Reset to factory defaults

# Check system resources
# Ensure sufficient RAM and disk space
```

### MCP Server Issues

**Problem:** Containers won't start

**Solutions:**
```bash
# Check Docker is running
docker ps

# View detailed logs
docker-compose -f docker-compose.mcp-gateway.yml logs

# Rebuild containers
docker-compose -f docker-compose.mcp-gateway.yml down
docker-compose -f docker-compose.mcp-gateway.yml up -d --build --force-recreate

# Check port conflicts
# Ensure port 8080 is not in use
netstat -an | grep 8080  # Unix/macOS
netstat -an | findstr 8080  # Windows
```

**Problem:** Cannot access files

**Solutions:**
```bash
# Check volume mounts
docker-compose -f docker-compose.mcp-gateway.yml config

# Verify file permissions
ls -la .mcp/

# Check ALLOWED_PATHS environment variable
docker-compose -f docker-compose.mcp-gateway.yml exec filesystem env
```

### Docker AI Issues

**Problem:** Docker AI doesn't detect gordon-mcp.yml

**Solutions:**
```bash
# Ensure file is in project root
ls gordon-mcp.yml

# Copy from configs if missing
cp .mcp/configs/gordon-mcp.yml ./gordon-mcp.yml

# Restart Docker Desktop

# Try explicit working directory
cd "C:/Users/Gestalt/Desktop/standards in ai whisperers/template-standard"
docker ai "test query"
```

**Problem:** Docker AI returns permission errors

**Solutions:**
```bash
# Check read permissions on files
chmod -R 755 .mcp/  # Unix/macOS

# Verify Docker has access to directory
# Docker Desktop → Settings → Resources → File Sharing
# Add project directory
```

### Client Integration Issues

**Problem:** Claude Desktop can't connect

**Solutions:**
```bash
# Verify gateway is running
curl http://localhost:8080/health

# Check config file syntax
cat "%APPDATA%\Claude\claude_desktop_config.json"  # Windows
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json  # macOS

# Restart Claude Desktop

# Check firewall settings
# Ensure port 8080 is allowed
```

**Problem:** Cursor/VSCode integration fails

**Solutions:**
```bash
# Verify MCP extension is installed
# Check extension settings

# Test gateway directly
curl http://localhost:8080

# Check IDE logs for errors
# VSCode: Help → Toggle Developer Tools → Console
# Cursor: Similar process
```

## Advanced Configuration

### Custom Port Configuration

```yaml
# In docker-compose.mcp-gateway.yml
services:
  mcp-gateway:
    ports:
      - "9000:8080"  # Change left port to desired port
```

Update client configs to use new port:
```json
{
  "url": "http://localhost:9000"
}
```

### Multiple Project Support

```yaml
# Create separate compose files for each project
docker-compose -f project1-mcp.yml up -d
docker-compose -f project2-mcp.yml up -d

# Use different ports for each
# project1-mcp.yml: ports: "8081:8080"
# project2-mcp.yml: ports: "8082:8080"
```

### CI/CD Integration

**GitHub Actions:**
```yaml
name: Validate Documentation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Start MCP Gateway
        run: |
          cp .mcp/configs/docker-compose.mcp-gateway.yml ./
          docker-compose -f docker-compose.mcp-gateway.yml up -d
          sleep 10  # Wait for services to start

      - name: Validate Documentation
        run: |
          docker ai "Validate all .md files in the repository"

      - name: Cleanup
        run: docker-compose -f docker-compose.mcp-gateway.yml down
```

### Performance Tuning

```yaml
# In docker-compose.mcp-gateway.yml
services:
  mcp-gateway:
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
```

### Logging Configuration

```yaml
# Add logging to services
services:
  mcp-gateway:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Maintenance

### Regular Updates

```bash
# Update Docker images
docker pull mcp/filesystem
docker pull docker/mcp-gateway

# Rebuild custom services
docker-compose -f docker-compose.mcp-gateway.yml build --no-cache

# Restart services
docker-compose -f docker-compose.mcp-gateway.yml restart
```

### Cleanup

```bash
# Stop services
docker-compose -f docker-compose.mcp-gateway.yml down

# Remove volumes (if needed)
docker-compose -f docker-compose.mcp-gateway.yml down -v

# Clean up unused images
docker image prune -a

# Clean up unused containers
docker container prune
```

## Next Steps

- Review [ARCHITECTURE.md](ARCHITECTURE.md) for system design details
- Implement custom validators in `.mcp/servers/standards-validator/`
- Configure pre-commit hooks for automatic validation
- Set up CI/CD integration for automated checks
- Customize validation rules for your specific needs

## Support

For issues and questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review Docker logs: `docker-compose logs`
3. Consult [MCP Documentation](https://github.com/anthropics/mcp)
4. Check [Docker MCP Guide](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)

---

**Setup complete?** Return to [README.md](README.md) for usage overview.
