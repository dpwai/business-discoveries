# Doc 32 — Lifecycle TALHAO_SAFRA (Do Planejamento a Colheita)

> Documento interno DeepWork AI Flows | Projeto SOAL
> Criado: 2026-03-08 | Reescrito: 2026-03-08
> Prerequisito: PLANEJAMENTO_SAFRA_PROCESS_FLOW.md (6 etapas)
> Publico: Joao (CTO — construir telas) + Rodrigo (produto — validar specs)

---

## Contexto

TALHAO_SAFRA e a entidade central do SOAL — 90% dos relatorios passam por ela. Este documento e o **spec completo do lifecycle no app**: do nascimento (planejamento de safra) ate o fechamento (colheita + calculo de produtividade).

**Ciclo completo:**

```
Planejamento aprovado -> TALHAO_SAFRA nasce
  -> SAFRA_ACAO auto-geradas (calendario)
    -> OPERACAO_CAMPO registradas no campo (Tiago/operadores)
      -> TICKET_BALANCA na colheita (Josmar/Vanessa)
        -> fn_fechar_colheita encerra o ciclo
```

**Safras alvo:**
- **25/26** — retroativo com dados existentes (50 plantios + 883 tickets colheita)
- **26/27** — template para workflow digital completo

**Decisao arquitetural:** SAFRA_ACAO e OPERACAO_CAMPO sao entidades **separadas**.

| Entidade | Papel | Quando nasce | Quem preenche |
|----------|-------|-------------|---------------|
| **SAFRA_ACAO** | Calendario planejado (feed Gantt) | Auto-gerada dos templates quando plano e aprovado | Sistema |
| **OPERACAO_CAMPO** | Registro real da execucao (maquina, operador, horimetro) | Tiago confirma no campo | Tiago/operador |

**Link:** `safra_acao_id` FK em OPERACAO_CAMPO vincula execucao real a acao planejada.

---

## 1. State Machine (9 estados)

### 1.1 Diagrama

```
                        +----------+
                        | rascunho |
                        +----+-----+
                             | Alessandro marca "pronto pra revisao"
                             v
                        +------------+
                        | em_revisao |
                        +----+-------+
                             | Claudio aprova
                             v
                        +----------+
                        | aprovado |
                        +----+-----+
                             | 1a SAFRA_ACAO iniciada (dessecacao/preparo solo)
                             v
                        +------------+
                        | preparando |
                        +----+-------+
                             | OPERACAO_CAMPO tipo='plantio' concluida
                             v
                        +----------+
                        | plantado |
                        +----+-----+
                             | 1a operacao manejo confirmada OU +N dias
                             v
                   +---------------------+
                   | em_desenvolvimento  |
                   +--------+------------+
                            | 1o ticket_balanca para este talhao_safra
                            v
                       +----------+
                       | colhendo |
                       +----+-----+
                            | ultimo ticket + fechamento
                            v
                       +---------+
                       | colhido |
                       +---------+

  Qualquer estado pre-plantado --> +------------+
                                   | cancelado  |
                                   +------------+
```

### 1.2 Tabela de Transicoes

| De | Para | Trigger | Quem | Dados capturados |
|----|------|---------|------|------------------|
| `rascunho` | `em_revisao` | Alessandro marca "pronto pra revisao" | Alessandro | snapshot v1 |
| `em_revisao` | `aprovado` | Claudio aprova plano | Claudio | `aprovado_por`, `data_aprovacao`, snapshot v3 |
| `aprovado` | `preparando` | Primeira SAFRA_ACAO iniciada (preparo solo/dessecacao) | Sistema (auto) | `safra_acao.data_inicio` |
| `preparando` | `plantado` | OPERACAO_CAMPO tipo=`plantio` concluida | Tiago confirma | `data_plantio`, `maquina_id`, `operador_id` |
| `plantado` | `em_desenvolvimento` | Auto apos primeira operacao manejo confirmada | Sistema | — |
| `em_desenvolvimento` | `colhendo` | Primeiro `ticket_balanca` para este `talhao_safra_id` | Josmar/Vanessa | `data_pesagem` |
| `colhendo` | `colhido` | Ultimo ticket + fechamento manual ou auto (fn_fechar_colheita) | Tiago ou Sistema | `data_colheita`, `produtividade_sc_ha` (calculada) |
| qualquer pre-plantado | `cancelado` | Cancelamento manual | Claudio/Alessandro | `observacoes` (motivo) |

**Regras de transicao:**
- Nao e possivel pular estados (ex: `rascunho` -> `colhido`)
- `cancelado` e estado terminal — nao volta
- `colhido` e estado terminal — dados de producao ja consolidados
- Retroativo 25/26: maioria vai direto para `colhido` (dados historicos)

---

## 2. Spec por Etapa do Lifecycle

### 2.1 Aprovacao -> Nascimento TALHAO_SAFRA

**Trigger:** Claudio aprova plano (Etapa 5 do PLANEJAMENTO_SAFRA_PROCESS_FLOW.md)
**Referencia completa:** PLANEJAMENTO_SAFRA_PROCESS_FLOW.md etapas 1-6

**Dados capturados no planejamento (pre-existentes no grid):**

| Campo | Tipo DDL | Quem preenche | Etapa | Notas |
|-------|----------|---------------|-------|-------|
| safra_id | UUID FK | Sistema | Etapa 1 | Safra ativa criada pelo admin |
| talhao_id | UUID FK | Alessandro | Etapa 3 | Dropdown por fazenda (71 talhoes) |
| cultura_id | UUID FK | Alessandro | Etapa 3 | Dropdown filtrado por grupo relevante |
| epoca | ENUM | Alessandro | Etapa 3 | safra / safrinha / terceira_safra |
| gleba | VARCHAR(100) | Alessandro | Etapa 3 | Sub-area do talhao (ex: HERMATRIA, BANACK) |
| cultivar | VARCHAR(200) | Alessandro | Etapa 3 | Texto livre (ex: BMX 56IX58, AS 3595 I2X) |
| area_plantada_ha | NUMERIC(10,2) | Sistema + override | Etapa 3 | Default: area_ha do talhao. Override manual se parcial |
| meta_produtividade_sc_ha | NUMERIC(10,2) | Alessandro | Etapa 3 | Meta em sacas/ha (opcional) |
| origem_semente | VARCHAR(200) | Alessandro | Etapa 3 | Castrolanda / Fazenda / FSI / outro |
| data_plantio_prevista | DATE | Sistema + override | Etapa 3 | Default regional (CALENDARIO_AGRICOLA). Alessandro ajusta |
| observacoes | TEXT | Alessandro/Lucas | Etapa 3-4 | Campo livre |
| atribuido_por | VARCHAR(200) | Sistema | Etapa 3 | Username de quem preencheu |
| aprovado_por | VARCHAR(200) | Sistema | Etapa 5 | Username de Claudio |
| data_aprovacao | DATE | Sistema | Etapa 5 | Data da aprovacao |
| status_planejamento | ENUM | Sistema | Etapa 5 | Setado para 'aprovado' |

**Efeito colateral da aprovacao:**
1. Todos TALHAO_SAFRA do plano transitam de `em_revisao` -> `aprovado`
2. Sistema executa `fn_gerar_safra_acoes()` para cada TALHAO_SAFRA aprovado
3. Snapshot v3 (final) salvo em `plano_safra_snapshots`

**UX no app (tela PlanejamentoSafra):**
- Grid editavel com colunas: Talhao (Fazenda) | Area | Safra anterior (read-only) | Cultura | Cultivar | Data plantio | Obs
- Indicador em tempo real: % gramineas (barra de progresso, meta 25-30%)
- Timeline preview: ao selecionar cultura, mostra operacoes esperadas do template
- Botao "Marcar pronto pra revisao" (Alessandro) -> "Aprovar" (Claudio)

---

### 2.2 SAFRA_ACAO — Auto-geracao e Calendario

**Trigger:** `fn_gerar_safra_acoes(talhao_safra_id)` executada apos aprovacao

**Campos gerados automaticamente:**

| Campo | Valor | Origem |
|-------|-------|--------|
| organization_id | Herdado do talhao_safra | Auto |
| talhao_safra_id | FK para o talhao_safra aprovado | Auto |
| safra_id | Herdado do talhao_safra | Auto |
| tipo | `template.tipo_operacao` | Template da cultura |
| titulo | `template.nome_operacao` | Template da cultura |
| data_inicio | `data_plantio_prevista + dias_offset_inicio` | Calculado |
| data_fim | `data_inicio + duracao_dias - 1` | Calculado |
| status | `'planejada'` | Default |
| area_ha | `talhao_safra.area_plantada_ha` | Herdado |
| template_id | FK para template_cultura_operacoes | Auto |
| gerado_automaticamente | `TRUE` | Default |

**Templates prontos (42 operacoes, 6 culturas):**

| Cultura | Operacoes | Ciclo total (dias) |
|---------|-----------|-------------------|
| Soja | 9 (dessecacao -> colheita) | 135 |
| Milho | 7 (dessecacao -> colheita) | 165 |
| Feijao | 10 (preparo solo -> colheita) | 120 |
| Trigo | 7 (dessecacao -> colheita) | 140 |
| Cevada | 6 (dessecacao -> colheita) | 130 |
| Aveia Preta | 3 (plantio -> dessecacao/rolagem) | 92 |

**Gap:** Ervilha forrageira (nova cultura 26/27) — sem template definido. Pedir Alessandro.

**UX no app (tela SafraCalendar.tsx):**
- Calendario Gantt horizontal: eixo Y = talhoes (agrupados por fazenda), eixo X = meses
- Cada SAFRA_ACAO renderizada como barra colorida por tipo de operacao
- Cores: preparo=cinza, plantio=verde, manejo=amarelo, colheita=laranja
- Interacao: arrastar barra para ajustar datas manualmente
- Botao "+" para adicionar acao extra (nao gerada pelo template)
- Status visual: planejada (borda pontilhada), em_andamento (borda solida), concluida (preenchida)
- Click na barra -> detalhes da acao + link para OPERACAO_CAMPO vinculada (se existir)

---

### 2.3 OPERACAO_CAMPO — Registro de Execucao no Campo

**ESTA E A SECAO PRINCIPAL DO DOCUMENTO.**

**Quem:** Tiago (gerente maquinario) ou operador via mobile
**Quando:** No momento da execucao ou no fim do dia
**Como:** Formulario mobile (3 toques max, botoes grandes, offline-first)

#### 2.3.1 Campos do Formulario Mobile

| # | Campo DDL | Tipo input | Obrigatorio | Pre-populado de | Validacao | Notas |
|---|-----------|-----------|-------------|-----------------|-----------|-------|
| 1 | `talhao_safra_id` | Dropdown (talhao + cultura) | Sim | SAFRA_ACAO selecionada no Gantt | Apenas talhao_safras da safra ativa com status IN ('aprovado','preparando','plantado','em_desenvolvimento') | Label mostra: "LAGARTO - Soja" |
| 2 | `safra_acao_id` | Dropdown (operacoes planejadas) | Nao | Se veio do Gantt: acao clicada | Apenas safra_acoes pendentes deste talhao_safra. NULL se operacao nao planejada | Vincula execucao ao plano |
| 3 | `tipo` | Auto-preenchido / Dropdown | Sim | Se safra_acao_id preenchido: `safra_acao.tipo`. Senao: dropdown livre | ENUM tipo_operacao_campo (20+ valores) | Locked se veio de safra_acao |
| 4 | `maquina_id` | Dropdown com busca | Sim | Ultima maquina usada neste tipo de operacao | Apenas maquinas com status='active'. Filtrar por tipo relevante (TRATOR, PLANTADEIRA, COLHEDORA, PULVERIZADOR) | 57 maquinas no cadastro |
| 5 | `operador_id` | Dropdown | Sim | Operador logado (se for operador) OU ultimo operador usado | Apenas operadores ativos | 15 operadores curados |
| 6 | `data_inicio` | Date picker | Sim | Hoje (default) | <= hoje | Formato DD/MM/AAAA |
| 7 | `data_fim` | Date picker | Nao | NULL (default: mesmo dia) | >= data_inicio | Para operacoes multi-dia (talhoes grandes) |
| 8 | `area_trabalhada_ha` | Numerico | Nao | `talhao_safra.area_plantada_ha` | > 0, <= area_ha do talhao | Pre-populado, operador ajusta se parcial |
| 9 | `horimetro_inicio` | Numerico | Nao | Ultimo `horimetro_fim` desta maquina | >= ultimo horimetro_fim desta maquina | Validacao sequencial por maquina |
| 10 | `horimetro_fim` | Numerico | Nao | NULL | > horimetro_inicio (se ambos preenchidos) | CHK constraint no DDL |
| 11 | `combustivel_litros` | Numerico | Nao | NULL | > 0 (se preenchido) | Complemento do Vestro (auto) |
| 12 | `implemento_codigo` | Dropdown | Nao | NULL | Implementos com status='ativo' (126 no cadastro) | Opcional — util para custeio |
| 13 | `fazenda_id` | Auto (hidden) | Sim | Derivado: talhao_safra -> talhao -> fazenda | — | DENORM (3 hops). Operador nao ve |
| 14 | `observacoes` | Texto livre / Audio | Nao | NULL | — | Audio transcrito automaticamente |

#### 2.3.2 Subformularios por Tipo de Operacao

Quando o operador seleciona o tipo, o formulario expande com campos especificos da entidade detalhe. Todos os campos de detalhe sao **opcionais**.

##### Plantio -> PLANTIO_DETALHE

| Campo DDL | Tipo input | Pre-populado de | Validacao | Notas |
|-----------|-----------|-----------------|-----------|-------|
| `variedade` | Texto | `talhao_safra.cultivar` | — | Pre-populado do planejamento |
| `populacao_sementes_ha` | Numerico | NULL | Faixa tipica: soja 200-400k, milho 50-90k | Na apostila do Alessandro |
| `espacamento_cm` | Numerico | NULL | Faixa tipica: soja 45-50, milho 70-80 | Padrao por cultura, raramente varia |
| `profundidade_cm` | Numerico | NULL | 1-15 cm | Operador informa |
| `tratamento_sementes` | Texto | NULL | — | Do receituario do Alessandro |
| `adubo_base` | Texto / Dropdown insumo | NULL | FK produto_insumo tipo FERTILIZANTE | — |
| `quantidade_adubo_kg_ha` | Numerico | NULL | > 0 | — |
| `umidade_solo_percent` | Numerico | NULL | 0-100% | Raramente medido — P3 |

##### Colheita -> COLHEITA_DETALHE

| Campo DDL | Tipo input | Pre-populado de | Validacao | Notas |
|-----------|-----------|-----------------|-----------|-------|
| `produtividade_kg_ha` | Numerico | NULL (calculado pos-pesagem) | >= 0 | Estimativa do operador |
| `produtividade_sacas_ha` | Auto-calculado | `kg_ha / 60` | >= 0 | KPI central |
| `umidade_media_percent` | Numerico | NULL | 0-100% | Estimativa no campo |
| `perdas_estimadas_percent` | Numerico | NULL | 0-100% | Visual do operador |
| `velocidade_media_kmh` | Numerico | NULL | > 0 | Da colhedora |
| `condicoes_climaticas` | JSONB / Form multi-campo | NULL | — | Tempo, temperatura, vento |

##### Pulverizacao -> PULVERIZACAO_DETALHE

| Campo DDL | Tipo input | Pre-populado de | Validacao | Notas |
|-----------|-----------|-----------------|-----------|-------|
| `alvo` | Texto | `safra_acao.titulo` (se existir) | — | Ex: "lagarta", "ferrugem", "erva daninha" |
| `dose_ha` | Numerico | NULL | > 0 | Dose do produto principal |
| `volume_calda_ha` | Numerico | NULL | > 0 (L/ha) | Volume de calda |
| `vazao_bico` | Numerico | NULL | > 0 | Calibracao do equipamento |
| `pressao_bar` | Numerico | NULL | > 0 | — |
| `temperatura_c` | Numerico | NULL | -5 a 50 | Condicao climatica |
| `umidade_relativa` | Numerico | NULL | 0-100% | — |
| `velocidade_vento_kmh` | Numerico | NULL | >= 0 | Limite legal para aplicacao |

**Nota:** Produto aplicado e registrado via APLICACAO_INSUMO (Doc 16), nao no detalhe de pulverizacao. O detalhe captura apenas dados **tecnicos** da operacao.

##### Outros tipos (dessecacao, adubacao, aracao, gradagem, etc.)

Nao tem subformulario. Campos de OPERACAO_CAMPO sao suficientes.

#### 2.3.3 Fluxo UX Mobile (3 Toques)

**Cenario 1 — Via Calendario Gantt (fluxo principal):**

```
Tela 0: SafraCalendar -> Tiago ve barras de operacoes planejadas para hoje/semana
  |
  | Toque 1: tap na barra da operacao planejada
  v
Tela 1: Form pre-preenchido
  - Talhao: LAGARTO - Soja (locked, veio do Gantt)
  - Tipo: Plantio (locked, veio da safra_acao)
  - Data: Hoje (default)
  - Maquina: [dropdown - ultimo usado]
  - Operador: [dropdown - logado]
  |
  | Toque 2: selecionar maquina (se diferente do default)
  v
Tela 1 (continuacao): campos opcionais colapsados
  - [+] Detalhe Plantio (expandir para variedade, populacao, etc.)
  - [+] Horimetro
  - [+] Observacoes / Audio
  |
  | Toque 3: SALVAR (botao verde grande, 48px+, posicao fixa no rodape)
  v
Feedback: "Operacao registrada" (toast verde) -> volta ao calendario
```

**Cenario 2 — Operacao nao planejada (ad-hoc):**

```
Tela 0: Menu principal -> "Nova Operacao"
  |
  | Toque 1: selecionar talhao + cultura (dropdown combinado)
  v
Tela 1: Form
  - Tipo: [dropdown livre - todos os tipos]
  - Maquina: [dropdown]
  - Operador: [dropdown]
  - Data: Hoje
  |
  | Toque 2-3: preencher campos + SALVAR
  v
Feedback: "Operacao registrada"
```

**Cenario 3 — Registro em lote (Tiago no fim do dia):**

```
Tela 0: "Registrar Operacoes do Dia"
  |
  v
Lista: talhoes com operacoes planejadas para hoje
  - [x] LAGARTO - Plantio (pre-marcado se Tiago ja confirmou)
  - [ ] MASSACRE - Dessecacao
  - [ ] ARACAS - Plantio
  |
  | Marcar concluidos + selecionar maquina/operador global
  | SALVAR TODOS
  v
Sistema cria N operacoes_campo de uma vez
```

#### 2.3.4 Audio Input

**Para quem:** 2 operadores com limitacao leitura/escrita + qualquer operador que prefira

**Formato de entrada:** Fala livre em portugues
- Exemplo: "Plantei o Lagarto hoje com a New Holland"
- Exemplo: "Pulverizei o Massacre e o Aracas com o Jacto, inseticida"

**Processamento:**
1. STT (Speech-to-Text) transcreve audio
2. NLP extrai entidades: talhao (fuzzy match), tipo operacao, maquina (fuzzy match), data
3. Sistema pre-preenche formulario com dados extraidos
4. **Tela de confirmacao:** operador ve campos preenchidos + botao "CONFIRMAR" ou "CORRIGIR"
5. Se confianca < threshold: alerta visual nos campos incertos

**Fallback:** Audio salvo como blob no campo `observacoes`. Alessandro ou Tiago transcreve depois.

**Desafio tecnico:** Ruido de maquinario no campo. Testar modelos STT com vocabulario agricola (nomes de talhoes, cultivares, produtos).

#### 2.3.5 Offline Strategy

| Aspecto | Implementacao |
|---------|---------------|
| Storage local | SQLite no dispositivo (React Native / PWA com IndexedDB) |
| Status de sync | Campo `sync_status`: `pendente_sync`, `sincronizado`, `erro_sync` |
| Indicador visual | Bolinha no header: verde (online + sync) / amarela (offline ou pendente) / vermelha (erro) |
| Trigger de sync | Automatico quando detecta conexao (Starlink ou celular) |
| Conflito | Ultimo-escritor-vence (operacoes de campo sao unidirecionais — nao ha edicao concorrente) |
| Dados offline | Cache de: talhao_safras ativos, maquinas, operadores, safra_acoes pendentes |
| Limite | Ate 100 operacoes pendentes de sync (alerta apos 50) |

**Contexto:** Starlink em 100% pulverizadores, ~50% plantadeiras, carros Alessandro e Tiago. 100% funcionarios tem smartphone.

#### 2.3.6 Efeitos Colaterais

Quando OPERACAO_CAMPO e salva, o sistema executa automaticamente:

| Condicao | Efeito | Entidade afetada |
|----------|--------|------------------|
| `safra_acao_id` preenchido | Atualiza `safra_acoes.status` para `'concluida'` | SAFRA_ACAO |
| Tipo = `plantio` e status = `concluida` | Seta `talhao_safras.data_plantio = data_inicio` | TALHAO_SAFRA |
| Tipo = `plantio` e status = `concluida` | Transiciona `talhao_safras.status_planejamento` para `'plantado'` | TALHAO_SAFRA |
| Primeiro `safra_acao` concluida (preparo/dessecacao) | Transiciona `talhao_safras.status_planejamento` para `'preparando'` | TALHAO_SAFRA |
| Primeira operacao manejo confirmada pos-plantio | Transiciona `talhao_safras.status_planejamento` para `'em_desenvolvimento'` | TALHAO_SAFRA |

---

### 2.4 TICKET_BALANCA — Pesagem na UBG

**Quem:** Josmar (analise qualidade) e Vanessa (pesagem + digitacao)
**Quando:** No momento da chegada do caminhao na UBG
**Hoje:** Caderno manual -> planilha a cada 15 dias. **Digitalizar = eliminar caderno.**
**Referencia tecnica:** I.N. 029/2011 (descontos umidade/impureza), simulador em `soal-secagem-playground.html`

#### 2.4.1 Campos do Formulario Mobile/Tablet

**Tela 1 — Identificacao (Josmar seleciona)**

| # | Campo DDL | Tipo input | Obrigatorio | Pre-populado de | Validacao | Notas |
|---|-----------|-----------|-------------|-----------------|-----------|-------|
| 1 | `safra_id` | Auto (hidden) | Sim | Safra ativa no sistema | — | Operador nao ve |
| 2 | `cultura_id` | Dropdown grande | Sim | NULL (Josmar seleciona) | Apenas culturas com talhao_safra ativo na safra | Botoes grandes: SOJA, MILHO, FEIJAO, TRIGO, CEVADA, AVEIA |
| 3 | `talhao_safra_id` | Dropdown filtrado | Sim | Filtrado pela cultura selecionada | Apenas talhao_safras da safra + cultura selecionada | Label: "LAGARTO (117 ha)" |
| 4 | `talhao_nome` | Auto (read-only) | Sim | `talhao_safra -> talhao.nome` | — | Exibido para confirmacao |
| 5 | `gleba` | Auto (read-only) | Nao | `talhao_safra.gleba` | — | Ex: HERMATRIA, BANACK, URUGUAI |
| 6 | `tipo` | Dropdown | Sim | `'entrada_producao'` (default) | ENUM tipo_ticket_balanca | Opcoes: entrada_producao, saida_venda, transferencia, pesagem_publica |
| 7 | `silo_destino_id` | Dropdown | Nao | Ultimo silo usado para esta cultura | Silos ativos (8 silos, 10.760t total) | S1-S6 + SP + SE |

**Tela 2 — Pesagem (Vanessa digita)**

| # | Campo DDL | Tipo input | Obrigatorio | Pre-populado de | Validacao | Notas |
|---|-----------|-----------|-------------|-----------------|-----------|-------|
| 8 | `data_pesagem` | Date picker | Sim | Hoje | — | — |
| 9 | `hora_pesagem` | Time picker | Nao | Agora | — | — |
| 10 | `motorista` | Texto com autocomplete | Nao | Autocomplete do historico | — | Fuzzy match nos ultimos 30 dias |
| 11 | `placa_veiculo` | Texto com autocomplete | Nao | Autocomplete do historico | Formato placa BR: AAA-0000 ou AAA0A00 (Mercosul) | — |
| 12 | `peso_bruto_kg` | **Numerico grande** | Sim | NULL | > 0 | **Teclado numerico, fonte 24px+, botao 48px+** |
| 13 | `peso_tara_kg` | **Numerico grande** | Sim | NULL | > 0, < peso_bruto_kg | **Mesmo estilo grande** |
| 14 | `peso_liquido_kg` | **Auto-calculado** | Sim | `peso_bruto_kg - peso_tara_kg` | **Read-only** | Exibido em destaque (fonte 28px, cor verde) |

**Tela 3 — Qualidade (Josmar preenche quando tem)**

| # | Campo DDL | Tipo input | Obrigatorio | Pre-populado de | Validacao | Notas |
|---|-----------|-----------|-------------|-----------------|-----------|-------|
| 15 | `umidade_pct` | Numerico | Nao | NULL | 0-100% (tipico: 10-25%) | Determinante para desconto e secagem |
| 16 | `impureza_g` | Numerico | Nao | NULL | >= 0 | Amostra padrao |
| 17 | `ardidos_g` | Numerico | Nao | NULL | >= 0 | — |
| 18 | `avariado_g` | Numerico | Nao | NULL | >= 0 | — |
| 19 | `verdes_g` | Numerico | Nao | NULL | >= 0 | — |
| 20 | `quebrado_g` | Numerico | Nao | NULL | >= 0 | — |
| 21 | `desconto_kg` | Auto-calculado | Nao | Formula I.N. 029/2011 | **Read-only** | Calculado a partir de umidade + impureza |
| 22 | `peso_final_kg` | Auto-calculado | Sim | `peso_liquido_kg - desconto_kg` | **Read-only** | Peso real armazenado |
| 23 | `variedade` | Texto | Nao | `talhao_safra.cultivar` | — | Pre-populado do planejamento |
| 24 | `destino` | Dropdown | Nao | `'armazenagem'` (default) | Opcoes: armazenagem, venda_direta, transferencia | — |
| 25 | `flag_semente` | Toggle | Nao | FALSE | — | SOAL produz sementes certificadas para Castrolanda |
| 26 | `observacoes` | Texto livre | Nao | NULL | — | — |

**Campos auto-preenchidos (hidden):**

| Campo DDL | Valor | Notas |
|-----------|-------|-------|
| `organization_id` | Org do usuario logado | Auto |
| `numero_ticket` | Sequencial auto-incrementado por safra | Sistema gera |
| `talhao_aba` | Derivado do talhao_safra | Compatibilidade com planilhas historicas |
| `source_file` | `'app'` | Distingue de dados importados (CSV) |

#### 2.4.2 Fluxo UX Josmar (Operator POV)

**Principios:** Funciona com mao suja. Botoes 48px+. Teclado numerico. Sol no display. 3 telas max.

```
+--------------------------------------------------+
|  TICKET BALANCA - Nova Pesagem                   |
+--------------------------------------------------+
|                                                  |
|  Cultura:                                        |
|  +--------+ +--------+ +--------+                |
|  | SOJA   | | MILHO  | | FEIJAO |                |
|  +--------+ +--------+ +--------+                |
|  +--------+ +--------+ +--------+                |
|  | TRIGO  | | CEVADA | | AVEIA  |                |
|  +--------+ +--------+ +--------+                |
|                                                  |
|  Talhao: (aparece apos selecionar cultura)       |
|  +----------------------------------------------+|
|  | LAGARTO (117 ha) - Santana           [v]     ||
|  +----------------------------------------------+|
|                                                  |
|              [ PROXIMO >>> ]                     |
+--------------------------------------------------+

           |  Toque 1: Cultura
           |  Toque 2: Talhao
           v

+--------------------------------------------------+
|  PESAGEM - LAGARTO / Soja                        |
+--------------------------------------------------+
|                                                  |
|  Peso Bruto (kg):                                |
|  +----------------------------------------------+|
|  |                              28.450          ||
|  +----------------------------------------------+|
|                                                  |
|  Peso Tara (kg):                                 |
|  +----------------------------------------------+|
|  |                              12.300          ||
|  +----------------------------------------------+|
|                                                  |
|  +--------------------- +-----------------------+|
|  | PESO LIQUIDO:       | 16.150 kg             ||
|  +---------------------+-----------------------+|
|                                                  |
|              [ PROXIMO >>> ]                     |
+--------------------------------------------------+

           |  Digita 2 numeros
           v

+--------------------------------------------------+
|  QUALIDADE (opcional)                            |
+--------------------------------------------------+
|                                                  |
|  Umidade (%): [____]  Impureza (g): [____]       |
|  Ardidos (g): [____]  Avariado (g): [____]       |
|  Verdes (g):  [____]  Quebrado (g): [____]       |
|                                                  |
|  Desconto: 0 kg    Peso Final: 16.150 kg        |
|                                                  |
|  +----------------------------------------------+|
|  |          *** SALVAR TICKET ***                ||
|  |          (botao verde, 60px altura)           ||
|  +----------------------------------------------+|
+--------------------------------------------------+
```

**Atalhos de produtividade:**
- Ultimo motorista/placa auto-sugerido
- Se talhao tem uma unica gleba, pula selecao de gleba
- Tela de qualidade e **opcional** — pode salvar direto da tela de pesagem (Josmar preenche qualidade depois)
- Historico: lista ultimos 10 tickets como referencia rapida

#### 2.4.3 Efeitos Colaterais

Quando TICKET_BALANCA e salvo:

| Condicao | Efeito | Entidade afetada |
|----------|--------|------------------|
| Primeiro ticket deste `talhao_safra_id` | Transiciona `status_planejamento` para `'colhendo'` | TALHAO_SAFRA |
| `talhao_safra_id` preenchido | Vincula pesagem ao planejamento — visivel no dashboard de produtividade | TALHAO_SAFRA (leitura) |
| `silo_destino_id` preenchido | Incrementa estoque virtual do silo (se sistema de estoque ativo) | ESTOQUE_SILO (futuro) |

#### 2.4.4 Comissao Josmar (regra de negocio)

**Regra:** 0,01% da receita anual + R$2,50/pesagem externa.
**Implementacao:** Query automatica no fim do ano fiscal (30/jun).
**Fonte:** COUNT de tickets tipo `'pesagem_publica'` * 2.50 + SUM(receita_anual) * 0.0001.
**Hoje:** Calculada manualmente. **Futuro:** Trigger ou relatorio automatico.

---

### 2.5 Fechamento de Colheita

**Trigger:** Manual (Tiago clica "Fechar Colheita" no dashboard) ou automatico (configurable: N dias sem novo ticket para o talhao_safra).

**Funcao:** `fn_fechar_colheita(talhao_safra_id)`

**O que faz:**
1. Agrega todos tickets do talhao_safra: COUNT, SUM(peso_final_kg), MIN/MAX(data_pesagem)
2. Calcula produtividade: `SUM(peso_final_kg) / 60 / area_plantada_ha` = sacas/ha
3. Atualiza TALHAO_SAFRA:
   - `status_planejamento = 'colhido'`
   - `data_colheita = MAX(data_pesagem)`
   - `produtividade_sc_ha = valor calculado`
4. Retorna resumo: total_tickets, peso_total_kg, produtividade_sc_ha, datas

**UX no app (tela Dashboard Colheita):**

```
+--------------------------------------------------+
|  COLHEITA - Safra 25/26                          |
+--------------------------------------------------+
|                                                  |
|  LAGARTO - Soja                                  |
|  Area: 117 ha | Meta: 65 sc/ha                   |
|  Tickets: 23 | Peso total: 421.800 kg            |
|  Produtividade: 60,1 sc/ha (92% da meta)         |
|  Status: COLHENDO                                |
|  [FECHAR COLHEITA]                               |
|                                                  |
|  MASSACRE - Milho                                |
|  Area: 85 ha | Meta: 180 sc/ha                   |
|  Tickets: 18 | Peso total: 918.000 kg            |
|  Produtividade: 180,0 sc/ha (100% da meta)       |
|  Status: COLHIDO (fechado 15/03/2026)            |
|                                                  |
+--------------------------------------------------+
```

**Card de produtividade:** Barra de progresso visual (real vs meta). Verde se >= 90% meta, amarelo 70-90%, vermelho < 70%.

---

## 3. Fluxo de Dados entre Entidades

### 3.1 Diagrama Completo

```
+------------------------------------------------------------------+
|                    PLANEJAMENTO (Mai-Jun)                          |
|                                                                    |
|  Alessandro + Lucas + Claudio                                      |
|  Grid de talhoes -> cultura x cultivar x area                      |
|                                                                    |
|  Output: TALHAO_SAFRA (status=aprovado)                            |
|          + plano_safra_snapshots (v1, v2, v3)                      |
+-------------------------------+----------------------------------+
                                |
                                | fn_gerar_safra_acoes()
                                v
+------------------------------------------------------------------+
|                CALENDARIO GANTT (app)                              |
|                                                                    |
|  SAFRA_ACAO (N acoes planejadas por talhao, datas calculadas)      |
|  Renderizado em SafraCalendar.tsx                                  |
|  Barras por tipo de operacao, arrastavel                           |
+-------------------------------+----------------------------------+
                                |
                                | Tiago confirma no campo (mobile)
                                v
+------------------------------------------------------------------+
|                EXECUCAO NO CAMPO (Set-Mai)                         |
|                                                                    |
|  OPERACAO_CAMPO (execucao real, safra_acao_id FK)                  |
|    + PLANTIO_DETALHE (se tipo=plantio)                             |
|    + COLHEITA_DETALHE (se tipo=colheita)                           |
|    + PULVERIZACAO_DETALHE (se tipo=pulverizacao)                   |
|    + APLICACAO_INSUMO (produtos usados — Doc 16)                   |
|                                                                    |
|  Efeito: status TALHAO_SAFRA avanca automaticamente               |
|  Efeito: status SAFRA_ACAO -> 'concluida'                         |
+-------------------------------+----------------------------------+
                                |
                                | Colheita chega na UBG
                                v
+------------------------------------------------------------------+
|                PESAGEM NA UBG (Dez-Jun)                            |
|                                                                    |
|  TICKET_BALANCA (pesagem real, talhao_safra_id FK)                 |
|  Josmar: analise qualidade                                         |
|  Vanessa: pesagem + digitacao                                      |
|                                                                    |
|  Efeito: 1o ticket -> status 'colhendo'                            |
+-------------------------------+----------------------------------+
                                |
                                | fn_fechar_colheita()
                                v
+------------------------------------------------------------------+
|                FECHAMENTO                                          |
|                                                                    |
|  TALHAO_SAFRA (status=colhido)                                     |
|    data_colheita = MAX(data_pesagem)                               |
|    produtividade_sc_ha = SUM(peso_final_kg) / 60 / area           |
|                                                                    |
|  Dashboard: produtividade real vs meta                             |
+------------------------------------------------------------------+
```

### 3.2 Pre-populacao entre Entidades

Mostra como dados fluem de uma entidade para pre-popular a proxima:

```
TALHAO_SAFRA
  .talhao_id ──────────────> OPERACAO_CAMPO.talhao_safra_id (lookup)
  .cultura_id ─────────────> Label no form: "Soja"
  .cultivar ───────────────> PLANTIO_DETALHE.variedade (default)
  .area_plantada_ha ───────> OPERACAO_CAMPO.area_trabalhada_ha (default)
  .data_plantio_prevista ──> Posicao no Gantt

SAFRA_ACAO
  .tipo ───────────────────> OPERACAO_CAMPO.tipo (locked)
  .talhao_safra_id ────────> OPERACAO_CAMPO.talhao_safra_id (herdado)
  .titulo ─────────────────> Label no form

TALHAO_SAFRA
  .cultura_id ─────────────> TICKET_BALANCA.cultura_id (filtro dropdown)
  .gleba ──────────────────> TICKET_BALANCA.gleba (auto)
  .cultivar ───────────────> TICKET_BALANCA.variedade (default)
```

---

## 4. Walkthroughs Concretos

### 4.1 Retroativo 25/26

Dados existentes:
- 50 registros de plantio (em `12_plantio_historico.csv`) com `talhao_id`, `safra_id`, `cultura_id`, `cultivar`, `area_plantada_ha`
- 883 tickets de colheita com `talhao_safra_id` (via nome de talhao)
- `data_plantio` preenchido em ~6% (maioria NULL)

Reconstrucao:
1. Os 50 registros 25/26 inseridos em `02_INSERT_DADOS.sql` §26 com `status_planejamento` do CSV (maioria 'colhido')
2. Cadeia FK completa: §27 safra_acoes (9) → §28 operacoes_campo (7) → §29 aplicacao_insumo (11). Ticket balança/recebimento grão agora em §17/17b (fase 6, 883+875 registros)
3. Plantio historico (§31) com ON CONFLICT DO NOTHING — fase 5 tem prioridade
4. UPDATE em batch (§32): setar rascunho→aprovado (25/26) ou colhido (historicos)

### 4.2 Prospectivo 26/27

Workflow completo digital:
1. Admin cria Safra 26/27 (Etapa 1)
2. Sistema gera grid com 71 talhoes + safra anterior 25/26 como referencia (Etapa 2)
3. Alessandro preenche cultura x talhao no grid (Etapa 3) -> status `rascunho`
4. Lucas revisa (Etapa 4) -> status `em_revisao`
5. Claudio aprova (Etapa 5) -> status `aprovado` -> sistema auto-gera SAFRA_ACOEs
6. Tiago executa operacoes no campo -> OPERACAO_CAMPO com `safra_acao_id` -> status avanca
7. Josmar/Vanessa pesam colheita -> TICKET_BALANCA -> status `colhendo` -> `colhido`

---

## 5. Funcoes SQL de Referencia

### 5.1 fn_gerar_safra_acoes(talhao_safra_id)

Gera N rows em `safra_acoes` a partir dos templates da cultura.

```sql
CREATE OR REPLACE FUNCTION fn_gerar_safra_acoes(p_talhao_safra_id UUID)
RETURNS INTEGER AS $$
DECLARE
    v_cultura_id UUID;
    v_safra_id UUID;
    v_org_id UUID;
    v_data_ancora DATE;
    v_area NUMERIC(10,2);
    v_count INTEGER := 0;
BEGIN
    -- Buscar dados do talhao_safra
    SELECT ts.cultura_id, ts.safra_id, ts.organization_id,
           COALESCE(ts.data_plantio_prevista, ts.data_plantio),
           ts.area_plantada_ha
    INTO v_cultura_id, v_safra_id, v_org_id, v_data_ancora, v_area
    FROM talhao_safras ts
    WHERE ts.talhao_safra_id = p_talhao_safra_id;

    IF v_cultura_id IS NULL THEN
        RAISE EXCEPTION 'talhao_safra_id % nao encontrado', p_talhao_safra_id;
    END IF;

    IF v_data_ancora IS NULL THEN
        RAISE EXCEPTION 'talhao_safra_id % nao tem data_plantio_prevista nem data_plantio', p_talhao_safra_id;
    END IF;

    -- Gerar safra_acoes a partir dos templates
    INSERT INTO safra_acoes (
        organization_id, talhao_safra_id, safra_id,
        tipo, titulo, data_inicio, data_fim,
        status, area_ha, template_id, gerado_automaticamente
    )
    SELECT
        v_org_id,
        p_talhao_safra_id,
        v_safra_id,
        t.tipo_operacao::TEXT,
        t.nome_operacao,
        v_data_ancora + t.dias_offset_inicio,
        v_data_ancora + t.dias_offset_inicio + t.duracao_dias - 1,
        'planejada',
        v_area,
        t.template_id,
        TRUE
    FROM template_cultura_operacoes t
    WHERE t.cultura_id = v_cultura_id
      AND t.organization_id = v_org_id
      AND t.status = 'active'
    ORDER BY t.sequencia;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_gerar_safra_acoes(UUID) IS
    'Gera safra_acoes automaticamente a partir dos templates da cultura do talhao_safra. Retorna quantidade de acoes geradas.';
```

### 5.2 fn_fechar_colheita(talhao_safra_id)

Agrega tickets de balanca, calcula produtividade, fecha ciclo.

```sql
CREATE OR REPLACE FUNCTION fn_fechar_colheita(p_talhao_safra_id UUID)
RETURNS TABLE(
    total_tickets INTEGER,
    peso_total_kg NUMERIC,
    produtividade_sc_ha NUMERIC,
    data_primeira_pesagem DATE,
    data_ultima_pesagem DATE
) AS $$
DECLARE
    v_area NUMERIC(10,2);
    v_total_tickets INTEGER;
    v_peso_total NUMERIC;
    v_produtividade NUMERIC;
    v_primeira DATE;
    v_ultima DATE;
BEGIN
    -- Buscar area plantada
    SELECT ts.area_plantada_ha INTO v_area
    FROM talhao_safras ts
    WHERE ts.talhao_safra_id = p_talhao_safra_id;

    IF v_area IS NULL OR v_area = 0 THEN
        RAISE EXCEPTION 'talhao_safra_id % nao encontrado ou area = 0', p_talhao_safra_id;
    END IF;

    -- Agregar tickets
    SELECT
        COUNT(tb.ticket_balanca_id),
        COALESCE(SUM(tb.peso_final_kg), 0),
        MIN(tb.data_pesagem),
        MAX(tb.data_pesagem)
    INTO v_total_tickets, v_peso_total, v_primeira, v_ultima
    FROM ticket_balancas tb
    WHERE tb.talhao_safra_id = p_talhao_safra_id;

    -- Calcular produtividade (sacas de 60kg por hectare)
    v_produtividade := ROUND(v_peso_total / 60.0 / v_area, 2);

    -- Atualizar talhao_safra
    UPDATE talhao_safras
    SET
        status_planejamento = 'colhido',
        data_colheita = v_ultima,
        produtividade_sc_ha = v_produtividade
    WHERE talhao_safra_id = p_talhao_safra_id;

    -- Retornar resumo
    RETURN QUERY SELECT v_total_tickets, v_peso_total, v_produtividade, v_primeira, v_ultima;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_fechar_colheita(UUID) IS
    'Fecha o ciclo de colheita: agrega tickets de balanca, calcula produtividade (sc/ha), atualiza status para colhido.';
```

### 5.3 FK safra_acao_id em operacoes_campo

```sql
-- DDL (ja incluido no 00_DDL_COMPLETO_V0.sql)
ALTER TABLE operacoes_campo
    ADD COLUMN safra_acao_id UUID REFERENCES safra_acoes(safra_acao_id);

CREATE INDEX idx_operacoes_campo_safra_acao ON operacoes_campo(safra_acao_id)
    WHERE safra_acao_id IS NOT NULL;

COMMENT ON COLUMN operacoes_campo.safra_acao_id IS
    'FK para safra_acoes — vincula a execucao real (OPERACAO_CAMPO) ao plano (SAFRA_ACAO).';
```

---

## 6. Queries de Referencia

### 6.1 Dashboard Lifecycle (count por status por safra)

```sql
SELECT
    s.ano_agricola,
    ts.status_planejamento,
    COUNT(*) as total,
    SUM(ts.area_plantada_ha) as area_total_ha
FROM talhao_safras ts
JOIN safras s ON ts.safra_id = s.safra_id
WHERE ts.status = 'active'
GROUP BY s.ano_agricola, ts.status_planejamento
ORDER BY s.ano_agricola, ts.status_planejamento;
```

### 6.2 Produtividade por Talhao (join tickets)

```sql
SELECT
    t.nome as talhao,
    c.nome as cultura,
    s.ano_agricola as safra,
    ts.area_plantada_ha,
    ts.cultivar,
    COUNT(tb.ticket_balanca_id) as tickets,
    COALESCE(SUM(tb.peso_final_kg), 0) as peso_total_kg,
    ROUND(COALESCE(SUM(tb.peso_final_kg), 0) / 60.0 / NULLIF(ts.area_plantada_ha, 0), 2) as sc_ha
FROM talhao_safras ts
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
LEFT JOIN ticket_balancas tb ON tb.talhao_safra_id = ts.talhao_safra_id
WHERE ts.talhao_id IS NOT NULL
GROUP BY t.nome, c.nome, s.ano_agricola, ts.area_plantada_ha, ts.cultivar
ORDER BY s.ano_agricola DESC, sc_ha DESC NULLS LAST;
```

### 6.3 Feed Calendario Gantt (safra_acoes ordenadas)

```sql
SELECT
    sa.safra_acao_id,
    t.nome as talhao,
    c.nome as cultura,
    sa.tipo,
    sa.titulo,
    sa.data_inicio,
    sa.data_fim,
    sa.status,
    sa.gerado_automaticamente,
    oc.operacao_campo_id as execucao_real_id,
    oc.data_inicio as data_execucao_real
FROM safra_acoes sa
JOIN talhao_safras ts ON sa.talhao_safra_id = ts.talhao_safra_id
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
LEFT JOIN operacoes_campo oc ON oc.safra_acao_id = sa.safra_acao_id
WHERE sa.safra_id = (SELECT safra_id FROM safras WHERE ano_agricola = '26/27' LIMIT 1)
ORDER BY t.nome, sa.data_inicio;
```

### 6.4 Compliance Rotacao (% gramineas)

```sql
SELECT
    s.ano_agricola,
    SUM(ts.area_plantada_ha) as area_total_ha,
    SUM(CASE WHEN c.grupo = 'graos' AND c.nome IN ('Milho', 'Trigo', 'Cevada', 'Aveia Branca', 'Aveia Preta', 'Centeio', 'Triticale')
         THEN ts.area_plantada_ha ELSE 0 END) as area_gramineas_ha,
    ROUND(
        SUM(CASE WHEN c.grupo = 'graos' AND c.nome IN ('Milho', 'Trigo', 'Cevada', 'Aveia Branca', 'Aveia Preta', 'Centeio', 'Triticale')
             THEN ts.area_plantada_ha ELSE 0 END)
        / NULLIF(SUM(ts.area_plantada_ha), 0) * 100, 1
    ) as pct_gramineas
FROM talhao_safras ts
JOIN safras s ON ts.safra_id = s.safra_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
WHERE ts.status = 'active'
  AND ts.talhao_id IS NOT NULL
GROUP BY s.ano_agricola
ORDER BY s.ano_agricola;
```

### 6.5 Fechamento Colheita em Batch

```sql
SELECT fn_fechar_colheita(ts.talhao_safra_id)
FROM talhao_safras ts
JOIN safras s ON ts.safra_id = s.safra_id
WHERE s.ano_agricola = '25/26'
  AND ts.status_planejamento != 'colhido'
  AND EXISTS (
      SELECT 1 FROM ticket_balancas tb
      WHERE tb.talhao_safra_id = ts.talhao_safra_id
  );
```

### 6.6 Reconstrucao 25/26

```sql
-- 1. Identificar talhao_safras 25/26 que tem tickets de colheita
SELECT
    ts.talhao_safra_id,
    t.nome as talhao_nome,
    c.nome as cultura_nome,
    ts.area_plantada_ha,
    COUNT(tb.ticket_balanca_id) as total_tickets,
    MIN(tb.data_pesagem) as primeira_pesagem,
    MAX(tb.data_pesagem) as ultima_pesagem,
    SUM(tb.peso_final_kg) as peso_total_kg,
    ROUND(SUM(tb.peso_final_kg) / 60.0 / NULLIF(ts.area_plantada_ha, 0), 2) as produtividade_sc_ha
FROM talhao_safras ts
JOIN safras s ON ts.safra_id = s.safra_id
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
LEFT JOIN ticket_balancas tb ON tb.talhao_safra_id = ts.talhao_safra_id
WHERE s.ano_agricola = '25/26'
  AND ts.talhao_id IS NOT NULL
GROUP BY ts.talhao_safra_id, t.nome, c.nome, ts.area_plantada_ha;

-- 2. UPDATE status_planejamento para 'colhido' onde existir colheita
UPDATE talhao_safras ts
SET
    status_planejamento = 'colhido',
    data_colheita = sub.ultima_pesagem,
    produtividade_sc_ha = sub.produtividade_sc_ha
FROM (
    SELECT
        ts2.talhao_safra_id,
        MAX(tb.data_pesagem) as ultima_pesagem,
        ROUND(SUM(tb.peso_final_kg) / 60.0 / NULLIF(ts2.area_plantada_ha, 0), 2) as produtividade_sc_ha
    FROM talhao_safras ts2
    JOIN safras s ON ts2.safra_id = s.safra_id
    JOIN ticket_balancas tb ON tb.talhao_safra_id = ts2.talhao_safra_id
    WHERE s.ano_agricola = '25/26'
    GROUP BY ts2.talhao_safra_id, ts2.area_plantada_ha
) sub
WHERE ts.talhao_safra_id = sub.talhao_safra_id;

-- 3. TALHAO_SAFRAs 25/26 SEM tickets -> status 'aprovado'
UPDATE talhao_safras ts
SET status_planejamento = 'aprovado'
FROM safras s
WHERE ts.safra_id = s.safra_id
  AND s.ano_agricola = '25/26'
  AND ts.talhao_id IS NOT NULL
  AND ts.status_planejamento = 'rascunho'
  AND NOT EXISTS (
      SELECT 1 FROM ticket_balancas tb
      WHERE tb.talhao_safra_id = ts.talhao_safra_id
  );
```

---

## 7. Validacoes e Constraints

1. **Capinzal = cultura unica por safra** — ja enforced pelo UNIQUE constraint `(talhao_id, safra_id, cultura_id, epoca, gleba)`. Regra de negocio: CAPINZAL sempre 100% milho OU 100% soja, nunca fracionado. Enforcement: aplicacao (nao DB).

2. **area_plantada_ha <= talhao.area_ha** — nao enforced como DB constraint porque glebas fragmentam a area. Validacao na aplicacao.

3. **State machine** — transicoes validas controladas na aplicacao. A coluna `status_planejamento` usa o ENUM `status_talhao_safra` que ja restringe aos 9 valores.

4. **Datas coerentes:**
   - `data_plantio_prevista` <= `data_plantio` (quando ambos existem)
   - `data_plantio` <= `data_colheita` (quando ambos existem)

5. **Horimetro crescente** — `chk_operacao_horimetro`: `horimetro_fim >= horimetro_inicio`

6. **Peso bruto > tara** — `chk_ticket_peso_bruto`: `peso_bruto_kg > 0`

7. **Umidade valida** — `chk_ticket_umidade`: `0 <= umidade_pct <= 100`

---

## 8. Gaps e Proximos Passos

| Gap | Impacto | Acao | Status |
|-----|---------|------|--------|
| INSERTs de template_cultura_operacoes NAO existiam | BLOCKER — sem templates, nao gera safra_acoes | Adicionados ao 01_INSERT_SEEDS.sql | ✅ Resolvido |
| safra_acoes.status e VARCHAR(20), sem ENUM | Inconsistencia — todos os outros status usam ENUM | Documentado. Considerar ENUM `status_safra_acao` futuro | Aceito V0 |
| Sem FK safra_acoes <-> operacoes_campo | Nao vincula acao planejada com operacao executada | `safra_acao_id` adicionado em operacoes_campo | ✅ Resolvido |
| Coluna chama `status_planejamento` mas cobre lifecycle inteiro | Naming artifact — nao e bug | Documentado. Considerar rename futuro | Aceito V0 |
| Ervilha forrageira sem template | Nova cultura 26/27, sem operacoes definidas | Pedir Alessandro | Pendente |
| data_plantio 25/26 = ~6% preenchido | Historico incompleto | Deixar NULL, nao fabricar | Aceito |
| Offline conflict resolution | Ultimo-escritor-vence e simplista | Suficiente para V0 — operacoes unidirecionais | Aceito V0 |
| Audio STT com ruido rural | Nao testado com vocabulario agricola | Testar com nomes de talhoes e cultivares antes de P2 | Pendente |
| Transicoes automaticas de status | Nao implementadas como triggers no DDL | Implementar na aplicacao (API layer) | Decisao: app, nao DB |

---

## 9. Metricas

| Metrica | Valor |
|---------|-------|
| Funcoes SQL lifecycle | 2 (fn_gerar_safra_acoes, fn_fechar_colheita) |
| Coluna safra_acao_id em operacoes_campo | +1 coluna, +1 index parcial |
| Seeds template_cultura_operacoes | 42 templates (6 culturas) |
| Campos formulario OPERACAO_CAMPO | 14 campos (4 obrigatorios, 10 opcionais) |
| Campos formulario TICKET_BALANCA | 26 campos (7 obrigatorios, 19 opcionais) |
| Subformularios detalhe | 3 (plantio: 8 campos, colheita: 6 campos, pulverizacao: 7 campos) |
| Telas UX OPERACAO_CAMPO | 1-2 telas (via Gantt: 1 tela pre-preenchida) |
| Telas UX TICKET_BALANCA | 3 telas (identificacao, pesagem, qualidade) |
| Efeitos colaterais automaticos | 5 transicoes de status (TALHAO_SAFRA) + 1 update (SAFRA_ACAO) |
| CSVs fase_5 (lifecycle completo) | 7: planejamento(01) → templates(02) → talhao_safra(03) → safra_acoes(04) → operacoes_campo(05) → aplicacao_insumo(06) → ticket_balanca(07) |

---

## 10. TALHAO_SAFRA como Hub Central de Custeio

### 10.1 Visao Geral — Unidade Central de Custeio

TALHAO_SAFRA e o nivel 5 da hierarquia de centro de custo (Doc 13):

```
Nivel 1: ORGANIZACAO       01
Nivel 2:   FAZENDA          01.01 (Sede)
Nivel 3:     SAFRA            01.01.026 (Safra 26/27)
Nivel 4:       CULTURA          01.01.026.01 (Soja)
Nivel 5:         TALHAO           01.01.026.01.001 (LAGARTO) ← TALHAO_SAFRA
```

**Todo custo e toda receita da fazenda converge nesta entidade.** E ela que responde:
- "Quanto custou plantar soja no LAGARTO na safra 25/26?"
- "Qual a produtividade por talhao?"
- "Qual cultura deu mais lucro?"
- "Quanto gastamos de insumo por hectare no feijao?"

As secoes 1-9 cobrem o **lifecycle** (nascimento → colheita). Esta secao cobre o **papel economico**: como custos e receitas se acumulam em TALHAO_SAFRA para gerar os dashboards de custeio.

---

### 10.2 Mapa de Conexoes (10 entidades)

```
                              PLANTIO_DETALHE ─────┐
                              COLHEITA_DETALHE ─────┤
                              PULVERIZACAO_DETALHE ─┤
                              DRONE_DETALHE ────────┤ via operacao_campo_id
                              TRANSPORTE_COLHEITA ──┘
                                        │
                                        ▼
    SAFRA_ACAO ──────────► OPERACAO_CAMPO ◄──── ABASTECIMENTO
    (planejado)            (custo real)          (combustivel via maquina_id)
         │                      │
         │     ┌────────────────┤
         ▼     ▼                ▼
    ╔═══════════════════════╗
    ║    TALHAO_SAFRA       ║
    ║  (hub de custeio)     ║
    ╚═══════════════════════╝
         ▲                ▲
         │                │
    APLICACAO_INSUMO   TICKET_BALANCA
    (custo insumos)    (producao/receita)
```

**Conexoes diretas (FK `talhao_safra_id`):**

| # | Entidade | Papel economico | Campo-chave de custo/receita |
|---|----------|-----------------|------------------------------|
| 1 | `operacoes_campo` | Custo de maquinario + mao de obra | `custo_operacao`, `combustivel_litros`, horimetros |
| 2 | `aplicacao_insumo` | Custo de insumos aplicados | `custo_unitario`, `custo_total`, `dose_por_ha` |
| 3 | `ticket_balancas` | Producao (receita) | `peso_final_kg`, `umidade_pct`, `impureza_pct` |
| 4 | `safra_acoes` | Custo planejado vs real | `custo_estimado`, `custo_real` |

**Conexoes indiretas (via `operacao_campo_id`):**

| # | Entidade | Dado de custo | Caminho |
|---|----------|---------------|---------|
| 5 | `plantio_detalhes` | Semente, adubo base, populacao | operacao_campo → talhao_safra |
| 6 | `colheita_detalhes` | `produtividade_sacas_ha` (KPI central) | operacao_campo → talhao_safra |
| 7 | `pulverizacao_detalhes` | Vazao, velocidade, bico | operacao_campo → talhao_safra |
| 8 | `drone_detalhes` | Voos, area sobrevoada | operacao_campo → talhao_safra |
| 9 | `transporte_colheita_detalhes` | Logistica campo→UBG | operacao_campo → talhao_safra |

**Conexao adjacente (via `maquina_id` em operacao_campo):**

| # | Entidade | Dado de custo | Caminho |
|---|----------|---------------|---------|
| 10 | `abastecimentos` | Litros diesel, custo combustivel | maquina_id → operacao_campo → talhao_safra (rateio por area/horas) |

---

### 10.3 Componentes de Custo por TALHAO_SAFRA

| Componente | Fonte (tabela.campo) | Calculo | Exemplo |
|------------|----------------------|---------|---------|
| **Maquinario** | `operacoes_campo.custo_operacao` | SUM direto por talhao_safra | Horas trator × custo/hora |
| **Combustivel** | `operacoes_campo.combustivel_litros` | Litros × preco diesel do periodo | 500L × R$6,50 = R$3.250 |
| **Insumos** | `aplicacao_insumo.custo_total` | SUM direto por talhao_safra | Fungicida + herbicida + adubo |
| **Semente** | `aplicacao_insumo` (tipo_insumo=semente) OU `plantio_detalhes` | Direto | 250k sementes × preco/milhar |
| **Mao de obra** | `operacoes_campo.operador_id` × horas trabalhadas | Horas × custo/hora do colaborador (folha) | 8h × R$25/h = R$200 |
| **Custo planejado** | `safra_acoes.custo_estimado` | SUM por talhao_safra | Budget antes da execucao |
| **Custo real** | `safra_acoes.custo_real` | SUM por talhao_safra | Acumulado pos-execucao |
| **Combustivel (rateio)** | `abastecimentos` via maquina_id | Litros da maquina × (area_talhao / area_total_maquina) | Rateio proporcional |

**Nota:** Combustivel tem duas fontes — campo direto (`operacoes_campo.combustivel_litros`, preenchido pelo operador) e rateio via abastecimentos Vestro. Para V0, usar o campo direto. Rateio via Vestro e refinamento futuro.

---

### 10.4 Receita por TALHAO_SAFRA

| Componente | Fonte (tabela.campo) | Calculo |
|------------|----------------------|---------|
| **Producao bruta (kg)** | `ticket_balancas.peso_final_kg` | SUM por talhao_safra |
| **Producao (sc/ha)** | Calculado | peso_total_kg / 60 / area_plantada_ha |
| **Receita bruta (R$)** | `vendas_grao` via saida_grao → ticket → talhao_safra | preco_unitario × quantidade_kg |
| **Descontos (%)** | `ticket_balancas.desconto_total_pct` | Umidade + impureza + avariados |
| **Peso liquido descontado** | Calculado | peso_final_kg × (1 - desconto_total_pct/100) |

**Caminho da receita:** TALHAO_SAFRA → TICKET_BALANCA → SAIDA_GRAO → VENDA_GRAO

---

### 10.5 Queries de Custeio

#### 10.5.1 Custo Total por Talhao/Safra

```sql
-- Agrega operacoes + insumos por talhao_safra
SELECT
    t.nome AS talhao,
    c.nome AS cultura,
    s.ano_agricola AS safra,
    ts.area_plantada_ha,
    -- Custo maquinario
    COALESCE(op.custo_maquinario, 0) AS custo_maquinario,
    -- Custo combustivel (campo direto)
    COALESCE(op.litros_combustivel, 0) AS litros_combustivel,
    -- Custo insumos
    COALESCE(ins.custo_insumos, 0) AS custo_insumos,
    -- Total
    COALESCE(op.custo_maquinario, 0) + COALESCE(ins.custo_insumos, 0) AS custo_total,
    -- Por hectare
    ROUND(
        (COALESCE(op.custo_maquinario, 0) + COALESCE(ins.custo_insumos, 0))
        / NULLIF(ts.area_plantada_ha, 0), 2
    ) AS custo_por_ha
FROM talhao_safras ts
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
LEFT JOIN (
    SELECT
        oc.talhao_safra_id,
        SUM(oc.custo_operacao) AS custo_maquinario,
        SUM(oc.combustivel_litros) AS litros_combustivel
    FROM operacoes_campo oc
    WHERE oc.status = 'active'
    GROUP BY oc.talhao_safra_id
) op ON op.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT
        ai.talhao_safra_id,
        SUM(ai.custo_total) AS custo_insumos
    FROM aplicacao_insumos ai
    WHERE ai.status = 'active'
    GROUP BY ai.talhao_safra_id
) ins ON ins.talhao_safra_id = ts.talhao_safra_id
WHERE ts.status = 'active'
ORDER BY s.ano_agricola DESC, custo_total DESC NULLS LAST;
```

#### 10.5.2 Custo por Hectare por Cultura (comparativo)

```sql
-- Comparativo entre culturas na mesma safra
SELECT
    c.nome AS cultura,
    s.ano_agricola AS safra,
    COUNT(ts.talhao_safra_id) AS qtd_talhoes,
    SUM(ts.area_plantada_ha) AS area_total_ha,
    -- Custos agregados
    ROUND(SUM(COALESCE(op.custo_maq, 0)) / NULLIF(SUM(ts.area_plantada_ha), 0), 2) AS maquinario_por_ha,
    ROUND(SUM(COALESCE(ins.custo_ins, 0)) / NULLIF(SUM(ts.area_plantada_ha), 0), 2) AS insumo_por_ha,
    ROUND(
        (SUM(COALESCE(op.custo_maq, 0)) + SUM(COALESCE(ins.custo_ins, 0)))
        / NULLIF(SUM(ts.area_plantada_ha), 0), 2
    ) AS custo_total_por_ha
FROM talhao_safras ts
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_operacao) AS custo_maq
    FROM operacoes_campo WHERE status = 'active'
    GROUP BY talhao_safra_id
) op ON op.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_total) AS custo_ins
    FROM aplicacao_insumos WHERE status = 'active'
    GROUP BY talhao_safra_id
) ins ON ins.talhao_safra_id = ts.talhao_safra_id
WHERE ts.status = 'active'
GROUP BY c.nome, s.ano_agricola
ORDER BY s.ano_agricola DESC, custo_total_por_ha DESC;
```

#### 10.5.3 Margem por Talhao (receita - custo)

```sql
-- Margem = receita bruta - custo total por talhao_safra
SELECT
    t.nome AS talhao,
    c.nome AS cultura,
    s.ano_agricola AS safra,
    ts.area_plantada_ha,
    -- Producao
    COALESCE(prod.peso_total_kg, 0) AS producao_kg,
    ROUND(COALESCE(prod.peso_total_kg, 0) / 60.0 / NULLIF(ts.area_plantada_ha, 0), 2) AS sc_ha,
    -- Receita (via vendas_grao)
    COALESCE(rec.receita_bruta, 0) AS receita_bruta,
    -- Custos
    COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0) AS custo_total,
    -- Margem
    COALESCE(rec.receita_bruta, 0)
        - (COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0)) AS margem_bruta,
    -- Margem por ha
    ROUND(
        (COALESCE(rec.receita_bruta, 0)
            - (COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0)))
        / NULLIF(ts.area_plantada_ha, 0), 2
    ) AS margem_por_ha
FROM talhao_safras ts
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(peso_final_kg) AS peso_total_kg
    FROM ticket_balancas WHERE status = 'active'
    GROUP BY talhao_safra_id
) prod ON prod.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT
        tb.talhao_safra_id,
        SUM(vg.valor_total) AS receita_bruta
    FROM vendas_grao vg
    JOIN saida_graos sg ON vg.venda_grao_id = sg.venda_grao_id
    JOIN ticket_balancas tb ON sg.ticket_balanca_id = tb.ticket_balanca_id
    WHERE vg.status = 'active'
    GROUP BY tb.talhao_safra_id
) rec ON rec.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_operacao) AS custo_maq
    FROM operacoes_campo WHERE status = 'active'
    GROUP BY talhao_safra_id
) op ON op.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_total) AS custo_ins
    FROM aplicacao_insumos WHERE status = 'active'
    GROUP BY talhao_safra_id
) ins ON ins.talhao_safra_id = ts.talhao_safra_id
WHERE ts.status = 'active'
ORDER BY s.ano_agricola DESC, margem_por_ha DESC NULLS LAST;
```

#### 10.5.4 Planejado vs Real por Safra

```sql
-- Compara custo planejado (safra_acoes) com custos reais (operacoes + insumos)
SELECT
    t.nome AS talhao,
    c.nome AS cultura,
    s.ano_agricola AS safra,
    ts.area_plantada_ha,
    -- Planejado
    COALESCE(plan.custo_estimado_total, 0) AS custo_planejado,
    COALESCE(plan.custo_real_total, 0) AS custo_real_safra_acao,
    -- Real (operacoes + insumos)
    COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0) AS custo_real_agregado,
    -- Desvio
    ROUND(
        CASE
            WHEN COALESCE(plan.custo_estimado_total, 0) = 0 THEN NULL
            ELSE (
                (COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0))
                - COALESCE(plan.custo_estimado_total, 0)
            ) / plan.custo_estimado_total * 100
        END, 1
    ) AS desvio_pct
FROM talhao_safras ts
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
LEFT JOIN (
    SELECT
        talhao_safra_id,
        SUM(custo_estimado) AS custo_estimado_total,
        SUM(custo_real) AS custo_real_total
    FROM safra_acoes
    WHERE status != 'cancelada'
    GROUP BY talhao_safra_id
) plan ON plan.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_operacao) AS custo_maq
    FROM operacoes_campo WHERE status = 'active'
    GROUP BY talhao_safra_id
) op ON op.talhao_safra_id = ts.talhao_safra_id
LEFT JOIN (
    SELECT talhao_safra_id, SUM(custo_total) AS custo_ins
    FROM aplicacao_insumos WHERE status = 'active'
    GROUP BY talhao_safra_id
) ins ON ins.talhao_safra_id = ts.talhao_safra_id
WHERE ts.status = 'active'
ORDER BY s.ano_agricola DESC, ABS(COALESCE(
    (COALESCE(op.custo_maq, 0) + COALESCE(ins.custo_ins, 0))
    - COALESCE(plan.custo_estimado_total, 0), 0
)) DESC;
```

---

### 10.6 Dashboard de Custeio (Spec UX para Joao)

#### 10.6.1 Card de Talhao — Visao Individual

```
┌─────────────────────────────────────────────────┐
│  LAGARTO  ·  Soja  ·  Safra 25/26  ·  120 ha   │
├─────────────────────────────────────────────────┤
│                                                 │
│  CUSTO TOTAL          R$ 198.000    R$ 1.650/ha │
│  ├── Maquinario  ████████░░░░  R$ 72.000  36%   │
│  ├── Insumos     ██████████░░  R$ 96.000  49%   │
│  ├── Semente     ███░░░░░░░░░  R$ 18.000   9%   │
│  └── Combustivel ██░░░░░░░░░░  R$ 12.000   6%   │
│                                                 │
│  PRODUCAO        7.200 sc    60,0 sc/ha         │
│  META            -           55,0 sc/ha  ✅ +9% │
│                                                 │
│  RECEITA BRUTA   R$ 936.000  R$ 7.800/ha        │
│  MARGEM BRUTA    R$ 738.000  R$ 6.150/ha        │
│                                                 │
│  PLANEJADO vs REAL                              │
│  ├── Estimado    R$ 180.000                     │
│  ├── Real        R$ 198.000                     │
│  └── Desvio      +10,0%  ⚠️                     │
│                                                 │
└─────────────────────────────────────────────────┘
```

#### 10.6.2 Tabela Comparativa — Todos os Talhoes de uma Cultura

```
┌───────────────┬────────┬───────────┬───────────┬─────────┬─────────┬──────────┐
│ Talhao        │ Area   │ Custo/ha  │ Produtiv. │ Receita │ Margem  │ Desvio   │
│               │ (ha)   │ (R$)      │ (sc/ha)   │ /ha     │ /ha     │ Plan(%)  │
├───────────────┼────────┼───────────┼───────────┼─────────┼─────────┼──────────┤
│ LAGARTO       │ 120,0  │ 1.650     │ 60,0      │ 7.800   │ 6.150   │ +10,0%   │
│ MASSACRE      │  95,0  │ 1.720     │ 58,5      │ 7.605   │ 5.885   │  +5,2%   │
│ SANTA RITA    │  80,0  │ 1.580     │ 62,3      │ 8.099   │ 6.519   │  -2,1%   │
│ CAPINZAL      │ 200,0  │ 1.490     │ 55,0      │ 7.150   │ 5.660   │  +0,8%   │
├───────────────┼────────┼───────────┼───────────┼─────────┼─────────┼──────────┤
│ MEDIA SOJA    │ 123,8  │ 1.610     │ 58,9      │ 7.664   │ 6.054   │  +3,5%   │
└───────────────┴────────┴───────────┴───────────┴─────────┴─────────┴──────────┘
```

#### 10.6.3 Telas Sugeridas

| Tela | Conteudo | Query base |
|------|----------|------------|
| **Custeio por Talhao** | Card individual (10.6.1) com drill-down por categoria | 10.5.1 |
| **Comparativo por Cultura** | Tabela (10.6.2) com ranking e media | 10.5.2 |
| **Mapa de Margem** | Mapa da fazenda com talhoes coloridos por margem/ha (verde→vermelho) | 10.5.3 |
| **Planejado vs Real** | Grafico de barras agrupadas por talhao (estimado vs real) | 10.5.4 |
| **Evolucao Safra** | Comparativo mesma cultura entre safras (custo/ha, sc/ha, margem) | 10.5.2 filtrado por cultura |

#### 10.6.4 Filtros Globais

Todos os dashboards de custeio devem suportar:
- **Safra** (dropdown, default = safra atual)
- **Fazenda** (dropdown, default = todas)
- **Cultura** (dropdown, default = todas)
- **Epoca** (safra / safrinha / cobertura)

---

### 10.7 Relacao com Doc 13 (Hierarquia Centro de Custo)

O codigo de centro de custo (Doc 13, secao 2) mapeia diretamente para TALHAO_SAFRA:

| Nivel | Entidade | Codigo exemplo | Como chegar |
|-------|----------|----------------|-------------|
| 1 | organizations | `01` | organization_id |
| 2 | fazendas | `01.01` | fazenda_id (via talhao_id) |
| 3 | safras | `01.01.026` | safra_id |
| 4 | culturas | `01.01.026.01` | cultura_id |
| 5 | **talhao_safras** | `01.01.026.01.001` | talhao_safra_id |

**Implicacao para Joao:** Qualquer agregacao de custo pode subir ou descer a hierarquia. SUM por cultura = nivel 4. SUM por fazenda = nivel 2. Drill-down de cultura para talhao = nivel 4 → 5.

---

*Criado: 2026-03-08 | Reescrito: 2026-03-08 | Expandido (hub de custeio): 2026-03-08 | DeepWork AI Flows*
