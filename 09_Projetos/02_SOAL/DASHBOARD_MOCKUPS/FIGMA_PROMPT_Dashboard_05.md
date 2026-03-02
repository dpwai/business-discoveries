# Figma Design Prompt: Dashboard #5 - Estoque de Grãos & Comercialização

## 🎯 Design Brief
Create a grain inventory and commercialization strategy dashboard focused on the critical "When to Sell?" decision. Target user: Claudio (Owner). The design must use clean spatial layouts with gold/yellow colors for grain representation, featuring realistic silo visualizations and real-time market data integration.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Grain_Inventory_Dashboard`
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
- `brand-primary`: `#10b981` (Emerald-500) - Positive Market Movement
- `brand-danger`: `#ef4444` (Red-500) - Negative Market Movement
- `brand-warning`: `#f59e0b` (Amber-500) - Hold Decision
- `brand-info`: `#3b82f6` (Blue-500) - Information

**Grain Colors (Primary Theme):**
- `grain-soy`: `#eab308` (Yellow-500) - Soja (Soybean)
- `grain-corn`: `#f97316` (Orange-500) - Milho (Corn)
- `grain-wheat`: `#d97706` (Amber-600) - Trigo (Wheat)
- `grain-generic`: `#ca8a04` (Yellow-600) - Generic grain

**Storage Status:**
- `storage-full`: `#10b981` (Emerald-500) - >80% capacity
- `storage-medium`: `#f59e0b` (Amber-500) - 40-80% capacity
- `storage-low`: `#ef4444` (Red-500) - <40% capacity

### Typography Styles

**Font Family:** Inter

- `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
- `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
- `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
- `Body/Number/XXL`: Inter Bold, 48px, Line Height 56px, #f4f4f5 (for large metrics)
- `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
- `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
- `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
- `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
- `Body/Text/M`: Inter Regular, 14px, Line Height 20px, #f4f4f5
- `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
- `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b
- `Ticker/Price`: Inter Mono, 18px, Line Height 24px (for market prices)

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

**Market Card (Variant):**
- Fill: `#18181b`
- Border: 1px solid grain color at 20% opacity
- Corner Radius: 8px
- Subtle grain texture overlay (optional)

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Estoque de Grãos"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Grain Inventory & Commercialization Strategy"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Controls
**Layout:** Horizontal, Gap 12px

**Element 1: Safra Selector**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Safra 2025/26"
- Style: Body/Number/S
- Icon: Chevron Down (12px)

**Element 2: Live Market Badge**
- Background: grain-soy at 15% opacity
- Border: 1px solid grain-soy at 40% opacity
- Padding: 10px 16px
- Text: "Mercado Ao Vivo"
- Style: Body/Number/S, grain-soy
- Icon: Live indicator dot (6px, pulsing)
- Animation: Pulse on dot

**Element 3: Market Report Button**
- Background: brand-primary
- Padding: 10px 20px
- Text: "Análise de Venda"
- Style: Body/Number/S, white
- Icon: TrendingUp (16px)

---

### 2. STORAGE OVERVIEW (Top Cards)
**Position:** Below Header, 32px margin top
**Layout:** 3 Cards, widths: 35% | 30% | 35%
**Gap:** 24px
**Card Height:** 200px

---

#### CARD 1: Total Inventory Summary

**Base:** Glassmorphism Card, 24px padding

**Header:**
- Text: "Estoque Total"
- Style: Heading/L
- Margin Bottom: 16px

**Main Metric:**
- **Value:** "18.450"
- **Unit:** "toneladas"
- Style Value: Body/Number/XXL, text-primary
- Style Unit: Body/Number/M, text-secondary
- Margin Bottom: 12px

**Breakdown Grid (2 columns):**

**Row 1:**
- **Left:**
  - Dot: 8×8px circle, grain-soy
  - Label: "Soja"
  - Value: "12.800 t"
  - Percentage: "69,4%"
  - Style: Body/Number/S, text-primary

- **Right:**
  - Dot: 8×8px circle, grain-corn
  - Label: "Milho"
  - Value: "5.650 t"
  - Percentage: "30,6%"
  - Style: Body/Number/S, text-primary

**Visual Bar:**
- Height: 8px
- Background: zinc-800
- Margin Top: 16px
- Segmented fill:
  - Soy segment: 69.4% width, grain-soy
  - Corn segment: 30.6% width, grain-corn
- Corner Radius: 4px

---

#### CARD 2: Commercialization Gauge

**Base:** Glassmorphism Card, 24px padding

**Header:**
- Text: "Status Comercial"
- Style: Heading/L
- Margin Bottom: 8px

**Half-Circle Gauge:**
- Type: Semi-circle (180° arc)
- Diameter: 160px
- Position: Centered
- Stroke Width: 20px

**Gauge Structure:**

**Background Arc:**
- Color: zinc-800
- Angle: 180° (full half circle)

**Progress Arcs (Stacked):**

1. **Sold Portion (Green):**
   - Color: brand-primary
   - Angle: 108° (60% of 180°)
   - Start: -90° (left position)
   - End: 18°

2. **Stored Portion (Yellow):**
   - Color: grain-soy
   - Angle: 72° (40% of 180°)
   - Start: 18°
   - End: 90° (right position)

**Center Content:**
- Position: Center of gauge

**Main Number:**
- Text: "60%"
- Style: Body/Number/XL, brand-primary, Bold
- Label Below: "Vendido"
- Style Label: Label/M, text-secondary

**Legend (Below Gauge):**
- Layout: Horizontal, Center, Gap 24px
- Margin Top: 16px

**Item 1:**
- Dot: 12×12px, brand-primary
- Text: "Vendido: 11.070 t"
- Style: Label/M, text-secondary

**Item 2:**
- Dot: 12×12px, grain-soy
- Text: "Armazenado: 7.380 t"
- Style: Label/M, text-secondary

---

#### CARD 3: Average Sell Price vs Target

**Base:** Glassmorphism Card, 24px padding

**Header:**
- Text: "Preço Médio Realizado"
- Style: Heading/L
- Margin Bottom: 12px

**Price Display:**

**Main Price:**
- Value: "R$ 148,20"
- Unit: "/saca"
- Style Value: Body/Number/XL, grain-soy, Bold
- Style Unit: Body/Number/S, text-secondary
- Margin Bottom: 8px

**Comparison Row:**
- Layout: Horizontal, Space Between

**Target:**
- Label: "Meta:"
- Value: "R$ 142,00"
- Style: Body/Number/M, text-secondary

**Variance:**
- Badge Background: brand-primary at 20% opacity
- Border: 1px solid brand-primary at 50% opacity
- Padding: 4px 12px
- Radius: 12px
- Icon: Arrow Up (12px, brand-primary)
- Text: "+4,4% acima"
- Style: Label/M, brand-primary, Semibold

**Mini Trend Line:**
- Height: 48px
- Margin Top: 12px
- Type: Line chart (last 30 days)
- Line Color: grain-soy
- Area Fill: grain-soy at 20% opacity
- Shows upward trend

---

### 3. MAIN CONTENT (Silo Visualization + Market Data)
**Position:** Below Storage Overview, 24px margin top
**Layout:** 2 Columns - 60% Left | 40% Right
**Gap:** 24px

---

### 3.1 LEFT COLUMN: Silo Visual Inventory

**Card: Storage Silos**
**Layout:** Glassmorphism Card, 24px padding
**Height:** 520px

**Header:**
- Text: "Armazenagem - Capacidade dos Silos"
- Style: Heading/L
- Margin Bottom: 20px

**Silo Grid:**
- Layout: 4 silos in horizontal row
- Gap: 32px
- Alignment: Bottom (silos sit on baseline)

---

**Silo Illustration Template:**

**Silo Structure (SVG-style):**

**Base Dimensions:**
- Width: 140px
- Total Height: 360px

**Components:**

1. **Dome Top:**
   - Shape: Semi-circle or cone
   - Width: 140px
   - Height: 40px
   - Fill: Linear gradient (zinc-700 to zinc-800)
   - Stroke: 2px solid zinc-600

2. **Cylinder Body:**
   - Shape: Rectangle with vertical lines (corrugated metal effect)
   - Width: 140px
   - Height: 280px
   - Fill: zinc-800
   - Stroke: 2px solid zinc-700
   - Details: Vertical lines every 20px (zinc-700)

3. **Base/Foundation:**
   - Shape: Trapezoid or rectangle
   - Width: 140px (top) to 150px (bottom)
   - Height: 40px
   - Fill: zinc-900
   - Stroke: 2px solid zinc-700

**Liquid Fill Effect:**

**Fill Container:**
- Position: Inside cylinder body
- Width: 134px (6px margin from edges)
- Height: Variable based on fill %
- Alignment: Bottom

**Fill Gradient:**
- Type: Linear gradient (vertical)
- Top Color: Grain color at 80% opacity
- Bottom Color: Grain color at 100% opacity
- Add subtle shine effect on left side (white at 10% opacity)

**Wave Effect (Top of liquid):**
- SVG path creating gentle wave
- Amplitude: 4px
- Frequency: 2-3 waves across width
- Color: Slightly brighter than fill

**Fill Level Indicator:**
- Position: Right side of silo, aligned with liquid top
- Type: Horizontal line + text
- Line: 2px, grain color
- Text: Fill percentage (e.g., "86%")
- Style: Body/Number/M, grain color, Bold
- Background: grain color at 20% opacity, padding 4px 8px

**Silo Label (Top):**
- Position: Above dome
- Background: bg-surface
- Border: 1px solid grain color at 30% opacity
- Padding: 8px 12px
- Radius: 6px

**Content:**
- **Name:** "Silo 1" or "Silo A"
- Style: Label/M, text-primary, Semibold
- **Type:** "Soja" or "Milho"
- Style: Label/S, grain color

**Tonnage Overlay (Center of liquid):**
- Position: Vertically centered in liquid fill
- Background: Semi-transparent overlay (black at 40% opacity)
- Padding: 8px 16px
- Radius: 8px

**Content:**
- **Amount:** "3.200"
- Style: Body/Number/L, white, Bold
- **Unit:** "toneladas"
- Style: Label/M, white

**Capacity Footer (Below silo):**
- Text: "Cap: 4.500 t"
- Style: Label/S, text-muted
- Alignment: Center

---

**Sample Silo 1: Soja (High Fill)**
- Name: "Silo A - Soja"
- Fill Level: 86%
- Fill Color: grain-soy gradient
- Current: 3.200 t
- Capacity: 4.500 t
- Status: Near full (green indicator)

**Sample Silo 2: Soja (Medium Fill)**
- Name: "Silo B - Soja"
- Fill Level: 62%
- Fill Color: grain-soy gradient
- Current: 2.800 t
- Capacity: 4.500 t

**Sample Silo 3: Milho (Medium Fill)**
- Name: "Silo C - Milho"
- Fill Level: 58%
- Fill Color: grain-corn gradient
- Current: 2.320 t
- Capacity: 4.000 t

**Sample Silo 4: Milho (Low Fill)**
- Name: "Silo D - Milho"
- Fill Level: 34%
- Fill Color: grain-corn gradient
- Current: 1.360 t
- Capacity: 4.000 t
- Status: Low (amber indicator)

---

### 3.2 RIGHT COLUMN: Market Intelligence

**Card 1: Market Ticker (Live Prices)**
**Layout:** Market Card, 20px padding
**Height:** 280px
**Border:** 1px solid grain-soy at 30% opacity

**Header:**
- Layout: Horizontal, Space Between
- **Title:** "Cotações de Mercado"
- Style: Heading/L
- **Live Badge:**
  - Dot: 6×6px, brand-primary, pulsing
  - Text: "AO VIVO"
  - Style: Label/S, brand-primary

**Market Data Grid:**
- Gap: 16px

---

**Market Item Template:**

**Item Layout:**
- Background: bg-surface
- Border Bottom: 1px solid zinc-800
- Padding: 16px
- Layout: Horizontal, Space Between

**Left Side:**
- **Commodity Name:**
  - Icon: Grain icon (16px, grain color)
  - Text: "Soja (CBOT Chicago)"
  - Style: Body/Text/M, text-primary

**Right Side (Metrics):**
- Layout: Vertical, Right aligned

**Price Row:**
- **Current Price:** "$13.85"
- Style: Ticker/Price, grain-soy, Bold
- **Currency:** "/bushel"
- Style: Label/S, text-muted

**Change Row:**
- Layout: Horizontal, gap 8px
- **Icon:** Arrow Up or Down (12px)
- **Change:** "+$0.24"
- **Percentage:** "(+1.77%)"
- Style: Label/M, brand-primary (positive) or brand-danger (negative)

---

**Sample Market Items:**

**1. Soja CBOT (Chicago)**
- Price: $13.85/bushel
- Change: +$0.24 (+1.77%)
- Color: brand-primary (positive)
- Icon: Arrow Up

**2. Soja B3 (Brasil)**
- Price: R$ 148,20/saca
- Change: +R$ 3.10 (+2.14%)
- Color: brand-primary

**3. Milho CBOT (Chicago)**
- Price: $4.92/bushel
- Change: -$0.08 (-1.60%)
- Color: brand-danger (negative)
- Icon: Arrow Down

**4. Milho B3 (Brasil)**
- Price: R$ 72,40/saca
- Change: -R$ 1.20 (-1.63%)
- Color: brand-danger

**5. Dólar (USD/BRL)**
- Price: R$ 5,48
- Change: +R$ 0.05 (+0.92%)
- Color: brand-primary

---

**Farm Average Price Comparison (Below Market Data):**
- Margin Top: 16px
- Background: brand-info at 10% opacity
- Border: 1px solid brand-info at 30% opacity
- Padding: 12px
- Radius: 6px

**Content:**
- Icon: Info Circle (14px, brand-info)
- Text: "Preço médio fixado: R$ 148,20 vs Mercado: R$ 148,20"
- Style: Label/M, text-primary
- Subtext: "Venda estratégica em ponto ótimo"
- Style: Label/S, brand-primary

---

**Card 2: Logistics Queue**
**Layout:** Glassmorphism Card, 20px padding
**Height:** 216px
**Margin Top:** 24px

**Header:**
- Text: "Fila de Carregamento"
- Style: Heading/L
- Margin Bottom: 12px

**Summary Metrics:**
- Layout: Horizontal, Space Between
- Margin Bottom: 16px

**Metric 1:**
- Icon: Truck (16px, grain-soy)
- Label: "Caminhões na Fila"
- Value: "8"
- Style: Body/Number/L, grain-soy

**Metric 2:**
- Icon: Calendar (16px, text-secondary)
- Label: "Agendados Hoje"
- Value: "12"
- Style: Body/Number/M, text-secondary

**Truck Queue List:**
- Layout: Vertical stack
- Gap: 8px
- Max visible: 3 items
- Scrollable if more

---

**Truck Item Template:**

**Item Layout:**
- Background: bg-surface
- Border Left: 3px solid grain color (soy/corn)
- Padding: 12px
- Radius: 6px

**Content Layout:** Horizontal, Space Between

**Left Side:**
- **Truck ID:** "Caminhão #JKL-5847"
  - Style: Body/Text/M, text-primary, Semibold
- **Commodity:** "Soja" + Dot (6px, grain-soy)
  - Style: Label/S, text-secondary

**Right Side:**
- **Tonnage:** "28 t"
  - Style: Body/Number/S, text-primary
- **Status:** "Carregando..."
  - Style: Label/S, grain-soy
  - Icon: Loading spinner (12px)

---

**Sample Truck Items:**

**1. Truck #JKL-5847**
- Commodity: Soja
- Amount: 28 t
- Status: "Carregando..." (active)
- Border: grain-soy

**2. Truck #MNO-3421**
- Commodity: Milho
- Amount: 25 t
- Status: "Aguardando" (queued)
- Border: grain-corn

**3. Truck #PQR-8965**
- Commodity: Soja
- Amount: 30 t
- Status: "Aguardando"
- Border: grain-soy

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Silo Visualization First:** The realistic silo illustrations are the focal point
2. **Market Data Prominence:** Live prices with clear positive/negative indicators
3. **Spatial Clarity:** Clean layouts with generous spacing
4. **Grain Color Coding:** Consistent use of yellow (soy) and orange (corn)

### Silo Design Principles
- **Realistic Proportions:** Silos should look authentic, not cartoonish
- **Liquid Fill Effect:** Smooth gradients with subtle wave animation
- **Corrugated Metal Texture:** Vertical lines suggest industrial storage
- **Clear Metrics:** Tonnage and capacity always visible

### Market Data Clarity
- **Real-time Feel:** Pulsing indicators for live data
- **Color Coding:** Green for gains, red for losses
- **Multiple Sources:** Show both international (Chicago) and local (B3) prices
- **Farm Comparison:** Always compare market price to farm's average fixed price

### Color Psychology
- **Yellow/Gold:** Soybean, wealth, harvest
- **Orange:** Corn, energy
- **Green:** Positive market movement, good decisions
- **Red:** Negative movement, caution

### Spacing System
- Use multiples of 4px for all spacing
- Generous spacing between silos (32px)
- Card padding: 20-24px
- Section gaps: 24px

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Grain_Inventory_2x.png`
- Export silo component as reusable SVG with fill mask
- Export market ticker component
- Export half-circle gauge as component
- Export truck queue item component

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_05_Grain_Inventory.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with live market badge
- [ ] Build 3 top cards (Total Inventory, Gauge, Price)
- [ ] Design half-circle commercialization gauge
- [ ] Create 4 realistic silo illustrations with liquid fill
- [ ] Add corrugated metal texture to silos
- [ ] Implement wave effect on liquid top
- [ ] Build market ticker with 5 price items
- [ ] Add live indicator animations (pulsing dots)
- [ ] Create logistics truck queue with 3 items
- [ ] Verify grain color consistency (yellow/orange)
- [ ] Add tonnage overlays to silos
- [ ] Check all spacing follows 4px grid
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 4-5 hours for experienced Figma designer
**Complexity:** Very High (Custom silo illustrations with liquid fill effects, real-time market data layout, gauge component)

---

## 💡 Implementation Notes

### Liquid Fill Animation (Future Implementation)
```
Gentle wave animation on liquid surface:
- Amplitude: 3-5px
- Period: 3 seconds
- Easing: sine wave

Shine effect:
- Subtle white gradient (10% opacity) on left side of liquid
- Simulates light reflection on grain surface
```

### Silo Fill Color Logic
```
IF fill_percentage >= 80 THEN
  indicator_color = storage-full (green)
ELSE IF fill_percentage >= 40 THEN
  indicator_color = storage-medium (amber)
ELSE
  indicator_color = storage-low (red)
```

### Market Price Update Frequency
- Live prices update every 30 seconds (simulated in static mockup)
- Use pulsing animation on "AO VIVO" badge
- Price changes show directional arrows

### Commercialization Strategy Indicator
```
IF farm_average_price > market_price THEN
  strategy = "Venda estratégica em ponto ótimo" (green badge)
ELSE IF farm_average_price < market_price THEN
  strategy = "Mercado acima do fixado - oportunidade perdida" (red badge)
ELSE
  strategy = "Preço equilibrado com mercado" (yellow badge)
```

### Silo Capacity Management
- Alert when silo > 90% full (need to plan sale/transfer)
- Alert when silo < 30% full (inefficient storage usage)
- Optimal range: 40-85% capacity

### Truck Queue Priority
- Active loading (Carregando) = Green indicator
- Waiting in queue (Aguardando) = Yellow indicator
- Delayed (Atrasado) = Red indicator
