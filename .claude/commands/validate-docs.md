---
description: Validate documentation files against AI Whisperers standards
---

# Validate Documentation Standards

Check the specified documentation file (or all .md files) for compliance with AI Whisperers standards.

## Validation Checks

1. **Header Structure**
   - Metadata line present (Doc-Type · Version · Updated · Author)
   - Concise purpose statement (≤120 words)
   - Clear scope definition

2. **Hierarchy Compliance**
   - Maximum 3 heading levels
   - Proper nesting (no level skipping)
   - Bullets used for deeper structures

3. **Cognitive Principles**
   - Short, symmetric lines
   - Clear temporal flow (input → process → output)
   - Micro-echoes for key concepts
   - Consistent section separators (---)

4. **Documentation Ratio**
   - Appropriate Human/Toon balance for document type
   - README: 100% Human
   - Setup guides: 20-30% Toon
   - API/Schema docs: 75-90% Toon

## Usage

```
/validate-docs [file-path]
```

**Examples:**
- `/validate-docs` - Validate all markdown files
- `/validate-docs README.md` - Validate main README
- `/validate-docs documentation-template/documentation-format.md` - Validate specific file

## Output

Returns validation report with:
- ✅ Passed checks
- ⚠️ Warnings (style suggestions)
- ❌ Failed checks (must fix)
- 📊 Documentation ratio analysis
