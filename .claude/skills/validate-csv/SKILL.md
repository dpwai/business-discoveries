---
name: validate-csv
description: Validate a CSV file against the SOAL DDL schema — checks columns, types, enums, FKs, NULLs, and data quality. Use when a new CSV arrives or before running generate_inserts.py.
disable-model-invocation: true
allowed-tools: Read, Grep, Bash, Glob
argument-hint: "<path-to-csv> [target-table-name]"
context: fork
---

# Validate CSV — DDL Schema Validator

Validate a CSV file against the SOAL DDL schema (`00_DDL_COMPLETO_V0.sql`), checking for structural and data quality issues before import.

**CSV path:** `$ARGUMENTS` (first arg = CSV path, optional second arg = target table name)

---

## Step 0: Preview the CSV

```bash
head -5 $ARGUMENTS
wc -l $ARGUMENTS
```

Identify: delimiter (comma vs semicolon), encoding issues, header row presence, record count.

---

## Step 1: Identify Target Table

If target table was provided as second argument, use it. Otherwise:
1. Infer from CSV filename (e.g., `15_ticket_balancas.csv` → `ticket_balancas`)
2. Infer from CSV path (e.g., `fase_6/` → UBG/operacoes tables)
3. If ambiguous, list candidate tables and ask user

---

## Step 2: Extract DDL Definition

Read the DDL file and extract the CREATE TABLE block for the target table:

```
Path: 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
```

Extract:
- All columns with types
- NOT NULL constraints
- DEFAULT values
- CHECK constraints
- ENUM types used (grep CREATE TYPE for each)
- Foreign key references

---

## Step 3: Column Validation

Compare CSV headers against DDL columns:

| Check | Rule |
|-------|------|
| **Missing columns** | CSV lacks columns that are NOT NULL and have no DEFAULT |
| **Extra columns** | CSV has columns not in DDL (may be intermediate/computed) |
| **Name mismatches** | Case differences, underscores vs spaces, accents |
| **Auto-generated** | Skip: `*_id` (PK), `created_at`, `updated_at`, `status`, `organization_id` — these are auto-generated |

---

## Step 4: Data Type Validation

For each CSV column mapped to a DDL column, check a sample (first 20 rows + last 5 rows):

| DDL Type | Validation |
|----------|-----------|
| `UUID` | Matches `/^[0-9a-f]{8}-[0-9a-f]{4}-/` or is a reference name (will be resolved) |
| `INTEGER` | Parseable as int, no decimals |
| `NUMERIC(x,y)` / `DECIMAL` | Parseable as float, check precision |
| `DATE` | Parseable as YYYY-MM-DD or DD/MM/YYYY |
| `TIMESTAMP` | Parseable as datetime |
| `VARCHAR(n)` | Length <= n |
| `TEXT` | Any string OK |
| `BOOLEAN` | true/false/0/1/sim/nao |
| ENUM type | Value exists in the CREATE TYPE definition |

---

## Step 5: Referential Integrity (FK Check)

For each FK column in the DDL:
1. Check if the CSV has that column
2. If yes, extract unique values from CSV
3. Check if those values exist in the referenced table's seed/data CSV (if available in IMPORTS/)
4. Report: N values found, M missing references

Use `generate_inserts.py` section mapping to find which CSV populates the referenced table.

---

## Step 6: Data Quality Checks

| Check | Rule |
|-------|------|
| **Duplicates** | Check if PK-equivalent columns have duplicates |
| **NULL ratio** | For NOT NULL columns, report % of empty/null values |
| **Outliers** | For numeric columns, flag values > 3 stddev from mean |
| **Date range** | For date columns, verify within expected safra range (Jul-Jun cycle) |
| **Encoding** | Flag non-UTF8 characters, mojibake patterns |
| **Trailing spaces** | Flag columns with significant whitespace |

---

## Step 7: Report

Output a structured validation report:

```markdown
## Validation Report: [filename] → [target_table]

**Records:** N (excluding header)
**Columns:** N CSV / M DDL (X mapped, Y missing, Z extra)

### Column Mapping
| CSV Column | DDL Column | Type | Status |
|------------|-----------|------|--------|
| col_name   | col_name  | UUID | OK     |
| col_name   | —         | —    | EXTRA  |
| —          | col_name  | INT  | MISSING (has DEFAULT) |

### Type Violations (sample)
| Row | Column | Value | Expected | Actual |
|-----|--------|-------|----------|--------|

### ENUM Violations
| Column | Invalid Values | Valid Values |
|--------|---------------|-------------|

### FK References
| FK Column | Target Table | Found | Missing | Coverage |
|-----------|-------------|-------|---------|----------|

### Data Quality
| Check | Result | Details |
|-------|--------|---------|

### Verdict: PASS / WARN / FAIL
```

---

## SOAL-Specific Rules

- **Safra format:** Must be `YY/YY` (e.g., `24/25`), fiscal year Jul→Jun
- **Talhao names:** May have inconsistencies — flag but don't fail
- **Cultura names:** Must match `tipo_cultura` enum (lowercase, no accents)
- **Money values:** Brazilian format `1.234,56` — verify conversion
- **organization_id:** If present, must be the SOAL org UUID from seeds
- **Gleba vs Talhao:** `gleba` is sub-area of talhao — both are valid in ticket_balancas

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL schema (source of truth) |
| `09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql` | Seed data (for FK validation) |
| `09_Projetos/01_SOAL/DDL/sql/generate_inserts.py` | CSV→SQL mapping |
| `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md` | CSV registry |
