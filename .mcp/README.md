# MCP Configuration - AI Whisperers Standards Repository

**Doc-Type:** Configuration Guide · Version 1.0 · Updated 2025-11-08 · Author AI Whisperers

Model Context Protocol (MCP) server configurations → AI agents interact with and validate AI Whisperers standardization templates

---

## What is MCP?

MCP standardizes how AI applications interact with external tools and data sources.

**Benefits:**
- Cross-model validation → any AI client validates documentation standards
- Automated checking → CI/CD integration for standards compliance
- Tool exposure → share validation tools across environments

---

## Quick Start

**Docker AI (Gordon) - Simplest:**
```bash
docker pull mcp/filesystem && docker pull mcp/fetch
docker ai "List all markdown files in documentation-template/"
docker ai "Validate the main README.md structure"
```

**MCP Gateway - Full Featured:**
```bash
docker-compose -f docker-compose.mcp-gateway.yml up -d --build
docker-compose -f docker-compose.mcp-gateway.yml ps  # Verify
# Connect AI clients to http://localhost:8080
```

---

## Available MCP Servers

| Server | Image | Capabilities | Security |
|--------|-------|--------------|----------|
| **Filesystem** | `mcp/filesystem` | Read templates, list directories, search docs | Read-only, restricted to project, allowed: .md/.json/.yml/.yaml/.py/.js/.ts |
| **Standards Validator** | Custom build | Validate docs, check ratios, analyze hierarchy | Local only, no external calls, non-destructive |

**Validator Tools:**

| Tool | Purpose | Example |
|------|---------|---------|
| `validate_documentation` | Check doc compliance | "Validate README.md" |
| `check_doc_ratio` | Analyze Human/Toon ratio | "Check ratio in api-spec.md" |
| `validate_hierarchy` | Check heading structure (≤3 levels) | "Validate hierarchy in guide.md" |
| `check_template_consistency` | Compare templates | "Check .claude template consistency" |
| `validate_toon_format` | Verify Toon syntax | "Validate Toon in config.md" |
| `analyze_cognitive_flow` | Check readability | "Analyze flow in docs.md" |

---

## Configuration Files

**gordon-mcp.yml** (Docker AI auto-detected):
```yaml
version: "3.8"
services:
  filesystem:
    image: mcp/filesystem
    volumes: [".:/data:ro"]
    environment: {ALLOWED_PATHS: "/data", ALLOWED_EXTENSIONS: ".md,.json,.yml,.yaml,.py,.js,.ts"}
  standards-validator:
    build: {context: ".mcp/servers/standards-validator"}
    volumes: [".:/workspace:ro"]
    environment: {PROJECT_TYPE: "standardization-template"}
```

**docker-compose.mcp-gateway.yml** (Full MCP Gateway):
```yaml
version: "3.8"
services:
  mcp-gateway:
    image: docker/mcp-gateway
    ports: ["8080:8080"]
    volumes: ["./configs:/configs"]
    networks: [mcp-network]
  filesystem:
    image: mcp/filesystem
    volumes: [".:/data:ro"]
    environment: {ALLOWED_PATHS: "/data"}
    networks: [mcp-network]
  standards-validator:
    build: {context: ".mcp/servers/standards-validator"}
    volumes: [".:/workspace:ro"]
    environment: {PROJECT_TYPE: "standardization-template"}
    networks: [mcp-network]
networks:
  mcp-network: {driver: bridge}
```

---

## AI Client Integration

**Claude Desktop** (`%APPDATA%\Claude\claude_desktop_config.json`):
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

**Docker AI** (auto-detects `gordon-mcp.yml`):
```bash
docker ai "Validate all documentation in documentation-template/"
docker ai "Check template consistency across automation-system-template/"
docker ai "Analyze documentation ratio in README.md"
```

**Cursor / VSCode** (MCP extension settings):
```json
{
  "mcp.servers": [
    {"name": "AI Whisperers Standards", "url": "http://localhost:8080"}
  ]
}
```

---

## Standards Validator Server

```
standards-validator/
├── Dockerfile                  # Container definition
├── requirements.txt            # Python dependencies
├── server.py                   # MCP server implementation
├── validators/                 # Validation modules
│   ├── doc_structure.py        # Doc structure validation
│   ├── toon_format.py          # Toon format validation
│   ├── cognitive_flow.py       # Readability analysis
│   └── template_check.py       # Template consistency
└── README.md                   # Server documentation
```

**Tool Examples:**
```python
# validate_documentation
{"file_path": "README.md", "strict": true, "check_ratio": true}
# → compliance report with passed/failed checks

# check_doc_ratio
{"file_path": "docs/api-spec.md", "expected_type": "api"}
# → Human/Toon ratio analysis + recommendations

# check_template_consistency
{"template_path": "automation-system-template/dot-folders/"}
# → consistency report across templates
```

---

## Security

| Aspect | Policy |
|--------|--------|
| **Filesystem** | Read-only, project directory only, excludes .git/.env/secrets |
| **Network** | Local only, no external API calls, no credentials required |
| **Operations** | Non-destructive, no file modifications, reports only |

---

## Use Cases

| Use Case | Command |
|----------|---------|
| **Pre-commit validation** | `docker ai "Validate all modified .md files for standards compliance"` |
| **PR review** | `docker ai "Check if new documentation follows AI Whisperers standards"` |
| **Template maintenance** | `docker ai "Compare .claude templates across all folders"` |
| **Batch validation** | `docker ai "Generate compliance report for all documentation"` |

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| **Docker AI doesn't detect config** | `cp .mcp/configs/gordon-mcp.yml ./` → restart Docker Desktop |
| **MCP Gateway connection refused** | `docker-compose -f docker-compose.mcp-gateway.yml ps` → check logs → restart |
| **Validator build fails** | `docker-compose build standards-validator --no-cache` |
| **Permission errors** | Check `ls -la` → verify volume mounts in docker-compose |

---

## File Organization

```
.mcp/
├── README.md                          # This file
├── ARCHITECTURE.md                    # System architecture
├── QUICKSTART.md                      # 30-second setup
├── SETUP.md                          # Detailed setup instructions
├── configs/
│   ├── gordon-mcp.yml                # Docker AI config
│   ├── docker-compose.mcp-gateway.yml # Gateway config
│   └── mcp-catalog.yaml              # Tool catalog
└── servers/standards-validator/      # Custom validation server
    ├── Dockerfile  ├── requirements.txt  ├── server.py
    ├── validators/ └── README.md
```

---

## Resources

**External:**
- [MCP Protocol](https://github.com/anthropics/mcp)
- [Docker MCP Docs](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [Claude Desktop MCP](https://docs.anthropic.com/claude/docs/model-context-protocol)

**Internal:**
- [AI Whisperers Standards](../README.md)
- [QUICKSTART](QUICKSTART.md) - Immediate setup
- [ARCHITECTURE](ARCHITECTURE.md) - System design
- [SETUP](SETUP.md) - Comprehensive configuration

---

**Version:** 1.0.0 · **Updated:** 2025-11-08 · **Repository:** AI Whisperers Standards Template
