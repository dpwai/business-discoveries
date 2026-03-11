-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — Views Gold: Dashboards Financeiros (Fase 4)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS: Fases 1-3 (03, 04, 05)
--
-- CONTEÚDO:
--   6 views Gold para dashboards
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Executive Overview (Dashboard 01)                      ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Waterfall: receita bruta - custos por safra

CREATE OR REPLACE VIEW vw_executive_overview AS
WITH receita AS (
    SELECT
        s.safra_id,
        s.ano_agricola AS safra,
        COALESCE(SUM(vg.valor_bruto), 0) + COALESCE(SUM(vd.valor_total), 0) AS receita_bruta,
        COALESCE(SUM(vg.valor_credito), 0) + COALESCE(SUM(vd.valor_liquido), 0) AS receita_liquida
    FROM safras s
    LEFT JOIN vendas_grao vg ON vg.safra_id = s.safra_id AND vg.status = 'active'
    LEFT JOIN vendas_diretas vd ON vd.safra_id = s.safra_id AND vd.status = 'active'
    GROUP BY s.safra_id, s.ano_agricola
),
custos AS (
    SELECT
        co.safra_id,
        co.tipo_custo,
        SUM(co.valor_total) AS custo_total
    FROM custo_operacoes co
    WHERE co.status = 'active'
      AND co.safra_id IS NOT NULL
    GROUP BY co.safra_id, co.tipo_custo
),
custos_agg AS (
    SELECT
        safra_id,
        SUM(custo_total) AS custo_total,
        SUM(CASE WHEN tipo_custo = 'insumo' THEN custo_total ELSE 0 END) AS custo_insumo,
        SUM(CASE WHEN tipo_custo = 'mecanizacao' THEN custo_total ELSE 0 END) AS custo_mecanizacao,
        SUM(CASE WHEN tipo_custo = 'mao_obra' THEN custo_total ELSE 0 END) AS custo_mao_obra,
        SUM(CASE WHEN tipo_custo = 'servico' THEN custo_total ELSE 0 END) AS custo_servico,
        SUM(CASE WHEN tipo_custo = 'depreciacao' THEN custo_total ELSE 0 END) AS custo_depreciacao,
        SUM(CASE WHEN tipo_custo = 'arrendamento' THEN custo_total ELSE 0 END) AS custo_arrendamento,
        SUM(CASE WHEN tipo_custo = 'administrativo' THEN custo_total ELSE 0 END) AS custo_administrativo
    FROM custos
    GROUP BY safra_id
)
SELECT
    r.safra,
    r.safra_id,
    r.receita_bruta,
    r.receita_liquida,
    COALESCE(ca.custo_total, 0) AS custo_total,
    r.receita_liquida - COALESCE(ca.custo_total, 0) AS margem_bruta,
    CASE
        WHEN r.receita_liquida > 0
        THEN ROUND((r.receita_liquida - COALESCE(ca.custo_total, 0)) / r.receita_liquida * 100, 1)
        ELSE 0
    END AS margem_pct,
    COALESCE(ca.custo_insumo, 0) AS custo_insumo,
    COALESCE(ca.custo_mecanizacao, 0) AS custo_mecanizacao,
    COALESCE(ca.custo_mao_obra, 0) AS custo_mao_obra,
    COALESCE(ca.custo_servico, 0) AS custo_servico,
    COALESCE(ca.custo_depreciacao, 0) AS custo_depreciacao,
    COALESCE(ca.custo_arrendamento, 0) AS custo_arrendamento,
    COALESCE(ca.custo_administrativo, 0) AS custo_administrativo
FROM receita r
LEFT JOIN custos_agg ca ON ca.safra_id = r.safra_id
ORDER BY r.safra DESC;

COMMENT ON VIEW vw_executive_overview IS 'Waterfall receita - custos por safra. Dashboard 01 — Claudio overview.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Custo Treemap (Dashboard 07)                           ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Hierarquia CC com custo_total, custo_por_ha, % do pai

CREATE OR REPLACE VIEW vw_custo_treemap AS
WITH RECURSIVE hierarquia AS (
    SELECT
        cc.centro_custo_id,
        cc.parent_id,
        cc.codigo,
        cc.nome,
        cc.nivel,
        cc.tipo,
        cc.centro_custo_id AS root_id,
        cc.codigo AS root_codigo
    FROM centro_custos cc
    WHERE cc.parent_id IS NULL AND cc.ativo = true

    UNION ALL

    SELECT
        filho.centro_custo_id,
        filho.parent_id,
        filho.codigo,
        filho.nome,
        filho.nivel,
        filho.tipo,
        h.root_id,
        h.root_codigo
    FROM centro_custos filho
    JOIN hierarquia h ON filho.parent_id = h.centro_custo_id
    WHERE filho.ativo = true
),
custos_por_cc AS (
    SELECT
        co.centro_custo_id,
        SUM(co.valor_total) AS custo_total,
        COUNT(*) AS qtd_lancamentos
    FROM custo_operacoes co
    WHERE co.status = 'active'
    GROUP BY co.centro_custo_id
)
SELECT
    h.centro_custo_id,
    h.parent_id,
    h.codigo,
    h.nome,
    h.nivel,
    h.tipo,
    COALESCE(c.custo_total, 0) AS custo_direto,
    COALESCE(c.qtd_lancamentos, 0) AS qtd_lancamentos
FROM hierarquia h
LEFT JOIN custos_por_cc c ON c.centro_custo_id = h.centro_custo_id;

COMMENT ON VIEW vw_custo_treemap IS 'Treemap hierárquico de custos por centro de custo. Dashboard 07. Frontend calcula roll-up e %.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Budget vs Actual (Dashboard 07)                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE OR REPLACE VIEW vw_budget_vs_actual AS
SELECT
    o.safra_id,
    s.ano_agricola AS safra,
    o.centro_custo_id,
    cc.codigo AS cc_codigo,
    cc.nome AS cc_nome,
    o.categoria AS tipo_custo,
    o.valor_previsto,
    o.valor_por_ha AS previsto_por_ha,
    o.area_prevista_ha,
    COALESCE(SUM(co.valor_total), 0) AS valor_realizado,
    CASE
        WHEN o.area_prevista_ha > 0
        THEN ROUND(COALESCE(SUM(co.valor_total), 0) / o.area_prevista_ha, 2)
        ELSE 0
    END AS realizado_por_ha,
    o.valor_previsto - COALESCE(SUM(co.valor_total), 0) AS variacao,
    CASE
        WHEN o.valor_previsto > 0
        THEN ROUND((COALESCE(SUM(co.valor_total), 0) / o.valor_previsto) * 100, 1)
        ELSE 0
    END AS pct_realizado
FROM orcamento_safras o
JOIN safras s ON o.safra_id = s.safra_id
JOIN centro_custos cc ON o.centro_custo_id = cc.centro_custo_id
LEFT JOIN custo_operacoes co ON co.centro_custo_id = o.centro_custo_id
    AND co.tipo_custo = o.categoria
    AND co.safra_id = o.safra_id
    AND co.status = 'active'
WHERE o.status = 'active'
GROUP BY o.safra_id, s.ano_agricola, o.centro_custo_id, cc.codigo, cc.nome,
         o.categoria, o.valor_previsto, o.valor_por_ha, o.area_prevista_ha;

COMMENT ON VIEW vw_budget_vs_actual IS 'Orçamento vs realizado por centro de custo × tipo_custo × safra. Dashboard 07.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Contas a pagar — Calendar heatmap (Dashboard 03)       ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE OR REPLACE VIEW vw_contas_pagar_calendar AS
SELECT
    DATE_TRUNC('week', cp.data_vencimento)::DATE AS semana,
    cp.categoria,
    COUNT(*) AS qtd_contas,
    SUM(cp.valor_original) AS valor_total,
    SUM(CASE WHEN cp.status_conta = 'paga' THEN cp.valor_pago ELSE 0 END) AS valor_pago,
    SUM(CASE WHEN cp.status_conta IN ('pendente', 'vencida') THEN cp.valor_original - COALESCE(cp.valor_pago, 0) ELSE 0 END) AS valor_aberto
FROM contas_pagar cp
WHERE cp.status = 'active'
GROUP BY DATE_TRUNC('week', cp.data_vencimento), cp.categoria
ORDER BY semana, cp.categoria;

COMMENT ON VIEW vw_contas_pagar_calendar IS 'Pivot semanas × categorias para heatmap calendar de pagamentos. Dashboard 03.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Contas a receber — Timeline por cliente (Dashboard 02) ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE OR REPLACE VIEW vw_contas_receber_timeline AS
SELECT
    pc.nome AS parceiro,
    pc.parceiro_comercial_id AS parceiro_id,
    DATE_TRUNC('month', cr.data_vencimento)::DATE AS mes,
    cr.categoria,
    COUNT(*) AS qtd_titulos,
    SUM(cr.valor_original) AS valor_total,
    SUM(CASE WHEN cr.status_conta = 'recebida' THEN cr.valor_recebido ELSE 0 END) AS valor_recebido,
    SUM(CASE WHEN cr.status_conta IN ('pendente', 'vencida') THEN cr.valor_original - COALESCE(cr.valor_recebido, 0) ELSE 0 END) AS valor_aberto,
    SUM(CASE WHEN cr.status_conta = 'vencida' THEN 1 ELSE 0 END) AS qtd_vencidas
FROM contas_receber cr
LEFT JOIN parceiros_comerciais pc ON cr.parceiro_id = pc.parceiro_comercial_id
WHERE cr.status = 'active'
GROUP BY pc.nome, pc.parceiro_comercial_id, DATE_TRUNC('month', cr.data_vencimento), cr.categoria
ORDER BY mes, parceiro;

COMMENT ON VIEW vw_contas_receber_timeline IS 'Timeline recebíveis por parceiro × mês. Dashboard 02.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEW: Custo por ha — Tendência 5 safras (Dashboard 07)       ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE OR REPLACE VIEW vw_custo_por_ha_trend AS
SELECT
    s.ano_agricola AS safra,
    s.safra_id,
    c.nome AS cultura,
    c.cultura_id,
    SUM(DISTINCT ts.area_plantada_ha) AS area_total_ha,
    SUM(co.valor_total) AS custo_total,
    CASE
        WHEN SUM(DISTINCT ts.area_plantada_ha) > 0
        THEN ROUND(SUM(co.valor_total) / SUM(DISTINCT ts.area_plantada_ha), 2)
        ELSE 0
    END AS custo_por_ha,
    co.tipo_custo
FROM custo_operacoes co
JOIN safras s ON co.safra_id = s.safra_id
JOIN culturas c ON co.cultura_id = c.cultura_id
LEFT JOIN talhao_safras ts ON ts.safra_id = co.safra_id
    AND ts.cultura_id = co.cultura_id
WHERE co.status = 'active'
GROUP BY s.ano_agricola, s.safra_id, c.nome, c.cultura_id, co.tipo_custo
ORDER BY s.ano_agricola, c.nome;

COMMENT ON VIEW vw_custo_por_ha_trend IS 'Tendência custo/ha por cultura×safra×tipo_custo. Comparação multi-safra. Dashboard 07.';


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIM — Fase 4: Views Gold para Dashboards
-- Resumo: 6 views Gold
-- ═══════════════════════════════════════════════════════════════════════════════
