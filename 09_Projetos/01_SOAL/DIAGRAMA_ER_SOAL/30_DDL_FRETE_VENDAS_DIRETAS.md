# DDL COMPLETO - MODULO FRETE + VENDAS DIRETAS

**Data:** 03/03/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 08 - ER Completo

---

## Pre-requisitos

Executar **antes** deste DDL:
- Doc 26 — Fundacional (organizations, safras, culturas, parceiros_comerciais)

---

## 1. Tabelas

### 1.1 FRETEIRO

```sql
-- =============================================
-- FRETEIRO - Viagens de frete campo → UBG
-- 116 viagens, 2 motoristas, 2 safras.
-- Custo de transporte interno (terceirizado).
-- =============================================

CREATE TABLE freteiros (
    freteiro_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id               UUID REFERENCES safras(id),

    -- Viagem
    nome_motorista         VARCHAR(100) NOT NULL,
    data_viagem            DATE NOT NULL,
    hora_viagem            TIME,
    placa                  VARCHAR(10),

    -- Carga
    produto                VARCHAR(100),                              -- SOJA, MILHO, etc.
    origem                 VARCHAR(100),                              -- nome da fazenda/talhao
    destino                VARCHAR(100),                              -- UBG, Castrolanda, etc.
    peso_kg                DECIMAL(12,2),

    -- Custo
    codigo_frete           VARCHAR(50),                               -- codigo do tipo de frete
    tarifa_por_ton         DECIMAL(10,2),
    valor_frete            DECIMAL(12,2),

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_freteiro_safra      ON freteiros(safra_id);
CREATE INDEX idx_freteiro_motorista  ON freteiros(nome_motorista);
CREATE INDEX idx_freteiro_data       ON freteiros(data_viagem);

-- Trigger
CREATE TRIGGER trg_freteiro_updated
    BEFORE UPDATE ON freteiros
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE freteiros IS 'Viagens de frete terceirizado campo→UBG. 116 viagens, 2 motoristas principais. R$40-50/ton.';
```

### 1.2 VENDA_DIRETA

```sql
-- =============================================
-- VENDA_DIRETA - Vendas diretas (sem cooperativa)
-- 73 vendas (feijao + inverno, 22/23→25/26).
-- Fonte: planilhas de vendas diretas.
-- =============================================

CREATE TABLE vendas_diretas (
    venda_direta_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id               UUID REFERENCES safras(id),
    cultura_id             UUID REFERENCES culturas(id),

    -- Venda
    data_venda             DATE NOT NULL,
    numero_nfe             VARCHAR(50),                               -- numero da NFe
    produtor               VARCHAR(100),                              -- SOAL, CK, etc.
    comprador              VARCHAR(200),                              -- ex: Mingote, Urutal
    tipo_feijao            VARCHAR(100),                              -- tipo especifico (ex: Urutal, Carioca)

    -- Valores
    quantidade_kg          DECIMAL(14,2),
    sacas                  DECIMAL(10,2),
    preco_unitario         DECIMAL(10,2),                             -- preco por saca
    valor_total            DECIMAL(14,2),
    imposto_senar          DECIMAL(12,2),
    valor_liquido          DECIMAL(14,2),

    -- Pagamento
    data_pagamento         DATE,
    conta_destino          VARCHAR(100),                              -- conta bancaria destino
    situacao               VARCHAR(100),                              -- status do pagamento

    -- Observacoes
    observacoes            TEXT,

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_venda_direta_safra    ON vendas_diretas(safra_id);
CREATE INDEX idx_venda_direta_cultura  ON vendas_diretas(cultura_id);
CREATE INDEX idx_venda_direta_data     ON vendas_diretas(data_venda);
CREATE INDEX idx_venda_direta_comprador ON vendas_diretas(comprador);

-- Trigger
CREATE TRIGGER trg_venda_direta_updated
    BEFORE UPDATE ON vendas_diretas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE vendas_diretas IS 'Vendas diretas sem intermediacao da cooperativa. Principalmente feijao. 73 vendas (22/23→25/26).';
```

---

## 2. Notas de Implementacao

### 2.1 Validacao Dijkstra

| FK proposta | Caminho alternativo | Hops | Decisao |
|-------------|---------------------|------|---------|
| `freteiro → maquinas` | motorista e terceirizado, nao usa maquina SOAL | — | NAO APLICAVEL |
| `freteiro → culturas` | produto e texto livre, nao FK | — | REMOVIDO |
| `venda_direta → parceiros_comerciais` | comprador e texto livre V0 | — | REMOVIDO |

### 2.2 Decisoes de Design

| Decisao | Justificativa |
|---------|---------------|
| `freteiro` sem FK para culturas | produto e texto livre no CSV (SOJA, MILHO). Futuramente pode virar FK |
| `venda_direta.tipo_feijao` texto | Classificacao especifica de feijao (Urutal, Carioca) nao e cultura SOAL |
| Tabelas separadas de vendas_grao | Vendas diretas tem schema diferente (sem bordero, sem filial, com tipo feijao) |

---

## 3. Ordem de Execucao

```
1. freteiros
2. vendas_diretas
```

---

## 4. Resumo

| Item | Quantidade |
|------|-----------|
| Tabelas | 2 |
| ENUMs | 0 |
| Indices | 7 |
| Triggers | 2 |

---

*Documento gerado em 03/03/2026 - DeepWork AI Flows*
*Baseado em CSVs coletados: 07_freteiros.csv (116 registros) + 05b_vendas_diretas.csv (73 registros)*
