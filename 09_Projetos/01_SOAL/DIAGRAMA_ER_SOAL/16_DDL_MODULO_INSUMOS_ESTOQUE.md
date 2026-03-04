# DDL COMPLETO - MODULO INSUMOS E ESTOQUE

**Data:** 09/02/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** doc 15 - MODULO INSUMOS E ESTOQUE SOAL

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES - Modulo Insumos e Estoque
-- =============================================

-- Tipos de produto insumo (21 tipos)
CREATE TYPE tipo_insumo AS ENUM (
    'semente',
    'fertilizante',
    'herbicida',
    'inseticida',
    'fungicida',
    'adjuvante',
    'corretivo',
    'inoculante',
    'tratamento_semente',
    'adubo_foliar',
    'medicamento_vet',
    'suplemento_mineral',
    'racao',
    'combustivel',
    'lubrificante',
    'peca_reposicao',
    'material_manutencao',
    'lenha',
    'embalagem',
    'epi',
    'outros'
);

-- Grupo do insumo
CREATE TYPE grupo_insumo AS ENUM (
    'agricola',
    'pecuario',
    'geral'
);

-- Classe toxicologica (ANVISA)
CREATE TYPE classe_toxicologica AS ENUM (
    'I',
    'II',
    'III',
    'IV',
    'nao_classificado'
);

-- Classe ambiental (IBAMA)
CREATE TYPE classe_ambiental AS ENUM (
    'I',
    'II',
    'III',
    'IV'
);

-- Fonte da compra
CREATE TYPE fonte_compra AS ENUM (
    'castrolanda',
    'revenda',
    'direto_fabrica',
    'barter',
    'producao_propria',
    'outros'
);

-- Status da compra
CREATE TYPE status_compra AS ENUM (
    'recebido',
    'parcial',
    'pendente',
    'cancelado'
);

-- Status do estoque
CREATE TYPE status_estoque AS ENUM (
    'ativo',
    'zerado',
    'bloqueado'
);

-- Tipos de movimentacao (12 tipos)
CREATE TYPE tipo_movimentacao_insumo AS ENUM (
    'entrada_compra',
    'entrada_barter',
    'entrada_producao',
    'entrada_devolucao',
    'entrada_ajuste',
    'saida_aplicacao',
    'saida_pecuaria',
    'saida_manutencao',
    'saida_ubg',
    'saida_transferencia',
    'saida_perda',
    'saida_ajuste'
);

-- Metodo de aplicacao
CREATE TYPE metodo_aplicacao AS ENUM (
    'plantadeira',
    'pulverizador',
    'distribuidor',
    'drone',
    'manual',
    'cocho',
    'seringa'
);

-- Contexto da aplicacao
CREATE TYPE contexto_aplicacao AS ENUM (
    'agricola',
    'pecuario',
    'manutencao',
    'ubg'
);
```

---

## 2. Tabelas Novas

### 2.1 PRODUTO_INSUMO (Catalogo)

```sql
-- =============================================
-- PRODUTO_INSUMO - Catalogo de produtos
-- Substitui: INSUMO (doc 08 original)
-- =============================================

CREATE TABLE produto_insumo (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    codigo                VARCHAR(50) NOT NULL,
    nome                  VARCHAR(200) NOT NULL,
    principio_ativo       VARCHAR(200),
    tipo                  tipo_insumo NOT NULL,
    grupo                 grupo_insumo NOT NULL,
    unidade_medida        VARCHAR(20) NOT NULL,
    unidade_embalagem     VARCHAR(50),
    fabricante            VARCHAR(200),
    registro_mapa         VARCHAR(50),
    classe_toxicologica   classe_toxicologica,
    classe_ambiental      classe_ambiental,
    carencia_dias         INTEGER,
    dose_recomendada_min  DECIMAL(10,4),
    dose_recomendada_max  DECIMAL(10,4),
    ativo                 BOOLEAN NOT NULL DEFAULT true,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT uq_produto_insumo_org_codigo UNIQUE (organization_id, codigo),
    CONSTRAINT chk_carencia_positiva CHECK (carencia_dias IS NULL OR carencia_dias >= 0),
    CONSTRAINT chk_dose_range CHECK (
        dose_recomendada_min IS NULL
        OR dose_recomendada_max IS NULL
        OR dose_recomendada_min <= dose_recomendada_max
    )
);

-- Indexes
CREATE INDEX idx_produto_insumo_org ON produto_insumo(organization_id);
CREATE INDEX idx_produto_insumo_tipo ON produto_insumo(tipo);
CREATE INDEX idx_produto_insumo_grupo ON produto_insumo(grupo);
CREATE INDEX idx_produto_insumo_nome ON produto_insumo(nome);
CREATE INDEX idx_produto_insumo_ativo ON produto_insumo(organization_id, ativo) WHERE ativo = true;

COMMENT ON TABLE produto_insumo IS 'Catalogo de produtos insumos - dicionario sem preco ou saldo';
COMMENT ON COLUMN produto_insumo.tipo IS '21 tipos: semente, fertilizante, herbicida, inseticida, fungicida, adjuvante, corretivo, inoculante, tratamento_semente, adubo_foliar, medicamento_vet, suplemento_mineral, racao, combustivel, lubrificante, peca_reposicao, material_manutencao, lenha, embalagem, epi, outros';
COMMENT ON COLUMN produto_insumo.registro_mapa IS 'Numero de registro no MAPA - obrigatorio para defensivos';
```

### 2.2 COMPRA_INSUMO (Registro de Compra)

```sql
-- =============================================
-- COMPRA_INSUMO - Registro de compras
-- Substitui: INSUMOS_CASTROLANDA (doc 05)
-- =============================================

CREATE TABLE compra_insumo (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    produto_insumo_id     UUID NOT NULL REFERENCES produto_insumo(id),
    nota_fiscal_item_id   UUID REFERENCES nota_fiscal_item(id),
    parceiro_id           UUID NOT NULL REFERENCES parceiro_comercial(id),
    safra_id              UUID REFERENCES safras(id),
    fonte                 fonte_compra NOT NULL,
    data_compra           DATE NOT NULL,
    quantidade            DECIMAL(12,4) NOT NULL,
    unidade               VARCHAR(20) NOT NULL,
    valor_unitario        DECIMAL(12,4) NOT NULL,
    valor_total           DECIMAL(14,2) NOT NULL,
    lote_fabricante       VARCHAR(50),
    data_fabricacao        DATE,
    data_validade          DATE,
    cultura_destino_id    UUID REFERENCES culturas(id),
    numero_pedido         VARCHAR(50),
    castrolanda_sync_id   VARCHAR(50),
    contrato_barter_id    UUID REFERENCES contrato_comercial(id),
    status                status_compra NOT NULL DEFAULT 'pendente',
    observacoes           TEXT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT chk_compra_quantidade_positiva CHECK (quantidade > 0),
    CONSTRAINT chk_compra_valor_positivo CHECK (valor_unitario >= 0 AND valor_total >= 0),
    CONSTRAINT chk_compra_validade CHECK (
        data_fabricacao IS NULL
        OR data_validade IS NULL
        OR data_fabricacao <= data_validade
    )
);

-- Indexes
CREATE INDEX idx_compra_insumo_org ON compra_insumo(organization_id);
CREATE INDEX idx_compra_insumo_produto ON compra_insumo(produto_insumo_id);
CREATE INDEX idx_compra_insumo_parceiro ON compra_insumo(parceiro_id);
CREATE INDEX idx_compra_insumo_safra ON compra_insumo(safra_id);
CREATE INDEX idx_compra_insumo_data ON compra_insumo(data_compra);
CREATE INDEX idx_compra_insumo_fonte ON compra_insumo(fonte);
CREATE INDEX idx_compra_insumo_status ON compra_insumo(status);
CREATE INDEX idx_compra_insumo_castrolanda ON compra_insumo(castrolanda_sync_id) WHERE castrolanda_sync_id IS NOT NULL;

COMMENT ON TABLE compra_insumo IS 'Registro de compras de insumos - multi-fornecedor (Castrolanda, revenda, barter, etc.)';
COMMENT ON COLUMN compra_insumo.castrolanda_sync_id IS 'ID da integracao Castrolanda - 90% das NFs passam pela cooperativa';
```

### 2.3 ESTOQUE_INSUMO (Posicao Atual)

```sql
-- =============================================
-- ESTOQUE_INSUMO - Saldo atual por produto+local
-- Entidade nova
-- =============================================

CREATE TABLE estoque_insumo (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id         UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    produto_insumo_id       UUID NOT NULL REFERENCES produto_insumo(id),
    fazenda_id              UUID NOT NULL REFERENCES fazendas(id),
    local_armazenamento     VARCHAR(100) NOT NULL,
    quantidade_atual        DECIMAL(12,4) NOT NULL DEFAULT 0,
    unidade                 VARCHAR(20) NOT NULL,
    custo_medio_unitario    DECIMAL(12,4) NOT NULL DEFAULT 0,
    valor_total_estoque     DECIMAL(14,2) NOT NULL DEFAULT 0,
    quantidade_minima       DECIMAL(12,4),
    quantidade_maxima       DECIMAL(12,4),
    lote_mais_antigo        VARCHAR(50),
    validade_mais_proxima   DATE,
    data_ultimo_inventario  DATE,
    status                  status_estoque NOT NULL DEFAULT 'ativo',
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT uq_estoque_produto_local UNIQUE (organization_id, produto_insumo_id, fazenda_id, local_armazenamento),
    CONSTRAINT chk_estoque_quantidade_nao_negativa CHECK (quantidade_atual >= 0),
    CONSTRAINT chk_estoque_custo_nao_negativo CHECK (custo_medio_unitario >= 0),
    CONSTRAINT chk_estoque_min_max CHECK (
        quantidade_minima IS NULL
        OR quantidade_maxima IS NULL
        OR quantidade_minima <= quantidade_maxima
    )
);

-- Indexes
CREATE INDEX idx_estoque_insumo_org ON estoque_insumo(organization_id);
CREATE INDEX idx_estoque_insumo_produto ON estoque_insumo(produto_insumo_id);
CREATE INDEX idx_estoque_insumo_fazenda ON estoque_insumo(fazenda_id);
CREATE INDEX idx_estoque_insumo_status ON estoque_insumo(status);
CREATE INDEX idx_estoque_insumo_reposicao ON estoque_insumo(organization_id)
    WHERE status = 'ativo' AND quantidade_atual <= quantidade_minima;
CREATE INDEX idx_estoque_insumo_validade ON estoque_insumo(validade_mais_proxima)
    WHERE validade_mais_proxima IS NOT NULL AND quantidade_atual > 0;

COMMENT ON TABLE estoque_insumo IS 'Posicao atual de estoque - uma linha por combinacao produto+fazenda+local';
COMMENT ON COLUMN estoque_insumo.custo_medio_unitario IS 'Custo medio ponderado - atualizado automaticamente nas entradas, mantido nas saidas';
COMMENT ON COLUMN estoque_insumo.valor_total_estoque IS 'Calculado: quantidade_atual x custo_medio_unitario';
```

### 2.4 MOVIMENTACAO_INSUMO (Historico)

```sql
-- =============================================
-- MOVIMENTACAO_INSUMO - Historico completo
-- Entidade nova - imutavel (append-only)
-- =============================================

CREATE TABLE movimentacao_insumo (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    estoque_insumo_id       UUID NOT NULL REFERENCES estoque_insumo(id),
    tipo                    tipo_movimentacao_insumo NOT NULL,
    data_movimento          TIMESTAMPTZ NOT NULL DEFAULT now(),
    quantidade              DECIMAL(12,4) NOT NULL,
    custo_unitario          DECIMAL(12,4) NOT NULL,
    valor_total             DECIMAL(14,2) NOT NULL,
    saldo_anterior          DECIMAL(12,4) NOT NULL,
    saldo_posterior         DECIMAL(12,4) NOT NULL,
    custo_medio_anterior    DECIMAL(12,4) NOT NULL,
    custo_medio_posterior   DECIMAL(12,4) NOT NULL,
    compra_insumo_id        UUID REFERENCES compra_insumo(id),
    aplicacao_insumo_id     UUID REFERENCES aplicacao_insumo(id),
    transferencia_destino_id UUID REFERENCES estoque_insumo(id),
    responsavel_id          UUID REFERENCES users(id),
    documento_referencia    VARCHAR(50),
    observacoes             TEXT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT chk_movimentacao_quantidade_positiva CHECK (quantidade > 0),
    CONSTRAINT chk_movimentacao_saldo_coerente CHECK (
        -- Entradas: saldo_posterior > saldo_anterior
        -- Saidas: saldo_posterior < saldo_anterior
        (tipo IN ('entrada_compra','entrada_barter','entrada_producao','entrada_devolucao','entrada_ajuste')
         AND saldo_posterior >= saldo_anterior)
        OR
        (tipo IN ('saida_aplicacao','saida_pecuaria','saida_manutencao','saida_ubg','saida_transferencia','saida_perda','saida_ajuste')
         AND saldo_posterior <= saldo_anterior)
    ),
    CONSTRAINT chk_movimentacao_compra_ref CHECK (
        (tipo = 'entrada_compra' AND compra_insumo_id IS NOT NULL)
        OR tipo != 'entrada_compra'
    ),
    CONSTRAINT chk_movimentacao_aplicacao_ref CHECK (
        (tipo = 'saida_aplicacao' AND aplicacao_insumo_id IS NOT NULL)
        OR tipo != 'saida_aplicacao'
    ),
    CONSTRAINT chk_movimentacao_transferencia_ref CHECK (
        (tipo = 'saida_transferencia' AND transferencia_destino_id IS NOT NULL)
        OR tipo != 'saida_transferencia'
    )
);

-- Indexes
CREATE INDEX idx_movimentacao_estoque ON movimentacao_insumo(estoque_insumo_id);
CREATE INDEX idx_movimentacao_tipo ON movimentacao_insumo(tipo);
CREATE INDEX idx_movimentacao_data ON movimentacao_insumo(data_movimento);
CREATE INDEX idx_movimentacao_compra ON movimentacao_insumo(compra_insumo_id) WHERE compra_insumo_id IS NOT NULL;
CREATE INDEX idx_movimentacao_aplicacao ON movimentacao_insumo(aplicacao_insumo_id) WHERE aplicacao_insumo_id IS NOT NULL;
CREATE INDEX idx_movimentacao_responsavel ON movimentacao_insumo(responsavel_id);

COMMENT ON TABLE movimentacao_insumo IS 'Historico imutavel (append-only) de todas as movimentacoes de estoque';
COMMENT ON COLUMN movimentacao_insumo.quantidade IS 'Sempre positivo - direcao definida pelo tipo';
```

### 2.5 APLICACAO_INSUMO (Refatorada)

```sql
-- =============================================
-- APLICACAO_INSUMO - Uso de insumo (refatorada)
-- Antes: apenas insumo_id, talhao_id, data, dose, area
-- Agora: multi-contexto (agricola, pecuario, manutencao, ubg)
-- =============================================

-- Se a tabela ja existe, usar ALTER TABLE (ver secao 4 - Migracao)
-- Se criando do zero:

CREATE TABLE aplicacao_insumo (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    produto_insumo_id     UUID NOT NULL REFERENCES produto_insumo(id),
    estoque_insumo_id     UUID REFERENCES estoque_insumo(id),
    operacao_campo_id     UUID REFERENCES operacoes_campo(id),
    talhao_safra_id       UUID REFERENCES talhao_safra(id),
    manejo_sanitario_id   UUID REFERENCES manejo_sanitario(id),
    manutencao_id         UUID REFERENCES manutencoes(id),
    receituario_id        UUID REFERENCES receituario_agronomico(id),
    data_aplicacao        DATE NOT NULL,
    dose_por_ha           DECIMAL(10,4),
    area_aplicada_ha      DECIMAL(10,4),
    quantidade_total      DECIMAL(12,4) NOT NULL,
    unidade               VARCHAR(20) NOT NULL,
    custo_unitario        DECIMAL(12,4) NOT NULL,
    custo_total           DECIMAL(14,2) NOT NULL,
    metodo_aplicacao      metodo_aplicacao,
    contexto              contexto_aplicacao NOT NULL,
    observacoes           TEXT,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Constraints
    CONSTRAINT chk_aplicacao_quantidade_positiva CHECK (quantidade_total > 0),
    CONSTRAINT chk_aplicacao_custo_positivo CHECK (custo_unitario >= 0 AND custo_total >= 0),
    CONSTRAINT chk_aplicacao_contexto_agricola CHECK (
        contexto != 'agricola' OR (operacao_campo_id IS NOT NULL AND talhao_safra_id IS NOT NULL)
    ),
    CONSTRAINT chk_aplicacao_contexto_pecuario CHECK (
        contexto != 'pecuario' OR manejo_sanitario_id IS NOT NULL
    ),
    CONSTRAINT chk_aplicacao_contexto_manutencao CHECK (
        contexto != 'manutencao' OR manutencao_id IS NOT NULL
    )
);

-- Indexes
CREATE INDEX idx_aplicacao_insumo_org ON aplicacao_insumo(organization_id);
CREATE INDEX idx_aplicacao_insumo_produto ON aplicacao_insumo(produto_insumo_id);
CREATE INDEX idx_aplicacao_insumo_operacao ON aplicacao_insumo(operacao_campo_id) WHERE operacao_campo_id IS NOT NULL;
CREATE INDEX idx_aplicacao_insumo_talhao_safra ON aplicacao_insumo(talhao_safra_id) WHERE talhao_safra_id IS NOT NULL;
CREATE INDEX idx_aplicacao_insumo_data ON aplicacao_insumo(data_aplicacao);
CREATE INDEX idx_aplicacao_insumo_contexto ON aplicacao_insumo(contexto);
CREATE INDEX idx_aplicacao_insumo_manejo ON aplicacao_insumo(manejo_sanitario_id) WHERE manejo_sanitario_id IS NOT NULL;
CREATE INDEX idx_aplicacao_insumo_manutencao ON aplicacao_insumo(manutencao_id) WHERE manutencao_id IS NOT NULL;

COMMENT ON TABLE aplicacao_insumo IS 'Uso de insumo no campo/pecuaria/manutencao/ubg - 1 OPERACAO_CAMPO pode ter N aplicacoes';
COMMENT ON COLUMN aplicacao_insumo.contexto IS 'agricola: requer operacao_campo_id + talhao_safra_id | pecuario: requer manejo_sanitario_id | manutencao: requer manutencao_id | ubg: estoque generico';
```

### 2.6 RECEITUARIO_AGRONOMICO (Ajustada)

```sql
-- =============================================
-- RECEITUARIO_AGRONOMICO - Ajuste de FK
-- Mantida, apenas renomeia insumo_id → produto_insumo_id
-- e adiciona campos novos
-- =============================================

-- Se a tabela ja existe, usar ALTER TABLE (ver secao 4)
-- Se criando do zero:

CREATE TABLE receituario_agronomico (
    id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id             UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    produto_insumo_id           UUID NOT NULL REFERENCES produto_insumo(id),
    numero_receita              VARCHAR(50) NOT NULL,
    numero_art                  VARCHAR(50) NOT NULL,
    responsavel_tecnico         VARCHAR(200) NOT NULL,
    crea                        VARCHAR(20) NOT NULL,
    cultura_id                  UUID REFERENCES culturas(id),
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

    -- Constraints
    CONSTRAINT chk_receituario_validade CHECK (data_emissao <= data_validade),
    CONSTRAINT chk_receituario_dose_positiva CHECK (dose_prescrita > 0),
    CONSTRAINT chk_receituario_carencia_positiva CHECK (intervalo_seguranca_dias >= 0)
);

-- Indexes
CREATE INDEX idx_receituario_org ON receituario_agronomico(organization_id);
CREATE INDEX idx_receituario_produto ON receituario_agronomico(produto_insumo_id);
CREATE INDEX idx_receituario_cultura ON receituario_agronomico(cultura_id) WHERE cultura_id IS NOT NULL;
CREATE INDEX idx_receituario_validade ON receituario_agronomico(data_validade);
CREATE INDEX idx_receituario_numero ON receituario_agronomico(numero_receita);

COMMENT ON TABLE receituario_agronomico IS 'Receituario agronomico - compliance MAPA para defensivos';
COMMENT ON COLUMN receituario_agronomico.numero_art IS 'Anotacao de Responsabilidade Tecnica do agronomo';
```

---

## 3. Funcoes e Triggers

### 3.1 Trigger: Atualizar updated_at

```sql
-- =============================================
-- Trigger generico para updated_at
-- =============================================

CREATE OR REPLACE FUNCTION fn_atualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar em todas as tabelas do modulo
CREATE TRIGGER trg_produto_insumo_updated_at
    BEFORE UPDATE ON produto_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

CREATE TRIGGER trg_compra_insumo_updated_at
    BEFORE UPDATE ON compra_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

CREATE TRIGGER trg_estoque_insumo_updated_at
    BEFORE UPDATE ON estoque_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

CREATE TRIGGER trg_aplicacao_insumo_updated_at
    BEFORE UPDATE ON aplicacao_insumo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

CREATE TRIGGER trg_receituario_updated_at
    BEFORE UPDATE ON receituario_agronomico
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();
```

### 3.2 Funcao: Registrar Entrada por Compra (Custo Medio Ponderado)

```sql
-- =============================================
-- Funcao: Processar entrada de compra no estoque
-- Atualiza custo medio ponderado automaticamente
-- =============================================

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
    -- Buscar dados da compra
    SELECT quantidade, valor_unitario, valor_total
    INTO v_compra
    FROM compra_insumo
    WHERE id = p_compra_insumo_id;

    -- Buscar saldo atual do estoque
    SELECT quantidade_atual, custo_medio_unitario, valor_total_estoque
    INTO v_estoque
    FROM estoque_insumo
    WHERE id = p_estoque_insumo_id
    FOR UPDATE; -- Lock para concorrencia

    -- Calcular novo custo medio ponderado
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

    -- Registrar movimentacao
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
    RETURNING id INTO v_movimentacao_id;

    -- Atualizar estoque
    UPDATE estoque_insumo
    SET quantidade_atual = v_novo_saldo,
        custo_medio_unitario = v_novo_custo_medio,
        valor_total_estoque = v_novo_valor_total,
        status = 'ativo'
    WHERE id = p_estoque_insumo_id;

    -- Atualizar status da compra
    UPDATE compra_insumo
    SET status = 'recebido'
    WHERE id = p_compra_insumo_id;

    RETURN v_movimentacao_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_entrada_compra_estoque IS 'Processa entrada de compra: calcula custo medio ponderado, registra movimentacao, atualiza saldo';
```

### 3.3 Funcao: Registrar Saida por Aplicacao

```sql
-- =============================================
-- Funcao: Processar saida por aplicacao no campo
-- Custo medio NAO muda na saida
-- =============================================

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
    -- Buscar dados da aplicacao
    SELECT quantidade_total, estoque_insumo_id, custo_unitario, custo_total
    INTO v_aplicacao
    FROM aplicacao_insumo
    WHERE id = p_aplicacao_insumo_id;

    -- Buscar saldo atual do estoque
    SELECT quantidade_atual, custo_medio_unitario, valor_total_estoque
    INTO v_estoque
    FROM estoque_insumo
    WHERE id = v_aplicacao.estoque_insumo_id
    FOR UPDATE;

    -- Validar saldo suficiente
    IF v_estoque.quantidade_atual < v_aplicacao.quantidade_total THEN
        RAISE EXCEPTION 'Saldo insuficiente. Disponivel: %, Solicitado: %',
            v_estoque.quantidade_atual, v_aplicacao.quantidade_total;
    END IF;

    v_novo_saldo = v_estoque.quantidade_atual - v_aplicacao.quantidade_total;
    v_novo_valor_total = v_novo_saldo * v_estoque.custo_medio_unitario;

    -- Registrar movimentacao (custo medio NAO muda)
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
    RETURNING id INTO v_movimentacao_id;

    -- Atualizar estoque
    UPDATE estoque_insumo
    SET quantidade_atual = v_novo_saldo,
        valor_total_estoque = v_novo_valor_total,
        status = CASE WHEN v_novo_saldo = 0 THEN 'zerado' ELSE 'ativo' END
    WHERE id = v_aplicacao.estoque_insumo_id;

    RETURN v_movimentacao_id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION fn_saida_aplicacao_estoque IS 'Processa saida por aplicacao: valida saldo, registra movimentacao, custo medio nao muda';
```

### 3.4 Funcao: Atualizar Custo na Aplicacao a partir do Estoque

```sql
-- =============================================
-- Trigger: Ao inserir APLICACAO_INSUMO, preencher
-- custo_unitario com custo_medio do estoque
-- =============================================

CREATE OR REPLACE FUNCTION fn_aplicacao_custo_from_estoque()
RETURNS TRIGGER AS $$
BEGIN
    -- Se custo_unitario nao foi informado, buscar do estoque
    IF NEW.custo_unitario IS NULL OR NEW.custo_unitario = 0 THEN
        SELECT custo_medio_unitario
        INTO NEW.custo_unitario
        FROM estoque_insumo
        WHERE id = NEW.estoque_insumo_id;

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
```

---

## 4. Scripts de Migracao (Entidades Existentes)

### 4.1 Renomear FKs em Entidades Existentes

```sql
-- =============================================
-- MIGRACAO: Renomear FKs de insumo_id para produto_insumo_id
-- Executar APOS criar tabela produto_insumo e migrar dados
-- =============================================

-- 4.1.1 PULVERIZACAO_DETALHE
ALTER TABLE pulverizacao_detalhe
    RENAME COLUMN insumo_id TO produto_insumo_id;

ALTER TABLE pulverizacao_detalhe
    DROP CONSTRAINT IF EXISTS fk_pulverizacao_insumo;

ALTER TABLE pulverizacao_detalhe
    ADD CONSTRAINT fk_pulverizacao_produto_insumo
    FOREIGN KEY (produto_insumo_id) REFERENCES produto_insumo(id);

COMMENT ON COLUMN pulverizacao_detalhe.produto_insumo_id IS 'Produto principal da pulverizacao - para detalhes de consumo ver APLICACAO_INSUMO';

-- 4.1.2 DRONE_DETALHE
ALTER TABLE drone_detalhe
    RENAME COLUMN insumo_id TO produto_insumo_id;

ALTER TABLE drone_detalhe
    DROP CONSTRAINT IF EXISTS fk_drone_insumo;

ALTER TABLE drone_detalhe
    ADD CONSTRAINT fk_drone_produto_insumo
    FOREIGN KEY (produto_insumo_id) REFERENCES produto_insumo(id);

COMMENT ON COLUMN drone_detalhe.produto_insumo_id IS 'Produto principal da aplicacao drone - para detalhes de consumo ver APLICACAO_INSUMO';

-- 4.1.3 DIETA_INGREDIENTE
ALTER TABLE dieta_ingrediente
    RENAME COLUMN insumo_id TO produto_insumo_id;

ALTER TABLE dieta_ingrediente
    DROP CONSTRAINT IF EXISTS fk_dieta_ingrediente_insumo;

ALTER TABLE dieta_ingrediente
    ADD CONSTRAINT fk_dieta_ingrediente_produto_insumo
    FOREIGN KEY (produto_insumo_id) REFERENCES produto_insumo(id);

-- 4.1.4 NOTA_FISCAL_ITEM
ALTER TABLE nota_fiscal_item
    ADD COLUMN IF NOT EXISTS produto_insumo_id UUID REFERENCES produto_insumo(id);

-- Se existia insumo_id:
-- ALTER TABLE nota_fiscal_item RENAME COLUMN insumo_id TO produto_insumo_id;

COMMENT ON COLUMN nota_fiscal_item.produto_insumo_id IS 'Vinculo com produto insumo - se o item da NF e um insumo';

-- 4.1.5 CONTRATO_COMERCIAL (barter)
ALTER TABLE contrato_comercial
    ADD COLUMN IF NOT EXISTS barter_produto_insumo_id UUID REFERENCES produto_insumo(id);

-- Se existia barter_insumo_id:
-- ALTER TABLE contrato_comercial RENAME COLUMN barter_insumo_id TO barter_produto_insumo_id;

COMMENT ON COLUMN contrato_comercial.barter_produto_insumo_id IS 'Insumo recebido em troca (barter) - referencia catalogo PRODUTO_INSUMO';
```

### 4.2 Migrar Dados de INSUMO para PRODUTO_INSUMO

```sql
-- =============================================
-- MIGRACAO: Dados INSUMO → PRODUTO_INSUMO
-- Executar se ja existe tabela insumo com dados
-- =============================================

INSERT INTO produto_insumo (
    id, organization_id, codigo, nome, tipo, grupo,
    unidade_medida, ativo, created_at, updated_at
)
SELECT
    id,
    organization_id,
    COALESCE(codigo, 'MIGRADO-' || LEFT(id::text, 8)),
    nome,
    tipo::tipo_insumo,
    CASE
        WHEN tipo IN ('semente','fertilizante','herbicida','inseticida','fungicida',
                       'adjuvante','corretivo','inoculante','tratamento_semente','adubo_foliar')
            THEN 'agricola'::grupo_insumo
        WHEN tipo IN ('medicamento_vet','suplemento_mineral','racao')
            THEN 'pecuario'::grupo_insumo
        ELSE 'geral'::grupo_insumo
    END,
    COALESCE(unidade, 'un'),
    COALESCE(ativo, true),
    created_at,
    updated_at
FROM insumo
ON CONFLICT (id) DO NOTHING;

-- Nota: Ajustar mapeamento de tipos conforme dados reais da tabela insumo
```

---

## 5. Views Uteis

### 5.1 Visao Geral do Estoque

```sql
-- =============================================
-- VIEW: Visao consolidada do estoque
-- =============================================

CREATE OR REPLACE VIEW vw_estoque_consolidado AS
SELECT
    pi.id as produto_id,
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
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.id
JOIN fazendas f ON ei.fazenda_id = f.id
WHERE pi.ativo = true;

COMMENT ON VIEW vw_estoque_consolidado IS 'Visao consolidada do estoque com alertas de reposicao e validade';
```

### 5.2 Consumo por Talhao na Safra

```sql
-- =============================================
-- VIEW: Custo de insumos por talhao na safra
-- =============================================

CREATE OR REPLACE VIEW vw_custo_insumo_talhao_safra AS
SELECT
    s.ano_agricola as safra,
    f.nome as fazenda,
    t.nome as talhao,
    c.nome as cultura,
    ts.area_plantada as area_ha,
    pi.tipo as tipo_insumo,
    pi.nome as produto,
    SUM(ai.quantidade_total) as quantidade_consumida,
    ai.unidade,
    AVG(ai.dose_por_ha) as dose_media_ha,
    SUM(ai.custo_total) as custo_total,
    CASE
        WHEN ts.area_plantada > 0
        THEN SUM(ai.custo_total) / ts.area_plantada
        ELSE 0
    END as custo_por_ha,
    COUNT(*) as qtd_aplicacoes
FROM aplicacao_insumo ai
JOIN produto_insumo pi ON ai.produto_insumo_id = pi.id
JOIN talhao_safra ts ON ai.talhao_safra_id = ts.id
JOIN talhoes t ON ts.talhao_id = t.id
JOIN fazendas f ON t.fazenda_id = f.id
JOIN culturas c ON ts.cultura_id = c.id
JOIN safras s ON ts.safra_id = s.id
WHERE ai.contexto = 'agricola'
GROUP BY s.ano_agricola, f.nome, t.nome, c.nome, ts.area_plantada,
         pi.tipo, pi.nome, ai.unidade;

COMMENT ON VIEW vw_custo_insumo_talhao_safra IS 'Custo de insumos detalhado por talhao/safra - base para custeio por absorcao';
```

### 5.3 Extrato de Movimentacoes

```sql
-- =============================================
-- VIEW: Extrato de movimentacoes (auditoria)
-- =============================================

CREATE OR REPLACE VIEW vw_extrato_movimentacoes AS
SELECT
    mi.data_movimento,
    pi.nome as produto,
    pi.tipo as tipo_produto,
    f.nome as fazenda,
    ei.local_armazenamento,
    mi.tipo as tipo_movimento,
    CASE
        WHEN mi.tipo LIKE 'entrada_%' THEN '+' || mi.quantidade::text
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
JOIN estoque_insumo ei ON mi.estoque_insumo_id = ei.id
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.id
JOIN fazendas f ON ei.fazenda_id = f.id
LEFT JOIN users u ON mi.responsavel_id = u.id
ORDER BY mi.data_movimento DESC;

COMMENT ON VIEW vw_extrato_movimentacoes IS 'Extrato bancario do estoque - todas as movimentacoes com contexto';
```

---

## 6. Ordem de Execucao

```
PASSO 1: Criar ENUM types (secao 1)
    └── Sem dependencias

PASSO 2: Criar tabela PRODUTO_INSUMO (secao 2.1)
    └── Depende de: organizations

PASSO 3: Migrar dados INSUMO → PRODUTO_INSUMO (secao 4.2)
    └── Depende de: PASSO 2
    └── Executar SOMENTE se tabela insumo ja tem dados

PASSO 4: Criar tabela COMPRA_INSUMO (secao 2.2)
    └── Depende de: PASSO 2, nota_fiscal_item, parceiro_comercial, safras, culturas, contrato_comercial

PASSO 5: Criar tabela ESTOQUE_INSUMO (secao 2.3)
    └── Depende de: PASSO 2, fazendas

PASSO 6: Criar/Refatorar tabela APLICACAO_INSUMO (secao 2.5)
    └── Depende de: PASSO 2, PASSO 5, operacoes_campo, talhao_safra, manejo_sanitario, manutencoes

PASSO 7: Criar tabela MOVIMENTACAO_INSUMO (secao 2.4)
    └── Depende de: PASSO 4, PASSO 5, PASSO 6, users

PASSO 8: Criar/Refatorar tabela RECEITUARIO_AGRONOMICO (secao 2.6)
    └── Depende de: PASSO 2, culturas

PASSO 9: Criar triggers updated_at (secao 3.1)
    └── Depende de: PASSOS 2-8

PASSO 10: Criar funcoes de negocio (secoes 3.2, 3.3, 3.4)
    └── Depende de: PASSOS 2-8

PASSO 11: Renomear FKs em entidades existentes (secao 4.1)
    └── Depende de: PASSO 3 (dados migrados)
    └── CUIDADO: Pode quebrar queries existentes

PASSO 12: Criar views (secao 5)
    └── Depende de: todos os passos anteriores
```

---

## 7. Resumo

| Item | Quantidade |
|------|-----------|
| ENUM types criados | 10 |
| Tabelas novas | 4 (PRODUTO_INSUMO, COMPRA_INSUMO, ESTOQUE_INSUMO, MOVIMENTACAO_INSUMO) |
| Tabelas refatoradas | 2 (APLICACAO_INSUMO, RECEITUARIO_AGRONOMICO) |
| FKs renomeadas | 5 entidades afetadas |
| Funcoes/Triggers | 5 (updated_at x4, custo_medio, saida_estoque, custo_auto) |
| Views | 3 (estoque_consolidado, custo_talhao_safra, extrato_movimentacoes) |
| Constraints | 15+ (checks de negocio) |
| Indexes | 30+ (performance) |

---

*DDL gerado em 09/02/2026 - DeepWork AI Flows*
*PostgreSQL 15+ | Referencia: doc 15 - MODULO INSUMOS E ESTOQUE SOAL*
