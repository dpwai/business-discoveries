# DDL — COLABORADORES + FOLHA DE PAGAMENTO

**Data:** 03/03/2026
**Versao:** 1.0
**Banco:** PostgreSQL 15+
**Referencia:** Doc 08 - Estrutura ER Completa | Doc 26 - DDL Fundacional | CLAUDE.md
**Fonte de dados:** ETL `DATA/RH/etl_folha_pagamento.py` (54/54 + 21/21 QC PASS)

> **Decisao de renaming:** `TRABALHADOR_RURAL` (Doc 26 §5.5) → `COLABORADORES`.
> Motivo: a entidade inclui administrativos, UBG, pecuaria — nao apenas rurais.
> Este DDL **substitui** a secao 5.5 do Doc 26.

---

## 1. ENUM Types (novos)

```sql
-- =============================================
-- ENUM TYPES — Modulo Colaboradores + Folha
-- Executar ANTES dos CREATE TABLEs abaixo
-- =============================================

-- Substitui 'tipo_contrato_trabalho' do Doc 26 (valores expandidos)
-- Se ja existir no banco, executar:
--   ALTER TYPE tipo_contrato_trabalho ADD VALUE IF NOT EXISTS 'informal';
--   ALTER TYPE tipo_contrato_trabalho ADD VALUE IF NOT EXISTS 'temporario';
-- Ou dropar e recriar se banco estiver vazio:
DROP TYPE IF EXISTS tipo_contrato_trabalho CASCADE;
CREATE TYPE tipo_contrato_trabalho AS ENUM ('clt', 'informal', 'temporario', 'safrista');

CREATE TYPE setor_trabalho AS ENUM (
    'agricola', 'pecuaria', 'ubg', 'administrativo', 'experiencia'
);

CREATE TYPE tipo_folha_pagamento AS ENUM (
    'regular', '13_1a_parcela', '13_2a_parcela', '14_salario', 'bonus', 'gratificacao'
);
```

**Nota:** `tipo_contrato_trabalho` ja existe no Doc 26 com valores (`clt`, `diarista`, `safrista`, `terceirizado`).
Os dados reais do ETL mostram apenas `CLT` e `INFORMAL`. Valores atualizados:
- `clt` — CLT formal (maioria)
- `informal` — sem CPF/contrato formal (ex: diaristas historicos)
- `temporario` — contrato por prazo determinado
- `safrista` — contrato de safra

---

## 2. Tabela `colaboradores` (substitui `trabalhadores_rurais`)

```sql
-- =============================================
-- COLABORADORES — Funcionarios de todas as areas
-- Substitui trabalhadores_rurais (Doc 26 §5.5)
-- Fonte: DATA/RH/colaboradores_soal_clean.csv (88 registros)
-- =============================================

-- Se trabalhadores_rurais existir no banco, migrar dados antes de dropar:
-- INSERT INTO colaboradores (...) SELECT ... FROM trabalhadores_rurais;
-- DROP TABLE trabalhadores_rurais CASCADE;

CREATE TABLE colaboradores (
    colaborador_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id   UUID NOT NULL REFERENCES organizations(organization_id),
    nome              VARCHAR(200) NOT NULL,
    cpf               VARCHAR(14),                        -- formato: 000.000.000-00 | nullable (informais)
    setor             setor_trabalho,                      -- agricola, pecuaria, ubg, administrativo, experiencia
    funcao            VARCHAR(100),                        -- ex: Tratorista, Motorista de Truck, Peao
    tipo_contrato     tipo_contrato_trabalho NOT NULL DEFAULT 'clt',
    data_admissao     DATE,
    data_desligamento DATE,
    conta_banco       VARCHAR(50),                         -- numero da conta (agencia no banco futuro)
    telefone          VARCHAR(20),

    status            VARCHAR(20) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_colaboradores_cpf
        UNIQUE (organization_id, cpf)
        -- Nota: partial unique WHERE cpf IS NOT NULL nao e possivel via CONSTRAINT
        -- Usar CREATE UNIQUE INDEX abaixo para partial unique
);

-- Partial unique: apenas CPFs nao-nulos sao unicos por org
DROP INDEX IF EXISTS uq_colaboradores_cpf;
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
COMMENT ON COLUMN colaboradores.setor IS
    'Setor do colaborador. Valores do ETL: AGRICOLA, UBG, ADMINISTRATIVO, EXPERIENCIA, PECUARIA.';
COMMENT ON COLUMN colaboradores.data_desligamento IS
    'Data de desligamento. NULL = colaborador ativo. Status derivado: data_desligamento IS NOT NULL → desligado.';
```

---

## 3. Tabela `folha_pagamento` (historico mensal)

```sql
-- =============================================
-- FOLHA_PAGAMENTO — Historico mensal de pagamentos
-- Fonte: DATA/RH/folha_pagamento_historico.csv (3.122 registros)
-- Periodo: Jul/2017 → Fev/2026 (104 meses)
-- =============================================

CREATE TABLE folha_pagamento (
    folha_pagamento_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id    UUID NOT NULL REFERENCES organizations(organization_id),
    colaborador_id     UUID NOT NULL REFERENCES colaboradores(colaborador_id),
    ano_mes            DATE NOT NULL,                      -- primeiro dia do mes (2020-01-01)
    tipo_folha         tipo_folha_pagamento NOT NULL DEFAULT 'regular',
    salario_bruto      NUMERIC(12,2) DEFAULT 0,
    ferias_pf          NUMERIC(12,2) DEFAULT 0,            -- ferias + provisao ferias
    decimo_terceiro    NUMERIC(12,2) DEFAULT 0,
    horas_extras       NUMERIC(12,2) DEFAULT 0,
    descontos          NUMERIC(12,2) DEFAULT 0,            -- valor negativo no ETL
    acrescimos         NUMERIC(12,2) DEFAULT 0,
    total_liquido      NUMERIC(12,2) DEFAULT 0,
    observacoes        TEXT,                                -- ex: "Castromed", "Consorcio", "Adiantamento"

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
    'Historico mensal de folha de pagamento. Granularidade: 1 registro por colaborador/mes/tipo. '
    'Fonte: planilhas FSI digitalizadas via ETL (118 abas, 5 eras de layout).';
COMMENT ON COLUMN folha_pagamento.ano_mes IS
    'Primeiro dia do mes de competencia. Ex: 2020-01-01 = janeiro/2020.';
COMMENT ON COLUMN folha_pagamento.tipo_folha IS
    'Tipo do lancamento: regular (mensal), 13_1a_parcela, 13_2a_parcela, 14_salario, bonus, gratificacao.';
COMMENT ON COLUMN folha_pagamento.descontos IS
    'Valor de descontos. Armazenado como valor positivo no banco (ETL converte negativos).';
```

---

## 4. ALTER OPERADORES — FK para colaboradores

```sql
-- =============================================
-- Vincular operadores (Doc 26 §5.2) a colaboradores
-- Match: Vestro operador ↔ colaborador CLT via CPF
-- =============================================

ALTER TABLE operadores
    ADD COLUMN colaborador_id UUID REFERENCES colaboradores(colaborador_id);

CREATE INDEX idx_operadores_colaborador ON operadores(colaborador_id)
    WHERE colaborador_id IS NOT NULL;

COMMENT ON COLUMN operadores.colaborador_id IS
    'FK opcional para colaboradores. Vincula operador Vestro ao registro CLT. Match via CPF.';
```

---

## 5. Dijkstra Check — Validacao de FK Redundante

| FK proposto | Caminho alternativo | Hops | Decisao |
|------------|---------------------|------|---------|
| `folha_pagamento → colaboradores` | Nenhum | — | **ESSENCIAL** (unica via) |
| `folha_pagamento → organizations` | via `colaboradores.organization_id` | 1 | **Mantido** (multi-tenant filter padrao) |
| `operadores → colaboradores` | Nenhum | — | **ESSENCIAL** (unica via de vinculacao) |

Todas as FKs passam no check Dijkstra.

---

## 6. Ordem de Execucao

```sql
-- Rodar APOS Doc 26 (que cria organizations, operadores, fn_atualizar_updated_at)
-- Ordem:
--   1. ENUMs (setor_trabalho, tipo_folha_pagamento, ALTER tipo_contrato_trabalho)
--   2. colaboradores
--   3. folha_pagamento (depende de colaboradores)
--   4. ALTER operadores (depende de colaboradores)
```

---

## 7. Resumo

| Item | Quantidade |
|------|-----------|
| ENUMs novos | 2 (`setor_trabalho`, `tipo_folha_pagamento`) |
| ENUMs alterados | 1 (`tipo_contrato_trabalho` — valores expandidos) |
| Tabelas novas | 2 (`colaboradores`, `folha_pagamento`) |
| Tabelas alteradas | 1 (`operadores` — ADD COLUMN) |
| Indexes | 7 |
| Triggers | 2 |
| Registros colaboradores | 88 (32 ativos, 56 desligados) |
| Registros folha | 3.122 (Jul/2017 → Fev/2026) |

---

*Gerado por: Claude Code | Projeto SOAL — DeepWork AI Flows*
