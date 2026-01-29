# 📦 SOAL Dashboards - Pacote de Entrega

**Projeto:** Sistema de Gestão SOAL (Serra da Onça Agropecuária)
**Preparado por:** Rodrigo Kugler
**Data:** 29 de Janeiro de 2026
**Destinatário:** João (Dev Lead - www.app.dpwai.com.br)

---

## 🎯 Visão Geral

Este diretório contém **tudo que você precisa** para implementar os 9 dashboards operacionais do sistema SOAL no app.dpwai.com.br.

**Total de horas de design estimadas:** 30-38 horas
**Total de linhas de especificação:** ~6.000 linhas
**Total de componentes únicos:** 40+

---

## 📚 Documentos Principais (Leia Nesta Ordem)

### 1️⃣ [HANDOFF_PARA_JOAO.md](./HANDOFF_PARA_JOAO.md) - **COMECE AQUI**
**O que é:** Guia completo de handoff
**Tempo de leitura:** 15-20 minutos
**Conteúdo:**
- O que você está recebendo
- Stack técnica esperada
- Fluxo de trabalho recomendado
- Estrutura de entrega sugerida
- Checklist de integração
- Próximos passos imediatos

**👉 Leia primeiro antes de qualquer coisa.**

---

### 2️⃣ [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) - Guia Técnico
**O que é:** Guia de implementação técnica detalhada
**Tempo de leitura:** 30-40 minutos
**Conteúdo:**
- Código base dos 8 componentes mais complexos
- KPI Card, Circular Progress, Waterfall Chart, Heatmap, Silo Visual, TreeMap, Kanban, Scatter Plot
- Utilitários de formatação
- Tailwind config customizado
- Performance e otimização
- Testing checklist

**👉 Use como referência durante a implementação.**

---

### 3️⃣ [DELIVERY_CHECKLIST.md](./DELIVERY_CHECKLIST.md) - Gestão do Projeto
**O que é:** Checklist completo de entrega por fase
**Tempo de leitura:** 10-15 minutos
**Conteúdo:**
- 7 fases do projeto (Preparação → Go-Live)
- Checklist granular de tarefas
- Priorização dos dashboards
- Métricas de sucesso
- Riscos e mitigações
- Log de atualizações

**👉 Use para trackear progresso e alinhar expectativas.**

---

## 🎨 Especificações de Design (Figma Prompts)

Cada arquivo abaixo é uma **especificação completa** de um dashboard, pronta para ser executada no Figma ou implementada diretamente em código.

### Dashboard 01: Executive Overview ("Raio-X da Safra")
- **Arquivo:** [FIGMA_PROMPT_Dashboard_01.md](./FIGMA_PROMPT_Dashboard_01.md)
- **Persona:** Claudio (Owner)
- **Foco:** Health check instantâneo da safra
- **Complexidade:** Média-Alta
- **Tempo:** 2-3 horas
- **Componentes chave:** Bento grid, Circular gauge, Waterfall chart, Risk alerts

### Dashboard 02: Accounts Receivable
- **Arquivo:** [FIGMA_PROMPT_Dashboard_02.md](./FIGMA_PROMPT_Dashboard_02.md)
- **Persona:** Valentina (Admin/Financial)
- **Foco:** Gestão de liquidez e recebimentos
- **Complexidade:** Alta
- **Tempo:** 3-4 horas
- **Componentes chave:** Heatmap calendar (8×12), Payment status table, Cash flow timeline

### Dashboard 03: Accounts Payable
- **Arquivo:** [FIGMA_PROMPT_Dashboard_03.md](./FIGMA_PROMPT_Dashboard_03.md)
- **Persona:** Valentina (Admin/Financial)
- **Foco:** Gestão de fluxo de caixa e pagamentos
- **Complexidade:** Média
- **Tempo:** 2-3 horas
- **Componentes chave:** Expense stacked bar, Cash burn projection, Payment queue

### Dashboard 04: Machinery & Diesel Intelligence
- **Arquivo:** [FIGMA_PROMPT_Dashboard_04.md](./FIGMA_PROMPT_Dashboard_04.md)
- **Persona:** Tiago (Operations)
- **Foco:** Eficiência da frota e consumo de diesel
- **Complexidade:** Muito Alta
- **Tempo:** 4-5 horas
- **Componentes chave:** Efficiency scatter plot (4 quadrants), Fuel tank gauge, 12 machine cards with manufacturer branding

### Dashboard 05: Grain Inventory & Commercialization
- **Arquivo:** [FIGMA_PROMPT_Dashboard_05.md](./FIGMA_PROMPT_Dashboard_05.md)
- **Persona:** Claudio (Owner)
- **Foco:** Decisão "Hold or Sell?"
- **Complexidade:** Alta
- **Tempo:** 4 horas
- **Componentes chave:** 4 realistic 2D silos with liquid fill, Half-circle commercialization gauge, Market ticker (B3/Chicago)

### Dashboard 06: Inputs Inventory
- **Arquivo:** [FIGMA_PROMPT_Dashboard_06.md](./FIGMA_PROMPT_Dashboard_06.md)
- **Persona:** Tiago (Operations)
- **Foco:** Prevenção de paradas operacionais
- **Complexidade:** Média-Alta
- **Tempo:** 3 horas
- **Componentes chave:** ABC Pareto chart, Critical alerts banner, Expiration color-coding, Category tabs

### Dashboard 07: Cost Accounting
- **Arquivo:** [FIGMA_PROMPT_Dashboard_07.md](./FIGMA_PROMPT_Dashboard_07.md)
- **Persona:** Claudio (Owner)
- **Foco:** Custo por hectare (métrica crítica)
- **Complexidade:** Muito Alta
- **Tempo:** 4-5 horas
- **Componentes chave:** Interactive treemap with drill-down, Cost/ha trend (5 safras), Budget vs Executed table, View toggle (Farm/Culture)

### Dashboard 08: Purchasing Programming
- **Arquivo:** [FIGMA_PROMPT_Dashboard_08.md](./FIGMA_PROMPT_Dashboard_08.md)
- **Persona:** Valentina (Admin/Financial)
- **Foco:** Gestão de RFQs (Request for Quotation)
- **Complexidade:** Alta
- **Tempo:** 3-4 horas
- **Componentes chave:** 5-column Kanban board, Approval queue with sparklines, One-click approve workflow, Priority badges

### Dashboard 09: Maintenance Hub
- **Arquivo:** [FIGMA_PROMPT_Dashboard_09.md](./FIGMA_PROMPT_Dashboard_09.md)
- **Persona:** Tiago (Operations)
- **Foco:** Redução de downtime e custos de manutenção
- **Complexidade:** Alta
- **Tempo:** 3-4 horas
- **Componentes chave:** Big status indicators (XXL fonts), Service order triage board, Cost split donut, Preventive schedule timeline, Workshop aesthetic

---

## 📁 Estrutura de Arquivos

```
DASHBOARD_MOCKUPS/
│
├── README.md                           ← Você está aqui
├── HANDOFF_PARA_JOAO.md               ← Leia primeiro
├── IMPLEMENTATION_GUIDE.md            ← Guia técnico
├── DELIVERY_CHECKLIST.md              ← Gestão de projeto
│
├── FIGMA_PROMPT_Dashboard_01.md       ← Executive Overview
├── FIGMA_PROMPT_Dashboard_02.md       ← Accounts Receivable
├── FIGMA_PROMPT_Dashboard_03.md       ← Accounts Payable
├── FIGMA_PROMPT_Dashboard_04.md       ← Machinery & Diesel
├── FIGMA_PROMPT_Dashboard_05.md       ← Grain Inventory
├── FIGMA_PROMPT_Dashboard_06.md       ← Inputs Inventory
├── FIGMA_PROMPT_Dashboard_07.md       ← Cost Accounting
├── FIGMA_PROMPT_Dashboard_08.md       ← Purchasing Programming
└── FIGMA_PROMPT_Dashboard_09.md       ← Maintenance Hub
```

---

## 🚀 Quick Start (Para João)

### Passo 1: Leitura (2 horas)
1. Leia [HANDOFF_PARA_JOAO.md](./HANDOFF_PARA_JOAO.md) completo
2. Scan rápido em [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md)
3. Leia [FIGMA_PROMPT_Dashboard_01.md](./FIGMA_PROMPT_Dashboard_01.md) (o piloto)

### Passo 2: Validação Técnica (1 hora)
1. Verificar se o app.dpwai.com.br usa Next.js + Tailwind
2. Instalar dependências necessárias: `lucide-react`, `recharts`
3. Configurar Tailwind com as cores do SOAL (copiar do Implementation Guide)

### Passo 3: Alinhamento (30 min)
1. Agendar kickoff com Rodrigo
2. Definir prioridade dos dashboards
3. Confirmar prazo para Dashboard 01 (piloto)

### Passo 4: Implementação
1. Executar Dashboard 01 (piloto)
2. Obter aprovação do Rodrigo + Claudio
3. Escalar para os outros 8 dashboards

---

## 🎨 Design System Global

Todos os 9 dashboards seguem o mesmo design system:

**Estética:** "Industrial Precision" (Bloomberg Terminal meets John Deere)
**Tema:** Dark exclusivo (sem light mode)
**Resolução base:** 1920×1080px (Desktop HD)
**Font:** Inter (Google Fonts)
**Spacing:** Grid de 4px
**Ícones:** Lucide React
**Gráficos:** Recharts

### Cores
```css
Canvas:      #09090b (background principal)
Surface:     #18181b (cards/panels)
Primary:     #f4f4f5 (texto principal)
Secondary:   #a1a1aa (texto secundário)
Emerald:     #10b981 (lucro, receita, positivo)
Red:         #ef4444 (despesa, dívida, negativo)
Amber:       #f59e0b (pendente, manutenção)
Blue:        #3b82f6 (info, ativo)
Yellow:      #eab308 (soja)
Orange:      #f97316 (milho)
```

---

## 📊 Componentes Reutilizáveis

**Essenciais (criar primeiro):**
1. `KPICard` - Usado em 7 dashboards
2. `StatusBadge` - Usado em 6 dashboards
3. `ProgressGauge` - Usado em 5 dashboards
4. `DataTable` - Usado em 8 dashboards
5. `BarChart` - Usado em 6 dashboards
6. `LineChart` - Usado em 4 dashboards
7. `AlertBanner` - Usado em 4 dashboards
8. `FilterBar` - Usado em 9 dashboards (global)

**Específicos (criar sob demanda):**
- `WaterfallChart` - Dashboard 01
- `HeatmapCalendar` - Dashboard 02
- `SiloVisual` - Dashboard 05
- `TreeMap` - Dashboard 07
- `KanbanBoard` - Dashboard 08
- `ScatterPlot` - Dashboard 04

**Código base de todos esses componentes está em [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md).**

---

## 🔗 Contexto do Projeto SOAL

### O Problema
A SOAL (Serra da Onça Agropecuária) gera dados em 4 sistemas separados:
- **AgriWin** (Financeiro/Estoque)
- **SharePoint** (Planejamento)
- **John Deere Operations Center** (Campo)
- **Castrolanda** (Comercial)

Hoje, para calcular **Custo Real por Hectare**, é necessário meio dia de trabalho manual juntando planilhas.

### A Solução
Construir 9 dashboards operacionais que:
1. **Integram dados** de múltiplas fontes (via Data Warehouse)
2. **Apresentam informações** de forma clara e acionável
3. **Permitem decisões rápidas** (minutos, não dias)

### O Impacto
- **Claudio:** Tomar decisões de R$ 5MM em 5 minutos (vs horas)
- **Tiago:** Evitar paradas operacionais de R$ 50k/dia
- **Valentina:** Gerenciar cash flow de R$ 30MM/ano com zero surpresas

---

## 📞 Próximos Passos Imediatos

### Para João
1. ✅ Ler este README completo
2. ✅ Ler [HANDOFF_PARA_JOAO.md](./HANDOFF_PARA_JOAO.md)
3. ✅ Validar stack do app.dpwai.com.br
4. 📅 Agendar kickoff com Rodrigo
5. 🚀 Começar Dashboard 01 (piloto)

### Para Rodrigo
1. ✅ Preparar pacote de entrega (este diretório) - **DONE**
2. 📅 Definir prioridade dos dashboards com Claudio/Tiago
3. 📅 Agendar kickoff com João
4. 🔍 Revisar Dashboard 01 quando João implementar

---

## ❓ Dúvidas Frequentes

**Q: Preciso executar todos os 9 dashboards no Figma antes de codificar?**
A: Não. Você pode escolher entre:
- Opção A: Figma primeiro (mais preciso, leva mais tempo)
- Opção B: Código direto seguindo as specs (mais rápido, pode precisar iterações)

**Q: O backend está pronto?**
A: Provavelmente não. Use dados mockados nas primeiras fases. A integração com APIs reais vem depois.

**Q: Qual dashboard fazer primeiro?**
A: Dashboard 01 (Executive Overview) como piloto. Depois, definir prioridade com Claudio/Tiago.

**Q: Quanto tempo vai levar?**
A: Estimativa:
- Dashboard 01 (piloto): 1-2 semanas
- Dashboards 02-09: 4-8 semanas (dependendo da priorização)
- Integração backend: 2-3 semanas
- QA e refinamento: 1 semana
- **Total: 8-14 semanas**

**Q: Posso adaptar as specs?**
A: Sim, mas alinhe com Rodrigo antes. As specs foram desenhadas para atender necessidades específicas do negócio.

**Q: Onde tirar dúvidas?**
A: Rodrigo Kugler (contato no HANDOFF_PARA_JOAO.md)

---

## 📚 Documentos de Contexto Adicional

Se você quiser entender melhor o projeto SOAL:

**Na pasta `/18_SPECIFICACOES_TECNICAS_FRONTEND/`:**
- `SOAL_FRONTEND_MASTERPLAN.md` - Especificação técnica master
- `dashboard_design_prompts.md` - Specs originais dos dashboards
- `SOAL_SETUP_GUIDE.md` - Guia de setup do ambiente

**Na pasta raiz do projeto:**
- `14_APRESENTACAO_CONCEITO_SOAL.md` - Apresentação do conceito para stakeholders

---

## 🎯 Objetivo Final

**Visão:** Transformar a SOAL de uma operação agrícola de 2.000 hectares baseada em "feeling" para uma máquina de decisão data-driven capaz de escalar para 20.000 hectares com confiança absoluta.

**Estes dashboards não são "apenas telas bonitas"** — eles são a interface de comando de um sistema nervoso digital que conecta dados de 4 sistemas legados e os transforma em insights acionáveis em tempo real.

---

**Bora transformar o agro em tech! 🚜💻**

---

*Última atualização: 29 de Janeiro de 2026*
*Preparado por: Rodrigo Kugler*
*Destinatário: João (Dev Lead - app.dpwai.com.br)*
