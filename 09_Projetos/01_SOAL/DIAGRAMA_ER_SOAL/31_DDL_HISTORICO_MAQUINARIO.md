# DDL COMPLETO - MODULO HISTORICO MAQUINARIO

**Data:** 03/03/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Schema:** public (ajustar conforme Medallion: bronze/silver/gold)
**Referencia:** Doc 08 - ER Completo, camada Operacional (Cyan)

---

## Pre-requisitos

Executar **antes** deste DDL:
- Doc 26 — Fundacional (organizations, maquinas, operadores)

---

## 1. ENUM Types

```sql
-- =============================================
-- ENUM TYPES - Historico Maquinario
-- =============================================

-- Tipo de registro historico
CREATE TYPE tipo_registro_maquinario AS ENUM (
    'abastecimento',
    'manutencao',
    'operacao_campo'
);
```

---

## 2. Tabela

### 2.1 HISTORICO_MAQUINAS

```sql
-- =============================================
-- HISTORICO_MAQUINAS - Registros legados de maquinario
-- 32.516 registros (1997-2026), 11 planilhas, 101 abas.
-- Consolidacao de abastecimentos, manutencoes e
-- operacoes de campo do sistema legado (planilhas).
-- =============================================

CREATE TABLE historico_maquinas (
    historico_maquina_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id        UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,

    -- FK para maquina (quando resolvida)
    maquina_id             UUID REFERENCES maquinas(id),

    -- Tipo de registro
    tipo_registro          tipo_registro_maquinario NOT NULL,

    -- Identificacao da maquina (dados brutos)
    maquina_codigo         VARCHAR(50),                               -- codigo original (ex: T-09, S660-01)
    maquina_nome           VARCHAR(200),                              -- nome completo
    maquina_status         VARCHAR(20),                               -- ATIVO, VENDIDO

    -- Temporalidade
    data_registro          DATE NOT NULL,

    -- Metricas de uso
    horimetro              DECIMAL(12,2),
    hodometro              DECIMAL(12,2),

    -- Abastecimento (tipo = 'abastecimento')
    combustivel            VARCHAR(50),                               -- DIESEL, GASOLINA
    quantidade_litros      DECIMAL(10,2),
    valor_unitario         DECIMAL(10,4),
    valor_total            DECIMAL(12,2),
    tanque_saida           VARCHAR(100),                              -- nome do tanque de combustivel

    -- Manutencao (tipo = 'manutencao')
    descricao_manutencao   TEXT,
    tipo_manutencao_txt    VARCHAR(100),                              -- preventiva, corretiva (texto livre)
    quantidade_pecas       DECIMAL(10,2),
    nota_fiscal            VARCHAR(50),

    -- Operacao de campo (tipo = 'operacao_campo')
    operacao               VARCHAR(200),                              -- tipo de operacao
    cultura                VARCHAR(100),
    implemento_codigo      VARCHAR(50),
    fazenda_talhao         VARCHAR(200),                              -- "FAZENDA - TALHAO" concatenado
    horimetro_inicio       DECIMAL(12,2),
    horimetro_fim          DECIMAL(12,2),

    -- Contexto compartilhado
    responsavel            VARCHAR(100),                              -- operador/motorista
    observacoes            TEXT,

    -- Rastreabilidade
    source_file            VARCHAR(200),
    source_aba             VARCHAR(200),                              -- aba da planilha Excel

    -- Auditoria
    status                 VARCHAR(20) DEFAULT 'active',
    created_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indices
CREATE INDEX idx_hist_maq_tipo       ON historico_maquinas(tipo_registro);
CREATE INDEX idx_hist_maq_maquina    ON historico_maquinas(maquina_id) WHERE maquina_id IS NOT NULL;
CREATE INDEX idx_hist_maq_codigo     ON historico_maquinas(maquina_codigo);
CREATE INDEX idx_hist_maq_data       ON historico_maquinas(data_registro);
CREATE INDEX idx_hist_maq_status     ON historico_maquinas(maquina_status);

-- Trigger
CREATE TRIGGER trg_historico_maquina_updated
    BEFORE UPDATE ON historico_maquinas
    FOR EACH ROW EXECUTE FUNCTION fn_atualizar_updated_at();

COMMENT ON TABLE historico_maquinas IS 'Dados legados de maquinario (1997-2026). 32.516 registros de 11 planilhas, 101 abas. Consolidacao de 3 tipos: abastecimento, manutencao, operacao de campo.';
COMMENT ON COLUMN historico_maquinas.maquina_id IS 'FK resolvida apos mapeamento codigo→UUID. NULL enquanto nao mapeado.';
COMMENT ON COLUMN historico_maquinas.fazenda_talhao IS 'Texto concatenado "FAZENDA - TALHAO" do legado. Nao e FK — precisa de mapeamento.';
```

---

## 3. Notas de Implementacao

### 3.1 Design: Tabela Unica vs Separadas

Optou-se por uma **tabela unica** com `tipo_registro` discriminador ao inves de 3 tabelas separadas (historico_abastecimentos, historico_manutencoes, historico_operacoes). Justificativa:

1. **Dados legados:** Estrutura vem de planilhas Excel com layouts variados (8 layouts detectados). Nao justifica modelagem relacional complexa para dados historicos.
2. **Query pattern:** Consultas sao quase sempre filtradas por maquina + periodo, independente do tipo.
3. **Import simplificado:** Um unico `COPY` ao inves de 3.
4. **Silver layer:** Transformacao para tabelas normalizadas (abastecimentos, manutencoes, operacoes_campo) ocorre no Silver, nao no Bronze.

### 3.2 Relacao com Doc 26

As tabelas `abastecimentos` e `manutencoes` do Doc 26 sao para dados **novos** (V0 em diante). O `historico_maquinas` e para dados **legados** (pre-V0). No Silver layer, dados de ambas as fontes serao unificados.

### 3.3 Validacao Dijkstra

| FK proposta | Caminho alternativo | Hops | Decisao |
|-------------|---------------------|------|---------|
| `historico_maquinas → operadores` | responsavel e texto livre, nao FK | — | REMOVIDO |
| `historico_maquinas → culturas` | cultura e texto livre legado | — | REMOVIDO |
| `historico_maquinas → talhoes` | fazenda_talhao e texto concatenado | — | REMOVIDO |

---

## 4. Resumo

| Item | Quantidade |
|------|-----------|
| Tabelas | 1 |
| ENUMs | 1 |
| Indices | 5 |
| Triggers | 1 |

---

*Documento gerado em 03/03/2026 - DeepWork AI Flows*
*Baseado em etl_maquinario.py (32.516 registros, 8 layouts dinamicos)*
