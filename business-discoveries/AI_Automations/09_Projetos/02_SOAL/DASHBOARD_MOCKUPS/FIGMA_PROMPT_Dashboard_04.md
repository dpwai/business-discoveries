  # Figma Design Prompt: Dashboard #4 - Maquinário & Diesel Intelligence

  ## 🎯 Design Brief
  Create an operational efficiency dashboard for agricultural fleet management, focused on identifying high-consumption machines and optimizing fuel usage. Target users: Tiago (Operations) and Claudio (Owner). The aesthetic must have a "rugged engineering" feel with technical gauges and industrial iconography - think construction equipment meets precision analytics.

  ---

  ## 📐 Canvas Setup

  ### Frame Specifications
  - **Frame Name:** `Machinery_Diesel_Dashboard`
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
  - `brand-primary`: `#10b981` (Emerald-500) - Efficient, Good Performance
  - `brand-danger`: `#ef4444` (Red-500) - Inefficient, High Consumption
  - `brand-warning`: `#f59e0b` (Amber-500) - Needs Attention, Moderate Issues
  - `agro-yellow`: `#eab308` (Yellow-500) - Construction/Agro Theme
  - `diesel-blue`: `#3b82f6` (Blue-500) - Diesel/Fuel representation

  **Machine Status:**
  - `status-active`: `#10b981` (Emerald-500) - Operating
  - `status-maintenance`: `#f59e0b` (Amber-500) - In Maintenance
  - `status-idle`: `#71717a` (Zinc-500) - Idle/Parked
  - `status-critical`: `#ef4444` (Red-500) - Critical Issue

  **Manufacturer Colors (for branding):**
  - `brand-john-deere`: `#367c2b` (Green)
  - `brand-case-ih`: `#e41e26` (Red)
  - `brand-new-holland`: `#003087` (Blue)
  - `brand-massey`: `#c8102e` (Red)
  - `brand-valtra`: `#e30613` (Red)

  ### Typography Styles

  **Font Family:** Inter

  - `Heading/XL`: Inter Bold, 30px, Line Height 36px, #f4f4f5
  - `Heading/L`: Inter Semibold, 18px, Line Height 24px, #f4f4f5
  - `Heading/M`: Inter Semibold, 14px, Line Height 20px, #a1a1aa
  - `Heading/S`: Inter Semibold, 12px, Line Height 16px, #a1a1aa
  - `Body/Number/XL`: Inter Bold, 32px, Line Height 40px, #f4f4f5
  - `Body/Number/L`: Inter Bold, 24px, Line Height 32px, #f4f4f5
  - `Body/Number/M`: Inter Semibold, 16px, Line Height 24px, #f4f4f5
  - `Body/Number/S`: Inter Semibold, 14px, Line Height 20px, #f4f4f5
  - `Body/Text/M`: Inter Regular, 14px, Line Height 20px, #f4f4f5
  - `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
  - `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b
  - `Mono/M`: Inter Mono, 14px, Line Height 20px, #f4f4f5 (for technical data)

  ### Component Styles

  **Glassmorphism Card:**
  - Fill: `#18181b` at 80% opacity
  - Border: 1px solid `#ffffff` at 10% opacity
  - Corner Radius: 12px
  - Effect: Background Blur 10px

  **Technical Panel (Variant):**
  - Fill: `#18181b`
  - Border: 1px solid `#eab308` at 20% opacity (yellow industrial accent)
  - Corner Radius: 8px
  - Inner Shadow: Subtle

  ---

  ## 📦 Layout Structure (Top to Bottom)

  ### 1. HEADER SECTION
  **Position:** Top, Full Width
  **Height:** 88px
  **Layout:** Horizontal, Space Between

  #### Left Side: Title Block
  - **Main Title:** "Gestão de Maquinário"
    - Style: Heading/XL
    - Color: text-primary
  - **Subtitle:** "Machinery & Fuel Intelligence Dashboard"
    - Style: Label/M
    - Color: text-secondary
    - Margin Top: 4px

  #### Right Side: Controls
  **Layout:** Horizontal, Gap 12px

  **Element 1: Time Period**
  - Background: Glassmorphism Card
  - Padding: 10px 16px
  - Text: "Últimos 7 dias"
  - Style: Body/Number/S
  - Icon: Calendar (16px)

  **Element 2: Fleet Filter**
  - Background: Glassmorphism Card
  - Padding: 10px 16px
  - Text: "Todas Máquinas"
  - Style: Body/Number/S
  - Icon: Filter (16px)

  **Element 3: Export Report**
  - Background: agro-yellow at 15% opacity
  - Border: 1px solid agro-yellow at 40% opacity
  - Padding: 10px 20px
  - Text: "Relatório"
  - Style: Body/Number/S, agro-yellow
  - Icon: Download (16px)

  ---

  ### 2. FLEET STATUS HEADER (KPI Strip)
  **Position:** Below Header, 32px margin top
  **Layout:** Horizontal, 4 equal sections, no gaps (connected design)
  **Total Height:** 100px

  **Design Style:** Connected status bar with dividers

  ---

  #### Section 1: Total Machines
  **Base:** Background: bg-surface
  **Border Right:** 1px solid zinc-800

  **Content:**
  - **Icon:** Tractor (32px, agro-yellow)
    - Position: Top center or left
  - **Value:** "12"
    - Style: Body/Number/XL, text-primary
    - Position: Center
  - **Label:** "Total de Máquinas"
    - Style: Label/M, text-secondary
    - Position: Below value

  ---

  #### Section 2: Active
  **Base:** Background: bg-surface with status-active glow (subtle)
  **Border Right:** 1px solid zinc-800

  **Content:**
  - **Icon:** Engine/Cog spinning (32px, status-active)
  - **Value:** "9"
    - Style: Body/Number/XL, status-active
  - **Label:** "Em Operação"
    - Style: Label/M, text-secondary

  ---

  #### Section 3: Maintenance
  **Base:** Background: bg-surface
  **Border Right:** 1px solid zinc-800

  **Content:**
  - **Icon:** Wrench (32px, status-maintenance)
  - **Value:** "2"
    - Style: Body/Number/XL, status-maintenance
  - **Label:** "Em Manutenção"
    - Style: Label/M, text-secondary
  - **Alert Badge:**
    - Small red dot (6×6px) if critical maintenance
    - Position: Top right of icon

  ---

  #### Section 4: Idle
  **Base:** Background: bg-surface

  **Content:**
  - **Icon:** Pause Circle (32px, status-idle)
  - **Value:** "1"
    - Style: Body/Number/XL, status-idle
  - **Label:** "Parado/Ocioso"
    - Style: Label/M, text-secondary

  ---

  ### 3. MAIN CONTENT GRID (2 Columns)
  **Position:** Below Fleet Status, 24px margin top
  **Layout:** 65% Left / 35% Right
  **Gap:** 24px

  ---

  ### 3.1 LEFT COLUMN: Efficiency Analysis

  **Card: Efficiency Scatter Plot**
  **Layout:** Glassmorphism Card, 24px padding
  **Height:** 480px

  **Header:**
  - Text: "Análise de Eficiência - Consumo vs Utilização"
    - Style: Heading/L
    - Margin Bottom: 20px

  **Subheader:**
  - Text: "Identifique máquinas com alto consumo e alta utilização (quadrante superior direito)"
    - Style: Label/M, text-secondary
    - Margin Bottom: 16px

  **Scatter Plot Chart:**

  **Dimensions:**
  - Width: Full card width minus padding
  - Height: 360px

  **Axes:**

  **X-Axis: Hours Worked (Horas Trabalhadas)**
  - Range: 0h to 80h (last 7 days)
  - Labels: 0, 20, 40, 60, 80
  - Style: Label/M, text-muted
  - Grid Lines: Vertical, zinc-800 at 15% opacity

  **Y-Axis: Liters per Hour (L/h)**
  - Range: 0 to 30 L/h
  - Labels: 0, 10, 20, 30
  - Style: Label/M, text-muted
  - Grid Lines: Horizontal, zinc-800 at 15% opacity

  **Quadrant Zones (Background overlays):**

  1. **Bottom Left (Low Usage, Low Consumption):**
    - Fill: zinc-800 at 5% opacity
    - Label: "Subutilizado" - Label/S, text-muted
    - Position: Corner of quadrant

  2. **Bottom Right (High Usage, Low Consumption):**
    - Fill: status-active at 10% opacity
    - Label: "IDEAL" - Label/S, status-active, Semibold
    - Icon: Star (12px)

  3. **Top Left (Low Usage, High Consumption):**
    - Fill: status-warning at 8% opacity
    - Label: "Ineficiente" - Label/S, status-warning

  4. **Top Right (High Usage, High Consumption):**
    - Fill: status-critical at 10% opacity
    - Label: "CRÍTICO" - Label/S, status-critical, Semibold
    - Icon: Alert Triangle (12px)

  **Data Points (Machine Bubbles):**

  **Bubble Design:**
  - Size: 40-60px diameter (proportional to total fuel cost)
  - Fill: Manufacturer brand color at 40% opacity
  - Border: 2px solid manufacturer color
  - Center Icon: Machine type icon (16px, white)
  - Label Below: Machine ID (e.g., "8R-04")
  - Hover Tooltip: Full details

  **Sample Data Points:**

  1. **John Deere 8R-04 (CRITICAL)**
    - Position: (72h, 26 L/h) - Top right quadrant
    - Size: 60px (high cost)
    - Color: brand-john-deere
    - Border: 2px solid brand-danger (alert)
    - Icon: Tractor
    - Label: "8R-04"

  2. **Case IH 340 (IDEAL)**
    - Position: (68h, 18 L/h) - Bottom right quadrant
    - Size: 56px
    - Color: brand-case-ih
    - Border: 2px solid brand-primary
    - Label: "C-340"

  3. **New Holland T7 (Inefficient)**
    - Position: (24h, 24 L/h) - Top left quadrant
    - Size: 44px
    - Color: brand-new-holland
    - Border: 2px solid brand-warning
    - Label: "T7-02"

  4. **Massey 7415 (Underutilized)**
    - Position: (18h, 14 L/h) - Bottom left
    - Size: 40px
    - Color: brand-massey
    - Label: "MF-15"

  **Legend:**
  - Position: Bottom right of chart
  - Layout: Vertical stack

  **Items:**
  - Green Dot + "Eficiente (< 20 L/h)"
  - Yellow Dot + "Moderado (20-25 L/h)"
  - Red Dot + "Crítico (> 25 L/h)"

  ---

  ### 3.2 RIGHT COLUMN: Fuel Tank Telemetry

  **Card: Fuel Storage Status**
  **Layout:** Technical Panel style, 24px padding
  **Height:** 480px

  **Header:**
  - Text: "Tanques de Combustível"
    - Style: Heading/L
    - Margin Bottom: 20px

  **Tank Visualization:**

  **Main Tank (Diesel S10):**

  **Tank Gauge (Large):**
  - Type: Vertical tank illustration
  - Width: 100% of card
  - Height: 280px

  **Tank Structure:**
  - Outer Container: Rectangle with rounded bottom (radius 12px)
  - Border: 2px solid diesel-blue at 40% opacity
  - Background: bg-surface-highlight

  **Liquid Fill:**
  - Fill Level: 68% (from bottom)
  - Color: Gradient from diesel-blue (bottom) to diesel-blue at 60% opacity (top)
  - Animation: Subtle wave effect on top surface (optional)

  **Capacity Markers (Right side):**
  - Lines at 25%, 50%, 75%, 100%
  - Labels: "25k L", "50k L", "75k L", "100k L"
  - Style: Label/S, text-muted
  - Current Level Indicator:
    - Arrow pointing to fill level
    - Text: "68.000 L" - Body/Number/M, diesel-blue, Bold
    - Background: diesel-blue at 20% opacity
    - Padding: 4px 8px

  **Tank Info Panel (Below Tank):**
  - Background: bg-surface
  - Padding: 16px
  - Border Top: 1px solid zinc-800

  **Data Grid (2 columns):**

  **Left Column:**
  - **Label:** "Capacidade Total"
    - Value: "100.000 L"
    - Style: Body/Number/M, text-primary

  - **Label:** "Consumo Médio/Dia"
    - Value: "8.400 L"
    - Style: Body/Number/M, text-secondary

  **Right Column:**
  - **Label:** "Disponível"
    - Value: "68.000 L"
    - Style: Body/Number/M, diesel-blue

  - **Label:** "Autonomia"
    - Value: "8,1 dias"
    - Style: Body/Number/M, agro-yellow
    - Icon: Clock (14px)

  **Alert Section:**
  - Margin Top: 12px
  - Background: brand-warning at 10% opacity
  - Border: 1px solid brand-warning at 30% opacity
  - Padding: 12px
  - Radius: 6px

  **Content:**
  - Icon: Alert Triangle (16px, brand-warning)
  - Text: "Próximo abastecimento programado para 05/02/26"
  - Style: Label/M, text-primary

  ---

  ### 4. FLEET GRID (Machine Cards)
  **Position:** Below Main Content Grid, 24px margin top
  **Layout:** Grid, 4 columns, gap 20px
  **Card Size:** Auto height

  ---

  **Machine Card Template:**

  **Card Base:**
  - Width: Full column width
  - Height: 320px
  - Background: Glassmorphism Card
  - Padding: 0 (image fills top)

  **Machine Photo Header:**
  - Height: 140px
  - Background: Gradient from manufacturer color to black
  - Image: Machine photo (tractor silhouette or actual photo)
  - Overlay: Gradient overlay for text readability

  **Top Badge (Status):**
  - Position: Top right, 12px inset
  - Size: Auto width, 24px height
  - Padding: 4px 12px
  - Radius: 12px
  - Font: Label/S, Semibold

  **Status Variants:**
  1. **Active:**
    - Background: status-active
    - Text: "OPERANDO" - White
    - Icon: Circle (pulsing) 6px

  2. **Maintenance:**
    - Background: status-maintenance
    - Text: "MANUTENÇÃO" - White
    - Icon: Wrench 12px

  3. **Idle:**
    - Background: status-idle
    - Text: "PARADO" - White

  **Machine ID (on photo):**
  - Position: Bottom left of photo, 12px inset
  - Text: "John Deere 8R-04"
  - Style: Body/Number/M, white, Semibold
  - Shadow: Text shadow for readability

  **Card Body:**
  - Padding: 16px
  - Background: bg-surface

  **Info Grid (2 rows × 2 columns):**
  - Gap: 12px

  **Metric 1: Horas Trabalhadas**
  - Icon: Clock (14px, text-muted)
  - Label: "Horas (7d)"
  - Value: "72h"
  - Style: Body/Number/M, text-primary

  **Metric 2: Consumo Médio**
  - Icon: Fuel Pump (14px, text-muted)
  - Label: "Consumo Médio"
  - Value: "26 L/h"
  - Style: Body/Number/M, brand-danger (high consumption)

  **Metric 3: Operador**
  - Icon: User (14px, text-muted)
  - Label: "Operador"
  - Value: "João Silva"
  - Style: Body/Text/M, text-secondary

  **Metric 4: Localização**
  - Icon: Map Pin (14px, text-muted)
  - Label: "Local Atual"
  - Value: "Talhão 12 - Retiro 2"
  - Style: Body/Text/M, text-secondary

  **Fuel Level Gauge:**
  - Position: Bottom of card
  - Margin Top: 16px
  - Height: 8px
  - Background: zinc-800
  - Fill: Gradient based on level
    - Green (>50%): brand-primary
    - Yellow (25-50%): brand-warning
    - Red (<25%): brand-danger
  - Current Level: 85%
  - Label Above: "Tanque: 85%" - Label/S, text-primary

  **Efficiency Score Badge:**
  - Position: Bottom right, absolute
  - Size: 52×52px circle
  - Background: Gradient based on score
    - Excellent (>90): brand-primary
    - Good (75-90): agro-yellow
    - Poor (<75): brand-danger
  - Border: 3px solid same color
  - Center Text:
    - Score: "92%" - Body/Number/M, white, Bold
    - Label: "Score" - Label/S, white

  ---

  **Sample Machine Card 1: John Deere 8R-04 (CRITICAL)**

  - Photo: John Deere tractor, green gradient overlay
  - Status Badge: "OPERANDO" (green, pulsing)
  - ID: "John Deere 8R-04"
  - Horas: "72h"
  - Consumo: "26 L/h" (RED - critical)
  - Operador: "João Silva"
  - Local: "Talhão 12 - Retiro 2"
  - Fuel Level: 85% (green)
  - Efficiency Score: 68% (red circle - poor)

  ---

  **Sample Machine Card 2: Case IH 340 (IDEAL)**

  - Photo: Case IH tractor, red gradient
  - Status Badge: "OPERANDO" (green)
  - ID: "Case IH 340"
  - Horas: "68h"
  - Consumo: "18 L/h" (GREEN - efficient)
  - Operador: "Pedro Santos"
  - Local: "Talhão 8 - Santana"
  - Fuel Level: 72%
  - Efficiency Score: 94% (green circle - excellent)

  ---

  **Sample Machine Card 3: New Holland T7-02 (MAINTENANCE)**

  - Photo: New Holland tractor, blue gradient
  - Status Badge: "MANUTENÇÃO" (amber)
  - ID: "New Holland T7-02"
  - Horas: "0h" (last 7 days)
  - Consumo: "-" (not operating)
  - Operador: "N/A"
  - Local: "Oficina Mecânica"
  - Fuel Level: 45% (yellow)
  - Efficiency Score: "-"

  ---

  **Sample Machine Card 4: Massey Ferguson 7415**

  - Photo: Massey Ferguson, red gradient
  - Status Badge: "PARADO" (grey)
  - ID: "Massey Ferguson 7415"
  - Horas: "18h"
  - Consumo: "14 L/h" (GREEN)
  - Operador: "Carlos Lima"
  - Local: "Garagem - Retiro 2"
  - Fuel Level: 92%
  - Efficiency Score: 88% (yellow - good)

  ---

  ## 🎯 Design Guidelines

  ### Visual Hierarchy
  1. **Status First:** Color-coded status badges immediately show machine state
  2. **Efficiency Focus:** Scatter plot is the primary decision-making tool
  3. **Technical Precision:** Gauges and metrics use exact values, not approximations
  4. **Fuel Urgency:** Tank levels and consumption rates prominently displayed

  ### Industrial Design Language
  - **Rugged Elements:** Industrial borders with yellow accents
  - **Technical Icons:** Use mechanical/engineering iconography
  - **Manufacturer Branding:** Respect brand colors (John Deere green, Case red, etc.)
  - **Gauge Design:** Analog-inspired digital gauges for fuel and efficiency

  ### Color Coding Logic
  - **Green:** Efficient operation, good performance
  - **Yellow/Amber:** Attention needed, moderate issues
  - **Red:** Critical, high consumption, requires action
  - **Brand Colors:** Maintain manufacturer identity

  ### Spacing System
  - Use multiples of 4px for all spacing
  - Card padding: 16-24px
  - Grid gaps: 20px
  - Section gaps: 24px

  ---

  ## 📤 Export Settings

  **For Development Handoff:**
  - Export entire frame as PNG @2x: `Machinery_Diesel_2x.png`
  - Export machine card component with all states
  - Export fuel tank gauge as reusable SVG
  - Export efficiency score badge component
  - Export scatter plot with quadrant zones

  **For Presentation:**
  - Export as PDF: `SOAL_Dashboard_04_Machinery.pdf`

  ---

  ## ✅ Checklist

  - [ ] Set up 1920×1080 frame with #09090b background
  - [ ] Create header with title and controls
  - [ ] Build fleet status KPI strip (4 sections connected)
  - [ ] Create efficiency scatter plot with 4 quadrants
  - [ ] Add 12+ data points to scatter plot
  - [ ] Design fuel tank vertical gauge with fill animation
  - [ ] Build machine card component (4 variants minimum)
  - [ ] Create 12 machine cards in 4×3 grid
  - [ ] Add manufacturer brand colors to cards
  - [ ] Design efficiency score circular badge
  - [ ] Add fuel level horizontal gauge
  - [ ] Verify industrial aesthetic with yellow accents
  - [ ] Check all spacing follows 4px grid
  - [ ] Export mockup at 2x resolution

  ---

  **Estimated Time:** 4-5 hours for experienced Figma designer
  **Complexity:** Very High (Custom scatter plot with quadrants, machine cards with photos, gauges, manufacturer branding)

  ---

  ## 💡 Implementation Notes

  ### Efficiency Score Calculation
  ```
  efficiency_score = (average_consumption_baseline / actual_consumption) × 100
  IF score >= 90 THEN status = "Excellent" (green)
  ELSE IF score >= 75 THEN status = "Good" (yellow)
  ELSE status = "Poor" (red)
  ```

  ### Scatter Plot Quadrant Thresholds
  - **X-Axis (Hours Worked):** Low < 40h, High >= 40h
  - **Y-Axis (L/h):** Efficient < 20 L/h, Inefficient >= 20 L/h

  ### Fuel Tank Autonomy Calculation
  ```
  autonomy_days = current_volume / average_daily_consumption
  IF autonomy_days < 3 THEN alert = "CRITICAL"
  ELSE IF autonomy_days < 7 THEN alert = "WARNING"
  ```

  ### Machine Photo Guidelines
  - Use high-contrast silhouettes if actual photos unavailable
  - Apply gradient overlay (manufacturer color to 60% black) for text readability
  - Maintain consistent aspect ratio across all cards

  ### Critical Machine Indicators
  On scatter plot, add red border (3px) to bubbles with:
  - Consumption > 25 L/h AND Hours > 60h
  - These are priority candidates for inspection
