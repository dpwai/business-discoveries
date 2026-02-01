# Figma Design Prompt: Tower Control TV - "Gestão à Vista" (Oficina Kugler)

## 🎯 Design Brief
**Device:** TV Screen (1920x1080), mounted on the wall of the workshoph.
**User:** Mechanics, Painters, Managers (View only).
**Goal:** Instant visibility of where every car is. "Don't let cars get stuck."
**Constraint:** Updates are manual via App (human dependent), so the flow must be SIMPLE (4-5 columns max) to reduce friction.

---

## 📐 Canvas Setup
- **Frame Name:** `TV_Torre_Controle_Oficina`
- **Dimensions:** 1920px × 1080px
- **Background:** `#09090b` (Zinc-950) - Optimized to reduce glare and save energy on TVs.
- **Typography:** Large, readable from 5 meters away. (Headings: 32px+, Cards: 24px+).

---

## 🚦 The Simplified Flow (Kanban Columns)

To ensure the team actually uses the form updates, we simplified the 6+ stages into **4 Focus Areas**:

1.  **A Fazer / Desmontagem** (Queue)
2.  **Funilaria** (Metal Work)
3.  **Pintura** (Includes Preparação & Painting)
4.  **Montagem & Acabamento** (Reassembly & Polishing)

*Use a 5th column "Pronto" only if space permits, otherwise "Pronto" clears the card.*

---

## 🎨 Visual Component: The "Job Card"

Each card represents a vehicle. It must be bold and simple.

**Card Anatomy:**
- **Background:** `#18181b` (Zinc-900) with a colored left-border indicating Priority (Red/Yellow/Green).
- **Header:**
    - **Vehicle:** "Toy. Corolla Cross" (Bold, White)
    - **Plate:** "ABC-1234" (Mono font, Zinc-400)
    - **Color Dot:** Visual reference (e.g., Pearl White)
- **Body:**
    - **Owner:** "Daniel K." (Truncated first name)
    - **Service:** "Batida Traseira" (Short description)
- **Footer (The most important metric):**
    - **Time in Stage:** "⏱️ 2d 4h" (Big numbers).
    - **Logic:** If Time > Standard, turn Text **RED** and pulse.

---

## 🏗️ Layout Structure

### 1. Header (10% Height)
- **Left:** Logo "Kugler Veículos" (White/Monochrome).
- **Center:** "Torre de Controle - Oficina"
- **Right:** Clock (Huge Digital Time) + "Oficina: 🟢 Operando".

### 2. The Board (80% Height)
- **Grid:** 4 Equal Columns (Gap 16px).
- **Column Headers:** Bold with counts. E.g., "FUNILARIA (3)".
- **Cards:** Stacked vertically. Maximum ~5 cards per column before "auto-scroll" pagination would be needed.
    - *Note:* Design for the "Happy Path" of ~4 cards per column to look perfect.

### 3. Footer (10% Height)
- **Summary Ticker:**
    - "🚗 Carros na Casa: **12**"
    - "📅 Entregas Hoje: **2**"
    - "⚠️ Atrasados: **1** (Verificar Corolla)"
- **Style:** High contrast strip (Zinc-800).

---

## 💡 UX & Logic for TV
1.  **Dark Mode Only:** TVs are bright. White backgrounds hurt eyes. Use Dark Zinc.
2.  **Color Coding:**
    - **Green:** On time.
    - **Yellow:** Near deadline.
    - **Red:** Delayed (Action required).
3.  **No Interactions:** This is a passive screen. No buttons, no scrollbars visible.
4.  **Readability:** Use `Inter` or `JetBrains Mono` for data. No serif fonts.
