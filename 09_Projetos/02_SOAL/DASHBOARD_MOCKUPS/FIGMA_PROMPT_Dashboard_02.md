# Figma Design Prompt: Dashboard #2 - Contas a Receber (Accounts Receivable)

## 🎯 Design Brief
Create a comprehensive Accounts Receivable dashboard for agricultural business management, focused on liquidity tracking and grain sales payments. Target users: Valentina (Financial Admin) and Claudio (Owner). The aesthetic must maintain the "Industrial Precision" standard with emphasis on financial clarity.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Accounts_Receivable_Dashboard`
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
- `brand-primary`: `#10b981` (Emerald-500) - Future Receivables, Paid
- `brand-danger`: `#ef4444` (Red-500) - Overdue
- `brand-warning`: `#f59e0b` (Amber-500) - Due Soon
- `brand-info`: `#3b82f6` (Blue-500) - Information
- `status-paid`: `#71717a` (Zinc-500) - Paid/Completed
- `status-pending`: `#10b981` (Emerald-500) - Open/Pending
- `status-overdue`: `#ef4444` (Red-500) - Overdue

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
- `Label/M`: Inter Medium, 12px, Line Height 16px, #a1a1aa
- `Label/S`: Inter Regular, 10px, Line Height 14px, #52525b

### Component Styles

**Glassmorphism Card:**
- Fill: `#18181b` at 80% opacity
- Border: 1px solid `#ffffff` at 10% opacity
- Corner Radius: 12px
- Effect: Background Blur 10px

**Status Badge:**
- Padding: 4px 8px
- Corner Radius: 4px
- Font: Label/M, Semibold

---

## 📦 Layout Structure (Top to Bottom)

### 1. HEADER SECTION
**Position:** Top, Full Width
**Height:** 88px
**Layout:** Horizontal, Space Between

#### Left Side: Title Block
- **Main Title:** "Contas a Receber"
  - Style: Heading/XL
  - Color: text-primary
- **Subtitle:** "Accounts Receivable Dashboard"
  - Style: Label/M
  - Color: text-secondary
  - Margin Top: 4px

#### Right Side: Filter Controls
**Layout:** Horizontal, Gap 12px

**Element 1: Safra Filter**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Todas as Safras"
- Style: Body/Number/S
- Icon: Chevron Down (12px)

**Element 2: Date Range**
- Background: Glassmorphism Card
- Padding: 10px 16px
- Text: "Últimos 90 dias"
- Style: Body/Number/S
- Icon: Calendar (16px, text-secondary)

**Element 3: Export Button**
- Background: brand-primary at 15% opacity
- Border: 1px solid brand-primary at 40% opacity
- Padding: 10px 20px
- Text: "Exportar"
- Style: Body/Number/S, brand-primary
- Icon: Download (16px)

---

### 2. KPI CARDS ROW
**Position:** Below Header, 32px margin top
**Layout:** 4 Columns, Equal Width, Gap 20px
**Card Height:** 140px

---

#### CARD 1: Total a Receber (Safra Atual)

**Base:** Glassmorphism Card with 20px padding

**Icon Badge (Top Left):**
- Size: 40×40px circle
- Background: brand-primary at 15% opacity
- Icon: Trending Up or Dollar Sign (20px, brand-primary)

**Content:**
- **Label:** "Total a Receber (Safra Atual)"
  - Style: Label/M
  - Color: text-secondary
  - Margin Bottom: 8px

- **Value:** "R$ 18.4M"
  - Style: Body/Number/XL
  - Color: brand-primary
  - Margin Bottom: 4px

- **Subtext:** "42 contratos ativos"
  - Style: Label/S
  - Color: text-muted

---

#### CARD 2: Total a Receber (Safras Passadas)

**Base:** Glassmorphism Card with 20px padding

**Icon Badge:**
- Background: brand-info at 15% opacity
- Icon: Clock or History (20px, brand-info)

**Content:**
- **Label:** "Total a Receber (Safras Passadas)"
  - Style: Label/M
  - Color: text-secondary

- **Value:** "R$ 3.2M"
  - Style: Body/Number/XL
  - Color: brand-info

- **Subtext:** "8 contratos pendentes"
  - Style: Label/S
  - Color: text-muted

---

#### CARD 3: Inadimplência (Overdue)

**Base:** Glassmorphism Card with 20px padding

**Icon Badge:**
- Background: brand-danger at 15% opacity
- Icon: Alert Triangle (20px, brand-danger)

**Content:**
- **Label:** "Inadimplência"
  - Style: Label/M
  - Color: text-secondary

- **Value:** "R$ 840K"
  - Style: Body/Number/XL
  - Color: brand-danger

- **Subtext:** "5 contratos atrasados"
  - Style: Label/S
  - Color: text-muted

- **Alert Badge:**
  - Position: Top Right corner
  - Size: 20×20px circle
  - Fill: brand-danger
  - Text: "5" - Label/S, white, bold
  - Center aligned

---

#### CARD 4: Próximos 30 Dias

**Base:** Glassmorphism Card with 20px padding

**Icon Badge:**
- Background: brand-warning at 15% opacity
- Icon: Calendar Check (20px, brand-warning)

**Content:**
- **Label:** "Próximos 30 Dias"
  - Style: Label/M
  - Color: text-secondary

- **Value:** "R$ 6.7M"
  - Style: Body/Number/XL
  - Color: brand-warning

- **Subtext:** "12 vencimentos programados"
  - Style: Label/S
  - Color: text-muted

---

### 3. PAYMENT CALENDAR HEATMAP
**Position:** Below KPI Cards, 24px margin top
**Layout:** Glassmorphism Card, 24px padding
**Height:** 380px

**Header:**
- Text: "Cronograma de Recebimentos"
- Style: Heading/L
- Color: text-primary
- Margin Bottom: 20px

**Legend (Top Right):**
- Layout: Horizontal, Gap 16px
- Position: Aligned with header

**Legend Items:**
1. Square (12×12px, status-paid) + "Pago" (Label/M, text-secondary)
2. Square (12×12px, status-pending) + "Em Aberto" (Label/M, text-secondary)
3. Square (12×12px, status-overdue) + "Atrasado" (Label/M, text-secondary)

**Heatmap Table Structure:**

**Dimensions:**
- Rows: 8 clients (variable based on data)
- Columns: 12 months (Jan - Dez)
- Cell Size: 80px width × 40px height
- Gap: 2px

**Row Header (Client Names):**
- Width: 180px (fixed)
- Text: Client name (e.g., "Cooperativa COOAGRI")
- Style: Body/Text/M, text-primary
- Background: bg-surface
- Padding: 12px

**Column Header (Months):**
- Height: 32px (fixed)
- Text: "Jan", "Fev", "Mar", etc.
- Style: Label/M, text-secondary
- Alignment: Center
- Background: bg-surface-highlight
- Border Bottom: 1px solid zinc-800

**Heatmap Cells:**

**Cell States:**

1. **Empty Cell (No payment):**
   - Background: bg-surface
   - Border: 1px solid zinc-800 at 30% opacity

2. **Payment Due (Em Aberto):**
   - Background: Gradient from brand-primary at varying opacity based on amount
   - Opacity Scale:
     - Low amount (< R$ 200K): 20% opacity
     - Medium (R$ 200K - R$ 500K): 40% opacity
     - High (> R$ 500K): 60% opacity
   - Text: "R$ 450K" (example)
   - Style: Label/M, brand-primary, Semibold
   - Alignment: Center

3. **Paid:**
   - Background: status-paid at 20% opacity
   - Text: "R$ 380K" (example)
   - Style: Label/M, status-paid
   - Icon: Checkmark (small, 12px, status-paid)

4. **Overdue:**
   - Background: status-overdue at 25% opacity
   - Border: 1px solid status-overdue
   - Text: "R$ 120K"
   - Style: Label/M, status-overdue, Semibold
   - Icon: Alert (small, 12px, status-overdue)

**Sample Data (Client Rows):**
1. Cooperativa COOAGRI
2. Bunge Alimentos S.A.
3. Cargill Agrícola
4. ADM do Brasil
5. Louis Dreyfus Company
6. Amaggi Exportação
7. Cooperativa COAMO
8. Grupo Scheffer

---

### 4. DETAILED RECEIVABLES TABLE
**Position:** Below Heatmap, 24px margin top
**Layout:** Glassmorphism Card, 24px padding
**Min Height:** 400px

**Header Row:**
- Text: "Lista Detalhada de Recebíveis"
- Style: Heading/L
- Margin Bottom: 16px

**Table Controls (Top Right):**
- Layout: Horizontal, Gap 12px
- **Search Bar:**
  - Width: 280px
  - Background: bg-surface-highlight
  - Border: 1px solid zinc-800
  - Padding: 8px 12px
  - Placeholder: "Buscar cliente ou contrato..."
  - Icon: Search (16px, text-muted)

- **Sort Dropdown:**
  - Background: bg-surface-highlight
  - Text: "Ordenar: Vencimento"
  - Icon: Arrow Up/Down

**Table Structure:**

**Table Header:**
- Background: bg-surface-highlight
- Border Bottom: 2px solid zinc-700
- Padding: 12px 16px
- Height: 48px

**Columns:**
1. **Cliente** (35% width)
   - Text: "Cliente"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Left

2. **Contrato** (15% width)
   - Text: "Contrato"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Left

3. **Vencimento** (15% width)
   - Text: "Vencimento"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Left

4. **Valor** (15% width)
   - Text: "Valor"
   - Style: Label/M, text-secondary, Semibold
   - Icon: Sort arrows
   - Alignment: Right

5. **Status** (12% width)
   - Text: "Status"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Center

6. **Ações** (8% width)
   - Text: "Ações"
   - Style: Label/M, text-secondary, Semibold
   - Alignment: Center

**Table Rows:**

**Row Height:** 60px
**Row Background:** Alternating - bg-surface (odd), transparent (even)
**Row Border:** Bottom 1px solid zinc-800 at 40% opacity
**Row Padding:** 12px 16px
**Hover State:** Background to bg-surface-highlight

**Sample Row 1 (Overdue):**
- **Cliente:**
  - Avatar: 32×32px circle, brand-danger at 20% opacity, initials "CA"
  - Name: "Cooperativa COOAGRI"
  - Style: Body/Text/M, text-primary
  - Gap: 12px

- **Contrato:**
  - Text: "#SOJ-2025-042"
  - Style: Body/Text/M, text-secondary

- **Vencimento:**
  - Text: "15/12/2025"
  - Subtext: "Vencido há 14 dias"
  - Style: Body/Text/M, status-overdue
  - Subtext Style: Label/S, status-overdue

- **Valor:**
  - Text: "R$ 320.450,00"
  - Style: Body/Number/M, text-primary, Semibold

- **Status:**
  - Badge: "ATRASADO"
  - Background: status-overdue at 20% opacity
  - Border: 1px solid status-overdue at 50% opacity
  - Text: Label/M, status-overdue, Semibold
  - Padding: 6px 12px
  - Radius: 4px

- **Ações:**
  - Icon Button: Three dots (Menu)
  - Size: 32×32px
  - Background: Transparent, hover to bg-surface-highlight
  - Icon: More Vertical (16px, text-secondary)

**Sample Row 2 (Em Aberto):**
- **Cliente:** "Bunge Alimentos S.A." (Avatar: "BA", brand-primary)
- **Contrato:** "#SOJ-2025-038"
- **Vencimento:** "02/02/2026" + "Vence em 4 dias" (brand-warning)
- **Valor:** "R$ 1.245.800,00"
- **Status:** "EM ABERTO" (status-pending badge)
- **Ações:** Menu button

**Sample Row 3 (Pago):**
- **Cliente:** "Cargill Agrícola" (Avatar: "CG", status-paid)
- **Contrato:** "#SOJ-2025-031"
- **Vencimento:** "10/01/2026" + "Pago em dia" (status-paid)
- **Valor:** "R$ 680.200,00"
- **Status:** "PAGO" (status-paid badge with checkmark icon)
- **Ações:** Menu button

**Table Footer:**
- Background: bg-surface
- Border Top: 1px solid zinc-700
- Height: 56px
- Padding: 16px 24px

**Footer Content:**
- Layout: Horizontal, Space Between

**Left Side:**
- Text: "Mostrando 1-10 de 42 contratos"
- Style: Label/M, text-secondary

**Right Side: Pagination**
- Layout: Horizontal, Gap 8px
- **Previous Button:**
  - Size: 32×32px
  - Background: bg-surface-highlight
  - Icon: Chevron Left (16px)
  - Disabled state: opacity 40%

- **Page Numbers:**
  - Buttons: 32×32px each
  - Active: bg-brand-primary at 20%, text brand-primary
  - Inactive: bg-surface-highlight, text-secondary
  - Text: "1", "2", "3", "..."

- **Next Button:**
  - Size: 32×32px
  - Background: bg-surface-highlight
  - Icon: Chevron Right (16px)

---

## 🎯 Design Guidelines

### Visual Hierarchy
1. **Financial Emphasis:** Large, bold numbers for monetary values
2. **Status Color Coding:**
   - Green (Emerald): Positive, open receivables, paid
   - Red: Overdue, critical
   - Amber/Yellow: Due soon, warning
   - Grey: Completed/Paid
3. **Table Readability:** Alternating row backgrounds, clear column separation
4. **Heatmap Intensity:** Color opacity indicates amount magnitude

### Spacing System
- Use multiples of 4px for all spacing
- Card padding: 20-24px
- Section gaps: 24px
- Table cell padding: 12-16px
- Tight gaps: 4-8px

### Interactive States
- **Table Row Hover:** Background to surface-highlight
- **Cell Hover (Heatmap):** Show tooltip with detailed info
- **Button Hover:** Opacity increase or background color shift
- **Sort Icons:** Active column shows different icon color

### Data Visualization Principles
- **Heatmap Color Intensity:** Directly proportional to amount
- **Status Badges:** Consistent sizing, clear color association
- **Client Avatars:** First letters of company name, branded colors

---

## 📤 Export Settings

**For Development Handoff:**
- Export entire frame as PNG @2x: `Accounts_Receivable_2x.png`
- Export heatmap component as separate SVG
- Export status badges as reusable components
- Export table row templates

**For Presentation:**
- Export as PDF: `SOAL_Dashboard_02_Receivables.pdf`

---

## ✅ Checklist

- [ ] Set up 1920×1080 frame with #09090b background
- [ ] Create header with title and filter controls
- [ ] Build 4 KPI cards with icons and values
- [ ] Create payment calendar heatmap (8 rows × 12 columns)
- [ ] Design heatmap cells with 4 states (empty, pending, paid, overdue)
- [ ] Build detailed table with 6 columns
- [ ] Create table rows with alternating backgrounds
- [ ] Design status badges (3 variants: paid, pending, overdue)
- [ ] Add client avatars to table rows
- [ ] Create pagination controls
- [ ] Verify all spacing follows 4px grid
- [ ] Check color contrast for accessibility
- [ ] Export mockup at 2x resolution

---

**Estimated Time:** 3-4 hours for experienced Figma designer
**Complexity:** High (Complex heatmap, dynamic table states, multiple data visualizations)

---

## 💡 Implementation Notes

### Heatmap Color Scale Logic
For automatic color scaling based on amount:
- Minimum amount in dataset = 0% opacity
- Maximum amount in dataset = 60% opacity
- Linear interpolation for values in between

### Status Badge Logic
```
IF payment_date > due_date AND status != "paid" THEN
  status = "ATRASADO" (overdue)
ELSE IF status == "paid" THEN
  status = "PAGO"
ELSE
  status = "EM ABERTO" (pending)
```

### Table Sorting
Default sort: By due date (ascending)
Alternative sorts: By amount, by client name, by status

### Hover Actions (Future Implementation)
- Heatmap cell hover: Show tooltip with contract details
- Table row hover: Highlight + show action buttons
- "Mark as Paid" quick action
- "Send Reminder" button for overdue items
