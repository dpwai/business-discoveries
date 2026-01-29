# SOAL Dashboard Design Specifications & Prompts

> **Use Case:** These prompts are designed to be used with AI coding tools (like Claude Code) or Image Generators to create high-fidelity UI drafts. They embody the "DeepWork Agro" aesthetic: clean, industrial, high-contrast, and focused on decision-making.

## 🎨 Global Design System (The "Vibe")
*   **Theme:** "Industrial Premium". Think financial terminal meets John Deere precision tech.
*   **Palette:**
    *   *Background:* `Zinc-950` (Deep Grey) for standard mode, `Slate-50` for high-contrast field mode.
    *   *Accents:* `Emerald-500` (Positive/Growth), `Amber-500` (Warning), `Rose-600` (Critical/Expense), `Sky-500` (Information).
    *   *Typography:* `Inter` or `Geist Mono` for numbers. High readability.
*   **Components:** Glassmorphism cards with subtle borders (`border-white/10`), large touch targets (min 44px) for mobile views.

---

## 1. 🚀 Executive Dashboard: "Raio-X da Safra" (The Claudio View)
*   **Goal:** Provide an instant health check of the business. The "Morning Coffee" screen.
*   **Target User:** Claudio Kugler.

### 🤖 Design Prompt
> Create a high-fidelity dashboard UI for an Executive Agricultural Summary named "Safra Overview".
>
> **Layout Strategy:** Bento Grid layout (highly modular).
>
> **Key Visual Blocks:**
> 1.  **Header:** "Safra 2025/26 - Soja" selector with a global "Net Margin Forecast" badge (e.g., "R$ 4.200/ha" in green).
> 2.  **Top Cards (KPIs):**
>     *   *Progress:* A circular progress bar showing "Plantio: 100%" and "Colheita: 12%".
>     *   *Financial:* "Cash Flow Status" mini sparkline chart (Green line for Income, Red bars for Expenses).
>     *   *Market:* "Average Sale Price" vs "Target Price".
> 3.  **Main Chart:** A "profitability waterfall" chart showing: Gross Revenue -> Subs -> Direct Costs -> Operational Costs -> Net Profit.
> 4.  **Risk Alert Section:** A prominent but compact notification area: "3 Tractors in Maintenance", "Rain Forecast: 40mm next 2 days".
>
> **Aesthetic:** Minimalist, data-dense but not cluttered. Use a dark theme with neon green accents for "Profit".

---

## 2. 💰 Contas a Receber (Receivables)
*   **Goal:** Track liquidity and grain sales payments.
*   **Target User:** Valentina / Claudio.

### 🤖 Design Prompt
> Create a comprehensive "Accounts Receivable" dashboard for an Agribusiness.
>
> **Layout Strategy:** Split view (KPIs on top, detailed list below).
>
> **Key Visual Blocks:**
> 1.  **KPI Row:**
>     *   "Total a Receber (Safra Atual)" vs "Total a Receber (Safras Passadas)".
>     *   "Inadimplência (Overdue)" in bright red.
>     *   "Próximos 30 dias" (Liquidity forecast).
> 2.  **Main Visualization:** A "Payment Calendar" heat map. Rows = Clients (Cooperatives/Traders), Columns = Months. Cells colored by amount scale.
> 3.  **Data Table:** A clean, sortable table listing: Cliente, Vencimento, Valor, Status (Em Aberto / Pago / Atrasado).
>     *   *Action:* Hover actions to "Mark as Paid" or "Send Reminder".
>
> **Aesthetic:** Financial focus. Very clear typography. Use shades of Green for future money, Grey for paid, Red for overdue.

---

## 3. 💸 Contas a Pagar (Payables)
*   **Goal:** Cash flow management and preventing interest penalties.
*   **Target User:** Valentina.

### 🤖 Design Prompt
> Create a "Accounts Payable" management interface.
>
> **Layout Strategy:** Calendar-centric view on the left, List view on the right.
>
> **Key Visual Blocks:**
> 1.  **Metric Cards:** "Total Vencendo Hoje", "Total na Semana", "Fluxo de Caixa Projetado (Saldo Final)".
> 2.  **Visual:** A Vertical Bar Chart stacked by Category (Insumos, Manutenção, Combustível, Folha). This helps identifying cost spikes.
> 3.  **The "Cash Burn" Line:** A line chart overlay showing the bank balance projection if all bills are paid.
> 4.  **Interaction:** A bulk action bar at the bottom: "Select All -> Authorize Payment".
>
> **Aesthetic:** Use "Warning Amber" and "Critical Red" for urgency. Clean white text on dark background for readability.

---

## 4. 🚜 Maquinário & Diesel (Operational Cost)
*   **Goal:** Identify high-consumption machines and operational efficiency.
*   **Target User:** Tiago / Claudio.

### 🤖 Design Prompt
> Create a detailed "Machinery & Fuel Intelligence" dashboard.
>
> **Layout Strategy:** Fleet Grid View.
>
> **Key Visual Blocks:**
> 1.  **Fleet Status Header:** Total Machines: 12 | Active: 9 | Maintenance: 2 | Idle: 1.
> 2.  **Main Chart:** Scatter Plot: X-Axis = "Hours Worked", Y-Axis = "Liters/Hour".
>     *   *Goal:* Identify machines in the top-right quadrant (High usage + High consumption = Abnormal).
> 3.  **Machine Cards (Grid):** Individual cards for each tractor (e.g., "John Deere 8R").
>     *   *Details:* Photo of the model, Status Badge, "Fuel Level" gauge, and "Efficiency Score" (e.g., 92%).
> 4.  **Fuel Tank Telemetry:** A visual representation of the main farm fuel tank levels (Current Volume vs Capacity).
>
> **Aesthetic:** Rugged, engineering style. Uses gauges and technical iconography. Color palette: Yellow (Construction/Agro), Dark Grey.

---

## 5. 🌾 Estoque de Grãos (Commercial Inventory)
*   **Goal:** Strategy of "When to sell".
*   **Target User:** Claudio.

### 🤖 Design Prompt
> Create a "Grain Inventory & Commercialization" dashboard.
>
> **Layout Strategy:** Silo Visualization.
>
> **Key Visual Blocks:**
> 1.  **Silo Visuals:** Realistic 2D vector illustrations of silos showing fill levels (%) using liquid fill effects.
>     *   Label: "Silo 1 (Soja)", "Silo 2 (Milho)". Includes tonnage text overlays.
> 2.  **Commercial Gauge:** A half-circle gauge showing "% Sold" vs "% Stored".
> 3.  **Market Ticker:** A scrolling ticker or static card block showing live commodity prices (Chicago/B3) vs "Average Fixed Price" of the farm.
> 4.  **Logistics Card:** "Trucks in Queue" or "Scheduled Loads" summary.
>
> **Aesthetic:** Clean, spatial usage. Gold/Yellow colors for Corn/Soy representation.

---

## 6. 🧪 Estoque de Insumos (Input Inventory)
*   **Goal:** Ensure operation doesn't stop due to missing chemicals/seeds.
*   **Target User:** Tiago / Agronomist.

### 🤖 Design Prompt
> Create an "Agro-Inputs Inventory" management screen.
>
> **Layout Strategy:** E-commerce style inventory grid.
>
> **Key Visual Blocks:**
> 1.  **ABC Curva Chart:** A Pareto chart showing which inputs represent 80% of the stocked value.
> 2.  **Stock Alerts:** A prominent section tracking "Low Stock" items (e.g., "Glyphosate: 2 days remaining").
> 3.  **Category Tabs:** Defensivos | Fertilizantes | Sementes | Peças.
> 4.  **Item List:** Rows showing: Product Name, Batch #, Expiration Date (Critical for chemicals), Quantity, Unit Costs.
>     *   *Visual Cue:* Color code expiration dates (Green > 6 mo, Yellow < 3 mo, Red < 1 mo).
>
> **Aesthetic:** Clinical, organized. High information density.

---

## 7. 📉 Custos por Fazenda/Cultura (Cost Accounting)
*   **Goal:** The specific breakdown of where money went.
*   **Target User:** Claudio / Accountant.

### 🤖 Design Prompt
> Create a "Cost Center Allocation" analytics dashboard.
>
> **Layout Strategy:** Drill-down Tree Map.
>
> **Key Visual Blocks:**
> 1.  **Macro Toggle:** Switch between "View by Farm" (Santana vs Retiro 2) and "View by Culture" (Soja vs Milho).
> 2.  **Treemap Visualization:** Large rectangles for biggest costs (e.g., "Fertilizers"), subdivided by specific types.
>     *   *Interaction:* Clicking a rectangle drills down into details.
> 3.  **Cost per Hectare Trend:** A Line Chart tracking the evolution of "Cost/Ha" over the last 5 harvests.
> 4.  **Comparative Table:** "Planned Budget" vs "Executed Cost" with a Deviation % column.
>
> **Aesthetic:** Analytical, spreadsheet-inspired but beautiful. Muted colors to reduce visual fatigue during deep analysis.

---

## 8. 📅 Programação de Compras (Purchasing Planning)
*   **Goal:** Optimization of cash flow vs needs.
*   **Target User:** Valentina.

### 🤖 Design Prompt
> Create a "Procurement & Purchasing Schedule" dashboard.
>
> **Layout Strategy:** Kanban Board + Timeline.
>
> **Key Visual Blocks:**
> 1.  **Kanban Board:** Columns for "Request", "Quotation", "Approval", "Ordered", "Received".
> 2.  **Approval Queue:** A dedicated focus area for Claudio/Manager to "One-click Approve" high-value purchases.
> 3.  **Price History:** When creating a purchase order, a small sparkline showing the price history of that specific item (inflation tracking).
>
> **Aesthetic:** Process-oriented. Clean cards, distinct status colors.

---

## 9. 🛠️ Gestão de Manutenção (Maintenance Hub) - *NEW*
*   **Goal:** Keep the fleet running. Stop the bleeding of money in parts.
*   **Target User:** Tiago.

### 🤖 Design Prompt
> Create a "Workshop & Maintenance Control" interface.
>
> **Layout Strategy:** Triage Board.
>
> **Key Visual Blocks:**
> 1.  **Status Indicators:** Big numeric indicators: "Machines Stopped", "Machines in Maintenance", "Machines Operating".
> 2.  **Service Order (OS) Cards:** Cards showing: Machine ID, Problem Description, mechanic assigned, and "Time Elapsed".
> 3.  **Cost Split:** Donut chart: "Labor Cost" vs "Parts Cost".
> 4.  **Preventive Schedule:** A timeline showing upcoming scheduled maintenance based on engine hours.
>
> **Aesthetic:** "Garage" feel but organized. High contrast for reading in the workshop.
