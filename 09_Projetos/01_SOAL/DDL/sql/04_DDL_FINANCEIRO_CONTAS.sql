-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — DDL Financeiro: Nota Fiscal + Contas a Pagar/Receber (Fase 2)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS:
--   00_DDL_COMPLETO_V0.sql (tabelas base)
--   03_DDL_FINANCEIRO_CUSTEIO.sql (centro_custos)
--
-- CONTEÚDO:
--   7 ENUMs
--   4 tabelas: notas_fiscais, nota_fiscal_itens, contas_pagar, contas_receber
--   3 views: vw_contas_pagar_vencimento, vw_contas_receber_pipeline, vw_fluxo_caixa_projetado
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ENUMs                                                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE TYPE tipo_nota_fiscal AS ENUM ('entrada', 'saida');
CREATE TYPE status_nota_fiscal AS ENUM ('emitida', 'autorizada', 'cancelada', 'inutilizada', 'denegada');
CREATE TYPE origem_nota_fiscal AS ENUM ('sefaz', 'castrolanda', 'manual', 'importada');

CREATE TYPE categoria_conta_pagar AS ENUM (
    'insumo', 'servico', 'folha', 'arrendamento',
    'financiamento', 'imposto', 'consorcio', 'outros'
);

CREATE TYPE status_conta AS ENUM ('pendente', 'paga', 'recebida', 'vencida', 'cancelada');

CREATE TYPE forma_pagamento AS ENUM (
    'boleto', 'transferencia', 'pix', 'cheque', 'dinheiro', 'compensacao'
);

CREATE TYPE categoria_conta_receber AS ENUM (
    'venda_cooperativa', 'venda_direta', 'arrendamento_receber',
    'servico_prestado', 'restituicao', 'outros'
);


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  NOTAS_FISCAIS — NF-e / NFS-e                                ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Inicialmente sparse — derivado de vendas_grao.data_emissao_nf
-- e extrato_cooperativa.nf_referencia. XML SEFAZ é V1+.

CREATE TABLE notas_fiscais (
    nota_fiscal_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    chave_nfe             VARCHAR(44),
    numero                VARCHAR(20),
    serie                 VARCHAR(5),
    tipo                  tipo_nota_fiscal NOT NULL,
    status_nf             status_nota_fiscal DEFAULT 'autorizada',
    origem                origem_nota_fiscal DEFAULT 'manual',

    parceiro_id           UUID REFERENCES parceiros_comerciais(parceiro_comercial_id),

    data_emissao          DATE NOT NULL,
    data_entrada_saida    DATE,

    valor_produtos        DECIMAL(14,2),
    valor_frete           DECIMAL(14,2),
    valor_seguro          DECIMAL(14,2),
    valor_desconto        DECIMAL(14,2),
    valor_total           DECIMAL(14,2) NOT NULL,

    impostos_json         JSONB,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_nf_chave UNIQUE (chave_nfe)
);

CREATE INDEX idx_nf_org              ON notas_fiscais(organization_id);
CREATE INDEX idx_nf_chave            ON notas_fiscais(chave_nfe) WHERE chave_nfe IS NOT NULL;
CREATE INDEX idx_nf_numero           ON notas_fiscais(numero);
CREATE INDEX idx_nf_parceiro         ON notas_fiscais(parceiro_id) WHERE parceiro_id IS NOT NULL;
CREATE INDEX idx_nf_data             ON notas_fiscais(data_emissao);
CREATE INDEX idx_nf_tipo             ON notas_fiscais(tipo);
CREATE INDEX idx_nf_impostos         ON notas_fiscais USING GIN (impostos_json);

CREATE TRIGGER trg_nota_fiscal_updated
    BEFORE UPDATE ON notas_fiscais
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE notas_fiscais IS 'Notas fiscais eletrônicas. Inicialmente sparse (sem XML SEFAZ). Chave NFe = 44 chars. impostos_json = {icms, pis, cofins, ipi, etc}.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  NOTA_FISCAL_ITENS — Itens da NF                              ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE TABLE nota_fiscal_itens (
    nota_fiscal_item_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nota_fiscal_id        UUID NOT NULL REFERENCES notas_fiscais(nota_fiscal_id) ON DELETE CASCADE,

    produto_insumo_id     UUID REFERENCES produto_insumo(produto_insumo_id),

    sequencia             INTEGER NOT NULL,
    codigo_produto        VARCHAR(50),
    descricao             VARCHAR(300) NOT NULL,
    ncm                   VARCHAR(10),
    cfop                  VARCHAR(10),
    unidade               VARCHAR(20),

    quantidade            DECIMAL(14,4) NOT NULL,
    valor_unitario        DECIMAL(14,4) NOT NULL,
    valor_total           DECIMAL(14,2) NOT NULL,

    valor_desconto        DECIMAL(14,2),
    impostos_item_json    JSONB,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_nfi_nf              ON nota_fiscal_itens(nota_fiscal_id);
CREATE INDEX idx_nfi_produto         ON nota_fiscal_itens(produto_insumo_id) WHERE produto_insumo_id IS NOT NULL;

CREATE TRIGGER trg_nota_fiscal_item_updated
    BEFORE UPDATE ON nota_fiscal_itens
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE nota_fiscal_itens IS 'Itens de nota fiscal. CASCADE delete com nota_fiscal. NCM/CFOP para classificação fiscal.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CONTAS_PAGAR — Contas a pagar da Valentina                   ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- ETLs:
--   fluxo_caixa_fsi (10.119 débitos) → status='paga' (histórico)
--   financiamentos_coop (220 débitos) → categoria='financiamento'
--   consorcios_fsi (20 ativos) → parcelas recorrentes

CREATE TABLE contas_pagar (
    conta_pagar_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    parceiro_id           UUID REFERENCES parceiros_comerciais(parceiro_comercial_id),
    centro_custo_id       UUID REFERENCES centro_custos(centro_custo_id),
    nota_fiscal_id        UUID REFERENCES notas_fiscais(nota_fiscal_id),
    contrato_arrendamento_id UUID,  -- FK futuro → contratos_arrendamento (Fase 3)

    categoria             categoria_conta_pagar NOT NULL,
    descricao             TEXT NOT NULL,

    data_emissao          DATE NOT NULL,
    data_vencimento       DATE NOT NULL,
    data_pagamento        DATE,

    valor_original        DECIMAL(14,2) NOT NULL,
    valor_juros           DECIMAL(14,2) DEFAULT 0,
    valor_multa           DECIMAL(14,2) DEFAULT 0,
    valor_desconto        DECIMAL(14,2) DEFAULT 0,
    valor_pago            DECIMAL(14,2),

    forma_pagamento       forma_pagamento,
    conta_bancaria        VARCHAR(100),

    numero_parcela        INTEGER DEFAULT 1,
    total_parcelas        INTEGER DEFAULT 1,

    status_conta          status_conta DEFAULT 'pendente',

    -- Rastreabilidade Bronze
    source_table          VARCHAR(50),
    source_id             UUID,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_cp_org              ON contas_pagar(organization_id);
CREATE INDEX idx_cp_parceiro         ON contas_pagar(parceiro_id) WHERE parceiro_id IS NOT NULL;
CREATE INDEX idx_cp_cc               ON contas_pagar(centro_custo_id) WHERE centro_custo_id IS NOT NULL;
CREATE INDEX idx_cp_nf               ON contas_pagar(nota_fiscal_id) WHERE nota_fiscal_id IS NOT NULL;
CREATE INDEX idx_cp_categoria        ON contas_pagar(categoria);
CREATE INDEX idx_cp_vencimento       ON contas_pagar(data_vencimento);
CREATE INDEX idx_cp_status           ON contas_pagar(status_conta);
CREATE INDEX idx_cp_source           ON contas_pagar(source_table, source_id);

CREATE TRIGGER trg_conta_pagar_updated
    BEFORE UPDATE ON contas_pagar
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contas_pagar IS 'Contas a pagar — operação diária da Valentina. ETLs: fluxo_caixa_fsi (10.119), financiamentos_coop (220), consorcios_fsi (20).';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CONTAS_RECEBER — Recebíveis (vendas, serviços)               ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- ETLs:
--   vendas_grao (170) → data_credito, valor_credito
--   vendas_diretas (73) → data_pagamento

CREATE TABLE contas_receber (
    conta_receber_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    parceiro_id           UUID REFERENCES parceiros_comerciais(parceiro_comercial_id),
    nota_fiscal_id        UUID REFERENCES notas_fiscais(nota_fiscal_id),
    contrato_comercial_id UUID,  -- FK futuro → contratos_comerciais (Fase 3)

    categoria             categoria_conta_receber NOT NULL,
    descricao             TEXT NOT NULL,

    data_emissao          DATE NOT NULL,
    data_vencimento       DATE NOT NULL,
    data_recebimento      DATE,

    valor_original        DECIMAL(14,2) NOT NULL,
    valor_juros           DECIMAL(14,2) DEFAULT 0,
    valor_desconto        DECIMAL(14,2) DEFAULT 0,
    valor_recebido        DECIMAL(14,2),

    forma_pagamento       forma_pagamento,
    conta_bancaria        VARCHAR(100),

    numero_parcela        INTEGER DEFAULT 1,
    total_parcelas        INTEGER DEFAULT 1,

    status_conta          status_conta DEFAULT 'pendente',

    -- Rastreabilidade Bronze
    source_table          VARCHAR(50),
    source_id             UUID,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_cr_org              ON contas_receber(organization_id);
CREATE INDEX idx_cr_parceiro         ON contas_receber(parceiro_id) WHERE parceiro_id IS NOT NULL;
CREATE INDEX idx_cr_nf               ON contas_receber(nota_fiscal_id) WHERE nota_fiscal_id IS NOT NULL;
CREATE INDEX idx_cr_categoria        ON contas_receber(categoria);
CREATE INDEX idx_cr_vencimento       ON contas_receber(data_vencimento);
CREATE INDEX idx_cr_status           ON contas_receber(status_conta);
CREATE INDEX idx_cr_source           ON contas_receber(source_table, source_id);

CREATE TRIGGER trg_conta_receber_updated
    BEFORE UPDATE ON contas_receber
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contas_receber IS 'Contas a receber — vendas cooperativa, diretas, serviços. ETLs: vendas_grao (170), vendas_diretas (73).';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEWS — Contas P/R                                           ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── View: Contas a pagar por vencimento (Dashboard 03) ────────
CREATE OR REPLACE VIEW vw_contas_pagar_vencimento AS
SELECT
    cp.conta_pagar_id,
    cp.descricao,
    cp.categoria,
    cp.data_vencimento,
    cp.valor_original,
    cp.valor_pago,
    cp.status_conta,
    cp.forma_pagamento,
    cp.numero_parcela,
    cp.total_parcelas,
    pc.nome AS parceiro_nome,
    cc.codigo AS centro_custo_codigo,
    cc.nome AS centro_custo_nome,
    CASE
        WHEN cp.status_conta IN ('paga', 'cancelada') THEN 'resolvido'
        WHEN cp.data_vencimento < CURRENT_DATE THEN 'vencido'
        WHEN cp.data_vencimento <= CURRENT_DATE + INTERVAL '7 days' THEN 'vence_7d'
        WHEN cp.data_vencimento <= CURRENT_DATE + INTERVAL '15 days' THEN 'vence_15d'
        WHEN cp.data_vencimento <= CURRENT_DATE + INTERVAL '30 days' THEN 'vence_30d'
        ELSE 'futuro'
    END AS urgencia
FROM contas_pagar cp
LEFT JOIN parceiros_comerciais pc ON cp.parceiro_id = pc.parceiro_comercial_id
LEFT JOIN centro_custos cc ON cp.centro_custo_id = cc.centro_custo_id
WHERE cp.status = 'active';

COMMENT ON VIEW vw_contas_pagar_vencimento IS 'Heatmap calendar de contas a pagar com urgência. Dashboard 03.';


-- ─── View: Pipeline de contas a receber (Dashboard 02) ─────────
CREATE OR REPLACE VIEW vw_contas_receber_pipeline AS
SELECT
    cr.conta_receber_id,
    cr.descricao,
    cr.categoria,
    cr.data_vencimento,
    cr.data_recebimento,
    cr.valor_original,
    cr.valor_recebido,
    cr.status_conta,
    pc.nome AS parceiro_nome,
    CASE
        WHEN cr.status_conta IN ('recebida', 'cancelada') THEN 'resolvido'
        WHEN cr.data_vencimento < CURRENT_DATE THEN 'atrasado'
        WHEN cr.data_vencimento <= CURRENT_DATE + INTERVAL '7 days' THEN 'proximo'
        WHEN cr.data_vencimento <= CURRENT_DATE + INTERVAL '30 days' THEN 'mes_atual'
        ELSE 'futuro'
    END AS pipeline_status
FROM contas_receber cr
LEFT JOIN parceiros_comerciais pc ON cr.parceiro_id = pc.parceiro_comercial_id
WHERE cr.status = 'active';

COMMENT ON VIEW vw_contas_receber_pipeline IS 'Timeline de recebíveis por parceiro/status. Dashboard 02.';


-- ─── View: Fluxo de caixa projetado (buckets 7/15/30/60/90 dias)
CREATE OR REPLACE VIEW vw_fluxo_caixa_projetado AS
WITH periodos AS (
    SELECT
        unnest(ARRAY['0-7d', '8-15d', '16-30d', '31-60d', '61-90d']) AS bucket,
        unnest(ARRAY[
            CURRENT_DATE + INTERVAL '7 days',
            CURRENT_DATE + INTERVAL '15 days',
            CURRENT_DATE + INTERVAL '30 days',
            CURRENT_DATE + INTERVAL '60 days',
            CURRENT_DATE + INTERVAL '90 days'
        ])::DATE AS data_fim,
        unnest(ARRAY[
            CURRENT_DATE,
            CURRENT_DATE + INTERVAL '8 days',
            CURRENT_DATE + INTERVAL '16 days',
            CURRENT_DATE + INTERVAL '31 days',
            CURRENT_DATE + INTERVAL '61 days'
        ])::DATE AS data_inicio
),
pagar AS (
    SELECT
        p.bucket,
        COALESCE(SUM(cp.valor_original - COALESCE(cp.valor_pago, 0)), 0) AS total_pagar
    FROM periodos p
    LEFT JOIN contas_pagar cp ON cp.data_vencimento BETWEEN p.data_inicio AND p.data_fim
        AND cp.status_conta IN ('pendente', 'vencida')
        AND cp.status = 'active'
    GROUP BY p.bucket, p.data_inicio
),
receber AS (
    SELECT
        p.bucket,
        COALESCE(SUM(cr.valor_original - COALESCE(cr.valor_recebido, 0)), 0) AS total_receber
    FROM periodos p
    LEFT JOIN contas_receber cr ON cr.data_vencimento BETWEEN p.data_inicio AND p.data_fim
        AND cr.status_conta IN ('pendente', 'vencida')
        AND cr.status = 'active'
    GROUP BY p.bucket, p.data_inicio
)
SELECT
    p.bucket,
    p.data_inicio,
    p.data_fim,
    COALESCE(pg.total_pagar, 0) AS total_pagar,
    COALESCE(rc.total_receber, 0) AS total_receber,
    COALESCE(rc.total_receber, 0) - COALESCE(pg.total_pagar, 0) AS saldo_projetado
FROM periodos p
LEFT JOIN pagar pg ON pg.bucket = p.bucket
LEFT JOIN receber rc ON rc.bucket = p.bucket
ORDER BY p.data_inicio;

COMMENT ON VIEW vw_fluxo_caixa_projetado IS 'Projeção cash flow: recebíveis - pagáveis por bucket temporal (7d, 15d, 30d, 60d, 90d).';


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIM — Fase 2: Nota Fiscal + Contas a Pagar/Receber
-- Resumo: 7 ENUMs, 4 tabelas, 3 views
-- Próximo: 05_DDL_FINANCEIRO_CONTRATOS.sql (Fase 3)
-- ═══════════════════════════════════════════════════════════════════════════════
