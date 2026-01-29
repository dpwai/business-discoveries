# Figma Design Prompt: Dashboard #7 - Custos por Fazenda/Cultura (Cost Accounting)

## 🎯 Design Brief
Create an analytical cost accounting dashboard for detailed financial breakdown of agricultural operations. Target users: Claudio (Owner) and Accountant. The aesthetic must be analytical yet beautiful - think spreadsheet meets data visualization, with muted colors to reduce visual fatigue during deep analysis sessions.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Cost_Accounting_Dashboard`
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
- `brand-primary`: `#10b981` (Emerald-500) - Under Budget
- `brand-danger`: `#ef4444` (Red-500) - Over Budget
- `brand-warning`: `#f59e0b` (Amber-500) - Near Budget Limit
- `brand-info`: `#3b82f6` (Blue-500) - Information

**Muted Analytical Colors (for Treemap):**
- `cost-fertilizers`: `#3b82f6` (Blue-500) - Fertilizantes
- `cost-seeds`: `#10b981` (Emerald-600) - Sementes
- `cost-pesticides`: `#8b5cf6` (Violet-500) - Defensivos
- `cost-fuel`: `#f59e0b` (Amber-500) - Combustível
- `cost-labor`: `#06b6d4` (Cyan-500) - Mão de Obra
- `cost-maintenance`: `#f97316` (Orange-500) - Manutenção
- `cost-other`: `#71717a` (Zinc-500) - Outros

**Farm/Culture Colors:**
- `farm-santana`: `#059669` (Emerald-600)
- `farm-retiro2`: `#0284c7` (Sky-600)
- `culture-soy`: `#eab308` (Yellow-500)
- `culture-corn`: `#f97316` (Orange-500)

### Typography Styles

**Font Family:** Inter

- `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
- `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
- `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
- `Body/Number/XXL`: Inter Bold, 48px, Line Height 56px, #f4f4f5
- `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
- `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
- `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
- `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
- `Body/Text/M`: Inter Regular, 14px, Line Height 20px, #f4f4f5
- `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
- `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b
- `Mono/M`: Inter Mono, 14px, Line Height 20px (for currency values)

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

**Analytical Card (Variant):**
- Fill: `#18181b`
- Border: 1px solid `#27272a`
- Corner Radius: 8px
- Subtle, professional

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Custos por Fazenda/Cultura"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Cost Accounting & Budget Analysis"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Controls
**Layout:** Horizontal, Gap 12px

**Element 1: View Toggle (Macro Toggle)**
- Type: Segmented control
- Width: 320px
- Background: bg-surface
- Border: 1px solid zinc-800
- Padding: 4px
- Radius: 8px

**Segments:**

**Segment 1: View by Farm**
- Text: "Por Fazenda"
- Icon: Map (16px)
- Active State:
  - Background: farm-santana at 20% opacity
  - Text Color: farm-santana
  - Font: Semibold

**Segment 2: View by Culture**
- Text: "Por Cultura"
- Icon: Wheat/Corn (16px)
- Inactive State:
  - Background: transparent
  - Text Color: text-secondary
  - Hover: bg-surface-highlight

**Element 2: Safra Selector**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Safra 2025/26"
- Style: Body/Number/S
- Icon: Chevron Down (12px)

**Element 3: Export Button**
- Background: brand-info at 15% opacity
- Border: 1px solid brand-info at 40% opacity
- Padding: 10px 20px
- Text: "Exportar Análise"
- Style: Body/Number/S, brand-info
- Icon: Download (16px)

---

### 2. COST SUMMARY CARDS
**Position:** Below Header, 32px margin top
**Layout:** 4 Cards, Equal Width, Gap 20px
**Card Height:** 140px

---

#### CARD 1: Total Cost

**Base:** Glassmorphism Card, 20px padding

**Icon Badge:**
- Size: 40×40px circle
- Background: brand-info at 15% opacity
- Icon: Calculator (20px, brand-info)

**Content:**
- **Label:** "Custo Total (Safra)"
  - Style: Label/M, text-secondary
  - Margin Bottom: 8px

- **Value:** "R$ 8.450.000"
  - Style: Body/Number/XL, text-primary
  - Margin Bottom: 4px

- **Subtext:** "Todas as fazendas"
  - Style: Label/S, text-muted

---

#### CARD 2: Cost per Hectare

**Base:** Glassmorphism Card, 20px padding

**Icon Badge:**
- Background: farm-santana at 15% opacity
- Icon: Maximize (20px, farm-santana)

**Content:**
- **Label:** "Custo por Hectare"
  - Style: Label/M, text-secondary

- **Value:** "R$ 4.225"
  - Style: Body/Number/XL, farm-santana
  - Unit: "/ha" - Body/Number/S

- **Comparison:**
  - Text: "+8,5% vs safra anterior"
  - Style: Label/S, brand-danger
  - Icon: Arrow Up (12px)

---

#### CARD 3: Budget Variance

**Base:** Glassmorphism Card, 20px padding

**Icon Badge:**
- Background: brand-warning at 15% opacity
- Icon: Target (20px, brand-warning)

**Content:**
- **Label:** "Desvio do Orçamento"
  - Style: Label/M, text-secondary

- **Value:** "+3,2%"
  - Style: Body/Number/XL, brand-warning

- **Subtext:** "R$ 262K acima do planejado"
  - Style: Label/S, text-muted

- **Progress Bar:**
  - Height: 4px
  - Background: zinc-800
  - Fill: brand-warning (103.2% of width, overflow indicator)
  - Margin Top: 12px

---

#### CARD 4: Largest Cost Category

**Base:** Glassmorphism Card, 20px padding

**Icon Badge:**
- Background: cost-fertilizers at 15% opacity
- Icon: Beaker (20px, cost-fertilizers)

**Content:**
- **Label:** "Maior Categoria de Custo"
  - Style: Label/M, text-secondary

- **Value:** "Fertilizantes"
  - Style: Body/Number/L, cost-fertilizers

- **Amount:** "R$ 2.8M (33%)"
  - Style: Body/Number/M, text-primary

---

### 3. MAIN CONTENT GRID
**Position:** Below Summary Cards, 24px margin top
**Layout:** 2 Columns - 55% Left | 45% Right
**Gap:** 24px

---

### 3.1 LEFT COLUMN: Treemap Visualization

**Card: Cost Breakdown Treemap**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 520px

**Header:**
- Text: "Distribuição de Custos - Treemap"
  - Style: Heading/L
  - Margin Bottom: 16px

**View Indicator:**
- Text: "Visualização: Por Categoria" (updates based on toggle)
  - Style: Label/M, text-secondary
  - Icon: Grid (12px)

**Treemap Container:**
- Width: Full card width
- Height: 440px
- Background: bg-surface-highlight
- Padding: 8px
- Radius: 8px

---

**Treemap Structure:**

**Layout:** Nested rectangles (larger area = higher cost)

**Level 1: Main Categories (Top-level rectangles)**

Each rectangle has:
- Fill: Category color at 60% opacity
- Border: 2px solid category color
- Padding: 12px
- Radius: 6px
- Hover: Brightness increase + cursor pointer

**Rectangle Contents:**

**Header (Top of rectangle):**
- **Category Name:** Bold, category color
  - Style: Body/Number/M, Semibold
- **Percentage:** Of total cost
  - Style: Label/M, text-secondary
  - Position: Same line as name

**Center (Large number):**
- **Amount:** "R$ 2,8M"
  - Style: Body/Number/L or XL (depending on rectangle size), white, Bold
  - Centered in rectangle

**Footer (Bottom of rectangle):**
- **Drill-down hint:** "Clique para detalhar →"
  - Style: Label/S, category color
  - Opacity: 0.7

---

**Sample Treemap Rectangles (Ordered by size):**

**1. Fertilizantes (Largest - 33%)**
- Size: 33% of total area
- Position: Top left, large rectangle
- Color: cost-fertilizers (blue)
- Header: "Fertilizantes | 33%"
- Center: "R$ 2,8M"
- Footer: "Clique para detalhar →"

**2. Sementes (22%)**
- Size: 22% of area
- Position: Top right
- Color: cost-seeds (emerald)
- Amount: "R$ 1,9M"

**3. Defensivos (20%)**
- Size: 20% of area
- Position: Middle left
- Color: cost-pesticides (violet)
- Amount: "R$ 1,7M"

**4. Combustível (12%)**
- Size: 12%
- Position: Bottom left
- Color: cost-fuel (amber)
- Amount: "R$ 1,0M"

**5. Mão de Obra (8%)**
- Size: 8%
- Color: cost-labor (cyan)
- Amount: "R$ 676K"

**6. Manutenção (3%)**
- Size: 3%
- Color: cost-maintenance (orange)
- Amount: "R$ 254K"

**7. Outros (2%)**
- Size: 2%
- Color: cost-other (zinc)
- Amount: "R$ 169K"

---

**Drill-down State (Optional for static mockup):**

When a rectangle is clicked, show sub-categories:

**Example: Fertilizantes drilled down**
- Original rectangle subdivides into smaller rectangles:
  - Ureia: R$ 1,2M (43%)
  - NPK: R$ 840K (30%)
  - MAP: R$ 560K (20%)
  - Outros: R$ 200K (7%)

**Back Button:**
- Position: Top left of treemap
- Text: "← Voltar"
- Style: Label/M, brand-info
- Visible only in drill-down state

---

### 3.2 RIGHT COLUMN: Trends & Budget Comparison

**Card 1: Cost per Hectare Trend**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 280px

**Header:**
- Text: "Evolução do Custo/Ha"
  - Style: Heading/L
  - Margin Bottom: 16px

**Subheader:**
- Text: "Últimas 5 safras"
  - Style: Label/M, text-secondary

**Line Chart:**

**Dimensions:**
- Width: Full card width
- Height: 180px

**X-Axis:** Safra (Harvest year)
- Labels: "21/22", "22/23", "23/24", "24/25", "25/26"
- Style: Label/M, text-muted
- Grid Lines: Vertical, zinc-800 at 15% opacity

**Y-Axis:** Cost per hectare (R$/ha)
- Range: R$ 3.000 to R$ 5.000
- Labels: 3k, 3.5k, 4k, 4.5k, 5k
- Style: Label/S, text-muted
- Grid Lines: Horizontal, zinc-800 at 15% opacity

**Data Line:**
- Color: brand-info
- Stroke: 3px
- Smooth curve
- Area Fill: brand-info at 10% opacity

**Data Points:**
- Circles: 8px diameter
- Fill: brand-info
- Border: 2px solid bg-canvas

**Sample Data:**
1. 21/22: R$ 3.680/ha
2. 22/23: R$ 3.850/ha
3. 23/24: R$ 3.920/ha
4. 24/25: R$ 3.895/ha
5. 25/26: R$ 4.225/ha (current, highlighted larger)

**Current Point Highlight:**
- Circle: 12px (larger)
- Label Above: "R$ 4.225"
  - Style: Body/Number/M, brand-info, Bold
  - Background: brand-info at 20% opacity
  - Padding: 4px 8px
  - Radius: 4px

**Trend Indicator:**
- Position: Bottom right of chart
- Text: "+8,5% vs safra anterior"
- Icon: Trending Up (14px, brand-danger)
- Style: Label/M, brand-danger

---

**Card 2: Budget vs Executed (Comparative Table)**
**Layout:** Analytical Card, 0px padding (table fills card)
**Height:** 216px
**Margin Top:** 24px

**Header:**
- Background: bg-surface-highlight
- Padding: 16px 20px
- Border Bottom: 1px solid zinc-700

**Title:**
- Text: "Orçado vs Executado"
- Style: Heading/L

---

**Table Structure:**

**Table Header:**
- Background: bg-surface
- Border Bottom: 2px solid zinc-700
- Padding: 10px 20px
- Height: 40px

**Columns:**

1. **Categoria** (40% width)
   - Text: "Categoria"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Left

2. **Orçado** (20% width)
   - Text: "Orçado"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Right

3. **Executado** (20% width)
   - Text: "Executado"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Right

4. **Desvio** (20% width)
   - Text: "Desvio %"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Right

---

**Table Rows:**

**Row Height:** 44px
**Row Background:** Alternating (bg-surface / transparent)
**Row Border:** Bottom 1px solid zinc-800 at 30%
**Row Padding:** 10px 20px

---

**Sample Rows:**

**Row 1: Fertilizantes (Over Budget)**
- **Categoria:**
  - Dot: 8×8px, cost-fertilizers
  - Text: "Fertilizantes"
  - Style: Body/Text/M, text-primary

- **Orçado:** "R$ 2.650.000"
  - Style: Body/Number/S, text-secondary

- **Executado:** "R$ 2.800.000"
  - Style: Body/Number/S, text-primary, Semibold

- **Desvio:** "+5,7%"
  - Style: Body/Number/S, brand-danger, Semibold
  - Background: brand-danger at 10% opacity
  - Padding: 4px 8px
  - Radius: 4px

**Row 2: Sementes (Under Budget)**
- Categoria: "Sementes" (emerald dot)
- Orçado: "R$ 1.950.000"
- Executado: "R$ 1.870.000"
- Desvio: "-4,1%"
  - Color: brand-primary (green)
  - Background: brand-primary at 10%

**Row 3: Defensivos (Near Budget)**
- Categoria: "Defensivos" (violet dot)
- Orçado: "R$ 1.680.000"
- Executado: "R$ 1.720.000"
- Desvio: "+2,4%"
  - Color: brand-warning (yellow)

**Row 4: Combustível (On Budget)**
- Categoria: "Combustível" (amber dot)
- Orçado: "R$ 1.000.000"
- Executado: "R$ 1.015.000"
- Desvio: "+1,5%"
  - Color: text-primary (neutral)

---

**Table Footer:**
- Background: bg-surface-highlight
- Border Top: 2px solid zinc-700
- Height: 44px
- Padding: 10px 20px

**Content:**
- Layout: Horizontal, Space Between

**Totals:**
- **Label:** "TOTAL"
  - Style: Label/M, text-secondary, Bold

- **Orçado Total:** "R$ 8.188.000"
  - Style: Body/Number/M, text-secondary, Bold

- **Executado Total:** "R$ 8.450.000"
  - Style: Body/Number/M, text-primary, Bold

- **Desvio Total:** "+3,2%"
  - Style: Body/Number/M, brand-warning, Bold
  - Background: brand-warning at 15%
  - Padding: 6px 12px
  - Radius: 6px

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Treemap Dominance:** Large interactive visualization draws attention
2. **Trend Analysis:** Line chart shows historical context
3. **Budget Focus:** Deviation percentages prominently displayed
4. **Muted Colors:** Analytical palette reduces visual fatigue

### Analytical Design Language
- **Spreadsheet-Inspired:** Tables with alternating rows
- **Data-Dense:** Maximum information, minimal decoration
- **Professional Muted Palette:** Blues, greens, violets at moderate saturation
- **Clear Typography:** Numbers are bold, labels are secondary

### Treemap Interaction (Concept)
- **Hover:** Rectangle brightens, shows tooltip
- **Click:** Drills down to sub-categories
- **Breadcrumb:** Shows drill-down path
- **Back Button:** Returns to top level

### Color Logic

**Deviation/Variance:**
- 🟢 Green: Under budget (negative %, good)
- 🟡 Yellow: Near budget (±2%)
- 🔴 Red: Over budget (positive %, bad)

**Cost Categories:**
- Consistent colors across all visualizations
- Muted tones for prolonged analysis

### Spacing System
- Use multiples of 4px for all spacing
- Card padding: 20-24px
- Table row padding: 10px vertical
- Section gaps: 24px

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Cost_Accounting_2x.png`
- Export treemap component with interaction states
- Export budget comparison table
- Export cost trend line chart
- Export deviation badge component (3 states)

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_07_Cost_Accounting.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with view toggle and controls
- [ ] Build 4 summary cards with metrics
- [ ] Design segmented control for Farm/Culture toggle
- [ ] Create treemap with 7 cost categories
- [ ] Calculate proportional rectangle sizes
- [ ] Add drill-down indicators to treemap
- [ ] Build cost/ha trend line chart (5 safras)
- [ ] Create budget comparison table (4-5 rows)
- [ ] Design deviation badges (3 color states)
- [ ] Add color-coded dots to table categories
- [ ] Calculate and display totals in table footer
- [ ] Verify muted analytical color palette
- [ ] Check all spacing follows 4px grid
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 4-5 hours for experienced Figma designer
**Complexity:** Very High (Interactive treemap with drill-down, proportional layout calculations, multi-dataset visualizations)

---

## 💡 Implementation Notes

### Treemap Size Calculation
```
For each category:
  rectangle_area = (category_cost / total_cost) × total_treemap_area

Layout algorithm:
  1. Sort categories by cost (descending)
  2. Use squarified treemap algorithm for balanced rectangles
  3. Maintain aspect ratios close to 1:1 for readability
```

### Deviation Color Logic
```
deviation_percentage = ((executed - budgeted) / budgeted) × 100

IF deviation_percentage < -2 THEN
  color = brand-primary (under budget, good)
ELSE IF deviation_percentage > 2 THEN
  color = brand-danger (over budget, bad)
ELSE
  color = brand-warning (near budget, neutral)
```

### View Toggle Behavior
**"Por Fazenda" (By Farm):**
- Treemap shows: Fazenda Santana vs Fazenda Retiro 2
- Each farm subdivides into cost categories

**"Por Cultura" (By Culture):**
- Treemap shows: Soja vs Milho
- Each culture subdivides into cost categories

### Cost per Hectare Calculation
```
cost_per_hectare = total_cost / total_planted_area
trend_percentage = ((current_year - previous_year) / previous_year) × 100
```

### Drill-down Interaction States
1. **Top Level:** Main categories (7 rectangles)
2. **Level 2:** Sub-categories within selected category
3. **Level 3:** Specific line items (optional, very detailed)

**Navigation:**
- Click rectangle to drill down
- "← Voltar" button to go back
- Breadcrumb: "Todas Categorias > Fertilizantes > Ureia"

### Budget Variance Alert Thresholds
- Critical: >5% over budget (red alert)
- Warning: 2-5% over budget (yellow)
- Acceptable: <2% variance (neutral)
- Excellent: Under budget (green)
