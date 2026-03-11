-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — ETL Bronze → Silver: Contas a Pagar/Receber (Fase 2)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- FONTES BRONZE:
--   1. fluxo_caixa_fsi (10.119) → split débito=CONTA_PAGAR, crédito=CONTA_RECEBER
--   2. financiamentos_coop (220) → CONTA_PAGAR, categoria='financiamento'
--   3. consorcios_fsi (20) → CONTA_PAGAR recorrente
--   4. vendas_grao (170) → CONTA_RECEBER
--   5. vendas_diretas (73) → CONTA_RECEBER
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 1: fluxo_caixa_fsi DÉBITO → contas_pagar               ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Status='paga' porque são registros históricos já liquidados.
-- Parceiro: fuzzy match por descricao (limitado — unmatched ficam NULL).

INSERT INTO contas_pagar (
    organization_id, categoria, descricao,
    data_emissao, data_vencimento, data_pagamento,
    valor_original, valor_pago, status_conta,
    conta_bancaria,
    source_table, source_id
)
SELECT
    fc.organization_id,
    CASE
        WHEN fc.setor ILIKE '%folha%' OR fc.setor ILIKE '%rh%' OR fc.descricao ILIKE '%salari%' OR fc.descricao ILIKE '%fgts%' OR fc.descricao ILIKE '%inss%'
            THEN 'folha'
        WHEN fc.descricao ILIKE '%impost%' OR fc.descricao ILIKE '%irpj%' OR fc.descricao ILIKE '%csll%' OR fc.descricao ILIKE '%icms%' OR fc.descricao ILIKE '%pis%' OR fc.descricao ILIKE '%cofins%'
            THEN 'imposto'
        WHEN fc.descricao ILIKE '%arrend%'
            THEN 'arrendamento'
        WHEN fc.descricao ILIKE '%financ%' OR fc.descricao ILIKE '%emprést%' OR fc.descricao ILIKE '%parcela%'
            THEN 'financiamento'
        WHEN fc.descricao ILIKE '%insumo%' OR fc.descricao ILIKE '%sement%' OR fc.descricao ILIKE '%fertil%' OR fc.descricao ILIKE '%defensiv%'
            THEN 'insumo'
        WHEN fc.descricao ILIKE '%serviç%' OR fc.descricao ILIKE '%consult%' OR fc.descricao ILIKE '%manut%'
            THEN 'servico'
        ELSE 'outros'
    END::categoria_conta_pagar,
    fc.descricao,
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    fc.debito,
    fc.debito,
    'paga',
    fc.conta_bancaria,
    'fluxo_caixa_fsi',
    fc.fluxo_caixa_fsi_id
FROM fluxo_caixa_fsi fc
WHERE fc.status = 'active'
  AND fc.debito IS NOT NULL
  AND fc.debito > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 2: fluxo_caixa_fsi CRÉDITO → contas_receber             ║
-- ╚═══════════════════════════════════════════════════════════════╝

INSERT INTO contas_receber (
    organization_id, categoria, descricao,
    data_emissao, data_vencimento, data_recebimento,
    valor_original, valor_recebido, status_conta,
    conta_bancaria,
    source_table, source_id
)
SELECT
    fc.organization_id,
    CASE
        WHEN fc.descricao ILIKE '%venda%' OR fc.descricao ILIKE '%castrolanda%credito%'
            THEN 'venda_cooperativa'
        WHEN fc.descricao ILIKE '%feij%' OR fc.descricao ILIKE '%direto%'
            THEN 'venda_direta'
        WHEN fc.descricao ILIKE '%restitu%' OR fc.descricao ILIKE '%devoluc%'
            THEN 'restituicao'
        ELSE 'outros'
    END::categoria_conta_receber,
    fc.descricao,
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    COALESCE(fc.data, MAKE_DATE(fc.ano, COALESCE(fc.mes, 1), 1)),
    fc.credito,
    fc.credito,
    'recebida',
    fc.conta_bancaria,
    'fluxo_caixa_fsi',
    fc.fluxo_caixa_fsi_id
FROM fluxo_caixa_fsi fc
WHERE fc.status = 'active'
  AND fc.credito IS NOT NULL
  AND fc.credito > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 3: financiamentos_coop → contas_pagar                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

INSERT INTO contas_pagar (
    organization_id, categoria, descricao,
    data_emissao, data_vencimento, data_pagamento,
    valor_original, valor_pago, status_conta,
    source_table, source_id
)
SELECT
    fin.organization_id,
    'financiamento',
    'Financiamento ' || fin.num_contrato || ' - ' || fin.tipo_financiamento::TEXT || ' (' || COALESCE(fin.descricao, '') || ')',
    fin.data_movimento,
    fin.data_movimento,
    fin.data_movimento,
    ABS(COALESCE(fin.debito, 0)),
    ABS(COALESCE(fin.debito, 0)),
    'paga',
    'financiamentos_coop',
    fin.financiamento_coop_id
FROM financiamentos_coop fin
WHERE fin.status = 'active'
  AND fin.debito IS NOT NULL
  AND fin.debito <> 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 4: vendas_grao → contas_receber                         ║
-- ╚═══════════════════════════════════════════════════════════════╝

INSERT INTO contas_receber (
    organization_id, categoria, descricao,
    data_emissao, data_vencimento, data_recebimento,
    valor_original, valor_recebido, status_conta,
    source_table, source_id
)
SELECT
    vg.organization_id,
    'venda_cooperativa',
    'Venda ' || COALESCE(vg.numero_venda, '') || ' - ' || COALESCE(vg.comprador, 'Castrolanda') || ' (' || COALESCE(vg.contrato, 'S/C') || ')',
    vg.data_venda,
    COALESCE(vg.data_credito, vg.data_venda + INTERVAL '30 days'),
    vg.data_credito,
    COALESCE(vg.valor_nota_fiscal, vg.valor_bruto),
    vg.valor_credito,
    CASE WHEN vg.data_credito IS NOT NULL THEN 'recebida' ELSE 'pendente' END,
    'vendas_grao',
    vg.venda_grao_id
FROM vendas_grao vg
WHERE vg.status = 'active'
  AND COALESCE(vg.valor_nota_fiscal, vg.valor_bruto) > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 5: vendas_diretas → contas_receber                      ║
-- ╚═══════════════════════════════════════════════════════════════╝

INSERT INTO contas_receber (
    organization_id, categoria, descricao,
    data_emissao, data_vencimento, data_recebimento,
    valor_original, valor_recebido, status_conta,
    source_table, source_id
)
SELECT
    vd.organization_id,
    'venda_direta',
    'Venda Direta ' || COALESCE(vd.numero_nfe, '') || ' - ' || COALESCE(vd.comprador, '') || ' (' || COALESCE(vd.tipo_feijao, '') || ')',
    vd.data_venda,
    COALESCE(vd.data_pagamento, vd.data_venda + INTERVAL '30 days'),
    vd.data_pagamento,
    COALESCE(vd.valor_liquido, vd.valor_total),
    CASE WHEN vd.data_pagamento IS NOT NULL THEN COALESCE(vd.valor_liquido, vd.valor_total) ELSE NULL END,
    CASE WHEN vd.data_pagamento IS NOT NULL THEN 'recebida' ELSE 'pendente' END,
    'vendas_diretas',
    vd.venda_direta_id
FROM vendas_diretas vd
WHERE vd.status = 'active'
  AND COALESCE(vd.valor_liquido, vd.valor_total) > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  RESUMO ETL                                                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

DO $$
DECLARE
    v_cp_total INTEGER;
    v_cr_total INTEGER;
    v_cp_fsi INTEGER;
    v_cp_fin INTEGER;
    v_cr_fsi INTEGER;
    v_cr_vg INTEGER;
    v_cr_vd INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_cp_total FROM contas_pagar;
    SELECT COUNT(*) INTO v_cr_total FROM contas_receber;
    SELECT COUNT(*) INTO v_cp_fsi FROM contas_pagar WHERE source_table = 'fluxo_caixa_fsi';
    SELECT COUNT(*) INTO v_cp_fin FROM contas_pagar WHERE source_table = 'financiamentos_coop';
    SELECT COUNT(*) INTO v_cr_fsi FROM contas_receber WHERE source_table = 'fluxo_caixa_fsi';
    SELECT COUNT(*) INTO v_cr_vg FROM contas_receber WHERE source_table = 'vendas_grao';
    SELECT COUNT(*) INTO v_cr_vd FROM contas_receber WHERE source_table = 'vendas_diretas';

    RAISE NOTICE 'ETL Contas P/R completo:';
    RAISE NOTICE '  Contas a Pagar: % total (FSI: %, Financiamentos: %)', v_cp_total, v_cp_fsi, v_cp_fin;
    RAISE NOTICE '  Contas a Receber: % total (FSI: %, Vendas Grão: %, Vendas Diretas: %)', v_cr_total, v_cr_fsi, v_cr_vg, v_cr_vd;
END $$;
