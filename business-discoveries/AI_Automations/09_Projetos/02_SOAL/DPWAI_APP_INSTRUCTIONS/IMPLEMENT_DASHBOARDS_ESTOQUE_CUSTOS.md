# Implementar: Dashboards Estoque de Grãos e Custos por Fazenda

## Status Atual

Os cards dos dashboards **Estoque de Grãos** e **Custos por Fazenda** aparecem na listagem de Dashboards Agrícolas, mas ao clicar neles o conteúdo interno ainda não está implementado.

## Dashboards Pendentes

### 1. Estoque de Grãos

**Descrição no card:** "Monitore silos, armazéns, cotações de mercado e expedição"

**Funcionalidades esperadas:**
- Visão geral dos silos e armazéns
- Quantidade atual de grãos por tipo (soja, milho, trigo, etc.)
- Capacidade total vs ocupada (%)
- Cotações de mercado em tempo real (ou última atualização)
- Histórico de expedições
- Alertas de capacidade crítica

**Dados necessários:**
- Cadastro de silos/armazéns
- Registros de entrada/saída de grãos
- Integração com fonte de cotações (Castrolanda, CBOT, etc.)
- Registros de expedição

**Visualizações sugeridas:**
- Cards com métricas principais (total armazenado, capacidade livre)
- Gráfico de barras: ocupação por silo
- Tabela: cotações atuais vs histórico
- Lista: últimas expedições

---

### 2. Custos por Fazenda

**Descrição no card:** "Análise de custos, orçado vs executado, custo por hectare"

**Funcionalidades esperadas:**
- Custo total por fazenda/talhão
- Comparativo orçado vs realizado
- Custo por hectare detalhado
- Breakdown por categoria (insumos, mão de obra, combustível, etc.)
- Evolução temporal dos custos
- Alertas de desvio orçamentário

**Dados necessários:**
- Cadastro de fazendas/talhões com área (hectares)
- Lançamentos de custos por categoria
- Orçamento planejado por período
- Integração com dados financeiros (AgriWin, notas fiscais)

**Visualizações sugeridas:**
- KPI cards: custo total, custo/ha, desvio orçamentário
- Gráfico de barras: orçado vs realizado por categoria
- Gráfico de linha: evolução do custo/ha ao longo do tempo
- Tabela drill-down: fazenda → talhão → categoria → itens

---

## Contexto Técnico

**Localização provável dos componentes:**
- `/pages/paineis/estoque-graos` ou similar
- `/pages/paineis/custos-fazenda` ou similar
- Componentes de dashboard em `/components/dashboards/`

**Padrão de dados:**
- Verificar se já existe API/endpoints para esses dados
- Seguir padrão Medallion (Bronze → Silver → Gold)
- Dados podem vir de formulários DPWAI ou integrações externas

**Design System:**
- Seguir padrão visual dos outros dashboards já implementados
- Usar componentes de cards, gráficos e tabelas existentes
- Manter consistência com dark theme

## Dependências

- [ ] Verificar se os formulários de entrada de dados existem
- [ ] Verificar se há dados de exemplo/mock para desenvolvimento
- [ ] Identificar fontes de dados reais (integrações)
- [ ] Definir período padrão de visualização (safra atual, últimos 30 dias, etc.)

## Prioridade

**Alta** - São dashboards core para a operação agrícola SOAL.

**Ordem sugerida:**
1. Custos por Fazenda (mais crítico para decisão de negócio)
2. Estoque de Grãos (depende de integrações com silos)

---

**Criado em:** 2026-02-02
**Status:** Pendente Implementação
