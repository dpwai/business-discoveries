---
name: gap-update
description: Regenerate GAP_ANALYSIS.md by scanning DDL tables, CSV files, Prisma models, and INSERT scripts. Reports completeness per entity.
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Grep, Bash
argument-hint: "[output-path]"
---

# GAP Update — GAP Analysis Regenerator

Scan all project artifacts and regenerate `GAP_ANALYSIS.md` with current completeness status per entity.

**Output:** `$ARGUMENTS` or default `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md`

---

## Step 1: Extract DDL Tables

```bash
grep "^CREATE TABLE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
```

For each table, extract:
- Table name (snake_case plural)
- Entity name (UPPER_SNAKE_CASE singular — derive from table name)
- DDL section (from preceding comment `-- SECAO X:`)
- DDL doc reference (from comment or known mapping)
- Column count
- ENUM types used

---

## Step 2: Scan CSV Files

```bash
find 09_Projetos/01_SOAL/DATA/IMPORTS -name "*.csv" -not -path "*DEPRECATED*" -not -path "*_archive*"
```

For each CSV:
- Filename and fase
- Record count (`wc -l` minus 1 for header)
- Header columns (first line)
- Map to target DDL table (by filename convention or generate_inserts.py mapping)

---

## Step 3: Check Prisma Schema

```bash
grep "^model " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma
```

For each model:
- Model name
- `@@map()` value (target table name)
- Field count

---

## Step 4: Check INSERT Scripts

```bash
grep "INSERT INTO " 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql | sed 's/INSERT INTO //' | sed 's/ .*//' | sort -u
grep "INSERT INTO " 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql | sed 's/INSERT INTO //' | sed 's/ .*//' | sort -u
```

For each table with INSERTs:
- Which file (seeds vs data)
- Approximate record count (count INSERT lines or ON CONFLICT blocks)

---

## Step 5: Determine Status per Entity

| Status | Criteria |
|--------|----------|
| `completo` | Has DDL + Prisma + CSV with data + INSERTs |
| `parcial` | Has DDL + Prisma + some data but incomplete |
| `sem_dados` | Has DDL + Prisma but no CSV/INSERT data |
| `seed_only` | Has DDL + Prisma + seed data but no operational data |
| `template` | Has DDL + Prisma + template CSV but no real data |
| `fora_escopo` | Defined but excluded from V0 |

---

## Step 6: Generate GAP_ANALYSIS.md

```markdown
# GAP Analysis — SOAL V0

**Gerado:** YYYY-MM-DD
**DDL:** 00_DDL_COMPLETO_V0.sql (N tabelas, M ENUMs)
**Prisma:** schema.prisma (N modelos, M enums)
**Seeds:** 01_INSERT_SEEDS.sql (Nk linhas)
**Dados:** 02_INSERT_DADOS.sql (Nk linhas)

---

## Resumo

| Status | Count | % |
|--------|-------|---|
| completo | N | X% |
| parcial | N | X% |
| sem_dados | N | X% |
| seed_only | N | X% |

---

## Matriz Completa

| # | Entidade | Tabela DDL | Prisma | CSV | Records | INSERTs | DDL Doc | Status |
|---|----------|-----------|--------|-----|---------|---------|---------|--------|
| 1 | ORGANIZATION | organizations | Organization | fase_1/01_organizations.csv | 1 | seeds | Doc 26 | completo |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

---

## Por Fase

### Fase 0 — Seeds
[table of entities in this phase]

### Fase 1 — Sistema
...

### Fase 2 — Territorial
...

[etc.]

---

## Entidades sem Dados (acao necessaria)

| Entidade | Motivo | Acao | Responsavel |
|----------|--------|------|-------------|

---

## Divergencias Encontradas

| Tipo | Descricao | Acao |
|------|-----------|------|
| DDL sem Prisma | [table] | Adicionar model |
| Prisma sem DDL | [model] | Remover ou criar table |
| CSV sem INSERT | [file] | Adicionar a generate_inserts.py |
```

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL source of truth |
| `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | Prisma schema |
| `09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql` | Seed INSERTs |
| `09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql` | Data INSERTs |
| `09_Projetos/01_SOAL/DDL/sql/generate_inserts.py` | CSV→INSERT mapping |
| `09_Projetos/01_SOAL/DATA/IMPORTS/` | All CSV files |
| `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md` | CSV registry |
