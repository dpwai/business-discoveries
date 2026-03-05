# DDL Database Engineer — SOAL V0

> Agente especializado em estrutura de banco de dados PostgreSQL para o projeto SOAL.
> Carregar quando: trabalhar com DDL, SQL, Prisma, migrations, seeds, ou imports.

## 1. Arquivos de Referência

| Arquivo | Caminho | Conteúdo |
|---------|---------|----------|
| DDL Completo V0 | `09_Projetos/01_SOAL/DDL/sql/00_DDL_COMPLETO_V0.sql` | 2.525 linhas, 57 tabelas, 40 ENUMs, 3 views, 3 funções |
| Prisma Schema | `09_Projetos/01_SOAL/DDL/prisma/schema.prisma` | 57 modelos + 40 enums |
| GAP Analysis | `09_Projetos/01_SOAL/DDL/GAP_ANALYSIS.md` | Matriz entidade × DDL × CSV × Prisma |
| DDL Playground | `09_Projetos/01_SOAL/DDL/soal-ddl-playground.html` | Status visual interativo |
| ETL Registry | `09_Projetos/01_SOAL/DATA/ETL_REGISTRY.md` | Registro de CSVs e ETLs |

## 2. Estrutura do Banco — 57 Tabelas em 12 Seções

### Seção 0: Funções
- `fn_atualizar_updated_at()` — trigger reutilizada por todas as tabelas
- `fn_entrada_compra_estoque()` — custo médio ponderado (Doc 16)
- `fn_saida_aplicacao_estoque()` — validação de saldo (Doc 16)
- `fn_aplicacao_custo_from_estoque()` — custo automático (Doc 16)

### Seção 1: ENUMs (40)
Territorial: tipo_fazenda, tipo_solo, tipo_silo, status_safra, epoca_safra, grupo_cultura, tipo_parceiro
Operacional: categoria_maquina, tipo_maquina, status_maquina, tipo_combustivel, tipo_manutencao, status_manutencao, tipo_cnh
Colaboradores: tipo_contrato_trabalho, setor_trabalho, tipo_folha_pagamento
Op.Campo: tipo_operacao_campo, status_operacao_campo, tipo_transporte
Insumos: tipo_insumo, grupo_insumo, classe_toxicologica, classe_ambiental, fonte_compra, status_compra, status_estoque, tipo_movimentacao_insumo, metodo_aplicacao, contexto_aplicacao
UBG: tipo_ticket_balanca, status_ticket, tipo_saida_grao, status_estoque_silo
Financeiro: tipo_transacao_extrato, tipo_transacao_cc, tipo_transacao_capital, tipo_financiamento_coop, modalidade_carga
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

### Seção 7: UBG (7 tabelas — Doc 28)
ticket_balancas, producao_ubg, pesagens_agricola, saidas_grao, recebimentos_grao, controles_secagem, estoques_silo + ALTER transporte→ticket_balancas

### Seção 8: Financeiro (7 tabelas — Doc 29)
extratos_cooperativa, cc_cooperativa, contas_capital, financiamentos_coop, vendas_grao, cargas_a_carga, custos_insumo_coop

### Seção 9: Frete+Vendas (2 tabelas — Doc 30)
freteiros, vendas_diretas

### Seção 10: Histórico (1 tabela — Doc 31)
historico_maquinas

### Seção 11: Auxiliar (2 tabelas — orphans)
talhao_mapping, ubg_caixa

### Seção 12: Views (3 — Doc 16)
vw_estoque_consolidado, vw_custo_insumo_talhao_safra, vw_extrato_movimentacoes

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

## 6. Dados Coletados (~93k registros)

| Fase | Registros | Entidades |
|------|-----------|-----------|
| fase_0 | 18.508 | CULTURAS, PRODUTO_INSUMO |
| fase_1 | 9 | ORGANIZATIONS, USERS |
| fase_2 | 2.560 | FAZENDAS→TALHAO_MAPPING |
| fase_3 | 3.555 | MAQUINAS→FOLHA_PAGAMENTO |
| fase_4 | 12.896 | EXTRATO→CARGA_A_CARGA |
| fase_6 | 21.260 | TICKET→UBG_CAIXA |
| fase_6_operacoes | 1.600 | OP_CAMPO→SAIDAS |
| historico | 32.516 | HISTORICO_MAQUINAS |

## 7. Entidades Hub — NUNCA criar atalhos cross-hub

- **TALHAO_SAFRA:** operacoes_campo, aplicacao_insumo, ticket_balancas
- **OPERACAO_CAMPO:** 5 detail tables + aplicacao_insumo
- **PRODUTO_INSUMO:** compra, estoque, aplicacao, receituario
- **MAQUINA:** abastecimentos, manutencoes, operacoes_campo, historico, tags_vestro

## 8. Próximos Passos para João

1. `psql -f 00_DDL_COMPLETO_V0.sql` — criar 57 tabelas
2. `npx prisma db pull` — verificar sync
3. Seed fase_0 → fase_1 → fase_2 (ordem obrigatória)
4. Import CSVs usando scripts Python em DATA/
5. Confirmar `epoca` ENUM em TALHAO_SAFRA

---
*Gerado: 2026-03-04 | DeepWork AI Flows*
