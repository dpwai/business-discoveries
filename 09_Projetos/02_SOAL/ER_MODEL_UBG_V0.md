# UBG ER Diagram Architecture (V0)
**System Layer:** DeepWork Platform - Agribusiness Domain
**Module:** Unidade de Beneficiamento de Grãos (UBG)
**Date:** 25/02/2026

## 1. Principles Applied
Following the ER Diagram Architect Agent rules:
1. **Inside-Out Approach:** All entities abstract the core business process rather than specific integrations.
2. **Dijkstra's Shortest Path FK Validation:** Relationships are optimized to eliminate redundancy. Leaf entities connect exclusively to direct parents.
3. **Multi-Tenancy:** The implicit relationship `organization_id -> organizations` exists in all tables but is omitted from relationship mapping traces to maintain graph purity.
4. **Naming Standards:** Tables are plural snake_case, entities are PascalCase, PKs are `[entity]_id`.

---

## 2. Entity Definitions

### 2.1 Core Reception Entities

**Entity: ScaleTicket** (ticket_balanca)
*Represents the truck entering and leaving the scale.*
- **Table:** `scale_tickets`
- **PK:** `ticket_id` (UUID)
- **Relationships:**
  - FK `harvest_id` -> `harvests` (Safra)
  - FK `machinery_id` -> `machineries` (Truck)
  - FK `sub_area_id` -> `sub_areas` (Talhão de Origem)
- **Fields:**
  - `gross_weight` (DECIMAL) - Peso cheio
  - `tare_weight` (DECIMAL) - Peso vazio (tara)
  - `net_weight` (DECIMAL) - Peso líquido calculado
  - `entry_time` (TIMESTAMP)
  - `exit_time` (TIMESTAMP)
  - `status` (VARCHAR) - active, deleted
  - `created_at` / `updated_at` (TIMESTAMP)

**Entity: GrainClassification** (recebimento_grao)
*Represents the sample classification taken at the moega. Leaf entity to ScaleTicket.*
- **Table:** `grain_classifications`
- **PK:** `classification_id` (UUID)
- **Relationships:**
  - FK `ticket_id` -> `scale_tickets` **(ONLY connection - Dijkstra Rule)**
- **Fields:**
  - `moisture_pct` (DECIMAL) - Umidade (%)
  - `impurity_pct` (DECIMAL) - Impureza (%)
  - `damaged_pct` (DECIMAL) - Ardidos (%)
  - `sprouted_pct` (DECIMAL) - Brotados (%)
  - `status` (VARCHAR)
  - `created_at` / `updated_at` (TIMESTAMP)

### 2.2 Processing & Drying Entities

**Entity: DryingControl** (controle_secagem)
*Represents a batch running through the dryer. Loads blend in the buffer ("pulmão"), so it relates to the Harvest, not specific tickets.*
- **Table:** `drying_controls`
- **PK:** `drying_id` (UUID)
- **Relationships:**
  - FK `harvest_id` -> `harvests`
  - FK `grain_id` -> `grains` (Type of grain: Soy, Corn, Beans)
- **Fields:**
  - `start_time` (TIMESTAMP)
  - `end_time` (TIMESTAMP)
  - `initial_moisture` (DECIMAL)
  - `final_moisture` (DECIMAL)
  - `drying_hours` (DECIMAL) - Used for proportional cost allocation (firewood/energy)
  - `status` (VARCHAR)
  - `created_at` / `updated_at` (TIMESTAMP)

### 2.3 Storage & Inventory Entities

**Entity: Silo** (silos)
*Represents the physical storage units (8 silos at UBG).*
- **Table:** `silos`
- **PK:** `silo_id` (UUID)
- **Relationships:** None direct except organization.
- **Fields:**
  - `identifier` (VARCHAR) - e.g., "Silo 1", "Silo Madeira"
  - `capacity_tons` (DECIMAL)
  - `type` (VARCHAR) - "convencional", "madeira"
  - `status` (VARCHAR)
  - `created_at` / `updated_at` (TIMESTAMP)

**Entity: SiloInventory** (estoque_silo)
*Represents period check-ins of estimated volume inside a silo.*
- **Table:** `silo_inventories`
- **PK:** `inventory_id` (UUID)
- **Relationships:**
  - FK `silo_id` -> `silos`
  - FK `grain_id` -> `grains`
  - FK `harvest_id` -> `harvests`
- **Fields:**
  - `estimated_tons` (DECIMAL) - Calculated visually or via pH/thermometry
  - `grain_density_ph` (DECIMAL) - Peso hectolítrico (pH)
  - `measurement_date` (TIMESTAMP)
  - `status` (VARCHAR)
  - `created_at` / `updated_at` (TIMESTAMP)

**Entity: SiloMovement** (movimentacao_silo / saida_grao)
*Represents the flow of grain out of the silo for external sale or internal consumption.*
- **Table:** `silo_movements`
- **PK:** `movement_id` (UUID)
- **Relationships:**
  - FK `silo_id` -> `silos`
  - FK `ticket_id` -> `scale_tickets` (Optional: If the exit goes through the scale)
- **Fields:**
  - `movement_type` (VARCHAR) - "Commodity", "Semente", "Ração", "Transilagem"
  - `destination_silo_id` (UUID) - Only for Transilagem
  - `volume_tons` (DECIMAL)
  - `movement_date` (TIMESTAMP)
  - `status` (VARCHAR)
  - `created_at` / `updated_at` (TIMESTAMP)

---

## 3. Dijkstra's Rule Validations (Redundancy Checks Mapped)
- ❌ **GrainClassification -> Harvest:** Redundant. `GrainClassification` -> `ScaleTicket` -> `Harvest` (Distance = 2). Did not draw.
- ❌ **GrainClassification -> Machinery:** Redundant. `GrainClassification` -> `ScaleTicket` -> `Machinery` (Distance = 2). Did not draw.
- ❌ **SiloMovement -> Harvest:** Redundant. `SiloMovement` -> `SiloInventory` -> `Harvest` or via `ScaleTicket` (Distance = 2).
- ✅ **SiloMovement -> Silo:** Kept. Direct flow out of physical storage.

## 4. Next Steps for Miro Board
- Create blue connectors exclusively linking exact paths outlined above.
- Add an orange sticky note: *"All UBG entities carry organization_id -> organizations (Multi-tenancy). Not drawn."*
- Separate the "Processo" pipeline (Scale -> Drying) from the "Storage" pipeline (Silo -> Movement), connected conceptually by the Harvest/Grain hub.
