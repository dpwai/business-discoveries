# SOAL ER Board Context Agent

## Agent Purpose

This agent provides complete, real-time context about the SOAL project ER diagram development, including the Miro board state, all entity definitions, layer architecture, open decisions, and development progress. Use this agent whenever you need to understand, extend, validate, or reference the SOAL data model.

## When to Use This Agent

- Before adding or modifying any entity in the ER diagram
- When designing new modules that connect to existing entities
- When preparing Miro board updates or implementation sessions
- When generating DDL SQL for new or refactored entities
- When cross-referencing business requirements against the data model
- When onboarding Joao (CTO) on Rodrigo's business entity decisions
- When validating that the Miro board matches documentation
- When answering questions about entity relationships, cardinality, or data flow

---

## Miro Board: CLAUDE_SOAL

**Board URL:** https://miro.com/app/board/uXjVGE__XFQ=
**Last Audited:** 10/02/2026
**Total Frames:** 10
**Total Entities:** ~90
**Architecture:** 7 functional layers, Medallion pattern (Bronze/Silver/Gold)

---

## Board Frame Map

### Frame 1: ENTIDADE UBG
**Domain:** Grain processing, post-harvest, silos, custom forms
**Layer:** Agricola (y=2000-5000)
**Color:** Mixed (Yellow primary)
**Contains:**
- Grain processing entities (Ticket Balanca, Entrada Grao, Classificacao Grao)
- Silo management (Estoque Silo, Movimentacao Silo, Saida Grao)
- Custom Forms section (Custom Forms, Form Entries)
- UBG logo and visual identity
- Color-coded sub-groups: Blue (system), Green (forms), Orange (operations), Pink (alerts), Cyan (integration)
- Legend box at bottom

**Key Entities:**
| Entity | Function |
|--------|----------|
| TICKET_BALANCA | Weighing records (numero, peso_bruto, tara, liquido, placa) |
| ENTRADA_GRAO | Grain intake (quantidade_kg, umidade, impurezas, origem) |
| CLASSIFICACAO_GRAO | Quality grading (ph, ardidos, quebrados, mofados) |
| ESTOQUE_SILO | Current silo inventory (silo_id, cultura_id, quantidade_atual_kg) |
| MOVIMENTACAO_SILO | Silo movements (entrada/saida/transferencia/quebra) |
| SAIDA_GRAO | Grain dispatch (quantidade_kg, destino, nota_fiscal_id) |
| CUSTOM_FORMS | Form definitions (organization_id, name, type) |
| FORM_ENTRIES | Form submissions (form_id, user_id, data JSONB) |

---

### Frame 2: Entidade Pecuario ?
**Domain:** Livestock management (beef cattle)
**Layer:** Pecuaria (y=12000)
**Color:** Green (#adf0c7)
**Frame title has "?" indicating some entities still under validation**
**Contains:**
- PECUARIA DE CORTE section header
- Sub-sections: DIETA, MANEJO, PASTO, MONTA, GTA
- Largest frame by entity count (~26 entities)
- Extensive relationship network between sub-domains

**Key Entities:**
| Entity | Sub-domain | Function |
|--------|-----------|----------|
| RACA | Cadastro | Breed registry (nome, codigo_abcz, especie, aptidao) |
| ANIMAL | Cadastro | Individual animal (sisbov, brinco_visual, brinco_eletronico, sexo, peso_atual) |
| LOTE_ANIMAL | Cadastro | Animal groups (codigo, categoria: cria/recria/engorda/reproducao) |
| PESAGEM | Cadastro | Weight records (peso_kg, gmd_kg, tipo) |
| PASTO | Pasto | Pasture areas (area_ha, tipo_forragem, capacidade_ua, lotacao_atual) |
| PASTO_AVALIACAO | Pasto | Forage evaluation (altura_entrada, disponibilidade_ms) |
| MOVIMENTACAO_PASTO | Pasto | Pasture rotation (lote, origem, destino, qtd_animais) |
| DIETA | Nutricao | Feed formulation (ms_kg_animal_dia, custo_kg_ms, gmd_esperado) |
| DIETA_INGREDIENTE | Nutricao | Diet composition (produto_insumo_id, percentual_ms, kg_por_animal_dia) |
| TRATO_ALIMENTAR | Nutricao | Feeding records (lote_id, dieta_id, quantidade_total_kg) |
| COCHO | Nutricao | Feed bunks (tipo: volumoso/concentrado/sal/agua, capacidade_kg) |
| CALENDARIO_SANITARIO | Manejo | Health calendar (tipo_manejo, produto, mes_aplicacao) |
| MANEJO_SANITARIO | Manejo | Health interventions (vacinacao, vermifugacao, carrapaticida, carencia_dias) |
| OCORRENCIA_SANITARIA | Manejo | Health incidents (doenca/acidente/morte/aborto, diagnostico) |
| ESTACAO_MONTA | Monta | Breeding season (tipo: monta_natural/iatf/ia/te/fiv, taxa_prenhez) |
| PROTOCOLO_IATF | Monta | IATF protocol (dia_0, dia_8, dia_9, dia_10 products) |
| COBERTURA | Monta | Mating record (femea_id, touro_id, tipo, semen_partida) |
| DIAGNOSTICO_GESTACAO | Monta | Pregnancy diagnosis (resultado, metodo, sexo_feto) |
| PARTO | Monta | Birth record (tipo_parto, peso_cria_kg, cria_id -> ANIMAL) |
| GTA | Comercial | Animal transit guide (numero_gta, qtd_animais, uf_origem/destino) |
| GTA_ANIMAL | Comercial | Animals in GTA (animal_id, sisbov, peso_kg) |
| VENDA_ANIMAL | Comercial | Sale record (arroba_preco, valor_cabeca, valor_total) |
| COMPRA_ANIMAL | Comercial | Purchase record (peso_compra_kg, valor_total) |

---

### Frame 3: Entidade Contratos
**Domain:** Commercial and rural worker contracts
**Layer:** Financeiro + Territorial
**Color:** Orange (#f8d3af)
**Contains:**
- CONTRATO TRABALHADOR RURAL section
- CONTRATOS section (commercial contracts)
- Note: "e cliente dpwai ? (possivel lead)" with linked entity
- Diagonal arrows connecting to other frames

**Key Entities:**
| Entity | Function |
|--------|----------|
| CONTRATO_COMERCIAL | Commercial contracts (venda_antecipada/barter/fixacao/cpr, quantidade_sacas, preco_saca) |
| CONTRATO_ENTREGA | Delivery schedule (data_entrega, quantidade_sacas, peso_liquido, umidade) |
| CPR_DOCUMENTO | Rural Product Certificate (numero_cpr, tipo: fisica/financeira, cartorio_registro) |
| CONTRATO_ARRENDAMENTO | Land lease contracts (numero, valor_ha, forma_pagamento) |

---

### Frame 4: Entidade RH
**Domain:** Human resources, rural labor
**Layer:** Operacional (y=2000-5000)
**Color:** Purple
**Contains:**
- Two entity tables connected vertically
- TRABALHADOR RURAL label
- Arrows connecting to Maquinario and Contratos frames

**Key Entities:**
| Entity | Function |
|--------|----------|
| TRABALHADOR_RURAL | Worker registry (nome, cpf, cargo, setor, tipo_contrato: clt/diarista/safrista, salario_base) |
| APONTAMENTO_MAO_OBRA | Labor tracking (data_trabalho, horas_trabalhadas, tipo_atividade, centro_custo_id) |

---

### Frame 5: Entidade DPWAI
**Domain:** DeepWork AI platform system entities
**Layer:** Sistema (y=-6000)
**Color:** Cyan/Blue (#c6dcff)
**Contains:**
- "funcionarios dpwai" and "contatos dpwai" labels
- "contrato dpwai" label
- "DPWAI" large text identifier
- Platform core entities

**Key Entities:**
| Entity | Function |
|--------|----------|
| ADMINS | DeepWork system admins (highest access level) |
| OWNERS | Paying clients / organization holders |
| ORGANIZATIONS | Client businesses (farms, companies) |
| ORGANIZATION_SETTINGS | Per-org configuration |
| USERS | System users (operators, managers) |
| ROLES | Access roles |
| PERMISSIONS | Granular permissions |
| USER_ROLES | User-role association (junction) |
| ROLE_PERMISSIONS | Role-permission association (junction) |
| USER_PERMISSIONS | Direct user permissions |
| INVITE_TOKENS | Invitation tokens for onboarding |

---

### Frame 6: Entidade maquinario
**Domain:** Machinery, fuel, maintenance, field operations
**Layer:** Operacional (y=2000-5000)
**Color:** Cyan (#ccf4ff)
**Contains:**
- MECANIZACAO section header
- Open questions annotated on board:
  - "Data onde foi feita nota fiscal ?, como funciona esse processo ?"
  - "aqui nao seria um cargo" / "cargo ?"
- Entity tables connected with relationship lines

**Key Entities:**
| Entity | Function |
|--------|----------|
| MAQUINAS | Equipment registry (codigo_interno, tipo, marca, modelo, placa, horimetro, hodometro) |
| OPERADORES | Machine operators (nome, cpf, cnh_numero, cnh_categoria, cnh_validade) |
| ABASTECIMENTOS | Refueling records (maquina_id, tipo_combustivel, quantidade_litros, horimetro_momento) |
| MANUTENCOES | Maintenance records (tipo: preventiva/corretiva/preditiva, custo_total) |
| OPERACOES_CAMPO | Field operations (maquina_id, operador_id, tipo_operacao, area_trabalhada_ha, geojson_trajeto) |

**Open Decisions:**
- Whether "cargo" should be a separate entity or attribute of OPERADORES
- How nota fiscal links to machinery operations

---

### Frame 7: Entidade CLIENTE
**Domain:** Client/territorial structure (farms, fields, seasons, crops)
**Layer:** Territorial (y=-2000)
**Color:** Mixed (Cyan, Yellow, Purple, Green)
**Contains:**
- Rich multi-colored entity layout
- "1xn" cardinality annotations
- "entidade forte!" annotation (identifying strong entities)
- Hierarchical entity relationships

**Key Entities:**
| Entity | Function |
|--------|----------|
| FAZENDAS | Farm registry (nome, cnpj, inscricao_estadual, car, area_total_ha, geojson) |
| TALHOES | Field plots (codigo, nome, area_ha, tipo_solo, geojson) |
| SILOS | Storage silos (codigo, capacidade_ton, tipo, localizacao) |
| SAFRAS | Agricultural seasons (ano_agricola, data_inicio Jul 1, data_fim Jun 30) |
| CULTURAS | Crop types (nome, codigo, ciclo_dias) |
| TALHAO_SAFRA | Field-season assignment (talhao_id, safra_id, cultura_id, area_plantada) |
| PARCEIRO_COMERCIAL | Business partners (razao_social, cnpj_cpf, tipo: fornecedor/cliente/arrendador/transportador) |
| CONTRATO_ARRENDAMENTO | Land lease (numero, data_inicio, data_fim, valor_ha) |

---

### Frame 8: ENTIDADE AGRICULTURA
**Domain:** Full agricultural production cycle
**Layer:** Agricola (y=2000-5000)
**Color:** Yellow (#fff6b6) primary, mixed
**Contains:**
- "Alessandro" label (agronomist stakeholder reference)
- Key business rule note: "safra e uma data que gira primeiro de julho e acaba dia 30 de junho 25/26 - 26/26"
- Extensive entity network covering planting through harvest
- Links to insumos, solo, and operations modules

**Key Entities:**
| Entity | Function |
|--------|----------|
| PLANTIO | Planting records (data_plantio, populacao_sementes, espacamento, profundidade) |
| COLHEITA | Harvest records (data_colheita, peso_bruto, peso_liquido, umidade, produtividade_sc_ha) |
| ANALISE_SOLO | Soil analysis (ph, materia_organica, P, K, Ca, Mg, Al, CTC, V) |
| RECOMENDACAO_ADUBACAO | Fertilization recommendation (N_kg_ha, P2O5_kg_ha, K2O_kg_ha, calagem_t_ha) |
| APLICACAO_INSUMO | Input application (refactored - links to PRODUTO_INSUMO, ESTOQUE_INSUMO, OPERACAO_CAMPO) |
| RECEITUARIO_AGRONOMICO | Agronomic prescription (numero_receita, ART, CREA, dose_prescrita, carencia) |

**Stakeholder Note:** Alessandro is the agronomist responsible for crop planning, soil analysis, and prescriptions. His workflow defines much of this frame's entity relationships.

---

### Frame 9: FINANCEIRO 2.0
**Domain:** Financial management (invoices, accounts, cost centers)
**Layer:** Financeiro (y=8000)
**Color:** Orange (#f8d3af)
**Contains:**
- "tudo sobre nf deve ser arquivo" (all NF data should be file/archive)
- "ARQUIVO DA NF" section
- "A NF E EMITIDA NA ORG OU FAZENDA ?" (open question: NF issued at org or farm level?)
- "FALTA FOLHA DE PAGAMENTO ACORDOR ACERTOS" (missing: payroll, agreements, settlements)
- Extensive orange-bordered entity tables

**Key Entities:**
| Entity | Function |
|--------|----------|
| NOTA_FISCAL | Invoice (numero, serie, chave_nfe, cfop, valor_total, xml_url, pdf_url) |
| NOTA_FISCAL_ITEM | Invoice line items (descricao, ncm, quantidade, valor_unitario) |
| CONTA_PAGAR | Accounts payable (documento, data_vencimento, valor_original, valor_pago, status) |
| CONTA_RECEBER | Accounts receivable (documento, data_vencimento, valor_original, valor_recebido, status) |
| CENTRO_CUSTO | Cost center hierarchy (codigo, nome, tipo, nivel, parent_id, orcamento_anual) |
| CUSTO_OPERACAO | Operation costs (tipo: insumo/mao_obra/mecanizacao/servico/depreciacao, custo_por_ha) |

**Open Decisions:**
- Whether NF is issued at Organization or Fazenda level
- Payroll (folha de pagamento) entities still missing
- Settlement/agreement (acordos/acertos) entities still missing

---

### Frame 10: Consumo e estoque
**Domain:** Inputs purchasing, inventory management, consumption tracking
**Layer:** Agricola (y=2000-5000)
**Color:** Yellow/Gold (#fff6b6)
**Status:** Newest frame - ready for Miro implementation (Doc 15)
**Contains:**
- Complete inputs lifecycle: Compra -> Estoque -> Aplicacao -> Custo
- Weighted average cost (custo medio ponderado) logic
- Connected to multiple existing frames (Agricultura, Financeiro, Pecuaria)

**Key Entities:**
| Entity | Status | Function |
|--------|--------|----------|
| PRODUTO_INSUMO | NEW (replaces INSUMO) | Product catalog (21 type ENUMs, 3 groups: agricola/pecuario/geral) |
| COMPRA_INSUMO | NEW (replaces INSUMOS_CASTROLANDA) | Purchase records (fonte: castrolanda/revenda/direto_fabrica/barter/producao_propria) |
| ESTOQUE_INSUMO | NEW | Current stock position per product + location (custo medio ponderado) |
| MOVIMENTACAO_INSUMO | NEW | Movement history (12 movement types: entrada_compra through saida_ajuste) |
| APLICACAO_INSUMO | REFACTORED | Field/livestock/maintenance usage (contexto: agricola/pecuario/manutencao/ubg) |
| RECEITUARIO_AGRONOMICO | ADJUSTED | Agronomic prescription (FK renamed: insumo_id -> produto_insumo_id) |

**Business Rules:**
- 1 OPERACAO_CAMPO can have N APLICACAO_INSUMO (e.g., Planting = seed + inoculant + base fertilizer + seed treatment)
- PULVERIZACAO_DETALHE = TECHNICAL data (pressure, flow, climate); APLICACAO_INSUMO = PRODUCT data (which, how much, cost) -- they complement, not duplicate
- Weighted average cost formula: new_avg = (current_qty x current_avg + purchase_qty x purchase_cost) / (current_qty + purchase_qty)
- Cost does NOT change on outflow, only on inflow

---

## Layer Architecture Summary

```
y=-6000  ┌─────────────────────────────────────────────────────────┐
         │  CAMADA SISTEMA (Blue #c6dcff) - 11 entities            │
         │  Admins, Owners, Orgs, Users, RBAC, Forms               │
         │  Frame 5: Entidade DPWAI                                │
         └─────────────────────────────────────────────────────────┘

y=-2000  ┌─────────────────────────────────────────────────────────┐
         │  CAMADA TERRITORIAL (Green #dbfaad) - 8 entities        │
         │  Fazendas, Talhoes, Silos, Safras, Culturas, Parceiros  │
         │  Frame 7: Entidade CLIENTE                              │
         └─────────────────────────────────────────────────────────┘

y=2000   ┌─────────────────────────────────────────────────────────┐
  to     │  CAMADA AGRICOLA (Yellow #fff6b6) - 16 entities         │
y=5000   │  Plantio, Colheita, Insumos, Estoque, Solo, Silos/UBG  │
         │  Frames 1, 8, 10                                        │
         ├─────────────────────────────────────────────────────────┤
         │  CAMADA OPERACIONAL (Cyan #ccf4ff) - 7 entities         │
         │  Maquinas, Operadores, Abastecimentos, Mao de Obra      │
         │  Frames 4, 6                                            │
         └─────────────────────────────────────────────────────────┘

y=8000   ┌─────────────────────────────────────────────────────────┐
         │  CAMADA FINANCEIRO (Orange #f8d3af) - 11 entities       │
         │  NF, Contas, Centro Custo, Contratos Comerciais         │
         │  Frames 3, 9                                            │
         └─────────────────────────────────────────────────────────┘

y=12000  ┌─────────────────────────────────────────────────────────┐
         │  CAMADA PECUARIA (Green #adf0c7) - 26 entities          │
         │  Animal, Lote, Pasto, Manejo, Reproducao, Nutricao, GTA │
         │  Frame 2                                                │
         └─────────────────────────────────────────────────────────┘

y=16000  ┌─────────────────────────────────────────────────────────┐
         │  CAMADA INFRAESTRUTURA (Gray #e7e7e7) - 11 entities     │
         │  Integracoes, Alertas, Auditoria, Logs                  │
         │  (No dedicated frame yet - spread across board)         │
         └─────────────────────────────────────────────────────────┘
```

---

## Cross-Layer Relationship Map

> **Convention:** `organization_id` exists on ALL entities for multi-tenancy filtering
> but is NOT drawn as a connector on the diagram. Use a single note on the board:
> *"All entities carry organization_id (FK → ORGANIZATIONS) for multi-tenancy. Not drawn to reduce noise."*

### Critical Foreign Key Chains (diagram-worthy only)

```
FAZENDAS (Territorial) ◄── ORGANIZATIONS (Sistema, via org_id — NOT drawn)
    │
    ├──► TALHOES ──► TALHAO_SAFRA ◄── SAFRAS ◄── CULTURAS
    ├──► SILOS ──► ESTOQUE_SILO
    └──► ESTOQUE_INSUMO (Agricola, per fazenda+product)

MAQUINAS (Operacional)
    ├──► ABASTECIMENTOS
    ├──► MANUTENCOES ──► CENTRO_CUSTO (Financeiro)
    └──► OPERACAO_CAMPO ──► APLICACAO_INSUMO (Agricola)
                                 │
                                 └──► ESTOQUE_INSUMO (qty/cost deduction)

PARCEIRO_COMERCIAL (Territorial)
    ├──► COMPRA_INSUMO (Agricola) ──► PRODUTO_INSUMO
    ├──► CONTRATO_COMERCIAL (Financeiro)
    └──► CONTRATO_ARRENDAMENTO (Territorial)

NOTA_FISCAL (Financeiro)
    ├──► NOTA_FISCAL_ITEM ──► PRODUTO_INSUMO (Agricola)
    ├──► CONTA_PAGAR
    └──► CONTA_RECEBER

ANIMAL (Pecuaria)
    ├──► LOTE_ANIMAL ──► PASTO
    ├──► MANEJO_SANITARIO ──► APLICACAO_INSUMO (Agricola)
    └──► GTA ──► VENDA_ANIMAL

TRABALHADOR_RURAL (Operacional)
    └──► APONTAMENTO_MAO_OBRA ──► CENTRO_CUSTO (Financeiro)
```

### Redundancy Rules Applied (Dijkstra's Shortest Path)

**Algorithm:** For each proposed FK, trace the shortest path in the adjacency list above. If path ≤ 2 hops exists via other edges, the FK is REDUNDANT for the diagram. See `er-diagram-architect.agent.md` § Dijkstra for full framework.

**Confirmed Redundant FKs — Consumo e Estoque (Doc 17):**

| Removed FK | Shortest Path (w/o this FK) | Hops | Pattern |
|-----------|---------------------------|------|---------|
| APLICACAO_INSUMO → PRODUTO_INSUMO | APLICACAO → ESTOQUE_INSUMO → PRODUTO_INSUMO | 2 | Transitive closure |
| APLICACAO_INSUMO → TALHAO_SAFRA | APLICACAO → OPERACAO_CAMPO → TALHAO_SAFRA | 2 | Transitive closure |
| PULVERIZACAO_DETALHE → PRODUTO_INSUMO | PULV → OPERACAO_CAMPO ← APLICACAO → ESTOQUE → PRODUTO | 4 | Leaf isolation + hub bypass |
| DRONE_DETALHE → PRODUTO_INSUMO | Same as PULVERIZACAO_DETALHE | 4 | Leaf isolation + hub bypass |

**Confirmed Redundant FKs — Agricultura (Doc 19):**

| Removed FK | Shortest Path (w/o this FK) | Hops | Pattern |
|-----------|---------------------------|------|---------|
| OPERACAO_CAMPO → FAZENDAS | OPERACAO → TALHAO_SAFRA → TALHOES → FAZENDAS | 3 | Gray zone (DDL denorm OK) |
| PULVERIZACAO_DETALHE → RECEITUARIO_AGRO | PULV → OPERACAO_CAMPO ← APLICACAO → RECEITUARIO | 3 | Leaf isolation |

**Confirmed Redundant FKs — Maquinario (Doc 20):**

| Removed FK | Shortest Path (w/o this FK) | Hops | Pattern |
|-----------|---------------------------|------|---------|
| ABASTECIMENTOS → FAZENDAS | ABASTECIMENTOS → MAQUINAS → FAZENDAS | 2 | Transitive closure |
| MANUTENCOES → FAZENDAS | MANUTENCOES → MAQUINAS → FAZENDAS | 2 | Transitive closure |

**Org_id links NOT drawn (convention — ALL modules):**
Every entity carries `organization_id` but it is NEVER drawn. Derivable via domain chains.

> **TODO:** Apply Dijkstra analysis to remaining modules: Pecuaria, Financeiro, UBG, RH, DPWAI/Sistema.

### Cross-Frame Connectors (diagonal arrows on Miro)

| From Frame | To Frame | Relationship | Type | Status |
|------------|----------|-------------|------|--------|
| DPWAI (5) | CLIENTE (7) | Organizations → Fazendas | 1:N | DRAW (real ownership) |
| CLIENTE (7) | AGRICULTURA (8) | Talhao_Safra → Plantio/Colheita | 1:N | DRAW |
| AGRICULTURA (8) | Consumo e estoque (10) | Operacao_Campo → Aplicacao_Insumo | 1:N | DRAW |
| Consumo e estoque (10) | FINANCEIRO (9) | Compra_Insumo → Nota_Fiscal_Item | N:1 | DRAW |
| Consumo e estoque (10) | FINANCEIRO (9) | Aplicacao_Insumo → Custo_Operacao | 1:1 | DRAW |
| maquinario (6) | AGRICULTURA (8) | Operacao_Campo → Talhao_Safra | N:1 | DRAW |
| maquinario (6) | FINANCEIRO (9) | Manutencoes → Centro_Custo | N:1 | DRAW |
| Pecuario (2) | Consumo e estoque (10) | Dieta_Ingrediente → Produto_Insumo | N:1 | DRAW |
| Pecuario (2) | Consumo e estoque (10) | Manejo_Sanitario → Aplicacao_Insumo | 1:N | DRAW |
| RH (4) | FINANCEIRO (9) | Apontamento_Mao_Obra → Centro_Custo | N:1 | DRAW |
| UBG (1) | AGRICULTURA (8) | Entrada_Grao ← Colheita | N:1 | DRAW |
| Contratos (3) | FINANCEIRO (9) | Contrato_Comercial → Conta_Receber | 1:N | DRAW |
| Contratos (3) | CLIENTE (7) | Contrato_Arrendamento → Talhoes | N:N | DRAW |

**Not drawn (redundant / org_id):** See Redundancy Rules above.

---

## Entity Graph (Dijkstra Adjacency List)

> **Purpose:** Use this adjacency list to trace shortest paths between any two entities.
> Before proposing ANY new FK, trace the path here first. If a path ≤ 2 hops exists, the FK is redundant.
> See `er-diagram-architect.agent.md` for the full Dijkstra framework and algorithm.

### How to Read

```
ENTITY → [list of entities it points TO via FK]
```

Each arrow = 1 hop. To check redundancy of proposed FK A→C, find A in the list and trace paths to C.

### Validated Adjacency List (Docs 17 + 19 + 20)

```
# ═══ CAMADA SISTEMA ═══
ADMINS → [OWNERS]
OWNERS → [ORGANIZATIONS]
ORGANIZATIONS → [FAZENDAS, USERS]                    # real ownership chains
USERS → [ROLES]
ROLES → [PERMISSIONS]
USER_ROLES → [USERS, ROLES]
ROLE_PERMISSIONS → [ROLES, PERMISSIONS]
INVITE_TOKENS → [ORGANIZATIONS]

# ═══ CAMADA TERRITORIAL ═══
FAZENDAS → [ORGANIZATIONS]
TALHOES → [FAZENDAS]
SILOS → [FAZENDAS]
SAFRAS → [ORGANIZATIONS]
CULTURAS → []                                        # root entity (no FK out)
TALHAO_SAFRA → [TALHOES, SAFRAS, CULTURAS]
PARCEIRO_COMERCIAL → [ORGANIZATIONS]
CONTRATO_ARRENDAMENTO → [PARCEIRO_COMERCIAL, TALHOES]

# ═══ CAMADA AGRICOLA (Consumo e Estoque - Doc 17) ═══
PRODUTO_INSUMO → []                                  # root catalog (org_id not listed)
COMPRA_INSUMO → [PRODUTO_INSUMO, PARCEIRO_COMERCIAL, SAFRAS, NOTA_FISCAL_ITEM, CULTURAS*, CONTRATO_COMERCIAL*]
ESTOQUE_INSUMO → [PRODUTO_INSUMO, FAZENDAS]
MOVIMENTACAO_INSUMO → [ESTOQUE_INSUMO, COMPRA_INSUMO*, APLICACAO_INSUMO*, ESTOQUE_INSUMO(destino)*, USERS]
APLICACAO_INSUMO → [ESTOQUE_INSUMO, OPERACAO_CAMPO*, MANEJO_SANITARIO*, MANUTENCOES*, RECEITUARIO_AGRONOMICO*]
RECEITUARIO_AGRONOMICO → [PRODUTO_INSUMO, CULTURAS]

# ═══ CAMADA AGRICOLA (Agricultura - Doc 19) ═══
OPERACAO_CAMPO → [TALHAO_SAFRA, MAQUINAS, OPERADORES]
PLANTIO_DETALHE → [OPERACAO_CAMPO]                   # leaf: parent only
COLHEITA_DETALHE → [OPERACAO_CAMPO]                  # leaf: parent only
PULVERIZACAO_DETALHE → [OPERACAO_CAMPO]              # leaf: parent only (insumo_id + receituario_id REMOVED)
DRONE_DETALHE → [OPERACAO_CAMPO]                     # leaf: parent only (insumo_id REMOVED)
TRANSPORTE_COLHEITA_DETALHE → [OPERACAO_CAMPO, OPERACAO_CAMPO(colheita), TICKET_BALANCA*]
ANALISE_SOLO → [TALHOES]
RECOMENDACAO_ADUBACAO → [ANALISE_SOLO, CULTURAS]

# ═══ CAMADA AGRICOLA (UBG/Silos) ═══
TICKET_BALANCA → [FAZENDAS]                          # TODO: validate in UBG module mapping
ENTRADA_GRAO → [TICKET_BALANCA]
CLASSIFICACAO_GRAO → [ENTRADA_GRAO]
ESTOQUE_SILO → [SILOS, CULTURAS, SAFRAS]
MOVIMENTACAO_SILO → [ESTOQUE_SILO]
SAIDA_GRAO → [ESTOQUE_SILO, NOTA_FISCAL*]

# ═══ CAMADA OPERACIONAL (Maquinario - Doc 20) ═══
MAQUINAS → [FAZENDAS]                                # VALIDATED (M05)
OPERADORES → []                                      # VALIDATED: no FK out (org_id only)
ABASTECIMENTOS → [MAQUINAS, OPERADORES]              # UPDATED: +OPERADORES (M03)
MANUTENCOES → [MAQUINAS, OPERADORES*, CENTRO_CUSTO*] # UPDATED: +OPERADORES* (M04)
TRABALHADOR_RURAL → [FAZENDAS]                       # TODO: validate
APONTAMENTO_MAO_OBRA → [TRABALHADOR_RURAL, CENTRO_CUSTO]

# ═══ CAMADA FINANCEIRO ═══
NOTA_FISCAL → [PARCEIRO_COMERCIAL]                   # TODO: validate in Financeiro module
NOTA_FISCAL_ITEM → [NOTA_FISCAL, PRODUTO_INSUMO]
CONTA_PAGAR → [NOTA_FISCAL*, CENTRO_CUSTO]
CONTA_RECEBER → [CONTRATO_COMERCIAL*, CENTRO_CUSTO]
CENTRO_CUSTO → [CENTRO_CUSTO(parent)*]               # hierarchical self-ref
CUSTO_OPERACAO → [CENTRO_CUSTO, APLICACAO_INSUMO*]
CONTRATO_COMERCIAL → [PARCEIRO_COMERCIAL, SAFRAS, PRODUTO_INSUMO*]
CONTRATO_ENTREGA → [CONTRATO_COMERCIAL]
CPR_DOCUMENTO → [CONTRATO_COMERCIAL]

# ═══ CAMADA PECUARIA ═══                            # TODO: full validation in Pecuaria module
RACA → []
ANIMAL → [RACA, LOTE_ANIMAL, ANIMAL(mae)*, ANIMAL(pai)*]
LOTE_ANIMAL → [PASTO]
PESAGEM → [ANIMAL]
PASTO → [FAZENDAS]
PASTO_AVALIACAO → [PASTO]
MOVIMENTACAO_PASTO → [LOTE_ANIMAL, PASTO(origem), PASTO(destino)]
DIETA → []
DIETA_INGREDIENTE → [DIETA, PRODUTO_INSUMO]
TRATO_ALIMENTAR → [LOTE_ANIMAL, DIETA, COCHO*]
COCHO → [PASTO*]
CALENDARIO_SANITARIO → []
MANEJO_SANITARIO → [ANIMAL, CALENDARIO_SANITARIO*]
OCORRENCIA_SANITARIA → [ANIMAL]
ESTACAO_MONTA → []
PROTOCOLO_IATF → [ESTACAO_MONTA]
COBERTURA → [ANIMAL(femea), ANIMAL(touro), ESTACAO_MONTA]
DIAGNOSTICO_GESTACAO → [ANIMAL]
PARTO → [ANIMAL(femea), ANIMAL(cria)]
GTA → [FAZENDAS]
GTA_ANIMAL → [GTA, ANIMAL]
VENDA_ANIMAL → [ANIMAL, GTA*]
COMPRA_ANIMAL → [ANIMAL]

# Legend: * = conditional/optional FK
# TODO = not yet validated by module-specific relationship mapping
```

### Hub Entities (8+ connections)

| Entity | Connections | Role |
|--------|------------|------|
| OPERACAO_CAMPO | 9 (3 in + 6 out) | Routes field operations to machinery, territory, and inputs |
| APLICACAO_INSUMO | 10 (6 in + 4 out) | Convergence point: what, from where, where, why, cost |
| ANIMAL | 9+ | Livestock identity — everything traces back to the animal |
| PRODUTO_INSUMO | 9 (0 in + 9 out) | Root catalog — referenced by purchases, stock, applications, NF, contracts, diets |

### Example Shortest Path Traces

**Q: Does DRONE_DETALHE need FK to PRODUTO_INSUMO?**
```
DRONE_DETALHE → OPERACAO_CAMPO → (APLICACAO_INSUMO backrefs) → ESTOQUE_INSUMO → PRODUTO_INSUMO
Path length: 4 hops (via backref). But APLICACAO_INSUMO.operacao_campo_id gives 2-hop access to product.
Result: REDUNDANT. Product info lives in APLICACAO_INSUMO, not in DRONE_DETALHE.
```

**Q: Does OPERACAO_CAMPO need FK to FAZENDAS?**
```
OPERACAO_CAMPO → TALHAO_SAFRA → TALHOES → FAZENDAS
Path length: 3 hops.
Result: GRAY ZONE. Could justify as DDL denormalization for query performance.
         Do NOT draw on diagram. Annotate in DDL: "-- DENORM: via talhao_safra→talhoes→fazendas"
```

**Q: Does COMPRA_INSUMO need FK to PARCEIRO_COMERCIAL?**
```
Remove COMPRA_INSUMO → PARCEIRO_COMERCIAL. Find alternate path.
No alternate path exists (PARCEIRO is the supplier, no other chain reaches it).
Result: ESSENTIAL. Draw it.
```

---

## Principal Data Flows

### Flow 1: Grain Lifecycle
```
PLANTIO -> COLHEITA -> TICKET_BALANCA -> ENTRADA_GRAO -> CLASSIFICACAO_GRAO
    |                                                          |
    v                                                          v
APLICACAO_INSUMO                                        ESTOQUE_SILO
    |                                                          |
    v                                                          v
PRODUTO_INSUMO <- COMPRA_INSUMO <- NF_ITEM            MOVIMENTACAO_SILO
    |                    |                                     |
    v                    v                                     v
RECEITUARIO        ESTOQUE_INSUMO                        SAIDA_GRAO
                   (custo medio)                              |
                                                              v
                                                    CONTRATO_COMERCIAL
```

### Flow 2: Input Lifecycle (Doc 15)
```
COMPRA -> ESTOQUE -> APLICACAO -> CUSTO
   |          |           |          |
   v          v           v          v
PARCEIRO  FAZENDA   OPERACAO    CENTRO
COMERCIAL  (local)   _CAMPO     _CUSTO
```

### Flow 3: Livestock Lifecycle
```
ANIMAL -> LOTE -> PASTO -> MANEJO_SANITARIO -> REPRODUCAO -> VENDA
   |        |        |           |                  |          |
   v        v        v           v                  v          v
PESAGEM  DIETA   AVALIACAO  CALENDARIO          PARTO       GTA
  |        |                                       |          |
  v        v                                       v          v
 GMD    TRATO                                   ANIMAL     NF_SAIDA
       ALIMENTAR                                (cria)
```

### Flow 4: Financial
```
NOTA_FISCAL -> CONTA_PAGAR/RECEBER -> CENTRO_CUSTO -> CUSTO_OPERACAO
     |                |                     |               |
     v                v                     v               v
  NF_ITEM        PAGAMENTO             ORCAMENTO        RATEIO -> $/HA
     |                |
     v                v
COMPRA_INSUMO   PARCEIRO_COMERCIAL
```

---

## Open Questions and Decisions

### Unresolved (Annotated on Board)

| # | Question | Frame | Impact | Who Decides |
|---|----------|-------|--------|-------------|
| 1 | "A NF E EMITIDA NA ORG OU FAZENDA?" | 9 (Financeiro) | Determines FK structure of NOTA_FISCAL | Claudio + Valentina |
| 2 | "aqui nao seria um cargo / cargo?" | 6 (Maquinario) | Whether CARGO is entity or attribute of OPERADORES | Joao + Rodrigo |
| 3 | "Data onde foi feita nota fiscal?, como funciona esse processo?" | 6 (Maquinario) | How NF links to machinery operations | Claudio + Tiago |
| 4 | "FALTA FOLHA DE PAGAMENTO ACORDOR ACERTOS" | 9 (Financeiro) | Payroll and settlement entities not yet designed | Valentina |
| 5 | "e cliente dpwai? (possivel lead)" | 3 (Contratos) | Whether external party entity doubles as lead tracking | Rodrigo |
| 6 | "Entidade Pecuario ?" (frame title) | 2 (Pecuario) | Some livestock entities still need validation | Claudio |
| 7 | Where are insumos stored? Separate defensives deposit? | Doc 15 | Defines ESTOQUE_INSUMO.local_armazenamento values | Claudio |
| 8 | Does Alessandro issue prescriptions for ALL applications? | Doc 15 | RECEITUARIO_AGRONOMICO completeness | Alessandro |

### Resolved Decisions

| Decision | Resolution | Date | Reference |
|----------|-----------|------|-----------|
| UUID vs auto-increment for PKs | UUID always | 04/02/2026 | er-diagram-architect.agent.md |
| Naming convention | Singular UPPER_SNAKE_CASE entities, plural snake_case tables | 04/02/2026 | er-diagram-architect.agent.md |
| External system naming | Abstract (fuel_supply not vestro_fuel) | 04/02/2026 | er-diagram-architect.agent.md |
| INSUMO vs PRODUTO_INSUMO | PRODUTO_INSUMO (catalog, no price/stock) | 09/02/2026 | Doc 15 |
| INSUMOS_CASTROLANDA vs COMPRA_INSUMO | COMPRA_INSUMO (supplier-agnostic) | 09/02/2026 | Doc 15 |
| Inventory costing method | Weighted average cost (custo medio ponderado) | 09/02/2026 | Doc 15 |
| Safra date range | July 1 to June 30 (e.g., 25/26 = Jul 2025 - Jun 2026) | Visit notes | Frame 8 annotation |
| Inside-out approach | Internal entities first, integrations last | 04/02/2026 | er-diagram-architect.agent.md |

---

## Development Progress

### Documentation Produced (18 docs in 19_DIAGRAMA_ER_SOAL/)

| Doc # | Title | Status | Key Content |
|-------|-------|--------|-------------|
| 01 | Preparacao Mapeamento Entidades | Complete | Initial entity mapping methodology |
| 02 | Guia Estudo Modelagem Dados | Complete | Data modeling study guide |
| 03 | Esboco Diagrama ER SOAL | Complete | First ER draft |
| 04 | Preparacao Visita Sabado Tiago/Claudio | Complete | On-site visit prep |
| 05 | Mapeamento Completo Entidades SOAL | Complete | Consolidated from 12+ meetings, ~53 entities (v2.0) |
| 06 | Mapeamento Entidades Pecuaria Corte | Complete | Beef cattle full entity mapping |
| 07 | Pesquisa Entidades Agropecuarias | Complete | Industry research for entity validation |
| 08 | Estrutura ER Completa SOAL | Complete (v1.1) | Master reference: 7 layers, ~90 entities |
| 09 | Operacoes Campo Agricultura | Complete | Field operations detail |
| 10 | UBG Fluxo Pos Colheita | Complete | Post-harvest grain processing flow |
| 11 | Pesquisa Financeiro Melhores Praticas | Complete | Financial module best practices research |
| 12 | Financeiro Plano Acao Draft | Complete | Financial module action plan |
| 13 | Hierarquia Centro Custo SOAL | Complete | Cost center hierarchy design |
| 14 | Cost Accounting Framework SOAL | Complete | Cost accounting methodology |
| 15 | Modulo Insumos Estoque SOAL | Complete | Inputs & inventory module (newest) |
| 16 | DDL Modulo Insumos Estoque | Complete | PostgreSQL DDL for inputs module |
| 17 | Relacionamentos Consumo Estoque | Complete | 33 relationships mapped → 24 after redundancy analysis |
| 19 | Relacionamentos Agricultura | Complete | 25 analyzed → 13 to draw, 4 redundant removed |
| 20 | Relacionamentos Maquinario | Complete | 22 analyzed → 6 to draw, 2 redundant removed, 4 already on board |

### Miro Board Implementation Status

| Frame | Board Status | Doc Alignment |
|-------|-------------|---------------|
| 1 - UBG | Implemented | Matches Doc 10 |
| 2 - Pecuario | Implemented (needs validation) | Matches Doc 06 |
| 3 - Contratos | Implemented | Partially matches Doc 08 |
| 4 - RH | Implemented (minimal) | Matches Doc 08 |
| 5 - DPWAI | Implemented | Matches Doc 05 |
| 6 - Maquinario | Implemented (has open questions) | Matches Doc 05/08 |
| 7 - CLIENTE | Implemented | Matches Doc 08 |
| 8 - AGRICULTURA | Implemented | Matches Docs 08, 09 |
| 9 - FINANCEIRO 2.0 | Implemented (has gaps) | Matches Docs 11-14 |
| 10 - Consumo e estoque | RELATIONSHIPS MAPPED (Doc 17: 24 connectors) | Docs 15, 17 |

### Entity Count Evolution

| Date | Total Entities | Milestone |
|------|---------------|-----------|
| 04/02/2026 | ~53 | Doc 05 - first complete mapping |
| 06/02/2026 | ~88 | Doc 08 - full ER with pecuaria + infra |
| 09/02/2026 | ~90 | Doc 15 - insumos module (+2 new, 2 replaced, 1 refactored) |

---

## FK Renames Pending (from Doc 15)

Entities that currently reference old `INSUMO` and need updating to `PRODUTO_INSUMO`:

| Entity | Current Field | Rename To |
|--------|--------------|-----------|
| DIETA_INGREDIENTE | insumo_id | produto_insumo_id |
| NOTA_FISCAL_ITEM | insumo_id | produto_insumo_id |
| CONTRATO_COMERCIAL | barter_insumo_id | barter_produto_insumo_id |

> **Removed from this list:** PULVERIZACAO_DETALHE and DRONE_DETALHE no longer carry
> direct `produto_insumo_id` — product info is derivable via OPERACAO_CAMPO → APLICACAO_INSUMO chain.
> See Redundancy Rules in Cross-Layer Relationship Map.

---

## Color Coding Reference

| Color | Hex | Layer | Miro Usage |
|-------|-----|-------|------------|
| Blue | #c6dcff | Sistema | Entity borders and fills |
| Green Lime | #dbfaad | Territorial | Entity borders and fills |
| Yellow | #fff6b6 | Agricola | Entity borders and fills |
| Cyan | #ccf4ff | Operacional | Entity borders and fills |
| Orange | #f8d3af | Financeiro | Entity borders and fills |
| Green | #adf0c7 | Pecuaria | Entity borders and fills |
| Gray | #e7e7e7 | Infraestrutura | Entity borders and fills |
| Red | #ffc6c6 | Alertas | Entity borders and fills |
| PK highlight | Yellow | All | Primary key fields |
| FK highlight | Blue | All | Foreign key fields |
| Dashed lines | Various | Cross-layer | External frame connectors |
| Solid lines | Layer color | Intra-layer | Internal frame connectors |

---

## Conventions and Standards

### Entity Design
- **PK:** Always UUID, never auto-increment
- **Timestamps:** `created_at` and `updated_at` on every entity
- **Naming:** Singular UPPER_SNAKE_CASE for entities, plural snake_case for tables
- **FKs:** `referenced_entity_id` pattern
- **Status fields:** ENUM with soft delete (`active/inactive/deleted`)
- **Money:** DECIMAL(14,2) for totals, DECIMAL(12,4) for unit prices
- **Geo:** GEOMETRY type for GeoJSON (talhoes, trajetos)

### Diagram Conventions (ER Board — Dijkstra-Validated)
- **Dijkstra rule:** Before drawing ANY connector, trace the shortest path in the adjacency list. If path ≤ 2 hops exists, do NOT draw. See `er-diagram-architect.agent.md` § Dijkstra.
- **org_id rule:** Every entity has `organization_id` FK but it is NOT drawn. Use a single board note.
- **Hub rule:** Entities with 8+ connections (OPERACAO_CAMPO, APLICACAO_INSUMO, ANIMAL, PRODUTO_INSUMO) are hubs. Never draw cross-hub shortcuts.
- **Leaf rule:** Detail entities (1:0..1) connect ONLY to their parent. No bypass FKs.
- **Crow's Foot Notation:** Use native ERD stroke caps for cardinality (1, 0..1, 1..N, 0..N).
- **Cross-frame connectors:** Dashed lines for cross-layer, solid for intra-layer.
- **Denormalization annotation:** Redundant FKs kept in DDL for performance get comment: `-- DENORM: derivable via X→Y→Z`

### Abstraction Rules
- Never name entities after external systems (Vestro, John Deere, AgriWin)
- Use generic business concepts (fuel_supply, not vestro_fuel)
- External systems are SOURCES, not entities
- Integrations are the last layer to design (inside-out approach)

### Medallion Architecture Mapping
- **Bronze Layer:** Raw data from ER entities (what the board defines)
- **Silver Layer:** Cleaned, joined, transformed data (derived from Bronze relationships)
- **Gold Layer:** Dashboard-ready aggregations (query definitions, not entities)

---

## How to Use This Agent

### For Board Updates
```
"I need to add a new entity to the [FRAME_NAME] frame.
What existing entities does it need to connect to?
What layer color should it use?
What coordinates should it go at?"
```

### For DDL Generation
```
"Generate the CREATE TABLE SQL for [ENTITY_NAME]
following the conventions in this agent."
```

### For Validation
```
"Validate that the Miro board matches the documentation.
Check Frame [N] against Doc [XX]."
```

### For New Module Design
```
"I need to design a new module for [DOMAIN].
What existing entities should it connect to?
What layer does it belong to?
Show me the entity definitions and relationships."
```

### For Stakeholder Communication
```
"Explain the [ENTITY/FLOW] to [Claudio/Tiago/Valentina/Alessandro]
in business terms, not technical jargon."
```

---

## Related Agents

| Agent | Relationship |
|-------|-------------|
| business-context-expert.agent.md | Provides business strategy and SOAL project context |
| er-diagram-architect.agent.md | Defines ER design standards, naming conventions, Miro workflow |
| diagnostic-document-generator.agent.md | Formats findings into client-facing deliverables |
| audio-transcription-analyzer.agent.md | Extracts entity requirements from meeting recordings |

---

## Key Stakeholders and Their Entity Domains

| Stakeholder | Role | Primary Entities | Validation Needed |
|-------------|------|-----------------|-------------------|
| **Claudio** | Owner (28yr experience) | ALL (final authority) | Safra dates, storage locations, insumo types |
| **Tiago** | Machinery Manager | Maquinas, Abastecimentos, Operadores, Manutencoes | NF process, cargo question |
| **Valentina** | Admin Manager | Nota Fiscal, Contas Pagar/Receber, Folha Pagamento | NF org vs fazenda, payroll entities |
| **Alessandro** | Agronomist | Plantio, Colheita, Analise Solo, Receituario, Insumos | Prescription completeness |
| **Josmar** | Grain Drying Operator | Ticket Balanca, Entrada Grao, Estoque Silo, Secador | UBG flow validation |
| **Joao** (CTO) | Technical Lead | Sistema, Infraestrutura, RBAC, Custom Forms | All technical architecture |
| **Rodrigo** (CEO) | Business/Product | Cross-cutting business logic, Centro Custo hierarchy | Business rules, entity naming |

---

## Next Milestones

| # | Action | Status | Responsible |
|---|--------|--------|-------------|
| 1 | Draw Consumo e Estoque connectors on Miro (24 relationships) | In progress (manual) | Rodrigo |
| 2 | Map relationships for Agricultura module | Complete (Doc 19: 13 connectors) | Claude + Rodrigo |
| 3 | Map relationships for Pecuaria module | Not started | Claude + Rodrigo |
| 4 | Map relationships for Financeiro module | Not started | Claude + Rodrigo |
| 5 | Map relationships for UBG module | Not started | Claude + Rodrigo |
| 6 | Map relationships for Maquinario module | Complete (Doc 20: 6 connectors, 4 exist + 2 new) | Claude + Rodrigo |
| 7 | Map relationships for DPWAI/Sistema module | Not started | Claude + Rodrigo |
| 7 | Rename FKs in 3 existing entities (insumo_id -> produto_insumo_id) | Pending | Rodrigo |
| 8 | Resolve open questions (NF org/fazenda, cargo, payroll) | Pending stakeholder meetings | Rodrigo + Claudio/Valentina |
| 9 | Generate full DDL SQL for all layers | Partial (Doc 16 covers insumos only) | Claude + Joao |
| 10 | Validate Pecuario frame entities with Claudio | Pending | Rodrigo + Claudio |

---

**Version:** 1.3
**Created:** 10/02/2026
**Updated:** 11/02/2026
**Last Board Audit:** 11/02/2026 (Maquinario frame via Miro API)
**Maintained by:** Rodrigo Kugler & DeepWork AI Flows
**Changelog:**
- **v1.3:** Validated Maquinario module adjacency list (Doc 20). Added OPERADORES to ABASTECIMENTOS and MANUTENCOES edges. Added Maquinario redundancy findings (2 FKs). Updated milestones (Maquinario complete). Added Doc 20 to documentation table.
- **v1.2:** Added Dijkstra's Shortest Path framework (per Joao's directive 11/02/2026). Added full Entity Graph adjacency list with hub identification. Added Agricultura redundancy findings (Doc 19). Updated diagram conventions with Dijkstra/hub/leaf rules.
- **v1.1:** Applied redundancy analysis (Doc 17). Added Diagram Conventions. Updated FK Renames (5→3). Updated milestones for module-by-module relationship mapping.
