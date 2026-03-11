---
name: etl-scaffold
description: Generate a Python ETL script skeleton following the SOAL project pattern. Use when creating a new ETL for a data source.
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Grep
argument-hint: "<source-description> [output-csv-name]"
---

# ETL Scaffold — Python ETL Generator

Generate a Python ETL script following the established pattern of the 33+ existing SOAL ETLs.

**Source description:** `$ARGUMENTS` (what data source to process, optionally followed by output CSV name)

---

## Step 1: Understand the Source

Ask/infer from the description:
1. **Source type:** Excel (.xlsx/.xls), HTML-as-xls, PDF, CSV, API response
2. **Source location:** Path relative to `09_Projetos/01_SOAL/DATA/`
3. **Target table(s):** Which DDL table(s) this feeds
4. **Output CSV:** Name and fase folder (e.g., `fase_4/19_new_data.csv`)
5. **Complexity:** Single sheet? Multi-sheet? Multi-file?

---

## Step 2: Choose the Right Pattern

Based on source type, use the closest existing ETL as template:

| Source Type | Reference ETL | Key Pattern |
|-------------|--------------|-------------|
| Excel single sheet | `etl_castrolanda_extrato.py` | pandas read, clean, transform, write |
| Excel multi-sheet | `etl_fsi_contas.py` | openpyxl, iterate sheets, merge |
| Excel multi-file | `etl_pesagens.py` | glob files, iterate with utils |
| HTML-as-xls | `etl_castrolanda_capital_html.py` | BeautifulSoup parse |
| Legacy .xls | `etl_agricola_utils.py` | xlrd via XlrdSheetAdapter |
| CSV transform | `etl_parceiros.py` | pandas read_csv, transform |

---

## Step 3: Generate the ETL Script

### Mandatory Structure

Every ETL MUST follow this skeleton:

```python
#!/usr/bin/env python3
"""
ETL: [Source Name] → [Output CSV(s)]

Source: [source file/folder description]
Output: IMPORTS/[fase]/[NN]_[name].csv

Execute: python3 [script_name].py
"""

import csv
from pathlib import Path
# Add: pandas, openpyxl, xlrd, re, datetime as needed

# ─── Paths ────────────────────────────────────────────────────────────────────

BASE_DIR = Path(__file__).parent
SOURCE = BASE_DIR / "[source_file_or_folder]"
OUTPUT = BASE_DIR.parent / "IMPORTS" / "[fase_N]" / "[NN]_[name].csv"

# ─── Helpers ──────────────────────────────────────────────────────────────────

def clean_str(s):
    """Strip and normalize string value."""
    if s is None:
        return ''
    return str(s).strip()


def clean_numeric(val):
    """Convert cell value to float, handling Brazilian format."""
    if val is None:
        return None
    if isinstance(val, (int, float)):
        return round(float(val), 2)
    s = str(val).strip().replace('\xa0', '').replace(' ', '')
    if not s or s in ('', '-', '#VALUE!', '#REF!', '#DIV/0!'):
        return None
    # Brazilian format: 1.234,56
    if ',' in s:
        s = s.replace('.', '').replace(',', '.')
    try:
        return round(float(s), 2)
    except ValueError:
        return None


# ─── Main ETL ─────────────────────────────────────────────────────────────────

def main():
    print(f"[ETL] Reading source: {SOURCE}")

    # 1. READ source
    # ... (source-specific reading logic)

    # 2. TRANSFORM
    records = []
    skipped = 0
    errors = []

    # ... (transformation logic)
    # For each record:
    #   - Clean strings (clean_str)
    #   - Parse numbers (clean_numeric)
    #   - Parse dates (YYYY-MM-DD format)
    #   - Validate against expected values
    #   - Append to records or increment skipped

    # 3. WRITE output CSV
    if not records:
        print("[ETL] ERROR: No records extracted!")
        return

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)

    fieldnames = list(records[0].keys())
    with open(OUTPUT, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(records)

    # 4. QC CHECKS
    print(f"\n{'='*60}")
    print(f"[QC] Output: {OUTPUT}")
    print(f"[QC] Records: {len(records)}")
    print(f"[QC] Skipped: {skipped}")
    if errors:
        print(f"[QC] Errors: {len(errors)}")
        for e in errors[:10]:
            print(f"  - {e}")
    print(f"{'='*60}")

    # 5. VALIDATION CHECKS
    _run_qc(records)


def _run_qc(records):
    """Run quality control checks on extracted records."""
    checks_passed = 0
    checks_total = 0

    # Check 1: No empty required fields
    # Check 2: Numeric ranges make sense
    # Check 3: Dates in expected range
    # Check 4: No duplicate keys
    # Check 5: Enum values valid
    # ... (add domain-specific checks)

    print(f"\n[QC] {checks_passed}/{checks_total} checks PASSED")


if __name__ == '__main__':
    main()
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Script name | `etl_[source_name].py` | `etl_castrolanda_extrato.py` |
| Output CSV | `[NN]_[table_name].csv` | `15_ticket_balancas.csv` |
| Section separators | `# ─── Title ───...` (80 chars) | See existing ETLs |
| Print prefixes | `[ETL]`, `[QC]`, `[WARN]` | Consistent logging |

### CSV Output Rules

- **Header:** snake_case matching DDL column names
- **Encoding:** UTF-8, no BOM
- **Delimiter:** comma (never semicolon)
- **Dates:** YYYY-MM-DD format
- **Numbers:** Decimal point (not comma), no thousands separator
- **Empty values:** Empty string (not NULL, not "None")
- **Booleans:** true/false (lowercase)
- **Enums:** Lowercase matching DDL CREATE TYPE values

---

## Step 4: Place the File

| Source Domain | Script Location |
|--------------|----------------|
| Agricultura | `DATA/AGRICULTURA/` |
| Castrolanda | `DATA/CASTROLANDA/` |
| Maquinario/Vestro | `DATA/MAQUINÁRIO/` |
| Org/territorial | `DATA/ORG/` |
| RH/folha | `DATA/RH/` |
| Parceiros | `DATA/PARCEIROS_PESSOAS/` |
| Insumos | `DATA/INSUMOS/` |
| UBG | `DATA/UBG/` |
| Financeiro | `DATA/FINANCEIRO/` |

---

## Step 5: Post-Generation Checklist

After generating the ETL, remind to:

- [ ] Run `python3 [script].py` and verify output
- [ ] Check output CSV with `/validate-csv` skill
- [ ] Add entry to `DATA/ETL_REGISTRY.md`
- [ ] Add CSV to `generate_inserts.py` if it feeds INSERT scripts
- [ ] Run `/sync-docs` if DDL or metrics changed

---

## Reference Files

| File | Purpose |
|------|---------|
| `DATA/AGRICULTURA/etl_agricola_utils.py` | Shared helpers (to_float, open_workbook, etc.) |
| `DATA/CASTROLANDA/etl_castrolanda_extrato.py` | Pattern: HTML-as-xls → CSV |
| `DATA/FINANCEIRO/etl_fsi_contas.py` | Pattern: multi-sheet Excel → multiple CSVs |
| `DATA/AGRICULTURA/etl_pesagens.py` | Pattern: multi-file with shared utils |
| `DATA/ETL_REGISTRY.md` | Registry of all CSVs |
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL (target schema) |
