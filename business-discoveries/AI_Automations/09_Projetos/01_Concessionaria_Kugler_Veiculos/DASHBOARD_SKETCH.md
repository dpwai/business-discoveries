# Dashboard Design Specification - Kugler Veiculos

## Overview
This dashboard is designed for the managers/owners of Kugler Veiculos to monitor the Funilaria & Pintura (Body Shop) operations in real-time. It integrates data from the NBS ERP and manual shop-floor inputs.

## Visual Style
-   **Theme**: Professional, Clean, Data-Centric.
-   **Colors**: Deepwork AI Flows Palette (Deep Ocean `#0A2342`, Core Blue `#0066FF`, White backgrounds).
-   **Layout**: Grid-based, responsive.

## Sections

### 1. Header
-   **Left**: Logo (Kugler Veiculos / Deepwork AI Flows).
-   **Right**: Current Date/Time, User Profile, Notification Bell.

### 2. Top KPI Cards (The "Pulse")
Four main cards displaying critical metrics:
1.  **Carros no Pátio (Cars in Yard)**: Total count (e.g., 24). Trend indicator (e.g., +2 vs yesterday).
2.  **Faturamento Projetado (Projected Billing)**: Current projection vs Meta (e.g., R$ 145k / 180k). Progress bar.
3.  **Eficiência da Equipe (Team Efficiency)**: Percentage (e.g., 82%). Color-coded (Green/Yellow/Red).
4.  **Ticket Médio (Average Ticket)**: Value (e.g., R$ 2.450).

### 3. Main Content Area (Split View)

#### Left Column: Real-Time Alerts & Bottlenecks (Priority)
-   **Title**: "Gargalos e Alertas"
-   **List Items**:
    -   ⚠️ 3 Carros aguardando peças (+48h).
    -   ⚠️ Funileiro "João" ocioso há 45min.
    -   ⚠️ Veículo ABC-1234 atrasado na Pintura.

#### Right Column: Production Flow & Forecast
-   **Chart**: "Veículos por Etapa" (Funnel or Bar Chart showing count in Funilaria, Pintura, Montagem, Polimento).
-   **List**: "Previsão de Entregas" (Today/Tomorrow).

### 4. Footer / Ticker
-   Scrolling status updates or simple summary (e.g., "Meta do Dia: 5 Entregas | Realizado: 2").

## Image Generation Prompt
> Professional BI dashboard UI design for an auto body shop management system. Dark blue header with "Kugler Veiculos" logo. Top row with 4 white KPI cards showing numbers and trend arrows. Main section split: Left side has a list of alert notifications with warning icons. Right side has a bar chart showing vehicle status distribution (Bodywork, Paint, Assembly). Clean, modern, minimalist interface, high resolution, Figma style, #0A2342 and #0066FF color scheme.
