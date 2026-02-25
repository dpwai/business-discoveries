# RELACIONAMENTOS COMPLETOS - Modulo UBG

**Data:** 11/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGCOBuw4=/ (frame isolado) + https://miro.com/app/board/uXjVGE__XFQ= (board principal)
**Referencia:** Doc 08 (Estrutura ER), Doc 10 (UBG Fluxo Pos-Colheita), Doc 17, Doc 19, Doc 21

---

## 1. Escopo do Modulo

### Entidades Mapeadas (9 UBG + 2 Sistema)

```
UBG ──────────────── Estrutura fisica (capacidade, secador, balanca, responsavel tecnico)
SILOS ────────────── Silos individuais (8 total: 7 convencionais + 1 sementes)
TICKET_BALANCA ───── Pesagem na chegada (peso bruto, tara, liquido, placa)
RECEBIMENTO_GRAO ── Recepcao + classificacao (umidade, PH, impurezas, descontos)
CONTROLE_SECAGEM ── Monitoramento secagem (leituras 30min, temp, lenha m3, I.N.029/2011)
ESTOQUE_SILO ─────── Posicao de estoque por silo (virtual vs real, umidade, temperatura)
MOVIMENTACAO_SILO ── Movimentacao entre silos (transferencia, secagem, aeracao)
SAIDA_GRAO ────────── Saidas (venda, transferencia, consumo/racao, plantio interno)
QUEBRA_PRODUCAO ──── Perdas (secagem, armazenagem, transporte) — virtual vs real
CUSTOM_FORMS ─────── Formularios customizados (Sistema layer, alojado no frame UBG)
FORM_ENTRIES ──────── Respostas dos formularios
```

### IMPORTANTE: Reconciliacao de Nomes (Doc 08 vs Doc 10)

| Doc 08 (Adjacencia Atual) | Doc 10 (Campo-Validado) | Acao |
|---------------------------|------------------------|------|
| ENTRADA_GRAO | RECEBIMENTO_GRAO | **RENAME** (Doc 10 mais preciso) |
| CLASSIFICACAO_GRAO | (mergido em RECEBIMENTO_GRAO) | **DROP** — campos de classificacao vivem em RECEBIMENTO |
| (nao existe) | UBG | **ADD** — entidade fisica da unidade |
| (nao existe) | CONTROLE_SECAGEM | **ADD** — leituras de secagem (I.N.029/2011) |
| (nao existe) | QUEBRA_PRODUCAO | **ADD** — apuracao de perdas |
| ESTOQUE_SILO | ESTOQUE_SILO | Manter (singular por convencao) |
| SAIDA_GRAO | SAIDA_GRAO | Manter (singular por convencao) |

> **Nota:** Doc 10 usa plurais (ESTOQUE_SILOS, SAIDAS_GRAOS). Padrao ER = singular UPPER_SNAKE_CASE. Corrigido aqui.

### Estado Atual no Miro (capturado via API 11/02/2026)

**Board:** uXjVGCOBuw4= (frame isolado para UBG)
**Frame:** ENTIDADE UBG (ID: 3458764659474067538)
**Posicao:** (-7974, -1264) | **Tamanho:** 5035 x 4517
**11 shapes + 1 image (logo) + 1 text label**
**9 connectors (all exist, linear flow + custom forms)**

### Mapa de Conexoes

```
                                    ┌───────────┐
                                    │    UBG    │──── FAZENDAS (fazenda_sede_id)
                                    └──┬─────┬──┘
                              contem │       │ recebe
                                     ▼       ▼
                              ┌────────┐  ┌──────────────┐
                              │ SILOS  │  │TICKET_BALANCA│──── OPERACAO_CAMPO (colheita)
                              │(8 und) │  │              │──── OPERADORES
                              └───┬────┘  └──────┬───────┘
                             silo_id│      classifica│ 1:1
                                   │               ▼
                                   │     ┌──────────────────┐
                                   │     │ RECEBIMENTO_GRAO │──── TALHAO_SAFRA
                                   │     │ (umid,PH,impureza│──── CULTURAS (*)
                                   │     └────────┬─────────┘
                                   │          seca │ 1:N
                                   │               ▼
                                   │     ┌──────────────────┐
                                   │     │CONTROLE_SECAGEM  │     LENHA = PRODUTO_INSUMO
                                   │     │(30min, temp, m3) │     (lenha_m3 = consumo)
                                   │     └────────┬─────────┘
                                   │        armazena│
                                   ▼               ▼
                              ┌────────────────────────┐
                              │     ESTOQUE_SILO       │──── CULTURAS
                              │ (virtual vs real, lote) │──── SAFRAS
                              └──┬──────┬──────┬───────┘
                            sai  │  move│  apura│
                                 ▼      ▼      ▼
                        ┌──────────┐ ┌────────┐ ┌──────────┐
                        │SAIDA_GRAO│ │MOVIM.  │ │ QUEBRA   │
                        │          │ │ _SILO  │ │_PRODUCAO │
                        │parceiro  │ │origem  │ │          │
                        │nota_fisc │ │destino │ │          │
                        │tipo_dest:│ │(SILOS) │ │          │
                        │•commodit │ └────────┘ └──────────┘
                        │•sementes │
                        │•RACAO ◄──── PECUARIA (fabrica racao)
                        │•plantio  │
                        └──────────┘

    ┌──────────────┐  ┌──────────────┐
    │ CUSTOM_FORMS │──│ FORM_ENTRIES │  (Sistema layer)
    └──────────────┘  └──────────────┘
```

---

## 2. Relacionamentos Internos (9 on board + 4 missing)

---

### U01: UBG -> SILOS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `silos.ubg_id` -> `ubg.id` |
| **Card.** | 1:N (uma UBG contem 8 silos) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Board** | EXISTS ("contem") |

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### U02: UBG <- TICKET_BALANCA

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `ticket_balanca.ubg_id` -> `ubg.id` |
| **Card.** | 1:N |
| **Obrigatoria** | Sim |
| **Board** | EXISTS ("recebe") |

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### U03: TICKET_BALANCA -> RECEBIMENTO_GRAO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `recebimento_grao.ticket_balanca_id` -> `ticket_balanca.id` |
| **Card.** | 1:1 (cada ticket gera exatamente um recebimento) |
| **Obrigatoria** | Sim |
| **ON DELETE** | CASCADE |
| **Board** | EXISTS ("classifica") |

**Por que funciona:** O ticket registra PESO. O recebimento registra QUALIDADE (umidade, PH, impureza, ardido, avariado, verde, quebrado — amostra padrao 200g). Sao dois atos sequenciais: primeiro pesa, depois classifica. Os descontos de umidade e impureza sao calculados no RECEBIMENTO_GRAO, gerando o peso_liquido_final.

---

### U04: RECEBIMENTO_GRAO -> CONTROLE_SECAGEM

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `controle_secagem.recebimento_id` -> `recebimento_grao.id` |
| **Card.** | 1:N (um recebimento pode ter N leituras de secagem, a cada 30min) |
| **Obrigatoria** | Sim |
| **ON DELETE** | CASCADE |
| **Board** | EXISTS ("seca") |

**Por que funciona:** Nem todo lote precisa de secagem (se umidade ja esta <14% para soja). Quando precisa, o grao passa pelo secador e gera N leituras a cada 30 minutos: umidade entrada/saida, temperaturas P1/P2/P3, temperatura do grao, consumo de lenha (m3). Atende I.N. 029/2011 do MAPA. Campo `tipo_secagem`: total, parcial, ressecagem.

---

### U05: SILOS <- ESTOQUE_SILO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `estoque_silo.silo_id` -> `silos.id` |
| **Card.** | 1:N (um silo pode ter multiplos lotes/culturas em estoque) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Board** | **NAO EXISTE — criar** |

**Por que funciona:** ESTOQUE_SILO e a posicao de estoque dentro de um silo especifico. Silo 3 pode ter: 120 ton soja safra 25/26 + 30 ton feijao safra 25/26. Cada registro = 1 cultura + 1 safra + 1 silo.

**Dijkstra:** Sem caminho alternativo ESTOQUE → SILOS. **ESSENCIAL.**

---

### U06: ESTOQUE_SILO -> SAIDA_GRAO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `saida_grao.estoque_silo_id` -> `estoque_silo.id` |
| **Card.** | 1:N |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Board** | EXISTS ("sai") |

**Por que funciona:** Toda saida deduz de um estoque especifico. Tipos de destino (ENUM): commodities (venda Castrolanda/feijoeiros), sementes (bags certificadas), **racao** (pecuaria — fabrica racao), plantio_interno (sementes proprias proxima safra).

---

### U07: ESTOQUE_SILO -> MOVIMENTACAO_SILO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `movimentacao_silo.silo_origem_id` -> `silos.id` + `silo_destino_id` -> `silos.id` |
| **Card.** | 1:N (um silo gera muitas movimentacoes) |
| **Board** | EXISTS ("move") |

> **Nota tecnica:** O board mostra ESTOQUE → MOVIMENTACAO ("move"), mas os FKs reais sao MOVIMENTACAO → SILOS (origem e destino). O conector representa o fluxo de negocio, nao a direcao FK. No diagrama final, desenhar 2 linhas: MOVIMENTACAO → SILO_ORIGEM (N:1) e MOVIMENTACAO → SILO_DESTINO (N:1).

---

### U08: ESTOQUE_SILO -> QUEBRA_PRODUCAO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `quebra_producao.estoque_silo_id` -> `estoque_silo.id` |
| **Card.** | 1:N |
| **Obrigatoria** | Sim |
| **Board** | EXISTS ("apura") |

**Por que funciona:** Quebra = diferenca entre quantidade virtual (calculada por entradas - saidas) e quantidade real (medicao fisica). Tipos: secagem (~2-3%), armazenagem (~0.5-1%/mes), transporte. E o KPI de eficiencia da UBG.

---

### U09: CUSTOM_FORMS -> FORM_ENTRIES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `form_entries.form_id` -> `custom_forms.id` |
| **Card.** | 1:N |
| **Board** | EXISTS ("preenche") |

**Nota:** Entidades da Camada Sistema, alojadas no frame UBG. Genéricas — servem toda a plataforma.

---

## 3. Relacionamentos Externos (cross-frame)

---

### U10: UBG -> FAZENDAS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `ubg.fazenda_sede_id` -> `fazendas.id` |
| **Card.** | N:1 (UBG localizada em uma fazenda) |
| **Board** | NAO EXISTE — criar tracejada verde |
| **Label** | "sede" |

**Dijkstra:** Caminho unico. **ESSENCIAL.** UBG fica na Fazenda Santana do Iapo.

---

### U11: TICKET_BALANCA -> OPERACAO_CAMPO (colheita)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `ticket_balanca.operacao_campo_id` -> `operacao_campo.id` |
| **Card.** | N:1 (muitos tickets por colheita — diferentes viagens) |
| **Obrigatoria** | Nao (tickets de saida/transferencia nao tem colheita) |
| **Board** | NAO EXISTE — criar tracejada amarela |
| **Label** | "colheita origem" |

**Por que funciona:** PONTE AGRICULTURA → UBG. O ticket de entrada registra de qual colheita veio o grao. Complementa TRANSPORTE_COLHEITA_DETALHE.ticket_balanca_id (Doc 19, A10) — vinculo bidirecional.

**Dijkstra:** Via TRANSPORTE_COLHEITA_DETALHE: TICKET ← TRANSP_DET → OPERACAO_CAMPO = 2 hops via backref. Mas ticket.operacao_campo_id e direto (para tickets SEM transporte_detalhe). **ESSENCIAL.**

---

### U12: TICKET_BALANCA -> OPERADORES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `ticket_balanca.operador_id` -> `operadores.id` |
| **Card.** | N:1 |
| **Board** | NAO EXISTE — criar tracejada ciano |
| **Label** | "operador balanca" |

---

### U13: RECEBIMENTO_GRAO -> TALHAO_SAFRA

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `recebimento_grao.talhao_safra_id` -> `talhao_safra.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar tracejada verde |
| **Label** | "talhao+safra" |

**Por que funciona:** Rastreabilidade de origem: "este lote de soja veio do Talhao Bonin, safra 25/26". Permite calcular produtividade real por talhao comparando peso colhido (COLHEITA_DETALHE) vs peso recebido na UBG (apos descontos).

---

### U14: ESTOQUE_SILO -> CULTURAS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `estoque_silo.cultura_id` -> `culturas.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar tracejada verde |
| **Label** | "cultura" |

---

### U15: ESTOQUE_SILO -> SAFRAS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `estoque_silo.safra_id` -> `safras.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Sim |
| **Board** | NAO EXISTE — criar tracejada verde |
| **Label** | "safra" |

---

### U16: SAIDA_GRAO -> PARCEIRO_COMERCIAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `saida_grao.parceiro_id` -> `parceiro_comercial.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Nao (saida interna/racao nao tem parceiro) |
| **Board** | NAO EXISTE — criar tracejada verde |
| **Label** | "comprador" |

---

### U17: SAIDA_GRAO -> NOTA_FISCAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `saida_grao.nota_fiscal_id` -> `nota_fiscal.id` |
| **Card.** | N:1 |
| **Obrigatoria** | Nao (saida interna = sem NF) |
| **Board** | NAO EXISTE — criar tracejada laranja |
| **Label** | "nf saida" |

---

## 4. Analise de Redundancia (Dijkstra)

### Redundantes — NAO Desenhar

| FK Removido | Caminho Alternativo | Hops | Pattern |
|------------|-------------------|------|---------|
| RECEBIMENTO_GRAO.ubg_id → UBG | RECEBIMENTO → TICKET → UBG | 2 | Transitive closure |
| RECEBIMENTO_GRAO.cultura_id → CULTURAS | RECEBIMENTO → TALHAO_SAFRA → CULTURAS | 2 | Transitive closure |
| SAIDA_GRAO.cultura_id → CULTURAS | SAIDA → ESTOQUE_SILO → CULTURAS | 2 | Transitive closure |
| QUEBRA_PRODUCAO.cultura_id → CULTURAS | QUEBRA → ESTOQUE_SILO → CULTURAS | 2 | Transitive closure |
| QUEBRA_PRODUCAO.safra_id → SAFRAS | QUEBRA → ESTOQUE_SILO → SAFRAS | 2 | Transitive closure |
| TICKET_BALANCA → FAZENDAS | TICKET → UBG → FAZENDAS | 2 | Transitive closure |

### DDL Denormalization (nao no diagrama, comentar no DDL)

| FK | Justificativa DDL | Derivavel Via |
|----|-------------------|---------------|
| CONTROLE_SECAGEM.ubg_id | Performance: filtrar secagens por UBG | SECAGEM → RECEBIMENTO → TICKET → UBG (3 hops) |
| MOVIMENTACAO_SILO.cultura_id | Saber o que moveu sem JOIN | MOVIM → SILO → ESTOQUE_SILO → CULTURAS (backref, complexo) |
| RECEBIMENTO_GRAO.responsavel_id → OPERADORES | Pode ser mesma pessoa do ticket | RECEBIMENTO → TICKET → OPERADORES (2 hops) |

### Org_id (NAO desenhar)

Todos os 9+2 entidades carregam `organization_id` mas nao e desenhado.

---

## 5. LENHA — Fluxo Madeira para Secagem

> **Contexto:** O secador de graos usa lenha (eucalipto) como combustivel. CONTROLE_SECAGEM.lenha_m3 registra o consumo por leitura. Joao (CTO) mencionou na reuniao 11/02/2026 que LENHA precisa de rastreabilidade.

### Modelo Proposto

```
PRODUTO_INSUMO (tipo = 'lenha')
      │
      ├── COMPRA_INSUMO (quando comprada de terceiros)
      │       └── NOTA_FISCAL_ITEM
      │
      └── ESTOQUE_INSUMO (estoque de lenha na UBG)
              │
              └── MOVIMENTACAO_INSUMO (tipo = 'saida_secagem')
                      │
                      └──► CONTROLE_SECAGEM.lenha_m3 (consumo registrado)
```

**NAO precisa de FK direto CONTROLE_SECAGEM → PRODUTO_INSUMO.** O consumo e registrado como quantidade (m3) no CONTROLE_SECAGEM. O vinculo ao estoque e feito via MOVIMENTACAO_INSUMO (tipo=saida_secagem) que referencia o ESTOQUE_INSUMO de lenha. O custo flui via CUSTO_OPERACAO (tipo=secagem) → CENTRO_CUSTO (01.01.810.02 Secagem).

**Questao aberta:** CONTROLE_SECAGEM precisa de FK para MOVIMENTACAO_INSUMO? Ou o vinculo e apenas temporal (mesmo dia/periodo)?

---

## 6. RACAO — Fluxo Graos para Pecuaria

> **Contexto:** SAIDA_GRAO.tipo_destino = 'racao' — graos saem do silo para virar racao animal. SOAL tem fabrica de racao propria.

### Modelo Proposto

```
ESTOQUE_SILO (soja/milho/farelo)
      │
      └── SAIDA_GRAO (tipo_destino = 'racao')
              │
              └──► [FABRICA RACAO — processo de moagem/mistura]
                      │
                      └──► DIETA_INGREDIENTE (Pecuaria)
                              │
                              └──► TRATO_ALIMENTAR → LOTE_ANIMAL
```

**Conexoes a criar quando Pecuaria for mapeado:**
1. SAIDA_GRAO → DIETA_INGREDIENTE? Ou via PRODUTO_INSUMO intermediario?
2. Existe entidade FABRICA_RACAO ou o processo e simplificado (saida silo → direto para cocho)?
3. O grao sai como PRODUTO_INSUMO (tipo=grao_racao) e entra no fluxo ESTOQUE_INSUMO da pecuaria?

**Questao para Claudio:** Como funciona o processo: grao sai do silo → moagem → mistura → cocho? Ou vai direto?

---

## 7. Referencia Cruzada com Docs Anteriores

| Doc | Relacao | Relevancia para UBG |
|-----|---------|---------------------|
| Doc 19 A10 | TRANSPORTE_COLHEITA_DETALHE → TICKET_BALANCA | Transporte campo→UBG gera ticket |
| Doc 19 A11 | TRANSPORTE_DET → OPERACAO_CAMPO (colheita) | Origem da carga |
| Doc 21 F18 | CONTRATO_ENTREGA → TICKET_BALANCA | Entrega contratual usa pesagem UBG |
| Doc 21 F19 | CONTRATO_ENTREGA → SAIDA_GRAO | Entrega vinculada a saida de silo |
| Doc 17 | COMPRA_INSUMO → PRODUTO_INSUMO | Compra de lenha entra pelo fluxo de insumos |

---

## 8. Questoes Abertas

| # | Questao | Impacto | Quem Decide |
|---|---------|---------|-------------|
| 1 | CLASSIFICACAO_GRAO existe como entidade separada ou mergida em RECEBIMENTO_GRAO? | Doc 08 tem separado, Doc 10 mergiu. Precisa confirmar com Joao. | Joao |
| 2 | CONTROLE_SECAGEM → MOVIMENTACAO_INSUMO (lenha) FK direto? | Rastreabilidade lenha consumption vs stock | Joao + Rodrigo |
| 3 | Entidade FABRICA_RACAO necessaria? | Se processo de moagem/mistura e rastreado, precisa entidade. Se simplificado, SAIDA_GRAO.tipo_destino='racao' e suficiente. | Claudio |
| 4 | SAIDA_GRAO → DIETA_INGREDIENTE ou via PRODUTO_INSUMO? | Como grao vira ingrediente de racao | Claudio + Alessandro |
| 5 | Leomar (engenheiro) — software do secador integravel? | Se sim, CONTROLE_SECAGEM pode ser alimentado automaticamente | Leomar + Joao |
| 6 | UBG atende apenas Santana ou tambem fazendas terceiras? | Se terceiras, TICKET_BALANCA precisa de fazenda_origem_id | Claudio |
| 7 | Silo de sementes/madeira — como funciona? E um silo multiuso? | Impacta SILOS.tipo ENUM values | Claudio |

---

## 9. Tabela Resumo Total

| # | De | Para | Card. | FK Em | Status Board | Status Doc |
|---|-----|------|-------|-------|-------------|-----------|
| **INTERNOS (9 on board)** |
| U01 | UBG | SILOS | 1:N | silos.ubg_id | EXISTS | DESENHAR |
| U02 | UBG | TICKET_BALANCA | 1:N | ticket.ubg_id | EXISTS | DESENHAR |
| U03 | TICKET_BALANCA | RECEBIMENTO_GRAO | 1:1 | receb.ticket_id | EXISTS | DESENHAR |
| U04 | RECEBIMENTO_GRAO | CONTROLE_SECAGEM | 1:N | secagem.receb_id | EXISTS | DESENHAR |
| U05 | ESTOQUE_SILO | SAIDA_GRAO | 1:N | saida.estoque_id | EXISTS | DESENHAR |
| U06 | ESTOQUE_SILO | MOVIMENTACAO_SILO | 1:N | (ver nota U07) | EXISTS | REDESENHAR |
| U07 | ESTOQUE_SILO | QUEBRA_PRODUCAO | 1:N | quebra.estoque_id | EXISTS | DESENHAR |
| U08 | MOVIMENTACAO_SILO | SILOS(origem) | N:1 | movim.silo_origem_id | (parte do U06) | SEPARAR |
| U09 | MOVIMENTACAO_SILO | SILOS(destino) | N:1 | movim.silo_destino_id | (parte do U06) | SEPARAR |
| U10 | CUSTOM_FORMS | FORM_ENTRIES | 1:N | entry.form_id | EXISTS | DESENHAR |
| **INTERNOS FALTANTES (4 novos)** |
| U11 | SILOS | ESTOQUE_SILO | 1:N | estoque.silo_id | NEW | DESENHAR |
| U12 | ESTOQUE_SILO | CULTURAS | N:1 | estoque.cultura_id | NEW | DESENHAR |
| U13 | ESTOQUE_SILO | SAFRAS | N:1 | estoque.safra_id | NEW | DESENHAR |
| U14 | CONTROLE_SECAGEM | ESTOQUE_SILO | N:1 | (armazena apos secagem) | (implicit in flow) | AVALIAR |
| **EXTERNOS (8 novos)** |
| U15 | UBG | FAZENDAS | N:1 | ubg.fazenda_sede_id | NEW | DESENHAR |
| U16 | TICKET_BALANCA | OPERACAO_CAMPO | N:1 | ticket.operacao_campo_id | NEW | DESENHAR |
| U17 | TICKET_BALANCA | OPERADORES | N:1 | ticket.operador_id | NEW | DESENHAR |
| U18 | RECEBIMENTO_GRAO | TALHAO_SAFRA | N:1 | receb.talhao_safra_id | NEW | DESENHAR |
| U19 | SAIDA_GRAO | PARCEIRO_COMERCIAL | N:1 | saida.parceiro_id | NEW | DESENHAR |
| U20 | SAIDA_GRAO | NOTA_FISCAL | N:1 | saida.nota_fiscal_id | NEW | DESENHAR |
| U21 | SAIDA_GRAO | OPERADORES | N:1 | saida.operador_id | NEW | DESENHAR |
| U22 | MOVIMENTACAO_SILO | OPERADORES | N:1 | movim.operador_id | NEW | DESENHAR |
| **REDUNDANTES** |
| ~~ | RECEBIMENTO_GRAO | UBG | N:1 | ~~ | ~~ | REDUNDANTE (2h via TICKET) |
| ~~ | RECEBIMENTO_GRAO | CULTURAS | N:1 | ~~ | ~~ | REDUNDANTE (2h via TALHAO_SAFRA) |
| ~~ | SAIDA_GRAO | CULTURAS | N:1 | ~~ | ~~ | REDUNDANTE (2h via ESTOQUE) |
| ~~ | QUEBRA_PRODUCAO | CULTURAS | N:1 | ~~ | ~~ | REDUNDANTE (2h via ESTOQUE) |
| ~~ | QUEBRA_PRODUCAO | SAFRAS | N:1 | ~~ | ~~ | REDUNDANTE (2h via ESTOQUE) |
| ~~ | TICKET_BALANCA | FAZENDAS | N:1 | ~~ | ~~ | REDUNDANTE (2h via UBG) |

### Contagem

| Categoria | Quantidade |
|-----------|-----------|
| Desenhar no diagrama | **22** (9 existem + 2 redesenhar + 11 novos) |
| Redundantes removidos (Dijkstra) | 6 |
| DDL-only denormalization | 3 |
| Org_id (convencao, nao desenhar) | 11 |
| Ja mapeados em outros Docs | 5 |
| Questoes abertas | 7 |
| **Total analisado** | **~54** |

---

## 10. Grafo de Adjacencia Atualizado

### Antes (Doc 08 names, com TODOs)

```
TICKET_BALANCA → [FAZENDAS]                          # TODO
ENTRADA_GRAO → [TICKET_BALANCA]
CLASSIFICACAO_GRAO → [ENTRADA_GRAO]
ESTOQUE_SILO → [SILOS, CULTURAS, SAFRAS]
MOVIMENTACAO_SILO → [ESTOQUE_SILO]
SAIDA_GRAO → [ESTOQUE_SILO, NOTA_FISCAL*]
```

### Depois (Doc 10 names, validado Doc 22)

```
# ═══ CAMADA AGRICOLA (UBG/Silos - Doc 22) ═══
UBG → [FAZENDAS]                                             # NEW entity (M05)
SILOS → [UBG]                                                # UPDATED: was [FAZENDAS]
TICKET_BALANCA → [UBG, OPERACAO_CAMPO*, OPERADORES]          # UPDATED: replaced FAZENDAS with UBG
RECEBIMENTO_GRAO → [TICKET_BALANCA, TALHAO_SAFRA]           # RENAMED from ENTRADA_GRAO, +TALHAO_SAFRA
# CLASSIFICACAO_GRAO → DROPPED (merged into RECEBIMENTO_GRAO)
CONTROLE_SECAGEM → [RECEBIMENTO_GRAO]                       # NEW entity
ESTOQUE_SILO → [SILOS, CULTURAS, SAFRAS]                    # VALIDATED (unchanged)
MOVIMENTACAO_SILO → [SILOS(origem), SILOS(destino), OPERADORES]  # CORRECTED: was [ESTOQUE_SILO]
SAIDA_GRAO → [ESTOQUE_SILO, PARCEIRO_COMERCIAL*, NOTA_FISCAL*, OPERADORES]  # UPDATED: +PARCEIRO, +OPERADORES
QUEBRA_PRODUCAO → [ESTOQUE_SILO, OPERADORES]                # NEW entity
CUSTOM_FORMS → []                                            # Sistema layer
FORM_ENTRIES → [CUSTOM_FORMS]                                # Sistema layer
```

---

## 11. Ordem de Desenho no Miro

### Fase 1: Validar 9 Conectores Existentes (10 min)

```
Verificar Crow's Foot em:
U01-U10 (todos existem). Corrigir:
- U06/U08/U09: Board mostra ESTOQUE→MOVIMENTACAO como 1 conector "move".
  Separar em: MOVIM→SILO_ORIGEM (N:1) + MOVIM→SILO_DESTINO (N:1)
```

### Fase 2: 4 Conectores Internos Faltantes (5 min)

```
U11: SILOS → ESTOQUE_SILO (1:N) — solida amarela, "silo"
U12: ESTOQUE_SILO → CULTURAS — tracejada verde, "cultura"
U13: ESTOQUE_SILO → SAFRAS — tracejada verde, "safra"
U14: CONTROLE_SECAGEM → ESTOQUE_SILO — avaliar se necessario
```

### Fase 3: 8 Conectores Externos (10 min)

```
U15: UBG → FAZENDAS — tracejada verde, "sede"
U16: TICKET_BALANCA → OPERACAO_CAMPO — tracejada amarela, "colheita origem"
U17: TICKET_BALANCA → OPERADORES — tracejada ciano, "operador"
U18: RECEBIMENTO_GRAO → TALHAO_SAFRA — tracejada verde, "talhao+safra"
U19: SAIDA_GRAO → PARCEIRO_COMERCIAL — tracejada verde, "comprador"
U20: SAIDA_GRAO → NOTA_FISCAL — tracejada laranja, "nf saida"
U21: SAIDA_GRAO → OPERADORES — tracejada ciano, "operador"
U22: MOVIMENTACAO_SILO → OPERADORES — tracejada ciano, "operador"
```

---

*Documento gerado em 11/02/2026 - DeepWork AI Flows*
*22 relacionamentos para desenhar (9 existem + 2 redesenhar + 11 novos), 6 redundantes removidos, ~54 total analisado*
*3 novas entidades vs Doc 08: UBG, CONTROLE_SECAGEM, QUEBRA_PRODUCAO. 1 rename: ENTRADA_GRAO → RECEBIMENTO_GRAO. 1 drop: CLASSIFICACAO_GRAO (merged).*
*Fluxos especiais documentados: LENHA (secagem) e RACAO (pecuaria)*
