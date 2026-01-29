# SOAL Project: Master Frontend Specification & Dashboard Architecture

**Version:** 2.1 (Deep Technical Specification + MCP Architecture)
**Target Execution Environment:** Claude Code / Cursor Agent / Figma
**Context Reference:** `SOAL_AGENT_CONTEXT_MASTER.md`

---

## 1. Project Context & Architectural Vision

### The Mission
To obtain absolute financial and operational control of **Serra da Onça Agropecuária (SOAL)** as it scales from 2,000 to 20,000 hectares. The system must transform intuitive agricultural knowledge (28 years of experience) into precise, data-driven decision-making tools.

### User Personas (Strict Adherence Required)
*   **Claudio (The Owner):** Demands financial clarity. "Are we making money?" "What is my cost per hectare?" He has zero tolerance for fluff.
*   **Tiago (Operations):** Needs efficiency. "Which tractor is drinking too much diesel?" "Is the inventory sufficient for tomorrow?"
*   **Valentina (Financial/Admin):** Needs speed and accuracy. "Cash flow management," "Accounts payable/receivable organization."

### Design Philosophy: "Industrial Precision"
*   **No Fluff / No Emojis:** The UI must be serious, high-end, and professional. Think Bloomberg Terminal met John Deere Operations Center.
*   **Information Density:** High. Do not waste whitespace. Use tables, dense grids, and high-contrast typography.
*   **Tech Stack:** Next.js 14+ (App Router), TailwindCSS, Shadcn/UI (customized), Lucide React (Icons), Recharts (primary visualization).

---

## 2. Global Design System Parameters

### Color Palette (Tailwind Tokens)
*   **Backgrounds:**
    *   `bg-canvas`: `#09090b` (Main background)
    *   `bg-surface`: `#18181b` (Card/Panel background)
    *   `bg-surface-highlight`: `#27272a` (Hover states)
*   **Typography:**
    *   `text-primary`: `#f4f4f5` (Zinc-100)
    *   `text-secondary`: `#a1a1aa` (Zinc-400)
    *   `text-muted`: `#52525b` (Zinc-600)
*   **Semantic Accents:**
    *   `brand-primary`: `#10b981` (Emerald-500) - Revenue, Profit, Growth.
    *   `brand-danger`: `#ef4444` (Red-500) - Debt, Expenses, Alerts.
    *   `brand-warning`: `#f59e0b` (Amber-500) - Pending, Maintenance.
    *   `brand-info`: `#3b82f6` (Blue-500) - Active Status, Info.
    *   `agro-soy`: `#eab308` (Yellow-500) - Soy culture.
    *   `agro-corn`: `#f97316` (Orange-500) - Corn culture.

### Structural Layout
*   **Sidebar:** Collapsible, rigid, icon-only option.
*   **Top Bar:** Global filters (Safra Year, Farm).
*   **Grid System:** 12-column flexible grid.

---

## 3. Detailed Dashboard Specifications

*Refer to previous version for full dashboard details (Executive, Financial, Operational, Strategic).*
*(Full details retained in execution context)*

### 3.1. Executive Overview ("Raio-X da Safra")
*   **Target:** Claudio. **Goal:** Instant health check.
*   **Key Blocks:** Net Margin cards, Harvest Progress Gauge, Profitability Waterfall, Risk Alerts, Market Position Table.

### 3.2. Accounts Receivable
*   **Target:** Valentina. **Goal:** Liquidity tracking.
*   **Key Blocks:** KPI Strip (Total/Overdue), Cash Flow Timeline (Stacked Bar), Detailed Contract Table.

### 3.3. Accounts Payable
*   **Target:** Valentina. **Goal:** Cash flow management.
*   **Key Blocks:** Expense Treemap (Money bleeding breakdown), Daily/Weekly Totals, Calendar view integration.

### 3.4. Machinery & Diesel Intelligence
*   **Target:** Tiago. **Goal:** Efficiency.
*   **Key Blocks:** Fleet Cards (Status/Fuel/Operator), Efficiency Scatter Plot (Load vs Consumption), Anomaly Feed.

### 3.5. Grain Inventory & Commercialization
*   **Target:** Claudio. **Goal:** "Hold or Sell?"
*   **Key Blocks:** 2D Silo Visuals, "Sold vs Stored" Donut, Market Ticker (B3/Chicago), Logistics Queue.

### 3.6. Inputs Inventory
*   **Target:** Tiago. **Goal:** No stoppages.
*   **Key Blocks:** ABC Curve, Low Stock Alerts (Red Box), Replacement Cost Analysis.

### 3.7. Cost Accounting
*   **Target:** Claudio. **Goal:** Cost per Hectare.
*   **Key Blocks:** Drill-down Tree Map (Farm > Culture > Type), Cost/Ha Trend Line, Budget vs Executed.

### 3.8. Purchasing Programming
*   **Target:** Valentina. **Goal:** RFQ Management.
*   **Key Blocks:** Kanban Board (Request -> Order), "One-Click Approve" for Claudio.

### 3.9. Maintenance Hub
*   **Target:** Tiago. **Goal:** Reduce downtime.
*   **Key Blocks:** Workshop Triage Board, Parts Waitlist, Maintenance Cost/Hour history.

---

## 4. MCP Integration Strategy (The "Neural Link")

**Strategic Directive:** This system is not just a UI; it is an "Agent-Ready" platform. We use **MCP (Model Context Protocol)** to give AI agents direct, secure access to the farm's digital nervous system.

### 4.1. The "Why" (CTO Directive)
Without MCP, the AI is a passive chatbot that hallucinates data. With MCP, the AI becomes an **Operator** that can:
1.  **Read Real Truth:** Access the PostgreSQL 'Gold Layer' directly to answer "How much did we spend on fertilizer?" without looking at a dashboard.
2.  **Act on Reality:** Trigger N8N workflows (e.g., "Send Purchase Order") directly from the chat interface.

### 4.2. Required MCP Servers & Tools

#### A. Data Core: `postgresql-mcp-server`
*   **Role:** The single source of financial and operational truth.
*   **Access Level:** `READ_ONLY` (Safety First).
*   **Exposed Tables (Gold Layer):**
    *   `financial_kpis` (Daily cash flow summaries)
    *   `machine_telemetry_agg` (Daily fleet efficiency)
    *   `inventory_current` (Real-time stock levels)
*   **Key Tools:**
    *   `query_gold_layer(query: string)`: Execute safe SQL queries.
    *   `get_kpi_trend(metric: string, days: int)`: Quick fetch for standard metrics.

#### B. Automation Core: `n8n-mcp-server`
*   **Role:** The hands of the system. Triggering actions in the real world.
*   **Access Level:** `EXECUTE`.
*   **Exposed Webhooks:**
    *   `trigger_alert_whatsapp`: Send urgent alerts to Tiago/Claudio.
    *   `create_purchasing_request`: Start a purchasing workflow in the Kanban.
    *   `generate_pdf_report`: Create a formalized PDF of the current view.

#### C. Knowledge Core: `filesystem-mcp-server`
*   **Role:** Access to unstructured data (The "Shadow IT").
*   **Path:** `/docs/contracts` and `/docs/invoices`.
*   **Capability:** Allow the agent to "read" a specific PDF invoice when asked "What was the unit price on the last Bayer invoice?".

### 4.3. User Experience (Chat-with-Data)
*   **Scenario:** Claudio is looking at the *Machinery Dashboard* and sees a spike.
*   **Interaction:** He opens the AI Chat Sidebar and asks: *"Why is John Deere 8R-04 consuming 20% more today?"*
*   **Agent Flow:**
    1.  Context Awareness: Agent knows Claudio is looking at `dashboard/fleet`.
    2.  tool_call: `postgresql.query("SELECT operator_id, field_id FROM operations WHERE machine='8R-04' AND date=TODAY")`.
    3.  Insight: "It's working on **Field 12 (Hillside)** which has a steeper gradient, and the operator is a **Trainee**. This explains the distinct load increase."

---

## 5. Execution Plan for Claude Code Agents

**Master Instruction:**
"You are a Senior Frontend Architect & AI Systems Engineer. Customize components for the Agri-Business context. Ensure all UI components are 'MCP-Ready' (i.e., they export clean data contexts for the sidebar chat)."

**Suggested Sub-Agent Workflow:**
1.  **Design Agent:** Setup Next.js + Tailwind + safe Industrial Theme.
2.  **MCP Agent:** Setup the `api/mcp/` route handlers or client-side context providers that will bridge the UI state to the AI assistant.
3.  **Feature Agents:** Build the 9 Dashboards adhering to the specs.
4.  **Mock Data Agent:** Generate realistic JSON mocks that mirror the structure of the intended PostgreSQL tables.

**Final Deliverable:**
A MCP-Integrated Next.js application where dashboards are not just views, but data contexts ready for intelligent interrogation.
