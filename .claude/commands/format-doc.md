---
description: Format a documentation file according to AI Whisperers standards
---

# Format Documentation File

Apply AI Whisperers documentation standards to a markdown file, including proper headers, structure, and cognitive principles.

## What This Does

1. **Add/Fix Header**
   - Insert metadata line if missing
   - Add purpose statement template
   - Include scope definition

2. **Fix Hierarchy**
   - Adjust heading levels to maximum 3
   - Convert over-nested headings to bullets
   - Ensure proper nesting order

3. **Apply Cognitive Principles**
   - Add section separators (---)
   - Improve line rhythm and symmetry
   - Insert micro-echoes for key concepts
   - Add visual cues (emojis) if appropriate

4. **Structure Optimization**
   - Add temporal flow markers where applicable
   - Create tables for comparisons
   - Add code blocks with proper syntax
   - Include examples and action hooks

## Usage

```
/format-doc <file-path> [--type=<doc-type>] [--ratio=<toon-ratio>]
```

**Arguments:**
- `<file-path>` - Path to markdown file to format
- `--type` - Document type (overview, guide, api, config, etc.)
- `--ratio` - Desired Toon format ratio (0.0-1.0)

**Examples:**
- `/format-doc new-feature.md --type=guide --ratio=0.3`
- `/format-doc api-spec.md --type=api --ratio=0.9`
- `/format-doc README.md --type=overview`

## Document Type Ratios

| Type | Default Toon Ratio | Description |
|------|-------------------|-------------|
| overview | 0.0 | README, introductions |
| guide | 0.2-0.3 | Setup, tutorials |
| api | 0.85-0.95 | API specifications |
| config | 0.95 | Configuration templates |
| pipeline | 0.75 | Data flow descriptions |
| adr | 0.5 | Architecture decisions |

## Safety

- Creates backup of original file (.bak)
- Shows diff before applying changes
- Asks for confirmation on major restructuring

## Output

Returns:
- 📄 Formatted file preview
- 📊 Before/after metrics
- ✅ Applied transformations
- 💾 Backup file location
