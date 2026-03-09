-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — DDL Financeiro: Centro de Custo + Custeio (Fase 1)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS: 00_DDL_COMPLETO_V0.sql (todas as tabelas base)
--
-- CONTEÚDO:
--   4 ENUMs: tipo_centro_custo, natureza_centro_custo, tipo_custo, tipo_rateio
--   3 tabelas: centro_custos, custo_operacoes, orcamento_safras
--   3 views: vw_centro_custo_hierarquia, vw_custo_por_talhao_safra, vw_custo_por_cultura_safra
--   1 função: fn_custo_acumulado
-- ═══════════════════════════════════════════════════════════════════════════════


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ENUMs                                                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE TYPE tipo_centro_custo AS ENUM (
    'organizacao', 'fazenda', 'safra', 'cultura', 'talhao',
    'departamento', 'subdepartamento', 'equipamento', 'maquina',
    'operacao', 'silo'
);

CREATE TYPE natureza_centro_custo AS ENUM (
    'producao', 'apoio', 'administrativo', 'financeiro'
);

CREATE TYPE tipo_custo AS ENUM (
    'insumo', 'mao_obra', 'mecanizacao', 'servico',
    'depreciacao', 'arrendamento', 'administrativo'
);

CREATE TYPE tipo_rateio AS ENUM (
    'direto', 'por_area', 'por_hora_maquina', 'por_producao', 'por_receita'
);


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CENTRO_CUSTOS — Hierarquia self-referential, 6 níveis        ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Doc 13: XX.YY.ZZZ.WW.NNN (Org.Fazenda.Safra.Cultura.Talhao)
-- Regra: Lançamentos só em permite_lancamento = true (níveis 4-5)
-- Roll-up automático via recursive CTE

CREATE TABLE centro_custos (
    centro_custo_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),
    parent_id             UUID REFERENCES centro_custos(centro_custo_id),

    codigo                VARCHAR(20) NOT NULL,
    nome                  VARCHAR(200) NOT NULL,
    nivel                 INTEGER NOT NULL CHECK (nivel BETWEEN 1 AND 6),
    tipo                  tipo_centro_custo NOT NULL,
    natureza              natureza_centro_custo NOT NULL,

    permite_lancamento    BOOLEAN DEFAULT false,
    ativo                 BOOLEAN DEFAULT true,

    -- FKs denorm para resolução rápida (Doc 13 §7.1)
    fazenda_id            UUID REFERENCES fazendas(fazenda_id),
    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),
    talhao_id             UUID REFERENCES talhoes(talhao_id),
    maquina_id            UUID REFERENCES maquinas(maquina_id),
    silo_id               UUID REFERENCES silos(silo_id),

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_centro_custo_codigo UNIQUE (organization_id, codigo)
);

CREATE INDEX idx_cc_parent           ON centro_custos(parent_id);
CREATE INDEX idx_cc_org              ON centro_custos(organization_id);
CREATE INDEX idx_cc_codigo           ON centro_custos(codigo);
CREATE INDEX idx_cc_nivel            ON centro_custos(nivel);
CREATE INDEX idx_cc_tipo             ON centro_custos(tipo);
CREATE INDEX idx_cc_fazenda          ON centro_custos(fazenda_id) WHERE fazenda_id IS NOT NULL;
CREATE INDEX idx_cc_safra            ON centro_custos(safra_id) WHERE safra_id IS NOT NULL;
CREATE INDEX idx_cc_cultura          ON centro_custos(cultura_id) WHERE cultura_id IS NOT NULL;
CREATE INDEX idx_cc_talhao           ON centro_custos(talhao_id) WHERE talhao_id IS NOT NULL;

CREATE TRIGGER trg_centro_custo_updated
    BEFORE UPDATE ON centro_custos
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE centro_custos IS 'Hierarquia de centros de custo, 6 níveis (Doc 13). Self-referential via parent_id. Seed: ~300-500 nós derivados de fazendas+safras+culturas+talhoes+maquinas+silos.';
COMMENT ON COLUMN centro_custos.codigo IS 'Código hierárquico XX.YY.ZZZ.WW.NNN. Unique por org.';
COMMENT ON COLUMN centro_custos.permite_lancamento IS 'Só níveis 4-5. Níveis 1-3 recebem consolidação automática via roll-up.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  CUSTO_OPERACOES — Acumulação de custos por centro de custo   ║
-- ╚═══════════════════════════════════════════════════════════════╝
-- Receptor dos ETLs Bronze → Silver:
--   custos_insumo_coop (553) → tipo='insumo'
--   consumo_agriwin (21.162) → tipo='insumo'|'mecanizacao'|etc
--   abastecimentos (1.200) → tipo='mecanizacao', subtipo='diesel'
--   ubg_caixa (19.177) → custos operacionais UBG

CREATE TABLE custo_operacoes (
    custo_operacao_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),
    centro_custo_id       UUID NOT NULL REFERENCES centro_custos(centro_custo_id),

    tipo_custo            tipo_custo NOT NULL,
    subtipo               VARCHAR(50),
    descricao             TEXT,

    data_custo            DATE NOT NULL,

    quantidade            DECIMAL(14,4),
    unidade               VARCHAR(20),
    valor_unitario        DECIMAL(14,4),
    valor_total           DECIMAL(14,2) NOT NULL,

    -- Custo por hectare (calculado se area disponível)
    custo_por_ha          DECIMAL(10,2),
    area_rateio_ha        DECIMAL(10,2),

    -- Rateio
    rateio_tipo           tipo_rateio DEFAULT 'direto',
    rateio_percentual     DECIMAL(5,2),
    rateio_origem_cc_id   UUID REFERENCES centro_custos(centro_custo_id),

    -- FKs denorm para rastreabilidade (-- DENORM: caminho ≥3 hops no ER)
    nota_fiscal_id        UUID,        -- FK futuro → notas_fiscais (Fase 2)
    abastecimento_id      UUID REFERENCES abastecimentos(abastecimento_id),
    manutencao_id         UUID REFERENCES manutencoes(manutencao_id),
    operacao_campo_id     UUID REFERENCES operacoes_campo(operacao_campo_id),
    aplicacao_insumo_id   UUID REFERENCES aplicacao_insumo(aplicacao_insumo_id),
    compra_insumo_id      UUID REFERENCES compra_insumo(compra_insumo_id),

    -- FKs denorm contextuais
    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),
    talhao_id             UUID REFERENCES talhoes(talhao_id),
    maquina_id            UUID REFERENCES maquinas(maquina_id),

    -- Rastreabilidade Bronze
    source_table          VARCHAR(50),
    source_id             UUID,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_co_org              ON custo_operacoes(organization_id);
CREATE INDEX idx_co_cc               ON custo_operacoes(centro_custo_id);
CREATE INDEX idx_co_tipo             ON custo_operacoes(tipo_custo);
CREATE INDEX idx_co_data             ON custo_operacoes(data_custo);
CREATE INDEX idx_co_safra            ON custo_operacoes(safra_id) WHERE safra_id IS NOT NULL;
CREATE INDEX idx_co_cultura          ON custo_operacoes(cultura_id) WHERE cultura_id IS NOT NULL;
CREATE INDEX idx_co_talhao           ON custo_operacoes(talhao_id) WHERE talhao_id IS NOT NULL;
CREATE INDEX idx_co_maquina          ON custo_operacoes(maquina_id) WHERE maquina_id IS NOT NULL;
CREATE INDEX idx_co_source           ON custo_operacoes(source_table, source_id);

CREATE TRIGGER trg_custo_operacao_updated
    BEFORE UPDATE ON custo_operacoes
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE custo_operacoes IS 'Custos acumulados por centro de custo. Receptor Silver dos ETLs Bronze (custos_insumo_coop, consumo_agriwin, abastecimentos, ubg_caixa). Base para custeio R$/ha.';
COMMENT ON COLUMN custo_operacoes.source_table IS 'Tabela Bronze de origem: custos_insumo_coop, consumo_agriwin, abastecimentos, ubg_caixa.';
COMMENT ON COLUMN custo_operacoes.rateio_origem_cc_id IS 'Centro de custo original antes do rateio. NULL se lançamento direto.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  ORCAMENTO_SAFRAS — Orçamento por centro de custo × safra     ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE TABLE orcamento_safras (
    orcamento_safra_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),
    safra_id              UUID NOT NULL REFERENCES safras(safra_id),
    centro_custo_id       UUID NOT NULL REFERENCES centro_custos(centro_custo_id),

    categoria             tipo_custo NOT NULL,
    descricao             VARCHAR(200),

    valor_previsto        DECIMAL(14,2) NOT NULL,
    valor_por_ha          DECIMAL(10,2),
    area_prevista_ha      DECIMAL(10,2),

    aprovado_por          UUID REFERENCES users(user_id),
    data_aprovacao        DATE,

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_orcamento_safra_cc_cat UNIQUE (safra_id, centro_custo_id, categoria)
);

CREATE INDEX idx_orc_org             ON orcamento_safras(organization_id);
CREATE INDEX idx_orc_safra           ON orcamento_safras(safra_id);
CREATE INDEX idx_orc_cc              ON orcamento_safras(centro_custo_id);
CREATE INDEX idx_orc_categoria       ON orcamento_safras(categoria);

CREATE TRIGGER trg_orcamento_safra_updated
    BEFORE UPDATE ON orcamento_safras
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE orcamento_safras IS 'Orçamento por centro de custo × safra × categoria. Claudio preenche para 25/26 e 26/27. Comparação via vw_budget_vs_actual.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  VIEWS — Hierarquia + Custeio                                 ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── View: Hierarquia completa do centro de custo ──────────────
CREATE OR REPLACE VIEW vw_centro_custo_hierarquia AS
WITH RECURSIVE hierarquia AS (
    SELECT
        cc.centro_custo_id,
        cc.codigo,
        cc.nome,
        cc.nivel,
        cc.tipo,
        cc.natureza,
        cc.parent_id,
        cc.permite_lancamento,
        cc.fazenda_id,
        cc.safra_id,
        cc.cultura_id,
        cc.talhao_id,
        cc.codigo AS caminho_codigo,
        cc.nome AS caminho_nome,
        1 AS profundidade
    FROM centro_custos cc
    WHERE cc.parent_id IS NULL
      AND cc.ativo = true

    UNION ALL

    SELECT
        filho.centro_custo_id,
        filho.codigo,
        filho.nome,
        filho.nivel,
        filho.tipo,
        filho.natureza,
        filho.parent_id,
        filho.permite_lancamento,
        filho.fazenda_id,
        filho.safra_id,
        filho.cultura_id,
        filho.talhao_id,
        h.caminho_codigo || ' > ' || filho.codigo,
        h.caminho_nome || ' > ' || filho.nome,
        h.profundidade + 1
    FROM centro_custos filho
    JOIN hierarquia h ON filho.parent_id = h.centro_custo_id
    WHERE filho.ativo = true
)
SELECT * FROM hierarquia
ORDER BY caminho_codigo;

COMMENT ON VIEW vw_centro_custo_hierarquia IS 'Recursive CTE — caminho completo de cada nó do centro de custo. Para navegação drill-down/roll-up.';


-- ─── View: Custo por talhão × safra (Dashboard 07) ─────────────
CREATE OR REPLACE VIEW vw_custo_por_talhao_safra AS
SELECT
    s.ano_agricola AS safra,
    s.safra_id,
    f.nome AS fazenda,
    f.fazenda_id,
    t.nome AS talhao,
    t.talhao_id,
    c.nome AS cultura,
    c.cultura_id,
    ts.area_plantada_ha AS area_ha,
    co.tipo_custo,
    SUM(co.valor_total) AS custo_total,
    CASE
        WHEN ts.area_plantada_ha > 0
        THEN ROUND(SUM(co.valor_total) / ts.area_plantada_ha, 2)
        ELSE 0
    END AS custo_por_ha,
    COUNT(*) AS qtd_lancamentos
FROM custo_operacoes co
JOIN centro_custos cc ON co.centro_custo_id = cc.centro_custo_id
JOIN talhao_safras ts ON cc.talhao_id = ts.talhao_id
    AND COALESCE(cc.safra_id, co.safra_id) = ts.safra_id
    AND COALESCE(cc.cultura_id, co.cultura_id) = ts.cultura_id
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN fazendas f ON t.fazenda_id = f.fazenda_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
WHERE co.status = 'active'
GROUP BY s.ano_agricola, s.safra_id, f.nome, f.fazenda_id,
         t.nome, t.talhao_id, c.nome, c.cultura_id,
         ts.area_plantada_ha, co.tipo_custo;

COMMENT ON VIEW vw_custo_por_talhao_safra IS 'Custo total e custo/ha por talhão×safra×cultura×tipo_custo. Base do Dashboard 07 (treemap custeio).';


-- ─── View: Custo por cultura × safra (roll-up) ─────────────────
CREATE OR REPLACE VIEW vw_custo_por_cultura_safra AS
SELECT
    s.ano_agricola AS safra,
    s.safra_id,
    c.nome AS cultura,
    c.cultura_id,
    SUM(ts.area_plantada_ha) AS area_total_ha,
    co.tipo_custo,
    SUM(co.valor_total) AS custo_total,
    CASE
        WHEN SUM(ts.area_plantada_ha) > 0
        THEN ROUND(SUM(co.valor_total) / SUM(ts.area_plantada_ha), 2)
        ELSE 0
    END AS custo_por_ha,
    COUNT(DISTINCT ts.talhao_safra_id) AS qtd_talhoes
FROM custo_operacoes co
JOIN centro_custos cc ON co.centro_custo_id = cc.centro_custo_id
JOIN talhao_safras ts ON cc.talhao_id = ts.talhao_id
    AND COALESCE(cc.safra_id, co.safra_id) = ts.safra_id
    AND COALESCE(cc.cultura_id, co.cultura_id) = ts.cultura_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
WHERE co.status = 'active'
GROUP BY s.ano_agricola, s.safra_id, c.nome, c.cultura_id, co.tipo_custo;

COMMENT ON VIEW vw_custo_por_cultura_safra IS 'Roll-up: custo/ha por cultura×safra. Comparação entre culturas na mesma safra.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  FUNÇÃO: Custo acumulado recursivo                            ║
-- ╚═══════════════════════════════════════════════════════════════╝

CREATE OR REPLACE FUNCTION fn_custo_acumulado(
    p_centro_custo_id UUID,
    p_data_inicio DATE,
    p_data_fim DATE
)
RETURNS DECIMAL(14,2) AS $$
DECLARE
    v_total DECIMAL(14,2);
BEGIN
    WITH RECURSIVE descendentes AS (
        SELECT centro_custo_id FROM centro_custos WHERE centro_custo_id = p_centro_custo_id
        UNION ALL
        SELECT cc.centro_custo_id
        FROM centro_custos cc
        JOIN descendentes d ON cc.parent_id = d.centro_custo_id
        WHERE cc.ativo = true
    )
    SELECT COALESCE(SUM(co.valor_total), 0)
    INTO v_total
    FROM custo_operacoes co
    WHERE co.centro_custo_id IN (SELECT centro_custo_id FROM descendentes)
      AND co.data_custo BETWEEN p_data_inicio AND p_data_fim
      AND co.status = 'active';

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_custo_acumulado(UUID, DATE, DATE) IS
    'Soma recursiva de custos de um centro de custo e todos os descendentes, dentro de um período. Doc 13 §7.3.';


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIM — Fase 1: Centro de Custo + Custeio
-- Resumo: 4 ENUMs, 3 tabelas, 3 views, 1 função
-- Próximo: 04_DDL_FINANCEIRO_CONTAS.sql (Fase 2)
-- ═══════════════════════════════════════════════════════════════════════════════
