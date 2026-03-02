# Plano de Reconstrução de Dados — SOAL

> Atualizado: 2026-03-01 21:45 | Pós-recuperação de transcripts

---

## Status da Recuperação

### ✅ RECUPERADO COM SUCESSO (36 arquivos de transcripts)

**ETL Scripts (12):**
- `CASTROLANDA/etl_castrolanda_capital_html.py` (222 lines)
- `CASTROLANDA/etl_castrolanda_carga_a_carga.py` (380 lines)
- `CASTROLANDA/etl_castrolanda_cc.py` (291 lines)
- `CASTROLANDA/etl_castrolanda_extrato.py` (310 lines)
- `CASTROLANDA/etl_castrolanda_pdf.py` (662 lines)
- `CASTROLANDA/etl_castrolanda_vendas.py` (279 lines)
- `INSUMOS/etl_insumos.py` (268 lines)
- `MAQUINÁRIO/etl_maquinario.py` (1000 lines)
- `MAQUINÁRIO/ABASTECIMENTOS/etl_tags_vestro.py` (220 lines)
- `PARCEIROS_PESSOAS/etl_parceiros.py` (281 lines)
- `UBG/etl_ubg_caixa.py` (297 lines)
- `UBG/producao/etl_ticket_balanca.py` (309 lines)

**Source CSVs (5):**
- `Lista_Maquinas_Consolidado.csv` (183 registros — corrigido quoting)
- `Listagem_Plantio_24_25.csv` (63 registros)
- `Listagem_Plantio_25_26.csv` (54 registros)
- `ORG/Listagem_Propriedades.csv` (12 propriedades)
- `ORG/Listagem_Talhoes.csv` (74 talhões)

**Import Infrastructure (4):**
- `IMPORTS/generate_all_imports.py` (317 lines — corrigido safe_run + on_bad_lines)
- `IMPORTS/fill_talhao_mapping.py` (137 lines)
- `IMPORTS/00_from_to_mapping.csv` (93 mapeamentos)
- `DATA/.gitignore`

**Documentação (6):**
- `19_DIAGRAMA_ER_SOAL/24_PLANO_COLETA_DADOS.md` (40KB)
- `19_DIAGRAMA_ER_SOAL/25_DDL_OPERACOES_CAMPO.md` (13KB)
- `19_DIAGRAMA_ER_SOAL/26_DDL_FUNDACIONAL_SISTEMA_TERRITORIAL_OPERACIONAL.md` (36KB)
- `19_DIAGRAMA_ER_SOAL/26_PRISMA_SCHEMA_FUNDACIONAL.prisma` (24KB)
- `19_DIAGRAMA_ER_SOAL/miro_api/draw_er_v2.py` (23KB)
- `10_REUNIOES/VALIDACAO_TIAGO_MAQUINAS.md` (8.6KB)

**Auxiliares criados (3):**
- `ORG/Listagem_Tanques.csv` (5 tanques — de memória, validar com Tiago)
- `AGRICULTURA/Listagem_Plantio.csv` (cópia de 24_25)
- `AGRICULTURA/Listagem_Plantio_25_26.csv` (cópia)

---

### ✅ CSVs GERADOS com generate_all_imports.py

| Fase | CSV | Registros | Status |
|------|-----|-----------|--------|
| 0 | `fase_0/01_culturas.csv` | 9 | ✅ |
| 1 | `fase_1_sistema/01_organizations.csv` | 1 | ✅ |
| 1 | `fase_1_sistema/02_users.csv` | 8 | ✅ |
| 2 | `fase_2/01_safras.csv` | 9 | ✅ |
| 2 | `fase_2/02_fazendas.csv` | 12 | ✅ |
| 2 | `fase_2/03_talhoes.csv` | 74 | ✅ |
| 2 | `fase_2/03b_talhao_nome_mapping.csv` | 170 | ✅ |
| 2 | `fase_2_territorial/01_ubg.csv` | 1 | ✅ (template) |
| 2 | `fase_2_territorial/02_silos_ubg.csv` | 8 | ✅ (template) |
| 3 | `fase_3/04_maquinas.csv` | 183 | ✅ |
| 3 | `fase_3/06_fuel_tanks.csv` | 5 | ✅ |
| 5 | `fase_5/07_talhao_safra_2425.csv` | 63 | ✅ |
| 5 | `fase_5/08_talhao_safra_2526.csv` | 54 | ✅ |
| 6 | `fase_6_operacoes/01_operacoes_campo_colheita.csv` | 5 | ✅ (template) |
| 6 | `fase_6_operacoes/02_operacoes_campo_plantio.csv` | 5 | ✅ (template) |
| 6 | `fase_6_operacoes/03_colheita_detalhe.csv` | 1 | ✅ (template) |

**Total gerado: 16 CSVs, 598 registros reais + templates**

---

### ⚠ NÃO GERADOS (falta arquivo fonte)

| CSV | Bloqueio | Como resolver |
|-----|----------|--------------|
| `fase_3/05_operadores.csv` | TICKET_BALANCA_historico.csv | Re-obter xlsx do Josmar |
| `fase_6/ticket_balanca.csv` | TICKET_BALANCA_historico.csv | Idem |
| `fase_6/fuel_supplies.csv` | Vestro_Abastecimentos_Clean.csv | Re-exportar portal Vestro (João) |
| `fase_2/04_parceiros_template.csv` | Parceiros_AgriWin_Clean.csv | Re-rodar ETL com xlsx (pedir para Valentina/João) |

---

### ❌ DADOS PROCESSADOS FALTANTES (outputs de ETL)

Estes são CSVs "Clean" que precisam dos xlsx/html fonte para serem re-gerados.
**Os ETL scripts estão todos recuperados** — só falta o input.

| Output | Registros | ETL Script | Input necessário | Disponível? |
|--------|-----------|-----------|------------------|-------------|
| `UBG_Caixa_Historico_Clean.csv` | 19.177 | etl_ubg_caixa.py | xlsx UBG Caixa | ❓ Verificar |
| `TICKET_BALANCA_historico.csv` | 548 | etl_ticket_balanca.py | 3 xlsx (soja/milho/feijão) | ❌ Pedir Josmar |
| `Parceiros_AgriWin_Clean.csv` | 2.201 | etl_parceiros.py | xlsx AgriWin | ❌ Deletados |
| `Insumos_AgriWin_Clean.csv` | 18.499 | etl_insumos.py | xlsx AgriWin | ❌ Deletados |
| `Castrolanda_Extrato_Clean.csv` | 8.211 | etl_castrolanda_extrato.py | HTML xls | ❓ Verificar portal |
| `Castrolanda_CC_Clean.csv` | 2.889 | etl_castrolanda_pdf.py | PDFs | ❓ Verificar |
| `Castrolanda_Capital_Clean.csv` | 119 | etl_castrolanda_capital_html.py | 15 xls | ✅ Em ~/Documents/ |
| `Castrolanda_Vendas_Clean.csv` | 170 | etl_castrolanda_vendas.py | HTML xls | ❓ Verificar portal |
| `Castrolanda_Carga_Clean.csv` | 1.337 | etl_castrolanda_carga_a_carga.py | HTML xls | ❓ Verificar portal |
| `Castrolanda_Financ_Clean.csv` | 220 | etl_castrolanda_pdf.py | PDFs | ❓ Verificar |
| `Maquinario_Historico_*.csv` | 32.516 | etl_maquinario.py | 11 xlsx | ❓ Verificar |
| `Vestro_Abastecimentos.csv` | 1.172 | etl_tags_vestro.py | Portal Vestro | ❌ João re-exportar |

**Total faltante: ~86.789 registros — TODOS re-geráveis com ETL scripts + input**

---

## Plano de Ação

### 1. IMEDIATO ✅ FEITO
- [x] Recuperar arquivos dos transcripts (36 arquivos)
- [x] Corrigir CSV de máquinas (quoting fix)
- [x] Re-rodar generate_all_imports.py (16 CSVs gerados)
- [x] Criar plano de reconstrução

### 2. ESTA SEMANA — Localizar xlsx fontes no Mac
- [ ] Buscar em ~/Documents/, ~/Desktop/, iCloud Drive
- [ ] Castrolanda Capital → **15 xls em ~/Documents/** ✅ encontrados
- [ ] Maquinário xlsx → verificar se existem em algum lugar
- [ ] UBG Caixa xlsx → verificar
- [ ] Castrolanda Extrato/Vendas/Carga HTML → re-baixar do portal se necessário
- [ ] Re-rodar ETLs que têm fonte disponível

### 3. ESTA SEMANA — Reunião Tiago
- [ ] Levar README_REUNIAO_TIAGO_OPERACOES.md (16 perguntas)
- [ ] Levar VALIDACAO_TIAGO_MAQUINAS.md (9 questões pendentes)
- [ ] Coletar dados operações campo históricos

### 4. PRÓXIMAS 2 SEMANAS — Re-obter dados faltantes
- [ ] Josmar: 3 xlsx Ticket Balança 23/24
- [ ] João: Re-exportar Vestro portal
- [ ] Valentina/João: Re-exportar AgriWin (Parceiros + Insumos)
- [ ] Castrolanda: PDFs C/C e Financiamentos (se não achados localmente)

### 5. MÉDIO PRAZO — Completar pipeline
- [ ] Re-rodar TODOS os ETLs com dados fonte
- [ ] Completar CSVs faltantes (operadores, ticket, fuel_supplies, parceiros)
- [ ] Reunião stakeholders para completar templates (UBG, Silos, Org)

---

## Nota: Dados ficam LOCAL ONLY
Dados confidenciais da SOAL (CSVs, xlsx, PDFs) **NÃO vão para o git**.
O `.gitignore` em DATA/ já protege: `*.csv`, `*.xlsx`, `*.xls`, `*.pdf`.
Scripts `.py` e docs `.md` podem ser commitados se necessário.
