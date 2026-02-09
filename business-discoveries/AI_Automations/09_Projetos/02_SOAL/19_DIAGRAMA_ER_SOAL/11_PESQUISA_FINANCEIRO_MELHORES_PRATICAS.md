# PESQUISA: Modulo Financeiro Agropecuario - Melhores Praticas

**Data:** 08/02/2026
**Versao:** 1.0
**Autor:** Claude + Rodrigo Kugler
**Objetivo:** Levantar boas praticas internacionais para estruturar o modulo financeiro do SOAL

---

## 1. Executive Summary

Esta pesquisa consolidou informacoes de fontes dos EUA (USDA, Universidades, Software Leaders) e Brasil (ERPs Agricolas) para identificar as melhores praticas em sistemas financeiros para agronegocio.

### Principais Descobertas

| Area | Melhor Pratica | Fonte |
|------|----------------|-------|
| **Custeio** | Custo por acre/hectare + por bushel/saca | Iowa State, Wisconsin Extension |
| **Centro de Custo** | Hierarquia Parent/Child alinhada ao IRS Schedule F | Farmonaut, Farmbrite |
| **KPIs** | 18 indicadores em 4 categorias (Liquidity, Solvency, Profitability, Efficiency) | USDA, Braintrust Ag |
| **Contratos** | Forward, Basis, HTA, Minimum Price, Barter | CME Group, Iowa State |
| **Estoque** | Reconciliacao automatica Physical vs Virtual | Greenstone, BinMaster |
| **Integracao** | Field data → Accounting em tempo real | Traction Ag, NetSuite |

---

## 2. Estrutura de Plano de Contas (Chart of Accounts)

### 2.1 Padrao Internacional (Alinhado ao IRS Schedule F)

O padrao americano organiza contas alinhadas ao formulario fiscal Schedule F, facilitando a geracao de relatorios para o governo.

**Estrutura Recomendada:**

```
ASSETS (Ativos)
├── Current Assets
│   ├── Cash and Checking
│   ├── Accounts Receivable
│   ├── Inventory - Grain
│   ├── Inventory - Livestock
│   ├── Inventory - Supplies
│   └── Prepaid Expenses
│
├── Fixed Assets
│   ├── Land
│   ├── Buildings & Improvements
│   ├── Machinery & Equipment
│   ├── Vehicles
│   └── Accumulated Depreciation
│
└── Other Assets
    ├── Breeding Stock
    └── Investments

LIABILITIES (Passivos)
├── Current Liabilities
│   ├── Accounts Payable
│   ├── Operating Loans
│   ├── Current Portion Long-Term Debt
│   └── Accrued Expenses
│
└── Long-Term Liabilities
    ├── Real Estate Loans
    ├── Equipment Loans
    └── Other Long-Term Debt

EQUITY (Patrimonio)
├── Owner's Capital
├── Retained Earnings
└── Current Year Earnings

INCOME (Receitas)
├── Crop Sales
│   ├── Soybeans
│   ├── Corn
│   ├── Wheat
│   └── Beans (Feijao)
│
├── Livestock Sales
│   ├── Market Cattle
│   ├── Cull Animals
│   └── Breeding Stock
│
├── Government Payments
│   ├── Direct Payments
│   ├── Conservation Programs
│   └── Disaster Payments
│
├── Cooperative Distributions
│
└── Other Income
    ├── Custom Work
    ├── Rental Income
    └── Insurance Proceeds

EXPENSES (Despesas)
├── Variable Costs (Custos Variaveis)
│   ├── Seeds & Plants
│   ├── Fertilizer & Lime
│   ├── Chemicals (Pesticides/Herbicides)
│   ├── Fuel & Oil
│   ├── Custom Hire (Servicos Terceiros)
│   ├── Hired Labor
│   ├── Repairs & Maintenance
│   └── Supplies
│
├── Fixed Costs (Custos Fixos)
│   ├── Depreciation
│   ├── Interest Expense
│   ├── Insurance
│   ├── Property Taxes
│   ├── Rent & Leases
│   └── Utilities
│
└── Overhead (Custos Indiretos)
    ├── Professional Fees
    ├── Office Expenses
    ├── Vehicle Expenses
    └── Miscellaneous
```

**Fonte:** [Farmonaut - Agriculture Chart of Accounts](https://farmonaut.com/blogs/agriculture-chart-of-accounts-essential-accounting-steps), [FastBooks Template](https://fastbooks.app/resources/chart-of-accounts/for-agriculture-farming/)

### 2.2 Hierarquia Parent/Child

**Conceito:** Contas pai agrupam contas filhas para consolidacao de relatorios.

**Exemplo:**
```
LIVESTOCK EXPENSES (Parent)
├── Medical Expenses (Child)
├── Feed Expenses (Child)
├── Processing Expenses (Child)
└── Breeding Expenses (Child)
```

**Beneficio:** Permite ver totais individuais das filhas E total consolidado do pai.

**Fonte:** [Farmbrite - Chart of Accounts](https://help.farmbrite.com/help/chart-of-accounts)

---

## 3. Centro de Custos (Cost Centers)

### 3.1 Estrutura Hierarquica Recomendada

```
ORGANIZATION (SOAL)
│
├── FAZENDA (ex: Santana do Iapo)
│   │
│   ├── SAFRA (ex: 2025/26)
│   │   │
│   │   ├── CULTURA (ex: Soja, Milho, Feijao)
│   │   │   │
│   │   │   └── TALHAO (ex: Bonin, Sede)
│   │   │       │
│   │   │       └── OPERACAO (Plantio, Pulverizacao, Colheita)
│   │   │
│   │   └── LOTE_ANIMAL (para pecuaria)
│   │
│   └── DEPARTAMENTO
│       ├── Mecanizacao
│       ├── UBG (Silos)
│       └── Administrativo
│
└── PECUARIA
    ├── Cria
    ├── Recria
    └── Engorda
```

### 3.2 Alocacao de Custos (Cost Allocation)

**Metodos de Rateio:**

| Metodo | Aplicacao | Formula |
|--------|-----------|---------|
| **Por Area** | Diesel, Mao de Obra, Arrendamento | Custo Total / Hectares Plantados |
| **Por Cultura** | Insumos especificos | Custo Direto na Cultura |
| **Por Operacao** | Hora-maquina | Custo/Hora x Horas Trabalhadas |
| **Por Cabeca** | Pecuaria | Custo Total / Numero de Cabecas |

**Comportamento de Custos:**

> "Fuel and labor costs per acre are constant regardless of acres covered. However, overhead costs per acre decline as usage increases."
> - Iowa State Extension

**Fonte:** [Iowa State - Estimating Farm Machinery Costs](https://www.extension.iastate.edu/agdm/crops/html/a3-29.html)

---

## 4. Custo de Producao por Unidade

### 4.1 Formula Base (Enterprise Budget)

```
CUSTO DE PRODUCAO = (Custos Variaveis + Custos Fixos) / Producao

Onde:
- Custos Variaveis: sementes, fertilizantes, defensivos, combustivel, mao de obra temporaria
- Custos Fixos: depreciacao, juros, impostos, seguro, arrendamento
- Producao: kg, sacas, bushels
```

### 4.2 Calculo de Breakeven (Ponto de Equilibrio)

```
Preco Breakeven = Custos Totais Projetados / Produtividade Esperada

Exemplo SOAL:
- Custo Total Soja: R$ 5.000/ha
- Produtividade: 60 sc/ha
- Breakeven: R$ 83,33/saca
```

**Fonte:** [Wisconsin Extension - Cost of Production](https://farms.extension.wisc.edu/articles/breakeven-cost-of-production-how-to-calculate/)

### 4.3 Componentes do Enterprise Budget

| Componente | Descricao | Exemplo |
|------------|-----------|---------|
| **Income** | Receita esperada | Preco x Producao |
| **Variable Costs** | Custos que variam com producao | Sementes, Fertilizantes, Diesel |
| **Fixed Costs** | Custos independentes de producao | Depreciacao, Arrendamento |
| **Returns Above Variable Costs** | Margem de Contribuicao | Income - Variable Costs |
| **Returns Above Total Costs** | Lucro Liquido | Income - Total Costs |

**Fonte:** [Penn State - Budgeting for Agricultural Decision Making](https://extension.psu.edu/budgeting-for-agricultural-decision-making), [Oklahoma State - Enterprise Budgets](https://extension.okstate.edu/fact-sheets/using-enterprise-budgets-in-farm-financial-planning.html)

---

## 5. KPIs e Metricas Financeiras

### 5.1 Farm Finance Scorecard (4 Categorias)

O Farm Finance Scorecard organiza metricas em 4 categorias principais:

#### A. PROFITABILITY (Rentabilidade)

| KPI | Formula | Meta |
|-----|---------|------|
| **Net Profit Margin** | Lucro Liquido / Receita Total | > 10% |
| **Return on Assets (ROA)** | Lucro Liquido / Ativos Totais | > 5% |
| **Return on Equity (ROE)** | Lucro Liquido / Patrimonio Liquido | > 8% |
| **Gross Margin per Acre** | (Receita - Custos Variaveis) / Acres | Varia por cultura |
| **Operating Profit Margin** | EBIT / Receita | > 15% |

#### B. LIQUIDITY (Liquidez)

| KPI | Formula | Meta |
|-----|---------|------|
| **Current Ratio** | Ativos Circulantes / Passivos Circulantes | > 1.5 |
| **Working Capital** | Ativos Circulantes - Passivos Circulantes | Positivo |
| **Working Capital to Gross Revenue** | Working Capital / Receita Bruta | > 0.3 |

#### C. SOLVENCY (Solvencia)

| KPI | Formula | Meta |
|-----|---------|------|
| **Debt to Asset Ratio** | Passivo Total / Ativo Total | < 0.4 |
| **Equity to Asset Ratio** | Patrimonio / Ativo Total | > 0.6 |
| **Debt to Equity Ratio** | Passivo / Patrimonio | < 0.67 |

#### D. EFFICIENCY (Eficiencia)

| KPI | Formula | Meta |
|-----|---------|------|
| **Asset Turnover** | Receita Total / Ativos Totais | > 0.25 |
| **Operating Expense Ratio** | Despesas Operacionais / Receita | < 0.7 |
| **Interest Expense Ratio** | Juros / Receita | < 0.1 |
| **Labor Efficiency** | Receita / Numero de Funcionarios | Maximizar |

**Fonte:** [PerformYard - Agriculture KPIs 2025](https://www.performyard.com/articles/agriculture-performance-indicators), [FCS America - Key Financial Metrics 2025](https://www.fcsamerica.com/resources/learning-center/key-financial-metrics-to-monitor-in-2025), [Braintrust Ag - 18 Farm Financial Ratios](https://braintrustag.com/18-farm-financial-ratios-what-gets-measured-gets-managed/)

### 5.2 Recomendacao para 2025/26

> "For 2025, three key financial measures are recommended: fixed costs, liquidity and family living expenditures."
> - FCS America

> "Most operations find it helpful to start small by tracking three to five core KPIs such as yield per acre, water usage, and labor costs."
> - PerformYard

---

## 6. Contratos de Comercializacao

### 6.1 Tipos de Contratos (EUA)

| Tipo | Descricao | Risco | Equivalente BR |
|------|-----------|-------|----------------|
| **Forward Cash** | Preco fixo, entrega futura | Baixo | Venda Antecipada |
| **Basis Contract** | Fixa basis, futuro aberto | Medio | Fixacao de Base |
| **Hedge-to-Arrive (HTA)** | Fixa futuro, basis aberto | Medio | Travamento de Preco |
| **Minimum Price** | Preco minimo garantido | Baixo | Preco Minimo |
| **Delayed Price** | Preco definido apos entrega | Alto | Preco a Fixar |

**Fonte:** [Iowa State - Commonly Used Grain Contracts](https://www.extension.iastate.edu/agdm/crops/html/a2-73.html)

### 6.2 Hedge-to-Arrive (HTA) em Detalhe

> "The hedge-to-arrive (HTA) contract was developed as a hybrid contract that would feature the best aspects of a forward contract with the basis flexibility."

**Componentes:**
- **Futures Price**: Fixado no momento do contrato
- **Basis**: Determinado posteriormente, geralmente antes da entrega
- **Risk**: Produtor assume o risco de basis

**Fonte:** [Iowa State - HTA Contracts](https://www.extension.iastate.edu/agdm/crops/html/a2-74.html)

### 6.3 Barter (Troca) - Pratica Brasileira

> "Barter is an exchange of agricultural inputs for grains, which often facilitates rural business planning and works as a hedging strategy."

**Vantagens:**
- Protecao contra flutuacoes cambiais
- Protecao contra variacao de precos
- Liquidez para o produtor (nao precisa de capital de giro)
- Operacao travada desde o inicio

**Inputs mais comuns em Barter:**
1. Fertilizantes
2. Sementes
3. Defensivos
4. Maquinas/Implementos

**Atencao:** Verificar se a cesta de insumos tem preco justo.

**Fonte:** [AgriBrasilis - How Do Barter Contracts Work](https://agribrasilis.com/2023/10/04/how-barter-contracts-work/)

### 6.4 CPR (Cedula de Produto Rural) - Brasil

Equivalente brasileiro aos contratos forward, com caracteristicas especificas:
- Registro em cartorio
- Garantias (penhor, hipoteca)
- Valor de face
- Tipos: Fisica ou Financeira

---

## 7. Gestao de Estoque de Graos

### 7.1 Virtual vs Fisico

**Conceito-chave:** Diferenciar estoque contabil (virtual) do estoque medido (fisico).

> "O que tem na planilha e um estoque virtual, sabe? Nao e o estoque real."
> - Claudio Kugler (SOAL)

**Pratica Recomendada:**

| Campo | Descricao |
|-------|-----------|
| `quantidade_virtual_kg` | Calculado por entradas - saidas - quebras estimadas |
| `quantidade_real_kg` | Medido fisicamente ou por sensor |
| `diferenca_kg` | Virtual - Real |
| `percentual_diferenca` | (Diferenca / Virtual) * 100 |

### 7.2 Reconciliacao Automatizada

> "Multi-location views allow comparison of physical, scale, and booked positions for fast, accurate reconciliations."

**Tecnologias Modernas:**
- Sensores IoT em silos (temperatura, umidade, nivel)
- Integracao automatica balanca → sistema
- Alertas de variancia

**Fonte:** [Greenstone - Grain Management](https://greenstonesystems.com/grain-management-solutions/), [BinMaster - AgriView](https://binmaster.com/agriview)

### 7.3 Rastreabilidade de Lotes

**Campos Recomendados:**
```
LOTE_GRAO
├── lote_id (UUID)
├── origem_talhao
├── safra_id
├── cultura_id
├── data_entrada
├── umidade_entrada
├── classificacao
├── silo_atual
├── historico_movimentacoes (JSON)
└── destino_final (venda/semente/racao)
```

---

## 8. Integracao Operacoes → Financeiro

### 8.1 Principio Fundamental

> "Traction Ag takes an accounting-first approach to farm management, directly linking every field operation to financial records."

**Fluxo Recomendado:**

```
OPERACAO_CAMPO (Plantio/Pulverizacao/Colheita)
         │
         │ automatico
         ▼
    CUSTO_OPERACAO
         │
         ├── insumo_id → preco_unitario
         ├── combustivel_litros → preco_diesel
         ├── horas_maquina → custo_hora
         └── mao_obra → custo_hora_homem
         │
         ▼
    CENTRO_CUSTO (Safra/Cultura/Talhao)
         │
         ▼
    CUSTO_POR_HECTARE
```

### 8.2 Integracao em Tempo Real

**Beneficios:**
- Decisoes baseadas em dados atualizados
- Eliminacao de retrabalho
- Reducao de erros manuais
- Visibilidade imediata de custos

**Fontes de Dados:**
- John Deere Operations Center
- Vestro (abastecimentos)
- Castrolanda (insumos/notas)
- Planilhas de campo

**Fonte:** [NetSuite - Farm Accounting](https://www.netsuite.com/portal/industries/agriculture-accounting.shtml), [Traction Ag](https://tractionag.com/)

---

## 9. Softwares de Referencia

### 9.1 EUA - Lideres de Mercado

| Software | Destaque | Preco (USD/ano) |
|----------|----------|-----------------|
| **Traction Ag** | Custo por acre, integracao JD | $950 - $3,800 |
| **Harvest Profit** | Analise de rentabilidade em tempo real | Variavel |
| **NetSuite Farm** | ERP completo, multi-entidade | Enterprise |
| **FarmBooks** | Simples, alinhado Schedule F | Acessivel |
| **Farmbrite** | Pecuaria + Agricultura | Acessivel |

### 9.2 Brasil - ERPs Agricolas

| Software | Destaque |
|----------|----------|
| **Siagri** | Lider no Brasil, completo |
| **Aegro** | Focado em gestao agricola |
| **AGROV** | ERP + Marketplace integrado |
| **Senior Agribusiness** | Visao 360 de operacoes |
| **AgriWin** | Usado pela SOAL atualmente |

**Fonte:** [Mosaic Agrotech - Top 10 ERPs](https://mosaicagro.tech/top-10-erps-para-o-agronegocio-transformando-a-gestao-rural-digital/)

---

## 10. Recomendacoes para SOAL

### 10.1 Estrutura Financeira Proposta

```
CAMADA FINANCEIRO (SOAL)
│
├── CENTRO_CUSTO (hierarquico)
│   ├── Org → Fazenda → Safra → Cultura → Talhao
│   └── Org → Fazenda → Departamento (Mecanizacao, UBG)
│
├── CUSTO_OPERACAO
│   ├── tipo: insumo, mao_obra, mecanizacao, servico, depreciacao
│   └── rateio: por_area, por_cultura, direto
│
├── NOTAS_FISCAIS
│   ├── Entrada (compras)
│   └── Saida (vendas)
│
├── CONTAS
│   ├── CONTA_PAGAR → vincula NF entrada
│   └── CONTA_RECEBER → vincula NF saida ou contrato
│
├── CONTRATOS
│   ├── CONTRATO_COMERCIAL (venda_antecipada, barter, fixacao, cpr)
│   ├── CONTRATO_ARRENDAMENTO
│   └── CPR_DOCUMENTO
│
└── PARCEIRO_COMERCIAL
    └── tipos: fornecedor, cliente, cooperativa, arrendador, transportador
```

### 10.2 Conexoes com Outros Modulos

| Modulo | Entidade | Conexao Financeira |
|--------|----------|-------------------|
| **Agricultura** | OPERACAO_CAMPO | → CUSTO_OPERACAO (insumos, mao_obra) |
| **Agricultura** | PLANTIO_DETALHE | → custo sementes, fertilizantes |
| **Agricultura** | COLHEITA_DETALHE | → receita projetada |
| **UBG** | SAIDAS_GRAOS | → NOTA_FISCAL, CONTA_RECEBER |
| **UBG** | QUEBRAS_PRODUCAO | → perda financeira |
| **Mecanizacao** | ABASTECIMENTOS | → CUSTO_OPERACAO (diesel) |
| **Mecanizacao** | MANUTENCOES | → CUSTO_OPERACAO (manutencao) |
| **Pecuaria** | VENDAS_GADO | → NOTA_FISCAL, CONTA_RECEBER |
| **Pecuaria** | TRATO_ALIMENTAR | → custo racao (graos internos) |
| **Territorial** | CONTRATO_ARRENDAMENTO | → CONTA_PAGAR |

### 10.3 KPIs Prioritarios para SOAL

**Fase 1 (MVP):**
1. Custo por hectare por cultura
2. Margem bruta por cultura
3. Custo de diesel por operacao
4. Contas a pagar vencidas

**Fase 2:**
5. ROA (Return on Assets)
6. Current Ratio (Liquidez)
7. Custo por saca produzida
8. Breakeven price por cultura

**Fase 3:**
9. Asset Turnover
10. Labor Efficiency
11. Debt to Asset Ratio
12. Net Profit Margin

### 10.4 Fluxos Financeiros Principais

#### A. Fluxo de Custos (Entrada)
```
NF_COMPRA → INSUMO_CASTROLANDA → APLICACAO_INSUMO → TALHAO_SAFRA
     │                                                    │
     ▼                                                    │
CONTA_PAGAR ────────────────────────────────────────────► CUSTO/HA
```

#### B. Fluxo de Receitas (Venda)
```
COLHEITA → TRANSPORTE → UBG → SAIDAS_GRAOS
                               │
                               ├── emitente = SOAL ──────► NF_SAIDA_SOAL
                               ├── emitente = CASTROLANDA ► NF_COOPERATIVA
                               └── emitente = INTERNO ────► sem NF (racao/plantio)
                                        │
                                        ▼
                                   CONTA_RECEBER
```

#### C. Fluxo de Contratos
```
CONTRATO_COMERCIAL (tipo: venda_antecipada/barter/cpr)
         │
         ├── tipo = barter ──► INSUMO recebido
         │
         └── tipo = cpr ──────► CPR_DOCUMENTO
                                     │
                                     ├── garantias
                                     └── cartorio
         │
         ▼
CONTRATO_ENTREGA
         │
         ├── ticket_balanca_id (saida fisica)
         └── nota_fiscal_id (documento fiscal)
```

---

## 11. Proximos Passos

### 11.1 Decisoes a Tomar

1. [ ] Validar estrutura de centro de custo com Claudio
2. [ ] Definir metodo de rateio para diesel e mao de obra
3. [ ] Mapear categorias de despesas alinhadas ao AgriWin
4. [ ] Definir KPIs prioritarios com Claudio
5. [ ] Entender fluxo de NF com Valentina (SOAL vs Castrolanda)
6. [ ] Mapear contratos existentes (CPR, barter, antecipada)

### 11.2 TBCs Financeiros

1. [ ] Como funciona o rateio de custos entre culturas hoje?
2. [ ] Qual a estrutura de centro de custo no AgriWin?
3. [ ] Como sao controlados os contratos de venda antecipada?
4. [ ] Existe CPR ativo? Quantos? Qual o fluxo?
5. [ ] Como e feita a reconciliacao de estoque virtual vs real?
6. [ ] Quais relatorios financeiros sao gerados hoje?

---

## 12. Fontes Consultadas

### Universidades e Extensao (EUA)
- [Iowa State - Ag Decision Maker](https://www.extension.iastate.edu/agdm/)
- [Wisconsin Extension - Farm Management](https://farms.extension.wisc.edu/)
- [Penn State Extension - Budgeting](https://extension.psu.edu/)
- [Oklahoma State - Enterprise Budgets](https://extension.okstate.edu/)
- [USDA Economic Research Service](https://www.ers.usda.gov/)

### Softwares e Empresas
- [Traction Ag](https://tractionag.com/)
- [Harvest Profit](https://www.harvestprofit.com/)
- [NetSuite Farm Accounting](https://www.netsuite.com/portal/industries/agriculture-accounting.shtml)
- [Greenstone Systems](https://greenstonesystems.com/)
- [Siagri](https://www.siagri.com.br/)
- [Aegro](https://aegro.com.br/)

### Artigos e Guias
- [PerformYard - Agriculture KPIs 2025](https://www.performyard.com/articles/agriculture-performance-indicators)
- [FCS America - Key Financial Metrics 2025](https://www.fcsamerica.com/resources/learning-center/key-financial-metrics-to-monitor-in-2025)
- [Braintrust Ag - 18 Farm Financial Ratios](https://braintrustag.com/18-farm-financial-ratios-what-gets-measured-gets-managed/)
- [AgriBrasilis - Barter Contracts](https://agribrasilis.com/2023/10/04/how-barter-contracts-work/)

### Regulamentacao
- [IRS Schedule F Instructions](https://www.irs.gov/instructions/i1040sf)
- [CFTC - Agricultural Trade Options](https://www.cftc.gov/IndustryOversight/ContractsProducts/AgriculturalTradeOptions/)
- [CME Group - Agricultural Commodities](https://www.cmegroup.com/markets/agriculture.html)

---

*Documento gerado em 08/02/2026 - DeepWork AI Flows*
*Pesquisa realizada com fontes internacionais (EUA) e brasileiras*
