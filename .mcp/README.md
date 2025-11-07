# MCP Configuration - AI Whisperers Standards Repository

This directory contains Model Context Protocol (MCP) server configurations for enabling AI agents to interact with and validate the AI Whisperers standardization templates.

## What is MCP?

Model Context Protocol (MCP) is an open protocol that standardizes how AI applications interact with external tools and data sources. In this repository, MCP enables:

- **Cross-model validation**: Any AI client can validate documentation standards
- **Automated checking**: CI/CD integration for standards compliance
- **Tool exposure**: Share validation tools across development environments

## Quick Start

### Option 1: Docker AI (Gordon) - Simplest

```bash
# 1. Ensure Docker Desktop is running

# 2. Pull built-in servers
docker pull mcp/filesystem && docker pull mcp/fetch

# 3. Test it
docker ai "List all markdown files in documentation-template/"
docker ai "Validate the main README.md structure"
```

### Option 2: MCP Gateway - Full Featured

```bash
# 1. Start MCP Gateway
docker-compose -f docker-compose.mcp-gateway.yml up -d --build

# 2. Verify running
docker-compose -f docker-compose.mcp-gateway.yml ps

# 3. Connect AI clients to http://localhost:8080
```

## Available MCP Servers

### 1. Filesystem Server (Built-in)

**Image:** `mcp/filesystem`

**Capabilities:**
- Read all template files
- List directory structures
- Search documentation
- Access examples

**Security:**
- Read-only access
- Restricted to project directory
- Allowed extensions: .md, .json, .yml, .yaml, .py, .js, .ts

### 2. Standards Validator (Custom)

**Purpose:** Validate documentation and templates against AI Whisperers standards

**Tools Provided:**

| Tool | Purpose | Example |
|------|---------|---------|
| `validate_documentation` | Check doc compliance | "Validate README.md" |
| `check_doc_ratio` | Analyze Human/Toon ratio | "Check ratio in api-spec.md" |
| `validate_hierarchy` | Check heading structure | "Validate hierarchy in guide.md" |
| `check_template_consistency` | Compare templates | "Check .claude template consistency" |
| `validate_toon_format` | Verify Toon syntax | "Validate Toon in config.md" |
| `analyze_cognitive_flow` | Check readability | "Analyze flow in documentation-format.md" |

## Configuration Files

### gordon-mcp.yml

Docker AI auto-detected configuration for development:

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

  standards-validator:
    build:
      context: .mcp/servers/standards-validator
    volumes:
      - .:/workspace:ro
    environment:
      - PROJECT_TYPE=standardization-template
```

### docker-compose.mcp-gateway.yml

Full MCP Gateway for production and multi-client support:

```yaml
version: "3.8"
services:
  mcp-gateway:
    image: docker/mcp-gateway
    ports:
      - "8080:8080"
    volumes:
      - ./configs:/configs
    networks:
      - mcp-network

  filesystem:
    image: mcp/filesystem
    volumes:
      - .:/data:ro
    environment:
      - ALLOWED_PATHS=/data
    networks:
      - mcp-network

  standards-validator:
    build:
      context: .mcp/servers/standards-validator
    volumes:
      - .:/workspace:ro
    environment:
      - PROJECT_TYPE=standardization-template
    networks:
      - mcp-network

networks:
  mcp-network:
    driver: bridge
```

## Integration with AI Clients

### Claude Desktop

**Config Location:** `%APPDATA%\Claude\claude_desktop_config.json` (Windows)

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

### Docker AI

Docker AI automatically detects `gordon-mcp.yml` in project root.

```bash
# Example queries
docker ai "Validate all documentation in documentation-template/"
docker ai "Check template consistency across automation-system-template/"
docker ai "Analyze documentation ratio in README.md"
docker ai "What files need Toon format updates?"
```

### Cursor IDE / VSCode

Install MCP extension and configure:

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

## Custom Validator Server

The `standards-validator` MCP server provides AI Whisperers-specific validation tools.

### Architecture

```
standards-validator/
├── Dockerfile              # Container definition
├── requirements.txt        # Python dependencies
├── server.py              # MCP server implementation
├── validators/            # Validation modules
│   ├── doc_structure.py   # Documentation structure validation
│   ├── toon_format.py     # Toon format validation
│   ├── cognitive_flow.py  # Readability analysis
│   └── template_check.py  # Template consistency
└── README.md             # Server documentation
```

### Tool Examples

#### validate_documentation

```python
{
  "file_path": "README.md",
  "strict": true,
  "check_ratio": true
}
# Returns: compliance report with passed/failed checks
```

#### check_doc_ratio

```python
{
  "file_path": "documentation-template/documentation-format.md",
  "expected_type": "guide"
}
# Returns: Human/Toon ratio analysis and recommendations
```

#### check_template_consistency

```python
{
  "template_path": "automation-system-template/dot-folders-and-config-templates/"
}
# Returns: consistency report across all templates
```

## Security Considerations

### Filesystem Access
- **Read-only** access to project directory
- No write permissions
- Limited to documentation and configuration files
- Excluded: .git/, .env files, secrets

### Network Access
- Standards validator runs locally only
- No external API calls required
- No credentials needed

### Validation Safety
- Non-destructive operations only
- No file modifications
- Recommendations and reports only

## Use Cases

### 1. Pre-Commit Validation

```bash
# In git hooks or CI/CD
docker ai "Validate all modified .md files for standards compliance"
```

### 2. Documentation Review

```bash
# During PR review
docker ai "Check if new documentation follows AI Whisperers standards"
docker ai "Analyze documentation ratio in added files"
```

### 3. Template Maintenance

```bash
# Regular maintenance
docker ai "Compare .claude templates across all folders"
docker ai "Find inconsistencies in .mcp configurations"
```

### 4. Batch Validation

```bash
# Validate entire repository
docker ai "Generate compliance report for all documentation"
docker ai "List files that need Toon format conversion"
```

## Troubleshooting

### Docker AI doesn't detect configuration

```bash
# Ensure gordon-mcp.yml is in project root
ls gordon-mcp.yml

# Copy from .mcp/configs/ if missing
cp .mcp/configs/gordon-mcp.yml ./

# Restart Docker Desktop
```

### MCP Gateway connection refused

```bash
# Check if gateway is running
docker-compose -f docker-compose.mcp-gateway.yml ps

# View logs
docker-compose -f docker-compose.mcp-gateway.yml logs

# Restart
docker-compose -f docker-compose.mcp-gateway.yml restart
```

### Validator build fails

```bash
# Clean rebuild
docker-compose -f docker-compose.mcp-gateway.yml build standards-validator --no-cache

# Check logs
docker logs standards-validator-mcp
```

### Permission errors

```bash
# Ensure read access to project files
ls -la

# Check volume mounts in docker-compose files
```

## File Organization

```
.mcp/
├── README.md                          # This file
├── ARCHITECTURE.md                    # System architecture
├── QUICKSTART.md                      # 30-second setup guide
├── SETUP.md                          # Detailed setup instructions
├── configs/                          # Configuration files
│   ├── gordon-mcp.yml                # Docker AI config
│   ├── docker-compose.mcp-gateway.yml # Gateway config
│   └── mcp-catalog.yaml              # Tool catalog
└── servers/                          # Custom MCP servers
    └── standards-validator/          # Validation server
        ├── Dockerfile
        ├── requirements.txt
        ├── server.py
        ├── validators/
        └── README.md
```

## Resources

- [MCP Protocol Specification](https://github.com/anthropics/mcp)
- [Docker MCP Documentation](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [Claude Desktop MCP Guide](https://docs.anthropic.com/claude/docs/model-context-protocol)
- [AI Whisperers Standards](../README.md)

## Next Steps

1. **Setup MCP**: Follow [QUICKSTART.md](QUICKSTART.md) for immediate setup
2. **Understand Architecture**: Read [ARCHITECTURE.md](ARCHITECTURE.md) for system design
3. **Detailed Setup**: See [SETUP.md](SETUP.md) for comprehensive configuration
4. **Customize Validator**: Modify `servers/standards-validator/` for project-specific needs

## Version

**Template Version:** 1.0.0
**Last Updated:** 2025-11-07
**Repository:** AI Whisperers Standards Template
