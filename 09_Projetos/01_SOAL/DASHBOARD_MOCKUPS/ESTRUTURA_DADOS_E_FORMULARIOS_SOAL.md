# Estrutura de Dados e Formulários - Sistema SOAL

**Documento Master de Engenharia Reversa: Dashboards → Dados → Formulários**
**Preparado por:** Rodrigo Kugler
**Data:** 31 de Janeiro de 2026
**Objetivo:** Mapear todos os dados necessários para alimentar os 9 dashboards e especificar os formulários de coleta para o app.dpwai.com.br

---

## 1. Visão Geral da Arquitetura de Dados

### 1.1 Decisão Estratégica: Substituição do AgriWin

> **IMPORTANTE:** O app.dpwai.com.br **SUBSTITUIRÁ o AgriWin** como sistema central da SOAL.
> Não estamos integrando com o AgriWin - estamos **migrando** suas funcionalidades para dentro da nossa plataforma.

**Implicações:**
1. Todos os módulos financeiros (Contas a Pagar/Receber) serão nativos do app
2. Cadastros mestres (Fornecedores, Clientes, Produtos) migram para nosso banco
3. Plano de Contas e estrutura contábil serão configurados no app
4. Histórico do AgriWin será importado uma única vez (migração inicial)

### 1.2 Filosofia: "Plataforma Unificada"

O app.dpwai.com.br será a **única fonte de verdade** para todos os dados da SOAL:

| Camada | Descrição | Responsável |
|--------|-----------|-------------|
| **Módulos Internos** | Financeiro, Estoque, Compras, Manutenção | App nativo |
| **Integrações Externas** | Vestro, John Deere, Castrolanda, APIs de Mercado | ETL/Pipeline |
| **Coleta de Campo** | Formulários mobile para operações | Operadores |

### 1.3 Mapa da Nova Arquitetura

```
┌─────────────────────────────────────────────────────────────────────┐
│                    APP.DPWAI.COM.BR (PLATAFORMA SOAL)               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                    MÓDULOS INTERNOS                         │   │
│   │        (Substituem o AgriWin - Core do Sistema)             │   │
│   ├─────────────────────────────────────────────────────────────┤   │
│   │ • Financeiro (Contas a Pagar / Receber)                     │   │
│   │ • Estoque de Insumos                                        │   │
│   │ • Cadastros Mestres (Fornecedores, Clientes, Produtos)      │   │
│   │ • Plano de Contas                                           │   │
│   │ • Fluxo de Caixa                                            │   │
│   │ • Notas Fiscais (Entrada/Saída)                             │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                 INTEGRAÇÕES EXTERNAS (ETL)                  │   │
│   ├─────────────────────────────────────────────────────────────┤   │
│   │ • Vestro → Dados de abastecimento (validação cruzada)       │   │
│   │ • John Deere OC → Telemetria, horas, localização            │   │
│   │ • Castrolanda → Contratos de venda, saldos cooperativa      │   │
│   │ • APIs Mercado → Cotações B3, CBOT, Dólar                   │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                 FORMULÁRIOS DE CAMPO                        │   │
│   ├─────────────────────────────────────────────────────────────┤   │
│   │ • Recebimento/Expedição de Grãos                            │   │
│   │ • Abastecimento de Máquinas                                 │   │
│   │ • Ordens de Serviço                                         │   │
│   │ • Movimentação de Estoque                                   │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.4 Plano de Migração do AgriWin

| Fase | Ação | Dados |
|------|------|-------|
| **Fase 0** | Export completo AgriWin | Backup de segurança |
| **Fase 1** | Migração de Cadastros | Fornecedores, Clientes, Produtos, Plano de Contas |
| **Fase 2** | Migração de Saldos | Saldos iniciais de estoque, contas a pagar/receber em aberto |
| **Fase 3** | Histórico (opcional) | Lançamentos dos últimos 2 anos para análise histórica |
| **Fase 4** | Go-Live | AgriWin desativado, app.dpwai.com.br como sistema único |

---

## 2. Análise por Dashboard: Dados Necessários

### Dashboard 01: Executive Overview ("Visão do Produtor")

**Persona:** Claudio (Owner)
**Frequência de Uso:** Diário (café da manhã)

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| A Pagar (7 Dias) | Contas a pagar por vencimento | **Módulo Financeiro (App)** | Interno |
| A Receber (Previsão) | Contratos de venda + saldo cooperativa | **Módulo Financeiro (App)** + Castrolanda | Interno + ETL |
| Saldo de Caixa | Saldo bancário projetado | **Módulo Financeiro (App)** | Interno |
| Status Colheita | % área colhida | John Deere OC | ETL |
| Status Secador | Operando/Parado | **FORMULÁRIO** | Manual |
| Fila Caminhões | Quantidade aguardando | **FORMULÁRIO** | Manual |
| % Silo Cheio | Volume armazenado | **FORMULÁRIO** | Manual |
| Alertas Maquinário | Máquinas com problema | **FORMULÁRIO** | Manual |
| Cotações Commodities | Preço soja/milho/dólar | API Externa | ETL |

#### Formulários Necessários

**FORM-01: Check-in Diário Secador**
- Campos: Status (Operando/Parado/Manutenção), Observações
- Responsável: Josmar
- Frequência: 2x dia (início/fim turno)

---

### Dashboard 02: Accounts Receivable (Contas a Receber)

**Persona:** Valentina (Admin/Financial)
**Frequência de Uso:** Semanal/Mensal

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Total a Receber (Safra) | Contratos ativos | **Módulo Financeiro (App)** + Castrolanda | Interno + ETL |
| Heatmap Pagamentos | Cronograma por cliente/mês | **Módulo Financeiro (App)** | Interno |
| Lista Recebíveis | Detalhes contratos | **Módulo Financeiro (App)** | Interno |
| Status Pagamento | Pago/Pendente/Atrasado | **Módulo Financeiro (App)** | Interno |

#### Formulários Necessários

**FORM-22: Lançamento de Conta a Receber**
- Campos: Cliente (dropdown), Descrição, Valor, Data Vencimento, Contrato Vinculado (opcional), Categoria
- Responsável: Valentina
- Frequência: A cada venda/contrato

**FORM-23: Baixa de Recebimento**
- Campos: Conta a Receber (link), Data Pagamento, Valor Recebido, Conta Bancária, Observações
- Responsável: Valentina
- Frequência: A cada pagamento recebido

---

### Dashboard 03: Accounts Payable (Contas a Pagar)

**Persona:** Valentina (Admin/Financial)
**Frequência de Uso:** Diário

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Total Vencendo Hoje | Boletos por data | **Módulo Financeiro (App)** | Interno |
| Despesas por Categoria | Classificação contábil | **Módulo Financeiro (App)** | Interno |
| Projeção Saldo | Saldo - pagamentos futuros | **Módulo Financeiro (App)** | Interno |
| Fila de Pagamentos | Lista ordenada por vencimento | **Módulo Financeiro (App)** | Interno |
| Autorização | Aprovação de pagamento | **FORMULÁRIO** | Manual |

#### Formulários Necessários

**FORM-02: Autorização de Pagamento**
- Campos: ID Conta, Valor, Data Pagamento, Aprovador, Observações
- Responsável: Claudio/Valentina
- Frequência: Conforme demanda
- Ação: Atualiza status no sistema

**FORM-24: Lançamento de Conta a Pagar**
- Campos: Fornecedor (dropdown), Descrição, Valor, Data Vencimento, Categoria (Plano de Contas), Centro de Custo, NF (upload)
- Responsável: Valentina
- Frequência: A cada compra/despesa

**FORM-25: Baixa de Pagamento**
- Campos: Conta a Pagar (link), Data Pagamento, Valor Pago, Conta Bancária, Comprovante (upload)
- Responsável: Valentina
- Frequência: A cada pagamento realizado

---

### Dashboard 04: Machinery & Diesel Intelligence

**Persona:** Tiago (Operations)
**Frequência de Uso:** Diário

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Total Máquinas | Cadastro de equipamentos | **Módulo Cadastros (App)** | Interno |
| Status (Ativo/Manutenção/Parado) | Estado atual | **FORMULÁRIO** | Manual |
| Horas Trabalhadas | Telemetria | John Deere OC | ETL |
| Consumo L/h | Cálculo (Litros/Horas) | Vestro + JD OC | ETL + Cálculo |
| Operador Atual | Quem está operando | **FORMULÁRIO** | Manual |
| Localização | Talhão atual | John Deere OC | ETL |
| Nível Tanque Máquina | % combustível | **FORMULÁRIO** | Manual |
| Tanque Principal (Diesel) | Volume disponível | Vestro | ETL |
| Eficiência Score | Cálculo interno | Calculado | Sistema |

#### Formulários Necessários

**FORM-03: Abastecimento de Máquina**
- Campos: Máquina (dropdown), Operador (dropdown), Litros, Horímetro Atual, Talhão/Local
- Responsável: Operador ou Frentista
- Frequência: A cada abastecimento
- Validação: Horímetro > último registro

**FORM-04: Status de Máquina (Mudança de Estado)**
- Campos: Máquina, Novo Status (dropdown), Motivo, Responsável
- Responsável: Tiago
- Frequência: Quando status muda
- Estados: Operando → Parado → Manutenção → Operando

---

### Dashboard 05: Grain Inventory & Commercialization

**Persona:** Claudio (Owner)
**Frequência de Uso:** Diário (safra)

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Estoque Total (Toneladas) | Volume por silo | **FORMULÁRIO** | Manual |
| Distribuição Soja/Milho | Tipo por silo | **FORMULÁRIO** | Manual |
| % Comercializado | Contratos fechados / produção | Castrolanda | Sistema |
| Preço Médio Realizado | Média ponderada vendas | Castrolanda | Sistema |
| Cotações Mercado | CBOT, B3, Dólar | API Externa | Sistema |
| Fila Caminhões | Aguardando carregamento | **FORMULÁRIO** | Manual |
| Caminhão em Carregamento | Status atual | **FORMULÁRIO** | Manual |

#### Formulários Necessários

**FORM-05: Recebimento de Grãos (Entrada no Silo)**
- Campos: Placa Caminhão, Peso Bruto (kg), Tara, Peso Líquido (calculado), Umidade (%), Tipo Grão (Soja/Milho), Silo Destino, Origem (Talhão)
- Responsável: Josmar
- Frequência: A cada descarga
- Integração: Balança (se disponível RS232/USB)

**FORM-06: Expedição de Grãos (Saída do Silo)**
- Campos: Placa Caminhão, Peso Carregado, Tipo Grão, Silo Origem, Destinatário, Contrato (se houver)
- Responsável: Josmar/Valentina
- Frequência: A cada carregamento

**FORM-07: Ajuste de Estoque de Silo**
- Campos: Silo, Volume Atual (toneladas), Tipo Grão, Data Medição, Responsável
- Responsável: Tiago
- Frequência: Semanal (conferência)

---

### Dashboard 06: Inputs Inventory (Estoque de Insumos)

**Persona:** Tiago (Operations)
**Frequência de Uso:** Semanal

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Valor Total Estoque | Saldo contábil | **Módulo Estoque (App)** | Interno |
| Itens por Categoria | Classificação | **Módulo Estoque (App)** | Interno |
| Quantidade em Estoque | Saldo físico | **Módulo Estoque (App)** | Interno |
| Lote / Vencimento | Dados de entrada | **FORMULÁRIO** | Manual |
| Estoque Mínimo | Parâmetro cadastrado | **Módulo Estoque (App)** | Interno |
| Alertas Críticos | Cálculo (dias operação) | Calculado | Sistema |
| Curva ABC | Cálculo por valor | Calculado | Sistema |

#### Formulários Necessários

**FORM-08: Entrada de Insumo (Recebimento de Compra)**
- Campos: Produto (dropdown/busca), Fornecedor, Quantidade, Unidade, Valor Unitário, Lote, Data Fabricação, Data Vencimento, Nota Fiscal
- Responsável: Valentina
- Frequência: A cada recebimento de compra
- Validação: Conferir com NF

**FORM-09: Saída de Insumo (Consumo Operacional)**
- Campos: Produto (dropdown), Quantidade Retirada, Destino (Talhão/Máquina), Responsável, Lote (FIFO automático)
- Responsável: Operador/Tiago
- Frequência: A cada uso
- Regra: Baixa automática do lote mais antigo

**FORM-10: Inventário Físico (Conferência)**
- Campos: Produto, Quantidade Contada, Quantidade Sistema, Diferença (calculado), Justificativa (se diferença)
- Responsável: Tiago
- Frequência: Mensal

---

### Dashboard 07: Cost Accounting (Custos por Fazenda/Cultura)

**Persona:** Claudio (Owner)
**Frequência de Uso:** Mensal

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Custo Total | Soma lançamentos | **Módulo Financeiro (App)** | Interno |
| Custo por Hectare | Custo / Área Plantada | Calculado | Sistema |
| Distribuição por Categoria | Plano de Contas | **Módulo Financeiro (App)** | Interno |
| Treemap | Visualização hierárquica | Calculado | Sistema |
| Orçado vs Executado | Orçamento + Lançamentos | **Módulo Orçamento (App)** | Interno |
| Evolução Histórica | Safras anteriores | **Módulo Financeiro (App)** | Interno |
| Área Plantada | Hectares por cultura | **FORMULÁRIO** | Manual |
| Rateio Diesel | Regra de alocação | **FORMULÁRIO** | Manual |

#### Formulários Necessários

**FORM-11: Cadastro de Safra/Cultura**
- Campos: Safra (ex: 2025/26), Cultura (Soja/Milho), Talhão, Área (hectares), Data Plantio, Variedade
- Responsável: Tiago
- Frequência: Início de cada safra

**FORM-12: Regra de Rateio de Custos**
- Campos: Categoria Custo, Critério Rateio (Por Área / Por Cultura / Fixo), Percentuais
- Responsável: Claudio
- Frequência: Início de safra ou quando muda
- Crítico: Define a lógica do algoritmo de Custo/ha

---

### Dashboard 08: Purchasing Programming (Programação de Compras)

**Persona:** Valentina (Admin/Financial)
**Frequência de Uso:** Diário

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Solicitações | Pedidos abertos | **Módulo Compras (App)** | Interno |
| Status Kanban | Etapa do processo | **Módulo Compras (App)** | Interno |
| Cotações | Preços de fornecedores | **Módulo Compras (App)** | Interno |
| Aprovações Pendentes | Itens aguardando OK | **Módulo Compras (App)** | Interno |
| Histórico de Preços | Compras anteriores | **Módulo Compras (App)** | Interno |
| Pedidos Enviados | NFs de compra | **Módulo Financeiro (App)** | Interno |
| Recebimentos | Entradas confirmadas | **FORMULÁRIO** | Manual |

#### Formulários Necessários

**FORM-13: Solicitação de Compra**
- Campos: Produto (texto livre ou dropdown), Quantidade, Unidade, Justificativa, Prioridade (Urgente/Alta/Normal/Baixa), Data Necessidade, Solicitante
- Responsável: Tiago/Operadores
- Frequência: Conforme demanda
- Workflow: Cria card no Kanban "Solicitação"

**FORM-14: Registro de Cotação**
- Campos: Solicitação (link), Fornecedor, Valor Unitário, Prazo Entrega, Condições Pagamento, Validade Proposta
- Responsável: Valentina
- Frequência: Mínimo 3 cotações por item
- Workflow: Move card para "Cotação"

**FORM-15: Aprovação de Compra**
- Campos: Solicitação (link), Cotação Selecionada, Valor Total, Aprovador, Observações
- Responsável: Claudio
- Frequência: Conforme demanda
- Workflow: Move card para "Pedido Enviado"
- Regra: Aprovação automática se < R$ 10.000 (parametrizável)

**FORM-16: Confirmação de Recebimento**
- Campos: Pedido (link), Data Recebimento, Quantidade Recebida, Confere com Pedido (S/N), Observações, NF Recebida
- Responsável: Valentina/Tiago
- Frequência: A cada entrega
- Workflow: Move card para "Recebido"

---

### Dashboard 09: Maintenance Hub (Gestão de Manutenção)

**Persona:** Tiago (Operations)
**Frequência de Uso:** Diário

#### Dados Necessários

| Componente | Dado | Fonte | Tipo |
|------------|------|-------|------|
| Máquinas Paradas | Contagem status crítico | **FORMULÁRIO** | Manual |
| Em Manutenção | Contagem OS abertas | **FORMULÁRIO** | Manual |
| Operando | Contagem status ativo | **FORMULÁRIO** | Manual |
| Ordens de Serviço | Lista de OS ativas | **FORMULÁRIO** | Manual |
| Custo Mão de Obra | Horas × Taxa | **FORMULÁRIO** | Manual |
| Custo Peças | Peças utilizadas | **HÍBRIDO** | AgriWin + Form |
| Manutenções Preventivas | Agenda por horímetro | **FORMULÁRIO** | Manual |
| Horas Motor | Telemetria | John Deere OC | Sistema |

#### Formulários Necessários

**FORM-17: Abertura de Ordem de Serviço (OS)**
- Campos: Máquina (dropdown), Tipo (Corretiva/Preventiva), Prioridade (Crítico/Normal), Problema Relatado (texto), Localização (Oficina/Campo), Data Abertura, Solicitante
- Responsável: Tiago/Operador
- Frequência: Quando problema identificado
- Ação: Atualiza status máquina para "Em Manutenção"

**FORM-18: Atualização de OS (Andamento)**
- Campos: OS (link), Status (Em Andamento/Aguardando Peças/Parado), Mecânico Responsável, Horas Trabalhadas, Observações
- Responsável: Mecânico/Tiago
- Frequência: Diário enquanto OS aberta

**FORM-19: Registro de Peças Utilizadas**
- Campos: OS (link), Peça (dropdown do estoque), Quantidade, Valor Unitário (preenchido auto)
- Responsável: Mecânico/Tiago
- Frequência: A cada uso de peça
- Integração: Baixa estoque (Form-09)

**FORM-20: Encerramento de OS**
- Campos: OS (link), Data Conclusão, Horas Totais Mão de Obra, Custo Total Peças (calculado), Custo Total (calculado), Descrição Serviço Realizado, Aprovação Técnica
- Responsável: Tiago
- Frequência: Ao concluir serviço
- Ação: Atualiza status máquina para "Operando"

**FORM-21: Cadastro de Manutenção Preventiva**
- Campos: Máquina, Tipo Revisão (ex: Revisão 500h), Intervalo (horas), Serviços Incluídos (checklist), Peças Padrão (lista), Tempo Estimado
- Responsável: Tiago
- Frequência: Uma vez por tipo de máquina
- Uso: Sistema gera alerta quando horímetro se aproxima

---

## 3. Resumo: Matriz de Formulários

### 3.1 Total de Formulários: 25

| ID | Nome | Dashboard(s) | Responsável Principal | Frequência |
|----|------|--------------|----------------------|------------|
| FORM-01 | Check-in Diário Secador | 01 | Josmar | 2x/dia |
| FORM-02 | Autorização de Pagamento | 03 | Claudio/Valentina | Conforme demanda |
| FORM-03 | Abastecimento de Máquina | 04 | Operador/Frentista | A cada abastecimento |
| FORM-04 | Status de Máquina | 04, 09 | Tiago | Mudança de estado |
| FORM-05 | Recebimento de Grãos | 05 | Josmar | A cada descarga |
| FORM-06 | Expedição de Grãos | 05 | Josmar/Valentina | A cada carregamento |
| FORM-07 | Ajuste de Estoque Silo | 05 | Tiago | Semanal |
| FORM-08 | Entrada de Insumo | 06 | Valentina | A cada recebimento |
| FORM-09 | Saída de Insumo | 06, 09 | Operador/Tiago | A cada uso |
| FORM-10 | Inventário Físico | 06 | Tiago | Mensal |
| FORM-11 | Cadastro Safra/Cultura | 07 | Tiago | Início safra |
| FORM-12 | Regra de Rateio | 07 | Claudio | Início safra |
| FORM-13 | Solicitação de Compra | 08 | Tiago/Operadores | Conforme demanda |
| FORM-14 | Registro de Cotação | 08 | Valentina | 3x por solicitação |
| FORM-15 | Aprovação de Compra | 08 | Claudio | Conforme demanda |
| FORM-16 | Confirmação Recebimento | 08 | Valentina/Tiago | A cada entrega |
| FORM-17 | Abertura de OS | 09 | Tiago/Operador | Quando necessário |
| FORM-18 | Atualização de OS | 09 | Mecânico/Tiago | Diário (OS aberta) |
| FORM-19 | Registro de Peças | 09 | Mecânico/Tiago | A cada uso |
| FORM-20 | Encerramento de OS | 09 | Tiago | Ao concluir |
| FORM-21 | Cadastro Manutenção Preventiva | 09 | Tiago | Setup inicial |
| FORM-22 | Lançamento Conta a Receber | 02 | Valentina | A cada venda |
| FORM-23 | Baixa de Recebimento | 02 | Valentina | A cada pagamento recebido |
| FORM-24 | Lançamento Conta a Pagar | 03 | Valentina | A cada compra/despesa |
| FORM-25 | Baixa de Pagamento | 03 | Valentina | A cada pagamento realizado |

### 3.2 Formulários por Responsável

| Responsável | Formulários | Total |
|-------------|-------------|-------|
| **Josmar** | FORM-01, 05, 06 | 3 |
| **Tiago** | FORM-04, 07, 09, 10, 11, 13, 16, 17, 18, 19, 20, 21 | 12 |
| **Valentina** | FORM-02, 08, 14, 16, 22, 23, 24, 25 | 8 |
| **Claudio** | FORM-02, 12, 15 | 3 |
| **Operadores** | FORM-03, 09, 13, 17 | 4 |
| **Mecânico** | FORM-18, 19 | 2 |

### 3.3 Formulários por Módulo do Sistema

| Módulo | Formulários | Descrição |
|--------|-------------|-----------|
| **Financeiro** | FORM-02, 22, 23, 24, 25 | Contas a Pagar/Receber |
| **Estoque** | FORM-08, 09, 10 | Movimentação de Insumos |
| **Compras** | FORM-13, 14, 15, 16 | Workflow de Aquisição |
| **Manutenção** | FORM-17, 18, 19, 20, 21 | Ordens de Serviço |
| **Operacional** | FORM-01, 03, 04, 05, 06, 07 | Coleta de Campo |
| **Configuração** | FORM-11, 12 | Setup de Safra/Rateio |

---

## 4. Especificação Detalhada dos Formulários (UX/UI)

### 4.1 Princípios de Design (DeepWork Field Ops)

```
┌──────────────────────────────────────────────────────────────────┐
│  PRINCÍPIOS UX PARA FORMULÁRIOS DE CAMPO                        │
├──────────────────────────────────────────────────────────────────┤
│  1. MENOS É MAIS: Máximo 6 campos por tela                       │
│  2. BOTÕES GRANDES: Mínimo 60px altura (dedo sujo de graxa)      │
│  3. DARK MODE: Funciona no sol e economiza bateria               │
│  4. OFFLINE-FIRST: Salva localmente, sincroniza depois           │
│  5. FEEDBACK IMEDIATO: Confirmação visual clara                  │
│  6. ORDEM MENTAL: Campos na ordem que o operador pensa           │
└──────────────────────────────────────────────────────────────────┘
```

### 4.2 Categorização por Complexidade

| Nível | Descrição | Formulários |
|-------|-----------|-------------|
| **Simples** | 1-3 campos, entrada rápida | FORM-01, 04 |
| **Médio** | 4-6 campos, dropdowns | FORM-03, 05, 06, 09, 17, 18, 20 |
| **Completo** | 7+ campos, validações | FORM-08, 13, 14, 21 |
| **Workflow** | Ação de aprovação | FORM-02, 15, 16 |

---

## 5. Especificações de Formulários para Desenvolvimento

### FORM-05: Recebimento de Grãos (O Mais Crítico)

**Contexto:** Josmar no secador, mão suja, sol forte, caminhões na fila.

```
┌─────────────────────────────────────────────────────────────────┐
│  📦 RECEBIMENTO DE GRÃOS                                        │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  PLACA DO CAMINHÃO                                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  ABC-1234                              [📷 Câmera]      │   │
│  └─────────────────────────────────────────────────────────┘   │
│  💡 Últimas: ABC-1234 | XYZ-5678 | DEF-9012                    │
│                                                                 │
│  PESO BRUTO (kg)          TARA (kg)                            │
│  ┌────────────────┐       ┌────────────────┐                   │
│  │     32.500     │       │      8.200     │                   │
│  └────────────────┘       └────────────────┘                   │
│  Peso Líquido: 24.300 kg                                       │
│                                                                 │
│  UMIDADE (%)                                                    │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  ◀────────────●─────────────────────────────────────▶ │    │
│  │              14.5%                                     │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  TIPO DE GRÃO                                                   │
│  ┌─────────────────────┐  ┌─────────────────────┐              │
│  │   🌱 SOJA           │  │   🌽 MILHO          │              │
│  │      [✓]            │  │      [ ]            │              │
│  └─────────────────────┘  └─────────────────────┘              │
│                                                                 │
│  SILO DESTINO                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Silo A - Soja (86% cheio)                         ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                         │   │
│  │               ✅ SALVAR REGISTRO                        │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Campos Técnicos:**

| Campo | Tipo | Validação | Obrigatório |
|-------|------|-----------|-------------|
| `placa_caminhao` | String (7 chars) | Regex: ABC-1234 | Sim |
| `peso_bruto_kg` | Integer | > 5000, < 60000 | Sim |
| `tara_kg` | Integer | > 3000, < 15000 | Sim |
| `peso_liquido_kg` | Integer (calc) | = peso_bruto - tara | Auto |
| `umidade_percent` | Decimal (1 casa) | 8.0 a 25.0 | Sim |
| `tipo_grao` | Enum | [SOJA, MILHO] | Sim |
| `silo_destino` | FK (Silo) | Silo com espaço disponível | Sim |
| `origem_talhao` | FK (Talhao) | Opcional | Não |
| `timestamp` | DateTime | Auto (UTC) | Auto |
| `operador_id` | FK (User) | Usuário logado | Auto |

---

### FORM-03: Abastecimento de Máquina

**Contexto:** Operador na bomba de diesel, precisa registrar rápido.

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛽ ABASTECIMENTO                                                │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  MÁQUINA                                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  🚜 John Deere 8R-04                               ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  LITROS ABASTECIDOS                                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                        245                              │   │
│  └─────────────────────────────────────────────────────────┘   │
│  [50] [100] [150] [200] [250] [300]  ← Atalhos rápidos         │
│                                                                 │
│  HORÍMETRO ATUAL                                                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                       2.847                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│  ⚠️ Último registro: 2.832h (Consumo: 15,3 L/h)                │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │               ✅ REGISTRAR ABASTECIMENTO                │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Campos Técnicos:**

| Campo | Tipo | Validação | Obrigatório |
|-------|------|-----------|-------------|
| `maquina_id` | FK (Maquina) | Ativa | Sim |
| `litros` | Decimal (1 casa) | 10 a 500 | Sim |
| `horimetro` | Decimal (1 casa) | > último_registro | Sim |
| `operador_id` | FK (User) | Logado | Auto |
| `timestamp` | DateTime | Auto | Auto |
| `localizacao` | String | Opcional (GPS) | Não |

**Cálculos Automáticos:**
- `consumo_medio = litros / (horimetro - horimetro_anterior)`
- Alerta se consumo > 25 L/h (anomalia)

---

### FORM-17: Abertura de Ordem de Serviço

```
┌─────────────────────────────────────────────────────────────────┐
│  🔧 NOVA ORDEM DE SERVIÇO                                       │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  MÁQUINA                                                        │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  🚜 John Deere 8R-04                               ▼   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  TIPO DE MANUTENÇÃO                                             │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │  ⚙️ CORRETIVA    │  │  📅 PREVENTIVA   │                    │
│  │     [✓]          │  │     [ ]          │                    │
│  └──────────────────┘  └──────────────────┘                    │
│                                                                 │
│  PRIORIDADE                                                     │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐               │
│  │🔴 CRIT │  │🟠 ALTA │  │🔵 NORM │  │⚪ BAIXA│               │
│  │  [✓]   │  │  [ ]   │  │  [ ]   │  │  [ ]   │               │
│  └────────┘  └────────┘  └────────┘  └────────┘               │
│                                                                 │
│  DESCRIÇÃO DO PROBLEMA                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Motor apresentando superaquecimento durante           │   │
│  │  operação. Temperatura excedendo 105°C.                │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│  [🎤 Ditar] [📷 Foto]                                          │
│                                                                 │
│  LOCALIZAÇÃO                                                    │
│  ┌──────────────────┐  ┌──────────────────┐                    │
│  │  🏭 OFICINA      │  │  🌾 CAMPO        │                    │
│  │     [✓]          │  │     [ ]          │                    │
│  └──────────────────┘  └──────────────────┘                    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │               ✅ ABRIR ORDEM DE SERVIÇO                 │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Campos Técnicos:**

| Campo | Tipo | Validação | Obrigatório |
|-------|------|-----------|-------------|
| `numero_os` | String (auto) | OS-2026-XXXX | Auto |
| `maquina_id` | FK (Maquina) | Ativa | Sim |
| `tipo` | Enum | [CORRETIVA, PREVENTIVA] | Sim |
| `prioridade` | Enum | [CRITICO, ALTA, NORMAL, BAIXA] | Sim |
| `descricao` | Text | Min 10 caracteres | Sim |
| `localizacao` | Enum | [OFICINA, CAMPO] | Sim |
| `fotos` | Array<URL> | Max 5 fotos | Não |
| `solicitante_id` | FK (User) | Logado | Auto |
| `data_abertura` | DateTime | Auto | Auto |
| `status` | Enum | = ABERTA (default) | Auto |

**Ações Automáticas:**
- Atualiza status da máquina para "Em Manutenção"
- Notifica Tiago (push notification)
- Se CRITICO, notifica Claudio também

---

### FORM-13: Solicitação de Compra

```
┌─────────────────────────────────────────────────────────────────┐
│  🛒 NOVA SOLICITAÇÃO DE COMPRA                                  │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  O QUE PRECISA?                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  🔍 Buscar produto...                                   │   │
│  └─────────────────────────────────────────────────────────┘   │
│  Sugestões: [Filtro de óleo] [Ureia] [Glifosato] [Diesel]      │
│                                                                 │
│  OU DESCREVA:                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Fertilizante NPK 10-10-10 para aplicação safra        │   │
│  │  25/26 nos talhões 5, 6 e 7.                           │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  QUANTIDADE           UNIDADE                                   │
│  ┌────────────────┐   ┌────────────────────────────────────┐   │
│  │       50       │   │  Toneladas                     ▼  │   │
│  └────────────────┘   └────────────────────────────────────┘   │
│                                                                 │
│  PRIORIDADE                                                     │
│  ┌────────┐  ┌────────┐  ┌────────┐  ┌────────┐               │
│  │🔴 URG  │  │🟠 ALTA │  │🔵 NORM │  │⚪ BAIXA│               │
│  │  [ ]   │  │  [ ]   │  │  [✓]   │  │  [ ]   │               │
│  └────────┘  └────────┘  └────────┘  └────────┘               │
│                                                                 │
│  PRECISO ATÉ:                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  📅  15/02/2026                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │               ✅ ENVIAR SOLICITAÇÃO                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. Modelo de Dados (Schema Simplificado)

### 6.1 Entidades Principais

```sql
-- Usuários e Perfis
CREATE TABLE usuarios (
    id UUID PRIMARY KEY,
    nome VARCHAR(100),
    perfil ENUM('admin', 'operacional', 'financeiro', 'gestor'),
    ativo BOOLEAN DEFAULT true
);

-- Máquinas (Frota)
CREATE TABLE maquinas (
    id UUID PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE,
    nome VARCHAR(100),
    fabricante VARCHAR(50),
    modelo VARCHAR(50),
    ano_fabricacao INT,
    horimetro_atual DECIMAL(10,1),
    status ENUM('operando', 'parado', 'manutencao'),
    foto_url VARCHAR(255)
);

-- Silos
CREATE TABLE silos (
    id UUID PRIMARY KEY,
    nome VARCHAR(50),
    capacidade_toneladas DECIMAL(10,2),
    volume_atual DECIMAL(10,2),
    tipo_grao ENUM('soja', 'milho', 'vazio'),
    ultima_medicao TIMESTAMP
);

-- Talhões
CREATE TABLE talhoes (
    id UUID PRIMARY KEY,
    nome VARCHAR(50),
    area_hectares DECIMAL(8,2),
    fazenda VARCHAR(50),
    cultura_atual VARCHAR(50),
    safra_atual VARCHAR(10)
);

-- Insumos (Produtos em Estoque)
CREATE TABLE insumos (
    id UUID PRIMARY KEY,
    nome VARCHAR(100),
    categoria ENUM('defensivos', 'fertilizantes', 'sementes', 'pecas', 'outros'),
    unidade VARCHAR(20),
    estoque_minimo DECIMAL(10,2),
    estoque_atual DECIMAL(10,2)
);

-- Lotes de Insumos
CREATE TABLE insumo_lotes (
    id UUID PRIMARY KEY,
    insumo_id UUID REFERENCES insumos(id),
    lote VARCHAR(50),
    quantidade DECIMAL(10,2),
    custo_unitario DECIMAL(10,2),
    data_fabricacao DATE,
    data_vencimento DATE,
    data_entrada TIMESTAMP
);
```

### 6.2 Registros de Formulários

```sql
-- FORM-05: Recebimento de Grãos
CREATE TABLE recebimentos_graos (
    id UUID PRIMARY KEY,
    placa_caminhao VARCHAR(10),
    peso_bruto_kg INT,
    tara_kg INT,
    peso_liquido_kg INT,
    umidade_percent DECIMAL(4,1),
    tipo_grao ENUM('soja', 'milho'),
    silo_id UUID REFERENCES silos(id),
    talhao_id UUID REFERENCES talhoes(id),
    operador_id UUID REFERENCES usuarios(id),
    timestamp TIMESTAMP DEFAULT NOW()
);

-- FORM-03: Abastecimentos
CREATE TABLE abastecimentos (
    id UUID PRIMARY KEY,
    maquina_id UUID REFERENCES maquinas(id),
    litros DECIMAL(6,1),
    horimetro DECIMAL(10,1),
    consumo_calculado DECIMAL(4,1),
    operador_id UUID REFERENCES usuarios(id),
    timestamp TIMESTAMP DEFAULT NOW()
);

-- FORM-17/18/20: Ordens de Serviço
CREATE TABLE ordens_servico (
    id UUID PRIMARY KEY,
    numero VARCHAR(20) UNIQUE,
    maquina_id UUID REFERENCES maquinas(id),
    tipo ENUM('corretiva', 'preventiva'),
    prioridade ENUM('critico', 'alta', 'normal', 'baixa'),
    status ENUM('aberta', 'andamento', 'aguardando_pecas', 'concluida'),
    descricao TEXT,
    localizacao ENUM('oficina', 'campo'),
    mecanico_id UUID REFERENCES usuarios(id),
    custo_mao_obra DECIMAL(10,2) DEFAULT 0,
    custo_pecas DECIMAL(10,2) DEFAULT 0,
    horas_trabalhadas DECIMAL(6,1) DEFAULT 0,
    solicitante_id UUID REFERENCES usuarios(id),
    data_abertura TIMESTAMP,
    data_conclusao TIMESTAMP
);

-- FORM-13/14/15/16: Solicitações de Compra
CREATE TABLE solicitacoes_compra (
    id UUID PRIMARY KEY,
    numero VARCHAR(20) UNIQUE,
    descricao TEXT,
    quantidade DECIMAL(10,2),
    unidade VARCHAR(20),
    prioridade ENUM('urgente', 'alta', 'normal', 'baixa'),
    status ENUM('solicitacao', 'cotacao', 'aprovacao', 'pedido', 'recebido'),
    data_necessidade DATE,
    solicitante_id UUID REFERENCES usuarios(id),
    aprovador_id UUID REFERENCES usuarios(id),
    data_aprovacao TIMESTAMP,
    valor_aprovado DECIMAL(12,2),
    data_criacao TIMESTAMP DEFAULT NOW()
);

-- Cotações (vinculadas à solicitação)
CREATE TABLE cotacoes (
    id UUID PRIMARY KEY,
    solicitacao_id UUID REFERENCES solicitacoes_compra(id),
    fornecedor VARCHAR(100),
    valor_unitario DECIMAL(10,2),
    prazo_entrega INT, -- dias
    condicao_pagamento VARCHAR(100),
    validade_proposta DATE,
    selecionada BOOLEAN DEFAULT false,
    data_registro TIMESTAMP DEFAULT NOW()
);
```

---

## 7. Módulos Internos e Integrações Externas

### 7.1 MÓDULOS INTERNOS (Substituem AgriWin)

> **Estes módulos são desenvolvidos DENTRO do app.dpwai.com.br**

#### 7.1.1 Módulo Financeiro (Core)
**Funcionalidades:**
- Contas a Pagar (lançamento, aprovação, baixa)
- Contas a Receber (lançamento, baixa, cobrança)
- Fluxo de Caixa (projeção automática)
- Conciliação Bancária
- Plano de Contas configurável
- Centro de Custos

**Formulários Vinculados:** FORM-02, 22, 23, 24, 25

#### 7.1.2 Módulo Estoque
**Funcionalidades:**
- Cadastro de Produtos/Insumos
- Controle de Lotes e Vencimentos
- Movimentações (Entrada/Saída)
- Inventário Físico
- Estoque Mínimo e Alertas
- Curva ABC automática

**Formulários Vinculados:** FORM-08, 09, 10

#### 7.1.3 Módulo Compras
**Funcionalidades:**
- Solicitação de Compra (workflow)
- Cotações de Fornecedores
- Aprovação (níveis hierárquicos)
- Pedido de Compra
- Histórico de Preços
- Kanban de Acompanhamento

**Formulários Vinculados:** FORM-13, 14, 15, 16

#### 7.1.4 Módulo Cadastros Mestres
**Funcionalidades:**
- Fornecedores
- Clientes
- Produtos/Insumos
- Máquinas/Equipamentos
- Colaboradores
- Talhões/Fazendas

**Formulários Vinculados:** Setup inicial + FORM-11

#### 7.1.5 Módulo Orçamento
**Funcionalidades:**
- Orçamento por Safra
- Orçamento por Centro de Custo
- Acompanhamento Orçado vs Realizado
- Alertas de Desvio

**Formulários Vinculados:** FORM-12 (Regras de Rateio)

---

### 7.2 INTEGRAÇÕES EXTERNAS (ETL)

#### 7.2.1 Vestro (Combustível)

**Dados a Extrair:**
- Abastecimentos (para validação cruzada com FORM-03)
- Volume tanque principal

**Método:** Web Scraper ou API (se disponível)
**Frequência:** Diária

#### 7.2.2 John Deere Operations Center

**Dados a Extrair:**
- Horas trabalhadas por máquina
- Localização em tempo real
- Área trabalhada por talhão

**Método:** API REST (credenciais developer)
**Frequência:** A cada 15 minutos (telemetria)

#### 7.2.3 Castrolanda (Cooperativa)

**Dados a Extrair:**
- Contratos de venda
- Saldos disponíveis na cooperativa
- Preços fixados

**Método:** Portal Web → Export manual ou API (verificar disponibilidade)
**Frequência:** Diária

#### 7.2.4 APIs de Mercado (Cotações)

**Dados a Extrair:**
- Preço Soja (CBOT Chicago)
- Preço Soja (B3 Brasil)
- Preço Milho (CBOT/B3)
- Dólar PTAX

**Método:** APIs públicas (CoinGecko para dólar, APIs B3)
**Frequência:** A cada 30 minutos (horário comercial)

---

### 7.3 MIGRAÇÃO DO AGRIWIN (One-Time)

> **Processo único de importação de dados históricos**

| Dado | Método | Prioridade |
|------|--------|------------|
| Fornecedores | CSV → Import | P0 |
| Clientes | CSV → Import | P0 |
| Produtos/Insumos | CSV → Import | P0 |
| Plano de Contas | CSV → Import | P0 |
| Contas a Pagar (em aberto) | CSV → Import | P0 |
| Contas a Receber (em aberto) | CSV → Import | P0 |
| Saldo Estoque | CSV → Import | P0 |
| Histórico Lançamentos (2 anos) | CSV → Import | P1 |
| Notas Fiscais (arquivos) | Cópia de arquivos | P2 |

**Ferramenta:** Script Python + Interface de validação no app

---

## 8. Próximos Passos para Implementação

### Fase 1: Setup Básico (Semana 1-2)
1. [ ] Criar estrutura de banco de dados
2. [ ] Implementar autenticação de usuários
3. [ ] Criar tela de login com avatares (estilo Josmar)
4. [ ] Implementar FORM-05 (Recebimento de Grãos) como piloto

### Fase 2: Formulários Críticos (Semana 3-4)
1. [ ] FORM-03 (Abastecimento)
2. [ ] FORM-04 (Status Máquina)
3. [ ] FORM-17 (Abertura OS)
4. [ ] Testar offline-first sync

### Fase 3: Workflows Completos (Semana 5-6)
1. [ ] FORM-13 a 16 (Ciclo de Compras)
2. [ ] FORM-17 a 20 (Ciclo de Manutenção)
3. [ ] Implementar notificações push

### Fase 4: Integrações (Semana 7-8)
1. [ ] Pipeline AgriWin
2. [ ] Crawler Vestro
3. [ ] API John Deere

### Fase 5: Dashboards (Semana 9-14)
1. [ ] Dashboard 01 (Executive Overview)
2. [ ] Dashboard 04 (Maquinário)
3. [ ] Dashboard 09 (Manutenção)
4. [ ] Demais dashboards em ordem de prioridade

---

## 9. Conclusão

### 9.1 Resumo da Arquitetura

Este documento mapeia **25 formulários** e **5 módulos internos** necessários para alimentar os **9 dashboards** do sistema SOAL.

### 9.2 Decisão Estratégica Principal

> **O app.dpwai.com.br SUBSTITUI o AgriWin como sistema central da SOAL.**

Isso significa:
- **NÃO** estamos integrando com AgriWin via ETL
- **ESTAMOS** construindo módulos nativos (Financeiro, Estoque, Compras)
- **MIGRAREMOS** os dados históricos do AgriWin uma única vez
- **DESATIVAREMOS** o AgriWin após go-live

### 9.3 Estrutura de Dados

| Tipo | Quantidade | Descrição |
|------|------------|-----------|
| **Módulos Internos** | 5 | Financeiro, Estoque, Compras, Cadastros, Orçamento |
| **Formulários** | 25 | Coleta de dados operacionais e transações |
| **Integrações ETL** | 4 | Vestro, John Deere, Castrolanda, APIs Mercado |
| **Dashboards** | 9 | Visualização de dados consolidados |

### 9.4 Filosofia de Implementação

1. **Plataforma Unificada:** Uma única fonte de verdade para todos os dados
2. **Mobile-First:** Formulários desenhados para campo (sol, graxa, pressa)
3. **Offline-First:** Funciona sem internet, sincroniza depois
4. **Workflow-Driven:** Processos com aprovações e status claros

### 9.5 Próximos Passos

1. **Validar** este documento com Claudio e Tiago
2. **Priorizar** quais módulos/formulários desenvolver primeiro
3. **Planejar migração** do AgriWin (export de dados)
4. **Desenvolver MVP** com Dashboard 01 + formulários críticos

---

**Documento preparado por:** Rodrigo Kugler
**Data:** 31 de Janeiro de 2026
**Versão:** 1.1
**Destinatário:** João (Dev Lead - app.dpwai.com.br)

---

## Changelog

| Versão | Data | Alteração |
|--------|------|-----------|
| 1.0 | 31/01/2026 | Documento inicial |
| 1.1 | 31/01/2026 | Atualizado para refletir **substituição do AgriWin** (não integração). Adicionados 4 formulários financeiros (FORM-22 a 25). Reorganizada seção de módulos internos. |
