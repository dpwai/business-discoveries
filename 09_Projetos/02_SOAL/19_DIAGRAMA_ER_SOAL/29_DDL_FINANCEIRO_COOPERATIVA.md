# DDL COMPLETO - MODULO FINANCEIRO COOPERATIVA (CASTROLANDA)

**Data:** 03/03/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 08 - ER Completo, camada Financeira (Orange)

---

## Pre-requisitos

Executar **antes** deste DDL:
- Doc 26 — Fundacional (organizations, safras, culturas, parceiros_comerciais)

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES - Modulo Financeiro Cooperativa
-- =============================================

-- Tipo de transacao no extrato por cultura
CREATE TYPE tipo_transacao_extrato AS ENUM (
    'saldo_anterior',
    'fornecimento',
    'transferencia',
    'credito_venda',
    'debito_compra',
    'desconto',
    'juros',
    'outro'
);

-- Tipo de transacao na conta corrente geral
CREATE TYPE tipo_transacao_cc AS ENUM (
    'saldo_anterior',
    'fornecimento',
    'transferencia',
    'credito_venda',
    'debito_compra',
    'pagamento',
    'desconto',
    'juros',
    'taxa',
    'outro'
);

-- Tipo de movimento capital
CREATE TYPE tipo_transacao_capital AS ENUM (
    'retencao',
    'capitalizacao',
    'devolucao',
    'juros',
    'outro'
);

-- Tipo de financiamento
CREATE TYPE tipo_financiamento_coop AS ENUM (
    'custeio',
    'investimento',
    'comercializacao',
    'capital_giro',
    'outro'
);

-- Modalidade da carga (Castrolanda)
CREATE TYPE modalidade_carga AS ENUM (
    'moagem',
    'semente',
    'consumo',
    'outro'
);
```

---

## 2. Tabelas

### 2.1 EXTRATO_COOPERATIVA

```sql
-- =============================================
-- EXTRATO_COOPERATIVA - Extrato por cultura
-- 8.211 transacoes, multiplas culturas.
-- Fonte: portal Castrolanda, export HTML/XLS.
-- =============================================

CREATE TABLE extratos_cooperativa (
    extrato_cooperativa_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- Identificacao cooperado
    matricula              VARCHAR(20) NOT NULL,                      -- matricula na Castrolanda (ex: 3156)
    cooperado              VARCHAR(200),                              -- nome do cooperado

    -- Conta/Cultura
    conta_codigo           VARCHAR(20),                               -- codigo interno Castrolanda (ex: 14)
    conta_descricao        VARCHAR(100),                              -- nome da cultura/conta (ex: CEVADA)
    safra_ref              VARCHAR(20),                               -- referencia de safra se houver

    -- Movimento
    data_movimento         DATE,
    descricao              TEXT NOT NULL,
    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),                                   -- D=debito, C=credito
    tipo_transacao         tipo_transacao_extrato NOT NULL DEFAULT 'outro',

    -- Referencia NF
    nf_referencia          VARCHAR(100),

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_extrato_coop_matricula ON extratos_cooperativa(matricula);
CREATE INDEX idx_extrato_coop_conta     ON extratos_cooperativa(conta_codigo);
CREATE INDEX idx_extrato_coop_data      ON extratos_cooperativa(data_movimento);
CREATE INDEX idx_extrato_coop_tipo      ON extratos_cooperativa(tipo_transacao);

-- Trigger
CREATE TRIGGER trg_extrato_coop_updated
    BEFORE UPDATE ON extratos_cooperativa
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE extratos_cooperativa IS 'Extrato Castrolanda por cultura. Cada conta e uma cultura (SOJA, MILHO, CEVADA, etc.). 8.211 transacoes historicas.';
```

### 2.2 CC_COOPERATIVA

```sql
-- =============================================
-- CC_COOPERATIVA - Conta corrente geral
-- 2.889 transacoes (Fev/2020 → Fev/2026).
-- Movimento consolidado de todas as culturas.
-- =============================================

CREATE TABLE cc_cooperativa (
    cc_cooperativa_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- Identificacao
    matricula              VARCHAR(20),
    cooperado              VARCHAR(200),

    -- Movimento
    data_movimento         DATE,
    num_lancamento         VARCHAR(50),                               -- numero do lancamento Castrolanda
    descricao              TEXT NOT NULL,
    cod_operacao           VARCHAR(100),                              -- codigo de operacao Castrolanda
    referencia             VARCHAR(200),                              -- referencia adicional

    -- Valores
    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),                                   -- D=debito, C=credito
    tipo_transacao         tipo_transacao_cc NOT NULL DEFAULT 'outro',

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_cc_coop_matricula ON cc_cooperativa(matricula);
CREATE INDEX idx_cc_coop_data      ON cc_cooperativa(data_movimento);
CREATE INDEX idx_cc_coop_tipo      ON cc_cooperativa(tipo_transacao);

-- Trigger
CREATE TRIGGER trg_cc_coop_updated
    BEFORE UPDATE ON cc_cooperativa
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE cc_cooperativa IS 'Conta corrente geral Castrolanda. Movimento consolidado de todas as operacoes. 2.889 transacoes (6 anos).';
```

### 2.3 CONTA_CAPITAL

```sql
-- =============================================
-- CONTA_CAPITAL - Capital social na cooperativa
-- 77 registros (2 contas: Materia Prima + UBC).
-- Retencoes, capitalizacoes, devolucoes.
-- =============================================

CREATE TABLE contas_capital (
    conta_capital_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- Identificacao
    cooperado              VARCHAR(200),
    conta_codigo           VARCHAR(20),                               -- ex: 24 (Mat.Prima), 39 (UBC)
    conta_descricao        VARCHAR(100),                              -- ex: MATERIA PRIMA, UBC

    -- Movimento
    data_movimento         DATE,
    historico              VARCHAR(200),                              -- tipo de historico
    descricao              TEXT,
    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),
    tipo_transacao         tipo_transacao_capital NOT NULL DEFAULT 'outro',

    -- Referencia NF
    nf_referencia          VARCHAR(100),

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_conta_capital_conta ON contas_capital(conta_codigo);
CREATE INDEX idx_conta_capital_data  ON contas_capital(data_movimento);
CREATE INDEX idx_conta_capital_tipo  ON contas_capital(tipo_transacao);

-- Trigger
CREATE TRIGGER trg_conta_capital_updated
    BEFORE UPDATE ON contas_capital
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contas_capital IS 'Capital social retido na Castrolanda. Contas 24 (Mat.Prima) e 39 (UBC). 77 registros.';
```

### 2.4 FINANCIAMENTO_COOP

```sql
-- =============================================
-- FINANCIAMENTO_COOP - Contratos de financiamento
-- 22 contratos (9 ativos), 220 movimentos totais.
-- Fonte: Fichas Graficas (PDF Castrolanda).
-- =============================================

CREATE TABLE financiamentos_coop (
    financiamento_coop_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- Contrato
    num_contrato           VARCHAR(50) NOT NULL,
    tipo_financiamento     tipo_financiamento_coop NOT NULL DEFAULT 'outro',

    -- Metadados do contrato (preenchidos no header da ficha)
    data_liberacao         DATE,
    vencimento_final       DATE,
    taxa_juros             DECIMAL(8,4),                              -- % ao periodo
    parcelas               INTEGER,
    modalidade             VARCHAR(100),

    -- Movimento
    data_movimento         DATE,
    historico              TEXT,
    credito                DECIMAL(14,2),
    debito                 DECIMAL(14,2),
    saldo                  DECIMAL(14,2),

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_financiamento_contrato ON financiamentos_coop(num_contrato);
CREATE INDEX idx_financiamento_tipo     ON financiamentos_coop(tipo_financiamento);
CREATE INDEX idx_financiamento_data     ON financiamentos_coop(data_movimento);

-- Trigger
CREATE TRIGGER trg_financiamento_coop_updated
    BEFORE UPDATE ON financiamentos_coop
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE financiamentos_coop IS 'Financiamentos via Castrolanda. 22 contratos (9 ativos). Dados das Fichas Graficas do extrato PDF.';
```

### 2.5 VENDA_GRAO

```sql
-- =============================================
-- VENDA_GRAO - Vendas de grao via cooperativa
-- 170 vendas historicas (13 safras, 6 culturas).
-- Fonte: planilhas de vendas Castrolanda.
-- =============================================

CREATE TABLE vendas_grao (
    venda_grao_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id               UUID REFERENCES safras(id),
    cultura_id             UUID REFERENCES culturas(id),

    -- Venda
    data_venda             DATE NOT NULL,
    numero_venda           VARCHAR(50),                               -- numero interno Castrolanda
    contrato               VARCHAR(50),                               -- codigo contrato (ex: VS35724-2)
    comprador              VARCHAR(200),                              -- ex: Cargill, Louis Dreyfus

    -- Logistica
    armazem                VARCHAR(50),                               -- codigo armazem
    filial                 VARCHAR(50),                               -- codigo filial
    municipio              VARCHAR(50),                               -- codigo municipio
    data_emissao_nf        DATE,
    data_embarque          DATE,
    frete_por_ton          DECIMAL(10,2),

    -- Valores
    peso_kg                DECIMAL(14,2),
    preco_por_saca         DECIMAL(10,2),
    valor_bruto            DECIMAL(14,2),
    desconto_bordero       DECIMAL(14,2),
    valor_nota_fiscal      DECIMAL(14,2),
    desconto_nf            DECIMAL(14,2),
    valor_credito          DECIMAL(14,2),
    data_credito           DATE,

    -- Emissor
    emissor_nf             VARCHAR(100),                              -- SOAL, CK, etc.

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_venda_grao_safra    ON vendas_grao(safra_id);
CREATE INDEX idx_venda_grao_cultura  ON vendas_grao(cultura_id);
CREATE INDEX idx_venda_grao_data     ON vendas_grao(data_venda);
CREATE INDEX idx_venda_grao_contrato ON vendas_grao(contrato);

-- Trigger
CREATE TRIGGER trg_venda_grao_updated
    BEFORE UPDATE ON vendas_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE vendas_grao IS 'Vendas de grao via Castrolanda. R$99.3M bruto historico, 170 vendas, 13 safras (18/19→25/26).';
```

### 2.6 CARGA_A_CARGA

```sql
-- =============================================
-- CARGA_A_CARGA - Relatorio carga-a-carga Castrolanda
-- 1.337 cargas, 7 culturas, 6 safras (20/21→25/26).
-- Detalhe de cada entrega na cooperativa com metricas
-- de qualidade especificas por cultura (JSON).
-- =============================================

CREATE TABLE cargas_a_carga (
    carga_a_carga_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id               UUID REFERENCES safras(id),
    cultura_id             UUID REFERENCES culturas(id),

    -- Produto
    produto_codigo         VARCHAR(20),                               -- codigo Castrolanda (ex: 079567)
    produto_nome           VARCHAR(200),                              -- ex: Soja Intacta IPRO
    cultivar               VARCHAR(100),                              -- IPRO, NEO, etc.

    -- Documento
    num_docto              VARCHAR(50),
    nota_fiscal            VARCHAR(50),
    data_entrega           DATE NOT NULL,
    modalidade             modalidade_carga DEFAULT 'moagem',

    -- Pesagem
    peso_bruto_kg          DECIMAL(12,2),
    peso_liquido_kg        DECIMAL(12,2),
    rec_sec                DECIMAL(8,2),                              -- rendimento apos secagem (%)

    -- Origem
    talhao                 VARCHAR(100),
    filial                 VARCHAR(20),
    placa                  VARCHAR(10),
    motorista              VARCHAR(100),

    -- Qualidade (PH)
    ph_inicial             DECIMAL(5,2),
    ph_final               DECIMAL(5,2),
    fn                     DECIMAL(8,2),                              -- falling number (trigo)

    -- Qualidade detalhada (varia por cultura)
    qualidade_json         JSONB,                                     -- {umidade_pct, impureza_pct, ardidos_pct, ...}

    -- Rastreabilidade
    arquivo_origem         VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_carga_safra    ON cargas_a_carga(safra_id);
CREATE INDEX idx_carga_cultura  ON cargas_a_carga(cultura_id);
CREATE INDEX idx_carga_data     ON cargas_a_carga(data_entrega);
CREATE INDEX idx_carga_produto  ON cargas_a_carga(produto_codigo);
CREATE INDEX idx_carga_qualidade ON cargas_a_carga USING GIN (qualidade_json);

-- Trigger
CREATE TRIGGER trg_carga_a_carga_updated
    BEFORE UPDATE ON cargas_a_carga
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE cargas_a_carga IS 'Relatorio carga-a-carga Castrolanda. 1.337 entregas com qualidade detalhada por cultura (JSON). 42.4k ton bruto.';
COMMENT ON COLUMN cargas_a_carga.qualidade_json IS 'Metricas de qualidade variam por cultura: soja(umidade,impureza,ardidos), trigo(umidade,ph,fn), etc.';
```

### 2.7 CUSTO_INSUMO_COOP

```sql
-- =============================================
-- CUSTO_INSUMO_COOP - Custos de insumos via cooperativa
-- 553 registros (soja 24/25 + feijao 25/26).
-- Fonte: planilhas de custo insumos Castrolanda.
-- =============================================

CREATE TABLE custos_insumo_coop (
    custo_insumo_coop_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id               UUID REFERENCES safras(id),
    cultura_id             UUID REFERENCES culturas(id),

    -- Produto
    categoria              VARCHAR(100),                              -- COMPOSTOS, HERBICIDAS, etc.
    nome_produto           VARCHAR(300),
    codigo_produto         VARCHAR(50),                               -- codigo Castrolanda
    unidade                VARCHAR(20),                               -- KG, L, UN

    -- Operacao
    data_emissao           DATE,
    numero_nf              VARCHAR(50),
    tipo_operacao          VARCHAR(50),                               -- 2-SIMPLES REMESSA, 5-VENDA

    -- Valores
    quantidade             DECIMAL(14,4),
    preco_unitario         DECIMAL(14,4),
    valor_total            DECIMAL(14,2),

    -- Devoluicao/Venda
    quantidade_vendida     DECIMAL(14,4),
    valor_vendido          DECIMAL(14,2),

    -- Rastreabilidade
    source_file            VARCHAR(200),

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_custo_insumo_safra    ON custos_insumo_coop(safra_id);
CREATE INDEX idx_custo_insumo_cultura  ON custos_insumo_coop(cultura_id);
CREATE INDEX idx_custo_insumo_produto  ON custos_insumo_coop(codigo_produto);
CREATE INDEX idx_custo_insumo_data     ON custos_insumo_coop(data_emissao);

-- Trigger
CREATE TRIGGER trg_custo_insumo_coop_updated
    BEFORE UPDATE ON custos_insumo_coop
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE custos_insumo_coop IS 'Custos de insumos fornecidos via Castrolanda. 553 registros (soja 24/25 + feijao 25/26).';
```

---

## 3. Notas de Implementacao

### 3.1 Validacao Dijkstra — FKs Removidas

| FK proposta | Caminho alternativo | Hops | Decisao |
|-------------|---------------------|------|---------|
| `venda_grao → parceiros_comerciais` | comprador e texto livre V0 | — | REMOVIDO |
| `carga_a_carga → talhao_safras` | talhao e texto livre, sem match garantido | — | REMOVIDO |
| `custo_insumo_coop → produto_insumo` | codigo_produto e referencia Castrolanda, nao FK SOAL | — | REMOVIDO |
| `cc_cooperativa → extratos_cooperativa` | sao visoes independentes do mesmo extrato | — | NAO APLICAVEL |

### 3.2 Decisoes de Design

| Decisao | Justificativa |
|---------|---------------|
| `carga_a_carga.qualidade_json` JSONB | Metricas variam por cultura (3-7 campos). JSONB evita colunas esparsas |
| Tabelas separadas por tipo de extrato | Extrato por cultura, C/C geral, e capital tem schemas distintos |
| `matricula` como VARCHAR, nao FK | Matricula Castrolanda e identificador externo, nao entidade SOAL |
| Sem FK entre vendas e saidas | Venda Castrolanda e saida UBG tem granularidade diferente (1 venda = N cargas) |

### 3.3 Conexoes com Outros Modulos

```
Doc 26:  organizations, safras, culturas
         └─→ referenciados por todas as 7 tabelas

Doc 28:  saidas_grao (UBG)
         └─→ complementar a vendas_grao (cooperativa) — mesma venda, visoes diferentes

Doc 16:  produto_insumo
         └─→ custo_insumo_coop referencia por codigo_produto (texto), nao FK
```

---

## 4. Ordem de Execucao

```
1. ENUM types (5)
2. extratos_cooperativa
3. cc_cooperativa
4. contas_capital
5. financiamentos_coop
6. vendas_grao
7. cargas_a_carga
8. custos_insumo_coop
```

---

## 5. Resumo

| Item | Quantidade |
|------|-----------|
| Tabelas | 7 |
| ENUMs | 5 |
| Indices | 18 |
| Triggers | 7 |
| Constraints CHECK | 0 |
| Constraints UNIQUE | 0 |

---

*Documento gerado em 03/03/2026 - DeepWork AI Flows*
*Baseado em Doc 08 (ER Completo) + 7 CSVs Castrolanda coletados (extrato, cc, capital, financiamentos, vendas, carga-a-carga, custo_insumos)*
