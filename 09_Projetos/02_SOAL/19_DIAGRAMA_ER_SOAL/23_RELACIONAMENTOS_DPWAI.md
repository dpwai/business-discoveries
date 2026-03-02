# RELACIONAMENTOS COMPLETOS - Modulo DPWAI/Sistema

**Data:** 12/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ= (Frame 5: Entidade DPWAI)
**Referencia:** Doc 05 (Mapeamento Completo), Doc 08 (Estrutura ER), Doc 22 (UBG — CUSTOM_FORMS/FORM_ENTRIES)

---

## 1. Escopo do Modulo

### Entidades Mapeadas (11 RBAC + 2 Formularios)

```
ADMINS ───────────── Administradores DeepWork (nivel mais alto, sem FK externo)
OWNERS ───────────── Proprietarios clientes (pagam a plataforma)
ORGANIZATIONS ────── Organizacao/empresa tenant (fazendas, empresas)
ORGANIZATION_SETTINGS ── Configuracoes por org (JSONB, 1:1)
USERS ────────────── Usuarios dentro de uma org (operadores, gestores, admins locais)
ROLES ────────────── Papeis de acesso (templates de permissao)
PERMISSIONS ──────── Permissoes granulares (recurso + acao)
USER_ROLES ───────── Junction: usuario ↔ papel (N:N)
ROLE_PERMISSIONS ─── Junction: papel ↔ permissao (N:N)
USER_PERMISSIONS ─── Junction: usuario ↔ permissao direta (N:N, bypass roles)
INVITE_TOKENS ────── Tokens de convite para onboarding de usuarios
CUSTOM_FORMS ─────── Formularios customizados (ja mapeado Doc 22 — frame UBG)
FORM_ENTRIES ─────── Respostas dos formularios (ja mapeado Doc 22 — frame UBG)
```

### IMPORTANTE: Correcao do Grafo de Adjacencia

> **ACHADO CRITICO:** A secao DPWAI no grafo de adjacencia (agent file v1.5) tem as direcoes de FK INVERTIDAS. As setas seguem o diagrama hierarquico do Doc 08 (top-down), nao a convencao FK do Dijkstra (entidade que CONTEM o FK aponta para entidade referenciada).

| Adjacencia Atual (ERRADA) | Correcao (FK real) | Motivo |
|---------------------------|-------------------|--------|
| ADMINS → [OWNERS] | ADMINS → [] | ADMINS nao tem FK para OWNERS. Relacao e operacional (admin cria owner via API) |
| OWNERS → [ORGANIZATIONS] | OWNERS → [] | OWNERS nao tem FK para ORGANIZATIONS. E ao contrario: ORGANIZATIONS.owner_id → OWNERS |
| ORGANIZATIONS → [FAZENDAS, USERS] | ORGANIZATIONS → [OWNERS] | FAZENDAS e USERS apontam PARA ORGANIZATIONS, nao o contrario. ORGANIZATIONS.owner_id → OWNERS |
| USERS → [ROLES] | USERS → [ORGANIZATIONS] | USER_ROLES junction table tem os FKs, nao USERS direto. USERS.organization_id e o FK real |
| ROLES → [PERMISSIONS] | ROLES → [] | ROLE_PERMISSIONS junction table tem os FKs, nao ROLES direto |

### Estado Atual no Miro (capturado via API 12/02/2026)

**Frame:** Entidade DPWAI (ID: 3458764658863283934)
**Posicao:** (15118, 9469) | **Tamanho:** 3158 x 2024
**3 shapes (todos unsupported) + 3 text labels + 1 text label**
**4 connectors (1 com label "cria", 3 sem label)**

**Shapes identificados por posicao e texto adjacente:**

| Shape ID | Posicao | Texto Proximo | Entidade Provavel |
|----------|---------|---------------|-------------------|
| 3458764658641289732 | (2077, 1468) | "DPWAI" | ORGANIZATIONS (ou grupo RBAC) |
| 3458764658863129275 | (347, 1606) | "funcionarios dpwai" / "contatos dpwai" | USERS (ou grupo funcional) |
| 3458764659028630797 | (764, 961) | (nenhum adjacente claro) | Entidade intermediaria |

**Texto labels no frame:**
- "DPWAI" — identificador principal
- "contrato dpwai" — referencia a contrato DeepWork com clientes
- "funcionarios dpwai" — referencia a equipe interna
- "contatos dpwai" — referencia a contatos da plataforma

**Connectors:**

| # | De → Para | Label | Direcao |
|---|-----------|-------|---------|
| 1 | 732 → 733(ext) | "cria" | EXTERNAL — provavel ORGANIZATIONS "cria" FAZENDAS |
| 2 | 275 → 690(ext) | "" | EXTERNAL — shape DPWAI → entidade frame CLIENTE |
| 3 | 797 → (vazio) | "" | EXTERNAL — conector pendente (dangling) |
| 4 | 733(ext) → 797 | "" | EXTERNAL — entidade externa → shape DPWAI |

> **Nota:** O frame DPWAI e o mais SIMPLES no board — 3 shapes representando agrupamentos conceituais, nao entidades individuais. Os 11 entities de RBAC existem na documentacao (Docs 05, 08) mas NAO estao detalhados no Miro como shapes individuais. Este modulo sera o primeiro onde o board precisa ser EXPANDIDO significativamente.

---

## 2. Relacionamentos Internos (dentro da Camada Sistema)

---

### D01: ORGANIZATIONS -> OWNERS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `organizations.owner_id` -> `owners.id` |
| **Card.** | N:1 (muitas orgs por owner, embora tipicamente 1:1 para fazendas) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Board** | NAO EXISTE como conector individual — frame tem representacao conceitual |

**Por que funciona:** Owner e o cliente pagante da DeepWork. Uma org (fazenda/empresa) pertence a um owner. Claudio pode ter Fazenda SOAL + Fazenda Sao Joao como ORGANIZATIONS distintas sob o mesmo OWNER.

**Dijkstra:** Caminho unico ORGANIZATIONS → OWNERS. **ESSENCIAL.**

---

### D02: ORGANIZATION_SETTINGS -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `organization_settings.organization_id` -> `organizations.id` |
| **Card.** | 1:1 (cada org tem exatamente um registro de settings) |
| **Obrigatoria** | Sim |
| **ON DELETE** | CASCADE |
| **Board** | NAO EXISTE — criar |

**Por que funciona:** Configuracoes especificas por org: moeda, fuso horario, feature flags, preferencias de UI. JSONB permite flexibilidade sem schema changes.

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### D03: USERS -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `users.organization_id` -> `organizations.id` |
| **Card.** | N:1 (muitos usuarios por org) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Board** | Provavel conector 275 → 690 (EXTERNAL) — verificar |

**Por que funciona:** Todo usuario pertence a exatamente uma organizacao. Josmar (operador UBG) pertence a SOAL. Valentina (financeiro) pertence a SOAL. E o vinculo de emprego/acesso.

**NOTA ESPECIAL:** Este FK e organization_id, mas NAO segue a convencao de "nao desenhar org_id". Para entidades da Camada Sistema, organization_id E o relacionamento de negocio primario (usuario PERTENCE a org), nao apenas filtro multi-tenancy. **DESENHAR.**

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### D04: USER_ROLES -> USERS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `user_roles.user_id` -> `users.id` |
| **Card.** | N:1 (muitas atribuicoes por usuario) |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

---

### D05: USER_ROLES -> ROLES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `user_roles.role_id` -> `roles.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

**D04 + D05 juntos:** USER_ROLES e tabela junction (N:N). Composite PK: (user_id, role_id). Campo adicional: `granted_at` (TIMESTAMP), `granted_by` FK → USERS (audit trail).

---

### D06: ROLE_PERMISSIONS -> ROLES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `role_permissions.role_id` -> `roles.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

---

### D07: ROLE_PERMISSIONS -> PERMISSIONS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `role_permissions.permission_id` -> `permissions.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

**D06 + D07 juntos:** ROLE_PERMISSIONS e tabela junction (N:N). Composite PK: (role_id, permission_id). Define quais permissoes cada papel tem.

---

### D08: USER_PERMISSIONS -> USERS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `user_permissions.user_id` -> `users.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

---

### D09: USER_PERMISSIONS -> PERMISSIONS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `user_permissions.permission_id` -> `permissions.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

**D08 + D09 juntos:** USER_PERMISSIONS e junction para atribuicao DIRETA de permissao, bypassing roles. Para excecoes temporarias ou acesso granular. Campos: `granted_at`, `granted_by` (audit).

---

### D10: INVITE_TOKENS -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `invite_tokens.organization_id` -> `organizations.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar |

**Por que funciona:** Token de convite vinculado a uma org. Quando aceito, cria USERS nessa org. Campos: token (unique), email_convidado, status (pendente/aceito/expirado), expira_em, criado_por_id.

---

### D11: INVITE_TOKENS -> USERS (criador)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `invite_tokens.criado_por_id` -> `users.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Nao (pode ser criado por admin do sistema) |
| **Board** | NAO EXISTE — criar |

**Dijkstra:** Sem caminho alternativo. **ESSENCIAL.**

---

### D12: CUSTOM_FORMS -> FORM_ENTRIES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `form_entries.form_id` -> `custom_forms.id` |
| **Board** | EXISTS (Doc 22, U09 — frame UBG) |

**Nota:** Ja mapeado completamente no Doc 22. Nao duplicar aqui.

---

### D13: FORM_ENTRIES -> USERS (submitter)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `form_entries.user_id` -> `users.id` |
| **Card.** | N:1 |
| **Board** | NAO EXISTE — criar (tracejada azul DPWAI → UBG frame) |

**Por que funciona:** Rastreabilidade: quem preencheu o formulario. Josmar preenche form_dryer, Valentina preenche form_accounts_payable.

---

### D14: CUSTOM_FORMS -> USERS (criador)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `custom_forms.criado_por_id` -> `users.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Nao |
| **Board** | NAO EXISTE — opcional (audit FK, avaliar se desenhar) |

---

## 3. Relacionamentos Externos (cross-frame)

---

### D15: ORGANIZATIONS -> FAZENDAS (ownership)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `fazendas.organization_id` -> `organizations.id` |
| **Card.** | 1:N (uma org tem muitas fazendas) |
| **Board** | Provavel conector "cria" (732 → 733) |
| **Status** | Ja na tabela Cross-Frame Connectors (DRAW) |

**Nota:** FK vive na FAZENDAS (fazendas.organization_id), mas a seta no diagrama sai de ORGANIZATIONS → FAZENDAS representando "org possui fazendas". Este e o unico cross-frame desenhado para org_id — porque e ownership real, nao filtro.

---

### D16: USERS referenciado por entidades externas

USERS e referenciado por multiplas entidades como FK de audit/operador:
- MOVIMENTACAO_INSUMO.user_id (Doc 17)
- FORM_ENTRIES.user_id (Doc 22)
- USER_ROLES.granted_by (interno)
- USER_PERMISSIONS.granted_by (interno)
- INVITE_TOKENS.criado_por_id (interno)

**Decisao:** FKs de audit (granted_by, criado_por_id) sao OPCIONAIS e de menor importancia visual. Desenhar apenas os FKs de negocio (FORM_ENTRIES.user_id). Para os demais, comentar no DDL.

---

## 4. Analise de Redundancia (Dijkstra)

### Redundantes — NAO Desenhar

| FK Removido | Caminho Alternativo | Hops | Pattern |
|------------|-------------------|------|---------|
| USER_ROLES → ORGANIZATIONS | USER_ROLES → USERS → ORGANIZATIONS | 2 | Transitive closure |
| USER_PERMISSIONS → ORGANIZATIONS | USER_PERMISSIONS → USERS → ORGANIZATIONS | 2 | Transitive closure |
| INVITE_TOKENS → OWNERS | INVITE_TOKENS → ORGANIZATIONS → OWNERS | 2 | Transitive closure |
| ORGANIZATION_SETTINGS → OWNERS | ORG_SETTINGS → ORGANIZATIONS → OWNERS | 2 | Transitive closure |
| ROLE_PERMISSIONS → ORGANIZATIONS | Roles sao system-wide, nao scoped por org | N/A | Nao aplicavel |

### DDL Denormalization (nao no diagrama)

| FK | Justificativa DDL | Derivavel Via |
|----|-------------------|---------------|
| ROLES.organization_id | Se roles forem org-scoped (decisao aberta) | ROLES sao system-wide por padrao |
| USER_ROLES.granted_by → USERS | Audit trail, nao business logic | Consulta audit log |

### ADMINS -> OWNERS: NAO E FK

A cadeia ADMINS → OWNERS → ORGANIZATIONS do Doc 08 e HIERARQUICA (quem pode criar quem), nao FK. ADMINS e OWNERS sao pools de usuarios separados:
- ADMINS = equipe DeepWork (Rodrigo, Joao)
- OWNERS = clientes pagantes (Claudio)

Nao existe `owners.admin_id` ou `admins.owner_id`. A criacao de OWNERS e feita via endpoint administrativo, sem FK persistente.

### Org_id (NAO desenhar — com excecoes)

Convencao: org_id nao e desenhado. **EXCECOES para Camada Sistema:**
- USERS.organization_id → ORGANIZATIONS: **DESENHAR** (e business relationship, nao filtro)
- FAZENDAS.organization_id → ORGANIZATIONS: **DESENHAR** (ownership, ja na Cross-Frame table)
- CUSTOM_FORMS.organization_id: NAO desenhar (e filtro)
- INVITE_TOKENS.organization_id → ORGANIZATIONS: **DESENHAR** (token pertence a org)

---

## 5. Entidades de Doc 05 NAO em Doc 08

Doc 05 define 4 entidades adicionais que NAO aparecem no Doc 08 (master reference):

| Entidade Doc 05 | Funcao | Status |
|-----------------|--------|--------|
| PERFIS | Perfil estendido do usuario (foto, cargo, preferencias JSONB) | Provavel drop — dados podem viver em USERS |
| SESSOES | Sessoes de login (token, IP, user_agent, expira_em) | Provavel infra — nao e ER de negocio |
| DEPARTMENTS | Areas/departamentos da org | Pode ser util — mas nao validado |
| AREA_USUARIOS | Junction USERS ↔ DEPARTMENTS (N:N) | Depende de DEPARTMENTS |

**Recomendacao:** Validar com Joao se estas 4 entidades devem ser incluidas. PERFIS pode ser um JSONB em USERS. SESSOES e infra (Redis/JWT, nao banco). DEPARTMENTS/AREA_USUARIOS precisa de caso de uso claro.

---

## 6. Questoes Abertas

| # | Questao | Impacto | Quem Decide |
|---|---------|---------|-------------|
| 1 | ROLES sao system-wide ou org-scoped? | Se org-scoped, ROLES precisa de organization_id FK | Joao |
| 2 | ADMINS e OWNERS compartilham tabela de auth ou sao separados? | Se separados, nao ha FK entre eles. Se unificados (tipo_usuario ENUM), simplifica. | Joao |
| 3 | PERFIS existe como entidade ou campos em USERS? | Separar permite evolucao independente. Mergir simplifica. | Joao |
| 4 | SESSOES e entidade ER ou infra (Redis/JWT)? | Se JWT stateless, nao precisa de entidade. Se session-based, precisa. | Joao |
| 5 | DEPARTMENTS/AREA_USUARIOS necessarios? | Se orgs pequenas (< 20 usuarios), nao precisa. Se grandes, sim. | Rodrigo + Joao |
| 6 | "contrato dpwai" (texto no board) — existe entidade CONTRATO_DPWAI? | Se DeepWork cobra por org/modulo, pode precisar de entidade para billing. | Rodrigo |
| 7 | PERMISSIONS sao fixas (seed) ou customizaveis por org? | Se fixas, PERMISSIONS e root entity. Se customizaveis, precisa org_id. | Joao |

---

## 7. Mapa de Conexoes

```
                    ADMINS (standalone)          OWNERS (standalone)
                         |                          ▲
                         | (cria via API,            | owner_id
                         |  sem FK)                  |
                         ▼                     ORGANIZATIONS
                       OWNERS                     │    │
                                                  │    └──► ORGANIZATION_SETTINGS (1:1)
                                                  │
                                              org_id │
                              ┌───────────────┬───┼───────────┐
                              ▼               ▼   ▼           ▼
                           USERS       INVITE_TOKENS     FAZENDAS
                           │    │                        (Territorial)
                      ┌────┤    └──────────┐
                      ▼    ▼               ▼
                USER_ROLES  USER_PERMS  FORM_ENTRIES
                  │    │      │    │        ▲
                  ▼    ▼      ▼    ▼        │
               USERS  ROLES USERS PERMS  CUSTOM_FORMS
                        │               (UBG frame)
                        ▼
                  ROLE_PERMS
                    │    │
                    ▼    ▼
                 ROLES  PERMS
```

---

## 8. Tabela Resumo Total

| # | De | Para | Card. | FK Em | Status Board | Status Doc |
|---|-----|------|-------|-------|-------------|-----------|
| **INTERNOS (12 relationships)** |
| D01 | ORGANIZATIONS | OWNERS | N:1 | organizations.owner_id | NEW | DESENHAR |
| D02 | ORGANIZATION_SETTINGS | ORGANIZATIONS | 1:1 | settings.organization_id | NEW | DESENHAR |
| D03 | USERS | ORGANIZATIONS | N:1 | users.organization_id | (provavel exist) | DESENHAR |
| D04 | USER_ROLES | USERS | N:1 | user_roles.user_id | NEW | DESENHAR |
| D05 | USER_ROLES | ROLES | N:1 | user_roles.role_id | NEW | DESENHAR |
| D06 | ROLE_PERMISSIONS | ROLES | N:1 | role_perms.role_id | NEW | DESENHAR |
| D07 | ROLE_PERMISSIONS | PERMISSIONS | N:1 | role_perms.permission_id | NEW | DESENHAR |
| D08 | USER_PERMISSIONS | USERS | N:1 | user_perms.user_id | NEW | DESENHAR |
| D09 | USER_PERMISSIONS | PERMISSIONS | N:1 | user_perms.permission_id | NEW | DESENHAR |
| D10 | INVITE_TOKENS | ORGANIZATIONS | N:1 | invite.organization_id | NEW | DESENHAR |
| D11 | INVITE_TOKENS | USERS (criador) | N:1 | invite.criado_por_id | NEW | DESENHAR |
| D12 | FORM_ENTRIES | USERS (submitter) | N:1 | entry.user_id | NEW | DESENHAR |
| **EXTERNOS (1 cross-frame)** |
| D13 | FAZENDAS | ORGANIZATIONS | N:1 | fazendas.organization_id | EXISTS ("cria") | JA MAPEADO |
| **JA MAPEADOS EM OUTROS DOCS** |
| ~~ | CUSTOM_FORMS | FORM_ENTRIES | 1:N | entry.form_id | EXISTS (Doc 22, U09) | Doc 22 |
| ~~ | USERS | MOVIMENTACAO_INSUMO | 1:N | movim.user_id | (Doc 17) | Doc 17 |
| **REDUNDANTES** |
| ~~ | USER_ROLES | ORGANIZATIONS | N:1 | ~~ | ~~ | REDUNDANTE (2h via USERS) |
| ~~ | USER_PERMISSIONS | ORGANIZATIONS | N:1 | ~~ | ~~ | REDUNDANTE (2h via USERS) |
| ~~ | INVITE_TOKENS | OWNERS | N:1 | ~~ | ~~ | REDUNDANTE (2h via ORGANIZATIONS) |
| ~~ | ORGANIZATION_SETTINGS | OWNERS | N:1 | ~~ | ~~ | REDUNDANTE (2h via ORGANIZATIONS) |

### Contagem

| Categoria | Quantidade |
|-----------|-----------|
| Desenhar no diagrama | **13** (1 existe + 12 novos) |
| Redundantes removidos (Dijkstra) | 4 |
| Org_id (convencao, exceto 3 desenhaveis) | ~11 |
| Ja mapeados em outros Docs | 2 |
| Questoes abertas | 7 |
| **Total analisado** | **~37** |

---

## 9. Grafo de Adjacencia Corrigido

### Antes (FK directions INVERTED from Doc 08 hierarchy)

```
ADMINS → [OWNERS]
OWNERS → [ORGANIZATIONS]
ORGANIZATIONS → [FAZENDAS, USERS]
USERS → [ROLES]
ROLES → [PERMISSIONS]
USER_ROLES → [USERS, ROLES]
ROLE_PERMISSIONS → [ROLES, PERMISSIONS]
INVITE_TOKENS → [ORGANIZATIONS]
```

### Depois (FK directions CORRECTED — Doc 23 validated)

```
# ═══ CAMADA SISTEMA (Doc 23 — FK directions corrected) ═══
ADMINS → []                                              # Standalone — no FK out (top-level platform entity)
OWNERS → []                                              # Standalone — no FK out (client-level entity)
ORGANIZATIONS → [OWNERS]                                 # CORRECTED: org.owner_id → owners (was inverted)
ORGANIZATION_SETTINGS → [ORGANIZATIONS]                  # NEW entry: settings.organization_id (1:1)
USERS → [ORGANIZATIONS]                                  # CORRECTED: users.organization_id (was [ROLES])
ROLES → []                                               # CORRECTED: root entity, no FK out (was [PERMISSIONS])
PERMISSIONS → []                                         # Root entity, no FK out
USER_ROLES → [USERS, ROLES]                              # Unchanged (was correct)
ROLE_PERMISSIONS → [ROLES, PERMISSIONS]                   # Unchanged (was correct)
USER_PERMISSIONS → [USERS, PERMISSIONS]                   # NEW entry (was missing from adjacency)
INVITE_TOKENS → [ORGANIZATIONS, USERS*]                  # UPDATED: +USERS (criado_por_id)
```

### Entradas Movidas (FAZENDAS aponta para ORGANIZATIONS, nao o contrario)

```
# CAMADA TERRITORIAL — ja correto:
FAZENDAS → [ORGANIZATIONS]    # fazendas.organization_id — this was already correct in Territorial section
```

A entrada `ORGANIZATIONS → [FAZENDAS, USERS]` no adjacency antigo era ERRADA e DUPLICADA:
- FAZENDAS → [ORGANIZATIONS] ja existe na Camada Territorial
- USERS → [ORGANIZATIONS] e a correcao (era USERS → [ROLES])
- ORGANIZATIONS → [OWNERS] e o unico FK real de ORGANIZATIONS

---

## 10. Expansao do Frame DPWAI no Miro

### Situacao Atual: 3 shapes conceituais

O frame DPWAI tem a MENOR representacao no board — apenas 3 shapes conceituais vs 11+ entidades documentadas. Para alinhar com os outros frames (onde cada entidade = 1 shape), o frame precisa ser expandido.

### Proposta de Layout

```
┌─────────────────────────────────────────────────────────────┐
│  ENTIDADE DPWAI (Camada Sistema — Azul #c6dcff)             │
│                                                             │
│  ┌─────────┐    ┌─────────┐                                │
│  │ ADMINS  │    │ OWNERS  │  (standalone, sem FK entre si)  │
│  └─────────┘    └────┬────┘                                │
│                      │ owner_id                             │
│                      ▼                                      │
│               ┌──────────────┐  ┌─────────────────────┐    │
│               │ORGANIZATIONS │──│ORGANIZATION_SETTINGS│    │
│               └──────┬───────┘  └─────────────────────┘    │
│                      │ organization_id                      │
│          ┌───────────┼───────────┐                          │
│          ▼           ▼           ▼                          │
│    ┌──────────┐ ┌─────────┐ ┌──────────────┐              │
│    │  USERS   │ │INVITE_  │ │ → FAZENDAS   │ (cross-frame)│
│    │          │ │TOKENS   │ │   (Territorial)│              │
│    └──┬───┬──┘ └─────────┘ └──────────────┘              │
│       │   │                                                │
│    ┌──┘   └──┐     ┌──────┐  ┌─────────────┐             │
│    ▼         ▼     │ROLES │  │ PERMISSIONS  │             │
│ ┌────────┐ ┌──────┐└──┬───┘  └──────┬──────┘             │
│ │USER_   │ │USER_ │   │             │                      │
│ │ROLES   │ │PERMS │   ▼             ▼                      │
│ │(N:N)   │ │(N:N) │ ┌──────────────────┐                  │
│ └────────┘ └──────┘ │ ROLE_PERMISSIONS │                  │
│                      │     (N:N)       │                  │
│                      └─────────────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

### Ordem de Desenho no Miro

**Fase 1: Expandir frame e criar shapes (15 min)**
```
Criar 11 entity shapes (tabelas) com cor azul #c6dcff:
ADMINS, OWNERS, ORGANIZATIONS, ORGANIZATION_SETTINGS,
USERS, ROLES, PERMISSIONS, USER_ROLES, ROLE_PERMISSIONS,
USER_PERMISSIONS, INVITE_TOKENS
(CUSTOM_FORMS e FORM_ENTRIES ja existem no frame UBG)
```

**Fase 2: 12 Conectores Internos (10 min)**
```
D01: ORGANIZATIONS → OWNERS (N:1) — solida azul, "owner"
D02: ORG_SETTINGS → ORGANIZATIONS (1:1) — solida azul, "config"
D03: USERS → ORGANIZATIONS (N:1) — solida azul, "org"
D04: USER_ROLES → USERS (N:1) — solida azul, "usuario"
D05: USER_ROLES → ROLES (N:1) — solida azul, "papel"
D06: ROLE_PERMS → ROLES (N:1) — solida azul, "papel"
D07: ROLE_PERMS → PERMISSIONS (N:1) — solida azul, "permissao"
D08: USER_PERMS → USERS (N:1) — solida azul, "usuario"
D09: USER_PERMS → PERMISSIONS (N:1) — solida azul, "permissao"
D10: INVITE_TOKENS → ORGANIZATIONS (N:1) — solida azul, "org"
D11: INVITE_TOKENS → USERS (N:1) — solida azul, "criador"
D12: FORM_ENTRIES → USERS (N:1) — tracejada azul→amarela, "submitter"
```

**Fase 3: 1 Conector Externo (ja existe)**
```
D13: FAZENDAS → ORGANIZATIONS (N:1) — tracejada verde→azul, "org" (verificar se ja OK)
```

---

*Documento gerado em 12/02/2026 - DeepWork AI Flows*
*13 relacionamentos para desenhar (1 existe + 12 novos), 4 redundantes removidos, ~37 total analisado*
*ACHADO CRITICO: Adjacencia DPWAI estava com direcoes FK invertidas — corrigido neste doc.*
*Frame DPWAI precisa expansao significativa: de 3 shapes conceituais para 11 entity shapes.*
*7 questoes abertas para Joao (CTO) sobre RBAC design.*
