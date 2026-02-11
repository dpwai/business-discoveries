# RELACIONAMENTOS COMPLETOS - Modulo Financeiro

**Data:** 11/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=
**Referencia:** Doc 08, Doc 12 (Plano Acao), Doc 13 (Centro Custo), Doc 14 (Cost Accounting), Doc 17, Doc 19, Doc 20

---

## 1. Escopo do Modulo

### Entidades Mapeadas (11 — across Frames 3 + 9)

```
Frame 9: FINANCEIRO 2.0
├── PARCEIRO_COMERCIAL ──── Fornecedores, clientes, cooperativas, arrendadores, transportadores
├── NOTA_FISCAL ──────────── NF-e entrada/saida (chave_nfe, xml, valores, impostos)
├── NOTA_FISCAL_ITEM ─────── Itens da NF (produto, ncm, quantidade, valor)
├── CONTA_PAGAR ──────────── Contas a pagar (vencimento, parcelas, status)
├── CONTA_RECEBER ────────── Contas a receber (vencimento, parcelas, status)
├── CENTRO_CUSTO ─────────── Hierarquia de custos (6 niveis: Org→Fazenda→Safra→Cultura→Talhao)
├── CUSTO_OPERACAO ───────── Registro individual de custo (tipo, valor, rateio)
├── CONTRATO_COMERCIAL ───── Contratos de venda (antecipada, barter, fixacao, CPR, spot)
├── CPR_DOCUMENTO ────────── Cedula de Produto Rural (fisica/financeira, cartorio)
└── CONTRATO_ENTREGA ─────── Entregas contra contrato (peso, umidade, NF)

Frame 3: Entidade Contratos
└── CONTRATO_ARRENDAMENTO ── Arrendamento de terra (valor_ha, forma_pagamento)
```

### Entidades JA Mapeadas em Outros Docs (nao repetir)

- COMPRA_INSUMO → PARCEIRO_COMERCIAL (Doc 17: R06)
- COMPRA_INSUMO → NOTA_FISCAL_ITEM (Doc 17: R05)
- CUSTO_OPERACAO → APLICACAO_INSUMO (Doc 17: R25)
- MANUTENCOES → CENTRO_CUSTO (Doc 20: M06)

### Estado Atual no Miro (capturado via API 11/02/2026)

**Frame 9 — FINANCEIRO 2.0** (ID: 3458764658910666873)
Posicao: (22069, 13782) | Tamanho: 5740 x 4621
10 entity shapes | 14 internal connectors | 5 external connectors

**Frame 3 — Entidade Contratos** (ID: 3458764658862684372)
Posicao: (34784, 14031) | Tamanho: 5653 x 3349
5 shapes | 3 internal connectors

**Anotacoes abertas no Board:**
- "A NF E EMITIDA NA ORG OU FAZENDA ?" (Frame 9)
- "tudo sobre nf deve ser arquivo" (Frame 9)
- "FALTA FOLHA DE PAGAMENTO ACORDOR ACERTOS" (Frame 9)
- "e cliente dpwai ? (possivel lead)" (Frame 3)

---

## 2. Shape Identification (via connector semantics)

| Shape ID (suffix) | Entity | Key Connectors |
|-------------------|--------|---------------|
| ...633373 | PARCEIRO_COMERCIAL | →NF "emite/recebe", →CP "paga", →CR "recebe", →CC "contrata" |
| ...633374 | CENTRO_CUSTO | →self "hierarquia", →CUSTO "aloca", →CP "vincula" |
| ...633375 | CUSTO_OPERACAO | receives "aloca" from CC |
| ...633376 | NOTA_FISCAL | →NFI "contem", →CP "gera_pagar", →CR "gera_receber" |
| ...633377 | NOTA_FISCAL_ITEM | receives "contem" |
| ...633378 | CONTA_PAGAR | receives "paga", "gera_pagar", "vincula" |
| ...633379 | CONTA_RECEBER | receives "recebe", "gera_receber", "gera_receita" |
| ...633380 | CONTRATO_COMERCIAL | →CPR "documenta", →CE "possui_entregas", →CR "gera_receita" |
| ...633381 | CPR_DOCUMENTO | receives "documenta" |
| ...633382 | CONTRATO_ENTREGA | receives "possui_entregas", →NF "vincula_nf" |

**External connectors detected:**
- MANUTENCOES (Maquinario) → CENTRO_CUSTO (already Doc 20 M06)
- 3 unnamed external shapes connecting to NF, NFI, and CUSTO_OPERACAO

---

## 3. Relacionamentos Internos (14 connectors — ALL exist on board)

---

### F01: PARCEIRO_COMERCIAL <- NOTA_FISCAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `nota_fiscal.parceiro_id` -> `parceiro_comercial.id` |
| **Cardinalidade** | 1:N (um parceiro emite/recebe muitas NFs) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("emite/recebe") |

**Por que funciona:** Toda NF tem emissor ou destinatario. Para NF entrada, parceiro = fornecedor (Castrolanda, revenda). Para NF saida, parceiro = comprador (cooperativa, trading).

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### F02: NOTA_FISCAL -> NOTA_FISCAL_ITEM

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `nota_fiscal_item.nota_fiscal_id` -> `nota_fiscal.id` |
| **Cardinalidade** | 1:N (uma NF tem muitos itens) |
| **Obrigatoria** | Sim |
| **ON DELETE** | CASCADE |
| **Miro** | EXISTS ("contem") |

**Por que funciona:** Estrutura pai-filho padrao de NF-e. Cada item tem NCM, CFOP, quantidade, valor unitario, impostos proprios. Permite rastrear qual produto foi comprado/vendido em qual NF.

**Dijkstra:** Parent-child. **ESSENCIAL.**

---

### F03: NOTA_FISCAL <- CONTA_PAGAR

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_pagar.nota_fiscal_id` -> `nota_fiscal.id` |
| **Cardinalidade** | 1:N (uma NF pode gerar N parcelas a pagar) |
| **Obrigatoria** | Nao (despesas sem NF: arrendamento em produto, servicos informais) |
| **ON DELETE** | SET NULL |
| **Miro** | EXISTS ("gera_pagar") |

**Por que funciona:** NF de entrada (compra de insumos, pecas, servicos) gera obrigacao de pagamento. Uma NF de R$100.000 pode virar 3 parcelas (30/60/90 dias). Quando nota_fiscal_id = NULL, e despesa direta sem documento fiscal.

**Dijkstra:** Caminho unico NF→CP. **ESSENCIAL.**

---

### F04: NOTA_FISCAL <- CONTA_RECEBER

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_receber.nota_fiscal_id` -> `nota_fiscal.id` |
| **Cardinalidade** | 1:N (uma NF de venda pode gerar N parcelas a receber) |
| **Obrigatoria** | Nao (receitas sem NF: adiantamentos, compensacoes) |
| **ON DELETE** | SET NULL |
| **Miro** | EXISTS ("gera_receber") |

**Por que funciona:** NF de saida (venda de graos, gado) gera direito de recebimento. Similar a F03 mas no sentido inverso.

**Dijkstra:** Caminho unico NF→CR. **ESSENCIAL.**

---

### F05: PARCEIRO_COMERCIAL <- CONTA_PAGAR

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_pagar.parceiro_id` -> `parceiro_comercial.id` |
| **Cardinalidade** | 1:N |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("paga") |

**Dijkstra:** Caminho alternativo: CP → NF → PARCEIRO = 2 hops. MAS nota_fiscal_id e OPCIONAL (despesas sem NF). Caminho condicional nao garante alcancabilidade. **ESSENCIAL.**

---

### F06: PARCEIRO_COMERCIAL <- CONTA_RECEBER

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_receber.parceiro_id` -> `parceiro_comercial.id` |
| **Cardinalidade** | 1:N |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("recebe") |

**Dijkstra:** Mesmo caso de F05. Caminhos via NF ou CONTRATO_COMERCIAL existem (2 hops) mas sao OPCIONAIS. **ESSENCIAL.**

---

### F07: CENTRO_CUSTO -> CENTRO_CUSTO (self-ref)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `centro_custo.parent_id` -> `centro_custo.id` |
| **Cardinalidade** | N:1 (muitos filhos, um pai) |
| **Obrigatoria** | Nao (nivel 1 = raiz, sem pai) |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("hierarquia") |

**Por que funciona:** Hierarquia de 6 niveis (Doc 13): Org → Fazenda → Safra → Cultura → Talhao. Codigo hierarquico: XX.YY.ZZZ.WW.NNN. Permite drill-down de custos e roll-up para consolidacao. Self-reference classica.

---

### F08: CENTRO_CUSTO <- CUSTO_OPERACAO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `custo_operacao.centro_custo_id` -> `centro_custo.id` |
| **Cardinalidade** | 1:N |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("aloca") |

**Por que funciona:** Todo custo e alocado a um centro de custo. Tipos de custo (Doc 14): insumo, mao_obra, mecanizacao, servico, depreciacao, arrendamento, administrativo. O centro de custo determina ONDE o custo e contabilizado (qual talhao, cultura, safra, fazenda).

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### F09: CENTRO_CUSTO <- CONTA_PAGAR

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_pagar.centro_custo_id` -> `centro_custo.id` |
| **Cardinalidade** | 1:N |
| **Obrigatoria** | Nao (pode registrar antes de alocar) |
| **ON DELETE** | SET NULL |
| **Miro** | EXISTS ("vincula") |

**Por que funciona:** Vincula a obrigacao de pagamento ao centro de custo para controle orcamentario. Permite: "quanto ja comprometi do orcamento de Soja 25/26?"

**Dijkstra:** CP → NF → ? → CENTRO_CUSTO? Sem caminho. **ESSENCIAL.**

---

### F10: PARCEIRO_COMERCIAL <- CONTRATO_COMERCIAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_comercial.parceiro_id` -> `parceiro_comercial.id` |
| **Cardinalidade** | 1:N |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("contrata") |

**Por que funciona:** Todo contrato de venda tem uma contraparte (cooperativa, trading, comprador direto). Tipos: venda_antecipada, barter, fixacao, CPR, spot.

**Dijkstra:** Caminho unico. **ESSENCIAL.**

---

### F11: CONTRATO_COMERCIAL -> CPR_DOCUMENTO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `cpr_documento.contrato_comercial_id` -> `contrato_comercial.id` |
| **Cardinalidade** | 1:0..1 (nem todo contrato tem CPR) |
| **Obrigatoria** | Condicional (so para contratos com CPR) |
| **ON DELETE** | CASCADE |
| **Miro** | EXISTS ("documenta") |

**Por que funciona:** CPR (Cedula de Produto Rural) e instrumento de credito rural brasileiro. Registrada em cartorio, com garantias (penhor, hipoteca, aval). Pode ser fisica (entrega produto) ou financeira (pagamento em dinheiro). Nem todo contrato de venda exige CPR — apenas quando ha financiamento ou garantia formal.

---

### F12: CONTRATO_COMERCIAL -> CONTRATO_ENTREGA

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_entrega.contrato_comercial_id` -> `contrato_comercial.id` |
| **Cardinalidade** | 1:N (um contrato tem muitas entregas parciais) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | EXISTS ("possui_entregas") |

**Por que funciona:** Contrato de 5.000 sacas e entregue em N remessas ao longo do periodo. Cada entrega registra: peso bruto/liquido, umidade, impureza, descontos, preco praticado. O percentual_entregue acumulado mostra progresso do contrato.

---

### F13: CONTRATO_COMERCIAL <- CONTA_RECEBER

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_receber.contrato_comercial_id` -> `contrato_comercial.id` |
| **Cardinalidade** | 1:N (um contrato gera N recebiveis) |
| **Obrigatoria** | Nao (recebiveis avulsos nao tem contrato) |
| **ON DELETE** | SET NULL |
| **Miro** | EXISTS ("gera_receita") |

**Por que funciona:** Cada entrega contra contrato gera um recebivel. Permite rastrear: "do contrato de 5.000 sacas com Cargill, ja recebi R$X de R$Y total".

**Dijkstra:** CR → NF → ? → CONTRATO? Sem caminho via NF. **ESSENCIAL.**

---

### F14: CONTRATO_ENTREGA -> NOTA_FISCAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_entrega.nota_fiscal_id` -> `nota_fiscal.id` |
| **Cardinalidade** | N:1 (muitas entregas podem referenciar mesma NF consolidada) |
| **Obrigatoria** | Nao (entrega pode preceder faturamento) |
| **ON DELETE** | SET NULL |
| **Miro** | EXISTS ("vincula_nf") |

**Por que funciona:** Cada entrega fisica gera (ou referencia) uma NF de saida. A NF comprova fiscalmente a saida de graos. O vinculo permite reconciliar entregas fisicas com documentos fiscais.

**Dijkstra:** CE → CONTRATO → ? → NF? Sem caminho. **ESSENCIAL.**

---

## 4. Relacionamentos Externos (8 connectors — maioria NAO existe no board)

---

### F15: CONTRATO_COMERCIAL -> SAFRAS

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_comercial.safra_id` -> `safras.id` |
| **Cardinalidade** | N:1 |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | NAO EXISTE — criar tracejada verde |
| **Miro Label** | "safra" |

**Por que funciona:** Contrato de venda e por safra. "Vendi 2.000 sacas de soja da safra 25/26 para Cargill." Sem safra_id, nao se sabe de qual colheita sao os graos.

**Dijkstra:** Sem caminho alternativo. **ESSENCIAL.**

---

### F16: CONTRATO_COMERCIAL -> PRODUTO_INSUMO (barter)

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_comercial.barter_produto_insumo_id` -> `produto_insumo.id` |
| **Cardinalidade** | N:1 |
| **Obrigatoria** | Condicional (so tipo = 'barter') |
| **ON DELETE** | RESTRICT |
| **Miro** | NAO EXISTE — criar tracejada amarela |
| **Miro Label** | "barter insumo" |

**Por que funciona:** No barter, produtor troca graos por insumos. Ex: "300 sacas de soja = 10 ton de fertilizante MAP". O barter_produto_insumo_id identifica QUAL insumo foi recebido em troca. Permite rastrear custo real do insumo obtido via barter.

**Dijkstra:** Sem caminho CC → PRODUTO_INSUMO sem este FK. **ESSENCIAL (condicional).**

---

### F17: NOTA_FISCAL_ITEM -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `nota_fiscal_item.produto_insumo_id` -> `produto_insumo.id` |
| **Cardinalidade** | N:1 |
| **Obrigatoria** | Nao (nem todo item de NF e insumo — pode ser servico, frete, etc.) |
| **ON DELETE** | SET NULL |
| **Miro** | NAO EXISTE — criar tracejada amarela |
| **Miro Label** | "produto" |

**Por que funciona:** Vincula o item fiscal ao catalogo de produtos do sistema. Permite: reconciliar compras fiscais com entrada em estoque, calcular preco medio de compra por produto, e integrar NF com COMPRA_INSUMO.

**Dijkstra:** NFI → NF → ? → PRODUTO_INSUMO? Sem caminho. **ESSENCIAL.**

> **Nota:** Este FK precisa de rename: `insumo_id` → `produto_insumo_id` (ja listado em FK Renames Pending no agent file).

---

### F18: CONTRATO_ENTREGA -> TICKET_BALANCA

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_entrega.ticket_balanca_id` -> `ticket_balanca.id` |
| **Cardinalidade** | N:1 |
| **Obrigatoria** | Nao (entrega pode nao ter pesagem propria) |
| **ON DELETE** | SET NULL |
| **Miro** | NAO EXISTE — criar tracejada amarela (cross-frame → UBG) |
| **Miro Label** | "pesagem" |

**Por que funciona:** Na entrega de graos, o caminhao pesa na balanca do comprador (ou cooperativa). O ticket comprova peso bruto, tara, liquido, e permite reconciliar com o peso estimado pelo contrato.

---

### F19: CONTRATO_ENTREGA -> SAIDA_GRAO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_entrega.saida_grao_id` -> `saida_grao.id` |
| **Cardinalidade** | N:1 |
| **Obrigatoria** | Nao |
| **ON DELETE** | SET NULL |
| **Miro** | NAO EXISTE — criar tracejada amarela (cross-frame → UBG) |
| **Miro Label** | "saida silo" |

**Por que funciona:** Conecta a entrega contratual a saida fisica do silo. SAIDA_GRAO registra quanto saiu do estoque; CONTRATO_ENTREGA registra quanto foi entregue contra o contrato. Permite reconciliar estoque fisico vs entregas contratuais.

---

### F20: CONTRATO_ARRENDAMENTO -> PARCEIRO_COMERCIAL

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `contrato_arrendamento.parceiro_id` -> `parceiro_comercial.id` |
| **Cardinalidade** | N:1 (um arrendador pode ter muitos contratos) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | Provavelmente EXISTS em Frame 3 ("possui") — verificar manualmente |
| **Miro Label** | "arrendador" |

**Por que funciona:** O contrato de arrendamento e com um PARCEIRO_COMERCIAL do tipo 'arrendador'. Identifica quem e o dono da terra arrendada, para pagamento e gestao contratual.

---

### F21: CONTRATO_ARRENDAMENTO -> TALHOES

| Aspecto | Detalhe |
|---------|---------|
| **FK** | Tabela associativa ou `contrato_arrendamento.talhao_id` |
| **Cardinalidade** | N:N (um contrato pode cobrir varios talhoes; um talhao pode ter multiplos contratos ao longo do tempo) |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro** | Provavelmente EXISTS em Frame 3 ("formaliza") — verificar |
| **Miro Label** | "terra arrendada" |

**Por que funciona:** O arrendamento e POR TALHAO (ou conjunto de talhoes). O valor_ha × area define o custo de arrendamento. Sem esse vinculo, nao se sabe qual terra e arrendada vs propria.

---

### F22: CONTA_PAGAR <- CONTRATO_ARRENDAMENTO

| Aspecto | Detalhe |
|---------|---------|
| **FK** | `conta_pagar.contrato_arrendamento_id` -> `contrato_arrendamento.id` |
| **Cardinalidade** | 1:N (um contrato gera N pagamentos ao longo do tempo) |
| **Obrigatoria** | Condicional (so para contas de tipo arrendamento) |
| **ON DELETE** | SET NULL |
| **Miro** | NAO EXISTE — criar tracejada laranja |
| **Miro Label** | "arrendamento" |

**Por que funciona:** Arrendamento gera pagamentos periodicos (mensal, semestral, safra). Vincula a obrigacao de pagamento ao contrato de origem.

**Dijkstra:** CP → NF → ? → CONTRATO_ARRENDAMENTO? Sem caminho. **ESSENCIAL.**

---

## 5. Analise de Redundancia (Dijkstra)

### FKs Potencialmente Redundantes — Validados como ESSENCIAIS

| FK Avaliado | Path Alternativo | Hops | Resultado | Motivo |
|------------|-----------------|------|-----------|--------|
| CONTA_PAGAR.parceiro_id | CP → NF → PARCEIRO | 2 | **ESSENCIAL** | nota_fiscal_id e OPCIONAL — path condicional |
| CONTA_RECEBER.parceiro_id | CR → NF → PARCEIRO ou CR → CONTRATO → PARCEIRO | 2 | **ESSENCIAL** | Ambos FKs intermediarios sao OPCIONAIS |
| CONTRATO_ENTREGA.nota_fiscal_id | CE → SAIDA_GRAO → NF | 2 | **ESSENCIAL** | saida_grao_id e OPCIONAL |

### FKs Redundantes — NAO Desenhar

| FK Removido | Caminho Alternativo | Hops | Pattern |
|------------|-------------------|------|---------|
| NOTA_FISCAL_ITEM → PARCEIRO_COMERCIAL | NFI → NF → PARCEIRO | 2 | Transitive closure |
| CPR_DOCUMENTO → PARCEIRO_COMERCIAL | CPR → CONTRATO → PARCEIRO | 2 | Transitive closure |
| CONTRATO_ENTREGA → PARCEIRO_COMERCIAL | CE → CONTRATO → PARCEIRO | 2 | Transitive closure |
| CUSTO_OPERACAO → NOTA_FISCAL | DDL denorm only (3 hops via CC→CP→NF) | 3 | Gray zone |
| CUSTO_OPERACAO → OPERACAO_CAMPO | DDL denorm only (2 hops via APLICACAO_INSUMO for insumo costs) | 2* | Conditional (*non-insumo costs need direct FK) |

### Org_id (NAO desenhar — convencao)

Todos os 11 entidades carregam `organization_id` mas nao e desenhado.

### CUSTO_OPERACAO — Context FKs (DDL-only, NAO no diagrama)

Doc 12 especifica FKs opcionais em CUSTO_OPERACAO para rastreabilidade:
`nota_fiscal_id`, `abastecimento_id`, `manutencao_id`, `operacao_campo_id`, `manejo_sanitario_id`, `safra_id`, `cultura_id`, `talhao_id`, `maquina_id`, `operador_id`

Todos sao DENORMALIZACAO para queries diretas. No diagrama, so desenhar CUSTO_OPERACAO → CENTRO_CUSTO (F08) e CUSTO_OPERACAO → APLICACAO_INSUMO (Doc 17). Os demais ficam no DDL com comentario `-- DENORM`.

---

## 6. Referencia Cruzada com Docs Anteriores

| Doc # | Relacao | Relevancia para Financeiro |
|-------|---------|---------------------------|
| Doc 17 R06 | COMPRA_INSUMO → PARCEIRO_COMERCIAL | Compra de insumos de fornecedor |
| Doc 17 R05 | COMPRA_INSUMO → NOTA_FISCAL_ITEM | Item fiscal que registra a compra |
| Doc 17 R25 | APLICACAO_INSUMO → CUSTO_OPERACAO (1:1) | Custo de insumo por aplicacao |
| Doc 20 M06 | MANUTENCOES → CENTRO_CUSTO | Custo de manutencao alocado (ja no board!) |
| Doc 19 A08/A09 | OPERACAO_CAMPO → MAQUINAS/OPERADORES | Base para custo de mecanizacao |

---

## 7. Questoes Abertas

| # | Questao | Fonte | Impacto | Quem Decide |
|---|---------|-------|---------|-------------|
| 1 | "A NF E EMITIDA NA ORG OU FAZENDA?" | Board Frame 9 | Determina se NOTA_FISCAL tem fazenda_id ou so org_id | Claudio + Valentina |
| 2 | "FALTA FOLHA DE PAGAMENTO ACORDOR ACERTOS" | Board Frame 9 | Entidades de payroll (FOLHA_PAGAMENTO, ACERTO) ainda nao desenhadas | Valentina + Joao |
| 3 | CONTRATO_ARRENDAMENTO → TALHOES e 1:N ou N:N? | Analise | Se N:N, precisa tabela associativa CONTRATO_ARRENDAMENTO_TALHAO | Claudio |
| 4 | CONTA_RECEBER precisa de centro_custo_id? | Doc 12 | Receitas normalmente nao sao alocadas por CC. Mas poderia ser util para rastreio. | Rodrigo |
| 5 | Novas entidades ORCAMENTO_SAFRA e DEPRECIACAO_ATIVO (Doc 14) — quando criar? | Analise | Adicionam budget tracking e controle patrimonial. Impacto em CENTRO_CUSTO e MAQUINAS. | Joao + Rodrigo |
| 6 | "e cliente dpwai? (possivel lead)" | Board Frame 3 | PARCEIRO_COMERCIAL pode servir como lead tracking? Ou precisa entidade separada? | Rodrigo |

---

## 8. Tabela Resumo Total

| # | De | Para | Card. | FK Em | Status Board | Status Doc |
|---|-----|------|-------|-------|-------------|-----------|
| **INTERNOS (14)** |
| F01 | NOTA_FISCAL | PARCEIRO_COMERCIAL | N:1 | nf.parceiro_id | EXISTS | DESENHAR |
| F02 | NOTA_FISCAL | NOTA_FISCAL_ITEM | 1:N | nfi.nota_fiscal_id | EXISTS | DESENHAR |
| F03 | CONTA_PAGAR | NOTA_FISCAL | N:1 | cp.nota_fiscal_id | EXISTS | DESENHAR |
| F04 | CONTA_RECEBER | NOTA_FISCAL | N:1 | cr.nota_fiscal_id | EXISTS | DESENHAR |
| F05 | CONTA_PAGAR | PARCEIRO_COMERCIAL | N:1 | cp.parceiro_id | EXISTS | DESENHAR |
| F06 | CONTA_RECEBER | PARCEIRO_COMERCIAL | N:1 | cr.parceiro_id | EXISTS | DESENHAR |
| F07 | CENTRO_CUSTO | CENTRO_CUSTO | self | cc.parent_id | EXISTS | DESENHAR |
| F08 | CUSTO_OPERACAO | CENTRO_CUSTO | N:1 | co.centro_custo_id | EXISTS | DESENHAR |
| F09 | CONTA_PAGAR | CENTRO_CUSTO | N:1 | cp.centro_custo_id | EXISTS | DESENHAR |
| F10 | CONTRATO_COMERCIAL | PARCEIRO_COMERCIAL | N:1 | cc.parceiro_id | EXISTS | DESENHAR |
| F11 | CONTRATO_COMERCIAL | CPR_DOCUMENTO | 1:0..1 | cpr.contrato_id | EXISTS | DESENHAR |
| F12 | CONTRATO_COMERCIAL | CONTRATO_ENTREGA | 1:N | ce.contrato_id | EXISTS | DESENHAR |
| F13 | CONTA_RECEBER | CONTRATO_COMERCIAL | N:1 | cr.contrato_id | EXISTS | DESENHAR |
| F14 | CONTRATO_ENTREGA | NOTA_FISCAL | N:1 | ce.nota_fiscal_id | EXISTS | DESENHAR |
| **EXTERNOS (8)** |
| F15 | CONTRATO_COMERCIAL | SAFRAS | N:1 | cc.safra_id | NEW | DESENHAR |
| F16 | CONTRATO_COMERCIAL | PRODUTO_INSUMO | N:1 | cc.barter_produto_insumo_id | NEW | DESENHAR (condicional) |
| F17 | NOTA_FISCAL_ITEM | PRODUTO_INSUMO | N:1 | nfi.produto_insumo_id | NEW | DESENHAR |
| F18 | CONTRATO_ENTREGA | TICKET_BALANCA | N:1 | ce.ticket_balanca_id | NEW | DESENHAR |
| F19 | CONTRATO_ENTREGA | SAIDA_GRAO | N:1 | ce.saida_grao_id | NEW | DESENHAR |
| F20 | CONTRATO_ARRENDAMENTO | PARCEIRO_COMERCIAL | N:1 | ca.parceiro_id | CHECK Frame 3 | DESENHAR |
| F21 | CONTRATO_ARRENDAMENTO | TALHOES | N:N | tabela assoc. | CHECK Frame 3 | DESENHAR |
| F22 | CONTA_PAGAR | CONTRATO_ARRENDAMENTO | N:1 | cp.contrato_arr_id | NEW | DESENHAR |
| **REDUNDANTES** |
| ~~ | NOTA_FISCAL_ITEM | PARCEIRO_COMERCIAL | N:1 | ~~ | ~~ | REDUNDANTE (2h via NF) |
| ~~ | CPR_DOCUMENTO | PARCEIRO_COMERCIAL | N:1 | ~~ | ~~ | REDUNDANTE (2h via CONTRATO) |
| ~~ | CONTRATO_ENTREGA | PARCEIRO_COMERCIAL | N:1 | ~~ | ~~ | REDUNDANTE (2h via CONTRATO) |

### Contagem

| Categoria | Quantidade |
|-----------|-----------|
| Desenhar no diagrama | **22** (14 existem + 8 novos) |
| Redundantes removidos (Dijkstra) | 3 |
| DDL-only denormalization (CUSTO_OPERACAO context FKs) | ~10 |
| Org_id (convencao, nao desenhar) | 11 |
| Ja mapeados em outros Docs | 4 |
| Questoes abertas | 6 |
| **Total analisado** | **~56** |

---

## 9. Grafo de Adjacencia Atualizado

### Antes (com TODOs)

```
NOTA_FISCAL → [PARCEIRO_COMERCIAL]                   # TODO: validate in Financeiro module
NOTA_FISCAL_ITEM → [NOTA_FISCAL, PRODUTO_INSUMO]
CONTA_PAGAR → [NOTA_FISCAL*, CENTRO_CUSTO]
CONTA_RECEBER → [CONTRATO_COMERCIAL*, CENTRO_CUSTO]
CENTRO_CUSTO → [CENTRO_CUSTO(parent)*]
CUSTO_OPERACAO → [CENTRO_CUSTO, APLICACAO_INSUMO*]
CONTRATO_COMERCIAL → [PARCEIRO_COMERCIAL, SAFRAS, PRODUTO_INSUMO*]
CONTRATO_ENTREGA → [CONTRATO_COMERCIAL]
CPR_DOCUMENTO → [CONTRATO_COMERCIAL]
```

### Depois (validado Doc 21)

```
NOTA_FISCAL → [PARCEIRO_COMERCIAL]                                       # VALIDATED (F01)
NOTA_FISCAL_ITEM → [NOTA_FISCAL, PRODUTO_INSUMO]                        # VALIDATED (F02, F17)
CONTA_PAGAR → [NOTA_FISCAL*, PARCEIRO_COMERCIAL, CENTRO_CUSTO*, CONTRATO_ARRENDAMENTO*]  # UPDATED
CONTA_RECEBER → [NOTA_FISCAL*, PARCEIRO_COMERCIAL, CONTRATO_COMERCIAL*] # UPDATED: +PARCEIRO, +NF
CENTRO_CUSTO → [CENTRO_CUSTO(parent)*]                                   # VALIDATED (F07)
CUSTO_OPERACAO → [CENTRO_CUSTO, APLICACAO_INSUMO*]                      # VALIDATED (F08)
CONTRATO_COMERCIAL → [PARCEIRO_COMERCIAL, SAFRAS, PRODUTO_INSUMO*]      # VALIDATED (F10, F15, F16)
CONTRATO_ENTREGA → [CONTRATO_COMERCIAL, NOTA_FISCAL*, TICKET_BALANCA*, SAIDA_GRAO*]  # UPDATED
CPR_DOCUMENTO → [CONTRATO_COMERCIAL]                                     # VALIDATED (F11)
CONTRATO_ARRENDAMENTO → [PARCEIRO_COMERCIAL, TALHOES]                   # VALIDATED (F20, F21)
```

**Mudancas na adjacencia:**
- CONTA_PAGAR: +PARCEIRO_COMERCIAL (F05), +CONTRATO_ARRENDAMENTO* (F22)
- CONTA_RECEBER: +PARCEIRO_COMERCIAL (F06), +NOTA_FISCAL* (F04)
- CONTRATO_ENTREGA: +NOTA_FISCAL* (F14), +TICKET_BALANCA* (F18), +SAIDA_GRAO* (F19)
- CONTRATO_ARRENDAMENTO: Fully validated (F20, F21)
- Removed all TODOs from Financeiro entities

---

## 10. Hub Entity Update: PARCEIRO_COMERCIAL

| Direcao | Relacoes |
|---------|---------|
| Incoming (como FK target) | NF(F01), CP(F05), CR(F06), CC(F10), CA(F20), COMPRA_INSUMO(Doc17) |
| Total | **6 incoming** |
| Hub? | **Nao** (6 < threshold 8). Mas e o 5o entidade mais conectada do sistema. |

---

## 11. Ordem de Desenho no Miro

### Fase 1: Validar 14 Conectores Existentes (10 min)

Todos os 14 internos ja existem. Verificar:
- Crow's Foot notation correta em todos
- Labels legíveis
- Direcao das setas consistente com FK

### Fase 2: 6 Novos Conectores em Frame 9 (10 min)

```
F15: CONTRATO_COMERCIAL → SAFRAS — tracejada verde, "safra"
F16: CONTRATO_COMERCIAL → PRODUTO_INSUMO — tracejada amarela, "barter insumo"
F17: NOTA_FISCAL_ITEM → PRODUTO_INSUMO — tracejada amarela, "produto"
F18: CONTRATO_ENTREGA → TICKET_BALANCA — tracejada amarela, "pesagem" (cross-frame UBG)
F19: CONTRATO_ENTREGA → SAIDA_GRAO — tracejada amarela, "saida silo" (cross-frame UBG)
F22: CONTA_PAGAR → CONTRATO_ARRENDAMENTO — tracejada laranja, "arrendamento"
```

### Fase 3: Verificar Frame 3 (5 min)

```
F20: CONTRATO_ARRENDAMENTO → PARCEIRO_COMERCIAL — verificar se "possui" = este conector
F21: CONTRATO_ARRENDAMENTO → TALHOES — verificar se "formaliza" = este conector
```

---

*Documento gerado em 11/02/2026 - DeepWork AI Flows*
*22 relacionamentos para desenhar (14 existem + 8 novos), 3 redundantes removidos, ~56 total analisado*
*Maior modulo mapeado ate agora: 11 entidades, 22 conectores*
