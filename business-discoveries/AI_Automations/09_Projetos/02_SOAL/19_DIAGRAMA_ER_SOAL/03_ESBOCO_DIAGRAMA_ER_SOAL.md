# Esboco Detalhado do Diagrama ER - Projeto SOAL

**Objetivo:** Representacao visual completa do modelo de dados da plataforma DeepWork para a SOAL, consolidando insights de todas as reunioes e discoveries realizados.

**Autor:** Rodrigo Kugler + DeepWork AI Flows
**Data:** 04/02/2026
**Versao:** 1.0
**Status:** Esboco para validacao tecnica com Joao

---

## SUMARIO EXECUTIVO

Este documento consolida informacoes de **12 reunioes** realizadas entre dezembro/2025 e fevereiro/2026:

| Data | Reuniao | Principais Insights para ER |
|------|---------|----------------------------|
| 15/12/2025 | Estrategia e Modelo de Negocio | SaaS multi-tenant, conceito de Organizacao |
| 22/12/2025 | Planejamento Tecnico DW | Medallion Architecture (Bronze/Silver/Gold) |
| 29/12/2025 | Decisoes Estrategicas MVP | N8N, CSV-first, foco em entrada de dados |
| XX/12/2025 | Discovery Presencial Claudio | Pain points: custo por hectare, visibilidade |
| 16/01/2026 | Discovery Tiago Maquinario | Vestro, John Deere, tabela DE-PARA talhoes |
| 19/01/2026 | Alinhamento Tecnico Pos-Discovery | Custom Forms, OBD/CAN, balanca via Drive |
| 27/01/2026 | Design Plataforma | Organizacao substitui Fazenda, permissoes |
| 28/01/2026 | Git Workflow e GCP | BigQuery, Cloud Storage, arquitetura hibrida |
| 29/01/2026 | Design System e AI Cost | Modulo Entradas de Dados, Vertex AI pricing |
| 30/01/2026 | Product Definition | Conectores Gold Layer, modelo de precificacao |
| 02/02/2026 | Apresentacao Mockups | Estoque virtual vs real, software Leomar |
| 03/02/2026 | Alinhamento Tecnico Joao/Rodrigo | ER como "ouro", entidades fortes/fracas |

---

## 1. ARQUITETURA GERAL DO MODELO DE DADOS

### 1.1 Visao Macro - Dominios do Sistema

```
+===============================================================================+
|                                                                               |
|                        PLATAFORMA DEEPWORK SOAL                               |
|                                                                               |
+===============================================================================+
|                                                                               |
|   +-------------------+      +-------------------+      +-------------------+  |
|   |                   |      |                   |      |                   |  |
|   |    IDENTIDADE     |      |    PERMISSOES     |      |     ALERTAS       |  |
|   |    & ACESSOS      |      |    & ROLES        |      |   & NOTIFICACOES  |  |
|   |                   |      |                   |      |                   |  |
|   | - Organizacoes    |      | - Roles           |      | - Alertas         |  |
|   | - Usuarios        |      | - Usuario_Roles   |      | - Config_Alertas  |  |
|   | - Perfis          |      | - Areas           |      | - Logs_Envio      |  |
|   | - Sessoes         |      | - Area_Usuarios   |      |                   |  |
|   |                   |      |                   |      |                   |  |
|   +-------------------+      +-------------------+      +-------------------+  |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                    ESTRUTURA TERRITORIAL                              |   |
|   |                                                                       |   |
|   |   +-------------+     +-------------+     +-------------+            |   |
|   |   |  FAZENDAS   |---->|   TALHOES   |<----|  CULTURAS   |            |   |
|   |   +-------------+     +-------------+     +-------------+            |   |
|   |         |                   |                   |                    |   |
|   |         v                   v                   v                    |   |
|   |   +-------------+     +-------------+     +-------------+            |   |
|   |   |    SILOS    |<----|   SAFRAS    |---->|TALHAO_SAFRA |            |   |
|   |   +-------------+     +-------------+     +-------------+            |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                    OPERACOES DE GRAOS                                 |   |
|   |                                                                       |   |
|   |   +---------------+                         +---------------+         |   |
|   |   |               |                         |               |         |   |
|   |   |   ENTRADAS    |-------[SILO]----------->|   ESTOQUE     |         |   |
|   |   |   GRAOS       |                         |   SILOS       |         |   |
|   |   |   (Josmar)    |                         |   (Leomar)    |         |   |
|   |   |               |<------[Reconcilia]------|               |         |   |
|   |   +---------------+                         +---------------+         |   |
|   |          |                                         |                  |   |
|   |          v                                         v                  |   |
|   |   +---------------+                         +---------------+         |   |
|   |   |   SAIDAS      |<------------------------|   QUEBRAS     |         |   |
|   |   |   GRAOS       |                         |   PRODUCAO    |         |   |
|   |   +---------------+                         +---------------+         |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                         MAQUINARIO                                    |   |
|   |                                                                       |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |   |  MAQUINAS   |---->| ABASTECIMENTOS|     | MANUTENCOES   |         |   |
|   |   +-------------+     |   (Vestro)    |     +---------------+         |   |
|   |         |             +---------------+            ^                  |   |
|   |         |                    |                     |                  |   |
|   |         v                    v                     |                  |   |
|   |   +-------------+     +---------------+            |                  |   |
|   |   | OPERACOES   |<----| OPERADORES    |------------+                  |   |
|   |   | CAMPO (JD)  |     +---------------+                               |   |
|   |   +-------------+                                                     |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                         FINANCEIRO                                    |   |
|   |                                                                       |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |   |   CUSTOS    |<----|NOTAS_FISCAIS  |---->|   INSUMOS     |         |   |
|   |   |             |     | (Valentina)   |     | (Castrolanda) |         |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |         |                                          |                  |   |
|   |         v                                          v                  |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |   |CUSTO_HECTARE|     |VENDAS_GRAOS   |<----|PROJECAO_VENDAS|         |   |
|   |   | (Dashboard) |     +---------------+     | (ate 2032)    |         |   |
|   |   +-------------+            |              +---------------+         |   |
|   |                              v                                        |   |
|   |                       +---------------+     +---------------+         |   |
|   |                       |CONTAS_RECEBER |     |CONTAS_PAGAR   |         |   |
|   |                       +---------------+     +---------------+         |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                       INTEGRACOES                                     |   |
|   |                                                                       |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |   | JOHN DEERE  |     |    VESTRO     |     | CASTROLANDA   |         |   |
|   |   | API Config  |     |  API Config   |     |  API Config   |         |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |         |                    |                     |                  |   |
|   |         v                    v                     v                  |   |
|   |   +----------------------------------------------------------+        |   |
|   |   |              LOGS_INTEGRACAO (Auditoria)                 |        |   |
|   |   +----------------------------------------------------------+        |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+-------------------------------------------------------------------------------+
|                                                                               |
|   +-----------------------------------------------------------------------+   |
|   |                                                                       |   |
|   |                    PECUARIA (Fase 2)                                  |   |
|   |                                                                       |   |
|   |   +-------------+     +---------------+     +---------------+         |   |
|   |   |  REBANHO    |---->|    MANEJO     |---->| VENDAS_GADO   |         |   |
|   |   |  (Animais)  |     | (Pesagens,    |     +---------------+         |   |
|   |   +-------------+     |  Vacinas)     |                               |   |
|   |                       +---------------+                               |   |
|   |                                                                       |   |
|   +-----------------------------------------------------------------------+   |
|                                                                               |
+===============================================================================+
```

---

## 2. DIAGRAMA ER DETALHADO - NOTACAO CROW'S FOOT

### 2.1 Dominio: Identidade e Acessos

```
+========================+          +========================+
|     ORGANIZACOES       |          |       USUARIOS         |
+========================+          +========================+
| PK  id              UUID|          | PK  id              UUID|
|     nome          STRING|<---||---<| FK  organizacao_id  UUID|
|     cnpj          STRING|          |     nome          STRING|
|     endereco      STRING|          |     email         STRING| [SINGULARIDADE]
|     area_total    DECIMAL|          |     senha_hash   STRING| [SINGULARIDADE]
|     created_at DATETIME|          |     telefone      STRING| [SINGULARIDADE]
|     updated_at DATETIME|          |     tipo            ENUM| (admin/gestor/operador)
|     ativo        BOOLEAN|          |     ativo        BOOLEAN|
+========================+          |     created_at DATETIME|
        |                           |     ultimo_acesso   DT|
        | 1:N                       +========================+
        |                                   |       |
        v                                   |       |
+========================+                  |       |
|       FAZENDAS         |                  |       | 1:1
+========================+                  |       |
| PK  id              UUID|                  |       v
| FK  organizacao_id  UUID|<---||------------+  +============+
|     nome          STRING|                     |   PERFIS   |
|     area_hectares DECIMAL|                     +============+
|     localizacao   STRING|                     | PK id   UUID|
|     latitude      DECIMAL|                     | FK usuario_id|
|     longitude     DECIMAL|                     |    foto_url  |
|     ativa        BOOLEAN|                     |    cargo     |
+========================+                     |    prefs_json|
                                               +============+
```

### 2.2 Dominio: Permissoes e Roles

```
+========================+          +========================+
|        AREAS           |          |         ROLES          |
+========================+          +========================+
| PK  id              UUID|          | PK  id              UUID|
| FK  organizacao_id  UUID|          |     nome          STRING|
|     nome          STRING|          |     codigo        STRING| (ver_dashboard_custos)
|     descricao     STRING|          |     descricao     STRING|
+========================+          +========================+
        |                                   |
        | N:N                               | N:N
        |                                   |
        v                                   v
+============================+      +============================+
|      AREA_USUARIOS         |      |      USUARIO_ROLES         |
+============================+      +============================+
| PK  area_id          UUID  |      | PK  usuario_id       UUID  |
| PK  usuario_id       UUID  |      | PK  role_id          UUID  |
|     atribuido_em  DATETIME |      |     granted_at    DATETIME |
+============================+      |     granted_by        UUID |
                                    +============================+

ROLES DEFINIDAS (Reuniao 27/01):
+--------------------------------+----------------------------------------+
| Codigo                         | Descricao                              |
+--------------------------------+----------------------------------------+
| ver_dashboard_custos           | Visualizar dashboard de custos         |
| ver_dashboard_estoque          | Visualizar estoque de graos/silos      |
| ver_dashboard_maquinario       | Visualizar consumo de maquinas         |
| editar_formularios             | Preencher entradas de dados            |
| criar_alertas                  | Configurar alertas personalizados      |
| gerenciar_usuarios             | Adicionar/remover usuarios             |
| ver_relatorios_financeiros     | Acesso a NF, contas a pagar/receber    |
| exportar_dados                 | Baixar dados em CSV/Excel              |
| configurar_integracoes         | Gerenciar APIs externas                |
+--------------------------------+----------------------------------------+
```

### 2.3 Dominio: Estrutura Territorial

```
+========================+          +========================+
|       FAZENDAS         |          |        TALHOES         |
+========================+          +========================+
| PK  id              UUID|---||---<| PK  id              UUID|
| FK  organizacao_id  UUID|          | FK  fazenda_id      UUID|
|     nome          STRING|          |     nome          STRING|
|     area_hectares DECIMAL|          |     nome_normalizado STR| [TABELA DE-PARA]
|     localizacao   STRING|          |     area_hectares DECIMAL|
|     latitude      DECIMAL|          |     tipo_solo     STRING|
|     longitude     DECIMAL|          |     observacoes   STRING|
|     ativa        BOOLEAN|          +========================+
+========================+                  |
        |                                   | N:N
        | 1:N                               |
        v                                   v
+========================+          +============================+
|        SILOS           |          |       TALHAO_SAFRA         |
+========================+          +============================+
| PK  id              UUID|          | PK  talhao_id        UUID  |
| FK  fazenda_id      UUID|          | PK  safra_id         UUID  |
|     nome          STRING|          | FK  cultura_id       UUID  |
|     capacidade_ton DECIMAL|          |     area_plantada   DECIMAL|
|     tipo            ENUM| (graneleiro/bag/armazem)      |     produtividade_est DECIMAL|
|     tem_aeracao  BOOLEAN|          +============================+
|     tem_termometria BOOL|
+========================+          +========================+
                                    |       CULTURAS         |
+========================+          +========================+
|        SAFRAS          |          | PK  id              UUID|
+========================+          |     nome          STRING|
| PK  id              UUID|          |     codigo        STRING| (SOJA/MILHO/FEIJAO)
| FK  organizacao_id  UUID|          |     ciclo_dias    INTEGER|
|     nome          STRING| (25/26)  |     epoca_plantio STRING|
|     data_inicio     DATE|          +========================+
|     data_fim        DATE|
|     ativa        BOOLEAN|
+========================+

TABELA DE-PARA (Talhoes - Descoberta 16/01 com Tiago):
+----------------------------------+--------------------+
| Nome Original (John Deere)       | Nome Normalizado   |
+----------------------------------+--------------------+
| Bonim                            | Bonin              |
| Boninho                          | Bonin              |
| Bonin lado esquerdo              | Bonin              |
| Bonin lado direito               | Bonin              |
| [Coletar na visita]              | [Normalizar]       |
+----------------------------------+--------------------+

Nota: Tiago mostrou na reuniao de 16/01 que o mesmo talhao aparece
com 5 nomes diferentes no John Deere. Isso requer tratamento na
camada Silver do Data Warehouse.
```

### 2.4 Dominio: Operacoes de Graos (CORE DO NEGOCIO)

```
+=================================+
|        ENTRADAS_GRAOS           |  [ENTIDADE FORTE - P0]
+=================================+
| PK  id                     UUID |
|     data_hora           DATETIME|
| FK  operador_id            UUID |------> USUARIOS (Josmar)
|     placa_caminhao       STRING |
|     motorista            STRING |
| FK  cultura_id             UUID |------> CULTURAS
| FK  talhao_origem_id       UUID |------> TALHOES
| FK  fazenda_origem_id      UUID |------> FAZENDAS
|     peso_bruto_kg       DECIMAL |  <-- Medido na balanca
|     umidade_percentual  DECIMAL |  <-- Medido pelo Josmar
|     impureza_percentual DECIMAL |  <-- Medido pelo Josmar
|     peso_liquido_est_kg DECIMAL |  <-- CALCULADO AUTOMATICO
| FK  silo_destino_id        UUID |------> SILOS
|     is_semente_propria  BOOLEAN |  <-- Flag separacao
|     qtd_semente_kg      DECIMAL |  <-- Se for semente
|     observacoes          STRING |
|     created_at         DATETIME |
+=================================+

FORMULA (Descoberta 02/02 com Claudio):
+--------------------------------------------------------------------+
| peso_liquido_estimado = peso_bruto                                 |
|                         - (peso_bruto * umidade_percentual)        |
|                         - (peso_bruto * impureza_percentual)       |
+--------------------------------------------------------------------+

CAMPOS DO CADERNO DO JOSMAR (a validar na visita):
- Data e hora
- Placa do caminhao
- Nome do motorista
- De qual talhao veio
- Peso bruto (balanca)
- % umidade (analise)
- % sujeira/impureza (analise)
- Para qual silo vai
- Se e semente propria
- Observacoes


+=================================+
|        SAIDAS_GRAOS             |
+=================================+
| PK  id                     UUID |
|     data_hora           DATETIME|
| FK  operador_id            UUID |
| FK  silo_origem_id         UUID |------> SILOS
| FK  cultura_id             UUID |------> CULTURAS
|     peso_kg             DECIMAL |
|     destino              STRING |
|     tipo_saida             ENUM | (venda/transferencia/consumo)
|     nota_fiscal          STRING |
|     preco_por_saca      DECIMAL |  <-- Se for venda
|     comprador            STRING |
|     created_at         DATETIME |
+=================================+


+=================================+
|        ESTOQUE_SILOS            |  [Integracao Software Leomar]
+=================================+
| PK  id                     UUID |
| FK  silo_id                UUID |------> SILOS
| FK  cultura_id             UUID |------> CULTURAS
|     data_posicao           DATE |
|     qtd_virtual_kg      DECIMAL |  <-- Calculado (entradas - saidas)
|     qtd_real_kg         DECIMAL |  <-- Do software Leomar
|     umidade_media       DECIMAL |
|     temperatura_media   DECIMAL |  <-- Se tiver termometria
|     ultima_atualizacao DATETIME |
+=================================+

CONCEITO ESTOQUE VIRTUAL vs REAL (Descoberta 02/02):
+--------------------------------------------------------------------+
| O Leomar sempre calcula com desconto MAIOR (margem de seguranca).  |
| Isso gera "sobra tecnica" - ex: esperava 960t, tem 1000t.          |
|                                                                    |
| Claudio: "O que tem na planilha e um estoque virtual, sabe?        |
|           Nao e o estoque real."                                   |
+--------------------------------------------------------------------+


+=================================+
|       QUEBRAS_PRODUCAO          |  [Oportunidade - Reuniao 03/02]
+=================================+
| PK  id                     UUID |
| FK  safra_id               UUID |
| FK  cultura_id             UUID |
| FK  silo_id                UUID |
|     data_apuracao          DATE |
|     peso_entrada_total  DECIMAL |  <-- Soma entradas brutas
|     peso_saida_total    DECIMAL |  <-- Soma saidas
|     quebra_estimada_kg  DECIMAL |  <-- Calculado
|     quebra_real_kg      DECIMAL |  <-- Apurado fisicamente
|     diferenca_kg        DECIMAL |  <-- Estimada - Real
|     percentual_quebra   DECIMAL |
|     observacoes          STRING |
+=================================+

RISCO IDENTIFICADO (Rodrigo - 03/02):
+--------------------------------------------------------------------+
| "Quem que garante que o cara nao pega e descarrega, sei la,        |
|  10, 20 sacas de feijao, tira ali, bota na quebra?"                |
|                                                                    |
| Oportunidade: Controle de quebra real vs estimada para detectar    |
| desvios de producao. 20 sacas de feijao = R$ 3.000-4.000           |
+--------------------------------------------------------------------+
```

### 2.5 Dominio: Maquinario

```
+=================================+
|          MAQUINAS               |  [ENTIDADE FORTE]
+=================================+
| PK  id                     UUID |
| FK  organizacao_id         UUID |
|     tipo                   ENUM | (trator/colheitadeira/pulverizador/caminhao)
|     marca               STRING |  (John Deere, Case, etc)
|     modelo              STRING |
|     ano                INTEGER |
|     potencia_cv        INTEGER |
|     numero_serie        STRING |
|     tag_vestro          STRING |  <-- ID no sistema Vestro
|     tag_john_deere      STRING |  <-- ID no Operations Center
|     capacidade_tanque_l DECIMAL|
|     horimetro_atual    DECIMAL |
|     status               ENUM  | (ativa/manutencao/inativa)
|     created_at        DATETIME |
+=================================+
        |
        | 1:N
        v
+=================================+
|       ABASTECIMENTOS            |  [Fonte: Vestro API]
+=================================+
| PK  id                     UUID |
|     data_hora           DATETIME|
| FK  maquina_id             UUID |------> MAQUINAS
| FK  operador_id            UUID |------> USUARIOS
|     litros              DECIMAL |
|     horimetro_leitura   DECIMAL |
|     horimetro_anterior  DECIMAL |  <-- Para calcular consumo
|     consumo_l_hora      DECIMAL |  <-- CALCULADO
| FK  fazenda_id             UUID |------> FAZENDAS
| FK  cultura_id             UUID |------> CULTURAS [NOVO VESTRO]
|     tanque_origem        STRING |
|     fonte                 ENUM  | (vestro/manual)
|     created_at         DATETIME |
+=================================+

FLUXO VESTRO ATUAL (Descoberta 16/01 com Tiago):
+--------------------------------------------------------------------+
| 1. Operador abastece e lanca no App Vestro                         |
| 2. As vezes erra o horimetro (540.00 vs 5400.0)                    |
| 3. Tiago exporta relatorio a cada 15/30 dias                       |
| 4. Tiago ABRE O EXCEL E CORRIGE LINHA POR LINHA                    |
| 5. Tiago ADICIONA COLUNAS MANUAIS (fazenda, operacao)              |
| 6. Tiago envia planilha para Valentina                             |
| 7. Valentina DIGITA MANUALMENTE nota por nota no AgriWin           |
|                                                                    |
| SOLUCAO: N8N coleta dados da API Vestro diariamente.               |
|          Regra Python corrige horimetros absurdos automaticamente. |
+--------------------------------------------------------------------+

VALIDACAO AUTOMATICA DE CONSUMO:
+--------------------------------------------------------------------+
| Se consumo_l_hora estiver FORA do padrao historico da maquina:     |
| -> Gerar ALERTA automatico                                         |
| -> Exemplo: Trator media 10L/h, registrou 25L/h = anomalia         |
+--------------------------------------------------------------------+


+=================================+
|      OPERACOES_CAMPO            |  [Fonte: John Deere API]
+=================================+
| PK  id                     UUID |
| FK  maquina_id             UUID |------> MAQUINAS
| FK  operador_id            UUID |------> USUARIOS
| FK  talhao_id              UUID |------> TALHOES
| FK  cultura_id             UUID |------> CULTURAS
|     tipo_operacao          ENUM | (plantio/pulverizacao/colheita/gradagem)
|     data_inicio         DATETIME|
|     data_fim            DATETIME|
|     area_trabalhada_ha  DECIMAL |
|     velocidade_media_kmh DECIMAL|
|     combustivel_consumido DECIMAL|
|     dados_json              JSON |  <-- Dados extras telemetria
|     created_at         DATETIME |
+=================================+

PARQUE DE MAQUINAS SOAL (Descoberta 16/01):
+--------------------------------------------------------------------+
| - Tratores John Deere com telemetria: 2 de 4 conectados            |
| - Colheitadeiras: telemetria parcial                               |
| - Patrolas 1990: SEM telemetria (controle via Vestro)              |
| - Caminhoes: SEM telemetria (controle via Vestro)                  |
|                                                                    |
| Estrategia: Usar ABASTECIMENTO como proxy de uso para maquinas     |
| legadas que nao tem telemetria nativa.                             |
+--------------------------------------------------------------------+


+=================================+
|        MANUTENCOES              |
+=================================+
| PK  id                     UUID |
| FK  maquina_id             UUID |------> MAQUINAS
|     data                   DATE |
|     tipo                   ENUM | (preventiva/corretiva/troca_oleo)
|     descricao            STRING |
|     horimetro           DECIMAL |
|     custo               DECIMAL |
|     pecas_utilizadas     STRING |
|     responsavel          STRING |
|     created_at         DATETIME |
+=================================+
```

### 2.6 Dominio: Financeiro

```
+=================================+
|           CUSTOS                |  [ENTIDADE FORTE]
+=================================+
| PK  id                     UUID |
| FK  safra_id               UUID |------> SAFRAS
| FK  fazenda_id             UUID |------> FAZENDAS (opcional)
| FK  cultura_id             UUID |------> CULTURAS (opcional)
|     categoria              ENUM | (insumos/diesel/mao_obra/manutencao/arrend)
|     subcategoria         STRING |
|     descricao            STRING |
|     valor               DECIMAL |
|     data                   DATE |
|     nota_fiscal          STRING |
|     fornecedor           STRING |
|     rateio_tipo            ENUM | (por_area/por_cultura/direto)
|     fonte                  ENUM | (castrolanda/manual/vestro)
|     created_at         DATETIME |
+=================================+

METODO DE RATEIO (Descoberta 02/02 com Claudio):
+--------------------------------------------------------------------+
| DIESEL:                                                            |
| "Gastou la no ano 150.000 litros de diesel, normalmente por        |
|  hectare de cultura, entendeu?"                                    |
|                                                                    |
| Estrategia: Rateio proporcional por area plantada (simplificado).  |
| Claudio validou que diferenca entre talhoes e irrelevante.         |
|                                                                    |
| MAO DE OBRA:                                                       |
| "A mao de obra e uma coisa complexa, porque nao e um negocio      |
|  que foi destinado tantos reais por hectare."                      |
|                                                                    |
| Estrategia: Rateio por area OU por hora-maquina (fase 2).          |
+--------------------------------------------------------------------+


+=================================+
|      INSUMOS_CASTROLANDA        |  [Fonte: API Castrolanda - a validar]
+=================================+
| PK  id                     UUID |
|     data_compra            DATE |
|     nota_fiscal          STRING |
|     produto              STRING |
|     quantidade          DECIMAL |
|     unidade              STRING | (kg/L/unidade)
|     valor_unitario      DECIMAL |
|     valor_total         DECIMAL |
| FK  cultura_destino_id     UUID |------> CULTURAS
| FK  safra_id               UUID |------> SAFRAS
|     created_at         DATETIME |
+=================================+

IMPORTANCIA CASTROLANDA (Descoberta 02/02):
+--------------------------------------------------------------------+
| "90% das notas de emissao sao pela Castrolanda."                   |
|                                                                    |
| Claudio vai falar com diretores para autorizar acesso ao TI.       |
| Integracao Castrolanda = Quick Win para dados financeiros.         |
+--------------------------------------------------------------------+


+=================================+
|       NOTAS_FISCAIS             |  [Fonte: Valentina/XML]
+=================================+
| PK  id                     UUID |
|     numero               STRING |
|     serie                STRING |
|     data_emissao           DATE |
|     fornecedor_cnpj      STRING |
|     fornecedor_nome      STRING |
|     valor_total         DECIMAL |
|     chave_acesso         STRING |  <-- Chave NFe 44 digitos
|     xml_path             STRING |  <-- Cloud Storage
|     status                 ENUM | (pendente/processada/cancelada)
| FK  processado_por_id      UUID |------> USUARIOS
|     created_at         DATETIME |
+=================================+


+=================================+
|        VENDAS_GRAOS             |
+=================================+
| PK  id                     UUID |
| FK  safra_id               UUID |------> SAFRAS
| FK  cultura_id             UUID |------> CULTURAS
|     data_venda             DATE |
|     quantidade_sacas    DECIMAL |
|     preco_saca          DECIMAL |
|     valor_total         DECIMAL |
|     comprador            STRING |
|     nota_fiscal          STRING |
|     tipo                   ENUM | (spot/contrato_futuro/barter)
|     data_entrega           DATE |  <-- Quando sera entregue
|     created_at         DATETIME |
+=================================+


+=================================+
|      PROJECAO_VENDAS            |  [Fonte: Planilha Claudio ate 2032]
+=================================+
| PK  id                     UUID |
| FK  safra_id               UUID |------> SAFRAS
| FK  cultura_id             UUID |------> CULTURAS
|     qtd_sacas_prevista  DECIMAL |
|     preco_medio_esperado DECIMAL|
|     data_previsao          DATE |
|     observacoes          STRING |
+=================================+

PLANILHA CLAUDIO (Descoberta 02/02):
+--------------------------------------------------------------------+
| - Projecao de vendas ate 2032                                      |
| - Previsao de venda em sacas por ano                               |
| - Acompanhamento de preco medio de mercado                         |
|                                                                    |
| COLETAR NA VISITA: Estrutura exata da planilha                     |
+--------------------------------------------------------------------+


+=================================+
|        CONTAS_PAGAR             |  [Fonte: SharePoint Valentina]
+=================================+
| PK  id                     UUID |
|     descricao            STRING |
|     fornecedor           STRING |
|     valor               DECIMAL |
|     data_vencimento        DATE |
|     data_pagamento         DATE |
|     status                 ENUM | (pendente/paga/atrasada)
|     categoria            STRING |
| FK  nota_fiscal_id         UUID |------> NOTAS_FISCAIS
|     created_at         DATETIME |
+=================================+


+=================================+
|       CONTAS_RECEBER            |
+=================================+
| PK  id                     UUID |
|     descricao            STRING |
|     cliente              STRING |
|     valor               DECIMAL |
|     data_vencimento        DATE |
|     data_recebimento       DATE |
|     status                 ENUM | (pendente/recebida/atrasada)
| FK  venda_id               UUID |------> VENDAS_GRAOS
|     created_at         DATETIME |
+=================================+
```

### 2.7 Dominio: Integracoes

```
+=================================+
|        INTEGRACOES              |  [Segredos/Secrets]
+=================================+
| PK  id                     UUID |
| FK  organizacao_id         UUID |------> ORGANIZACOES
|     tipo                   ENUM | (john_deere/vestro/castrolanda/agriwin)
|     nome                 STRING |
|     api_key       STRING (CRYPT)|  <-- DADOS SENSIVEIS
|     api_secret    STRING (CRYPT)|  <-- DADOS SENSIVEIS
|     token         STRING (CRYPT)|
|     token_expira_em    DATETIME |
|     ultima_sincronizacao   DT   |
|     status                 ENUM | (ativa/erro/inativa)
|     config_json            JSON |
|     created_at         DATETIME |
+=================================+

ARQUITETURA DE SEGURANCA (Reuniao 03/02 - Joao):
+--------------------------------------------------------------------+
| - Credenciais NUNCA em GitHub                                      |
| - Uso de GCP Secret Manager                                        |
| - Dados de singularidade (CPF, nome, endereco) = SENSIVEIS         |
| - Ambiente de dev isolado em VM (Hostinger KVM2)                   |
| - Kill switch: desligar VM = encerra bot                           |
+--------------------------------------------------------------------+


+=================================+
|      LOGS_INTEGRACAO            |  [Auditoria]
+=================================+
| PK  id                     UUID |
| FK  integracao_id          UUID |------> INTEGRACOES
|     data_hora           DATETIME|
|     tipo                   ENUM | (sucesso/erro/warning)
|     mensagem             STRING |
|     registros_processados INT  |
|     detalhes_json          JSON |
+=================================+
```

### 2.8 Dominio: Alertas e Notificacoes

```
+=================================+
|          ALERTAS                |
+=================================+
| PK  id                     UUID |
| FK  organizacao_id         UUID |------> ORGANIZACOES
|     tipo                   ENUM | (estoque_baixo/manutencao/integracao_erro/consumo_anormal)
|     titulo               STRING |
|     mensagem             STRING |
|     severidade             ENUM | (info/warning/error/critical)
|     entidade_tipo        STRING |  <-- Ex: "MAQUINAS"
|     entidade_id            UUID |  <-- Ex: ID do trator
|     criado_em           DATETIME|
|     lido_em             DATETIME|
|     resolvido_em        DATETIME|
| FK  resolvido_por_id       UUID |------> USUARIOS
+=================================+

TIPOS DE ALERTAS (Reuniao 30/01):
+--------------------------------------------------------------------+
| ACAO/REACAO:                                                       |
| - "Se estoque de glifosato < 100L, avise."                         |
| - "Se diesel < 500L, avise."                                       |
|                                                                    |
| RESUMO:                                                            |
| - "Resumo diario da operacao no WhatsApp as 18h."                  |
|                                                                    |
| TECNICO:                                                           |
| - "Falha na integracao com John Deere."                            |
| - "Integracao Vestro nao sincroniza ha 3 dias."                    |
|                                                                    |
| ANOMALIA:                                                          |
| - "Trator X consumiu 25L/h (media: 10L/h)."                        |
+--------------------------------------------------------------------+


+=================================+
|      CONFIG_ALERTAS             |  [Configuracao personalizada]
+=================================+
| PK  id                     UUID |
| FK  organizacao_id         UUID |
| FK  usuario_id             UUID |  <-- Quem criou
|     tipo_alerta            ENUM |
|     condicao_json          JSON |  <-- {"campo": "estoque", "operador": "<", "valor": 100}
|     canais_notificacao   STRING | (app/email/whatsapp)
|     ativo              BOOLEAN |
|     created_at         DATETIME |
+=================================+
```

### 2.9 Dominio: Pecuaria (Fase 2)

```
+=================================+
|          ANIMAIS                |  [Fase 2 - Gado de Corte]
+=================================+
| PK  id                     UUID |
| FK  organizacao_id         UUID |
|     identificacao        STRING |  <-- Brinco/numero
|     raca                 STRING |
|     sexo                   ENUM | (macho/femea)
|     data_nascimento        DATE |
|     peso_atual          DECIMAL |
|     status                 ENUM | (ativo/vendido/morto)
|     lote                 STRING |  <-- Piquete/lote
|     created_at         DATETIME |
+=================================+


+=================================+
|          MANEJOS                |
+=================================+
| PK  id                     UUID |
| FK  animal_id              UUID |------> ANIMAIS
|     data                   DATE |
|     tipo                   ENUM | (pesagem/vacinacao/vermifugo/outro)
|     peso_kg             DECIMAL |  <-- Se for pesagem
|     produto              STRING |  <-- Se for medicacao
|     observacoes          STRING |
|     created_at         DATETIME |
+=================================+


+=================================+
|        VENDAS_GADO              |
+=================================+
| PK  id                     UUID |
| FK  animal_id              UUID |------> ANIMAIS
|     data_venda             DATE |
|     peso_venda_kg       DECIMAL |
|     preco_arroba        DECIMAL |
|     valor_total         DECIMAL |
|     comprador            STRING |
|     nota_fiscal          STRING |
+=================================+

NOTAS (Descoberta 02/02):
+--------------------------------------------------------------------+
| - Claudio mencionou gado de corte como funcionalidade futura       |
| - Rodrigo propos modulo separado dentro da mesma plataforma        |
| - Rebanho estimado: ~1000 cabecas (a confirmar)                    |
| - A mapear: tem brinco eletronico? Como e o controle hoje?         |
+--------------------------------------------------------------------+
```

---

## 3. MAPA DE RELACIONAMENTOS COMPLETO

### 3.1 Matriz de Cardinalidade

```
+-------------------------+-------------------------+-------------+
| Entidade A              | Entidade B              | Cardinalidade|
+-------------------------+-------------------------+-------------+
| ORGANIZACOES            | FAZENDAS                | 1:N         |
| ORGANIZACOES            | USUARIOS                | 1:N         |
| ORGANIZACOES            | SAFRAS                  | 1:N         |
| ORGANIZACOES            | INTEGRACOES             | 1:N         |
| ORGANIZACOES            | ALERTAS                 | 1:N         |
| ORGANIZACOES            | AREAS                   | 1:N         |
+-------------------------+-------------------------+-------------+
| FAZENDAS                | TALHOES                 | 1:N         |
| FAZENDAS                | SILOS                   | 1:N         |
| FAZENDAS                | MAQUINAS                | 1:N         |
+-------------------------+-------------------------+-------------+
| USUARIOS                | PERFIS                  | 1:1         |
| USUARIOS                | SESSOES                 | 1:N         |
| USUARIOS                | ALERTAS (resolvidos)    | 1:N         |
| USUARIOS                | ROLES                   | N:N         |
| USUARIOS                | AREAS                   | N:N         |
+-------------------------+-------------------------+-------------+
| TALHOES                 | SAFRAS                  | N:N         |
| TALHOES                 | CULTURAS                | N:N         |
| TALHOES                 | ENTRADAS_GRAOS          | 1:N         |
| TALHOES                 | OPERACOES_CAMPO         | 1:N         |
+-------------------------+-------------------------+-------------+
| SILOS                   | ENTRADAS_GRAOS          | 1:N         |
| SILOS                   | SAIDAS_GRAOS            | 1:N         |
| SILOS                   | ESTOQUE_SILOS           | 1:N         |
+-------------------------+-------------------------+-------------+
| CULTURAS                | ENTRADAS_GRAOS          | 1:N         |
| CULTURAS                | SAIDAS_GRAOS            | 1:N         |
| CULTURAS                | CUSTOS                  | 1:N         |
| CULTURAS                | VENDAS_GRAOS            | 1:N         |
| CULTURAS                | ABASTECIMENTOS          | 1:N         |
+-------------------------+-------------------------+-------------+
| MAQUINAS                | ABASTECIMENTOS          | 1:N         |
| MAQUINAS                | OPERACOES_CAMPO         | 1:N         |
| MAQUINAS                | MANUTENCOES             | 1:N         |
+-------------------------+-------------------------+-------------+
| SAFRAS                  | CUSTOS                  | 1:N         |
| SAFRAS                  | VENDAS_GRAOS            | 1:N         |
| SAFRAS                  | PROJECAO_VENDAS         | 1:N         |
| SAFRAS                  | INSUMOS_CASTROLANDA     | 1:N         |
+-------------------------+-------------------------+-------------+
| INTEGRACOES             | LOGS_INTEGRACAO         | 1:N         |
+-------------------------+-------------------------+-------------+
| NOTAS_FISCAIS           | CONTAS_PAGAR            | 1:N         |
+-------------------------+-------------------------+-------------+
| VENDAS_GRAOS            | CONTAS_RECEBER          | 1:1         |
+-------------------------+-------------------------+-------------+
| ANIMAIS                 | MANEJOS                 | 1:N         |
| ANIMAIS                 | VENDAS_GADO             | 1:1         |
+-------------------------+-------------------------+-------------+
```

### 3.2 Entidades Fortes vs Fracas

```
+===========================+==============+========================================+
| ENTIDADE                  | CLASSIFICACAO| JUSTIFICATIVA                         |
+===========================+==============+========================================+
| USUARIOS                  | FORTE        | Dados de singularidade (email, CPF)   |
| ENTRADAS_GRAOS            | FORTE        | Core do negocio, producao             |
| CUSTOS                    | FORTE        | Dados financeiros criticos            |
| NOTAS_FISCAIS             | FORTE        | Documentos fiscais/legais             |
| MAQUINAS                  | FORTE        | Ativos de alto valor                  |
| INTEGRACOES               | FORTE        | Credenciais sensiveis                 |
| VENDAS_GRAOS              | FORTE        | Receita do negocio                    |
+---------------------------+--------------+----------------------------------------+
| ABASTECIMENTOS            | FRACA        | Alto volume, dados de telemetria      |
| OPERACOES_CAMPO           | FRACA        | Alto volume, dados de telemetria      |
| LOGS_INTEGRACAO           | FRACA        | Dados de auditoria                    |
| ALERTAS                   | FRACA        | Muitos por organizacao                |
| ESTOQUE_SILOS             | FRACA        | Snapshot diario                       |
| MANEJOS                   | FRACA        | Alto volume por animal                |
+===========================+==============+========================================+

INSIGHT JOAO (03/02):
+--------------------------------------------------------------------+
| "Quanto mais forte entidade de negocio, mais dinheiro provavelmente|
|  ele ganha com aquela entidade."                                   |
|                                                                    |
| Se ENTRADAS_GRAOS tem relacao forte com SILOS e CUSTOS,           |
| provavelmente tem muito dinheiro envolvido nessa conexao.          |
+--------------------------------------------------------------------+
```

---

## 4. CONECTORES - GOLD LAYER

### 4.1 Conceito de Conectores (Reuniao 30/01)

```
+====================================================================+
|                     CONECTORES - GOLD LAYER                         |
+====================================================================+
|                                                                     |
| O DESAFIO:                                                         |
| Ingerir dados (Bronze) e limpar (Silver) e "facil".                |
| O valor real esta no CRUZAMENTO (Gold).                            |
|                                                                     |
| Exemplo: Saber que o caminhao X que pesou na balanca e o mesmo     |
| que descarregou no secador 10 min depois.                          |
|                                                                     |
| SOLUCAO:                                                           |
| Interface onde o usuario (ou consultor DPY no setup) cria          |
| "Conectores" definindo como os dados se ligam.                     |
|                                                                     |
+====================================================================+
```

### 4.2 Conectores Identificados

```
CONECTOR 1: Entrada Graos <-> Balanca
+--------------------------------------------------------------------+
| Fonte A: ENTRADAS_GRAOS (Josmar)                                   |
| Fonte B: REGISTROS_BALANCA (Planilha Vanessa - a criar)            |
| Chave: placa_caminhao + janela_tempo (+-30min)                     |
| Resultado: Validacao peso bruto informado vs pesado                |
+--------------------------------------------------------------------+

CONECTOR 2: Abastecimento <-> Operacao Campo
+--------------------------------------------------------------------+
| Fonte A: ABASTECIMENTOS (Vestro)                                   |
| Fonte B: OPERACOES_CAMPO (John Deere)                              |
| Chave: maquina_id + janela_tempo                                   |
| Resultado: Custo de diesel por operacao/talhao                     |
+--------------------------------------------------------------------+

CONECTOR 3: Entrada Graos <-> Estoque Silos
+--------------------------------------------------------------------+
| Fonte A: ENTRADAS_GRAOS (Josmar)                                   |
| Fonte B: ESTOQUE_SILOS (Leomar)                                    |
| Chave: silo_id + cultura_id + data                                 |
| Resultado: Reconciliacao estoque virtual vs real                   |
+--------------------------------------------------------------------+

CONECTOR 4: Custos <-> Talhoes (Custo por Hectare)
+--------------------------------------------------------------------+
| Fonte A: CUSTOS (agregado por safra/cultura)                       |
| Fonte B: TALHAO_SAFRA (area plantada)                              |
| Chave: safra_id + cultura_id                                       |
| Resultado: R$/hectare por cultura                                  |
+--------------------------------------------------------------------+

CONECTOR 5: Insumos Castrolanda <-> Aplicacoes Campo
+--------------------------------------------------------------------+
| Fonte A: INSUMOS_CASTROLANDA                                       |
| Fonte B: OPERACOES_CAMPO (tipo: pulverizacao)                      |
| Chave: cultura_id + janela_tempo + produto                         |
| Resultado: Rastreabilidade de aplicacao                            |
+--------------------------------------------------------------------+

CONECTOR 6: Vendas <-> Saidas Graos
+--------------------------------------------------------------------+
| Fonte A: VENDAS_GRAOS                                              |
| Fonte B: SAIDAS_GRAOS                                              |
| Chave: nota_fiscal OU (cultura_id + data + quantidade)             |
| Resultado: Reconciliacao vendas vs entregas                        |
+--------------------------------------------------------------------+
```

---

## 5. FLUXOS DE DADOS PRINCIPAIS

### 5.1 Fluxo: Entrada de Graos (P0 - CRITICO)

```
                         CAMPO
                           |
                           v
+----------------+    +---------+    +----------------+
|   COLHEITA     |--->| CAMINHAO|--->|    BALANCA     |
| (John Deere)   |    +---------+    | (Peso Bruto)   |
+----------------+         |         +----------------+
                           |                |
                           v                v
                    +----------------+  +----------------+
                    |    SECADOR     |  | PLANILHA DRIVE |
                    |    (Josmar)    |  |   (Vanessa)    |
                    +----------------+  +----------------+
                           |                |
       +-------------------+                |
       |                                    |
       v                                    v
+----------------+                   +----------------+
| FORMULARIO DPY |                   | INTEGRACAO DPY |
| (Tablet Josmar)|                   | (API/Drive)    |
+----------------+                   +----------------+
       |                                    |
       +----------------+-------------------+
                        |
                        v
               +----------------+
               | ENTRADAS_GRAOS |
               | (Bronze Layer) |
               +----------------+
                        |
                        v
               +----------------+
               |  TRATAMENTO    |
               | (Silver Layer) |
               | - Normalizacao |
               | - Calculo peso |
               | - Validacao    |
               +----------------+
                        |
          +-------------+-------------+
          |             |             |
          v             v             v
   +----------+  +----------+  +----------+
   | ESTOQUE  |  | DASHBOARD|  | ALERTAS  |
   | SILOS    |  | PRODUCAO |  |          |
   +----------+  +----------+  +----------+
```

### 5.2 Fluxo: Abastecimento de Maquinas

```
+----------------+
|   OPERADOR     |
| (App Vestro)   |
+----------------+
       |
       | Lanca: maquina, litros, horimetro
       v
+----------------+
|    VESTRO      |
| (Servidor)     |
+----------------+
       |
       | API ou Export Excel
       v
+----------------+
|     N8N        |
| (Orquestrador) |
+----------------+
       |
       v
+----------------+
| ABASTECIMENTOS |
| (Bronze Layer) |
+----------------+
       |
       v
+----------------+
|  TRATAMENTO    |
| (Silver Layer) |
| - Corrige hora |
| - Calcula L/h  |
| - Valida range |
+----------------+
       |
       +-----------+-----------+
       |           |           |
       v           v           v
+----------+ +----------+ +----------+
| CONSUMO  | | CUSTO    | | ALERTA   |
| MAQUINA  | | DIESEL   | | ANOMALIA |
+----------+ +----------+ +----------+
```

### 5.3 Fluxo: Custo por Hectare (Dashboard Principal)

```
+----------------+     +----------------+     +----------------+
| INSUMOS        |     |    DIESEL      |     | MAO DE OBRA    |
| (Castrolanda)  |     | (Vestro/Rateio)|     | (Rateio Area)  |
+----------------+     +----------------+     +----------------+
       |                      |                      |
       v                      v                      v
+----------------------------------------------------------+
|                        CUSTOS                             |
|  (Agregados por: safra_id, cultura_id, fazenda_id)       |
+----------------------------------------------------------+
                              |
                              v
+----------------------------------------------------------+
|                     TALHAO_SAFRA                          |
|  (Area plantada por talhao/cultura/safra)                |
+----------------------------------------------------------+
                              |
                              v
+----------------------------------------------------------+
|                  CUSTO POR HECTARE                        |
|  = SUM(Custos) / SUM(Area Plantada)                      |
|                                                           |
|  Por Fazenda:    R$ X.XXX/ha                             |
|  Por Cultura:    Soja R$ X.XXX/ha | Milho R$ X.XXX/ha    |
|  Por Talhao:     Bonim R$ X.XXX/ha | Santana R$ X.XXX/ha |
+----------------------------------------------------------+
```

---

## 6. DASHBOARDS E SUAS FONTES

### 6.1 Dashboard: Estoque de Graos por Silo (P0)

```
+====================================================================+
|                    ESTOQUE DE GRAOS POR SILO                        |
+====================================================================+
|                                                                     |
|  +-------------+  +-------------+  +-------------+  +-------------+ |
|  |   SILO 1    |  |   SILO 2    |  |   SILO 3    |  |   SILO 5    | |
|  |             |  |             |  |             |  |             | |
|  |   TRIGO     |  |   SOJA      |  |   TRIGO     |  |   TRIGO     | |
|  |   850t      |  |   1200t     |  |   200t      |  |   1800t     | |
|  |   ||||||||  |  |   ||||||    |  |   ||        |  |   ||||||||| | |
|  |   85%       |  |   60%       |  |   20%       |  |   90%       | |
|  +-------------+  +-------------+  +-------------+  +-------------+ |
|                                                                     |
|  Virtual: 4.050t                  Real (Leomar): 4.120t            |
|  Diferenca: +70t (Sobra tecnica)                                   |
|                                                                     |
+====================================================================+

FONTES DE DADOS:
- SILOS (capacidade, nome)
- ESTOQUE_SILOS (quantidade, umidade)
- CULTURAS (tipo de grao)
- ENTRADAS_GRAOS (soma entradas)
- SAIDAS_GRAOS (soma saidas)
```

### 6.2 Dashboard: Custo por Fazenda e Cultura (P0)

```
+====================================================================+
|                   CUSTO POR FAZENDA E CULTURA                       |
+====================================================================+
|                                                                     |
|  Safra: 2025/26                                  [Filtrar Cultura] |
|                                                                     |
|  +-------------------+----------------------------------------+     |
|  | FAZENDA           | SOJA     | MILHO    | FEIJAO   | TOTAL |     |
|  +-------------------+----------------------------------------+     |
|  | Santana do Iapo   | R$ 4.200 | R$ 3.800 | R$ 5.100 | ...   |     |
|  | Sao Joao          | R$ 4.100 | R$ 3.600 | -        | ...   |     |
|  | [Outras]          | ...      | ...      | ...      | ...   |     |
|  +-------------------+----------------------------------------+     |
|                                                                     |
|  COMPOSICAO DE CUSTOS (Soja - Santana):                            |
|  +------------------------+----------+----------+                   |
|  | Insumos (Castrolanda)  |  R$ 2.100|    50%   |                   |
|  | Diesel                 |  R$   840|    20%   |                   |
|  | Mao de Obra            |  R$   630|    15%   |                   |
|  | Manutencao             |  R$   420|    10%   |                   |
|  | Outros                 |  R$   210|     5%   |                   |
|  +------------------------+----------+----------+                   |
|                                                                     |
+====================================================================+

FONTES DE DADOS:
- CUSTOS (valor, categoria, cultura_id, fazenda_id)
- TALHAO_SAFRA (area plantada)
- INSUMOS_CASTROLANDA
- ABASTECIMENTOS (diesel)
```

### 6.3 Dashboard: Consumo de Maquinas (P1)

```
+====================================================================+
|                    CONSUMO DE MAQUINAS                              |
+====================================================================+
|                                                                     |
|  Periodo: [Ultimos 30 dias]                                        |
|                                                                     |
|  +-------------------+--------+--------+--------+--------+          |
|  | MAQUINA           | LITROS | HORAS  | L/HORA | STATUS |          |
|  +-------------------+--------+--------+--------+--------+          |
|  | JD 8R 410 #01     | 1.250  |   125  |  10.0  |   OK   |          |
|  | JD 8R 410 #02     | 1.180  |   118  |  10.0  |   OK   |          |
|  | JD 7195J #03      | 2.100  |    84  |  25.0  |  ALERTA|  <---    |
|  | Case Patriot      |   890  |    45  |  19.8  |   OK   |          |
|  +-------------------+--------+--------+--------+--------+          |
|                                                                     |
|  [!] ALERTA: JD 7195J #03 consumiu 25L/h (media: 12L/h)            |
|                                                                     |
+====================================================================+

FONTES DE DADOS:
- MAQUINAS (nome, tag)
- ABASTECIMENTOS (litros, horimetro)
- Calculo: (horimetro_atual - horimetro_anterior) / litros
```

---

## 7. ENTIDADES A VALIDAR NA VISITA

### 7.1 Checklist por Pessoa

```
JOSMAR (Secador) - ENTIDADES: ENTRADAS_GRAOS
+--------------------------------------------------------------------+
| [ ] Quais campos voce anota no caderno?                            |
| [ ] Em que ordem voce anota?                                       |
| [ ] Como voce calcula o desconto de umidade/sujeira?               |
| [ ] Como decide para qual silo vai?                                |
| [ ] Quanto tempo leva para registrar uma carga?                    |
| [ ] Tem Wi-Fi no secador?                                          |
| [ ] Consegue usar tablet/celular?                                  |
+--------------------------------------------------------------------+

LEOMAR (Silos) - ENTIDADES: ESTOQUE_SILOS, SILOS
+--------------------------------------------------------------------+
| [ ] Como funciona o software de controle?                          |
| [ ] Quais dados ele mostra (temperatura, umidade)?                 |
| [ ] Tem exportacao de dados ou API?                                |
| [ ] Como voces sabem o estoque real de cada silo?                  |
| [ ] Posso ver a tela do sistema? (FOTOGRAFAR)                      |
+--------------------------------------------------------------------+

TIAGO (Maquinario) - ENTIDADES: MAQUINAS, ABASTECIMENTOS
+--------------------------------------------------------------------+
| [ ] Posso ver a planilha mestre de frota?                          |
| [ ] Quantas maquinas tem telemetria John Deere?                    |
| [ ] Como funciona o Vestro na pratica?                             |
| [ ] Quais maquinas mais consomem?                                  |
| [ ] Como e o controle de manutencao?                               |
+--------------------------------------------------------------------+

VALENTINA (Financeiro) - ENTIDADES: NOTAS_FISCAIS, CUSTOS
+--------------------------------------------------------------------+
| [ ] Posso ver o fluxo de entrada de NF?                            |
| [ ] Como esta organizada a planilha de contas a pagar?             |
| [ ] Quanto tempo gasta por semana digitando dados?                 |
| [ ] O que e mais repetitivo no seu trabalho?                       |
+--------------------------------------------------------------------+

CLAUDIO (Geral) - ENTIDADES: PROJECAO_VENDAS, FAZENDAS
+--------------------------------------------------------------------+
| [ ] Posso ver a planilha de projecao ate 2032?                     |
| [ ] Quais relatorios voce mais usa?                                |
| [ ] O que te faria sentir no controle do negocio?                  |
| [ ] Qual dado voce mais sente falta hoje?                          |
+--------------------------------------------------------------------+
```

### 7.2 Dados Quantitativos a Coletar

```
ESTRUTURA TERRITORIAL
+--------------------------------------------------------------------+
| Dado                          | Valor Esperado    | Valor Real     |
+--------------------------------------------------------------------+
| Numero de fazendas            | 3-4               | [            ] |
| Numero de talhoes             | 15-20             | [            ] |
| Numero de silos               | 7-8               | [            ] |
| Area total (ha)               | ~2.150            | [            ] |
+--------------------------------------------------------------------+

MAQUINARIO
+--------------------------------------------------------------------+
| Dado                          | Valor Esperado    | Valor Real     |
+--------------------------------------------------------------------+
| Total de maquinas             | 15-20             | [            ] |
| Com telemetria John Deere     | 2-4               | [            ] |
| Cadastradas no Vestro         | 10+               | [            ] |
| Patrolas/Legado (sem telem.)  | 3-5               | [            ] |
+--------------------------------------------------------------------+

PRODUCAO
+--------------------------------------------------------------------+
| Dado                          | Valor Esperado    | Valor Real     |
+--------------------------------------------------------------------+
| Entradas de graos/dia (safra) | 5-15              | [            ] |
| Abastecimentos/dia            | 10-20             | [            ] |
| Volume diesel/ano (L)         | ~150.000          | [            ] |
+--------------------------------------------------------------------+
```

---

## 8. PROXIMOS PASSOS

### 8.1 Antes da Visita

1. [ ] Imprimir este documento
2. [ ] Preparar tablet para anotacoes
3. [ ] Confirmar com Claudio data/hora
4. [ ] Revisar perguntas por stakeholder

### 8.2 Durante a Visita

1. [ ] Fotografar caderno do Josmar
2. [ ] Fotografar tela do software Leomar
3. [ ] Coletar planilha de frota do Tiago
4. [ ] Coletar planilha de projecao do Claudio
5. [ ] Testar Wi-Fi no secador

### 8.3 Apos a Visita

1. [ ] Consolidar anotacoes neste documento
2. [ ] Criar Diagrama ER visual no Miro
3. [ ] Validar com Joao a modelagem tecnica
4. [ ] Apresentar para Claudio para validacao
5. [ ] Iniciar modelagem do banco PostgreSQL

---

## 9. GLOSSARIO TECNICO

| Termo | Definicao |
|-------|-----------|
| **ER** | Entity-Relationship (Entidade-Relacionamento) |
| **PK** | Primary Key (Chave Primaria) |
| **FK** | Foreign Key (Chave Estrangeira) |
| **1:1** | Um para Um |
| **1:N** | Um para Muitos |
| **N:N** | Muitos para Muitos |
| **Bronze** | Camada de dados brutos |
| **Silver** | Camada de dados tratados |
| **Gold** | Camada de dados cruzados/agregados |
| **Entidade Forte** | Dados sensiveis/core do negocio |
| **Entidade Fraca** | Dados de volume/auditoria |
| **Singularidade** | Dados que identificam pessoa (CPF, nome) |
| **Conector** | Regra de cruzamento entre entidades |

---

## 10. REFERENCIAS

### Reunioes Consultadas

1. `2025-12-15_Estrategia_e_Modelo_Negocio.md`
2. `2025-12-22_Planejamento_Tecnico_Data_Warehouse.md`
3. `2025-12-29_Decisoes_Estrategicas_e_MVP.md`
4. `2025-12-XX_Discovery_Presencial_Claudio_Kugler.md`
5. `2026-01-16_Discovery_Tiago_Maquinario.md`
6. `2026-01-19_Alinhamento_Tecnico_Pos_Discovery.md`
7. `2026-01-27_Design_Plataforma_e_Integracoes.md`
8. `2026-01-28_Git_Workflow_and_GCP.md`
9. `2026-01-29_Design_System_and_AI_Cost.md`
10. `2026-01-30_Product_Definition_and_Business_Model.md`
11. `2026-02-02_Apresentacao_Mockups_Validacao_Conceito.md`
12. `2026-02-03_Alinhamento_Tecnico_Joao_Rodrigo.md`

### Documentos Relacionados

- `01_PREPARACAO_MAPEAMENTO_ENTIDADES.md`
- `02_GUIA_ESTUDO_MODELAGEM_DADOS.md`

---

**Documento preparado por:** DeepWork AI Flows
**Data:** 04/02/2026
**Versao:** 1.0
**Status:** Esboco para validacao

---

> "A plataforma e o front depende muito disso. Esse daqui que a gente precisa, com isso daqui e o ouro da nossa plataforma."
> -- Joao Balzer, CTO (03/02/2026)
