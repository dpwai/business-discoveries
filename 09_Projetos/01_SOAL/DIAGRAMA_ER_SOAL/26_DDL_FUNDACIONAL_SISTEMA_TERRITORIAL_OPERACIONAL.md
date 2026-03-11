# DDL COMPLETO - CAMADAS FUNDACIONAIS: SISTEMA + TERRITORIAL + OPERACIONAL

**Data:** 28/02/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 08 - Estrutura ER Completa SOAL | CLAUDE.md - Convenções

> Este DDL cobre as 3 camadas fundacionais que são **pré-requisito** de todos os outros módulos
> (Doc 16 - Insumos, Doc 25 - Operações Campo, futuro DDL Financeiro/UBG).
> Deve ser executado ANTES de qualquer outro DDL.

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES — Camadas Sistema + Territorial + Operacional
-- Executar ANTES de qualquer CREATE TABLE
-- =============================================

-- Territorial
CREATE TYPE tipo_fazenda AS ENUM ('propria', 'arrendada', 'parceria', 'comodato');
CREATE TYPE tipo_solo AS ENUM ('latossolo_vermelho', 'argissolo', 'cambissolo', 'neossolo', 'nitossolo', 'outros');
CREATE TYPE tipo_silo AS ENUM ('metalico', 'bolsa', 'armazem', 'tulha');
CREATE TYPE status_safra AS ENUM ('planejamento', 'em_andamento', 'encerrada');
CREATE TYPE epoca_safra AS ENUM ('safra', 'safrinha', 'terceira_safra');
CREATE TYPE grupo_cultura AS ENUM ('graos', 'oleaginosa', 'cobertura', 'forrageira', 'pastagem', 'fibra', 'florestal', 'outros');
CREATE TYPE tipo_parceiro AS ENUM ('fornecedor', 'cliente', 'arrendador', 'transportador', 'cooperativa', 'orgao_publico');

-- Operacional
CREATE TYPE categoria_maquina AS ENUM ('maquina', 'implemento');
CREATE TYPE tipo_maquina AS ENUM ('trator', 'colheitadeira', 'pulverizador', 'plantadeira', 'caminhao', 'utilitario', 'drone', 'outros');
CREATE TYPE status_maquina AS ENUM ('ativo', 'inativo', 'manutencao', 'vendido', 'sucateado');
CREATE TYPE tipo_combustivel AS ENUM ('diesel_s10', 'diesel_s500', 'gasolina', 'etanol', 'arla32');
CREATE TYPE tipo_manutencao AS ENUM ('preventiva', 'corretiva', 'preditiva');
CREATE TYPE status_manutencao AS ENUM ('aberta', 'em_andamento', 'concluida', 'cancelada');
CREATE TYPE tipo_cnh AS ENUM ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE');
CREATE TYPE tipo_contrato_trabalho AS ENUM ('clt', 'diarista', 'safrista', 'terceirizado');
```

---

## 2. Funcao Auxiliar — updated_at Trigger

```sql
-- =============================================
-- TRIGGER FUNCTION — Reutilizada por TODAS as tabelas
-- =============================================

CREATE OR REPLACE FUNCTION fn_atualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_atualizar_updated_at() IS
    'Atualiza updated_at automaticamente em qualquer UPDATE. Reutilizada por todas as tabelas.';
```

---

## 3. Camada Sistema

### 3.1 ADMINS (Super-administradores da plataforma)

```sql
-- =============================================
-- ADMINS — Super-admin cross-org (DeepWork AI Flows)
-- Unica tabela SEM organization_id
-- =============================================

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
```

### 3.2 OWNERS (Donos de organizacao)

```sql
-- =============================================
-- OWNERS — Proprietario da org (ex: Claudio Kugler)
-- Sem organization_id — owner CRIA a org
-- =============================================

CREATE TABLE owners (
    owner_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id          UUID REFERENCES admins(admin_id),   -- quem criou o owner
    nome              VARCHAR(200) NOT NULL,
    email             VARCHAR(254) NOT NULL,
    cpf               VARCHAR(14),                        -- formato: 000.000.000-00
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
```

### 3.3 ORGANIZATIONS (Organizacoes)

```sql
-- =============================================
-- ORGANIZATIONS — Entidade raiz do multi-tenant
-- SOAL = 1 organizacao. Toda entidade abaixo carrega organization_id.
-- =============================================

CREATE TABLE organizations (
    organization_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id          UUID NOT NULL REFERENCES owners(owner_id),
    nome              VARCHAR(200) NOT NULL,
    nome_fantasia     VARCHAR(200),
    cnpj              VARCHAR(18),                        -- formato: 00.000.000/0000-00
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
```

### 3.4 ORGANIZATION_SETTINGS (Configuracoes flexiveis)

```sql
-- =============================================
-- ORGANIZATION_SETTINGS — Configuracoes chave-valor por org
-- Ex: moeda, timezone, unidade de area padrao
-- =============================================

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
```

### 3.5 USERS (Usuarios do sistema)

```sql
-- =============================================
-- USERS — Josmar, Valentina, Tiago, Alessandro, etc.
-- Cada user pertence a UMA org
-- =============================================

CREATE TABLE users (
    user_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    email             VARCHAR(254) NOT NULL,
    cpf               VARCHAR(14),
    cargo             VARCHAR(100),                       -- ex: Operador UBG, Administrativa
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
```

### 3.6 RBAC — Roles, Permissions e tabelas associativas

```sql
-- =============================================
-- ROLES — Perfis de acesso (admin, gerente, operador)
-- =============================================

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

-- =============================================
-- PERMISSIONS — Acoes possiveis no sistema
-- Formato: recurso:acao (ex: talhao_safra:read)
-- =============================================

CREATE TABLE permissions (
    permission_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recurso           VARCHAR(100) NOT NULL,              -- ex: talhao_safra, maquina, abastecimento
    acao              VARCHAR(50) NOT NULL,                -- ex: read, write, delete, approve

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_permissions_recurso_acao UNIQUE (recurso, acao)
);

COMMENT ON TABLE permissions IS 'Catalogo de permissoes. Sem org_id — permissoes sao globais.';

-- =============================================
-- USER_ROLES — M:N entre users e roles
-- =============================================

CREATE TABLE user_roles (
    user_id           UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id           UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, role_id)
);

CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);

-- =============================================
-- ROLE_PERMISSIONS — M:N entre roles e permissions
-- =============================================

CREATE TABLE role_permissions (
    role_id           UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    permission_id     UUID NOT NULL REFERENCES permissions(permission_id) ON DELETE CASCADE,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (role_id, permission_id)
);

CREATE INDEX idx_role_permissions_perm_id ON role_permissions(permission_id);
```

---

## 4. Camada Territorial

### 4.1 FAZENDAS

```sql
-- =============================================
-- FAZENDAS — Propriedades rurais da org
-- CSV referencia: IMPORTS/fase_2/02_fazendas.csv (9 fazendas, 4.127 ha)
-- =============================================

CREATE TABLE fazendas (
    fazenda_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    tipo              tipo_fazenda NOT NULL DEFAULT 'propria',
    cnpj              VARCHAR(18),                        -- CNPJ da fazenda (pode diferir da org)
    inscricao_estadual VARCHAR(20),
    car               VARCHAR(50),                        -- Cadastro Ambiental Rural
    area_total_ha     NUMERIC(12,2),
    geojson           JSONB,                              -- GeoJSON do perimetro (sem PostGIS V0)
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

COMMENT ON TABLE fazendas IS 'Propriedades rurais. SOAL tem 9 fazendas (4.127 ha). CAR preenchido via PDFs oficiais.';
```

### 4.2 TALHOES

```sql
-- =============================================
-- TALHOES — Subdivisoes das fazendas
-- CSV referencia: IMPORTS/fase_2/03_talhoes.csv (71 talhoes)
-- IMPORTANTE: Naming inconsistente entre modulos AgriWin — normalizar via talhao_mapping (sem dados ainda)
-- =============================================

CREATE TABLE talhoes (
    talhao_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    fazenda_id        UUID NOT NULL REFERENCES fazendas(fazenda_id),
    codigo            VARCHAR(20),                        -- codigo AgriWin legado (ex: 130, 80)
    nome              VARCHAR(200) NOT NULL,              -- nome canonico (ex: FAZENDINHA, URUGUAI)
    area_ha           NUMERIC(10,2) NOT NULL,
    tipo_solo         tipo_solo,
    geojson           JSONB,                              -- GeoJSON do perimetro (sem PostGIS V0)
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
```

### 4.3 SAFRAS

```sql
-- =============================================
-- SAFRAS — Periodos agricolas (ano fiscal jul-jun)
-- CSV referencia: IMPORTS/fase_2/01_safras.csv
-- Regra de negocio: Safra 25/26 = Jul/2025 → Jun/2026
-- =============================================

CREATE TABLE safras (
    safra_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    ano_agricola      VARCHAR(9) NOT NULL,                -- formato: 2024/2025
    descricao         VARCHAR(100),                       -- ex: Safra 24/25
    data_inicio       DATE NOT NULL,                      -- ex: 2024-07-01
    data_fim          DATE NOT NULL,                      -- ex: 2025-06-30
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
```

### 4.4 CULTURAS

```sql
-- =============================================
-- CULTURAS — Tipos de cultura plantada
-- CSV referencia: IMPORTS/fase_0/01_culturas.csv (126 culturas)
-- Semente ≠ Soja: SOAL produz sementes certificadas Castrolanda
-- =============================================

CREATE TABLE culturas (
    cultura_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome              VARCHAR(100) NOT NULL,              -- ex: soja, milho, trigo
    nome_exibicao     VARCHAR(100) NOT NULL,              -- ex: Soja, Milho, Trigo
    grupo             grupo_cultura NOT NULL DEFAULT 'graos',
    ciclo_dias        INTEGER,                            -- dias medio do ciclo
    unidade_colheita  VARCHAR(20) DEFAULT 'sc_60kg',      -- sc_60kg, ton, kg
    observacoes       TEXT,

    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_culturas_nome UNIQUE (nome)
);

CREATE TRIGGER trg_culturas_updated_at
    BEFORE UPDATE ON culturas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE culturas IS 'Catalogo de culturas. Sem org_id — culturas sao universais. 126 culturas V0.';
```

### 4.5 TALHAO_SAFRAS (Entidade central)

```sql
-- =============================================
-- TALHAO_SAFRAS — Entidade CENTRAL do sistema
-- 90% dos relatorios passam por esta tabela
-- CSV referencia: IMPORTS/fase_5/07_talhao_safra_2425.csv, 08_talhao_safra_2526.csv
-- Campo epoca: pendente de criacao (confirmado CLAUDE.md regras de negocio)
-- =============================================

CREATE TABLE talhao_safras (
    talhao_safra_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    talhao_id         UUID NOT NULL REFERENCES talhoes(talhao_id),
    safra_id          UUID NOT NULL REFERENCES safras(safra_id),
    cultura_id        UUID NOT NULL REFERENCES culturas(cultura_id),
    epoca             epoca_safra NOT NULL DEFAULT 'safra',  -- safra/safrinha/terceira_safra
    area_plantada_ha  NUMERIC(10,2) NOT NULL,
    cultivar          VARCHAR(200),                       -- ex: DM 56I59 RSF IPRO
    gleba             VARCHAR(100),                       -- sub-area do talhao (ex: HERMATRIA, BANACK dentro de CAPINZAL)
    origem_semente    VARCHAR(100),                       -- fonte: castrolanda, fazenda, fsi, agromusa, etc.
    data_plantio_prevista DATE,                           -- estimativa de plantio (ancora para calendario SAFRA_ACAO)
    data_plantio      DATE,
    data_colheita     DATE,
    produtividade_sc_ha NUMERIC(10,2),                    -- sacas/ha (calculado pos-colheita)
    observacoes       TEXT,

    -- Planejamento de safra (Mai-Jun)
    status_planejamento status_talhao_safra NOT NULL DEFAULT 'rascunho',
    meta_produtividade_sc_ha NUMERIC(10,2),
    atribuido_por     VARCHAR(200),                       -- quem definiu esta cultura
    aprovado_por      VARCHAR(200),                       -- quem aprovou
    data_aprovacao    DATE,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- PostgreSQL: NULL != NULL em UNIQUE, entao rows com gleba=NULL nao conflitam entre si
    CONSTRAINT uq_talhao_safra UNIQUE (talhao_id, safra_id, cultura_id, epoca, gleba)
);

CREATE INDEX idx_talhao_safras_org_id ON talhao_safras(organization_id);
CREATE INDEX idx_talhao_safras_talhao_id ON talhao_safras(talhao_id);
CREATE INDEX idx_talhao_safras_safra_id ON talhao_safras(safra_id);
CREATE INDEX idx_talhao_safras_cultura_id ON talhao_safras(cultura_id);

CREATE TRIGGER trg_talhao_safras_updated_at
    BEFORE UPDATE ON talhao_safras
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE talhao_safras IS 'Entidade CENTRAL. Vincula talhao+safra+cultura+epoca. 90% dos relatorios passam por aqui.';
```

### 4.6 SILOS

```sql
-- =============================================
-- SILOS — Estruturas de armazenamento
-- 8 silos: 6 conv metalicos + 2 pulmao, 10.760t total
-- =============================================

CREATE TABLE silos (
    silo_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    fazenda_id        UUID NOT NULL REFERENCES fazendas(fazenda_id),
    codigo            VARCHAR(20),
    nome              VARCHAR(200) NOT NULL,
    tipo              tipo_silo NOT NULL,
    capacidade_ton    NUMERIC(12,2),
    formato_fundo     VARCHAR(20),                        -- plano, conico
    elevado           BOOLEAN DEFAULT FALSE,
    localizacao       TEXT,                               -- descricao textual V0
    geojson           JSONB,                              -- coordenada pontual

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

COMMENT ON TABLE silos IS 'Estruturas de armazenamento. 8 silos (6 conv + 2 pulmao), 10.760t capacidade total.';
```

### 4.7 PARCEIROS_COMERCIAIS

```sql
-- =============================================
-- PARCEIROS_COMERCIAIS — Fornecedores, clientes, cooperativas, etc.
-- CSV referencia: IMPORTS/fase_2/06_parceiros_agriwin.csv (2.201 registros)
-- tipo e ARRAY: um parceiro pode ser fornecedor E cliente (ex: Castrolanda)
-- =============================================

CREATE TABLE parceiros_comerciais (
    parceiro_comercial_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    razao_social      VARCHAR(300) NOT NULL,
    nome_fantasia     VARCHAR(300),
    cpf_cnpj          VARCHAR(18),                        -- CPF (14 chars) ou CNPJ (18 chars)
    tipo_documento    VARCHAR(4),                          -- CPF ou CNPJ
    tipo              tipo_parceiro[] NOT NULL DEFAULT '{}', -- ARRAY: fornecedor + cliente ao mesmo tempo
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
```

---

## 5. Camada Operacional

### 5.1 MAQUINAS

```sql
-- =============================================
-- MAQUINAS — Maquinario e implementos da org
-- CSV referencia: IMPORTS/fase_3/04_maquinas.csv (57 maquinas: 52 ativo + 5 vendido) + fase_3/04_implementos.csv (126 implementos: 103 ativo + 23 vendido)
-- Regra: maquinas pertencem a ORG, nao a fazenda. Custo alocado via OPERACAO_CAMPO.
-- =============================================

CREATE TABLE maquinas (
    maquina_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    codigo_interno    VARCHAR(20) NOT NULL,                -- ex: C-01, T-09, MB-03
    nome              VARCHAR(200) NOT NULL,               -- ex: Colh. JD S660 /16
    categoria         categoria_maquina NOT NULL,          -- maquina ou implemento
    tipo              tipo_maquina,                        -- trator, colheitadeira, etc.
    marca             VARCHAR(100),
    modelo            VARCHAR(100),
    ano_fabricacao     INTEGER,
    chassi            VARCHAR(50),
    numero_serie      VARCHAR(50),
    placa             VARCHAR(10),
    horimetro_atual   NUMERIC(10,1) DEFAULT 0,
    hodometro_atual   NUMERIC(12,1) DEFAULT 0,
    trator_vinculado_id UUID REFERENCES maquinas(maquina_id), -- self-ref para implementos
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

COMMENT ON TABLE maquinas IS '57 maquinas (52 ativo + 5 vendido) + 126 implementos (103 ativo + 23 vendido). Pertencem a ORG, nao a fazenda. Self-ref para implemento→trator.';
```

### 5.2 OPERADORES

```sql
-- =============================================
-- OPERADORES — Operadores de maquinas
-- CSV referencia: IMPORTS/fase_3/04_operadores_vestro.csv (30 operadores)
-- =============================================

CREATE TABLE operadores (
    operador_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    cpf               VARCHAR(14),
    cnh_numero        VARCHAR(20),
    cnh_categoria     tipo_cnh,
    cnh_validade      DATE,
    telefone          VARCHAR(20),
    matricula_vestro  VARCHAR(20),                        -- matricula no sistema Vestro

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
```

### 5.3 ABASTECIMENTOS

```sql
-- =============================================
-- ABASTECIMENTOS — Registros de abastecimento de combustivel
-- CSV referencia: IMPORTS/fase_6/10_fuel_supplies.csv (Vestro)
-- Fonte primaria: API/crawler Vestro (Joao auditar)
-- =============================================

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
    tanque_nome       VARCHAR(100),                       -- nome do tanque de origem
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
```

### 5.4 MANUTENCOES

```sql
-- =============================================
-- MANUTENCOES — Ordens de manutencao de maquinas
-- Dados pendentes coleta
-- =============================================

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
    prestador_servico VARCHAR(200),                       -- oficina/mecanico externo
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
```

### 5.5 TRABALHADORES_RURAIS

```sql
-- =============================================
-- TRABALHADORES_RURAIS — Funcionarios rurais da org
-- Dados pendentes: Valentina
-- =============================================

CREATE TABLE trabalhadores_rurais (
    trabalhador_rural_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    cpf               VARCHAR(14),
    cargo             VARCHAR(100),                       -- ex: Tratorista, Peao, Tecnico
    setor             VARCHAR(100),                       -- ex: Agricultura, UBG, Manutencao
    tipo_contrato     tipo_contrato_trabalho NOT NULL DEFAULT 'clt',
    salario_base      NUMERIC(10,2),
    data_admissao     DATE,
    data_demissao     DATE,
    telefone          VARCHAR(20),
    observacoes       TEXT,

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_trabalhadores_cpf UNIQUE (organization_id, cpf)
);

CREATE INDEX idx_trabalhadores_org_id ON trabalhadores_rurais(organization_id);
CREATE INDEX idx_trabalhadores_status ON trabalhadores_rurais(status)
    WHERE status = 'active';

CREATE TRIGGER trg_trabalhadores_updated_at
    BEFORE UPDATE ON trabalhadores_rurais
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE trabalhadores_rurais IS 'Funcionarios rurais. Dados pendentes Valentina. Tipo contrato: CLT/diarista/safrista/terceirizado.';
```

---

## 6. Notas de Implementacao

### 6.1 Validacao Dijkstra — FKs removidas

| FK proposta | Caminho existente | Hops | Decisao |
|------------|-------------------|------|---------|
| `talhao_safras.fazenda_id` | talhao_safras → talhoes → fazendas | 2 | REDUNDANTE — nao desenhar |
| `abastecimentos.fazenda_id` | nao se aplica (maquina pertence a ORG, nao fazenda) | — | NAO EXISTE — maquina e org-level |
| `manutencoes.operador_id` | manutencao e sobre maquina, nao sobre quem operava | — | NAO SE APLICA — fora do modelo |
| `silos.safra_id` | silo e estrutura fisica permanente, safra e temporal | — | NAO SE APLICA — conceitos ortogonais |

### 6.2 Decisoes de Design

| # | Decisao | Justificativa |
|---|---------|---------------|
| 1 | `organization_id` em todas as tabelas (exceto admins, culturas, permissions) | Multi-tenant. Nunca aparece no diagrama ER (regra CLAUDE.md) |
| 2 | `PARCEIRO_COMERCIAL.tipo` como `tipo_parceiro[]` (ARRAY) | Castrolanda e fornecedor E cooperativa. Evita tabela M:N |
| 3 | `MAQUINAS.trator_vinculado_id` self-referencing FK | Implementos vinculados a tratores. NULL para maquinas autonomas |
| 4 | GEOJSON como `JSONB`, sem PostGIS | V0 simplificado. PostGIS na Silver layer futura |
| 5 | `CULTURAS` sem organization_id | Catalogo universal — soja e soja em qualquer org |
| 6 | `PERMISSIONS` sem organization_id | Catalogo global de acoes — roles da org combinam |
| 7 | `tipo_documento` em parceiros_comerciais | Diferencia CPF de CNPJ para validacoes futuras |
| 8 | `epoca_safra` ENUM em `talhao_safras` | Campo confirmado — mesmo talhao com safra+safrinha |
| 9 | `data_plantio_prevista` em `talhao_safras` | Ancora para gerar calendario SAFRA_ACAO. Defaults regionais em CALENDARIO_AGRICOLA_CAMPOS_GERAIS.md |
| 10 | `gleba` em `talhao_safras` + UNIQUE constraint | Sub-area do talhao (ex: HERMATRIA dentro de CAPINZAL). NULL != NULL em UNIQUE |
| 11 | Campos planejamento safra em `talhao_safras` | status_planejamento, meta_produtividade, atribuido_por, aprovado_por, data_aprovacao |
| 9 | RBAC simplificado V0 | Sem INVITE_TOKENS, sem USER_PERMISSIONS diretas |
| 10 | `status VARCHAR(20) DEFAULT 'active'` para soft-delete | Padrao CLAUDE.md secao 4.3 |

### 6.3 Fora deste DDL

| Entidade | DDL existente | Motivo |
|----------|--------------|--------|
| OPERACAO_CAMPO + detalhes | Doc 25 | Ja documentado |
| PRODUTO_INSUMO, COMPRA_INSUMO, ESTOQUE_INSUMO, etc. | Doc 16 | Ja documentado |
| NOTA_FISCAL, CONTA_PAGAR/RECEBER, CENTRO_CUSTO | Proximo DDL | Camada Financeira |
| TICKET_BALANCA, RECEBIMENTO_GRAO, SECAGEM, etc. | Proximo DDL | Camada UBG |
| CONTRATO_ARRENDAMENTO | Proximo DDL | Camada Financeira |
| Pecuaria (22+ entidades) | — | Fora do V0 |

---

## 7. Ordem de Execucao

```
-- EXECUTAR NA ORDEM EXATA:

-- Passo 1: ENUMs (secao 1)
-- Passo 2: Funcao trigger (secao 2)

-- Passo 3: Camada Sistema
--   3a. admins
--   3b. owners (depende de admins)
--   3c. organizations (depende de owners)
--   3d. organization_settings (depende de organizations)
--   3e. users (depende de organizations)
--   3f. roles (depende de organizations)
--   3g. permissions (sem dependencia)
--   3h. user_roles (depende de users + roles)
--   3i. role_permissions (depende de roles + permissions)

-- Passo 4: Camada Territorial
--   4a. fazendas (depende de organizations)
--   4b. talhoes (depende de fazendas)
--   4c. safras (depende de organizations)
--   4d. culturas (sem dependencia)
--   4e. talhao_safras (depende de talhoes + safras + culturas)
--   4f. silos (depende de fazendas)
--   4g. parceiros_comerciais (depende de organizations)

-- Passo 5: Camada Operacional
--   5a. maquinas (depende de organizations, self-ref)
--   5b. operadores (depende de organizations)
--   5c. abastecimentos (depende de maquinas + operadores)
--   5d. manutencoes (depende de maquinas)
--   5e. trabalhadores_rurais (depende de organizations)
```

---

## 8. Resumo

| Camada | Tabelas | ENUMs | Indexes | Triggers |
|--------|---------|-------|---------|----------|
| Sistema | 9 (admins, owners, organizations, org_settings, users, roles, permissions, user_roles, role_permissions) | 0 | 6 | 6 |
| Territorial | 7 (fazendas, talhoes, safras, culturas, talhao_safras, silos, parceiros_comerciais) | 7 | 12 | 7 |
| Operacional | 5 (maquinas, operadores, abastecimentos, manutencoes, trabalhadores_rurais) | 7 | 11 | 5 |
| **Total** | **21 tabelas** | **14 ENUMs** | **29 indexes** | **18 triggers** |

---

## 9. Compatibilidade com DDLs Existentes

Este DDL fornece as tabelas referenciadas por:

| DDL | FK que resolve | Tabela deste DDL |
|-----|---------------|-------------------|
| Doc 16 — Insumos | `organization_id` em todas | `organizations` |
| Doc 16 — APLICACAO_INSUMO | `talhao_safra_id` | `talhao_safras` |
| Doc 25 — OPERACAO_CAMPO | `talhao_safra_id`, `maquina_id`, `operador_id` | `talhao_safras`, `maquinas`, `operadores` |
| Doc 25 — OPERACAO_CAMPO | `fazenda_id` (DENORM) | `fazendas` |
| Futuro — NFs/Contratos | `parceiro_comercial_id` | `parceiros_comerciais` |
| Futuro — Centro Custo | `safra_id`, `cultura_id`, `fazenda_id` | `safras`, `culturas`, `fazendas` |

---

*DDL gerado em 28/02/2026 — DeepWork AI Flows*
*PostgreSQL 15+ | Referencia: Doc 08 - Estrutura ER Completa + CLAUDE.md Convencoes*
*Baseado em Doc 08 + Doc 16 + Doc 25 + CSVs IMPORTS/*
