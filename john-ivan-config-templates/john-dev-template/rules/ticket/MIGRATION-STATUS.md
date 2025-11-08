# Ticket Rules - Framework Alignment Migration Status

**Date**: 2025-11-04  
**Version**: Phase 1 Complete

## Overview

This document tracks the migration of ticket management rules to full compliance with the rule-authoring framework (`rule.authoring.overview.v1`).

## Completed Work

### ✅ Phase 1: Foundation & Templars (COMPLETE)

#### 1. Ticket Rules Index Created
**File**: `.cursor/rules/ticket/ticket-rules-index.mdc`
- Complete manifest of all ticket rules with stable IDs
- Dependency graph documented
- Reading paths for different roles
- Common scenarios with rule sequences
- **ID**: `rule.ticket.overview.v1`

#### 2. Templars Created
**Location**: `.cursor/templars/ticket/`

All templars created with complete front-matter:
- ✅ `templar.plan.v1` (`plan-templar.md`) - Plan.md structure
- ✅ `templar.context.v1` (`context-templar.md`) - Context.md structure
- ✅ `templar.progress.v1` (`progress-templar.md`) - Progress.md entry format
- ✅ `templar.timeline.v1` (`timeline-templar.md`) - Timeline.md structure
- ✅ `templar.recap.v1` (`recap-templar.md`) - Recap.md structure
- ✅ `templar.rca.v1` (`rca-templar.md`) - RCA.md structure
- ✅ `templar-index.md` - Templar manifest and usage guide

#### 3. Rules Updated to Full Framework Compliance

**✅ plan-rule.mdc** → `rule.ticket.plan.v1`
- Complete front-matter with all 10 required fields
- Explicit input/output contracts
- Deterministic steps (13 steps)
- OPSEC and Leak Control section
- Integration Points
- Failure Modes and Recovery
- FINAL MUST-PASS CHECKLIST (7 items)
- References by stable ID: `rule.ticket.complexity-assessment.v1`, `templar.plan.v1`

**✅ progress-rule.mdc** → `rule.ticket.progress.v1`
- Complete front-matter
- Explicit input/output contracts (append-only discipline)
- Deterministic steps (9 steps)
- OPSEC and Leak Control section
- Integration Points
- Failure Modes and Recovery
- FINAL MUST-PASS CHECKLIST (7 items)
- References by stable ID: `rule.ticket.timeline.v1`, `templar.progress.v1`

**✅ context-rule.mdc** → `rule.ticket.context.v1`
- Complete front-matter
- Explicit input/output contracts (mutable working memory)
- Deterministic steps (13 steps)
- OPSEC and Leak Control section
- Integration Points
- Failure Modes and Recovery
- FINAL MUST-PASS CHECKLIST (7 items)
- References by stable ID: `templar.context.v1`

**✅ validation-before-completion-rule.mdc** → `rule.ticket.validation.v1`
- Complete front-matter
- Explicit input/output contracts
- Deterministic steps (13 validation steps)
- Formatting Requirements (validation evidence format)
- OPSEC and Leak Control section
- Integration Points
- Failure Modes and Recovery
- FINAL MUST-PASS CHECKLIST (9 items)
- References by stable ID: `rule.ticket.plan.v1`, `rule.ticket.progress.v1`, `rule.ticket.context.v1`, `rule.ticket.recap.v1`

## Framework Compliance Checklist

Per `rule.authoring.file-structure.v1`, each rule must have:

| Requirement | plan | progress | context | validation | Others |
|-------------|------|----------|---------|------------|--------|
| **Front-matter (10 fields)** | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| 1. Purpose & Scope | ✅ | ✅ | ✅ | ✅ | Partial |
| 2. Inputs (Contract) | ✅ | ✅ | ✅ | ✅ | ❌ |
| 3. Outputs (Contract) | ✅ | ✅ | ✅ | ✅ | ❌ |
| 4. Deterministic Steps | ✅ | ✅ | ✅ | ✅ | ❌ |
| 5. Formatting Requirements | ✅ | ✅ | ✅ | ✅ | ❌ |
| 6. OPSEC and Leak Control | ✅ | ✅ | ✅ | ✅ | ❌ |
| 7. Integration Points | ✅ | ✅ | ✅ | ✅ | Partial |
| 8. Failure Modes and Recovery | ✅ | ✅ | ✅ | ✅ | ❌ |
| 9. Provenance Footer Spec | ✅ | ✅ | ✅ | ✅ | ❌ |
| 10. Related Rules | ✅ | ✅ | ✅ | ✅ | Partial |
| **FINAL MUST-PASS CHECKLIST (last)** | ✅ | ✅ | ✅ | ✅ | ❌ |

## Remaining Work

### 🔴 Phase 2: Complete Core Rules (HIGH PRIORITY)

These rules need full framework alignment:

#### **recap-rule.mdc** → `rule.ticket.recap.v1`
- ⚠️ Has description, needs full front-matter
- ❌ Missing contracts
- ❌ Missing deterministic steps
- ❌ Missing OPSEC section
- Template: Follow pattern from plan-rule.mdc

#### **rca-rule.mdc** → `rule.ticket.rca.v1`
- ⚠️ Has description, needs full front-matter
- ❌ Missing contracts
- ❌ Missing deterministic steps
- ❌ Missing OPSEC section
- Template: Follow pattern from plan-rule.mdc

#### **timeline-tracking-rule.mdc** → `rule.ticket.timeline.v1`
- ❌ NO front-matter at all (starts with "# Timeline Tracking Rule")
- ✅ Content is comprehensive and excellent
- ❌ Missing contracts
- ❌ Needs canonical section structure
- **HIGH PRIORITY** - Critical rule, needs immediate attention

### 🟡 Phase 3: Process Rules (MEDIUM PRIORITY)

#### **complexity-assessment-rule.mdc** → `rule.ticket.complexity-assessment.v1`
- ⚠️ Has description, needs full front-matter
- ❌ Missing contracts
- ❌ Needs deterministic steps for performing assessment
- Template: Follow pattern from validation-rule.mdc

#### **ai-completion-discipline.mdc** → `rule.ticket.completion-discipline.v1`
- ⚠️ Has description, needs full front-matter
- ❌ Consider `kind: guideline` instead of `kind: rule` (behavioral, not file-generating)
- ✅ Content is excellent behavioral guidance
- ❌ Missing contracts (if keeping as rule)
- Template: May need custom approach for behavioral rules

#### **switching-discipline.mdc** → `rule.ticket.switching-discipline.v1`
- ⚠️ Has description, needs full front-matter
- ❌ Missing contracts
- ❌ Missing deterministic steps
- Template: Follow pattern from context-rule.mdc

### 🟢 Phase 4: Workflow & Integration (LOW PRIORITY)

#### **ticket-workflow-rule.mdc** → `rule.ticket.workflow.v1`
- ⚠️ Has description, needs full front-matter
- ✅ Comprehensive content
- ❌ Needs contracts
- ❌ Needs canonical section structure
- **Note**: This is the hub rule - similar to rule-authoring-overview.mdc

#### **current-rule.mdc** → `rule.ticket.current.v1`
- Needs review and alignment
- Governs: `**/tickets/current.md`

#### **references-rule.mdc** → `rule.ticket.references.v1`
- Needs review and alignment
- Governs: `**/tickets/**/references.md`

#### **timeline-workflow-integration.mdc** → `rule.ticket.timeline-workflow-integration.v1`
- Needs review and alignment
- Integration of timeline with workflow

## Migration Pattern

For each remaining rule, follow this pattern (based on completed rules):

### Step 1: Add Front-Matter
```yaml
---
id: rule.ticket.[name].v1
kind: rule
version: 1.0.0
description: [Clear one-sentence description]
globs: ["**/tickets/**/*.md"]  # What files to read
governs: ["**/tickets/**/[name].md"]  # What files to modify
implements: [action]  # e.g., recap.create, rca.analyze
requires:
  - [dependent rule IDs]
  - templar.[name].v1
model_hints: { temp: 0.2, top_p: 0.9 }
provenance: { owner: team-ticket, last_review: 2025-11-04 }
---
```

### Step 2: Convert Existing Sections

**Old Format** → **New Format**:
- "Purpose" → "Purpose & Scope" (add "Applies to" and "Does not apply to")
- "Core Responsibilities" → Fold into Purpose or Outputs
- "Allowed Content" → Part of Outputs contract
- "Not Allowed Content" → Keep as guidance, or move to OPSEC
- "Required Checklist" → "FINAL MUST-PASS CHECKLIST" (must be last)

### Step 3: Add Missing Canonical Sections

1. **Inputs (Contract)** - What must exist before rule executes
2. **Outputs (Contract)** - What will be created/modified
3. **Deterministic Steps** - Numbered, verifiable actions
4. **OPSEC and Leak Control** - What must NOT appear in outputs
5. **Failure Modes and Recovery** - Known failure scenarios and recovery actions

### Step 4: Update Cross-References

**Old**: `@/ticket/plan-rule.mdc`  
**New**: `rule.ticket.plan.v1`

### Step 5: Validate Against Framework

Check against `rule.authoring.file-structure.v1`:
- [ ] 10 front-matter fields present
- [ ] All 10 canonical sections in correct order
- [ ] FINAL MUST-PASS CHECKLIST is last section
- [ ] References use stable IDs
- [ ] Contracts are explicit and testable

## Benefits Achieved So Far

### For Completed Rules:
1. **Discoverable by Tooling** - Stable IDs enable rule indexing and searching
2. **Dependency Tracking** - Tools can build dependency graphs
3. **Version Management** - Breaking changes trackable via major version
4. **Testable Contracts** - Input/output contracts enable automated validation
5. **OPSEC Enforcement** - Explicit leak prevention guidelines
6. **Failure Recovery** - Clear guidance for error scenarios

### For Templars:
1. **Structured Templates** - Formal structure definitions with placeholders
2. **Versioned** - Breaking changes to templates tracked
3. **Reusable** - Same templar can be used by multiple rules
4. **Documented** - Clear purpose and usage for each templar

## Success Metrics

**Current Status**:
- ✅ 4 of 11 core rules fully compliant (36%)
- ✅ 6 of 6 templars created (100%)
- ✅ Index and manifest created
- ⚠️ 7 rules need completion (64%)

**Target** (End of Phase 2):
- 8 of 11 core rules fully compliant (73%)
- All critical rules (plan, progress, context, validation, timeline, recap, rca) compliant

**Target** (End of Migration):
- 11 of 11 core rules fully compliant (100%)
- All cross-references use stable IDs
- All rules testable via automated validation

## Next Actions

### Immediate (This Week):
1. Update `timeline-tracking-rule.mdc` (critical, no front-matter)
2. Update `recap-rule.mdc` and `rca-rule.mdc` (needed for ticket closure)
3. Test updated rules with actual ticket workflow

### Short-term (Next Sprint):
4. Update `complexity-assessment-rule.mdc`
5. Update `ai-completion-discipline.mdc` (consider guideline vs rule)
6. Update `switching-discipline.mdc`

### Medium-term (Next Month):
7. Update `ticket-workflow-rule.mdc` (hub rule, complex)
8. Update remaining integration rules
9. Create validation automation for rule compliance
10. Document migration lessons learned

## Questions for Resolution

1. **Behavioral Rules**: Should `ai-completion-discipline.mdc` be `kind: guideline` instead of `kind: rule`?
   - It doesn't generate or modify files
   - It defines behavioral expectations for AI
   - Consider creating new kind: "guideline" or "principle"

2. **Workflow Rule Complexity**: `ticket-workflow-rule.mdc` is very comprehensive. Should it:
   - Remain as single rule (like rule-authoring-overview)
   - Be split into multiple rules by concern
   - Reference other rules rather than duplicate their content

3. **Template Migration**: Should existing `tickets/templates/*.md` files:
   - Remain as-is (user-facing examples)
   - Be replaced by templars
   - Both kept (templars for structure, templates for examples)

## Resources

- **Rule Authoring Framework**: `.cursor/rules/rule-authoring/rule-authoring-overview.mdc`
- **File Structure Requirements**: `.cursor/rules/rule-authoring/rule-file-structure.mdc`
- **Contract Guidelines**: `.cursor/rules/rule-authoring/rule-contracts-and-scope.mdc`
- **Templar Guidelines**: `.cursor/rules/rule-authoring/rule-templars-and-exemplars.mdc`
- **Example Compliant Rules**: `plan-rule.mdc`, `progress-rule.mdc`, `context-rule.mdc`, `validation-before-completion-rule.mdc`

## Change Log

### 2025-11-04 - Phase 1 Complete
- Created ticket-rules-index.mdc with full manifest
- Created 6 templars with complete front-matter
- Updated 4 rules to full framework compliance
- Documented migration patterns and remaining work
- Established stable ID scheme for ticket rules

