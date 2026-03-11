---
name: ui-ux-audit
description: Mandatory audit workflow for UI/UX changes that reads current state FIRST, checks for redundancy, respects clean design philosophy, and identifies genuine gaps before implementation. Auto-invoked when user mentions UI, UX, design, layout, page improvements, visual changes, or interface modifications.
---

# UI/UX Audit Skill

Mandatory pre-implementation audit process for UI/UX modifications.

## When to Use

Auto-invoke when user mentions: UI, UX, design, layout, homepage, page improvements, visual changes, or interface modifications.

## Audit Process (5 Steps)

### Step 1: Read Current State FIRST

Before proposing ANY changes:
- Read ALL target files completely
- Take screenshots if browser tools available
- Document the current visual state
- **NEVER propose changes without seeing current state**

### Step 2: Document Existing Elements

Create an evidence-based inventory:
```
EXISTING ELEMENTS:
- [ ] Navigation: [describe]
- [ ] Layout structure: [describe]
- [ ] Color scheme: [describe]
- [ ] Typography: [describe]
- [ ] Components: [list all]
- [ ] Interactions: [list all]
- [ ] Responsive behavior: [describe]
```

### Step 3: Redundancy Check

For EACH proposed change, verify:
- Does this element already exist in a different form?
- Would this duplicate information shown elsewhere?
- Is there an existing component that serves this purpose?

**Common redundancy anti-patterns to AVOID:**
- Portfolio visualizations when impact cards already display metrics
- Large UI cards overshadowing primary calls-to-action
- Adding bulk to intentionally minimal pages
- Duplicate data displays across sections
- Adding features that compete with existing navigation patterns

### Step 4: Identify Genuine Gaps

Only propose solutions for PROVEN gaps:
- What specific user need is unmet?
- What task is currently impossible or unnecessarily difficult?
- Is there evidence (not assumption) that this gap exists?

**Rule:** If you cannot articulate the specific user problem, the change is not justified.

### Step 5: Design Philosophy Verification

Ensure recommendations respect:
- Clean, minimal aesthetics (less is more)
- Existing design language and patterns
- Performance implications (no unnecessary weight)
- Accessibility standards (contrast, readability, touch targets)
- Mobile-first responsiveness

## Audit Output Template

```markdown
## UI/UX Audit Report

### Current State
[Screenshot/description of current state]

### Proposed Changes
| # | Change | Justification | Redundancy Risk | Verdict |
|---|--------|--------------|-----------------|---------|
| 1 | ...    | ...          | None/Low/High   | GO/NO-GO |

### Genuine Gaps Found
1. [Gap description + evidence]

### Recommendations
- [Ordered by impact, minimal changes first]

### Changes NOT Recommended (and why)
- [What was considered but rejected, with reasoning]
```

## Verification Checklist

Before implementing ANY change:

- [ ] I read the current files completely
- [ ] I documented what already exists
- [ ] I checked each proposal for redundancy
- [ ] I identified only genuine (not assumed) gaps
- [ ] My proposals respect clean design philosophy
- [ ] I considered mobile/responsive implications
- [ ] I verified accessibility standards
- [ ] The minimum viable change was chosen over feature-heavy alternatives

## Integration with Project Conventions

When auditing SOAL playgrounds specifically:
- Respect existing CSS variables (`--bg, --fg, --accent, --green, --yellow, --red`)
- Maintain dark theme as default
- Preserve keyboard shortcuts pattern
- Keep self-contained single-file HTML approach
- Mobile-first for field operators (Josmar, Tiago, Alessandro)

## This Audit Process is NOT Optional

When users request UI/UX work, this audit MUST be performed before writing any implementation code. The cost of a 2-minute audit is trivial compared to the cost of implementing redundant or harmful UI changes.
