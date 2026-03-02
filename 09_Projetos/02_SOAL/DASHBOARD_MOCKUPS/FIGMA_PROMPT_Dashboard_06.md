# Figma Design Prompt: Dashboard #6 - Estoque de Insumos (Inputs Inventory)

## 🎯 Design Brief
Create a clinical, highly-organized inputs inventory dashboard to prevent operational stoppages due to missing chemicals, seeds, or parts. Target users: Tiago (Operations) and Agronomist. The aesthetic must be clean, information-dense, and methodical - think pharmacy inventory meets industrial warehouse management.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Inputs_Inventory_Dashboard`
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
- `brand-primary`: `#10b981` (Emerald-500) - In Stock, Healthy
- `brand-danger`: `#ef4444` (Red-500) - Out of Stock, Critical
- `brand-warning`: `#f59e0b` (Amber-500) - Low Stock, Attention
- `brand-info`: `#3b82f6` (Blue-500) - Information

**Expiration Status:**
- `expiry-safe`: `#10b981` (Emerald-500) - >6 months
- `expiry-warning`: `#f59e0b` (Amber-500) - 1-6 months
- `expiry-critical`: `#ef4444` (Red-500) - <1 month

**Category Colors:**
- `category-defensivos`: `#8b5cf6` (Violet-500) - Defensivos (Pesticides)
- `category-fertilizantes`: `#06b6d4` (Cyan-500) - Fertilizantes
- `category-sementes`: `#10b981` (Emerald-500) - Sementes (Seeds)
- `category-pecas`: `#f97316` (Orange-500) - Peças (Parts)

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
- `Mono/S`: Inter Mono, 12px, Line Height 16px (for batch numbers, SKUs)

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

**Clinical Card (Variant):**
- Fill: `#18181b`
- Border: 1px solid `#27272a`
- Corner Radius: 8px
- Clean, sharp edges

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Estoque de Insumos"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Agricultural Inputs Inventory Management"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Controls
**Layout:** Horizontal, Gap 12px

**Element 1: Search Bar**
- Width: 320px
- Background: bg-surface
- Border: 1px solid zinc-800
- Padding: 10px 16px
- Placeholder: "Buscar produto, lote ou fornecedor..."
- Icon: Search (16px, text-muted)
- Radius: 8px

**Element 2: Sort Dropdown**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Ordenar: Vencimento"
- Style: Body/Number/S
- Icon: Arrow Up/Down (12px)

**Element 3: Add Item Button**
- Background: brand-primary
- Padding: 10px 20px
- Text: "Novo Insumo"
- Style: Body/Number/S, white
- Icon: Plus (16px)

---

### 2. CRITICAL ALERTS BANNER
**Position:** Below Header, 32px margin top
**Layout:** Full Width
**Height:** Auto (minimum 80px)
**Background:** brand-danger at 10% opacity
**Border:** 1px solid brand-danger at 40% opacity
**Padding:** 20px 24px
**Radius:** 12px

**Content Layout:** Horizontal, Space Between

**Left Side:**
- **Icon:** Alert Triangle (24px, brand-danger)
- **Title:** "Alertas de Estoque Crítico"
  - Style: Heading/L, brand-danger
  - Margin Left: 12px
- **Count Badge:**
  - Background: brand-danger
  - Text: "5" - Label/M, white, Bold
  - Size: 24×24px circle
  - Position: Next to title

**Right Side (Alert Items):**
- Layout: Horizontal, gap 24px

**Alert Item Template:**
- **Product Name:** "Glifosato 480g/L"
  - Style: Body/Text/M, text-primary, Semibold
- **Status:** "Restam 2 dias de operação"
  - Style: Label/M, brand-danger
  - Icon: Clock (12px)

**Sample Alerts:**
1. "Glifosato 480g/L - Restam 2 dias"
2. "Semente Soja TMG 7062 - Estoque zero"
3. "Ureia 45% - 3 dias de operação"

**Action Button:**
- Text: "Ver Todos os Alertas →"
- Style: Body/Text/M, brand-danger, Semibold
- Underline on hover

---

### 3. MAIN CONTENT GRID
**Position:** Below Alerts, 24px margin top
**Layout:** 2 Columns - 40% Left | 60% Right
**Gap:** 24px

---

### 3.1 LEFT COLUMN: Analytics & Quick Stats

**Card 1: ABC Curve (Pareto Chart)**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 360px

**Header:**
- Text: "Curva ABC - Valor em Estoque"
  - Style: Heading/L
  - Margin Bottom: 16px

**Subheader:**
- Text: "20% dos itens representam 80% do valor"
  - Style: Label/M, text-secondary
  - Margin Bottom: 20px

**Pareto Chart:**

**Dimensions:**
- Width: Full card width
- Height: 240px

**Chart Type:** Combined Bar + Line chart

**X-Axis:** Product categories (sorted by value)
- Labels: Defensivos, Sementes, Fertilizantes, Peças, Outros
- Style: Label/M, text-secondary
- Rotation: 0° (horizontal)

**Y-Axis (Left):** Value in stock (R$)
- Range: R$ 0 to R$ 800K
- Labels: 0, 200K, 400K, 600K, 800K
- Style: Label/S, text-muted
- Grid Lines: Horizontal, zinc-800 at 15% opacity

**Y-Axis (Right):** Cumulative percentage
- Range: 0% to 100%
- Labels: 0%, 25%, 50%, 75%, 100%
- Style: Label/S, text-muted

**Bars (Value per category):**
- Width: 60px each
- Gap: 12px
- Colors: Respective category colors
- Corner Radius: 4px (top)

**Sample Data:**
1. Defensivos: R$ 680K (85% height) - category-defensivos
2. Sementes: R$ 420K (52%) - category-sementes
3. Fertilizantes: R$ 280K (35%) - category-fertilizantes
4. Peças: R$ 120K (15%) - category-pecas
5. Outros: R$ 50K (6%) - zinc-500

**Cumulative Line:**
- Type: Line overlay
- Color: brand-primary
- Stroke: 3px
- Points: Circle markers (8px)
- Path: Shows cumulative percentage reaching 100%

**80/20 Reference Line:**
- Horizontal dashed line at 80%
- Color: brand-warning
- Dash: 4px 4px
- Label: "80% do Valor" - Label/S, brand-warning

**Legend:**
- Position: Below chart
- Layout: Horizontal, gap 16px

**Items:**
- Bar icon + "Valor por Categoria"
- Line icon + "Acumulado %"

---

**Card 2: Stock Summary Cards**
**Layout:** 3 mini cards, vertical stack
**Gap:** 16px
**Margin Top:** 24px

---

**Mini Card Template:**
- Height: 100px
- Background: Clinical Card
- Padding: 16px
- Border: 1px solid category color at 30% opacity

**Mini Card 1: Low Stock Items**
- Border Color: brand-danger at 30%
- Icon: Alert Circle (20px, brand-danger)
- Label: "Estoque Baixo"
- Value: "12 itens"
- Style Value: Body/Number/L, brand-danger
- Subtext: "Requer reposição urgente"

**Mini Card 2: Expiring Soon**
- Border Color: brand-warning at 30%
- Icon: Calendar X (20px, brand-warning)
- Label: "Vencimento Próximo"
- Value: "8 itens"
- Style Value: Body/Number/L, brand-warning
- Subtext: "< 3 meses para vencer"

**Mini Card 3: Total Value**
- Border Color: brand-info at 30%
- Icon: Package (20px, brand-info)
- Label: "Valor Total em Estoque"
- Value: "R$ 1,55M"
- Style Value: Body/Number/L, brand-info
- Subtext: "284 itens cadastrados"

---

### 3.2 RIGHT COLUMN: Inventory Grid

**Card: Products Inventory Table**
**Layout:** Clinical Card, 0px padding (table fills card)
**Height:** 744px (to match left column)

**Tab Navigation (Top of card):**
- Background: bg-surface-highlight
- Height: 56px
- Padding: 0 24px
- Border Bottom: 1px solid zinc-800

**Tabs:**
- Layout: Horizontal, gap 8px
- Padding: 16px 0

**Tab Design:**
- Padding: 10px 20px
- Radius: 6px
- Style: Body/Text/M, text-secondary

**Active Tab:**
- Background: category color at 15% opacity
- Text Color: category color
- Font: Semibold
- Border Bottom: 2px solid category color

**Tab Items:**
1. **Defensivos (42)** - category-defensivos
2. **Fertilizantes (28)** - category-fertilizantes
3. **Sementes (15)** - category-sementes
4. **Peças (38)** - category-pecas

---

**Table Structure:**

**Table Header:**
- Background: bg-surface
- Border Bottom: 2px solid zinc-700
- Padding: 12px 24px
- Height: 48px
- Sticky (stays on scroll)

**Columns:**

1. **Produto** (30% width)
   - Text: "Produto"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Left

2. **Lote** (12% width)
   - Text: "Lote"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Left

3. **Vencimento** (15% width)
   - Text: "Vencimento"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Left

4. **Quantidade** (15% width)
   - Text: "Quantidade"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Right

5. **Custo Unit.** (13% width)
   - Text: "Custo Unit."
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Right

6. **Valor Total** (15% width)
   - Text: "Valor Total"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Right

---

**Table Rows:**

**Row Height:** 72px
**Row Background:** Alternating
  - Odd: bg-surface
  - Even: transparent
**Row Border:** Bottom 1px solid zinc-800 at 30% opacity
**Row Padding:** 12px 24px
**Hover State:** Background to bg-surface-highlight

---

**Row Template:**

**Column 1: Product (with icon and alerts):**

**Layout:** Horizontal, gap 12px

**Product Icon:**
- Size: 40×40px circle
- Background: category color at 15% opacity
- Icon: Category-specific (16px, category color)
  - Defensivos: Spray can
  - Fertilizantes: Beaker
  - Sementes: Seed/Leaf
  - Peças: Cog/Wrench

**Product Info:**
- **Name:** Product name
  - Style: Body/Text/M, text-primary, Semibold
- **Supplier:** Manufacturer/brand
  - Style: Label/S, text-muted
  - Margin Top: 2px

**Alert Badge (if applicable):**
- Position: Right of product name
- Size: 18×18px circle
- Background: alert color
- Icon: Alert symbol (10px, white)
- Types:
  - Red: Critical stock/expired
  - Yellow: Low stock/expiring soon
  - Green: Optimal stock

---

**Column 2: Batch Number:**
- Text: Batch code (e.g., "LOT-2025-847")
- Style: Mono/S, text-secondary
- Background: bg-surface-highlight (subtle)
- Padding: 4px 8px
- Radius: 4px

---

**Column 3: Expiration Date:**

**Layout:** Vertical

**Date:**
- Text: "15/08/2026"
- Style: Body/Text/M, color based on expiry status

**Time Remaining:**
- Text: "6,5 meses"
- Style: Label/S, color based on expiry status
- Icon: Clock (10px)

**Color Logic:**
- Green (expiry-safe): >6 months
- Yellow (expiry-warning): 1-6 months
- Red (expiry-critical): <1 month

---

**Column 4: Quantity:**

**Layout:** Vertical, Right aligned

**Current Stock:**
- Text: "1.200"
- Style: Body/Number/M, text-primary, Semibold

**Unit:**
- Text: "litros" or "kg" or "unidades"
- Style: Label/S, text-muted

**Stock Level Indicator:**
- Horizontal mini bar (100px width, 4px height)
- Background: zinc-800
- Fill: Color based on stock level
  - Green (>50% of minimum): brand-primary
  - Yellow (25-50%): brand-warning
  - Red (<25%): brand-danger
- Margin Top: 4px

---

**Column 5: Unit Cost:**
- Text: "R$ 45,80"
- Style: Body/Number/M, text-primary
- Unit: "/litro"
- Style Unit: Label/S, text-muted

---

**Column 6: Total Value:**
- Text: "R$ 54.960,00"
- Style: Body/Number/M, text-primary, Semibold

---

**Sample Table Rows:**

**Row 1: Glifosato 480g/L (CRITICAL)**
- Icon: Spray can (violet background)
- Product: "Glifosato 480g/L"
- Supplier: "Bayer CropScience"
- Alert: Red badge (critical stock)
- Lote: "LOT-2025-0847"
- Vencimento: "15/03/2026" (2,5 meses) - Yellow
- Quantidade: "480 L" - Stock bar at 15% (RED)
- Custo: "R$ 68,50/L"
- Total: "R$ 32.880,00"

**Row 2: Ureia 45% N (WARNING)**
- Icon: Beaker (cyan background)
- Product: "Ureia 45% N"
- Supplier: "Yara Brasil"
- Alert: Yellow badge (low stock)
- Lote: "LOT-2025-1203"
- Vencimento: "N/A" (fertilizers don't expire typically)
- Quantidade: "2.800 kg" - Stock bar at 35% (YELLOW)
- Custo: "R$ 3,20/kg"
- Total: "R$ 8.960,00"

**Row 3: Semente Soja TMG 7062 (HEALTHY)**
- Icon: Seed (green background)
- Product: "Semente Soja TMG 7062"
- Supplier: "Tropical Melhoramento"
- Alert: Green badge (optimal)
- Lote: "LOT-2025-0956"
- Vencimento: "15/12/2026" (10,5 meses) - Green
- Quantidade: "1.500 kg" - Stock bar at 75% (GREEN)
- Custo: "R$ 285,00/kg"
- Total: "R$ 427.500,00"

**Row 4: Filtro de Óleo John Deere**
- Icon: Cog (orange background)
- Product: "Filtro de Óleo RE504836"
- Supplier: "John Deere"
- Alert: None
- Lote: "JD-2024-5847"
- Vencimento: "N/A"
- Quantidade: "24 unidades" - Stock bar at 60% (GREEN)
- Custo: "R$ 180,00/un"
- Total: "R$ 4.320,00"

---

**Table Footer:**
- Background: bg-surface
- Border Top: 1px solid zinc-700
- Height: 56px
- Padding: 16px 24px

**Footer Content:**
- Layout: Horizontal, Space Between

**Left Side:**
- Text: "Mostrando 1-15 de 42 itens"
- Style: Label/M, text-secondary

**Right Side: Pagination**
- Layout: Horizontal, Gap 8px
- Buttons: 32×32px each
- Active: bg-category-color at 20%, text category-color
- Inactive: bg-surface-highlight, text-secondary

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Critical Alerts First:** Red banner immediately shows stockouts
2. **Clinical Organization:** Clean rows, clear columns, methodical layout
3. **Expiration Urgency:** Color-coded expiration dates catch attention
4. **ABC Analysis:** Pareto chart identifies high-value items

### Information Density
- **High Density:** Maximum information per screen
- **Scannable:** Color coding enables quick visual scanning
- **Batch Tracking:** Mono font for batch numbers (technical precision)
- **Stock Indicators:** Mini progress bars show stock levels at a glance

### Color Coding System

**Expiration:**
- 🟢 Green: >6 months (safe)
- 🟡 Yellow: 1-6 months (monitor)
- 🔴 Red: <1 month (urgent)

**Stock Level:**
- 🟢 Green: >50% of minimum stock
- 🟡 Yellow: 25-50%
- 🔴 Red: <25% (critical)

**Categories:**
- 🟣 Violet: Defensivos
- 🔵 Cyan: Fertilizantes
- 🟢 Emerald: Sementes
- 🟠 Orange: Peças

### Spacing System
- Use multiples of 4px for all spacing
- Table row padding: 12px vertical
- Card padding: 24px
- Section gaps: 24px

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Inputs_Inventory_2x.png`
- Export table row component with all states
- Export expiration badge component (3 states)
- Export stock level indicator bar
- Export ABC Pareto chart component

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_06_Inputs_Inventory.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with search and controls
- [ ] Build critical alerts banner with 3+ alerts
- [ ] Create ABC Pareto chart (bar + line combo)
- [ ] Build 3 summary mini cards
- [ ] Design category tabs (4 categories)
- [ ] Create inventory table with 6 columns
- [ ] Build table rows with all components (icon, batch, expiry, quantity, cost)
- [ ] Add expiration color coding (3 states)
- [ ] Create stock level mini bars
- [ ] Add category icons (4 types)
- [ ] Design pagination controls
- [ ] Verify clinical aesthetic (clean, organized)
- [ ] Check all spacing follows 4px grid
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 3-4 hours for experienced Figma designer
**Complexity:** High (Complex table with multiple states, Pareto chart, color-coded expiration system, category tabs)

---

## 💡 Implementation Notes

### Expiration Color Logic
```
months_to_expiry = (expiration_date - today) / 30

IF months_to_expiry > 6 THEN
  color = expiry-safe (green)
ELSE IF months_to_expiry >= 1 THEN
  color = expiry-warning (yellow)
ELSE
  color = expiry-critical (red)
```

### Stock Level Alert Logic
```
stock_percentage = (current_stock / minimum_stock) × 100

IF stock_percentage < 25 THEN
  alert = "CRITICAL" (red)
  days_remaining = current_stock / daily_usage
ELSE IF stock_percentage < 50 THEN
  alert = "WARNING" (yellow)
ELSE
  alert = "HEALTHY" (green)
```

### ABC Curve Calculation
```
1. Sort all items by total value (descending)
2. Calculate cumulative percentage
3. Plot bars for each category's total value
4. Overlay line showing cumulative %
5. Highlight 20/80 point (20% of items = 80% of value)
```

### Critical Alerts Banner Logic
Show items with:
- Stock level < 3 days of operation
- Expiration < 30 days
- Stock = 0 (out of stock)

Priority order: Out of stock → Critical expiry → Low stock

### Table Sorting Default
Default sort: Expiration date (ascending) - shows items expiring soonest first
Alternative sorts: Stock level, Total value, Product name

### Category Icon Mapping
- Defensivos (Pesticides): Spray can icon
- Fertilizantes (Fertilizers): Beaker/chemistry icon
- Sementes (Seeds): Seed/leaf icon
- Peças (Parts): Cog/wrench icon
