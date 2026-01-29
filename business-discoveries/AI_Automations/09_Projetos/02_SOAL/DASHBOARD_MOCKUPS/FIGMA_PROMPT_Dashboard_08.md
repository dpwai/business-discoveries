  # Figma Design Prompt: Dashboard #8 - Programação de Compras (Purchasing Programming)

  ## 🎯 Design Brief
  Create a process-oriented purchasing management dashboard focused on optimizing cash flow versus operational needs. Target user: Valentina (Financial/Admin). The aesthetic must be clean with distinct status colors - think project management meets procurement workflow, with emphasis on approval processes and price tracking.

  ---

  ## 📐 Canvas Setup

  ### Frame Specifications
  - **Frame Name:** `Purchasing_Programming_Dashboard`
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
  - `brand-primary`: `#10b981` (Emerald-500) - Approved, Completed
  - `brand-danger`: `#ef4444` (Red-500) - Rejected, Urgent
  - `brand-warning`: `#f59e0b` (Amber-500) - Pending Approval
  - `brand-info`: `#3b82f6` (Blue-500) - In Process

  **Kanban Status Colors:**
  - `status-request`: `#71717a` (Zinc-500) - Request
  - `status-quotation`: `#3b82f6` (Blue-500) - Quotation
  - `status-approval`: `#f59e0b` (Amber-500) - Awaiting Approval
  - `status-ordered`: `#8b5cf6` (Violet-500) - Ordered
  - `status-received`: `#10b981` (Emerald-500) - Received

  **Priority Colors:**
  - `priority-urgent`: `#ef4444` (Red-500)
  - `priority-high`: `#f59e0b` (Amber-500)
  - `priority-normal`: `#3b82f6` (Blue-500)
  - `priority-low`: `#71717a` (Zinc-500)

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

  **Kanban Card:**
  - Fill: `#18181b`
  - Border: 1px solid `#27272a`
  - Border Left: 3px solid status color (accent)
  - Corner Radius: 8px
  - Shadow: Subtle (0px 2px 8px rgba(0,0,0,0.2))
  - Hover: Lift effect (shadow increase)

  ---

  ## 📦 Layout Structure (Top to Bottom)

  ### 1. HEADER SECTION
  **Position:** Top, Full Width
  **Height:** 88px
  **Layout:** Horizontal, Space Between

  #### Left Side: Title Block
  - **Main Title:** "Programação de Compras"
    - Style: Heading/XL
    - Color: text-primary
  - **Subtitle:** "Purchasing Planning & Approval Workflow"
    - Style: Label/M
    - Color: text-secondary
    - Margin Top: 4px

  #### Right Side: Controls
  **Layout:** Horizontal, Gap 12px

  **Element 1: Filter Dropdown**
  - Background: Glassmorphism Card
  - Padding: 10px 16px
  - Text: "Todas as Prioridades"
  - Style: Body/Number/S
  - Icon: Filter (16px)

  **Element 2: Date Range**
  - Background: Glassmorphism Card
  - Padding: 10px 16px
  - Text: "Este Mês"
  - Style: Body/Number/S
  - Icon: Calendar (16px)

  **Element 3: New Request Button**
  - Background: brand-primary
  - Padding: 10px 20px
  - Text: "Nova Solicitação"
  - Style: Body/Number/S, white
  - Icon: Plus (16px)

  ---

  ### 2. METRICS STRIP
  **Position:** Below Header, 32px margin top
  **Layout:** 5 Cards, Equal Width, Gap 16px
  **Card Height:** 120px

  ---

  **Metric Card Template:**
  - Background: Glassmorphism Card
  - Padding: 16px
  - Border Top: 3px solid status color

  ---

  #### CARD 1: Requests

  **Border Top:** status-request (zinc)

  **Content:**
  - **Icon:** File Text (20px, status-request)
  - **Value:** "8"
    - Style: Body/Number/XL, status-request
  - **Label:** "Solicitações"
    - Style: Label/M, text-secondary
  - **Amount:** "R$ 280K"
    - Style: Body/Number/S, text-muted

  ---

  #### CARD 2: Quotation

  **Border Top:** status-quotation (blue)

  **Content:**
  - **Icon:** Search (20px, status-quotation)
  - **Value:** "12"
    - Style: Body/Number/XL, status-quotation
  - **Label:** "Em Cotação"
    - Style: Label/M, text-secondary
  - **Amount:** "R$ 485K"
    - Style: Body/Number/S, text-muted

  ---

  #### CARD 3: Approval Queue (HIGHLIGHTED)

  **Border Top:** status-approval (amber)
  **Background:** status-approval at 5% opacity (subtle highlight)

  **Content:**
  - **Icon:** Clock (20px, status-approval)
  - **Value:** "5"
    - Style: Body/Number/XL, status-approval, Bold
  - **Label:** "Aguardando Aprovação"
    - Style: Label/M, text-secondary, Bold
  - **Amount:** "R$ 340K"
    - Style: Body/Number/S, text-primary
  - **Alert Badge:**
    - Position: Top right
    - Size: 20×20px circle
    - Fill: status-approval
    - Text: "!" - white, bold

  ---

  #### CARD 4: Ordered

  **Border Top:** status-ordered (violet)

  **Content:**
  - **Icon:** Package (20px, status-ordered)
  - **Value:** "15"
    - Style: Body/Number/XL, status-ordered
  - **Label:** "Pedidos Enviados"
    - Style: Label/M, text-secondary
  - **Amount:** "R$ 920K"
    - Style: Body/Number/S, text-muted

  ---

  #### CARD 5: Received

  **Border Top:** status-received (emerald)

  **Content:**
  - **Icon:** Check Circle (20px, status-received)
  - **Value:** "23"
    - Style: Body/Number/XL, status-received
  - **Label:** "Recebidos (mês)"
    - Style: Label/M, text-secondary
  - **Amount:** "R$ 1,2M"
    - Style: Body/Number/S, text-muted

  ---

  ### 3. MAIN CONTENT: Kanban Board + Approval Queue
  **Position:** Below Metrics Strip, 24px margin top
  **Layout:** Full Width

  ---

  ### 3.1 APPROVAL QUEUE (Top Priority Section)

  **Section Header:**
  - Background: status-approval at 10% opacity
  - Border: 1px solid status-approval at 30% opacity
  - Padding: 16px 20px
  - Radius: 8px 8px 0 0
  - Margin Bottom: 0 (connects to cards below)

  **Content:**
  - Layout: Horizontal, Space Between

  **Left:**
  - Icon: Alert Triangle (20px, status-approval)
  - Text: "Fila de Aprovação - Ação Requerida"
  - Style: Heading/L, text-primary

  **Right:**
  - Text: "5 itens aguardando | Total: R$ 340.000"
  - Style: Body/Number/S, status-approval

  ---

  **Approval Cards Container:**
  - Background: bg-surface
  - Border: 1px solid status-approval at 20% opacity
  - Padding: 20px
  - Radius: 0 0 8px 8px
  - Margin Bottom: 24px

  **Layout:** Horizontal scroll, gap 16px
  **Card Width:** 360px (fixed)

  ---

  **Approval Card Template:**

  **Base:**
  - Background: Glassmorphism Card
  - Border: 1px solid status-approval at 40% opacity
  - Border Left: 4px solid priority color
  - Padding: 20px
  - Radius: 8px
  - Shadow: 0 4px 12px rgba(0,0,0,0.15)

  **Header Row:**
  - Layout: Horizontal, Space Between

  **Left:**
  - **Request ID:** "#PUR-2026-0142"
    - Style: Mono/S, text-secondary
    - Background: bg-surface-highlight
    - Padding: 4px 8px
    - Radius: 4px

  **Right:**
  - **Priority Badge:**
    - Background: priority color at 20%
    - Border: 1px solid priority color
    - Text: "URGENTE"
    - Style: Label/S, priority color, Bold
    - Padding: 4px 10px
    - Radius: 12px

  ---

  **Content Section:**

  **Product/Item:**
  - Text: "Fertilizante NPK 10-10-10"
  - Style: Body/Number/M, text-primary, Semibold
  - Margin Bottom: 8px

  **Supplier:**
  - Icon: Building (14px, text-muted)
  - Text: "Yara Brasil Fertilizantes"
  - Style: Body/Text/S, text-secondary
  - Margin Bottom: 12px

  **Details Grid (2 columns):**

  **Column 1:**
  - **Label:** "Quantidade"
  - **Value:** "50 toneladas"
  - Style Value: Body/Text/M, text-primary

  **Column 2:**
  - **Label:** "Valor Total"
  - **Value:** "R$ 142.500,00"
  - Style Value: Body/Number/M, text-primary, Bold

  **Delivery:**
  - **Label:** "Entrega Solicitada"
  - **Value:** "05/02/2026"
  - Style: Body/Text/S, text-secondary
  - Margin Top: 8px

  ---

  **Price History Sparkline:**
  - Height: 32px
  - Margin: 12px 0
  - Background: bg-surface-highlight
  - Padding: 8px
  - Radius: 4px

  **Mini Line Chart:**
  - Width: 100%
  - Height: 16px
  - Line Color: status-approval
  - Stroke: 2px
  - Area Fill: status-approval at 15%
  - Shows last 6 months price trend

  **Chart Label:**
  - Text: "Histórico de Preço (6m): +12% ↗"
  - Style: Label/S, status-approval
  - Position: Below chart

  ---

  **Requester Info:**
  - Layout: Horizontal, gap 8px
  - Margin Top: 12px
  - Padding Top: 12px
  - Border Top: 1px solid zinc-800

  **Avatar:**
  - Size: 24×24px circle
  - Background: brand-info at 20%
  - Initials: "TS"
  - Style: Label/S, brand-info, Bold

  **Text:**
  - **Name:** "Tiago Silva"
  - **Date:** "Solicitado em 28/01/26"
  - Style: Label/S, text-muted

  ---

  **Action Buttons:**
  - Layout: Horizontal, gap 8px
  - Margin Top: 16px

  **Reject Button:**
  - Background: transparent
  - Border: 1px solid brand-danger
  - Text: "Rejeitar"
  - Style: Body/Text/M, brand-danger
  - Padding: 10px 20px
  - Radius: 6px
  - Icon: X (14px)

  **Approve Button:**
  - Background: brand-primary
  - Text: "Aprovar Compra"
  - Style: Body/Text/M, white, Semibold
  - Padding: 10px 24px
  - Radius: 6px
  - Icon: Check (14px, white)
  - Hover: Brightness 110%

  ---

  **Sample Approval Cards:**

  **Card 1: URGENT (Red Border)**
  - ID: #PUR-2026-0142
  - Priority: URGENTE (red)
  - Product: "Fertilizante NPK 10-10-10"
  - Supplier: "Yara Brasil"
  - Quantity: 50 toneladas
  - Value: R$ 142.500,00
  - Delivery: 05/02/2026
  - Price History: +12% ↗
  - Requester: Tiago Silva

  **Card 2: HIGH (Amber Border)**
  - ID: #PUR-2026-0138
  - Priority: ALTA (amber)
  - Product: "Semente Soja TMG 7063"
  - Supplier: "Tropical Melhoramento"
  - Quantity: 1.200 kg
  - Value: R$ 85.200,00

  **Card 3: NORMAL (Blue Border)**
  - ID: #PUR-2026-0135
  - Priority: NORMAL (blue)
  - Product: "Peças John Deere (Kit Filtros)"
  - Supplier: "John Deere Brasil"
  - Value: R$ 12.800,00

  ---

  ### 3.2 KANBAN BOARD

  **Section Title:**
  - Text: "Pipeline de Compras"
  - Style: Heading/L
  - Margin Bottom: 20px

  **Board Layout:**
  - Type: Horizontal columns
  - Columns: 5 (Request, Quotation, Approval, Ordered, Received)
  - Gap: 20px
  - Scroll: Horizontal if needed

  ---

  **Kanban Column Template:**

  **Column Container:**
  - Width: 280px (fixed)
  - Min Height: 600px
  - Background: bg-surface-highlight
  - Border: 1px solid zinc-800
  - Radius: 8px
  - Padding: 16px

  **Column Header:**
  - Background: status color at 15% opacity
  - Border: 1px solid status color at 30% opacity
  - Padding: 12px 16px
  - Radius: 6px
  - Margin Bottom: 16px

  **Header Content:**
  - **Title:** Column name
    - Style: Body/Number/M, status color, Semibold
  - **Count Badge:**
    - Background: status color
    - Text: Count (e.g., "8")
    - Size: 20×20px circle
    - Style: Label/S, white, Bold
    - Position: Right aligned

  ---

  **Purchase Card (in Column):**

  **Card Base:**
  - Background: Kanban Card style
  - Border Left: 3px solid status color
  - Width: 100%
  - Padding: 16px
  - Margin Bottom: 12px
  - Cursor: Grab (draggable)

  **Card Header:**
  - **ID:** "#PUR-2026-0145"
    - Style: Mono/S, text-muted
    - Margin Bottom: 8px

  **Product:**
  - Text: Product name (truncated if long)
  - Style: Body/Text/M, text-primary, Semibold
  - Margin Bottom: 4px

  **Supplier:**
  - Text: Supplier name
  - Style: Label/M, text-secondary
  - Margin Bottom: 12px

  **Amount:**
  - Text: "R$ 45.800"
  - Style: Body/Number/M, text-primary, Bold
  - Margin Bottom: 8px

  **Priority Badge:**
  - Background: priority color at 20%
  - Text: Priority level
  - Style: Label/S, priority color
  - Padding: 4px 8px
  - Radius: 4px
  - Margin Bottom: 8px

  **Footer:**
  - Layout: Horizontal, Space Between
  - Padding Top: 8px
  - Border Top: 1px solid zinc-800 at 50%

  **Avatar:**
  - Size: 20×20px circle
  - Initials or photo

  **Date:**
  - Text: Time elapsed (e.g., "2 dias")
  - Style: Label/S, text-muted
  - Icon: Clock (12px)

  ---

  **Column 1: Solicitação (Request)**
  - Status Color: status-request (zinc)
  - Count: 8
  - Sample Cards: 3 visible

  **Sample Card:**
  - ID: #PUR-2026-0145
  - Product: "Herbicida Glifosato 480g"
  - Supplier: "Bayer CropScience"
  - Amount: R$ 45.800
  - Priority: Normal
  - Requester: Tiago Silva
  - Time: 2 dias

  ---

  **Column 2: Cotação (Quotation)**
  - Status Color: status-quotation (blue)
  - Count: 12
  - Cards showing comparison quotes

  **Sample Card:**
  - ID: #PUR-2026-0138
  - Product: "Diesel S10"
  - Supplier: "Petrobras (3 cotações)"
  - Amount: R$ 95.200
  - Priority: Alta
  - Time: 4 dias

  ---

  **Column 3: Aprovação (Approval)**
  - Status Color: status-approval (amber)
  - Count: 5
  - **Note:** "Ver Fila de Aprovação acima ↑"
  - Simplified cards or empty with redirect

  ---

  **Column 4: Pedido Enviado (Ordered)**
  - Status Color: status-ordered (violet)
  - Count: 15

  **Sample Card:**
  - ID: #PUR-2026-0125
  - Product: "Semente Milho Pioneer"
  - Supplier: "Corteva Agriscience"
  - Amount: R$ 180.400
  - Priority: Normal
  - Status: "Entrega em 5 dias"
  - Time: 12 dias

  ---

  **Column 5: Recebido (Received)**
  - Status Color: status-received (emerald)
  - Count: 23
  - Cards marked with check icon

  **Sample Card:**
  - ID: #PUR-2026-0102
  - Product: "Fertilizante Ureia"
  - Supplier: "Yara Brasil"
  - Amount: R$ 120.500
  - Status: "Recebido 22/01/26"
  - Check Icon: Green checkmark

  ---

  ## 🎯 Design Guidelines

  ### Visual Hierarchy
  1. **Approval Queue First:** Urgent actions at the top
  2. **Kanban Flow:** Left-to-right process visualization
  3. **Status Colors:** Distinct colors for each stage
  4. **Priority Badges:** Immediate visual priority identification

  ### Process-Oriented Design
  - **Kanban Workflow:** Classic task board layout
  - **Drag-and-Drop Feel:** Cards appear movable
  - **Status Progression:** Clear left-to-right flow
  - **Action-Focused:** Prominent approve/reject buttons

  ### Color Coding System

  **Kanban Stages:**
  - ⚪ Zinc: Request (initial)
  - 🔵 Blue: Quotation (in process)
  - 🟡 Amber: Approval (action needed)
  - 🟣 Violet: Ordered (in transit)
  - 🟢 Emerald: Received (complete)

  **Priority Levels:**
  - 🔴 Red: Urgent
  - 🟡 Amber: High
  - 🔵 Blue: Normal
  - ⚪ Zinc: Low

  ### Spacing System
  - Use multiples of 4px for all spacing
  - Card padding: 16-20px
  - Column gaps: 20px
  - Section gaps: 24px

  ---

  ## 📤 Export Settings

  **For Development Handoff:**
  - Export entire frame as PNG @2x: `Purchasing_Programming_2x.png`
  - Export kanban card component (all states)
  - Export approval card component
  - Export price history sparkline
  - Export priority badge component

  **For Presentation:**
  - Export as PDF: `SOAL_Dashboard_08_Purchasing.pdf`

  ---

  ## ✅ Checklist

  - [ ] Set up 1920×1080 frame with #09090b background
  - [ ] Create header with filters and controls
  - [ ] Build 5 metrics cards with status colors
  - [ ] Design approval queue section with header
  - [ ] Create 3-5 approval cards with actions
  - [ ] Add price history sparklines to approval cards
  - [ ] Build kanban board with 5 columns
  - [ ] Create purchase card component (multiple states)
  - [ ] Add 3+ cards per column
  - [ ] Design priority badges (4 levels)
  - [ ] Add draggable card indicators
  - [ ] Verify status color consistency
  - [ ] Check all spacing follows 4px grid
  - [ ] Export mockup at 2x resolution

  ---

  **Estimated Time:** 3-4 hours for experienced Figma designer
  **Complexity:** High (Kanban board layout, multiple card types, approval workflow, sparkline integration)

  ---

  ## 💡 Implementation Notes

  ### Kanban Drag-and-Drop
  ```
  Card states:
  - Default: Border left 3px, subtle shadow
  - Hover: Cursor grab, shadow increase
  - Dragging: Opacity 70%, cursor grabbing, larger shadow
  - Drop zone: Column background highlight
  ```

  ### Approval Workflow
  ```
  User clicks "Aprovar":
  1. Card moves from Approval Queue to "Ordered" column
  2. Status updates to "Pedido Enviado"
  3. Notification sent to requester
  4. Count in metrics updates

  User clicks "Rejeitar":
  1. Card moves back to "Request" column
  2. Rejection reason modal appears
  3. Requester notified
  ```

  ### Priority Calculation
  ```
  Priority determined by:
  - Value (> R$ 100K = High priority)
  - Delivery urgency (< 7 days = Urgent)
  - Stock level (critical stock = Urgent)
  - Requester role (Owner request = High)
  ```

  ### Price History Sparkline
  ```
  Data points: Last 6 months
  Color: Status-approval (amber)
  Trend indicator:
    IF current_price > avg_6m THEN "↗ +X%"
    ELSE "↘ -X%"
  ```

  ### Column Limits (for workflow balance)
  - Request: No limit
  - Quotation: Alert if > 15 items (bottleneck)
  - Approval: Alert if > 5 items (requires attention)
  - Ordered: No limit
  - Received: Archive after 30 days

  ### One-Click Approve Requirements
  Only available if:
  - Value < R$ 200K (higher needs detailed review)
  - Supplier is pre-approved
  - Budget available in category
  - No red flags in price history (>20% increase)
