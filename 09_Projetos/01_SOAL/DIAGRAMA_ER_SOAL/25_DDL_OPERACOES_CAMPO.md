# DDL COMPLETO - MODULO OPERACOES DE CAMPO

**Data:** 28/02/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 09 - OPERACOES DE CAMPO AGRICULTURA

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES - Modulo Operacoes de Campo
-- =============================================

-- Tipo de operacao de campo (22 tipos)
CREATE TYPE tipo_operacao_campo AS ENUM (
    -- Preparo de solo
    'aracao',
    'gradagem_pesada',
    'gradagem_niveladora',
    'subsolagem',
    'escarificacao',
    'terraceamento',
    -- Manejo pre-plantio
    'dessecacao_pre_plantio',
    'calagem',
    'gessagem',
    -- Plantio
    'plantio',
    'replantio',
    -- Tratos culturais
    'pulverizacao_herbicida',
    'pulverizacao_inseticida',
    'pulverizacao_fungicida',
    'pulverizacao_foliar',
    'aplicacao_drone',
    'adubacao_cobertura',
    'irrigacao',
    -- Colheita
    'colheita',
    'dessecacao_pre_colheita',
    -- Outras
    'monitoramento',
    'transporte_interno'
);

-- Status da operacao
CREATE TYPE status_operacao_campo AS ENUM (
    'planejada',
    'em_andamento',
    'concluida',
    'cancelada'
);

-- Tipo de transporte (para TRANSPORTE_COLHEITA_DETALHE)
CREATE TYPE tipo_transporte AS ENUM (
    'proprio',
    'terceiro'
);
```

---

## 2. Tabela Principal

### 2.1 OPERACAO_CAMPO

```sql
-- =============================================
-- OPERACAO_CAMPO - Entidade HUB (9+ conexoes)
-- Registro de toda atividade agricola no campo.
-- Campos comuns centralizados; detalhes em filhas 1:0..1.
-- =============================================

CREATE TABLE operacoes_campo (
    operacao_campo_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    talhao_safra_id       UUID NOT NULL REFERENCES talhao_safras(id),
    maquina_id            UUID REFERENCES maquinas(id),         -- NULL para operacoes manuais (monitoramento)
    operador_id           UUID REFERENCES operadores(id),       -- NULL para operacoes terceirizadas
    fazenda_id            UUID REFERENCES fazendas(id),         -- DENORM: derivavel via talhao_safra→talhoes→fazendas (3 hops)

    -- Classificacao
    tipo                  tipo_operacao_campo NOT NULL,
    status                status_operacao_campo NOT NULL DEFAULT 'concluida',

    -- Temporalidade
    data_inicio           DATE NOT NULL,
    data_fim              DATE,

    -- Metricas de campo
    area_trabalhada_ha    DECIMAL(10,4),
    horimetro_inicio      DECIMAL(12,2),
    horimetro_fim         DECIMAL(12,2),
    combustivel_litros    DECIMAL(10,2),

    -- Custo (calculado via trigger ou manual)
    custo_operacao        DECIMAL(12,2),

    -- Contexto
    implemento_codigo     VARCHAR(50),              -- codigo informal do implemento (ex: "PLANTADEIRA 643")
    observacoes           TEXT,
    geojson_trajeto       JSONB,                    -- trajeto GPS (futuro: John Deere)

    -- Auditoria
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_operacao_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_operacao_horimetro CHECK (
        horimetro_fim IS NULL OR horimetro_inicio IS NULL OR horimetro_fim >= horimetro_inicio
    ),
    CONSTRAINT chk_operacao_area CHECK (area_trabalhada_ha IS NULL OR area_trabalhada_ha > 0)
);

-- Indices
CREATE INDEX idx_operacoes_campo_talhao_safra ON operacoes_campo(talhao_safra_id);
CREATE INDEX idx_operacoes_campo_maquina      ON operacoes_campo(maquina_id);
CREATE INDEX idx_operacoes_campo_tipo         ON operacoes_campo(tipo);
CREATE INDEX idx_operacoes_campo_data         ON operacoes_campo(data_inicio);
CREATE INDEX idx_operacoes_campo_fazenda      ON operacoes_campo(fazenda_id);     -- DENORM justifica indice

COMMENT ON COLUMN operacoes_campo.fazenda_id IS 'DENORM: 3 hops via talhao_safra→talhoes→fazendas. Mantido para performance em filtros por fazenda.';
COMMENT ON COLUMN operacoes_campo.implemento_codigo IS 'Referencia textual ao implemento usado (ex: PLANTADEIRA 643, PRIMA 082). Nao FK — implementos nao tem cadastro formal V0.';
```

---

## 3. Entidades Detalhe (filhas 1:0..1)

### 3.1 PLANTIO_DETALHE

```sql
-- =============================================
-- PLANTIO_DETALHE
-- Ativado quando tipo IN ('plantio', 'replantio')
-- =============================================

CREATE TABLE plantio_detalhes (
    plantio_detalhe_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(id) ON DELETE CASCADE,

    -- Dados de plantio
    variedade             VARCHAR(100),               -- cultivar plantada
    populacao_sementes_ha INTEGER,                     -- sementes/ha
    espacamento_cm        DECIMAL(6,2),                -- entre linhas
    profundidade_cm       DECIMAL(4,2),                -- profundidade de semeadura
    tratamento_sementes   VARCHAR(200),                -- produtos de TSI
    adubo_base            VARCHAR(200),                -- formulacao (ex: "08-20-20")
    quantidade_adubo_kg_ha DECIMAL(8,2),               -- kg/ha
    umidade_solo_percent  DECIMAL(5,2),                -- no momento do plantio

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE plantio_detalhes IS 'Detalhe 1:0..1 de OPERACAO_CAMPO para tipo plantio/replantio.';
```

### 3.2 COLHEITA_DETALHE

```sql
-- =============================================
-- COLHEITA_DETALHE
-- Ativado quando tipo = 'colheita'
-- KPI central: produtividade_sacas_ha
-- =============================================

CREATE TABLE colheita_detalhes (
    colheita_detalhe_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(id) ON DELETE CASCADE,

    -- Producao
    producao_total_kg     DECIMAL(12,2),
    produtividade_kg_ha   DECIMAL(10,2),
    produtividade_sacas_ha DECIMAL(10,2),              -- KPI CENTRAL da fazenda

    -- Qualidade
    umidade_media_percent DECIMAL(5,2),
    perdas_estimadas_percent DECIMAL(5,2),

    -- Performance da colheitadeira
    velocidade_media_kmh  DECIMAL(6,2),
    condicoes_climaticas  JSONB,                       -- {temperatura, umidade_ar, chuva_mm}

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_colheita_producao CHECK (producao_total_kg IS NULL OR producao_total_kg >= 0),
    CONSTRAINT chk_colheita_produtividade CHECK (produtividade_sacas_ha IS NULL OR produtividade_sacas_ha >= 0)
);

COMMENT ON COLUMN colheita_detalhes.produtividade_sacas_ha IS 'KPI central: sacas/ha. Soja saca=60kg, Milho saca=60kg, Trigo saca=60kg.';
```

### 3.3 PULVERIZACAO_DETALHE

```sql
-- =============================================
-- PULVERIZACAO_DETALHE
-- Ativado quando tipo LIKE 'pulverizacao_%'
-- Dados TECNICOS apenas. Produto aplicado via APLICACAO_INSUMO.
-- =============================================

CREATE TABLE pulverizacao_detalhes (
    pulverizacao_detalhe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id       UUID NOT NULL UNIQUE REFERENCES operacoes_campo(id) ON DELETE CASCADE,

    -- Alvo
    alvo                  VARCHAR(200),                -- praga/doenca/daninha

    -- Parametros de aplicacao
    dose_ha               DECIMAL(10,4),               -- dose produto/ha
    volume_calda_ha       DECIMAL(8,2),                -- litros calda/ha
    vazao_bico            DECIMAL(8,4),                -- litros/min por bico
    pressao_bar           DECIMAL(6,2),                -- pressao de trabalho

    -- Condicoes climaticas (criticas para eficacia)
    temperatura_c         DECIMAL(4,1),                -- ideal: 20-30C
    umidade_relativa      DECIMAL(5,2),                -- ideal: >55%
    velocidade_vento_kmh  DECIMAL(5,2),                -- ideal: <10 km/h

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE pulverizacao_detalhes IS 'Dados TECNICOS da pulverizacao. Produto aplicado registrado via APLICACAO_INSUMO (Doc 16), nao aqui.';
```

### 3.4 DRONE_DETALHE

```sql
-- =============================================
-- DRONE_DETALHE
-- Ativado quando tipo = 'aplicacao_drone'
-- Produto aplicado via APLICACAO_INSUMO (mesmo que pulverizacao).
-- =============================================

CREATE TABLE drone_detalhes (
    drone_detalhe_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(id) ON DELETE CASCADE,

    -- Equipamento
    modelo_drone          VARCHAR(100),

    -- Parametros de voo
    altitude_voo_m        DECIMAL(6,2),
    velocidade_voo_ms     DECIMAL(6,2),
    largura_faixa_m       DECIMAL(6,2),
    volume_calda_ha       DECIMAL(8,2),

    -- Performance
    autonomia_bateria_min INTEGER,
    numero_voos           INTEGER,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### 3.5 TRANSPORTE_COLHEITA_DETALHE

```sql
-- =============================================
-- TRANSPORTE_COLHEITA_DETALHE
-- Ativado quando tipo = 'transporte_interno'
-- PONTE entre ciclo agricola e ciclo UBG.
-- =============================================

CREATE TABLE transporte_colheita_detalhes (
    transporte_colheita_detalhe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(id) ON DELETE CASCADE,

    -- Origem e destino
    colheita_origem_id    UUID REFERENCES operacoes_campo(id),  -- auto-ref: qual colheita gerou esta carga
    ticket_balanca_id     UUID REFERENCES ticket_balancas(id),  -- chegada na UBG (preenchido apos pesagem)

    -- Viagem
    numero_viagem         INTEGER,
    placa_veiculo         VARCHAR(10),
    motorista             VARCHAR(100),
    tipo_transporte       tipo_transporte DEFAULT 'proprio',
    transportadora        VARCHAR(100),                         -- se tipo = 'terceiro'

    -- Tempos
    hora_saida_campo      TIMESTAMP WITH TIME ZONE,
    hora_chegada_ubg      TIMESTAMP WITH TIME ZONE,

    -- Carga
    peso_estimado_kg      DECIMAL(12,2),
    distancia_km          DECIMAL(8,2),

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transporte_horarios CHECK (
        hora_chegada_ubg IS NULL OR hora_saida_campo IS NULL OR hora_chegada_ubg >= hora_saida_campo
    ),
    CONSTRAINT chk_transporte_terceiro CHECK (
        tipo_transporte != 'terceiro' OR transportadora IS NOT NULL
    )
);

COMMENT ON TABLE transporte_colheita_detalhes IS 'Ponte agricultura→UBG. Conecta OPERACAO_CAMPO(colheita) ao TICKET_BALANCA via transporte.';
```

---

## 4. Trigger de Updated_at

```sql
-- =============================================
-- TRIGGER: auto-update updated_at
-- =============================================

CREATE OR REPLACE FUNCTION fn_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_operacoes_campo_updated
    BEFORE UPDATE ON operacoes_campo
    FOR EACH ROW EXECUTE FUNCTION fn_update_timestamp();
```

---

## 5. Notas de Implementacao

### 5.1 FK DENORM: fazenda_id

`fazenda_id` em `operacoes_campo` e derivavel via `talhao_safra → talhoes → fazendas` (3 hops = gray zone pela regra Dijkstra 4.1). Mantido no DDL com comentario DENORM por performance — 90% das queries filtram por fazenda. **NAO desenhar no diagrama ER.**

### 5.2 FKs REMOVIDAS (validacao Dijkstra Doc 19)

| FK removida | Caminho alternativo | Hops | Decisao |
|-------------|---------------------|------|---------|
| `pulverizacao_detalhe → produto_insumo` | PULV → OPERACAO ← APLICACAO → ESTOQUE → PRODUTO | 4 | REMOVIDO |
| `drone_detalhe → produto_insumo` | mesmo caminho | 4 | REMOVIDO |
| `pulverizacao_detalhe → receituario_agro` | PULV → OPERACAO ← APLICACAO → RECEITUARIO | 3 | REMOVIDO |

### 5.3 Conexao com Modulo Insumos (Doc 16)

```
OPERACAO_CAMPO ←── 1:N ──→ APLICACAO_INSUMO
```

A tabela `aplicacao_insumo` (Doc 16) ja tem `operacao_campo_id UUID REFERENCES operacoes_campo(id)` com constraint:
```sql
CONSTRAINT chk_aplicacao_contexto_agricola CHECK (
    contexto != 'agricola' OR (operacao_campo_id IS NOT NULL AND talhao_safra_id IS NOT NULL)
)
```

### 5.4 Implemento como texto (nao FK)

V0 nao tem cadastro formal de implementos. O campo `implemento_codigo` armazena referencia textual (ex: "PLANTADEIRA 643", "PRIMA 082"). Futuramente pode virar FK para tabela de implementos.

---

*Documento gerado em 28/02/2026 - DeepWork AI Flows*
*Baseado em Doc 09 (Operacoes Campo) + Doc 16 (Insumos DDL) + Doc 19 (Relacionamentos validados)*
