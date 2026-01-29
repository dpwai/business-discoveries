# 🔧 Guia de Implementação Técnica: Componentes SOAL

**Complemento ao HANDOFF_PARA_JOAO.md**
**Para:** João (Dev Lead)
**Foco:** Como implementar os componentes mais complexos dos dashboards

---

## 📚 Índice de Componentes

1. [KPI Card](#1-kpi-card) - Básico, usado em todos os dashboards
2. [Circular Progress Gauge](#2-circular-progress-gauge) - Dashboard 01, 05
3. [Waterfall Chart](#3-waterfall-chart) - Dashboard 01
4. [Heatmap Calendar](#4-heatmap-calendar) - Dashboard 02
5. [2D Silo Visual](#5-2d-silo-visual) - Dashboard 05
6. [TreeMap Interactive](#6-treemap-interactive) - Dashboard 07
7. [Kanban Board](#7-kanban-board) - Dashboard 08
8. [Scatter Plot com Quadrantes](#8-scatter-plot-com-quadrantes) - Dashboard 04

---

## 1. KPI Card

**Usado em:** Todos os dashboards
**Complexidade:** Baixa
**Biblioteca:** Não precisa (puro React + Tailwind)

### 1.1. Anatomia

```
┌─────────────────────────────────────┐
│ LABEL (12px, text-muted)           │
│                                     │
│ VALUE (30px, font-bold)        ↑   │
│ text-primary ou semantic color  8% │
│                                     │
│ SUBTITLE (14px, text-secondary)    │
└─────────────────────────────────────┘
```

### 1.2. Código Base

```tsx
// components/dashboard/KPICard.tsx
import { LucideIcon } from 'lucide-react';
import { cn } from '@/lib/utils';

interface KPICardProps {
  label: string;
  value: string | number;
  subtitle?: string;
  trend?: {
    value: number;
    direction: 'up' | 'down';
  };
  icon?: LucideIcon;
  variant?: 'default' | 'success' | 'danger' | 'warning';
  className?: string;
}

export function KPICard({
  label,
  value,
  subtitle,
  trend,
  icon: Icon,
  variant = 'default',
  className
}: KPICardProps) {
  const variantStyles = {
    default: 'text-primary',
    success: 'text-emerald-500',
    danger: 'text-red-500',
    warning: 'text-amber-500'
  };

  return (
    <div className={cn(
      "bg-surface rounded-lg p-6 border border-zinc-800",
      className
    )}>
      <div className="flex items-start justify-between mb-4">
        <p className="text-xs font-medium text-muted uppercase tracking-wide">
          {label}
        </p>
        {Icon && <Icon className="w-4 h-4 text-zinc-600" />}
      </div>

      <div className="flex items-baseline gap-2">
        <p className={cn(
          "text-3xl font-bold",
          variantStyles[variant]
        )}>
          {value}
        </p>

        {trend && (
          <span className={cn(
            "text-sm font-medium",
            trend.direction === 'up' ? 'text-emerald-500' : 'text-red-500'
          )}>
            {trend.direction === 'up' ? '↑' : '↓'} {Math.abs(trend.value)}%
          </span>
        )}
      </div>

      {subtitle && (
        <p className="text-sm text-secondary mt-2">
          {subtitle}
        </p>
      )}
    </div>
  );
}
```

### 1.3. Exemplo de Uso

```tsx
<KPICard
  label="Margem Líquida"
  value="R$ 2,4M"
  subtitle="vs R$ 2,1M safra anterior"
  trend={{ value: 14.3, direction: 'up' }}
  variant="success"
/>
```

---

## 2. Circular Progress Gauge

**Usado em:** Dashboard 01 (Harvest Progress), Dashboard 05 (Commercialization)
**Complexidade:** Média
**Biblioteca:** Recharts ou SVG customizado

### 2.1. Anatomia

```
       ┌───────────────┐
       │   PROGRESS    │
       │               │
       │     68%       │  ← Center value (48px, bold)
       │               │
       │  450/660 ha   │  ← Subtitle (14px)
       └───────────────┘
```

### 2.2. Código Base (SVG Customizado)

```tsx
// components/charts/CircularProgress.tsx
interface CircularProgressProps {
  value: number;        // 0-100
  size?: number;        // diameter in px
  strokeWidth?: number;
  color?: string;
  bgColor?: string;
  centerLabel: string;
  centerSubLabel?: string;
}

export function CircularProgress({
  value,
  size = 200,
  strokeWidth = 12,
  color = '#10b981',      // emerald-500
  bgColor = '#27272a',    // zinc-800
  centerLabel,
  centerSubLabel
}: CircularProgressProps) {
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (value / 100) * circumference;

  return (
    <div className="relative inline-flex items-center justify-center">
      <svg width={size} height={size} className="-rotate-90">
        {/* Background circle */}
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke={bgColor}
          strokeWidth={strokeWidth}
        />

        {/* Progress circle */}
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke={color}
          strokeWidth={strokeWidth}
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          strokeLinecap="round"
          className="transition-all duration-500 ease-out"
        />
      </svg>

      {/* Center content */}
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <p className="text-5xl font-bold text-primary">
          {value}%
        </p>
        {centerSubLabel && (
          <p className="text-sm text-secondary mt-1">
            {centerSubLabel}
          </p>
        )}
      </div>
    </div>
  );
}
```

### 2.3. Exemplo de Uso

```tsx
<CircularProgress
  value={68}
  size={220}
  strokeWidth={16}
  color="#10b981"
  centerLabel="68%"
  centerSubLabel="450/660 ha"
/>
```

---

## 3. Waterfall Chart

**Usado em:** Dashboard 01 (Profitability Waterfall)
**Complexidade:** Alta
**Biblioteca:** Recharts (customizado)

### 3.1. Anatomia

```
Receita Bruta ████████████ 8.5M
              ↓
Custos Variáveis ▓▓▓▓▓▓ -3.2M
              ↓
Custos Fixos    ▓▓▓ -1.8M
              ↓
Margem Líquida  ████ 3.5M
```

### 3.2. Código Base (Simplificado)

```tsx
// components/charts/WaterfallChart.tsx
import { BarChart, Bar, XAxis, YAxis, Cell, ResponsiveContainer } from 'recharts';

interface WaterfallData {
  name: string;
  value: number;
  type: 'positive' | 'negative' | 'total';
}

interface WaterfallChartProps {
  data: WaterfallData[];
}

export function WaterfallChart({ data }: WaterfallChartProps) {
  // Transform data to show stacked effect
  const transformedData = data.map((item, index) => {
    let start = 0;
    for (let i = 0; i < index; i++) {
      start += data[i].value;
    }
    return {
      ...item,
      start,
      end: start + item.value,
      displayValue: Math.abs(item.value)
    };
  });

  const colorMap = {
    positive: '#10b981',  // emerald-500
    negative: '#ef4444',  // red-500
    total: '#3b82f6'      // blue-500
  };

  return (
    <ResponsiveContainer width="100%" height={400}>
      <BarChart data={transformedData}>
        <XAxis
          dataKey="name"
          stroke="#52525b"
          tick={{ fill: '#a1a1aa', fontSize: 12 }}
        />
        <YAxis
          stroke="#52525b"
          tick={{ fill: '#a1a1aa', fontSize: 12 }}
          tickFormatter={(value) => `${(value / 1000000).toFixed(1)}M`}
        />

        {/* Invisible bar for positioning */}
        <Bar dataKey="start" stackId="stack" fill="transparent" />

        {/* Visible bar */}
        <Bar dataKey="displayValue" stackId="stack">
          {transformedData.map((entry, index) => (
            <Cell key={`cell-${index}`} fill={colorMap[entry.type]} />
          ))}
        </Bar>
      </BarChart>
    </ResponsiveContainer>
  );
}
```

### 3.3. Exemplo de Uso

```tsx
const waterfallData = [
  { name: 'Receita Bruta', value: 8500000, type: 'positive' },
  { name: 'Custos Variáveis', value: -3200000, type: 'negative' },
  { name: 'Custos Fixos', value: -1800000, type: 'negative' },
  { name: 'Margem Líquida', value: 3500000, type: 'total' }
];

<WaterfallChart data={waterfallData} />
```

---

## 4. Heatmap Calendar

**Usado em:** Dashboard 02 (Payment Calendar)
**Complexidade:** Muito Alta
**Biblioteca:** Custom SVG ou react-calendar-heatmap

### 4.1. Anatomia

```
Cliente   Jan  Fev  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
Coop1    [██] [░░] [██] [██] [░░] [██] [██] [░░] [██] [██] [░░] [██]
Coop2    [░░] [██] [░░] [██] [██] [░░] [██] [██] [░░] [██] [██] [░░]
...

Legend: ██ Paid   ░░ Pending   ▓▓ Overdue
```

### 4.2. Estrutura de Dados

```typescript
interface HeatmapData {
  client: string;
  months: Array<{
    month: number;        // 1-12
    value: number;        // amount
    status: 'paid' | 'pending' | 'overdue';
    dueDate: string;
  }>;
}
```

### 4.3. Código Base (Simplificado)

```tsx
// components/charts/HeatmapCalendar.tsx
interface HeatmapCalendarProps {
  data: HeatmapData[];
}

export function HeatmapCalendar({ data }: HeatmapCalendarProps) {
  const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                  'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

  const statusColors = {
    paid: 'bg-emerald-500',
    pending: 'bg-amber-500',
    overdue: 'bg-red-500'
  };

  return (
    <div className="overflow-x-auto">
      <table className="w-full border-collapse">
        <thead>
          <tr>
            <th className="text-left p-2 text-xs text-muted">Cliente</th>
            {months.map(month => (
              <th key={month} className="p-2 text-xs text-muted text-center">
                {month}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.map((row, rowIndex) => (
            <tr key={rowIndex} className="border-t border-zinc-800">
              <td className="p-2 text-sm text-primary font-medium">
                {row.client}
              </td>
              {row.months.map((cell, cellIndex) => (
                <td key={cellIndex} className="p-2">
                  <div
                    className={cn(
                      "w-10 h-10 rounded",
                      statusColors[cell.status],
                      "hover:ring-2 hover:ring-white cursor-pointer transition-all"
                    )}
                    title={`${cell.status} - R$ ${(cell.value / 1000).toFixed(0)}k`}
                  />
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

---

## 5. 2D Silo Visual

**Usado em:** Dashboard 05 (Grain Inventory)
**Complexidade:** Alta
**Biblioteca:** SVG customizado

### 5.1. Anatomia

```
    ╱‾‾‾‾‾╲
   ╱       ╲
  │  SOJA   │ ← Label
  │  1,280t │ ← Quantity
  │▓▓▓▓▓▓▓▓▓│ ← Fill level (animated)
  │▓▓▓▓▓▓▓▓▓│
  │░░░░░░░░░│ ← Empty space
  └─────────┘
  68% Cheio  ← Percentage
```

### 5.2. Código Base

```tsx
// components/charts/SiloVisual.tsx
interface SiloVisualProps {
  label: string;
  currentQuantity: number;
  maxCapacity: number;
  unit?: string;
  color?: string;
  width?: number;
  height?: number;
}

export function SiloVisual({
  label,
  currentQuantity,
  maxCapacity,
  unit = 't',
  color = '#eab308',    // yellow-500 for soy
  width = 120,
  height = 180
}: SiloVisualProps) {
  const fillPercentage = (currentQuantity / maxCapacity) * 100;
  const fillHeight = (height - 40) * (fillPercentage / 100); // 40px for roof

  return (
    <div className="flex flex-col items-center gap-2">
      {/* Silo SVG */}
      <svg width={width} height={height} className="relative">
        {/* Silo roof (trapezoid) */}
        <path
          d={`M ${width * 0.2} 0 L ${width * 0.8} 0 L ${width} 40 L 0 40 Z`}
          fill="#27272a"
          stroke="#52525b"
          strokeWidth="2"
        />

        {/* Silo body */}
        <rect
          x="0"
          y="40"
          width={width}
          height={height - 40}
          fill="#18181b"
          stroke="#52525b"
          strokeWidth="2"
        />

        {/* Fill (from bottom up) */}
        <rect
          x="4"
          y={height - fillHeight - 4}
          width={width - 8}
          height={fillHeight}
          fill={color}
          opacity="0.8"
          className="transition-all duration-1000 ease-out"
        />

        {/* Wave effect on top of fill (optional) */}
        <path
          d={`M 4 ${height - fillHeight - 4} Q ${width/4} ${height - fillHeight - 8} ${width/2} ${height - fillHeight - 4} T ${width - 4} ${height - fillHeight - 4}`}
          fill={color}
          opacity="0.9"
        />

        {/* Labels inside silo */}
        <text
          x={width / 2}
          y={height / 2 - 10}
          textAnchor="middle"
          className="text-xs font-bold fill-white"
        >
          {label}
        </text>
        <text
          x={width / 2}
          y={height / 2 + 10}
          textAnchor="middle"
          className="text-lg font-bold fill-white"
        >
          {currentQuantity.toLocaleString()}{unit}
        </text>
      </svg>

      {/* Percentage below */}
      <p className="text-sm font-medium text-secondary">
        {fillPercentage.toFixed(0)}% Cheio
      </p>
    </div>
  );
}
```

### 5.3. Exemplo de Uso

```tsx
<div className="flex gap-6">
  <SiloVisual
    label="SOJA"
    currentQuantity={1280}
    maxCapacity={2000}
    color="#eab308"
  />
  <SiloVisual
    label="MILHO"
    currentQuantity={850}
    maxCapacity={1500}
    color="#f97316"
  />
</div>
```

---

## 6. TreeMap Interactive

**Usado em:** Dashboard 07 (Cost Accounting)
**Complexidade:** Muito Alta
**Biblioteca:** Recharts Treemap

### 6.1. Anatomia

```
┌─────────────────────────────────────┐
│  Defensivos (35%)                   │
│  R$ 1,2M                       ███  │
│                                     │
├──────────────┬──────────────────────┤
│ Fertilizantes│  Diesel (15%)        │
│ (25%)        │  R$ 520k        ██   │
│ R$ 850k  ██  │                      │
└──────────────┴──────────────────────┘
```

### 6.2. Estrutura de Dados

```typescript
interface TreeMapNode {
  name: string;
  value: number;
  percentage: number;
  children?: TreeMapNode[];
  color?: string;
}
```

### 6.3. Código Base

```tsx
// components/charts/TreeMapInteractive.tsx
import { Treemap, ResponsiveContainer } from 'recharts';

interface TreeMapProps {
  data: TreeMapNode[];
  onNodeClick?: (node: TreeMapNode) => void;
}

export function TreeMapInteractive({ data, onNodeClick }: TreeMapProps) {
  // Color scale for different categories
  const categoryColors = {
    'Defensivos': '#ef4444',
    'Fertilizantes': '#f59e0b',
    'Diesel': '#eab308',
    'Sementes': '#10b981',
    'Manutenção': '#3b82f6',
    'Mão de Obra': '#8b5cf6',
    'Outros': '#6b7280'
  };

  const CustomContent = (props: any) => {
    const { x, y, width, height, name, value, percentage } = props;

    return (
      <g>
        <rect
          x={x}
          y={y}
          width={width}
          height={height}
          fill={categoryColors[name] || '#27272a'}
          stroke="#09090b"
          strokeWidth={2}
          className="cursor-pointer hover:opacity-80 transition-opacity"
          onClick={() => onNodeClick?.(props)}
        />

        {width > 80 && height > 60 && (
          <>
            <text
              x={x + width / 2}
              y={y + height / 2 - 10}
              textAnchor="middle"
              fill="white"
              className="text-sm font-semibold pointer-events-none"
            >
              {name}
            </text>
            <text
              x={x + width / 2}
              y={y + height / 2 + 10}
              textAnchor="middle"
              fill="white"
              className="text-xs pointer-events-none"
            >
              R$ {(value / 1000000).toFixed(1)}M ({percentage}%)
            </text>
          </>
        )}
      </g>
    );
  };

  return (
    <ResponsiveContainer width="100%" height={500}>
      <Treemap
        data={data}
        dataKey="value"
        aspectRatio={4 / 3}
        stroke="#09090b"
        fill="#27272a"
        content={<CustomContent />}
      />
    </ResponsiveContainer>
  );
}
```

---

## 7. Kanban Board

**Usado em:** Dashboard 08 (Purchasing Programming)
**Complexidade:** Muito Alta
**Biblioteca:** @dnd-kit/core (drag and drop)

### 7.1. Anatomia

```
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│ SOLICITADO  │ COTANDO     │ APROVANDO   │ EMITIDO     │ RECEBIDO    │
│ (12)        │ (5)         │ (3)         │ (8)         │ (2)         │
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┤
│ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │
│ │ CARD    │ │ │ CARD    │ │ │ CARD    │ │ │ CARD    │ │ │ CARD    │ │
│ └─────────┘ │ └─────────┘ │ └─────────┘ │ └─────────┘ │ └─────────┘ │
│ ┌─────────┐ │             │             │             │             │
│ │ CARD    │ │             │             │             │             │
│ └─────────┘ │             │             │             │             │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

### 7.2. Estrutura de Dados

```typescript
interface KanbanCard {
  id: string;
  title: string;
  quantity: string;
  unitPrice: number;
  totalValue: number;
  priority: 'urgent' | 'high' | 'normal' | 'low';
  requestDate: string;
  requester: string;
}

interface KanbanColumn {
  id: string;
  title: string;
  cards: KanbanCard[];
}
```

### 7.3. Código Base (Sem Drag-Drop primeiro)

```tsx
// components/dashboard/KanbanBoard.tsx
import { Badge } from '@/components/ui/badge';

interface KanbanBoardProps {
  columns: KanbanColumn[];
  onCardClick?: (card: KanbanCard) => void;
}

export function KanbanBoard({ columns, onCardClick }: KanbanBoardProps) {
  const priorityColors = {
    urgent: 'bg-red-500',
    high: 'bg-orange-500',
    normal: 'bg-blue-500',
    low: 'bg-gray-500'
  };

  return (
    <div className="grid grid-cols-5 gap-4 h-[600px]">
      {columns.map((column) => (
        <div
          key={column.id}
          className="flex flex-col bg-surface rounded-lg border border-zinc-800"
        >
          {/* Column Header */}
          <div className="p-4 border-b border-zinc-800">
            <h3 className="text-sm font-semibold text-primary">
              {column.title}
            </h3>
            <p className="text-xs text-muted mt-1">
              {column.cards.length} itens
            </p>
          </div>

          {/* Cards */}
          <div className="flex-1 overflow-y-auto p-2 space-y-2">
            {column.cards.map((card) => (
              <div
                key={card.id}
                className="bg-canvas rounded border border-zinc-800 p-3 cursor-pointer hover:border-zinc-600 transition-colors"
                onClick={() => onCardClick?.(card)}
              >
                {/* Priority badge */}
                <div className="flex items-center justify-between mb-2">
                  <Badge
                    variant="outline"
                    className={cn(
                      "text-xs",
                      priorityColors[card.priority]
                    )}
                  >
                    {card.priority}
                  </Badge>
                  <p className="text-xs text-muted">
                    {new Date(card.requestDate).toLocaleDateString('pt-BR')}
                  </p>
                </div>

                {/* Card content */}
                <h4 className="text-sm font-medium text-primary mb-1">
                  {card.title}
                </h4>
                <p className="text-xs text-secondary mb-2">
                  {card.quantity}
                </p>

                {/* Value */}
                <p className="text-lg font-bold text-primary">
                  R$ {(card.totalValue / 1000).toFixed(1)}k
                </p>

                {/* Requester */}
                <p className="text-xs text-muted mt-2">
                  Solicitante: {card.requester}
                </p>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
```

---

## 8. Scatter Plot com Quadrantes

**Usado em:** Dashboard 04 (Machinery Efficiency)
**Complexidade:** Alta
**Biblioteca:** Recharts

### 8.1. Anatomia

```
Alta Performance     │  Atenção
                    │
    • JD-01          │      • CS-03
    • JD-02          │
────────────────────┼────────────────────
                    │
    • NH-05          │      • JD-04
                    │      • CS-02
  Eficiente        │  Crítico
```

### 8.2. Código Base

```tsx
// components/charts/ScatterPlotQuadrants.tsx
import { ScatterChart, Scatter, XAxis, YAxis, ZAxis, CartesianGrid, ResponsiveContainer, ReferenceLine, Tooltip } from 'recharts';

interface ScatterPoint {
  id: string;
  name: string;
  x: number;        // fuel efficiency
  y: number;        // load factor
  z: number;        // hours worked (for size)
  color: string;
}

interface ScatterPlotQuadrantsProps {
  data: ScatterPoint[];
  xAxisLabel: string;
  yAxisLabel: string;
}

export function ScatterPlotQuadrants({
  data,
  xAxisLabel,
  yAxisLabel
}: ScatterPlotQuadrantsProps) {
  // Calculate medians for quadrant lines
  const xMedian = data.reduce((sum, p) => sum + p.x, 0) / data.length;
  const yMedian = data.reduce((sum, p) => sum + p.y, 0) / data.length;

  const CustomTooltip = ({ active, payload }: any) => {
    if (active && payload?.[0]) {
      const point = payload[0].payload;
      return (
        <div className="bg-surface border border-zinc-700 rounded p-3">
          <p className="text-sm font-semibold text-primary">{point.name}</p>
          <p className="text-xs text-secondary mt-1">
            {xAxisLabel}: {point.x.toFixed(1)}
          </p>
          <p className="text-xs text-secondary">
            {yAxisLabel}: {point.y.toFixed(1)}%
          </p>
          <p className="text-xs text-muted mt-1">
            {point.z}h trabalhadas
          </p>
        </div>
      );
    }
    return null;
  };

  return (
    <ResponsiveContainer width="100%" height={500}>
      <ScatterChart margin={{ top: 20, right: 20, bottom: 20, left: 20 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#27272a" />

        <XAxis
          type="number"
          dataKey="x"
          name={xAxisLabel}
          stroke="#52525b"
          tick={{ fill: '#a1a1aa', fontSize: 12 }}
          label={{ value: xAxisLabel, position: 'insideBottom', offset: -10, fill: '#a1a1aa' }}
        />

        <YAxis
          type="number"
          dataKey="y"
          name={yAxisLabel}
          stroke="#52525b"
          tick={{ fill: '#a1a1aa', fontSize: 12 }}
          label={{ value: yAxisLabel, angle: -90, position: 'insideLeft', fill: '#a1a1aa' }}
        />

        <ZAxis type="number" dataKey="z" range={[100, 400]} />

        {/* Quadrant lines */}
        <ReferenceLine
          x={xMedian}
          stroke="#52525b"
          strokeDasharray="5 5"
          strokeWidth={2}
        />
        <ReferenceLine
          y={yMedian}
          stroke="#52525b"
          strokeDasharray="5 5"
          strokeWidth={2}
        />

        <Tooltip content={<CustomTooltip />} />

        <Scatter
          data={data}
          fill="#10b981"
        >
          {data.map((entry, index) => (
            <circle
              key={`circle-${index}`}
              r={8}
              fill={entry.color}
              stroke="#09090b"
              strokeWidth={2}
            />
          ))}
        </Scatter>
      </ScatterChart>
    </ResponsiveContainer>
  );
}
```

---

## 9. Utilitários Globais

### 9.1. Formatação de Valores

```tsx
// lib/formatters.ts

export const formatCurrency = (value: number): string => {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value);
};

export const formatCurrencyCompact = (value: number): string => {
  if (value >= 1000000) {
    return `R$ ${(value / 1000000).toFixed(1)}M`;
  } else if (value >= 1000) {
    return `R$ ${(value / 1000).toFixed(0)}k`;
  }
  return formatCurrency(value);
};

export const formatPercentage = (value: number, decimals: number = 1): string => {
  return `${value.toFixed(decimals)}%`;
};

export const formatDate = (date: string | Date): string => {
  return new Intl.DateTimeFormat('pt-BR', {
    day: '2-digit',
    month: 'short',
    year: 'numeric'
  }).format(new Date(date));
};

export const formatQuantity = (value: number, unit: string): string => {
  return `${value.toLocaleString('pt-BR')} ${unit}`;
};
```

### 9.2. Tailwind Config Customizado

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        canvas: '#09090b',
        surface: '#18181b',
        'surface-highlight': '#27272a',
        primary: '#f4f4f5',
        secondary: '#a1a1aa',
        muted: '#52525b',
        'brand-primary': '#10b981',
        'brand-danger': '#ef4444',
        'brand-warning': '#f59e0b',
        'brand-info': '#3b82f6',
        'agro-soy': '#eab308',
        'agro-corn': '#f97316'
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif']
      }
    }
  }
}
```

---

## 10. Performance e Otimização

### 10.1. Virtualization para Listas Longas

Para tabelas com 100+ linhas (Dashboard 02, 06), use `@tanstack/react-virtual`:

```tsx
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualizedTable({ data }: { data: any[] }) {
  const parentRef = React.useRef<HTMLDivElement>(null);

  const virtualizer = useVirtualizer({
    count: data.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 60, // row height
    overscan: 5
  });

  return (
    <div ref={parentRef} className="h-[600px] overflow-auto">
      <div style={{ height: `${virtualizer.getTotalSize()}px` }}>
        {virtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.index}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualRow.size}px`,
              transform: `translateY(${virtualRow.start}px)`
            }}
          >
            {/* Row content */}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### 10.2. Memoization para Charts

```tsx
import { memo } from 'react';

export const WaterfallChart = memo(({ data }: WaterfallChartProps) => {
  // ... chart implementation
}, (prevProps, nextProps) => {
  // Custom comparison: only re-render if data actually changed
  return JSON.stringify(prevProps.data) === JSON.stringify(nextProps.data);
});
```

---

## 11. Testing Checklist

Para cada componente implementado, valide:

- [ ] Renderiza corretamente em 1920×1080
- [ ] Responsivo em telas menores (1366×768)
- [ ] Cores seguem o design system
- [ ] Hover states funcionam
- [ ] Tooltips mostram informações corretas
- [ ] Performance: < 16ms de render time
- [ ] Acessibilidade: ARIA labels presentes
- [ ] Dark mode exclusivo (não suporta light mode)

---

**Próximo passo:** Começar pela implementação dos componentes básicos (KPICard, StatusBadge) antes dos complexos (TreeMap, Kanban).
