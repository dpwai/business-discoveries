---
name: er-playground
description: Generate a self-contained HTML interactive ER diagram with force-directed graph, canvas rendering, layer filters, and detail panel. Use when the user wants to visualize database entities and relationships as an explorable graph.
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Grep
argument-hint: "[output-file.html] [context-description]"
---

# ER Playground — Interactive Entity-Relationship Diagram Generator

Generate a **single self-contained HTML file** with an interactive force-directed graph of database entities and their relationships. Canvas-based rendering, zero external dependencies.

**Output file:** `$0` (or default to `er-playground.html` in the current directory)
**Context:** `$1` (optional description of the project/domain)

---

## Architecture

Single HTML file (~800 lines) with inline CSS and JS. No external dependencies. Works fully offline.

### Data Model (defined as JS objects/arrays in `<script>`)

```
ENUMS{} — Object mapping enum_name to array of string values:
  { tipo_fazenda: ["propria", "arrendada", "parceria", "comodato"], ... }

LAYERS[] — Array of layer definitions:
  { key: "sistema", label: "Sistema", color: "#4a90d9", y: 100 }
  - key: internal identifier
  - label: display name
  - color: hex color for node headers
  - y: initial Y position band for force layout

ENTITIES[] — Array of entity objects:
  { id: "table_name",           // SQL table name (snake_case plural)
    name: "ENTITY_NAME",        // Display name (UPPER_SNAKE_CASE singular)
    layer: "sistema",           // key from LAYERS
    pk: "entity_id",            // primary key column name
    ddlDoc: "Doc 26",           // source documentation reference
    status: "completo",         // completo | parcial | sem_dados
    csvRecords: 883,            // record count (0 if no data)
    csvFile: "path/to/file.csv",// CSV source path (optional)
    enums: ["enum_name"],       // array of ENUM keys used by this entity
    cols: [                     // array of column definitions
      { col: "field_name",      // column name
        type: "UUID",           // SQL type
        pk: 1,                  // truthy if primary key
        fk: "target_table",     // target table name if foreign key (optional)
        en: 1                   // truthy if column uses an ENUM type (optional)
      }
    ]
  }

EDGES[] — Array of FK relationship objects (excluding organization_id):
  { from: "source_table", to: "target_table", col: "fk_column_name" }
```

### Computed at Init
- `entMap{}` — entity lookup by id
- `e.inEdges[]` / `e.outEdges[]` — incoming/outgoing edges per entity

---

## Page Layout

```
+-----------------------------------------------------------+
|  HEADER: "Project ER Playground" + stats badges           |
+--------+-------------------------------+------------------+
| LEFT   |      CANVAS (graph)           | RIGHT PANEL      |
| 220px  |      flex: 1                  | 360px            |
|        |                               | (slide-in        |
| Layer  |   Nodes + Edges               |  on click)       |
| toggles|   Zoom/Pan/Drag               |                  |
| Search |                               | Columns          |
| Stats  |                               | ENUMs            |
| Legend |                               | FKs in/out       |
+--------+-------------------------------+------------------+
```

### Header
- Project title (h1) with accent-colored second word
- Stats badges: `N/N entidades`, `N edges`, `N enums`, `N records`

### Left Panel (220px, fixed)
- Search input — filters entities by name (dims non-matching, never hides)
- Layer toggle list — color dot + label + count, click to toggle visibility
- Keyboard shortcuts section

### Canvas (flex: 1)
- HTML5 Canvas 2D with world-space transform (zoom + pan)
- Draw order: edges -> nodes -> labels

### Right Panel (360px, slide-in)
- Opens on node click, closes on Esc or close button
- Shows: entity name, layer badge, status/doc/records pills, CSV path
- Columns table with PK/FK/ENUM flags
- ENUM values display
- Clickable outgoing FKs ("Referencia") and incoming FKs ("Referenciado por")
- Clicking an entity in the panel navigates to it with animated pan

---

## Canvas Rendering

### Node Visual
- Rounded rect: colored header (layer color) + dark body (#161b22)
- Header: entity name (bold, 10px monospace, dark text on colored bg)
- Body: PK line (key emoji + column name, blue) + FK lines (arrow + target, orange)
- Width: 160px fixed, height: 24px header + 16px * rows + 6px padding
- Max 6 visible rows (overflow shows "+ N FKs")
- Selection ring: blue 2.5px stroke
- Hover ring: blue 0.5 opacity

### Edge Visual
- Quadratic bezier curves between node centers
- Arrow head at target (8px, 0.3 rad spread)
- Default: rgba(139,148,158,0.25), 0.8px
- Highlighted (connected to active node): rgba(88,166,255,0.7), 1.8px
- Dimmed (when node selected, unconnected): rgba(139,148,158,0.08)
- Self-reference (e.g. maquinas.trator_vinculado_id): ellipse loop above node
- FK label shown at midpoint when zoom > 1.5 and edge highlighted

### Force Simulation
1. **Repulsion** — node-node: `F = 8000 / dist^2` (O(n^2), fine for <100 nodes)
2. **Spring** — edges: `F = 0.03 * (dist - 220)` (pulls connected nodes)
3. **Layer gravity** — `F = 0.02 * (targetY - node.y)` (anchors to layer Y band)
4. **Damping:** 0.7 per tick
5. **Alpha cooling:** start 1.0, decay 0.98/tick, stops when < 0.005
6. **Pre-warm:** 200 synchronous ticks at load (no animation), RAF only during drag

### Initial Positions (grid by layer)
- Each layer has a Y band (defined in LAYERS[].y)
- Left-aligned layers: insumos, financeiro
- Right-aligned layers: op_campo, frete_vendas
- Center-aligned: all others
- Entities spaced 200px apart horizontally within their layer
- Small random Y jitter (+/-20px)

---

## Interaction

### Mouse
- **Click node:** opens right panel with details, highlights connected edges
- **Drag node:** moves node, reactivates force simulation
- **Drag empty space:** pans the canvas
- **Scroll wheel:** zoom centered on cursor (clamp 0.2 - 4.0)
- **Double-click empty:** fit-all (zoom to show all visible nodes)

### Keyboard
- `Esc` — close panel, deselect node
- `F` — fit-all
- `1`-`9` — toggle layer visibility
- `Space` — reset zoom/pan to origin

### Search
- Input in left panel, real-time filter
- Matching nodes: full opacity
- Non-matching: opacity 0.15
- Never removes nodes, only dims

---

## Right Panel Detail View

When a node is clicked, slide-in panel (360px) with:

1. **Header:** entity name (mono bold) + layer badge (colored) + close button
2. **Meta pills:** status (completo/parcial/sem_dados) + DDL doc + record count
3. **CSV path** (if exists, monospace, muted)
4. **Columns table:** campo | tipo | flags (PK/FK/ENUM badges)
   - organization_id row: class `org-row`, opacity 0.35, "(oculto)" label
5. **ENUMs section:** enum name (yellow) + values joined by middle dot
6. **Outgoing FKs** ("Referencia (FKs saindo)"): clickable, arrow + target name + column
7. **Incoming FKs** ("Referenciado por (FKs entrando)"): clickable, arrow + source name + column

Clicking an entity in the panel:
- Enables its layer if hidden
- Animated pan+zoom to center on node (400ms ease-in-out)
- Updates panel content

---

## Design System

### Theme (CSS Variables)
```css
--bg: #0d1117;    --bg2: #161b22;   --bg3: #21262d;   --bg4: #30363d;
--fg: #e6edf3;    --fg2: #8b949e;   --fg3: #484f58;
--accent: #58a6ff; --green: #3fb950; --yellow: #d29922;
--red: #f85149;    --orange: #db6d28;
--radius: 8px;
--font: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--mono: 'SF Mono', 'Fira Code', 'Cascadia Code', monospace;
```

### Status Pills
```
completo:  background rgba(63,185,80,.15), color var(--green)
parcial:   background rgba(210,153,34,.15), color var(--yellow)
sem_dados: background rgba(139,148,158,.12), color var(--fg3)
```

### Flag Badges (column table)
```
PK:   background rgba(88,166,255,.2), color var(--accent)
FK:   background rgba(219,109,40,.2), color var(--orange)
ENUM: background rgba(210,153,34,.15), color var(--yellow)
```

---

## Safety Rules

- **NEVER use innerHTML.** Use only safe DOM methods: `createElement`, `textContent`, `appendChild`.
- Use a `clearChildren` pattern: `el.textContent = ""` before repopulating.
- All user-facing text set via `.textContent`, never string concatenation into DOM.
- All data is hardcoded (no user input), but DOM safety is still mandatory.

---

## Generation Process

1. **Gather data:** Read from context or ask the user for:
   - DDL/SQL file or list of tables with columns, types, PKs, FKs
   - ENUM definitions
   - Layer/section assignments for each table
   - Status and record counts per entity (from GAP analysis or similar)
   - CSV file paths (if available)

2. **Parse and structure:** Build ENUMS, LAYERS, ENTITIES, EDGES arrays from the source data.
   - org_id edges: EXCLUDED from EDGES[] array (org_id shown grayed in detail panel only)
   - Self-references: INCLUDED (e.g. maquinas.trator_vinculado_id -> maquinas)

3. **Write file:** Output single HTML following the architecture above.

4. **Verify:** Open in browser, confirm:
   - All nodes render positioned by layer
   - Scroll zoom, drag pan, drag node all work
   - Layer toggles hide/show correctly
   - Click node opens detail panel with correct columns/ENUMs/FKs
   - Clicking entity in panel navigates to it
   - Search dims non-matching nodes
   - Performance: smooth 60fps drag

---

## Labels (Portuguese by default)

- Buscar / Filtrar entidades...
- Camadas
- Atalhos
- Colunas, Campo, Tipo, Flags
- Referencia (FKs saindo), Referenciado por (FKs entrando)
- completo, parcial, sem_dados
- (oculto) — for organization_id

Override language by specifying in the context argument.

---

## Reference Implementation

See the SOAL ER playground as the canonical reference:
`09_Projetos/02_SOAL/DDL/soal-er-playground.html`

This file contains 57 entities across 9 layers with 82 edges, 40 ENUMs, and ~95k records. Use it as the template for structure, styling, and interaction patterns.
