---
description: Run comprehensive debugging workflow with checks
model: sonnet
---

# Debugging Workflow

Execute systematic debugging checks to identify and resolve issues.

## Debugging Steps:

1. **Syntax Check** - Verify code syntax
2. **Import Check** - Test all imports
3. **Type Check** - Run type checker (mypy, pyright, etc.)
4. **Unit Tests** - Execute test suite
5. **Integration Tests** - Check component integration
6. **Log Review** - Check recent error logs

## Execution:

!PYTHONPATH=".:$PYTHONPATH" timeout 120 python -m pytest -v --tb=short

## Common Issues to Check:

- `ModuleNotFoundError` - PYTHONPATH issues
- `ConnectionRefusedError` - Service not running (Redis, DB, etc.)
- `ImportError` - Missing dependencies
- `AttributeError` - API changes
- `TypeError` - Type mismatches

## Quick Fixes:

**Dependency Issues:**
```bash
pip install -r requirements.txt
```

**Service Issues:**
```bash
docker-compose up -d
```

## Log Locations:

- Application logs: `logs/` or `app/logs/`
- Test logs: `tests/results/`
- Service logs: Check docker-compose logs

# CUSTOMIZATION NOTES:
# - Update log locations for your project
# - Add project-specific debugging steps
# - Include common error patterns specific to your stack
# - Add service startup commands (Redis, PostgreSQL, etc.)
