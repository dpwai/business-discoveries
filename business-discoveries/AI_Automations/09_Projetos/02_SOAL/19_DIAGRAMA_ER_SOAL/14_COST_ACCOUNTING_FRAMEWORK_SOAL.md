# COST ACCOUNTING FRAMEWORK - SOAL

**Data:** 09/02/2026
**Versao:** 1.0
**Status:** Draft para Revisao com Claudio
**Perspectiva:** Cost Accounting Expert aplicado ao Agronegocio
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## 1. Objetivo deste Documento

Este documento define a **metodologia de custeio** completa para a SOAL. Nao estamos falando de entidades de banco de dados aqui -- estamos falando de **como pensar sobre custos** na operacao agropecuaria, de forma que o Claudio consiga:

1. Saber exatamente quanto custa produzir 1 hectare de cada cultura
2. Saber quanto custa produzir 1 saca de cada grao
3. Comparar safras, fazendas, talhoes e culturas entre si
4. Tomar decisoes de plantio baseadas em numeros reais, nao intuicao
5. Identificar onde esta perdendo dinheiro e onde esta ganhando

A pergunta que move tudo: **"Quanto custa produzir 1 saca de soja no Talhao Bonin na Safra 25/26?"**

---

## 2. Filosofia de Custeio: Absorption Costing Adaptado

### 2.1 Por que Absorption Costing?

No agronegocio, a decisao correta e usar **custeio por absorcao** (absorption costing), onde TODOS os custos de producao sao alocados ao produto final (grao colhido). A razao:

- O Claudio precisa saber o **custo real completo** por saca para definir preco de venda
- Bancos e cooperativas exigem demonstracao de custo total para linhas de credito (Plano Safra)
- O breakeven price so faz sentido com custo total absorvido
- A legislacao brasileira (ITR, IR) trabalha com custo de producao completo

### 2.2 O Que Isso Significa na Pratica

```
CUSTO TOTAL POR HECTARE = Custos Diretos + Custos Indiretos Alocados

Onde:
  Custos Diretos    = tudo que consigo alocar diretamente ao talhao/cultura
  Custos Indiretos  = tudo que preciso ratear (distribuir proporcionalmente)
```

### 2.3 Complemento: Margem de Contribuicao

Embora o custeio oficial seja por absorcao, o sistema tambem deve calcular a **margem de contribuicao** (custeio variavel) para decisoes de curto prazo:

```
Margem de Contribuicao = Receita - Custos Variaveis

Util para:
  - Decidir se planta trigo na safrinha (curto prazo)
  - Avaliar se aceita um contrato spot abaixo do custo total
  - Priorizar culturas quando ha restricao de area
```

---

## 3. Classificacao de Custos SOAL

### 3.1 Matriz de Classificacao

Todo custo da SOAL se encaixa em duas dimensoes simultaneas:

| | **DIRETO** (alocavel ao talhao) | **INDIRETO** (precisa rateio) |
|---|---|---|
| **VARIAVEL** (muda com area/producao) | Sementes, Defensivos, Fertilizantes, Diesel de operacao em talhao especifico | Diesel sem cultura definida, Manutencao preventiva geral |
| **FIXO** (nao muda com area) | Arrendamento de talhao especifico | Salarios fixos, Depreciacao, Seguro, Administrativo |

### 3.2 Categorias Detalhadas

#### A) CUSTOS DIRETOS VARIAVEIS (maior volume, maior precisao)

Sao os custos que **nascem vinculados a um talhao/cultura especifica**.

| Categoria | Subcategorias | Origem no Sistema | Exemplo SOAL |
|-----------|---------------|-------------------|--------------|
| **Sementes** | Soja, Milho, Feijao, Trigo | PLANTIO_DETALHE + INSUMOS_CASTROLANDA | 4.5 sacas/ha soja = R$ 1.350/ha |
| **Fertilizantes** | Base (plantio), Cobertura, Foliar | PULVERIZACAO_DETALHE + INSUMOS_CASTROLANDA | MAP 08-40-00 = R$ 650/ha |
| **Defensivos** | Herbicida, Inseticida, Fungicida, Adjuvante | PULVERIZACAO_DETALHE + INSUMOS_CASTROLANDA | 3-4 aplicacoes/safra = R$ 800-1.200/ha |
| **Corretivos** | Calcario, Gesso | OPERACAO_CAMPO (calagem, gessagem) | R$ 200-400/ha (amortizado em 3-4 anos) |
| **Tratamento de Sementes** | Fungicida, Inseticida, Inoculante | PLANTIO_DETALHE | R$ 80-150/ha |
| **Secagem** | Lenha, Energia do secador | CONTROLE_SECAGEM | R$ 15-30/ton dependendo umidade |
| **Frete campo-UBG** | Transporte interno | TRANSPORTE_COLHEITA_DETALHE | R$ 8-15/ton |

#### B) CUSTOS DIRETOS FIXOS

Custos fixos que conseguimos alocar a um talhao ou cultura.

| Categoria | Subcategorias | Origem no Sistema | Exemplo SOAL |
|-----------|---------------|-------------------|--------------|
| **Arrendamento** | Terra arrendada especifica | CONTRATO_ARRENDAMENTO | R$ X sacas soja/ha/ano |
| **Irrigacao** | Sistema fixo em talhao especifico | CENTRO_CUSTO infraestrutura | R$ Y/ha irrigado |

#### C) CUSTOS INDIRETOS VARIAVEIS (precisam rateio)

Custos que variam com a atividade mas nao sabemos para qual cultura foram.

| Categoria | Subcategorias | Base de Rateio Recomendada | Exemplo SOAL |
|-----------|---------------|---------------------------|--------------|
| **Diesel (sem cultura)** | Abastecimentos gerais | Horas-maquina por cultura OU area proporcional | Trator fez servico geral |
| **Manutencao corretiva** | Pecas, servicos de maquina | Horas-maquina da maquina por cultura | Troca de correia da colheitadeira |
| **Mao de obra temporaria** | Diaristas, safristas | Area plantada por cultura | Funcionarios de safra |
| **Drone terceirizado** | Servico de aplicacao | Area aplicada (direto se possivel) | R$/ha contratado |

#### D) CUSTOS INDIRETOS FIXOS (overhead)

Custos que existem independente de quanto se planta.

| Categoria | Subcategorias | Base de Rateio Recomendada | Exemplo SOAL |
|-----------|---------------|---------------------------|--------------|
| **Depreciacao maquinas** | Tratores, colheitadeiras, pulverizadores | Horas-maquina por cultura | R$ 150.000/ano colheitadeira S680 |
| **Depreciacao edificacoes** | Galpao, oficina, UBG | Area plantada por fazenda | R$ 50.000/ano |
| **Salarios fixos** | Operadores, mecanico, administrativo | Area plantada por cultura | Tiago, Josmar, etc |
| **Encargos** | INSS, FGTS, 13o, ferias | Segue salario | ~70% sobre salario |
| **Seguro agricola** | Proagro, seguro privado | Diretamente pela cultura segurada | R$/ha por cultura |
| **Seguro maquinas** | Frota | Valor segurado por maquina | R$/ano por equipamento |
| **Administrativo** | Escritorio, contabilidade, TI | Receita bruta por fazenda/cultura | R$ 10.000-15.000/mes |
| **Impostos/taxas** | ITR, licencas ambientais | Area total | R$/ha |
| **Custos financeiros** | Juros, IOF, tarifas | Valor financiado por cultura | Custeio Plano Safra |

---

## 4. Objetos de Custo: A Hierarquia do "Para Quem"

### 4.1 O Que e um Objeto de Custo?

Um objeto de custo e "aquilo que estamos custeando". No caso da SOAL, existem **5 niveis de objetos de custo**, do mais granular ao mais consolidado:

```
NIVEL 5 (mais granular): TALHAO-SAFRA-CULTURA
  "Quanto custou produzir soja no Talhao Bonin na Safra 25/26?"

NIVEL 4: CULTURA-FAZENDA-SAFRA
  "Quanto custou produzir soja na Santana do Iapo na Safra 25/26?"

NIVEL 3: SAFRA-FAZENDA
  "Quanto custou a Safra 25/26 inteira na Santana do Iapo?"

NIVEL 2: FAZENDA
  "Quanto custou operar a Santana do Iapo no ano?"

NIVEL 1: ORGANIZACAO
  "Quanto custou operar a SOAL inteira no ano?"
```

### 4.2 Regra de Ouro

**Custos devem ser alocados no nivel MAIS GRANULAR possivel.** Se sabemos que o diesel foi para a soja no Talhao Bonin, alocamos la. Se so sabemos que foi na fazenda, alocamos na fazenda e rateamos depois.

```
PRINCIPIO: Alocar no nivel mais baixo possivel, ratear so quando necessario

BOM:  Semente de soja → Talhao Bonin (nivel 5)
BOM:  Diesel do trator durante plantio da soja → Talhao Bonin (nivel 5)
OK:   Diesel do trator em servico geral → Mecanizacao Santana (rateio para nivel 4)
RUIM: Jogar tudo em "custo da safra" sem detalhar por cultura
```

### 4.3 Unidades de Medida dos Objetos de Custo

| Objeto de Custo | Unidade de Area | Unidade de Producao | KPI Principal |
|-----------------|-----------------|---------------------|---------------|
| Talhao-Safra-Cultura | hectare (ha) | sacas de 60kg | R$/ha e R$/saca |
| Cultura-Fazenda-Safra | hectare (ha) | sacas de 60kg | R$/ha e R$/saca |
| Safra-Fazenda | hectare (ha) | R$ receita | R$/ha e margem % |
| Fazenda | hectare total | R$ receita | R$/ha e margem % |
| Organizacao | hectare total | R$ receita | R$/ha e margem % |

---

## 5. Metodo de Acumulacao: Job Costing Agricola

### 5.1 Cada Talhao-Safra e um "Job"

No cost accounting industrial, existe o conceito de **job costing** (custeio por ordem) onde cada "trabalho" acumula seus proprios custos. Na SOAL, cada **TALHAO_SAFRA** e um job:

```
JOB: Talhao Bonin - Soja - Safra 25/26
├── Area: 85,5 ha
├── Periodo: Jul/2025 - Jun/2026
│
├── CUSTOS ACUMULADOS:
│   ├── Sementes:        R$  115.425  (R$ 1.350/ha)
│   ├── Fertilizantes:   R$   55.575  (R$   650/ha)
│   ├── Defensivos:      R$   85.500  (R$ 1.000/ha)
│   ├── Corretivos:      R$   17.100  (R$   200/ha - amortizado)
│   ├── Diesel direto:   R$   34.200  (R$   400/ha)
│   ├── Secagem:         R$   12.825  (R$   150/ha)
│   ├── [rateio] Deprec: R$   25.650  (R$   300/ha)
│   ├── [rateio] Salario: R$  21.375  (R$   250/ha)
│   ├── [rateio] Admin:  R$    8.550  (R$   100/ha)
│   └── [rateio] Outros: R$   12.825  (R$   150/ha)
│
├── CUSTO TOTAL:         R$  389.025
├── CUSTO/HA:            R$    4.550
│
├── PRODUCAO:
│   ├── Produtividade:   60 sacas/ha
│   ├── Producao total:  5.130 sacas
│   └── CUSTO/SACA:      R$    75,83
│
├── RECEITA:
│   ├── Preco venda:     R$   125,00/saca
│   ├── Receita total:   R$  641.250
│   └── MARGEM BRUTA:    R$  252.225 (39,3%)
│
└── BREAKEVEN PRICE:     R$    75,83/saca
```

### 5.2 Por Que Job Costing e Nao Process Costing

| Criterio | Job Costing (escolhido) | Process Costing |
|----------|------------------------|-----------------|
| Cada talhao e unico? | Sim - solo, historico, variedade diferentes | Nao se aplica |
| Custos sao rastreados por unidade? | Sim - por talhao/cultura | Nao - media geral |
| Produto e homogeneo? | Nao - cada talhao tem produtividade diferente | Sim |
| Precisa comparar "jobs"? | Sim - comparar talhoes, culturas, safras | Nao |

---

## 6. Sistema de Rateio (Overhead Allocation)

### 6.1 Principios de Rateio

```
1. PROPORCIONALIDADE: O rateio deve refletir o consumo real do recurso
2. MATERIALIDADE: So rateia custos relevantes (>1% do custo total)
3. SIMPLICIDADE: Prefere-se uma base de rateio simples e explicavel
4. CONSISTENCIA: Mesmo criterio safra apos safra (comparabilidade)
5. CAUSALIDADE: A base de rateio deve ter relacao causal com o custo
```

### 6.2 Bases de Rateio por Tipo de Custo

| Custo Indireto | Base de Rateio | Formula | Justificativa |
|----------------|----------------|---------|---------------|
| **Diesel sem cultura** | Area plantada (ha) | custo_total x (area_cultura / area_total) | Simplificacao aceitavel |
| **Depreciacao trator** | Horas-maquina (h) | deprec_anual x (horas_cultura / horas_total) | Uso real da maquina |
| **Depreciacao colheitadeira** | Horas de colheita (h) | deprec_anual x (horas_colheita_cultura / horas_total) | So colhe na safra |
| **Depreciacao pulverizador** | Area pulverizada (ha) | deprec_anual x (area_pulv_cultura / area_pulv_total) | Uso direto |
| **Depreciacao UBG** | Toneladas processadas | deprec_anual x (ton_cultura / ton_total) | Volume processado |
| **Salarios operadores** | Horas-maquina (h) | salario_anual x (horas_cultura / horas_total) | Operador segue a maquina |
| **Salario mecanico** | Horas manutencao (h) | salario_anual x (horas_manut_cultura / horas_total) | Se tem dado, senao por area |
| **Salario administrativo** | Area plantada (ha) | salario_anual x (area_cultura / area_total) | Simplificacao |
| **Seguro agricola** | Diretamente a cultura | valor_seguro_cultura | Cada cultura tem seu seguro |
| **Seguro maquinas** | Horas-maquina (h) | seguro_anual x (horas_cultura / horas_total) | Uso proporcional |
| **Custos financeiros** | Valor financiado | juros x (financ_cultura / financ_total) | Custeio e por cultura |
| **Administrativo geral** | Receita bruta (R$) | admin x (receita_cultura / receita_total) | Quem gera mais receita absorve mais |

### 6.3 Exemplo Pratico de Rateio

**Cenario:** Depreciacao anual da Colheitadeira S680 = R$ 150.000

```
Horas de colheita na Safra 25/26:
  Soja:   280 horas (56%)
  Milho:  120 horas (24%)
  Feijao:  50 horas (10%)
  Trigo:   50 horas (10%)
  TOTAL:  500 horas (100%)

Rateio:
  Soja:   R$ 150.000 x 56% = R$ 84.000
  Milho:  R$ 150.000 x 24% = R$ 36.000
  Feijao: R$ 150.000 x 10% = R$ 15.000
  Trigo:  R$ 150.000 x 10% = R$ 15.000

Custo/ha:
  Soja:   R$ 84.000 / 421,8 ha = R$ 199/ha
  Milho:  R$ 36.000 / 185,5 ha = R$ 194/ha
  Feijao: R$ 15.000 /  85,0 ha = R$ 176/ha
  Trigo:  R$ 15.000 / 120,0 ha = R$ 125/ha
```

### 6.4 Hierarquia de Preferencia de Rateio

Quando nao sabemos a base ideal, seguir esta ordem:

```
1. HORAS-MAQUINA (melhor - dado real de uso)
   Fonte: OPERACAO_CAMPO.horimetro_fim - horimetro_inicio

2. AREA TRABALHADA (bom - dado real de cobertura)
   Fonte: OPERACAO_CAMPO.area_trabalhada_ha

3. AREA PLANTADA (aceitavel - proporcao simples)
   Fonte: TALHAO_SAFRA.area_plantada

4. RECEITA BRUTA (ultimo recurso - quem gera mais paga mais)
   Fonte: SAIDAS_GRAOS.valor_total por cultura
```

---

## 7. Tratamento de Custos Especiais

### 7.1 Corretivos de Solo (Calcario e Gesso)

**Problema:** Calcario e gesso tem efeito residual de 3-4 anos. Jogar o custo inteiro no ano de aplicacao distorce o custo/ha.

**Solucao: Amortizacao**
```
Custo calcario aplicado: R$ 120.000 (200 ha x R$ 600/ha)
Vida util estimada: 4 anos (safras)

Custo por safra: R$ 120.000 / 4 = R$ 30.000/safra
Custo por ha por safra: R$ 30.000 / 200 ha = R$ 150/ha/safra

No sistema:
  CUSTO_OPERACAO.tipo_custo = 'insumo'
  CUSTO_OPERACAO.subtipo = 'calcario_amortizado'
  CUSTO_OPERACAO.valor_total = R$ 30.000 (1/4 do total)
  Campo extra: amortizacao_safras_restantes = 3
```

**Pergunta para Claudio:** Em quantas safras voce amortiza calcario e gesso? 3? 4?

### 7.2 Depreciacao de Maquinario

**Metodo recomendado:** Depreciacao por uso (horas-maquina), nao linear.

```
Colheitadeira S680:
  Valor aquisicao: R$ 1.500.000
  Valor residual estimado: R$ 300.000
  Vida util estimada: 8.000 horas

  Depreciacao por hora = (1.500.000 - 300.000) / 8.000 = R$ 150/hora

  Safra 25/26: 500 horas colhendo
  Depreciacao safra: 500 x R$ 150 = R$ 75.000
```

**Pergunta para Claudio:** Qual a vida util estimada (em horas) das principais maquinas? Colheitadeira, trator, pulverizador?

### 7.3 Arrendamento de Terra

**Cenario A:** Arrendamento em dinheiro (R$/ha/ano)
```
Custo direto fixo → alocar ao talhao arrendado
```

**Cenario B:** Arrendamento em produto (sacas soja/ha/ano)
```
Converter para R$ usando preco de referencia do momento do pagamento
Custo direto fixo → alocar ao talhao arrendado
```

**Cenario C:** Terra propria
```
Custo de oportunidade = valor que receberia se arrendasse
Nao contabilizar como custo real, mas mostrar em relatorio separado
como "custo de oportunidade" para comparacao com arrendamento
```

**Pergunta para Claudio:** Como sao os contratos de arrendamento? Em dinheiro ou em sacas? Quanto por hectare?

### 7.4 Barter (Troca de Graos por Insumos)

```
Contrato Barter com Castrolanda:
  SOAL entrega: 500 sacas soja
  SOAL recebe: 10 ton fertilizante MAP

No custeio:
  1. Registra CONTRATO_COMERCIAL tipo 'barter'
  2. O fertilizante entra como insumo a valor de mercado
  3. A soja sai como venda ao preco de conversao do barter
  4. A diferenca (se houver) e custo financeiro ou ganho
```

### 7.5 Custo da UBG (Secagem e Armazenagem)

A UBG e um centro de custo de apoio que presta "servico" para as culturas:

```
CUSTOS UBG:
├── Lenha para secador:      R$ 80.000/safra
├── Energia eletrica UBG:    R$ 25.000/safra
├── Depreciacao equipamentos: R$ 40.000/safra
├── Salario operadores UBG:  R$ 60.000/safra
├── Manutencao:              R$ 20.000/safra
└── TOTAL:                   R$ 225.000/safra

RATEIO por tonelada processada:
  Soja:   3.000 ton (60%)  → R$ 135.000
  Milho:  1.200 ton (24%)  → R$  54.000
  Feijao:   400 ton (8%)   → R$  18.000
  Trigo:    400 ton (8%)   → R$  18.000

Custo UBG por ha:
  Soja:   R$ 135.000 / 421,8 ha = R$ 320/ha
  Milho:  R$  54.000 / 185,5 ha = R$ 291/ha
  Feijao: R$  18.000 /  85,0 ha = R$ 212/ha
  Trigo:  R$  18.000 / 120,0 ha = R$ 150/ha
```

### 7.6 Quebras de Producao

```
Quebra de secagem = custo de producao (aumenta custo/saca)
Quebra de armazenagem = custo de producao (aumenta custo/saca)

Calculo:
  Producao colhida: 5.130 sacas soja
  Quebra secagem: 2% = 102,6 sacas
  Quebra armazenagem: 0,5% = 25,65 sacas
  Producao liquida: 5.001,75 sacas

  Custo total: R$ 389.025
  Custo/saca SEM quebra: R$ 75,83
  Custo/saca COM quebra: R$ 77,78

  Impacto da quebra: +R$ 1,95/saca (+2,6%)
```

**Pergunta para Claudio:** Quais sao os percentuais tipicos de quebra? Por secagem? Por armazenagem? Por cultura?

---

## 8. Custo por Etapa do Ciclo Produtivo

### 8.1 Composicao Tipica de Custo por Hectare (Soja)

Esta e a estrutura que o Claudio precisa validar com os numeros reais dele:

```
CUSTO DE PRODUCAO - SOJA - REFERENCIA (R$/ha)
==================================================================

1. INSUMOS (Custos Diretos Variaveis)
   ├── Sementes                          R$ 1.200 - 1.500
   ├── Fertilizantes base (plantio)      R$   600 -   800
   ├── Adubacao cobertura                R$   200 -   400
   ├── Herbicidas (2-3 aplicacoes)       R$   300 -   500
   ├── Inseticidas (2-3 aplicacoes)      R$   200 -   400
   ├── Fungicidas (2-3 aplicacoes)       R$   300 -   500
   ├── Adjuvantes/outros                 R$    50 -   100
   ├── Tratamento de sementes            R$    80 -   150
   └── Inoculante                        R$    15 -    30
   SUBTOTAL INSUMOS:                     R$ 2.945 - 4.380
   % do custo total:                     55% - 65%

2. OPERACOES MECANICAS (Custos Variaveis + Rateio)
   ├── Preparo de solo                   R$   200 -   350
   │   (gradagem, subsolagem, nivelamento)
   ├── Plantio                           R$   150 -   250
   ├── Pulverizacoes (5-7 passadas)      R$   250 -   450
   ├── Colheita                          R$   300 -   500
   ├── Transporte interno                R$    80 -   150
   └── Diesel total                      R$   350 -   600
   SUBTOTAL OPERACOES:                   R$ 1.330 - 2.300
   % do custo total:                     25% - 30%

3. POS-COLHEITA (Rateio UBG)
   ├── Secagem                           R$   100 -   200
   ├── Armazenagem                       R$    50 -   100
   └── Beneficiamento                    R$    30 -    50
   SUBTOTAL POS-COLHEITA:               R$   180 -   350
   % do custo total:                     3% - 5%

4. CUSTOS FIXOS E OVERHEAD (Rateio)
   ├── Depreciacao maquinas              R$   250 -   400
   ├── Salarios e encargos               R$   200 -   350
   ├── Arrendamento (se aplicavel)       R$   300 -   600
   ├── Seguro agricola                   R$    80 -   150
   ├── Administrativo                    R$    80 -   120
   ├── Custos financeiros                R$   100 -   200
   └── Corretivos amortizados            R$   100 -   200
   SUBTOTAL FIXOS/OVERHEAD:             R$ 1.110 - 2.020
   % do custo total:                     15% - 25%

==================================================================
CUSTO TOTAL ESTIMADO/HA (SOJA):         R$ 5.565 - 9.050
MEDIA REFERENCIA:                        R$ 5.200 - 6.500/ha

Com produtividade de 55-65 sacas/ha:
CUSTO POR SACA:                          R$ 80 - 118/saca
BREAKEVEN com 60 sacas/ha:               R$ 87 - 108/saca
```

**Pergunta para Claudio:** Esses ranges fazem sentido para a realidade da SOAL? Onde vocees se encaixam?

---

## 9. KPIs Financeiros Essenciais

### 9.1 KPIs Operacionais (por Safra/Cultura)

| KPI | Formula | Meta | Frequencia |
|-----|---------|------|------------|
| **Custo por hectare** | Custo Total / Area Plantada | Menor que benchmark regional | Mensal durante safra |
| **Custo por saca** | Custo Total / Producao (sacas) | Menor que preco de venda | Apos colheita |
| **Breakeven price** | Custo Total / Producao (sacas) | Menor que preco mercado | Apos colheita |
| **Margem bruta/ha** | (Receita - Custo) / Area | Positiva, >20% | Apos venda |
| **Margem bruta %** | (Receita - Custo) / Receita x 100 | >25% | Apos venda |
| **Produtividade** | Producao (sacas) / Area (ha) | >media regional | Apos colheita |
| **Custo insumos/ha** | Soma insumos / Area | Benchmark Castrolanda | Pre-plantio |
| **Custo mecanizacao/ha** | Soma mec / Area | Benchmark regional | Mensal |

### 9.2 KPIs de Eficiencia

| KPI | Formula | O Que Mede |
|-----|---------|------------|
| **Consumo diesel L/ha** | Litros totais / Area trabalhada | Eficiencia mecanica |
| **Horas-maquina/ha** | Horas totais / Area trabalhada | Eficiencia operacional |
| **Custo manutencao/hora** | Custo manutencao / Horas maquina | Saude da frota |
| **Quebra de producao %** | (Esperado - Real) / Esperado x 100 | Eficiencia pos-colheita |
| **Custo secagem/ton** | Custo UBG / Toneladas secadas | Eficiencia UBG |
| **% custo fixo** | Custos fixos / Custo total x 100 | Alavancagem operacional |

### 9.3 KPIs Financeiros (Contas a Pagar/Receber)

| KPI | Formula | Meta |
|-----|---------|------|
| **Saldo contas a pagar** | Soma valores pendentes | Menor que disponivel |
| **Saldo contas a receber** | Soma valores pendentes | Cobrar antes de pagar |
| **Prazo medio pagamento** | Media dias para pagar | Maximizar sem atraso |
| **Prazo medio recebimento** | Media dias para receber | Minimizar |
| **Gap de caixa** | Recebimento medio - Pagamento medio | Positivo (recebe antes) |
| **Contratos entregues %** | Quantidade entregue / Contratada | Acompanhar compromissos |

---

## 10. Periodo de Custeio: Ano Agricola vs Ano Calendario

### 10.1 Definicao

```
ANO AGRICOLA (SAFRA): Jul/YYYY a Jun/YYYY+1
  - E o periodo correto para custeio de producao
  - Custos de Jul/25 a Jun/26 = Safra 2025/26
  - Coincide com ciclo biologico (preparo → colheita)

ANO CALENDARIO: Jan a Dez
  - Usado para contabilidade fiscal (IR, IRPJ)
  - Pode cruzar 2 safras

O SISTEMA DEVE SUPORTAR AMBOS:
  - Relatorios por SAFRA para gestao operacional
  - Relatorios por ANO CALENDARIO para fiscal
```

### 10.2 Custos que Cruzam Safras

```
Exemplo: Calcario aplicado em Mai/2025
  - Pertence a Safra 2025/26 (aplicado no preparo)
  - Mas amortizado tambem em 2026/27, 2027/28, 2028/29

Exemplo: Colheita de trigo safrinha em Out/2025
  - Pertence a Safra 2024/25 (plantado na safrinha anterior)
  - Receita de venda pode cair em 2025 ou 2026

O campo safra_id em CUSTO_OPERACAO resolve isso:
  - Cada custo e vinculado a UMA safra
  - Independente do mes calendario em que ocorreu
```

**Pergunta para Claudio:** Qual o mes exato que voce considera inicio e fim da safra? Jul-Jun? Ago-Jul?

---

## 11. Fluxo Completo de Custeio (End-to-End)

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                        FLUXO DE CUSTEIO SOAL - END TO END                        │
└──────────────────────────────────────────────────────────────────────────────────┘

FASE 1: PLANEJAMENTO (antes do plantio)
─────────────────────────────────────────
  ORCAMENTO por cultura/talhao
  ├── Custo estimado por ha (baseado em safra anterior + precos atuais)
  ├── Area planejada por cultura
  ├── Producao estimada (produtividade x area)
  ├── Receita estimada (producao x preco futuro)
  └── Margem projetada

  Decisao: Qual cultura plantar onde? Vale plantar trigo na safrinha?

FASE 2: COMPRA DE INSUMOS
─────────────────────────
  Castrolanda entrega insumos → INSUMOS_CASTROLANDA
       │
       ▼
  NOTA_FISCAL (entrada) → CONTA_PAGAR
       │
       └── Custo do insumo registrado, aguardando uso no campo

FASE 3: OPERACOES DE CAMPO
───────────────────────────
  Cada operacao gera custo:

  OPERACAO_CAMPO
       │
       ├── Custo de INSUMO aplicado (semente, defensivo, fertilizante)
       │   └── CUSTO_OPERACAO tipo=insumo, subtipo=semente/herbicida/etc
       │
       ├── Custo de DIESEL consumido
       │   └── CUSTO_OPERACAO tipo=mecanizacao, subtipo=diesel
       │
       ├── Custo de MAO DE OBRA (horas do operador)
       │   └── CUSTO_OPERACAO tipo=mao_obra, subtipo=salario
       │
       └── Custo de DEPRECIACAO (horas da maquina)
           └── CUSTO_OPERACAO tipo=depreciacao, subtipo=maquinas

FASE 4: POS-COLHEITA
─────────────────────
  COLHEITA_DETALHE (producao medida)
       │
       ▼
  TICKET_BALANCA → RECEBIMENTO_GRAOS → CONTROLE_SECAGEM → ESTOQUE_SILOS
       │
       └── Custos de secagem, armazenagem → CUSTO_OPERACAO tipo=servico

FASE 5: RATEIO PERIODICO (mensal ou ao fim da safra)
─────────────────────────────────────────────────────
  Custos indiretos acumulados nos centros de apoio:

  MECANIZACAO (01.01.800)
       │
       └── Diesel sem cultura + Depreciacao + Manutencao geral
           Rateio por horas-maquina → distribui para cada cultura

  UBG (01.01.810)
       │
       └── Lenha + Energia + Pessoal + Depreciacao secador
           Rateio por tonelada processada → distribui para cada cultura

  ADMINISTRATIVO (01.90)
       │
       └── Escritorio + RH + TI + Contabilidade
           Rateio por area plantada → distribui para cada fazenda/cultura

FASE 6: APURACAO DE RESULTADO
──────────────────────────────
  Por talhao-safra-cultura:

  CUSTO TOTAL = Soma todos CUSTO_OPERACAO do centro_custo
  PRODUCAO = COLHEITA_DETALHE.producao_total_kg - QUEBRAS_PRODUCAO
  RECEITA = SAIDAS_GRAOS.valor_total

  ┌─────────────────────────────────────────────────────────┐
  │ RESULTADO: TALHAO BONIN - SOJA - SAFRA 25/26           │
  ├─────────────────────────────────────────────────────────┤
  │ Custo Total:        R$ 389.025                          │
  │ Custo/ha:           R$   4.550                          │
  │ Producao:           5.002 sacas (pos-quebra)            │
  │ Custo/saca:         R$   77,78                          │
  │ Receita:            R$ 641.250                          │
  │ Margem Bruta:       R$ 252.225 (39,3%)                  │
  │ Breakeven:          R$  77,78/saca                      │
  │ Preco Mercado:      R$ 125,00/saca                      │
  │ Margem de Seguranca: R$ 47,22/saca (37,8%)             │
  └─────────────────────────────────────────────────────────┘
```

---

## 12. Orcamento vs Realizado (Variance Analysis)

### 12.1 Conceito

O sistema deve permitir comparar o **orcado** (planejado) com o **realizado** (efetivo):

```
CENTRO_CUSTO tem:
  orcamento_anual   = quanto planejou gastar no ano
  orcamento_mensal  = quanto planejou gastar no mes

CUSTO_OPERACAO acumula:
  valor_total = quanto efetivamente gastou

VARIACAO = Realizado - Orcado
  Se positiva: gastou mais que o planejado (desfavoravel)
  Se negativa: gastou menos que o planejado (favoravel)
```

### 12.2 Analise de Variacao por Componente

| Componente | Orcado/ha | Realizado/ha | Variacao | Causa Provavel |
|------------|-----------|--------------|----------|----------------|
| Sementes | R$ 1.350 | R$ 1.400 | +R$ 50 (desf.) | Preco subiu 3,7% |
| Defensivos | R$ 1.000 | R$ 1.200 | +R$ 200 (desf.) | Aplicacao extra fungicida (ferrugem) |
| Diesel | R$ 400 | R$ 380 | -R$ 20 (fav.) | Menor consumo GPS |
| Secagem | R$ 150 | R$ 200 | +R$ 50 (desf.) | Safra mais umida |

**Pergunta para Claudio:** Voce faz orcamento por safra hoje? Mesmo que no caderno? Que categorias usa?

---

## 13. Questoes Estrategicas para Validar com Claudio

### 13.1 Sobre Custos Diretos

| # | Pergunta | Por Que Importa | Resposta Claudio |
|---|----------|-----------------|------------------|
| 1 | Quais sao as culturas plantadas hoje e areas aproximadas? | Definir objetos de custo | |
| 2 | Quantos talhoes existem e quais sao os nomes? | Nivel mais granular de custeio | |
| 3 | Como voce compra insumos? Tudo via Castrolanda ou tem outros? | Fluxo de nota fiscal | |
| 4 | Existe barter? Como funciona na pratica? | Tratamento contabil especifico | |
| 5 | Sementes: compra certificada ou usa proprias? | Impacta custo/ha | |

### 13.2 Sobre Custos Indiretos e Rateio

| # | Pergunta | Por Que Importa | Resposta Claudio |
|---|----------|-----------------|------------------|
| 6 | Quando o trator abastece, o operador sabe para qual cultura esta trabalhando? | Se sim, custo direto. Se nao, rateio | |
| 7 | Maquinas sao compartilhadas entre fazendas? | Rateio entre fazendas | |
| 8 | Como voce calcula depreciacao hoje? Vida util das maquinas? | Base para rateio | |
| 9 | Quantos funcionarios fixos e quanto ganham (faixa)? | Custo fixo de mao de obra | |
| 10 | Existem funcionarios temporarios na safra? | Custo variavel de mao de obra | |

### 13.3 Sobre Arrendamento e Custos Fixos

| # | Pergunta | Por Que Importa | Resposta Claudio |
|---|----------|-----------------|------------------|
| 11 | Quais terras sao proprias e quais arrendadas? | Custo direto fixo | |
| 12 | Arrendamento e em R$/ha ou sacas/ha? Quanto? | Conversao e alocacao | |
| 13 | Em quantas safras amortiza calcario? E gesso? | Custo amortizado | |
| 14 | Quais seguros tem? Proagro? Privado? Valores? | Custo fixo por cultura | |

### 13.4 Sobre Receita e Comercializacao

| # | Pergunta | Por Que Importa | Resposta Claudio |
|---|----------|-----------------|------------------|
| 15 | Como vende soja? Via Castrolanda? Preco fixo ou CBOT? | Fluxo de receita | |
| 16 | Feijao: vende direto? Para quem? Quem emite NF? | Fluxo diferente dos outros graos | |
| 17 | Tem CPR ativo? Quantos? Que valores? | Obrigacoes futuras | |
| 18 | Tem contratos de venda antecipada? Quanto ja travou? | Receita ja comprometida | |
| 19 | Qual quebra tipica de secagem e armazenagem por cultura? | Impacto no custo/saca | |

### 13.5 Sobre Orcamento e Decisao

| # | Pergunta | Por Que Importa | Resposta Claudio |
|---|----------|-----------------|------------------|
| 20 | Voce faz orcamento por safra? Que nivel de detalhe? | Baseline para variance analysis | |
| 21 | Como decide o que plantar em cada talhao? | Criterio de decisao a sistematizar | |
| 22 | Qual o custo/saca que voce estima "de cabeca" hoje? | Validar nosso modelo vs intuicao | |
| 23 | Inicio e fim do ano agricola: Jul-Jun? Ago-Jul? | Periodo de apuracao | |
| 24 | Tem financiamento Plano Safra? Quanto e a que taxa? | Custo financeiro por cultura | |

---

## 14. Impacto no Modelo ER: O Que Muda

### 14.1 Campo Novo em CUSTO_OPERACAO

```
-- Adicionar para suportar orcamento vs realizado
orcamento_referencia    DECIMAL(14,2)  Valor orcado para comparacao
variacao                DECIMAL(14,2)  Realizado - Orcado (calculado)
variacao_tipo           ENUM           favoravel, desfavoravel, neutro

-- Adicionar para suportar amortizacao
amortizacao_origem_id   UUID           FK -> CUSTO_OPERACAO (custo original)
amortizacao_parcela     INTEGER        Parcela atual (1 de 4, etc)
amortizacao_total       INTEGER        Total de parcelas
```

### 14.2 Entidade Nova: ORCAMENTO_SAFRA

```
ORCAMENTO_SAFRA
├── id                    UUID          PK
├── organization_id       UUID          FK -> ORGANIZATIONS
├── safra_id              UUID          FK -> SAFRAS
├── centro_custo_id       UUID          FK -> CENTRO_CUSTO
├── categoria             ENUM          insumo, mecanizacao, mao_obra, servico,
│                                       depreciacao, arrendamento, administrativo
├── subcategoria          VARCHAR(50)   Detalhe (semente, diesel, etc)
├── valor_previsto        DECIMAL(14,2) Valor orcado
├── valor_por_ha          DECIMAL(10,2) Valor orcado por ha
├── area_prevista_ha      DECIMAL(10,4) Area prevista
├── producao_prevista_sacas DECIMAL(12,2) Producao prevista
├── preco_venda_previsto  DECIMAL(10,2) Preco de venda estimado
├── observacoes           TEXT
├── aprovado_por          UUID          FK -> USERS
├── data_aprovacao        DATE
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

### 14.3 Entidade Nova: DEPRECIACAO_ATIVO

```
DEPRECIACAO_ATIVO
├── id                    UUID          PK
├── organization_id       UUID          FK -> ORGANIZATIONS
├── maquina_id            UUID          FK -> MAQUINAS (ou ativo generico)
├── descricao             VARCHAR(200)  Nome do ativo
├── valor_aquisicao       DECIMAL(14,2) Valor de compra
├── data_aquisicao        DATE          Data de compra
├── valor_residual        DECIMAL(14,2) Valor residual estimado
├── vida_util_horas       DECIMAL(10,2) Vida util em horas (preferencial)
├── vida_util_anos        INTEGER       Vida util em anos (alternativo)
├── metodo                ENUM          por_uso, linear, acelerada
├── depreciacao_por_hora  DECIMAL(10,4) Valor por hora (calculado)
├── depreciacao_anual     DECIMAL(14,2) Valor por ano (se linear)
├── horas_acumuladas      DECIMAL(12,2) Total horas ja depreciadas
├── valor_depreciado_acum DECIMAL(14,2) Total ja depreciado
├── valor_contabil_atual  DECIMAL(14,2) Valor aquisicao - depreciado
├── ativo                 BOOLEAN       Ativo ou baixado
├── created_at            TIMESTAMP
└── updated_at            TIMESTAMP
```

### 14.4 View: CUSTO_COMPLETO_POR_TALHAO

```sql
CREATE VIEW vw_custo_completo_talhao AS
SELECT
    ts.id as talhao_safra_id,
    t.nome as talhao,
    c.nome as cultura,
    s.ano_agricola as safra,
    f.nome as fazenda,
    ts.area_plantada as area_ha,

    -- Custos diretos
    SUM(CASE WHEN co.rateio_tipo = 'direto' THEN co.valor_total ELSE 0 END) as custo_direto,

    -- Custos rateados
    SUM(CASE WHEN co.rateio_tipo != 'direto' THEN co.valor_total ELSE 0 END) as custo_rateado,

    -- Total
    SUM(co.valor_total) as custo_total,
    SUM(co.valor_total) / ts.area_plantada as custo_por_ha,

    -- Breakdown por tipo
    SUM(CASE WHEN co.tipo_custo = 'insumo' THEN co.valor_total ELSE 0 END) as custo_insumos,
    SUM(CASE WHEN co.tipo_custo = 'mecanizacao' THEN co.valor_total ELSE 0 END) as custo_mecanizacao,
    SUM(CASE WHEN co.tipo_custo = 'mao_obra' THEN co.valor_total ELSE 0 END) as custo_mao_obra,
    SUM(CASE WHEN co.tipo_custo = 'depreciacao' THEN co.valor_total ELSE 0 END) as custo_depreciacao,
    SUM(CASE WHEN co.tipo_custo = 'servico' THEN co.valor_total ELSE 0 END) as custo_servicos,
    SUM(CASE WHEN co.tipo_custo = 'arrendamento' THEN co.valor_total ELSE 0 END) as custo_arrendamento,
    SUM(CASE WHEN co.tipo_custo = 'administrativo' THEN co.valor_total ELSE 0 END) as custo_administrativo,

    -- Producao (se disponivel)
    COALESCE(prod.producao_sacas, 0) as producao_sacas,
    CASE WHEN COALESCE(prod.producao_sacas, 0) > 0
         THEN SUM(co.valor_total) / prod.producao_sacas
         ELSE NULL
    END as custo_por_saca

FROM talhao_safra ts
JOIN talhoes t ON ts.talhao_id = t.id
JOIN culturas c ON ts.cultura_id = c.id
JOIN safras s ON ts.safra_id = s.id
JOIN fazendas f ON t.fazenda_id = f.id
LEFT JOIN custo_operacao co ON co.centro_custo_id IN (
    SELECT id FROM centro_custo WHERE talhao_id = t.id AND safra_id = s.id
)
LEFT JOIN (
    SELECT
        oc.talhao_safra_id,
        SUM(cd.produtividade_sacas_ha * ts2.area_plantada) as producao_sacas
    FROM colheita_detalhe cd
    JOIN operacao_campo oc ON cd.operacao_id = oc.id
    JOIN talhao_safra ts2 ON oc.talhao_safra_id = ts2.id
    GROUP BY oc.talhao_safra_id
) prod ON prod.talhao_safra_id = ts.id

GROUP BY ts.id, t.nome, c.nome, s.ano_agricola, f.nome, ts.area_plantada, prod.producao_sacas;
```

---

## 15. Resumo Executivo para Apresentar ao Claudio

### O Que Estamos Construindo

Um sistema que responde automaticamente:

1. **"Quanto custou produzir soja este ano?"** → R$ X.XXX/ha, R$ XX/saca
2. **"Onde estou gastando mais?"** → Insumos 55%, Mecanizacao 25%, ...
3. **"Vale plantar trigo na safrinha?"** → Breakeven R$ 58/saca vs mercado R$ 55 - margem negativa
4. **"Quanto ja entreguei do contrato Castrolanda?"** → 60% das 2.000 sacas
5. **"Quanto tenho a pagar este mes?"** → R$ 180.000 nos proximos 7 dias
6. **"Talhao Bonin ou Talhao Sede: qual produz melhor?"** → Bonin: R$ 4.550/ha, Sede: R$ 5.200/ha

### O Que Preciso do Claudio

1. Validar os **ranges de custo** (secao 8) com numeros reais
2. Responder as **24 perguntas** (secao 13) para calibrar o modelo
3. Confirmar **regras de rateio** (secao 6.2) - especialmente diesel e depreciacao
4. Definir **periodo da safra** (Jul-Jun ou outro?)
5. Informar **vida util das maquinas** para depreciacao correta

### O Que NAO Muda

A hierarquia de centro de custo (doc 13) e as entidades do financeiro (doc 12) continuam validas. Este documento **complementa** aqueles com a logica de como os custos fluem dentro da estrutura.

---

## 16. Proximos Passos

| # | Acao | Responsavel | Prazo |
|---|------|-------------|-------|
| 1 | Revisar este documento internamente | Rodrigo + Joao | Antes da reuniao |
| 2 | Agendar sessao com Claudio (2-3h) | Rodrigo | Proxima semana |
| 3 | Apresentar doc 13 (Centro Custo) + doc 14 (este) | Rodrigo | Na sessao |
| 4 | Coletar respostas das 24 perguntas | Claudio | Na sessao |
| 5 | Ajustar modelo com dados reais | Rodrigo + Claude | Pos-sessao |
| 6 | Preencher ORCAMENTO_SAFRA com Safra 25/26 | Claudio + Rodrigo | Pos-sessao |
| 7 | Validar com Joao viabilidade tecnica | Joao | Pos-ajuste |

---

*Documento gerado em 09/02/2026 - DeepWork AI Flows*
*Perspectiva de Cost Accounting Expert aplicado ao Agronegocio*
*Para revisao interna e posterior validacao com Claudio Kugler*
