---
name: er-validate
description: Validate ER diagram integrity — run Dijkstra redundant FK check, detect hub violations, verify leaf entity rules, and check org_id compliance.
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Glob
argument-hint: "[entity-name | 'full']"
---

# ER Validate — Dijkstra FK Redundancy Checker

Parse the DDL to build an adjacency graph and run Dijkstra's algorithm to detect redundant foreign keys, hub violations, and leaf entity rule breaks per CLAUDE.md section 4.

**Focus:** `$ARGUMENTS` — specific entity name or "full" for complete validation

---

## Step 1: Build Adjacency Graph

Parse DDL to extract all FK relationships:

```bash
# Extract all REFERENCES from DDL
grep -n "REFERENCES" 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
```

For each `REFERENCES` clause, extract:
- Source table (the CREATE TABLE block it's inside)
- Source column (the column with the FK)
- Target table (after REFERENCES)
- Target column (after target table)

Build:
- `edges[]` — list of `(source, target, column)` tuples
- `adj{}` — adjacency list (bidirectional for pathfinding)

**Exclude from graph:** `organization_id` references (org_id rule — CLAUDE.md §4.2)

---

## Step 2: Dijkstra Redundant FK Check

For EACH edge `A → C`:

1. Temporarily remove edge `A → C` from the graph
2. Find shortest path from `A` to `C` using remaining edges (BFS is sufficient)
3. Record path length

Decision matrix (CLAUDE.md §4.1):

| Path Length | Verdict | Action |
|-------------|---------|--------|
| No path | ESSENTIAL | Keep FK — it's the only connection |
| 1 hop | REDUNDANT | Remove FK from ER diagram |
| 2 hops | REDUNDANT | Remove FK from ER diagram |
| 3 hops | GRAY ZONE | OK in DDL with `-- DENORM` comment, NOT in ER diagram |
| 4+ hops | CONSIDER | May justify denormalization in DDL only |

---

## Step 3: Hub Entity Validation

Hub entities (CLAUDE.md §4.2) have 8+ connections:
- OPERACAO_CAMPO
- APLICACAO_INSUMO
- ANIMAL (fora escopo V0)
- PRODUTO_INSUMO

**Check:** No cross-hub shortcuts exist (FK directly between two hub entities that could go through an intermediate).

---

## Step 4: Leaf Entity Validation

Leaf entities (detail tables) should connect ONLY to their parent:
- PLANTIO_DETALHE → OPERACAO_CAMPO only
- COLHEITA_DETALHE → OPERACAO_CAMPO only
- PULVERIZACAO_DETALHE → OPERACAO_CAMPO only

**Check:** No extra FKs beyond the parent FK (+ organization_id which is always present).

---

## Step 5: Organization ID Compliance

**Rule:** Every table MUST have `organization_id` but it MUST NOT appear in ER diagrams.

```bash
# Tables missing organization_id
# (parse each CREATE TABLE block and check for organization_id column)
```

Report tables that:
- Missing `organization_id` (violation)
- Have `organization_id` drawn as a relationship in any ER doc (check DIAGRAMA_ER_SOAL/*.md)

---

## Step 6: Additional Checks

### 6.1 Naming Convention (CLAUDE.md §3)

| Element | Convention | Check |
|---------|-----------|-------|
| Table names | plural snake_case | `CREATE TABLE xxx` matches pattern |
| PK names | `entidade_id` | Not bare `id` |
| FK names | `entidade_referenciada_id` | Matches referenced table |
| Timestamps | both present | `created_at` + `updated_at` in every table |

### 6.2 Orphan Tables

Tables with zero incoming AND zero outgoing FKs (excluding org_id):
- These should be root entities (organizations, admins) or have a justification

### 6.3 Circular References

Detect cycles in the FK graph (self-references like `maquinas.trator_vinculado_id` are OK, but multi-table cycles should be flagged).

---

## Step 7: Report

```markdown
## ER Validation Report

**Date:** YYYY-MM-DD
**Tables analyzed:** N
**Edges analyzed:** N (excluding org_id)

### Redundant FKs Detected

| Source | Target | Column | Alt Path | Hops | Verdict |
|--------|--------|--------|----------|------|---------|
| table_a | table_c | fk_col | A→B→C | 2 | REDUNDANT |

### Hub Violations
[Cross-hub shortcuts found]

### Leaf Violations
[Leaf entities with extra FKs]

### Org ID Compliance
- Missing org_id: [list]
- Drawn in ER: [list]

### Naming Violations
[Tables/columns not following conventions]

### Orphan Tables
[Tables with no FK connections]

### Summary
| Check | Pass | Fail | Warn |
|-------|------|------|------|
| Redundant FK | N | N | N |
| Hub rules | N | N | — |
| Leaf rules | N | N | — |
| Org ID | N | N | — |
| Naming | N | N | — |
```

---

## Implementation Note

The Dijkstra/BFS check can be implemented inline with a Python snippet via Bash:

```python
# Build graph from grep output, run BFS for each edge
from collections import deque

def bfs(adj, start, end, skip_edge=None):
    """BFS shortest path, optionally skipping one edge."""
    visited = {start}
    queue = deque([(start, 0)])
    while queue:
        node, dist = queue.popleft()
        if node == end:
            return dist
        for neighbor in adj.get(node, []):
            if skip_edge and (node, neighbor) == skip_edge:
                continue
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, dist + 1))
    return -1  # no path
```

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL with all FKs |
| `CLAUDE.md §4` | ER diagram rules (Dijkstra, hub, leaf, org_id) |
| `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/08_ESTRUTURA_ER_COMPLETA_SOAL.md` | Master ER reference |
| `.github/agents/er-diagram-architect.agent.md` | Detailed ER rules |
| `.github/agents/soal-er-board-context.agent.md` | Current board state |
