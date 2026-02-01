# Figma Design Prompt: Dashboard #1 - "Visão do Produtor" (The Daily Quick View)

## 🎯 Design Brief
**Philosophy:** "Less is More". The user wants a clean, direct start screen. No clutter, no complex maps, no noise.
**Primary Goal:** Answer "How is my cash flow?" and "Is anything broken?" in 5 seconds.
**Visual Style:** "Executive Industrial". Dark, Sleek, Glassmorphism cards, Zinc colors. Consistent with Dashboards 03, 04, and 08.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Producer_Home_QuickView`
- **Dimensions:** 1920px × 1080px (Desktop HD)
- **Background Color:** `#09090b` (Zinc-950)
- **Padding:** 32px

---

## 🎨 Design System Tokens (Unified)

### Color Palette
- **Bg:** `#09090b` (Canvas), `#18181b` (Cards)
- **Financials:**
    - `money-out`: `#ef4444` (Red-500) - Accounts Payable
    - `money-in`: `#10b981` (Emerald-500) - Accounts Receivable/Profit
    - `money-neutral`: `#3b82f6` (Blue-500) - Balances
- **Status:**
    - `status-ok`: `#10b981` (Emerald-500)
    - `status-alert`: `#f59e0b` (Amber-500)
    - `status-critical`: `#ef4444` (Red-500)

### Typography
- **Headings:** Inter, SemiBold.
- **Numbers:** Inter or Roboto Mono (Bold). Financials must be large and legible.

---

## 📦 Layout Structure

### 1. HEADER: The Morning Greeting
**Height:** 80px
**Layout:** Minimalist Row

- **Left:** "Bom dia, Claudio" (Large, Welcoming) + Date
- **Right:** Weather Ticker (Minimalist Capsule)
    - "⛅ 24°C | 💧 Chuva: 0mm (Hoje)" (White text, concise)

---

### 2. ROW 1: THE FINANCIAL PULSE (Priority #1)
**Height:** 280px
**Layout:** 3 Cards (Payable, Receivable, Cash Balance)
*Direct request: "Um olhar rápido em contas a pagar e receber."*

#### Card 1: A Pagar (Curto Prazo)
- **Title:** "A Pagar (7 Dias)"
- **Icon:** Arrow Up Right (Red)
- **Main Value:** **R$ 142.500** (Large, Red text)
- **Sub-detail:** "3 boletos vencendo hoje" (Alert text)
- **Action:** Button "Ver Detalhes" (Ghost style)

#### Card 2: A Receber (Curto Prazo)
- **Title:** "A Receber (Previsão)"
- **Icon:** Arrow Down Left (Green)
- **Main Value:** **R$ 450.000** (Large, Green text)
- **Sub-detail:** "Disponível na Cooperativa: R$ 380k"
- **Visual:** Simple trend line (sparkline) showing positive trend.

#### Card 3: Saldo de Caixa (Projetado)
- **Title:** "Disponibilidade de Caixa"
- **Icon:** Wallet/Bank (Blue)
- **Main Value:** **R$ 1.2M** (White text)
- **Visual:** A simple progress bar or "Safety Level" indicator (Green Zone).
- **Status:** "Caixa Saudável" (Badge)

---

### 3. ROW 2: OPERATIONAL REALITY (The "Silo" & "Field" Pulse)
**Height:** 320px
**Layout:** 2 Large Cards (Split 50/50)

#### Card 1: Resumo da Safra (Silo & Colheita)
*Simple view of what matters physically.*
- **Title:** "Status da Colheita & Recebimento"
- **Layout:** Horizontal stats sequence.
    - **Colheita:** � **45% Concluído** (Progress bar)
    - **Secador:** 🔥 **Operando** (Green Badge)
    - **Fila:** � **2 Caminhões** (Neutral)
    - **Silo:** � **60% Cheio** (Visual fill bar)
- **Design:** Clean icons, large numbers, no complex tables.

#### Card 2: Alertas de Maquinário (Exception Management)
*Only what needs fixing. If everything is fine, show "All Good".*
- **Title:** "Atenção na Frota"
- **Content:** List of strictly critical items (Maximum 3).
    - 🔴 **JD 8R:** Consumo Excessivo (28L/h)
    - 🟡 **Pulverizador:** Manutenção Preventiva em 5h
    - *If no alerts:* Show a large Green Check "Frota 100% Operacional".

---

### 4. ROW 3: COMMODITIES & DECISION (Quick Market View)
**Height:** 160px
**Layout:** 4 Small Ticker Cards
*Quick decision support.*

- **Ticker 1:** Soja Spot: **R$ 138,00** (🔻 -0.5%)
- **Ticker 2:** Milho Spot: **R$ 58,00** (➖ 0.0%)
- **Ticker 3:** Dólar PTAX: **R$ 5,45** (🔺 +1.2%)
- **Ticker 4:** Ureia/Ton: **US$ 380** (📉 Baixa)

---

## 💡 UX Philosophy for this Dashboard
1.  **"Don't Make Me Think":** Green is good money, Red is bad money/alert.
2.  **No Scrolling:** Everything fits on one 1080p screen.
3.  **Click to Dive:** This dashboard is the surface. Clicking "A Pagar" goes to Dashboard #3. Clicking "Frota" goes to Dashboard #4.
4.  **Zero Fluff:** No map overlays, no satellite imagery here. Just the numbers that matter for the morning coffee decision.
