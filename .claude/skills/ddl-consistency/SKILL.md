---
name: ddl-consistency
description: Check consistency between DDL, Prisma schema, and INSERT scripts. Reports divergences in tables, columns, enums, and record counts.
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Glob
argument-hint: "[focus-area]"
---

# DDL Consistency — Schema Cross-Validator

Compare DDL (`00_DDL_COMPLETO_V0.sql`), Prisma schema (`schema.prisma`), and INSERT scripts to find divergences.

**Focus area (optional):** `$ARGUMENTS` — specific table/module to focus on, or "full" for everything

---

## Step 1: Collect Metrics

```bash
# DDL metrics
grep -c "^CREATE TABLE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "^CREATE TYPE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "^CREATE.*VIEW " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "CREATE INDEX " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
grep -c "CREATE TRIGGER " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql

# Prisma metrics
grep -c "^model " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma
grep -c "^enum " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma

# INSERT metrics
wc -l 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql

# Tables in each
grep "^CREATE TABLE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql | sed 's/CREATE TABLE //' | sed 's/ (//' | sort
grep "^model " 09_Projetos/01_SOAL/DDL/prisma/schema.prisma | sed 's/model //' | sed 's/ {//' | sort
```

---

## Step 2: Table-Level Consistency

### 2.1 DDL ↔ Prisma: Table/Model Mapping

For each DDL table, verify a corresponding Prisma model exists:
- DDL table name: `snake_case_plural` (e.g., `talhao_safras`)
- Prisma model name: `PascalCase` (e.g., `TalhaoSafra`)
- Mapping: Prisma uses `@@map("table_name")` to link

Report:
- Tables in DDL but missing from Prisma
- Models in Prisma but missing from DDL
- Incorrect `@@map()` values

### 2.2 DDL ↔ INSERTs: Table Coverage

For each DDL table, check if it has INSERTs in either seeds or data:

```bash
grep "INSERT INTO " 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql | sed 's/INSERT INTO //' | sed 's/ .*//' | sort -u
grep "INSERT INTO " 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql | sed 's/INSERT INTO //' | sed 's/ .*//' | sort -u
```

Report: Tables with no INSERT data (expected for some — note which ones are OK to be empty).

---

## Step 3: Column-Level Consistency

For each table (or focused table):

### 3.1 DDL ↔ Prisma Columns

Compare column by column:
- Column exists in both
- Type mapping is correct (e.g., `UUID` → `String @db.Uuid`, `NUMERIC(12,2)` → `Decimal`)
- Nullability matches (`NOT NULL` in DDL → no `?` in Prisma)
- Defaults match
- Relations in Prisma match FKs in DDL

### 3.2 DDL ↔ INSERT Columns

For each INSERT statement, verify:
- Column list matches DDL columns (minus auto-generated: PK with DEFAULT, created_at, updated_at)
- Column order is consistent
- No references to removed/renamed columns

---

## Step 4: ENUM Consistency

### 4.1 DDL ↔ Prisma ENUMs

For each `CREATE TYPE` in DDL:
- Corresponding `enum` exists in Prisma
- All values match (order doesn't matter)
- `@@map()` in Prisma matches DDL type name

### 4.2 DDL ↔ INSERT ENUM Usage

For columns with ENUM types:
- INSERT values are valid enum members
- No typos or case mismatches

---

## Step 5: FK & Relation Consistency

For each FK in DDL (`REFERENCES` clause):
- Prisma has matching `@relation`
- Referenced table/column exists
- ON DELETE/UPDATE behavior matches

---

## Step 6: generate_inserts.py Consistency

Check that `generate_inserts.py` references:
- Correct CSV file paths (files exist)
- Correct target table names (match DDL)
- Correct column mappings
- Correct section numbering (sequential, no gaps)

```bash
python3 -c "
import ast, sys
# Parse generate_inserts.py for CSV paths and table names
# Report any mismatches
"
```

---

## Step 7: Report

```markdown
## DDL Consistency Report

**Date:** YYYY-MM-DD
**Focus:** [full | specific-table]

### Summary
| Artifact | Count | Match |
|----------|-------|-------|
| DDL Tables | N | — |
| Prisma Models | N | N/N match |
| DDL ENUMs | N | — |
| Prisma Enums | N | N/N match |
| Tables with INSERTs | N/N | — |

### Divergences Found

#### Critical (must fix)
1. [Table X exists in DDL but not Prisma]
2. [Column Y type mismatch: DDL=UUID, Prisma=String]

#### Warnings (review)
1. [Table Z has no INSERT data]
2. [ENUM value 'foo' in INSERT but not in CREATE TYPE]

#### Info
1. [N tables are empty by design (leaf entities, future phases)]

### Verdict: CONSISTENT / N ISSUES FOUND
```

---

## Reference Files

| File | Path |
|------|------|
| DDL | `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` |
| Prisma | `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` |
| Seeds | `09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql` |
| Data | `09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql` |
| Generator | `09_Projetos/01_SOAL/DDL/sql/generate_inserts.py` |
| GAP Analysis | `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md` |
