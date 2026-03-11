# DDL Database Engineer — SOAL V0

> Agente especializado em estrutura de banco de dados PostgreSQL para o projeto SOAL.
> Carregar quando: trabalhar com DDL, SQL, Prisma, migrations, seeds, ou imports.

## 1. Arquivos de Referência

| Arquivo | Caminho | Conteúdo |
|---------|---------|----------|
| DDL Completo V0 | `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | 3.031 linhas, 66 tabelas (-producao_ubg +consumo_agriwin), 45 ENUMs, 4 views, 6 funções |
| Prisma Schema | `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | 66 modelos + 45 enums |
| GAP Analysis | `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md` | Matriz entidade × DDL × CSV × Prisma |
| DDL Playground | `09_Projetos/01_SOAL/DDL/soal-ddl-playground.html` | Status visual interativo |
| ETL Registry | `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md` | Registro de CSVs e ETLs |

## 2. Estrutura do Banco — 63 Tabelas em 13 Seções

### Seção 0: Funções
- `fn_atualizar_updated_at()` — trigger reutilizada por todas as tabelas
- `fn_entrada_compra_estoque()` — custo médio ponderado (Doc 16)
- `fn_saida_aplicacao_estoque()` — validação de saldo (Doc 16)
- `fn_aplicacao_custo_from_estoque()` — custo automático (Doc 16)

### Seção 1: ENUMs (44)
Territorial: tipo_fazenda, tipo_solo, tipo_silo, status_safra, epoca_safra, grupo_cultura, tipo_parceiro
Operacional: categoria_maquina, tipo_maquina, status_maquina, tipo_combustivel, tipo_manutencao, status_manutencao, tipo_cnh
Colaboradores: tipo_contrato_trabalho, setor_trabalho, tipo_folha_pagamento
Op.Campo: tipo_operacao_campo, status_operacao_campo, tipo_transporte
Insumos: tipo_insumo, grupo_insumo, classe_toxicologica, classe_ambiental, fonte_compra, status_compra, status_estoque, tipo_movimentacao_insumo, metodo_aplicacao, contexto_aplicacao
UBG: tipo_ticket_balanca, status_ticket, tipo_saida_grao, status_estoque_silo, tipo_secagem, tipo_alocacao_silo
Financeiro Coop: tipo_transacao_extrato, tipo_transacao_cc, tipo_transacao_capital, tipo_financiamento_coop, modalidade_carga
Financeiro FSI: tipo_registro_fsi, situacao_consorcio
Histórico: tipo_registro_maquinario

### Seção 2: Sistema (9 tabelas — Doc 26)
admins, owners, organizations, organization_settings, users, roles, permissions, user_roles, role_permissions

### Seção 3: Territorial (10 tabelas — Doc 26 + 25b + orphans)
fazendas, talhoes, safras, culturas, talhao_safras, silos, parceiros_comerciais, matriculas, ubgs, tanques_combustivel

### Seção 4: Operacional (8 tabelas — Doc 26 + 27 + orphans)
maquinas, operadores, abastecimentos, manutencoes, colaboradores, folha_pagamento, tags_vestro + ALTER operadores→colaboradores

### Seção 5: Insumos (6 tabelas — Doc 16)
produto_insumo, receituario_agronomico, compra_insumo, estoque_insumo, aplicacao_insumo, movimentacao_insumo

### Seção 6: Operações Campo (6 tabelas — Doc 25a)
operacoes_campo, plantio_detalhes, colheita_detalhes, pulverizacao_detalhes, drone_detalhes, transporte_colheita_detalhes + ALTER aplicacao_insumo→operacoes_campo

### Seção 7: UBG (9 tabelas — Doc 28)
ticket_balancas, pesagens_agricola, saidas_grao, recebimentos_grao, controles_secagem, leituras_secagem, estoques_silo, alocacoes_silo, consumo_agriwin

### Seção 8: Financeiro Coop (7 tabelas — Doc 29)
extratos_cooperativa, cc_cooperativa, contas_capital, financiamentos_coop, vendas_grao, cargas_a_carga, custos_insumo_coop

### Seção 8b: Financeiro FSI (4 tabelas)
fluxo_caixa_fsi, caixa_escritorio_fsi, kugler_x_fsi, consorcios_fsi

### Seção 9: Frete+Vendas (2 tabelas — Doc 30)
freteiros, vendas_diretas

### Seção 10: Histórico (1 tabela — Doc 31)
historico_maquinas

### Seção 11: Auxiliar (2 tabelas — orphans)
talhao_mapping, ubg_caixa

### Seção 12: Views (4 — Doc 16 + UBG)
vw_estoque_consolidado, vw_custo_insumo_talhao_safra, vw_extrato_movimentacoes, vw_estoque_silo_atual

## 3. Conflitos Resolvidos

| Conflito | Resolução |
|----------|-----------|
| trabalhadores_rurais vs colaboradores | COLABORADORES vence (Doc 27 > Doc 26) |
| tipo_contrato_trabalho ENUM | clt, informal, temporario, safrista (Doc 27) |
| fn_update_timestamp vs fn_atualizar_updated_at | Unificado: fn_atualizar_updated_at() |
| PK naming: id vs entidade_id | Padronizado: entidade_id (CLAUDE.md §3) |
| FK references inconsistentes | Padronizado: organization_id como PK |
| vendas_castrolanda vs vendas_grao | Merge em vendas_grao |

## 4. Convenções SQL (de CLAUDE.md §3)

| Elemento | Convenção | Exemplo |
|----------|-----------|---------|
| Tabelas SQL | plural snake_case | `talhao_safras` |
| Primary Keys | `entidade_id` UUID | `talhao_safra_id UUID` |
| Foreign Keys | `entidade_referenciada_id` | `safra_id`, `talhao_id` |
| Atributos | snake_case | `area_ha`, `horimetro_inicial` |
| Timestamps | sempre os dois | `created_at`, `updated_at` |
| PKs | **sempre UUID** | `DEFAULT gen_random_uuid()` |

### Prisma Conventions
- PascalCase models → `@@map("snake_case_plural")`
- camelCase fields → `@map("snake_case")`
- PK: `id @map("entidade_id")`
- `@db.Uuid`, `@db.Timestamptz`, `@db.Decimal(x,y)`, `@db.VarChar(n)`
- `@updatedAt` no campo updatedAt
- Named relations quando ambíguo

## 5. Regras de Modificação

1. **Nunca alterar entidade sem atualizar AMBOS:** SQL DDL + Prisma Schema
2. **Novo ENUM:** Seção 1 do SQL + topo do Prisma
3. **Nova tabela:** Seção correta do SQL + model Prisma + relações reversas
4. **Nova FK:** Aplicar Dijkstra check (CLAUDE.md §4.1)
5. **Triggers:** TODAS as tabelas devem ter trigger updated_at
6. **Indexes:** TODAS as FKs devem ter index

## 6. Dados Coletados (~106k registros)

| Fase | Registros | Entidades |
|------|-----------|-----------|
| fase_0 | 18.508 | CULTURAS, PRODUTO_INSUMO |
| fase_1 | 9 | ORGANIZATIONS, USERS |
| fase_2 | 2.560 | FAZENDAS→TALHAO_MAPPING |
| fase_3 | 3.555 | MAQUINAS→FOLHA_PAGAMENTO |
| fase_4 | 25.719 | EXTRATO→CARGA_A_CARGA + FSI (fluxo_caixa 10.119 + caixa_escritorio 1.185 + kugler_x_fsi 1.499 + consorcios 20) |
| fase_6 | 21.260 | TICKET→UBG_CAIXA |
| fase_6_operacoes | 1.600 | OP_CAMPO→SAIDAS |
| historico | 32.516 | HISTORICO_MAQUINAS |

## 7. Entidades Hub — NUNCA criar atalhos cross-hub

- **TALHAO_SAFRA:** operacoes_campo, aplicacao_insumo, ticket_balancas
- **OPERACAO_CAMPO:** 5 detail tables + aplicacao_insumo
- **PRODUTO_INSUMO:** compra, estoque, aplicacao, receituario
- **MAQUINA:** abastecimentos, manutencoes, operacoes_campo, historico, tags_vestro

## 8. Próximos Passos para João

1. `psql -f 00_DDL_COMPLETO_V0.sql` — criar 66 tabelas
2. `npx prisma db pull` — verificar sync
3. Seed fase_0 → fase_1 → fase_2 (ordem obrigatória)
4. Import CSVs usando scripts Python em DATA/
5. Confirmar `epoca` ENUM em TALHAO_SAFRA

---
*Atualizado: 2026-03-06 | DeepWork AI Flows*
