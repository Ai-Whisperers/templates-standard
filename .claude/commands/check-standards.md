---
description: Validate template consistency across the repository
---

# Check Standards Consistency

Ensure consistency across all template folders and validate that examples match documentation.

## What This Checks

1. **Template Consistency**
   - Compare .claude folders across template directories
   - Verify .mcp folder structures match standards
   - Check minimal variation principle is maintained

2. **Documentation Alignment**
   - Examples in documentation match actual template files
   - File paths referenced in docs exist
   - Version numbers are synchronized

3. **Completeness**
   - All required files present in templates
   - No orphaned references
   - Cross-references are valid

4. **Format Compliance**
   - JSON files are valid
   - YAML files parse correctly
   - Markdown files follow standards

## Usage

```
/check-standards [--verbose]
```

**Options:**
- `--verbose` - Show detailed comparison output

## Validation Steps

1. Scan `automation-system-template/dot-folders-and-config-templates/`
2. Compare .claude and .mcp structures
3. Verify against documentation-template/ specs
4. Check main README.md references
5. Validate file integrity

## Output

Returns comprehensive report:
- 📂 Template structure comparison
- 🔗 Cross-reference validation
- ⚠️ Inconsistencies found
- ✅ Compliance summary
- 💡 Suggested fixes
