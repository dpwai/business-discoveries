# Figma Design Prompt: Dashboard #1 - Executive Overview "Raio-X da Safra"

## 🎯 Design Brief
Create a high-fidelity executive dashboard for agricultural business management with an "Industrial Precision" aesthetic - think Bloomberg Terminal meets John Deere Operations Center.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Executive_Overview_Dashboard`
- **Dimensions:** 1920px × 1080px (Desktop HD)
- **Background Color:** `#09090b` (Zinc-950)
- **Padding:** 24px all sides

---

## 🎨 Design System Tokens

### Color Palette (Save as Figma Styles)

**Backgrounds:**
- `bg-canvas`: `#09090b`
- `bg-surface`: `#18181b`
- `bg-surface-highlight`: `#27272a`

**Typography:**
- `text-primary`: `#f4f4f5` (Zinc-100)
- `text-secondary`: `#a1a1aa` (Zinc-400)
- `text-muted`: `#52525b` (Zinc-600)

**Semantic Colors:**
- `brand-primary`: `#10b981` (Emerald-500) - Profit, Growth
- `brand-danger`: `#ef4444` (Red-500) - Expenses, Alerts
- `brand-warning`: `#f59e0b` (Amber-500) - Warnings
- `brand-info`: `#3b82f6` (Blue-500) - Information
- `agro-soy`: `#eab308` (Yellow-500) - Soy culture
- `agro-corn`: `#f97316` (Orange-500) - Corn culture

### Typography Styles (Save as Text Styles)

**Font Family:** Inter (Download from Google Fonts if needed)

- `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
- `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
- `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
- `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
- `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
- `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
- `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
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
- **Main Title:** "Raio-X da Safra"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Executive Overview Dashboard"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Controls Row
**Layout:** Horizontal, Gap 16px

**Element 1: Safra Selector**
- Type: Dropdown/Select component
- Background: Glassmorphism Card
- Padding: 12px 16px
- Text: "Safra 2025/26 - Soja"
- Style: Body/Number/M
- Color: text-primary
- Icon: Chevron Down (12px, text-secondary)

**Element 2: Net Margin Badge**
- Background: `#10b981` at 20% opacity
- Border: 1px solid `#10b981` at 50% opacity
- Corner Radius: 8px
- Padding: 12px 24px
- Layout: Vertical, Center Aligned

  - **Label:** "Margem Líquida Projetada"
    - Style: Label/M
    - Color: brand-primary
  - **Value:** "R$ 4.200" + "/ha" (smaller)
    - Number: Body/Number/L, brand-primary
    - Unit: Body/Number/S, brand-primary

---

### 2. TOP KPI CARDS ROW
**Position:** Below Header, 32px margin top
**Layout:** 3 Columns, Equal Width (1fr 1fr 1fr), Gap 24px
**Card Height:** 280px

---

#### CARD 1: Progresso da Safra

**Base:** Glassmorphism Card with 24px padding

**Header:**
- Text: "Progresso da Safra"
- Style: Heading/M
- Margin Bottom: 16px

**Content Layout:** Horizontal, 2 circular progress indicators

**Progress Indicator 1: Plantio (100%)**
- **Circle Specs:**
  - Outer Diameter: 128px
  - Stroke Width: 12px
  - Background Track: `#27272a`
  - Progress Track: `#10b981` (brand-primary)
  - Progress: 100% (full circle)
  - Cap: Round

- **Center Content:**
  - Text: "100%"
  - Style: Body/Number/XL
  - Color: brand-primary

- **Label Below:**
  - Text: "Plantio"
  - Style: Body/Number/S
  - Color: text-primary
  - Margin Top: 12px

**Progress Indicator 2: Colheita (12%)**
- **Circle Specs:**
  - Same as above
  - Progress Track: `#eab308` (agro-soy)
  - Progress: 12% (calculate: 360° × 0.12 = 43.2°)

- **Center Content:**
  - Text: "12%"
  - Style: Body/Number/XL
  - Color: agro-soy

- **Label Below:**
  - Text: "Colheita"
  - Style: Body/Number/S
  - Color: text-primary

**Gap between indicators:** 32px

---

#### CARD 2: Status de Fluxo de Caixa

**Base:** Glassmorphism Card with 24px padding

**Header:**
- Text: "Status de Fluxo de Caixa"
- Style: Heading/M
- Margin Bottom: 16px

**Saldo Row:**
- Layout: Horizontal, Space Between
- **Left:** "Saldo Atual" - Label/M, text-muted
- **Right:** "R$ 2.4M" - Body/Number/L, brand-primary
- Margin Bottom: 16px

**Mini Bar Chart:**
- Container Height: 96px
- Layout: 8 vertical bars, equal width, gap 4px
- Alignment: Bottom

**Bar Data (Height %, Color):**
1. 60% - brand-primary at 30% opacity
2. 75% - brand-primary at 30% opacity
3. 50% - brand-primary at 30% opacity
4. 90% - brand-primary at 30% opacity
5. 40% - brand-danger at 30% opacity
6. 55% - brand-danger at 30% opacity
7. 85% - brand-primary at 30% opacity
8. 100% - brand-primary at 30% opacity

**Bars Style:**
- Corner Radius: 2px (top only)

**Legend Row:**
- Position: Below chart, 12px margin top
- Layout: Horizontal, Space Between

**Legend Item 1:**
- Square: 12×12px, brand-primary, radius 2px
- Text: "Receita" - Label/M, text-secondary
- Gap: 8px

**Legend Item 2:**
- Square: 12×12px, brand-danger, radius 2px
- Text: "Despesas" - Label/M, text-secondary
- Gap: 8px

---

#### CARD 3: Preço Médio de Venda

**Base:** Glassmorphism Card with 24px padding

**Header:**
- Text: "Preço Médio de Venda"
- Style: Heading/M
- Margin Bottom: 16px

**Section 1: Preço Realizado**
- Layout: Horizontal, Space Between
- **Left:** "Preço Realizado" - Label/M, text-muted
- **Right:** "R$ 142,50" - Body/Number/L, text-primary
- **Subtext:** "por saca" - Label/S, text-secondary (aligned right)
- Margin Bottom: 16px

**Divider:**
- 1px height, color: `#27272a`
- Margin Bottom: 16px

**Section 2: Meta**
- Layout: Horizontal, Space Between
- **Left:** "Meta" - Label/M, text-muted
- **Right:** "R$ 135,00" - Body/Number/M, text-secondary
- Margin Bottom: 12px

**Variance Row:**
- **Text 1:** "+5.6%" - Label/M, brand-primary, Semibold
- **Text 2:** "acima da meta" - Label/M, text-muted
- Gap: 8px

---

### 3. MAIN CHART: Profitability Waterfall
**Position:** Below KPI Cards, 24px margin top
**Layout:** Glassmorphism Card, 24px padding
**Height:** 440px

**Header:**
- Text: "Rentabilidade - Análise Waterfall"
- Style: Heading/L
- Margin Bottom: 24px

**Chart Container:**
- Height: 320px
- Layout: Horizontal, 5 columns, equal width, gap 24px
- Padding: 0 32px
- Alignment: Bottom

**Column 1: Receita Bruta**
- Bar Height: 100% (320px)
- Bar Width: Full column width
- Fill: brand-primary
- Corner Radius: 8px (top only)
- **Label Above:** "R$ 12.5M" - Body/Number/S, brand-primary
- **Label Below:** "Receita Bruta" - Label/M, text-secondary
- Gap from bar: 12px

**Column 2: Subsídios**
- Bar Height: 20% (64px)
- Position: Aligned to bottom
- Fill: brand-info at 50% opacity
- Corner Radius: 8px (top only)
- **Label Above:** "+R$ 1.2M" - Body/Number/S, brand-info
- **Label Below:** "Subsídios" - Label/M, text-secondary

**Column 3: Custos Diretos**
- Bar Height: 60% (192px)
- Fill: brand-danger at 70% opacity
- Corner Radius: 8px (top only)
- **Label Above:** "-R$ 7.8M" - Body/Number/S, brand-danger
- **Label Below:** "Custos Diretos" - Label/M, text-secondary

**Column 4: Custos Operacionais**
- Bar Height: 30% (96px)
- Fill: brand-danger at 50% opacity
- Corner Radius: 8px (top only)
- **Label Above:** "-R$ 2.1M" - Body/Number/S, brand-danger
- **Label Below:** "Custos Operacionais" - Label/M, text-secondary

**Column 5: Lucro Líquido**
- Bar Height: 45% (144px)
- Fill: brand-primary at 80% opacity
- Corner Radius: 8px (top only)
- **Label Above:** "R$ 3.8M" - Body/Number/S, brand-primary
- **Label Below:** "Lucro Líquido" - Label/M, text-secondary

---

### 4. BOTTOM SECTION: Risk Alerts & Market Position
**Position:** Below Main Chart, 24px margin top
**Layout:** 2 Columns, Equal Width (1fr 1fr), Gap 24px

---

#### LEFT CARD: Alertas de Risco

**Base:** Glassmorphism Card, 24px padding
**Min Height:** 280px

**Header:**
- Text: "Alertas de Risco"
- Style: Heading/L
- Margin Bottom: 16px

**Alert List:** Vertical stack, gap 12px

**Alert Card Style (Base):**
- Layout: Horizontal, gap 12px
- Padding: 12px
- Corner Radius: 8px
- Alignment: Start

**Alert 1: Warning Level**
- Background: brand-warning at 10% opacity
- Border: 1px solid brand-warning at 30% opacity

**Indicator Dot:**
- Size: 8×8px circle
- Fill: brand-warning
- Position: 6px from top

**Content:**
- **Title:** "3 Tratores em Manutenção"
  - Style: Body/Number/S, text-primary
- **Description:** "John Deere 8R-04, Case IH 340, New Holland T7"
  - Style: Label/M, text-secondary
  - Margin Top: 4px

**Alert 2: Info Level**
- Background: brand-info at 10% opacity
- Border: 1px solid brand-info at 30% opacity
- Indicator: brand-info

**Content:**
- **Title:** "Previsão de Chuva"
- **Description:** "40mm esperados nos próximos 2 dias - Ajustar cronograma de colheita"

**Alert 3: Critical Level**
- Background: brand-danger at 10% opacity
- Border: 1px solid brand-danger at 30% opacity
- Indicator: brand-danger

**Content:**
- **Title:** "Estoque Baixo: Glifosato"
- **Description:** "Restam apenas 2 dias de operação"

---

#### RIGHT CARD: Posição de Mercado

**Base:** Glassmorphism Card, 24px padding

**Header:**
- Text: "Posição de Mercado"
- Style: Heading/L
- Margin Bottom: 16px

**Table Structure:**

**Table Header Row:**
- Border Bottom: 1px solid `#27272a`
- Padding Bottom: 12px

**Columns:**
1. "Commodity" - Left aligned, Label/M, text-secondary
2. "Preço B3" - Right aligned, Label/M, text-secondary
3. "Chicago" - Right aligned, Label/M, text-secondary
4. "Variação" - Right aligned, Label/M, text-secondary

**Table Rows:** (Each row has bottom border: 1px solid `#27272a` at 50% opacity, padding 16px vertical)

**Row 1: Soja**
- **Col 1:**
  - Dot: 8×8px circle, agro-soy
  - Text: "Soja" - Body/Number/S, text-primary
  - Gap: 8px
- **Col 2:** "R$ 142,50" - Body/Number/S, text-primary, Semibold
- **Col 3:** "$13.45" - Body/Number/S, text-primary
- **Col 4:** "+2.3%" - Body/Number/S, brand-primary, Semibold

**Row 2: Milho**
- **Col 1:**
  - Dot: agro-corn
  - Text: "Milho"
- **Col 2:** "R$ 68,90"
- **Col 3:** "$4.82"
- **Col 4:** "-1.1%" - Body/Number/S, brand-danger, Semibold

**Row 3: Dólar**
- **Col 1:**
  - Dot: `#71717a` (Zinc-500)
  - Text: "Dólar"
- **Col 2:** "R$ 5,42"
- **Col 3:** "-"
- **Col 4:** "+0.8%" - brand-primary

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. High contrast between background and cards (glassmorphism effect)
2. Bold numbers for key metrics
3. Color coding for semantic meaning (green = positive, red = negative)

### Spacing System
- Use multiples of 4px for all spacing
- Card padding: 24px
- Section gaps: 24px
- Element gaps: 12-16px
- Tight gaps: 4-8px

### Interactive States (Optional for Static Mockup)
- Hover on cards: Increase border opacity to 20%
- Hover on buttons/dropdowns: Background to surface-highlight

### Accessibility
- Ensure all text has minimum 4.5:1 contrast ratio
- Use semibold/bold weights for better readability on dark backgrounds

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Executive_Overview_2x.png`
- Export individual components as SVG (icons, charts)
- Export color styles as JSON
- Export text styles documentation

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_01_Executive.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create all color styles in Figma
- [ ] Create all text styles in Figma
- [ ] Build glassmorphism card component
- [ ] Create header section with title and controls
- [ ] Build 3 KPI cards (Progress, Cash Flow, Price)
- [ ] Create waterfall chart with 5 columns
- [ ] Build risk alerts section with 3 alert cards
- [ ] Create market position table with 3 rows
- [ ] Verify all spacing follows 4px grid
- [ ] Check all colors match specification
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 2-3 hours for experienced Figma designer
**Complexity:** Medium-High (Custom charts, precise spacing, glassmorphism effects)
