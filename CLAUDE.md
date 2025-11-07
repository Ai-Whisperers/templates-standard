# Claude Project Context - AI Whisperers Standards Repository

**Doc-Type:** Project Context · Version 1.0 · Updated 2025-11-07 · Author AI Whisperers

## Project Overview

This repository contains standardization templates and documentation for AI Whisperers company-wide development practices.

**Purpose:** Provide reusable templates, standards, and configurations that ensure consistency across all AI Whisperers projects while optimizing for both human comprehension and AI/LLM processing.

**Scope:** Covers data architecture, documentation formats, AI development workflows, testing stratification, and deployment patterns.

---

## Repository Structure

```
template-standard/
├── README.md                       # Main standards overview
├── CLAUDE.md                       # This file - project context
│
├── documentation-template/         # Documentation standards
│   ├── documentation-format.md     # Human + Toon dual-layer format
│   ├── neuroparsing-protocol.md    # Cognitive neuroscience principles
│   └── proportion-in-docs.md       # Human/Toon ratio guidelines
│
├── automation-system-template/     # Automation and AI integration
│   ├── automation.md               # .mcp and .claude orchestration
│   ├── integration-system.md       # Testing stratification layers
│   ├── ai-layer/                   # AI layer explanations
│   │   ├── README.md               # .claude vs .mcp comparison
│   │   └── example.md              # Hybrid folder layout
│   └── dot-folders-and-config-templates/
│       ├── README.md
│       ├── claude-and-ai-automation/
│       │   ├── .claude/            # Claude Code templates
│       │   └── .mcp/               # MCP server templates
│       ├── git-and-linting/
│       │   └── .github/            # GitHub workflows
│       └── vs-code dev container/
│           └── .devcontainer/      # Dev container config
│
├── .claude/                        # This repo's Claude config
│   ├── README.md
│   ├── settings.local.json
│   └── commands/
│       ├── validate-docs.md
│       ├── check-standards.md
│       └── format-doc.md
│
└── .mcp/                           # This repo's MCP config
    ├── README.md
    ├── QUICKSTART.md
    ├── SETUP.md
    ├── ARCHITECTURE.md
    ├── configs/
    │   ├── gordon-mcp.yml
    │   ├── docker-compose.mcp-gateway.yml
    │   └── mcp-catalog.yaml
    └── servers/
        └── standards-validator/    # Custom validation server (planned)
```

---

## Core Standards

### 1. Data & Architecture

**Format Stack:**
- Arrow (processing) + Parquet (storage) for structured data
- Polars for DataFrame operations (Arrow-native)
- JSON only for API headers, never for databases
- Toon format for LLM-optimized documentation (~22% token reduction)

**Deployment:**
- Docker containers for all services
- Kubernetes on-prem for orchestration
- Custom domains, avoid vendor lock-in

### 2. Documentation Standards

**Dual-Layer Format:**
- Human-oriented header: concise, natural language
- Toon-format body: structured for AI consumption
- Metadata line: `Doc-Type · Version · Updated · Author`

**Hierarchy Rules:**
- Maximum 3 heading levels (##, ###, ####)
- Deeper structures use bullets
- Section separators: `---`

**Cognitive Principles:**
- Short, symmetric lines (rhythmic)
- Temporal flow markers (→, ←, ↓)
- Micro-echoes for key concepts
- Visual cues where appropriate

**Documentation Ratios:**
| Document Type | Toon % | Human % |
|---------------|--------|---------|
| README/Overview | 0 | 100 |
| Setup Guides | 20-30 | 70-80 |
| API Specs | 85-95 | 5-15 |
| Config Templates | 95 | 5 |
| Pipelines | 75 | 25 |

### 3. AI Development Workflows

**.claude Folder:**
- Project-specific AI configuration
- Custom slash commands
- Permissions and hooks
- Environment variables
- Local personality layer

**.mcp Folder:**
- Model Context Protocol servers
- Cross-tool interoperability
- Standardized tool interfaces
- Service-level orchestration
- Ecosystem gateway

**Principle:** Minimal variation between .claude instances across repos (sufficient context, no drift)

### 4. Integration & Testing

**Stratification Layers:**
1. **Code Layer** - Static analysis, unit tests, mutation testing
2. **Bot Layer** - Dependency audits, coverage delta, regression estimation
3. **AI Layer** - Intent validation, semantic consistency, pseudo-QA
4. **QA Layer** - Integration, UX, edge cases, acceptance

**AI Assistants:**
- `.mcp` holds context manifests
- `.claude` holds reasoning templates
- Live evaluation during development

---

## Working with This Repository

### When Adding New Standards

1. **Document in main README.md**
   - Follow hierarchy limits
   - Use cognitive principles
   - Add metadata line

2. **Create templates**
   - Place in appropriate template folder
   - Ensure minimal variation from existing
   - Add examples

3. **Update validation**
   - Add checks to slash commands
   - Update MCP catalog if needed
   - Test with sample files

4. **Commit properly**
   - Pre-commit hooks will validate
   - Use descriptive commit messages
   - Reference related standards

### When Editing Documentation

**Before:**
- Read existing standards (documentation-template/)
- Understand Human/Toon ratio for doc type
- Check cognitive principles

**During:**
- Maintain hierarchy (≤3 levels)
- Add metadata line
- Use section separators
- Apply temporal flow markers

**After:**
- Run `/validate-docs [file]`
- Check git diff for unintended changes
- Commit with descriptive message

### When Updating Templates

**Consistency is critical:**
- Changes to templates should be intentional
- Run `/check-standards` before committing
- Ensure examples match documentation
- Update version numbers

**Minimal variation principle:**
- Templates should differ only in project-specific context
- Core structure must remain consistent
- Document any necessary variations

---

## Development Environment

### Prerequisites
- Docker Desktop (for MCP servers)
- Git
- Your preferred AI client (Claude Code, Docker AI, etc.)

### Setup
1. Clone repository
2. Copy `.mcp/configs/gordon-mcp.yml` to root (for Docker AI)
3. Or start MCP Gateway: `docker-compose -f docker-compose.mcp-gateway.yml up -d`
4. Claude automatically loads `.claude/` configuration

### Available Commands

**Slash Commands:**
- `/validate-docs [file]` - Check documentation compliance
- `/check-standards` - Validate template consistency
- `/format-doc <file> --type=<type>` - Format documentation file

**Docker AI Queries:**
- `docker ai "Validate README.md"`
- `docker ai "Check template consistency"`
- `docker ai "List files in documentation-template/"`

---

## Key Principles

### 1. Build Once, Scale Infinitely
Front-load complexity (Arrow/Parquet/Polars) so scaling never breaks. Every byte stays structure-aware.

### 2. Complexity Paid Once, Simplicity Forever
Invest in proper architecture upfront. Automation, elasticity, and AI alignment compound over time.

### 3. AI is the Infrastructure
Our AI *is* the infrastructure. Documentation and code are optimized for both human and machine consumption.

### 4. Structure Scales Itself
Arrow-native architecture + schema permanence = systems that scale by design, not by accident.

### 5. Precision and Empathy Are Sequential
Documentation serves humans first (clarity, empathy) then machines (precision, structure). Both phases are essential.

---

## Context for AI Assistants

**When helping with this repository:**

✅ **DO:**
- Validate documentation against standards
- Maintain hierarchy limits (≤3 levels)
- Preserve cognitive principles
- Check Human/Toon ratios
- Ensure template consistency
- Follow minimal variation principle
- Add metadata lines to new docs
- Use section separators

❌ **DON'T:**
- Create over-nested headings (>3 levels)
- Skip metadata lines
- Ignore cognitive principles
- Change template structure without reason
- Mix documentation ratios inappropriately
- Remove micro-echoes or temporal markers

**Quality Checks:**
- Every new .md file needs metadata line
- Hierarchy never exceeds 3 levels
- Section separators (---) between major sections
- README files: 100% human-oriented
- API specs: 75-95% Toon format
- Templates: minimal variation, maximum consistency

---

## Resources

**Internal:**
- [Main README](README.md) - Standards overview
- [Documentation Format](documentation-template/documentation-format.md)
- [Neuroparsing Protocol](documentation-template/neuroparsing-protocol.md)
- [Automation System](automation-system-template/automation.md)
- [.claude README](.claude/README.md)
- [.mcp README](.mcp/README.md)

**External:**
- [Toon Format Repo](https://github.com/toon-format/toon)
- [Arrow Documentation](https://arrow.apache.org/docs/)
- [MCP Protocol](https://github.com/anthropics/mcp)
- [Docker MCP Guide](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)

---

## Project Metadata

**Repository:** template-standard
**Organization:** AI Whisperers
**Type:** Standardization Templates
**Primary Language:** Markdown (documentation), Python/JavaScript (examples)
**License:** Internal Use
**Maintainers:** AI Whisperers Team
**Last Updated:** 2025-11-07
**Version:** 1.0.0

---

**Ready to work?** Use `/validate-docs` and `/check-standards` to ensure compliance.
