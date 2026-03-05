# CLAUDE.md — DeepWork AI Flows / Projeto SOAL

> Contexto sempre ativo para Claude Code neste repositório.
> Para contexto profundo, carregar os agent files referenciados na seção final.

---

## 1. Identidade do Projeto

**Empresa:** DeepWork AI Flows (Rodrigo Kugler — CEO/Comercial | João Vitor Balzer — CTO/Técnico)
**Posicionamento:** Consultoria + automação personalizada. Não somos software SaaS genérico.
**Projeto ativo:** SOAL — Serra da Onça Agropecuária (cliente: Claudio Kugler)
**Fase atual:** DDL consolidado + INSERT scripts prontos + coleta de dados em andamento
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## 2. Arquitetura Geral

**Stack:** Python + FastAPI | PostgreSQL | N8N (automações) | Power BI / Looker Studio
**Padrão de dados:** Medallion Architecture — Bronze (raw) → Silver (limpo) → Gold (analytics)
**O ER diagram define o Bronze layer.** Silver e Gold são transformações, não entidades.
**Infra:** Docker + Docker Compose
**DDL status:** ✅ 57 tabelas, 40 ENUMs, 3 views, 3 funções, ~120 indexes, ~50 triggers — tudo consolidado em SQL único
**Prisma schema:** ✅ 57 modelos, 40 enums, relações completas
**INSERT scripts:** ✅ Seeds (23k linhas) + Dados históricos (43k linhas, ~37k registros)

---

## 3. Convenções de Nomenclatura — SEMPRE SEGUIR

| Elemento | Convenção | Exemplo |
|----------|-----------|---------|
| Entidades ER | UPPER_SNAKE_CASE singular | `TALHAO_SAFRA`, `OPERACAO_CAMPO` |
| Tabelas SQL | plural snake_case | `talhao_safras`, `operacoes_campo` |
| Primary Keys | `entidade_id` UUID | `talhao_safra_id UUID` |
| Foreign Keys | `entidade_referenciada_id` | `safra_id`, `talhao_id` |
| Atributos | snake_case | `area_ha`, `horimetro_inicial` |
| Timestamps | sempre os dois | `created_at`, `updated_at` |
| PKs | **sempre UUID** — nunca auto-increment | `DEFAULT gen_random_uuid()` |

---

## 4. Regras do Diagrama ER — SEMPRE APLICAR

### 4.1 Dijkstra: Validação de FK Redundante
Antes de propor qualquer FK nova, rodar o check:
1. Remover o FK proposto A→C temporariamente
2. Encontrar o caminho mais curto de A até C via edges existentes
3. Decisão:
   - **Sem caminho** → FK é ESSENCIAL — desenhar
   - **Caminho ≤ 2 hops** → FK é REDUNDANTE — NÃO desenhar
   - **Caminho = 3 hops** → GRAY ZONE — não desenhar no diagrama, pode existir no DDL com comentário `-- DENORM`
   - **Caminho ≥ 4 hops** → considerar denormalização apenas no DDL

### 4.2 Regras Absolutas
- **org_id:** Toda entidade carrega `organization_id` mas ele **NUNCA** é desenhado no diagrama. Usar nota no board.
- **Abstração:** NUNCA nomear entidade com o nome de sistema externo. `fuel_supply` não `vestro_fuel`.
- **Inside-out:** Entidades internas primeiro. Integrações externas são a ÚLTIMA camada.
- **Hub entities:** OPERACAO_CAMPO, APLICACAO_INSUMO, ANIMAL, PRODUTO_INSUMO têm 8+ conexões. Nunca criar atalhos cross-hub.
- **Leaf entities:** Entidades detalhe (PLANTIO_DETALHE, COLHEITA_DETALHE, etc.) conectam SOMENTE ao pai. Zero FKs extras.

### 4.3 Padrão de Entidade
```sql
CREATE TABLE nome_tabela (
    entidade_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- FKs de negócio
    -- campos de negócio
    status        VARCHAR(20) DEFAULT 'active',  -- soft delete
    created_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## 5. Arquitetura de Dados SOAL — 7 Camadas

| Layer | Cor | Entidades principais | Status V0 |
|-------|-----|---------------------|-----------|
| Sistema | Blue #c6dcff | ADMINS, OWNERS, ORGANIZATIONS, USERS, RBAC | ✅ DDL + CSV + INSERT |
| Territorial | Lime #dbfaad | FAZENDAS, TALHOES, SILOS, SAFRAS, CULTURAS, TALHAO_SAFRA, PARCEIRO_COMERCIAL | ✅ DDL + CSV + INSERT |
| Agrícola | Yellow #fff6b6 | OPERACAO_CAMPO, PLANTIO/COLHEITA/PULVERIZACAO_DETALHE, PRODUTO_INSUMO, COMPRA/ESTOQUE/APLICACAO_INSUMO | ✅ DDL + CSV parcial |
| Operacional | Cyan #ccf4ff | MAQUINAS, OPERADORES, ABASTECIMENTOS, MANUTENCOES | ✅ DDL + CSV + INSERT |
| Financeiro | Orange #f8d3af | NOTA_FISCAL, CONTA_PAGAR/RECEBER, CENTRO_CUSTO, CONTRATOS | ✅ DDL + CSV (Castrolanda) |
| UBG | Yellow mix | TICKET_BALANCA, RECEBIMENTO_GRAO, CONTROLE_SECAGEM, ESTOQUE_SILO, SAIDA_GRAO | ✅ DDL + CSV + INSERT |
| Pecuária | Green #adf0c7 | ANIMAL, LOTE, PASTO, MANEJO, REPRODUCAO... | ⛔ FORA DO ESCOPO V0 |

**Entidade central:** `TALHAO_SAFRA` — 90% dos relatórios passam por ela.
**Entidade crítica de digitalização:** `TICKET_BALANCA` — Josmar usa caderno hoje.

---

## 6. Categorias de Coleta de Dados

| Cat | Método | Executor | Frequência |
|-----|--------|----------|------------|
| **A — Seed** | SQL script (João) | João | Uma vez |
| **B — CSV Import** | Template CSV → script Python | Rodrigo coleta, João importa | Pontual |
| **C — Form** | Formulário web/mobile | Usuário final | Contínuo |
| **D — API** | Script automático (N8N/Python) | Automação | Periódico |
| **E — Auto** | Trigger/stored procedure | Sistema | Tempo real |

**Regra de dependência:** Nunca popular entidade filha antes da entidade pai existir.
Ordem: Fase 0 (raízes) → Fase 1 (sistema) → Fase 2 (território) → Fase 3 (operacional) → Fase 4 (financeiro base) → Fase 5 (planejamento safra) → Fase 6 (operações contínuas) → Fase 7 (auto-calculado).

---

## 7. Fora do Escopo V0 — NUNCA incluir no planejamento atual

- ⛔ Toda a camada Pecuária (22+ entidades)
- ⛔ Integração John Deere Operations Center
- ⛔ Entidades de Infraestrutura (logs, webhooks, alertas) — geradas automaticamente

---

## 8. Stakeholders SOAL

| Pessoa | Papel | Entidades que alimenta |
|--------|-------|------------------------|
| **Claudio Kugler** | Owner (28 anos de experiência) | Valida tudo — decisor final |
| **Tiago** | Gerente de Maquinário | MAQUINAS (CSV), OPERACAO_CAMPO (form), MANUTENCOES |
| **Valentina** | Administrativa | CONTA_PAGAR/RECEBER, COMPRA_INSUMO, CONTRATOS, TRABALHADOR_RURAL |
| **Alessandro** | Agrônomo | TALHAO_SAFRA (planejamento), ANALISE_SOLO, RECOMENDACAO_ADUBACAO, RECEITUARIO. Prescreve TODAS operações campo. Usa apostila manual → AgriWin (~3h/sem). 2 funcionários com limitação leitura/escrita → entrada por áudio obrigatória. |
| **Lucas** | Agrônomo/Consultor histórico | Excel com dados desde 1994. Emite receituários agronômicos. Planejamento safra com Alessandro+Claudio. Dados: TALHAO_SAFRA hist, ANALISE_SOLO. Fonte: Fundação ABC. |
| **Vanessa** | Operadora Balança UBG | TICKET_BALANCA (pesagem + digitação), consolida dados a cada 15 dias |
| **Josmar** | Operador UBG/Balança | TICKET_BALANCA (análise qualidade), RECEBIMENTO_GRAO, CONTROLE_SECAGEM, SAIDA_GRAO |
| **João Vitor Balzer** | CTO | DDL, seeds, imports, integrações, triggers |
| **Rodrigo Kugler** | CEO/Produto | Coordenação geral, coleta de dados, regras de negócio |

---

## 9. Regras de Negócio Críticas SOAL

- **Safra:** Ano fiscal de 01/julho a 30/junho. Ex: Safra 25/26 = Jul 2025 → Jun 2026.
- **Semente ≠ Soja:** SOAL produz sementes certificadas para a Castrolanda — cultura separada.
- **UBG é independente:** Tem custos próprios (lenha, energia) separados dos custos agrícolas.
- **Custo médio ponderado:** Método de custeio do estoque de insumos (ver DDL Doc 16).
- **Ticket Balança = ponto de transferência:** Grão passa de responsabilidade "Agricultura" para "UBG" nesse momento.
- **Maquinas pertencem à Organização, não à Fazenda:** Custo alocado via OPERACAO_CAMPO.
- **Lenha é PRODUTO_INSUMO:** Tipo `LENHA`, grupo `geral`. Consumida na secagem da UBG.
- **Centro de Custo tem 6 níveis:** Org → Fazenda → Safra → Cultura → Talhão → Tipo de custo.
- **`epoca` em TALHAO_SAFRA:** Mesmo talhão pode ter SAFRA (verão) + SAFRINHA (2a safra) no mesmo ano. ✅ Campo já incluído no DDL consolidado e Prisma.
- **Gleba ≠ Talhão:** Dentro de uma aba de talhão no Ticket Balança podem existir múltiplas glebas (sub-áreas). Ex: talhão CAPINZAL tem glebas HERMATRIA, BANACK, URUGUAI. Campo `gleba` já existe em TICKET_BALANCA.
- **UBG tem dois fluxos de receita:** (1) varejo de subprodutos (feno, quirera, milho, aveia, pré-secado); (2) serviço de pesagem pública (bovinos, suinos, eucalipto, pinus). Custos próprios separados da agricultura.
- **Fluxo Ticket Balança atual:** Vanessa pesa e digita → Josmar preenche análise de qualidade → Vanessa consolida a cada 15 dias na planilha. Digitalização = eliminar caderno + planilha.
- **Comissão Josmar:** 0,01% da receita anual + R$2,50/pesagem externa — calculada manualmente no fim do ano. Automatable via trigger.
- **CULTURAS seed:** 9 culturas no CSV seed: SOJA, MILHO, FEIJÃO, TRIGO, AVEIA, CEVADA, MILHETO, AZEVEM, AVEIA PRETA.
- **Naming talhões:** 183 variantes → 61 canônicos via `talhao_mapping`. Tabela de mapeamento criada no DDL.
- **Conectividade campo:** Starlink em 100% pulverizadores, ~50% plantadeiras, carros Alessandro e Tiago. 100% funcionários têm smartphone. 2 funcionários com limitação leitura/escrita → entrada por áudio é obrigatória.
- **Rotação de cultura:** 25-30% da área total em gramíneas todo ano (milho, trigo, aveia) para quebrar ciclo de doenças.
- **Histórico patógenos por talhão:** Esclerotínia (mofo branco) no LAGARTO, não no MASSACRE — decisões de manejo por talhão baseadas em histórico.
- **Capinzal:** Distância operacional = cultura única (100% milho OU 100% soja, nunca fracionado).
- **Fundação ABC:** Fonte de pesquisa para variedades e coberturas. Lucas traz resultados, filtrados por microclima local.
- **AgriWin sync NF falha:** Castrolanda demora 2-3 dias, nem todas NFs sincronizam. Até 1 dia lancando manual quando falha.

---

## 10. Sistemas Externos (fontes de dados, não entidades)

| Sistema | Dado útil | Método | Status |
|---------|-----------|--------|--------|
| **AgriWin** (legacy ERP) | Parceiros, NFs históricas, contas históricas | Export CSV → import | ✅ Dados extraídos (parceiros + insumos). Substituindo, não integrando |
| **Vestro** | Abastecimentos (combustível) + tags RFID | Portal HTML → ETL | ✅ ETL pronto (1.200 abastecimentos, 47 tags, 30 operadores) |
| **SEFAZ** | XML de NFes | API SEFAZ DFe / Webhook | V0 — planejado |
| **Castrolanda** | Extrato, C/C, capital, vendas, carga-a-carga, financiamentos | Portal HTML → ETL | ✅ 6 ETLs prontos (8.211+ transações) |
| **Fundação ABC** | Análise de solo, pesquisa variedades | Via Lucas (Excel/PDF) | Pendente coleta |
| **CAR** | KML/KMZ dos talhões | Download manual → GeoJSON | Pontual |
| **John Deere** | Telemetria de operações | API JD | ⛔ V0 fora do escopo |
| **FSI (RH)** | Folha de pagamento | Excel 118 abas → ETL | ✅ ETL pronto (87 colaboradores, 3.122 registros, 2017-2026) |

**Regra:** AgriWin é REFERÊNCIA de quais dados existem — nunca referência de como estruturar.

---

## 11. Documentos de Referência

| Doc | Caminho | Conteúdo |
|-----|---------|----------|
| **DDL Completo V0** | `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | 57 tabelas, 2.525 linhas, pronto para `psql -f` |
| **INSERT Seeds** | `09_Projetos/01_SOAL/DDL/sql/01_INSERT_SEEDS.sql` | Seeds fase 0-2 (23k linhas) |
| **INSERT Dados** | `09_Projetos/01_SOAL/DDL/sql/02_INSERT_DADOS.sql` | ~37k registros de CSVs (43k linhas) |
| **Prisma Schema** | `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | 57 modelos, 2.224 linhas |
| **GAP Analysis** | `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md` | Matriz 57 entidades x DDL x CSV x Prisma |
| **DDL Playground** | `09_Projetos/01_SOAL/DDL/soal-ddl-playground.html` | Dashboard interativo dark theme |
| **ER Playground** | `09_Projetos/01_SOAL/DDL/soal-er-playground.html` | ER diagram force-directed graph |
| Plano de Coleta | `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/24_PLANO_COLETA_DADOS.md` | Plano completo V0 + templates CSV + checklist Dia 01 |
| DDL Insumos | `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/16_DDL_MODULO_INSUMOS_ESTOQUE.md` | DDL detalhado módulo insumos |
| ER Completo | `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/08_ESTRUTURA_ER_COMPLETA_SOAL.md` | Master ER com ~92 entidades, 7 camadas |
| Centro de Custo | `09_Projetos/01_SOAL/DIAGRAMA_ER_SOAL/13_HIERARQUIA_CENTRO_CUSTO_SOAL.md` | Hierarquia 6 níveis + código de centro de custo |
| ETL Registry | `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md` | Registro mestre de todos os CSVs em IMPORTS/ |
| Reuniões SOAL | `09_Projetos/01_SOAL/REUNIOES/` | 20+ notas de reunião (Dez 2025 → Mar 2026) |

---

## 11b. Data Files Coletados (Bronze layer)

Todos em: `09_Projetos/01_SOAL/DATA/`

### IMPORTS/ — Organizado por fase

| Fase | Conteúdo | CSVs | Status |
|------|----------|------|--------|
| `fase_0/` | Seeds (culturas, insumos AgriWin) | 3 | ✅ |
| `fase_1_sistema/` | Organizations, users | 2 | ✅ |
| `fase_2/` | Safras, fazendas, talhões, matrículas, parceiros | 6 | ✅ |
| `fase_2_territorial/` | UBG, silos | 2 | ✅ (parcial — pendente Josmar) |
| `fase_3/` | Máquinas, operadores, tags Vestro, colaboradores, folha | 7 | ✅ |
| `fase_4/` | Castrolanda (extrato, C/C, capital, financiamentos, vendas, carga-a-carga) | 6 | ✅ |
| `fase_5/` | Planejamento safra | 0 | ⏳ vazio — pendente |
| `fase_6/` | Produção UBG, abastecimentos Vestro, caixa UBG | 3 | ✅ |
| `fase_6_operacoes/` | Colheita, plantio, pesagens, vendas, custo insumos, freteiros, saídas | 10 | ✅ |

### FONTE UNIFICADA — Pasta Agrícola

`DATA/AGRICULTURA/colheita/Agricola/Agricola/` — 41 planilhas, 6 safras (20/21→25/26), 7 culturas.
**UMA ÚNICA FONTE que alimenta 5 entidades:**

| Entidade destino | CSV em IMPORTS | Registros |
|-----------------|----------------|-----------|
| TICKET_BALANCA | `fase_6/09_producao_ubg.csv` | 883 tickets |
| PRODUCAO_UBG | `fase_6/09_producao_ubg.csv` | (mesmo CSV) |
| PESAGEM_AGRICOLA | `fase_6_operacoes/04_pesagens_agricola.csv` | 806 pesagens |
| TALHAO_SAFRA (hist) | Derivado | Evidência de cultivo por talhão |
| SAIDA_GRAO | `fase_6_operacoes/08_saidas_producao.csv` | 542 embarques |

### ETL Scripts ativos (30+)

| Pasta | Scripts | Dados processados |
|-------|---------|-------------------|
| `AGRICULTURA/` | etl_pesagens, etl_saidas, etl_vendas, etl_custo_insumos, etl_freteiros, etl_agricola_utils, etl_talhao_safra | Fonte unificada agrícola |
| `CASTROLANDA/` | etl_castrolanda_extrato, _cc, _pdf, _capital_html, _vendas, _carga_a_carga | 6 extrações portal Castrolanda |
| `MAQUINÁRIO/` | etl_maquinas, etl_maquinario, ABASTECIMENTOS/etl_vestro_abastecimentos | Máquinas + combustível Vestro |
| `ORG/` | etl_fazendas, etl_matriculas, etl_fuel_tanks, etl_talhoes | Estrutura territorial |
| `RH/` | etl_colaboradores, etl_folha_import, etl_folha_pagamento | Folha pagamento FSI |
| `PARCEIROS_PESSOAS/` | etl_parceiros | AgriWin parceiros |
| `INSUMOS/` | etl_insumos | AgriWin insumos |
| `UBG/` | etl_ubg_caixa | Caixa histórica UBG |

ETLs REMOVIDOS (obsoletos): `etl_producao_ubg.py`, `etl_ticket_balanca.py`, `etl_agricola.py`

### Dados pendentes

- **Soja 25/26:** Arquivo no zip é cópia do 24-25. Precisa arquivo real.
- **Milho 25/26:** Parcial — apenas SANTA RITA + SANTO ANDRE (35 tickets).
- **Análise de Solo:** Pendente coleta com Lucas/Alessandro.
- **Contratos:** Pendente Valentina.

---

## 12. DDL Consolidation

**Deliverables em:** `09_Projetos/01_SOAL/DDL/`

| Arquivo | Métricas |
|---------|----------|
| `sql/00_DDL_COMPLETO_V0.sql` | 2.525 linhas, 57 tabelas, 40 ENUMs, 3 views, 3 funções, ~120 indexes, ~50 triggers |
| `sql/01_INSERT_SEEDS.sql` | 23k linhas — seeds fase 0-2 |
| `sql/02_INSERT_DADOS.sql` | 43k linhas — ~37k registros de 35 tabelas |
| `sql/generate_inserts.py` | Script gerador de INSERTs a partir dos CSVs |
| `prisma/schema.prisma` | 2.224 linhas, 57 modelos, 40 enums |
| `GAP_ANALYSIS.md` | Matriz 57 entidades x DDL x CSV x Prisma |
| `soal-ddl-playground.html` | Dashboard interativo dark theme |
| `soal-er-playground.html` | ER diagram force-directed graph |

**Fontes consolidadas:** 9 DDL docs (16, 25a, 25b, 26, 27, 28, 29, 30, 31)

**Conflitos resolvidos:**
- trabalhadores_rurais → colaboradores (Doc 27 vence)
- PK padronizado: entidade_id (não bare `id`)
- Trigger unificada: fn_atualizar_updated_at()
- vendas_castrolanda merged em vendas_grao
- 5 tabelas órfãs criadas: ubgs, tanques_combustivel, tags_vestro, talhao_mapping, ubg_caixa

**Próximo passo João:** `psql -f 00_DDL_COMPLETO_V0.sql` → `psql -f 01_INSERT_SEEDS.sql` → `psql -f 02_INSERT_DADOS.sql`

---

## 13. Agent Files (contexto profundo — carregar quando necessário)

| Agent | Quando carregar |
|-------|----------------|
| `business-context-expert.agent.md` | Estratégia de negócio, posicionamento, precificação |
| `er-diagram-architect.agent.md` | Regras ER detalhadas, Dijkstra completo, guia Miro |
| `soal-er-board-context.agent.md` | Estado atual do board, adjacency list completo das 92+ entidades |
| `data-collection-engineer.agent.md` | Coleta de dados entidade por entidade, templates CSV |
| `ddl-database-engineer.agent.md` | DDL/SQL/Prisma, contexto completo para trabalhar com DB |
| `audio-transcription-analyzer.agent.md` | Análise de transcrições de reunião → docs estruturados |
| `diagnostic-document-generator.agent.md` | Geração de diagnósticos formais para clientes |

**Todos em:** `.github/agents/` (12 arquivos total)

---

## 14. Princípios de Trabalho

1. **Simples antes de complexo** — "boring is good". N8N antes de custom code.
2. **MVP primeiro** — iterar com feedback, não construir perfeito.
3. **Velocidade de entrega** > arquitetura perfeita.
4. **Resultado mensurável** — toda decisão técnica deve ter ROI claro para o cliente.
5. **Sem sobre-engenharia** — não criar abstração para caso de uso único.
6. **Offline-first para campo** — sistemas de campo funcionam sem internet.
7. **Operator POV** — UX para o Josmar: botão grande, 3 toques max, funciona com mão suja.

---

## 15. Estrutura de Pastas do Repositório

```
business-discoveries/
├── .github/agents/              # 12 agent files (contexto profundo)
├── 01_Visao_Negocio/            # Estratégia, modelo de negócio, acordo sócios
├── 02_Identidade_Marca/         # Missão, valores, personas
├── 03_Identidade_Visual/        # Logo, cores, design system
├── 07_Operacional/              # Roteiros entrevista, guia precificação, templates
├── 08_Ferramentas/              # Scripts utilitários
├── 09_Projetos/01_SOAL/         # ⭐ PROJETO PRINCIPAL
│   ├── DATA/                    # Bronze layer (2.261 arquivos, 1.5GB+)
│   │   ├── AGRICULTURA/         # Fonte unificada (41 planilhas, 7 ETLs)
│   │   ├── CASTROLANDA/         # Portal cooperativa (6 ETLs)
│   │   ├── IMPORTS/             # CSVs organizados por fase (38 ativos)
│   │   ├── INSUMOS/             # AgriWin legacy (18.499 registros)
│   │   ├── MAQUINÁRIO/          # Máquinas + Vestro abastecimentos
│   │   ├── ORG/                 # Matrículas, fazendas (88 matrículas, 4.127 ha)
│   │   ├── PARCEIROS_PESSOAS/   # AgriWin parceiros (2.201 registros)
│   │   ├── RH/                  # Folha pagamento FSI (87 colaboradores)
│   │   ├── UBG/                 # Caixa histórica (19.177 registros)
│   │   └── ETL_REGISTRY.md     # Registro mestre de todos CSVs
│   ├── DDL/                     # Schema consolidado
│   │   ├── sql/                 # DDL + INSERT scripts
│   │   ├── prisma/              # Prisma schema
│   │   └── *.html               # Playgrounds interativos (DDL + ER)
│   ├── DIAGRAMA_ER_SOAL/        # 31 docs de design ER (Docs 08-31)
│   ├── REUNIOES/                # 20+ notas de reunião (Dez 2025 → Mar 2026)
│   ├── DASHBOARD_MOCKUPS/       # 9 prompts Figma + design system
│   └── DPWAI_APP_INSTRUCTIONS/  # 4 tasks de fix do app
├── 10_Gestao_Tecnica/           # Stack tecnológico, arquitetura
├── 11_Juridico/                 # Briefings jurídico/contábil
├── _archive/                    # Arquivos deprecados (26 pastas)
└── CLAUDE.md                    # Este arquivo
```

---

*Última atualização: 2026-03-04 (sessão 4 — varredura completa) | Mantido por: Rodrigo Kugler & DeepWork AI Flows*
