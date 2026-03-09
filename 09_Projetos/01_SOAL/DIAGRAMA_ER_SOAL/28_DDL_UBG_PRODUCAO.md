# DDL COMPLETO - MODULO UBG (PRODUCAO + ARMAZENAGEM)

**Data:** 03/03/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 08 - ER Completo, camada UBG (Yellow mix)

---

## Pre-requisitos

Executar **antes** deste DDL:
- Doc 26 — Fundacional (organizations, fazendas, talhoes, safras, culturas, talhao_safras, silos, parceiros_comerciais, maquinas, operadores)
- Doc 25a — Operacoes Campo (operacoes_campo — referenciado por ticket_balanca via transporte)

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES - Modulo UBG
-- =============================================

-- Tipo de ticket de balanca
CREATE TYPE tipo_ticket_balanca AS ENUM (
    'entrada_producao',     -- colheita chegando do campo
    'pesagem_externa',      -- servico de pesagem publica (bovinos, eucalipto, etc.)
    'transferencia_silo',   -- movimento entre silos
    'saida_venda'           -- saida para compradores
);

-- Status do ticket
CREATE TYPE status_ticket AS ENUM (
    'pesado',               -- apenas pesagem feita
    'classificado',         -- qualidade preenchida (Josmar)
    'consolidado',          -- validado na planilha quinzenal (Vanessa)
    'cancelado'
);

-- Tipo de saida de grao
CREATE TYPE tipo_saida_grao AS ENUM (
    'venda_cooperativa',    -- via Castrolanda
    'venda_direta',         -- venda direta a comprador
    'transferencia',        -- entre unidades
    'devolucao',            -- devolucao ao produtor
    'descarte'              -- grao fora de especificacao
);

-- Status do estoque silo
CREATE TYPE status_estoque_silo AS ENUM (
    'ativo',
    'vazio',
    'em_manutencao'
);
```

---

## 2. Tabelas

### 2.1 TICKET_BALANCA

```sql
-- =============================================
-- TICKET_BALANCA - Entidade central da UBG
-- Ponto de transferencia agricultura → UBG.
-- Josmar opera; Vanessa consolida quinzenalmente.
-- =============================================

CREATE TABLE ticket_balancas (
    ticket_balanca_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),
    talhao_safra_id       UUID REFERENCES talhao_safras(id),        -- NULL para pesagem externa
    silo_destino_id       UUID REFERENCES silos(id),                -- silo onde o grao foi depositado

    -- Classificacao
    tipo                  tipo_ticket_balanca NOT NULL DEFAULT 'entrada_producao',
    status                status_ticket NOT NULL DEFAULT 'pesado',

    -- Identificacao
    numero_ticket         INTEGER,                                   -- numero sequencial (futuro: auto-gerado)

    -- Origem
    talhao_aba            VARCHAR(100),                              -- nome da aba na planilha fonte
    talhao_nome           VARCHAR(100),                              -- nome canonico do talhao
    gleba                 VARCHAR(100),                              -- sub-area do talhao (ex: HERMATRIA, BANACK)

    -- Pesagem
    data_pesagem          DATE NOT NULL,
    hora_pesagem          TIME,
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    -- Qualidade (preenchido por Josmar)
    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    avariado_g            DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),
    quebrado_g            DECIMAL(8,2),

    -- Descontos e peso final
    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    -- Transporte
    placa_veiculo         VARCHAR(10),
    motorista             VARCHAR(100),
    destino               VARCHAR(100),                              -- 'UBG', 'CASTROLANDA', nome do comprador

    -- Producao
    variedade             VARCHAR(100),                              -- cultivar (ex: IPRO, NEO)
    flag_semente          BOOLEAN DEFAULT FALSE,                     -- true = producao de semente certificada

    -- Contexto
    observacoes           TEXT,
    source_file           VARCHAR(200),                              -- rastreabilidade ETL

    -- Auditoria
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_ticket_peso_bruto CHECK (peso_bruto_kg IS NULL OR peso_bruto_kg > 0),
    CONSTRAINT chk_ticket_peso_liquido CHECK (peso_liquido_kg IS NULL OR peso_liquido_kg >= 0),
    CONSTRAINT chk_ticket_umidade CHECK (umidade_pct IS NULL OR (umidade_pct >= 0 AND umidade_pct <= 100))
);

-- Indices
CREATE INDEX idx_ticket_balanca_safra       ON ticket_balancas(safra_id);
CREATE INDEX idx_ticket_balanca_cultura     ON ticket_balancas(cultura_id);
CREATE INDEX idx_ticket_balanca_data        ON ticket_balancas(data_pesagem);
CREATE INDEX idx_ticket_balanca_talhao_safra ON ticket_balancas(talhao_safra_id);
CREATE INDEX idx_ticket_balanca_silo        ON ticket_balancas(silo_destino_id) WHERE silo_destino_id IS NOT NULL;

-- Trigger
CREATE TRIGGER trg_ticket_balanca_updated
    BEFORE UPDATE ON ticket_balancas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE ticket_balancas IS 'Ponto de transferencia agricultura→UBG. Cada pesagem na balanca gera um ticket.';
COMMENT ON COLUMN ticket_balancas.gleba IS 'Sub-area dentro de um talhao. Ex: talhao CAPINZAL tem glebas HERMATRIA, BANACK, URUGUAI.';
COMMENT ON COLUMN ticket_balancas.flag_semente IS 'True quando a producao e de semente certificada para Castrolanda (cultura separada).';
```

### 2.2 ~~PRODUCAO_UBG~~ (REMOVIDA 2026-03-09)

> **DEPRECADO:** Tabela `producao_ubg` foi REMOVIDA do DDL consolidado em 2026-03-09. Substituída por `ticket_balancas` + `recebimentos_grao`. O DDL abaixo é referência histórica apenas.

```sql
-- =============================================
-- PRODUCAO_UBG - Registro consolidado de producao
-- Derivado dos tickets de balanca, com dados de
-- produtividade e area por talhao/cultura/safra.
-- =============================================

CREATE TABLE producao_ubg (
    producao_ubg_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),

    -- Dados fonte
    arquivo_fonte         VARCHAR(200),                              -- arquivo Excel original
    aba                   VARCHAR(100),                              -- aba da planilha
    talhao_header         VARCHAR(100),                              -- nome do talhao no header da aba
    area_ha               DECIMAL(10,4),
    produtividade_kg_ha   DECIMAL(10,2),
    produto_variedade     VARCHAR(100),                              -- cultivar
    producao_total_kg     DECIMAL(12,2),

    -- Pesagem individual
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

    -- Qualidade
    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_pct          DECIMAL(5,2),
    ardidos_pct           DECIMAL(5,2),
    avariado_pct          DECIMAL(5,2),
    verdes_pct            DECIMAL(5,2),
    quebrado_pct          DECIMAL(5,2),

    -- Descontos
    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    -- Auditoria
    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_producao_ubg_safra   ON producao_ubg(safra_id);
CREATE INDEX idx_producao_ubg_cultura ON producao_ubg(cultura_id);
CREATE INDEX idx_producao_ubg_data    ON producao_ubg(data_pesagem);

-- Trigger
CREATE TRIGGER trg_producao_ubg_updated
    BEFORE UPDATE ON producao_ubg
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE producao_ubg IS 'Dados historicos de producao UBG importados das planilhas de controle (2022-2026). 883 tickets, 7 culturas.';
```

### 2.3 PESAGEM_AGRICOLA

```sql
-- =============================================
-- PESAGEM_AGRICOLA - Pesagens no campo (pré-UBG)
-- Dados de pesagem na fazenda antes do transporte
-- para a UBG. 806 registros, 7 culturas, 3 safras.
-- =============================================

CREATE TABLE pesagens_agricola (
    pesagem_agricola_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),

    -- Contexto
    arquivo               VARCHAR(200),
    talhao_aba            VARCHAR(100),
    talhao_nome           VARCHAR(100),

    -- Pesagem
    data_pesagem          DATE NOT NULL,
    hora_pesagem          TIME,
    gleba                 VARCHAR(100),
    destino               VARCHAR(100),
    placa                 VARCHAR(10),
    motorista             VARCHAR(100),
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    -- Qualidade
    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    avariado_g            DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),
    quebrado_g            DECIMAL(8,2),

    -- Descontos
    desconto_kg           DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    -- Producao
    variedade             VARCHAR(100),
    flag_semente          BOOLEAN DEFAULT FALSE,

    -- Rastreabilidade
    observacoes           TEXT,
    source_file           VARCHAR(200),

    -- Auditoria
    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_pesagem_agr_safra   ON pesagens_agricola(safra_id);
CREATE INDEX idx_pesagem_agr_cultura ON pesagens_agricola(cultura_id);
CREATE INDEX idx_pesagem_agr_data    ON pesagens_agricola(data_pesagem);

-- Trigger
CREATE TRIGGER trg_pesagem_agricola_updated
    BEFORE UPDATE ON pesagens_agricola
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE pesagens_agricola IS 'Pesagens agricolas no campo. Diferente de ticket_balanca que e na UBG.';
```

### 2.4 SAIDA_GRAO

```sql
-- =============================================
-- SAIDA_GRAO - Embarques de grao saindo da UBG
-- 542 registros, 4 culturas, 4 safras, 13 contratos.
-- Rastreia: contrato, transportadora, motorista, peso.
-- =============================================

CREATE TABLE saidas_grao (
    saida_grao_id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),

    -- Contrato
    contrato_codigo       VARCHAR(50),                               -- ex: VS12724-5
    contrato_descricao    VARCHAR(300),                              -- ex: SOJA INTACTA - LOUIS DREYFUS - 600 TONS

    -- Embarque
    data_embarque         DATE NOT NULL,
    hora_embarque         TIME,
    origem                VARCHAR(100) DEFAULT 'UBG',
    destino               VARCHAR(100),                              -- nome do comprador/destino
    transportadora        VARCHAR(100),                              -- empresa de frete
    motorista             VARCHAR(100),
    placa                 VARCHAR(10),
    tipo_produto          VARCHAR(100),                              -- tipo especifico se houver

    -- Pesagem
    peso_bruto_kg         DECIMAL(12,2),
    peso_tara_kg          DECIMAL(12,2),
    peso_liquido_kg       DECIMAL(12,2),

    -- Qualidade (na saida)
    umidade_pct           DECIMAL(5,2),
    ph                    DECIMAL(5,2),
    impureza_g            DECIMAL(8,2),
    ardidos_g             DECIMAL(8,2),
    verdes_g              DECIMAL(8,2),

    -- Descontos cooperativa
    desconto_coop_kg      DECIMAL(12,2),
    peso_final_kg         DECIMAL(12,2),

    -- Valores
    sacas                 DECIMAL(10,2),
    preco_por_saca        DECIMAL(10,2),
    preco_por_kg          DECIMAL(10,4),
    valor_bruto           DECIMAL(14,2),

    -- Rastreabilidade
    source_file           VARCHAR(200),

    -- Auditoria
    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_saida_grao_safra     ON saidas_grao(safra_id);
CREATE INDEX idx_saida_grao_cultura   ON saidas_grao(cultura_id);
CREATE INDEX idx_saida_grao_data      ON saidas_grao(data_embarque);
CREATE INDEX idx_saida_grao_contrato  ON saidas_grao(contrato_codigo);

-- Trigger
CREATE TRIGGER trg_saida_grao_updated
    BEFORE UPDATE ON saidas_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE saidas_grao IS 'Embarques de grao saindo da UBG para compradores. Vinculado a contratos de venda (VS*, etc.).';
```

### 2.5 RECEBIMENTO_GRAO

```sql
-- =============================================
-- RECEBIMENTO_GRAO - Recebimento formal na UBG
-- Gerado a partir de TICKET_BALANCA apos classificacao.
-- Dados pendentes de coleta (Josmar).
-- =============================================

CREATE TABLE recebimentos_grao (
    recebimento_grao_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FK pai
    ticket_balanca_id     UUID NOT NULL REFERENCES ticket_balancas(ticket_balanca_id),

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),
    silo_destino_id       UUID REFERENCES silos(id),

    -- Classificacao pos-pesagem
    classificacao_grao    VARCHAR(50),                               -- Tipo 1, Tipo 2, Fora de tipo
    umidade_final_pct     DECIMAL(5,2),                              -- apos secagem
    ph_final              DECIMAL(5,2),
    impureza_final_pct    DECIMAL(5,2),

    -- Descontos aplicados
    desconto_umidade_kg   DECIMAL(12,2),
    desconto_impureza_kg  DECIMAL(12,2),
    desconto_outros_kg    DECIMAL(12,2),
    peso_recebido_kg      DECIMAL(12,2),                             -- peso final apos todos os descontos

    -- Observacoes
    observacoes           TEXT,

    -- Auditoria
    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_recebimento_ticket ON recebimentos_grao(ticket_balanca_id);
CREATE INDEX idx_recebimento_safra  ON recebimentos_grao(safra_id);
CREATE INDEX idx_recebimento_silo   ON recebimentos_grao(silo_destino_id);

-- Trigger
CREATE TRIGGER trg_recebimento_grao_updated
    BEFORE UPDATE ON recebimentos_grao
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE recebimentos_grao IS 'Recebimento formal pos-classificacao. Derivado de TICKET_BALANCA. Dados pendentes Josmar.';
```

### 2.6 CONTROLE_SECAGEM

```sql
-- =============================================
-- CONTROLE_SECAGEM - Processo de secagem na UBG
-- Lenha = PRODUTO_INSUMO tipo LENHA.
-- Dados pendentes de coleta (Josmar).
-- =============================================

CREATE TABLE controles_secagem (
    controle_secagem_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),
    silo_id               UUID REFERENCES silos(id),                 -- silo/secador onde ocorreu

    -- Periodo
    data_inicio           DATE NOT NULL,
    data_fim              DATE,
    hora_inicio           TIME,
    hora_fim              TIME,

    -- Parametros de secagem
    umidade_entrada_pct   DECIMAL(5,2),
    umidade_saida_pct     DECIMAL(5,2),
    temperatura_c         DECIMAL(5,1),
    peso_entrada_kg       DECIMAL(12,2),
    peso_saida_kg         DECIMAL(12,2),
    perda_secagem_kg      DECIMAL(12,2),                             -- peso_entrada - peso_saida

    -- Consumo de insumos
    lenha_m3              DECIMAL(10,2),                              -- metros cubicos de lenha
    energia_kwh           DECIMAL(10,2),                              -- consumo eletrico

    -- Custo
    custo_lenha           DECIMAL(12,2),
    custo_energia         DECIMAL(12,2),
    custo_total_secagem   DECIMAL(12,2),

    -- Observacoes
    observacoes           TEXT,

    -- Auditoria
    status                VARCHAR(20) DEFAULT 'active',
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT chk_secagem_datas CHECK (data_fim IS NULL OR data_fim >= data_inicio),
    CONSTRAINT chk_secagem_umidade CHECK (
        umidade_entrada_pct IS NULL OR umidade_saida_pct IS NULL
        OR umidade_entrada_pct >= umidade_saida_pct
    )
);

-- Indices
CREATE INDEX idx_secagem_safra  ON controles_secagem(safra_id);
CREATE INDEX idx_secagem_silo   ON controles_secagem(silo_id);
CREATE INDEX idx_secagem_data   ON controles_secagem(data_inicio);

-- Trigger
CREATE TRIGGER trg_controle_secagem_updated
    BEFORE UPDATE ON controles_secagem
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE controles_secagem IS 'Registro de cada ciclo de secagem na UBG. Custos proprios (lenha + energia) separados da agricultura.';
COMMENT ON COLUMN controles_secagem.lenha_m3 IS 'Lenha e PRODUTO_INSUMO tipo LENHA, grupo geral. Consumida exclusivamente na secagem.';
```

### 2.7 ESTOQUE_SILO

```sql
-- =============================================
-- ESTOQUE_SILO - Posicao de estoque por silo
-- Auto-calculado via triggers/views.
-- Snapshot do estoque em cada silo.
-- =============================================

CREATE TABLE estoques_silo (
    estoque_silo_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FKs de negocio
    silo_id               UUID NOT NULL REFERENCES silos(id),
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),

    -- Status
    status_estoque        status_estoque_silo NOT NULL DEFAULT 'ativo',

    -- Posicao
    data_referencia       DATE NOT NULL,                              -- data do snapshot
    quantidade_kg         DECIMAL(14,2) NOT NULL DEFAULT 0,
    capacidade_restante_kg DECIMAL(14,2),

    -- Qualidade media
    umidade_media_pct     DECIMAL(5,2),
    ph_medio              DECIMAL(5,2),

    -- Totais acumulados
    total_entradas_kg     DECIMAL(14,2) DEFAULT 0,
    total_saidas_kg       DECIMAL(14,2) DEFAULT 0,
    total_perda_secagem_kg DECIMAL(14,2) DEFAULT 0,

    -- Auditoria
    created_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT uq_estoque_silo_data UNIQUE (silo_id, safra_id, cultura_id, data_referencia),
    CONSTRAINT chk_estoque_quantidade CHECK (quantidade_kg >= 0)
);

-- Indices
CREATE INDEX idx_estoque_silo_silo   ON estoques_silo(silo_id);
CREATE INDEX idx_estoque_silo_safra  ON estoques_silo(safra_id);
CREATE INDEX idx_estoque_silo_data   ON estoques_silo(data_referencia);

-- Trigger
CREATE TRIGGER trg_estoque_silo_updated
    BEFORE UPDATE ON estoques_silo
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE estoques_silo IS 'Snapshot de estoque por silo/safra/cultura. Auto-calculado via trigger ou view materializada.';
```

---

## 3. Notas de Implementacao

### 3.1 Validacao Dijkstra — FKs Removidas

| FK proposta | Caminho alternativo | Hops | Decisao |
|-------------|---------------------|------|---------|
| `ticket_balanca → fazendas` | ticket_balanca → talhao_safras → talhoes → fazendas | 3 | REMOVIDO (gray zone) |
| `saida_grao → parceiros_comerciais` | N/A — destino e texto livre V0 | — | NAO NECESSARIO V0 |
| `producao_ubg → talhao_safras` | N/A — dados historicos sem talhao_safra_id resolvido | — | OMITIDO |
| `pesagem_agricola → talhao_safras` | N/A — idem | — | OMITIDO |
| `recebimento_grao → safra/cultura` | recebimento → ticket_balanca.safra_id/cultura_id | 1 | REDUNDANTE mas mantido para queries diretas (DENORM) |

### 3.2 Decisoes de Design

| Decisao | Justificativa |
|---------|---------------|
| `ticket_balanca.gleba` texto livre | Glebas nao tem cadastro formal V0 — apenas sub-areas informais |
| `producao_ubg` separada de `ticket_balanca` | Dados historicos com formato diferente (header de area/produtividade por aba) |
| `pesagem_agricola` separada | Pesagens no campo (pre-transporte) vs pesagens na UBG (ticket_balanca) |
| `estoque_silo` com UNIQUE composto | Um snapshot por silo/safra/cultura/data — evita duplicatas |
| `controle_secagem.lenha_m3` direto | Nao FK para APLICACAO_INSUMO V0 — simplificacao |

### 3.3 Conexoes com Outros Modulos

```
Doc 26:  organizations, fazendas, talhoes, safras, culturas, talhao_safras, silos
         └─→ referenciados por ticket_balancas, producao_ubg, pesagens_agricola,
             saidas_grao, recebimentos_grao, controles_secagem, estoques_silo

Doc 25a: operacoes_campo (via transporte_colheita_detalhes.ticket_balanca_id)
         └─→ TRANSPORTE_COLHEITA_DETALHE ja referencia ticket_balancas

Doc 16:  produto_insumo (lenha) → nao FK direta, texto em controles_secagem V0
```

---

## 4. Ordem de Execucao

```
1. ENUM types (4)
2. ticket_balancas
3. producao_ubg
4. pesagens_agricola
5. saidas_grao
6. recebimentos_grao     ← depende de ticket_balancas
7. controles_secagem
8. estoques_silo
```

---

## 5. Resumo

| Item | Quantidade |
|------|-----------|
| Tabelas | 7 |
| ENUMs | 4 |
| Indices | 19 |
| Triggers | 7 |
| Constraints CHECK | 6 |
| Constraints UNIQUE | 1 |

---

*Documento gerado em 03/03/2026 - DeepWork AI Flows*
*Baseado em Doc 08 (ER Completo) + CSVs coletados (ticket_balanca, producao_ubg, pesagens_agricola, saidas_producao)*
