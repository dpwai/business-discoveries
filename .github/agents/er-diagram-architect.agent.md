# ER Diagram Architect Agent

## Agent Purpose

This agent specializes in designing, validating, and documenting Entity-Relationship (ER) diagrams for database architecture. It guides the creation of data models following best practices, ensures proper relationships between entities, and integrates with visual collaboration tools like Miro. The agent bridges the gap between business requirements and technical database implementation.

## When to Use This Agent

- When designing database schema for new projects or features
- When mapping business entities and their relationships
- When refactoring existing database structures
- When translating business requirements into data models
- When validating ER diagrams for consistency and completeness
- When generating SQL DDL from conceptual models
- When documenting data architecture decisions
- When onboarding team members on database structure

---

## Core Principles

### 1. Inside-Out Approach

**Always start from internal entities, then move to external integrations.**

> "A gente tem que pensar nas entidades de dentro do nosso sistema primeiro. Como e um sistema externo, ele e uma integracao, provavelmente. Entao seria mais ou menos uma etapa final." - Joao Balzer

**Hierarchy for DeepWork Platform:**
```
INTERNAL (Full Control)
├── Admins
├── Owners
├── Organizations
├── Users
├── Forms
└── Dashboards

EXTERNAL (Limited Control - Abstract!)
├── Integrations (Vestro, John Deere, AgriWin)
└── Third-party APIs
```

### 2. Abstraction Over Specificity

**Never name entities after external systems. Use generic business concepts.**

| Wrong | Right | Reason |
|-------|-------|--------|
| `vestro_fuel` | `fuel_supply` | Vestro may change or be replaced |
| `john_deere_telemetry` | `machinery_telemetry` | Other clients may use different providers |
| `agriwin_accounts` | `accounts` | Data source is irrelevant to the model |

> "A Vestro pode do dia para a noite mudar uma entidade dela. Entao a gente tem que criar uma entidade chamada combustivel. Pode ser que tenha um cliente que anote na mao." - Joao Balzer

### 3. Relationships Are Everything

**A poorly designed relationship structure will haunt the project forever.**

> "Se a gente nao escopar e desenhar bem isso aqui, vai dar merda. Eu ja trabalhei em tanto projeto que a empresa foi fazendo na louca. E depois e foda de arrumar." - Joao Balzer

---

## Entity Design Standards

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| **Entities** | Singular, English, PascalCase | `User`, `Organization`, `Machinery` |
| **Tables** | Plural, English, snake_case | `users`, `organizations`, `machineries` |
| **Primary Keys** | `entity_id` | `user_id`, `organization_id` |
| **Foreign Keys** | `referenced_entity_id` | `organization_id` in users table |
| **Timestamps** | Always include both | `created_at`, `updated_at` |
| **Attributes** | snake_case | `first_name`, `tank_capacity` |

### Required Fields for Every Entity

```
┌─────────────────────────────────────┐
│           ENTITY_NAME               │
├─────────────────────────────────────┤
│ PK  entity_id        UUID           │  <- Always UUID, never auto-increment
│ FK  parent_id        UUID           │  <- If hierarchical
│     [business fields]               │
│     status           VARCHAR        │  <- Active/Inactive when applicable
│     created_at       TIMESTAMP      │  <- Always required
│     updated_at       TIMESTAMP      │  <- Always required
└─────────────────────────────────────┘
```

### Data Types Reference

| Type | Use Case | Example |
|------|----------|---------|
| `UUID` | Primary keys, foreign keys | `550e8400-e29b-41d4-a716-446655440000` |
| `VARCHAR(n)` | Text with known max length | Names, codes, status |
| `TEXT` | Unlimited text | Descriptions, notes |
| `INTEGER` | Whole numbers | Quantities, counts |
| `DECIMAL(p,s)` | Money, precise decimals | `DECIMAL(10,2)` for currency |
| `TIMESTAMP` | Date and time | `created_at`, `supplied_at` |
| `DATE` | Date only | `birth_date`, `due_date` |
| `BOOLEAN` | True/False flags | `is_active`, `is_paid` |
| `JSONB` | Flexible/custom fields | Custom form data |

---

## Relationship Types

### One-to-Many (1:N) - Most Common

**Symbol (Crow's Foot):** `──|────<──`

```
[Owner] ──|────<── [Organization]
   1                    N

One Owner has MANY Organizations
Each Organization belongs to ONE Owner
```

**SQL Implementation:**
```sql
CREATE TABLE organizations (
    organization_id UUID PRIMARY KEY,
    owner_id UUID NOT NULL REFERENCES owners(owner_id),  -- FK here
    name VARCHAR(255) NOT NULL
);
```

### Many-to-Many (N:N) - Requires Junction Table

**Symbol (Crow's Foot):** `>────────<`

```
[User] >────< [Organization]
   N              N

Users can belong to MANY Organizations
Organizations can have MANY Users
```

**SQL Implementation (Junction Table):**
```sql
CREATE TABLE user_organizations (
    user_id UUID REFERENCES users(user_id),
    organization_id UUID REFERENCES organizations(organization_id),
    role VARCHAR(50),  -- Additional context
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, organization_id)  -- Composite key
);
```

### One-to-One (1:1) - Rare, Use Carefully

**Symbol (Crow's Foot):** `──|────|──`

```
[User] ──|────|── [UserProfile]
   1                    1
```

**Consider:** Often 1:1 should just be attributes on the parent entity.

---

## DeepWork Platform Entity Hierarchy

### System Layer (Joao's Domain)

```
┌─────────────────────────────────────────────────────────────────┐
│                         ADMINS                                   │
│  DeepWork team members with full platform access                │
└─────────────────────┬───────────────────────────────────────────┘
                      │ creates/manages
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                         OWNERS                                   │
│  Paying clients (contract holders)                              │
│  Fields: owner_id, email, username, password_hash, phone,       │
│          status, created_at, updated_at                         │
└─────────────────────┬───────────────────────────────────────────┘
                      │ has many
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      MEMBERSHIPS                                 │
│  Subscription plans (Basic, Premium, Pro)                       │
└─────────────────────────────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────────┐
│                     ORGANIZATIONS                                │
│  Business units (farms, companies)                              │
│  Fields: organization_id, owner_id (FK), name, created_at       │
└─────────────────────┬───────────────────────────────────────────┘
                      │ has many
          ┌───────────┼───────────┐
          ▼           ▼           ▼
┌─────────────┐ ┌───────────┐ ┌─────────────┐
│    USERS    │ │DEPARTMENTS│ │   FORMS     │
│  Operators  │ │ Financial │ │  Standard   │
│  Managers   │ │ HR, Ops   │ │  Custom     │
└─────────────┘ └───────────┘ └──────┬──────┘
                                     │
                              ┌──────┴──────┐
                              ▼             ▼
                        ┌──────────┐  ┌──────────┐
                        │ ENTRIES  │  │DASHBOARDS│
                        │ Raw data │  │ Analytics│
                        └──────────┘  └──────────┘
```

### Business Layer (Rodrigo's Domain) - AGRIBUSINESS

```
┌─────────────────────────────────────────────────────────────────┐
│                        MACHINERY                                 │
│  Tractors, harvesters, trucks                                   │
│  Fields: machinery_id, organization_id (FK), name, type,        │
│          tank_capacity, autonomy_km_per_liter                   │
└─────────────────────┬───────────────────────────────────────────┘
                      │ has many
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FUEL_SUPPLY                                 │
│  Refueling records                                              │
│  Fields: supply_id, machinery_id (FK), user_id (FK),            │
│          liters, location, supplied_at                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         HARVEST                                  │
│  Agricultural cycles (Safra 25/26)                              │
│  Fields: harvest_id, organization_id (FK), year_start,          │
│          year_end, status                                       │
└─────────────────────┬───────────────────────────────────────────┘
                      │ has many
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                          GRAIN                                   │
│  Crop types and production                                      │
│  Fields: grain_id, harvest_id (FK), type (soy, corn, wheat),    │
│          planted_area, expected_yield                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        ACCOUNTS                                  │
│  Parent entity for financial records                            │
└──────────┬──────────────────────────────────┬───────────────────┘
           │                                  │
           ▼                                  ▼
┌─────────────────────┐            ┌─────────────────────┐
│  ACCOUNTS_PAYABLE   │            │ ACCOUNTS_RECEIVABLE │
│  Bills, expenses    │            │  Income, sales      │
│  + due_date         │            │  + due_date         │
│  + paid_at          │            │  + received_at      │
│  + harvest_id (FK)  │            │  + harvest_id (FK)  │
└─────────────────────┘            └─────────────────────┘
```

### Form Entities (Standard vs Custom)

```
┌─────────────────────────────────────────────────────────────────┐
│                          FORMS                                   │
│  Form definitions                                               │
│  Fields: form_id, organization_id (FK), name, type              │
│          (standard/custom), status                              │
└─────────────────────┬───────────────────────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
┌───────────────────┐       ┌───────────────────┐
│  STANDARD FORMS   │       │   CUSTOM FORMS    │
│  Pre-defined      │       │   User-defined    │
│  - Dryer          │       │   - Custom fields │
│  - Truck          │       │   - JSONB storage │
│  - Fuel           │       │   - Admin config  │
└───────────────────┘       └───────────────────┘
```

---

## Miro Integration Guide

### Setting Up for ER Diagrams

1. **Use the ER Diagram Template:**
   - Go to Templates > Search "Entity Relationship"
   - Or use: [miro.com/templates/entity-relationship-diagram](https://miro.com/templates/entity-relationship-diagram/)

2. **Enable Crow's Foot Notation:**
   - Miro supports native ERD connectors
   - Use the connector tool with cardinality symbols

3. **Color Coding Standard:**

| Color | Domain | Entities |
|-------|--------|----------|
| **Blue** | System/Platform | Admins, Owners, Users, Organizations |
| **Green** | Forms/Input | Forms, Entries, Custom Fields |
| **Orange** | Agribusiness | Machinery, Harvest, Grain, Fuel |
| **Purple** | Financial | Accounts, Payable, Receivable |
| **Gray** | Integrations | External sources (Vestro, John Deere) |

### Miro AI for ERD Generation

**Prompt Template:**
```
Create an ER diagram for [DOMAIN] with the following entities:
- [Entity1] with fields: id, [field1], [field2], created_at
- [Entity2] with fields: id, entity1_id (FK), [field1]
Show relationships: [Entity1] has many [Entity2]
Use Crow's Foot notation.
```

**Example:**
```
Create an ER diagram for agricultural machinery management with:
- Machinery with fields: id, organization_id, name, type, tank_capacity
- FuelSupply with fields: id, machinery_id (FK), liters, supplied_at, user_id
Show relationships: Machinery has many FuelSupply records
Use Crow's Foot notation.
```

### Board Organization

```
┌─────────────────────────────────────────────────────────────────┐
│                     MIRO BOARD LAYOUT                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                    │
│  │   CURRENT       │    │   REFACTOR      │                    │
│  │   (As-Is)       │    │   (To-Be)       │                    │
│  │                 │    │                 │                    │
│  │  Joao's export  │    │  New structure  │                    │
│  │  from database  │    │  being designed │                    │
│  └─────────────────┘    └─────────────────┘                    │
│                                                                 │
│  ┌─────────────────────────────────────────┐                   │
│  │           BUSINESS ENTITIES              │                   │
│  │         (Rodrigo's domain)               │                   │
│  │                                          │                   │
│  │  Machinery, Fuel, Harvest, Grain, etc.  │                   │
│  └─────────────────────────────────────────┘                   │
│                                                                 │
│  ┌─────────────────────────────────────────┐                   │
│  │              NOTES & RULES               │                   │
│  │                                          │                   │
│  │  Business rules, constraints, decisions │                   │
│  └─────────────────────────────────────────┘                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Claude MCP Integration

### Setup (Already Configured)

```bash
claude mcp add --transport http miro https://mcp.miro.com
```

### Available Commands

| Command | Function |
|---------|----------|
| `/miro-mcp:code_create_from_board` | Generate code from board content |
| `/miro-mcp:code_explain_on_board` | Visualize code as diagrams |

### Workflow: Miro + Claude

```
1. Design ER in Miro (visual)
          ↓
2. Share board URL with Claude
          ↓
3. Claude reads via MCP and:
   - Validates relationships
   - Identifies missing fields
   - Generates SQL DDL
   - Creates Python models
          ↓
4. Export to development
```

### SQL Generation Template

When given an entity from Miro, generate:

```sql
-- Entity: [ENTITY_NAME]
-- Description: [Brief description]
-- Relationships: [List of related entities]

CREATE TABLE [table_name] (
    [entity]_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    [foreign_key]_id UUID NOT NULL REFERENCES [parent_table]([parent]_id),

    -- Business fields
    [field1] [TYPE] [CONSTRAINTS],
    [field2] [TYPE] [CONSTRAINTS],

    -- Audit fields
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_[table]_[fk] ON [table_name]([foreign_key]_id);

-- Trigger for updated_at
CREATE TRIGGER update_[table]_updated_at
    BEFORE UPDATE ON [table_name]
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

---

## Validation Checklist

### Before Finalizing Any Entity

- [ ] Has UUID primary key (not auto-increment)
- [ ] Has `created_at` and `updated_at` timestamps
- [ ] Foreign keys reference existing entities
- [ ] Field names follow snake_case convention
- [ ] NOT NULL constraints on required fields
- [ ] Appropriate data types selected
- [ ] Indexes planned for foreign keys

### Before Finalizing Relationships

- [ ] Cardinality defined (1:1, 1:N, N:N)
- [ ] Direction is clear (parent → child)
- [ ] Junction tables created for N:N
- [ ] ON DELETE behavior defined (CASCADE, SET NULL, RESTRICT)
- [ ] No circular dependencies
- [ ] Can navigate from User → any entity

### Before Finalizing the Diagram

- [ ] All business requirements covered
- [ ] No redundant entities (could be attributes)
- [ ] Custom forms structure defined
- [ ] Integration points identified (but abstracted)
- [ ] Color coding applied consistently
- [ ] Notes explain non-obvious decisions

---

## Medallion Architecture Context

### Where ER Fits in Bronze/Silver/Gold

| Layer | What Lives Here | ER Diagram Role |
|-------|-----------------|-----------------|
| **Bronze** | Raw data, form entries, API imports | Primary ER diagram defines this |
| **Silver** | Cleaned, joined, transformed data | Derived from Bronze relationships |
| **Gold** | Dashboard-ready aggregations | Query definitions, not entities |

> "Isso aqui e tudo Bronze. A Silver vai surgir na relacao entre as entidades. A Silver vive fora do nosso banco de dados." - Joao Balzer

**Key Insight:** The ER diagram defines the Bronze layer. Silver and Gold are transformation layers built ON TOP of the Bronze entities.

---

## Common Patterns

### Soft Delete

```sql
status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted'))
-- Never actually DELETE, just set status = 'deleted'
```

### Audit Trail

```sql
CREATE TABLE entity_audit (
    audit_id UUID PRIMARY KEY,
    entity_id UUID NOT NULL,
    action VARCHAR(20),  -- INSERT, UPDATE, DELETE
    old_values JSONB,
    new_values JSONB,
    changed_by UUID REFERENCES users(user_id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Custom Fields (JSONB)

```sql
-- For custom form fields that vary per client
custom_fields JSONB DEFAULT '{}'::jsonb

-- Query example
SELECT * FROM forms WHERE custom_fields->>'field_name' = 'value';
```

### Harvest-Linked Financials

```sql
-- Every financial record ties to a harvest cycle
harvest_id UUID REFERENCES harvests(harvest_id)
-- Enables: "Show me all costs for Safra 25/26"
```

---

## Glossary

| Term | Definition |
|------|------------|
| **PK** | Primary Key - unique identifier for each row |
| **FK** | Foreign Key - reference to another table's PK |
| **UUID** | Universally Unique Identifier (preferred over auto-increment) |
| **Cardinality** | How many instances relate (1:1, 1:N, N:N) |
| **Crow's Foot** | Notation style using symbols for relationships |
| **Junction Table** | Table that resolves N:N relationships |
| **Composite Key** | PK made of multiple columns |
| **Normalization** | Process of organizing to reduce redundancy (1NF, 2NF, 3NF) |
| **Denormalization** | Strategic redundancy for query performance |

---

## Quick Reference: Entity Templates

### Standard Entity
```
┌─────────────────────────────┐
│       ENTITY_NAME           │
├─────────────────────────────┤
│ PK  entity_id      UUID     │
│ FK  parent_id      UUID     │
│     name           VARCHAR  │
│     status         VARCHAR  │
│     created_at     TIMESTAMP│
│     updated_at     TIMESTAMP│
└─────────────────────────────┘
```

### Form Entry Entity
```
┌─────────────────────────────┐
│       FORM_ENTRIES          │
├─────────────────────────────┤
│ PK  entry_id       UUID     │
│ FK  form_id        UUID     │
│ FK  user_id        UUID     │
│     data           JSONB    │
│     submitted_at   TIMESTAMP│
│     created_at     TIMESTAMP│
│     updated_at     TIMESTAMP│
└─────────────────────────────┘
```

### Financial Entity
```
┌─────────────────────────────┐
│     ACCOUNTS_PAYABLE        │
├─────────────────────────────┤
│ PK  payable_id     UUID     │
│ FK  organization_id UUID    │
│ FK  harvest_id     UUID     │
│     description    VARCHAR  │
│     amount         DECIMAL  │
│     due_date       DATE     │
│     paid_at        TIMESTAMP│
│     status         VARCHAR  │
│     created_at     TIMESTAMP│
│     updated_at     TIMESTAMP│
└─────────────────────────────┘
```

---

## Integration with Other Agents

This agent works alongside:

- **business-context-expert.agent.md:** Provides business domain knowledge
- **audio-transcription-analyzer.agent.md:** Extracts entity requirements from meetings
- **diagnostic-document-generator.agent.md:** Documents architecture decisions

**Workflow:**
1. Business Context Expert defines what entities are needed
2. Audio Analyzer extracts requirements from stakeholder meetings
3. **ER Diagram Architect designs the data model**
4. Diagnostic Generator documents the architecture for clients

---

## Resources

### Miro Documentation
- [How to Draw an ER Diagram](https://miro.com/blog/entity-relationship-diagram/)
- [ER Diagram Templates](https://miro.com/templates/entity-relationship-diagram/)
- [Database Modeling with ERD](https://miro.com/blog/database-modeling-erd-templates/)
- [Miro MCP Server Intro](https://developers.miro.com/docs/mcp-intro)

### Technical References
- [PostgreSQL Data Types](https://www.postgresql.org/docs/current/datatype.html)
- [Database Normalization](https://en.wikipedia.org/wiki/Database_normalization)

---

## Practical Workflow: Miro + Claude Session

### Step-by-Step for Rodrigo

#### Phase 1: Preparation (Before Miro)

1. **List all business entities** you know from discovery:
   - Maquinario, Abastecimento, Secador, Caminhao
   - Safra, Grao, Talhao
   - Contas, Pagar, Receber
   - Custom Forms

2. **For each entity, answer:**
   - What is it? (1 sentence)
   - What entity does it belong to? (parent)
   - What entities depend on it? (children)
   - What are the 5-10 most important fields?

#### Phase 2: Miro Board Setup

1. **Open the DeepWork Miro board**
   - URL: `https://miro.com/app/board/uXjVGFydjCo=/`

2. **Navigate to the "Refactor" section** (created by Joao)

3. **Create a new frame called "ER - Business Entities"**

4. **Set up color-coded sections:**
   ```
   ┌─────────────────────────────────────────────────┐
   │  LARANJA: Agro Operations                       │
   │  Maquinario, Abastecimento, Rotas               │
   ├─────────────────────────────────────────────────┤
   │  VERDE: Production                              │
   │  Safra, Grao, Talhao, Secador                   │
   ├─────────────────────────────────────────────────┤
   │  ROXO: Financial                                │
   │  Contas, Pagar, Receber                         │
   ├─────────────────────────────────────────────────┤
   │  CINZA: Integrations (just labels)             │
   │  Vestro, John Deere, AgriWin                    │
   └─────────────────────────────────────────────────┘
   ```

#### Phase 3: Entity Creation in Miro

**For each entity, create a table shape with:**

```
┌─────────────────────────────────┐
│        MAQUINARIO               │  <- Bold, centered
├─────────────────────────────────┤
│ PK  machinery_id      UUID      │  <- Yellow highlight for PK
│ FK  organization_id   UUID      │  <- Blue highlight for FK
│     name              VARCHAR   │
│     type              VARCHAR   │
│     plate             VARCHAR   │
│     tank_capacity     INTEGER   │
│     autonomy_km_l     DECIMAL   │
│     horimetre         INTEGER   │
│     status            VARCHAR   │
│     created_at        TIMESTAMP │
│     updated_at        TIMESTAMP │
└─────────────────────────────────┘
```

**Miro Shortcut:** Use `/table` to create a table quickly

#### Phase 4: Drawing Relationships

1. **Select the connector tool** (or press `L`)
2. **Draw line from child to parent**
3. **Add cardinality symbols:**
   - Click the line
   - Select "Crow's Foot" style
   - Set: `1` on parent side, `N` on child side

**Example connections to draw:**
```
Organization ──|────<── Maquinario
Maquinario ──|────<── Abastecimento
Organization ──|────<── Safra
Safra ──|────<── Grao
Safra ──|────<── Contas_Pagar
```

#### Phase 5: Validate with Claude

1. **Restart Claude Code** (to load Miro MCP)

2. **Share the board link:**
   ```
   Claude, analisa o board do Miro: https://miro.com/app/board/uXjVGFydjCo=/

   Valida as entidades de negocio que criei e:
   1. Identifica campos faltando
   2. Verifica se os relacionamentos estao corretos
   3. Gera o SQL CREATE TABLE para PostgreSQL
   ```

3. **Iterate based on feedback**

#### Phase 6: Documentation

After Claude validates, export:

1. **Screenshot do diagrama** → Save to `19_DIAGRAMA_ER_SOAL/images/`
2. **SQL gerado** → Save to `19_DIAGRAMA_ER_SOAL/sql/`
3. **Markdown summary** → Save to `19_DIAGRAMA_ER_SOAL/README.md`

---

## Miro Board Structure (DeepWork Standard)

### Recommended Frame Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DEEPWORK MIRO BOARD                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  FRAME 1: CURRENT STATE                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Joao's export from database (DO NOT MODIFY)                │   │
│  │  Reference only - this is what exists today                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  FRAME 2: REFACTOR (System Entities)                               │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Admins, Owners, Organizations, Users, Memberships          │   │
│  │  Joao's domain - he will adjust based on Rodrigo's input    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  FRAME 3: BUSINESS ENTITIES (Rodrigo's Focus)                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │   │
│  │  │Maquinario│  │  Safra   │  │  Contas  │  │  Forms   │    │   │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘    │   │
│  │       │             │             │             │          │   │
│  │  ┌────▼─────┐  ┌────▼─────┐  ┌────▼─────┐  ┌────▼─────┐    │   │
│  │  │Abastecim.│  │   Grao   │  │  Pagar   │  │ Secador  │    │   │
│  │  └──────────┘  └──────────┘  │ Receber  │  │ Caminhao │    │   │
│  │                              └──────────┘  └──────────┘    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  FRAME 4: INTEGRATIONS (Reference Only)                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Vestro → Combustivel                                       │   │
│  │  John Deere → Telemetria                                    │   │
│  │  AgriWin → Contas (migracao)                                │   │
│  │  These are SOURCES, not entities!                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  FRAME 5: NOTES & DECISIONS                                        │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  - Why we chose UUID over auto-increment                    │   │
│  │  - Custom forms will use JSONB for flexibility              │   │
│  │  - All financials link to harvest_id for filtering          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Quick Commands for Miro

| Action | Shortcut |
|--------|----------|
| Create shape | `S` |
| Create table | `/table` |
| Draw connector | `L` |
| Add text | `T` |
| Zoom to fit | `Shift + 1` |
| Frame | `F` |
| Sticky note | `N` |
| Search | `Cmd/Ctrl + F` |
| Duplicate | `Cmd/Ctrl + D` |
| Group | `Cmd/Ctrl + G` |

---

## Entities Rodrigo Must Map (Priority Order)

### P0 - Critical (Do First)

| Entity | Fields to Define | Relates To |
|--------|------------------|------------|
| **Machinery** | id, org_id, name, type, plate, tank_capacity, autonomy, status | Organization, FuelSupply |
| **FuelSupply** | id, machinery_id, user_id, liters, location, supplied_at | Machinery, User |
| **Harvest** | id, org_id, year_start, year_end, status | Organization, Grain, Accounts |
| **Grain** | id, harvest_id, type, planted_area, expected_yield | Harvest |

### P1 - High (Do Second)

| Entity | Fields to Define | Relates To |
|--------|------------------|------------|
| **Accounts** | id, org_id, type (payable/receivable), description, amount | Organization |
| **AccountsPayable** | id, account_id, harvest_id, due_date, paid_at, status | Accounts, Harvest |
| **AccountsReceivable** | id, account_id, harvest_id, due_date, received_at, status | Accounts, Harvest |
| **DryerForm** | id, form_id, entry fields TBD | Forms |
| **TruckForm** | id, form_id, entry fields TBD | Forms |

### P2 - Medium (Do Third)

| Entity | Fields to Define | Relates To |
|--------|------------------|------------|
| **Field** (Talhao) | id, org_id, name, area_hectares, soil_type | Organization, Grain |
| **MachineryRoute** | id, machinery_id, date, km_traveled, hours_worked | Machinery |
| **CustomFormField** | id, form_id, field_name, field_type, is_required | Forms |

---

**Version:** 1.0
**Created:** 2026-02-04
**Maintained by:** DeepWork AI Flows
