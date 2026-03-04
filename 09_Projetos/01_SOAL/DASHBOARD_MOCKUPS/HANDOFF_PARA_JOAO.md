# 📦 Pacote de Handoff: Dashboards SOAL → João

**Data:** 29 de Janeiro de 2026
**De:** Rodrigo Kugler
**Para:** João (Dev Lead - www.app.dpwai.com.br)
**Objetivo:** Fornecer todos os views dos 9 dashboards SOAL para integração no app existente

---

## 🎯 1. O Que Você Está Recebendo

### 1.1. Pacote de Design (Figma Prompts)
**Localização:** `/DASHBOARD_MOCKUPS/FIGMA_PROMPT_Dashboard_*.md`

Você tem **9 documentos de especificação completos**, cada um contendo:
- ✅ Layout pixel-perfect (1920×1080px)
- ✅ Sistema de cores completo (HEX codes)
- ✅ Tipografia (Inter font, todos os tamanhos)
- ✅ Especificações de componentes
- ✅ Dados de exemplo realistas
- ✅ Lógica de negócio e cálculos

**Tempo estimado de execução no Figma:** 30-38 horas (você pode começar por qualquer dashboard prioritário)

### 1.2. Lista dos 9 Dashboards

| # | Nome | Foco | Persona | Complexidade | Tempo |
|---|------|------|---------|--------------|-------|
| 01 | Executive Overview | "Raio-X da Safra" | Claudio | Média-Alta | 2-3h |
| 02 | Accounts Receivable | Liquidez | Valentina | Alta | 3-4h |
| 03 | Accounts Payable | Fluxo de Caixa | Valentina | Média | 2-3h |
| 04 | Machinery & Diesel | Eficiência Frota | Tiago | Muito Alta | 4-5h |
| 05 | Grain Inventory | "Hold or Sell?" | Claudio | Alta | 4h |
| 06 | Inputs Inventory | Prevenção Paradas | Tiago | Média-Alta | 3h |
| 07 | Cost Accounting | Custo/Hectare | Claudio | Muito Alta | 4-5h |
| 08 | Purchasing Programming | RFQ Kanban | Valentina | Alta | 3-4h |
| 09 | Maintenance Hub | Redução Downtime | Tiago | Alta | 3-4h |

---

## 🛠 2. Stack Técnico do Projeto

**⚠️ IMPORTANTE:** Estes dashboards foram desenhados para este stack específico. Se o seu app usa outra stack, algumas adaptações podem ser necessárias.

### 2.1. Stack Esperada
```
Framework:      Next.js 14+ (App Router)
Styling:        TailwindCSS 3+
Components:     Shadcn/UI (customizado)
Icons:          Lucide React
Gráficos:       Recharts (primary) ou Chart.js
Linguagem:      TypeScript (preferencial)
```

### 2.2. Design System Global

#### Cores (Tailwind Tokens)
```css
/* Backgrounds */
--bg-canvas: #09090b;           /* Main background */
--bg-surface: #18181b;          /* Cards/Panels */
--bg-surface-highlight: #27272a; /* Hover states */

/* Typography */
--text-primary: #f4f4f5;        /* Zinc-100 */
--text-secondary: #a1a1aa;      /* Zinc-400 */
--text-muted: #52525b;          /* Zinc-600 */

/* Semantic Colors */
--brand-primary: #10b981;       /* Emerald-500 - Lucro, Receita */
--brand-danger: #ef4444;        /* Red-500 - Dívida, Despesa, Alertas */
--brand-warning: #f59e0b;       /* Amber-500 - Pendências, Manutenção */
--brand-info: #3b82f6;          /* Blue-500 - Status Ativo */
--agro-soy: #eab308;           /* Yellow-500 - Soja */
--agro-corn: #f97316;          /* Orange-500 - Milho */
```

#### Tipografia
```css
Font Family:    Inter (Google Fonts)
Font Weights:   400 (Regular), 500 (Medium), 600 (Semibold), 700 (Bold)

Hierarchy:
- Display:      text-4xl (36px) / font-bold
- H1:           text-3xl (30px) / font-bold
- H2:           text-2xl (24px) / font-semibold
- H3:           text-xl (20px) / font-semibold
- Body:         text-base (16px) / font-normal
- Caption:      text-sm (14px) / font-normal
- Label:        text-xs (12px) / font-medium
```

#### Espaçamento (Grid 4px)
```
Componentes internos:  gap-2 (8px), gap-4 (16px)
Cards/Panels:          p-4 (16px), p-6 (24px)
Layout principal:      gap-6 (24px)
```

---

## 📋 3. Fluxo de Trabalho Recomendado

### 3.1. Opção A: Figma → Código (Recomendado)
```
1. Executar os 9 Figma Prompts no Figma
   ↓
2. Obter designs finais aprovados pelo Rodrigo/Claudio/Tiago
   ↓
3. Exportar assets e medidas do Figma
   ↓
4. Implementar components no app.dpwai.com.br
   ↓
5. Integrar com APIs backend (PostgreSQL Gold Layer)
```

### 3.2. Opção B: Código Direto (Mais Rápido, Menos Preciso)
```
1. Ler os FIGMA_PROMPT_Dashboard_*.md
   ↓
2. Implementar diretamente no código seguindo as specs
   ↓
3. Iterar com feedback visual do time
```

**👉 Recomendação:** Use a **Opção A** para dashboards críticos (01, 04, 05, 07). Use a **Opção B** para dashboards secundários (03, 08, 09) se o tempo for apertado.

---

## 🎨 4. Como Usar os Figma Prompts

### 4.1. Setup Inicial no Figma
1. Abra o Figma (navegador ou desktop app)
2. Crie um novo arquivo: "SOAL - Dashboards Operacionais"
3. Configure a página com o artboard 1920×1080px (Desktop HD)
4. Instale o plugin "Content Reel" para popular dados (opcional)

### 4.2. Executando Cada Prompt
Cada arquivo `FIGMA_PROMPT_Dashboard_XX.md` contém:

```
1. DESIGN BRIEF (contexto de negócio)
2. CANVAS SETUP (dimensões, grid, cores)
3. LAYOUT STRUCTURE (wireframe em texto)
4. COMPONENTS (especificações detalhadas)
5. SAMPLE DATA (dados realistas para preencher)
6. IMPLEMENTATION NOTES (lógica de negócio)
7. FINAL CHECKLIST (QA visual)
```

**Como usar:**
1. Leia o documento completo
2. Siga a seção "LAYOUT STRUCTURE" para criar o wireframe
3. Use "COMPONENTS" para detalhar cada elemento
4. Preencha com "SAMPLE DATA"
5. Valide com "FINAL CHECKLIST"

---

## 🔗 5. Integração com Backend (www.app.dpwai.com.br)

### 5.1. Estrutura de Dados Esperada

Estes dashboards foram projetados para consumir dados da **"Gold Layer"** (camada Ouro) do Data Warehouse SOAL.

**Tabelas PostgreSQL esperadas:**
```sql
- financial_kpis          -- Dashboard 01, 02, 03
- machine_telemetry_agg   -- Dashboard 04, 09
- inventory_current       -- Dashboard 05, 06
- cost_accounting         -- Dashboard 07
- purchasing_requests     -- Dashboard 08
```

### 5.2. Endpoints API Sugeridos

Para cada dashboard, você precisará de endpoints REST ou GraphQL:

```typescript
// Dashboard 01: Executive Overview
GET /api/dashboards/executive
Response: {
  net_margin: number;
  harvest_progress: number;
  profitability_waterfall: Array<{stage: string, value: number}>;
  risk_alerts: Array<{type: string, message: string, severity: string}>;
}

// Dashboard 04: Machinery
GET /api/dashboards/machinery
Response: {
  fleet: Array<{
    id: string;
    name: string;
    status: "operating" | "maintenance" | "stopped";
    fuel_efficiency: number;
    operator: string;
  }>;
}

// ... (repetir para os 9 dashboards)
```

**👉 Documentação Completa das APIs deve ser criada após definição do schema PostgreSQL.**

### 5.3. MCP Integration (Futuro - Fase 2)

Os dashboards foram projetados para serem **"MCP-Ready"** (Model Context Protocol).

Isso significa que futuramente, um agente de IA poderá:
- Ler os dados desses dashboards
- Responder perguntas como: *"Por que o custo de diesel subiu 20% em Novembro?"*
- Acionar workflows via N8N diretamente do chat

**Para Fase 1 (agora):** Ignore o MCP. Foque apenas na UI/UX.
**Para Fase 2 (futuro):** Cada dashboard deve exportar seu "contexto" via `api/mcp/` routes.

---

## 📦 6. Estrutura de Entrega Sugerida

### 6.1. Organização de Pastas no Seu Repositório

Sugestão para `www.app.dpwai.com.br`:

```
app.dpwai.com.br/
├── app/
│   ├── dashboards/
│   │   ├── executive/page.tsx        # Dashboard 01
│   │   ├── receivables/page.tsx      # Dashboard 02
│   │   ├── payables/page.tsx         # Dashboard 03
│   │   ├── machinery/page.tsx        # Dashboard 04
│   │   ├── grain-inventory/page.tsx  # Dashboard 05
│   │   ├── inputs-inventory/page.tsx # Dashboard 06
│   │   ├── cost-accounting/page.tsx  # Dashboard 07
│   │   ├── purchasing/page.tsx       # Dashboard 08
│   │   └── maintenance/page.tsx      # Dashboard 09
│   └── layout.tsx (Global Layout com Sidebar)
├── components/
│   ├── ui/              # Shadcn/UI components
│   ├── dashboard/       # Dashboard-specific components
│   │   ├── KPICard.tsx
│   │   ├── WaterfallChart.tsx
│   │   ├── StatusBadge.tsx
│   │   └── ...
│   └── charts/          # Recharts wrappers
│       ├── CircularProgress.tsx
│       ├── HeatmapCalendar.tsx
│       └── ...
├── lib/
│   ├── api.ts           # API client functions
│   ├── utils.ts         # Utility functions
│   └── constants.ts     # Colors, fonts, etc.
└── styles/
    └── globals.css      # Tailwind + custom CSS
```

### 6.2. Componentes Reutilizáveis (Prioridade Alta)

Baseado nos 9 dashboards, estes componentes aparecem múltiplas vezes:

**Essenciais (criar primeiro):**
```typescript
1. KPICard           - Usado em 7 dashboards
2. StatusBadge       - Usado em 6 dashboards
3. ProgressGauge     - Usado em 5 dashboards
4. DataTable         - Usado em 8 dashboards
5. BarChart          - Usado em 6 dashboards
6. LineChart         - Usado em 4 dashboards
7. AlertBanner       - Usado em 4 dashboards
8. FilterBar         - Usado em 9 dashboards (global)
```

**Específicos (criar sob demanda):**
```typescript
- WaterfallChart       (Dashboard 01)
- HeatmapCalendar      (Dashboard 02)
- SiloVisual           (Dashboard 05)
- TreeMap              (Dashboard 07)
- KanbanBoard          (Dashboard 08)
- ScatterPlot          (Dashboard 04)
```

---

## ✅ 7. Checklist de Integração

### 7.1. Antes de Começar
- [ ] Confirmar acesso ao repositório `www.app.dpwai.com.br`
- [ ] Verificar se o stack é compatível (Next.js + Tailwind + React)
- [ ] Confirmar estrutura de pastas e convenções de código existentes
- [ ] Alinhar com Rodrigo sobre prioridade dos dashboards (qual fazer primeiro?)

### 7.2. Fase 1: Setup do Design System
- [ ] Configurar as cores globais no `tailwind.config.js`
- [ ] Adicionar Inter font ao projeto (`next/font/google`)
- [ ] Criar componentes base (KPICard, StatusBadge, etc.)
- [ ] Criar o Layout global com Sidebar

### 7.3. Fase 2: Implementação dos Dashboards (Iterativa)
- [ ] Dashboard 01: Executive Overview (prioridade máxima para Claudio)
- [ ] Dashboard 04: Machinery (prioridade máxima para Tiago)
- [ ] Dashboard 07: Cost Accounting (prioridade máxima para Claudio)
- [ ] Dashboards 02, 03, 05, 06, 08, 09 (ordem a definir com time)

### 7.4. Fase 3: Integração Backend
- [ ] Definir schema das APIs com o backend
- [ ] Implementar fetch/SWR/React Query nos dashboards
- [ ] Substituir dados mockados por dados reais
- [ ] Testar com dados de produção (safeguard de segurança)

### 7.5. Fase 4: QA e Refinamento
- [ ] Testar em resoluções diferentes (1366×768, 1920×1080, 2560×1440)
- [ ] Validar cores e legibilidade com Claudio/Tiago/Valentina
- [ ] Performance check (tempo de load < 2s)
- [ ] Validar cálculos de negócio com dados reais

---

## 🚀 8. Próximos Passos Imediatos

### 8.1. Para Você (João)
1. **Ler este documento completo**
2. **Escolher o caminho:** Opção A (Figma primeiro) ou Opção B (código direto)?
3. **Alinhar com Rodrigo:** Qual dashboard começar primeiro?
4. **Setup do ambiente:**
   - Clonar/atualizar repositório `app.dpwai.com.br`
   - Instalar dependências (se necessário): `lucide-react`, `recharts`
   - Configurar Tailwind com as cores do SOAL
5. **Executar o primeiro dashboard** (recomendado: Dashboard 01 ou 04)

### 8.2. Para o Rodrigo (Suporte)
1. **Aprovação de prioridades:** Definir ordem de implementação
2. **Revisão de Figma:** Se João executar os prompts, revisar os designs
3. **Validação de negócio:** Conferir se os cálculos e métricas estão corretos
4. **Feedback contínuo:** Ciclo de review após cada dashboard implementado

---

## 📞 9. Contato e Suporte

**Dúvidas sobre:**
- **Design/UX:** Rodrigo Kugler
- **Regras de negócio:** Claudio, Tiago (via Rodrigo)
- **Stack técnico:** João (líder do projeto)

**Documentos de Referência:**
- `SOAL_FRONTEND_MASTERPLAN.md` - Especificação técnica completa
- `dashboard_design_prompts.md` - Specs originais dos dashboards
- `FIGMA_PROMPT_Dashboard_*.md` (9 arquivos) - Specs detalhadas para Figma
- `14_APRESENTACAO_CONCEITO_SOAL.md` - Contexto de negócio

---

## 🎯 10. Objetivo Final

**Visão:** Transformar a SOAL de uma operação agrícola de 2.000 hectares baseada em "feeling" para uma máquina de decisão data-driven capaz de escalar para 20.000 hectares com confiança absoluta.

**Estes dashboards não são "apenas telas bonitas"** — eles são a interface de comando de um sistema nervoso digital que permite:
- Claudio tomar decisões de R$ 5MM em 5 minutos
- Tiago evitar paradas operacionais de R$ 50k/dia
- Valentina gerenciar cash flow de R$ 30MM/ano com zero surpresas

**Prazo:** Não há prazo definido. Qualidade > Velocidade. Mas quanto mais rápido validarmos o Dashboard 01 com dados reais, mais rápido podemos iterar nos outros.

---

**Bora botar o braço! 💪**
