# Claude Code Configuration - AI Whisperers Standards

This directory contains Claude Code settings and customizations for the AI Whisperers standardization template repository.

## Project Context

This repository defines company-wide standards for:
- Data formats and architecture (Arrow/Parquet)
- Documentation protocols (Human + Toon format)
- AI development workflows (.claude + .mcp integration)
- Testing and QA stratification
- Deployment and infrastructure patterns

## Quick Start

1. Claude will automatically load this configuration when working in this repository
2. Use custom slash commands to validate and maintain standards
3. Hooks ensure documentation consistency before commits

## Custom Slash Commands

### `/validate-docs`
Check documentation files against AI Whisperers standards:
- Human-oriented header structure
- Toon format compliance
- Documentation ratio validation
- Neuroparsing protocol adherence

### `/check-standards`
Validate template consistency:
- Compare .claude/.mcp templates across folders
- Ensure examples match documentation
- Check for missing files

### `/format-doc`
Format a documentation file according to standards:
- Add proper headers with metadata
- Structure with correct hierarchy (≤3 levels)
- Apply cognitive rhythm principles

## What's Configured

### 1. Permissions

**Allowed Operations:**
- Read all template files and documentation
- Git operations (status, diff, log, add, commit, push)
- File operations for documentation maintenance
- Bash scripts for validation

**Denied Operations:**
- No destructive operations on template files
- Protected documentation originals

**Ask for Confirmation:**
- Changes to core README.md files
- Modifications to template standards

### 2. Hooks

**PreToolUse:**
- Before commits: validate documentation formatting
- Before template edits: check consistency

**PostToolUse:**
- After documentation edits: remind to validate
- After template changes: suggest validation

**SessionStart:**
- Display current project context
- Show recent changes to standards

### 3. Environment Variables

Project-specific environment:
```json
{
  "PROJECT_NAME": "AI Whisperers Standards",
  "DOC_RATIO_CHECK": "enabled",
  "TOON_FORMAT_VALIDATION": "enabled"
}
```

## File Structure

```
.claude/
├── README.md                    # This file
├── settings.local.json          # Permissions, hooks, env vars
└── commands/                    # Custom slash commands
    ├── validate-docs.md        # /validate-docs command
    ├── check-standards.md      # /check-standards command
    └── format-doc.md           # /format-doc command
```

## Working with This Repository

### Documentation Standards

When creating or editing documentation:

1. **Always include metadata line:**
   ```
   Doc-Type: [Type] · Version [X.Y] · Updated [YYYY-MM-DD] · Author AI Whisperers
   ```

2. **Follow hierarchy limits:**
   - Maximum 3 heading levels (##, ###, ####)
   - Use bullets for deeper nesting

3. **Apply cognitive principles:**
   - Short, symmetric lines
   - Clear temporal flow
   - Micro-echoes for key concepts

4. **Balance human/Toon ratio:**
   - Use Documentation Ratio Protocol
   - README files: 100% Human
   - API/Schema docs: 75-90% Toon
   - Guides: 20-30% Toon

### Template Maintenance

When updating templates:

1. **Maintain consistency:**
   - Changes to one template should propagate to examples
   - Keep minimal variation between .claude folders
   - Preserve context sufficiency

2. **Version control:**
   - Update version numbers in template files
   - Document changes in commit messages
   - Use hooks to validate before committing

3. **Cross-reference:**
   - Ensure documentation matches template structure
   - Update examples when standards change
   - Keep automation.md synchronized with template folders

## Best Practices

1. **Before committing changes:**
   - Run `/validate-docs` on modified files
   - Run `/check-standards` to ensure consistency
   - Review git diff for unintended changes

2. **When adding new standards:**
   - Document in main README.md
   - Create templates in appropriate folders
   - Add validation to slash commands
   - Update this configuration if needed

3. **Documentation workflow:**
   - Draft human-oriented header first
   - Add Toon-format body for structured content
   - Validate ratio and formatting
   - Commit with descriptive message

## Integration with .mcp

This `.claude` configuration works alongside `.mcp` for:

- **Local context:** `.claude` provides project-specific guidance
- **Tool interface:** `.mcp` exposes validation tools to any AI client
- **Hybrid intelligence:** Both enable comprehensive standards maintenance

See `.mcp/README.md` for MCP server setup and capabilities.

## Customization Notes

This configuration is tailored for the standards repository. When using these templates in other projects:

1. Copy template structure from `john-ivan-config-templates/` or `automation-practical-guide/`
2. Customize for specific project context
3. Maintain minimal variation (as per automation.md principle)
4. Keep sufficient context without drift

## Version

**Template Version:** 1.0.0
**Last Updated:** 2025-11-07
**Applies To:** AI Whisperers Standards Repository
