# Revisao Process Flow SOAL -- Fase a Fase

> Documento de revisao cronologica de como os dados fluem desde as entidades raiz (Fase 0) ate as operacoes continuas (Fase 6) e auto-calculados (Fase 7).
> Objetivo: entender o estado atual de cada fase, gaps, e como tudo se conecta.
>
> Data: 2026-03-06 | Autor: Rodrigo Kugler

---

## FASE 0 -- Seeds (Entidades Raiz)

**Status: COMPLETO**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_0/01_culturas.csv` | 126 | culturas | OK |
| `fase_0/03_produto_insumo_agriwin.csv` | 18.499 | produto_insumos | OK |
| `fase_0/03_produto_insumo_castrolanda.csv` | 395 | produto_insumos | OK |

**Observacoes:**
- Culturas: 126 culturas em 8 grupos (graos, oleaginosa, cobertura, forrageira, pastagem, florestal, fibra, outros)
- Insumos: 2 fontes complementares -- AgriWin (catalogo historico amplo) + Castrolanda (catalogo atual com precos)
- ROLES/PERMISSIONS: definidos em codigo, nao em CSV

**Fluxo:** Estas sao as raizes. Tudo que vem depois depende delas. Culturas alimentam TALHAO_SAFRA. Produto_Insumo alimenta COMPRA_INSUMO, APLICACAO_INSUMO, ESTOQUE.

---

## FASE 1 -- Sistema e Plataforma

**Status: COMPLETO**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_1_sistema/01_organizations.csv` | 1 | organizations | MANUAL |
| `fase_1_sistema/02_users.csv` | 8 | users | MANUAL |

**Observacoes:**
- 1 organizacao (SOAL) + 8 usuarios (Claudio, Tiago, Valentina, Alessandro, Josmar, Rodrigo, Joao, + 1)
- OWNERS criado implicitamente (Claudio)
- Sem ETL -- seed manual

**Fluxo:** Organizations e o tenant. Tudo carrega organization_id. Users sao os operadores do sistema.

---

## FASE 2 -- Territorio

**Status: COMPLETO**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_2/01_safras.csv` | 9 | safras | MANUAL |
| `fase_2/02_fazendas.csv` | 9 | fazendas | OK (ETL) |
| `fase_2/03_talhoes.csv` | 71 | talhoes | OK (ETL) |
| `fase_2/04_matriculas.csv` | 88 | matriculas | OK (ETL) |
| `fase_2/06_parceiros_agriwin.csv` | 2.201 | parceiros_comerciais | OK (ETL) |
| `fase_2_territorial/01_ubg.csv` | 1 | ubgs | MANUAL |
| `fase_2_territorial/02_silos_ubg.csv` | 8 | silos | MANUAL |

**Observacoes:**
- 9 safras (17/18 a 26/27) -- cobertura historica completa
- 9 fazendas, 71 talhoes, 88 matriculas (59 SOAL + 29 CK), 4.127 ha
- UBG: 1 unidade, 8 silos (6 conv metalicos + 2 pulmao), 10.760t capacidade total
- Parceiros: 2.201 do AgriWin (fornecedores, clientes, arrendadores, transportadores, cooperativa)
- **GAP:** Contrato_Arrendamento -- pendente Valentina (dados nao coletados)
- **GAP:** Geojson dos talhoes -- KML/KMZ do CAR disponivel mas nao convertido para o CSV

**Fluxo:** Territorio e a base para tudo. TALHAO + SAFRA + CULTURA = TALHAO_SAFRA (entidade central). Fazendas agrupam talhoes. UBG/Silos recebem graos. Parceiros participam de compras/vendas.

---

## FASE 3 -- Cadastros Operacionais

**Status: COMPLETO**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_3/04_maquinas.csv` | 57 | maquinas | OK (ETL) |
| `fase_3/04_implementos.csv` | 126 | maquinas (tipo=implemento) | OK (ETL) |
| `fase_3/05_operadores.csv` | 15 | operadores | MANUAL |
| `fase_3/04_operadores_vestro.csv` | 30 | (referencia cruzada) | OK (ETL) |
| `fase_3/05_tags_maquinas_vestro.csv` | 47 | tags_vestro | OK (ETL) |
| `fase_3/06_fuel_tanks.csv` | 5 | tanques_combustivel | OK (ETL) |
| `fase_3/07_colaboradores.csv` | 82 | colaboradores | OK (ETL) |
| `fase_3/08_folha_pagamento.csv` | 3.122 | folha_pagamento | OK (ETL) |

**Observacoes:**
- 57 maquinas (52 ativo + 5 vendido) + 126 implementos (103 ativo + 23 vendido)
- 15 operadores curados manualmente (cruzamento colaboradores x vestro)
- 47 tags RFID Vestro + 30 motoristas Vestro (para match com abastecimentos)
- 82 colaboradores + 3.122 registros folha (Jul/2017 a Fev/2026, 5 eras de layout)
- 5 tanques de combustivel
- **GAP:** Centro de Custo (hierarquia 6 niveis) -- seed a ser gerado por Joao. Nao tem CSV.
- **GAP:** Horimetro_inicial das maquinas -- precisa leitura no "Dia 01" (Tiago)
- **PENDENTE:** Validacao Tiago sobre 9 questoes de maquinas (doc VALIDACAO_TIAGO_MAQUINAS.md)

**Fluxo:** Maquinas + Operadores sao necessarios para OPERACAO_CAMPO (Fase 6). Colaboradores + Folha sao o backbone RH. Tags Vestro fazem o match automatico nos abastecimentos.

---

## FASE 4 -- Financeiro Base

**Status: COMPLETO (historico) | PARCIAL (operacional)**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_4/07_castrolanda_extrato.csv` | 8.211 | castrolanda_extrato | OK |
| `fase_4/09_castrolanda_cc_completo.csv` | 2.891 | castrolanda_cc | OK |
| `fase_4/11_castrolanda_financiamentos.csv` | 220 | financiamentos_castrolanda | OK |
| `fase_4/12_castrolanda_capital_html.csv` | 95 | capital_castrolanda | OK |
| `fase_4/13_castrolanda_vendas.csv` | 170 | vendas_grao | OK |
| `fase_4/14_castrolanda_carga_a_carga.csv` | 1.309 | carga_a_carga_castrolanda | OK |
| `fase_4/11_compra_insumo_castrolanda.csv` | 6.331 | compra_insumos | OK |
| `fase_4/15_fluxo_caixa_fsi.csv` | 10.119 | fluxo_caixa_fsi | OK |
| `fase_4/16_caixa_escritorio_fsi.csv` | 1.185 | caixa_escritorio_fsi | OK |
| `fase_4/17_kugler_x_fsi.csv` | 1.499 | kugler_x_fsi | OK |
| `fase_4/18_consorcios_fsi.csv` | 20 | consorcios_fsi | OK |

**Observacoes:**
- Castrolanda: 6 ETLs cobrindo extrato (6 anos), C/C completo, financiamentos (22 contratos), capital, vendas (13 safras, R$99.3M), carga-a-carga (6 safras, 42.4k ton)
- FSI: 4 CSVs cobrindo fluxo de caixa (2017-2026), caixa escritorio, inter-company, consorcios
- Compra de insumos: 6.331 registros Castrolanda (16 culturas, R$65.7M, Jan/2020-Mar/2026)
- **GAP:** NOTA_FISCAL -- integracao SEFAZ nao implementada. NFs historicas do AgriWin nao extraidas.
- **GAP:** CONTA_PAGAR / CONTA_RECEBER -- nao existem como CSV separado. FSI fluxo_caixa e o mais proximo.
- **GAP:** CONTRATO_COMERCIAL -- pendente Valentina
- **GAP:** CPR_DOCUMENTO -- pendente Valentina

**Fluxo:** Financeiro base e o maior volume de dados historicos. Castrolanda e a cooperativa central (fornece insumos + compra graos). FSI e o RH/financeiro. Estes dados alimentam dashboards e custeio de safra. Compra_insumo conecta com PRODUTO_INSUMO (Fase 0) + PARCEIRO (Fase 2).

---

## FASE 5 -- Planejamento da Safra

**Status: ✅ CADEIA FK COMPLETA — 5 CSVs processados por `generate_inserts.py`**

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_5/01_planejamento_safra.csv` | 50 | talhao_safras | ❌ IGNORADO (redundante com 03) |
| `fase_5/02_template_operacoes_cultura.csv` | 42 | template_cultura_operacoes | ✅ COMPLETO (seeds) |
| `fase_5/03_talhao_safra.csv` | 50 | talhao_safras | ✅ COMPLETO (seção 26) |
| `fase_5/04_safra_acoes.csv` | 9 | safra_acoes | ✅ COMPLETO (seção 27) |
| `fase_5/05_operacoes_campo.csv` | 7 | operacoes_campo | ✅ COMPLETO (seção 28) |
| `fase_5/06_aplicacao_insumo.csv` | 11 | aplicacao_insumo | ✅ COMPLETO (seção 29) |
| ~~`fase_5/07_ticket_balanca.csv`~~ | ~~8~~ | ~~ticket_balancas~~ | ARQUIVADO — dados em fase_6/15_ticket_balancas.csv |
| ~~`fase_5/08_recebimentos_grao.csv`~~ | ~~8~~ | ~~recebimentos_grao~~ | ARQUIVADO — dados em fase_6/16_recebimentos_grao.csv |

**Observacoes:**
- Cadeia FK resolvida via subqueries compostas (safra+talhao+cultura+epoca+gleba)
- `03_talhao_safra.csv` inserido com `ON CONFLICT DO NOTHING` — dados fase 5 tem prioridade sobre plantio historico
- `01_planejamento_safra.csv` IGNORADO — dados redundantes com 03 (que ja tem status_planejamento, aprovado_por, etc.)
- Template de operacoes por cultura: 6 culturas com 9-12 operacoes sequenciadas (dessecacao -> plantio -> pulverizacoes -> colheita com dias_offset)
- Process Flow documentado (6 etapas): Criar Safra -> Grid -> Alessandro v1 -> Review v2 -> Aprovacao Claudio -> Auto-gerar operacoes (usando `data_plantio_prevista` como ancora para calcular datas)
- Campo `data_plantio_prevista` adicionado ao DDL — ancora para gerar calendario SAFRA_ACAO. Defaults por cultura em `CALENDARIO_AGRICOLA_CAMPOS_GERAIS.md`
- **TALHAO_SAFRA historico** ja existe derivado dos 883 tickets da fonte Agricola (Fase 6) + 152 plantio historico
- **GAP:** ANALISE_SOLO -- pendente coleta com Lucas/Alessandro
- **GAP:** RECOMENDACAO_ADUBACAO -- depende de ANALISE_SOLO
- **GAP:** RECEITUARIO_AGRONOMICO -- baixa prioridade segundo Alessandro

**Fluxo:** TALHAO_SAFRA e a ENTIDADE CENTRAL. 90% dos relatorios passam por ela. Conecta Talhao (Fase 2) + Safra (Fase 2) + Cultura (Fase 0). Quando Alessandro escolhe uma cultura para um talhao, o sistema auto-gera as operacoes esperadas a partir do template.

---

## FASE 6 -- Operacoes Continuas

**Status: PARCIAL (historico rico, operacional em template)**

### 6A -- Dados historicos (OK)

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| ~~`fase_6/09_producao_ubg.csv`~~ | ~~883~~ | ~~producao_ubg~~ | ARQUIVADO em `_archive/` |
| `fase_6/15_ticket_balancas.csv` | 883 | ticket_balancas (peso only) | OK |
| `fase_6/16_recebimentos_grao.csv` | 875 | recebimentos_grao (qualidade) | OK |
| `fase_6/10_abastecimentos_vestro.csv` | 1.202 | abastecimentos | MISSING_SRC |
| `fase_6/11_manutencoes_historico.csv` | ? | manutencoes | MISSING_SRC |
| `fase_6/12_abastecimentos_historico.csv` | ? | abastecimentos | MISSING_SRC |
| `fase_6/14_ubg_caixa.csv` | 19.177 | ubg_caixa | OK |
| (fase 5 lifecycle) | 5 | controles_secagem | OK |
| (fase 5 lifecycle) | 25 | leituras_secagem | OK |
| (fase 5 lifecycle) | 8 | alocacao_silo | OK |
| (fase 5 lifecycle) | 10 | estoque_silo | OK |

### 6B -- Operacoes agricolas (MIX de OK + TEMPLATE)

| CSV | Registros | Tabela destino | Status |
|-----|-----------|---------------|--------|
| `fase_6_operacoes/01_operacoes_campo_colheita.csv` | headers+notas | operacoes_campo | TEMPLATE (precisa Tiago) |
| `fase_6_operacoes/02_operacoes_campo_plantio.csv` | headers+notas | operacoes_campo | TEMPLATE (precisa Tiago) |
| `fase_6_operacoes/03_colheita_detalhe.csv` | headers+notas | colheita_detalhes | TEMPLATE (precisa Tiago) |
| `fase_6_operacoes/04_pesagens_agricola.csv` | 806 | pesagens (perspectiva agricola) | OK |
| `fase_6_operacoes/05a_vendas_castrolanda.csv` | 13 | vendas_grao | MISSING_SRC |
| `fase_6_operacoes/05b_vendas_diretas.csv` | 73 | vendas_grao | MISSING_SRC |
| `fase_6_operacoes/06_custo_insumos_castrolanda.csv` | 553 | (referencia custeio) | MISSING_SRC |
| `fase_6_operacoes/07_freteiros.csv` | 116 | (referencia frete) | MISSING_SRC |
| `fase_6_operacoes/08_saidas_producao.csv` | 542 | saidas_grao | MISSING_SRC |
| `fase_6_operacoes/12_consumo_agriwin.csv` | 21.162 | (referencia consumo) | OK |
| `fase_6_operacoes/12_plantio_historico.csv` | 145 | (referencia plantio) | OK |

**Observacoes:**
- **Fonte Agricola Unificada:** 883 tickets + 806 pesagens da mesma fonte (41 planilhas, 6 safras)
- Consumo AgriWin: 21.162 rows (9.482 ops), 8 safras, R$99.2M -- rico em historico de operacoes
- Plantio historico: 145 registros, 6 safras, 10 culturas
- Saidas producao: 542 embarques, 4 culturas, 13 contratos
- UBG Caixa: 19.177 registros (2011-2026) -- historico financeiro completo da UBG
- **UBG Lifecycle (fase 5):** 5 controles de secagem + 25 leituras + 8 alocacoes silo + 10 estoque silo -- cadeia completa TICKET_BALANCA -> RECEBIMENTO -> SECAGEM -> ESTOQUE
- **MISSING_SRC:** 8 CSVs cujos fontes originais foram deletados. CSVs ja gerados, so nao da pra re-rodar ETL.
- **GAP CRITICO:** Operacoes campo (colheita/plantio) + colheita_detalhe sao TEMPLATES. Precisam de dados do Tiago (maquina, operador, horimetro por operacao). Sem isso, nao tem custeio por operacao.
- **GAP:** Dados faltantes -- Soja 25/26 (copia errada), Milho 25/26 (parcial)
- **DASHBOARDS:** 2 HTML mockups em progresso (design system + executive overview)

**Fluxo:** Fase 6 e o dia-a-dia. OPERACAO_CAMPO e o hub -- cada operacao conecta TALHAO_SAFRA + MAQUINA + OPERADOR + detalhe especifico. TICKET_BALANCA e o ponto de transferencia Agricultura->UBG. Abastecimentos Vestro linkam MAQUINA + OPERADOR + litros. O consumo AgriWin e a melhor fonte historica de "quem fez o que onde".

---

## FASE 7 -- Auto-Calculado

**Status: DDL PRONTO | TRIGGERS DEFINIDOS | NAO EXECUTAVEL AINDA**

Entidades auto-calculadas (nao tem CSV, sao triggers):
- MOVIMENTACAO_INSUMO -- gatilho: INSERT em COMPRA/APLICACAO_INSUMO
- ESTOQUE_INSUMO -- gatilho: trigger em MOVIMENTACAO_INSUMO (custo medio ponderado)
- APLICACAO_INSUMO -- gatilho: INSERT em OPERACAO_CAMPO
- MOVIMENTACAO_SILO -- gatilho: INSERT em RECEBIMENTO_GRAO ou SAIDA_GRAO
- ESTOQUE_SILO -- gatilho: trigger em MOVIMENTACAO_SILO (10 registros seed ja inseridos via fase 5 lifecycle)
- CUSTO_OPERACAO -- gatilho: trigger em OPERACAO_CAMPO

**Observacoes:**
- DDL tem as 3 funcoes e ~57 triggers definidos
- So funciona quando Fase 6 estiver rodando em producao
- Depende de: OPERACAO_CAMPO preenchido, COMPRA_INSUMO com produto_insumo_id valido, TICKET_BALANCA com silo_destino

---

## VISAO CRONOLOGICA -- Como tudo se conecta

```
FASE 0 (Seeds)
  |-- CULTURAS (126) -----> TALHAO_SAFRA (Fase 5)
  |-- PRODUTO_INSUMO (18.894) -> COMPRA_INSUMO (Fase 4/6) -> ESTOQUE (Fase 7)

FASE 1 (Sistema)
  |-- ORGANIZATION (1) ---> org_id em TUDO
  |-- USERS (8) ----------> quem opera o sistema

FASE 2 (Territorio)
  |-- SAFRAS (9) ----------> TALHAO_SAFRA + toda referencia temporal
  |-- FAZENDAS (9) --------> agrupa TALHOES
  |-- TALHOES (71) --------> TALHAO_SAFRA + OPERACAO_CAMPO
  |-- UBG (1) + SILOS (8) -> TICKET_BALANCA + ESTOQUE_SILO
  |-- PARCEIROS (2.201) ---> COMPRA/VENDA/CONTRATO

FASE 3 (Operacional)
  |-- MAQUINAS (183) ------> OPERACAO_CAMPO + ABASTECIMENTO + MANUTENCAO
  |-- OPERADORES (15) -----> OPERACAO_CAMPO + ABASTECIMENTO
  |-- COLABORADORES (82) --> FOLHA + APONTAMENTO_MAO_OBRA
  |-- TAGS VESTRO (47) ----> match automatico ABASTECIMENTO

FASE 4 (Financeiro)
  |-- CASTROLANDA (6 ETLs, ~14k registros) --> custeio, vendas, financiamentos
  |-- FSI (4 CSVs, ~12.8k registros) --------> fluxo caixa, RH financeiro
  |-- COMPRA_INSUMO (6.331) -----------------> vincula PRODUTO_INSUMO + SAFRA

FASE 5 (Planejamento) <-- TEMPLATE, pendente Alessandro
  |-- TALHAO_SAFRA = TALHAO + SAFRA + CULTURA --> ENTIDADE CENTRAL
  |-- data_plantio_prevista -----> ancora para gerar datas das SAFRA_ACAO
  |-- Template operacoes (6 culturas) ----------> auto-gera OPERACAO_CAMPO

FASE 6 (Operacoes) <-- MIX de historico + templates
  |-- TICKET_BALANCA (883 hist) --> RECEBIMENTO (875) -> SECAGEM (5+25 leit) -> ESTOQUE_SILO (10)
  |-- OPERACAO_CAMPO (templates) -> DETALHE + APLICACAO_INSUMO
  |-- ABASTECIMENTOS (1.202) ----> custo combustivel por maquina
  |-- CONSUMO_AGRIWIN (21k) -----> referencia historica rica

FASE 7 (Auto) <-- triggers no DDL, ativados em producao
  |-- ESTOQUE_INSUMO, ESTOQUE_SILO, CUSTO_OPERACAO, etc.
```

---

## GAPS CONSOLIDADOS (por prioridade)

### P0 -- Bloqueiam o "Dia 01"
1. **TALHAO_SAFRA planejamento** -- template vazio, depende Alessandro
2. **OPERACAO_CAMPO** -- templates sem dados, depende Tiago (maquina + operador por operacao)
3. **Centro de Custo** -- hierarquia nao gerada (seed Joao)

### P1 -- Importantes mas nao bloqueantes
4. **NOTA_FISCAL** -- integracao SEFAZ nao implementada
5. **CONTRATO_COMERCIAL** -- pendente Valentina
6. **CONTRATO_ARRENDAMENTO** -- pendente Valentina
7. **ANALISE_SOLO** -- pendente Lucas/Alessandro
8. **Dados faltantes:** Soja 25/26 (copia errada), Milho 25/26 (parcial)

### P2 -- Nice to have
9. **Geojson talhoes** -- KML disponivel, conversao pendente
10. **Horimetro_inicial** -- leitura Dia 01 com Tiago
11. **APONTAMENTO_MAO_OBRA** -- nao tem forma de coleta definida

---

## NUMEROS CONSOLIDADOS

| Metrica | Valor |
|---------|-------|
| CSVs em IMPORTS/ | 62 |
| CSVs com dados (OK + MISSING_SRC + DEMO) | 54 |
| CSVs template (sem dados) | 4 |
| CSVs removidos historicamente | 4 |
| Total registros em Seeds (01_INSERT) | ~23k linhas |
| Total registros em Dados (02_INSERT) | ~56k registros + fase 5 lifecycle + 48 UBG demo (5 secagem + 25 leituras + 8 alocação + 10 estoque) — 78k linhas SQL |
| Tabelas no DDL | 66 |
| ENUMs | 45 |
| ETL scripts ativos | 30+ |
| Fontes externas processadas | 10 (AgriWin, Vestro, Castrolanda, FSI, CAR, Agricola, Maquinario, RH, Parceiros, Insumos) |
| Reunioes documentadas | 20 (Dez 2025 -> Mar 2026) |
| Dashboard mockups | 2 (design system + executive overview) |

---

*Gerado: 2026-03-08 | Mantido por: Rodrigo Kugler & DeepWork AI Flows*
