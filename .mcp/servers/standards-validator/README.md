# Standards Validator MCP Server

Custom MCP server for validating documentation and templates against AI Whisperers standards.

## Status

⚠️ **This server is currently a placeholder and not yet implemented.**

This README describes the planned architecture and functionality. Implementation is pending.

## Overview

The Standards Validator is a custom MCP server that provides specialized tools for:
- Validating documentation structure and formatting
- Checking Human/Toon ratio compliance
- Verifying template consistency
- Analyzing cognitive flow and readability
- Ensuring Toon format syntax correctness

## Planned Architecture

```
standards-validator/
├── Dockerfile              # Container definition
├── requirements.txt        # Python dependencies
├── server.py              # MCP server implementation
├── validators/            # Validation modules
│   ├── __init__.py
│   ├── doc_structure.py   # Documentation structure validation
│   ├── toon_format.py     # Toon format validation
│   ├── cognitive_flow.py  # Readability analysis
│   └── template_check.py  # Template consistency checking
├── utils/                 # Utility functions
│   ├── __init__.py
│   ├── file_reader.py     # File reading helpers
│   └── markdown_parser.py # Markdown parsing utilities
└── README.md             # This file
```

## Planned Tools

### 1. validate_documentation

Validates a documentation file against AI Whisperers standards.

**Parameters:**
```json
{
  "file_path": "README.md",
  "document_type": "overview",
  "strict_mode": true
}
```

**Checks:**
- Metadata line present and properly formatted
- Purpose statement exists (≤120 words)
- Scope definition included
- Hierarchy compliance (≤3 levels)
- Heading level consistency
- Section separators present
- Cognitive principles applied

**Returns:**
```json
{
  "passed": true,
  "passed_checks": [
    "Metadata line present",
    "Hierarchy valid (max depth: 3)",
    "Section separators consistent"
  ],
  "failed_checks": [],
  "warnings": [
    "Consider adding more micro-echoes for key concepts"
  ],
  "recommendations": [
    "Add visual cues (emojis) for better section differentiation"
  ]
}
```

### 2. check_documentation_ratio

Analyzes Human vs. Toon format ratio.

**Parameters:**
```json
{
  "file_path": "api-spec.md",
  "expected_type": "api"
}
```

**Returns:**
```json
{
  "human_ratio": 0.15,
  "toon_ratio": 0.85,
  "expected_range": {
    "min": 0.75,
    "max": 0.95
  },
  "compliant": true,
  "analysis": "Within expected range for API documentation",
  "recommendations": []
}
```

### 3. validate_hierarchy

Checks heading hierarchy compliance.

**Parameters:**
```json
{
  "file_path": "guide.md"
}
```

**Returns:**
```json
{
  "valid": false,
  "max_depth": 4,
  "violations": [
    {
      "line": 45,
      "level": 4,
      "heading": "#### Over-nested Section",
      "suggestion": "Convert to bullet list or reduce nesting"
    }
  ],
  "structure": [
    {"level": 1, "text": "Main Title", "line": 1},
    {"level": 2, "text": "Section", "line": 10},
    {"level": 3, "text": "Subsection", "line": 20}
  ]
}
```

### 4. check_template_consistency

Compares templates across repository.

**Parameters:**
```json
{
  "template_type": "claude"
}
```

**Returns:**
```json
{
  "templates_checked": [
    "automation-system-template/dot-folders-and-config-templates/claude-and-ai-automation/.claude",
    ".claude"
  ],
  "inconsistencies": [
    {
      "type": "missing_file",
      "file": "commands/validate-docs.md",
      "found_in": [".claude"],
      "missing_in": ["template"]
    },
    {
      "type": "content_difference",
      "file": "settings.local.json",
      "differences": [
        "Template has different permission patterns"
      ]
    }
  ],
  "recommendations": [
    "Synchronize validate-docs command to template",
    "Review permission patterns for consistency"
  ]
}
```

### 5. validate_toon_format

Verifies Toon format syntax correctness.

**Parameters:**
```json
{
  "file_path": "config.toon",
  "strict": true
}
```

**Returns:**
```json
{
  "valid": true,
  "syntax_errors": [],
  "warnings": [
    {
      "line": 12,
      "message": "Inconsistent indentation detected",
      "severity": "low"
    }
  ],
  "statistics": {
    "total_lines": 50,
    "toon_lines": 45,
    "comment_lines": 5
  }
}
```

### 6. analyze_cognitive_flow

Analyzes readability and cognitive principles.

**Parameters:**
```json
{
  "file_path": "documentation-format.md"
}
```

**Returns:**
```json
{
  "score": 85,
  "metrics": {
    "line_symmetry": 0.9,
    "temporal_flow": 0.85,
    "micro_echo_density": 0.7,
    "visual_rhythm": 0.8
  },
  "suggestions": [
    "Add more temporal markers (→, ←) in procedural sections",
    "Increase micro-echo repetition for key concepts",
    "Consider adding visual separators for better rhythm"
  ],
  "strengths": [
    "Excellent heading hierarchy",
    "Good use of section separators",
    "Strong temporal flow in sequential sections"
  ]
}
```

## Implementation Plan

### Phase 1: Basic Structure Validation
- [x] Define architecture
- [ ] Implement MCP server framework (server.py)
- [ ] Create doc_structure.py validator
- [ ] Add basic hierarchy checking
- [ ] Implement metadata validation

### Phase 2: Ratio Analysis
- [ ] Implement toon_format.py parser
- [ ] Add Human/Toon ratio calculation
- [ ] Create ratio compliance checker
- [ ] Add document type detection

### Phase 3: Template Consistency
- [ ] Implement template_check.py
- [ ] Add template comparison logic
- [ ] Create inconsistency detection
- [ ] Generate recommendations

### Phase 4: Cognitive Analysis
- [ ] Implement cognitive_flow.py
- [ ] Add readability metrics
- [ ] Create flow analysis
- [ ] Add suggestion engine

### Phase 5: Integration & Testing
- [ ] Add comprehensive tests
- [ ] Create Docker container
- [ ] Integrate with gordon-mcp.yml
- [ ] Add to docker-compose.mcp-gateway.yml
- [ ] Write usage documentation

## Technology Stack

**Language:** Python 3.11+

**Dependencies:**
- `mcp-sdk` - MCP server framework
- `markdown` - Markdown parsing
- `pyyaml` - YAML parsing
- `jsonschema` - JSON validation
- `regex` - Advanced pattern matching

**Development:**
- `pytest` - Testing framework
- `black` - Code formatting
- `mypy` - Type checking

## Docker Container

**Dockerfile (planned):**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "server.py"]
```

**requirements.txt (planned):**
```
mcp-sdk>=1.0.0
markdown>=3.5.0
pyyaml>=6.0.1
jsonschema>=4.20.0
regex>=2023.10.3
```

## Usage Examples

Once implemented, the server will be used like:

```bash
# Via Docker AI
docker ai "Validate README.md against standards"

# Via MCP Gateway
curl -X POST http://localhost:8080/tools/validate_documentation \
  -H "Content-Type: application/json" \
  -d '{"file_path": "README.md"}'

# Via Claude Desktop
# "Please validate the documentation-format.md file"
```

## Development Guidelines

When implementing this server:

1. **Follow AI Whisperers standards:**
   - Documentation with metadata headers
   - Maximum 3 heading levels
   - Cognitive principles in code structure

2. **Validation should be:**
   - Non-destructive (read-only)
   - Fast (< 500ms per file)
   - Comprehensive (all standards covered)
   - Helpful (actionable recommendations)

3. **Code quality:**
   - Type hints throughout
   - Comprehensive tests (>80% coverage)
   - Clear error messages
   - Detailed logging

4. **Security:**
   - Read-only file access
   - No external network calls
   - Input validation on all parameters
   - Safe file path handling

## Contributing

To implement this server:

1. Create Python virtual environment
2. Install dependencies from requirements.txt
3. Implement validators in validators/ directory
4. Add tests in tests/ directory
5. Build Docker container
6. Test with gordon-mcp.yml
7. Update documentation

## Resources

- [MCP SDK Documentation](https://github.com/anthropics/mcp)
- [AI Whisperers Standards](../../../README.md)
- [Documentation Format](../../../documentation-template/documentation-format.md)
- [Neuroparsing Protocol](../../../documentation-template/neuroparsing-protocol.md)

## Version

**Status:** Planned (Not Implemented)
**Target Version:** 1.0.0
**Last Updated:** 2025-11-07

---

**Want to implement this?** Follow the implementation plan above and create a PR with your implementation.
