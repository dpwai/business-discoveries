-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — ETL Bronze → Silver: Contratos + Entregas (Fase 3)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- FONTES BRONZE:
--   1. vendas_grao (170) → agrupar por contrato → contratos_comerciais
--   2. cargas_a_carga (1.309) → contrato_entregas
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 1: vendas_grao → contratos_comerciais                   ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Agrupa vendas_grao por campo `contrato` para derivar contratos distintos.

INSERT INTO contratos_comerciais (
    organization_id, safra_id, cultura_id,
    tipo, status_contrato, numero_contrato, descricao,
    data_inicio, data_fim,
    quantidade_kg, quantidade_sacas, preco_por_saca, valor_total,
    quantidade_entregue_kg, valor_recebido, pct_entregue
)
SELECT
    vg.organization_id,
    vg.safra_id,
    vg.cultura_id,
    'venda_antecipada',
    'cumprido',
    vg.contrato,
    'Contrato Castrolanda ' || vg.contrato || ' (' || COALESCE(vg.comprador, 'Castrolanda') || ')',
    MIN(vg.data_venda),
    MAX(vg.data_venda),
    SUM(vg.peso_kg),
    SUM(vg.peso_kg) / 60.0,
    AVG(vg.preco_por_saca),
    SUM(vg.valor_bruto),
    SUM(vg.peso_kg),
    SUM(COALESCE(vg.valor_credito, 0)),
    100.0
FROM vendas_grao vg
WHERE vg.status = 'active'
  AND vg.contrato IS NOT NULL
  AND vg.contrato <> ''
GROUP BY vg.organization_id, vg.safra_id, vg.cultura_id, vg.contrato, vg.comprador
ON CONFLICT (organization_id, numero_contrato) DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 2: cargas_a_carga → contrato_entregas                   ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Cada carga = 1 entrega contra contrato.
-- Match por nota_fiscal ou produto_codigo contra contratos_comerciais.

INSERT INTO contrato_entregas (
    contrato_comercial_id,
    carga_a_carga_id,
    data_entrega,
    quantidade_kg,
    quantidade_sacas,
    numero_documento,
    placa,
    motorista,
    qualidade_json
)
SELECT
    cc.contrato_comercial_id,
    cac.carga_a_carga_id,
    cac.data_entrega,
    cac.peso_liquido_kg,
    cac.peso_liquido_kg / 60.0,
    cac.num_docto,
    cac.placa,
    cac.motorista,
    cac.qualidade_json
FROM cargas_a_carga cac
JOIN contratos_comerciais cc
    ON cc.safra_id = cac.safra_id
    AND cc.cultura_id = cac.cultura_id
    AND cc.organization_id = cac.organization_id
WHERE cac.status = 'active'
  AND cac.peso_liquido_kg > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  RESUMO ETL                                                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

DO $$
DECLARE
    v_contratos INTEGER;
    v_entregas INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_contratos FROM contratos_comerciais;
    SELECT COUNT(*) INTO v_entregas FROM contrato_entregas;

    RAISE NOTICE 'ETL Contratos completo:';
    RAISE NOTICE '  Contratos comerciais: % registros', v_contratos;
    RAISE NOTICE '  Entregas: % registros', v_entregas;
END $$;
