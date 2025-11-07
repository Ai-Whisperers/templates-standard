# MCP Architecture - AI Whisperers Standards Repository

Visual guide to understand how MCP servers integrate with the AI Whisperers standardization system.

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AI Clients                                │
│  • Docker AI (Gordon)                                            │
│  • Claude Desktop                                                │
│  • Cursor IDE                                                    │
│  • VSCode with Continue.dev                                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ MCP Protocol
                         │ (stdio or SSE)
                         │
        ┌────────────────┴───────────────┐
        │                                │
        ▼                                ▼
┌───────────────┐              ┌──────────────────┐
│  gordon-mcp   │              │  MCP Gateway     │
│  (Docker AI)  │              │  (Port 8080)     │
└───────┬───────┘              └────────┬─────────┘
        │                               │
        │ Docker Compose                │ Docker Network
        │                               │ (mcp-network)
        └───────────┬───────────────────┘
                    │
        ┌───────────┴──────────────────────────────────┐
        │                                              │
        ▼                                              ▼
┌─────────────────┐                         ┌──────────────────────┐
│  Built-in MCP   │                         │  Custom MCP Server   │
│    Server       │                         │  standards-validator │
│                 │                         │                      │
│ • filesystem    │                         │ Tools:               │
│                 │                         │ • validate_doc       │
└────────┬────────┘                         │ • check_ratio        │
         │                                  │ • validate_hierarchy │
         │ Read-only access                 │ • check_templates    │
         │                                  │ • validate_toon      │
         │                                  │ • analyze_flow       │
         │                                  └──────────┬───────────┘
         │                                             │
         │                                             │ Validates
         │                                             │
         ▼                                             ▼
┌─────────────────────────────────────────────────────────────────┐
│         AI Whisperers Standards Repository                      │
│                                                                  │
│  ├── README.md               (Main standards overview)          │
│  ├── documentation-template/ (Doc format standards)             │
│  ├── automation-system-template/ (System templates)             │
│  │   └── dot-folders-and-config-templates/                     │
│  │       ├── .claude/       (Claude config templates)           │
│  │       └── .mcp/          (MCP config templates)              │
│  ├── .claude/               (This repo's Claude config)         │
│  └── .mcp/                  (This repo's MCP config)            │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow: Documentation Validation Example

```
User Query: "Validate README.md against AI Whisperers standards"
    │
    ├─► 1. AI Client → MCP Gateway (or Docker AI)
    │
    ├─► 2. Gateway routes to appropriate servers:
    │      ├─► filesystem server → reads README.md
    │      └─► standards-validator → validates structure
    │
    ├─► 3. standards-validator:
    │      ├─► Check header structure (metadata line)
    │      ├─► Validate hierarchy (≤3 levels)
    │      ├─► Analyze cognitive flow
    │      ├─► Check documentation ratio
    │      └─► Return compliance report
    │
    └─► 4. Results returned to user through AI client
```

## MCP Server Communication

### Stdio Transport (Docker AI)

```
Docker AI
    ↓ stdin/stdout
    ↓
MCP Server (Container)
    ↓ Tool calls
    ↓
Validation Logic
```

### SSE Transport (MCP Gateway)

```
AI Client
    ↓ HTTP/SSE (Port 8080)
    ↓
MCP Gateway
    ↓ Docker network
    ↓
MCP Servers (Containers)
    ↓ Tool calls
    ↓
Validation Logic
```

## Security Boundaries

```
┌─────────────────────────────────────────────────────────┐
│                    Security Zones                       │
│                                                         │
│  ┌─────────────────────────────────────────────────┐  │
│  │  Filesystem Server (Read-Only)                  │  │
│  │  • Can: Read project files                      │  │
│  │  • Cannot: Write, execute, delete               │  │
│  │  • Restricted: .md, .json, .yml, .yaml only     │  │
│  │  • Excluded: .git/, .env, credentials           │  │
│  └─────────────────────────────────────────────────┘  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐  │
│  │  Standards Validator (Analysis Only)            │  │
│  │  • Can: Read files, analyze structure           │  │
│  │  • Can: Generate reports and recommendations    │  │
│  │  • Cannot: Modify files, execute code           │  │
│  │  • Cannot: Access external networks             │  │
│  └─────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Configuration Flow

```
Source of Truth: .mcp/configs/
    │
    ├─► gordon-mcp.yml
    ├─► docker-compose.mcp-gateway.yml
    └─► mcp-catalog.yaml
    │
    ├─► Copied to project root (for Docker compatibility)
    │
    └─► Loaded by Docker AI or MCP Gateway
```

## Standards Validator Architecture

```
┌────────────────────────────────────────────────────────┐
│         standards-validator MCP Server                 │
│                                                        │
│  ┌──────────────────────────────────────────────┐    │
│  │  MCP Server Framework                        │    │
│  │  • list_tools() - Advertise capabilities    │    │
│  │  • call_tool() - Route tool requests         │    │
│  └─────────────────┬────────────────────────────┘    │
│                    │                                  │
│  ┌─────────────────┴────────────────────────────┐    │
│  │  Validation Tools                            │    │
│  │                                              │    │
│  │  ├─ validate_documentation_impl()           │    │
│  │  ├─ check_doc_ratio_impl()                  │    │
│  │  ├─ validate_hierarchy_impl()               │    │
│  │  ├─ check_template_consistency_impl()       │    │
│  │  ├─ validate_toon_format_impl()             │    │
│  │  └─ analyze_cognitive_flow_impl()           │    │
│  └─────────────────┬────────────────────────────┘    │
│                    │                                  │
│  ┌─────────────────┴────────────────────────────┐    │
│  │  Validation Modules                          │    │
│  │  • doc_structure.py - Structure checks       │    │
│  │  • toon_format.py - Toon syntax validation   │    │
│  │  • cognitive_flow.py - Readability metrics   │    │
│  │  • template_check.py - Template comparison   │    │
│  └──────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────┘
```

## Deployment Models

### Model 1: Docker AI (Development)

```
Developer Workflow:
    │
    ├─► 1. Edit documentation or templates
    │
    ├─► 2. Ask Docker AI questions:
    │      "Validate my changes"
    │      "Check template consistency"
    │
    ├─► 3. Docker AI auto-starts MCP servers
    │      (from gordon-mcp.yml)
    │
    └─► 4. Get instant validation results
```

**Pros:**
- Zero configuration
- Auto-detects gordon-mcp.yml
- Perfect for quick validation
- No persistent services

**Cons:**
- Only works with Docker AI
- Servers restart each time
- No multi-client support

### Model 2: MCP Gateway (CI/CD & Team)

```
Team Workflow:
    │
    ├─► 1. Start MCP Gateway once:
    │      docker-compose -f docker-compose.mcp-gateway.yml up -d
    │
    ├─► 2. Multiple team members + CI connect:
    │      • Claude Desktop
    │      • Cursor IDE
    │      • VSCode
    │      • GitHub Actions
    │
    ├─► 3. Persistent service runs 24/7
    │
    └─► 4. All clients share validation tools
```

**Pros:**
- Multiple AI clients
- Persistent connections
- CI/CD integration
- Centralized validation

**Cons:**
- Manual startup required
- More resource intensive
- Requires per-client configuration

## File Organization

```
Project Root
├── gordon-mcp.yml                  (Active - Docker AI)
├── docker-compose.mcp-gateway.yml  (Active - Gateway)
│
├── .claude/                        (Claude configuration)
│   ├── README.md
│   ├── settings.local.json
│   └── commands/
│
└── .mcp/                           (MCP source)
    ├── README.md                   (Overview)
    ├── SETUP.md                    (Detailed setup)
    ├── QUICKSTART.md               (Fast setup)
    ├── ARCHITECTURE.md             (This file)
    │
    ├── configs/                    (Config templates)
    │   ├── gordon-mcp.yml
    │   ├── docker-compose.mcp-gateway.yml
    │   └── mcp-catalog.yaml
    │
    └── servers/                    (Custom servers)
        └── standards-validator/
            ├── Dockerfile
            ├── requirements.txt
            ├── server.py
            ├── validators/
            └── README.md
```

## Tool Capability Matrix

| Tool | Read Files | Validate Docs | Check Templates | Analyze Ratio | Toon Format |
|------|------------|---------------|-----------------|---------------|-------------|
| **filesystem** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **standards-validator** | ✅ | ✅ | ✅ | ✅ | ✅ |

## Validation Workflow

```
┌─────────────────────────────────────────────────────────┐
│ 1. Developer edits documentation                        │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│ 2. AI client calls validate_documentation tool          │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│ 3. standards-validator reads file via filesystem server │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│ 4. Run validation modules:                              │
│    ├─ Check metadata header                             │
│    ├─ Validate hierarchy (≤3 levels)                    │
│    ├─ Analyze cognitive flow                            │
│    ├─ Check documentation ratio                         │
│    └─ Verify Toon format (if applicable)                │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│ 5. Generate compliance report                           │
│    • Passed checks ✅                                    │
│    • Warnings ⚠️                                         │
│    • Failed checks ❌                                    │
│    • Recommendations 💡                                  │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│ 6. Return results to AI client                          │
└─────────────────────────────────────────────────────────┘
```

## Performance Characteristics

### Built-in Servers
- **Startup:** < 1 second
- **Memory:** ~20 MB
- **Latency:** < 10 ms (local file reads)

### Standards Validator
- **Startup:** ~2-3 seconds (Python + dependencies)
- **Memory:** ~50-100 MB
- **Latency:**
  - Single file validation: 50-200 ms
  - Template comparison: 200-500 ms
  - Full repository scan: 1-3 seconds

## Integration Points

### With .claude Configuration

```
.claude/settings.local.json hooks
    │
    ├─► PreToolUse(git commit)
    │   └─► Call MCP validate_documentation
    │
    └─► PostToolUse(Edit *.md)
        └─► Remind to run validation
```

### With CI/CD

```yaml
# GitHub Actions example
- name: Validate Documentation
  run: |
    docker-compose -f docker-compose.mcp-gateway.yml up -d
    docker ai "Validate all modified .md files"
    docker-compose -f docker-compose.mcp-gateway.yml down
```

### With Pre-commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit
docker ai "Validate staged .md files" || exit 1
```

## Extensibility

### Adding New Validation Rules

```python
# In .mcp/servers/standards-validator/validators/custom_rule.py
def validate_custom_rule(content: str) -> dict:
    """Add your custom validation logic"""
    return {
        "passed": True,
        "message": "Custom validation passed"
    }
```

### Adding New Tools

```python
# In .mcp/servers/standards-validator/server.py
@app.call_tool()
async def your_new_tool_impl(args: Dict[str, Any]) -> Dict[str, Any]:
    # Your implementation
    return {"result": "..."}
```

## Monitoring and Observability

### View Logs

```bash
# All services
docker-compose -f docker-compose.mcp-gateway.yml logs -f

# Specific server
docker logs standards-validator-mcp -f

# Last 100 lines
docker logs --tail=100 standards-validator-mcp
```

### Health Checks

```bash
# Check running containers
docker-compose -f docker-compose.mcp-gateway.yml ps

# Gateway health
curl http://localhost:8080/health

# Resource usage
docker stats standards-validator-mcp
```

## Troubleshooting Decision Tree

```
Issue: Validation not working
    │
    ├─► Is Docker Desktop running?
    │   ├─ No → Start Docker Desktop
    │   └─ Yes → Continue
    │
    ├─► Using Docker AI or Gateway?
    │   ├─ Docker AI → Is gordon-mcp.yml in root?
    │   │             └─ No → Copy from .mcp/configs/
    │   └─ Gateway → Is gateway container running?
    │                └─ No → docker-compose up -d
    │
    ├─► Are containers built?
    │   └─ No → docker-compose build standards-validator
    │
    └─► Check logs for errors
        └─ docker logs standards-validator-mcp
```

## Resources

- [MCP Protocol Spec](https://github.com/anthropics/mcp)
- [Docker MCP Docs](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
- [Quick Start](QUICKSTART.md)
- [Setup Guide](SETUP.md)

---

**Need detailed setup?** Continue to [SETUP.md](SETUP.md)
