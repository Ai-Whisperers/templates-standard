# MCP Quick Start - AI Whisperers Standards

Fast setup guide for getting MCP servers running for standards validation.

## Prerequisites Check

- [ ] Docker Desktop installed and running
- [ ] Project cloned locally
- [ ] Terminal/command prompt access

## 30-Second Setup (Docker AI)

```bash
# 1. Navigate to project root
cd "C:/Users/Gestalt/Desktop/standards in ai whisperers/template-standard"

# 2. Ensure gordon-mcp.yml exists in root
cp .mcp/configs/gordon-mcp.yml ./

# 3. Pull built-in servers
docker pull mcp/filesystem

# 4. Test it!
docker ai "List all markdown files in the project"
```

## 2-Minute Setup (MCP Gateway)

```bash
# 1. Copy gateway config to root
cp .mcp/configs/docker-compose.mcp-gateway.yml ./

# 2. Build and start all services
docker-compose -f docker-compose.mcp-gateway.yml up -d --build

# 3. Verify running
docker-compose -f docker-compose.mcp-gateway.yml ps

# 4. Test connection
curl http://localhost:8080/health
```

## Quick Test Commands

### Documentation Validation

```bash
# Check main README
docker ai "Validate the main README.md against AI Whisperers standards"

# Analyze documentation structure
docker ai "Check the hierarchy structure in documentation-template/documentation-format.md"

# Verify documentation ratio
docker ai "Analyze the Human/Toon ratio in all documentation files"
```

### Template Validation

```bash
# Check template consistency
docker ai "Compare .claude folders across automation-system-template/"

# Find template differences
docker ai "What are the differences between .claude templates?"

# Validate completeness
docker ai "Are all required files present in the .mcp template?"
```

### File Discovery

```bash
# Find documentation
docker ai "List all markdown files in documentation-template/"

# Find configuration files
docker ai "Show all JSON files in .claude folders"

# Search for specific content
docker ai "Find files mentioning 'Toon format'"
```

## Common Issues

### Docker Desktop not running

```bash
# Windows: Start from Start menu
"C:\Program Files\Docker\Docker\Docker Desktop.exe"

# macOS: Start from Applications
open -a Docker

# Linux: Start service
sudo systemctl start docker
```

### Configuration file missing

```bash
# Copy gordon config
cp .mcp/configs/gordon-mcp.yml ./gordon-mcp.yml

# Copy gateway config
cp .mcp/configs/docker-compose.mcp-gateway.yml ./docker-compose.mcp-gateway.yml
```

### Build fails

```bash
# Clean rebuild of validator
docker-compose -f docker-compose.mcp-gateway.yml build standards-validator --no-cache

# Check logs
docker-compose -f docker-compose.mcp-gateway.yml logs standards-validator
```

### Permission errors

```bash
# Check file permissions
ls -la .mcp/

# Fix permissions (if needed)
chmod -R 755 .mcp/
```

### Gateway won't start

```bash
# View detailed logs
docker-compose -f docker-compose.mcp-gateway.yml logs

# Restart fresh
docker-compose -f docker-compose.mcp-gateway.yml down
docker-compose -f docker-compose.mcp-gateway.yml up -d --build
```

## Tool Summary

### Built-in Tools

| Tool | Purpose | Example |
|------|---------|---------|
| **filesystem** | Read project files | "Show README.md contents" |

### Custom Validator Tools

| Tool | Purpose | Example |
|------|---------|---------|
| **validate_documentation** | Check standards compliance | "Validate README.md structure" |
| **check_doc_ratio** | Analyze Human/Toon ratio | "Check ratio in api-spec.md" |
| **validate_hierarchy** | Check heading levels | "Validate hierarchy in guide.md" |
| **check_template_consistency** | Compare templates | "Check .claude consistency" |
| **validate_toon_format** | Verify Toon syntax | "Validate Toon in config.toon" |
| **analyze_cognitive_flow** | Readability analysis | "Analyze flow in docs" |

## Example Workflows

### 1. Validate New Documentation

```bash
# Create new doc
touch documentation-template/new-guide.md

# Ask AI to format it
docker ai "Format documentation-template/new-guide.md according to AI Whisperers standards for a setup guide"

# Validate result
docker ai "Validate documentation-template/new-guide.md"
```

### 2. Update Template

```bash
# Modify template
# (make changes to .claude/settings.local.json)

# Check consistency
docker ai "Check if my .claude template is consistent with the standard template"

# Validate changes
docker ai "List any inconsistencies in the updated .claude configuration"
```

### 3. Pre-Commit Check

```bash
# Check modified files
git diff --name-only | grep .md > changed_docs.txt

# Validate each
docker ai "Validate all files in changed_docs.txt"
```

### 4. Generate Report

```bash
# Full repository validation
docker ai "Generate a compliance report for all documentation in this repository"

# Template analysis
docker ai "Create a summary of template structures across all folders"
```

## Next Steps

- **Full Documentation**: [README.md](README.md) for complete MCP overview
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md) for system design
- **Detailed Setup**: [SETUP.md](SETUP.md) for advanced configuration
- **Customize Validator**: Modify `servers/standards-validator/` for specific needs

## Verification Checklist

After setup, verify everything works:

- [ ] `docker ps` shows running containers
- [ ] `docker ai "List files"` returns file list
- [ ] Validation commands return structured reports
- [ ] No permission errors in logs
- [ ] Gateway responds at http://localhost:8080 (if using gateway)

## Getting Help

If stuck:

1. Check [SETUP.md](SETUP.md) for detailed troubleshooting
2. View logs: `docker-compose -f docker-compose.mcp-gateway.yml logs`
3. Restart services: `docker-compose -f docker-compose.mcp-gateway.yml restart`
4. Rebuild: `docker-compose -f docker-compose.mcp-gateway.yml up -d --build`

---

**Ready to dive deeper?** Continue to [ARCHITECTURE.md](ARCHITECTURE.md) to understand the system design.
