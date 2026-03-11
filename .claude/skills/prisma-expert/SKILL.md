---
name: prisma-expert
description: Prisma schema modeling, migrations, type-safe queries, and DDL sync. Use for schema changes, relation design, and keeping Prisma aligned with raw SQL.
disable-model-invocation: false
allowed-tools: Read, Grep, Bash, Glob, Write, Edit
argument-hint: "[task-description]"
---

# Prisma Expert — Schema Modeling & DDL Sync for SOAL

Expert in Prisma ORM — schema modeling, migrations, type-safe queries, and keeping Prisma schema in sync with raw PostgreSQL DDL.

**Task:** `$ARGUMENTS`

**Source:** Adapted from 0xfurai/claude-code-subagents (prisma-expert)

---

## SOAL Context

- **Prisma schema:** `09_Projetos/01_SOAL/DDL/prisma/schema.prisma`
- **Current state:** 66 models, 45 enums, complete relations
- **Raw DDL:** `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` (source of truth)
- **Rule:** DDL is the source of truth. Prisma MUST match DDL, not the other way around.

---

## SOAL Prisma Conventions

### Model Naming
```prisma
model TalhaoSafra {
  @@map("talhao_safras")  // DDL table name (plural snake_case)
}
```

### Field Naming
```prisma
model TalhaoSafra {
  talhao_safra_id  String   @id @default(dbgenerated("gen_random_uuid()")) @db.Uuid
  safra_id         String   @db.Uuid
  talhao_id        String   @db.Uuid
  organization_id  String   @db.Uuid
  status           String   @default("active") @db.VarChar(20)
  created_at       DateTime @default(now()) @db.Timestamptz
  updated_at       DateTime @default(now()) @updatedAt @db.Timestamptz

  // Relations
  safra        Safra        @relation(fields: [safra_id], references: [safra_id])
  talhao       Talhao       @relation(fields: [talhao_id], references: [talhao_id])
  organization Organization @relation(fields: [organization_id], references: [organization_id])
}
```

### Type Mappings (DDL → Prisma)

| PostgreSQL | Prisma | Decorator |
|-----------|--------|-----------|
| `UUID` | `String` | `@db.Uuid` |
| `VARCHAR(n)` | `String` | `@db.VarChar(n)` |
| `TEXT` | `String` | (none needed) |
| `INTEGER` | `Int` | (none needed) |
| `NUMERIC(p,s)` | `Decimal` | `@db.Decimal(p,s)` |
| `BOOLEAN` | `Boolean` | (none needed) |
| `DATE` | `DateTime` | `@db.Date` |
| `TIMESTAMP WITH TIME ZONE` | `DateTime` | `@db.Timestamptz` |
| `JSONB` | `Json` | `@db.JsonB` |
| Custom ENUM | `EnumName` | (use Prisma enum) |

### Enum Mapping
```prisma
enum TipoCultura {
  graos
  oleaginosa
  cobertura
  forrageira
  pastagem
  florestal
  fibra
  outros

  @@map("tipo_cultura")  // DDL CREATE TYPE name
}
```

---

## Focus Areas

### Schema Modeling
- Every model must have `@@map()` pointing to DDL table name
- Every enum must have `@@map()` pointing to DDL type name
- Relations must use explicit `fields` and `references`
- `@relation` name only needed for ambiguous relations (multiple FKs to same table)

### DDL ↔ Prisma Sync Workflow

When DDL changes:
1. Read the changed `CREATE TABLE` / `ALTER TABLE` in DDL
2. Update the corresponding Prisma model
3. Verify type mappings, nullability, defaults
4. Verify relations match FK constraints
5. Run `/ddl-consistency` to cross-validate

When Prisma changes (rare — DDL is source of truth):
1. Generate migration SQL: `npx prisma migrate dev --create-only`
2. Review generated SQL against DDL conventions
3. Apply to DDL file manually (never auto-apply)

### Advanced Querying
- Use `include` for eager loading relations (avoid N+1)
- Use `select` to fetch only needed fields
- Use `where` with compound filters for complex queries
- Use raw queries (`$queryRaw`) for CTEs, window functions, complex joins
- Review generated SQL: `prisma.$on('query', console.log)`

### Transactions
```typescript
await prisma.$transaction([
  prisma.talhaoSafra.update({ ... }),
  prisma.operacaoCampo.create({ ... }),
]);
```

### Performance
- Add `@@index` for frequently queried fields
- Use `@@unique` for business-level unique constraints
- Compound indexes: `@@index([safra_id, talhao_id])`

---

## Quality Checklist

- [ ] Every DDL table has a corresponding Prisma model
- [ ] Every DDL enum has a corresponding Prisma enum
- [ ] `@@map()` values match DDL names exactly
- [ ] All UUID fields use `@db.Uuid`
- [ ] All timestamp fields use `@db.Timestamptz`
- [ ] All relations have explicit `fields` and `references`
- [ ] Nullability matches DDL (NOT NULL → no `?` in Prisma)
- [ ] Default values match DDL
- [ ] No orphan models (every model has at least org relation)

---

## Reference Files

| File | Purpose |
|------|---------|
| `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | Prisma schema (66 models) |
| `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | DDL source of truth |
| `CLAUDE.md §3` | Naming conventions |
