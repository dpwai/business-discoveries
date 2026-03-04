---
name: coleta-dashboard
description: Generate a self-contained HTML dashboard for tracking data collection progress. Use when the user wants to create or update a visual tracker for entities, phases, statuses, and dependencies in a data project.
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Grep
argument-hint: "[output-file.html] [context-description]"
---

# Coleta Dashboard — Data Collection Tracker Generator

Generate a **single self-contained HTML file** that serves as an interactive dashboard for tracking data collection progress across entities organized in phases.

**Output file:** `$0` (or default to `coleta-dashboard.html` in the current directory)
**Context:** `$1` (optional description of the project/domain)

---

## Architecture

The dashboard is a single HTML file with inline CSS and JS. No external dependencies except Google Fonts (JetBrains Mono + DM Sans). Works offline after first font load.

### Data Model (defined as JS arrays in the file)

```
NODES[] — Array of entity objects:
  { id: 'ENTITY_NAME',        // UPPER_SNAKE_CASE, unique
    phase: 0,                  // integer, groups entities into sections
    cat: 'A',                  // single letter category (method/type)
    status: 'pendente',        // one of STATUS_CYCLE values
    records: 0,                // integer count of collected records
    desc: 'Full description.'  // text shown in detail drawer
  }

EDGES[] — Array of [parent, child] tuples:
  ['PARENT_ENTITY', 'CHILD_ENTITY']

STATUS_CYCLE — Array of status keys in rotation order
STATUS — Object mapping status keys to { fill, ring, label, dim }
PHASE_COLORS — Array of hex colors, one per phase
PHASE_SHORT — Array of short phase labels
PHASE_LONG — Array of full phase names
CAT_LABEL — Object mapping category letters to descriptions
```

### UI Components

1. **Sticky Header**
   - Project title + subtitle
   - Stacked progress bar (segments per status, proportional width)
   - Progress label: `X/total coletado (Y%)`, `N parcial`, `total registros`
   - Status filter buttons (click to filter, click again to clear)
   - Action button: "Gerar Prompt"

2. **Toolbar**
   - Search input (filters entities by name, `/` keyboard shortcut to focus)
   - Category legend chips (A=Seed, B=CSV, etc.)

3. **Phase Sections** (one per phase, collapsible)
   - Left accent bar (phase color)
   - Phase name + entity count + mini progress bar
   - Chevron toggle (collapsed hides body)
   - Grid of entity cards (auto-fill, min 260px)

4. **Entity Cards**
   - Status color dot + entity name (monospace) + category badge
   - Record count badge (green) + status tag (colored)
   - Truncated description (1 line)
   - Click opens detail drawer

5. **Detail Drawer** (slides in from right, 440px)
   - Entity name as title + close button
   - Meta tags: phase, category, record count
   - Status change buttons (4 buttons, current one highlighted)
   - Full description
   - Dependencies: "Depende de (N)" — parent entities from EDGES, clickable
   - Feeds: "Alimenta (N)" — child entities from EDGES, clickable
   - Clicking a dependency navigates the drawer to that entity

6. **Prompt Modal** (centered overlay)
   - Auto-generates context summary: counts by status, entity lists with record counts, critical dependency blockers, next phase to attack
   - Copy button + close button

### Keyboard Shortcuts
- `/` — focus search
- `Escape` — close drawer or modal

---

## Design System

### Theme (CSS Variables)
```css
--bg-0: #0d1117;      /* page background */
--bg-1: #161b22;      /* card/section background */
--bg-2: #21262d;      /* borders, subtle backgrounds */
--bg-3: #30363d;      /* hover states */
--fg-0: #f0f6fc;      /* primary text */
--fg-1: #c9d1d9;      /* body text */
--fg-2: #8b949e;      /* secondary text */
--fg-3: #6e7681;      /* muted text */
```

### Status Colors
```
coletado:  ring=#2ea043, fill=#238636, dim=rgba(46,160,67,.15)
parcial:   ring=#d29922, fill=#9e6a03, dim=rgba(210,153,34,.15)
pendente:  ring=#484f58, fill=#3d444d, dim=rgba(72,79,88,.15)
bloqueado: ring=#f85149, fill=#b91c1c, dim=rgba(248,81,73,.15)
```

### Typography
- **Display/mono:** JetBrains Mono — entity names, counts, code-like content
- **Body:** DM Sans — descriptions, labels, buttons
- Font sizes: 10-16px range, nothing smaller

### Layout
- Max content width: 1400px centered
- Card grid: `repeat(auto-fill, minmax(260px, 1fr))`
- Generous padding (12-24px), clear visual hierarchy
- Responsive: single column below 768px, drawer goes full-width

### Interactions
- Subtle hover transitions (0.15s)
- No flashy animations
- Status changes update all views immediately (progress bar, header stats, cards, drawer)

---

## Safety Rules

- **NEVER use innerHTML.** Use only safe DOM methods: `createElement`, `textContent`, `appendChild`, `removeChild`.
- Use a `clearChildren(el)` helper: `while (el.firstChild) el.removeChild(el.firstChild);`
- Use a factory helper: `el(tag, className, textContent)` for clean DOM creation.
- All user-facing text set via `.textContent`, never string concatenation into DOM.

---

## Generation Process

1. **Gather data:** Ask the user for (or read from context):
   - List of entities with: id, phase, category, status, record count, description
   - List of edges (parent→child dependencies)
   - Phase names and colors
   - Category definitions
   - Status definitions (or use defaults above)
   - Project title and subtitle

2. **Populate arrays:** Fill NODES, EDGES, PHASE_LONG, PHASE_SHORT, PHASE_COLORS, CAT_LABEL, STATUS with the project data.

3. **Write file:** Output a single HTML file following the architecture above.

4. **Verify:** Open in browser if possible, confirm all entities render, drawer works, prompt generates correctly.

---

## Labels (Portuguese by default)

All UI labels in Portuguese:
- Coletado, Parcial, Pendente, Bloqueado
- Fase, Entidades, Registros
- Depende de, Alimenta
- Buscar entidade...
- Gerar Prompt, Copiar, Fechar
- Descricao

Override language by specifying in the context argument.

---

## Reference Implementation

See the SOAL playground as the canonical reference:
`09_Projetos/02_SOAL/soal-coleta-playground.html`

This file contains 41 entities across 8 phases with full dependency tracking. Use it as a template for structure and styling.
