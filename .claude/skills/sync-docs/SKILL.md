---
name: sync-docs
description: Full sync of all project artifacts after any change — regenerates INSERT SQLs, updates all docs, playgrounds, memory, and metrics. Use after modifying DDL, CSVs, generate_inserts.py, Prisma, or ER docs.
disable-model-invocation: true
allowed-tools: Read, Edit, Write, Bash, Glob, Grep, Agent
argument-hint: "[description-of-changes]"
---

# Sync Docs — Full Project Sync

**Trigger:** After ANY change to DDL, CSVs, generate_inserts.py, Prisma schema, or ER docs.
**Goal:** Regenerate all derived artifacts AND update ALL documentation to be 100% consistent.
**Change description:** $ARGUMENTS

---

## Step 0: Regenerate INSERT SQL Files (ALWAYS FIRST)

This is the FIRST step, ALWAYS. Even if only docs changed — regenerate to ensure SQLs match the current state of CSVs + generate_inserts.py.

```bash
cd 09_Projetos/01_SOAL/DDL/sql && python3 generate_inserts.py
```

**Verify:**
- Zero errors in output
- Note the line counts printed for `01_INSERT_SEEDS.sql` and `02_INSERT_DADOS.sql`
- If errors, fix `generate_inserts.py` first, then re-run

---

## Step 1: Collect Current Metrics (from regenerated output)

Run ALL of these to get ground truth numbers:

```bash
# ─── SQL file metrics ───
wc -l 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/generate_inserts.py

# ─── DDL object counts ───
grep -c "^CREATE TABLE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "^CREATE TYPE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "^CREATE.*VIEW " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "^CREATE.*FUNCTION " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "CREATE INDEX " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "CREATE TRIGGER " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql

# ─── Prisma metrics ───
grep -c "^model " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma
grep -c "^enum " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma

# ─── INSERT structure ───
# Last section number in 02_INSERT_DADOS.sql
grep "^-- [0-9]" 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql | tail -1
# All section headers (for reference)
grep "^-- [0-9]" 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql
# Last section number in 01_INSERT_SEEDS.sql
grep "^-- [0-9]" 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql | tail -1

# ─── CSV counts ───
find 09_Projetos/01_SOAL/DATA/IMPORTS -name "*.csv" -not -path "*DEPRECATED*" | wc -l
# Per-fase breakdown
for fase in fase_0 fase_1_sistema fase_2 fase_2_territorial fase_3 fase_4 fase_5 fase_6 fase_6_operacoes; do echo "$fase: $(find 09_Projetos/01_SOAL/DATA/IMPORTS/$fase -name '*.csv' 2>/dev/null | wc -l) CSVs"; done
```

Save ALL these numbers — they're the SOURCE OF TRUTH for updating docs.

Today's date: !`date +%Y-%m-%d`

---

## Step 2: Update ALL Artifacts — Complete Checklist

Check and update EVERY file below. Do NOT skip any. Use Grep to find impacted lines, then Edit tool for surgical changes.

### 2.1 — SQL INSERT Files (already regenerated in Step 0)

Verify the regenerated `01_INSERT_SEEDS.sql` and `02_INSERT_DADOS.sql`:
- Section numbering is sequential
- FK dependency order is correct (parents before children)
- ON CONFLICT clauses where needed
- COMMIT at end of each file
- Footer comment matches actual totals

### 2.2 — `CLAUDE.md` (root)

**4 metric locations + 1 date:**

| Location | What | Pattern to grep |
|----------|------|----------------|
| §2 header (~line 24-26) | DDL status line (tabelas, ENUMs, views, indexes, triggers) | `DDL status` |
| §2 header (~line 26) | INSERT scripts line (Seeds Xk + Dados Xk) | `INSERT scripts` |
| §11 Docs table (~line 182-184) | DDL Completo row, INSERT Seeds row, INSERT Dados row | `INSERT Dados` |
| §12 DDL Consolidation table (~line 267-269) | Same metrics in different format | `02_INSERT_DADOS` |
| Footer (last line) | Date + session number + description | `Última atualização` |

**Also check:** Prisma metrics (modelos, enums), CSV counts in §11b.

### 2.3 — `MEMORY.md`

Path: `.claude/projects/-Users-rodrigokugler-Documents-business-discoveries/memory/MEMORY.md`

| Location | What |
|----------|------|
| `## Project State` header | Date, phase description |
| `## DDL Consolidation` section | Date in header, deliverables table (INSERT Seeds/Dados rows), detail blocks |
| Any entity-specific notes | Record counts, status |

### 2.4 — `GAP_ANALYSIS.md`

Path: `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md`

**For EACH entity row:**
- `csvFile` column — does it list the correct CSV source(s)?
- `Records` column — does the count match?
- `Status` column — `sem_dados` → `completo`? `template` → `completo`? `parcial` still correct?
- `DDL Doc` column — correct doc reference?

**Grep patterns:**
```
sem_dados
parcial
template
csvRecords
```

### 2.5 — `ETL_REGISTRY.md`

Path: `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md`

**For EACH CSV entry:**
- Record count matches actual CSV (`wc -l` minus header)
- ETL Script column — which script generates it
- Status — OK, REMOVIDO, etc.
- If CSV is now processed by generate_inserts.py, note the section number (e.g., `§26`)

### 2.6 — `soal-ddl-playground.html`

Path: `09_Projetos/01_SOAL/DDL/soal-ddl-playground.html`

**3 areas to update:**

1. **Badge date:** `<span class="header-badge">Bronze Layer V0 -- YYYY-MM-DD</span>`
2. **JS data array:** Each entity line like:
   ```js
   {name:'ENTITY',section:'...',csvFile:'...',csvRecords:NNN,status:'xxx'}
   ```
   Update `csvRecords`, `csvFile`, and `status` for any changed entity.
3. **Summary stats** if hardcoded anywhere in the HTML.

### 2.7 — `soal-er-playground.html`

Path: `09_Projetos/01_SOAL/DDL/soal-er-playground.html`

Check for badge date, entity data arrays, or hardcoded counts.

### 2.8 — `soal-secagem-playground.html`

Path: `09_Projetos/01_SOAL/DDL/soal-secagem-playground.html`

Check for badge date if present.

### 2.9 — `soal-alocacao-playground.html`

Path: `09_Projetos/01_SOAL/DDL/soal-alocacao-playground.html`

Check for badge date if present.

### 2.10 — `PROCESS_FLOW_REVISAO_FASES.md`

Path: `09_Projetos/01_SOAL/PROCESS_FLOW_REVISAO_FASES.md`

| Location | What |
|----------|------|
| Each Fase section | CSV table (filename, registros, tabela destino, status) |
| `## NUMEROS CONSOLIDADOS` table | Total registros Seeds, Total registros Dados, Tabelas DDL, ENUMs, ETL scripts, CSVs count |

### 2.11 — `PLANEJAMENTO_SAFRA_PROCESS_FLOW.md`

Path: `09_Projetos/01_SOAL/PLANEJAMENTO_SAFRA_PROCESS_FLOW.md`

Check CSV Templates section, INSERTs note, record counts.

### 2.12 — `32_LIFECYCLE_TALHAO_SAFRA.md`

Path: `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/32_LIFECYCLE_TALHAO_SAFRA.md`

Check section references (§26-30), INSERT references, record counts.

### 2.13 — `.github/agents/ddl-database-engineer.agent.md`

Check for DDL metrics, table counts, INSERT references.

### 2.14 — Other ER Docs (`DIAGRAMA_ER_SOAL/*.md`)

Grep ALL docs in `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/` for stale metrics:
```bash
grep -rn "INSERT\|tabelas\|ENUMs\|registros\|generate_inserts" 09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/*.md
```

### 2.15 — Prisma Schema (if DDL changed)

If tables/columns/enums changed in DDL, verify `prisma/schema.prisma` is aligned:
- Same models as DDL tables
- Same enums as DDL types
- Same fields and relations
- Same field types

---

## Step 3: Cross-Verify Consistency

After ALL edits, verify nothing was missed:

```bash
# Search for OLD metric values that should have been updated
# (adjust OLD_VALUES based on what changed)
grep -rn "OLD_LINE_COUNT\|OLD_RECORD_COUNT\|OLD_DATE" \
  CLAUDE.md \
  .claude/projects/*/memory/MEMORY.md \
  09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md \
  09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md \
  09_Projetos/01_SOAL/PROCESS_FLOW_REVISAO_FASES.md \
  09_Projetos/01_SOAL/PLANEJAMENTO_SAFRA_PROCESS_FLOW.md \
  09_Projetos/01_SOAL/DDL/soal-ddl-playground.html \
  09_Projetos/01_SOAL/DDL/soal-er-playground.html \
  09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/32_LIFECYCLE_TALHAO_SAFRA.md

# Verify all dates are today
grep -rn "header-badge\|Última atualização\|atualizado 2026" \
  CLAUDE.md \
  .claude/projects/*/memory/MEMORY.md \
  09_Projetos/01_SOAL/DDL/soal-ddl-playground.html
```

---

## Step 4: Report to User

Show a summary table:

```
| # | File | What changed | Old → New |
|---|------|-------------|-----------|
| 1 | CLAUDE.md | INSERT Dados line count | 63k → 65k |
| 2 | ... | ... | ... |
```

Then run `git diff --stat` to show the complete picture.

---

## Important Rules

- **Step 0 (regenerate SQLs) is MANDATORY** — always first, no exceptions
- **NEVER skip a document** — check ALL 15 items in the checklist every time
- **NEVER guess metrics** — always measure first (Step 1), then update
- **NEVER rewrite entire files** — use Edit tool for surgical changes only
- **ALWAYS update dates** — CLAUDE.md footer, playground badges, MEMORY.md section header
- **ALWAYS increment session number** in CLAUDE.md footer (`sessão N` → `sessão N+1`) — unless same session
- **ALWAYS report what changed** — user needs to see the diff summary
- **If DDL was modified**, also verify Prisma schema alignment (2.15)
- **If new CSVs were added**, update ETL_REGISTRY + GAP_ANALYSIS + PROCESS_FLOW (all three)
- **If entity status changed** (e.g., got first data), update GAP_ANALYSIS + DDL playground + PROCESS_FLOW
- **Order matters:** Regenerate → Measure → Update docs → Verify → Report
