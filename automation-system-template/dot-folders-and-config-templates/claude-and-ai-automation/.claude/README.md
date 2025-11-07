# Claude Code Configuration Template

This directory contains Claude Code settings and customizations for your project.

## Quick Start

1. Copy this template to your project root as `.claude/`
2. Customize `settings.local.json` for your project:
   - Update environment variables
   - Add project-specific permissions
   - Configure hooks for your workflow
3. Create custom slash commands in `commands/`
4. Add project context in `CLAUDE.md` (in project root)

## What's Configured

### 1. Custom Slash Commands ([commands/](commands/))

Quick-access commands for common workflows. Examples:

- `/run-tests` - Run test suite
- `/check-org` - Validate repository organization
- `/debug` - Run debugging workflow

Create new commands by adding markdown files in `commands/`.

### 2. Permissions ([settings.local.json](settings.local.json))

#### Allowed Operations

Claude can automatically execute these without asking:

- **Git operations**: status, diff, log, add, commit, push
- **Python/Testing**: pytest, python scripts
- **Package management**: pip, npm (read-only)
- **File operations**: ls, cat, mkdir, mv, cp, find
- **Docker**: docker, docker-compose commands
- **Development scripts**: bash scripts/

#### Denied Operations

Claude is blocked from accessing sensitive files:

- `.env` and `.env.*` files
- Credential files (AWS, SSH keys)
- Destructive operations (rm -rf /, force push)

#### Ask for Confirmation

These operations require user approval:

- Package installation (pip install, npm install)
- Destructive git operations (reset --hard, rebase)
- Docker cleanup (down -v, prune)

### 3. Hooks ([settings.local.json](settings.local.json))

Automatically run commands at specific events:

- **PreToolUse**: Before tool execution (e.g., pre-commit checks)
- **PostToolUse**: After tool completion (e.g., test reminders)
- **SessionStart**: When session begins (e.g., show project context)
- **SessionEnd**: When session ends (e.g., check uncommitted changes)

### 4. Environment Variables

Project-specific environment variables:

```json
{
  "env": {
    "PYTHONPATH": ".:./api",
    "APP_ENV": "development"
  }
}
```

## File Structure

```
.claude/
├── README.md                    # This file
├── settings.local.json          # Permissions, hooks, env vars (git-ignored)
└── commands/                    # Custom slash commands
    ├── run-tests.md            # /run-tests command
    ├── debug.md                # /debug command
    └── check-org.md            # /check-org command
```

## Adding New Commands

1. Create a markdown file in `commands/`:

   ```bash
   touch .claude/commands/my-command.md
   ```

2. Add frontmatter and content:

   ```markdown
   ---
   description: Brief description of what this command does
   model: sonnet # Optional: specify model
   ---

   # Command Title

   For bash commands, prefix with `!`:
   !bash scripts/my-script.sh

   For prompts with arguments, use $1, $2:
   Analyze the file at $1 and generate report.
   ```

3. Use the command:
   ```
   /my-command arg1 arg2
   ```

## Customization Checklist

- [ ] Update environment variables in `settings.local.json`
- [ ] Customize session start message with project name
- [ ] Add project-specific slash commands
- [ ] Configure pre-commit hooks for your workflow
- [ ] Update permission patterns for your tools
- [ ] Create `CLAUDE.md` in project root with project context
- [ ] Add `.claude/settings.local.json` to `.gitignore`

## Best Practices

1. **Keep `settings.local.json` private**: Never commit with secrets
2. **Use `settings.json` for team settings**: Create `.claude/settings.json` for team-shared config
3. **Document commands**: Add clear descriptions to slash commands
4. **Test hooks**: Hooks can block operations if they fail
5. **Use matchers**: Target hooks to specific operations with matchers
6. **Set timeouts**: Always set reasonable timeouts for hooks

## Additional Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)
- [Settings Reference](https://docs.claude.com/en/docs/claude-code/settings)
- [Slash Commands Guide](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Hooks Reference](https://docs.claude.com/en/docs/claude-code/hooks)

## Version

**Template Version:** 1.0.0
**Last Updated:** 2025-11-07
