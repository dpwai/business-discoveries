-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — INSERT Seeds: Centro de Custo (Fase 1)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-09
-- PostgreSQL 15+
--
-- DEPENDÊNCIAS:
--   00_DDL_COMPLETO_V0.sql (organizations, fazendas, safras, culturas, talhoes, maquinas, silos)
--   01_INSERT_SEEDS.sql (dados base)
--   03_DDL_FINANCEIRO_CUSTEIO.sql (centro_custos)
--
-- NOTA: Este seed é gerado manualmente com base na hierarquia Doc 13.
-- Para gerar a versão completa com todos os talhões/máquinas, usar:
--   python generate_centro_custo_seeds.py
-- ═══════════════════════════════════════════════════════════════════════════════

-- Usar subqueries para resolver UUIDs dinâmicos
-- org_id constante: a única organização SOAL
DO $$
DECLARE
    v_org_id UUID;
BEGIN
    SELECT organization_id INTO v_org_id FROM organizations LIMIT 1;

    -- ════════════════════════════════════════════════════════════════
    -- NÍVEL 1: ORGANIZAÇÃO
    -- ════════════════════════════════════════════════════════════════
    INSERT INTO centro_custos (organization_id, codigo, nome, nivel, tipo, natureza, permite_lancamento)
    VALUES (v_org_id, '01', 'SOAL', 1, 'organizacao', 'producao', false);

    -- ════════════════════════════════════════════════════════════════
    -- NÍVEL 2: FAZENDAS + DEPARTAMENTOS
    -- ════════════════════════════════════════════════════════════════

    -- Fazendas (9 fazendas de fazendas_curado.csv)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id)
    SELECT
        v_org_id,
        (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01'),
        '01.' || LPAD(ROW_NUMBER() OVER (ORDER BY f.nome)::TEXT, 2, '0'),
        'Fazenda ' || f.nome,
        2, 'fazenda', 'producao', false,
        f.fazenda_id
    FROM fazendas f
    WHERE f.organization_id = v_org_id
    ORDER BY f.nome;

    -- Departamentos nível 2
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento)
    VALUES
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01'), '01.90', 'Administrativo', 2, 'departamento', 'administrativo', false),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01'), '01.95', 'Financeiro', 2, 'departamento', 'financeiro', false);

    -- ════════════════════════════════════════════════════════════════
    -- NÍVEL 3: SAFRAS por fazenda + DEPARTAMENTOS de apoio
    -- ════════════════════════════════════════════════════════════════

    -- Safras por fazenda (apenas safras com status <> encerrada ou as mais recentes)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id, safra_id)
    SELECT
        v_org_id,
        cc_faz.centro_custo_id,
        cc_faz.codigo || '.' || LPAD(SUBSTRING(s.ano_agricola FROM 3 FOR 2) || SUBSTRING(s.ano_agricola FROM 6 FOR 2), 3, '0'),
        'Safra ' || s.ano_agricola || ' - ' || f.nome,
        3, 'safra', 'producao', false,
        f.fazenda_id,
        s.safra_id
    FROM fazendas f
    JOIN centro_custos cc_faz ON cc_faz.fazenda_id = f.fazenda_id AND cc_faz.nivel = 2
    CROSS JOIN safras s
    WHERE f.organization_id = v_org_id
      AND s.organization_id = v_org_id
      AND s.ano_agricola IN ('24/25', '25/26', '26/27');

    -- Mecanização por fazenda (nível 3)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id)
    SELECT
        v_org_id,
        cc_faz.centro_custo_id,
        cc_faz.codigo || '.800',
        'Mecanização - ' || f.nome,
        3, 'departamento', 'apoio', false,
        f.fazenda_id
    FROM fazendas f
    JOIN centro_custos cc_faz ON cc_faz.fazenda_id = f.fazenda_id AND cc_faz.nivel = 2
    WHERE f.organization_id = v_org_id;

    -- UBG (nível 3, apenas na fazenda principal — Santana do Iapo)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id)
    SELECT
        v_org_id,
        cc_faz.centro_custo_id,
        cc_faz.codigo || '.810',
        'UBG - ' || f.nome,
        3, 'departamento', 'apoio', false,
        f.fazenda_id
    FROM fazendas f
    JOIN centro_custos cc_faz ON cc_faz.fazenda_id = f.fazenda_id AND cc_faz.nivel = 2
    WHERE f.organization_id = v_org_id
      AND f.nome ILIKE '%santana%';

    -- Subdepartamentos Administrativos (nível 3)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento)
    VALUES
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.001', 'Escritório', 3, 'subdepartamento', 'administrativo', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.002', 'Recursos Humanos', 3, 'subdepartamento', 'administrativo', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.003', 'Contabilidade/Fiscal', 3, 'subdepartamento', 'administrativo', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.004', 'Jurídico', 3, 'subdepartamento', 'administrativo', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.005', 'Seguros', 3, 'subdepartamento', 'administrativo', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.90'), '01.90.006', 'Tecnologia', 3, 'subdepartamento', 'administrativo', true);

    -- Subdepartamentos Financeiros (nível 3)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento)
    VALUES
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.95'), '01.95.001', 'Custos Financeiros', 3, 'subdepartamento', 'financeiro', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.95'), '01.95.002', 'Arrendamentos', 3, 'subdepartamento', 'financeiro', true),
        (v_org_id, (SELECT centro_custo_id FROM centro_custos WHERE codigo = '01.95'), '01.95.003', 'Depreciação', 3, 'subdepartamento', 'financeiro', true);

    -- UBG subdepartamentos (nível 4)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento)
    SELECT
        v_org_id,
        cc_ubg.centro_custo_id,
        cc_ubg.codigo || '.' || LPAD(seq::TEXT, 2, '0'),
        dept,
        4, 'operacao', 'apoio', true
    FROM centro_custos cc_ubg
    CROSS JOIN (VALUES (1, 'Recepção/Balança'), (2, 'Secagem'), (3, 'Armazenagem'), (4, 'Beneficiamento')) AS t(seq, dept)
    WHERE cc_ubg.tipo = 'departamento' AND cc_ubg.nome ILIKE 'UBG%';

    -- ════════════════════════════════════════════════════════════════
    -- NÍVEL 4: CULTURAS por safra×fazenda
    -- ════════════════════════════════════════════════════════════════
    -- Gera nível 4 para culturas que realmente têm talhao_safra registrado

    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id, safra_id, cultura_id)
    SELECT DISTINCT
        v_org_id,
        cc_safra.centro_custo_id,
        cc_safra.codigo || '.' || LPAD(
            (ROW_NUMBER() OVER (PARTITION BY cc_safra.centro_custo_id ORDER BY c.nome))::TEXT, 2, '0'
        ),
        c.nome || ' - ' || s.ano_agricola || ' - ' || f.nome,
        4, 'cultura', 'producao', true,
        f.fazenda_id,
        s.safra_id,
        c.cultura_id
    FROM talhao_safras ts
    JOIN talhoes t ON ts.talhao_id = t.talhao_id
    JOIN fazendas f ON t.fazenda_id = f.fazenda_id
    JOIN culturas c ON ts.cultura_id = c.cultura_id
    JOIN safras s ON ts.safra_id = s.safra_id
    JOIN centro_custos cc_safra ON cc_safra.fazenda_id = f.fazenda_id
        AND cc_safra.safra_id = s.safra_id
        AND cc_safra.nivel = 3
        AND cc_safra.tipo = 'safra'
    WHERE ts.organization_id = v_org_id
    ORDER BY cc_safra.centro_custo_id, c.nome;

    -- Mecanização subcategorias (nível 4)
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, fazenda_id)
    SELECT
        v_org_id,
        cc_mec.centro_custo_id,
        cc_mec.codigo || '.' || LPAD(seq::TEXT, 2, '0'),
        cat || ' - ' || f.nome,
        4, 'equipamento', 'apoio', true,
        f.fazenda_id
    FROM centro_custos cc_mec
    JOIN fazendas f ON cc_mec.fazenda_id = f.fazenda_id
    CROSS JOIN (VALUES
        (1, 'Tratores'), (2, 'Colheitadeiras'), (3, 'Pulverizadores'),
        (4, 'Implementos'), (5, 'Caminhões'), (6, 'Drones')
    ) AS t(seq, cat)
    WHERE cc_mec.tipo = 'departamento' AND cc_mec.nome ILIKE 'Mecanização%';

    -- Silos como nível 5 sob UBG > Armazenagem
    INSERT INTO centro_custos (organization_id, parent_id, codigo, nome, nivel, tipo, natureza, permite_lancamento, silo_id)
    SELECT
        v_org_id,
        cc_arm.centro_custo_id,
        cc_arm.codigo || '.' || LPAD(ROW_NUMBER() OVER (ORDER BY si.nome)::TEXT, 3, '0'),
        si.nome,
        5, 'silo', 'apoio', true,
        si.silo_id
    FROM silos si
    JOIN centro_custos cc_arm ON cc_arm.nome ILIKE 'Armazenagem%' AND cc_arm.nivel = 4
    WHERE si.organization_id = v_org_id;

    -- ════════════════════════════════════════════════════════════════
    -- RESUMO
    -- ════════════════════════════════════════════════════════════════
    RAISE NOTICE 'Centro de custos seed complete. Total: % registros',
        (SELECT COUNT(*) FROM centro_custos WHERE organization_id = v_org_id);

END $$;
