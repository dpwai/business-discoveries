# DIAGNOSTIC REPORT
Serra da Onça Agropecuária (SOAL)

**Focus Area:** Unidade de Beneficiamento de Grãos (UBG) - Meeting Transcript Analysis
**Date Classification:** 25/02/2026
**Prepared by:** DeepWork AI Flows
**Version:** 1.0

---
"Transforming intuition into precision"

## 1. Executive Summary

**Context**
SOAL operates a complex grain processing unit (UBG) involving receiving grain from the fields, classifying it, drying it, storing it in silos, and managing dispatch for commodities (external sales) and internal consumption (seeds and livestock).

**Core Challenge**
Currently, calculating the real cost of grain processing per crop type and tracking the exact inventory in silos relies on manual spreadsheet consolidation, visual estimations based on grain density, and broad proportional allocations for resources like firewood and electricity. 

**Key Findings**
- **Harvest Entry and Classification:** The truck weights (full and empty) are recorded along with technical grain characteristics (moisture, impurities, damaged, sprouted). Water evaporation and impurities are discounted mathematically to estimate the final volume of clean, dry grain. 
- **Silo Inventory Math:** Real-time silo inventory is not precisely weighed on dispatch to silos. It is estimated via visual checks, standard volume formulas factoring the grain density (pH), and data from a highly fragile IoT thermometry system.
- **Resource Allocation (Firewood):** Firewood is currently allocated proportionally based on the *drying time* per crop type (e.g., corn arrives with 30% moisture and takes significantly longer than soy at 16-18%). Exact per-batch calculation is impossible as the same boiler heats different dryers simultaneously.
- **Internal Billing:** Grain processed into seeds or livestock feed represents an internal transaction (the UBG essentially "sells" a service to the farm). If this isn't recorded as an internal sale, the UBG's operational cost falsely inflates.

**Recommended Path**
Implement the V0 MVP focusing exclusively on the initial receipt, classification, and real-time calculation of processed grain inventory availability, alongside basic internal and external outflows. Resource and cost allocations should be added in a subsequent phase.

---

## 2. Current State Analysis

### 2.1 Systems and Data Landscape

| System | Function | Data Quality | Integration Status | Notes |
|--------|----------|--------------|-------------------|-------|
| Excel Spreadsheets | Grain Reception & Classification | Medium | Isolated | Josmar records sample data; Vanessa/Maria digitalizes later. |
| Vidtec Thermometry | Silo internal temperature | Low | Isolated | System has frequent outages ("fragile") but is critical for monitoring grain cooling. |
| Visual Inspection | Inventory tracking | Medium | Manual | Physical silo volume combined with density (pH) is used to estimate tons available. |

### 2.2 Process Mapping

**Process: Recebimento e Beneficiamento de Grãos**

- **Current Flow:** Truck arrives from the field and gets weighed full (Balança - Vanessa). It proceeds to the Moega (Josmar) where a sample is taken to check humidity, impurities, and damaged grains ("ardidos, brotados"). It gets cleaned, dried, cooled, and stored in a "pulmão" (buffer) before silo allocation. The truck returns to the scale to be weighed empty (tara).
- **Pain Points:** Double data entry (from notebook to Excel). Operational complexity restricts operators from manual data entry.
- **Data Touchpoints:** Scale, Moisture tester, Excel spreadsheets.
- **Stakeholder Impact:** Vanessa (Scale), Josmar (Moega/Dryer), Leomar (Gestor UBG).

**Process: Controle de Lenha (Secagem)**
- **Current Flow:** An initial stock of firewood is visually estimated (e.g., 800m³). After harvest finishes, the total usage is proportionally allocated to the crops (corn, soy, beans) based on the recorded *hours of dryer operation*, not exact cubic meters per batch.

### 2.3 Shadow IT and Workarounds

- "Média de Tara": For internal farm trucks during peak operation, instead of weighing empty every time, they use a fixed average weight (e.g., 13.2 tons) to speed up flow. 
- "pH/Volume Math": Using grain density (pH) to roughly calculate how much tonnage is currently sitting in a silo based on its physical capacity, because there are no flow scales measuring input/output volume of the silos directly.

---

## 3. Answers to Preparation Questions (Highlights)

- **Q1/5 (Balança / Responsabilidade):** The scale is the exact transition point where the grain moves from "crop" (lavoura) to "UBG". The origin field (talhão) is mandatory at the scale to allocate clean/dry grain availability back to the crop's yield management.
- **Q6 (Classificação):** Josmar captures: Humidity, Impurities, "Ardidos" (Damaged), and "Brotados" (Sprouted). 
- **Q16-21 (Armazenagem):** Product from different fields merges in the buffer ("pulmão") and becomes one consolidated batch per silo, excet for contaminated or defective grain which must be segregated.
- **Q22-30 (Rateio):** It is proportional by *time in dryer* (tempo de secagem). Cannot calculate per batch immediately because the boiler serves multiple lines simultaneously. This confirms the ER design should rely on proportional allocation algorithms running periodically, rather than strictly transactional costs.
- **Q32-38 (Saídas):** Outflow for seeds and livestock feed internalizes a service cost; the Farm must "purchase" it from UBG to balance UBG's operational cost sheets.

## 4. Next Steps

### Immediate Actions (DeepWork)
1. Complete the V0 interface prioritizing absolute simplicity (large buttons, drop-downs) for operators.
2. Structure the `ER_MODEL_UBG_V0.md` incorporating the *Inside-Out* and *Shortest Path* (Dijkstra) rules to map the data flow from `Machinery` and `Harvest` to `Recebimento` and `Secagem`.

### Decision Points
- [x] Confirmed the 4-phase core flow: Scale -> Moega -> Dryer -> Silo
- [x] Confirmed allocation mechanics (based on drying time)
- [x] Adopt baseline manual tracking for silo volume via density calculation on Phase 0 MVP.
