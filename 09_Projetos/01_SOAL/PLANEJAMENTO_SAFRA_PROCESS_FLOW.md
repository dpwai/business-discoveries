# Process Flow — Planejamento de Safra (Mai-Jun)

> Documento interno DeepWork AI Flows | Projeto SOAL
> Criado: 2026-03-06

---

## Contexto

O planejamento de safra hoje eh manual: Alessandro + Lucas + Claudio se reunem 2-3 vezes em Mai-Jun, decidem cultura x talhao x cultivar, e Alessandro produz uma planilha Excel. A pasta `fase_5/` estava vazia porque nunca foi digitalizado.

**Objetivo:** Digitalizar o processo pre-safra e alimentar automaticamente o calendario Gantt (`SafraCalendar.tsx`) que o Joao ja construiu no `dpwai-app`.

**Insight critico:** Quando o usuario escolhe uma cultura pra um talhao, o sistema auto-gera as operacoes esperadas (ex: feijao = preparo solo, plantio, 6x pulv, colheita). Isso cria o "calendario pre-montado".

---

## Process Flow: 6 Etapas

### Etapa 1 — Criar Safra (Admin/Rodrigo)

```
Trigger: Todo ano em Abril-Maio
Quem: Admin (Rodrigo ou sistema automatico)
Acao: Criar registro SAFRA 26/27 (Jul 2026 -> Jun 2027) com status 'planejamento'
Output: safra_id criado
```

### Etapa 2 — Gerar Grid de Planejamento (Sistema)

```
Trigger: Safra criada
Quem: Sistema automatico
Acao:
  1. Buscar todos 71 talhoes ativos (com fazenda, area_ha)
  2. Buscar safra anterior (25/26) — o que foi plantado em cada talhao
  3. Gerar grid:
     +--------------------+--------+----------+----------+----------+----------+
     | Talhao (Fazenda)   | Area   | 25/26    | 26/27    | 26/27    | Obs      |
     |                    | (ha)   | Safra    | Safra    | Safrinha |          |
     +--------------------+--------+----------+----------+----------+----------+
     | LAGARTO (Santana)  | 117,0  | Soja     | [      ] | [      ] |          |
     | MASSACRE (Santana) |  85,0  | Milho    | [      ] | [      ] |          |
     | CAPINZAL (Capinz.) |  21,5  | Soja     | [      ] | [      ] |          |
     +--------------------+--------+----------+----------+----------+----------+
  4. Coluna "25/26 Safra" = referencia (read-only) pra facilitar decisao de rotacao
  5. Indicador visual: % da area total em gramineas (meta: 25-30%)
Output: Grid pronta pra preencher
```

### Etapa 3 — Preencher Plano (Alessandro, 1a rodada)

```
Trigger: Grid disponivel
Quem: Alessandro (agronomo)
Acao:
  1. Para cada talhao, selecionar:
     - Cultura safra (dropdown: soja, milho, feijao, trigo, cevada...)
     - Cultivar (text: BMX 56IX58, AS 3595 I2X...)
     - Cultura safrinha (opcional)
     - Cultivar safrinha (opcional)
     - Observacoes (text livre)
  2. A cada selecao de cultura, sistema MOSTRA:
     - % gramineas atualizado em tempo real (diretriz 25-30%)
     - Timeline preview das operacoes esperadas (do template)
  3. Pode importar via CSV (formato fase_5) se quiser preencher offline
  4. Salvar = cria TALHAO_SAFRA records com status 'rascunho'
  5. Sistema salva SNAPSHOT v1 automaticamente
Output: Plano v1 (rascunho Alessandro)
```

### Etapa 4 — Revisao (Lucas + Alessandro, 2a rodada)

```
Trigger: Alessandro marca plano como "pronto pra revisao"
Quem: Lucas (consultor) + Alessandro
Acao:
  1. Lucas abre o plano — ve grid com escolhas do Alessandro
  2. Pode alterar: cultura, cultivar, observacoes
  3. Cada alteracao registra quem mudou e quando
  4. Inputs do Lucas: dados historicos (produtividade, patogenos), pesquisa Fundacao ABC
  5. Salvar = SNAPSHOT v2 automaticamente
  6. Sistema mostra diff v1 -> v2 (highlight do que mudou)
Output: Plano v2 (revisao Lucas)
```

### Etapa 5 — Aprovacao (Claudio, 3a rodada)

```
Trigger: Lucas/Alessandro marcam como "pronto pra aprovacao"
Quem: Claudio (owner/decisor final)
Acao:
  1. Claudio ve plano final com diff das versoes
  2. Pode fazer ajustes finais
  3. Aprova -> status de todos TALHAO_SAFRA muda pra 'aprovado'
  4. SNAPSHOT v3 (final/aprovado) salvo automaticamente
Output: Plano aprovado -> alimenta calendario do Joao
```

### Etapa 6 — Gerar Operacoes (Sistema, automatico)

```
Trigger: Plano aprovado
Quem: Sistema automatico
Acao:
  1. Para cada TALHAO_SAFRA aprovado:
     - Buscar TEMPLATE da cultura (ex: feijao)
     - Gerar SAFRA_ACAO records com datas relativas ao plantio estimado
     - Ex feijao: preparo_solo (-30d), plantio (dia 0), pulv_herbicida (+7d),
       pulv_inseticida (+14d), pulv_fungicida (+21d), pulv_fungicida (+35d),
       pulv_inseticida (+49d), pulv_fungicida (+63d), colheita (+90d)
  2. Operacoes aparecem no calendario Gantt do Joao
  3. Status SAFRA muda pra 'em_andamento' quando primeiro plantio acontecer
Output: Calendario pre-montado com todas operacoes esperadas
```

---

## DDL Changes

### 1. Novo ENUM: `status_talhao_safra`

9 valores: `rascunho`, `em_revisao`, `aprovado`, `preparando`, `plantado`, `em_desenvolvimento`, `colhendo`, `colhido`, `cancelado`

### 2. ALTER `talhao_safras`: +5 campos

| Campo | Tipo | Descricao |
|-------|------|-----------|
| `status_planejamento` | `status_talhao_safra NOT NULL DEFAULT 'rascunho'` | Lifecycle do planejamento/execucao |
| `meta_produtividade_sc_ha` | `NUMERIC(10,2)` | Meta de produtividade em sacas/ha |
| `atribuido_por` | `VARCHAR(200)` | Quem definiu esta cultura |
| `aprovado_por` | `VARCHAR(200)` | Quem aprovou |
| `data_aprovacao` | `DATE` | Quando foi aprovado |

### 3. Nova tabela: `plano_safra_snapshots`

Snapshots versionados (v1=Alessandro, v2=Lucas, v3=Claudio). `dados_json` = JSONB com array completo do plano.

### 4. Nova tabela: `template_cultura_operacoes`

Templates de operacoes por cultura. FK para `culturas` e usa ENUM `tipo_operacao_campo`. `dias_offset_inicio` relativo ao plantio (dia 0).

### 5. Nova tabela: `safra_acoes`

Acoes geradas automaticamente a partir dos templates. FK para `talhao_safras`, `safras`, `users` (responsavel), e `template_cultura_operacoes`. Alimenta o calendario Gantt.

---

## CSV Templates (fase_5/)

### `01_planejamento_safra.csv`

Headers: `safra,fazenda,talhao,gleba,cultura,epoca,cultivar,area_plantada_ha,meta_produtividade_sc_ha,origem_semente,observacoes`

### `02_template_operacoes_cultura.csv`

Headers: `cultura,tipo_operacao,nome_operacao,fase,dias_offset_inicio,duracao_dias,sequencia,obrigatoria`

Seed data incluido: soja (9 ops), milho (7 ops), feijao (10 ops), trigo (7 ops), cevada (6 ops), aveia_preta (3 ops) = 42 templates.

---

## Relacao com o Calendario do Joao

```
+---------------------------------------------------------------+
|                     PLANEJAMENTO (Mai-Jun)                     |
|                                                                |
|  Grid de talhoes -> Alessandro define cultura x talhao         |
|  -> Sistema gera TALHAO_SAFRA (status: rascunho)              |
|  -> Revisao Lucas -> Aprovacao Claudio                         |
|  -> Sistema gera SAFRA_ACOES via templates                     |
|                                                                |
+-------------------------------+-------------------------------+
                                |
                                v
+---------------------------------------------------------------+
|              CALENDARIO GANTT (Joao)                           |
|                                                                |
|  SafraCalendar.tsx renderiza:                                  |
|  - TalhaoRow com culturas alocadas (TALHAO_SAFRA)             |
|  - OperationBar com operacoes (OPERACAO_CAMPO)                |
|  - AcaoBar com acoes planejadas (SAFRA_ACOES)                 |
|  - Status cycle: rascunho -> aprovado -> plantado -> colhido  |
|                                                                |
+-------------------------------+-------------------------------+
                                |
                                v
+---------------------------------------------------------------+
|                EXECUCAO (Set-Nov em diante)                    |
|  Tiago/operadores confirmam operacoes no campo                |
|  -> OPERACAO_CAMPO com dados reais                            |
|  -> Status avanca no lifecycle                                |
+---------------------------------------------------------------+
```

---

## Templates Seed por Cultura

### Soja (9 operacoes)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | dessecacao_pre_plantio | Dessecacao | preparo | -15 | 2 |
| 2 | plantio | Plantio | plantio | 0 | 5 |
| 3 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +10 | 1 |
| 4 | pulverizacao_inseticida | 1o Inseticida | manejo | +25 | 1 |
| 5 | pulverizacao_fungicida | 1o Fungicida | manejo | +35 | 1 |
| 6 | pulverizacao_fungicida | 2o Fungicida | manejo | +50 | 1 |
| 7 | pulverizacao_inseticida | 2o Inseticida | manejo | +65 | 1 |
| 8 | dessecacao_pre_colheita | Dessecacao pre-colheita | colheita | +110 | 1 |
| 9 | colheita | Colheita | colheita | +120 | 10 |

### Milho (7 operacoes)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | dessecacao_pre_plantio | Dessecacao | preparo | -15 | 2 |
| 2 | plantio | Plantio | plantio | 0 | 5 |
| 3 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +10 | 1 |
| 4 | adubacao_cobertura | Adubacao cobertura | manejo | +20 | 1 |
| 5 | pulverizacao_inseticida | 1o Inseticida | manejo | +30 | 1 |
| 6 | pulverizacao_fungicida | 1o Fungicida | manejo | +45 | 1 |
| 7 | colheita | Colheita | colheita | +150 | 10 |

### Feijao (10 operacoes)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | aracao | Preparo de solo | preparo | -30 | 3 |
| 2 | dessecacao_pre_plantio | Dessecacao | preparo | -15 | 2 |
| 3 | plantio | Plantio | plantio | 0 | 3 |
| 4 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +7 | 1 |
| 5 | pulverizacao_inseticida | 1o Inseticida | manejo | +14 | 1 |
| 6 | pulverizacao_fungicida | 1o Fungicida | manejo | +21 | 1 |
| 7 | pulverizacao_fungicida | 2o Fungicida | manejo | +35 | 1 |
| 8 | pulverizacao_inseticida | 2o Inseticida | manejo | +49 | 1 |
| 9 | pulverizacao_fungicida | 3o Fungicida | manejo | +63 | 1 |
| 10 | colheita | Colheita | colheita | +90 | 7 |

### Trigo (7 operacoes)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | dessecacao_pre_plantio | Dessecacao | preparo | -10 | 2 |
| 2 | plantio | Plantio | plantio | 0 | 5 |
| 3 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +15 | 1 |
| 4 | pulverizacao_fungicida | 1o Fungicida | manejo | +30 | 1 |
| 5 | pulverizacao_fungicida | 2o Fungicida | manejo | +50 | 1 |
| 6 | pulverizacao_inseticida | 1o Inseticida | manejo | +40 | 1 |
| 7 | colheita | Colheita | colheita | +130 | 10 |

### Cevada (6 operacoes)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | dessecacao_pre_plantio | Dessecacao | preparo | -10 | 2 |
| 2 | plantio | Plantio | plantio | 0 | 5 |
| 3 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +15 | 1 |
| 4 | pulverizacao_fungicida | 1o Fungicida | manejo | +30 | 1 |
| 5 | pulverizacao_fungicida | 2o Fungicida | manejo | +50 | 1 |
| 6 | colheita | Colheita | colheita | +120 | 10 |

### Aveia Preta (3 operacoes — cobertura)

| # | Tipo | Nome | Fase | Offset | Dias |
|---|------|------|------|--------|------|
| 1 | plantio | Plantio | plantio | 0 | 3 |
| 2 | pulverizacao_herbicida | Herbicida pos-emergente | manejo | +15 | 1 |
| 3 | dessecacao_pre_plantio | Dessecacao (rolagem) | manejo | +90 | 2 |

---

## Metricas

| Metrica | Antes | Depois |
|---------|-------|--------|
| Tabelas | 63 | 66 |
| ENUMs | 46 | 47 |
| Modelos Prisma | 63 | 66 |
| Enums Prisma | 44 | 45 |

---

*Criado: 2026-03-06 | DeepWork AI Flows*
