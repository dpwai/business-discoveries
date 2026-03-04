# RELACIONAMENTOS COMPLETOS - Modulo Consumo e Estoque

**Data:** 10/02/2026
**Versao:** 1.0
**Status:** Definicao completa para implementacao no Miro
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=
**Referencia:** Doc 15 - Modulo Insumos e Estoque

---

## Indice

1. [Resumo Visual](#1-resumo-visual)
2. [Relacionamentos Internos](#2-relacionamentos-internos-dentro-do-modulo)
3. [Relacionamentos Externos](#3-relacionamentos-externos-para-outros-modulos)
4. [Referencias Reversas](#4-referencias-reversas-entidades-que-apontam-para-este-modulo)
5. [Guia de Conectores Miro](#5-guia-de-conectores-miro)
6. [Tabela Resumo Total](#6-tabela-resumo-total)

---

## 1. Resumo Visual

### Entidades do Modulo (6)

```
PRODUTO_INSUMO ─────── Catalogo (dicionario de produtos)
COMPRA_INSUMO ──────── Registro de compra (quando, de quem, quanto custou)
ESTOQUE_INSUMO ─────── Posicao atual (saldo, custo medio, localizacao)
MOVIMENTACAO_INSUMO ── Historico (cada entrada e saida, rastreabilidade)
APLICACAO_INSUMO ───── Uso (campo, pecuaria, manutencao, UBG)
RECEITUARIO_AGRONOMICO Prescricao (compliance MAPA, defensivos)
```

### Mapa de Conexoes

```
                    ORGANIZATIONS ◄─────────────────────────────────────────────┐
                         │                                                      │
          ┌──────────────┼────────────────────────────────────┐                │
          │              │                                    │                │
          ▼              ▼                                    ▼                │
   ┌─────────────┐  ┌──────────────┐                  ┌──────────────┐        │
   │  PRODUTO    │  │   COMPRA     │──► PARCEIRO      │  ESTOQUE     │        │
   │  _INSUMO    │  │   _INSUMO    │──► NF_ITEM       │  _INSUMO     │──► FAZENDAS
   │  (catalogo) │  │   (compra)   │──► SAFRAS        │  (saldo)     │        │
   │             │  │              │──► CULTURAS      │              │        │
   │             │  │              │──► CONTRATO_COM. │              │        │
   └──────┬──────┘  └──────┬───────┘                  └──────┬───────┘        │
          │                │                                  │                │
          │ 1:N            │ 1:1 (gera entrada)              │ 1:N            │
          │                ▼                                  │                │
          │         ┌──────────────────┐                     │                │
          ├────────►│  MOVIMENTACAO    │◄────────────────────┘                │
          │         │  _INSUMO         │                                      │
          │         │  (historico)      │──► USERS (responsavel)              │
          │         └────────┬─────────┘                                      │
          │                  │ 1:1 (gera saida)                               │
          │                  ▼                                                │
          │         ┌──────────────────┐                                      │
          ├────────►│  APLICACAO       │──► OPERACAO_CAMPO                    │
          │         │  _INSUMO         │──► TALHAO_SAFRA                      │
          │         │  (uso)           │──► MANEJO_SANITARIO                  │
          │         │                  │──► MANUTENCOES                       │
          │         │                  │──► CUSTO_OPERACAO                    │
          │         └────────┬─────────┘                                      │
          │                  │ N:1                                             │
          │                  ▼                                                │
          │         ┌──────────────────┐                                      │
          └────────►│  RECEITUARIO     │──► CULTURAS                          │
                    │  _AGRONOMICO     │                                      │
                    │  (prescricao)    │──────────────────────────────────────┘
                    └──────────────────┘
```

**Total de relacionamentos: 31**
- Internos: 10
- Externos: 16
- Reversos: 5

---

## 2. Relacionamentos Internos (Dentro do Modulo)

Estes sao os conectores DENTRO do frame "Consumo e estoque". Todos usam **linha solida amarela** com **Crow's Foot notation**.

---

### R01: PRODUTO_INSUMO -> COMPRA_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | PRODUTO_INSUMO |
| **Para** | COMPRA_INSUMO |
| **Cardinalidade** | 1:N (um produto aparece em muitas compras) |
| **FK** | `compra_insumo.produto_insumo_id` -> `produto_insumo.id` |
| **Obrigatoria** | Sim (toda compra precisa referenciar um produto do catalogo) |
| **ON DELETE** | RESTRICT (nao pode apagar produto que ja tem compras) |
| **Miro Connector** | `──│────<──` Linha solida amarela. "1" no lado PRODUTO, "N" no lado COMPRA |

**Por que funciona:** O PRODUTO_INSUMO e o catalogo puro - nao tem preco, nao tem quantidade. E o "dicionario". Cada COMPRA_INSUMO registra uma aquisicao especifica desse produto, com preco, quantidade e fornecedor daquele momento. Separar catalogo de compra permite que o mesmo produto (ex: Roundup) tenha N registros de compra com precos diferentes ao longo do tempo, de fornecedores diferentes, e em safras diferentes.

---

### R02: PRODUTO_INSUMO -> ESTOQUE_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | PRODUTO_INSUMO |
| **Para** | ESTOQUE_INSUMO |
| **Cardinalidade** | 1:N (um produto pode estar em varios locais) |
| **FK** | `estoque_insumo.produto_insumo_id` -> `produto_insumo.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** O estoque e uma POSICAO POR LOCAL. O mesmo Roundup pode ter saldo no "Galpao Principal" e no "Deposito Defensivos". Cada linha de ESTOQUE_INSUMO representa uma combinacao unica de produto + local de armazenamento. Isso permite saber exatamente onde cada produto esta e qual o custo medio em cada ponto.

---

### R03: PRODUTO_INSUMO -> APLICACAO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | PRODUTO_INSUMO |
| **Para** | APLICACAO_INSUMO |
| **Cardinalidade** | 1:N (um produto e aplicado muitas vezes) |
| **FK** | `aplicacao_insumo.produto_insumo_id` -> `produto_insumo.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** Cada vez que alguem usa um insumo (seja no plantio, na pulverizacao, na pecuaria ou na manutencao), gera um registro de APLICACAO_INSUMO. O FK para PRODUTO_INSUMO diz QUAL produto foi usado. Isso permite calcular: "quanto de Roundup eu usei na safra inteira?" somando todas as aplicacoes daquele produto.

---

### R04: PRODUTO_INSUMO -> RECEITUARIO_AGRONOMICO

| Aspecto | Detalhe |
|---------|---------|
| **De** | PRODUTO_INSUMO |
| **Para** | RECEITUARIO_AGRONOMICO |
| **Cardinalidade** | 1:N (um produto pode ter varias receitas ao longo do tempo) |
| **FK** | `receituario_agronomico.produto_insumo_id` -> `produto_insumo.id` |
| **Obrigatoria** | Sim |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** O receituario agronomico e uma exigencia legal do MAPA para defensivos. O Alessandro (agronomo) emite uma receita prescrevendo um produto especifico com dose especifica para uma cultura especifica. O mesmo produto pode ter varias receitas porque cada aplicacao pode ter uma receita diferente (dose diferente, cultura diferente, praga diferente).

---

### R05: COMPRA_INSUMO -> MOVIMENTACAO_INSUMO (entrada)

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | MOVIMENTACAO_INSUMO |
| **Cardinalidade** | 1:1 (cada compra gera exatamente uma entrada no estoque) |
| **FK** | `movimentacao_insumo.compra_insumo_id` -> `compra_insumo.id` |
| **Obrigatoria** | Condicional (obrigatoria quando tipo = `entrada_compra`) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────│──` Linha solida amarela. "1" em ambos os lados |

**Por que funciona:** Quando Castrolanda entrega um insumo, dois coisas acontecem: (1) cria-se o registro de COMPRA_INSUMO com os dados comerciais (preco, NF, fornecedor) e (2) gera-se automaticamente uma MOVIMENTACAO_INSUMO do tipo `entrada_compra` que incrementa o saldo do ESTOQUE_INSUMO e recalcula o custo medio ponderado. A relacao 1:1 garante rastreabilidade total: cada unidade de estoque sabe de qual compra veio.

**Nota:** E 1:1 e nao 1:N porque uma compra gera UMA entrada. Se o produto for entregue em parcelas, cada parcela e uma COMPRA_INSUMO separada com status `parcial`.

---

### R06: ESTOQUE_INSUMO -> MOVIMENTACAO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | ESTOQUE_INSUMO |
| **Para** | MOVIMENTACAO_INSUMO |
| **Cardinalidade** | 1:N (um estoque tem muitas movimentacoes ao longo do tempo) |
| **FK** | `movimentacao_insumo.estoque_insumo_id` -> `estoque_insumo.id` |
| **Obrigatoria** | Sim (toda movimentacao afeta um estoque) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** MOVIMENTACAO_INSUMO e o LIVRO RAZAO do estoque. Cada entrada, saida, ajuste ou transferencia e um registro imutavel com saldo_anterior e saldo_posterior. Isso garante auditoria completa. A qualquer momento, voce pode reconstruir a historia completa de um estoque somando todas as movimentacoes. O estoque atual (quantidade_atual em ESTOQUE_INSUMO) e sempre o saldo_posterior da ultima movimentacao.

---

### R07: APLICACAO_INSUMO -> MOVIMENTACAO_INSUMO (saida)

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | MOVIMENTACAO_INSUMO |
| **Cardinalidade** | 1:1 (cada aplicacao gera exatamente uma saida do estoque) |
| **FK** | `movimentacao_insumo.aplicacao_insumo_id` -> `aplicacao_insumo.id` |
| **Obrigatoria** | Condicional (obrigatoria quando tipo = `saida_aplicacao`) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────│──` Linha solida amarela |

**Por que funciona:** Espelho da R05. Quando alguem aplica um insumo no campo, cria-se APLICACAO_INSUMO (dados de uso: onde, quanto, dose) e gera-se MOVIMENTACAO_INSUMO do tipo `saida_aplicacao` que decrementa o saldo. O custo da saida usa o custo medio atual do estoque (custo medio NAO muda na saida, so na entrada).

---

### R08: ESTOQUE_INSUMO -> APLICACAO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | ESTOQUE_INSUMO |
| **Para** | APLICACAO_INSUMO |
| **Cardinalidade** | 1:N (de um estoque saem muitas aplicacoes) |
| **FK** | `aplicacao_insumo.estoque_insumo_id` -> `estoque_insumo.id` |
| **Obrigatoria** | Sim (toda aplicacao precisa dizer DE ONDE saiu o produto) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** Essa FK responde a pergunta: "de qual deposito/galpao saiu esse insumo?". Se a fazenda tem dois locais de armazenamento (Galpao Principal e Deposito Defensivos), ao aplicar Roundup no Talhao Bonin, o sistema precisa saber de qual estoque fisico descontar. Isso permite controle real por ponto de armazenamento, nao so por produto.

---

### R09: RECEITUARIO_AGRONOMICO -> APLICACAO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | RECEITUARIO_AGRONOMICO |
| **Para** | APLICACAO_INSUMO |
| **Cardinalidade** | 1:N (uma receita pode cobrir varias aplicacoes) |
| **FK** | `aplicacao_insumo.receituario_id` -> `receituario_agronomico.id` |
| **Obrigatoria** | Condicional (obrigatoria quando o insumo e defensivo agricola) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──│────<──` Linha solida amarela |

**Por que funciona:** Compliance legal. Para defensivos (herbicidas, inseticidas, fungicidas), a lei exige receituario agronomico emitido por agronomo com CREA. Uma receita pode cobrir a mesma aplicacao em varios talhoes (mesma dose, mesmo produto, mesma praga). A FK e opcional porque insumos nao-defensivos (semente, fertilizante, combustivel) nao precisam de receita.

---

### R10: MOVIMENTACAO_INSUMO -> ESTOQUE_INSUMO (transferencia)

| Aspecto | Detalhe |
|---------|---------|
| **De** | MOVIMENTACAO_INSUMO |
| **Para** | ESTOQUE_INSUMO (destino) |
| **Cardinalidade** | N:1 (muitas transferencias podem ter o mesmo destino) |
| **FK** | `movimentacao_insumo.transferencia_destino_id` -> `estoque_insumo.id` |
| **Obrigatoria** | Condicional (obrigatoria quando tipo = `saida_transferencia`) |
| **ON DELETE** | RESTRICT |
| **Miro Connector** | `──<────│──` Linha solida amarela, tracejada (transferencia interna) |

**Por que funciona:** Quando transfere produto de um local para outro (ex: Galpao Principal -> Deposito da Fazenda 2), gera-se DUAS movimentacoes: uma `saida_transferencia` no estoque de origem (com `transferencia_destino_id` apontando para o estoque destino) e uma `entrada_transferencia` no estoque de destino. Isso mantm rastreabilidade bidirecional.

---

## 3. Relacionamentos Externos (Para Outros Modulos)

Estes sao conectores que SAEM do frame "Consumo e estoque" para entidades em outros frames. Usam **linha tracejada** na cor do modulo destino.

---

### R11: PRODUTO_INSUMO -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **De** | PRODUTO_INSUMO |
| **Para** | ORGANIZATIONS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 (muitos produtos pertencem a uma organizacao) |
| **FK** | `produto_insumo.organization_id` -> `organizations.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul. Sai de PRODUTO_INSUMO para cima (y=-6000) |
| **Miro Label** | "org" |

**Por que funciona:** Multi-tenancy. Cada organizacao (fazenda/empresa) tem seu proprio catalogo de produtos. A SOAL ve seus produtos, outra fazenda ve os dela. Essa FK e a base do isolamento de dados na plataforma DPWAI.

---

### R12: COMPRA_INSUMO -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | ORGANIZATIONS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 |
| **FK** | `compra_insumo.organization_id` -> `organizations.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul |

**Por que funciona:** Mesmo principio de multi-tenancy. Compras pertencem a uma organizacao.

---

### R13: COMPRA_INSUMO -> NOTA_FISCAL_ITEM

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | NOTA_FISCAL_ITEM (Frame 9: Financeiro) |
| **Cardinalidade** | N:1 (muitas compras podem vir do mesmo item de NF... mas na pratica 1:1) |
| **FK** | `compra_insumo.nota_fiscal_item_id` -> `nota_fiscal_item.id` |
| **Obrigatoria** | Nao (compra pode existir sem NF - ex: producao propria, estoque inicial) |
| **Miro Connector** | Linha tracejada laranja. Sai de COMPRA para baixo (y=8000) |
| **Miro Label** | "NF" |

**Por que funciona:** Vincula a compra a contabilidade. Quando Castrolanda entrega e emite NF, cada item da NF corresponde a uma compra de insumo. O FK e opcional porque existem entradas sem NF: semente propria (guardada da safra anterior), ajustes de inventario, barter. Isso nao pode ser obrigatorio senao trava o fluxo.

---

### R14: COMPRA_INSUMO -> PARCEIRO_COMERCIAL

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | PARCEIRO_COMERCIAL (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitas compras do mesmo fornecedor) |
| **FK** | `compra_insumo.parceiro_id` -> `parceiro_comercial.id` |
| **Obrigatoria** | Sim (toda compra tem um fornecedor) |
| **Miro Connector** | Linha tracejada verde. Sai de COMPRA para cima (y=-2000) |
| **Miro Label** | "fornecedor" |

**Por que funciona:** PARCEIRO_COMERCIAL e a entidade unificada para fornecedores, clientes, arrendadores e transportadores. Para compra de insumos, o parceiro e o FORNECEDOR (Castrolanda, revenda, fabricante direto). Centralizar em PARCEIRO_COMERCIAL evita duplicar cadastros - a Castrolanda que fornece insumos e a mesma Castrolanda que compra graos.

---

### R15: COMPRA_INSUMO -> SAFRAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | SAFRAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitas compras por safra) |
| **FK** | `compra_insumo.safra_id` -> `safras.id` |
| **Obrigatoria** | Sim (toda compra e para uma safra) |
| **Miro Connector** | Linha tracejada verde |
| **Miro Label** | "safra" |

**Por que funciona:** Toda compra de insumo agricola e vinculada a uma safra (ex: Safra 25/26 = Jul 2025 a Jun 2026). Isso e fundamental para custeio: "quanto gastei em insumos na safra 25/26?" e a pergunta numero 1 do Claudio. Sem esse vinculo, nao e possivel calcular custo por hectare por safra.

---

### R16: COMPRA_INSUMO -> CULTURAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | CULTURAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 |
| **FK** | `compra_insumo.cultura_destino_id` -> `culturas.id` |
| **Obrigatoria** | Nao (nem sempre sabe no momento da compra) |
| **Miro Connector** | Linha tracejada verde, fina |
| **Miro Label** | "cultura destino" |

**Por que funciona:** Opcional e estrategico. Na hora da compra, as vezes o produtor ja sabe que o adubo e para soja. As vezes nao sabe ainda. Quando sabe, registrar a cultura destino permite pro-ratear custos de insumo por cultura antes mesmo da aplicacao. Quando nao sabe, o custo e alocado na aplicacao (APLICACAO_INSUMO.talhao_safra_id que ja tem a cultura).

---

### R17: COMPRA_INSUMO -> CONTRATO_COMERCIAL

| Aspecto | Detalhe |
|---------|---------|
| **De** | COMPRA_INSUMO |
| **Para** | CONTRATO_COMERCIAL (Frame 3: Contratos / Frame 9: Financeiro) |
| **Cardinalidade** | N:1 |
| **FK** | `compra_insumo.contrato_barter_id` -> `contrato_comercial.id` |
| **Obrigatoria** | Nao (so quando a compra veio de troca barter) |
| **Miro Connector** | Linha tracejada laranja, fina |
| **Miro Label** | "barter" |

**Por que funciona:** Barter e a troca de graos por insumos. O produtor vende soja futura e recebe insumos agora. Quando isso acontece, a COMPRA_INSUMO precisa vincular ao contrato de barter para: (1) rastrear a obrigacao de entrega de graos e (2) calcular o custo real do insumo (que nao e preco de tabela, e preco da soja negociada). Opcional porque a maioria das compras e pagamento normal.

---

### R18: ESTOQUE_INSUMO -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **De** | ESTOQUE_INSUMO |
| **Para** | ORGANIZATIONS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 |
| **FK** | `estoque_insumo.organization_id` -> `organizations.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul |

**Por que funciona:** Multi-tenancy. Isolamento de dados de estoque por organizacao.

---

### R19: ESTOQUE_INSUMO -> FAZENDAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | ESTOQUE_INSUMO |
| **Para** | FAZENDAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 (muitos estoques por fazenda) |
| **FK** | `estoque_insumo.fazenda_id` -> `fazendas.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada verde |
| **Miro Label** | "onde esta" |

**Por que funciona:** O estoque fisico de insumos fica em uma fazenda especifica. A SOAL tem (ou tera) mais de uma fazenda. Saber que o Roundup esta na "Fazenda Sede" e nao na "Fazenda 2" e essencial para logistica e para saber de onde mandar o produto pro campo. Combinado com `local_armazenamento` (VARCHAR), da a posicao exata: "Fazenda Sede > Galpao Defensivos".

---

### R20: APLICACAO_INSUMO -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | ORGANIZATIONS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 |
| **FK** | `aplicacao_insumo.organization_id` -> `organizations.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul |

**Por que funciona:** Multi-tenancy.

---

### R21: APLICACAO_INSUMO -> OPERACAO_CAMPO

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | OPERACAO_CAMPO (Frame 8: Agricultura) |
| **Cardinalidade** | N:1 (muitas aplicacoes por operacao) |
| **FK** | `aplicacao_insumo.operacao_campo_id` -> `operacao_campo.id` |
| **Obrigatoria** | Condicional (obrigatoria quando contexto = `agricola`) |
| **Miro Connector** | Linha solida amarela (mesma camada Agricola) |
| **Miro Label** | "operacao" |

**Por que funciona:** ESSA E A RELACAO MAIS IMPORTANTE DO MODULO. Uma OPERACAO_CAMPO (ex: plantio de soja no Talhao Bonin) pode consumir N insumos simultaneamente:

```
OPERACAO_CAMPO (tipo=plantio)
    ├── APLICACAO_INSUMO: Semente TMG 4185 (75kg/ha x 85ha = 6.375kg)
    ├── APLICACAO_INSUMO: Inoculante Nitragin (2 doses/ha x 85ha = 170 doses)
    ├── APLICACAO_INSUMO: MAP 08-40-00 (250kg/ha x 85ha = 21.250kg)
    └── APLICACAO_INSUMO: Standak (200ml/ha x 85ha = 17L)
```

Sem essa relacao N:1, nao seria possivel saber quais insumos foram usados em cada operacao e calcular o custo total da operacao (soma de todos os insumos + mao de obra + mecanizacao).

---

### R22: APLICACAO_INSUMO -> TALHAO_SAFRA

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | TALHAO_SAFRA (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 |
| **FK** | `aplicacao_insumo.talhao_safra_id` -> `talhao_safra.id` |
| **Obrigatoria** | Condicional (obrigatoria quando contexto = `agricola`) |
| **Miro Connector** | Linha tracejada verde |
| **Miro Label** | "onde aplicou" |

**Por que funciona:** TALHAO_SAFRA e a combinacao talhao + safra + cultura (ex: "Bonin + 25/26 + Soja"). Vincular a aplicacao a essa combinacao permite calcular custo de insumo por hectare por cultura por safra - que e o KPI central do projeto SOAL. E diferente de vincular so ao talhao porque o mesmo talhao pode ter soja na safra 25/26 e milho na 26/27.

---

### R23: APLICACAO_INSUMO -> MANEJO_SANITARIO

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | MANEJO_SANITARIO (Frame 2: Pecuario) |
| **Cardinalidade** | N:1 |
| **FK** | `aplicacao_insumo.manejo_sanitario_id` -> `manejo_sanitario.id` |
| **Obrigatoria** | Condicional (obrigatoria quando contexto = `pecuario`) |
| **Miro Connector** | Linha tracejada verde (cruza camadas) |
| **Miro Label** | "manejo" |

**Por que funciona:** Quando o veterinario aplica Ivermectina nos animais, isso e um MANEJO_SANITARIO (dados de saude: tipo, dosagem, via, carencia) E tambem um consumo de insumo (Ivermectina saiu do estoque). O APLICACAO_INSUMO registra O QUE saiu e QUANTO custou, o MANEJO_SANITARIO registra POR QUE e COMO foi aplicado. Complementam, nao duplicam.

---

### R24: APLICACAO_INSUMO -> MANUTENCOES

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | MANUTENCOES (Frame 6: Maquinario) |
| **Cardinalidade** | N:1 |
| **FK** | `aplicacao_insumo.manutencao_id` -> `manutencoes.id` |
| **Obrigatoria** | Condicional (obrigatoria quando contexto = `manutencao`) |
| **Miro Connector** | Linha tracejada ciano |
| **Miro Label** | "manutencao" |

**Por que funciona:** Quando o mecanico troca oleo de um trator, isso e uma MANUTENCAO (dados tecnicos: tipo, maquina, horimetro) E tambem um consumo de insumo (oleo hidraulico saiu do estoque). Mesma logica da pecuaria: APLICACAO_INSUMO cuida do custo, MANUTENCAO cuida da operacao tecnica.

---

### R25: APLICACAO_INSUMO -> CUSTO_OPERACAO

| Aspecto | Detalhe |
|---------|---------|
| **De** | APLICACAO_INSUMO |
| **Para** | CUSTO_OPERACAO (Frame 9: Financeiro) |
| **Cardinalidade** | 1:1 (cada aplicacao gera exatamente um lancamento de custo) |
| **FK** | `custo_operacao.aplicacao_insumo_id` -> `aplicacao_insumo.id` |
| **Obrigatoria** | Sim (toda aplicacao tem custo) |
| **ON DELETE** | CASCADE |
| **Miro Connector** | Linha tracejada laranja |
| **Miro Label** | "gera custo" |

**Por que funciona:** CUSTO_OPERACAO e o livro de custos. Cada vez que um insumo e aplicado, gera-se um lancamento de custo do tipo `insumo` vinculado ao CENTRO_CUSTO correto. Isso alimenta os dashboards de custeio: custo por hectare, custo por cultura, custo por safra. A relacao 1:1 garante que nao existam custos orfaos nem aplicacoes sem custo.

---

### R26: MOVIMENTACAO_INSUMO -> USERS

| Aspecto | Detalhe |
|---------|---------|
| **De** | MOVIMENTACAO_INSUMO |
| **Para** | USERS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 |
| **FK** | `movimentacao_insumo.responsavel_id` -> `users.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul, fina |
| **Miro Label** | "quem" |

**Por que funciona:** Auditoria e responsabilidade. Cada movimentacao de estoque precisa registrar QUEM fez. Se sumir 100L de diesel, o sistema mostra quem registrou a ultima movimentacao. Tambem permite calcular produtividade por operador.

---

### R27: RECEITUARIO_AGRONOMICO -> ORGANIZATIONS

| Aspecto | Detalhe |
|---------|---------|
| **De** | RECEITUARIO_AGRONOMICO |
| **Para** | ORGANIZATIONS (Frame 5: DPWAI) |
| **Cardinalidade** | N:1 |
| **FK** | `receituario_agronomico.organization_id` -> `organizations.id` |
| **Obrigatoria** | Sim |
| **Miro Connector** | Linha tracejada azul |

**Por que funciona:** Multi-tenancy.

---

### R28: RECEITUARIO_AGRONOMICO -> CULTURAS

| Aspecto | Detalhe |
|---------|---------|
| **De** | RECEITUARIO_AGRONOMICO |
| **Para** | CULTURAS (Frame 7: Cliente/Territorial) |
| **Cardinalidade** | N:1 |
| **FK** | `receituario_agronomico.cultura_id` -> `culturas.id` |
| **Obrigatoria** | Sim (receita e sempre para uma cultura) |
| **Miro Connector** | Linha tracejada verde |
| **Miro Label** | "cultura" |

**Por que funciona:** O receituario prescreve um defensivo para uma cultura especifica. Roundup para SOJA tem dose e carencia diferente de Roundup para MILHO. A cultura e obrigatoria porque a lei exige essa informacao na receita.

---

## 4. Referencias Reversas (Entidades que Apontam Para Este Modulo)

Estas sao entidades que JA EXISTEM em outros frames e que possuem (ou precisarao possuir) FKs apontando para PRODUTO_INSUMO. Requerem RENOMEACAO de FK.

---

### R29: PULVERIZACAO_DETALHE -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | PULVERIZACAO_DETALHE (Frame 8: Agricultura) |
| **Para** | PRODUTO_INSUMO |
| **Cardinalidade** | N:1 |
| **FK atual** | `pulverizacao_detalhe.insumo_id` (RENOMEAR para `produto_insumo_id`) |
| **Miro Connector** | Linha solida amarela (mesma camada) |

**Nota:** PULVERIZACAO_DETALHE registra dados TECNICOS (pressao em bar, vazao L/ha, velocidade km/h, condicoes climaticas). APLICACAO_INSUMO registra dados de PRODUTO (qual, quanto, custo). NAO sao redundantes - uma OPERACAO_CAMPO de pulverizacao tem 1 PULVERIZACAO_DETALHE e N APLICACAO_INSUMO.

---

### R30: DRONE_DETALHE -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | DRONE_DETALHE (Frame 8: Agricultura) |
| **Para** | PRODUTO_INSUMO |
| **Cardinalidade** | N:1 |
| **FK atual** | `drone_detalhe.insumo_id` (RENOMEAR para `produto_insumo_id`) |
| **Miro Connector** | Linha solida amarela |

**Por que funciona:** Mesma logica do PULVERIZACAO_DETALHE. Drone tem dados tecnicos especificos (altitude_voo, faixa_aplicacao, bateria) e tambem consome insumos.

---

### R31: DIETA_INGREDIENTE -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | DIETA_INGREDIENTE (Frame 2: Pecuario) |
| **Para** | PRODUTO_INSUMO |
| **Cardinalidade** | N:1 |
| **FK atual** | `dieta_ingrediente.insumo_id` (RENOMEAR para `produto_insumo_id`) |
| **Miro Connector** | Linha tracejada verde (cruza camadas: Pecuaria -> Agricola) |

**Por que funciona:** Uma DIETA (formulacao nutricional para o gado) e composta de N ingredientes. Cada ingrediente e um PRODUTO_INSUMO do tipo pecuario (racao, sal mineral, suplemento). O catalogo e unificado porque o mesmo sal mineral que aparece na dieta e o mesmo que esta no estoque e que foi comprado.

---

### R32: NOTA_FISCAL_ITEM -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | NOTA_FISCAL_ITEM (Frame 9: Financeiro) |
| **Para** | PRODUTO_INSUMO |
| **Cardinalidade** | N:1 |
| **FK atual** | `nota_fiscal_item.insumo_id` (RENOMEAR para `produto_insumo_id`) |
| **Miro Connector** | Linha tracejada laranja (cruza camadas: Financeiro -> Agricola) |

**Por que funciona:** Cada item de uma nota fiscal de compra de insumos referencia um produto do catalogo. Isso permite reconciliar: "o que a NF diz que chegou" vs "o que o estoque registrou que entrou".

---

### R33: CONTRATO_COMERCIAL -> PRODUTO_INSUMO

| Aspecto | Detalhe |
|---------|---------|
| **De** | CONTRATO_COMERCIAL (Frame 3: Contratos) |
| **Para** | PRODUTO_INSUMO |
| **Cardinalidade** | N:1 |
| **FK atual** | `contrato_comercial.barter_insumo_id` (RENOMEAR para `barter_produto_insumo_id`) |
| **Obrigatoria** | Condicional (so em contratos tipo barter) |
| **Miro Connector** | Linha tracejada laranja |

**Por que funciona:** Em contratos de barter, o produtor troca graos por insumos. O contrato precisa referenciar QUAL insumo sera recebido (ex: "troco 500 sacas de soja por 20 toneladas de MAP 08-40-00"). Opcional porque nem todo contrato e barter.

---

## 5. Guia de Conectores Miro

### Legenda de Linhas

| Tipo Linha | Quando Usar | Exemplo |
|------------|-------------|---------|
| **Solida amarela** | Relacao INTERNA (mesma camada Agricola) | PRODUTO_INSUMO -> COMPRA_INSUMO |
| **Tracejada azul** | Para camada Sistema (y=-6000) | Qualquer entidade -> ORGANIZATIONS |
| **Tracejada verde** | Para camada Territorial (y=-2000) | COMPRA -> SAFRAS, ESTOQUE -> FAZENDAS |
| **Tracejada laranja** | Para camada Financeiro (y=8000) | COMPRA -> NF_ITEM, APLICACAO -> CUSTO_OPERACAO |
| **Tracejada ciano** | Para camada Operacional | APLICACAO -> MANUTENCOES |
| **Tracejada verde escuro** | Para camada Pecuaria (y=12000) | APLICACAO -> MANEJO_SANITARIO |
| **Solida amarela fina** | Relacao condicional interna | MOVIMENTACAO -> transferencia_destino |

### Legenda de Cardinalidade (Crow's Foot)

```
1:1    ──│────│──     Um para um (raro: Compra->Movimentacao entrada)
1:N    ──│────<──     Um para muitos (padrao: Produto->Compra)
N:1    ──>────│──     Muitos para um (reverso do 1:N visto do filho)
```

### Espessura de Linha

| Espessura | Significado |
|-----------|-------------|
| **Grossa (3px)** | Relacao critica para o fluxo principal (R01, R05, R06, R07, R21, R25) |
| **Media (2px)** | Relacao importante (R02, R03, R08, R13, R14, R15, R19) |
| **Fina (1px)** | Relacao secundaria/condicional (R16, R17, R23, R24, R26) |

### Labels nos Conectores

Cada conector EXTERNO deve ter um label curto no meio da linha:

| Conector | Label |
|----------|-------|
| -> ORGANIZATIONS | "org" |
| -> NOTA_FISCAL_ITEM | "NF" |
| -> PARCEIRO_COMERCIAL | "fornecedor" |
| -> SAFRAS | "safra" |
| -> CULTURAS | "cultura destino" |
| -> CONTRATO_COMERCIAL | "barter" |
| -> FAZENDAS | "onde esta" |
| -> OPERACAO_CAMPO | "operacao" |
| -> TALHAO_SAFRA | "onde aplicou" |
| -> MANEJO_SANITARIO | "manejo" |
| -> MANUTENCOES | "manutencao" |
| -> CUSTO_OPERACAO | "gera custo" |
| -> USERS | "quem" |

---

## 6. Tabela Resumo Total

### Todas as 33 Relacoes Ordenadas por Prioridade de Desenho

| # | De | Para | Card. | FK Em | Tipo Linha | Espessura | Obrig. |
|---|-----|------|-------|-------|------------|-----------|--------|
| **INTERNOS - Desenhar primeiro** |
| R01 | PRODUTO_INSUMO | COMPRA_INSUMO | 1:N | compra.produto_insumo_id | Solida amarela | Grossa | Sim |
| R02 | PRODUTO_INSUMO | ESTOQUE_INSUMO | 1:N | estoque.produto_insumo_id | Solida amarela | Media | Sim |
| R03 | PRODUTO_INSUMO | APLICACAO_INSUMO | 1:N | aplicacao.produto_insumo_id | Solida amarela | Media | Sim |
| R04 | PRODUTO_INSUMO | RECEITUARIO_AGRO | 1:N | receituario.produto_insumo_id | Solida amarela | Media | Sim |
| R05 | COMPRA_INSUMO | MOVIMENTACAO (entrada) | 1:1 | movimentacao.compra_insumo_id | Solida amarela | Grossa | Cond. |
| R06 | ESTOQUE_INSUMO | MOVIMENTACAO | 1:N | movimentacao.estoque_insumo_id | Solida amarela | Grossa | Sim |
| R07 | APLICACAO_INSUMO | MOVIMENTACAO (saida) | 1:1 | movimentacao.aplicacao_insumo_id | Solida amarela | Grossa | Cond. |
| R08 | ESTOQUE_INSUMO | APLICACAO_INSUMO | 1:N | aplicacao.estoque_insumo_id | Solida amarela | Media | Sim |
| R09 | RECEITUARIO_AGRO | APLICACAO_INSUMO | 1:N | aplicacao.receituario_id | Solida amarela | Media | Cond. |
| R10 | MOVIMENTACAO | ESTOQUE (destino) | N:1 | movimentacao.transferencia_destino_id | Solida amarela fina | Fina | Cond. |
| **EXTERNOS - Desenhar segundo** |
| R11 | PRODUTO_INSUMO | ORGANIZATIONS | N:1 | produto.organization_id | Tracejada azul | Fina | Sim |
| R12 | COMPRA_INSUMO | ORGANIZATIONS | N:1 | compra.organization_id | Tracejada azul | Fina | Sim |
| R13 | COMPRA_INSUMO | NOTA_FISCAL_ITEM | N:1 | compra.nota_fiscal_item_id | Tracejada laranja | Media | Nao |
| R14 | COMPRA_INSUMO | PARCEIRO_COMERCIAL | N:1 | compra.parceiro_id | Tracejada verde | Media | Sim |
| R15 | COMPRA_INSUMO | SAFRAS | N:1 | compra.safra_id | Tracejada verde | Media | Sim |
| R16 | COMPRA_INSUMO | CULTURAS | N:1 | compra.cultura_destino_id | Tracejada verde | Fina | Nao |
| R17 | COMPRA_INSUMO | CONTRATO_COMERCIAL | N:1 | compra.contrato_barter_id | Tracejada laranja | Fina | Nao |
| R18 | ESTOQUE_INSUMO | ORGANIZATIONS | N:1 | estoque.organization_id | Tracejada azul | Fina | Sim |
| R19 | ESTOQUE_INSUMO | FAZENDAS | N:1 | estoque.fazenda_id | Tracejada verde | Media | Sim |
| R20 | APLICACAO_INSUMO | ORGANIZATIONS | N:1 | aplicacao.organization_id | Tracejada azul | Fina | Sim |
| R21 | APLICACAO_INSUMO | OPERACAO_CAMPO | N:1 | aplicacao.operacao_campo_id | Solida amarela | Grossa | Cond. |
| R22 | APLICACAO_INSUMO | TALHAO_SAFRA | N:1 | aplicacao.talhao_safra_id | Tracejada verde | Media | Cond. |
| R23 | APLICACAO_INSUMO | MANEJO_SANITARIO | N:1 | aplicacao.manejo_sanitario_id | Tracejada verde | Fina | Cond. |
| R24 | APLICACAO_INSUMO | MANUTENCOES | N:1 | aplicacao.manutencao_id | Tracejada ciano | Fina | Cond. |
| R25 | APLICACAO_INSUMO | CUSTO_OPERACAO | 1:1 | custo_op.aplicacao_insumo_id | Tracejada laranja | Grossa | Sim |
| R26 | MOVIMENTACAO | USERS | N:1 | movimentacao.responsavel_id | Tracejada azul | Fina | Sim |
| R27 | RECEITUARIO_AGRO | ORGANIZATIONS | N:1 | receituario.organization_id | Tracejada azul | Fina | Sim |
| R28 | RECEITUARIO_AGRO | CULTURAS | N:1 | receituario.cultura_id | Tracejada verde | Media | Sim |
| **REVERSOS - Atualizar entidades existentes** |
| R29 | PULVERIZACAO_DET | PRODUTO_INSUMO | N:1 | pulv.produto_insumo_id (renomear) | Solida amarela | Fina | Sim |
| R30 | DRONE_DETALHE | PRODUTO_INSUMO | N:1 | drone.produto_insumo_id (renomear) | Solida amarela | Fina | Sim |
| R31 | DIETA_INGREDIENTE | PRODUTO_INSUMO | N:1 | dieta_ing.produto_insumo_id (renomear) | Tracejada verde | Fina | Sim |
| R32 | NOTA_FISCAL_ITEM | PRODUTO_INSUMO | N:1 | nf_item.produto_insumo_id (renomear) | Tracejada laranja | Fina | Sim |
| R33 | CONTRATO_COMERCIAL | PRODUTO_INSUMO | N:1 | contrato.barter_produto_insumo_id (renomear) | Tracejada laranja | Fina | Cond. |

### Contagem por Entidade

| Entidade | Total Relacoes | Como Pai (1:N/1:1) | Como Filho (N:1) | Referenciada Externamente |
|----------|---------------|---------------------|-------------------|--------------------------|
| PRODUTO_INSUMO | 12 | 4 internos + 5 reversos = 9 | 1 (Organizations) | 5 (Pulv, Drone, Dieta, NF_Item, Contrato) |
| COMPRA_INSUMO | 8 | 1 interno (Movimentacao) | 7 (Produto, Org, NF, Parceiro, Safra, Cultura, Contrato) | 0 |
| ESTOQUE_INSUMO | 5 | 2 internos (Movimentacao, Aplicacao) | 3 (Produto, Org, Fazenda) | 0 |
| MOVIMENTACAO_INSUMO | 5 | 0 | 5 (Estoque, Compra, Aplicacao, Estoque destino, Users) | 0 |
| APLICACAO_INSUMO | 10 | 1 interno (Movimentacao) + 1 externo (Custo) | 8 (Produto, Estoque, Receituario, Org, OpCampo, TalhaoSafra, Manejo, Manutencao) | 0 |
| RECEITUARIO_AGRO | 4 | 1 interno (Aplicacao) | 3 (Produto, Org, Culturas) | 0 |

### Entidade Mais Conectada: APLICACAO_INSUMO (10 relacoes)

Isso faz sentido porque APLICACAO_INSUMO e o PONTO DE CONVERGENCIA entre:
- O que foi usado (PRODUTO_INSUMO)
- De onde veio (ESTOQUE_INSUMO)
- Onde foi usado (TALHAO_SAFRA / MANEJO_SANITARIO / MANUTENCOES)
- Por que foi usado (OPERACAO_CAMPO)
- Com que autorizacao (RECEITUARIO_AGRONOMICO)
- Quanto custou (CUSTO_OPERACAO)

---

## 7. Ordem de Desenho no Miro (Otimizada)

### Fase 1: Esqueleto Interno (10 min)

Desenhar as 6 entidades e os 10 conectores internos PRIMEIRO, antes de qualquer conector externo. Isso garante que o modulo fique legivel isoladamente.

```
Ordem:
1. PRODUTO_INSUMO (topo, x=-5000, y=2000)
2. COMPRA_INSUMO (abaixo, x=-5000, y=3000)
3. ESTOQUE_INSUMO (abaixo, x=-5000, y=4000)
4. MOVIMENTACAO_INSUMO (lateral, x=-3500, y=4000)
5. APLICACAO_INSUMO (esquerda, x=-7000, y=3500)
6. RECEITUARIO_AGRONOMICO (esquerda abaixo, x=-7000, y=4500)

Conectores internos (em ordem):
R01: PRODUTO -> COMPRA (vertical para baixo)
R02: PRODUTO -> ESTOQUE (vertical para baixo, ao lado do R01)
R06: ESTOQUE -> MOVIMENTACAO (horizontal para direita)
R05: COMPRA -> MOVIMENTACAO (diagonal para baixo-direita)
R07: APLICACAO -> MOVIMENTACAO (horizontal longa para direita)
R03: PRODUTO -> APLICACAO (diagonal para esquerda-baixo)
R08: ESTOQUE -> APLICACAO (horizontal para esquerda)
R04: PRODUTO -> RECEITUARIO (diagonal para esquerda-baixo)
R09: RECEITUARIO -> APLICACAO (vertical para cima)
R10: MOVIMENTACAO -> ESTOQUE destino (curva interna)
```

### Fase 2: Conectores Externos Criticos (10 min)

```
R21: APLICACAO -> OPERACAO_CAMPO (solida amarela grossa, para esquerda)
R25: APLICACAO -> CUSTO_OPERACAO (tracejada laranja grossa, para baixo)
R13: COMPRA -> NOTA_FISCAL_ITEM (tracejada laranja media, para baixo)
R14: COMPRA -> PARCEIRO_COMERCIAL (tracejada verde media, para cima)
R15: COMPRA -> SAFRAS (tracejada verde media, para cima)
R19: ESTOQUE -> FAZENDAS (tracejada verde media, para cima)
R22: APLICACAO -> TALHAO_SAFRA (tracejada verde media, para cima)
R28: RECEITUARIO -> CULTURAS (tracejada verde media, para cima)
```

### Fase 3: Conectores Externos Secundarios (5 min)

```
R11-R12-R18-R20-R27: -> ORGANIZATIONS (5x tracejada azul fina)
R16: COMPRA -> CULTURAS (tracejada verde fina)
R17: COMPRA -> CONTRATO_COMERCIAL (tracejada laranja fina)
R23: APLICACAO -> MANEJO_SANITARIO (tracejada verde fina)
R24: APLICACAO -> MANUTENCOES (tracejada ciano fina)
R26: MOVIMENTACAO -> USERS (tracejada azul fina)
```

### Fase 4: Reversos (5 min)

```
R29-R30: PULVERIZACAO/DRONE -> PRODUTO_INSUMO (solida amarela fina)
R31: DIETA_INGREDIENTE -> PRODUTO_INSUMO (tracejada verde fina)
R32: NOTA_FISCAL_ITEM -> PRODUTO_INSUMO (tracejada laranja fina)
R33: CONTRATO_COMERCIAL -> PRODUTO_INSUMO (tracejada laranja fina)
```

---

*Documento gerado em 10/02/2026 - DeepWork AI Flows*
*33 relacionamentos mapeados para o Modulo Consumo e Estoque*
