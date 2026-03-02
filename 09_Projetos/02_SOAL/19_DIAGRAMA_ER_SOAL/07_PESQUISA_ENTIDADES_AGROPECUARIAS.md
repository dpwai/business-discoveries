# Pesquisa: Entidades para Sistemas Agropecuarios

**Data:** 06/02/2026
**Autor:** Rodrigo Kugler + Claude (DeepWork AI Flows)
**Objetivo:** Identificar gaps e oportunidades de melhoria no modelo ER do SOAL
**Status:** Documento de contexto para decisao

---

## 1. Resumo Executivo

Esta pesquisa analisou sistemas de gestao agropecuaria de referencia (TOTVS Agro, Aegro, sistemas internacionais) para identificar:

1. **Entidades que podem estar faltando** no modelo atual do SOAL
2. **Entidades que talvez nao facam sentido** na pratica
3. **Padroes de mercado** a considerar

**Resultado:** Identificadas 13 entidades potencialmente faltantes e 7 entidades para revisao.

---

## 2. Entidades Potencialmente Faltantes

### 2.1 Modulo Agricola

#### RECEITUARIO_AGRONOMICO

**Prioridade:** ALTA (Obrigatorio por lei)

```
RECEITUARIO_AGRONOMICO
├── receituario_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── numero (VARCHAR 50)
├── data_emissao (DATE)
├── profissional_nome (VARCHAR 200)
├── profissional_crea (VARCHAR 20)
├── art_numero (VARCHAR 50)
├── cultura_id (FK -> CULTURAS)
├── talhao_id (FK -> TALHOES)
├── area_tratada_ha (DECIMAL 10,2)
├── praga_alvo (VARCHAR 200)
├── produto_comercial (VARCHAR 200)
├── principio_ativo (VARCHAR 200)
├── dosagem (DECIMAL 10,4)
├── unidade_dosagem (VARCHAR 20)
├── volume_calda_lha (DECIMAL 10,2)
├── modo_aplicacao (VARCHAR 100)
├── intervalo_seguranca_dias (INT)
├── intervalo_reentrada_horas (INT)
├── epi_obrigatorio (TEXT)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Justificativa:**
- Portaria MAPA 805/2025 torna rastreabilidade de defensivos obrigatoria
- Vincula profissional habilitado (CREA) com aplicacao
- Base para compliance e auditorias

**Fontes:**
- https://www.totvs.com/blog/gestao-agricola/receituario-agronomico/
- https://agroreceita.com.br/rastreabilidade-de-defensivos/

---

#### ANALISE_SOLO

**Prioridade:** ALTA (Base para adubacao)

```
ANALISE_SOLO
├── analise_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── talhao_id (FK -> TALHOES)
├── laboratorio (VARCHAR 200)
├── numero_laudo (VARCHAR 50)
├── data_coleta (DATE)
├── data_resultado (DATE)
├── profundidade_cm (VARCHAR 20)
├── ph_agua (DECIMAL 4,2)
├── ph_cacl2 (DECIMAL 4,2)
├── materia_organica_percent (DECIMAL 5,2)
├── fosforo_p_mgdm3 (DECIMAL 8,2)
├── potassio_k_mgdm3 (DECIMAL 8,2)
├── calcio_ca_cmolcdm3 (DECIMAL 6,2)
├── magnesio_mg_cmolcdm3 (DECIMAL 6,2)
├── aluminio_al_cmolcdm3 (DECIMAL 6,2)
├── hidrogenio_al_cmolcdm3 (DECIMAL 6,2)
├── ctc_cmolcdm3 (DECIMAL 6,2)
├── saturacao_bases_percent (DECIMAL 5,2)
├── enxofre_s_mgdm3 (DECIMAL 8,2)
├── boro_b_mgdm3 (DECIMAL 6,3)
├── cobre_cu_mgdm3 (DECIMAL 6,3)
├── ferro_fe_mgdm3 (DECIMAL 8,2)
├── manganes_mn_mgdm3 (DECIMAL 8,2)
├── zinco_zn_mgdm3 (DECIMAL 6,3)
├── textura (VARCHAR 50)
├── argila_percent (DECIMAL 5,2)
├── arquivo_laudo_url (VARCHAR 500)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Justificativa:**
- Base cientifica para recomendacao de adubacao
- Permite rastrear historico de fertilidade por talhao
- Correlaciona com produtividade

**Fontes:**
- https://soiltestfrst.org/
- https://acsess.onlinelibrary.wiley.com/doi/full/10.1002/ael2.70016

---

#### RECOMENDACAO_ADUBACAO

**Prioridade:** MEDIA

```
RECOMENDACAO_ADUBACAO
├── recomendacao_id (PK, UUID)
├── analise_solo_id (FK -> ANALISE_SOLO)
├── talhao_id (FK -> TALHOES)
├── safra_id (FK -> SAFRAS)
├── cultura_id (FK -> CULTURAS)
├── produtividade_esperada_kgha (DECIMAL 10,2)
├── nitrogenio_n_kgha (DECIMAL 8,2)
├── fosforo_p2o5_kgha (DECIMAL 8,2)
├── potassio_k2o_kgha (DECIMAL 8,2)
├── calcario_tnha (DECIMAL 8,2)
├── gesso_kgha (DECIMAL 8,2)
├── enxofre_s_kgha (DECIMAL 8,2)
├── micronutrientes (JSONB)
├── responsavel_tecnico (VARCHAR 200)
├── data_recomendacao (DATE)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

#### CONTRATO_ARRENDAMENTO

**Prioridade:** ALTA (Impacta custo fixo)

```
CONTRATO_ARRENDAMENTO
├── contrato_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── fazenda_id (FK -> FAZENDAS)
├── tipo (ENUM: arrendamento/parceria/comodato)
├── proprietario_nome (VARCHAR 200)
├── proprietario_cpf_cnpj (VARCHAR 20)
├── area_total_ha (DECIMAL 10,2)
├── data_inicio (DATE)
├── data_fim (DATE)
├── valor_por_ha_ano (DECIMAL 12,2)
├── valor_total_ano (DECIMAL 14,2)
├── forma_pagamento (ENUM: fixo_dinheiro/sacas_produto/percentual_producao)
├── quantidade_sacas_ha (DECIMAL 8,2)
├── percentual_producao (DECIMAL 5,2)
├── cultura_referencia (VARCHAR 50)
├── indice_reajuste (VARCHAR 50)
├── dia_vencimento (INT)
├── observacoes (TEXT)
├── arquivo_contrato_url (VARCHAR 500)
├── status (ENUM: ativo/encerrado/renovacao_pendente)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Justificativa:**
- Estatuto da Terra (Lei 4.504/64) regula contratos agrarios
- Diferenca entre arrendamento (valor fixo) e parceria (risco compartilhado)
- Impacta diretamente custo de producao por hectare

**Fontes:**
- https://aegro.com.br/blog/arrendamento-rural/
- https://www.totvs.com/blog/gestao-agricola/contrato-de-parceria-rural-como-funciona-e-como-fazer/

---

#### ESTACAO_METEOROLOGICA

**Prioridade:** MEDIA (IoT/Precisao)

```
ESTACAO_METEOROLOGICA
├── estacao_id (PK, UUID)
├── fazenda_id (FK -> FAZENDAS)
├── nome (VARCHAR 100)
├── codigo (VARCHAR 50)
├── fabricante (VARCHAR 100)
├── modelo (VARCHAR 100)
├── latitude (DECIMAL 10,7)
├── longitude (DECIMAL 10,7)
├── altitude_m (DECIMAL 6,2)
├── data_instalacao (DATE)
├── intervalo_leitura_min (INT)
├── sensores_disponiveis (JSONB)
├── status (ENUM: ativo/manutencao/inativo)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

#### LEITURA_CLIMATICA

**Prioridade:** MEDIA (Time-series)

```
LEITURA_CLIMATICA
├── leitura_id (PK, UUID)
├── estacao_id (FK -> ESTACAO_METEOROLOGICA)
├── data_hora (TIMESTAMP)
├── temperatura_c (DECIMAL 5,2)
├── temperatura_min_c (DECIMAL 5,2)
├── temperatura_max_c (DECIMAL 5,2)
├── umidade_relativa_percent (DECIMAL 5,2)
├── precipitacao_mm (DECIMAL 8,2)
├── velocidade_vento_kmh (DECIMAL 6,2)
├── direcao_vento_graus (INT)
├── radiacao_solar_wm2 (DECIMAL 8,2)
├── pressao_atmosferica_hpa (DECIMAL 7,2)
├── ponto_orvalho_c (DECIMAL 5,2)
├── evapotranspiracao_mm (DECIMAL 6,2)
├── molhamento_foliar_min (INT)
├── created_at (TIMESTAMP)
```

**Nota:** Considerar particao por mes/ano para performance.

**Fontes:**
- https://rynanagriculture.com/smart-weather-station
- https://aws.amazon.com/solutions/guidance/building-an-agricultural-sensor-network-using-iot-and-amazon-documentdb/

---

#### TRABALHADOR_RURAL

**Prioridade:** MEDIA

```
TRABALHADOR_RURAL
├── trabalhador_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR 200)
├── cpf (VARCHAR 14)
├── data_nascimento (DATE)
├── telefone (VARCHAR 20)
├── endereco (VARCHAR 300)
├── tipo (ENUM: mensalista/diarista/safrista/terceirizado)
├── funcao (VARCHAR 100)
├── data_admissao (DATE)
├── data_demissao (DATE)
├── salario_base (DECIMAL 12,2)
├── valor_diaria (DECIMAL 10,2)
├── ctps (VARCHAR 20)
├── pis (VARCHAR 20)
├── status (ENUM: ativo/inativo/ferias/afastado)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Diferenca de OPERADOR:**
- OPERADOR = quem opera maquina (pode ser trabalhador ou terceiro)
- TRABALHADOR_RURAL = funcionario com vinculo (CLT, diarista, etc.)

---

#### APONTAMENTO_MAO_OBRA

**Prioridade:** MEDIA

```
APONTAMENTO_MAO_OBRA
├── apontamento_id (PK, UUID)
├── trabalhador_id (FK -> TRABALHADOR_RURAL)
├── talhao_id (FK -> TALHOES)
├── safra_id (FK -> SAFRAS)
├── data (DATE)
├── hora_inicio (TIME)
├── hora_fim (TIME)
├── horas_trabalhadas (DECIMAL 5,2)
├── atividade (VARCHAR 200)
├── tipo_atividade (ENUM: plantio/aplicacao/colheita/manutencao/outros)
├── quantidade_realizada (DECIMAL 10,2)
├── unidade_quantidade (VARCHAR 20)
├── valor_hora (DECIMAL 10,2)
├── valor_total (DECIMAL 12,2)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
```

**Fontes:**
- https://www.fieldclock.com/
- https://www.spaceag.co/en/workers

---

#### CONTRATO_COMERCIAL

**Prioridade:** ALTA (Gestao de risco)

```
CONTRATO_COMERCIAL
├── contrato_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── numero_contrato (VARCHAR 50)
├── tipo (ENUM: venda_futura/barter/hedge/spot)
├── contraparte (VARCHAR 200)
├── contraparte_cnpj (VARCHAR 20)
├── cultura_id (FK -> CULTURAS)
├── safra_id (FK -> SAFRAS)
├── quantidade_sacas (DECIMAL 12,2)
├── preco_saca (DECIMAL 12,4)
├── valor_total (DECIMAL 14,2)
├── moeda (ENUM: BRL/USD)
├── cotacao_dolar (DECIMAL 8,4)
├── data_contrato (DATE)
├── data_entrega_inicio (DATE)
├── data_entrega_fim (DATE)
├── local_entrega (VARCHAR 200)
├── incoterm (VARCHAR 10)
├── penalidade_nao_entrega_percent (DECIMAL 5,2)
├── status (ENUM: ativo/executado/cancelado/parcial)
├── quantidade_entregue (DECIMAL 12,2)
├── observacoes (TEXT)
├── arquivo_contrato_url (VARCHAR 500)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Tipos de contrato:**
- **Venda Futura:** Preco fixo para entrega futura
- **Barter:** Troca insumos por producao
- **Hedge:** Protecao via derivativos (B3/CBOT)

**Fontes:**
- https://www.cmegroup.com/markets/agriculture.html
- https://www.ice.com/agriculture

---

### 2.2 Modulo Pecuaria

#### DIETA

**Prioridade:** ALTA (Confinamento)

```
DIETA
├── dieta_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR 100)
├── codigo (VARCHAR 50)
├── tipo_animal (ENUM: recria/terminacao/cria/reproducao)
├── categoria_animal_id (FK -> CATEGORIA_ANIMAL)
├── peso_vivo_min_kg (DECIMAL 8,2)
├── peso_vivo_max_kg (DECIMAL 8,2)
├── materia_seca_percent (DECIMAL 5,2)
├── proteina_bruta_percent (DECIMAL 5,2)
├── energia_metabolizavel_mcalkg (DECIMAL 6,3)
├── fibra_ndf_percent (DECIMAL 5,2)
├── concentrado_percent (DECIMAL 5,2)
├── volumoso_percent (DECIMAL 5,2)
├── consumo_esperado_pv_percent (DECIMAL 5,2)
├── gmd_esperado_kg (DECIMAL 5,3)
├── custo_kg_ms (DECIMAL 10,4)
├── ingredientes (JSONB)
├── status (ENUM: ativa/inativa)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**JSONB ingredientes:**
```json
[
  {"ingrediente": "Milho grão", "percent_ms": 45.0, "kg_por_cab": 4.5},
  {"ingrediente": "Farelo soja", "percent_ms": 15.0, "kg_por_cab": 1.5},
  {"ingrediente": "Silagem milho", "percent_ms": 35.0, "kg_por_cab": 12.0},
  {"ingrediente": "Nucleo mineral", "percent_ms": 5.0, "kg_por_cab": 0.5}
]
```

---

#### TRATO_ALIMENTAR

**Prioridade:** ALTA (Confinamento)

```
TRATO_ALIMENTAR
├── trato_id (PK, UUID)
├── lote_id (FK -> LOTE)
├── dieta_id (FK -> DIETA)
├── data (DATE)
├── numero_trato (INT)
├── horario (TIME)
├── quantidade_cabecas (INT)
├── quantidade_fornecida_kg (DECIMAL 10,2)
├── quantidade_sobra_kg (DECIMAL 10,2)
├── consumo_real_kg (DECIMAL 10,2)
├── consumo_por_cabeca_kg (DECIMAL 8,3)
├── responsavel_id (FK -> USERS)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
```

**Fontes:**
- https://www.scielo.br/j/asas/a/m8Zywthv3rcZZX5j47gwd7r/?lang=en
- https://ojs.pubvet.com.br/index.php/revista/article/download/3758/3685/1857

---

#### CERTIFICADORA

**Prioridade:** MEDIA (SISBOV)

```
CERTIFICADORA
├── certificadora_id (PK, UUID)
├── nome (VARCHAR 200)
├── cnpj (VARCHAR 20)
├── codigo_mapa (VARCHAR 20)
├── endereco (VARCHAR 300)
├── telefone (VARCHAR 20)
├── email (VARCHAR 200)
├── status (ENUM: ativa/suspensa/inativa)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Justificativa:**
- SISBOV exige certificadora credenciada pelo MAPA
- Vincula animal com certificadora responsavel

**Fontes:**
- https://www.qima.com/food/sustainable/sisbov
- https://www.brazilianfarmers.com/discover/beef/do-you-know-where-your-beef-comes-from-brazil-will-tell-you/

---

### 2.3 Modulo Financeiro

#### CENTRO_CUSTO

**Prioridade:** ALTA

```
CENTRO_CUSTO
├── centro_custo_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── parent_id (FK -> CENTRO_CUSTO)
├── codigo (VARCHAR 50)
├── nome (VARCHAR 200)
├── tipo (ENUM: fazenda/talhao/cultura/atividade/administrativo)
├── nivel (INT)
├── fazenda_id (FK -> FAZENDAS)
├── talhao_id (FK -> TALHOES)
├── cultura_id (FK -> CULTURAS)
├── is_active (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Hierarquia exemplo:**
```
001 - Fazenda SOAL
├── 001.01 - Talhao A1
│   ├── 001.01.01 - Soja 24/25
│   └── 001.01.02 - Milho Safrinha 25
├── 001.02 - Talhao A2
└── 001.99 - Administrativo
```

---

#### ORCAMENTO

**Prioridade:** MEDIA (Planejado vs Realizado)

```
ORCAMENTO
├── orcamento_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── safra_id (FK -> SAFRAS)
├── centro_custo_id (FK -> CENTRO_CUSTO)
├── categoria_custo_id (FK -> CATEGORIA_CUSTO)
├── descricao (VARCHAR 200)
├── valor_orcado (DECIMAL 14,2)
├── valor_realizado (DECIMAL 14,2)
├── variacao_percent (DECIMAL 6,2)
├── mes_referencia (INT)
├── ano_referencia (INT)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 3. Entidades para Revisao

### 3.1 PROJECAO_VENDAS

**Situacao atual:** Entidade separada com campos manuais.

**Questionamento:** E realmente uma entidade ou um relatorio calculado?

**Analise:**
- Se for apenas `area × produtividade_esperada × preco`, pode ser VIEW
- Se tiver inputs manuais de expectativa do produtor, manter como entidade

**Recomendacao:** Manter se houver cenarios (otimista/pessimista/realista) ou inputs manuais.

---

### 3.2 INSUMOS_CASTROLANDA

**Situacao atual:** Entidade especifica para um fornecedor.

**Questionamento:** Muito acoplada a um sistema externo.

**Recomendacao:** Generalizar para `COMPRA_INSUMO` com campo `fonte = castrolanda/outras`.

---

### 3.3 MOVIMENTACAO_SILO

**Situacao atual:** Registra transferencias entre silos.

**Questionamento:** Pode ser redundante se ENTRADA/SAIDA ja capturam tudo.

**Analise:**
- Faz sentido para transferencia interna (silo A → silo B sem sair da fazenda)
- Secagem tambem pode ser "movimentacao" (silo umido → secador → silo seco)

**Recomendacao:** Manter, mas adicionar `tipo = transferencia/secagem/aeracao`.

---

### 3.4 DESTINO

**Situacao atual:** Entidade separada para clientes/cooperativas.

**Questionamento:** Sobrepoe com FORNECEDOR?

**Recomendacao:** Unificar em `PARCEIRO_COMERCIAL` com `tipo = cliente/fornecedor/cooperativa`.

```
PARCEIRO_COMERCIAL
├── parceiro_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── tipo (ENUM: cliente/fornecedor/cooperativa/transportadora)
├── razao_social (VARCHAR 200)
├── nome_fantasia (VARCHAR 200)
├── cnpj (VARCHAR 20)
├── inscricao_estadual (VARCHAR 20)
├── endereco (VARCHAR 300)
├── cidade (VARCHAR 100)
├── uf (CHAR 2)
├── cep (VARCHAR 10)
├── telefone (VARCHAR 20)
├── email (VARCHAR 200)
├── contato_nome (VARCHAR 200)
├── is_active (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

### 3.5 APARTACAO (Pecuaria)

**Situacao atual:** Entidade separada para separacao de animais.

**Questionamento:** Pode ser tipo de MOVIMENTACAO_ANIMAL.

**Analise:**
- Apartacao tem criterios especificos (peso, sexo, categoria)
- Gera multiplos destinos (varios lotes)
- Tem campos proprios (peso_min, peso_max, quantidade_separada)

**Recomendacao:** Manter separada - tem complexidade propria.

---

### 3.6 ROLE_PERMISSION (RBAC)

**Situacao atual:** Tabela N:N entre Role e Permission.

**Questionamento:** Muitos registros para cada combinacao.

**Alternativas:**
1. Manter como esta (flexibilidade maxima)
2. Permissions como JSONB array na Role (menos joins)
3. Bitmask de permissions (performance, menos flexivel)

**Recomendacao:** Manter como esta para MVP. Otimizar depois se necessario.

---

### 3.7 MORTE (Pecuaria)

**Situacao atual:** Entidade separada para registro de mortes.

**Questionamento:** Pode ser status do ANIMAL.

**Analise:**
- Morte tem campos especificos (causa, laudo, valor_perda)
- Precisa de auditoria e rastreabilidade
- Regulamentacao sanitaria exige documentacao

**Recomendacao:** Manter separada - entidade de evento, nao de status.

---

## 4. Padroes de Mercado Observados

### 4.1 TOTVS Agro Multicultivo

**Modulos identificados (15+):**
1. Programacao e requisicao de insumos
2. Climatologia e meteorologia
3. Ordem de servico mobile
4. Controle de atividades manuais
5. Controle de atividades mecanizadas
6. Controle de aplicacoes de insumos
7. Controle agronomico e fitossanitario
8. Controle de qualidade de operacoes
9. Gestao de custos (por produto, local, recurso)
10. Gestao de colheita (romaneio)
11. Unidade de producao (fazendas, blocos, talhoes)

**Fonte:** https://produtos.totvs.com/ficha-tecnica/tudo-sobre-o-totvs-agro-multicultivo/

---

### 4.2 Rastreabilidade SISBOV

**Estrutura do numero:**
- 15 digitos
- Posicoes 1-3: Codigo 105 (Brasil)
- Posicoes 4-5: Codigo IBGE da UF
- Posicoes 6-14: Numero sequencial
- Posicao 15: Digito verificador

**Dados obrigatorios:**
- Numero SISBOV
- Pais de origem
- Raca
- Sexo
- Fazenda de nascimento
- Cidade/Estado de nascimento
- Data de nascimento
- Data de identificacao
- Certificadora responsavel

**Fonte:** https://www.icar.org/Documents/technical_series/ICAR-Technical-Series-no-9-Sousse/Cardoso.pdf

---

### 4.3 Sistemas de Silos

**Entidades tipicas:**
1. **Monitoramento por celula:** Temperatura, umidade
2. **Secagem:** Processo com entrada/saida de umidade
3. **Batch accounting:** Lote por qualidade
4. **Aeracao:** Registros de ventilacao

**Fonte:** https://grainmanagement.com

---

### 4.4 Custos de Producao

**Metricas padrao:**
- Custo por hectare (R$/ha)
- Custo por saca (R$/sc)
- Custo por talhao
- Custo fixo vs variavel

**Composicao tipica soja 24/25:**
| Componente | % do Custo |
|------------|------------|
| Fertilizantes | 25-30% |
| Defensivos | 20-25% |
| Sementes | 10-15% |
| Operacoes mecanizadas | 15-20% |
| Mao de obra | 5-10% |
| Arrendamento | 10-20% |
| Outros | 5-10% |

**Fonte:** https://agroadvance.com.br/blog-custo-de-producao-de-soja-por-hectare-em-2024/

---

## 5. Gaps Criticos Identificados

### 5.1 Agricola

| Gap | Impacto | Prioridade |
|-----|---------|------------|
| RECEITUARIO_AGRONOMICO | Compliance legal | P0 |
| CONTRATO_ARRENDAMENTO | Custo de producao incorreto | P0 |
| ANALISE_SOLO | Adubacao sem base cientifica | P1 |
| CONTRATO_COMERCIAL | Gestao de risco de preco | P1 |
| ESTACAO_METEOROLOGICA | Agricultura de precisao | P2 |

### 5.2 Pecuaria

| Gap | Impacto | Prioridade |
|-----|---------|------------|
| DIETA | Confinamento sem controle nutricional | P0 |
| TRATO_ALIMENTAR | Consumo nao rastreado | P0 |
| CERTIFICADORA | SISBOV incompleto | P1 |

### 5.3 Financeiro

| Gap | Impacto | Prioridade |
|-----|---------|------------|
| CENTRO_CUSTO | Rateio manual, sem hierarquia | P1 |
| ORCAMENTO | Sem planejado vs realizado | P2 |

---

## 6. Recomendacoes

### 6.1 Acoes Imediatas (Sprint atual)

1. **Adicionar CONTRATO_ARRENDAMENTO** - Impacta custo fixo
2. **Adicionar DIETA + TRATO_ALIMENTAR** - Confinamento e essencial
3. **Unificar DESTINO + FORNECEDOR** em PARCEIRO_COMERCIAL

### 6.2 Acoes Proximo Sprint

4. **Adicionar RECEITUARIO_AGRONOMICO** - Compliance
5. **Adicionar CONTRATO_COMERCIAL** - Gestao de risco
6. **Adicionar CENTRO_CUSTO** - Hierarquia de custos

### 6.3 Backlog

7. ANALISE_SOLO + RECOMENDACAO_ADUBACAO
8. ESTACAO_METEOROLOGICA + LEITURA_CLIMATICA
9. TRABALHADOR_RURAL + APONTAMENTO_MAO_OBRA
10. ORCAMENTO
11. CERTIFICADORA

---

## 7. Fontes Consultadas

### Sistemas de Referencia
- [TOTVS Agro](https://www.totvs.com/agro/)
- [Aegro](https://aegro.com.br/)
- [AgriERP](https://agrierp.com/)
- [Cropin](https://www.cropin.com/)

### Rastreabilidade
- [SISBOV - QIMA](https://www.qima.com/food/sustainable/sisbov)
- [Brazilian Farmers](https://www.brazilianfarmers.com/discover/beef/)
- [ICAR Technical Series](https://www.icar.org/Documents/technical_series/)

### Custos e Mercado
- [AgroAdvance](https://agroadvance.com.br/)
- [CME Group](https://www.cmegroup.com/markets/agriculture.html)
- [ICE Agriculture](https://www.ice.com/agriculture)

### IoT e Sensores
- [RYNAN Agriculture](https://rynanagriculture.com/)
- [AWS Agricultural IoT](https://aws.amazon.com/solutions/guidance/building-an-agricultural-sensor-network-using-iot-and-amazon-documentdb/)

### Compliance
- [AgroReceita](https://agroreceita.com.br/)
- [Confea](https://www.confea.org.br/)

---

*Documento gerado para suporte a decisao. Nao representa implementacao final.*
