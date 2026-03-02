# Doc 21 — Alinhamento DPWAI App x SOAL Bronze Layer

> Mapeamento completo entre o schema Prisma do app (dpwai-app) e os dados coletados (DATA/IMPORTS/).
> Criado: 2026-03-01 | Autores: Rodrigo Kugler + Claude

---

## 1. Contexto

O João incluiu o repo `dpwai-app` no workspace em 2026-02-28. Nessa sessão:

### Trabalho realizado no dpwai-app:
1. **Removido módulo Simulador** — página + 11 componentes + 10 API routes + 3 models Prisma (CropPlan, CropPlanItem, CropPlanViewPreset) + constantes. -3.135 linhas.
2. **Limpeza de dependências duplicadas** — removido `bcrypt` (mantido `bcryptjs`), `motion` (mantido `framer-motion`), `@types/bcrypt`, `@types/bcryptjs`.
3. **Análise completa do app** — 516 API routes, 259 models Prisma, ~160 páginas tenant, 19 CSV templates de importação.
4. **Branch:** `feat/data-coverage-audit-fixes` — 2 commits pushados.

### Trabalho anterior do João (audit `9c057fde`):
- Criou model `Cultura` (faltava)
- Criou model `FuelTank` (tanques combustível)
- Expandiu `Machinery` com `purchaseValue`, `rfidTag`, `engineNumber`, `serialRenavam`
- Expandiu `Operador` com `matriculaExterna` (Vestro), `empresa`, `tipo`
- Expandiu `TicketBalanca` com campos de qualidade (umidade, pH, impureza, ardido, verde)
- Expandiu `ManutencaoMaquina`, `FuelingRecord`, `EndividamentoRural`
- Adicionou `fiscalYearStart/End` em `Safra`
- Adicionou 25+ campos Castrolanda em `VendaGrao`

---

## 2. Mapeamento Entidades: App Prisma ↔ SOAL DDL ↔ CSV Import

### Camada Sistema

| Prisma Model | SOAL DDL (Doc 26) | CSV Import | Status |
|-------------|-------------------|------------|--------|
| `Tenant` | ORGANIZATIONS | — (seed João) | ✅ OK |
| `User` + `Membership` | USERS | — (seed João) | ✅ OK |
| `RBACRole` + `RBACPermission` | ROLES + PERMISSIONS | — (seed João) | ✅ OK |

### Camada Territorial

| Prisma Model | SOAL DDL (Doc 26) | CSV Import | Rows | Status |
|-------------|-------------------|------------|------|--------|
| `Safra` | SAFRAS | `fase_2/01_safras.csv` | 11 | ✅ OK |
| `Property` | FAZENDAS | `fase_2/02_fazendas.csv` | 13 | ✅ OK |
| `Talhao` | TALHOES | `fase_2/03_talhoes.csv` | 72 | ✅ OK |
| `TalhaoMapping` | — (não existe no DDL) | `fase_2/03b_talhao_nome_mapping.csv` | 184 | ✅ EXTRA útil |
| `Cultura` | CULTURAS | `fase_0/01_culturas.csv` | 10 | ✅ OK |
| `TalhaoSafra` | TALHAO_SAFRAS | `fase_5/07_talhao_safra_2425.csv` + `08_talhao_safra_2526.csv` | 251 | ⚠️ cultura é String livre |
| `Silo` | SILOS | — (Josmar pendente) | — | ⏳ Bloqueado |
| `Fornecedor` + `Cliente` | PARCEIROS_COMERCIAIS | `fase_2/05_parceiros_template.csv` + `06_parceiros_agriwin.csv` | 2.210 | ✅ OK (split vs unified) |

### Camada Operacional

| Prisma Model | SOAL DDL (Doc 26) | CSV Import | Rows | Status |
|-------------|-------------------|------------|------|--------|
| `Machinery` | MAQUINAS | `fase_3/04_maquinas.csv` | 184 | ✅ OK |
| `Operador` | OPERADORES | `fase_3/04_operadores_vestro.csv` + `05_operadores_parcial.csv` | 62 | ⚠️ Parcial (falta CPF/cargo) |
| `FuelingRecord` | ABASTECIMENTOS | `fase_6/10_fuel_supplies.csv` + `12_abastecimentos_historico.csv` | 23.790 | ✅ OK |
| `FuelTank` | TANQUES_COMBUSTIVEL | `fase_3/06_fuel_tanks.csv` | 5 | ✅ OK |
| `ManutencaoMaquina` | MANUTENCOES | `fase_6/11_manutencoes_historico.csv` | 9.871 | ✅ OK |
| `Funcionario` | TRABALHADORES_RURAIS | — (Valentina pendente) | — | ⏳ Bloqueado |

### Camada Agrícola

| Prisma Model | SOAL DDL (Doc 16) | CSV Import | Rows | Status |
|-------------|-------------------|------------|------|--------|
| `OperacaoCampo` | OPERACAO_CAMPO | `fase_6/13_operacoes_campo_historico.csv` | 31 | ✅ OK (pouco dado) |
| `ProdutoInsumo` | PRODUTO_INSUMO | `fase_0/02_produto_insumo_seed.csv` + `03_produto_insumo_agriwin.csv` | 18.538 | ✅ OK |
| `CompraInsumo` | COMPRA_INSUMO | — | — | ⏳ Fase posterior |
| `EstoqueInsumo` | ESTOQUE_INSUMO | — | — | ⏳ Fase posterior |
| `AplicacaoInsumo` | APLICACAO_INSUMO | — | — | ⏳ Fase posterior |
| `AnaliseSolo` | ANALISE_SOLO | — (Alessandro pendente) | — | ⏳ Bloqueado |
| `CentroCusto` | CENTRO_CUSTO | `fase_3/07_centro_custo.csv` | 387 | ✅ OK |

### Camada Financeira / Castrolanda

| Prisma Model | SOAL DDL | CSV Import | Rows | Status |
|-------------|----------|------------|------|--------|
| `VendaGrao` | VENDA_GRAO | `fase_4/13_castrolanda_vendas.csv` | 171 | ✅ OK |
| — (Carga a Carga) | — | `fase_4/14_castrolanda_carga_a_carga.csv` | 1.338 | ✅ OK (sem model ainda) |
| `EndividamentoRural` | ENDIVIDAMENTO | `fase_4/11_castrolanda_financiamentos.csv` | 221 | ✅ OK |
| `ContaPagar` | CONTA_PAGAR | — | — | ⏳ Fase posterior |
| `ContaReceber` | CONTA_RECEBER | — | — | ⏳ Fase posterior |
| `NotaFiscalAgro` | NOTA_FISCAL | — | — | ⏳ Fase posterior |
| `ContratoComercial` | CONTRATO_COMERCIAL | — (Valentina pendente) | — | ⏳ Bloqueado |

### Camada UBG

| Prisma Model | SOAL DDL | CSV Import | Rows | Status |
|-------------|----------|------------|------|--------|
| `TicketBalanca` | TICKET_BALANCA | `fase_6/09_ticket_balanca.csv` | 549 | ⚠️ Só 23/24 (24/25 milho duplicado) |
| `SiloUBG` | SILO_UBG | — (Josmar pendente) | — | ⏳ Bloqueado |
| `RecebimentoGrao` | RECEBIMENTO_GRAO | — | — | ⏳ Fase posterior |
| `ControleSecagem` | CONTROLE_SECAGEM | — | — | ⏳ Fase posterior |
| `EstoqueSiloUBG` | ESTOQUE_SILO_UBG | — | — | ⏳ Fase posterior |
| `SaidaGraoUBG` | SAIDA_GRAO | — | — | ⏳ Fase posterior |

---

## 3. Mapeamento de Headers: Templates App ↔ CSVs Nossos

Os 19 templates do app (`templates_dpwai_app/`) definem os headers da UI de importação.
Os 31 CSVs nossos (`fase_*/`) contêm dados reais já processados via ETL.

### Templates com CSV correspondente pronto:

| Template App | CSV SOAL | Compatível? | Diferenças |
|-------------|----------|-------------|------------|
| `template_culturas.csv` | `fase_0/01_culturas.csv` | ✅ Match | Headers idênticos |
| `template_talhao_safra.csv` | `fase_5/07_talhao_safra_2425.csv` | ⚠️ Parcial | App: pt-BR headers / SOAL: en headers + lookups |
| `template_operadores.csv` | `fase_3/04_operadores_vestro.csv` | ⚠️ Parcial | App tem mais campos (cpf, cnh, telefone) |
| `template_abastecimentos.csv` | `fase_6/12_abastecimentos_historico.csv` | ⚠️ Parcial | SOAL tem source_file/aba extras |
| `template_manutencoes.csv` | `fase_6/11_manutencoes_historico.csv` | ✅ ~Match | Campos quase idênticos |
| `template_operacoes_campo.csv` | `fase_6/13_operacoes_campo_historico.csv` | ⚠️ Parcial | SOAL tem source_file/aba extras |
| `template_ticket_balanca.csv` | `fase_6/09_ticket_balanca.csv` | ⚠️ Parcial | SOAL tem source_tab_name, is_seed |
| `template_vendas.csv` | `fase_4/13_castrolanda_vendas.csv` | ⚠️ Diferente | SOAL tem 24 campos, template tem 8 |
| `template_tanques_combustivel.csv` | `fase_3/06_fuel_tanks.csv` | ✅ Match | Headers equivalentes |
| `template_centros_custo.csv` | `fase_3/07_centro_custo.csv` | ✅ ~Match | Campos equivalentes |
| `template_fornecedores.csv` | `fase_2/06_parceiros_agriwin.csv` | ⚠️ Diferente | SOAL tem doc_type, cpf_cnpj_valid |
| `template_maquinas.csv` | `fase_3/04_maquinas.csv` | ❌ Diferente | Template = log diário / SOAL = cadastro |

### Templates SEM CSV correspondente (precisam de coleta):

| Template App | Entidade | Quem coleta | Quando |
|-------------|----------|-------------|--------|
| `template_clientes.csv` | Cliente | Valentina | Fase posterior |
| `template_custos.csv` | CustoProducaoTalhao | Calculado | Após operações |
| `template_estoque.csv` | EstoqueInsumo | Valentina | Fase posterior |
| `template_insumos.csv` | AplicacaoInsumo | Alessandro/Tiago | Fase posterior |
| `template_producao.csv` | Colheita | Tiago | Fase posterior |
| `template_safras.csv` | TalhaoSafra (alt) | — | Duplica template_talhao_safra |
| `template_geral.csv` | Genérico | — | Catch-all |

---

## 4. Gaps e Bloqueadores para Continuar Coleta

### ALTA PRIORIDADE — Bloqueiam importação

| # | Gap | Responsável | Dependência |
|---|-----|-------------|-------------|
| 1 | **Import API não grava no banco** — POST retorna sucesso fake (TODO em todos os switch cases) | João | Nenhuma |
| 2 | **TalhaoSafra.cultura é String livre** — não referencia model Cultura via FK | João | Nenhuma |
| 3 | **Seed SOAL parcial** — 2 fazendas/10 talhões/8 máquinas (precisa dos 7/72/183 reais) | João | CSVs prontos ✅ |
| 4 | **Ticket Balança 24/25 milho** — arquivo entregue era duplicate do 23/24 | Rodrigo | Vanessa/Josmar |

### MÉDIA PRIORIDADE — Bloqueiam fases futuras

| # | Gap | Responsável | Dependência |
|---|-----|-------------|-------------|
| 5 | Lista completa de Silos | Josmar + Claudio | Reunião |
| 6 | Trabalhadores Rurais (CLT/PJ/temporário) | Valentina | Reunião |
| 7 | Análise de Solo (laudos) | Alessandro | Laudos PDF/planilha |
| 8 | Contratos comerciais | Valentina | Documentos |
| 9 | Operadores — falta CPF, cargo, fazenda base | Valentina | Reunião |
| 10 | Castrolanda Carga-a-Carga 22/23 Soja Intacta IPRO | Rodrigo | Re-download (erro 500) |

### BAIXA PRIORIDADE — Melhorias

| # | Gap | Notas |
|---|-----|-------|
| 11 | Headers template_app vs CSV SOAL desalinhados | Decidir: adaptar CSVs para headers app ou vice-versa |
| 12 | Fornecedor + Cliente separados no app vs PARCEIRO_COMERCIAL unificado no DDL | Design válido, apenas documentar |
| 13 | Model SafraCultura existe no app mas não no DDL SOAL | Extra útil — manter |

---

## 5. Próximos Passos — Ordem de Execução

### Fase A: Alinhar Schema (João)
1. Implementar Import API — persistência real por categoria no `POST /api/agro/[tenant]/importacao`
2. Adicionar FK `Cultura` em `TalhaoSafra` (hoje é String)
3. Atualizar seed SOAL com dados reais dos CSVs

### Fase B: Importar Dados Base (Rodrigo + João)
1. Importar Fase 0: Culturas (10) + Produto Insumo seed (38)
2. Importar Fase 2: Safras (11) + Fazendas (7) + Talhões (72) + Parceiros (2.210)
3. Importar Fase 3: Máquinas (183) + Operadores (62) + Tanks (5) + Centro Custo (387)
4. Importar Fase 5: TalhaoSafra 24/25 (196) + 25/26 (55)

### Fase C: Importar Dados Operacionais (Rodrigo + João)
5. Importar Fase 6: Ticket Balança (549) + Abastecimentos (23.790) + Manutenções (9.871) + Operações (31)
6. Importar Fase 4: Castrolanda (extrato 8.212 + vendas 171 + carga-a-carga 1.338 + financiamentos 221)

### Fase D: Coleta Pendente (Rodrigo coordena)
7. Ticket Balança 24/25 milho (Vanessa/Josmar)
8. Silos (Josmar)
9. Trabalhadores (Valentina)
10. Análise Solo (Alessandro)
11. Contratos (Valentina)

---

## 6. Inventário de Arquivos

### No business-discoveries (este repo):
```
DATA/IMPORTS/
├── 00_CSV_INVENTORY_TABLE.md          ← este inventário (31 CSVs, 69.285 rows)
├── 00_from_to_mapping.csv             ← metadata de mapeamento de colunas
├── generate_all_imports.py            ← script master que gera todos os CSVs
├── fill_talhao_mapping.py             ← reconciliação de nomes talhão
├── templates_dpwai_app/               ← 19 templates copiados do app (headers UI)
├── fase_0/                            ← 3 CSVs (culturas, insumos seed, insumos AgriWin)
├── fase_2/                            ← 6 CSVs (safras, fazendas, talhões, parceiros)
├── fase_3/                            ← 6 CSVs (máquinas, operadores, tags, tanks, CC)
├── fase_4/                            ← 8 CSVs (Castrolanda: extrato, CC, capital, vendas, etc)
├── fase_5/                            ← 2 CSVs (talhão_safra 24/25 + 25/26)
└── fase_6/                            ← 5 CSVs (ticket balança, fuel, manutenção, operações)
```

### No dpwai-app:
```
dpwaiagro/prisma/
├── schema.prisma                      ← 259 models, ~10K linhas
├── seed.ts                            ← Seed base (plans, demo tenant, departments)
├── seed-soal-data.ts                  ← Seed SOAL parcial (2 fazendas, 10 talhões, 8 máquinas)
├── seed-soal-forms-25.ts              ← 25 formulários SOAL mock
└── seed-rbac.ts                       ← RBAC permissions catalog

dpwaiagro/public/templates/importacao/
└── 19 templates CSV                   ← Headers para UI de importação

dpwaiagro/app/api/agro/[tenant]/importacao/
└── route.ts                           ← ⚠️ TODO: persistência não implementada
```

---

*Última atualização: 2026-03-01 | Rodrigo Kugler + Claude*
