# RELACIONAMENTOS COMPLETOS - Modulo Agricultura

**Data:** 10/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGCOBuw4=/
**Referencia:** Doc 08 (Estrutura ER), Doc 09 (Operacoes Campo), Doc 17 (Consumo e Estoque)

---

## 1. Escopo do Modulo

### Entidades Mapeadas (8)

```
OPERACAO_CAMPO ─────────── Entidade PAI (centraliza todos os campos comuns)
PLANTIO_DETALHE ────────── Campos especificos de plantio (variedade, populacao, espacamento)
COLHEITA_DETALHE ───────── Campos especificos de colheita (producao, produtividade, umidade)
PULVERIZACAO_DETALHE ───── Campos especificos de pulverizacao (pressao, vazao, clima)
DRONE_DETALHE ──────────── Campos especificos de aplicacao aerea (altitude, faixa, bateria)
TRANSPORTE_COLHEITA_DET ── Campos especificos de transporte pos-colheita (viagem, placa, UBG)
ANALISE_SOLO ───────────── Analise quimica do solo (pH, P, K, Ca, Mg, CTC, V%)
RECOMENDACAO_ADUBACAO ──── Prescricao de fertilizacao baseada na analise
```

### Entidades JA Mapeadas em Doc 17 (nao repetir)

- APLICACAO_INSUMO (Doc 17: R03, R07-R09, R21-R25)
- RECEITUARIO_AGRONOMICO (Doc 17: R04, R09, R27-R28)
- PRODUTO_INSUMO, COMPRA_INSUMO, ESTOQUE_INSUMO, MOVIMENTACAO_INSUMO

### Mapa de Conexoes

```
                    TALHOES (Territorial)
                       │
                       │ N:1 (onde coletou)
                       ▼
                 ┌─────────────┐         ┌──────────────┐
                 │ ANALISE_SOLO│────────►│ RECOMENDACAO  │──► CULTURAS
                 │             │  1:N    │ _ADUBACAO     │
                 └─────────────┘         └──────────────┘


    TALHAO_SAFRA (Territorial)
         │
         │ 1:N (todas as operacoes deste talhao+safra+cultura)
         ▼
    ┌──────────────────────────────────────────────────────────────────┐
    │                      OPERACAO_CAMPO                              │
    │  tipo | status | data_inicio | data_fim | area_ha | custo       │
    │  maquina_id ──► MAQUINAS       operador_id ──► OPERADORES       │
    └───┬──────────┬──────────┬──────────┬──────────┬─────────────────┘
        │          │          │          │          │
        │ 1:0..1   │ 1:0..1   │ 1:0..1   │ 1:0..1   │ 1:0..1
        ▼          ▼          ▼          ▼          ▼
    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌──────────────┐
    │PLANTIO │ │COLHEITA│ │PULVERI │ │ DRONE  │ │ TRANSPORTE   │
    │DETALHE │ │DETALHE │ │ZACAO_D │ │DETALHE │ │COLHEITA_DET  │
    │        │ │        │ │        │ │        │ │              │
    │variedad│ │produca │ │alvo    │ │altitude│ │colheita_orig │──► OPERACAO_CAMPO
    │populaca│ │produtiv│ │dose_ha │ │velocid │ │              │     (tipo=colheita)
    │espacam │ │umidade │ │pressao │ │faixa   │ │ticket_balan  │──► TICKET_BALANCA
    │profund │ │perdas  │ │temperat│ │n_voos  │ │              │     (UBG)
    └────────┘ └────────┘ └────────┘ └────────┘ └──────────────┘
                                                        │
                              APLICACAO_INSUMO ◄────────┘ (via OPERACAO_CAMPO)
                              (Doc 17, R21)               (ja mapeado)
```

---

## 2. Relacionamentos Internos (Hierarquia OPERACAO_CAMPO)

Conectores DENTRO da estrutura pai-filho. Todos usam **linha solida amarela** com **Crow's Foot**.

---

### A01: TALHAO_SAFRA -> OPERACAO_CAMPO

| Aspecto | Detalhe |
|---------|---------|
| **De** | TALHAO_SAFRA (Frame 7: Cliente/Territorial) |
| **Para** | OPERACAO_CAMPO |
| **Cardinalidade** | 1:N (um talhao/safra tem muitas operacoes ao longo do ciclo) |
| **FK** | `operacao_campo.talhao_safra_id` -> `talhao_safra.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha tracejada verde (cruza Territorial -> Agricola). Grossa. |
| **Miro Label** | "talhao+safra" |

**Por que funciona:** TALHAO_SAFRA e a combinacao talhao + safra + cultura (ex: "Bonin + 25/26 + Soja"). Toda operacao de campo acontece em um talhao especifico dentro de uma safra especifica. Isso permite a timeline completa: preparo de solo → plantio → tratos culturais → colheita, tudo vinculado ao mesmo TALHAO_SAFRA. E o que gera o custo por hectare por cultura.

---

### A02: OPERACAO_CAMPO -> PLANTIO_DETALHE

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | PLANTIO_DETALHE |
| **Cardinalidade** | 1:0..1 (nem toda operacao tem detalhe de plantio, so tipo IN ('plantio','replantio')) |
| **FK** | `plantio_detalhe.operacao_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional (obrigatoria quando tipo IN ('plantio', 'replantio')) |
| **ON DELETE** | CASCADE |
| **Miro Connector** | `──│────○──` Linha solida amarela. "1" no lado OPERACAO, "0..1" no lado DETALHE |

**Por que funciona:** Estrutura hibrida (Doc 09). OPERACAO_CAMPO centraliza campos comuns (data, maquina, operador, area, custo). PLANTIO_DETALHE adiciona APENAS os campos especificos do plantio (variedade/cultivar, populacao de sementes/ha, espacamento entre linhas, profundidade, tratamento de sementes, adubo de base). Evita que a tabela pai tenha 100+ colunas com NULLs para os 20+ tipos de operacao.

---

### A03: OPERACAO_CAMPO -> COLHEITA_DETALHE

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | COLHEITA_DETALHE |
| **Cardinalidade** | 1:0..1 (so quando tipo = 'colheita') |
| **FK** | `colheita_detalhe.operacao_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional |
| **ON DELETE** | CASCADE |
| **Miro Connector** | `──│────○──` Linha solida amarela |

**Por que funciona:** Campos de colheita sao unicos: producao_total_kg, produtividade_kg_ha, produtividade_sacas_ha, umidade_media, perdas_estimadas, velocidade_colheitadeira, condicoes_climaticas. Nenhum outro tipo de operacao usa esses campos. O produtividade_sacas_ha e o KPI mais importante da fazenda — e calculado aqui.

---

### A04: OPERACAO_CAMPO -> PULVERIZACAO_DETALHE

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | PULVERIZACAO_DETALHE |
| **Cardinalidade** | 1:0..1 (so quando tipo LIKE 'pulverizacao_%') |
| **FK** | `pulverizacao_detalhe.operacao_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional |
| **ON DELETE** | CASCADE |
| **Miro Connector** | `──│────○──` Linha solida amarela |

**Por que funciona:** PULVERIZACAO_DETALHE registra dados TECNICOS da pulverizacao: alvo (praga/doenca/daninha), dose_ha, volume_calda_ha, vazao_bico, pressao_bar, temperatura, umidade_relativa, velocidade_vento. Esses dados sao criticos para eficacia e compliance (condicoes climaticas ideais: 20-30C, UR >55%, vento <10 km/h). NAO e redundante com APLICACAO_INSUMO — PULVERIZACAO_DETALHE = COMO foi aplicado, APLICACAO_INSUMO = O QUE foi aplicado.

---

### A05: OPERACAO_CAMPO -> DRONE_DETALHE

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | DRONE_DETALHE |
| **Cardinalidade** | 1:0..1 (so quando tipo = 'aplicacao_drone') |
| **FK** | `drone_detalhe.operacao_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional |
| **ON DELETE** | CASCADE |
| **Miro Connector** | `──│────○──` Linha solida amarela |

**Por que funciona:** Campos especificos de aplicacao aerea: modelo_drone, altitude_voo_m, velocidade_voo_ms, largura_faixa_m, volume_calda_ha, autonomia_bateria_min, numero_voos. Esses parametros nao existem em pulverizacao terrestre. A tendencia e aumentar o uso de drones — ter a entidade separada permite rastreabilidade especifica.

---

### A06: OPERACAO_CAMPO -> TRANSPORTE_COLHEITA_DETALHE

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | TRANSPORTE_COLHEITA_DETALHE |
| **Cardinalidade** | 1:0..1 (so quando tipo = 'transporte_interno') |
| **FK** | `transporte_colheita_detalhe.operacao_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional |
| **ON DELETE** | CASCADE |
| **Miro Connector** | `──│────○──` Linha solida amarela |

**Por que funciona:** O transporte campo→UBG e uma operacao de campo com campos especificos: numero_viagem, placa_veiculo, motorista, tipo_transporte (proprio/terceiro), hora_saida_campo, hora_chegada_ubg, peso_estimado, distancia_km. E a ponte entre o ciclo agricola (colheita) e o ciclo pos-colheita (UBG/silo).

---

## 3. Relacionamentos Internos (Solo)

---

### A07: ANALISE_SOLO -> RECOMENDACAO_ADUBACAO

| Aspecto | Detalhe |
|---------|---------|
| **De** | ANALISE_SOLO |
| **Para** | RECOMENDACAO_ADUBACAO |
| **Cardinalidade** | 1:N (uma analise gera recomendacoes para diferentes culturas) |
| **FK** | `recomendacao_adubacao.analise_id` -> `analise_solo.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** Uma analise de solo (coleta de amostra no talhao X) gera N recomendacoes de adubacao — uma por cultura que sera plantada naquele talhao. O mesmo solo com pH 5.2 e P baixo vai ter recomendacao diferente para soja vs milho vs trigo. A ANALISE_SOLO e o DIAGNOSTICO, a RECOMENDACAO_ADUBACAO e a PRESCRICAO.

---

## 4. Relacionamentos Externos

Conectores que SAEM das entidades de Agricultura para outros modulos. Usam **linha tracejada** na cor do modulo destino.

---

### A08: OPERACAO_CAMPO -> MAQUINAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | MAQUINAS (Frame 6: Maquinario) |
| **Cardinalidade** | N:1 (muitas operacoes usam a mesma maquina) |
| **FK** | `operacao_campo.maquina_id` -> `maquinas.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha solida ciano (mesma camada Operacional). Media. |
| **Miro Label** | "maquina" |

**Por que funciona:** Toda operacao de campo usa uma maquina (plantadeira, pulverizador, colheitadeira, trator). O vinculo permite: (1) calcular horas de uso por maquina, (2) controlar horimetro, (3) programar manutencao preventiva baseada em uso real, (4) calcular custo de mecanizacao por operacao.

---

### A09: OPERACAO_CAMPO -> OPERADORES

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERACAO_CAMPO |
| **Para** | OPERADORES (Frame 6: Maquinario) |
| **Cardinalidade** | N:1 (muitas operacoes do mesmo operador) |
| **FK** | `operacao_campo.operador_id` -> `operadores.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha solida ciano. Media. |
| **Miro Label** | "operador" |

**Por que funciona:** Quem operou a maquina naquela operacao. Permite: (1) calcular rendimento por operador (ha/hora), (2) verificar habilitacao (CNH compativel com a maquina), (3) controlar jornada, (4) identificar responsabilidade em caso de problema.

---

### A10: TRANSPORTE_COLHEITA_DETALHE -> TICKET_BALANCA

| Aspecto | Detalhe |
|---------|---------|
| **De** | TRANSPORTE_COLHEITA_DETALHE |
| **Para** | TICKET_BALANCA (Frame 1: UBG) |
| **Cardinalidade** | 1:1 (cada viagem gera um ticket de balanca na chegada) |
| **FK** | `transporte_colheita_detalhe.ticket_balanca_id` -> `ticket_balanca.id` |
| **Obrigatoria** | Nao (pode ainda nao ter chegado) |
| **ON DELETE** | SET NULL |
| **Miro Connector** | `──│────│──` Linha tracejada amarela (cruza Agricultura -> UBG). Media. |
| **Miro Label** | "chegada UBG" |

**Por que funciona:** PONTE AGRICULTURA → UBG. Quando o caminhao sai do campo com a carga de graos e chega na UBG (Unidade de Beneficiamento), ele pesa na balanca e gera um TICKET_BALANCA. Essa FK conecta os dois mundos: o ciclo de campo (quanto colheu) e o ciclo pos-colheita (quanto pesou na chegada, umidade, classificacao). A diferenca entre peso estimado no campo e peso na balanca revela perdas no transporte.

---

### A11: TRANSPORTE_COLHEITA_DETALHE -> OPERACAO_CAMPO (colheita)

| Aspecto | Detalhe |
|---------|---------|
| **De** | TRANSPORTE_COLHEITA_DETALHE |
| **Para** | OPERACAO_CAMPO (onde tipo = 'colheita') |
| **Cardinalidade** | N:1 (muitas viagens de transporte para uma mesma colheita) |
| **FK** | `transporte_colheita_detalhe.colheita_origem_id` -> `operacao_campo.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha solida amarela. Fina. Auto-referencia interna. |
| **Miro Label** | "origem colheita" |

**Por que funciona:** Uma colheita grande pode gerar 5, 10, 20 viagens de caminhao. Cada viagem (TRANSPORTE_COLHEITA_DETALHE) precisa saber de QUAL colheita veio para rastrear a carga. Isso e auto-referencia: TRANSPORTE aponta para outra OPERACAO_CAMPO (de tipo colheita).

---

### A12: ANALISE_SOLO -> TALHOES

| Aspecto | Detalhe |
|---------|---------|
| **De** | ANALISE_SOLO |
| **Para** | TALHOES (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitas analises por talhao ao longo dos anos) |
| **FK** | `analise_solo.talhao_id` -> `talhoes.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha tracejada verde. Media. |
| **Miro Label** | "talhao" |

**Por que funciona:** A analise de solo e feita POR TALHAO, nao por safra. O solo e um recurso permanente — seu pH, fosforo, potassio mudam lentamente ao longo dos anos. Vincular ao TALHAO (nao ao TALHAO_SAFRA) permite historico: "como o pH do Talhao Bonin evoluiu de 2020 a 2026?". O campo `data_coleta` registra quando a amostra foi coletada.

---

### A13: RECOMENDACAO_ADUBACAO -> CULTURAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | RECOMENDACAO_ADUBACAO |
| **Para** | CULTURAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitas recomendacoes para a mesma cultura) |
| **FK** | `recomendacao_adubacao.cultura_id` -> `culturas.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha tracejada verde. Fina. |
| **Miro Label** | "cultura" |

**Por que funciona:** A adubacao e cultura-especifica. Soja extrai muito fosforo, milho extrai muito nitrogenio. A mesma analise de solo gera recomendacoes diferentes: para soja = mais P2O5, para milho = mais N. Sem o vinculo a cultura, a recomendacao nao tem sentido agronomico.

---

## 5. Analise de Redundancia

### Principio Aplicado

> Se um FK e derivavel por uma cadeia existente, NAO desenhar no diagrama. Uma fonte de verdade.

### Redundancias Identificadas

| FK Removido | Derivavel Via | Acao |
|------------|--------------|------|
| OPERACAO_CAMPO.fazenda_id -> FAZENDAS | `talhao_safra_id -> TALHAO_SAFRA.talhao_id -> TALHOES.fazenda_id` | NAO desenhar. FK pode existir na DDL para performance, mas nao no diagrama. |
| PULVERIZACAO_DETALHE.receituario_id -> RECEITUARIO_AGRONOMICO | `operacao_id -> OPERACAO_CAMPO <- APLICACAO_INSUMO.receituario_id` | NAO desenhar NEM manter na DDL. O receituario e por PRODUTO (vive em APLICACAO_INSUMO), nao por operacao tecnica. |
| PULVERIZACAO_DETALHE.insumo_id -> PRODUTO_INSUMO | Ja removido em Doc 17 (R29) | Confirmado. |
| DRONE_DETALHE.insumo_id -> PRODUTO_INSUMO | Ja removido em Doc 17 (R30) | Confirmado. |

### Org_id (NAO desenhar — convencao do board)

| Entidade | FK | Derivavel Via |
|----------|-----|--------------|
| OPERACAO_CAMPO | organization_id | talhao_safra -> talhoes -> fazendas -> org |
| ANALISE_SOLO | organization_id | talhao -> fazendas -> org |
| RECOMENDACAO_ADUBACAO | organization_id | analise_solo -> talhao -> fazendas -> org |

---

## 6. Referencia Cruzada com Doc 17

Relacionamentos que JA conectam entidades deste modulo mas foram mapeados no Doc 17:

| Doc 17 # | Relacionamento | Relevancia para Agricultura |
|----------|---------------|---------------------------|
| R21 | APLICACAO_INSUMO -> OPERACAO_CAMPO (N:1) | Cada operacao consome N insumos |
| R25 | APLICACAO_INSUMO -> CUSTO_OPERACAO (1:1) | Custo de insumo por operacao |
| R09 | RECEITUARIO_AGRO -> APLICACAO_INSUMO (1:N) | Prescricao para defensivos |
| R29 | ~~PULVERIZACAO_DET -> PRODUTO_INSUMO~~ | Removido (redundante) |
| R30 | ~~DRONE_DETALHE -> PRODUTO_INSUMO~~ | Removido (redundante) |

---

## 7. Questoes Abertas

| # | Questao | Impacto | Quem Decide |
|---|---------|---------|-------------|
| 1 | RECOMENDACAO_ADUBACAO deveria ter FK para OPERACAO_CAMPO? (vincular prescricao ao que foi executado) | Permitiria rastrear "seguimos a recomendacao?" | Rodrigo + Alessandro |
| 2 | OPERACAO_CAMPO.fazenda_id manter na DDL como denormalizacao? | Performance em queries de filtro por fazenda | Joao |
| 3 | ANALISE_SOLO precisa de FK para laboratorio/parceiro_comercial? | Rastreabilidade de quem fez a analise | Alessandro |

---

## 8. Tabela Resumo Total

### Todas as Relacoes do Modulo Agricultura

| # | De | Para | Card. | FK Em | Tipo Linha | Espessura | Status |
|---|-----|------|-------|-------|------------|-----------|--------|
| **INTERNOS - Hierarquia OPERACAO_CAMPO** |
| A01 | TALHAO_SAFRA | OPERACAO_CAMPO | 1:N | operacao.talhao_safra_id | Tracejada verde | Grossa | DESENHAR |
| A02 | OPERACAO_CAMPO | PLANTIO_DETALHE | 1:0..1 | plantio_det.operacao_id | Solida amarela | Media | DESENHAR |
| A03 | OPERACAO_CAMPO | COLHEITA_DETALHE | 1:0..1 | colheita_det.operacao_id | Solida amarela | Media | DESENHAR |
| A04 | OPERACAO_CAMPO | PULVERIZACAO_DETALHE | 1:0..1 | pulv_det.operacao_id | Solida amarela | Media | DESENHAR |
| A05 | OPERACAO_CAMPO | DRONE_DETALHE | 1:0..1 | drone_det.operacao_id | Solida amarela | Media | DESENHAR |
| A06 | OPERACAO_CAMPO | TRANSPORTE_COLH_DET | 1:0..1 | transp_det.operacao_id | Solida amarela | Media | DESENHAR |
| **INTERNOS - Solo** |
| A07 | ANALISE_SOLO | RECOMENDACAO_ADUBACAO | 1:N | recomendacao.analise_id | Solida amarela | Media | DESENHAR |
| **EXTERNOS** |
| A08 | OPERACAO_CAMPO | MAQUINAS | N:1 | operacao.maquina_id | Solida ciano | Media | DESENHAR |
| A09 | OPERACAO_CAMPO | OPERADORES | N:1 | operacao.operador_id | Solida ciano | Media | DESENHAR |
| A10 | TRANSPORTE_COLH_DET | TICKET_BALANCA | 1:1 | transp_det.ticket_balanca_id | Tracejada amarela | Media | DESENHAR |
| A11 | TRANSPORTE_COLH_DET | OPERACAO_CAMPO (colh) | N:1 | transp_det.colheita_origem_id | Solida amarela | Fina | DESENHAR |
| A12 | ANALISE_SOLO | TALHOES | N:1 | analise.talhao_id | Tracejada verde | Media | DESENHAR |
| A13 | RECOMENDACAO_ADUB | CULTURAS | N:1 | recomendacao.cultura_id | Tracejada verde | Fina | DESENHAR |
| **REDUNDANTES (nao desenhar)** |
| ~~ | OPERACAO_CAMPO | FAZENDAS | N:1 | operacao.fazenda_id | ~~ | ~~ | REDUNDANTE (via TALHAO_SAFRA) |
| ~~ | PULVERIZACAO_DET | RECEITUARIO_AGRO | N:1 | pulv.receituario_id | ~~ | ~~ | REDUNDANTE (via APLICACAO_INSUMO) |
| ~~ | PULVERIZACAO_DET | PRODUTO_INSUMO | N:1 | pulv.insumo_id | ~~ | ~~ | REDUNDANTE (Doc 17 R29) |
| ~~ | DRONE_DETALHE | PRODUTO_INSUMO | N:1 | drone.insumo_id | ~~ | ~~ | REDUNDANTE (Doc 17 R30) |

### Contagem

| Categoria | Quantidade |
|-----------|-----------|
| Desenhar no diagrama | **13** |
| Redundantes removidos | 4 |
| Org_id (convencao, nao desenhar) | 3 |
| Ja mapeados em Doc 17 (referencia cruzada) | 5 |
| **Total analisado** | **25** |

### Entidade Mais Conectada: OPERACAO_CAMPO (9 relacoes)

| Direcao | Relacoes |
|---------|---------|
| Como PAI (1:N / 1:0..1) | 5 filhos (Plantio, Colheita, Pulv, Drone, Transporte) + N Aplicacoes (Doc 17) |
| Como FILHO (N:1) | TALHAO_SAFRA, MAQUINAS, OPERADORES |
| Auto-referencia | TRANSPORTE.colheita_origem_id (colheita -> transporte) |

---

## 9. Ordem de Desenho no Miro

### Fase 1: Esqueleto OPERACAO_CAMPO (10 min)

```
1. OPERACAO_CAMPO (centro do frame)
2. PLANTIO_DETALHE (abaixo-esquerda)
3. COLHEITA_DETALHE (abaixo-centro-esquerda)
4. PULVERIZACAO_DETALHE (abaixo-centro-direita)
5. DRONE_DETALHE (abaixo-direita)
6. TRANSPORTE_COLHEITA_DETALHE (abaixo-extremo-direita)

Conectores internos:
A02: OPERACAO -> PLANTIO_DET (vertical para baixo)
A03: OPERACAO -> COLHEITA_DET (vertical para baixo)
A04: OPERACAO -> PULVERIZACAO_DET (vertical para baixo)
A05: OPERACAO -> DRONE_DET (vertical para baixo)
A06: OPERACAO -> TRANSPORTE_DET (vertical para baixo)
A11: TRANSPORTE_DET -> OPERACAO (colheita) (curva interna)
```

### Fase 2: Solo (5 min)

```
7. ANALISE_SOLO (separado, lateral direita)
8. RECOMENDACAO_ADUBACAO (abaixo de ANALISE_SOLO)

Conector:
A07: ANALISE_SOLO -> RECOMENDACAO_ADUBACAO (vertical para baixo)
```

### Fase 3: Conectores Externos (5 min)

```
A01: TALHAO_SAFRA -> OPERACAO_CAMPO (tracejada verde, para cima)
A08: OPERACAO_CAMPO -> MAQUINAS (solida ciano, lateral)
A09: OPERACAO_CAMPO -> OPERADORES (solida ciano, lateral)
A10: TRANSPORTE_DET -> TICKET_BALANCA (tracejada amarela, para UBG)
A12: ANALISE_SOLO -> TALHOES (tracejada verde, para cima)
A13: RECOMENDACAO_ADUB -> CULTURAS (tracejada verde, para cima)
```

---

## 10. Fluxo Completo da Safra (Referencia)

```
SAFRA INICIA (Jul)
      │
      ▼
ANALISE_SOLO (coleta, envia laboratorio)
      │
      ▼
RECOMENDACAO_ADUBACAO (Alessandro prescreve N, P, K, calagem)
      │
      ▼
OPERACAO_CAMPO (tipo=calagem/gessagem) + APLICACAO_INSUMO
      │
      ▼
OPERACAO_CAMPO (tipo=aracao/gradagem/subsolagem) ← preparo de solo
      │
      ▼
OPERACAO_CAMPO (tipo=dessecacao_pre_plantio) + APLICACAO_INSUMO + RECEITUARIO
      │
      ▼
OPERACAO_CAMPO (tipo=plantio) + PLANTIO_DETALHE + APLICACAO_INSUMO (semente+adubo+trat.sementes)
      │
      ▼
OPERACAO_CAMPO (tipo=pulverizacao_*) + PULVERIZACAO_DETALHE + APLICACAO_INSUMO + RECEITUARIO
      │  (repete N vezes ao longo do ciclo: herbicida, inseticida, fungicida, foliar)
      │
      ▼
OPERACAO_CAMPO (tipo=adubacao_cobertura) + APLICACAO_INSUMO
      │
      ▼
OPERACAO_CAMPO (tipo=colheita) + COLHEITA_DETALHE
      │
      ▼
OPERACAO_CAMPO (tipo=transporte_interno) + TRANSPORTE_COLHEITA_DETALHE
      │                                            │
      │                                            └──► TICKET_BALANCA (UBG)
      ▼
SAFRA ENCERRA (Jun)
```

---

*Documento gerado em 10/02/2026 - DeepWork AI Flows*
*13 relacionamentos para desenhar, 4 redundantes removidos, 25 total analisado*
