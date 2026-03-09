# GAP ANALYSIS — Entidade × DDL × CSV × Prisma

> Gerado: 2026-03-04 | Projeto SOAL V0 (Bronze Layer)
> Cruzamento de 9 DDL docs, 38 CSVs em IMPORTS/, 19 modelos Prisma, 48 entidades do playground

---

## 1. Matriz Mestre

### Legenda
- **DDL Doc:** Número do documento markdown fonte
- **CREATE TABLE:** ✅ existe | ❌ falta
- **ENUMs:** Lista dos ENUMs usados pela tabela
- **Triggers:** ✅ tem trigger updated_at | ❌ não tem
- **CSV:** Arquivo em `DATA/IMPORTS/` (se existir)
- **Records:** Quantidade de registros no CSV
- **Prisma:** ✅ existe no schema | ❌ falta
- **Status:** `completo` | `parcial` | `pendente` | `sem_dados`

---

### SEÇÃO 0 — SISTEMA (Doc 26)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| ADMINS | 26 | ✅ | — | ✅ | — | 0 | ✅ | sem_dados |
| OWNERS | 26 | ✅ | — | ✅ | — | 1 | ✅ | sem_dados |
| ORGANIZATIONS | 26 | ✅ | — | ✅ | `fase_1_sistema/01_organizations.csv` | 1 | ✅ | completo |
| ORG_SETTINGS | 26 | ✅ | — | ✅ | — | 0 | ✅ | sem_dados |
| USERS | 26 | ✅ | — | ✅ | `fase_1_sistema/02_users.csv` | 8 | ✅ | completo |
| ROLES | 26 | ✅ | — | ✅ | — | 0 | ✅ | sem_dados |
| PERMISSIONS | 26 | ✅ | — | — | — | 0 | ✅ | sem_dados |
| USER_ROLES | 26 | ✅ | — | — | — | 0 | ✅ | sem_dados |
| ROLE_PERMISSIONS | 26 | ✅ | — | — | — | 0 | ✅ | sem_dados |

### SEÇÃO 1 — TERRITORIAL (Doc 26 + Doc 25b)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| FAZENDAS | 26 | ✅ | tipo_fazenda, tipo_solo | ✅ | `fase_2/02_fazendas.csv` | 9 | ✅ | completo (9 fazendas, 4.127 ha, CAR+CCIR+ITR) |
| TALHOES | 26 | ✅ | — | ✅ | `fase_2/03_talhoes.csv` | 71 | ✅ | completo |
| SAFRAS | 26 | ✅ | status_safra, epoca_safra | ✅ | `fase_2/01_safras.csv` | 9 | ✅ | completo |
| CULTURAS | 26 | ✅ | grupo_cultura | ✅ | `fase_0/01_culturas.csv` | 126 | ✅ | completo |
| TALHAO_SAFRA | 26+32 | ✅ | epoca_safra, status_talhao_safra | ✅ | `fase_5/03_talhao_safra.csv` (50, planejamento 25/26) + `fase_6_operacoes/12_plantio_historico.csv` (152) | 202 | ✅ | completo. Fase 5 com ON CONFLICT DO NOTHING (prioridade). Campos planejamento: data_plantio_prevista, status_planejamento, meta_produtividade_sc_ha, atribuido_por, aprovado_por, data_aprovacao |
| SILOS | 26 | ✅ | tipo_silo | ✅ | `fase_2_territorial/02_silos_ubg.csv` | 8 | ✅ | completo |
| PARCEIRO_COMERCIAL | 26 | ✅ | tipo_parceiro | ✅ | `fase_2/06_parceiros_agriwin.csv` | 2.201 | ✅ | completo |
| MATRICULAS | 25b | ✅ | — | ❌ | `fase_2/04_matriculas.csv` | 88 | ❌ | completo |
| UBG | — | ✅ | — | ✅ | `fase_2_territorial/01_ubg.csv` | 1 | ✅ | completo |

### SEÇÃO 2 — OPERACIONAL (Doc 26 + Doc 27)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| MAQUINAS | 26 | ✅ | categoria_maquina, tipo_maquina, status_maquina | ✅ | `fase_3/04_maquinas.csv` + `fase_3/04_implementos.csv` | 57+126 (com status + marca) | ✅ | completo |
| OPERADORES | 26 | ✅ | tipo_cnh | ✅ | `fase_3/05_operadores.csv` | 15 | ✅ | completo |
| ABASTECIMENTOS | 26 | ✅ | tipo_combustivel | ✅ | `fase_6/10_abastecimentos_vestro.csv` | 1.200 | ✅ | completo |
| MANUTENCOES | 26 | ✅ | tipo_manutencao, status_manutencao | ✅ | — | 0 | ✅ | sem_dados |
| ~~TRABALHADORES_RURAIS~~ | ~~26~~ | ~~✅~~ | — | — | — | — | ~~✅~~ | **SUBSTITUÍDO** |
| COLABORADORES | 27 | ✅ | setor_trabalho, tipo_contrato_trabalho | ✅ | `fase_3/07_colaboradores.csv` | 82 | ❌ | completo |
| FOLHA_PAGAMENTO | 27 | ✅ | tipo_folha_pagamento | ✅ | `fase_3/08_folha_pagamento.csv` | 3.122 | ❌ | completo |
| TAGS_VESTRO | — | ❌ | — | — | `fase_3/05_tags_maquinas_vestro.csv` | 47 | ❌ | **ÓRFÃ** |
| TANQUES_COMBUSTIVEL | — | ❌ | — | — | `fase_3/06_fuel_tanks.csv` | 5 | ❌ | **ÓRFÃ** |
| OPERADORES_VESTRO | — | ❌ | — | — | `fase_3/04_operadores_vestro.csv` | 30 | ❌ | **ÓRFÃ** |

### SEÇÃO 3 — AGRÍCOLA: INSUMOS (Doc 16)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| PRODUTO_INSUMO | 16 | ✅ | tipo_insumo, grupo_insumo, classe_toxicologica, classe_ambiental | ✅ | `fase_0/03_produto_insumo_agriwin.csv` + `fase_0/03_produto_insumo_castrolanda.csv` | 18.499 + 395 | ❌ | completo |
| COMPRA_INSUMO | 16 | ✅ | fonte_compra, status_compra | ✅ | `fase_4/11_compra_insumo_castrolanda.csv` | 6.331 | ❌ | completo |
| ESTOQUE_INSUMO | 16 | ✅ | status_estoque | ✅ | — | 0 | ❌ | sem_dados |
| MOVIMENTACAO_INSUMO | 16 | ✅ | tipo_movimentacao_insumo | — | — | 0 | ❌ | sem_dados |
| APLICACAO_INSUMO | 16+32 | ✅ | metodo_aplicacao, contexto_aplicacao | ✅ | `fase_5/06_aplicacao_insumo.csv` (11, com FK) + `fase_6_operacoes/12_consumo_agriwin.csv` (raw, 9.482 ops) | 21.173 | ❌ | parcial. Fase 5 INSERTs com operacao_campo_id + talhao_safra_id resolvidos |
| RECEITUARIO_AGRONOMICO | 16 | ✅ | — | ✅ | — | 0 | ❌ | sem_dados |

### SEÇÃO 4 — AGRÍCOLA: OPERAÇÕES DE CAMPO (Doc 25a)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| OPERACAO_CAMPO | 25a+32 | ✅ | tipo_operacao_campo, status_operacao_campo | ✅ | `fase_5/05_operacoes_campo.csv` (7, com FK completo) + `fase_6_operacoes/12_consumo_agriwin.csv` (9.482 ops AgriWin) + `01+02_operacoes.csv` | 9.520 | ❌ | parcial. Fase 5 INSERTs com talhao_safra_id + safra_acao_id resolvidos |
| PLANTIO_DETALHE | 25a | ✅ | — | ❌ | `fase_6_operacoes/12_plantio_historico.csv` (cultivar, origem, tratamento) | 152 | ❌ | parcial |
| COLHEITA_DETALHE | 25a | ✅ | — | ❌ | `fase_6_operacoes/03_colheita_detalhe.csv` | 1 | ❌ | sem_dados |
| PULVERIZACAO_DETALHE | 25a | ✅ | — | ❌ | — | 0 | ❌ | sem_dados |
| DRONE_DETALHE | 25a | ✅ | — | ❌ | — | 0 | ❌ | sem_dados |
| TRANSPORTE_COLHEITA_DETALHE | 25a | ✅ | tipo_transporte | ❌ | — | 0 | ❌ | sem_dados |

### SEÇÃO 5 — UBG / PÓS-COLHEITA (Doc 28)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| TICKET_BALANCA | 28+32 | ✅ | tipo_ticket_balanca, status_ticket | ✅ | `fase_6/15_ticket_balancas.csv` (883) | 883 | ✅ | completo. PESO ONLY — campos qualidade em RECEBIMENTO_GRAO |
| PRODUCAO_UBG | 28 | ✅ | — | ✅ | `fase_6/_archive/09_producao_ubg.csv` (arquivado) | 883 | ✅ | completo. Tabela legada — dados reais agora em ticket_balancas + recebimentos_grao |
| PESAGEM_AGRICOLA | 28 | ✅ | — | ✅ | `fase_6_operacoes/04_pesagens_agricola.csv` | 806 | ✅ | completo |
| SAIDA_GRAO | 28 | ✅ | tipo_saida_grao | ✅ | `fase_6_operacoes/08_saidas_producao.csv` | 542 | ✅ | completo |
| RECEBIMENTO_GRAO | 28 | ✅ | — | ✅ | `fase_6/16_recebimentos_grao.csv` (875) | 875 | ✅ | completo. Classificacao pre-secagem (Josmar). FK subquery por ticket match |
| CONTROLE_SECAGEM | 28 | ✅ | tipo_secagem | ✅ | `fase_6/17_controles_secagem.csv` | 5 | ✅ | ⚠️ DEMO — dados fictícios. Substituir por dados reais Josmar/Vanessa. FK recebimento_grao_id (nullable) |
| LEITURA_SECAGEM | 28 | ✅ | tipo_secagem | ✅ | `fase_6/18_leituras_secagem.csv` | 25 | ✅ | ⚠️ DEMO — dados fictícios. Substituir por dados reais |
| ESTOQUE_SILO | 28 | ✅ | status_estoque_silo | ✅ | `fase_6/20_estoques_silo.csv` | 10 | ❌ | ⚠️ DEMO — dados fictícios. Substituir por dados reais |
| ALOCACAO_SILO | 28 | ✅ | tipo_alocacao_silo | ✅ | `fase_6/19_alocacoes_silo.csv` | 8 | ✅ | ⚠️ DEMO — dados fictícios. Substituir por dados reais |

### SEÇÃO 6 — FINANCEIRO / COOPERATIVA (Doc 29)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| EXTRATO_COOPERATIVA | 29 | ✅ | tipo_transacao_extrato | ✅ | `fase_4/07_castrolanda_extrato.csv` | 8.211 | ❌ | completo |
| CC_COOPERATIVA | 29 | ✅ | tipo_transacao_cc | ✅ | `fase_4/09_castrolanda_cc_completo.csv` | 2.891 | ❌ | completo |
| CONTA_CAPITAL | 29 | ✅ | tipo_transacao_capital | ✅ | `fase_4/12_castrolanda_capital_html.csv` | 95 | ❌ | completo |
| FINANCIAMENTO_COOP | 29 | ✅ | tipo_financiamento_coop | ✅ | `fase_4/11_castrolanda_financiamentos.csv` | 220 | ❌ | completo |
| VENDA_GRAO | 29 | ✅ | — | ✅ | `fase_4/13_castrolanda_vendas.csv` | 170 | ❌ | completo |
| CARGA_A_CARGA | 29 | ✅ | modalidade_carga | ✅ | `fase_4/14_castrolanda_carga_a_carga.csv` | 1.309 | ❌ | completo |
| CUSTO_INSUMO_COOP | 29 | ✅ | — | ✅ | `fase_6_operacoes/06_custo_insumos_castrolanda.csv` | 553 | ❌ | completo |

### SEÇÃO 6b — FINANCEIRO / FSI (4 tabelas)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| FLUXO_CAIXA_FSI | FSI | ✅ | tipo_registro_fsi | ✅ | `fase_4/15_fluxo_caixa_fsi.csv` | 10.119 | ✅ | completo |
| CAIXA_ESCRITORIO_FSI | FSI | ✅ | — | ✅ | `fase_4/16_caixa_escritorio_fsi.csv` | 1.185 | ✅ | completo |
| KUGLER_X_FSI | FSI | ✅ | — | ✅ | `fase_4/17_kugler_x_fsi.csv` | 1.499 | ✅ | completo |
| CONSORCIOS_FSI | FSI | ✅ | situacao_consorcio | ✅ | `fase_4/18_consorcios_fsi.csv` | 20 | ✅ | completo |

> **Nota:** Dados extraidos de "Contas a pagar - FSI (1).xlsx" (contabilidade FSI). DDL + Prisma + INSERT completos desde 2026-03-06.

### SEÇÃO 7 — FRETE + VENDAS DIRETAS (Doc 30)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| FRETEIRO | 30 | ✅ | — | ✅ | `fase_6_operacoes/07_freteiros.csv` | 116 | ❌ | completo |
| VENDA_DIRETA | 30 | ✅ | — | ✅ | `fase_6_operacoes/05b_vendas_diretas.csv` | 73 | ❌ | completo |

### SEÇÃO 8 — VENDAS CASTROLANDA (Doc 29 overlap)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| VENDA_CASTROLANDA | — | ❌ | — | — | `fase_6_operacoes/05a_vendas_castrolanda.csv` | 13 | ❌ | **ver nota** |

> **Nota:** `vendas_castrolanda` (13 registros) parece ser um subconjunto de `vendas_grao` (170 registros, Doc 29). O CSV `05a_vendas_castrolanda.csv` tem schema idêntico a `vendas_grao`. **Decisão:** merge no `vendas_grao` — não criar tabela separada.

### SEÇÃO 8b — PLANEJAMENTO DE SAFRA (3 tabelas)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| PLANO_SAFRA_SNAPSHOT | Plan | ✅ | — | ✅ | — | 0 | ✅ | sem_dados |
| TEMPLATE_CULTURA_OPERACOES | Plan | ✅ | tipo_operacao_campo | ✅ | `fase_5/02_template_operacoes_cultura.csv` | 42 | ✅ | sem_dados |
| SAFRA_ACOES | Plan+32 | ✅ | — | ✅ | `fase_5/04_safra_acoes.csv` | 9 | ✅ | completo. INSERTs com talhao_safra_id + template_id resolvidos |

> **Nota:** Modulo de planejamento pre-safra (Mai-Jun). Templates auto-geram operacoes no calendario Gantt. `talhao_safras` ganhou 5 novos campos: `status_planejamento` (ENUM `status_talhao_safra`), `meta_produtividade_sc_ha`, `atribuido_por`, `aprovado_por`, `data_aprovacao`.

### SEÇÃO 9 — HISTÓRICO MAQUINÁRIO (Doc 31)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| HISTORICO_MAQUINAS | 31 | ✅ | tipo_registro_maquinario | ✅ | — | 32.516 | ❌ | completo |

### SEÇÃO 10 — ENTIDADES AUXILIARES (Sem DDL)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| TALHAO_MAPPING | — | ❌ | — | — | — (CSV removido, sem dados) | 0 | ❌ | **ÓRFÃ** |
| UBG_CAIXA | — | ❌ | — | — | `fase_6/14_ubg_caixa.csv` | 19.177 | ❌ | **ÓRFÃ** |
| CENTRO_CUSTO | — | ❌ | — | — | `fase_3/07_centro_custo.csv` (playground diz 387, mas CSV não encontrado fisicamente) | 387? | ❌ | **ÓRFÃ** |

---

## 2. Resumo de Cobertura

| Métrica | Valor |
|---------|-------|
| **Entidades totais V0** | 69 (excluindo TRABALHADORES_RURAIS substituído) |
| **Com CREATE TABLE** | 66 |
| **Sem CREATE TABLE (órfãs)** | 6 (TAGS_VESTRO, TANQUES_COMBUSTIVEL, OPERADORES_VESTRO, TALHAO_MAPPING, UBG_CAIXA, UBG) |
| **Com CSV (dados coletados)** | 43 arquivos → ~44 entidades |
| **Com modelo Prisma** | 65 |
| **Sem modelo Prisma** | 4 entidades (MATRICULAS, OPERADORES_VESTRO, TANQUES_COMBUSTIVEL parcial, TAGS_VESTRO parcial) |
| **ENUMs definidos** | 45 únicos |
| **Triggers definidos** | 57 |
| **Indexes definidos** | 187 |
| **Views definidas** | 4 (Doc 16 — insumos + UBG estoque silo) |
| **Functions definidas** | 3 (Doc 16 estoque) |

---

## 3. Entidades Órfãs — Ação Necessária

| Entidade | Records | CSV | Ação |
|----------|---------|-----|------|
| **TAGS_VESTRO** | 47 | `fase_3/05_tags_maquinas_vestro.csv` | Criar DDL (FK → maquinas) |
| **TANQUES_COMBUSTIVEL** | 5 | `fase_3/06_fuel_tanks.csv` | Criar DDL (FK → fazendas) |
| **OPERADORES_VESTRO** | 30 | `fase_3/04_operadores_vestro.csv` | Avaliar: merge com OPERADORES ou tabela de mapeamento |
| **TALHAO_MAPPING** | 0 | — (CSV removido) | DDL existe, sem dados até mapping real ser gerado |
| **UBG_CAIXA** | 19.177 | `fase_6/14_ubg_caixa.csv` | Criar DDL (caixa financeiro da UBG) |
| **UBG** | 1 | `fase_2_territorial/01_ubg.csv` | Criar DDL (unidade de beneficiamento — entidade territorial) |
| **CENTRO_CUSTO** | 387? | CSV não confirmado fisicamente | Criar DDL se CSV existir; senão, seed only |
| ~~FLUXO_CAIXA_FSI~~ | 10.119 | `fase_4/15_fluxo_caixa_fsi.csv` | ✅ **RESOLVIDO** — DDL + Prisma + INSERT criados 2026-03-06 |
| ~~CAIXA_ESCRITORIO_FSI~~ | 1.185 | `fase_4/16_caixa_escritorio_fsi.csv` | ✅ **RESOLVIDO** — DDL + Prisma + INSERT criados 2026-03-06 |
| ~~KUGLER_X_FSI~~ | 1.499 | `fase_4/17_kugler_x_fsi.csv` | ✅ **RESOLVIDO** — DDL + Prisma + INSERT criados 2026-03-06 |
| ~~CONSORCIOS_FSI~~ | 20 | `fase_4/18_consorcios_fsi.csv` | ✅ **RESOLVIDO** — DDL + Prisma + INSERT criados 2026-03-06 |

---

## 4. Conflitos Resolvidos

| Conflito | Resolução |
|----------|-----------|
| `trabalhadores_rurais` (Doc 26) vs `colaboradores` (Doc 27) | **COLABORADORES vence.** Não criar trabalhadores_rurais. Prisma: Colaborador @@map("colaboradores") |
| `tipo_contrato_trabalho` valores (Doc 26 vs Doc 27) | **Doc 27 vence:** `clt, informal, temporario, safrista` |
| `fn_update_timestamp()` (Doc 25a) vs `fn_atualizar_updated_at()` (Doc 26) | **Unificar como `fn_atualizar_updated_at()`** — usar em todas as tabelas |
| PK naming: `id` (Doc 16, 28) vs `entidade_id` (Doc 26) | **Padronizar `entidade_id`** (CLAUDE.md §3). Ajustar Doc 16 e 28 no SQL consolidado |
| FK references: `organizations(id)` vs `organizations(organization_id)` | **Padronizar `organization_id`** como PK column |
| `tipo_saida_grao` ENUM definido mas não usado (Doc 28) | **Manter o ENUM** — será usado quando `saidas_grao` ganhar coluna `tipo` no futuro |
| `vendas_castrolanda` (13 registros) vs `vendas_grao` (170 registros) | **Merge em `vendas_grao`** — mesmo schema, mesma entidade |

---

## 5. Ordem de Execução SQL

```
Seção 0:  Extensões + Funções
Seção 1:  ENUMs (TODOS, 40+)
Seção 2:  Sistema (9 tabelas — Doc 26)
Seção 3:  Territorial (9 tabelas — Doc 26 + 25b + órfãs UBG)
Seção 4:  Operacional (8 tabelas — Doc 26 + 27 + órfãs tags/tanques)
Seção 5:  Insumos (6 tabelas — Doc 16)
Seção 6:  Operações Campo (6 tabelas — Doc 25a)
Seção 7:  UBG/Pós-colheita (8 tabelas — Doc 28)
Seção 8:  Financeiro (7 tabelas — Doc 29)
Seção 9:  Frete + Vendas (2 tabelas — Doc 30)
Seção 10: Histórico (1 tabela — Doc 31)
Seção 11: Auxiliares (3 tabelas — órfãs)
Seção 11b: Planejamento Safra (3 tabelas — plano_safra_snapshots, template_cultura_operacoes, safra_acoes)
Seção 12: Triggers (44+)
Seção 13: Views (3)
Seção 14: Indexes (123+)
```

---

*Atualizado: 2026-03-06 | Fonte: DDL Docs 16, 25a, 25b, 26, 27, 28, 29, 30, 31 + CSVs em IMPORTS/ | +leituras_secagem (I.N. 029/2011 MAPA) | +FSI contas (4 CSVs, 12.823 registros)*
