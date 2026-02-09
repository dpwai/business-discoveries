# FINANCEIRO SOAL - Plano de Acao e Draft Detalhado

**Data:** 08/02/2026
**Versao:** 1.0
**Status:** Draft para Validacao
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## PARTE 1: PLANO DE ACAO

### Visao Geral

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│                         MODULO FINANCEIRO SOAL                              │
│                                                                             │
│    ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐     │
│    │  CUSTOS │   │  NOTAS  │   │ CONTAS  │   │CONTRATOS│   │PARCEIROS│     │
│    │         │   │ FISCAIS │   │  P/R    │   │         │   │         │     │
│    └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘     │
│         │             │             │             │             │           │
│         └─────────────┴─────────────┴─────────────┴─────────────┘           │
│                                     │                                       │
│                                     ▼                                       │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │                    CENTRO DE CUSTO HIERARQUICO                   │     │
│    │         Org → Fazenda → Safra → Cultura → Talhao                │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                     │                                       │
│         ┌───────────────────────────┼───────────────────────────┐           │
│         │                           │                           │           │
│         ▼                           ▼                           ▼           │
│    ┌─────────┐               ┌─────────────┐              ┌──────────┐     │
│    │AGRICULT.│               │ MECANIZACAO │              │ PECUARIA │     │
│    │   UBG   │               │             │              │          │     │
│    └─────────┘               └─────────────┘              └──────────┘     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Fases de Implementacao

#### FASE 0: Fundacao (Semana 1-2)
```
[ ] Validar estrutura de Centro de Custo com Claudio
[ ] Mapear categorias existentes no AgriWin
[ ] Definir metodo de rateio (diesel, mao de obra)
[ ] Criar PARCEIRO_COMERCIAL com dados existentes
```

#### FASE 1: Core Financeiro (Semana 3-4)
```
[ ] Implementar CENTRO_CUSTO hierarquico
[ ] Implementar NOTA_FISCAL + NOTA_FISCAL_ITEM
[ ] Implementar CONTA_PAGAR + CONTA_RECEBER
[ ] Conectar com INSUMOS_CASTROLANDA existente
```

#### FASE 2: Custos Operacionais (Semana 5-6)
```
[ ] Implementar CUSTO_OPERACAO
[ ] Conectar OPERACAO_CAMPO → CUSTO_OPERACAO
[ ] Conectar ABASTECIMENTOS → CUSTO_OPERACAO
[ ] Conectar MANUTENCOES → CUSTO_OPERACAO
[ ] Implementar rateio automatico
```

#### FASE 3: Comercializacao (Semana 7-8)
```
[ ] Implementar CONTRATO_COMERCIAL
[ ] Implementar CPR_DOCUMENTO
[ ] Implementar CONTRATO_ENTREGA
[ ] Conectar SAIDAS_GRAOS → NOTA_FISCAL
[ ] Conectar VENDAS_GADO → NOTA_FISCAL
```

#### FASE 4: Dashboards e KPIs (Semana 9-10)
```
[ ] Custo por hectare por cultura
[ ] Margem bruta por safra
[ ] Breakeven price
[ ] Cash flow projetado
```

---

## PARTE 2: MAPA DE CONEXOES

### 2.1 Conexoes Completas Entre Modulos

```
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                                     SISTEMA (RBAC)                                           │
│                                                                                              │
│    ORGANIZATIONS ──────────────────────────────────────────────────────────────────┐        │
│         │                                                                           │        │
└─────────┼───────────────────────────────────────────────────────────────────────────┼────────┘
          │                                                                           │
          ▼                                                                           ▼
┌─────────────────────┐                                               ┌─────────────────────┐
│     TERRITORIAL     │                                               │     FINANCEIRO      │
│                     │                                               │                     │
│  FAZENDAS           │                                               │  PARCEIRO_COMERCIAL │
│     │               │                                               │     │               │
│     ├── TALHOES     │                                               │     ├── fornecedor  │
│     │                │                                              │     ├── cliente     │
│     └── SILOS ──────┼──────────────────────────┐                    │     ├── cooperativa │
│                     │                          │                    │     ├── arrendador  │
│  SAFRAS             │                          │                    │     └── transportador│
│     │               │                          │                    │                     │
│     └── CULTURAS    │                          │                    │  CENTRO_CUSTO ◄─────┼────┐
│           │         │                          │                    │     │               │    │
└───────────┼─────────┘                          │                    │     ├── nivel 1: Org│    │
            │                                    │                    │     ├── nivel 2: Faz│    │
            ▼                                    │                    │     ├── nivel 3: Saf│    │
┌───────────────────────────────────────────┐    │                    │     ├── nivel 4: Cul│    │
│              AGRICULTURA                   │    │                    │     └── nivel 5: Tal│    │
│                                           │    │                    │                     │    │
│  TALHAO_SAFRA                             │    │                    │  CUSTO_OPERACAO     │    │
│     │                                     │    │                    │     │               │    │
│     ▼                                     │    │                    │     ├── tipo_custo  │    │
│  OPERACAO_CAMPO ─────────────────────────────────────────────────────────►│ insumo       │    │
│     │                                     │    │                    │     │ mao_obra     │    │
│     ├── PLANTIO_DETALHE ──► custo semente─────────────────────────────────► mecanizacao  │    │
│     │                                     │    │                    │     │ servico      │    │
│     ├── COLHEITA_DETALHE                  │    │                    │     │ depreciacao  │    │
│     │        │                            │    │                    │     │               │    │
│     │        ▼                            │    │                    │     └── rateio_tipo │    │
│     ├── PULVERIZACAO_DETALHE ──► custo defensivo──────────────────────────────────────────┘    │
│     │                                     │    │                    │                          │
│     └── TRANSPORTE_COLHEITA_DETALHE       │    │                    │  NOTA_FISCAL             │
│              │                            │    │                    │     │                    │
│              │ ticket_balanca_id          │    │                    │     ├── ENTRADA (compra) │
│              ▼                            │    │                    │     │      │             │
└──────────────┼────────────────────────────┘    │                    │     │      ▼             │
               │                                 │                    │     │   CONTA_PAGAR      │
               ▼                                 │                    │     │                    │
┌──────────────────────────────────────────┐     │                    │     └── SAIDA (venda)    │
│                 UBG                       │     │                    │            │             │
│                                          │     │                    │            ▼             │
│  TICKET_BALANCA                          │     │                    │       CONTA_RECEBER      │
│     │                                    │     │                    │                          │
│     ▼                                    │     │                    │  CONTRATO_COMERCIAL      │
│  RECEBIMENTO_GRAOS                       │     │                    │     │                    │
│     │                                    │     │                    │     ├── venda_antecipada │
│     ▼                                    │     │                    │     ├── barter           │
│  CONTROLE_SECAGEM ──► custo lenha ───────────────────────────────────────► fixacao           │
│     │                                    │     │                    │     └── cpr              │
│     ▼                                    │     │                    │            │             │
│  ESTOQUE_SILOS ◄─────────────────────────┼─────┘                    │            ▼             │
│     │                                    │                          │     CPR_DOCUMENTO        │
│     ├── MOVIMENTACAO_SILO                │                          │                          │
│     │                                    │                          │  CONTRATO_ENTREGA        │
│     ├── SAIDAS_GRAOS ─────────────────────────────────────────────────────► ticket_balanca_id │
│     │      │                             │                          │            │             │
│     │      ├── emitente = soal ──────────────────────────────────────────► nota_fiscal_id     │
│     │      ├── emitente = cooperativa    │                          │                          │
│     │      └── emitente = interno        │                          │  CONTRATO_ARRENDAMENTO   │
│     │                                    │                          │     │                    │
│     └── QUEBRAS_PRODUCAO ──► perda ──────────────────────────────────────► CONTA_PAGAR        │
│                                          │                          │                          │
└──────────────────────────────────────────┘                          └──────────────────────────┘
               │
               │
               ▼
┌──────────────────────────────────────────┐
│             MECANIZACAO                   │
│                                          │
│  MAQUINAS                                │
│     │                                    │
│     ├── ABASTECIMENTOS ──► custo diesel ──────────────────────────────────► CUSTO_OPERACAO
│     │                                    │
│     ├── MANUTENCOES ──► custo manutencao ─────────────────────────────────► CUSTO_OPERACAO
│     │                                    │
│     └── OPERACOES_CAMPO ──► hora-maquina ─────────────────────────────────► CUSTO_OPERACAO
│                                          │
│  OPERADORES                              │
│     │                                    │
│     └──► mao de obra ─────────────────────────────────────────────────────► CUSTO_OPERACAO
│                                          │
└──────────────────────────────────────────┘
               │
               │
               ▼
┌──────────────────────────────────────────┐
│              PECUARIA                     │
│                                          │
│  ANIMAL → LOTE_ANIMAL                    │
│     │                                    │
│     ├── MANEJO_SANITARIO ──► custo veterinario ───────────────────────────► CUSTO_OPERACAO
│     │                                    │
│     ├── TRATO_ALIMENTAR ◄─── SAIDAS_GRAOS (racao) ──► custo interno      │
│     │                                    │
│     ├── VENDA_ANIMAL ─────────────────────────────────────────────────────► NOTA_FISCAL
│     │        │                           │                                      │
│     │        └───────────────────────────────────────────────────────────► CONTA_RECEBER
│     │                                    │
│     └── COMPRA_ANIMAL ◄──────────────────────────────────────────────────── NOTA_FISCAL
│                │                         │                                      │
│                └─────────────────────────────────────────────────────────► CONTA_PAGAR
│                                          │
└──────────────────────────────────────────┘
```

---

### 2.2 Tabela de Conexoes Diretas

| Modulo Origem | Entidade Origem | Modulo Destino | Entidade Destino | Tipo Conexao | Campo FK |
|---------------|-----------------|----------------|------------------|--------------|----------|
| Agricultura | OPERACAO_CAMPO | Financeiro | CUSTO_OPERACAO | 1:1 | operacao_campo_id |
| Agricultura | PLANTIO_DETALHE | Financeiro | CUSTO_OPERACAO | 1:N | plantio_detalhe_id |
| Agricultura | PULVERIZACAO_DETALHE | Financeiro | CUSTO_OPERACAO | 1:N | pulverizacao_id |
| UBG | SAIDAS_GRAOS | Financeiro | NOTA_FISCAL | N:1 | nota_fiscal_id |
| UBG | SAIDAS_GRAOS | Financeiro | PARCEIRO_COMERCIAL | N:1 | parceiro_id |
| UBG | SAIDAS_GRAOS | Financeiro | CONTRATO_COMERCIAL | N:1 | contrato_id |
| UBG | QUEBRAS_PRODUCAO | Financeiro | CUSTO_OPERACAO | 1:1 | quebra_id |
| Mecanizacao | ABASTECIMENTOS | Financeiro | CUSTO_OPERACAO | 1:1 | abastecimento_id |
| Mecanizacao | MANUTENCOES | Financeiro | CUSTO_OPERACAO | 1:1 | manutencao_id |
| Pecuaria | VENDA_ANIMAL | Financeiro | NOTA_FISCAL | N:1 | nota_fiscal_id |
| Pecuaria | VENDA_ANIMAL | Financeiro | CONTA_RECEBER | 1:1 | conta_receber_id |
| Pecuaria | COMPRA_ANIMAL | Financeiro | NOTA_FISCAL | N:1 | nota_fiscal_id |
| Pecuaria | COMPRA_ANIMAL | Financeiro | CONTA_PAGAR | 1:1 | conta_pagar_id |
| Pecuaria | MANEJO_SANITARIO | Financeiro | CUSTO_OPERACAO | 1:1 | manejo_id |
| Territorial | CONTRATO_ARRENDAMENTO | Financeiro | CONTA_PAGAR | 1:N | contrato_id |
| Financeiro | CONTRATO_ENTREGA | UBG | TICKET_BALANCA | N:1 | ticket_balanca_id |

---

## PARTE 3: DRAFT DETALHADO DAS ENTIDADES

### 3.1 PARCEIRO_COMERCIAL (Entidade Mestre)

**Descricao:** Cadastro unificado de todos os parceiros de negocio.

```
PARCEIRO_COMERCIAL
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── tipo                  ENUM          fornecedor, cliente, cooperativa, arrendador, transportador
├── razao_social          VARCHAR(200)  Nome/Razao social
├── nome_fantasia         VARCHAR(200)  Nome fantasia
├── cnpj_cpf              VARCHAR(20)   CNPJ ou CPF
├── inscricao_estadual    VARCHAR(20)   IE
├── endereco              TEXT          Endereco completo
├── cidade                VARCHAR(100)  Cidade
├── estado                VARCHAR(2)    UF
├── cep                   VARCHAR(10)   CEP
├── telefone              VARCHAR(20)   Telefone principal
├── email                 VARCHAR(100)  Email
├── contato_nome          VARCHAR(100)  Nome do contato
├── banco                 VARCHAR(50)   Banco para pagamento
├── agencia               VARCHAR(20)   Agencia
├── conta                 VARCHAR(30)   Conta
├── pix_chave             VARCHAR(100)  Chave PIX
├── limite_credito        DECIMAL(14,2) Limite de credito
├── prazo_pagamento_dias  INTEGER       Prazo padrao
├── observacoes           TEXT          Notas
├── ativo                 BOOLEAN       Status ativo
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

**Relacionamentos:**
- NOTA_FISCAL (1:N) - Parceiro emite ou recebe NFs
- CONTA_PAGAR (1:N) - Fornecedor recebe pagamentos
- CONTA_RECEBER (1:N) - Cliente deve pagamentos
- CONTRATO_COMERCIAL (1:N) - Parte em contratos
- CONTRATO_ARRENDAMENTO (1:N) - Arrendador de terras

---

### 3.2 CENTRO_CUSTO (Hierarquico)

**Descricao:** Estrutura hierarquica para alocacao de custos.

```
CENTRO_CUSTO
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── parent_id             UUID          FK → CENTRO_CUSTO (self-reference)
├── codigo                VARCHAR(50)   Codigo unico (ex: "01.02.003")
├── nome                  VARCHAR(100)  Nome do centro
├── nivel                 INTEGER       1=Org, 2=Faz, 3=Saf, 4=Cul, 5=Tal
├── tipo                  ENUM          producao, administrativo, comercial, manutencao
├── orcamento_anual       DECIMAL(14,2) Orcamento previsto
├── orcamento_mensal      DECIMAL(14,2) Orcamento mensal
├── permite_lancamento    BOOLEAN       Pode receber lancamentos diretos?
├── fazenda_id            UUID          FK → FAZENDAS (opcional)
├── safra_id              UUID          FK → SAFRAS (opcional)
├── cultura_id            UUID          FK → CULTURAS (opcional)
├── talhao_id             UUID          FK → TALHOES (opcional)
├── ativo                 BOOLEAN       Status
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

**Exemplo de Hierarquia:**

```
01 - SOAL (nivel 1 - Organizacao)
├── 01.01 - Fazenda Santana do Iapo (nivel 2)
│   ├── 01.01.01 - Safra 2025/26 (nivel 3)
│   │   ├── 01.01.01.01 - Soja (nivel 4)
│   │   │   ├── 01.01.01.01.001 - Talhao Bonin (nivel 5)
│   │   │   ├── 01.01.01.01.002 - Talhao Sede (nivel 5)
│   │   │   └── ...
│   │   ├── 01.01.01.02 - Milho (nivel 4)
│   │   ├── 01.01.01.03 - Feijao (nivel 4)
│   │   └── 01.01.01.04 - Trigo (nivel 4)
│   │
│   ├── 01.01.02 - Mecanizacao (nivel 3 - departamento)
│   │   ├── 01.01.02.01 - Tratores
│   │   ├── 01.01.02.02 - Colheitadeiras
│   │   └── 01.01.02.03 - Pulverizadores
│   │
│   └── 01.01.03 - UBG (nivel 3 - departamento)
│       ├── 01.01.03.01 - Secagem
│       └── 01.01.03.02 - Armazenagem
│
├── 01.02 - Fazenda Sao Joao (nivel 2)
│   └── ...
│
└── 01.90 - Administrativo (nivel 2)
    ├── 01.90.01 - Escritorio
    ├── 01.90.02 - RH
    └── 01.90.03 - TI
```

---

### 3.3 CUSTO_OPERACAO

**Descricao:** Registro de cada custo individual alocado a um centro de custo.

```
CUSTO_OPERACAO
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── centro_custo_id       UUID          FK → CENTRO_CUSTO
├── tipo_custo            ENUM          insumo, mao_obra, mecanizacao, servico,
│                                       depreciacao, arrendamento, administrativo
├── subtipo               VARCHAR(50)   Subcategoria (ex: "semente", "diesel", "herbicida")
├── descricao             VARCHAR(200)  Descricao do custo
├── data_custo            DATE          Data do custo
├── quantidade            DECIMAL(12,4) Quantidade
├── unidade               VARCHAR(20)   Unidade (L, kg, ha, h)
├── valor_unitario        DECIMAL(12,4) Valor por unidade
├── valor_total           DECIMAL(14,2) Valor total
├── custo_por_ha          DECIMAL(10,2) Valor / hectares (calculado)
├── rateio_tipo           ENUM          direto, por_area, por_cultura, por_producao
├── rateio_percentual     DECIMAL(5,2)  % se rateado
├── area_rateio_ha        DECIMAL(10,4) Area base do rateio
│
│ -- Referencias opcionais (de onde veio o custo)
├── nota_fiscal_id        UUID          FK → NOTA_FISCAL
├── abastecimento_id      UUID          FK → ABASTECIMENTOS
├── manutencao_id         UUID          FK → MANUTENCOES
├── operacao_campo_id     UUID          FK → OPERACAO_CAMPO
├── aplicacao_insumo_id   UUID          FK → APLICACAO_INSUMO
├── manejo_sanitario_id   UUID          FK → MANEJO_SANITARIO
├── quebra_producao_id    UUID          FK → QUEBRAS_PRODUCAO
│
│ -- Contexto
├── safra_id              UUID          FK → SAFRAS
├── cultura_id            UUID          FK → CULTURAS
├── talhao_id             UUID          FK → TALHOES
├── maquina_id            UUID          FK → MAQUINAS
├── operador_id           UUID          FK → OPERADORES
│
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

**Tipos de Custo e Subtipos:**

| tipo_custo | subtipos |
|------------|----------|
| insumo | semente, fertilizante, herbicida, inseticida, fungicida, adjuvante, calcario, gesso |
| mao_obra | salario, encargos, beneficios, terceiros |
| mecanizacao | diesel, oleo, depreciacao_maquina, manutencao |
| servico | frete, armazenagem, secagem, beneficiamento, consultoria |
| depreciacao | maquinas, edificacoes, benfeitorias |
| arrendamento | terra, equipamento |
| administrativo | escritorio, contabilidade, juridico, seguros |

---

### 3.4 NOTA_FISCAL

**Descricao:** Registro de notas fiscais de entrada e saida.

```
NOTA_FISCAL
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── tipo                  ENUM          entrada, saida
├── numero                VARCHAR(20)   Numero da NF
├── serie                 VARCHAR(5)    Serie
├── chave_nfe             VARCHAR(50)   Chave de acesso (44 digitos)
├── cfop                  VARCHAR(10)   CFOP principal
├── data_emissao          DATE          Data de emissao
├── data_entrada_saida    DATE          Data de entrada/saida
├── parceiro_id           UUID          FK → PARCEIRO_COMERCIAL
├── emitente              ENUM          soal, cooperativa, terceiro
├── valor_produtos        DECIMAL(14,2) Valor dos produtos
├── valor_frete           DECIMAL(12,2) Valor do frete
├── valor_seguro          DECIMAL(12,2) Valor do seguro
├── valor_desconto        DECIMAL(12,2) Descontos
├── valor_icms            DECIMAL(12,2) ICMS
├── valor_ipi             DECIMAL(12,2) IPI
├── valor_pis             DECIMAL(12,2) PIS
├── valor_cofins          DECIMAL(12,2) COFINS
├── valor_total           DECIMAL(14,2) Valor total
├── xml_url               VARCHAR(500)  URL do XML
├── pdf_url               VARCHAR(500)  URL do DANFE
├── status                ENUM          pendente, processada, cancelada
├── origem                ENUM          digitada, importada_xml, integracao_castrolanda
├── castrolanda_sync_id   VARCHAR(50)   ID da integracao Castrolanda
├── processado_por_id     UUID          FK → USERS
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

### 3.5 NOTA_FISCAL_ITEM

**Descricao:** Itens individuais de cada nota fiscal.

```
NOTA_FISCAL_ITEM
├── id                    UUID          PK
├── nota_fiscal_id        UUID          FK → NOTA_FISCAL
├── numero_item           INTEGER       Sequencial do item
├── codigo_produto        VARCHAR(50)   Codigo do produto
├── descricao             VARCHAR(200)  Descricao
├── ncm                   VARCHAR(10)   NCM
├── cfop                  VARCHAR(10)   CFOP do item
├── unidade               VARCHAR(10)   Unidade
├── quantidade            DECIMAL(12,4) Quantidade
├── valor_unitario        DECIMAL(12,4) Valor unitario
├── valor_total           DECIMAL(14,2) Valor total do item
├── valor_desconto        DECIMAL(12,2) Desconto
├── valor_icms            DECIMAL(12,2) ICMS
├── aliquota_icms         DECIMAL(5,2)  Aliquota ICMS
├── valor_ipi             DECIMAL(12,2) IPI
├── aliquota_ipi          DECIMAL(5,2)  Aliquota IPI
│
│ -- Vinculacao com outras entidades
├── insumo_id             UUID          FK → INSUMO (se compra de insumo)
├── cultura_id            UUID          FK → CULTURAS (se venda de grao)
├── saida_grao_id         UUID          FK → SAIDAS_GRAOS (se venda de grao)
├── venda_animal_id       UUID          FK → VENDA_ANIMAL (se venda de gado)
│
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

### 3.6 CONTA_PAGAR

**Descricao:** Obrigacoes a pagar (fornecedores, arrendamentos, etc).

```
CONTA_PAGAR
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── parceiro_id           UUID          FK → PARCEIRO_COMERCIAL
├── centro_custo_id       UUID          FK → CENTRO_CUSTO
├── nota_fiscal_id        UUID          FK → NOTA_FISCAL (opcional)
├── contrato_arrendamento_id UUID       FK → CONTRATO_ARRENDAMENTO (opcional)
├── numero_documento      VARCHAR(50)   Numero do documento
├── descricao             VARCHAR(200)  Descricao
├── categoria             ENUM          insumo, servico, arrendamento, equipamento,
│                                       administrativo, impostos, outros
├── data_emissao          DATE          Data de emissao
├── data_vencimento       DATE          Data de vencimento
├── data_pagamento        DATE          Data do pagamento (se pago)
├── valor_original        DECIMAL(14,2) Valor original
├── valor_juros           DECIMAL(12,2) Juros (se atraso)
├── valor_multa           DECIMAL(12,2) Multa (se atraso)
├── valor_desconto        DECIMAL(12,2) Desconto (se antecipado)
├── valor_pago            DECIMAL(14,2) Valor efetivamente pago
├── status                ENUM          pendente, parcial, paga, cancelada, vencida
├── forma_pagamento       ENUM          boleto, transferencia, pix, cheque, dinheiro
├── banco                 VARCHAR(50)   Banco do pagamento
├── conta_bancaria        VARCHAR(50)   Conta do pagamento
├── comprovante_url       VARCHAR(500)  URL do comprovante
├── safra_id              UUID          FK → SAFRAS
├── cultura_id            UUID          FK → CULTURAS
├── numero_parcela        INTEGER       Numero da parcela (1, 2, 3...)
├── total_parcelas        INTEGER       Total de parcelas
├── pago_por_id           UUID          FK → USERS
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

### 3.7 CONTA_RECEBER

**Descricao:** Valores a receber (clientes, cooperativas, etc).

```
CONTA_RECEBER
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── parceiro_id           UUID          FK → PARCEIRO_COMERCIAL
├── nota_fiscal_id        UUID          FK → NOTA_FISCAL (opcional)
├── contrato_comercial_id UUID          FK → CONTRATO_COMERCIAL (opcional)
├── saida_grao_id         UUID          FK → SAIDAS_GRAOS (opcional)
├── venda_animal_id       UUID          FK → VENDA_ANIMAL (opcional)
├── numero_documento      VARCHAR(50)   Numero do documento
├── descricao             VARCHAR(200)  Descricao
├── categoria             ENUM          venda_grao, venda_gado, servico, arrendamento, outros
├── data_emissao          DATE          Data de emissao
├── data_vencimento       DATE          Data de vencimento
├── data_recebimento      DATE          Data do recebimento (se recebido)
├── valor_original        DECIMAL(14,2) Valor original
├── valor_juros           DECIMAL(12,2) Juros recebidos
├── valor_desconto        DECIMAL(12,2) Desconto concedido
├── valor_recebido        DECIMAL(14,2) Valor efetivamente recebido
├── status                ENUM          pendente, parcial, recebida, cancelada, vencida
├── forma_recebimento     ENUM          boleto, transferencia, pix, cheque, compensacao
├── banco                 VARCHAR(50)   Banco do recebimento
├── conta_bancaria        VARCHAR(50)   Conta do recebimento
├── comprovante_url       VARCHAR(500)  URL do comprovante
├── safra_id              UUID          FK → SAFRAS
├── cultura_id            UUID          FK → CULTURAS
├── numero_parcela        INTEGER       Numero da parcela
├── total_parcelas        INTEGER       Total de parcelas
├── recebido_por_id       UUID          FK → USERS
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

### 3.8 CONTRATO_COMERCIAL

**Descricao:** Contratos de venda de graos (antecipada, barter, fixacao, CPR).

```
CONTRATO_COMERCIAL
├── id                    UUID          PK
├── organization_id       UUID          FK → ORGANIZATIONS
├── numero_contrato       VARCHAR(50)   Numero do contrato
├── tipo                  ENUM          venda_antecipada, barter, fixacao, cpr, spot
├── parceiro_id           UUID          FK → PARCEIRO_COMERCIAL (comprador)
├── safra_id              UUID          FK → SAFRAS
├── cultura_id            UUID          FK → CULTURAS
├── data_contrato         DATE          Data de assinatura
├── data_inicio_entrega   DATE          Inicio do periodo de entrega
├── data_fim_entrega      DATE          Fim do periodo de entrega
├── quantidade_sacas      DECIMAL(12,2) Quantidade contratada (sacas)
├── quantidade_kg         DECIMAL(14,2) Quantidade em kg
├── preco_saca            DECIMAL(10,2) Preco por saca
├── preco_kg              DECIMAL(10,4) Preco por kg
├── moeda                 ENUM          BRL, USD
├── taxa_cambio           DECIMAL(8,4)  Taxa de cambio (se USD)
├── valor_total_estimado  DECIMAL(14,2) Valor total estimado
├── base_preco            ENUM          fixo, cbot, b3, cooperativa
├── premio_desconto       DECIMAL(10,2) Premio ou desconto sobre base
├── local_entrega         VARCHAR(200)  Local de entrega
├── frete_por_conta       ENUM          vendedor, comprador
├── condicoes_qualidade   TEXT          Especificacoes de qualidade
├── penalidades           TEXT          Clausulas de penalidade
├── quantidade_entregue   DECIMAL(14,2) Quantidade ja entregue
├── percentual_entregue   DECIMAL(5,2)  % ja entregue
├── status                ENUM          ativo, em_entrega, concluido, cancelado
├── cpr_documento_id      UUID          FK → CPR_DOCUMENTO (se tipo = cpr)
├── observacoes           TEXT
├── arquivo_contrato_url  VARCHAR(500)  URL do contrato assinado
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

**Campos especificos para BARTER:**

```
│ -- Se tipo = barter
├── barter_insumo_id      UUID          FK → INSUMO (o que recebeu em troca)
├── barter_quantidade     DECIMAL(12,4) Quantidade do insumo
├── barter_valor_insumo   DECIMAL(14,2) Valor equivalente do insumo
├── barter_relacao        VARCHAR(50)   Ex: "1 saca soja = 3kg fertilizante"
```

---

### 3.9 CPR_DOCUMENTO

**Descricao:** Cedula de Produto Rural - documento especifico brasileiro.

```
CPR_DOCUMENTO
├── id                    UUID          PK
├── contrato_comercial_id UUID          FK → CONTRATO_COMERCIAL
├── numero_cpr            VARCHAR(50)   Numero da CPR
├── tipo_cpr              ENUM          fisica, financeira
├── data_emissao          DATE          Data de emissao
├── data_vencimento       DATE          Data de vencimento
├── valor_face            DECIMAL(14,2) Valor nominal
├── valor_liquidacao      DECIMAL(14,2) Valor de liquidacao
├── emitente_nome         VARCHAR(200)  Nome do emitente
├── emitente_cpf_cnpj     VARCHAR(20)   CPF/CNPJ do emitente
├── credor_nome           VARCHAR(200)  Nome do credor
├── credor_cpf_cnpj       VARCHAR(20)   CPF/CNPJ do credor
├── produto               VARCHAR(100)  Produto (Soja, Milho, etc)
├── quantidade            DECIMAL(12,2) Quantidade
├── unidade               VARCHAR(20)   Unidade (sacas, kg, ton)
├── local_entrega         VARCHAR(200)  Local de entrega
├── cartorio_nome         VARCHAR(200)  Cartorio de registro
├── cartorio_cidade       VARCHAR(100)  Cidade do cartorio
├── numero_registro       VARCHAR(50)   Numero do registro em cartorio
├── data_registro         DATE          Data do registro
├── garantias             TEXT          Descricao das garantias
├── garantia_tipo         ENUM          penhor, hipoteca, alienacao, aval, nenhuma
├── garantia_valor        DECIMAL(14,2) Valor da garantia
├── garantia_descricao    TEXT          Descricao detalhada
├── status                ENUM          emitida, registrada, em_vigor, liquidada, inadimplente
├── arquivo_cpr_url       VARCHAR(500)  URL do documento
├── arquivo_registro_url  VARCHAR(500)  URL do registro cartorial
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

### 3.10 CONTRATO_ENTREGA

**Descricao:** Registro de cada entrega vinculada a um contrato.

```
CONTRATO_ENTREGA
├── id                    UUID          PK
├── contrato_comercial_id UUID          FK → CONTRATO_COMERCIAL
├── numero_entrega        INTEGER       Sequencial de entrega (1, 2, 3...)
├── data_entrega          DATE          Data da entrega
├── ticket_balanca_id     UUID          FK → TICKET_BALANCA
├── saida_grao_id         UUID          FK → SAIDAS_GRAOS
├── nota_fiscal_id        UUID          FK → NOTA_FISCAL
├── quantidade_sacas      DECIMAL(12,2) Quantidade entregue (sacas)
├── quantidade_kg         DECIMAL(14,2) Quantidade em kg
├── peso_bruto_kg         DECIMAL(12,2) Peso bruto
├── peso_liquido_kg       DECIMAL(12,2) Peso liquido
├── umidade_percent       DECIMAL(5,2)  Umidade
├── impureza_percent      DECIMAL(5,2)  Impureza
├── desconto_umidade_kg   DECIMAL(10,2) Desconto por umidade
├── desconto_impureza_kg  DECIMAL(10,2) Desconto por impureza
├── peso_final_kg         DECIMAL(12,2) Peso final apos descontos
├── preco_praticado       DECIMAL(10,4) Preco por kg nesta entrega
├── valor_entrega         DECIMAL(14,2) Valor desta entrega
├── placa_veiculo         VARCHAR(10)   Placa do caminhao
├── motorista             VARCHAR(100)  Nome do motorista
├── transportadora        VARCHAR(100)  Transportadora
├── status                ENUM          programada, em_transito, entregue, conferida
├── observacoes           TEXT
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

---

## PARTE 4: FLUXOS DETALHADOS

### 4.1 Fluxo: Compra de Insumo → Custo por Hectare

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE CUSTO - INSUMOS                                │
└────────────────────────────────────────────────────────────────────────────────┘

1. COMPRA
   ┌─────────────────┐
   │ Castrolanda     │ ─── Integracao API ───► INSUMOS_CASTROLANDA
   │ entrega insumo  │                               │
   └─────────────────┘                               │
                                                     ▼
2. NOTA FISCAL                               ┌─────────────────┐
                                             │  NOTA_FISCAL    │
   NF de entrada                             │  tipo: entrada  │
   (XML importado)                           │  parceiro: Cast.│
                                             └────────┬────────┘
                                                      │
                                                      ▼
3. CONTA A PAGAR                             ┌─────────────────┐
                                             │  CONTA_PAGAR    │
   Gera titulo a pagar                       │  categoria: ins.│
   com vencimento                            │  status: pend.  │
                                             └────────┬────────┘
                                                      │
                                                      ▼
4. APLICACAO                                 ┌─────────────────┐
                                             │APLICACAO_INSUMO │
   Insumo aplicado no campo                  │  insumo_id      │
   via OPERACAO_CAMPO                        │  talhao_id      │
   (PULVERIZACAO_DETALHE)                    │  dose_ha        │
                                             └────────┬────────┘
                                                      │
                                                      ▼
5. CUSTO ALOCADO                             ┌─────────────────┐
                                             │ CUSTO_OPERACAO  │
   Custo alocado ao                          │ tipo: insumo    │
   centro de custo                           │ centro_custo_id │
   (Safra/Cultura/Talhao)                    │ valor_total     │
                                             └────────┬────────┘
                                                      │
                                                      ▼
6. CUSTO/HA                                  ┌─────────────────┐
                                             │  CALCULO        │
   custo_por_ha = valor_total / area_ha      │  R$ 250/ha      │
                                             └─────────────────┘
```

---

### 4.2 Fluxo: Venda de Grao → Receita

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE RECEITA - GRAOS                                │
└────────────────────────────────────────────────────────────────────────────────┘

1. CONTRATO (opcional)
   ┌─────────────────┐
   │ CONTRATO_       │
   │ COMERCIAL       │ ─── Se venda antecipada, barter, ou CPR
   │ tipo: xxx       │
   └────────┬────────┘
            │
            ▼
2. SAIDA DO SILO                             ┌─────────────────┐
                                             │  SAIDAS_GRAOS   │
   Grao sai do silo                          │  tipo_saida:    │
   para venda                                │   venda         │
                                             │  tipo_destino:  │
                                             │   commodities   │
                                             └────────┬────────┘
                                                      │
                              ┌────────────────────────┼────────────────────────┐
                              │                        │                        │
                              ▼                        ▼                        ▼
3. EMITENTE DA NF    ┌─────────────┐        ┌─────────────┐        ┌─────────────┐
                     │emitente=SOAL│        │emit=COOPERAT│        │emit=INTERNO │
                     │ (feijao)    │        │ (Castrolanda)│        │ (racao/    │
                     └──────┬──────┘        └──────┬──────┘        │  plantio)   │
                            │                      │               └─────────────┘
                            ▼                      ▼                    (sem NF)
4. NOTA FISCAL       ┌─────────────┐        ┌─────────────┐
                     │ NOTA_FISCAL │        │ NOTA_FISCAL │
                     │ emitente:   │        │ emitente:   │
                     │  soal       │        │  cooperativa│
                     └──────┬──────┘        └──────┬──────┘
                            │                      │
                            └──────────┬───────────┘
                                       │
                                       ▼
5. ENTREGA (se contrato)         ┌─────────────────┐
                                 │CONTRATO_ENTREGA │
   Registra entrega              │ contrato_id     │
   vinculada ao contrato         │ ticket_balanca  │
                                 │ nota_fiscal_id  │
                                 └────────┬────────┘
                                          │
                                          ▼
6. CONTA A RECEBER               ┌─────────────────┐
                                 │ CONTA_RECEBER   │
   Gera titulo a receber         │ parceiro_id     │
   com vencimento                │ valor_original  │
                                 │ status: pendente│
                                 └────────┬────────┘
                                          │
                                          ▼
7. RECEBIMENTO                   ┌─────────────────┐
                                 │ RECEBIMENTO     │
   Baixa do titulo               │ data_recebimento│
   na conta bancaria             │ valor_recebido  │
                                 │ status: recebida│
                                 └─────────────────┘
```

---

### 4.3 Fluxo: Diesel → Custo por Operacao

```
┌────────────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE CUSTO - DIESEL                                 │
└────────────────────────────────────────────────────────────────────────────────┘

1. ABASTECIMENTO
   ┌─────────────────┐
   │  Vestro App     │ ─── Integracao API ───► ABASTECIMENTOS
   │  operador       │                               │
   │  abastece       │                               │
   └─────────────────┘                               │
                                                     │
                                                     ▼
2. DADOS CAPTURADOS                          ┌─────────────────┐
                                             │ ABASTECIMENTOS  │
   - maquina_id                              │ litros: 150     │
   - litros                                  │ horimetro: 5200 │
   - horimetro                               │ maquina_id      │
   - operador                                │ operador_id     │
   - cultura_id                              └────────┬────────┘
                                                      │
                                                      ▼
3. CALCULO CONSUMO                           ┌─────────────────┐
                                             │ CALCULO         │
   consumo_L_hora = litros /                 │ consumo: 12 L/h │
     (horimetro_atual - horimetro_anterior)  │                 │
                                             └────────┬────────┘
                                                      │
                                                      ▼
4. CUSTO ALOCADO                             ┌─────────────────┐
                                             │ CUSTO_OPERACAO  │
   valor = litros x preco_diesel             │ tipo: mecaniz.  │
   centro_custo = cultura do abastecimento   │ subtipo: diesel │
                                             │ valor: R$ 900   │
                                             └────────┬────────┘
                                                      │
                                                      ▼
5. RATEIO                                    ┌─────────────────┐
                                             │ RATEIO          │
   Se cultura nao informada:                 │ por_area ou     │
   rateio proporcional por area              │ por_cultura     │
   das culturas ativas                       └────────┬────────┘
                                                      │
                                                      ▼
6. CUSTO/HA                                  ┌─────────────────┐
                                             │ CUSTO/HA        │
   Soma todos custos diesel                  │ Diesel: R$ 85/ha│
   da cultura / area plantada                └─────────────────┘
```

---

## PARTE 5: KPIs E DASHBOARDS

### 5.1 Dashboard Financeiro Principal

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                         DASHBOARD FINANCEIRO - SOAL                              │
│                              Safra 2025/26                                       │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐     │
│  │   CUSTO TOTAL       │  │   RECEITA TOTAL     │  │   MARGEM BRUTA      │     │
│  │   Safra 2025/26     │  │   Safra 2025/26     │  │                     │     │
│  │                     │  │                     │  │                     │     │
│  │   R$ 12.500.000     │  │   R$ 18.750.000     │  │   R$ 6.250.000      │     │
│  │   ▲ +8% vs 24/25    │  │   ▲ +12% vs 24/25   │  │   33.3%             │     │
│  └─────────────────────┘  └─────────────────────┘  └─────────────────────┘     │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │   CUSTO POR CULTURA (R$/ha)                                              │   │
│  │                                                                          │   │
│  │   Soja     ████████████████████████████████  R$ 5.200/ha                │   │
│  │   Milho    ██████████████████████████        R$ 4.100/ha                │   │
│  │   Feijao   ██████████████████████████████████████████  R$ 7.800/ha      │   │
│  │   Trigo    ████████████████████            R$ 3.500/ha                  │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │   BREAKEVEN vs PRECO ATUAL                                               │   │
│  │                                                                          │   │
│  │   Cultura   │ Breakeven │ Preco Atual │ Margem    │ Status             │   │
│  │   ──────────┼───────────┼─────────────┼───────────┼──────────          │   │
│  │   Soja      │ R$ 86,67  │ R$ 125,00   │ +44,2%    │ ✅ LUCRO           │   │
│  │   Milho     │ R$ 51,25  │ R$ 68,00    │ +32,7%    │ ✅ LUCRO           │   │
│  │   Feijao    │ R$ 195,00 │ R$ 280,00   │ +43,6%    │ ✅ LUCRO           │   │
│  │   Trigo     │ R$ 58,33  │ R$ 55,00    │ -5,7%     │ ⚠️ ATENCAO         │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
│  ┌───────────────────────────────┐  ┌───────────────────────────────┐          │
│  │   CONTAS A PAGAR              │  │   CONTAS A RECEBER            │          │
│  │                               │  │                               │          │
│  │   Vencidas: R$ 45.000 ⚠️      │  │   Vencidas: R$ 0              │          │
│  │   Proximos 7 dias: R$ 180.000 │  │   Proximos 7 dias: R$ 320.000 │          │
│  │   Proximos 30 dias: R$ 520.000│  │   Proximos 30 dias: R$ 850.000│          │
│  │   Total: R$ 1.250.000         │  │   Total: R$ 2.100.000         │          │
│  └───────────────────────────────┘  └───────────────────────────────┘          │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │   COMPOSICAO DE CUSTOS (% do total)                                      │   │
│  │                                                                          │   │
│  │   Insumos      ████████████████████████████████████████  45%            │   │
│  │   Mecanizacao  ██████████████████████  25%                              │   │
│  │   Mao de Obra  ██████████████  15%                                      │   │
│  │   Arrendamento ██████████  10%                                          │   │
│  │   Outros       ████  5%                                                 │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
│                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────┘
```

---

### 5.2 Queries SQL para KPIs

**1. Custo por Hectare por Cultura:**
```sql
SELECT
    c.nome as cultura,
    s.nome as safra,
    SUM(co.valor_total) as custo_total,
    SUM(ts.area_plantada) as area_total,
    SUM(co.valor_total) / SUM(ts.area_plantada) as custo_por_ha
FROM custo_operacao co
JOIN centro_custo cc ON co.centro_custo_id = cc.id
JOIN talhao_safra ts ON cc.talhao_id = ts.talhao_id AND cc.safra_id = ts.safra_id
JOIN culturas c ON ts.cultura_id = c.id
JOIN safras s ON ts.safra_id = s.id
WHERE s.id = :safra_id
GROUP BY c.nome, s.nome
ORDER BY custo_por_ha DESC;
```

**2. Breakeven por Cultura:**
```sql
WITH custos AS (
    SELECT
        c.id as cultura_id,
        c.nome as cultura,
        SUM(co.valor_total) as custo_total,
        SUM(ts.area_plantada) as area_total
    FROM custo_operacao co
    JOIN centro_custo cc ON co.centro_custo_id = cc.id
    JOIN talhao_safra ts ON cc.talhao_id = ts.talhao_id
    JOIN culturas c ON ts.cultura_id = c.id
    WHERE cc.safra_id = :safra_id
    GROUP BY c.id, c.nome
),
producao AS (
    SELECT
        c.id as cultura_id,
        SUM(cd.produtividade_sacas_ha * ts.area_plantada) as producao_sacas
    FROM colheita_detalhe cd
    JOIN operacao_campo oc ON cd.operacao_id = oc.id
    JOIN talhao_safra ts ON oc.talhao_safra_id = ts.id
    JOIN culturas c ON ts.cultura_id = c.id
    WHERE ts.safra_id = :safra_id
    GROUP BY c.id
)
SELECT
    cu.cultura,
    cu.custo_total,
    cu.area_total,
    cu.custo_total / cu.area_total as custo_por_ha,
    p.producao_sacas,
    cu.custo_total / p.producao_sacas as breakeven_por_saca
FROM custos cu
JOIN producao p ON cu.cultura_id = p.cultura_id;
```

**3. Contas a Pagar por Vencimento:**
```sql
SELECT
    CASE
        WHEN data_vencimento < CURRENT_DATE THEN 'Vencidas'
        WHEN data_vencimento <= CURRENT_DATE + INTERVAL '7 days' THEN 'Proximos 7 dias'
        WHEN data_vencimento <= CURRENT_DATE + INTERVAL '30 days' THEN 'Proximos 30 dias'
        ELSE 'Apos 30 dias'
    END as faixa_vencimento,
    COUNT(*) as quantidade,
    SUM(valor_original - COALESCE(valor_pago, 0)) as valor_em_aberto
FROM conta_pagar
WHERE status IN ('pendente', 'parcial', 'vencida')
  AND organization_id = :org_id
GROUP BY faixa_vencimento
ORDER BY MIN(data_vencimento);
```

---

## PARTE 6: PROXIMOS PASSOS

### Checklist de Implementacao

#### Fase 0 - Fundacao
- [ ] Conversa com Claudio: validar estrutura de centro de custo
- [ ] Conversa com Valentina: mapear categorias do AgriWin
- [ ] Conversa com Valentina: entender fluxo de NF (SOAL vs Castrolanda)
- [ ] Definir metodo de rateio padrao para diesel
- [ ] Levantar contratos ativos (CPR, barter, antecipada)

#### Fase 1 - Entidades Core
- [ ] Criar PARCEIRO_COMERCIAL e popular com dados existentes
- [ ] Criar CENTRO_CUSTO hierarquico
- [ ] Criar NOTA_FISCAL + NOTA_FISCAL_ITEM
- [ ] Criar CONTA_PAGAR + CONTA_RECEBER
- [ ] Integracao com INSUMOS_CASTROLANDA

#### Fase 2 - Custos
- [ ] Criar CUSTO_OPERACAO
- [ ] Conectar OPERACAO_CAMPO → CUSTO_OPERACAO
- [ ] Conectar ABASTECIMENTOS → CUSTO_OPERACAO
- [ ] Conectar MANUTENCOES → CUSTO_OPERACAO
- [ ] Implementar logica de rateio

#### Fase 3 - Comercializacao
- [ ] Criar CONTRATO_COMERCIAL
- [ ] Criar CPR_DOCUMENTO
- [ ] Criar CONTRATO_ENTREGA
- [ ] Conectar SAIDAS_GRAOS → NOTA_FISCAL
- [ ] Conectar SAIDAS_GRAOS → CONTRATO_ENTREGA

#### Fase 4 - Dashboards
- [ ] Dashboard: Custo por hectare
- [ ] Dashboard: Breakeven
- [ ] Dashboard: Contas a pagar/receber
- [ ] Dashboard: Margem por cultura
- [ ] Alertas: Contas vencidas

---

### TBCs para Validar

| # | Pergunta | Responsavel | Status |
|---|----------|-------------|--------|
| 1 | Qual a estrutura de centro de custo no AgriWin? | Valentina | [ ] |
| 2 | Como e feito o rateio de diesel hoje? | Claudio | [ ] |
| 3 | Quais categorias de despesa existem? | Valentina | [ ] |
| 4 | Existem CPRs ativos? Quantos? | Claudio | [ ] |
| 5 | Como funcionam os contratos barter? | Claudio | [ ] |
| 6 | Quem emite NF de venda de feijao? | Valentina | [ ] |
| 7 | Como e feita a baixa de contas a pagar? | Valentina | [ ] |
| 8 | Qual banco/conta usam? | Valentina | [ ] |

---

*Documento gerado em 08/02/2026 - DeepWork AI Flows*
*Draft para validacao com stakeholders*
