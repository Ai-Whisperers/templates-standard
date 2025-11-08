# MCP Setup Guide

**Doc-Type:** Setup Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Comprehensive setup for Model Context Protocol servers in AI Whisperers standards repository.

---

## Prerequisites

| Software | Version | Purpose |
|----------|---------|---------|
| Docker Desktop | 4.23+ | Container runtime |
| Git | Latest | Repository cloning |
| Docker AI CLI | 4.25+ | Optional - Docker AI integration |
| Claude Desktop | Latest | Optional - Claude integration |

**System Requirements:**
- RAM: 4 GB min, 8 GB recommended
- Disk: 2 GB free
- OS: Windows 10+, macOS 10.15+, modern Linux

---

## Installation

### Clone Repository

```bash
cd ~/projects
git clone <repository-url> ai-whisperers-standards
cd ai-whisperers-standards
```

### Start Docker

| Platform | Command |
|----------|---------|
| Windows | `"C:\Program Files\Docker\Docker\Docker Desktop.exe"` |
| macOS | `open -a Docker` |
| Linux | `sudo systemctl start docker` |

### Choose Setup Method

#### Option A: Docker AI (Development)

```bash
cp .mcp/configs/gordon-mcp.yml ./gordon-mcp.yml
docker pull mcp/filesystem
docker ai "List markdown files in documentation-template/"
```

#### Option B: MCP Gateway (Teams/CI)

```bash
cp .mcp/configs/docker-compose.mcp-gateway.yml ./
docker-compose -f docker-compose.mcp-gateway.yml up -d --build
docker-compose -f docker-compose.mcp-gateway.yml ps
curl http://localhost:8080/health
```

---

## Configuration

### Gordon MCP (Docker AI)

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
```

**Customization:** Modify `ALLOWED_EXTENSIONS` to control file types.

### MCP Gateway

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

### Client Integration

**Claude Desktop:** Edit config file:
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- macOS/Linux: `~/Library/Application Support/Claude/claude_desktop_config.json`

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

**VSCode:** `.vscode/settings.json`
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

---

## Verification

### Docker AI Tests

```bash
docker ai "List all files in the project root"
docker ai "Show the contents of README.md"
docker ai "What folders exist in automation-system-template?"
docker ai "Find all JSON files in .claude folders"
```

### MCP Gateway Tests

```bash
curl http://localhost:8080/health
curl http://localhost:8080/tools
docker-compose -f docker-compose.mcp-gateway.yml logs
docker-compose -f docker-compose.mcp-gateway.yml ps
```

### Client Integration Tests

**Claude Desktop:**
1. Open Claude Desktop
2. Ask: "List files in the AI Whisperers standards repository"
3. Verify file listing appears

**Cursor IDE:**
1. Open project in Cursor
2. Ask: "What markdown files are in documentation-template?"
3. Verify repository access

---

## Usage Examples

### Documentation Validation

```bash
docker ai "Does README.md follow AI Whisperers documentation standards?"
docker ai "Check if documentation-template/documentation-format.md has proper heading hierarchy"
docker ai "Does the main README have the required metadata line?"
```

### Template Inspection

```bash
docker ai "What are the differences between .claude folders in different templates?"
docker ai "List all files in automation-system-template/dot-folders-and-config-templates/.claude/"
docker ai "Are the .mcp README files consistent across templates?"
```

### File Discovery

```bash
docker ai "Where are all the settings.local.json files?"
docker ai "Which files mention 'Toon format'?"
docker ai "How many markdown files are in the documentation-template?"
```

---

## Troubleshooting

### Docker Desktop Issues

| Problem | Solution |
|---------|----------|
| Won't start | Windows: Enable Hyper-V (`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`)<br>All: Settings → Troubleshoot → Reset to factory defaults |
| Resource issues | Check RAM and disk space availability |

### MCP Server Issues

| Problem | Solution |
|---------|----------|
| Containers won't start | `docker ps`<br>`docker-compose -f docker-compose.mcp-gateway.yml logs`<br>`docker-compose -f docker-compose.mcp-gateway.yml down && docker-compose -f docker-compose.mcp-gateway.yml up -d --build --force-recreate` |
| Cannot access files | `docker-compose -f docker-compose.mcp-gateway.yml config`<br>Verify file permissions<br>Check ALLOWED_PATHS env var |
| Port conflicts | `netstat -an \| grep 8080` (Unix/macOS)<br>`netstat -an \| findstr 8080` (Windows) |

### Docker AI Issues

| Problem | Solution |
|---------|----------|
| Doesn't detect gordon-mcp.yml | `ls gordon-mcp.yml`<br>`cp .mcp/configs/gordon-mcp.yml ./gordon-mcp.yml`<br>Restart Docker Desktop |
| Permission errors | `chmod -R 755 .mcp/` (Unix/macOS)<br>Docker Desktop → Settings → Resources → File Sharing → Add project directory |

### Client Integration Issues

| Problem | Solution |
|---------|----------|
| Claude can't connect | `curl http://localhost:8080/health`<br>Verify config syntax<br>Restart Claude Desktop<br>Check firewall (port 8080) |
| Cursor/VSCode fails | Verify MCP extension installed<br>`curl http://localhost:8080`<br>Check IDE logs (Help → Toggle Developer Tools → Console) |

---

## Advanced Configuration

### Custom Ports

```yaml
# In docker-compose.mcp-gateway.yml
services:
  mcp-gateway:
    ports:
      - "9000:8080"  # Change left port
```

Update clients:
```json
{"url": "http://localhost:9000"}
```

### Multiple Projects

```bash
docker-compose -f project1-mcp.yml up -d  # ports: "8081:8080"
docker-compose -f project2-mcp.yml up -d  # ports: "8082:8080"
```

### CI/CD Integration

```yaml
# GitHub Actions
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
          sleep 10
      - name: Validate Documentation
        run: docker ai "Validate all .md files in the repository"
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
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

---

## Maintenance

### Updates

```bash
docker pull mcp/filesystem
docker pull docker/mcp-gateway
docker-compose -f docker-compose.mcp-gateway.yml build --no-cache
docker-compose -f docker-compose.mcp-gateway.yml restart
```

### Cleanup

```bash
docker-compose -f docker-compose.mcp-gateway.yml down
docker-compose -f docker-compose.mcp-gateway.yml down -v  # Remove volumes
docker image prune -a
docker container prune
```

---

## Next Steps

- Review [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- Implement custom validators in `.mcp/servers/standards-validator/`
- Configure pre-commit hooks
- Set up CI/CD integration

## Support

1. Check [Troubleshooting](#troubleshooting)
2. Review Docker logs: `docker-compose logs`
3. Consult [MCP Documentation](https://github.com/anthropics/mcp)
4. Check [Docker MCP Guide](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)

---

**Setup complete?** Return to [README.md](README.md) for usage overview.
