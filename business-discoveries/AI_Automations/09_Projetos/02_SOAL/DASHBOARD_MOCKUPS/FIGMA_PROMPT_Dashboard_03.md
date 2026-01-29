# Figma Design Prompt: Dashboard #3 - Contas a Pagar (Accounts Payable)

## 🎯 Design Brief
Create a cash flow management dashboard for agricultural business, focused on preventing payment delays and interest penalties. Target user: Valentina (Financial Admin). The design must emphasize urgency with strategic use of Warning (Amber) and Critical (Red) colors while maintaining the "Industrial Precision" aesthetic.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Accounts_Payable_Dashboard`
- **Dimensions:** 1920px × 1080px (Desktop HD)
- **Background Color:** `#09090b` (Zinc-950)
- **Padding:** 24px all sides

---

## 🎨 Design System Tokens

### Color Palette (Use Established Styles)

**Backgrounds:**
- `bg-canvas`: `#09090b`
- `bg-surface`: `#18181b`
- `bg-surface-highlight`: `#27272a`

**Typography:**
- `text-primary`: `#f4f4f5` (Zinc-100)
- `text-secondary`: `#a1a1aa` (Zinc-400)
- `text-muted`: `#52525b` (Zinc-600)

**Semantic Colors:**
- `brand-primary`: `#10b981` (Emerald-500) - Paid, Healthy Cash Flow
- `brand-danger`: `#ef4444` (Red-500) - Due Today, Critical
- `brand-warning`: `#f59e0b` (Amber-500) - Due This Week, Attention
- `brand-info`: `#3b82f6` (Blue-500) - Information, Future Payments

**Category Colors (Expenses):**
- `category-inputs`: `#8b5cf6` (Violet-500) - Insumos (Seeds, Chemicals)
- `category-maintenance`: `#f97316` (Orange-500) - Manutenção
- `category-fuel`: `#eab308` (Yellow-500) - Combustível/Diesel
- `category-payroll`: `#06b6d4` (Cyan-500) - Folha de Pagamento
- `category-other`: `#71717a` (Zinc-500) - Outros

### Typography Styles

**Font Family:** Inter

- `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
- `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
- `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
- `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
- `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
- `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
- `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
- `Body/Text/M`: Inter Regular, 14px, Line Height 20px, #f4f4f5
- `Body/Text/S`: Inter Regular, 12px, Line Height 18px, #f4f4f5
- `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
- `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Contas a Pagar"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Cash Flow Management Dashboard"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Action Controls
**Layout:** Horizontal, Gap 12px

**Element 1: Time Range Filter**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Próximos 30 dias"
- Style: Body/Number/S
- Icon: Calendar (16px, text-secondary)

**Element 2: Category Filter**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Todas Categorias"
- Style: Body/Number/S
- Icon: Filter (16px)

**Element 3: Add Payment Button**
- Background: brand-primary
- Padding: 10px 20px
- Text: "Nova Conta"
- Style: Body/Number/S, white
- Icon: Plus (16px, white)
- Hover: Brightness 110%

---

### 2. METRIC CARDS ROW
**Position:** Below Header, 32px margin top
**Layout:** 3 Columns, Equal Width, Gap 20px
**Card Height:** 160px

---

#### CARD 1: Total Vencendo Hoje (CRITICAL)

**Base:** Glassmorphism Card with 20px padding
**Border:** 1px solid brand-danger at 40% opacity (ALERT state)

**Header Row:**
- Layout: Horizontal, Space Between

**Left Side:**
- Icon Badge: 40×40px circle
  - Background: brand-danger at 20% opacity
  - Icon: Alert Circle (20px, brand-danger)

**Right Side:**
- Alert Indicator: Pulsing red dot
  - Size: 8×8px circle
  - Fill: brand-danger
  - Effect: Pulse animation (optional for static)

**Content:**
- **Label:** "Total Vencendo Hoje"
  - Style: Label/M
  - Color: text-secondary
  - Margin Bottom: 8px

- **Value:** "R$ 487.500,00"
  - Style: Body/Number/XL
  - Color: brand-danger
  - Margin Bottom: 4px

- **Subtext:** "8 contas pendentes"
  - Style: Label/S
  - Color: text-muted
  - Margin Bottom: 12px

- **Action Link:**
  - Text: "Autorizar Pagamentos →"
  - Style: Body/Text/S, brand-danger, Semibold
  - Underline on hover

---

#### CARD 2: Total na Semana

**Base:** Glassmorphism Card with 20px padding

**Icon Badge:**
- Background: brand-warning at 15% opacity
- Icon: Calendar Clock (20px, brand-warning)

**Content:**
- **Label:** "Total na Semana"
  - Style: Label/M
  - Color: text-secondary

- **Value:** "R$ 1.245.800,00"
  - Style: Body/Number/XL
  - Color: brand-warning

- **Subtext:** "23 contas programadas"
  - Style: Label/S
  - Color: text-muted

- **Progress Bar:**
  - Height: 4px
  - Background: zinc-800
  - Fill: brand-warning
  - Progress: 35% (represents portion due today/tomorrow)
  - Corner Radius: 2px
  - Margin Top: 12px

---

#### CARD 3: Fluxo de Caixa Projetado

**Base:** Glassmorphism Card with 20px padding

**Icon Badge:**
- Background: brand-info at 15% opacity
- Icon: Trending Down (20px, brand-info)

**Content:**
- **Label:** "Saldo Final Projetado (30d)"
  - Style: Label/M
  - Color: text-secondary

- **Value:** "R$ 2.3M"
  - Style: Body/Number/XL
  - Color: brand-primary (positive balance)

- **Comparison:**
  - Text: "+R$ 450K vs mês anterior"
  - Style: Label/S, brand-primary
  - Icon: Arrow Up (12px)

- **Mini Trend Line:**
  - Simple line graph showing 7-day balance projection
  - Height: 32px
  - Color: brand-primary at 40% opacity
  - Margin Top: 8px

---

### 3. MAIN CONTENT ROW (Split View)
**Position:** Below Metric Cards, 24px margin top
**Layout:** 2 Columns - 60% Left / 40% Right
**Gap:** 24px

---

### 3.1 LEFT COLUMN: Expense Breakdown & Cash Burn

**Card 1: Despesas por Categoria (Stacked Bar Chart)**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 400px

**Header:**
- Text: "Despesas por Categoria - Próximos 30 Dias"
- Style: Heading/L
- Margin Bottom: 20px

**Chart Area:**
- Height: 280px
- Layout: Vertical bars, 4 weeks
- Gap between bars: 16px
- Bar Width: ~140px each

**Week Labels (X-Axis):**
- Text: "Semana 1", "Semana 2", "Semana 3", "Semana 4"
- Style: Label/M, text-secondary
- Position: Below each bar

**Stacked Bar Data:**

**Week 1 (Current Week):**
- Total Height: 100% (highest expenses)
- Segments (bottom to top):
  1. Insumos: 45% - category-inputs
  2. Manutenção: 15% - category-maintenance
  3. Combustível: 20% - category-fuel
  4. Folha: 15% - category-payroll
  5. Outros: 5% - category-other
- Total Label Above: "R$ 1.24M" - Body/Number/S, text-primary

**Week 2:**
- Total Height: 60%
- Similar segment distribution
- Total: "R$ 680K"

**Week 3:**
- Total Height: 45%
- Total: "R$ 520K"

**Week 4:**
- Total Height: 70%
- Total: "R$ 820K"

**Legend:**
- Position: Below chart, centered
- Layout: Horizontal, wrap, gap 16px

**Legend Items:**
1. Color Square (12×12px, category-inputs, radius 2px) + "Insumos" (R$ 1.8M total)
2. Color Square (category-maintenance) + "Manutenção" (R$ 480K)
3. Color Square (category-fuel) + "Combustível" (R$ 620K)
4. Color Square (category-payroll) + "Folha de Pagamento" (R$ 450K)
5. Color Square (category-other) + "Outros" (R$ 180K)

---

**Card 2: Projeção de Saldo (Cash Burn Line)**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 320px
**Margin Top:** 24px

**Header:**
- Text: "Projeção de Saldo Bancário"
- Style: Heading/L
- Margin Bottom: 20px

**Subheader:**
- Text: "Saldo atual: R$ 3.2M | Se todos os pagamentos forem realizados"
- Style: Label/M, text-secondary

**Chart Area:**
- Height: 200px
- Type: Line chart with area fill

**Chart Elements:**

**Current Balance Line:**
- Horizontal dashed line at starting point
- Y-Value: R$ 3.2M
- Color: zinc-600
- Dash: 4px 4px
- Label: "Saldo Atual"

**Projected Balance Line:**
- Start: R$ 3.2M (today)
- Path: Descending line with steps (payments)
- End: R$ 2.3M (day 30)
- Color: brand-primary
- Stroke: 3px
- Area Fill: brand-primary at 15% opacity

**Critical Threshold Line:**
- Horizontal dashed line
- Y-Value: R$ 1.5M
- Color: brand-danger
- Dash: 4px 4px
- Label: "Limite de Segurança" - Label/S, brand-danger

**X-Axis:**
- Labels: "Hoje", "Sem 1", "Sem 2", "Sem 3", "Sem 4"
- Grid: Vertical lines, zinc-800 at 20% opacity

**Y-Axis:**
- Labels: R$ 0M, R$ 1M, R$ 2M, R$ 3M, R$ 4M
- Style: Label/S, text-muted
- Grid: Horizontal lines, zinc-800 at 20% opacity

**Payment Markers (on the line):**
- Dots at significant payment dates
- Size: 8×8px circles
- Fill: brand-warning
- Tooltip on hover (visual indicator only): "15/02 - R$ 487K"

---

### 3.2 RIGHT COLUMN: Payment List & Calendar

**Payment Queue List**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 744px (to match left column total height)

**Header:**
- Text: "Fila de Pagamentos"
- Style: Heading/L
- Margin Bottom: 16px

**Filter Tabs:**
- Layout: Horizontal, gap 8px
- Margin Bottom: 20px

**Tabs:**
1. "Hoje (8)" - Active
   - Background: brand-danger at 20% opacity
   - Text: Body/Text/M, brand-danger, Semibold
   - Padding: 8px 16px
   - Radius: 6px

2. "Esta Semana (15)"
   - Background: transparent
   - Text: Body/Text/M, text-secondary
   - Hover: bg-surface-highlight

3. "Próximo Mês (42)"
   - Same as tab 2

**Payment Cards List:**
- Scrollable area
- Gap between cards: 12px

---

**Payment Card Template:**

**Card Base:**
- Background: bg-surface
- Border: 1px solid zinc-800 at 40% opacity
- Padding: 16px
- Corner Radius: 8px
- Height: Auto

**Card States:**
1. **Due Today (Critical):**
   - Border: 1px solid brand-danger at 60% opacity
   - Left Border: 4px solid brand-danger (accent)

2. **Due This Week:**
   - Border: 1px solid brand-warning at 40% opacity
   - Left Border: 4px solid brand-warning

3. **Future:**
   - Border: standard
   - Left Border: 4px solid brand-info

---

**Sample Payment Card 1 (Due Today - CRITICAL):**

**Header Row:**
- Layout: Horizontal, Space Between

**Left:**
- **Vendor Name:** "Bayer CropScience"
  - Style: Body/Number/M, text-primary, Semibold
- **Category Tag:**
  - Text: "Insumos"
  - Background: category-inputs at 20% opacity
  - Text Color: category-inputs
  - Padding: 4px 8px
  - Radius: 4px
  - Style: Label/S

**Right:**
- **Amount:** "R$ 142.350,00"
  - Style: Body/Number/M, brand-danger (due today)
  - Bold

**Middle Row:**
- Layout: Horizontal, gap 16px
- Margin: 8px 0

**Info Items:**
1. Invoice: "#INV-2025-1847"
   - Icon: File Text (14px, text-muted)
   - Text: Label/M, text-secondary

2. Due Date: "Hoje - 29/01/26"
   - Icon: Calendar (14px, brand-danger)
   - Text: Label/M, brand-danger

3. Payment Method: "Transferência"
   - Icon: Bank (14px, text-muted)
   - Text: Label/M, text-secondary

**Bottom Row:**
- Layout: Horizontal, Space Between

**Left: Checkbox**
- Size: 20×20px
- Border: 1px solid zinc-600
- Checked: brand-danger background, white checkmark
- Label: "Selecionar" - Label/S, text-muted

**Right: Actions**
- Layout: Horizontal, gap 8px

**Button 1: View Details**
- Icon: Eye (16px)
- Background: transparent
- Hover: bg-surface-highlight
- Size: 32×32px

**Button 2: Approve Payment**
- Text: "Autorizar"
- Background: brand-danger at 20% opacity
- Text Color: brand-danger
- Padding: 6px 12px
- Style: Label/M, Semibold
- Hover: Opacity 100%, white text

---

**Sample Payment Card 2 (Due This Week):**
- Vendor: "John Deere Brasil"
- Category: "Manutenção" (category-maintenance)
- Amount: "R$ 68.400,00"
- Invoice: "#INV-2025-1892"
- Due: "03/02/26 - 5 dias"
- Colors: brand-warning instead of brand-danger

---

**Sample Payment Card 3 (Future):**
- Vendor: "Petrobras Distribuidora"
- Category: "Combustível" (category-fuel)
- Amount: "R$ 95.200,00"
- Invoice: "#INV-2025-1905"
- Due: "15/02/26 - 17 dias"
- Colors: brand-info

---

**List Footer (Sticky Bottom):**
- Background: bg-surface with blur
- Border Top: 1px solid zinc-700
- Padding: 16px
- Layout: Horizontal, Space Between

**Left Side:**
- Text: "8 contas selecionadas"
- Style: Body/Text/M, text-primary
- Checkbox: "Selecionar todas" (link)

**Right Side:**
- **Total Selected:** "Total: R$ 487.500,00"
  - Style: Body/Number/M, brand-danger, Bold
  - Margin Right: 16px

**Bulk Action Button:**
- Text: "Autorizar Selecionados"
- Background: brand-danger
- Text Color: white
- Padding: 10px 24px
- Style: Body/Number/S, Bold
- Icon: Check Circle (16px, white)
- Radius: 6px

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Urgency First:** Critical payments (due today) use red borders and highlights
2. **Clear Categorization:** Color-coded categories for expense tracking
3. **Cash Flow Focus:** Projection chart prominently shows runway and safety limits
4. **Actionable Design:** Payment authorization is quick and prominent

### Color Psychology
- **Red (Danger):** Immediate action required, due today
- **Amber (Warning):** Attention needed, due soon
- **Blue (Info):** Informational, future payments
- **Category Colors:** Help identify spending patterns at a glance

### Spacing System
- Use multiples of 4px for all spacing
- Card padding: 20-24px
- List item gaps: 12px
- Section gaps: 24px
- Tight gaps: 4-8px

### Interactive States
- **Payment Card Hover:** Border opacity increase + subtle lift shadow
- **Checkbox Interaction:** Clear checked/unchecked states
- **Bulk Selection:** Footer appears when items selected
- **Tab Active State:** Background color + semibold text

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Accounts_Payable_2x.png`
- Export payment card component with all states
- Export stacked bar chart as reusable component
- Export category color palette as JSON

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_03_Payables.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with title and action controls
- [ ] Build 3 metric cards with urgency indicators
- [ ] Create stacked bar chart (4 weeks × 5 categories)
- [ ] Build cash burn projection line chart
- [ ] Design payment card component (3 urgency states)
- [ ] Create payment queue list with 3+ sample cards
- [ ] Add filter tabs (Hoje, Esta Semana, Próximo Mês)
- [ ] Design bulk selection footer with actions
- [ ] Add category color legend to bar chart
- [ ] Verify urgency color hierarchy (red > amber > blue)
- [ ] Check all spacing follows 4px grid
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 3-4 hours for experienced Figma designer
**Complexity:** High (Multiple chart types, complex payment cards with states, bulk actions)

---

## 💡 Implementation Notes

### Urgency Classification Logic
```
IF due_date == TODAY THEN
  urgency = "CRITICAL" (brand-danger)
ELSE IF due_date <= TODAY + 7 days THEN
  urgency = "WARNING" (brand-warning)
ELSE
  urgency = "INFO" (brand-info)
```

### Cash Flow Projection Calculation
```
projected_balance = current_balance
FOR EACH payment IN next_30_days:
  projected_balance -= payment.amount
  plot_point(payment.due_date, projected_balance)
```

### Bulk Selection Behavior
- Checkbox selects individual payment
- "Select All" selects all payments in current tab view
- Footer shows total count + total amount
- "Authorize Selected" triggers payment workflow

### Category Expense Distribution
Based on agricultural business typical spending:
- Insumos (Inputs): 45-50% - Seeds, fertilizers, pesticides
- Manutenção (Maintenance): 12-18% - Equipment repairs
- Combustível (Fuel): 18-22% - Diesel for machinery
- Folha (Payroll): 12-15% - Labor costs
- Outros (Other): 5-8% - Administrative, utilities, etc.
