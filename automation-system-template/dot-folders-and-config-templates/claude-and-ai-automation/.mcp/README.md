# MCP (Model Context Protocol) Configuration Template

This directory contains MCP server configurations for enabling AI agents to interact with your application.

## What is MCP?

Model Context Protocol (MCP) is an open protocol that standardizes how AI applications interact with external tools and data sources.

## Quick Start

1. Copy this template to your project root as `.mcp/`
2. Customize the configuration files for your project
3. Choose setup option:
   - **Option 1**: Docker AI (Gordon) - Auto-detected, simplest setup
   - **Option 2**: MCP Gateway - Full-featured, supports multiple AI clients

## Configuration Files

### gordon-mcp.yml

Docker AI auto-detected configuration. Place in project root.

```yaml
version: "3.8"
services:
  filesystem:
    image: mcp/filesystem
    volumes:
      - .:/data:ro
    environment:
      - ALLOWED_PATHS=/data
      
  fetch:
    image: mcp/fetch
    environment:
      - ALLOWED_HOSTS=localhost,api.openai.com
```

### docker-compose.mcp-gateway.yml

Full MCP Gateway for multiple AI clients.

```yaml
version: "3.8"
services:
  mcp-gateway:
    image: docker/mcp-gateway
    ports:
      - "8080:8080"
    volumes:
      - ./configs:/configs
```

## Available MCP Servers

### 1. Filesystem Server

**Image:** `mcp/filesystem`

**Capabilities:**
- Read project files
- List directory contents
- Search for files
- Access documentation

**Configuration:**
```yaml
filesystem:
  image: mcp/filesystem
  volumes:
    - .:/data:ro
  environment:
    - ALLOWED_PATHS=/data
    - ALLOWED_EXTENSIONS=.py,.js,.ts,.md,.json,.yml
```

### 2. Fetch Server

**Image:** `mcp/fetch`

**Capabilities:**
- Make HTTP requests to local API
- Test external integrations
- Fetch remote data sources

**Configuration:**
```yaml
fetch:
  image: mcp/fetch
  environment:
    - ALLOWED_HOSTS=localhost,api.example.com
    - TIMEOUT=30000
```

### 3. Time Server

**Image:** `mcp/time`

**Capabilities:**
- Get current timestamps
- Format date/time strings
- Calculate time differences

## Integration with AI Clients

### Claude Desktop

**Config Location:** `%APPDATA%\Claude\claude_desktop_config.json` (Windows)

```json
{
  "mcpServers": {
    "your-project": {
      "url": "http://localhost:8080",
      "transport": "sse"
    }
  }
}
```

### Docker AI

Docker AI automatically detects `gordon-mcp.yml` in project root.

```bash
docker ai "Analyze the project structure"
docker ai "What files are in the data directory?"
```

## Security Considerations

### Filesystem Access

- MCP filesystem server has **read-only** access
- Restrict to project directory only
- Configure allowed file extensions

### Network Access

- Limit fetch server to specific hosts
- Use localhost for local services
- Configure timeouts

### Credentials

- Never expose API keys in MCP configurations
- Use environment variables for secrets
- MCP Gateway supports OAuth

## Customization

### Add Custom MCP Server

1. Create server implementation in `.mcp/servers/`
2. Add to `docker-compose.mcp-gateway.yml`
3. Update `mcp-catalog.yaml`

### Example Custom Server

```yaml
custom-server:
  build:
    context: .mcp/servers/custom
  environment:
    - API_KEY=${API_KEY}
  ports:
    - "9000:9000"
```

## Troubleshooting

### Gordon doesn't detect configuration

```bash
# Ensure gordon-mcp.yml is in project root
ls gordon-mcp.yml

# Restart Docker Desktop
```

### MCP Gateway connection refused

```bash
# Check if gateway is running
docker ps | grep mcp-gateway

# View logs
docker logs mcp-gateway

# Restart gateway
docker-compose -f docker-compose.mcp-gateway.yml restart
```

## Resources

- [Docker MCP Documentation](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [Model Context Protocol Spec](https://github.com/anthropics/mcp)
- [Claude Desktop MCP Guide](https://docs.anthropic.com/claude/docs/model-context-protocol)

## Template Version

**Version:** 1.0.0
**Last Updated:** 2025-11-07
