-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — ETL Bronze → Silver: custo_operacoes (Fase 1)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS:
--   00_DDL_COMPLETO_V0.sql + 01/02 INSERTs (dados Bronze)
--   03_DDL_FINANCEIRO_CUSTEIO.sql (centro_custos, custo_operacoes)
--   03_INSERT_CENTRO_CUSTO_SEED.sql (centro_custos populado)
--
-- FONTES BRONZE:
--   1. custos_insumo_coop (553 registros) → tipo='insumo'
--   2. consumo_agriwin (21.162 registros) → tipo variado
--   3. abastecimentos (1.200 registros) → tipo='mecanizacao', subtipo='diesel'
--
-- NOTA: Executar APÓS centro_custos seed estar populado.
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 1: custos_insumo_coop → custo_operacoes                 ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- 553 registros. tipo='insumo'. Resolve CC nível 4 (cultura) via safra+cultura.

INSERT INTO custo_operacoes (
    organization_id, centro_custo_id, tipo_custo, subtipo, descricao,
    data_custo, quantidade, unidade, valor_unitario, valor_total,
    safra_id, cultura_id,
    source_table, source_id
)
SELECT
    cic.organization_id,
    -- Resolve centro_custo nível 4 (cultura×safra) — sem talhão (limitação aceita)
    COALESCE(
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.cultura_id = cic.cultura_id
           AND cc.safra_id = cic.safra_id
           AND cc.nivel = 4
           AND cc.tipo = 'cultura'
         LIMIT 1),
        -- Fallback: primeiro CC nível 3 (safra) da org
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.safra_id = cic.safra_id
           AND cc.nivel = 3
           AND cc.tipo = 'safra'
         LIMIT 1)
    ),
    'insumo',
    cic.categoria,
    cic.nome_produto || ' (NF ' || COALESCE(cic.numero_nf, 'S/N') || ')',
    COALESCE(cic.data_emissao, '2025-01-01'),
    cic.quantidade,
    cic.unidade,
    cic.preco_unitario,
    cic.valor_total,
    cic.safra_id,
    cic.cultura_id,
    'custos_insumo_coop',
    cic.custo_insumo_coop_id
FROM custos_insumo_coop cic
WHERE cic.status = 'active'
  AND cic.valor_total IS NOT NULL
  AND cic.valor_total > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 2: consumo_agriwin → custo_operacoes                    ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- 21.162 registros. Map tipo_operacao → tipo_custo.
-- Sem talhão na fonte (limitação aceita para MVP).
-- CC nível 4 (cultura) quando possível, senão nível 3 (safra).

INSERT INTO custo_operacoes (
    organization_id, centro_custo_id, tipo_custo, subtipo, descricao,
    data_custo, quantidade, unidade, valor_unitario, valor_total,
    safra_id, cultura_id,
    source_table, source_id
)
SELECT
    ca.organization_id,
    -- Resolve CC: cultura×safra se possível, senão safra
    COALESCE(
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.cultura_id = ca.cultura_id
           AND cc.safra_id = ca.safra_id
           AND cc.nivel = 4
           AND cc.tipo = 'cultura'
         LIMIT 1),
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.safra_id = ca.safra_id
           AND cc.nivel = 3
           AND cc.tipo = 'safra'
         LIMIT 1),
        -- Último fallback: org root
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.nivel = 1
         LIMIT 1)
    ),
    -- Map tipo_operacao → tipo_custo
    CASE
        WHEN ca.tipo_operacao ILIKE '%sement%' OR ca.tipo_operacao ILIKE '%fertil%'
             OR ca.tipo_operacao ILIKE '%herbicid%' OR ca.tipo_operacao ILIKE '%fungicid%'
             OR ca.tipo_operacao ILIKE '%inseticid%' OR ca.tipo_operacao ILIKE '%adubo%'
             OR ca.tipo_operacao ILIKE '%corretiv%' OR ca.tipo_operacao ILIKE '%inocul%'
             OR ca.tipo_operacao ILIKE '%adjuv%' OR ca.tipo_operacao ILIKE '%trat%sement%'
            THEN 'insumo'
        WHEN ca.tipo_operacao ILIKE '%diesel%' OR ca.tipo_operacao ILIKE '%combust%'
             OR ca.tipo_operacao ILIKE '%maquin%' OR ca.tipo_operacao ILIKE '%trator%'
            THEN 'mecanizacao'
        WHEN ca.tipo_operacao ILIKE '%mao%obra%' OR ca.tipo_operacao ILIKE '%salari%'
             OR ca.tipo_operacao ILIKE '%funcion%'
            THEN 'mao_obra'
        WHEN ca.tipo_operacao ILIKE '%servic%' OR ca.tipo_operacao ILIKE '%fret%'
             OR ca.tipo_operacao ILIKE '%terceir%'
            THEN 'servico'
        WHEN ca.tipo_operacao ILIKE '%deprec%'
            THEN 'depreciacao'
        WHEN ca.tipo_operacao ILIKE '%arrend%'
            THEN 'arrendamento'
        ELSE 'insumo'  -- Default seguro: maioria do consumo_agriwin é insumo
    END::tipo_custo,
    ca.tipo_operacao,
    ca.descricao_item,
    COALESCE(ca.data_operacao, '2025-01-01'),
    ca.quantidade,
    ca.unidade,
    ca.valor_unitario,
    COALESCE(ca.valor_total, 0),
    ca.safra_id,
    ca.cultura_id,
    'consumo_agriwin',
    ca.consumo_agriwin_id
FROM consumo_agriwin ca
WHERE ca.status = 'active'
  AND ca.valor_total IS NOT NULL
  AND ca.valor_total > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ETL 3: abastecimentos → custo_operacoes                     ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- 1.200 registros. tipo='mecanizacao', subtipo='diesel'.
-- Se tem operacao_campo_id → lançamento direto via talhão.
-- Senão → CC mecanização (rateio posterior).

INSERT INTO custo_operacoes (
    organization_id, centro_custo_id, tipo_custo, subtipo, descricao,
    data_custo, quantidade, unidade, valor_unitario, valor_total,
    abastecimento_id, maquina_id,
    source_table, source_id
)
SELECT
    ab.organization_id,
    -- Resolve CC: mecanização da org (nível 3)
    COALESCE(
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.tipo = 'departamento'
           AND cc.nome ILIKE 'Mecanização%'
           AND cc.nivel = 3
         LIMIT 1),
        (SELECT cc.centro_custo_id FROM centro_custos cc
         WHERE cc.nivel = 1
         LIMIT 1)
    ),
    'mecanizacao',
    'diesel',
    'Abastecimento ' || COALESCE(ab.maquina_nome, '') || ' - ' || COALESCE(ab.placa, ''),
    ab.data_abastecimento,
    ab.quantidade_litros,
    'litros',
    CASE WHEN ab.quantidade_litros > 0 THEN ab.valor_total / ab.quantidade_litros ELSE 0 END,
    COALESCE(ab.valor_total, 0),
    ab.abastecimento_id,
    ab.maquina_id,
    'abastecimentos',
    ab.abastecimento_id
FROM abastecimentos ab
WHERE ab.status = 'active'
  AND ab.valor_total IS NOT NULL
  AND ab.valor_total > 0
ON CONFLICT DO NOTHING;


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  RESUMO ETL                                                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- Verificar contagens
DO $$
DECLARE
    v_total INTEGER;
    v_insumo INTEGER;
    v_agriwin INTEGER;
    v_diesel INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_total FROM custo_operacoes;
    SELECT COUNT(*) INTO v_insumo FROM custo_operacoes WHERE source_table = 'custos_insumo_coop';
    SELECT COUNT(*) INTO v_agriwin FROM custo_operacoes WHERE source_table = 'consumo_agriwin';
    SELECT COUNT(*) INTO v_diesel FROM custo_operacoes WHERE source_table = 'abastecimentos';

    RAISE NOTICE 'ETL custo_operacoes completo:';
    RAISE NOTICE '  Total: % registros', v_total;
    RAISE NOTICE '  custos_insumo_coop: % registros', v_insumo;
    RAISE NOTICE '  consumo_agriwin: % registros', v_agriwin;
    RAISE NOTICE '  abastecimentos: % registros', v_diesel;
END $$;
