# 24 — PLANO DE COLETA DE DADOS: SOAL V0

> **Versão:** 1.0
> **Data:** 2026-02-26
> **Escopo:** Entidades ativas para o "Dia 01" — excluídos Pecuária e integração John Deere (versão futura)
> **Entidades cobertas:** ~63 (de ~92 totais)
> **Objetivo:** Estrutura completa para que a partir do Dia 01 todos os dados entrem no sistema de forma correta e rastreável

---

## Índice

1. [Categorias de Coleta](#1-categorias-de-coleta)
2. [Ordem Crítica de Inserção](#2-ordem-crítica-de-inserção)
3. [Fora do Escopo V0](#3-fora-do-escopo-v0)
4. [Fase 0 — Seed: Entidades Raiz](#4-fase-0--seed-entidades-raiz)
5. [Fase 1 — Sistema e Plataforma](#5-fase-1--sistema-e-plataforma)
6. [Fase 2 — Território](#6-fase-2--território)
7. [Fase 3 — Cadastros Operacionais](#7-fase-3--cadastros-operacionais)
8. [Fase 4 — Financeiro Base](#8-fase-4--financeiro-base)
9. [Fase 5 — Planejamento da Safra](#9-fase-5--planejamento-da-safra)
10. [Fase 6 — Operações Contínuas](#10-fase-6--operações-contínuas)
11. [Fase 7 — Auto-Calculado](#11-fase-7--auto-calculado)
12. [Templates CSV](#12-templates-csv)
13. [Checklist de Prontidão ("Dia 01")](#13-checklist-de-prontidão-dia-01)

---

## 1. Categorias de Coleta

Toda entidade se enquadra em exatamente uma categoria de coleta:

| Categoria | Método | Quem executa | Frequência |
|-----------|--------|--------------|------------|
| **A — Seed** | João insere via SQL script | João (CTO) | Uma vez no setup |
| **B — CSV Import** | Template CSV preenchido → script de ingestão Python | Rodrigo coleta, João importa | Uma vez + eventual |
| **C — Form** | Formulário web/mobile no app | Usuário final (Tiago, Josmar, Valentina, Alessandro) | Contínuo |
| **D — API/Integration** | Script automático (N8N ou Python crawler) | Automação | Periódico (diário/semanal) |
| **E — Auto-calculado** | Trigger ou stored procedure (nenhuma ação do usuário) | Sistema | Em tempo real |

---

## 2. Ordem Crítica de Inserção

A sequência abaixo respeita as dependências de FK. Uma entidade **não pode** ser populada antes de suas entidades pai existirem.

```
FASE 0 ─── Entidades raiz (sem FK de negócio)
            CULTURAS, ROLES, PERMISSIONS, PRODUTO_INSUMO (catálogo)

FASE 1 ─── Sistema / Plataforma
            OWNERS → ORGANIZATIONS → FAZENDAS
                          └──► SAFRAS
                          └──► USERS

FASE 2 ─── Território
            TALHOES (via CAR/KML)
            UBG → SILOS
            PARCEIRO_COMERCIAL
            CONTRATO_ARRENDAMENTO

FASE 3 ─── Cadastros Operacionais
            MAQUINAS (planilha Tiago)
            OPERADORES
            TRABALHADOR_RURAL
            CENTRO_CUSTO (hierarquia)

FASE 4 ─── Financeiro Base
            NOTA_FISCAL (via SEFAZ) → NOTA_FISCAL_ITEM
            CONTA_PAGAR / CONTA_RECEBER
            CONTRATO_COMERCIAL → CONTRATO_ENTREGA → CPR_DOCUMENTO

FASE 5 ─── Planejamento da Safra (anual)
            TALHAO_SAFRA ← (TALHOES + SAFRAS + CULTURAS)  ← ENTIDADE CENTRAL
            ANALISE_SOLO → RECOMENDACAO_ADUBACAO
            RECEITUARIO_AGRONOMICO

FASE 6 ─── Operações Contínuas (dia a dia)
            OPERACAO_CAMPO → [PLANTIO/COLHEITA/PULVERIZACAO/DRONE/TRANSPORTE_DETALHE]
            COMPRA_INSUMO → ESTOQUE_INSUMO*
            ABASTECIMENTOS (Vestro)
            MANUTENCOES
            TICKET_BALANCA → RECEBIMENTO_GRAO → CONTROLE_SECAGEM
            SAIDA_GRAO / QUEBRA_PRODUCAO
            APONTAMENTO_MAO_OBRA

FASE 7 ─── Auto-calculado (sistema faz sozinho)
            MOVIMENTACAO_INSUMO, ESTOQUE_INSUMO, MOVIMENTACAO_SILO,
            ESTOQUE_SILO, CUSTO_OPERACAO, APLICACAO_INSUMO*, todos os logs
```

> `*` ESTOQUE_INSUMO é a posição atual — calculada automaticamente. APLICACAO_INSUMO é gerada a partir do OPERACAO_CAMPO.

---

## 3. Fora do Escopo V0

As seguintes entidades **não** fazem parte do plano atual:

| Grupo | Entidades | Motivo |
|-------|-----------|--------|
| **Pecuária** | ANIMAL, LOTE_ANIMAL, PESAGEM, PASTO, PASTO_AVALIACAO, MOVIMENTACAO_PASTO, MANEJO_SANITARIO, OCORRENCIA_SANITARIA, DIETA, DIETA_INGREDIENTE, TRATO_ALIMENTAR, COCHO, CALENDARIO_SANITARIO, ESTACAO_MONTA, PROTOCOLO_IATF, COBERTURA, DIAGNOSTICO_GESTACAO, PARTO, GTA, GTA_ANIMAL, VENDA_ANIMAL, COMPRA_ANIMAL, RACA | Versão futura |
| **John Deere** | Integração automática OPERACAO_CAMPO | Versão futura — campo será preenchido manualmente no V0 |
| **Infraestrutura** | INTEGRACAO, INTEGRACAO_LOG, WEBHOOK_CONFIG/DELIVERY, ALERTA_*, SESSION_LOG, ERROR_LOG, AUDIT_LOG, DATA_CHANGE_LOG | Gerados automaticamente pelo sistema — nenhuma coleta necessária |

---

## 4. Fase 0 — Seed: Entidades Raiz

**Executado por:** João via SQL seed scripts
**Quando:** Antes de qualquer outra coisa — pré-requisito absoluto
**Como:** Scripts SQL que populam as tabelas antes do primeiro usuário logar

---

### 4.1 CULTURAS

**O que é:** Catálogo fixo de culturas agricultáveis — não muda com frequência.

| Campo | Tipo | Valor SOAL |
|-------|------|------------|
| cultura_id | UUID | gerado |
| nome | VARCHAR | Soja, Milho, Trigo, Aveia, Sorgo, Semente de Soja |
| codigo | VARCHAR | SOJ, MIL, TRI, AVE, SOR, SEM |
| ciclo_dias | INTEGER | 120, 130, 100, 90, 110, 130 |
| ativo | BOOLEAN | true |

> **Nota:** "Semente de Soja" é cultura separada de "Soja" — SOAL produz sementes certificadas para a Castrolanda, com tratamento diferenciado.

---

### 4.2 ROLES e PERMISSIONS

**O que é:** Controle de acesso baseado em papéis. Definido em código, não em planilha.

**Roles iniciais SOAL:**

| Role | Descrição | Usuários típicos |
|------|-----------|-----------------|
| `admin` | Acesso total | Rodrigo, João |
| `owner` | Dono da organização | Claudio |
| `manager` | Gestor operacional | Tiago |
| `agronomist` | Agrônomo | Alessandro |
| `operator` | Operador de campo/UBG | Josmar, tratoristas |
| `finance` | Financeiro/administrativo | Valentina |
| `viewer` | Somente leitura | Stakeholders externos |

---

### 4.3 PRODUTO_INSUMO — Catálogo Base

**O que é:** Catálogo de todos os insumos utilizados — sementes, fertilizantes, defensivos, combustíveis, peças, etc.

**Categoria:** A (Seed base) + B (Import complementar do Agriwin)

**Fonte:** Agriwin tem um catálogo de produtos existente. Exportar e ajustar para os tipos do nosso sistema.

**Template CSV para complementação manual:** Ver [Seção 12.1](#121-template-produto_insumo)

**Campos obrigatórios na importação:**

| Campo | Tipo | Notas |
|-------|------|-------|
| nome | VARCHAR | Nome comercial do produto |
| tipo | ENUM | Ver lista de 21 tipos (Doc 16) |
| grupo | ENUM | agricola / manutencao / geral |
| unidade_medida | VARCHAR | kg, L, un, sc, t |
| ncm | VARCHAR | Código fiscal (8 dígitos) |
| ativo | BOOLEAN | true |

**Campos opcionais (complementar depois):**

| Campo | Quando preencher |
|-------|-----------------|
| registro_mapa | Defensivos agrícolas — obrigatório por lei |
| classe_toxicologica | Defensivos — ANVISA (I a IV + NC) |
| classe_ambiental | Defensivos — IBAMA (I a IV) |
| dose_minima / dose_maxima | Para receituário agronômico |

> **Nota crítica:** Não copiar a estrutura de produtos do Agriwin. Apenas os nomes e NCMs são úteis. A categorização (tipo, grupo) deve seguir o nosso schema (Doc 16 DDL).

---

## 5. Fase 1 — Sistema e Plataforma

**Executado por:** João (setup) + Rodrigo (usuários)
**Quando:** Imediatamente após Fase 0

---

### 5.1 OWNERS

**O que é:** O dono/contratante da plataforma — Claudio Kugler no caso da SOAL.

**Categoria:** A — Seed (inserido por João no setup)

| Campo | Valor SOAL |
|-------|-----------|
| email | email do Claudio |
| username | claudio.kugler |
| phone | telefone do Claudio |
| status | active |

---

### 5.2 ORGANIZATIONS

**O que é:** A unidade de negócio — "Serra da Onça Agropecuária LTDA".

**Categoria:** A — Seed

| Campo | Valor SOAL |
|-------|-----------|
| owner_id | → Claudio (OWNERS) |
| name | Serra da Onça Agropecuária |
| cnpj | CNPJ da SOAL |
| status | active |

---

### 5.3 SAFRAS

**O que é:** Ciclos agrícolas. Ano fiscal vai de 01/julho a 30/junho.

**Categoria:** A — Seed (setup das safras ativas + históricas relevantes)

| Safra | data_inicio | data_fim | status |
|-------|------------|---------|--------|
| 2024/2025 | 2024-07-01 | 2025-06-30 | encerrada |
| 2025/2026 | 2025-07-01 | 2026-06-30 | ativa |
| 2026/2027 | 2026-07-01 | 2027-06-30 | planejamento |

> **Nota:** Safras históricas anteriores a 2024/2025 — avaliar com João se importar ou deixar como referência externa.

---

### 5.4 USERS

**O que é:** Usuários operacionais do sistema.

**Categoria:** C — Form (Rodrigo cria via admin panel)

**Usuários iniciais SOAL:**

| Nome | Role | Email | Módulos principais |
|------|------|-------|-------------------|
| Claudio Kugler | owner | — | Dashboard, financeiro |
| Tiago | manager | — | Maquinário, operações |
| Valentina | finance | — | Financeiro, NF, contratos |
| Alessandro | agronomist | — | Agricultura, insumos |
| Josmar | operator | — | UBG, balança |
| Rodrigo Kugler | admin | — | Todos |

---

## 6. Fase 2 — Território

**Quando:** Logo após Fase 1 — estas entidades são pré-requisito para quase tudo
**Responsável pela coleta:** Rodrigo (coordena), fontes variadas

---

### 6.1 FAZENDAS

**O que é:** Propriedades rurais físicas da SOAL.

**Categoria:** A — Seed (João cria manualmente com dados do CAR)

**Dados necessários:**

| Campo | Fonte | Notas |
|-------|-------|-------|
| nome | Rodrigo/Claudio | "Fazenda Serra da Onça", etc. |
| cnpj | Valentina / Documentos | CNPJ ou CPF |
| inscricao_estadual | Documentos | |
| car | CAR / INCRA | Código do Cadastro Ambiental Rural |
| nirf | Receita Federal | Número do Imóvel Rural na Receita |
| area_total_ha | CAR / Documentos | Área total em hectares |
| geojson | Arquivo KML/KMZ do CAR | Converter para GeoJSON |
| municipio / uf | Documentos | Cascavel/PR |
| organization_id | → SOAL |  |

> **Ação:** Rodrigo solicita ao Claudio/Valentina os arquivos KML do CAR e os documentos da fazenda. João converte KML → GeoJSON.

---

### 6.2 TALHOES

**O que é:** Subdivisões da fazenda — unidade mínima de operação agrícola.

**Categoria:** B — CSV Import (gerado a partir dos arquivos KML/KMZ do CAR)

**Processo:**
1. Rodrigo solicita arquivos KML/KMZ ao Claudio ou Tiago
2. João roda script de conversão KML → GeoJSON → CSV
3. Rodrigo completa campos de negócio (nome, tipo_solo) no CSV
4. João importa

**Template CSV:** Ver [Seção 12.2](#122-template-talhoes)

| Campo | Fonte | Obrigatoriedade |
|-------|-------|----------------|
| codigo | Tiago (sistema interno) | Obrigatório |
| nome | Tiago/Claudio | Obrigatório |
| area_ha | KML (calculado) | Obrigatório |
| tipo_solo | Alessandro/Claudio | Opcional inicial |
| geojson | Convertido do KML | Obrigatório |
| fazenda_id | → FAZENDAS | Obrigatório |

> **Nota:** SOAL tem ~2.000 ha em produção, divididos em talhões. Quantificar com Tiago no próximo alinhamento.

---

### 6.3 UBG (Unidade de Beneficiamento de Grãos)

**O que é:** A unidade física de recebimento, secagem e armazenamento de grãos. Entidade mãe dos silos.

**Categoria:** C — Form (Rodrigo cadastra manualmente)

| Campo | Valor SOAL |
|-------|-----------|
| nome | UBG Serra da Onça |
| capacidade_total_ton | A confirmar com Josmar/Claudio |
| responsavel | Josmar |
| fazenda_id | → Fazenda principal |

---

### 6.4 SILOS

**O que é:** Estruturas físicas de armazenamento de grãos — dependem da UBG.

**Categoria:** C — Form (Rodrigo cadastra com Josmar)

**SOAL tem:** 7 silos convencionais + 1 silo especial para sementes (a confirmar com Josmar)

**Template de levantamento (preencher com Josmar):**

| Campo | O que perguntar |
|-------|----------------|
| codigo | "Qual o número/código do silo?" |
| capacidade_ton | "Quantas toneladas esse silo aguenta?" |
| tipo | METALICO / ALVENARIA / BAG / SEMENTE |
| localizacao | "Onde fica dentro da propriedade?" |
| ubg_id | → UBG |

---

### 6.5 PARCEIRO_COMERCIAL

**O que é:** Fornecedores, clientes, arrendatários, transportadores, cooperativas.

**Categoria:** B — CSV Import (do Agriwin) + C — Form (novos parceiros)

**Fonte primária:** Agriwin tem cadastro completo de parceiros. Exportar e transformar.

**Template CSV:** Ver [Seção 12.3](#123-template-parceiro_comercial)

**Tipos presentes na SOAL:**
- `fornecedor` — Castrolanda, revendas de insumos, fornecedores de peças
- `cliente` — Castrolanda (compra grãos e sementes), outros compradores
- `arrendador` — Proprietários de terras arrendadas pela SOAL
- `transportador` — Empresas de frete para grãos
- `cooperativa` — Castrolanda (pode ser ambos: fornecedor + cliente)

> **Nota:** Castrolanda aparece como fornecedor (insumos) E como cliente (grãos/sementes). O campo `tipo` aceita múltiplos valores — checar DDL.

---

### 6.6 CONTRATO_ARRENDAMENTO

**O que é:** Contratos de arrendamento de terras (SOAL arrenda áreas adicionais de terceiros).

**Categoria:** C — Form (Valentina digita) ou B — CSV se volume for grande

| Campo | Fonte | Notas |
|-------|-------|-------|
| parceiro_id | → PARCEIRO_COMERCIAL | Arrendador (dono da terra) |
| talhao_id | → TALHOES | Área arrendada |
| numero_contrato | Valentina/Documentos | |
| data_inicio / data_fim | Valentina/Documentos | |
| valor_ha | Valentina/Documentos | R$/ha por safra ou por ano |
| forma_pagamento | Valentina | grãos / dinheiro / saca |
| status | — | ativo / encerrado |

> **Ação:** Rodrigo solicita a Valentina a listagem de todos os contratos de arrendamento ativos e históricos.

---

## 7. Fase 3 — Cadastros Operacionais

**Quando:** Após Fase 2 (precisa de FAZENDAS)
**Responsável:** Rodrigo coleta, Tiago valida (maquinário), Valentina valida (RH)

---

### 7.1 MAQUINAS

**O que é:** Frota de tratores, colheitadeiras, caminhões, pulverizadores, drones, implementos.

**Categoria:** B — CSV Import (planilha do Tiago)

**Ação:** Rodrigo solicita planilha completa de máquinas ao Tiago.

**Template CSV:** Ver [Seção 12.4](#124-template-maquinas)

| Campo | O que confirmar com Tiago |
|-------|--------------------------|
| nome | Nome como o Tiago chama a máquina |
| tipo | TRATOR / COLHEITADEIRA / CAMINHAO / PULVERIZADOR / DRONE / IMPLEMENTO / VEICULO |
| marca / modelo | Marca extraída automaticamente do nome pelo ETL (95% máquinas, 82% implementos). Validar com Tiago os itens sem marca. |
| placa | Veículos com placa |
| numero_serie | Número de série (importante para telemetria futura JD) |
| ano_fabricacao | Documento ou nota fiscal |
| capacidade_tanque_litros | Tiago sabe de cabeça |
| horimetro_inicial | Leitura atual do horímetro no Dia 01 |
| fazenda_id | Onde a máquina está alocada (pode rotacionar) |

> **Nota crítica:** O `horimetro_inicial` é o valor no horímetro no momento do cadastro. Todo abastecimento e manutenção vai referenciar leituras a partir desse valor. Se errar esse dado, os cálculos de custo por hora ficam incorretos.

---

### 7.2 OPERADORES

**O que é:** Pessoas que operam maquinário — tratoristas, motoristas, aplicadores.

**Categoria:** C — Form (Rodrigo cadastra com Tiago)

| Campo | Fonte |
|-------|-------|
| nome | Tiago / RH |
| cpf | RH / Valentina |
| cargo | operador_maquina / motorista / aplicador / operador_balanca / tecnico_agricola |
| cnh_numero / categoria / validade | RH — habilitação |
| status | ativo / inativo |
| organization_id | → SOAL |

> **Nota:** OPERADORES é separado de TRABALHADOR_RURAL porque operadores têm atributos específicos (CNH, habilitação para maquinário pesado). Um operador pode também ser um trabalhador rural.

---

### 7.3 TRABALHADOR_RURAL

**O que é:** Todos os trabalhadores rurais (inclui operadores + tratoristas + auxiliares de campo).

**Categoria:** C — Form ou B — CSV (Valentina tem lista da folha de pagamento)

| Campo | Fonte |
|-------|-------|
| nome | Valentina / RH |
| cpf | RH |
| cargo | texto livre ou enum (a definir) |
| data_admissao | RH |
| tipo_contrato | CLT / temporario / terceirizado |
| fazenda_id | → FAZENDAS |
| status | ativo / inativo |

> **Ação:** Rodrigo solicita a Valentina lista de funcionários ativos com CPF, cargo e data de admissão.

---

### 7.4 CENTRO_CUSTO

**O que é:** Hierarquia de centros de custo para rateio e custeio das operações. Definida em Doc 13.

**Categoria:** A — Seed (João insere a hierarquia definida no Doc 13)

**Hierarquia SOAL (6 níveis):**

```
01              → SOAL (Organização)
 01.01          → Fazenda Serra da Onça
  01.01.2526    → Safra 25/26
   01.01.2526.SOJ    → Cultura: Soja
    01.01.2526.SOJ.T001  → Talhão 001
     01.01.2526.SOJ.T001.MEC  → Tipo custo: Mecanização
```

**Tipos de custo no nível mais profundo:** MEC (mecanização), INS (insumos), MAO (mão de obra), SVC (serviços), DEP (depreciação), ADM (administrativo)

> **Ação:** João cria script seed baseado no Doc 13 para popular a hierarquia completa antes do Dia 01.

---

## 8. Fase 4 — Financeiro Base

**Quando:** Após Fase 2 (precisa de PARCEIRO_COMERCIAL e FAZENDAS)
**Responsável:** Valentina (coleta e formulários), automação SEFAZ (NFs)

---

### 8.1 NOTA_FISCAL

**O que é:** Notas fiscais emitidas e recebidas pela SOAL.

**Categoria:** D — API/Integration (SEFAZ download automático) + B — CSV histórico do Agriwin

**Processo de automação SEFAZ:**
- Agriwin já tem integração SEFAZ funcionando (DFe distribuição)
- Script Python ou N8N faz download do XML das NFs via API SEFAZ
- Parser do XML extrai campos e popula NOTA_FISCAL + NOTA_FISCAL_ITEM automaticamente
- Frequência sugerida: sync diário ou webhook

**Campos extraídos do XML automaticamente:**

| Campo | Origem no XML |
|-------|--------------|
| numero / serie | `nNF / serie` |
| chave_nfe | `chNFe` |
| data_emissao | `dhEmi` |
| valor_total | `vNF` |
| parceiro_id | `CNPJ/CPF` → lookup em PARCEIRO_COMERCIAL |
| cfop | `CFOP` |
| xml_url / pdf_url | Armazenado no S3/storage |

> **Nota:** A questão em aberto "NF é emitida na ORG ou na FAZENDA?" deve ser resolvida com Valentina antes de implementar. Afeta o campo `fazenda_id` na NOTA_FISCAL.

---

### 8.2 NOTA_FISCAL_ITEM

**O que é:** Itens de cada nota fiscal — relaciona NF com PRODUTO_INSUMO.

**Categoria:** E — Auto-calculado (derivado do XML da NF)

| Campo | Origem |
|-------|--------|
| nota_fiscal_id | → NOTA_FISCAL |
| produto_insumo_id | → PRODUTO_INSUMO (via NCM ou nome) |
| descricao | XML `xProd` |
| quantidade | XML `qCom` |
| unidade | XML `uCom` |
| valor_unitario | XML `vUnCom` |
| valor_total | XML `vProd` |

> **Nota:** O match entre `xProd` da NF e o PRODUTO_INSUMO do nosso catálogo vai exigir lógica de fuzzy matching ou tabela de mapeamento. Tarefa técnica para João.

---

### 8.3 CONTA_PAGAR

**O que é:** Contas a pagar — duplicatas, boletos, parcelas de compras.

**Categoria:** B — CSV histórico (do Agriwin) + C — Form (novas contas via Valentina)

**Template CSV para importação histórica do Agriwin:**

| Campo | Tipo | Notas |
|-------|------|-------|
| parceiro_id | UUID | → PARCEIRO_COMERCIAL (match por CNPJ) |
| nota_fiscal_id | UUID | Se vinculada a NF (opcional) |
| documento | VARCHAR | Número do documento/duplicata |
| data_emissao | DATE | |
| data_vencimento | DATE | |
| valor_original | DECIMAL(14,2) | |
| valor_pago | DECIMAL(14,2) | Se já pago |
| data_pagamento | DATE | Se já pago |
| status | ENUM | pendente / pago / vencido / cancelado |
| centro_custo_id | UUID | → CENTRO_CUSTO |
| descricao | TEXT | Histórico |

---

### 8.4 CONTA_RECEBER

**O que é:** Contas a receber — venda de grãos, sementes, outros recebíveis.

**Categoria:** B — CSV histórico (do Agriwin) + C — Form (novos recebíveis)

**Campos similares ao CONTA_PAGAR**, com:
- `data_recebimento` (em vez de `data_pagamento`)
- `valor_recebido` (em vez de `valor_pago`)
- `contrato_comercial_id` → link ao contrato de venda (se houver)

---

### 8.5 CONTRATO_COMERCIAL

**O que é:** Contratos de venda antecipada, fixação de preço, barter, CPR.

**Categoria:** C — Form (Valentina digita) + B — CSV se volume histórico for grande

| Campo | Fonte | Notas |
|-------|-------|-------|
| parceiro_id | → PARCEIRO_COMERCIAL | Comprador (ex: Castrolanda) |
| safra_id | → SAFRAS | Safra de referência |
| tipo | ENUM | venda_antecipada / fixacao / barter / cpf_fisica |
| data_assinatura | Documentos | |
| produto_insumo_id | → PRODUTO_INSUMO | Produto vendido/trocado |
| quantidade_ton | Valentina | |
| preco_unitario | Valentina | R$ ou US$/saca |
| status | — | ativo / liquidado / cancelado |

---

### 8.6 CONTRATO_ENTREGA e CPR_DOCUMENTO

**O que é:** Programações de entrega vinculadas ao contrato comercial. CPR = Cédula de Produto Rural.

**Categoria:** C — Form (Valentina)

| Entidade | Depende de |
|----------|-----------|
| CONTRATO_ENTREGA | CONTRATO_COMERCIAL |
| CPR_DOCUMENTO | CONTRATO_COMERCIAL |

> Campos detalhados a confirmar com Valentina durante levantamento financeiro.

---

## 9. Fase 5 — Planejamento da Safra

**Quando:** Após Fases 0–3 (precisa de TALHOES + SAFRAS + CULTURAS)
**Responsável:** Alessandro + Rodrigo
**Frequência:** Uma vez por safra (anual, início de julho)

---

### 9.1 TALHAO_SAFRA ← ENTIDADE CENTRAL

**O que é:** O cruzamento de talhão × safra × cultura — a entidade que ancora 90% dos relatórios.

**Categoria:** C — Form (Alessandro/Rodrigo preenchem o planejamento da safra)

**Lógica:** Para cada talhão, no início de cada safra, decide-se qual cultura plantar em qual área.

| Campo | O que perguntar a Alessandro |
|-------|------------------------------|
| talhao_id | → TALHOES (qual talhão?) |
| safra_id | → SAFRAS (qual safra?) |
| cultura_id | → CULTURAS (soja? milho?) |
| epoca | safra / safrinha / terceira_safra |
| area_plantada_ha | Pode ser < area do talhão (se plantado parcialmente) |
| cultivar | Variedade especifica (ex: BMX 56IX58) |
| gleba | Sub-area do talhão (ex: HERMATRIA dentro de CAPINZAL) |
| origem_semente | Fonte: Castrolanda / Fazenda / FSI / outro |
| data_plantio_prevista | Estimativa de plantio — ancora para gerar calendario SAFRA_ACAO. Sistema sugere default regional (ver CALENDARIO_AGRICOLA_CAMPOS_GERAIS.md), Alessandro ajusta |
| meta_produtividade_sc_ha | Estimativa de Alessandro baseada em histórico |

> **Nota crítica:** Um talhão pode ter **dois registros TALHAO_SAFRA** na mesma safra se for dividido entre duas culturas (ex: 50ha soja + 30ha milho). Isso é normal — confirmar com Alessandro se acontece na SOAL.

---

### 9.2 ANALISE_SOLO

**O que é:** Laudos de análise de solo por talhão — dados do laboratório.

**Categoria:** B — CSV Import (laudos do laboratório em CSV/Excel) ou C — Form manual

**Fonte:** Alessandro recebe laudos do laboratório (IAPAR, Castrolanda Lab, ou terceiros)

**Template CSV:** Ver [Seção 12.5](#125-template-analise_solo)

| Campo | Unidade | Faixa típica |
|-------|---------|-------------|
| talhao_id | → TALHOES | — |
| data_coleta | DATE | — |
| profundidade_cm | cm | 0-20, 20-40 |
| ph | — | 4.5–7.0 |
| materia_organica | g/dm³ | 10–50 |
| fosforo_p | mg/dm³ | 3–300 |
| potassio_k | cmolc/dm³ | 0.1–0.8 |
| calcio_ca | cmolc/dm³ | 1–10 |
| magnesio_mg | cmolc/dm³ | 0.5–4 |
| aluminio_al | cmolc/dm³ | 0–1 |
| ctc | cmolc/dm³ | 5–25 |
| saturacao_bases_v | % | 40–80 |
| argila_pct | % | 0–100 |
| laboratorio | VARCHAR | Nome do laboratório |
| numero_amostra | VARCHAR | Código da amostra no laudo |

---

### 9.3 RECOMENDACAO_ADUBACAO

**O que é:** Recomendação de adubação gerada a partir da análise de solo por Alessandro.

**Categoria:** C — Form (Alessandro preenche)

| Campo | Notas |
|-------|-------|
| analise_solo_id | → ANALISE_SOLO |
| cultura_id | → CULTURAS (para qual cultura?) |
| n_kg_ha, p2o5_kg_ha, k2o_kg_ha | Doses de N, P, K recomendadas |
| calcario_t_ha | Calagem recomendada |
| gesso_t_ha | Gessagem se necessário |
| observacoes | Notas técnicas do Alessandro |

---

### 9.4 RECEITUARIO_AGRONOMICO

**O que é:** Receituário para aplicação de defensivos — obrigatório por lei (ART do agrônomo).

**Categoria:** C — Form (Alessandro preenche para cada aplicação prescrita)

| Campo | Notas |
|-------|-------|
| produto_insumo_id | → PRODUTO_INSUMO (defensivo) |
| cultura_id | Para qual cultura |
| numero_receita | Número do receituário |
| crea_responsavel | CREA do Alessandro |
| art_numero | Anotação de Responsabilidade Técnica |
| dose_prescrita_por_ha | Dose aprovada |
| carencia_dias | Carência pré-colheita |
| data_prescricao | Data da emissão |
| validade_dias | Validade do receituário |

---

## 10. Fase 6 — Operações Contínuas

**Quando:** A partir do Dia 01 — fluxo diário/semanal
**Responsável:** Varia por módulo (ver tabela abaixo)

---

### 10.1 OPERACAO_CAMPO

**O que é:** Registro de cada operação agrícola realizada — plantio, pulverização, colheita, dessecação, etc.

**Categoria:** C — Form (Tiago registra no sistema) — *JD Operations Center = versão futura*

**Depende de:** TALHAO_SAFRA + MAQUINAS + OPERADORES

| Campo | Quem preenche | Notas |
|-------|--------------|-------|
| talhao_safra_id | Tiago | → TALHAO_SAFRA (qual área?) |
| maquina_id | Tiago | → MAQUINAS (qual máquina?) |
| operador_id | Tiago | → OPERADORES (quem operou?) |
| tipo_operacao | Tiago | ENUM: plantio/colheita/pulverizacao/adubacao/dessecacao/subsolagem/gradagem/transporte/drone/outro |
| data_operacao | Tiago | Data e hora início |
| duracao_horas | Tiago | Horas trabalhadas na operação |
| area_operada_ha | Tiago | Área efetivamente trabalhada |
| horimetro_inicio / fim | Tiago | Leitura do horímetro |
| velocidade_media | Tiago | km/h (se registrado) |
| observacoes | Tiago | Texto livre |

> **Subformulários (1 OPERACAO_CAMPO → 1 detalhe específico):**
> A partir do tipo_operacao, o sistema abre o subformulário correspondente:
> - `plantio` → PLANTIO_DETALHE
> - `colheita` → COLHEITA_DETALHE
> - `pulverizacao` → PULVERIZACAO_DETALHE
> - `drone` → DRONE_DETALHE
> - `transporte` → TRANSPORTE_COLHEITA_DETALHE

---

### 10.2 PLANTIO_DETALHE

**Categoria:** C — Form (subformulário de OPERACAO_CAMPO)

| Campo | Notas |
|-------|-------|
| operacao_campo_id | → OPERACAO_CAMPO |
| populacao_sementes_mil_ha | Sementes por hectare × mil |
| espacamento_cm | Espaçamento entre linhas |
| profundidade_cm | Profundidade de semeadura |
| velocidade_plantio_kmh | |
| umidade_solo_pct | Se medida |

---

### 10.3 COLHEITA_DETALHE

**Categoria:** C — Form (subformulário de OPERACAO_CAMPO)

| Campo | Notas |
|-------|-------|
| operacao_campo_id | → OPERACAO_CAMPO |
| peso_bruto_ton | Total colhido (grão + impureza + umidade) |
| peso_liquido_ton | Após descontos |
| umidade_colheita_pct | % de umidade no momento |
| impureza_pct | % de impureza |
| produtividade_sc_ha | Sacas por hectare (calculado) |

---

### 10.4 PULVERIZACAO_DETALHE

**Categoria:** C — Form (subformulário de OPERACAO_CAMPO)
**Foco:** Dados técnicos da operação (não qual produto — isso fica em APLICACAO_INSUMO)

| Campo | Notas |
|-------|-------|
| operacao_campo_id | → OPERACAO_CAMPO |
| pressao_bar | Pressão de trabalho |
| vazao_lha | Litros por hectare |
| velocidade_kmh | Velocidade de trabalho |
| temperatura_c | Temperatura ambiente |
| umidade_relativa_pct | Umidade do ar |
| vento_kmh | Velocidade do vento |
| horario_inicio / fim | Horário da operação |
| bico_tipo | Tipo de ponta/bico utilizado |

---

### 10.5 COMPRA_INSUMO

**O que é:** Registro de compra de insumos — semente, fertilizante, defensivo, combustível, etc.

**Categoria:** D — API Castrolanda (futuro) + C — Form manual (atual)

**Depende de:** PRODUTO_INSUMO + PARCEIRO_COMERCIAL + SAFRAS

| Campo | Quem preenche | Notas |
|-------|--------------|-------|
| produto_insumo_id | Valentina | → PRODUTO_INSUMO |
| parceiro_id | Valentina | → PARCEIRO_COMERCIAL (quem vendeu) |
| safra_id | Valentina | → SAFRAS |
| nota_fiscal_item_id | Sistema | → linkado automaticamente via NF |
| quantidade | Valentina | Em unidade do produto |
| valor_unitario | Valentina | Preço pago por unidade |
| data_compra | Valentina | |
| fonte | Valentina | castrolanda / revenda / direto_fabrica / barter / producao_propria |
| local_entrega | Valentina | Onde o insumo foi entregue |

> **Nota:** Ao registrar uma COMPRA_INSUMO, o sistema automaticamente cria uma MOVIMENTACAO_INSUMO (entrada) e atualiza o ESTOQUE_INSUMO com custo médio ponderado (ver Doc 16 DDL função `fn_entrada_compra_estoque`).

---

### 10.6 ABASTECIMENTOS

**O que é:** Registros de abastecimento de combustível das máquinas.

**Categoria:** D — API/Crawler Vestro

**Processo Vestro:**
1. Script Python faz login no portal Vestro periodicamente (semanal ou diário)
2. Faz download do relatório de abastecimentos em CSV
3. Parser mapeia campos Vestro → nosso schema
4. Insere em ABASTECIMENTOS fazendo match de máquina por placa/série

**Campos extraídos do Vestro:**

| Nosso campo | Campo Vestro |
|-------------|-------------|
| maquina_id | Match por placa/serie → MAQUINAS |
| operador_id | Match por nome/CPF → OPERADORES |
| data_abastecimento | Data/hora do posto |
| litros | Litros abastecidos |
| horimetro | Leitura do horímetro |
| custo_por_litro | Preço por litro |

> **Ação técnica (João):** Auditar o portal Vestro — verificar se tem API oficial, se exporta CSV, ou se precisa de crawler.

---

### 10.7 MANUTENCOES

**O que é:** Registros de manutenções realizadas nas máquinas.

**Categoria:** C — Form (Tiago registra)

**Depende de:** MAQUINAS + OPERADORES + CENTRO_CUSTO

| Campo | O que Tiago preenche |
|-------|---------------------|
| maquina_id | → MAQUINAS |
| operador_id | → OPERADORES (quem fez) |
| tipo | PREVENTIVA / CORRETIVA / REVISAO |
| descricao | O que foi feito |
| data_realizacao | Quando |
| horimetro | Leitura no momento |
| custo_total | Valor total gasto |
| nota_fiscal_id | NF da peça/serviço (se houver) |
| centro_custo_id | → CENTRO_CUSTO |
| km_horimetro_proxima | Quando deve fazer próxima manutenção |

---

### 10.8 TICKET_BALANCA — PONTO CRÍTICO DE DIGITALIZAÇÃO

**O que é:** Registro de entrada de carga na balança da UBG — cada caminhão que entra.

**Categoria:** C — Form (app mobile Josmar — PRIORIDADE MÁXIMA)

**Contexto:** Josmar atualmente escreve no caderno. Cada linha do caderno = um TICKET_BALANCA. Este é o ponto de maior risco de perda de dados da operação.

**Design do formulário (Operator POV — mãos sujas, tablet):**
- Botões grandes, poucos campos por tela
- Auto-fill onde possível (ex: UBG = sempre a mesma)
- Teclado numérico para pesos

| Campo | UI no formulário | Notas |
|-------|----------------|-------|
| ubg_id | Auto (único) | |
| operador_id | Dropdown (Josmar logado) | Auto-fill |
| data_entrada | Auto (hora atual) | Confirmar |
| placa_veiculo | Input texto | Placa do caminhão |
| motorista_nome | Input texto | Nome do motorista |
| peso_bruto_ton | Numérico grande | Peso com carga |
| peso_tara_ton | Numérico grande | Peso do veículo vazio |
| peso_liquido_ton | Auto-calculado | bruto − tara |
| talhao_safra_id | Dropdown filtrado | De qual talhão veio |
| operacao_campo_id | Dropdown | Vinculado à colheita do dia |

---

### 10.9 RECEBIMENTO_GRAO

**O que é:** Classificação do grão recebido — umidade, impureza, peneira. Criado após o TICKET_BALANCA.

**Categoria:** C — Form (Josmar, subformulário do Ticket)

| Campo | Notas |
|-------|-------|
| ticket_balanca_id | → TICKET_BALANCA |
| talhao_safra_id | → TALHAO_SAFRA (rastreabilidade) |
| umidade_pct | % umidade |
| impureza_pct | % impureza |
| avariados_pct | % grãos avariados |
| esverdeados_pct | % grãos esverdeados |
| quebrados_pct | % grãos quebrados |
| nota_classificacao | Nota final (desconto Castrolanda) |

---

### 10.10 CONTROLE_SECAGEM

**O que é:** Registro do processo de secagem do grão no secador.

**Categoria:** C — Form (Josmar)

| Campo | Notas |
|-------|-------|
| recebimento_grao_id | → RECEBIMENTO_GRAO |
| umidade_entrada_pct | Antes de secar |
| umidade_saida_pct | Após secar (alvo: 13%) |
| temperatura_ar_c | Temperatura do ar de secagem |
| duracao_horas | Tempo no secador |
| consumo_lenha_kg | Lenha consumida (UBG usa lenha de eucalipto) |
| operador_id | → OPERADORES (Josmar) |

> **Nota:** O consumo de lenha deve ser vinculado ao ESTOQUE_INSUMO de lenha (LENHA é um PRODUTO_INSUMO do tipo LENHA). Cada secagem = uma saída de estoque de lenha.

---

### 10.11 SAIDA_GRAO

**O que é:** Saída de grão do silo — venda, transferência, uso interno.

**Categoria:** C — Form (Josmar/Valentina)

| Campo | Notas |
|-------|-------|
| estoque_silo_id | → ESTOQUE_SILO (de qual silo) |
| parceiro_id | → PARCEIRO_COMERCIAL (para quem) |
| nota_fiscal_id | NF de saída (se emitida) |
| operador_id | → OPERADORES |
| quantidade_ton | |
| data_saida | |
| tipo_saida | venda / transferencia / consumo_interno / amostra |
| destino | Texto livre (armazém destino, etc.) |

---

### 10.12 APONTAMENTO_MAO_OBRA

**O que é:** Registro de horas trabalhadas por trabalhador rural em cada operação/centro de custo.

**Categoria:** C — Form (Valentina ou supervisor de campo)

| Campo | Notas |
|-------|-------|
| trabalhador_rural_id | → TRABALHADOR_RURAL |
| centro_custo_id | → CENTRO_CUSTO (onde foi alocado) |
| data | Data do apontamento |
| horas_trabalhadas | Horas normais |
| horas_extras | Horas extras |
| atividade | Texto livre (o que foi feito) |

---

## 11. Fase 7 — Auto-Calculado

Estas entidades **não exigem coleta** — são geradas automaticamente por triggers e funções do banco.

| Entidade | Gatilho | Lógica |
|----------|---------|--------|
| MOVIMENTACAO_INSUMO | INSERT em COMPRA_INSUMO ou APLICACAO_INSUMO | Append-only ledger de todas as movimentações |
| ESTOQUE_INSUMO | Trigger em MOVIMENTACAO_INSUMO | Posição atual = soma de entradas − saídas; custo médio ponderado |
| APLICACAO_INSUMO | INSERT em OPERACAO_CAMPO (se houver insumos) | Derivado dos insumos aplicados na operação |
| MOVIMENTACAO_SILO | INSERT em RECEBIMENTO_GRAO ou SAIDA_GRAO | Rastro de todas as movimentações de grão |
| ESTOQUE_SILO | Trigger em MOVIMENTACAO_SILO | Posição atual por silo por cultura |
| CUSTO_OPERACAO | Trigger em OPERACAO_CAMPO | Custo calculado por ha baseado em insumos + combustível + mão de obra |

---

## 12. Templates CSV

### 12.1 Template: PRODUTO_INSUMO

```csv
nome,tipo,grupo,unidade_medida,ncm,registro_mapa,classe_toxicologica,dose_minima,dose_maxima,ativo
Uréia 46% N,FERTILIZANTE_MINERAL,agricola,kg,3102100090,,,,,true
Glifosato 480g/L,HERBICIDA,agricola,L,3808930090,BR12345,III,1.5,4.0,true
Sementes Soja TMG 7062 IPRO,SEMENTE,agricola,kg,1201100090,,,35,55,true
Óleo Diesel S10,COMBUSTIVEL,manutencao,L,2710192100,,,,,true
Filtro de Óleo,PECA_MANUTENCAO,manutencao,un,8421231000,,,,,true
Lenha Eucalipto,LENHA,geral,kg,4401120090,,,,,true
```

### 12.2 Template: TALHOES

```csv
codigo,nome,area_ha,tipo_solo,fazenda_codigo,geojson
T001,Talhão Norte,85.5,LATOSSOLO_VERMELHO,SOAL_01,"{""type"":""Polygon"",""coordinates"":[[...]]}"
T002,Talhão Sul,62.3,LATOSSOLO_VERMELHO_AMARELO,SOAL_01,"{""type"":""Polygon"",""coordinates"":[[...]]}"
```

> **Nota:** A coluna `geojson` é gerada automaticamente a partir do KML. Rodrigo preenche apenas `codigo`, `nome` e `tipo_solo`.

### 12.3 Template: PARCEIRO_COMERCIAL

```csv
razao_social,cnpj_cpf,tipo,email,telefone,inscricao_estadual,municipio,uf
Cooperativa Castrolanda,75049579000150,cooperativa,contato@castrolanda.com.br,(42)3220-0000,PR-123456,Castro,PR
Reaguil Distribuidora Agrícola,12345678000190,fornecedor,compras@reaguil.com.br,,PR-789012,Cascavel,PR
João da Silva - Arrendamento,12345678910,arrendador,,,,,
```

### 12.4 Template: MAQUINAS

```csv
nome,tipo,marca,modelo,placa,numero_serie,ano_fabricacao,capacidade_tanque_litros,horimetro_inicial,fazenda_codigo,status
John Deere 8R 310,TRATOR,John Deere,8R 310,,1RW8R310XPA123456,2021,680,12450,SOAL_01,ativo
New Holland TC5.90,COLHEITADEIRA,New Holland,TC5.90,,YGN111111,2019,450,8200,SOAL_01,ativo
Volkswagen Constellation 24.280,CAMINHAO,Volkswagen,24.280,ABC1D23,,2020,300,0,SOAL_01,ativo
Jacto Uniport 3030,PULVERIZADOR,Jacto,Uniport 3030,,JACTO12345,2022,2000,1500,SOAL_01,ativo
```

> **Instrução para Tiago:** Preencher uma linha por máquina. O campo `horimetro_inicial` deve ser lido **no dia da virada para o sistema** (Dia 01). Se a máquina não tem horímetro (ex: implemento), deixar 0.

### 12.5 Template: ANALISE_SOLO

```csv
talhao_codigo,data_coleta,profundidade_cm,ph,materia_organica,fosforo_p,potassio_k,calcio_ca,magnesio_mg,aluminio_al,ctc,saturacao_bases_v,argila_pct,laboratorio,numero_amostra
T001,2025-08-15,0-20,6.2,38,18.5,0.45,5.2,1.8,0.0,14.2,73.5,62,IAPAR,2025-T001-A
T001,2025-08-15,20-40,5.8,22,8.2,0.32,3.8,1.2,0.2,11.8,61.0,68,IAPAR,2025-T001-B
T002,2025-08-15,0-20,6.0,35,22.1,0.38,4.9,1.6,0.0,13.5,71.2,58,IAPAR,2025-T002-A
```

---

## 13. Checklist de Prontidão ("Dia 01")

Para que o sistema esteja pronto para operar no Dia 01, os seguintes itens precisam estar completos:

### Semana -4 (João executa)
- [ ] Seed: CULTURAS populada
- [ ] Seed: ROLES e PERMISSIONS configurados
- [ ] Seed: OWNERS e ORGANIZATIONS criados (SOAL)
- [ ] Seed: SAFRAS criadas (24/25, 25/26, 26/27)
- [ ] DDL: Todos os outros módulos além do insumos (Doc 16 já tem insumos)

### Semana -3 (Rodrigo coleta, João importa)
- [ ] Obtido arquivos KML/KMZ dos talhões com Tiago/Claudio
- [ ] CSV TALHOES gerado (KML→GeoJSON + nome + tipo_solo)
- [ ] Import TALHOES executado
- [ ] CSV PARCEIRO_COMERCIAL exportado do Agriwin e revisado
- [ ] Import PARCEIRO_COMERCIAL executado
- [ ] FAZENDAS cadastradas manualmente (dados do CAR + CNPJ)

### Semana -2 (Rodrigo coleta, João importa)
- [ ] CSV PRODUTO_INSUMO base gerado (export Agriwin + manual)
- [ ] Import PRODUTO_INSUMO executado
- [ ] CSV MAQUINAS preenchido por Tiago (com horímetro atual)
- [ ] Import MAQUINAS executado
- [ ] OPERADORES cadastrados (form admin)
- [ ] TRABALHADOR_RURAL importado (lista Valentina)
- [ ] CENTRO_CUSTO hierarquia populada (seed João baseado em Doc 13)
- [ ] UBG e SILOS cadastrados manualmente (com Josmar)

### Semana -1 (Rodrigo + time)
- [ ] USERS criados para todos os operadores (Tiago, Josmar, Valentina, Alessandro)
- [ ] TALHAO_SAFRA planejamento 25/26 preenchido (Alessandro)
- [ ] PARCEIROS: Contratos de arrendamento cadastrados (Valentina)
- [ ] CONTRATO_COMERCIAL: Contratos ativos de venda cadastrados (Valentina)
- [ ] Setup da automação SEFAZ (download de NFs) testado
- [ ] Setup do crawler Vestro testado (abastecimentos)
- [ ] Treinamento Josmar: app UBG (TICKET_BALANCA)
- [ ] Treinamento Tiago: form OPERACAO_CAMPO
- [ ] Treinamento Valentina: form financeiro

### Dia 01
- [ ] Josmar começa a registrar todos os TICKET_BALANCA no sistema
- [ ] Tiago começa a registrar todas as OPERACAO_CAMPO no sistema
- [ ] Valentina começa a registrar COMPRA_INSUMO e CONTA_PAGAR no sistema
- [ ] Alessandro cadastra ANALISE_SOLO da safra atual
- [ ] Sistema rodando em produção

---

## Questões Abertas que Bloqueiam o Plano

| # | Questão | Impacto | Responsável |
|---|---------|---------|-------------|
| 1 | NF é emitida na ORG ou na FAZENDA? | Estrutura FK da NOTA_FISCAL | Valentina + Claudio |
| 2 | Quantos talhões tem a SOAL atualmente? | Escopo da importação | Tiago |
| 3 | Vestro tem API ou só portal web? | Método de extração abastecimentos | João auditar |
| 4 | Castrolanda consegue exportar CSV do histórico de compras? | Import COMPRA_INSUMO histórico | Rodrigo perguntar |
| 5 | Josmar tem tablet disponível? Qual modelo? | Design do app UBG (iOS/Android/Web) | Rodrigo verificar |
| 6 | Quais são todos os silos (código, capacidade, tipo)? | Cadastro SILOS | Josmar + Claudio |
| 7 | SOAL tem funcionários terceirizados? | Estrutura TRABALHADOR_RURAL | Valentina |
| 8 | Alessandro emite receituário para TODAS as aplicações ou só defensivos? | Completude RECEITUARIO_AGRONOMICO | Alessandro |

---

**Versão:** 1.0
**Criado:** 2026-02-26
**Autor:** Rodrigo Kugler + DeepWork AI Flows
**Próximo:** `25_AGENTE_COLETA_DADOS.md` — agente especializado para guiar o processo entidade por entidade
