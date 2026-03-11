# GAP ANALYSIS — Entidade × DDL × CSV × Prisma

> Atualizado: 2026-03-09 | Projeto SOAL V0 (Bronze Layer)
> Cruzamento de 10 DDL docs, 38 CSVs em IMPORTS/, 66 modelos Prisma, 66 tabelas DDL

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
| ROLES | 26 | ✅ | — | ✅ | seed | 5 | ✅ | completo (5 roles: admin, agronomo, operador_campo, operador_ubg, administrativo) |
| PERMISSIONS | 26 | ✅ | — | — | seed | 32 | ✅ | completo (8 módulos × 4 ações CRUD) |
| USER_ROLES | 26 | ✅ | — | — | seed | 8 | ✅ | completo (8 users vinculados) |
| ROLE_PERMISSIONS | 26 | ✅ | — | — | seed | ~60 | ✅ | completo (admin=tudo, outros=módulos específicos) |

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
| ~~PRODUCAO_UBG~~ | ~~28~~ | ~~✅~~ | — | — | — | — | — | **REMOVIDA 2026-03-09** — substituída por ticket_balancas + recebimentos_grao |
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

### SEÇÃO 9b — STAGING BRONZE (dados não normalizados)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| CONSUMO_AGRIWIN | — | ✅ | — | ✅ | `fase_6_operacoes/12_consumo_agriwin.csv` | 21.162 | ✅ | completo. Staging Bronze — Silver layer transforma em operacoes_campo + aplicacao_insumo |

> **Nota:** `consumo_agriwin` é tabela staging (Medallion Bronze). Dados AgriWin nível safra+cultura/fazenda, sem `talhao_safra_id`. Transformação para entidades normalizadas fica no Silver layer quando `talhao_mapping` estiver populado.

### SEÇÃO 10 — FINANCEIRO TARGET: CUSTEIO (Fase 1 — Doc 13)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| CENTRO_CUSTO | 13 | ✅ | tipo_centro_custo, natureza_centro_custo | ✅ | seed script | ~300-500 | ✅ | completo. Hierarquia 6 níveis, self-referential |
| CUSTO_OPERACAO | Fin | ✅ | tipo_custo, tipo_rateio | ✅ | ETL Bronze→Silver | ~23k (custos_insumo+consumo_agriwin+abastecimentos) | ✅ | completo. Silver layer |
| ORCAMENTO_SAFRA | Fin | ✅ | — (usa tipo_custo) | ✅ | — | 0 | ✅ | sem_dados. Claudio preenche 25/26+26/27 |

### SEÇÃO 10b — FINANCEIRO TARGET: CONTAS P/R (Fase 2)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| NOTA_FISCAL | Fin | ✅ | tipo_nota_fiscal, status_nota_fiscal, origem_nota_fiscal | ✅ | — | 0 | ✅ | sem_dados. Sparse — sem XML SEFAZ |
| NOTA_FISCAL_ITEM | Fin | ✅ | — | ✅ | — | 0 | ✅ | sem_dados |
| CONTA_PAGAR | Fin | ✅ | categoria_conta_pagar, status_conta, forma_pagamento | ✅ | ETL Bronze→Silver | ~10k (fluxo_caixa_fsi+financiamentos) | ✅ | completo |
| CONTA_RECEBER | Fin | ✅ | categoria_conta_receber | ✅ | ETL Bronze→Silver | ~5k (fluxo_caixa_fsi+vendas_grao+vendas_diretas) | ✅ | completo |

### SEÇÃO 10c — FINANCEIRO TARGET: CONTRATOS (Fase 3)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| CONTRATO_COMERCIAL | Fin | ✅ | tipo_contrato_comercial, status_contrato | ✅ | ETL vendas_grao | ~30 distintos | ✅ | completo |
| CONTRATO_ENTREGA | Fin | ✅ | — | ✅ | ETL cargas_a_carga | ~1.309 | ✅ | completo |
| CPR_DOCUMENTO | Fin | ✅ | — | ✅ | — | 0 | ✅ | sem_dados. Pendente Valentina |
| CONTRATO_ARRENDAMENTO | Fin | ✅ | — (usa status_contrato) | ✅ | — | 0 | ✅ | sem_dados. Pendente Valentina |
| CONTRATO_ARRENDAMENTO_TALHAO | Fin | ✅ | — | — | — | 0 | ✅ | sem_dados. N:N associativa |
| DEPRECIACAO_ATIVO | Fin | ✅ | metodo_depreciacao | ✅ | seed 183 ativos | 183 | ✅ | sem_dados. Tiago confirma valores |

### SEÇÃO 11 — ENTIDADES AUXILIARES (Sem DDL)

| Entidade | DDL Doc | CREATE TABLE | ENUMs | Triggers | CSV | Records | Prisma | Status |
|----------|---------|-------------|-------|----------|-----|---------|--------|--------|
| TALHAO_MAPPING | — | ❌ | — | — | — (CSV removido, sem dados) | 0 | ❌ | **ÓRFÃ** |
| UBG_CAIXA | — | ❌ | — | — | `fase_6/14_ubg_caixa.csv` | 19.177 | ❌ | **ÓRFÃ** |

---

## 2. Resumo de Cobertura

| Métrica | Valor |
|---------|-------|
| **Entidades totais V0** | 69 Bronze + 12 Financeiro Target = 81 |
| **Com CREATE TABLE** | 78 (66 Bronze + 12 Financeiro Target) |
| **Sem CREATE TABLE (órfãs)** | 5 (TAGS_VESTRO, TANQUES_COMBUSTIVEL, OPERADORES_VESTRO, TALHAO_MAPPING, UBG) |
| **Com CSV (dados coletados)** | 44 arquivos → ~45 entidades |
| **Com modelo Prisma** | 78 (+12 financeiro target) |
| **Sem modelo Prisma** | 3 entidades (MATRICULAS, OPERADORES_VESTRO, TANQUES_COMBUSTIVEL parcial) |
| **ENUMs definidos** | 59 (45 originais + 14 financeiro target) |
| **Triggers definidos** | 69 (57 + 12 financeiro target) |
| **Indexes definidos** | ~240 (~190 + ~50 financeiro target) |
| **Views definidas** | 13 (4 originais + 3 custeio + 3 contas P/R + 6 Gold dashboards - 3 overlap) |
| **Functions definidas** | 6 (5 originais + 1 fn_custo_acumulado) |
| **Registros INSERT Seeds** | ~24k linhas (23.5k originais + centro_custo ~300-500) |
| **Registros INSERT Dados** | ~112k registros (~77k originais + ~35k ETL Bronze→Silver) |

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
=== V0 (00_DDL_COMPLETO_V0.sql) ===
Seção 0:  Extensões + Funções
Seção 1:  ENUMs (45)
Seção 2:  Sistema (9 tabelas)
Seção 3:  Territorial (9 tabelas)
Seção 4:  Operacional (8 tabelas)
Seção 5:  Insumos (6 tabelas)
Seção 6:  Operações Campo (6 tabelas)
Seção 7:  UBG/Pós-colheita (8 tabelas)
Seção 8:  Financeiro Bronze (11 tabelas)
Seção 9:  Frete + Vendas (2 tabelas)
Seção 10: Histórico (1 tabela)
Seção 11: Auxiliares (2 tabelas)
Seção 11b: Planejamento Safra (3 tabelas)
Seção 12: Views + Funções (4 views, 5 funções)

=== Financeiro Target (03-06 scripts) ===
Fase 1:   03_DDL_FINANCEIRO_CUSTEIO.sql (4 ENUMs, 3 tabelas, 3 views, 1 função)
          03_INSERT_CENTRO_CUSTO_SEED.sql (seed ~300-500 registros)
          03_ETL_CUSTO_OPERACAO.sql (ETL Bronze→Silver ~23k registros)
Fase 2:   04_DDL_FINANCEIRO_CONTAS.sql (7 ENUMs, 4 tabelas, 3 views)
          04_ETL_CONTAS_PR.sql (ETL Bronze→Silver ~15k registros)
Fase 3:   05_DDL_FINANCEIRO_CONTRATOS.sql (3 ENUMs, 5+1 tabelas, 3 ALTERs)
          05_ETL_CONTRATOS.sql (ETL Bronze→Silver ~1.3k registros)
Fase 4:   06_VIEWS_GOLD_FINANCEIRO.sql (6 views Gold para dashboards)
```

---

*Atualizado: 2026-03-09 | +Financeiro Target: 12 tabelas (4 fases), 14 ENUMs, 9 views, 1 função, 3 ETLs Bronze→Silver (~35k registros) | Prisma: 78 modelos, 59 enums*
