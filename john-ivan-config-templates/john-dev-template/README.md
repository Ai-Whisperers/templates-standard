# AI Development Ruleset

A comprehensive, domain-organized ruleset for AI-assisted software development, designed for use with Cursor IDE or similar AI coding assistants.

## Overview

This repository contains a structured collection of rules (.mdc files) that guide AI assistants in maintaining code quality, following best practices, and automating development workflows. The rules are organized into specialized domains, each addressing specific aspects of the software development lifecycle.

## Structure

```
.
├── rules/              # Rule definitions (.mdc files)
│   ├── agile/         # Agile methodology and documentation rules
│   ├── migration/     # System migration process rules
│   ├── rule-authoring/ # Meta-rules for creating and maintaining rules
│   ├── technical-specifications/ # Technical documentation standards
│   ├── ticket/        # Ticket workflow and project management rules
│   └── *.mdc          # General coding and quality rules
└── templars/          # Template files for structured documentation
    └── ticket/        # Templates for ticket-related documents
```

## What Are .mdc Files?

.mdc (Markdown Configuration) files define rules for AI assistants. Each rule contains:

- **YAML Frontmatter**: Metadata about when and how the rule applies
  - `id`: Unique identifier for the rule
  - `description`: What the rule does
  - `globs`: File patterns the rule applies to (e.g., `**/*.cs` for all C# files)
  - `governs`: File patterns the rule can modify
  - `alwaysApply`: Whether the rule applies automatically or requires explicit invocation
  - `version`: Semantic version of the rule
  - `provenance`: Ownership and review metadata

- **Markdown Content**: Detailed guidelines, requirements, and examples

### Example Rule Structure

```yaml
---
description: This rule prevents the AI from using apologies in its responses.
globs: **/*.*
alwaysApply: false
---
- Never use apologies
```

## Rule Domains

### 1. General Coding Rules (Root Level)

Located in `rules/`, these rules apply across all file types to ensure code quality and consistency:

- **clean-code.mdc**: Guidelines for writing maintainable, readable code
  - Constants over magic numbers
  - Meaningful names
  - Single responsibility principle
  - DRY (Don't Repeat Yourself)
  - Smart comments

- **dry-principle.mdc**: Enforces code reuse and elimination of duplication

- **general-coding-rules.mdc**: Universal standards including:
  - Verify information before presenting
  - Make changes file by file
  - No apologies or unnecessary confirmations
  - Preserve existing code structures
  - Security-first approach

- **development-commit-message.mdc**: Comprehensive git commit message standards
  - Format: `<type>(scope): short summary`
  - Types: feat, fix, chore, docs, refactor, test, style, perf, ci
  - Mandatory commit body with context
  - PowerShell-safe commit message file creation

- **csharp-xml-docs-rule.mdc**: Standards for C# XML documentation comments
  - Class-level documentation requirements
  - Member documentation (fields, properties, methods, events)
  - XML tags: `<summary>`, `<param>`, `<returns>`, `<exception>`, `<remarks>`

- **Behavioral Rules**:
  - `no-apologies-rule.mdc`: Never apologize in responses
  - `no-summaries-rule.mdc`: Don't summarize changes made
  - `no-inventions-rule.mdc`: Don't invent changes not requested
  - `no-understanding-feedback-rule.mdc`: Avoid meta-commentary about understanding
  - `verify-information-rule.mdc`: Always verify before presenting
  - `file-by-file-changes-rule.mdc`: Make changes incrementally
  - `single-chunk-edits-rule.mdc`: Provide all edits in one chunk per file

- **Code Quality Rules**:
  - `comment-usage.mdc`: When and how to use comments
  - `naming-conventions.mdc`: Naming standards for variables, functions, classes
  - `function-length-and-responsibility.mdc`: Keep functions small and focused
  - `code-quality-and-best-practices.mdc`: Overall quality standards
  - `readme-structure-rule.mdc`: Consistent README.md structure requirements

### 2. Agile Documentation Rules (`rules/agile/`)

Standards for documenting agile artifacts:

- **epic-documentation-rule.mdc**: How to document epics
  - High-level business objectives
  - Success criteria
  - Dependencies and risks

- **business-feature-documentation-rule.mdc**: Business feature specifications
  - User value proposition
  - Acceptance criteria
  - Business rules

- **technical-feature-documentation-rule.mdc**: Technical implementation details
  - Architecture decisions
  - Technical constraints
  - Implementation approach

- **user-story-documentation-rule.mdc**: User story standards
  - "As a... I want... So that..." format
  - Acceptance criteria
  - Testing scenarios

- **story-splitting-rule.mdc**: Guidelines for breaking down large stories
  - Vertical slicing strategies
  - Value delivery optimization
  - Dependency management

- **agent-application-rule.mdc**: Agentic invocation strategy
  - Description-triggered (no globs)
  - Used for complex, multi-step agile documentation tasks

### 3. Migration Rules (`rules/migration/`)

Systematic approach to legacy system migrations:

- **migration-overview.mdc**: High-level migration strategy and phases

- **phase-1-data-collection.mdc**: Gather information about legacy system
  - Code analysis
  - Dependency mapping
  - Business logic extraction

- **phase-2-specification-creation.mdc**: Document current system behavior
  - Domain objects
  - Business rules
  - Integration points

- **phase-2b-specification-review.mdc**: Validate specifications
  - Completeness checks
  - Stakeholder review
  - Gap analysis

- **phase-3-migration-planning.mdc**: Create migration roadmap
  - Risk assessment
  - Rollback strategies
  - Testing approach

### 4. Rule Authoring Rules (`rules/rule-authoring/`)

Meta-rules for creating and maintaining the rule system itself:

- **rule-authoring-overview.mdc**: Philosophy and approach to rule creation
  - Extract from practice, not theory
  - Minimal viable rules
  - Evolve through usage

- **rule-file-structure.mdc**: Canonical schema for .mdc files
  - 11 required fields in YAML frontmatter
  - Proper YAML format (not JSON arrays)
  - Markdown body structure

- **rule-naming-conventions.mdc**: Naming standards for rule IDs
  - Format: `rule.[domain].[action].v[major]`
  - Examples: `rule.agile.epic-documentation.v1`

- **rule-contracts-and-scope.mdc**: Define rule boundaries
  - What files the rule reads (globs)
  - What files the rule modifies (governs)
  - Cross-rule dependencies

- **rule-invocation-strategies.mdc**: Three strategies for triggering rules
  - **Strategy 1**: File-mask triggered (operational rules with globs)
  - **Strategy 2**: Description-triggered agentic (agent-application rules, no globs)
  - **Strategy 3**: Always-apply (universal read-only rules)

- **rule-validation-and-checklists.mdc**: Quality assurance for rules
  - Validation criteria
  - Self-testing checklists
  - Compliance verification

- **rule-cross-references.mdc**: How rules reference and depend on each other

- **rule-templars-and-exemplars.mdc**: Template and example file standards

- **rule-provenance-and-versioning.mdc**: Versioning and ownership metadata
  - Semantic versioning
  - Review tracking
  - Change history

- **rule-extraction-from-practice.mdc**: Process for creating rules from experience
  - Observe patterns in practice
  - Document what works
  - Formalize as rules

### 5. Technical Specifications Rules (`rules/technical-specifications/`)

Standards for documenting technical architecture:

- **domain-object-rule.mdc**: Document domain entities
  - Properties and relationships
  - Validation rules
  - Lifecycle management

- **enumeration-rule.mdc**: Document enumerations and constant sets
  - Value definitions
  - Usage context
  - Evolution strategy

- **business-rules-rule.mdc**: Document business logic
  - Conditions and actions
  - Validation logic
  - Decision tables

- **entity-relationship-rule.mdc**: Document relationships between entities
  - Cardinality
  - Referential integrity
  - Cascade behaviors

- **domain-overview-rule.mdc**: High-level domain documentation
  - Bounded contexts
  - Domain events
  - Ubiquitous language

- **integration-points-rule.mdc**: Document external integrations
  - API contracts
  - Data formats
  - Error handling

- **documentation-architecture-rule.mdc**: How to structure technical docs
  - File organization
  - Cross-referencing
  - Versioning

- **hybrid-documentation-architecture-rule.mdc**: Mixed documentation approaches
  - Centralized vs. distributed
  - When to use each approach

- **specification-anti-duplication-rule.mdc**: Prevent duplicate documentation
  - Single source of truth principle
  - Cross-reference instead of copy
  - Canonical location determination

### 6. Ticket Workflow Rules (`rules/ticket/`)

Project management and ticket tracking standards:

- **ticket-workflow-rule.mdc**: Overall workflow for ticket management
  - Lifecycle states
  - Transition criteria
  - Documentation requirements

- **ticket-rule.mdc**: Core ticket structure and requirements

- **plan-rule.mdc**: How to document implementation plans
  - Approach description
  - Task breakdown
  - Risk identification

- **context-rule.mdc**: Capture relevant context for tickets
  - Related code locations
  - Dependencies
  - Historical decisions

- **progress-rule.mdc**: Track and document progress
  - Status updates
  - Blockers
  - Completed work

- **recap-rule.mdc**: Summarize ticket outcomes
  - What was done
  - What was learned
  - Follow-up items

- **rca-rule.mdc**: Root cause analysis for bugs
  - Problem statement
  - Investigation steps
  - Resolution and prevention

- **complexity-assessment-rule.mdc**: Estimate ticket complexity
  - Effort estimation
  - Risk factors
  - Skill requirements

- **timeline-tracking-rule.mdc**: Time tracking for tickets
  - Estimate vs. actual
  - Timeline visualization
  - Forecasting

- **switching-discipline.mdc**: Context switching protocols
  - Save state before switching
  - Minimize interruptions
  - Resume efficiently

- **ai-completion-discipline.mdc**: When AI should mark work complete
  - Completion criteria
  - Validation requirements
  - Handoff procedures

- **validation-before-completion-rule.mdc**: Pre-completion checklist
  - Tests passing
  - Documentation updated
  - Code reviewed

- **references-rule.mdc**: How to manage references in tickets
  - File references
  - External links
  - Version tracking

## Templars (Templates)

Located in `templars/ticket/`, these are template files for creating structured documentation:

- **plan-templar.md**: Template for implementation plans
- **context-templar.md**: Template for context documentation
- **progress-templar.md**: Template for progress tracking
- **recap-templar.md**: Template for recaps/summaries
- **rca-templar.md**: Template for root cause analysis
- **timeline-templar.md**: Template for timeline tracking

## Critical Documentation

### CRITICAL-YAML-FORMAT-ISSUES.md

This document identifies a widespread formatting issue affecting 98% of rules:

**Problem**: Most rules use JSON array syntax `["pattern"]` instead of proper YAML format for `globs` and `governs` fields.

**Correct Format**:
```yaml
# Single pattern
globs: **/pattern.md

# Multiple patterns
globs:
  - **/pattern1.md
  - **/pattern2.md
```

**Status**: Documented for systematic correction

### CROSS-DOMAIN-INVOCATION-VALIDATION.md

Validation report showing that 96% of rules are missing the `alwaysApply` field:

**Issue**: Rules don't explicitly declare invocation behavior

**Impact**: Ambiguity about whether rules auto-trigger or require explicit invocation

**Recommendation**: Add `alwaysApply: false` to all rules (systematic update needed)

## How Rules Work

### Invocation Strategies

Rules use three invocation strategies:

1. **File-Mask Triggered (Strategy 1)**
   - Rule triggers when matching files are opened/edited
   - Uses `globs` to match files
   - Uses `governs` to specify modifiable files
   - `alwaysApply: false`

2. **Description-Triggered Agentic (Strategy 2)**
   - Rule triggered by description matching
   - No `globs` or `governs` fields
   - Used for complex, multi-step workflows
   - `alwaysApply: false`

3. **Always-Apply (Strategy 3)**
   - Universal rules that always apply
   - `globs: **/*` (all files)
   - `governs: []` (read-only)
   - `alwaysApply: true`

### Rule Application Flow

1. User opens/edits a file or requests an action
2. AI assistant identifies matching rules based on:
   - File patterns (`globs`)
   - Description matching
   - Always-apply status
3. AI applies rule guidelines to:
   - Validate code
   - Generate content
   - Enforce standards
   - Automate workflows
4. AI modifies only files specified in `governs` field

## Key Principles

### 1. Extract from Practice, Not Theory

Rules are created based on real development experience, not academic speculation. If a pattern proves valuable in practice, it becomes a rule.

### 2. Minimal Viable Rules

Start with the simplest rule that solves the problem. Evolve only when demonstrated need arises.

### 3. Single Source of Truth

Each concept should be documented once. Other references should link to the canonical source.

### 4. Explicit Over Implicit

Make intentions clear. Use explicit field values (`alwaysApply: false`) rather than relying on defaults.

### 5. Self-Consistency

The rule system should follow its own rules. Meta-rules in `rule-authoring/` govern how all rules are created.

### 6. Composability

Rules can reference and build upon other rules using the `requires` field and cross-references.

## Usage with Cursor IDE

Cursor IDE reads .mdc files from the `.cursor/rules/` directory. To use this ruleset:

1. Copy the `rules/` directory to `.cursor/rules/` in your project
2. Copy the `templars/` directory to `.cursor/templars/`
3. Cursor will automatically apply matching rules based on file patterns
4. Invoke agent-application rules explicitly when needed

## Current Status

**Rules**: 47 total across 5 domains
- General: 36 rules
- Agile: 6 rules (including agent-application)
- Migration: 5 rules
- Rule Authoring: 11 rules (including agent-application)
- Technical Specifications: 11 rules (including agent-application)
- Ticket Workflow: 14 rules (including agent-application)

**Known Issues**:
- 98% of rules use JSON array format instead of YAML (documented in CRITICAL-YAML-FORMAT-ISSUES.md)
- 96% of rules missing `alwaysApply` field (documented in CROSS-DOMAIN-INVOCATION-VALIDATION.md)

**Recommended Actions**:
1. Systematically convert JSON arrays to YAML format
2. Add `alwaysApply: false` to all rules
3. Update `rule-file-structure.mdc` to reflect 11-field canonical schema

## Contributing

When creating or modifying rules:

1. Follow the canonical schema defined in `rules/rule-authoring/rule-file-structure.mdc`
2. Use proper YAML format (not JSON arrays)
3. Include all 11 required frontmatter fields
4. Extract rules from practice, not theory
5. Test rules before committing
6. Update version and provenance metadata
7. Follow semantic versioning
8. Document changes in commit messages per `development-commit-message.mdc`

## License

This ruleset is designed for internal development use. Adapt and extend as needed for your projects.

## Philosophy

This ruleset embodies a philosophy of systematic, AI-assisted development:

- **Automation with Guardrails**: Let AI handle repetitive tasks while enforcing quality standards
- **Documentation as Code**: Treat documentation with the same rigor as source code
- **Continuous Improvement**: Rules evolve based on what works in practice
- **Consistency Through Automation**: Use AI to enforce standards that humans might forget
- **Explicit Knowledge**: Capture tribal knowledge as executable rules

By encoding development standards as machine-readable rules, teams can maintain consistency, onboard faster, and focus on creative problem-solving rather than memorizing style guides.
