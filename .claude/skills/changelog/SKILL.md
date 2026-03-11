---
name: changelog
description: Generate a changelog entry from recent git commits or manual description. Tracks DDL changes, ETL additions, data imports, and project milestones.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, Grep, Glob
argument-hint: "[version-or-description]"
---

# Changelog — Project Change Tracker for SOAL

Generate structured changelog entries tracking DDL changes, ETL additions, data imports, and project milestones.

**Version/Description:** `$ARGUMENTS`

**Source:** Adapted from alirezarezvani/claude-skills (changelog-generator)

---

## Step 1: Gather Changes

### From Git (primary)
```bash
# Recent commits since last tag or N days
git log --oneline --since="7 days ago" --no-merges
git diff --stat HEAD~10
```

### From File Changes
```bash
# Recently modified files
find 09_Projetos/01_SOAL -name "*.sql" -newer CHANGELOG.md 2>/dev/null
find 09_Projetos/01_SOAL -name "*.py" -newer CHANGELOG.md 2>/dev/null
find 09_Projetos/01_SOAL/DATA/IMPORTS -name "*.csv" -newer CHANGELOG.md 2>/dev/null
```

### From Metrics Delta
Compare current metrics against last changelog entry:
```bash
grep -c "^CREATE TABLE " 09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql
wc -l 09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql
```

---

## Step 2: Categorize Changes

Use Keep a Changelog categories, adapted for SOAL:

| Category | SOAL Meaning | Examples |
|----------|-------------|----------|
| **Added** | New tables, ETLs, CSVs, skills, docs | "Added consumo_agriwin table (21k rows)" |
| **Changed** | Modified DDL, updated ETLs, schema changes | "Changed talhao_safras: added data_plantio_prevista" |
| **Fixed** | Bug fixes in ETLs, data corrections | "Fixed parceiros ETL column alignment" |
| **Removed** | Deprecated tables, deleted ETLs, removed CSVs | "Removed producao_ubg table (replaced by ticket_balancas)" |
| **Data** | New data imports, CSV updates | "Imported 6.331 compras insumos Castrolanda" |
| **Docs** | Documentation updates | "Updated GAP_ANALYSIS.md with 66 entities" |

---

## Step 3: Generate Entry

### Format

```markdown
## [version] — YYYY-MM-DD

### Added
- [description] ([scope]: DDL/ETL/CSV/Prisma/Doc)

### Changed
- [description] ([scope])

### Fixed
- [description] ([scope])

### Removed
- [description] ([scope])

### Data
- [description] — N records from [source]

### Metrics
| Metric | Previous | Current | Delta |
|--------|----------|---------|-------|
| DDL Tables | N | N | +N |
| DDL ENUMs | N | N | +N |
| Prisma Models | N | N | +N |
| Seeds (lines) | Nk | Nk | +Nk |
| Data (lines) | Nk | Nk | +Nk |
| ETL Scripts | N | N | +N |
| CSVs (active) | N | N | +N |
| Total Records | ~Nk | ~Nk | +Nk |
```

---

## Step 4: Write to CHANGELOG.md

Prepend the new entry to `CHANGELOG.md` (create if not exists):

**Location:** `09_Projetos/01_SOAL/CHANGELOG.md`

Keep entries in reverse chronological order (newest first).

### Version Numbering for SOAL

Since this is pre-production, use session-based versioning:
- Format: `v0.SESSION` (e.g., `v0.9`, `v0.10`)
- Session number from CLAUDE.md footer (`sessao N`)
- OR use date-based: `YYYY-MM-DD` when no version applies

---

## Step 5: Summary

Print a one-line summary suitable for commit messages:
```
changelog: vX.Y — [1-sentence summary of most important change]
```

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/CHANGELOG.md` | Changelog file (create if missing) |
| `CLAUDE.md` | Session number in footer |
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL metrics |
| `09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql` | Seeds metrics |
| `09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql` | Data metrics |
