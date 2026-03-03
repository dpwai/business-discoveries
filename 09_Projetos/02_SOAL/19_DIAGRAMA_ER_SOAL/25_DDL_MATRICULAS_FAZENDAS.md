# Doc 25 — DDL MATRICULAS + Enriquecimento FAZENDAS

> Fase 2 do ETL Matrículas. Baseado em 88 registros validados (59 SOAL + 29 CK).
> Fonte: `DATA/ORG/matriculas_soal_clean.csv`

---

## 1. Entidade MATRICULA (Camada Territorial)

**Posição no ER:** MATRICULA → [FAZENDAS] (leaf da camada territorial)
**Adjacency:** `MATRICULAS → [FAZENDAS]`

### Decisões de design

| Decisão | Justificativa |
|---------|---------------|
| `numero_matricula` é VARCHAR, não PK | Pode ser "T 7510" (transcrição), "Posse", ou numérico. Não é unique (ex: 3961 tem 3 aquisições no mesmo registro). |
| `registro` campo separado | O sufixo R/XX identifica o registro dentro da matrícula (ex: "3.112-R/02" vs "3.112-R/04") |
| CCIR/ITR/CAR ficam em FAZENDAS | Compartilhados por múltiplas matrículas da mesma fazenda. São atributos do imóvel rural, não da matrícula individual. |
| `titular` enum SOAL/CK | Identifica quem detém a matrícula atualmente. CK = Claudio Kugler pessoal (em transferência para SOAL). |
| Sem bridge TALHAO_MATRICULA | Não temos mapeamento talhão↔matrícula. Requer análise GIS. Pode ser adicionado futuramente. |

### DDL

```sql
-- ═══════════════════════════════════════════════════════════════
-- MATRICULAS — Registros de matrícula imobiliária
-- Camada: Territorial (Lime)
-- Fonte: Resumo Matriculas.xlsx, aba "Matriculas SOAL"
-- ═══════════════════════════════════════════════════════════════

CREATE TABLE matriculas (
    matricula_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fazenda_id                UUID NOT NULL REFERENCES fazendas(fazenda_id),
    -- organization_id omitido no diagrama (regra ER 4.2)

    -- Identificação da matrícula
    numero_matricula          VARCHAR(20),            -- Ex: "8", "903", "T 7510", "Posse". NÃO unique.
    registro                  VARCHAR(20),            -- Sufixo R/XX do cartório. Ex: "R/02", "R/14 e R15"
    descricao                 TEXT,                   -- Descrição livre do cartório/escritura

    -- Área
    area_ha                   NUMERIC(10,4) NOT NULL, -- Área bruta da matrícula em hectares

    -- Titularidade
    titular                   VARCHAR(10) NOT NULL DEFAULT 'SOAL',  -- SOAL | CK
        -- CK = Claudio Kugler pessoal, em processo de transferência para SOAL

    -- Histórico de aquisição
    data_aquisicao            DATE,                   -- Data da escritura de compra
    proprietario_anterior     TEXT,                   -- Nome do vendedor original
    valor_compra              NUMERIC(12,2),          -- Valor de compra (apenas 3 registros têm)

    -- Incorporação
    data_incorporacao_soal    DATE,                   -- Data de integração ao patrimônio SOAL
    registro_anterior_1       VARCHAR(20),            -- Matrícula que esta substituiu (col G)
    registro_anterior_2       VARCHAR(20),            -- Segundo registro anterior (col H)

    -- Observações
    observacoes               TEXT,                   -- Flags: transcrição, posse, pendências

    -- Padrão
    status                    VARCHAR(20) DEFAULT 'active',
    created_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices
CREATE INDEX idx_matriculas_fazenda ON matriculas(fazenda_id);
CREATE INDEX idx_matriculas_numero ON matriculas(numero_matricula);
CREATE INDEX idx_matriculas_titular ON matriculas(titular);
```

---

## 2. Enriquecimento FAZENDAS

Campos a adicionar na entidade FAZENDAS existente:

```sql
-- ═══════════════════════════════════════════════════════════════
-- ALTER FAZENDAS — Adicionar campos de matrículas
-- Fonte: planilha Resumo Matrículas (tabela resumo rows 103-113)
-- ═══════════════════════════════════════════════════════════════

ALTER TABLE fazendas ADD COLUMN area_total_ha      NUMERIC(10,2);  -- Soma bruta de todas as matrículas
ALTER TABLE fazendas ADD COLUMN area_agricola_ha   NUMERIC(10,2);  -- Área destinada a plantio
ALTER TABLE fazendas ADD COLUMN ccir_incra         VARCHAR(30);    -- Certificado Cadastro Imóvel Rural
ALTER TABLE fazendas ADD COLUMN itr                VARCHAR(20);    -- Imposto Territorial Rural
ALTER TABLE fazendas ADD COLUMN car                VARCHAR(80);    -- Cadastro Ambiental Rural
ALTER TABLE fazendas ADD COLUMN localidade         VARCHAR(100);   -- Bairro/localidade (ex: "Pedeira / Jararaca")
```

### Dados para seed (FAZENDAS)

| Fazenda | area_total_ha | area_agricola_ha | ccir_incra | itr | car | localidade |
|---------|--------------|-----------------|------------|-----|-----|------------|
| SANTANA DO IAPO | 1456.81 | 405.93 | 715.042.010.111-0 / 706.027.017.612-5 | 0.866.831-0 / 0.866.823-0 | PR-4119400-E3DD... / PR-4119400-2A45... | Pedeira / Jararaca |
| SANTO ANDRE | 900.42 | 552.87 | 951.137.829.455-7 | — | PR-4119400-F3D9... | Bairro Santo André |
| STO ANT. CAPINZAL | 690.32 | 326.01 | 706.027.021.679-8 / 706.027.013.196-2 | 1.973.828-5 | PR-4119400-D2A2... / PR-4119400-2470... | Capinzal |
| LAJEADO DO SAO JOAO | 617.66 | 340.68 | 706.027.274.305-1 | 0.475.834-0 | PR-4119400-2E79... | Joaquim Murtinho |
| SAO FRANCISCO | 312.02 | 156.64 | 715.042.010.111-0 / 706.027.026.379-6 / 951.072.986.593-2 | 0.866.823-0 / 2.894.244-2 | PR-4119400-2A45... / PR-4119400-41BF... / PR-4119400-787E... | Bairro Francisca Leme |
| SANTA RITA | 115.44 | 48.98 | — | — | — | Sertão do Jararaca |
| SAO JOSE | 34.90 | 24.55 | — | — | — | Sertão do Jararaca |

**Nota:** Santana e São Francisco compartilham CCIR `715.042.010.111-0` — provavelmente um imóvel rural que abrange ambas. Algumas fazendas têm múltiplos CCIRs porque são compostas de imóveis rurais distintos no INCRA.

---

## 3. Análise Dijkstra

| FK proposta | Caminho sem ela | Hops | Decisão |
|------------|----------------|------|---------|
| MATRICULA → FAZENDAS | Sem caminho alternativo | — | **ESSENCIAL** — desenhar |
| MATRICULA → ORGANIZATIONS | MATRICULA → FAZENDAS → ORGANIZATIONS | 2 | **REDUNDANTE** — org_id implícito |
| MATRICULA → TALHOES | Sem mapeamento disponível | — | **NÃO APLICÁVEL** — bridge futura |

---

## 4. Resumo ER

```
# Adjacency list atualizada (Territorial)
FAZENDAS → [ORGANIZATIONS]
TALHOES → [FAZENDAS]
SILOS → [FAZENDAS]                    # (via UBG na prática)
SAFRAS → [ORGANIZATIONS]
CULTURAS → []
TALHAO_SAFRA → [TALHOES, SAFRAS, CULTURAS]
PARCEIRO_COMERCIAL → [ORGANIZATIONS]
CONTRATO_ARRENDAMENTO → [PARCEIRO_COMERCIAL, TALHOES]
MATRICULAS → [FAZENDAS]              # ← NOVA ENTIDADE
```

---

## 5. Impacto no board Miro

- Adicionar card MATRICULAS na camada Territorial (Lime #dbfaad)
- Conector: MATRICULAS → FAZENDAS (seta direta)
- Sem conector para TALHOES (bridge futura, requer GIS)
- Atualizar card FAZENDAS com novos campos

---

## 6. Fora do escopo

- Bridge table `talhao_matricula` — requer mapeamento GIS/CAR que não temos
- Histórico de transferências CK→SOAL — processo jurídico em andamento, não modelar agora
- Parsing de PDFs individuais das matrículas (410 arquivos na pasta)
- Integração com CAR.gov.br

---

*Criado: 2026-03-03 | Baseado em: ETL Fase 1 (`etl_matriculas.py`) + análise validação cruzada*
