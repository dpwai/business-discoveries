# RELACIONAMENTOS COMPLETOS - Modulo Maquinario

**Data:** 11/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=
**Referencia:** Doc 08 (Estrutura ER), Doc 09 (Operacoes Campo), Doc 17 (Consumo e Estoque), Doc 19 (Agricultura)

---

## 1. Escopo do Modulo

### Entidades Mapeadas (4)

```
MAQUINAS ──────────── Cadastro de equipamentos (tratores, colheitadeiras, pulverizadores, etc.)
OPERADORES ────────── Operadores de maquinas (CNH, habilitacao, certificacoes)
ABASTECIMENTOS ────── Registros de abastecimento (combustivel, horimetro, litros)
MANUTENCOES ───────── Registros de manutencao (preventiva, corretiva, preditiva)
```

### Entidades JA Mapeadas em Outros Docs (nao repetir)

- OPERACAO_CAMPO → MAQUINAS (Doc 19: A08)
- OPERACAO_CAMPO → OPERADORES (Doc 19: A09)
- APLICACAO_INSUMO → MANUTENCOES (Doc 17: contexto = manutencao)
- CUSTO_OPERACAO (Doc 17: tipo = mecanizacao)

### Estado Atual no Miro (capturado via API 11/02/2026)

**Frame:** Entidade maquinario (ID: 3458764658863284508)
**Posicao:** (16550, 20879) | **Tamanho:** 4158 x 2203
**Header:** "MECANIZACAO"

**Shapes no Board (4 entidades):**

| Shape ID | Entidade | Connectors |
|----------|----------|-----------|
| 3458764658641289787 | MAQUINAS | → ABASTECIMENTOS ("abastece"), → MANUTENCOES ("mantem") |
| 3458764658641289788 | OPERADORES | → ABASTECIMENTOS ("opera"), → MANUTENCOES ("responsavel"), → OPERACAO_CAMPO ("realiza") |
| 3458764658641289789 | ABASTECIMENTOS | Recebe de MAQUINAS e OPERADORES |
| 3458764658641289790 | MANUTENCOES | Recebe de MAQUINAS e OPERADORES |

**Anotacoes abertas no Board:**
- "Data onde foi feita nota fiscal ?, como funciona esse processo ?"
- "aqui nao seria um cargo / cargo ?"

### Mapa de Conexoes

```
                  FAZENDAS (Territorial)
                     │
                     │ N:1 (pertence a)
                     ▼
               ┌───────────┐
               │  MAQUINAS  │──────────────────────────────────────┐
               │            │                                      │
               │codigo_inter│    ┌────────────┐                    │
               │tipo, marca │    │ OPERADORES │                    │
               │placa       │    │            │                    │
               │horimetro   │    │ nome, cpf  │                    │
               └───┬────┬───┘    │ cnh_numero │                    │
                   │    │        └──┬─────┬───┘                    │
                   │    │           │     │                         │
          abastece │    │ mantem    │     │ responsavel             │
                   │    │        opera    │                         │
                   ▼    │           ▼     │                         │
            ┌──────────────┐  ┌──────────────┐                     │
            │ABASTECIMENTOS│  │ MANUTENCOES  │──► CENTRO_CUSTO     │
            │              │  │              │    (Financeiro)      │
            │maquina_id    │  │maquina_id    │                     │
            │operador_id   │  │responsavel_id│                     │
            │tipo_combust  │  │tipo (prev/   │                     │
            │qtd_litros    │  │ corr/pred)   │                     │
            │horimetro_mom │  │custo_total   │                     │
            └──────────────┘  └──────────────┘                     │
                                                                   │
                        OPERACAO_CAMPO (Agricultura) ◄─────────────┘
                           maquina_id (Doc 19, A08)
                           operador_id (Doc 19, A09)
```

---

## 2. Relacionamentos Internos (dentro do frame Maquinario)

Conectores DENTRO do frame. Todos usam **linha solida ciano (#ccf4ff)** com **Crow's Foot**.

---

### M01: MAQUINAS -> ABASTECIMENTOS

| Aspecto | Detalhe |
|---------|---------|
| **De** | MAQUINAS |
| **Para** | ABASTECIMENTOS |
| **Cardinalidade** | 1:N (uma maquina tem muitos abastecimentos ao longo do tempo) |
| **FK** | `abastecimentos.maquina_id` -> `maquinas.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida ciano. Media. |
| **Miro Label** | "abastece" |
| **Board Status** | JA EXISTE (Shape 787 → 789, caption: "abastece") |

**Por que funciona:** Cada abastecimento registra QUAL maquina foi abastecida. O horimetro_momento captura o hodometro/horimetro no ato do abastecimento, permitindo calcular consumo por hora trabalhada (L/h). Exemplo: Trator John Deere 6150J foi abastecido com 200L de diesel S10 quando o horimetro marcava 4.520h. Na proxima manutencao preventiva (a cada 500h), o sistema sabe que faltam 4.520 - 4.000 = 520h → ja passou.

**Dijkstra Validation:** Caminho unico MAQUINAS → ABASTECIMENTOS. Nenhum caminho alternativo existe. **ESSENCIAL.**

---

### M02: MAQUINAS -> MANUTENCOES

| Aspecto | Detalhe |
|---------|---------|
| **De** | MAQUINAS |
| **Para** | MANUTENCOES |
| **Cardinalidade** | 1:N (uma maquina tem muitas manutencoes) |
| **FK** | `manutencoes.maquina_id` -> `maquinas.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida ciano. Media. |
| **Miro Label** | "mantem" |
| **Board Status** | JA EXISTE (Shape 787 → 790, caption: "mantem") |

**Por que funciona:** Toda manutencao e de uma maquina especifica. Os tipos (preventiva, corretiva, preditiva) determinam o fluxo: preventiva e programada por horimetro/calendario, corretiva e emergencial (quebra), preditiva usa sensores/analise de oleo. O campo `custo_total` alimenta o CUSTO_OPERACAO (tipo: mecanizacao). O historico de manutencoes permite calcular TCO (Total Cost of Ownership) por maquina e decidir quando substituir.

**Dijkstra Validation:** Caminho unico MAQUINAS → MANUTENCOES. **ESSENCIAL.**

---

### M03: OPERADORES -> ABASTECIMENTOS

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERADORES |
| **Para** | ABASTECIMENTOS |
| **Cardinalidade** | 1:N (um operador faz muitos abastecimentos) |
| **FK** | `abastecimentos.operador_id` -> `operadores.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida ciano. Media. |
| **Miro Label** | "opera" |
| **Board Status** | JA EXISTE (Shape 788 → 789, caption: "opera") |

**Por que funciona:** Registra QUEM fez o abastecimento. Importante para: (1) controle de combustivel — quem abasteceu quanto, (2) auditoria — evita abastecimentos fantasma, (3) responsabilidade — se a maquina foi abastecida com combustivel errado, sabe quem fez. Na pratica, o operador vai ao tanque de diesel da fazenda, abastece, e registra no app/caderno.

**Dijkstra Validation:** OPERADORES → ABASTECIMENTOS. Sem caminho alternativo. **ESSENCIAL.**

---

### M04: OPERADORES -> MANUTENCOES

| Aspecto | Detalhe |
|---------|---------|
| **De** | OPERADORES |
| **Para** | MANUTENCOES |
| **Cardinalidade** | 1:N (um operador e responsavel por muitas manutencoes) |
| **FK** | `manutencoes.responsavel_id` -> `operadores.id` |
| **Obrigatoria** | Nao (manutencao terceirizada pode nao ter operador interno) |
| **ON DELETE** | SET NULL |
| **Miro Connector** | `──│────○<──` Linha solida ciano. Media. |
| **Miro Label** | "responsavel" |
| **Board Status** | JA EXISTE (Shape 788 → 790, caption: "responsavel") |

**Por que funciona:** Quem e o responsavel pela manutencao. Em manutencao preventiva (troca de oleo, filtros), normalmente e o proprio operador da maquina. Em manutencao corretiva (conserto de motor, eixo), pode ser um mecanico da fazenda ou terceirizado. FK opcional porque manutencoes terceirizadas (oficina externa) podem nao ter operador interno vinculado — nesse caso, o rastreamento e via NOTA_FISCAL/PARCEIRO_COMERCIAL.

**Dijkstra Validation:** OPERADORES → MANUTENCOES. Sem caminho alternativo. **ESSENCIAL.**

---

## 3. Relacionamentos Externos

Conectores que SAEM das entidades de Maquinario para outros modulos. Usam **linha tracejada** na cor do modulo destino.

---

### M05: MAQUINAS -> FAZENDAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | MAQUINAS |
| **Para** | FAZENDAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitas maquinas pertencem a mesma fazenda) |
| **FK** | `maquinas.fazenda_id` -> `fazendas.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──>────│──` Linha tracejada verde. Media. Cruza Operacional → Territorial. |
| **Miro Label** | "fazenda" |
| **Board Status** | NAO EXISTE — precisa criar |

**Por que funciona:** Cada maquina esta registrada em uma fazenda. Mesmo que uma organizacao tenha 3 fazendas (Sede, Bonin, Paiaguas), cada trator e alocado a uma fazenda especifica. Isso permite: (1) controle patrimonial por fazenda, (2) calcular custo de mecanizacao por fazenda, (3) saber onde a maquina esta fisicamente. Se uma maquina for emprestada temporariamente para outra fazenda, isso pode ser rastreado via OPERACAO_CAMPO (o talhao_safra indica a fazenda onde operou).

**Dijkstra Validation:**
```
Remover MAQUINAS → FAZENDAS. Buscar caminho alternativo.
MAQUINAS ← OPERACAO_CAMPO (backref via maquina_id) → TALHAO_SAFRA → TALHOES → FAZENDAS
Caminho: 4 hops via backref. NAO e forward path.
Nenhum caminho forward MAQUINAS → ... → FAZENDAS existe sem este FK.
Resultado: ESSENCIAL. Desenhar.
```

---

### M06: MANUTENCOES -> CENTRO_CUSTO

| Aspecto | Detalhe |
|---------|---------|
| **De** | MANUTENCOES |
| **Para** | CENTRO_CUSTO (Frame 9: Financeiro) |
| **Cardinalidade** | N:1 (muitas manutencoes alocadas ao mesmo centro de custo) |
| **FK** | `manutencoes.centro_custo_id` -> `centro_custo.id` |
| **Obrigatoria** | Nao (pode registrar manutencao antes de alocar custo) |
| **ON DELETE** | SET NULL |
| **Miro Connector** | `──>────│──` Linha tracejada laranja. Media. Cruza Operacional → Financeiro. |
| **Miro Label** | "custo" |
| **Board Status** | NAO EXISTE — precisa criar |

**Por que funciona:** Manutencao e um dos maiores custos operacionais da fazenda. O CENTRO_CUSTO hierarquico (Doc 13) permite alocar: "Esta troca de motor de R$15.000 vai para Fazenda Sede → Maquinario → Manutencao Corretiva → Colheitadeira". Sem essa FK, nao consegue calcular o custo de mecanizacao por ha (um dos KPIs mais criticos da gestao agricola).

**Dijkstra Validation:**
```
Remover MANUTENCOES → CENTRO_CUSTO. Buscar alternativa.
MANUTENCOES → MAQUINAS → FAZENDAS → ... nao chega em CENTRO_CUSTO.
MANUTENCOES ← APLICACAO_INSUMO (backref) → CUSTO_OPERACAO → CENTRO_CUSTO = 3 hops via backref.
Nenhum forward path existe.
Resultado: ESSENCIAL. Desenhar.
```

---

## 4. Analise de Redundancia (Dijkstra)

### Principio Aplicado

> Para cada FK proposto, tracar o caminho mais curto no grafo de adjacencia. Se path ≤ 2 hops existe via outros edges, o FK e REDUNDANTE para o diagrama.

### Redundancias Identificadas

| FK Avaliado | Caminho Alternativo (sem este FK) | Hops | Resultado | Acao |
|------------|----------------------------------|------|-----------|------|
| ABASTECIMENTOS → FAZENDAS | ABASTECIMENTOS → MAQUINAS → FAZENDAS | **2** | REDUNDANTE | NAO desenhar. Derivavel via maquina. |
| MANUTENCOES → FAZENDAS | MANUTENCOES → MAQUINAS → FAZENDAS | **2** | REDUNDANTE | NAO desenhar. Derivavel via maquina. |
| OPERADORES → FAZENDAS | Sem forward path (operador pode atuar em multiplas fazendas) | — | VER NOTA | Depende de decisao de negocio. Ver Questoes Abertas. |

**Nota sobre OPERADORES → FAZENDAS:** No modelo atual, OPERADORES nao tem `fazenda_id`. Operadores pertencem a `organization_id` (nivel organizacao) e podem operar maquinas em qualquer fazenda da org. A fazenda onde o operador trabalhou e derivavel via OPERACAO_CAMPO.operador_id + talhao_safra → talhoes → fazendas. Se for necessario "fazenda base" do operador (onde e alocado), isso e um campo informativo, nao uma FK essencial para o diagrama.

### Org_id (NAO desenhar — convencao do board)

| Entidade | FK | Derivavel Via |
|----------|-----|--------------|
| MAQUINAS | organization_id | fazendas → organizations |
| OPERADORES | organization_id | Raiz (sem outro caminho, mas convencao nao desenhar) |
| ABASTECIMENTOS | organization_id | maquinas → fazendas → organizations |
| MANUTENCOES | organization_id | maquinas → fazendas → organizations |

---

## 5. Referencia Cruzada com Docs Anteriores

Relacionamentos que JA conectam entidades deste modulo mas foram mapeados em outros documentos:

| Doc # | Relacao # | Relacionamento | Direcao | Relevancia para Maquinario |
|-------|-----------|---------------|---------|---------------------------|
| Doc 19 | A08 | OPERACAO_CAMPO → MAQUINAS (N:1) | Agricultura → Maquinario | Toda operacao de campo usa uma maquina; permite calcular horas de uso, consumo, custo de mecanizacao |
| Doc 19 | A09 | OPERACAO_CAMPO → OPERADORES (N:1) | Agricultura → Maquinario | Quem operou a maquina; permite calcular rendimento por operador (ha/hora) |
| Doc 17 | — | APLICACAO_INSUMO.manutencao_id → MANUTENCOES | Consumo → Maquinario | Quando manutencao consome insumos (oleo, filtros, pecas), registra via APLICACAO_INSUMO (contexto=manutencao) |
| Doc 17 | — | CUSTO_OPERACAO (tipo=mecanizacao) | Financeiro → conceitual | Custo de mecanizacao por operacao, derivado de horas-maquina + manutencao + combustivel |

---

## 6. Questoes Abertas

| # | Questao | Fonte | Impacto | Quem Decide |
|---|---------|-------|---------|-------------|
| 1 | "aqui nao seria um cargo / cargo ?" | Board (Frame 6) | OPERADORES.cargo e atributo (VARCHAR) ou entidade separada CARGO com hierarquia? Se entidade: OPERADORES.cargo_id → CARGO. Se atributo: campo texto simples. | Joao + Rodrigo |
| 2 | "Data onde foi feita nota fiscal ?, como funciona esse processo ?" | Board (Frame 6) | Como NF de compra de combustivel/pecas liga a ABASTECIMENTOS/MANUTENCOES? Opcoes: (a) ABASTECIMENTOS → NOTA_FISCAL direto, (b) via COMPRA_INSUMO → NOTA_FISCAL_ITEM (se combustivel entra no catalogo PRODUTO_INSUMO), (c) sem FK — NF e controlada pelo financeiro separadamente. | Claudio + Tiago + Valentina |
| 3 | ABASTECIMENTOS precisa de FK para ESTOQUE_INSUMO? | Analise Doc 15 | Se combustivel e rastreado como PRODUTO_INSUMO (tipo=combustivel) no estoque, cada abastecimento deveria gerar MOVIMENTACAO_INSUMO (tipo: saida_abastecimento) e deduzir ESTOQUE_INSUMO. Isso criaria: ABASTECIMENTOS → MOVIMENTACAO_INSUMO (1:1). Fluxo: compra diesel → ESTOQUE_INSUMO → abastecimento → MOVIMENTACAO_INSUMO (saida). | Joao + Rodrigo |
| 4 | ABASTECIMENTOS precisa de CENTRO_CUSTO direto? | Analise financeira | Custo de combustivel pode fluir via: (a) direto: ABASTECIMENTOS.centro_custo_id, (b) indireto: quantidade_litros × preco_litro → CUSTO_OPERACAO (tipo: mecanizacao) → CENTRO_CUSTO. Opcao (b) evita FK redundante mas requer logica de calculo. | Rodrigo + Valentina |
| 5 | OPERADORES → FAZENDAS (fazenda base)? | Analise adjacencia | Operador tem fazenda base ou trabalha cross-farm? Se cross-farm, org_id e suficiente. Se tem base, adicionar `fazenda_base_id` FK mas NAO desenhar (informativo, nao essencial para o diagrama). | Claudio |
| 6 | MANUTENCOES → NOTA_FISCAL (invoice de servico terceirizado)? | Board question #2 | Manutencao externa (oficina, concessionaria) gera NF de servico. FK direto: `manutencoes.nota_fiscal_id → nota_fiscal.id`. Ou derivavel via CUSTO_OPERACAO → CONTA_PAGAR → NOTA_FISCAL? Path = 3 hops, GRAY ZONE. | Joao + Valentina |

---

## 7. Tabela Resumo Total

### Todas as Relacoes do Modulo Maquinario

| # | De | Para | Card. | FK Em | Tipo Linha | Espessura | Status |
|---|-----|------|-------|-------|------------|-----------|--------|
| **INTERNOS (dentro do frame Maquinario)** |
| M01 | MAQUINAS | ABASTECIMENTOS | 1:N | abastecimentos.maquina_id | Solida ciano | Media | DESENHAR (ja existe) |
| M02 | MAQUINAS | MANUTENCOES | 1:N | manutencoes.maquina_id | Solida ciano | Media | DESENHAR (ja existe) |
| M03 | OPERADORES | ABASTECIMENTOS | 1:N | abastecimentos.operador_id | Solida ciano | Media | DESENHAR (ja existe) |
| M04 | OPERADORES | MANUTENCOES | 1:N | manutencoes.responsavel_id | Solida ciano | Media | DESENHAR (ja existe) |
| **EXTERNOS (cross-frame)** |
| M05 | MAQUINAS | FAZENDAS | N:1 | maquinas.fazenda_id | Tracejada verde | Media | DESENHAR (criar novo) |
| M06 | MANUTENCOES | CENTRO_CUSTO | N:1 | manutencoes.centro_custo_id | Tracejada laranja | Media | DESENHAR (criar novo) |
| **REDUNDANTES (nao desenhar)** |
| ~~ | ABASTECIMENTOS | FAZENDAS | N:1 | abastecimentos.fazenda_id | ~~ | ~~ | REDUNDANTE (2 hops via MAQUINAS) |
| ~~ | MANUTENCOES | FAZENDAS | N:1 | manutencoes.fazenda_id | ~~ | ~~ | REDUNDANTE (2 hops via MAQUINAS) |

### Contagem

| Categoria | Quantidade |
|-----------|-----------|
| Desenhar no diagrama | **6** |
| Redundantes removidos (Dijkstra) | 2 |
| Org_id (convencao, nao desenhar) | 4 |
| Ja mapeados em outros Docs (referencia cruzada) | 4 |
| Questoes abertas (decisao pendente) | 6 |
| **Total analisado** | **22** |

### Miro Board: Conectores a Atualizar

| Conector | Board Status | Acao Necessaria |
|----------|-------------|-----------------|
| M01: MAQUINAS → ABASTECIMENTOS | Existe ("abastece") | Adicionar Crow's Foot 1:N |
| M02: MAQUINAS → MANUTENCOES | Existe ("mantem") | Adicionar Crow's Foot 1:N |
| M03: OPERADORES → ABASTECIMENTOS | Existe ("opera") | Renomear label para "operador" + Crow's Foot 1:N |
| M04: OPERADORES → MANUTENCOES | Existe ("responsavel") | Adicionar Crow's Foot 1:0..N + circulo (opcional) |
| M05: MAQUINAS → FAZENDAS | NAO EXISTE | Criar tracejada verde N:1 com label "fazenda" |
| M06: MANUTENCOES → CENTRO_CUSTO | NAO EXISTE | Criar tracejada laranja N:1 com label "custo" |

---

## 8. Grafo de Adjacencia Atualizado

### Antes (com TODOs)

```
MAQUINAS → [FAZENDAS]                   # TODO: validate in Maquinario module
OPERADORES → []                         # TODO: validate FK structure
ABASTECIMENTOS → [MAQUINAS]
MANUTENCOES → [MAQUINAS, CENTRO_CUSTO*]
```

### Depois (validado Doc 20)

```
MAQUINAS → [FAZENDAS]                   # VALIDADO (M05)
OPERADORES → []                         # VALIDADO: sem FK out (org_id only)
ABASTECIMENTOS → [MAQUINAS, OPERADORES] # ATUALIZADO: +OPERADORES (M03)
MANUTENCOES → [MAQUINAS, OPERADORES*, CENTRO_CUSTO*]  # ATUALIZADO: +OPERADORES* (M04)
```

**Mudancas na adjacencia:**
- ABASTECIMENTOS: adicionado `OPERADORES` (FK operador_id confirmado pelo board)
- MANUTENCOES: adicionado `OPERADORES*` (FK responsavel_id confirmado pelo board, opcional)
- MAQUINAS → FAZENDAS: removido TODO, confirmado essencial
- OPERADORES: confirmado sem FKs outgoing (apenas org_id, nao desenhado)

---

## 9. Entidade Mais Conectada: MAQUINAS (7 relacoes)

| Direcao | Relacoes |
|---------|---------|
| Como PAI (1:N) | 2: ABASTECIMENTOS (M01), MANUTENCOES (M02) |
| Como FILHO (N:1) | 1: FAZENDAS (M05) |
| Incoming (N:1 de outros modulos) | 1: OPERACAO_CAMPO.maquina_id (Doc 19, A08) |
| Via APLICACAO_INSUMO | 1: MANUTENCOES ← APLICACAO_INSUMO (Doc 17, contexto=manutencao) |
| Via CUSTO_OPERACAO | 1: tipo=mecanizacao (conceitual) |
| Hub candidato? | **NAO** (7 conexoes < threshold de 8). Nao e hub. |

### OPERADORES (5 relacoes)

| Direcao | Relacoes |
|---------|---------|
| Como PAI (1:N) | 2: ABASTECIMENTOS (M03), MANUTENCOES (M04) |
| Incoming (N:1 de outros modulos) | 1: OPERACAO_CAMPO.operador_id (Doc 19, A09) |
| Incoming (cross-frame) | 1: OPERADORES ← OPERACAO_CAMPO via "realiza" (board connector) |
| Hub candidato? | **NAO** (5 conexoes). Entidade de cadastro. |

---

## 10. Fluxo de Vida da Maquina (Referencia)

```
COMPRA DA MAQUINA
      │
      ▼
MAQUINAS (cadastro: codigo, tipo, marca, modelo, placa, horimetro=0)
      │
      ├──────────────── Ciclo Diario ──────────────────┐
      │                                                 │
      │  ┌─── OPERACAO_CAMPO (uso no campo) ◄───────── OPERADORES
      │  │    tipo: plantio, colheita, pulverizacao     (quem operou)
      │  │    area_trabalhada_ha, horimetro_inicio/fim
      │  │
      │  ├─── ABASTECIMENTOS (combustivel) ◄────────── OPERADORES
      │  │    tipo_combustivel, quantidade_litros        (quem abasteceu)
      │  │    horimetro_momento → controla consumo L/h
      │  │
      │  └─── MANUTENCOES (preventiva) ◄──────────── OPERADORES
      │       tipo: preventiva (a cada 500h)             (quem fez)
      │       troca_oleo, filtros, graxas
      │       custo_total → CENTRO_CUSTO
      │
      ├──────────────── Evento Nao-Planejado ──────────┐
      │                                                 │
      │  └─── MANUTENCOES (corretiva/preditiva) ◄──── PARCEIRO_COMERCIAL*
      │       tipo: corretiva (quebra) ou preditiva     (oficina/concessionaria)
      │       custo_total → CENTRO_CUSTO
      │       pecas/oleo → APLICACAO_INSUMO (contexto=manutencao)
      │
      │──────────────── Controle Contínuo ─────────────┐
      │                                                 │
      │  horimetro_atual: soma de todas as operacoes
      │  hodometro_atual: para veiculos com km
      │  TCO = Σ(combustivel + manutencao + depreciacao)
      │
      ▼
FIM DE VIDA (venda, sucata, troca)
```

---

## 11. Ordem de Desenho no Miro

### Fase 1: Validar Conectores Existentes (5 min)

```
Os 4 conectores internos JA EXISTEM no board.
Verificar e atualizar:
1. M01: MAQUINAS → ABASTECIMENTOS - adicionar Crow's Foot 1:N
2. M02: MAQUINAS → MANUTENCOES - adicionar Crow's Foot 1:N
3. M03: OPERADORES → ABASTECIMENTOS - renomear label "opera" → "operador" + Crow's Foot
4. M04: OPERADORES → MANUTENCOES - adicionar circulo (opcional) + Crow's Foot
```

### Fase 2: Conectores Novos (5 min)

```
5. M05: MAQUINAS → FAZENDAS
   - Tracejada verde
   - Sai da borda esquerda/superior de MAQUINAS
   - Vai para Frame 7 (CLIENTE/Territorial)
   - Label: "fazenda"

6. M06: MANUTENCOES → CENTRO_CUSTO
   - Tracejada laranja
   - Sai da borda inferior/direita de MANUTENCOES
   - Vai para Frame 9 (FINANCEIRO 2.0)
   - Label: "custo"
```

### Fase 3: Confirmar Cross-Frame (verificar)

```
Conectores que ENTRAM no Maquinario (ja documentados, verificar existencia):
- A08: OPERACAO_CAMPO → MAQUINAS (Doc 19) - "maquina"
- A09: OPERACAO_CAMPO → OPERADORES (Doc 19) - "operador"
- Board: OPERADORES → OPERACAO_CAMPO ("realiza") - ja existe (Shape 788 → 847358366)
```

---

## 12. Notas sobre Decisoes Pendentes da Reuniao 11/02/2026

Da reuniao tecnica Joao + Rodrigo (Doc Reunioes):

1. **Dijkstra aplicado:** Todos os 6 conectores validados pelo algoritmo de shortest path. Nenhum conector redundante encontrado dentro do modulo (os 2 redundantes sao cross-module para FAZENDAS).

2. **LENHA (nova entidade mencionada):** Joao mencionou que UBG precisa de entidade LENHA para combustivel do secador. Isso NAO impacta Maquinario — LENHA seria PRODUTO_INSUMO (tipo=lenha) com fluxo de compra/estoque proprio. Registrar quando modulo UBG for mapeado.

3. **RH precisa expandir:** Joao indicou que a estrutura de RH precisa crescer. OPERADORES pode precisar de FK para TRABALHADOR_RURAL ou ser absorvido por ele. Decisao futura quando RH for mapeado.

---

*Documento gerado em 11/02/2026 - DeepWork AI Flows*
*6 relacionamentos para desenhar, 2 redundantes removidos, 22 total analisado*
*4 conectores ja existem no Miro, 2 novos a criar*
