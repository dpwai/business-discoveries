-- ═══════════════════════════════════════════════════════════════════════════════
-- SOAL — DDL Completo V0 (Bronze Layer)
-- Serra da Onça Agropecuária — DeepWork AI Flows
-- Gerado: 2026-03-04
-- PostgreSQL 15+
--
-- Fontes consolidadas:
--   Doc 16  — Módulo Insumos e Estoque
--   Doc 25b — Matrículas e Fazendas
--   Doc 25a — Operações de Campo
--   Doc 26  — Fundacional (Sistema + Territorial + Operacional)
--   Doc 27  — Colaboradores + Folha de Pagamento
--   Doc 28  — UBG (Produção + Armazenagem)
--   Doc 29  — Financeiro Cooperativa (Castrolanda)
--   Doc 30  — Frete + Vendas Diretas
--   Doc 31  — Histórico Maquinário
--
-- REGRAS APLICADAS:
--   1. PK padrão: entidade_id UUID (CLAUDE.md §3)
--   2. colaboradores substitui trabalhadores_rurais (Doc 27 > Doc 26 §5.5)
--   3. tipo_contrato_trabalho: clt, informal, temporario, safrista (Doc 27)
--   4. Trigger function: fn_atualizar_updated_at() ÚNICA
--   5. FK references usam PK corretas (organization_id, não id)
--   6. Migration scripts omitidos (Doc 16 §4)
--   7. FKs para entidades fora do V0 comentadas como -- FK futuro
--   8. organization_id NUNCA desenhado no ER mas SEMPRE presente no DDL
-- ═══════════════════════════════════════════════════════════════════════════════

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 0: EXTENSÕES + FUNÇÕES                                ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- Habilitar geração de UUID (PostgreSQL 13+ tem gen_random_uuid() nativo)
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;  -- Descomente se PG < 13

-- Trigger function reutilizada por TODAS as tabelas
CREATE OR REPLACE FUNCTION fn_atualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_atualizar_updated_at() IS
    'Atualiza updated_at automaticamente em qualquer UPDATE. Reutilizada por todas as tabelas.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 1: ENUMs (~40 tipos)                                  ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── Territorial ───────────────────────────────────────────────
CREATE TYPE tipo_fazenda AS ENUM ('propria', 'arrendada', 'parceria', 'comodato');
CREATE TYPE tipo_solo AS ENUM ('latossolo_vermelho', 'argissolo', 'cambissolo', 'neossolo', 'nitossolo', 'outros');
CREATE TYPE tipo_silo AS ENUM ('metalico', 'bolsa', 'armazem', 'tulha');
CREATE TYPE status_safra AS ENUM ('planejamento', 'em_andamento', 'encerrada');
CREATE TYPE epoca_safra AS ENUM ('safra', 'safrinha', 'terceira_safra');
CREATE TYPE grupo_cultura AS ENUM ('graos', 'forrageira', 'pastagem', 'oleaginosa', 'outros');
CREATE TYPE tipo_parceiro AS ENUM ('fornecedor', 'cliente', 'arrendador', 'transportador', 'cooperativa', 'orgao_publico');

-- ─── Operacional ───────────────────────────────────────────────
CREATE TYPE categoria_maquina AS ENUM ('maquina', 'implemento');
CREATE TYPE tipo_maquina AS ENUM ('trator', 'colheitadeira', 'pulverizador', 'plantadeira', 'caminhao', 'utilitario', 'drone', 'outros');
CREATE TYPE status_maquina AS ENUM ('ativo', 'manutencao', 'vendido', 'sucateado');
CREATE TYPE tipo_combustivel AS ENUM ('diesel_s10', 'diesel_s500', 'gasolina', 'etanol', 'arla32');
CREATE TYPE tipo_manutencao AS ENUM ('preventiva', 'corretiva', 'preditiva');
CREATE TYPE status_manutencao AS ENUM ('aberta', 'em_andamento', 'concluida', 'cancelada');
CREATE TYPE tipo_cnh AS ENUM ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE');

-- ─── Colaboradores (Doc 27 — substitui Doc 26) ────────────────
CREATE TYPE tipo_contrato_trabalho AS ENUM ('clt', 'informal', 'temporario', 'safrista');
CREATE TYPE setor_trabalho AS ENUM ('agricola', 'pecuaria', 'ubg', 'administrativo', 'experiencia');
CREATE TYPE tipo_folha_pagamento AS ENUM ('regular', '13_1a_parcela', '13_2a_parcela', '14_salario', 'bonus', 'gratificacao');

-- ─── Operações de Campo (Doc 25a) ─────────────────────────────
CREATE TYPE tipo_operacao_campo AS ENUM (
    'aracao', 'gradagem_pesada', 'gradagem_niveladora', 'subsolagem', 'escarificacao', 'terraceamento',
    'dessecacao_pre_plantio', 'calagem', 'gessagem',
    'plantio', 'replantio',
    'pulverizacao_herbicida', 'pulverizacao_inseticida', 'pulverizacao_fungicida', 'pulverizacao_foliar',
    'aplicacao_drone', 'adubacao_cobertura', 'irrigacao',
    'colheita', 'dessecacao_pre_colheita',
    'monitoramento', 'transporte_interno'
);
CREATE TYPE status_operacao_campo AS ENUM ('planejada', 'em_andamento', 'concluida', 'cancelada');
CREATE TYPE tipo_transporte AS ENUM ('proprio', 'terceiro');

-- ─── Insumos e Estoque (Doc 16) ──────────────────────────────
CREATE TYPE tipo_insumo AS ENUM (
    'semente', 'fertilizante', 'herbicida', 'inseticida', 'fungicida', 'adjuvante',
    'corretivo', 'inoculante', 'tratamento_semente', 'adubo_foliar',
    'medicamento_vet', 'suplemento_mineral', 'racao',
    'combustivel', 'lubrificante', 'peca_reposicao', 'material_manutencao',
    'lenha', 'embalagem', 'epi', 'outros'
);
CREATE TYPE grupo_insumo AS ENUM ('agricola', 'pecuario', 'geral');
CREATE TYPE classe_toxicologica AS ENUM ('I', 'II', 'III', 'IV', 'nao_classificado');
CREATE TYPE classe_ambiental AS ENUM ('I', 'II', 'III', 'IV');
CREATE TYPE fonte_compra AS ENUM ('castrolanda', 'revenda', 'direto_fabrica', 'barter', 'producao_propria', 'outros');
CREATE TYPE status_compra AS ENUM ('recebido', 'parcial', 'pendente', 'cancelado');
CREATE TYPE status_estoque AS ENUM ('ativo', 'zerado', 'bloqueado');
CREATE TYPE tipo_movimentacao_insumo AS ENUM (
    'entrada_compra', 'entrada_barter', 'entrada_producao', 'entrada_devolucao', 'entrada_ajuste',
    'saida_aplicacao', 'saida_pecuaria', 'saida_manutencao', 'saida_ubg', 'saida_transferencia', 'saida_perda', 'saida_ajuste'
);
CREATE TYPE metodo_aplicacao AS ENUM ('plantadeira', 'pulverizador', 'distribuidor', 'drone', 'manual', 'cocho', 'seringa');
CREATE TYPE contexto_aplicacao AS ENUM ('agricola', 'pecuario', 'manutencao', 'ubg');

-- ─── UBG (Doc 28) ─────────────────────────────────────────────
CREATE TYPE tipo_ticket_balanca AS ENUM ('entrada_producao', 'pesagem_externa', 'transferencia_silo', 'saida_venda');
CREATE TYPE status_ticket AS ENUM ('pesado', 'classificado', 'consolidado', 'cancelado');
CREATE TYPE tipo_saida_grao AS ENUM ('venda_cooperativa', 'venda_direta', 'transferencia', 'devolucao', 'descarte');
CREATE TYPE status_estoque_silo AS ENUM ('ativo', 'vazio', 'em_manutencao');

-- ─── Financeiro Cooperativa (Doc 29) ──────────────────────────
CREATE TYPE tipo_transacao_extrato AS ENUM ('saldo_anterior', 'fornecimento', 'transferencia', 'credito_venda', 'debito_compra', 'desconto', 'juros', 'outro');
CREATE TYPE tipo_transacao_cc AS ENUM ('saldo_anterior', 'fornecimento', 'transferencia', 'credito_venda', 'debito_compra', 'pagamento', 'desconto', 'juros', 'taxa', 'outro');
CREATE TYPE tipo_transacao_capital AS ENUM ('retencao', 'capitalizacao', 'devolucao', 'juros', 'outro');
CREATE TYPE tipo_financiamento_coop AS ENUM ('custeio', 'investimento', 'comercializacao', 'capital_giro', 'outro');
CREATE TYPE modalidade_carga AS ENUM ('moagem', 'semente', 'consumo', 'outro');

-- ─── Histórico Maquinário (Doc 31) ────────────────────────────
CREATE TYPE tipo_registro_maquinario AS ENUM ('abastecimento', 'manutencao', 'operacao_campo');


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 2: SISTEMA (Doc 26) — 9 tabelas                       ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 2.1 ADMINS ────────────────────────────────────────────────
CREATE TABLE admins (
    admin_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome              VARCHAR(200) NOT NULL,
    email             VARCHAR(254) NOT NULL,
    password_hash     VARCHAR(255) NOT NULL,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_admins_email UNIQUE (email)
);

CREATE TRIGGER trg_admins_updated_at
    BEFORE UPDATE ON admins
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE admins IS 'Super-administradores da plataforma. Cross-org — sem organization_id.';


-- ─── 2.2 OWNERS ───────────────────────────────────────────────
CREATE TABLE owners (
    owner_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id          UUID REFERENCES admins(admin_id),
    nome              VARCHAR(200) NOT NULL,
    email             VARCHAR(254) NOT NULL,
    cpf               VARCHAR(14),
    telefone          VARCHAR(20),
    password_hash     VARCHAR(255) NOT NULL,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_owners_email UNIQUE (email),
    CONSTRAINT uq_owners_cpf UNIQUE (cpf)
);

CREATE INDEX idx_owners_admin_id ON owners(admin_id);

CREATE TRIGGER trg_owners_updated_at
    BEFORE UPDATE ON owners
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE owners IS 'Proprietarios de organizacoes. Um owner pode ter multiplas orgs.';


-- ─── 2.3 ORGANIZATIONS ───────────────────────────────────────
CREATE TABLE organizations (
    organization_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id          UUID NOT NULL REFERENCES owners(owner_id),
    nome              VARCHAR(200) NOT NULL,
    nome_fantasia     VARCHAR(200),
    cnpj              VARCHAR(18),
    inscricao_estadual VARCHAR(20),
    endereco          TEXT,
    municipio         VARCHAR(100),
    uf                CHAR(2),
    telefone          VARCHAR(20),

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_organizations_cnpj UNIQUE (cnpj)
);

CREATE INDEX idx_organizations_owner_id ON organizations(owner_id);

CREATE TRIGGER trg_organizations_updated_at
    BEFORE UPDATE ON organizations
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE organizations IS 'Multi-tenant root. SOAL = 1 org. Todas as entidades abaixo referenciam organization_id.';


-- ─── 2.4 ORGANIZATION_SETTINGS ───────────────────────────────
CREATE TABLE organization_settings (
    setting_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    chave             VARCHAR(100) NOT NULL,
    valor             JSONB NOT NULL,
    descricao         TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_org_settings_chave UNIQUE (organization_id, chave)
);

CREATE INDEX idx_org_settings_org_id ON organization_settings(organization_id);

CREATE TRIGGER trg_org_settings_updated_at
    BEFORE UPDATE ON organization_settings
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE organization_settings IS 'Configuracoes chave-valor flexiveis por org. JSONB permite tipos variados.';


-- ─── 2.5 USERS ────────────────────────────────────────────────
CREATE TABLE users (
    user_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    email             VARCHAR(254) NOT NULL,
    cpf               VARCHAR(14),
    cargo             VARCHAR(100),
    telefone          VARCHAR(20),
    password_hash     VARCHAR(255) NOT NULL,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT uq_users_cpf UNIQUE (organization_id, cpf)
);

CREATE INDEX idx_users_org_id ON users(organization_id);

CREATE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE users IS 'Usuarios finais do sistema. Cada user pertence a uma org.';


-- ─── 2.6 ROLES ────────────────────────────────────────────────
CREATE TABLE roles (
    role_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(50) NOT NULL,
    descricao         TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_roles_nome UNIQUE (organization_id, nome)
);

CREATE INDEX idx_roles_org_id ON roles(organization_id);

CREATE TRIGGER trg_roles_updated_at
    BEFORE UPDATE ON roles
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();


-- ─── 2.7 PERMISSIONS ─────────────────────────────────────────
CREATE TABLE permissions (
    permission_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recurso           VARCHAR(100) NOT NULL,
    acao              VARCHAR(50) NOT NULL,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_permissions_recurso_acao UNIQUE (recurso, acao)
);

COMMENT ON TABLE permissions IS 'Catalogo de permissoes. Sem org_id — permissoes sao globais.';


-- ─── 2.8 USER_ROLES (M:N) ────────────────────────────────────
CREATE TABLE user_roles (
    user_id           UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id           UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, role_id)
);

CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);


-- ─── 2.9 ROLE_PERMISSIONS (M:N) ──────────────────────────────
CREATE TABLE role_permissions (
    role_id           UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    permission_id     UUID NOT NULL REFERENCES permissions(permission_id) ON DELETE CASCADE,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (role_id, permission_id)
);

CREATE INDEX idx_role_permissions_perm_id ON role_permissions(permission_id);


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 3: TERRITORIAL (Doc 26 + 25b + orphans) — 10 tabelas  ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 3.1 FAZENDAS ─────────────────────────────────────────────
CREATE TABLE fazendas (
    fazenda_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    tipo              tipo_fazenda NOT NULL DEFAULT 'propria',
    cnpj              VARCHAR(18),
    inscricao_estadual VARCHAR(20),
    car               VARCHAR(80),
    area_total_ha     NUMERIC(12,2),
    area_agricola_ha  NUMERIC(10,2),
    ccir_incra        VARCHAR(30),
    itr               VARCHAR(20),
    localidade        VARCHAR(100),
    geojson           JSONB,
    endereco          TEXT,
    municipio         VARCHAR(100),
    uf                CHAR(2),

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_fazendas_nome UNIQUE (organization_id, nome)
);

CREATE INDEX idx_fazendas_org_id ON fazendas(organization_id);

CREATE TRIGGER trg_fazendas_updated_at
    BEFORE UPDATE ON fazendas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE fazendas IS 'Propriedades rurais. SOAL tem ~12 fazendas. Campos Doc 25b incluidos (area_agricola, ccir, itr, localidade).';


-- ─── 3.2 TALHOES ─────────────────────────────────────────────
CREATE TABLE talhoes (
    talhao_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    fazenda_id        UUID NOT NULL REFERENCES fazendas(fazenda_id),
    codigo            VARCHAR(20),
    nome              VARCHAR(200) NOT NULL,
    area_ha           NUMERIC(10,2) NOT NULL,
    tipo_solo         tipo_solo,
    geojson           JSONB,
    altitude_media_m  NUMERIC(8,2),
    observacoes       TEXT,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_talhoes_nome UNIQUE (organization_id, fazenda_id, nome)
);

CREATE INDEX idx_talhoes_org_id ON talhoes(organization_id);
CREATE INDEX idx_talhoes_fazenda_id ON talhoes(fazenda_id);

CREATE TRIGGER trg_talhoes_updated_at
    BEFORE UPDATE ON talhoes
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE talhoes IS 'Subdivisoes das fazendas. 71 talhoes mapeados. Nome canonico via mapping CSV.';


-- ─── 3.3 SAFRAS ──────────────────────────────────────────────
CREATE TABLE safras (
    safra_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    ano_agricola      VARCHAR(9) NOT NULL,
    descricao         VARCHAR(100),
    data_inicio       DATE NOT NULL,
    data_fim          DATE NOT NULL,
    status            status_safra NOT NULL DEFAULT 'planejamento',
    observacoes       TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_safras_ano UNIQUE (organization_id, ano_agricola),
    CONSTRAINT chk_safras_datas CHECK (data_fim > data_inicio)
);

CREATE INDEX idx_safras_org_id ON safras(organization_id);

CREATE TRIGGER trg_safras_updated_at
    BEFORE UPDATE ON safras
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE safras IS 'Periodos agricolas. Ano fiscal: jul→jun. Safra 25/26 = Jul/2025 a Jun/2026.';


-- ─── 3.4 CULTURAS ────────────────────────────────────────────
CREATE TABLE culturas (
    cultura_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome              VARCHAR(100) NOT NULL,
    nome_exibicao     VARCHAR(100) NOT NULL,
    grupo             grupo_cultura NOT NULL DEFAULT 'graos',
    ciclo_dias        INTEGER,
    unidade_colheita  VARCHAR(20) DEFAULT 'sc_60kg',
    observacoes       TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_culturas_nome UNIQUE (nome)
);

CREATE TRIGGER trg_culturas_updated_at
    BEFORE UPDATE ON culturas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE culturas IS 'Catalogo de culturas. Sem org_id — culturas sao universais. 9 culturas V0.';


-- ─── 3.5 TALHAO_SAFRAS (Entidade CENTRAL) ────────────────────
CREATE TABLE talhao_safras (
    talhao_safra_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    talhao_id         UUID NOT NULL REFERENCES talhoes(talhao_id),
    safra_id          UUID NOT NULL REFERENCES safras(safra_id),
    cultura_id        UUID NOT NULL REFERENCES culturas(cultura_id),
    epoca             epoca_safra NOT NULL DEFAULT 'safra',
    area_plantada_ha  NUMERIC(10,2) NOT NULL,
    cultivar          VARCHAR(200),
    data_plantio      DATE,
    data_colheita     DATE,
    produtividade_sc_ha NUMERIC(10,2),
    observacoes       TEXT,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_talhao_safra UNIQUE (talhao_id, safra_id, cultura_id, epoca)
);

CREATE INDEX idx_talhao_safras_org_id ON talhao_safras(organization_id);
CREATE INDEX idx_talhao_safras_talhao_id ON talhao_safras(talhao_id);
CREATE INDEX idx_talhao_safras_safra_id ON talhao_safras(safra_id);
CREATE INDEX idx_talhao_safras_cultura_id ON talhao_safras(cultura_id);

CREATE TRIGGER trg_talhao_safras_updated_at
    BEFORE UPDATE ON talhao_safras
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE talhao_safras IS 'Entidade CENTRAL. Vincula talhao+safra+cultura+epoca. 90% dos relatorios passam por aqui.';


-- ─── 3.6 SILOS ───────────────────────────────────────────────
CREATE TABLE silos (
    silo_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    fazenda_id        UUID NOT NULL REFERENCES fazendas(fazenda_id),
    codigo            VARCHAR(20),
    nome              VARCHAR(200) NOT NULL,
    tipo              tipo_silo NOT NULL,
    capacidade_ton    NUMERIC(12,2),
    localizacao       TEXT,
    geojson           JSONB,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_silos_codigo UNIQUE (organization_id, codigo)
);

CREATE INDEX idx_silos_org_id ON silos(organization_id);
CREATE INDEX idx_silos_fazenda_id ON silos(fazenda_id);

CREATE TRIGGER trg_silos_updated_at
    BEFORE UPDATE ON silos
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE silos IS 'Estruturas de armazenamento. Dados pendentes coleta Josmar.';


-- ─── 3.7 PARCEIROS_COMERCIAIS ────────────────────────────────
CREATE TABLE parceiros_comerciais (
    parceiro_comercial_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    razao_social      VARCHAR(300) NOT NULL,
    nome_fantasia     VARCHAR(300),
    cpf_cnpj          VARCHAR(18),
    tipo_documento    VARCHAR(4),
    tipo              tipo_parceiro[] NOT NULL DEFAULT '{}',
    telefone          VARCHAR(20),
    email             VARCHAR(254),
    endereco          TEXT,
    municipio         VARCHAR(100),
    uf                CHAR(2),
    inscricao_estadual VARCHAR(20),
    observacoes       TEXT,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_parceiros_cpf_cnpj UNIQUE (organization_id, cpf_cnpj)
);

CREATE INDEX idx_parceiros_org_id ON parceiros_comerciais(organization_id);
CREATE INDEX idx_parceiros_tipo ON parceiros_comerciais USING GIN (tipo);

CREATE TRIGGER trg_parceiros_updated_at
    BEFORE UPDATE ON parceiros_comerciais
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE parceiros_comerciais IS '2.201 parceiros do AgriWin. tipo[] = ARRAY para multiplos papeis.';


-- ─── 3.8 MATRICULAS (Doc 25b) ────────────────────────────────
CREATE TABLE matriculas (
    matricula_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fazenda_id                UUID NOT NULL REFERENCES fazendas(fazenda_id),

    numero_matricula          VARCHAR(20),
    registro                  VARCHAR(20),
    descricao                 TEXT,
    area_ha                   NUMERIC(10,4) NOT NULL,
    titular                   VARCHAR(10) NOT NULL DEFAULT 'SOAL',

    data_aquisicao            DATE,
    proprietario_anterior     TEXT,
    valor_compra              NUMERIC(12,2),
    data_incorporacao_soal    DATE,
    registro_anterior_1       VARCHAR(20),
    registro_anterior_2       VARCHAR(20),
    observacoes               TEXT,

    status                    VARCHAR(20) DEFAULT 'active',
    created_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_matriculas_fazenda ON matriculas(fazenda_id);
CREATE INDEX idx_matriculas_numero ON matriculas(numero_matricula);
CREATE INDEX idx_matriculas_titular ON matriculas(titular);

CREATE TRIGGER trg_matriculas_updated_at
    BEFORE UPDATE ON matriculas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE matriculas IS 'Registros de matricula imobiliaria. 88 registros (59 SOAL + 29 CK). Leaf da camada territorial.';


-- ─── 3.9 UBG (Unidade de Beneficiamento — orphan) ────────────
CREATE TABLE ubgs (
    ubg_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    fazenda_sede_id   UUID REFERENCES fazendas(fazenda_id),

    capacidade_recepcao_t_dia   NUMERIC(10,2),
    capacidade_secagem_t_dia    NUMERIC(10,2),
    tem_balanca       BOOLEAN DEFAULT FALSE,
    tem_tombador      BOOLEAN DEFAULT FALSE,
    tem_secador       BOOLEAN DEFAULT FALSE,
    software_ubg      VARCHAR(100),
    responsavel_tecnico VARCHAR(200),
    crea_responsavel  VARCHAR(20),
    latitude          NUMERIC(10,7),
    longitude         NUMERIC(10,7),
    observacoes       TEXT,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ubgs_org_id ON ubgs(organization_id);
CREATE INDEX idx_ubgs_fazenda ON ubgs(fazenda_sede_id);

CREATE TRIGGER trg_ubgs_updated_at
    BEFORE UPDATE ON ubgs
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE ubgs IS 'Unidade de Beneficiamento de Graos. Dados pendentes coleta Josmar (capacidades, GPS).';


-- ─── 3.10 TANQUES_COMBUSTIVEL (orphan) ───────────────────────
CREATE TABLE tanques_combustivel (
    tanque_combustivel_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    fazenda_id        UUID REFERENCES fazendas(fazenda_id),
    nome              VARCHAR(200) NOT NULL,
    tipo_combustivel  tipo_combustivel,
    capacidade_litros NUMERIC(10,2),
    volume_atual_litros NUMERIC(10,2),

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tanques_org_id ON tanques_combustivel(organization_id);
CREATE INDEX idx_tanques_fazenda ON tanques_combustivel(fazenda_id);

CREATE TRIGGER trg_tanques_updated_at
    BEFORE UPDATE ON tanques_combustivel
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE tanques_combustivel IS 'Tanques de combustivel nas fazendas. Fonte: Vestro portal (5 tanques).';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 4: OPERACIONAL (Doc 26 + 27 + orphans) — 8 tabelas    ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 4.1 MAQUINAS ─────────────────────────────────────────────
CREATE TABLE maquinas (
    maquina_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    codigo_interno    VARCHAR(20) NOT NULL,
    nome              VARCHAR(200) NOT NULL,
    categoria         categoria_maquina NOT NULL,
    tipo              tipo_maquina,
    marca             VARCHAR(100),
    modelo            VARCHAR(100),
    ano_fabricacao     INTEGER,
    chassi            VARCHAR(50),
    numero_serie      VARCHAR(50),
    placa             VARCHAR(10),
    horimetro_atual   NUMERIC(10,1) DEFAULT 0,
    hodometro_atual   NUMERIC(12,1) DEFAULT 0,
    trator_vinculado_id UUID REFERENCES maquinas(maquina_id),
    valor_compra      NUMERIC(14,2),
    data_compra       DATE,
    valor_atual       NUMERIC(14,2),
    nota_fiscal_compra VARCHAR(50),
    status            status_maquina NOT NULL DEFAULT 'ativo',

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_maquinas_codigo UNIQUE (organization_id, codigo_interno)
);

CREATE INDEX idx_maquinas_org_id ON maquinas(organization_id);
CREATE INDEX idx_maquinas_trator_vinculado ON maquinas(trator_vinculado_id)
    WHERE trator_vinculado_id IS NOT NULL;
CREATE INDEX idx_maquinas_status ON maquinas(status)
    WHERE status = 'ativo';

CREATE TRIGGER trg_maquinas_updated_at
    BEFORE UPDATE ON maquinas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE maquinas IS '183 maquinas/implementos. Pertencem a ORG, nao a fazenda. Self-ref para implemento→trator.';


-- ─── 4.2 OPERADORES ──────────────────────────────────────────
CREATE TABLE operadores (
    operador_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    cpf               VARCHAR(14),
    cnh_numero        VARCHAR(20),
    cnh_categoria     tipo_cnh,
    cnh_validade      DATE,
    telefone          VARCHAR(20),
    matricula_vestro  VARCHAR(20),
    -- colaborador_id adicionado após criação de colaboradores (seção 4.5)

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_operadores_cpf UNIQUE (organization_id, cpf)
);

CREATE INDEX idx_operadores_org_id ON operadores(organization_id);

CREATE TRIGGER trg_operadores_updated_at
    BEFORE UPDATE ON operadores
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE operadores IS '30 operadores via Vestro. CPF pendente coleta completa.';


-- ─── 4.3 ABASTECIMENTOS ──────────────────────────────────────
CREATE TABLE abastecimentos (
    abastecimento_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    maquina_id        UUID NOT NULL REFERENCES maquinas(maquina_id),
    operador_id       UUID REFERENCES operadores(operador_id),
    data_hora         TIMESTAMP WITH TIME ZONE NOT NULL,
    tipo_combustivel  tipo_combustivel NOT NULL,
    quantidade_litros NUMERIC(10,2) NOT NULL,
    valor_total       NUMERIC(12,2),
    preco_unitario    NUMERIC(10,4),
    horimetro_momento NUMERIC(10,1),
    odometro_momento  NUMERIC(12,1),
    tanque_nome       VARCHAR(100),
    observacoes       TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_abastecimentos_org_id ON abastecimentos(organization_id);
CREATE INDEX idx_abastecimentos_maquina_id ON abastecimentos(maquina_id);
CREATE INDEX idx_abastecimentos_operador_id ON abastecimentos(operador_id)
    WHERE operador_id IS NOT NULL;
CREATE INDEX idx_abastecimentos_data ON abastecimentos(data_hora);

CREATE TRIGGER trg_abastecimentos_updated_at
    BEFORE UPDATE ON abastecimentos
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE abastecimentos IS 'Abastecimentos de combustivel via Vestro. Fonte: crawler/API.';


-- ─── 4.4 MANUTENCOES ─────────────────────────────────────────
CREATE TABLE manutencoes (
    manutencao_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    maquina_id        UUID NOT NULL REFERENCES maquinas(maquina_id),
    tipo              tipo_manutencao NOT NULL,
    descricao         TEXT,
    data_abertura     DATE NOT NULL,
    data_conclusao    DATE,
    horimetro_abertura NUMERIC(10,1),
    custo_pecas       NUMERIC(12,2) DEFAULT 0,
    custo_mao_obra    NUMERIC(12,2) DEFAULT 0,
    custo_total       NUMERIC(12,2) DEFAULT 0,
    prestador_servico VARCHAR(200),
    status            status_manutencao NOT NULL DEFAULT 'aberta',
    observacoes       TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_manutencoes_org_id ON manutencoes(organization_id);
CREATE INDEX idx_manutencoes_maquina_id ON manutencoes(maquina_id);
CREATE INDEX idx_manutencoes_status ON manutencoes(status)
    WHERE status IN ('aberta', 'em_andamento');

CREATE TRIGGER trg_manutencoes_updated_at
    BEFORE UPDATE ON manutencoes
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE manutencoes IS 'Ordens de manutencao. Custo = pecas + mao_obra. Historico via ETL maquinario.';


-- ─── 4.5 COLABORADORES (Doc 27 — substitui trabalhadores_rurais) ──
CREATE TABLE colaboradores (
    colaborador_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    cpf               VARCHAR(14),
    setor             setor_trabalho,
    funcao            VARCHAR(100),
    tipo_contrato     tipo_contrato_trabalho NOT NULL DEFAULT 'clt',
    data_admissao     DATE,
    data_desligamento DATE,
    conta_banco       VARCHAR(50),
    telefone          VARCHAR(20),

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Partial unique: apenas CPFs nao-nulos sao unicos por org
CREATE UNIQUE INDEX uq_colaboradores_cpf_partial
    ON colaboradores (organization_id, cpf)
    WHERE cpf IS NOT NULL;

CREATE INDEX idx_colaboradores_org_id ON colaboradores(organization_id);
CREATE INDEX idx_colaboradores_cpf ON colaboradores(cpf)
    WHERE cpf IS NOT NULL;
CREATE INDEX idx_colaboradores_setor ON colaboradores(setor);

CREATE TRIGGER trg_colaboradores_updated_at
    BEFORE UPDATE ON colaboradores
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE colaboradores IS
    'Funcionarios de todas as areas (agricola, UBG, administrativo, pecuaria). '
    'Substitui trabalhadores_rurais do Doc 26. Fonte: ETL folha_pagamento.py (88 registros).';
COMMENT ON COLUMN colaboradores.cpf IS
    'CPF formatado 000.000.000-00. Nullable para informais historicos sem documento.';
COMMENT ON COLUMN colaboradores.data_desligamento IS
    'Data de desligamento. NULL = colaborador ativo.';


-- ─── 4.6 FOLHA_PAGAMENTO (Doc 27) ────────────────────────────
CREATE TABLE folha_pagamento (
    folha_pagamento_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id    UUID NOT NULL REFERENCES organizations(organization_id),
    colaborador_id     UUID NOT NULL REFERENCES colaboradores(colaborador_id),
    ano_mes            DATE NOT NULL,
    tipo_folha         tipo_folha_pagamento NOT NULL DEFAULT 'regular',
    salario_bruto      NUMERIC(12,2) DEFAULT 0,
    ferias_pf          NUMERIC(12,2) DEFAULT 0,
    decimo_terceiro    NUMERIC(12,2) DEFAULT 0,
    horas_extras       NUMERIC(12,2) DEFAULT 0,
    descontos          NUMERIC(12,2) DEFAULT 0,
    acrescimos         NUMERIC(12,2) DEFAULT 0,
    total_liquido      NUMERIC(12,2) DEFAULT 0,
    observacoes        TEXT,

    created_at         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_folha_colaborador_mes
        UNIQUE (organization_id, colaborador_id, ano_mes, tipo_folha)
);

CREATE INDEX idx_folha_colaborador_mes ON folha_pagamento(colaborador_id, ano_mes);
CREATE INDEX idx_folha_ano_mes ON folha_pagamento(ano_mes);
CREATE INDEX idx_folha_org_id ON folha_pagamento(organization_id);

CREATE TRIGGER trg_folha_pagamento_updated_at
    BEFORE UPDATE ON folha_pagamento
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE folha_pagamento IS
    'Historico mensal de folha de pagamento. 3.122 registros (Jul/2017→Fev/2026).';
COMMENT ON COLUMN folha_pagamento.ano_mes IS
    'Primeiro dia do mes de competencia. Ex: 2020-01-01 = janeiro/2020.';
COMMENT ON COLUMN folha_pagamento.descontos IS
    'Valor de descontos. Armazenado como valor positivo no banco.';


-- ─── 4.7 ALTER OPERADORES → FK para colaboradores (Doc 27) ───
ALTER TABLE operadores
    ADD COLUMN colaborador_id UUID REFERENCES colaboradores(colaborador_id);

CREATE INDEX idx_operadores_colaborador ON operadores(colaborador_id)
    WHERE colaborador_id IS NOT NULL;

COMMENT ON COLUMN operadores.colaborador_id IS
    'FK opcional para colaboradores. Vincula operador Vestro ao registro CLT. Match via CPF.';


-- ─── 4.8 TAGS_VESTRO (orphan) ────────────────────────────────
CREATE TABLE tags_vestro (
    tag_vestro_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    codigo            VARCHAR(50),
    codigo_maquinas   VARCHAR(50),
    nome_vestro       VARCHAR(200),
    tag_rfid          VARCHAR(50),
    tipo_medicao      VARCHAR(50),
    combustivel       VARCHAR(50),
    tipo_proprietario VARCHAR(50),
    empresa_vestro    VARCHAR(200),
    match_type        VARCHAR(50),
    volume_max_litros NUMERIC(10,2),
    maquina_id        UUID REFERENCES maquinas(maquina_id),
    ativo             BOOLEAN DEFAULT TRUE,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tags_vestro_org_id ON tags_vestro(organization_id);
CREATE INDEX idx_tags_vestro_maquina ON tags_vestro(maquina_id) WHERE maquina_id IS NOT NULL;
CREATE INDEX idx_tags_vestro_rfid ON tags_vestro(tag_rfid);

CREATE TRIGGER trg_tags_vestro_updated_at
    BEFORE UPDATE ON tags_vestro
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE tags_vestro IS 'Tags RFID do sistema Vestro. 47 tags mapeadas para maquinas. Fonte: portal Vestro xlsx.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 5: INSUMOS (Doc 16) — 6 tabelas                       ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 5.1 PRODUTO_INSUMO ──────────────────────────────────────
CREATE TABLE produto_insumo (
    produto_insumo_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id           UUID NOT NULL REFERENCES organizations(organization_id),
    codigo                    VARCHAR(50) NOT NULL,
    nome                      VARCHAR(200) NOT NULL,
    principio_ativo           VARCHAR(200),
    tipo                      tipo_insumo NOT NULL,
    grupo                     grupo_insumo NOT NULL,
    unidade_medida            VARCHAR(20) NOT NULL,
    unidade_embalagem         VARCHAR(50),
    fabricante                VARCHAR(200),
    registro_mapa             VARCHAR(50),
    classe_toxicologica       classe_toxicologica,
    classe_ambiental          classe_ambiental,
    carencia_dias             INTEGER,
    dose_recomendada_min      DECIMAL(10,4),
    dose_recomendada_max      DECIMAL(10,4),
    ativo                     BOOLEAN NOT NULL DEFAULT true,

    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT uq_produto_insumo_org_codigo UNIQUE (organization_id, codigo),
    CONSTRAINT chk_carencia_positiva CHECK (carencia_dias IS NULL OR carencia_dias >= 0),
    CONSTRAINT chk_dose_range CHECK (
        dose_recomendada_min IS NULL
        OR dose_recomendada_max IS NULL
        OR dose_recomendada_min <= dose_recomendada_max
    )
);

CREATE INDEX idx_produto_insumo_org ON produto_insumo(organization_id);
CREATE INDEX idx_produto_insumo_tipo ON produto_insumo(tipo);
CREATE INDEX idx_produto_insumo_grupo ON produto_insumo(grupo);
CREATE INDEX idx_produto_insumo_nome ON produto_insumo(nome);
CREATE INDEX idx_produto_insumo_ativo ON produto_insumo(organization_id, ativo) WHERE ativo = true;

CREATE TRIGGER trg_produto_insumo_updated_at
    BEFORE UPDATE ON produto_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE produto_insumo IS 'Catalogo de produtos insumos - dicionario sem preco ou saldo';
COMMENT ON COLUMN produto_insumo.tipo IS '21 tipos: semente, fertilizante, herbicida, inseticida, fungicida, adjuvante, corretivo, inoculante, tratamento_semente, adubo_foliar, medicamento_vet, suplemento_mineral, racao, combustivel, lubrificante, peca_reposicao, material_manutencao, lenha, embalagem, epi, outros';
COMMENT ON COLUMN produto_insumo.registro_mapa IS 'Numero de registro no MAPA - obrigatorio para defensivos';


-- ─── 5.2 RECEITUARIO_AGRONOMICO ──────────────────────────────
CREATE TABLE receituario_agronomico (
    receituario_agronomico_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id             UUID NOT NULL REFERENCES organizations(organization_id),
    produto_insumo_id           UUID NOT NULL REFERENCES produto_insumo(produto_insumo_id),
    numero_receita              VARCHAR(50) NOT NULL,
    numero_art                  VARCHAR(50) NOT NULL,
    responsavel_tecnico         VARCHAR(200) NOT NULL,
    crea                        VARCHAR(20) NOT NULL,
    cultura_id                  UUID REFERENCES culturas(cultura_id),
    praga_alvo                  VARCHAR(200),
    dose_prescrita              DECIMAL(10,4) NOT NULL,
    unidade_dose                VARCHAR(20) NOT NULL,
    intervalo_seguranca_dias    INTEGER NOT NULL,
    data_emissao                DATE NOT NULL,
    data_validade               DATE NOT NULL,
    observacoes                 TEXT,
    arquivo_url                 VARCHAR(500),

    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_receituario_validade CHECK (data_emissao <= data_validade),
    CONSTRAINT chk_receituario_dose_positiva CHECK (dose_prescrita > 0),
    CONSTRAINT chk_receituario_carencia_positiva CHECK (intervalo_seguranca_dias >= 0)
);

CREATE INDEX idx_receituario_org ON receituario_agronomico(organization_id);
CREATE INDEX idx_receituario_produto ON receituario_agronomico(produto_insumo_id);
CREATE INDEX idx_receituario_cultura ON receituario_agronomico(cultura_id) WHERE cultura_id IS NOT NULL;
CREATE INDEX idx_receituario_validade ON receituario_agronomico(data_validade);
CREATE INDEX idx_receituario_numero ON receituario_agronomico(numero_receita);

CREATE TRIGGER trg_receituario_updated_at
    BEFORE UPDATE ON receituario_agronomico
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE receituario_agronomico IS 'Receituario agronomico - compliance MAPA para defensivos';
COMMENT ON COLUMN receituario_agronomico.numero_art IS 'Anotacao de Responsabilidade Tecnica do agronomo';


-- ─── 5.3 COMPRA_INSUMO ───────────────────────────────────────
CREATE TABLE compra_insumo (
    compra_insumo_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id           UUID NOT NULL REFERENCES organizations(organization_id),
    produto_insumo_id         UUID NOT NULL REFERENCES produto_insumo(produto_insumo_id),
    -- nota_fiscal_item_id    UUID REFERENCES nota_fiscal_item(nota_fiscal_item_id),  -- FK futuro
    parceiro_id               UUID NOT NULL REFERENCES parceiros_comerciais(parceiro_comercial_id),
    safra_id                  UUID REFERENCES safras(safra_id),
    fonte                     fonte_compra NOT NULL,
    data_compra               DATE NOT NULL,
    quantidade                DECIMAL(12,4) NOT NULL,
    unidade                   VARCHAR(20) NOT NULL,
    valor_unitario            DECIMAL(12,4) NOT NULL,
    valor_total               DECIMAL(14,2) NOT NULL,
    lote_fabricante           VARCHAR(50),
    data_fabricacao            DATE,
    data_validade              DATE,
    cultura_destino_id        UUID REFERENCES culturas(cultura_id),
    numero_pedido             VARCHAR(50),
    castrolanda_sync_id       VARCHAR(50),
    -- contrato_barter_id     UUID REFERENCES contrato_comercial(contrato_comercial_id),  -- FK futuro
    status                    status_compra NOT NULL DEFAULT 'pendente',
    observacoes               TEXT,

    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_compra_quantidade_positiva CHECK (quantidade > 0),
    CONSTRAINT chk_compra_valor_positivo CHECK (valor_unitario >= 0 AND valor_total >= 0),
    CONSTRAINT chk_compra_validade CHECK (
        data_fabricacao IS NULL
        OR data_validade IS NULL
        OR data_fabricacao <= data_validade
    )
);

CREATE INDEX idx_compra_insumo_org ON compra_insumo(organization_id);
CREATE INDEX idx_compra_insumo_produto ON compra_insumo(produto_insumo_id);
CREATE INDEX idx_compra_insumo_parceiro ON compra_insumo(parceiro_id);
CREATE INDEX idx_compra_insumo_safra ON compra_insumo(safra_id);
CREATE INDEX idx_compra_insumo_data ON compra_insumo(data_compra);
CREATE INDEX idx_compra_insumo_fonte ON compra_insumo(fonte);
CREATE INDEX idx_compra_insumo_status ON compra_insumo(status);
CREATE INDEX idx_compra_insumo_castrolanda ON compra_insumo(castrolanda_sync_id) WHERE castrolanda_sync_id IS NOT NULL;

CREATE TRIGGER trg_compra_insumo_updated_at
    BEFORE UPDATE ON compra_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE compra_insumo IS 'Registro de compras de insumos - multi-fornecedor (Castrolanda, revenda, barter, etc.)';
COMMENT ON COLUMN compra_insumo.castrolanda_sync_id IS 'ID da integracao Castrolanda - 90% das NFs passam pela cooperativa';


-- ─── 5.4 ESTOQUE_INSUMO ──────────────────────────────────────
CREATE TABLE estoque_insumo (
    estoque_insumo_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id             UUID NOT NULL REFERENCES organizations(organization_id),
    produto_insumo_id           UUID NOT NULL REFERENCES produto_insumo(produto_insumo_id),
    fazenda_id                  UUID NOT NULL REFERENCES fazendas(fazenda_id),
    local_armazenamento         VARCHAR(100) NOT NULL,
    quantidade_atual            DECIMAL(12,4) NOT NULL DEFAULT 0,
    unidade                     VARCHAR(20) NOT NULL,
    custo_medio_unitario        DECIMAL(12,4) NOT NULL DEFAULT 0,
    valor_total_estoque         DECIMAL(14,2) NOT NULL DEFAULT 0,
    quantidade_minima           DECIMAL(12,4),
    quantidade_maxima           DECIMAL(12,4),
    lote_mais_antigo            VARCHAR(50),
    validade_mais_proxima       DATE,
    data_ultimo_inventario      DATE,
    status                      status_estoque NOT NULL DEFAULT 'ativo',

    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT uq_estoque_produto_local UNIQUE (organization_id, produto_insumo_id, fazenda_id, local_armazenamento),
    CONSTRAINT chk_estoque_quantidade_nao_negativa CHECK (quantidade_atual >= 0),
    CONSTRAINT chk_estoque_custo_nao_negativo CHECK (custo_medio_unitario >= 0),
    CONSTRAINT chk_estoque_min_max CHECK (
        quantidade_minima IS NULL
        OR quantidade_maxima IS NULL
        OR quantidade_minima <= quantidade_maxima
    )
);

CREATE INDEX idx_estoque_insumo_org ON estoque_insumo(organization_id);
CREATE INDEX idx_estoque_insumo_produto ON estoque_insumo(produto_insumo_id);
CREATE INDEX idx_estoque_insumo_fazenda ON estoque_insumo(fazenda_id);
CREATE INDEX idx_estoque_insumo_status ON estoque_insumo(status);
CREATE INDEX idx_estoque_insumo_reposicao ON estoque_insumo(organization_id)
    WHERE status = 'ativo' AND quantidade_atual <= quantidade_minima;
CREATE INDEX idx_estoque_insumo_validade ON estoque_insumo(validade_mais_proxima)
    WHERE validade_mais_proxima IS NOT NULL AND quantidade_atual > 0;

CREATE TRIGGER trg_estoque_insumo_updated_at
    BEFORE UPDATE ON estoque_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE estoque_insumo IS 'Posicao atual de estoque - uma linha por combinacao produto+fazenda+local';
COMMENT ON COLUMN estoque_insumo.custo_medio_unitario IS 'Custo medio ponderado - atualizado automaticamente nas entradas, mantido nas saidas';
COMMENT ON COLUMN estoque_insumo.valor_total_estoque IS 'Calculado: quantidade_atual x custo_medio_unitario';


-- ─── 5.5 APLICACAO_INSUMO ────────────────────────────────────
CREATE TABLE aplicacao_insumo (
    aplicacao_insumo_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id           UUID NOT NULL REFERENCES organizations(organization_id),
    produto_insumo_id         UUID NOT NULL REFERENCES produto_insumo(produto_insumo_id),
    estoque_insumo_id         UUID REFERENCES estoque_insumo(estoque_insumo_id),
    operacao_campo_id         UUID,  -- FK adicionada após criação de operacoes_campo (seção 6)
    talhao_safra_id           UUID REFERENCES talhao_safras(talhao_safra_id),
    -- manejo_sanitario_id    UUID REFERENCES manejo_sanitario(manejo_sanitario_id),  -- FK futuro (pecuária V0 fora)
    manutencao_id             UUID REFERENCES manutencoes(manutencao_id),
    receituario_id            UUID REFERENCES receituario_agronomico(receituario_agronomico_id),
    data_aplicacao            DATE NOT NULL,
    dose_por_ha               DECIMAL(10,4),
    area_aplicada_ha          DECIMAL(10,4),
    quantidade_total          DECIMAL(12,4) NOT NULL,
    unidade                   VARCHAR(20) NOT NULL,
    custo_unitario            DECIMAL(12,4) NOT NULL,
    custo_total               DECIMAL(14,2) NOT NULL,
    metodo_aplicacao          metodo_aplicacao,
    contexto                  contexto_aplicacao NOT NULL,
    observacoes               TEXT,

    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_aplicacao_quantidade_positiva CHECK (quantidade_total > 0),
    CONSTRAINT chk_aplicacao_custo_positivo CHECK (custo_unitario >= 0 AND custo_total >= 0),
    CONSTRAINT chk_aplicacao_contexto_agricola CHECK (
        contexto != 'agricola' OR (operacao_campo_id IS NOT NULL AND talhao_safra_id IS NOT NULL)
    ),
    -- chk_aplicacao_contexto_pecuario omitido: manejo_sanitario fora do V0
    CONSTRAINT chk_aplicacao_contexto_manutencao CHECK (
        contexto != 'manutencao' OR manutencao_id IS NOT NULL
    )
);

CREATE INDEX idx_aplicacao_insumo_org ON aplicacao_insumo(organization_id);
CREATE INDEX idx_aplicacao_insumo_produto ON aplicacao_insumo(produto_insumo_id);
CREATE INDEX idx_aplicacao_insumo_operacao ON aplicacao_insumo(operacao_campo_id) WHERE operacao_campo_id IS NOT NULL;
CREATE INDEX idx_aplicacao_insumo_talhao_safra ON aplicacao_insumo(talhao_safra_id) WHERE talhao_safra_id IS NOT NULL;
CREATE INDEX idx_aplicacao_insumo_data ON aplicacao_insumo(data_aplicacao);
CREATE INDEX idx_aplicacao_insumo_contexto ON aplicacao_insumo(contexto);
CREATE INDEX idx_aplicacao_insumo_manutencao ON aplicacao_insumo(manutencao_id) WHERE manutencao_id IS NOT NULL;

CREATE TRIGGER trg_aplicacao_insumo_updated_at
    BEFORE UPDATE ON aplicacao_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE aplicacao_insumo IS 'Uso de insumo no campo/pecuaria/manutencao/ubg - 1 OPERACAO_CAMPO pode ter N aplicacoes';
COMMENT ON COLUMN aplicacao_insumo.contexto IS 'agricola: requer operacao_campo_id + talhao_safra_id | manutencao: requer manutencao_id | ubg: estoque generico';


-- ─── 5.6 MOVIMENTACAO_INSUMO ─────────────────────────────────
CREATE TABLE movimentacao_insumo (
    movimentacao_insumo_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    estoque_insumo_id           UUID NOT NULL REFERENCES estoque_insumo(estoque_insumo_id),
    tipo                        tipo_movimentacao_insumo NOT NULL,
    data_movimento              TIMESTAMPTZ NOT NULL DEFAULT now(),
    quantidade                  DECIMAL(12,4) NOT NULL,
    custo_unitario              DECIMAL(12,4) NOT NULL,
    valor_total                 DECIMAL(14,2) NOT NULL,
    saldo_anterior              DECIMAL(12,4) NOT NULL,
    saldo_posterior             DECIMAL(12,4) NOT NULL,
    custo_medio_anterior        DECIMAL(12,4) NOT NULL,
    custo_medio_posterior       DECIMAL(12,4) NOT NULL,
    compra_insumo_id            UUID REFERENCES compra_insumo(compra_insumo_id),
    aplicacao_insumo_id         UUID REFERENCES aplicacao_insumo(aplicacao_insumo_id),
    transferencia_destino_id    UUID REFERENCES estoque_insumo(estoque_insumo_id),
    responsavel_id              UUID REFERENCES users(user_id),
    documento_referencia        VARCHAR(50),
    observacoes                 TEXT,

    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT chk_movimentacao_quantidade_positiva CHECK (quantidade > 0),
    CONSTRAINT chk_movimentacao_saldo_coerente CHECK (
        (tipo IN ('entrada_compra','entrada_barter','entrada_producao','entrada_devolucao','entrada_ajuste')
         AND saldo_posterior >= saldo_anterior)
        OR
        (tipo IN ('saida_aplicacao','saida_pecuaria','saida_manutencao','saida_ubg','saida_transferencia','saida_perda','saida_ajuste')
         AND saldo_posterior <= saldo_anterior)
    ),
    CONSTRAINT chk_movimentacao_compra_ref CHECK (
        (tipo = 'entrada_compra' AND compra_insumo_id IS NOT NULL) OR tipo != 'entrada_compra'
    ),
    CONSTRAINT chk_movimentacao_aplicacao_ref CHECK (
        (tipo = 'saida_aplicacao' AND aplicacao_insumo_id IS NOT NULL) OR tipo != 'saida_aplicacao'
    ),
    CONSTRAINT chk_movimentacao_transferencia_ref CHECK (
        (tipo = 'saida_transferencia' AND transferencia_destino_id IS NOT NULL) OR tipo != 'saida_transferencia'
    )
);

CREATE INDEX idx_movimentacao_estoque ON movimentacao_insumo(estoque_insumo_id);
CREATE INDEX idx_movimentacao_tipo ON movimentacao_insumo(tipo);
CREATE INDEX idx_movimentacao_data ON movimentacao_insumo(data_movimento);
CREATE INDEX idx_movimentacao_compra ON movimentacao_insumo(compra_insumo_id) WHERE compra_insumo_id IS NOT NULL;
CREATE INDEX idx_movimentacao_aplicacao ON movimentacao_insumo(aplicacao_insumo_id) WHERE aplicacao_insumo_id IS NOT NULL;
CREATE INDEX idx_movimentacao_responsavel ON movimentacao_insumo(responsavel_id);

COMMENT ON TABLE movimentacao_insumo IS 'Historico imutavel (append-only) de todas as movimentacoes de estoque';
COMMENT ON COLUMN movimentacao_insumo.quantidade IS 'Sempre positivo - direcao definida pelo tipo';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 6: OPERAÇÕES CAMPO (Doc 25a) — 6 tabelas              ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 6.1 OPERACOES_CAMPO (Entidade HUB) ──────────────────────
CREATE TABLE operacoes_campo (
    operacao_campo_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),
    talhao_safra_id       UUID NOT NULL REFERENCES talhao_safras(talhao_safra_id),
    maquina_id            UUID REFERENCES maquinas(maquina_id),
    operador_id           UUID REFERENCES operadores(operador_id),
    fazenda_id            UUID REFERENCES fazendas(fazenda_id),         -- DENORM: 3 hops via talhao_safra→talhoes→fazendas

    tipo                  tipo_operacao_campo NOT NULL,
    status                status_operacao_campo NOT NULL DEFAULT 'concluida',

    data_inicio           DATE NOT NULL,
    data_fim              DATE,

    area_trabalhada_ha    DECIMAL(10,4),
    horimetro_inicio      DECIMAL(12,2),
    horimetro_fim         DECIMAL(12,2),
    combustivel_litros    DECIMAL(10,2),
    custo_operacao        DECIMAL(12,2),

    implemento_codigo     VARCHAR(50),
    observacoes           TEXT,
    geojson_trajeto       JSONB,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_operacao_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_operacao_horimetro CHECK (
        horimetro_fim IS NULL OR horimetro_inicio IS NULL OR horimetro_fim >= horimetro_inicio
    ),
    CONSTRAINT chk_operacao_area CHECK (area_trabalhada_ha IS NULL OR area_trabalhada_ha > 0)
);

CREATE INDEX idx_operacoes_campo_talhao_safra ON operacoes_campo(talhao_safra_id);
CREATE INDEX idx_operacoes_campo_maquina      ON operacoes_campo(maquina_id);
CREATE INDEX idx_operacoes_campo_tipo         ON operacoes_campo(tipo);
CREATE INDEX idx_operacoes_campo_data         ON operacoes_campo(data_inicio);
CREATE INDEX idx_operacoes_campo_fazenda      ON operacoes_campo(fazenda_id);

CREATE TRIGGER trg_operacoes_campo_updated
    BEFORE UPDATE ON operacoes_campo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON COLUMN operacoes_campo.fazenda_id IS 'DENORM: 3 hops via talhao_safra→talhoes→fazendas. Mantido para performance em filtros por fazenda.';
COMMENT ON COLUMN operacoes_campo.implemento_codigo IS 'Referencia textual ao implemento usado. Nao FK — implementos nao tem cadastro formal V0.';


-- ─── 6.1b ALTER APLICACAO_INSUMO → FK para operacoes_campo ───
ALTER TABLE aplicacao_insumo
    ADD CONSTRAINT fk_aplicacao_operacao_campo
    FOREIGN KEY (operacao_campo_id) REFERENCES operacoes_campo(operacao_campo_id);


-- ─── 6.2 PLANTIO_DETALHES ────────────────────────────────────
CREATE TABLE plantio_detalhes (
    plantio_detalhe_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(operacao_campo_id) ON DELETE CASCADE,

    variedade             VARCHAR(100),
    populacao_sementes_ha INTEGER,
    espacamento_cm        DECIMAL(6,2),
    profundidade_cm       DECIMAL(4,2),
    tratamento_sementes   VARCHAR(200),
    adubo_base            VARCHAR(200),
    quantidade_adubo_kg_ha DECIMAL(8,2),
    umidade_solo_percent  DECIMAL(5,2),

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE plantio_detalhes IS 'Detalhe 1:0..1 de OPERACAO_CAMPO para tipo plantio/replantio.';


-- ─── 6.3 COLHEITA_DETALHES ───────────────────────────────────
CREATE TABLE colheita_detalhes (
    colheita_detalhe_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(operacao_campo_id) ON DELETE CASCADE,

    producao_total_kg     DECIMAL(12,2),
    produtividade_kg_ha   DECIMAL(10,2),
    produtividade_sacas_ha DECIMAL(10,2),
    umidade_media_percent DECIMAL(5,2),
    perdas_estimadas_percent DECIMAL(5,2),
    velocidade_media_kmh  DECIMAL(6,2),
    condicoes_climaticas  JSONB,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_colheita_producao CHECK (producao_total_kg IS NULL OR producao_total_kg >= 0),
    CONSTRAINT chk_colheita_produtividade CHECK (produtividade_sacas_ha IS NULL OR produtividade_sacas_ha >= 0)
);

COMMENT ON COLUMN colheita_detalhes.produtividade_sacas_ha IS 'KPI central: sacas/ha. Soja saca=60kg, Milho saca=60kg, Trigo saca=60kg.';


-- ─── 6.4 PULVERIZACAO_DETALHES ───────────────────────────────
CREATE TABLE pulverizacao_detalhes (
    pulverizacao_detalhe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id       UUID NOT NULL UNIQUE REFERENCES operacoes_campo(operacao_campo_id) ON DELETE CASCADE,

    alvo                  VARCHAR(200),
    dose_ha               DECIMAL(10,4),
    volume_calda_ha       DECIMAL(8,2),
    vazao_bico            DECIMAL(8,4),
    pressao_bar           DECIMAL(6,2),
    temperatura_c         DECIMAL(4,1),
    umidade_relativa      DECIMAL(5,2),
    velocidade_vento_kmh  DECIMAL(5,2),

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE pulverizacao_detalhes IS 'Dados TECNICOS da pulverizacao. Produto aplicado registrado via APLICACAO_INSUMO (Doc 16), nao aqui.';


-- ─── 6.5 DRONE_DETALHES ──────────────────────────────────────
CREATE TABLE drone_detalhes (
    drone_detalhe_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(operacao_campo_id) ON DELETE CASCADE,

    modelo_drone          VARCHAR(100),
    altitude_voo_m        DECIMAL(6,2),
    velocidade_voo_ms     DECIMAL(6,2),
    largura_faixa_m       DECIMAL(6,2),
    volume_calda_ha       DECIMAL(8,2),
    autonomia_bateria_min INTEGER,
    numero_voos           INTEGER,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- ─── 6.6 TRANSPORTE_COLHEITA_DETALHES ────────────────────────
CREATE TABLE transporte_colheita_detalhes (
    transporte_colheita_detalhe_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operacao_campo_id     UUID NOT NULL UNIQUE REFERENCES operacoes_campo(operacao_campo_id) ON DELETE CASCADE,

    colheita_origem_id    UUID REFERENCES operacoes_campo(operacao_campo_id),
    ticket_balanca_id     UUID,  -- FK adicionada após criação de ticket_balancas (seção 7)

    numero_viagem         INTEGER,
    placa_veiculo         VARCHAR(10),
    motorista             VARCHAR(100),
    tipo_transporte       tipo_transporte DEFAULT 'proprio',
    transportadora        VARCHAR(100),

    hora_saida_campo      TIMESTAMP WITH TIME ZONE,
    hora_chegada_ubg      TIMESTAMP WITH TIME ZONE,

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


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 7: UBG (Doc 28) — 7 tabelas                           ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 7.1 TICKET_BALANCAS ─────────────────────────────────────
CREATE TABLE ticket_balancas (
    ticket_balanca_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),
    talhao_safra_id       UUID REFERENCES talhao_safras(talhao_safra_id),
    silo_destino_id       UUID REFERENCES silos(silo_id),

    tipo                  tipo_ticket_balanca NOT NULL DEFAULT 'entrada_producao',
    status                status_ticket NOT NULL DEFAULT 'pesado',

    numero_ticket         INTEGER,

    talhao_aba            VARCHAR(100),
    talhao_nome           VARCHAR(100),
    gleba                 VARCHAR(100),

    data_pesagem          DATE NOT NULL,
    hora_pesagem          TIME,
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    avariado_g            DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),
    quebrado_g            DECIMAL(8,2),

    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    placa_veiculo         VARCHAR(10),
    motorista             VARCHAR(100),
    destino               VARCHAR(100),

    variedade             VARCHAR(100),
    flag_semente          BOOLEAN DEFAULT FALSE,

    observacoes           TEXT,
    source_file           VARCHAR(200),

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_ticket_peso_bruto CHECK (peso_bruto_kg IS NULL OR peso_bruto_kg > 0),
    CONSTRAINT chk_ticket_peso_liquido CHECK (peso_liquido_kg IS NULL OR peso_liquido_kg >= 0),
    CONSTRAINT chk_ticket_umidade CHECK (umidade_pct IS NULL OR (umidade_pct >= 0 AND umidade_pct <= 100))
);

CREATE INDEX idx_ticket_balanca_safra       ON ticket_balancas(safra_id);
CREATE INDEX idx_ticket_balanca_cultura     ON ticket_balancas(cultura_id);
CREATE INDEX idx_ticket_balanca_data        ON ticket_balancas(data_pesagem);
CREATE INDEX idx_ticket_balanca_talhao_safra ON ticket_balancas(talhao_safra_id);
CREATE INDEX idx_ticket_balanca_silo        ON ticket_balancas(silo_destino_id) WHERE silo_destino_id IS NOT NULL;

CREATE TRIGGER trg_ticket_balanca_updated
    BEFORE UPDATE ON ticket_balancas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE ticket_balancas IS 'Ponto de transferencia agricultura→UBG. Cada pesagem na balanca gera um ticket.';
COMMENT ON COLUMN ticket_balancas.gleba IS 'Sub-area dentro de um talhao. Ex: talhao CAPINZAL tem glebas HERMATRIA, BANACK, URUGUAI.';
COMMENT ON COLUMN ticket_balancas.flag_semente IS 'True quando a producao e de semente certificada para Castrolanda.';


-- ─── 7.1b ALTER transporte_colheita → FK para ticket_balancas ──
ALTER TABLE transporte_colheita_detalhes
    ADD CONSTRAINT fk_transporte_ticket_balanca
    FOREIGN KEY (ticket_balanca_id) REFERENCES ticket_balancas(ticket_balanca_id);


-- ─── 7.2 PRODUCAO_UBG ────────────────────────────────────────
CREATE TABLE producao_ubg (
    producao_ubg_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),

    arquivo_fonte         VARCHAR(200),
    aba                   VARCHAR(100),
    talhao_header         VARCHAR(100),
    area_ha               DECIMAL(10,4),
    produtividade_kg_ha   DECIMAL(10,2),
    produto_variedade     VARCHAR(100),
    producao_total_kg     DECIMAL(12,2),

    data_pesagem          DATE,
    hora_pesagem          TIME,
    gleba                 VARCHAR(100),
    destino               VARCHAR(100),
    variedade_ticket      VARCHAR(100),
    motorista             VARCHAR(100),
    placa                 VARCHAR(10),
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_pct          DECIMAL(5,2),
    ardidos_pct           DECIMAL(5,2),
    avariado_pct          DECIMAL(5,2),
    verdes_pct            DECIMAL(5,2),
    quebrado_pct          DECIMAL(5,2),

    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_producao_ubg_safra   ON producao_ubg(safra_id);
CREATE INDEX idx_producao_ubg_cultura ON producao_ubg(cultura_id);
CREATE INDEX idx_producao_ubg_data    ON producao_ubg(data_pesagem);

CREATE TRIGGER trg_producao_ubg_updated
    BEFORE UPDATE ON producao_ubg
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE producao_ubg IS 'Dados historicos de producao UBG importados das planilhas de controle (2022-2026). 883 tickets, 7 culturas.';


-- ─── 7.3 PESAGENS_AGRICOLA ───────────────────────────────────
CREATE TABLE pesagens_agricola (
    pesagem_agricola_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),

    arquivo               VARCHAR(200),
    talhao_aba            VARCHAR(100),
    talhao_nome           VARCHAR(100),

    data_pesagem          DATE NOT NULL,
    hora_pesagem          TIME,
    gleba                 VARCHAR(100),
    destino               VARCHAR(100),
    placa                 VARCHAR(10),
    motorista             VARCHAR(100),
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    avariado_g            DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),
    quebrado_g            DECIMAL(8,2),

    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    variedade             VARCHAR(100),
    flag_semente          BOOLEAN DEFAULT FALSE,

    observacoes           TEXT,
    source_file           VARCHAR(200),

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_pesagem_agr_safra   ON pesagens_agricola(safra_id);
CREATE INDEX idx_pesagem_agr_cultura ON pesagens_agricola(cultura_id);
CREATE INDEX idx_pesagem_agr_data    ON pesagens_agricola(data_pesagem);

CREATE TRIGGER trg_pesagem_agricola_updated
    BEFORE UPDATE ON pesagens_agricola
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE pesagens_agricola IS 'Pesagens agricolas no campo. Diferente de ticket_balanca que e na UBG.';


-- ─── 7.4 SAIDAS_GRAO ─────────────────────────────────────────
CREATE TABLE saidas_grao (
    saida_grao_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),

    contrato_codigo       VARCHAR(50),
    contrato_descricao    VARCHAR(300),

    data_embarque         DATE NOT NULL,
    hora_embarque         TIME,
    origem                VARCHAR(100) DEFAULT 'UBG',
    destino               VARCHAR(100),
    transportadora        VARCHAR(100),
    motorista             VARCHAR(100),
    placa                 VARCHAR(10),
    tipo_produto          VARCHAR(100),

    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),

    desconto_coop_kg      DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    sacas                 DECIMAL(10,2),
    preco_por_saca        DECIMAL(10,2),
    preco_por_kg          DECIMAL(10,4),
    valor_bruto           DECIMAL(14,2),

    source_file           VARCHAR(200),

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_saida_grao_safra     ON saidas_grao(safra_id);
CREATE INDEX idx_saida_grao_cultura   ON saidas_grao(cultura_id);
CREATE INDEX idx_saida_grao_data      ON saidas_grao(data_embarque);
CREATE INDEX idx_saida_grao_contrato  ON saidas_grao(contrato_codigo);

CREATE TRIGGER trg_saida_grao_updated
    BEFORE UPDATE ON saidas_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE saidas_grao IS 'Embarques de grao saindo da UBG para compradores. 542 registros, 4 culturas, 4 safras.';


-- ─── 7.5 RECEBIMENTOS_GRAO ───────────────────────────────────
CREATE TABLE recebimentos_grao (
    recebimento_grao_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    ticket_balanca_id     UUID NOT NULL REFERENCES ticket_balancas(ticket_balanca_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),
    silo_destino_id       UUID REFERENCES silos(silo_id),

    classificacao_grao    VARCHAR(50),
    umidade_final_pct     DECIMAL(5,2),
    ph_final              DECIMAL(5,2),
    impureza_final_pct    DECIMAL(5,2),

    desconto_umidade_kg   DECIMAL(12,2),
    desconto_impureza_kg  DECIMAL(12,2),
    desconto_outros_kg    DECIMAL(12,2),
    peso_recebido_kg      DECIMAL(12,2),

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_recebimento_ticket ON recebimentos_grao(ticket_balanca_id);
CREATE INDEX idx_recebimento_safra  ON recebimentos_grao(safra_id);
CREATE INDEX idx_recebimento_silo   ON recebimentos_grao(silo_destino_id);

CREATE TRIGGER trg_recebimento_grao_updated
    BEFORE UPDATE ON recebimentos_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE recebimentos_grao IS 'Recebimento formal pos-classificacao. Derivado de TICKET_BALANCA. Dados pendentes Josmar.';


-- ─── 7.6 CONTROLES_SECAGEM ───────────────────────────────────
CREATE TABLE controles_secagem (
    controle_secagem_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),
    silo_id               UUID REFERENCES silos(silo_id),

    data_inicio           DATE NOT NULL,
    data_fim              DATE,
    hora_inicio           TIME,
    hora_fim              TIME,

    umidade_entrada_pct   DECIMAL(5,2),
    umidade_saida_pct     DECIMAL(5,2),
    temperatura_c         DECIMAL(5,1),
    peso_entrada_kg       DECIMAL(12,2),
    peso_saida_kg         DECIMAL(12,2),
    perda_secagem_kg      DECIMAL(12,2),

    lenha_m3              DECIMAL(10,2),
    energia_kwh           DECIMAL(10,2),

    custo_lenha           DECIMAL(12,2),
    custo_energia         DECIMAL(12,2),
    custo_total_secagem   DECIMAL(12,2),

    observacoes           TEXT,

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_secagem_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_secagem_umidade CHECK (
        umidade_entrada_pct IS NULL OR umidade_saida_pct IS NULL
        OR umidade_entrada_pct >= umidade_saida_pct
    )
);

CREATE INDEX idx_secagem_safra  ON controles_secagem(safra_id);
CREATE INDEX idx_secagem_silo   ON controles_secagem(silo_id);
CREATE INDEX idx_secagem_data   ON controles_secagem(data_inicio);

CREATE TRIGGER trg_controle_secagem_updated
    BEFORE UPDATE ON controles_secagem
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE controles_secagem IS 'Registro de cada ciclo de secagem na UBG. Custos proprios (lenha + energia) separados da agricultura.';
COMMENT ON COLUMN controles_secagem.lenha_m3 IS 'Lenha e PRODUTO_INSUMO tipo LENHA, grupo geral. Consumida exclusivamente na secagem.';


-- ─── 7.7 ESTOQUES_SILO ──────────────────────────────────────
CREATE TABLE estoques_silo (
    estoque_silo_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    silo_id               UUID NOT NULL REFERENCES silos(silo_id),
    safra_id              UUID REFERENCES safras(safra_id),
    cultura_id            UUID REFERENCES culturas(cultura_id),

    status_estoque        status_estoque_silo NOT NULL DEFAULT 'ativo',

    data_referencia       DATE NOT NULL,
    quantidade_kg         DECIMAL(14,2) NOT NULL DEFAULT 0,
    capacidade_restante_kg DECIMAL(14,2),

    umidade_media_pct     DECIMAL(5,2),
    ph_medio              DECIMAL(5,2),

    total_entradas_kg     DECIMAL(14,2) DEFAULT 0,
    total_saidas_kg       DECIMAL(14,2) DEFAULT 0,
    total_perda_secagem_kg DECIMAL(14,2) DEFAULT 0,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_estoque_silo_data UNIQUE (silo_id, safra_id, cultura_id, data_referencia),
    CONSTRAINT chk_estoque_quantidade CHECK (quantidade_kg >= 0)
);

CREATE INDEX idx_estoque_silo_silo   ON estoques_silo(silo_id);
CREATE INDEX idx_estoque_silo_safra  ON estoques_silo(safra_id);
CREATE INDEX idx_estoque_silo_data   ON estoques_silo(data_referencia);

CREATE TRIGGER trg_estoque_silo_updated
    BEFORE UPDATE ON estoques_silo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE estoques_silo IS 'Snapshot de estoque por silo/safra/cultura. Auto-calculado via trigger ou view materializada.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 8: FINANCEIRO (Doc 29) — 7 tabelas                    ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 8.1 EXTRATOS_COOPERATIVA ────────────────────────────────
CREATE TABLE extratos_cooperativa (
    extrato_cooperativa_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    matricula              VARCHAR(20) NOT NULL,
    cooperado              VARCHAR(200),

    conta_codigo           VARCHAR(20),
    conta_descricao        VARCHAR(100),
    safra_ref              VARCHAR(20),

    data_movimento         DATE,
    descricao              TEXT NOT NULL,
    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),
    tipo_transacao         tipo_transacao_extrato NOT NULL DEFAULT 'outro',

    nf_referencia          VARCHAR(100),
    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_extrato_coop_matricula ON extratos_cooperativa(matricula);
CREATE INDEX idx_extrato_coop_conta     ON extratos_cooperativa(conta_codigo);
CREATE INDEX idx_extrato_coop_data      ON extratos_cooperativa(data_movimento);
CREATE INDEX idx_extrato_coop_tipo      ON extratos_cooperativa(tipo_transacao);

CREATE TRIGGER trg_extrato_coop_updated
    BEFORE UPDATE ON extratos_cooperativa
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE extratos_cooperativa IS 'Extrato Castrolanda por cultura. 8.211 transacoes historicas.';


-- ─── 8.2 CC_COOPERATIVA ──────────────────────────────────────
CREATE TABLE cc_cooperativa (
    cc_cooperativa_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    matricula              VARCHAR(20),
    cooperado              VARCHAR(200),

    data_movimento         DATE,
    num_lancamento         VARCHAR(50),
    descricao              TEXT NOT NULL,
    cod_operacao           VARCHAR(100),
    referencia             VARCHAR(200),

    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),
    tipo_transacao         tipo_transacao_cc NOT NULL DEFAULT 'outro',

    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_cc_coop_matricula ON cc_cooperativa(matricula);
CREATE INDEX idx_cc_coop_data      ON cc_cooperativa(data_movimento);
CREATE INDEX idx_cc_coop_tipo      ON cc_cooperativa(tipo_transacao);

CREATE TRIGGER trg_cc_coop_updated
    BEFORE UPDATE ON cc_cooperativa
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE cc_cooperativa IS 'Conta corrente geral Castrolanda. 2.889 transacoes (6 anos).';


-- ─── 8.3 CONTAS_CAPITAL ──────────────────────────────────────
CREATE TABLE contas_capital (
    conta_capital_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    cooperado              VARCHAR(200),
    conta_codigo           VARCHAR(20),
    conta_descricao        VARCHAR(100),

    data_movimento         DATE,
    historico              VARCHAR(200),
    descricao              TEXT,
    debito                 DECIMAL(14,2),
    credito                DECIMAL(14,2),
    saldo                  DECIMAL(14,2),
    tipo_dc                CHAR(1),
    tipo_transacao         tipo_transacao_capital NOT NULL DEFAULT 'outro',

    nf_referencia          VARCHAR(100),
    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_conta_capital_conta ON contas_capital(conta_codigo);
CREATE INDEX idx_conta_capital_data  ON contas_capital(data_movimento);
CREATE INDEX idx_conta_capital_tipo  ON contas_capital(tipo_transacao);

CREATE TRIGGER trg_conta_capital_updated
    BEFORE UPDATE ON contas_capital
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE contas_capital IS 'Capital social retido na Castrolanda. Contas 24 (Mat.Prima) e 39 (UBC). 77 registros.';


-- ─── 8.4 FINANCIAMENTOS_COOP ─────────────────────────────────
CREATE TABLE financiamentos_coop (
    financiamento_coop_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    num_contrato           VARCHAR(50) NOT NULL,
    tipo_financiamento     tipo_financiamento_coop NOT NULL DEFAULT 'outro',

    data_liberacao         DATE,
    vencimento_final       DATE,
    taxa_juros             DECIMAL(8,4),
    parcelas               INTEGER,
    modalidade             VARCHAR(100),

    data_movimento         DATE,
    historico              TEXT,
    credito                DECIMAL(14,2),
    debito                 DECIMAL(14,2),
    saldo                  DECIMAL(14,2),

    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_financiamento_contrato ON financiamentos_coop(num_contrato);
CREATE INDEX idx_financiamento_tipo     ON financiamentos_coop(tipo_financiamento);
CREATE INDEX idx_financiamento_data     ON financiamentos_coop(data_movimento);

CREATE TRIGGER trg_financiamento_coop_updated
    BEFORE UPDATE ON financiamentos_coop
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE financiamentos_coop IS 'Financiamentos via Castrolanda. 22 contratos (9 ativos), 220 movimentos.';


-- ─── 8.5 VENDAS_GRAO ─────────────────────────────────────────
CREATE TABLE vendas_grao (
    venda_grao_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id               UUID REFERENCES safras(safra_id),
    cultura_id             UUID REFERENCES culturas(cultura_id),

    data_venda             DATE NOT NULL,
    numero_venda           VARCHAR(50),
    contrato               VARCHAR(50),
    comprador              VARCHAR(200),

    armazem                VARCHAR(50),
    filial                 VARCHAR(50),
    municipio              VARCHAR(50),
    data_emissao_nf        DATE,
    data_embarque          DATE,
    frete_por_ton          DECIMAL(10,2),

    peso_kg                DECIMAL(14,2),
    preco_por_saca         DECIMAL(10,2),
    valor_bruto            DECIMAL(14,2),
    desconto_bordero       DECIMAL(14,2),
    valor_nota_fiscal      DECIMAL(14,2),
    desconto_nf            DECIMAL(14,2),
    valor_credito          DECIMAL(14,2),
    data_credito           DATE,

    emissor_nf             VARCHAR(100),
    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_venda_grao_safra    ON vendas_grao(safra_id);
CREATE INDEX idx_venda_grao_cultura  ON vendas_grao(cultura_id);
CREATE INDEX idx_venda_grao_data     ON vendas_grao(data_venda);
CREATE INDEX idx_venda_grao_contrato ON vendas_grao(contrato);

CREATE TRIGGER trg_venda_grao_updated
    BEFORE UPDATE ON vendas_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE vendas_grao IS 'Vendas de grao via Castrolanda. R$99.3M bruto historico, 170 vendas, 13 safras.';


-- ─── 8.6 CARGAS_A_CARGA ──────────────────────────────────────
CREATE TABLE cargas_a_carga (
    carga_a_carga_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id               UUID REFERENCES safras(safra_id),
    cultura_id             UUID REFERENCES culturas(cultura_id),

    produto_codigo         VARCHAR(20),
    produto_nome           VARCHAR(200),
    cultivar               VARCHAR(100),

    num_docto              VARCHAR(50),
    nota_fiscal            VARCHAR(50),
    data_entrega           DATE NOT NULL,
    modalidade             modalidade_carga DEFAULT 'moagem',

    peso_bruto_kg          DECIMAL(12,2),
    peso_liquido_kg        DECIMAL(12,2),
    rec_sec                DECIMAL(8,2),

    talhao                 VARCHAR(100),
    filial                 VARCHAR(20),
    placa                  VARCHAR(10),
    motorista              VARCHAR(100),

    ph_inicial             DECIMAL(5,2),
    ph_final               DECIMAL(5,2),
    fn                     DECIMAL(8,2),

    qualidade_json         JSONB,

    arquivo_origem         VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_carga_safra    ON cargas_a_carga(safra_id);
CREATE INDEX idx_carga_cultura  ON cargas_a_carga(cultura_id);
CREATE INDEX idx_carga_data     ON cargas_a_carga(data_entrega);
CREATE INDEX idx_carga_produto  ON cargas_a_carga(produto_codigo);
CREATE INDEX idx_carga_qualidade ON cargas_a_carga USING GIN (qualidade_json);

CREATE TRIGGER trg_carga_a_carga_updated
    BEFORE UPDATE ON cargas_a_carga
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE cargas_a_carga IS 'Relatorio carga-a-carga Castrolanda. 1.337 entregas, 42.4k ton bruto.';
COMMENT ON COLUMN cargas_a_carga.qualidade_json IS 'Metricas de qualidade variam por cultura: soja(umidade,impureza,ardidos), trigo(umidade,ph,fn), etc.';


-- ─── 8.7 CUSTOS_INSUMO_COOP ──────────────────────────────────
CREATE TABLE custos_insumo_coop (
    custo_insumo_coop_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id               UUID REFERENCES safras(safra_id),
    cultura_id             UUID REFERENCES culturas(cultura_id),

    categoria              VARCHAR(100),
    nome_produto           VARCHAR(300),
    codigo_produto         VARCHAR(50),
    unidade                VARCHAR(20),

    data_emissao           DATE,
    numero_nf              VARCHAR(50),
    tipo_operacao          VARCHAR(50),

    quantidade             DECIMAL(14,4),
    preco_unitario         DECIMAL(14,4),
    valor_total            DECIMAL(14,2),

    quantidade_vendida     DECIMAL(14,4),
    valor_vendido          DECIMAL(14,2),

    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_custo_insumo_safra    ON custos_insumo_coop(safra_id);
CREATE INDEX idx_custo_insumo_cultura  ON custos_insumo_coop(cultura_id);
CREATE INDEX idx_custo_insumo_produto  ON custos_insumo_coop(codigo_produto);
CREATE INDEX idx_custo_insumo_data     ON custos_insumo_coop(data_emissao);

CREATE TRIGGER trg_custo_insumo_coop_updated
    BEFORE UPDATE ON custos_insumo_coop
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE custos_insumo_coop IS 'Custos de insumos fornecidos via Castrolanda. 553 registros.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 9: FRETE + VENDAS DIRETAS (Doc 30) — 2 tabelas        ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 9.1 FRETEIROS ────────────────────────────────────────────
CREATE TABLE freteiros (
    freteiro_id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id               UUID REFERENCES safras(safra_id),

    nome_motorista         VARCHAR(100) NOT NULL,
    data_viagem            DATE NOT NULL,
    hora_viagem            TIME,
    placa                  VARCHAR(10),

    produto                VARCHAR(100),
    origem                 VARCHAR(100),
    destino                VARCHAR(100),
    peso_kg                DECIMAL(12,2),

    codigo_frete           VARCHAR(50),
    tarifa_por_ton         DECIMAL(10,2),
    valor_frete            DECIMAL(12,2),

    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_freteiro_safra      ON freteiros(safra_id);
CREATE INDEX idx_freteiro_motorista  ON freteiros(nome_motorista);
CREATE INDEX idx_freteiro_data       ON freteiros(data_viagem);

CREATE TRIGGER trg_freteiro_updated
    BEFORE UPDATE ON freteiros
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE freteiros IS 'Viagens de frete terceirizado campo→UBG. 116 viagens, 2 motoristas principais.';


-- ─── 9.2 VENDAS_DIRETAS ──────────────────────────────────────
CREATE TABLE vendas_diretas (
    venda_direta_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    safra_id               UUID REFERENCES safras(safra_id),
    cultura_id             UUID REFERENCES culturas(cultura_id),

    data_venda             DATE NOT NULL,
    numero_nfe             VARCHAR(50),
    produtor               VARCHAR(100),
    comprador              VARCHAR(200),
    tipo_feijao            VARCHAR(100),

    quantidade_kg          DECIMAL(14,2),
    sacas                  DECIMAL(10,2),
    preco_unitario         DECIMAL(10,2),
    valor_total            DECIMAL(14,2),
    imposto_senar          DECIMAL(12,2),
    valor_liquido          DECIMAL(14,2),

    data_pagamento         DATE,
    conta_destino          VARCHAR(100),
    situacao               VARCHAR(100),

    observacoes            TEXT,
    source_file            VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_venda_direta_safra    ON vendas_diretas(safra_id);
CREATE INDEX idx_venda_direta_cultura  ON vendas_diretas(cultura_id);
CREATE INDEX idx_venda_direta_data     ON vendas_diretas(data_venda);
CREATE INDEX idx_venda_direta_comprador ON vendas_diretas(comprador);

CREATE TRIGGER trg_venda_direta_updated
    BEFORE UPDATE ON vendas_diretas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE vendas_diretas IS 'Vendas diretas sem intermediacao da cooperativa. Principalmente feijao. 73 vendas.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 10: HISTÓRICO MAQUINÁRIO (Doc 31) — 1 tabela          ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 10.1 HISTORICO_MAQUINAS ──────────────────────────────────
CREATE TABLE historico_maquinas (
    historico_maquina_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(organization_id),

    maquina_id             UUID REFERENCES maquinas(maquina_id),

    tipo_registro          tipo_registro_maquinario NOT NULL,

    maquina_codigo         VARCHAR(50),
    maquina_nome           VARCHAR(200),
    maquina_status         VARCHAR(20),

    data_registro          DATE NOT NULL,

    horimetro              DECIMAL(12,2),
    hodometro              DECIMAL(12,2),

    combustivel            VARCHAR(50),
    quantidade_litros      DECIMAL(10,2),
    valor_unitario         DECIMAL(10,4),
    valor_total            DECIMAL(12,2),
    tanque_saida           VARCHAR(100),

    descricao_manutencao   TEXT,
    tipo_manutencao_txt    VARCHAR(100),
    quantidade_pecas       DECIMAL(10,2),
    nota_fiscal            VARCHAR(50),

    operacao               VARCHAR(200),
    cultura                VARCHAR(100),
    implemento_codigo      VARCHAR(50),
    fazenda_talhao         VARCHAR(200),
    horimetro_inicio       DECIMAL(12,2),
    horimetro_fim          DECIMAL(12,2),

    responsavel            VARCHAR(100),
    observacoes            TEXT,

    source_file            VARCHAR(200),
    source_aba             VARCHAR(200),

    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_hist_maq_tipo       ON historico_maquinas(tipo_registro);
CREATE INDEX idx_hist_maq_maquina    ON historico_maquinas(maquina_id) WHERE maquina_id IS NOT NULL;
CREATE INDEX idx_hist_maq_codigo     ON historico_maquinas(maquina_codigo);
CREATE INDEX idx_hist_maq_data       ON historico_maquinas(data_registro);
CREATE INDEX idx_hist_maq_status     ON historico_maquinas(maquina_status);

CREATE TRIGGER trg_historico_maquina_updated
    BEFORE UPDATE ON historico_maquinas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE historico_maquinas IS 'Dados legados de maquinario (1997-2026). 32.516 registros, 11 planilhas, 101 abas.';
COMMENT ON COLUMN historico_maquinas.maquina_id IS 'FK resolvida apos mapeamento codigo→UUID. NULL enquanto nao mapeado.';
COMMENT ON COLUMN historico_maquinas.fazenda_talhao IS 'Texto concatenado "FAZENDA - TALHAO" do legado. Nao e FK.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 11: AUXILIARES (orphans) — 2 tabelas                   ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 11.1 TALHAO_MAPPING ─────────────────────────────────────
CREATE TABLE talhao_mapping (
    talhao_mapping_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    talhoes_csv_name      VARCHAR(200),
    plantio_2425_name     VARCHAR(200),
    plantio_2526_name     VARCHAR(200),
    canonical_name        VARCHAR(200) NOT NULL,

    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE talhao_mapping IS 'Tabela auxiliar de normalizacao de nomes de talhoes entre modulos AgriWin. 183 variantes → 61 canonicos.';


-- ─── 11.2 UBG_CAIXA ──────────────────────────────────────────
CREATE TABLE ubg_caixa (
    ubg_caixa_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(organization_id),

    arquivo               VARCHAR(200),
    ano                   INTEGER,
    mes                   INTEGER,
    data                  DATE,
    produto               VARCHAR(200),
    qtde                  DECIMAL(12,4),
    descricao             TEXT,
    comprador             VARCHAR(200),
    localidade            VARCHAR(200),
    forma_pgto            VARCHAR(100),
    credito               DECIMAL(14,2),
    debito                DECIMAL(14,2),
    saldo                 DECIMAL(14,2),
    tipo                  VARCHAR(50),

    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_ubg_caixa_org_id ON ubg_caixa(organization_id);
CREATE INDEX idx_ubg_caixa_data ON ubg_caixa(data);
CREATE INDEX idx_ubg_caixa_tipo ON ubg_caixa(tipo);
CREATE INDEX idx_ubg_caixa_ano_mes ON ubg_caixa(ano, mes);

CREATE TRIGGER trg_ubg_caixa_updated
    BEFORE UPDATE ON ubg_caixa
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE ubg_caixa IS 'Fluxo de caixa historico da UBG. 19.177 registros (2011-2026). Receitas: varejo subprodutos + pesagem publica.';


-- ╔═══════════════════════════════════════════════════════════════╗
-- ║  SEÇÃO 12: VIEWS + FUNÇÕES DE NEGÓCIO (Doc 16)               ║
-- ╚═══════════════════════════════════════════════════════════════╝

-- ─── 12.1 Função: Entrada por Compra (Custo Médio Ponderado) ──
CREATE OR REPLACE FUNCTION fn_entrada_compra_estoque(
    p_compra_insumo_id UUID,
    p_estoque_insumo_id UUID,
    p_responsavel_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_compra RECORD;
    v_estoque RECORD;
    v_novo_custo_medio DECIMAL(12,4);
    v_novo_saldo DECIMAL(12,4);
    v_novo_valor_total DECIMAL(14,2);
    v_movimentacao_id UUID;
BEGIN
    SELECT quantidade, valor_unitario, valor_total
    INTO v_compra
    FROM compra_insumo
    WHERE compra_insumo_id = p_compra_insumo_id;

    SELECT quantidade_atual, custo_medio_unitario, valor_total_estoque
    INTO v_estoque
    FROM estoque_insumo
    WHERE estoque_insumo_id = p_estoque_insumo_id
    FOR UPDATE;

    IF v_estoque.quantidade_atual + v_compra.quantidade > 0 THEN
        v_novo_custo_medio = (
            v_estoque.quantidade_atual * v_estoque.custo_medio_unitario
            + v_compra.quantidade * v_compra.valor_unitario
        ) / (v_estoque.quantidade_atual + v_compra.quantidade);
    ELSE
        v_novo_custo_medio = v_compra.valor_unitario;
    END IF;

    v_novo_saldo = v_estoque.quantidade_atual + v_compra.quantidade;
    v_novo_valor_total = v_novo_saldo * v_novo_custo_medio;

    INSERT INTO movimentacao_insumo (
        estoque_insumo_id, tipo, quantidade, custo_unitario, valor_total,
        saldo_anterior, saldo_posterior, custo_medio_anterior, custo_medio_posterior,
        compra_insumo_id, responsavel_id
    ) VALUES (
        p_estoque_insumo_id, 'entrada_compra', v_compra.quantidade,
        v_compra.valor_unitario, v_compra.valor_total,
        v_estoque.quantidade_atual, v_novo_saldo,
        v_estoque.custo_medio_unitario, v_novo_custo_medio,
        p_compra_insumo_id, p_responsavel_id
    )
    RETURNING movimentacao_insumo_id INTO v_movimentacao_id;

    UPDATE estoque_insumo
    SET quantidade_atual = v_novo_saldo,
        custo_medio_unitario = v_novo_custo_medio,
        valor_total_estoque = v_novo_valor_total,
        status = 'ativo'
    WHERE estoque_insumo_id = p_estoque_insumo_id;

    UPDATE compra_insumo
    SET status = 'recebido'
    WHERE compra_insumo_id = p_compra_insumo_id;

    RETURN v_movimentacao_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_entrada_compra_estoque IS 'Processa entrada de compra: calcula custo medio ponderado, registra movimentacao, atualiza saldo';


-- ─── 12.2 Função: Saída por Aplicação ────────────────────────
CREATE OR REPLACE FUNCTION fn_saida_aplicacao_estoque(
    p_aplicacao_insumo_id UUID,
    p_responsavel_id UUID DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_aplicacao RECORD;
    v_estoque RECORD;
    v_novo_saldo DECIMAL(12,4);
    v_novo_valor_total DECIMAL(14,2);
    v_movimentacao_id UUID;
BEGIN
    SELECT quantidade_total, estoque_insumo_id, custo_unitario, custo_total
    INTO v_aplicacao
    FROM aplicacao_insumo
    WHERE aplicacao_insumo_id = p_aplicacao_insumo_id;

    SELECT quantidade_atual, custo_medio_unitario, valor_total_estoque
    INTO v_estoque
    FROM estoque_insumo
    WHERE estoque_insumo_id = v_aplicacao.estoque_insumo_id
    FOR UPDATE;

    IF v_estoque.quantidade_atual < v_aplicacao.quantidade_total THEN
        RAISE EXCEPTION 'Saldo insuficiente. Disponivel: %, Solicitado: %',
            v_estoque.quantidade_atual, v_aplicacao.quantidade_total;
    END IF;

    v_novo_saldo = v_estoque.quantidade_atual - v_aplicacao.quantidade_total;
    v_novo_valor_total = v_novo_saldo * v_estoque.custo_medio_unitario;

    INSERT INTO movimentacao_insumo (
        estoque_insumo_id, tipo, quantidade, custo_unitario, valor_total,
        saldo_anterior, saldo_posterior, custo_medio_anterior, custo_medio_posterior,
        aplicacao_insumo_id, responsavel_id
    ) VALUES (
        v_aplicacao.estoque_insumo_id, 'saida_aplicacao', v_aplicacao.quantidade_total,
        v_estoque.custo_medio_unitario, v_aplicacao.quantidade_total * v_estoque.custo_medio_unitario,
        v_estoque.quantidade_atual, v_novo_saldo,
        v_estoque.custo_medio_unitario, v_estoque.custo_medio_unitario,
        p_aplicacao_insumo_id, p_responsavel_id
    )
    RETURNING movimentacao_insumo_id INTO v_movimentacao_id;

    UPDATE estoque_insumo
    SET quantidade_atual = v_novo_saldo,
        valor_total_estoque = v_novo_valor_total,
        status = CASE WHEN v_novo_saldo = 0 THEN 'zerado' ELSE 'ativo' END
    WHERE estoque_insumo_id = v_aplicacao.estoque_insumo_id;

    RETURN v_movimentacao_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_saida_aplicacao_estoque IS 'Processa saida por aplicacao: valida saldo, registra movimentacao, custo medio nao muda';


-- ─── 12.3 Trigger: Custo automático na aplicação ─────────────
CREATE OR REPLACE FUNCTION fn_aplicacao_custo_from_estoque()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.custo_unitario IS NULL OR NEW.custo_unitario = 0 THEN
        SELECT custo_medio_unitario
        INTO NEW.custo_unitario
        FROM estoque_insumo
        WHERE estoque_insumo_id = NEW.estoque_insumo_id;

        NEW.custo_total = NEW.quantidade_total * NEW.custo_unitario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_aplicacao_custo_auto
    BEFORE INSERT ON aplicacao_insumo
    FOR EACH ROW
    WHEN (NEW.estoque_insumo_id IS NOT NULL)
    EXECUTE FUNCTION fn_aplicacao_custo_from_estoque();


-- ─── 12.4 View: Estoque Consolidado ──────────────────────────
CREATE OR REPLACE VIEW vw_estoque_consolidado AS
SELECT
    pi.produto_insumo_id as produto_id,
    pi.codigo,
    pi.nome as produto,
    pi.tipo,
    pi.grupo,
    pi.unidade_medida,
    f.nome as fazenda,
    ei.local_armazenamento,
    ei.quantidade_atual,
    ei.custo_medio_unitario,
    ei.valor_total_estoque,
    ei.quantidade_minima,
    CASE
        WHEN ei.quantidade_atual <= 0 THEN 'ZERADO'
        WHEN ei.quantidade_minima IS NOT NULL AND ei.quantidade_atual <= ei.quantidade_minima THEN 'REPOR'
        WHEN ei.quantidade_minima IS NOT NULL AND ei.quantidade_atual <= ei.quantidade_minima * 1.5 THEN 'ATENCAO'
        ELSE 'OK'
    END as status_reposicao,
    ei.validade_mais_proxima,
    CASE
        WHEN ei.validade_mais_proxima IS NOT NULL AND ei.validade_mais_proxima <= CURRENT_DATE THEN 'VENCIDO'
        WHEN ei.validade_mais_proxima IS NOT NULL AND ei.validade_mais_proxima <= CURRENT_DATE + INTERVAL '30 days' THEN 'VENCE_30D'
        WHEN ei.validade_mais_proxima IS NOT NULL AND ei.validade_mais_proxima <= CURRENT_DATE + INTERVAL '90 days' THEN 'VENCE_90D'
        ELSE 'OK'
    END as status_validade,
    ei.data_ultimo_inventario,
    ei.status as status_estoque
FROM estoque_insumo ei
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.produto_insumo_id
JOIN fazendas f ON ei.fazenda_id = f.fazenda_id
WHERE pi.ativo = true;

COMMENT ON VIEW vw_estoque_consolidado IS 'Visao consolidada do estoque com alertas de reposicao e validade';


-- ─── 12.5 View: Custo Insumo por Talhão/Safra ────────────────
CREATE OR REPLACE VIEW vw_custo_insumo_talhao_safra AS
SELECT
    s.ano_agricola as safra,
    f.nome as fazenda,
    t.nome as talhao,
    c.nome as cultura,
    ts.area_plantada_ha as area_ha,
    pi.tipo as tipo_insumo,
    pi.nome as produto,
    SUM(ai.quantidade_total) as quantidade_consumida,
    ai.unidade,
    AVG(ai.dose_por_ha) as dose_media_ha,
    SUM(ai.custo_total) as custo_total,
    CASE
        WHEN ts.area_plantada_ha > 0
        THEN SUM(ai.custo_total) / ts.area_plantada_ha
        ELSE 0
    END as custo_por_ha,
    COUNT(*) as qtd_aplicacoes
FROM aplicacao_insumo ai
JOIN produto_insumo pi ON ai.produto_insumo_id = pi.produto_insumo_id
JOIN talhao_safras ts ON ai.talhao_safra_id = ts.talhao_safra_id
JOIN talhoes t ON ts.talhao_id = t.talhao_id
JOIN fazendas f ON t.fazenda_id = f.fazenda_id
JOIN culturas c ON ts.cultura_id = c.cultura_id
JOIN safras s ON ts.safra_id = s.safra_id
WHERE ai.contexto = 'agricola'
GROUP BY s.ano_agricola, f.nome, t.nome, c.nome, ts.area_plantada_ha,
         pi.tipo, pi.nome, ai.unidade;

COMMENT ON VIEW vw_custo_insumo_talhao_safra IS 'Custo de insumos detalhado por talhao/safra - base para custeio por absorcao';


-- ─── 12.6 View: Extrato de Movimentações ─────────────────────
CREATE OR REPLACE VIEW vw_extrato_movimentacoes AS
SELECT
    mi.data_movimento,
    pi.nome as produto,
    pi.tipo as tipo_produto,
    f.nome as fazenda,
    ei.local_armazenamento,
    mi.tipo as tipo_movimento,
    CASE
        WHEN mi.tipo::text LIKE 'entrada_%' THEN '+' || mi.quantidade::text
        ELSE '-' || mi.quantidade::text
    END as movimento,
    mi.custo_unitario,
    mi.valor_total,
    mi.saldo_anterior,
    mi.saldo_posterior,
    mi.custo_medio_anterior,
    mi.custo_medio_posterior,
    u.nome as responsavel,
    mi.documento_referencia,
    mi.observacoes
FROM movimentacao_insumo mi
JOIN estoque_insumo ei ON mi.estoque_insumo_id = ei.estoque_insumo_id
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.produto_insumo_id
JOIN fazendas f ON ei.fazenda_id = f.fazenda_id
LEFT JOIN users u ON mi.responsavel_id = u.user_id
ORDER BY mi.data_movimento DESC;

COMMENT ON VIEW vw_extrato_movimentacoes IS 'Extrato bancario do estoque - todas as movimentacoes com contexto';


-- ═══════════════════════════════════════════════════════════════════════════════
-- FIM DO DDL COMPLETO V0
-- ═══════════════════════════════════════════════════════════════════════════════
-- Resumo:
--   42 ENUMs
--   56 tabelas (9 sistema + 10 territorial + 8 operacional + 6 insumos +
--               6 operacoes campo + 7 UBG + 7 financeiro + 2 frete/vendas +
--               1 historico + 2 auxiliares = 58 objetos, incluindo 3 views)
--   ~120 indices
--   ~50 triggers
--   3 funcoes de negocio
--   3 views
--
-- Gerado: 2026-03-04 — DeepWork AI Flows
-- PostgreSQL 15+ | Projeto SOAL — Serra da Onça Agropecuária
-- ═══════════════════════════════════════════════════════════════════════════════
