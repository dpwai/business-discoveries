# Figma Design Prompt: Dashboard #1 - "O Dia do Produtor" (Operational Reality)

## 🎯 Design Brief
Create a highly functional, "Battle Station" style dashboard for a rural producer. Unlike the previous executive version, this one must be **action-oriented**. The producer opens this at 6:00 AM to decide: "What needs my attention today?".
Focus on **Weather Risks**, **Machinery Status**, **Critical Alerts**, and **Daily Costs**. The aesthetic should be "Industrial Precision" - dark mode, high contrast, dense information but clear hierarchy.

---

## 📐 Canvas Setup

### Frame Specifications
- **Frame Name:** `Producer_Daily_Dashboard`
- **Dimensions:** 1920px × 1080px (Desktop HD)
- **Background Color:** `#0f172a` (Slate-950 - slightly bluer/richer dark for modern feel)
- **Padding:** 24px all sides

---

## 🎨 Design System Tokens

### Color Palette
**Backgrounds:**
- `bg-canvas`: `#0f172a`
- `bg-card`: `#1e293b` (Slate-800)
- `bg-card-highlight`: `#334155` (Slate-700)

**Typography:**
- `text-primary`: `#f1f5f9` (Slate-100)
- `text-secondary`: `#94a3b8` (Slate-400)
- `text-accent`: `#38bdf8` (Sky-400) - For operational data

**Semantic Colors (Critical for Alerts):**
- `status-ok`: `#22c55e` (Green-500) - Everything running smooth
- `status-warning`: `#f59e0b` (Amber-500) - Needs attention (Maintenance, Inventory)
- `status-critical`: `#ef4444` (Red-500) - STOPPER (Breakdown, Pest outbreak)
- `weather-rain`: `#3b82f6` (Blue-500)
- `weather-dry`: `#f97316` (Orange-500)

### Typography
**Font:** Inter or Roboto (Clean, legible numbers are priority)

---

## 📦 Layout Structure

### 1. HEADER: The "Morning Check"
**Height:** 80px
**Layout:** Flex, Space Between

- **Left:** Logo "SOAL Intelligence" + Date/Time (e.g., "Quinta, 29 Jan | 06:15 AM")
- **Center:** **Weather Ticker** (Crucial)
  - Layout: Horizontal capsule
  - Content: "⛅ 24°C | Vento: 12km/h NO | 💧 Chuva em 48h: **45mm** (Alerta)"
  - Style: The "45mm" should be bold/colored to draw attention.
- **Right:** User Profile + "Emergency Stop" button (or similar quick action).

---

### 2. TOP ROW: "O Que Está Acontecendo Agora?" (Real-Time Ops)
**Height:** 320px
**Layout:** 3 Cards (Weather Risk, Machinery Live, Market Opportunities)

#### Card 1: Risco Climático & Janela de Trabalho (35% Width)
*The most important factor for daily decisions.*
- **Title:** "Janela de Operação"
- **Visual:** A 5-day forecast timeline focusing on "Plantability/Harvestability".
- **Content:**
  - Today: ✅ Ideal (Green)
  - Tomorrow: ✅ Ideal (Green)
  - Saturday: ⚠️ Chuva (40mm) - PARADA OBRIGATÓRIA
  - Sunday: ❌ Solo Encharcado
  - **Action Item:** "Recomendação: Acelerar colheita no Talhão 4 hoje e amanhã."

#### Card 2: Status da Frota em Tempo Real (35% Width)
*Are the machines working?*
- **Title:** "Operação em Campo: Plantio Soja"
- **Visual:** 3 circular stats or list.
  - **Ativos:** 4 Máquinas (Green dot)
  - **Parados:** 1 Máquina (Red dot - blinking?)
  - **Eficiência Média:** 85%
- **List Detail:**
  - 🚜 JD 8R (Talhão 02): 5.2 km/h | 🟢 Operando
  - 🚜 Case 340 (Talhão 04): 0.0 km/h | 🔴 Parado (Manutenção Hidráulica - 45min)
  - 🚜 Pulverizador (Talhão 01): 18 km/h | 🟢 Aplicando Fungicida

#### Card 3: Oportunidades de Mercado (30% Width)
*Should I sell today?*
- **Title:** "Mercado & Metas"
- **Content:**
  - **Soja Spot:** R$ 138,00 (🔻 -0.5%)
  - **Target de Venda:** R$ 142,00
  - **Indicador:** "Segurar Venda" (Visual badge)
  - **Dólar:** R$ 5,45 (🔺 +1.2%)

---

### 3. MIDDLE ROW: "Briefing de Decisão" (Alerts & Costs)
**Height:** 400px
**Layout:** 2 Columns (2fr, 1fr)

#### Card 1: Mapa de Alertas & Saúde da Lavoura (Map View)
*Where are the problems?*
- **Visual:** A stylized map of the farm outlines (Talhões).
- **Overlays:**
  - **Talhão 02:** 🐞 Alerta de Praga (Lagarta) - Nível Médio (Yellow overlay)
  - **Talhão 05:** 💧 Déficit Hídrico - Nível Baixo (Green overlay)
  - **Talhão 08:** 📉 Baixa População de Plantas (Red overlay area)
- **Sidebar on map:** List of active alerts categorized by Priority.
  - "🔴 ALTA: Talhão 08 com falha de plantio detectada (5%). Replantio recomendado."
  - "🟡 MÉDIA: Monitoramento de Lagarta no Talhão 02 indicou nível de dano econômico em 3 dias."

#### Card 2: Custo Real vs Planejado (Financial Reality)
*Am I bleeding money?*
- **Title:** "Acumulado da Safra"
- **Visual:** Gauge or Bullet Chart.
- **Metric:**
  - **Custo Atual:** R$ 3.850/ha
  - **Meta/Orçamento:** R$ 3.800/ha
  - **Delta:** 🔺 +R$ 50/ha (Over budget)
- **Breakdown (Mini list):**
  - Diesel: ✅ Dentro da meta
  - Defensivos: ❌ +12% (Devido a extra de fungicida)
  - Manutenção: ✅ Dentro da meta

---

### 4. BOTTOM ROW: "Planejamento Próximas 24h"
**Height:** 180px
**Layout:** Horizontal Timeline or Kanban-style cards

- **Col 1 (Manhã):** "Concluir Plantio Talhão 04" | "Recebimento Adubo (10h)"
- **Col 2 (Tarde):** "Mover Maquinário para Talhão 06" | "Manutenção Preventiva JD 7J"
- **Col 3 (Noite):** "Aplicação Noturna (Se vento < 10km/h)"

---

## 🎯 Key Design Features for the Producer
1.  **"Red stops the eye":** Use red sparingly but strictly for things that require immediate phone calls (Machines stopped, Pest outbreaks).
2.  **Dense but Grouped:** Heavy information density is fine (they are experts), but group it logically (Weather / Iron / Agronomy / Money).
3.  **Direct Language:** Don't say "Variance Analysis of Fuel Consumption". Say "Diesel: Gastando 10% a mais que o planejado".

## 📤 Export Checklist
- [ ] Dark Mode (Essential for low-light cab viewing or early morning).
- [ ] High Contrast Fonts for readability.
- [ ] "Morning Briefing" summary visible at a glance.
