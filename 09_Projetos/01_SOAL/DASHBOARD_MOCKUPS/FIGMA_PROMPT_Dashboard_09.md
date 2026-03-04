# Figma Design Prompt: Dashboard #9 - Gestão de Manutenção (Maintenance Hub)

## 🎯 Design Brief
Create a workshop-oriented maintenance management dashboard to keep the fleet running and control parts costs. Target user: Tiago (Operations). The aesthetic must have a "garage feel but organized" - think mechanic's workshop meets digital triage board, with high contrast for reading in workshop conditions (bright lights, dirty hands, tablets).

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Maintenance_Hub_Dashboard`
- **Dimensions:** 1920px × 1080px (Desktop HD)
- **Background Color:** `#09090b` (Zinc-950)
- **Padding:** 24px all sides

---

## 🎨 Design System Tokens

### Color Palette

**Backgrounds:**
- `bg-canvas`: `#09090b`
- `bg-surface`: `#18181b`
- `bg-surface-highlight`: `#27272a`

**Typography:**
- `text-primary`: `#f4f4f5` (Zinc-100)
- `text-secondary`: `#a1a1aa` (Zinc-400)
- `text-muted`: `#52525b` (Zinc-600)

**Semantic Colors:**
- `brand-primary`: `#10b981` (Emerald-500) - Operating, Completed
- `brand-danger`: `#ef4444` (Red-500) - Critical, Stopped
- `brand-warning`: `#f59e0b` (Amber-500) - In Maintenance, Attention
- `brand-info`: `#3b82f6` (Blue-500) - Scheduled, Information

**Workshop Colors:**
- `workshop-critical`: `#ef4444` (Red-500) - Machine stopped
- `workshop-active`: `#f59e0b` (Amber-500) - In maintenance
- `workshop-operating`: `#10b981` (Emerald-500) - Running
- `workshop-scheduled`: `#3b82f6` (Blue-500) - Preventive scheduled

**Cost Colors:**
- `cost-labor`: `#06b6d4` (Cyan-500) - Labor/service
- `cost-parts`: `#f97316` (Orange-500) - Parts/materials

### Typography Styles

**Font Family:** Inter

- `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
- `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
- `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
- `Body/Number/XXL`: Inter Bold, 56px, Line Height 64px, #f4f4f5 (for big indicators)
- `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
- `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
- `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
- `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
- `Body/Text/M`: Inter Regular, 14px, Line Height 20px, #f4f4f5
- `Body/Text/L`: Inter Regular, 16px, Line Height 24px, #f4f4f5 (for problem descriptions)
- `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
- `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b
- `Mono/M`: Inter Mono, 14px, Line Height 20px (for machine IDs, OS numbers)

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

**Workshop Card (Variant):**
- Fill: `#18181b`
- Border: 1px solid `#27272a`
- Border Left: 4px solid status color (accent)
- Corner Radius: 8px
- Shadow: 0 2px 8px rgba(0,0,0,0.3) (stronger shadow for workshop visibility)

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Gestão de Manutenção"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Workshop & Fleet Maintenance Control"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Controls
**Layout:** Horizontal, Gap 12px

**Element 1: Time Filter**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Esta Semana"
- Style: Body/Number/S
- Icon: Calendar (16px)

**Element 2: Machine Filter**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Todas Máquinas"
- Style: Body/Number/S
- Icon: Filter (16px)

**Element 3: New Service Order**
- Background: brand-warning
- Padding: 10px 20px
- Text: "Nova OS"
- Style: Body/Number/S, white, Bold
- Icon: Wrench (16px)

---

### 2. BIG STATUS INDICATORS (Hero Metrics)
**Position:** Below Header, 32px margin top
**Layout:** 3 Cards, Equal Width, Gap 24px
**Card Height:** 180px

**Design:** Large, bold numbers for at-a-glance status

---

#### CARD 1: Machines Stopped (CRITICAL)

**Base:** Workshop Card
**Border Left:** 4px solid workshop-critical
**Background:** workshop-critical at 5% opacity (alert glow)

**Icon:**
- Size: 48×48px circle
- Background: workshop-critical at 20% opacity
- Icon: Alert Octagon (28px, workshop-critical)
- Position: Top left

**Content:**
- **Value:** "2"
  - Style: Body/Number/XXL, workshop-critical, Bold
  - Position: Center-prominent

- **Label:** "Máquinas Paradas"
  - Style: Heading/L, text-primary
  - Position: Below value

- **Subtext:** "Perda: R$ 12.400/dia"
  - Style: Body/Number/M, workshop-critical
  - Icon: TrendingDown (16px)
  - Margin Top: 8px

**Alert Badge:**
- Position: Top right
- Size: 28×28px circle
- Fill: workshop-critical
- Icon: Exclamation mark (white, bold)
- Pulse animation (optional)

---

#### CARD 2: In Maintenance

**Base:** Workshop Card
**Border Left:** 4px solid workshop-active

**Icon:**
- Background: workshop-active at 20% opacity
- Icon: Wrench/Tool (28px, workshop-active)

**Content:**
- **Value:** "5"
  - Style: Body/Number/XXL, workshop-active, Bold

- **Label:** "Em Manutenção"
  - Style: Heading/L, text-primary

- **Subtext:** "Tempo médio: 3,2 dias"
  - Style: Body/Number/M, text-secondary
  - Icon: Clock (16px)

---

#### CARD 3: Operating

**Base:** Workshop Card
**Border Left:** 4px solid workshop-operating

**Icon:**
- Background: workshop-operating at 20% opacity
- Icon: CheckCircle (28px, workshop-operating)

**Content:**
- **Value:** "9"
  - Style: Body/Number/XXL, workshop-operating, Bold

- **Label:** "Operando"
  - Style: Heading/L, text-primary

- **Subtext:** "75% da frota"
  - Style: Body/Number/M, workshop-operating
  - Icon: Activity (16px)

---

### 3. MAIN CONTENT GRID
**Position:** Below Status Indicators, 24px margin top
**Layout:** 2 Columns - 60% Left | 40% Right
**Gap:** 24px

---

### 3.1 LEFT COLUMN: Service Orders Triage Board

**Card: Active Service Orders**
**Layout:** Workshop Card, 24px padding
**Height:** 600px

**Header:**
- Text: "Ordens de Serviço Ativas"
- Style: Heading/L
- Margin Bottom: 20px

**Filter Tabs:**
- Layout: Horizontal, gap 8px
- Margin Bottom: 16px

**Tab Options:**
1. **Crítico (2)** - Red background at 15%
2. **Em Andamento (3)** - Amber (active)
3. **Aguardando Peças (2)** - Blue
4. **Todas (7)**

---

**Service Order Card Template:**

**Card Base:**
- Background: bg-surface
- Border: 1px solid zinc-800
- Border Left: 4px solid priority color
- Padding: 20px
- Radius: 8px
- Margin Bottom: 16px
- Shadow: 0 2px 6px rgba(0,0,0,0.2)

**Header Row:**
- Layout: Horizontal, Space Between

**Left:**
- **OS Number:** "OS #2026-0847"
  - Style: Mono/M, text-secondary
  - Background: bg-surface-highlight
  - Padding: 4px 10px
  - Radius: 4px

**Right:**
- **Priority Badge:**
  - Text: "CRÍTICO" or "NORMAL"
  - Background: priority color at 20%
  - Border: 1px solid priority color
  - Style: Label/S, priority color, Bold
  - Padding: 4px 12px
  - Radius: 12px

---

**Machine Info:**
- Layout: Horizontal, gap 12px
- Margin: 12px 0

**Machine Icon:**
- Size: 40×40px circle
- Background: workshop-active at 15%
- Icon: Tractor (20px, workshop-active)

**Machine Details:**
- **ID:** "John Deere 8R-04"
  - Style: Body/Number/M, text-primary, Semibold
- **Location:** "Oficina Mecânica - Box 2"
  - Style: Label/M, text-secondary
  - Icon: MapPin (12px)

---

**Problem Description:**
- Background: bg-surface-highlight
- Padding: 12px
- Radius: 6px
- Margin: 12px 0

**Title:** "Problema Relatado:"
- Style: Label/M, text-secondary
- Margin Bottom: 4px

**Description:** "Motor apresentando superaquecimento durante operação. Temperatura excedendo 105°C. Possível falha no sistema de arrefecimento."
- Style: Body/Text/M, text-primary
- Line Height: 24px (readable)

---

**Assignment & Time:**
- Layout: Horizontal, Space Between
- Padding: 12px 0
- Border Top: 1px solid zinc-800
- Border Bottom: 1px solid zinc-800
- Margin: 12px 0

**Mechanic:**
- Icon: User (16px, text-muted)
- Text: "Mecânico: Carlos Silva"
- Style: Body/Text/M, text-secondary

**Time Elapsed:**
- Icon: Clock (16px, workshop-warning)
- Text: "Em andamento há 2d 4h"
- Style: Body/Number/M, workshop-warning, Semibold

---

**Cost Breakdown:**
- Layout: 2 columns grid
- Gap: 12px

**Labor:**
- Label: "Mão de Obra"
- Value: "R$ 1.200"
- Style: Body/Number/S, cost-labor
- Icon: Users (14px)

**Parts:**
- Label: "Peças"
- Value: "R$ 3.850"
- Style: Body/Number/S, cost-parts
- Icon: Package (14px)

**Total:**
- Layout: Horizontal, Space Between
- Background: bg-canvas at 50%
- Padding: 8px 12px
- Radius: 4px
- Margin Top: 8px

**Label:** "Total Estimado:"
- Style: Label/M, text-secondary

**Value:** "R$ 5.050"
- Style: Body/Number/M, text-primary, Bold

---

**Action Buttons:**
- Layout: Horizontal, gap 8px
- Margin Top: 12px

**Update Status:**
- Background: transparent
- Border: 1px solid brand-info
- Text: "Atualizar"
- Style: Body/Text/M, brand-info
- Padding: 8px 16px
- Icon: Edit (14px)

**Complete:**
- Background: brand-primary
- Text: "Concluir OS"
- Style: Body/Text/M, white, Semibold
- Padding: 8px 20px
- Icon: CheckCircle (14px)

---

**Sample Service Order Cards:**

**OS #1: CRITICAL (Red border)**
- OS: #2026-0847
- Priority: CRÍTICO
- Machine: John Deere 8R-04
- Location: Oficina - Box 2
- Problem: "Motor superaquecimento 105°C. Falha sistema arrefecimento."
- Mechanic: Carlos Silva
- Time: 2d 4h
- Labor: R$ 1.200
- Parts: R$ 3.850
- Total: R$ 5.050

**OS #2: IN PROGRESS (Amber border)**
- OS: #2026-0852
- Priority: NORMAL
- Machine: Case IH 340
- Problem: "Substituição preventiva de filtros e óleo hidráulico."
- Mechanic: João Santos
- Time: 6h
- Labor: R$ 450
- Parts: R$ 820
- Total: R$ 1.270

**OS #3: WAITING PARTS (Blue border)**
- OS: #2026-0845
- Priority: NORMAL
- Machine: New Holland T7-02
- Problem: "Aguardando peça #RE504836 (Filtro de óleo)"
- Mechanic: N/A
- Time: 5d (waiting)
- Status: "Peça em trânsito, chegada prevista 02/02"

---

### 3.2 RIGHT COLUMN: Cost Analysis & Schedule

**Card 1: Cost Split (Donut Chart)**
**Layout:** Workshop Card, 24px padding
**Height:** 320px

**Header:**
- Text: "Distribuição de Custos (Mês)"
- Style: Heading/L
- Margin Bottom: 20px

**Donut Chart:**

**Dimensions:**
- Diameter: 200px
- Stroke Width: 40px
- Center Hole: 120px diameter

**Segments:**

1. **Labor (Mão de Obra):**
   - Value: 42%
   - Color: cost-labor (cyan)
   - Amount: R$ 18.400

2. **Parts (Peças):**
   - Value: 58%
   - Color: cost-parts (orange)
   - Amount: R$ 25.600

**Center Content:**
- **Total:** "R$ 44K"
  - Style: Body/Number/XL, text-primary, Bold
- **Label:** "Total Mês"
  - Style: Label/M, text-secondary

---

**Legend:**
- Position: Below chart
- Layout: Vertical stack, gap 12px

**Item 1: Labor**
- Layout: Horizontal, Space Between
- **Left:**
  - Square: 16×16px, cost-labor, radius 4px
  - Text: "Mão de Obra"
  - Style: Body/Text/M, text-primary
- **Right:**
  - Value: "R$ 18.400"
  - Percentage: "42%"
  - Style: Body/Number/M, cost-labor, Semibold

**Item 2: Parts**
- Same layout
- Color: cost-parts (orange)
- Value: "R$ 25.600"
- Percentage: "58%"

---

**Alert Box:**
- Margin Top: 16px
- Background: brand-danger at 10% opacity
- Border: 1px solid brand-danger at 30%
- Padding: 12px
- Radius: 6px

**Content:**
- Icon: AlertTriangle (16px, brand-danger)
- Text: "Custo de peças aumentou 23% vs mês anterior"
- Style: Label/M, text-primary

---

**Card 2: Preventive Maintenance Schedule**
**Layout:** Workshop Card, 24px padding
**Height:** 256px
**Margin Top:** 24px

**Header:**
- Text: "Manutenções Preventivas Programadas"
- Style: Heading/L
- Margin Bottom: 16px

**Timeline View:**

**Timeline Container:**
- Background: bg-surface-highlight
- Padding: 16px
- Radius: 6px

---

**Schedule Item Template:**

**Item Layout:**
- Layout: Horizontal, gap 12px
- Padding: 12px
- Border Bottom: 1px solid zinc-800 at 30%

**Left: Date Badge**
- Width: 60px
- Background: workshop-scheduled at 15%
- Border: 1px solid workshop-scheduled at 40%
- Padding: 8px
- Radius: 6px
- Text Align: Center

**Day:** "05"
- Style: Body/Number/L, workshop-scheduled, Bold

**Month:** "FEV"
- Style: Label/S, text-secondary

---

**Right: Details**

**Machine:**
- Text: "John Deere 8R-04"
- Style: Body/Text/M, text-primary, Semibold

**Service:**
- Text: "Revisão 500h - Troca de filtros e fluidos"
- Style: Label/M, text-secondary
- Margin Top: 2px

**Trigger:**
- Icon: Gauge (12px, text-muted)
- Text: "Horas do motor: 487h / 500h"
- Style: Label/S, text-muted
- Margin Top: 4px

**Progress Bar:**
- Height: 4px
- Background: zinc-800
- Fill: workshop-scheduled
- Progress: 97.4% (487/500)
- Margin Top: 8px

---

**Sample Schedule Items:**

**Item 1: Due Soon (Feb 05)**
- Machine: John Deere 8R-04
- Service: Revisão 500h
- Hours: 487h / 500h (97.4%)
- Date: 05/FEV

**Item 2: Due Soon (Feb 08)**
- Machine: Case IH 340
- Service: Revisão 1000h
- Hours: 976h / 1000h (97.6%)

**Item 3: Scheduled (Feb 12)**
- Machine: Massey Ferguson 7415
- Service: Revisão anual completa
- Hours: 2.145h / 2.500h (85.8%)

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Big Numbers First:** Hero metrics show critical status immediately
2. **Triage Focus:** Active service orders prioritized
3. **Cost Awareness:** Donut chart shows spending split
4. **Preventive Planning:** Timeline shows upcoming maintenance

### Workshop Aesthetic
- **Garage Feel:** Industrial, rugged, practical
- **High Contrast:** Easy to read in bright workshop lights
- **Touch-Friendly:** Large buttons for tablet use with dirty hands
- **Status Colors:** Bold, distinct colors for quick scanning
- **Problem-Focused:** Issue descriptions prominent and readable

### Color Coding

**Machine Status:**
- 🔴 Red: Stopped (critical)
- 🟡 Amber: In maintenance
- 🟢 Green: Operating
- 🔵 Blue: Scheduled/waiting

**Cost Types:**
- 🔵 Cyan: Labor
- 🟠 Orange: Parts

### Spacing System
- Use multiples of 4px for all spacing
- Extra padding for touch targets (min 44px height)
- Card padding: 20-24px
- Section gaps: 24px
- High contrast borders for workshop visibility

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Maintenance_Hub_2x.png`
- Export service order card component
- Export donut chart component
- Export timeline schedule item
- Export big status indicator cards

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_09_Maintenance.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with filters and controls
- [ ] Build 3 big status indicator cards (XXL numbers)
- [ ] Design service order card with all sections
- [ ] Create 3+ service order samples (critical, normal, waiting)
- [ ] Build donut chart for cost split
- [ ] Add cost breakdown legend
- [ ] Create preventive schedule timeline
- [ ] Design 3 schedule items with progress bars
- [ ] Add filter tabs for service orders
- [ ] Verify high-contrast colors for workshop use
- [ ] Ensure touch-friendly button sizes (44px min)
- [ ] Check all spacing follows 4px grid
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 3-4 hours for experienced Figma designer
**Complexity:** High (Large status indicators, detailed service order cards, donut chart, timeline with progress bars)

---

## 💡 Implementation Notes

### Service Order Priority Logic
```
Priority = "CRÍTICO" IF:
  - Machine is completely stopped AND
  - Machine is critical to operations AND
  - Downtime > 24 hours

Priority = "ALTA" IF:
  - Preventive maintenance overdue OR
  - Safety issue detected OR
  - Multiple machines of same type affected

Priority = "NORMAL": Standard maintenance
```

### Cost Tracking
```
Labor Cost Calculation:
  labor_hours × mechanic_hourly_rate

Parts Cost:
  SUM(part_unit_cost × quantity) + shipping

Alert if:
  month_parts_cost > (avg_last_3_months × 1.2)
  "Parts cost increased >20%"
```

### Preventive Maintenance Triggers
```
Due when:
  - Engine hours reach threshold (e.g., every 500h)
  - Calendar date (annual inspections)
  - Operational hours (e.g., every 100h of operation)

Alert colors:
  - Red: Overdue
  - Amber: Due within 20 hours or 7 days
  - Blue: Scheduled (>20h or >7 days away)
  - Green: Recently completed
```

### Time Elapsed Display
```
IF elapsed_hours < 24:
  display = "Xh" (e.g., "6h")
ELSE IF elapsed_hours < 48:
  display = "1d Xh" (e.g., "1d 4h")
ELSE:
  display = "Xd Yh" (e.g., "2d 4h")

Color:
  - Green: < 24h
  - Amber: 24h - 72h
  - Red: > 72h (delayed)
```

### Downtime Cost Calculation
```
For critical machines:
  daily_cost = (daily_operation_value / total_machines)

Display on "Machines Stopped" card:
  "Perda: R$ X/dia"

Helps justify expedited repairs and premium parts
```

### Workshop Visibility Optimizations
- Minimum font size: 12px
- Minimum button height: 44px (touch-friendly)
- High contrast ratios (4.5:1 minimum)
- Bold fonts for critical information
- Color + icon redundancy (not color alone)
- Large touch targets for tablet use
