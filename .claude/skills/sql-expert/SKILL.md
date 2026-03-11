---
name: sql-expert
description: PostgreSQL expert for schema design, query optimization, indexing strategies, migrations, and runtime performance. Use for DDL authoring, EXPLAIN analysis, and production-ready SQL.
disable-model-invocation: false
allowed-tools: Read, Grep, Bash, Glob, Write, Edit
argument-hint: "[query-or-task-description]"
---

# SQL Expert — PostgreSQL Mastery for SOAL

Expert in PostgreSQL database management, optimization, and schema design — adapted to the SOAL project conventions.

**Task:** `$ARGUMENTS`

**Source:** Adapted from 0xfurai/claude-code-subagents (postgres-expert) + alirezarezvani/claude-skills (database-schema-designer)

---

## SOAL Context (always apply)

- **DDL location:** `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql`
- **Current state:** 66 tables, 45 ENUMs, 4 views, 6 functions, 190 indexes, 57 triggers
- **PK convention:** `entidade_id UUID DEFAULT gen_random_uuid()` — NEVER auto-increment
- **Table naming:** plural snake_case (`talhao_safras`, `operacoes_campo`)
- **Entity naming:** UPPER_SNAKE_CASE singular (`TALHAO_SAFRA`)
- **Mandatory columns:** `organization_id UUID`, `status VARCHAR(20) DEFAULT 'active'`, `created_at`, `updated_at`
- **Trigger:** All tables use `fn_atualizar_updated_at()` for `updated_at`
- **org_id rule:** Always present in DDL, NEVER drawn in ER diagrams
- **Dijkstra FK rule:** See CLAUDE.md §4.1 before adding any FK

---

## Focus Areas

### Schema Design
- Normalize to 3NF, denormalize only with `-- DENORM` comment
- Follow Medallion Architecture: Bronze (raw) → Silver (clean) → Gold (analytics)
- Multi-tenancy via `organization_id` on every table
- Soft delete via `status` column (never hard delete in Bronze)
- UUIDs for all PKs — enables distributed inserts without coordination

### Query Optimization
- Analyze execution plans with `EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)`
- Index strategy: B-tree for equality/range, GIN for arrays/JSONB, GiST for geo
- Composite indexes: most selective column first
- Partial indexes for filtered queries (e.g., `WHERE status = 'active'`)
- Cover indexes to avoid heap lookups

### Indexing (SOAL has 190 indexes)
- Every FK column gets an index (already done in DDL)
- Composite indexes for common query patterns
- Check for unused indexes: `pg_stat_user_indexes WHERE idx_scan = 0`
- Check for missing indexes: `pg_stat_user_tables WHERE seq_scan > idx_scan`

### Migrations
- Generate forward migration SQL (CREATE/ALTER)
- Generate rollback SQL (DROP/ALTER reverse)
- Order: ENUMs → tables → indexes → triggers → views → functions
- Test with `BEGIN; ... ROLLBACK;` before applying

### Performance
- Connection pooling (PgBouncer recommended)
- VACUUM and ANALYZE scheduling
- Table partitioning for large tables (consumo_agriwin: 21k+ rows growing)
- Materialized views for Gold layer aggregations

---

## Quality Checklist

- [ ] All PKs are UUID with `DEFAULT gen_random_uuid()`
- [ ] All tables have `organization_id`, `status`, `created_at`, `updated_at`
- [ ] All FKs have corresponding indexes
- [ ] No redundant FKs (Dijkstra check passed)
- [ ] ENUM values are lowercase snake_case
- [ ] Trigger `fn_atualizar_updated_at()` attached to every table
- [ ] CHECK constraints for business rules (e.g., `area_ha > 0`)
- [ ] ON DELETE behavior explicitly set on all FKs
- [ ] Comments on complex columns/functions
- [ ] Migration is reversible

---

## Common SOAL Queries

### Hub entity: TALHAO_SAFRA (90% of reports)
```sql
-- Custeio por talhao/safra
SELECT ts.*, s.nome AS safra, t.nome AS talhao, c.nome AS cultura
FROM talhao_safras ts
JOIN safras s ON s.safra_id = ts.safra_id
JOIN talhoes t ON t.talhao_id = ts.talhao_id
JOIN culturas c ON c.cultura_id = ts.cultura_id
WHERE ts.organization_id = $1 AND ts.status = 'active';
```

### Window functions for time-series
```sql
-- Running total combustivel por maquina
SELECT m.nome, a.data_abastecimento, a.litros,
  SUM(a.litros) OVER (PARTITION BY a.maquina_id ORDER BY a.data_abastecimento) AS litros_acumulado
FROM abastecimentos a
JOIN maquinas m ON m.maquina_id = a.maquina_id;
```

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL source of truth |
| `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | Prisma schema (must stay in sync) |
| `CLAUDE.md §3-4` | Naming conventions + ER rules |
| `.github/agents/ddl-database-engineer.agent.md` | Full DDL context |
