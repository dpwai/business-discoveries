# CLAUDE.md — DeepWork AI Flows / Projeto SOAL

> Contexto sempre ativo para Claude Code neste repositório.
> Para contexto profundo, carregar os agent files referenciados na seção final.

---

## 1. Identidade do Projeto

**Empresa:** DeepWork AI Flows (Rodrigo Kugler — CEO/Comercial | João Vitor Balzer — CTO/Técnico)
**Posicionamento:** Consultoria + automação personalizada. Não somos software SaaS genérico.
**Projeto ativo:** SOAL — Serra da Onça Agropecuária (cliente: Claudio Kugler)
**Fase atual:** Coleta de dados + construção do Bronze layer do Data Warehouse
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## 2. Arquitetura Geral

**Stack:** Python + FastAPI | PostgreSQL | N8N (automações) | Power BI / Looker Studio
**Padrão de dados:** Medallion Architecture — Bronze (raw) → Silver (limpo) → Gold (analytics)
**O ER diagram define o Bronze layer.** Silver e Gold são transformações, não entidades.
**Infra:** Docker + Docker Compose

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
| Sistema | Blue #c6dcff | ADMINS, OWNERS, ORGANIZATIONS, USERS, RBAC | ✅ mapeado |
| Territorial | Lime #dbfaad | FAZENDAS, TALHOES, SILOS, SAFRAS, CULTURAS, TALHAO_SAFRA, PARCEIRO_COMERCIAL | ✅ mapeado |
| Agrícola | Yellow #fff6b6 | OPERACAO_CAMPO, PLANTIO/COLHEITA/PULVERIZACAO_DETALHE, PRODUTO_INSUMO, COMPRA/ESTOQUE/APLICACAO_INSUMO | ✅ DDL parcial (Doc 16) |
| Operacional | Cyan #ccf4ff | MAQUINAS, OPERADORES, ABASTECIMENTOS, MANUTENCOES | ✅ mapeado |
| Financeiro | Orange #f8d3af | NOTA_FISCAL, CONTA_PAGAR/RECEBER, CENTRO_CUSTO, CONTRATOS | ✅ mapeado |
| UBG | Yellow mix | TICKET_BALANCA, RECEBIMENTO_GRAO, CONTROLE_SECAGEM, ESTOQUE_SILO, SAIDA_GRAO | ✅ mapeado |
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
| **Alessandro** | Agrônomo | TALHAO_SAFRA (planejamento), ANALISE_SOLO, RECOMENDACAO_ADUBACAO, RECEITUARIO |
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
- **`epoca` em TALHAO_SAFRA:** Mesmo talhão pode ter SAFRA (verão) + SAFRINHA (2a safra) no mesmo ano. Campo **AUSENTE** no schema atual — João deve adicionar `epoca ENUM('SAFRA','SAFRINHA','TERCEIRA_SAFRA')`.
- **Gleba ≠ Talhão:** Dentro de uma aba de talhão no Ticket Balança podem existir múltiplas glebas (sub-áreas). Ex: talhão CAPINZAL tem glebas HERMATRIA, BANACK, URUGUAI. Campo `gleba` já existe em TICKET_BALANCA.
- **UBG tem dois fluxos de receita:** (1) varejo de subprodutos (feno, quirera, milho, aveia, pré-secado); (2) serviço de pesagem pública (bovinos, suinos, eucalipto, pinus). Custos próprios separados da agricultura.
- **Fluxo Ticket Balança atual:** Vanessa pesa e digita → Josmar preenche análise de qualidade → Vanessa consolida a cada 15 dias na planilha. Digitalização = eliminar caderno + planilha.
- **Comissão Josmar:** 0,01% da receita anual + R$2,50/pesagem externa — calculada manualmente no fim do ano. Automatable via trigger.
- **CULTURAS seed incompleto:** Descobertos nos CSVs — adicionar: FEIJÃO, MILHETO, AZEVEM, AVEIA PRETA, AVEIA BRANCA (além de TRIGO, AVEIA genérico já existentes).
- **Naming talhões inconsistente entre módulos AgriWin:** Talhões, Plantio e Operações usam nomes diferentes para o mesmo talhão. Criar tabela de mapeamento antes de importar.

---

## 10. Sistemas Externos (fontes de dados, não entidades)

| Sistema | Dado útil | Método | Status |
|---------|-----------|--------|--------|
| **AgriWin** (legacy ERP) | Parceiros, NFs históricas, contas históricas | Export CSV → import | Substituindo, não integrando |
| **Vestro** | Abastecimentos (combustível) | Crawler/API (João auditar) | V0 |
| **SEFAZ** | XML de NFes | API SEFAZ DFe | V0 |
| **Castrolanda** | Compras de insumos | API planejada | V0/futuro |
| **CAR** | KML/KMZ dos talhões | Download manual → GeoJSON | Pontual |
| **John Deere** | Telemetria de operações | API JD | ⛔ V0 fora do escopo |

**Regra:** AgriWin é REFERÊNCIA de quais dados existem — nunca referência de como estruturar.

---

## 11. Documentos de Referência

| Doc | Caminho | Conteúdo |
|-----|---------|----------|
| Plano de Coleta | `19_DIAGRAMA_ER_SOAL/24_PLANO_COLETA_DADOS.md` | Plano completo V0 + templates CSV + checklist Dia 01 |
| DDL Insumos | `19_DIAGRAMA_ER_SOAL/16_DDL_MODULO_INSUMOS_ESTOQUE.md` | Único DDL SQL completo disponível |
| ER Completo | `19_DIAGRAMA_ER_SOAL/08_ESTRUTURA_ER_COMPLETA_SOAL.md` | Master ER com ~90 entidades, 7 camadas |
| Centro de Custo | `19_DIAGRAMA_ER_SOAL/13_HIERARQUIA_CENTRO_CUSTO_SOAL.md` | Hierarquia 6 níveis + código de centro de custo |
| AgriWin Legacy | `00_CONHECIMENTO/AGRIWIN/` | Estrutura do sistema legado (para referência de dados) |
| Reuniões SOAL | `09_Projetos/02_SOAL/10_REUNIOES/` | Histórico de decisões técnicas |

---

## 11b. Data Files Coletados (Bronze layer seeds)

Todos em: `09_Projetos/02_SOAL/DATA/`

| Arquivo | Entidade alvo | Registros | Observação |
|---------|--------------|-----------|------------|
| `Listagem_Talhoes.csv` | TALHOES | 72 | 7 fazendas, precisa de KML/CAR para geo |
| `Listagem_Plantio_24_25.csv` | TALHAO_SAFRA | 63 / 2.464 ha | Inclui FEIJÃO e MILHETO |
| `Listagem_Plantio_25_26.csv` | TALHAO_SAFRA | 54 / 1.996 ha | Safra inverno: TRIGO, AZEVEM, AVEIA |
| `Lista_Maquinas_Consolidado.csv` | MAQUINAS | 183 (156 ativo) | Unificação de 3 planilhas brutas |
| `UBG_Caixa_Historico_Clean.csv` | CAIXA_UBG (futuro) | 19.325 registros | ETL: `DATA/UBG/etl_ubg_caixa.py` — 2011–2026 |

**FONTE UNIFICADA — Pasta Agrícola:** `DATA/AGRICULTURA/colheita/Agricola/Agricola/`
A "Planilha Controle de Produção" (1 por cultura por safra) é **UMA ÚNICA FONTE** que alimenta 5 entidades:

| Entidade destino | CSV em IMPORTS | Registros |
|-----------------|----------------|-----------|
| TICKET_BALANCA | `fase_6/09_producao_ubg.csv` | 883 tickets (3 safras: 22/23→25/26) |
| PRODUCAO_UBG | `fase_6/09_producao_ubg.csv` | (mesmo CSV, perspectiva UBG) |
| PESAGEM_AGRICOLA | `fase_6_operacoes/04_pesagens_agricola.csv` | 806 pesagens |
| TALHAO_SAFRA (hist) | Derivado → enriquece `fase_5/07_talhao_safra_*.csv` | Evidência de cultivo por talhão |
| SAIDA_GRAO | `fase_6_operacoes/08_saidas_producao.csv` | 542 embarques |

ETLs ativos: `etl_pesagens.py`, `etl_saidas.py`, `etl_agricola_utils.py` (em `DATA/AGRICULTURA/`)
ETLs REMOVIDOS: ~~`etl_producao_ubg.py`~~, ~~`etl_ticket_balanca.py`~~, ~~`etl_agricola.py`~~ (monolitos obsoletos)

**Schema CSV de Máquinas:** `codigo, nome, categoria, subtipo, ano, chassi, num_serie_renavam, num_motor, responsavel, trator_vinculado, valor_compra, data_compra, valor_atual, nota_fiscal, status`
- `categoria`: MAQUINA | IMPLEMENTO
- `trator_vinculado`: referência informal ao equipamento pai nos implementos (ex: "S660-01", "T-09")
- Mapeamento para códigos formais necessário antes da importação SQL

**Validação pendente Tiago:** `10_REUNIOES/VALIDACAO_TIAGO_MAQUINAS.md` — 9 seções, 4 itens alta prioridade que bloqueiam importação

---

## 12. Agent Files (contexto profundo — carregar quando necessário)

| Agent | Quando carregar |
|-------|----------------|
| `business-context-expert.agent.md` | Estratégia de negócio, posicionamento, precificação |
| `er-diagram-architect.agent.md` | Regras ER detalhadas, Dijkstra completo, guia Miro |
| `soal-er-board-context.agent.md` | Estado atual do board, adjacency list completo das 90+ entidades, todos os relacionamentos mapeados |
| `data-collection-engineer.agent.md` | Coleta de dados entidade por entidade, templates CSV, protocolo de coleta por stakeholder |

**Todos em:** `.github/agents/`

---

## 13. Princípios de Trabalho

1. **Simples antes de complexo** — "boring is good". N8N antes de custom code.
2. **MVP primeiro** — iterar com feedback, não construir perfeito.
3. **Velocidade de entrega** > arquitetura perfeita.
4. **Resultado mensurável** — toda decisão técnica deve ter ROI claro para o cliente.
5. **Sem sobre-engenharia** — não criar abstração para caso de uso único.
6. **Offline-first para campo** — sistemas de campo funcionam sem internet.
7. **Operator POV** — UX para o Josmar: botão grande, 3 toques max, funciona com mão suja.

---

*Última atualização: 2026-02-27 (sessão 3) | Mantido por: Rodrigo Kugler & DeepWork AI Flows*
