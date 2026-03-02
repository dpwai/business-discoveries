# Doc 27 — Plano de Trabalho: Coleta + Schema (Perspectiva Rodrigo)

> O que eu (Rodrigo) estou coletando, o que já entreguei, e como isso define os schemas.
> O João recebe os CSVs + definição de schema e implementa do lado dele.
> Criado: 2026-03-01 | Rodrigo Kugler

---

## Como funciona

```
Rodrigo coleta planilha/dado → ETL → CSV limpo → define schema da entidade
                                                          ↓
                                              João implementa no Prisma + banco
```

Cada planilha coletada valida e refina o schema. Se o CSV tem campos que o schema não previu, o schema precisa ser atualizado. Se o schema tem campos que nenhum dado preenche, questionar se é necessário agora.

---

## Inventário de Coleta — Por Entidade

### Status: ✅ Coletado | ⚠️ Parcial | ⏳ Pendente | ❌ Bloqueado

---

### FASE 0 — Seeds (dados raiz)

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| CULTURAS | ✅ | 9 | Discovery + CSVs plantio | `fase_0/01_culturas.csv` | ✅ Sim — name, display_name, group, harvest_unit |
| PRODUTO_INSUMO (seed) | ✅ | 38 | Manual (combustíveis, lubrificantes) | `fase_0/02_produto_insumo_seed.csv` | ✅ Sim — name, tipo, grupo, unidade, ncm |
| PRODUTO_INSUMO (AgriWin) | ✅ | 18.499 | 200 xlsx AgriWin | `fase_0/03_produto_insumo_agriwin.csv` | ✅ Sim — 12 campos, 99.8% classificado |

**ETL scripts:** `DATA/INSUMOS/etl_insumos.py`
**Descobertas de schema:** 162 variantes de unidade → 55 canônicas. Campo `categoria_agriwin` útil para rastreabilidade legado.

---

### FASE 2 — Territorial

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| SAFRAS | ✅ | 10 | Calculado (Jul-Jun) | `fase_2/01_safras.csv` | ✅ Sim — season_code, fiscal_year_start/end, status |
| FAZENDAS | ✅ | 8 | Discovery + Claudio | `fase_2/02_fazendas.csv` | ✅ Sim — name, cnpj, municipality, total_area_ha |
| TALHOES | ✅ | 72 | Listagem_Talhoes.csv (AgriWin) | `fase_2/03_talhoes.csv` | ✅ Sim — 7 campos. Falta GeoJSON (KML/CAR) |
| TALHAO_MAPPING | ✅ | 184 | Reconciliação 3 fontes | `fase_2/03b_talhao_nome_mapping.csv` | ✅ Sim — de-para naming (AgriWin ↔ Plantio ↔ canônico) |
| PARCEIRO_COMERCIAL | ✅ | 2.201 | 23 xlsx AgriWin | `fase_2/06_parceiros_agriwin.csv` | ✅ Sim — 14 campos. 1.825 sem tipo (Valentina classificar) |
| PARCEIRO (seed manual) | ✅ | 8 | Manual (Castrolanda, labs, UBG) | `fase_2/05_parceiros_template.csv` | ✅ Sim |
| UBG | ⚠️ | 19.177 (caixa) | Planilha histórica Josmar | `DATA/UBG/UBG_Caixa_Historico_Clean.csv` | ⚠️ Caixa coletada, entidade UBG em si não seedada |
| SILOS | ❌ | 0 | Josmar + Claudio | — | ⏳ Precisa reunião |

**ETL scripts:** `DATA/PARCEIROS_PESSOAS/etl_parceiros.py`
**Descobertas de schema:**
- Talhão naming é inconsistente entre módulos AgriWin → `03b_talhao_nome_mapping.csv` resolve
- PARCEIRO: 830 CNPJ + 206 CPF, 1.165 sem doc — campo `doc_type` necessário no schema
- UBG caixa: 19.177 registros 2011→2026, mas é dado financeiro UBG, não a entidade UBG em si

---

### FASE 3 — Operacional

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| MAQUINAS | ⚠️ | 183 | 3 planilhas Tiago (consolidadas) | `fase_3/04_maquinas.csv` | ✅ Sim — 15 campos. 9 questões Tiago pendentes |
| OPERADORES (Vestro) | ✅ | 30 | Tags Vestro | `fase_3/04_operadores_vestro.csv` | ⚠️ Parcial — falta CPF, cargo, fazenda base |
| OPERADORES (parcial) | ⚠️ | 31 | Consolidação manual | `fase_3/05_operadores_parcial.csv` | ⚠️ Valentina completar |
| TAGS RFID VESTRO | ✅ | 42 | Portal Vestro | `fase_3/05_tags_maquinas_vestro.csv` | ✅ Sim — tag_rfid, tipo_medicao, match com máquinas |
| TANQUES COMBUSTÍVEL | ✅ | 5 | Discovery (Tiago) | `fase_3/06_fuel_tanks.csv` | ✅ Sim — name, fuel_type, capacity_liters |
| CENTRO_CUSTO | ✅ | 387 | Gerado (`generate_all_imports.py`) | `fase_3/07_centro_custo.csv` | ✅ Sim — 10 campos, 6 níveis hierárquicos |
| TRABALHADOR_RURAL | ❌ | 0 | Valentina | — | ⏳ Reunião necessária |

**ETL scripts:** `DATA/MAQUINÁRIO/ABASTECIMENTOS/etl_tags_vestro.py`
**Descobertas de schema:**
- MAQUINAS: `trator_vinculado` é referência informal (ex: "S660-01") → precisa lookup para FK
- OPERADORES: Vestro usa `matricula_vestro` como ID — campo necessário no schema
- 9 questões pendentes para Tiago: ver `10_REUNIOES/VALIDACAO_TIAGO_MAQUINAS.md`

---

### FASE 4 — Financeiro (Castrolanda)

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| EXTRATO_COOPERATIVA | ✅ | 8.211 | Portal Castrolanda (HTML→ETL) | `fase_4/07_castrolanda_extrato.csv` | ✅ Sim — 14 campos, 9 contas por cultura |
| CONTA_CORRENTE | ✅ | 2.889 | Portal Castrolanda (PDF 214 pgs) | `fase_4/09_castrolanda_cc_completo.csv` | ✅ Sim — 7 campos, 6 anos |
| CONTA_CAPITAL | ✅ | 77 | Portal Castrolanda (HTML) | `fase_4/12_castrolanda_capital_html.csv` | ✅ Sim — 13 campos, validado ALL PASS |
| FINANCIAMENTOS | ✅ | 220 | Portal Castrolanda (PDF) | `fase_4/11_castrolanda_financiamentos.csv` | ✅ Sim — 7 campos, 22 contratos |
| VENDAS_GRAO | ✅ | 170 | Portal Castrolanda (HTML) | `fase_4/13_castrolanda_vendas.csv` | ✅ Sim — 24 campos, R$99.3M |
| CARGA_A_CARGA | ✅ | 1.337 | Portal Castrolanda (HTML) | `fase_4/14_castrolanda_carga_a_carga.csv` | ✅ Sim — 20 campos, qualidade em JSON |
| NOTA_FISCAL | ⏳ | 0 | SEFAZ API (DFe) | — | Schema existe, dado via API (João) |
| CONTA_PAGAR | ⏳ | 0 | Form Valentina | — | Schema existe, sem dado ainda |
| CONTA_RECEBER | ⏳ | 0 | Form Valentina | — | Schema existe, sem dado ainda |

**ETL scripts:** `DATA/CASTROLANDA/etl_castrolanda_extrato.py`, `etl_castrolanda_cc.py`, `etl_castrolanda_pdf.py`, `etl_castrolanda_capital_html.py`, `etl_castrolanda_vendas.py`, `etl_castrolanda_carga_a_carga.py`
**Descobertas de schema:**
- Castrolanda exporta HTML disfarçado de .xls → usar `lxml.html` (NUNCA `pd.read_html`)
- CARGA_A_CARGA: campos de qualidade variam por cultura → armazenar como JSON
- VENDAS: 25+ campos incluindo frete_ton, desconto_bordero, data_credito → schema expandido
- **Falta model Prisma para CARGA_A_CARGA** — João precisa criar

---

### FASE 5 — Planejamento Safra

O planejamento é uma etapa real do ciclo agrícola: antes de qualquer operação de campo, o Alessandro e o Claudio definem a alocação de culturas por talhão para a safra. Essa decisão alimenta tudo que vem depois (operações, insumos, custos).

**Dados diretos (planejamento formal):**

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| TALHAO_SAFRA 24/25 | ✅ | 196 | Listagem_Plantio_24_25.csv (AgriWin) | `fase_5/07_talhao_safra_2425.csv` | ✅ Sim — 7 campos |
| TALHAO_SAFRA 25/26 | ✅ | 55 | Listagem_Plantio_25_26.csv (AgriWin) | `fase_5/08_talhao_safra_2526.csv` | ✅ Sim — 7 campos |
| ANALISE_SOLO | ❌ | 0 | Alessandro (laudos) | — | Schema existe, dado não coletado |
| RECEITUARIO | ⏳ | 0 | Alessandro (form futuro) | — | Schema existe, coleta contínua |

**Dados históricos indiretos (safras 20/21 a 23/24):**

Não temos a Listagem de Plantio das safras anteriores, mas conseguimos reconstruir parcialmente o que foi plantado onde a partir de:
- `fase_4/14_castrolanda_carga_a_carga.csv` — 1.337 cargas com cultura + talhão + safra (20/21→25/26)
- `fase_6/09_ticket_balanca.csv` — 548 tickets com cultura + talhão (23/24)

Esses dados evidenciam a alocação real (o que foi colhido), não o planejamento. Mas servem para popular TALHAO_SAFRA retroativamente se necessário.

| Safra | Fonte direta (planejamento) | Fonte indireta (colheita) |
|-------|-----------------------------|---------------------------|
| 20/21 | ⏳ Coletar com Claudio | Carga-a-Carga Castrolanda |
| 21/22 | ⏳ Coletar com Claudio | Carga-a-Carga Castrolanda |
| 22/23 | ⏳ Coletar com Claudio | Carga-a-Carga Castrolanda (⚠️ Soja Intacta IPRO faltando) |
| 23/24 | ⏳ Coletar com Claudio | Carga-a-Carga + Ticket Balança |
| 24/25 | ✅ Listagem Plantio | Carga-a-Carga (parcial, safra em andamento) |
| 25/26 | ✅ Listagem Plantio | — (safra futura) |

**Coleta histórica:** Rodrigo coletar TALHAO_SAFRA de safras anteriores (20/21→23/24) em reunião com Claudio esta semana.

**Reconciliação UBG ↔ Castrolanda:**
O Carga-a-Carga é a perspectiva da Castrolanda (cooperativa recebe o grão). Deve reconciliar com o relatório de saída de grãos da UBG (SOAL despacha o grão). São dois lados do mesmo fluxo:

```
UBG (SOAL)                          Castrolanda (Cooperativa)
─────────────                        ──────────────────────────
TICKET_BALANCA (pesagem entrada)
       ↓
RECEBIMENTO_GRAO (classificação)
       ↓
CONTROLE_SECAGEM (beneficiamento)
       ↓
ESTOQUE_SILO (armazenamento)
       ↓
SAIDA_GRAO (despacho) ──────────→ CARGA_A_CARGA (recebimento)
   peso saída                         peso chegada
```

A diferença entre peso saída UBG e peso chegada Castrolanda = quebra de transporte + reclassificação. Essa reconciliação é um controle financeiro importante.

**Descobertas de schema:**
- `epoca` / `tipoSafra`: SAFRA, SAFRINHA, INVERNO — campo essencial, faltava no schema original
- `cultura` é String livre no Prisma → precisa FK para model Cultura
- Descoberto FEIJÃO e MILHETO nos CSVs de plantio (não estavam no seed original de culturas)
- Reconstrução histórica via Carga-a-Carga é possível mas parcial (não tem área plantada, só peso colhido)

---

### FASE 6 — Operações Contínuas

| Entidade | Status | Registros | Fonte | CSV Output | Schema definido? |
|----------|--------|-----------|-------|------------|-----------------|
| TICKET_BALANCA | ⚠️ | 548 | Planilha Josmar/Vanessa | `fase_6/09_ticket_balanca.csv` | ✅ Sim — 22 campos. **24/25 milho FALTANDO** |
| ABASTECIMENTOS (recente) | ✅ | 1.173 | Portal Vestro | `fase_6/10_fuel_supplies.csv` | ✅ Sim — 11 campos |
| MANUTENÇÕES (histórico) | ✅ | 9.871 | 11 xlsx Tiago (1997→2026) | `fase_6/11_manutencoes_historico.csv` | ✅ Sim — 18 campos |
| ABASTECIMENTOS (histórico) | ✅ | 22.617 | 11 xlsx Tiago (2009→2026) | `fase_6/12_abastecimentos_historico.csv` | ✅ Sim — 17 campos |
| OPERAÇÕES CAMPO (histórico) | ✅ | 31 | 11 xlsx Tiago (pouco dado) | `fase_6/13_operacoes_campo_historico.csv` | ✅ Sim — 12 campos |

**ETL scripts:** `DATA/UBG/producao/etl_ticket_balanca.py`, `DATA/MAQUINÁRIO/etl_maquinario.py`
**Descobertas de schema:**
- Maquinário histórico: 8 layouts diferentes detectados dinamicamente (1997→2026 mudou muito)
- TICKET_BALANCA: `gleba` é sub-área do talhão (ex: CAPINZAL tem HERMATRIA, BANACK, URUGUAI)
- TICKET_BALANCA: `is_seed` flag necessária — SOAL produz sementes certificadas

---

## Resumo: O que eu entrego pro João

### Já entregue (31 CSVs, 69.285 rows)

| O quê | Onde | Para o João fazer |
|-------|------|-------------------|
| 31 CSVs limpos por fase | `DATA/IMPORTS/fase_*/` | Usar como base para seed real no banco |
| 19 CSV templates (do app) | `DATA/IMPORTS/templates_dpwai_app/` | Referência dos headers da UI de import |
| Descobertas de schema | Este doc + `MEMORY.md` | Ajustar Prisma models conforme campo novo/corrigido |
| Mapeamento talhão naming | `fase_2/03b_talhao_nome_mapping.csv` | Implementar `TalhaoMapping` real |
| Doc 21 (Alinhamento App↔SOAL) | `21_ALINHAMENTO_DPWAI_APP_SOAL.md` | Mapa Prisma ↔ DDL ↔ CSV |
| Doc 26 (DDL Fundacional) | `19_DIAGRAMA_ER_SOAL/26_DDL_*` | Referência SQL para PostgreSQL |

### Ajustes de schema que descobri na coleta

| # | Ajuste | Origem da descoberta | CSV que evidencia |
|---|--------|---------------------|-------------------|
| 1 | FK `culturaId` em TalhaoSafra (hoje é String) | Plantio 24/25 e 25/26 | `fase_5/07_*.csv` |
| 2 | ENUM `tipoSafra` (SAFRA/SAFRINHA/TERCEIRA_SAFRA) | Plantio com safra+safrinha mesmo talhão | `fase_5/07_*.csv` |
| 3 | Campo `gleba` em TICKET_BALANCA | Josmar usa sub-áreas | `fase_6/09_*.csv` |
| 4 | Campo `is_seed` em TICKET_BALANCA | SOAL produz sementes | `fase_6/09_*.csv` |
| 5 | Model CARGA_A_CARGA (não existe) | 1.337 registros Castrolanda | `fase_4/14_*.csv` |
| 6 | Campo `matricula_vestro` em OPERADORES | Vestro usa matrícula como ID | `fase_3/04_operadores_vestro.csv` |
| 7 | Culturas extras: FEIJÃO, MILHETO, AZEVEM, AVEIA PRETA/BRANCA | Descoberto nos plantios | `fase_0/01_culturas.csv` |
| 8 | Campo `qualidade_json` em CARGA_A_CARGA | Campos variam por cultura | `fase_4/14_*.csv` |

---

## Minhas pendências (Rodrigo)

| # | O quê | Com quem | Bloqueador para |
|---|-------|----------|-----------------|
| 1 | Ticket Balança 24/25 milho (arquivo era duplicate) | Vanessa/Josmar | TICKET_BALANCA completo |
| 2 | Carga-a-Carga 22/23 Soja Intacta IPRO (erro 500) | Portal Castrolanda | CARGA_A_CARGA completo |
| 3 | Lista real de silos | Josmar + Claudio | SILOS |
| 4 | Trabalhadores rurais (CLT/PJ/temporário) | Valentina | TRABALHADOR_RURAL |
| 5 | Classificação de 1.825 parceiros sem tipo | Valentina | PARCEIRO_COMERCIAL completo |
| 6 | Operadores com CPF, cargo, fazenda | Valentina | OPERADORES completo |
| 7 | Laudos análise de solo | Alessandro | ANALISE_SOLO |
| 8 | Contratos comerciais | Valentina | CONTRATO_COMERCIAL |
| 9 | Validação Tiago máquinas (9 questões) | Tiago | MAQUINAS import final |

---

## Playground

O arquivo `soal-coleta-playground.html` tem a visualização interativa com status de cada entidade. Manter atualizado conforme coleta avança.

---

*Última atualização: 2026-03-01 | Rodrigo Kugler*
