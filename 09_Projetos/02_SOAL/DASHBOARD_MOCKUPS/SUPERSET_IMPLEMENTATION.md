# 🚀 Implementação Rápida: Apache Superset + Design SOAL

**Objetivo:** Acelerar o desenvolvimento dos dashboards usando Superset como engine de BI, mantendo fidelidade ao design "Industrial Precision".

**Tempo estimado:** 2-4 semanas (vs 8-14 semanas para código custom)
**Economia:** 50-60% do esforço original

---

## 📊 Estratégia de Implementação

### Dashboards via Superset (4 dashboards)
| Dashboard | Complexidade Superset | Fidelidade Design |
|-----------|----------------------|-------------------|
| 01 Executive | Baixa | 85% |
| 02 Receivables | Média (Heatmap) | 80% |
| 03 Payables | Baixa | 90% |
| 06 Inputs | Baixa | 85% |

### Dashboards Custom React (4 dashboards)
| Dashboard | Razão Custom |
|-----------|-------------|
| 04 Machinery | Scatter plot com quadrantes + machine cards específicos |
| 05 Grain | Silo Visual 2D animado não existe em BI tools |
| 07 Cost Accounting | TreeMap interativo com drill-down complexo |
| 08 Purchasing | Kanban board não existe em BI tools |

### Dashboard Híbrido (1 dashboard)
| Dashboard | Superset | Custom |
|-----------|----------|--------|
| 09 Maintenance | Donut chart, tabelas | Big status indicators |

---

## 🛠 Parte 1: Setup do Superset

### 1.1. Instalação via Docker (Recomendado)

```bash
# Clone o repositório oficial
git clone https://github.com/apache/superset.git
cd superset

# Iniciar com Docker Compose
docker compose -f docker-compose-non-dev.yml up -d

# Acessar em http://localhost:8088
# Login: admin / admin
```

### 1.2. Conectar ao PostgreSQL Gold Layer

1. Acesse **Settings > Database Connections**
2. Clique **+ Database**
3. Selecione **PostgreSQL**
4. Configure:
   ```
   Host: [seu-host-postgres]
   Port: 5432
   Database: soal_gold_layer
   Username: [user]
   Password: [password]
   Display Name: SOAL Gold Layer
   ```

---

## 🎨 Parte 2: Customização do Tema Dark "Industrial Precision"

### 2.1. Criar Tema Custom CSS

Superset permite injetar CSS customizado. Crie o arquivo:

```css
/* superset_custom_theme.css */

/* ================================================
   SOAL "Industrial Precision" Theme for Superset
   ================================================ */

/* ----- ROOT VARIABLES ----- */
:root {
  /* Backgrounds */
  --soal-bg-canvas: #09090b;
  --soal-bg-surface: #18181b;
  --soal-bg-surface-highlight: #27272a;

  /* Typography */
  --soal-text-primary: #f4f4f5;
  --soal-text-secondary: #a1a1aa;
  --soal-text-muted: #52525b;

  /* Semantic Colors */
  --soal-brand-primary: #10b981;
  --soal-brand-danger: #ef4444;
  --soal-brand-warning: #f59e0b;
  --soal-brand-info: #3b82f6;

  /* Agro Colors */
  --soal-agro-soy: #eab308;
  --soal-agro-corn: #f97316;
}

/* ----- GLOBAL OVERRIDES ----- */
body {
  background-color: var(--soal-bg-canvas) !important;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif !important;
}

/* ----- DASHBOARD BACKGROUND ----- */
.dashboard {
  background-color: var(--soal-bg-canvas) !important;
}

.dashboard-content {
  background-color: var(--soal-bg-canvas) !important;
}

/* ----- CHART CONTAINERS (Cards) ----- */
.chart-container {
  background-color: var(--soal-bg-surface) !important;
  border: 1px solid #27272a !important;
  border-radius: 8px !important;
}

.slice_container {
  background-color: var(--soal-bg-surface) !important;
}

/* ----- TYPOGRAPHY ----- */
.header-title,
.dashboard-header h1,
.chart-header {
  color: var(--soal-text-primary) !important;
  font-weight: 600 !important;
}

.slice-header span {
  color: var(--soal-text-primary) !important;
  font-size: 14px !important;
  font-weight: 600 !important;
}

/* ----- FILTER BAR ----- */
.filter-bar {
  background-color: var(--soal-bg-surface) !important;
  border-right: 1px solid #27272a !important;
}

.filter-bar .ant-select {
  background-color: var(--soal-bg-surface-highlight) !important;
}

/* ----- TABLES ----- */
.reactable-data td {
  background-color: var(--soal-bg-surface) !important;
  color: var(--soal-text-primary) !important;
  border-color: #27272a !important;
}

.reactable-header-sortable {
  background-color: var(--soal-bg-surface-highlight) !important;
  color: var(--soal-text-secondary) !important;
}

/* ----- BIG NUMBER (KPIs) ----- */
.big-number-total {
  color: var(--soal-text-primary) !important;
  font-weight: 700 !important;
}

.big-number-total.positive {
  color: var(--soal-brand-primary) !important;
}

.big-number-total.negative {
  color: var(--soal-brand-danger) !important;
}

/* ----- CHART COLORS ----- */
/* Force chart color palette */
.nvd3 .nv-bar {
  fill: var(--soal-brand-primary) !important;
}

.echarts-for-react text {
  fill: var(--soal-text-secondary) !important;
}

/* ----- PIE/DONUT CHARTS ----- */
.pie-label-outside {
  fill: var(--soal-text-primary) !important;
}

/* ----- LINE CHARTS ----- */
.nvd3 .nv-line {
  stroke: var(--soal-brand-info) !important;
}

/* ----- TOOLTIPS ----- */
.nvtooltip {
  background-color: var(--soal-bg-surface) !important;
  border: 1px solid #27272a !important;
  color: var(--soal-text-primary) !important;
}

/* ----- LOADING STATES ----- */
.loading-panel {
  background-color: var(--soal-bg-surface) !important;
}

/* ----- SCROLLBARS ----- */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: var(--soal-bg-canvas);
}

::-webkit-scrollbar-thumb {
  background: var(--soal-bg-surface-highlight);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #3f3f46;
}
```

### 2.2. Aplicar o Tema no Superset

**Opção A: Via Docker Environment**

Adicione ao `docker-compose-non-dev.yml`:

```yaml
superset:
  environment:
    - SUPERSET_WEBSERVER_DOMAINS=["localhost:8088", "app.dpwai.com.br"]
  volumes:
    - ./superset_custom_theme.css:/app/superset/static/assets/stylesheets/custom.css
```

**Opção B: Via superset_config.py**

```python
# superset_config.py

# Enable custom CSS
CUSTOM_CSS = """
/* Cole aqui todo o CSS acima */
"""

# Or reference external file
# CUSTOM_CSS_FILE = "/path/to/superset_custom_theme.css"

# Color Palette for Charts
EXTRA_CATEGORICAL_COLOR_SCHEMES = [
    {
        "id": "soal_industrial",
        "description": "SOAL Industrial Precision",
        "label": "SOAL Industrial",
        "isDefault": True,
        "colors": [
            "#10b981",  # Emerald (primary)
            "#3b82f6",  # Blue (info)
            "#f59e0b",  # Amber (warning)
            "#ef4444",  # Red (danger)
            "#eab308",  # Yellow (soy)
            "#f97316",  # Orange (corn)
            "#8b5cf6",  # Violet
            "#06b6d4",  # Cyan
        ]
    }
]
```

---

## 📈 Parte 3: Criando os Dashboards no Superset

### 3.1. Dashboard 01: Executive Overview

**Datasets necessários:**
```sql
-- Dataset: kpis_executive
SELECT
  safra,
  fazenda,
  margem_liquida,
  progresso_colheita_pct,
  receita_bruta,
  custos_variaveis,
  custos_fixos,
  lucro_liquido
FROM gold.vw_executive_kpis
WHERE safra = '2024/2025';
```

**Charts a criar:**

| # | Tipo Superset | Componente SOAL | Config |
|---|---------------|-----------------|--------|
| 1 | Big Number | Margem Líquida | Format: R$ X,XXM, Color: emerald |
| 2 | Big Number with Trendline | Receita Bruta | Format: R$ X,XXM, Sparkline 30d |
| 3 | Big Number | Progresso Colheita | Format: XX%, Suffix: "concluído" |
| 4 | Waterfall | Profitability | Custom: Receita → Custos → Lucro |
| 5 | Table | Risk Alerts | Conditional formatting |

**Layout Grid (Superset):**
```
┌──────────────┬──────────────┬──────────────┬──────────────┐
│  Big Number  │  Big Number  │  Big Number  │  Big Number  │
│  Margem Líq  │  Receita     │  Progresso   │  Custo/ha    │
├──────────────┴──────────────┼──────────────┴──────────────┤
│       Waterfall Chart       │       Risk Alerts Table     │
│     (Profitability Flow)    │    (Conditional Colors)     │
└─────────────────────────────┴─────────────────────────────┘
```

### 3.2. Dashboard 02: Accounts Receivable

**Datasets necessários:**
```sql
-- Dataset: receivables_heatmap
SELECT
  cliente,
  mes,
  ano,
  valor,
  status,  -- 'pago', 'pendente', 'vencido'
  data_vencimento
FROM gold.vw_contas_receber_mensal
WHERE safra = '2024/2025';

-- Dataset: receivables_summary
SELECT
  SUM(CASE WHEN status = 'pago' THEN valor ELSE 0 END) as recebido,
  SUM(CASE WHEN status = 'pendente' THEN valor ELSE 0 END) as a_receber,
  SUM(CASE WHEN status = 'vencido' THEN valor ELSE 0 END) as vencido
FROM gold.vw_contas_receber;
```

**Charts a criar:**

| # | Tipo Superset | Componente SOAL |
|---|---------------|-----------------|
| 1 | Big Number | Total Recebido |
| 2 | Big Number | Total A Receber |
| 3 | Big Number | Total Vencido (red) |
| 4 | Heatmap | Payment Calendar (cliente × mês) |
| 5 | Table | Detailed Receivables |

**Heatmap Config:**
```json
{
  "viz_type": "heatmap",
  "all_columns_x": "mes",
  "all_columns_y": "cliente",
  "metric": "valor",
  "linear_color_scheme": "custom",
  "custom_colors": ["#27272a", "#10b981"]
}
```

### 3.3. Dashboard 03: Accounts Payable

**Datasets necessários:**
```sql
-- Dataset: payables_by_category
SELECT
  categoria,
  SUM(valor) as total,
  COUNT(*) as qtd_pagamentos
FROM gold.vw_contas_pagar
WHERE safra = '2024/2025'
GROUP BY categoria;

-- Dataset: cash_burn_projection
SELECT
  data,
  saldo_projetado,
  pagamentos_dia
FROM gold.vw_projecao_caixa
WHERE data BETWEEN CURRENT_DATE AND CURRENT_DATE + 90;
```

**Charts a criar:**

| # | Tipo Superset | Componente SOAL |
|---|---------------|-----------------|
| 1 | Big Number | Total A Pagar |
| 2 | Big Number | Próximos 7 Dias |
| 3 | Stacked Bar | Despesas por Categoria |
| 4 | Line Chart | Cash Burn Projection |
| 5 | Table | Payment Queue |

### 3.4. Dashboard 06: Inputs Inventory

**Datasets necessários:**
```sql
-- Dataset: inventory_current
SELECT
  produto,
  categoria,  -- 'Defensivos', 'Fertilizantes', 'Sementes', 'Peças'
  quantidade,
  unidade,
  valor_unitario,
  valor_total,
  data_validade,
  dias_para_vencer,
  classificacao_abc  -- 'A', 'B', 'C'
FROM gold.vw_estoque_insumos;
```

**Charts a criar:**

| # | Tipo Superset | Componente SOAL |
|---|---------------|-----------------|
| 1 | Big Number | Valor Total Estoque |
| 2 | Pie Chart | Distribuição por Categoria |
| 3 | Bar Chart | ABC Pareto (ordenado por valor) |
| 4 | Table | Inventory Details (com conditional formatting para validade) |

---

## 🔗 Parte 4: Embedding no app.dpwai.com.br

### 4.1. Habilitar Guest Access

```python
# superset_config.py

# Enable embedding
GUEST_ROLE_NAME = "Public"
GUEST_TOKEN_JWT_SECRET = "your-secret-key"
GUEST_TOKEN_JWT_ALGO = "HS256"
GUEST_TOKEN_HEADER_NAME = "X-GuestToken"

# Enable CORS for embedding
ENABLE_CORS = True
CORS_OPTIONS = {
    "supports_credentials": True,
    "allow_headers": ["*"],
    "resources": ["*"],
    "origins": ["https://app.dpwai.com.br", "http://localhost:3000"]
}

# Feature flags
FEATURE_FLAGS = {
    "EMBEDDED_SUPERSET": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
}
```

### 4.2. Gerar Guest Token (Backend)

```typescript
// api/superset/guest-token.ts
import jwt from 'jsonwebtoken';

export async function generateGuestToken(dashboardId: string, userId: string) {
  const payload = {
    user: {
      username: userId,
      first_name: "Guest",
      last_name: "User",
    },
    resources: [{
      type: "dashboard",
      id: dashboardId,
    }],
    rls: [], // Row Level Security filters if needed
  };

  const token = jwt.sign(payload, process.env.SUPERSET_JWT_SECRET!, {
    algorithm: 'HS256',
    expiresIn: '1h',
  });

  return token;
}
```

### 4.3. Componente React para Embed

```tsx
// components/SupersetDashboard.tsx
import { useEffect, useRef } from 'react';
import { embedDashboard } from '@superset-ui/embedded-sdk';

interface SupersetDashboardProps {
  dashboardId: string;
  filters?: Record<string, string>;
}

export function SupersetDashboard({ dashboardId, filters }: SupersetDashboardProps) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const embed = async () => {
      if (!containerRef.current) return;

      // Get guest token from our backend
      const response = await fetch(`/api/superset/guest-token?dashboard=${dashboardId}`);
      const { token } = await response.json();

      await embedDashboard({
        id: dashboardId,
        supersetDomain: process.env.NEXT_PUBLIC_SUPERSET_URL!,
        mountPoint: containerRef.current,
        fetchGuestToken: () => Promise.resolve(token),
        dashboardUiConfig: {
          hideTitle: true,
          hideChartControls: true,
          hideTab: true,
          filters: {
            visible: true,
            expanded: false,
          },
        },
      });
    };

    embed();
  }, [dashboardId]);

  return (
    <div
      ref={containerRef}
      className="w-full h-full min-h-[800px] bg-canvas"
    />
  );
}
```

### 4.4. Uso nas Pages

```tsx
// app/dashboards/executive/page.tsx
import { SupersetDashboard } from '@/components/SupersetDashboard';

export default function ExecutiveDashboard() {
  return (
    <div className="flex flex-col h-screen bg-canvas">
      <header className="h-16 bg-surface border-b border-zinc-800 flex items-center px-6">
        <h1 className="text-xl font-bold text-primary">Executive Overview</h1>
        {/* Filters can go here */}
      </header>

      <main className="flex-1 overflow-hidden">
        <SupersetDashboard
          dashboardId="1"
          filters={{ safra: '2024/2025' }}
        />
      </main>
    </div>
  );
}
```

---

## 🎨 Parte 5: Custom Visualizations (para componentes que não existem)

### 5.1. Silo Visual (Dashboard 05)

Superset permite criar plugins de visualização custom. Para o Silo:

```typescript
// superset-frontend/plugins/plugin-chart-silo/src/Silo.tsx
import React from 'react';

interface SiloProps {
  data: Array<{
    name: string;
    current: number;
    max: number;
    color: string;
  }>;
  height: number;
  width: number;
}

export default function Silo({ data, height, width }: SiloProps) {
  const siloWidth = Math.min(120, width / data.length - 20);
  const siloHeight = height - 60;

  return (
    <div className="flex justify-around items-end p-4" style={{ height, width }}>
      {data.map((silo, index) => {
        const fillPct = (silo.current / silo.max) * 100;
        const fillHeight = (siloHeight - 40) * (fillPct / 100);

        return (
          <div key={index} className="flex flex-col items-center">
            <svg width={siloWidth} height={siloHeight}>
              {/* Silo roof */}
              <path
                d={`M ${siloWidth * 0.2} 0 L ${siloWidth * 0.8} 0 L ${siloWidth} 30 L 0 30 Z`}
                fill="#27272a"
                stroke="#52525b"
                strokeWidth="2"
              />
              {/* Silo body */}
              <rect
                x="0"
                y="30"
                width={siloWidth}
                height={siloHeight - 30}
                fill="#18181b"
                stroke="#52525b"
                strokeWidth="2"
              />
              {/* Fill */}
              <rect
                x="4"
                y={siloHeight - fillHeight - 4}
                width={siloWidth - 8}
                height={fillHeight}
                fill={silo.color}
                opacity="0.8"
              />
              {/* Label */}
              <text
                x={siloWidth / 2}
                y={siloHeight / 2}
                textAnchor="middle"
                fill="white"
                fontSize="14"
                fontWeight="bold"
              >
                {silo.current.toLocaleString()}t
              </text>
            </svg>
            <p className="text-sm text-secondary mt-2">{silo.name}</p>
            <p className="text-xs text-muted">{fillPct.toFixed(0)}%</p>
          </div>
        );
      })}
    </div>
  );
}
```

### 5.2. Registrar o Plugin

```typescript
// superset-frontend/src/visualizations/presets/MainPreset.js
import SiloChartPlugin from '../plugins/plugin-chart-silo';

export default class MainPreset {
  constructor() {
    this.plugins = [
      // ... existing plugins
      new SiloChartPlugin().configure({ key: 'silo' }),
    ];
  }
}
```

---

## ⏱ Parte 6: Timeline de Implementação

### Semana 1: Setup e Tema
- [ ] Instalar Superset via Docker
- [ ] Conectar PostgreSQL Gold Layer
- [ ] Aplicar tema CSS "Industrial Precision"
- [ ] Validar cores e tipografia

### Semana 2: Dashboards Superset (01, 02, 03, 06)
- [ ] Criar datasets SQL
- [ ] Configurar Dashboard 01 (Executive)
- [ ] Configurar Dashboard 02 (Receivables)
- [ ] Configurar Dashboard 03 (Payables)
- [ ] Configurar Dashboard 06 (Inputs)

### Semana 3: Custom Components + Embedding
- [ ] Criar plugin Silo Visual
- [ ] Configurar embedding no app.dpwai.com.br
- [ ] Testar guest tokens
- [ ] Integrar dashboards na aplicação

### Semana 4: Dashboards Custom (04, 05, 07, 08)
- [ ] Implementar Dashboard 04 (Machinery) - Custom React
- [ ] Implementar Dashboard 05 (Grain) - Custom + Silo plugin
- [ ] Implementar Dashboard 07 (Cost) - Custom React
- [ ] Implementar Dashboard 08 (Purchasing) - Custom React

### Semana 5: QA e Refinamento
- [ ] Testar todos os dashboards
- [ ] Ajustar responsividade
- [ ] Performance tuning
- [ ] Feedback do time

---

## ✅ Checklist Final

### Superset
- [ ] Tema dark "Industrial Precision" aplicado
- [ ] 4 dashboards criados (01, 02, 03, 06)
- [ ] Embedding funcionando
- [ ] Guest tokens configurados
- [ ] RLS (Row Level Security) se necessário

### Custom Components
- [ ] Silo Visual plugin criado
- [ ] 4 dashboards custom implementados (04, 05, 07, 08)
- [ ] Integração com APIs

### Integração
- [ ] app.dpwai.com.br exibindo todos os 9 dashboards
- [ ] Navegação entre dashboards
- [ ] Filtros globais (Safra, Fazenda)
- [ ] Performance < 2s load time

---

## 📚 Recursos

- [Apache Superset Docs](https://superset.apache.org/docs/)
- [Superset Embedding SDK](https://www.npmjs.com/package/@superset-ui/embedded-sdk)
- [Custom Viz Plugins](https://superset.apache.org/docs/contributing/creating-viz-plugins)
- [Superset Docker](https://superset.apache.org/docs/installation/docker-compose)

---

**Tempo Total Estimado:** 4-5 semanas (vs 8-14 semanas código puro)
**Economia:** ~50% do esforço
**Fidelidade ao Design:** 85-90%

---

*Preparado por: Claude Code*
*Data: 29 de Janeiro de 2026*
