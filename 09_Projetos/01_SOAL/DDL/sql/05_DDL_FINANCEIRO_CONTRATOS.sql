-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — DDL Financeiro: Contratos + Comercialização + Depreciação (Fase 3)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS:
--   00_DDL_COMPLETO_V0.sql (tabelas base)
--   03_DDL_FINANCEIRO_CUSTEIO.sql (centro_custos)
--   04_DDL_FINANCEIRO_CONTAS.sql (notas_fiscais, contas_receber)
--
-- CONTEÚDO:
--   3 ENUMs
--   5 tabelas: contratos_comerciais, contrato_entregas, cpr_documentos,
--              contratos_arrendamento, depreciacao_ativos
--   1 tabela associativa: contrato_arrendamento_talhoes
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ENUMs                                                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE TYPE tipo_contrato_comercial AS ENUM (
    'venda_antecipada', 'barter', 'fixacao', 'cpr', 'spot'
);

CREATE TYPE status_contrato AS ENUM (
    'negociacao', 'ativo', 'cumprido', 'cancelado', 'vencido'
);

CREATE TYPE metodo_depreciacao AS ENUM (
    'linear', 'por_uso', 'acelerada'
);


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CONTRATOS_COMERCIAIS — Venda de grãos                        ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- ETL: vendas_grao (170) → agrupar por `contrato` → contratos distintos
-- "Quanto já entreguei do contrato Castrolanda?" — Claudio

CREATE TABLE contratos_comerciais (
    contrato_comercial_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    parceiro_id           UUID REFERENCES parceiros_comerciais(parceiro_comercial_id),
    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),

    tipo                  tipo_contrato_comercial NOT NULL,
    status_contrato       status_contrato DEFAULT 'ativo',

    numero_contrato       VARCHAR(50),
    descricao             TEXT,

    data_inicio           DATE,
    data_fim              DATE,

    quantidade_kg         DECIMAL(14,2),
    quantidade_sacas      DECIMAL(14,2),
    preco_por_saca        DECIMAL(10,2),
    valor_total           DECIMAL(14,2),

    -- Barter específico
    barter_produto_insumo_id UUID REFERENCES produto_insumo(produto_insumo_id),
    barter_valor_insumo   DECIMAL(14,2),

    -- Progresso
    quantidade_entregue_kg DECIMAL(14,2) DEFAULT 0,
    valor_recebido        DECIMAL(14,2) DEFAULT 0,
    pct_entregue          DECIMAL(5,2) DEFAULT 0,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_contrato_numero UNIQUE (organization_id, numero_contrato)
);

CREATE INDEX idx_contrato_org        ON contratos_comerciais(organization_id);
CREATE INDEX idx_contrato_parceiro   ON contratos_comerciais(parceiro_id) WHERE parceiro_id IS NOT NULL;
CREATE INDEX idx_contrato_safra      ON contratos_comerciais(safra_id);
CREATE INDEX idx_contrato_cultura    ON contratos_comerciais(cultura_id);
CREATE INDEX idx_contrato_tipo       ON contratos_comerciais(tipo);
CREATE INDEX idx_contrato_status     ON contratos_comerciais(status_contrato);

CREATE TRIGGER trg_contrato_comercial_updated
    BEFORE UPDATE ON contratos_comerciais
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contratos_comerciais IS 'Contratos de venda de grãos. Derivados de vendas_grao (170, agrupar por campo contrato). Tipos: venda_antecipada, barter, fixação, CPR, spot.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CONTRATO_ENTREGAS — Entregas contra contrato                 ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- ETL: cargas_a_carga (1.309) → cada carga = 1 entrega contra contrato

CREATE TABLE contrato_entregas (
    contrato_entrega_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contrato_comercial_id UUID NOT NULL REFERENCES contratos_comerciais(contrato_comercial_id),

    nota_fiscal_id        UUID REFERENCES notas_fiscais(nota_fiscal_id),
    ticket_balanca_id     UUID REFERENCES ticket_balancas(ticket_balanca_id),
    saida_grao_id         UUID REFERENCES saidas_grao(saida_grao_id),
    carga_a_carga_id      UUID REFERENCES cargas_a_carga(carga_a_carga_id),

    data_entrega          DATE NOT NULL,
    quantidade_kg         DECIMAL(14,2) NOT NULL,
    quantidade_sacas      DECIMAL(14,2),

    numero_documento      VARCHAR(50),
    placa                 VARCHAR(10),
    motorista             VARCHAR(100),

    qualidade_json        JSONB,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ce_contrato         ON contrato_entregas(contrato_comercial_id);
CREATE INDEX idx_ce_data             ON contrato_entregas(data_entrega);
CREATE INDEX idx_ce_carga            ON contrato_entregas(carga_a_carga_id) WHERE carga_a_carga_id IS NOT NULL;

CREATE TRIGGER trg_contrato_entrega_updated
    BEFORE UPDATE ON contrato_entregas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contrato_entregas IS 'Entregas individuais contra contrato comercial. ETL: cargas_a_carga (1.309). Rastreabilidade: ticket_balanca + saida_grao + NF.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CPR_DOCUMENTOS — Cédula de Produto Rural                    ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Inicialmente vazio — dados pendentes Valentina

CREATE TABLE cpr_documentos (
    cpr_documento_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),
    contrato_comercial_id UUID REFERENCES contratos_comerciais(contrato_comercial_id),

    numero_cpr            VARCHAR(50),
    tipo_cpr              VARCHAR(20) DEFAULT 'fisica',  -- fisica, financeira
    data_emissao          DATE,
    data_vencimento       DATE,

    produto               VARCHAR(100),
    quantidade_kg         DECIMAL(14,2),
    valor_total           DECIMAL(14,2),

    credor                VARCHAR(200),
    cartorio              VARCHAR(200),
    registro_cartorio     VARCHAR(50),

    status_cpr            VARCHAR(20) DEFAULT 'ativo',

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_cpr_org             ON cpr_documentos(organization_id);
CREATE INDEX idx_cpr_contrato        ON cpr_documentos(contrato_comercial_id) WHERE contrato_comercial_id IS NOT NULL;

CREATE TRIGGER trg_cpr_documento_updated
    BEFORE UPDATE ON cpr_documentos
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE cpr_documentos IS 'Cédulas de Produto Rural (CPR). Inicialmente vazio — Valentina coleta. Vinculado a contrato comercial quando tipo=CPR.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CONTRATOS_ARRENDAMENTO + N:N com talhões                    ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Inicialmente vazio — dados pendentes Valentina

CREATE TABLE contratos_arrendamento (
    contrato_arrendamento_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id          UUID NOT NULL REFERENCES organizations(organization_id),

    parceiro_id              UUID REFERENCES parceiros_comerciais(parceiro_comercial_id),

    numero_contrato          VARCHAR(50),
    descricao                TEXT,

    data_inicio              DATE,
    data_fim                 DATE,

    area_total_ha            DECIMAL(10,2),
    valor_por_ha             DECIMAL(10,2),
    valor_total_anual        DECIMAL(14,2),
    forma_pagamento          VARCHAR(100),

    status_contrato          status_contrato DEFAULT 'ativo',

    observacoes              TEXT,

    status                   VARCHAR(20) DEFAULT 'active',
    created_at               TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at               TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_arr_org             ON contratos_arrendamento(organization_id);
CREATE INDEX idx_arr_parceiro        ON contratos_arrendamento(parceiro_id) WHERE parceiro_id IS NOT NULL;
CREATE INDEX idx_arr_status          ON contratos_arrendamento(status_contrato);

CREATE TRIGGER trg_contrato_arrendamento_updated
    BEFORE UPDATE ON contratos_arrendamento
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contratos_arrendamento IS 'Contratos de arrendamento de terra. Valentina coleta. FK parceiro = arrendador.';

-- Tabela associativa N:N: contrato_arrendamento × talhão
CREATE TABLE contrato_arrendamento_talhoes (
    contrato_arrendamento_id UUID NOT NULL REFERENCES contratos_arrendamento(contrato_arrendamento_id) ON DELETE CASCADE,
    talhao_id                UUID NOT NULL REFERENCES talhoes(talhao_id),
    area_ha                  DECIMAL(10,2),
    PRIMARY KEY (contrato_arrendamento_id, talhao_id)
);

CREATE INDEX idx_cat_talhao ON contrato_arrendamento_talhoes(talhao_id);


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  DEPRECIACAO_ATIVOS — Depreciação de máquinas/implementos     ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Seed: 1 registro por máquina ativa (57+126 = 183).
-- Valores estimados, Tiago confirma depois.

CREATE TABLE depreciacao_ativos (
    depreciacao_ativo_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    maquina_id            UUID NOT NULL REFERENCES maquinas(maquina_id),

    metodo                metodo_depreciacao DEFAULT 'linear',

    data_aquisicao        DATE,
    valor_aquisicao       DECIMAL(14,2),
    valor_residual        DECIMAL(14,2) DEFAULT 0,
    vida_util_anos        INTEGER,
    vida_util_horas       INTEGER,

    depreciacao_mensal     DECIMAL(14,2),
    depreciacao_acumulada  DECIMAL(14,2) DEFAULT 0,
    valor_contabil_atual   DECIMAL(14,2),

    data_ultimo_calculo    DATE,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_depreciacao_maquina UNIQUE (maquina_id)
);

CREATE INDEX idx_dep_org             ON depreciacao_ativos(organization_id);
CREATE INDEX idx_dep_maquina         ON depreciacao_ativos(maquina_id);
CREATE INDEX idx_dep_metodo          ON depreciacao_ativos(metodo);

CREATE TRIGGER trg_depreciacao_ativo_updated
    BEFORE UPDATE ON depreciacao_ativos
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE depreciacao_ativos IS 'Depreciação de máquinas e implementos. 1 registro por ativo. Métodos: linear, por_uso (horas), acelerada. Valores estimados, Tiago valida.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ALTER TABLES — Adicionar FKs das Fases anteriores            ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- Fase 2 → Fase 3: contas_pagar.contrato_arrendamento_id
ALTER TABLE contas_pagar
    ADD CONSTRAINT fk_cp_contrato_arrendamento
    FOREIGN KEY (contrato_arrendamento_id) REFERENCES contratos_arrendamento(contrato_arrendamento_id);

-- Fase 2 → Fase 3: contas_receber.contrato_comercial_id
ALTER TABLE contas_receber
    ADD CONSTRAINT fk_cr_contrato_comercial
    FOREIGN KEY (contrato_comercial_id) REFERENCES contratos_comerciais(contrato_comercial_id);

-- Fase 1 → Fase 2: custo_operacoes.nota_fiscal_id
ALTER TABLE custo_operacoes
    ADD CONSTRAINT fk_co_nota_fiscal
    FOREIGN KEY (nota_fiscal_id) REFERENCES notas_fiscais(nota_fiscal_id);


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIM — Fase 3: Contratos + Comercialização + Depreciação
-- Resumo: 3 ENUMs, 5 tabelas + 1 tabela associativa, 3 ALTERs
-- Próximo: 06_VIEWS_GOLD_FINANCEIRO.sql (Fase 4)
-- ═══════════════════════════════════════════════════════════════════════════════
