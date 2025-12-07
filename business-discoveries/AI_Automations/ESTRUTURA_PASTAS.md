# 📁 Estrutura de Pastas - Deepwork AI Flows

Este documento explica a organização das pastas e onde encontrar cada tipo de informação.

## 🗂️ Visão Geral da Estrutura

```
AI_Automations/
├── 01_Visao_Negocio/          # Visão geral e estrutura do negócio
├── 02_Identidade_Marca/       # Identidade da marca Deepwork AI Flows
├── 03_Identidade_Visual/      # Logos, cores, tipografia
├── 04_Pesquisa_Mercado/       # Pesquisa de mercado e segmentos
├── 05_Contatos_Clientes/       # Contatos potenciais e análises
├── 06_MVP_Produto/            # Definições de MVP e perguntas por segmento
├── 07_Operacional/            # Templates, roteiros, estruturas
├── 08_Ferramentas/            # Scripts e ferramentas auxiliares
├── README.md                   # Documento principal (comece aqui!)
└── ESTRUTURA_PASTAS.md         # Este arquivo
```

---

## 📂 Detalhamento por Pasta

### 01_Visao_Negocio
**O que contém:** Documentos fundamentais sobre a visão e estrutura do negócio

**Arquivos principais:**
- `VISAO_NEGOCIO_CONSOLIDADA.md` ⭐ **COMECE AQUI** - Visão consolidada do negócio
- `CONTEXTO_NEGOCIO.md` - Perguntas estratégicas para contexto completo
- `ESTRUTURA_BUSINESS_PLAN.md` - Template para Business Plan
- `SOCIEDADE_E_PARCEIRIA.md` ⚠️ **CRÍTICO** - Estrutura da sociedade

**Quando usar:** Para entender a visão geral do negócio, planejar estrutura societária, criar business plan

---

### 02_Identidade_Marca
**O que contém:** Toda a identidade da marca Deepwork AI Flows

**Arquivos principais:**
- `IDENTIDADE_MARCA_LANDING_PAGE.md` ⭐ **PRINCIPAL** - Documento central com toda identidade
- `DECISAO_NOME_DEEPWORK_AI_FLOWS.md` ✅ - Nome oficial aprovado
- `MISSAO_VISAO_VALORES.md` - Missão, visão e valores
- `POSICIONAMENTO_DIFERENCIACAO.md` - Posicionamento de mercado
- `PUBLICO_ALVO_PERSONAS.md` - Público-alvo e personas
- `TOM_DE_VOZ.md` - Diretrizes de comunicação

**Documentos de referência:**
- `DECISAO_TAGLINE.md` - Decisão do tagline
- `TAGLINES_DEEPWORK_AI_FLOWS.md` - Sugestões de taglines
- `ANALISE_NOME_MARCA_SUGESTOES.md` - Análise inicial de nomes
- `SUGESTOES_NOME_MARCA_V2.md` - Segunda rodada de sugestões
- `SUGESTOES_NOME_V3_UNICOS.md` - Terceira rodada de sugestões

**Quando usar:** Para construir landing page, criar materiais de marketing, definir comunicação

---

### 03_Identidade_Visual
**O que contém:** Logos, identidade visual e materiais gráficos

**Arquivos principais:**
- `IDENTIDADE_VISUAL_GERADA.md` - Descrição completa da identidade visual
- `README_LOGOS.md` - Guia de uso dos logos
- `preview_logos.html` - Visualização de todos os logos

**Logos SVG:**
- `logo_conceito.svg` - Logo horizontal principal
- `logo_vertical.svg` - Logo vertical
- `logo_icone.svg` - Ícone/Isotipo isolado
- `logo_monocromatico.svg` - Versão monocromática (preto)
- `logo_fundo_escuro.svg` - Versão para fundo escuro

**Prompts e guias:**
- `PROMPT_IDENTIDADE_VISUAL_GEMINI.md` - Prompt detalhado para geração
- `PROMPT_GEMINI_3_PRONTO.md` - Prompt pronto para uso
- `CONVERTER_SVG_PNG.md` - Guia para converter SVGs em PNGs

**Quando usar:** Para usar logos em materiais, criar apresentações, desenvolver landing page

---

### 04_Pesquisa_Mercado
**O que contém:** Pesquisa detalhada de mercado sobre os segmentos potenciais

**Arquivos principais:**
- `COMPARACAO_SEGMENTOS.md` - Matriz de comparação dos segmentos
- `README_PESQUISA.md` - Guia e estrutura da pesquisa

**Pesquisas por segmento:**
- `pesquisa_consorcios.md` - Dados de mercado sobre consórcios
- `pesquisa_concessionarias.md` - Dados de mercado sobre concessionárias
- `pesquisa_ramo_medico.md` - Dados de mercado sobre ramo médico

**Análise de concorrência:**
- `concorrencia_consorcios.md`
- `concorrencia_concessionarias.md`
- `concorrencia_ramo_medico.md`

**Insights consolidados:**
- `insights_consorcios.md`
- `insights_concessionarias.md`
- `insights_ramo_medico.md`

**Comparação consolidada:**
- `comparacao_segmentos_pesquisa.md` ⭐ Comparação baseada em pesquisa

**Quando usar:** Para entender o mercado, comparar segmentos, tomar decisões estratégicas

---

### 05_Contatos_Clientes
**O que contém:** Contatos potenciais e análises de clientes

**Arquivos principais:**
- `CONTATOS_POTENCIAIS.md` ⭐ - Documento consolidado com todos os contatos
- `ANALISE_INICIAL_RECOMENDACOES.md` ⭐ - Análise e recomendações para primeiro MVP

**Quando usar:** Para gerenciar contatos, priorizar clientes, planejar abordagens

---

### 06_MVP_Produto
**O que contém:** Definições de MVP e perguntas específicas por segmento

**Arquivos principais:**
- `MVP_DEFINITION.md` - Guia para definição do MVP
- `PERGUNTAS_ESPECIFICAS_CONCESSIONARIAS.md` - Perguntas sobre concessionárias
- `PERGUNTAS_ESPECIFICAS_CONSORCIOS.md` - Perguntas sobre consórcios
- `PERGUNTAS_ESPECIFICAS_RAMO_MEDICO.md` - Perguntas sobre ramo médico

**Quando usar:** Para definir MVP, preparar entrevistas com clientes de segmentos específicos

---

### 07_Operacional
**O que contém:** Templates, roteiros e estruturas operacionais

**Arquivos principais:**
- `ROTEIRO_ENTREVISTA.md` 🎤 **PRÓXIMO PASSO** - Roteiro para entrevista consultiva
- `TEMPLATE_RELATORIO_CLIENTE.md` 📋 - Template para relatório pós-entrevista
- `ESTRUTURA_GITHUB.md` - Estrutura proposta para repositório GitHub

**Quando usar:** Para conduzir entrevistas, criar relatórios, organizar repositório

---

### 08_Ferramentas
**O que contém:** Scripts e ferramentas auxiliares

**Scripts de conversão de logos:**
- `gerar_pngs.py` - Script Python (requer cairosvg)
- `gerar_pngs_simples.py` - Script alternativo (requer svglib)
- `gerar_pngs.bat` - Script batch para Windows
- `gerar_pngs_inkscape.bat` - Script para usar com Inkscape

**Quando usar:** Para converter logos SVG em PNG, automatizar tarefas

---

## 🎯 Fluxos de Trabalho Comuns

### Para entender o negócio pela primeira vez:
1. `README.md` - Visão geral
2. `01_Visao_Negocio/VISAO_NEGOCIO_CONSOLIDADA.md` - Visão consolidada
3. `02_Identidade_Marca/IDENTIDADE_MARCA_LANDING_PAGE.md` - Identidade da marca

### Para preparar uma entrevista com cliente:
1. `07_Operacional/ROTEIRO_ENTREVISTA.md` - Roteiro de entrevista
2. `06_MVP_Produto/PERGUNTAS_ESPECIFICAS_*.md` - Perguntas do segmento
3. `05_Contatos_Clientes/CONTATOS_POTENCIAIS.md` - Informações do contato

### Para criar materiais de marketing:
1. `02_Identidade_Marca/IDENTIDADE_MARCA_LANDING_PAGE.md` - Identidade completa
2. `03_Identidade_Visual/` - Logos e identidade visual
3. `02_Identidade_Marca/TOM_DE_VOZ.md` - Diretrizes de comunicação

### Para pesquisar mercado:
1. `04_Pesquisa_Mercado/COMPARACAO_SEGMENTOS.md` - Comparação geral
2. `04_Pesquisa_Mercado/pesquisa_*.md` - Pesquisas específicas
3. `04_Pesquisa_Mercado/insights_*.md` - Insights consolidados

### Para definir MVP:
1. `06_MVP_Produto/MVP_DEFINITION.md` - Guia de definição
2. `05_Contatos_Clientes/ANALISE_INICIAL_RECOMENDACOES.md` - Recomendações
3. `07_Operacional/TEMPLATE_RELATORIO_CLIENTE.md` - Template de análise

---

## 📝 Notas

- Todos os caminhos nos documentos foram atualizados para refletir a nova estrutura
- Se encontrar referências a caminhos antigos, avise para atualização
- A numeração das pastas (01_, 02_, etc.) indica uma ordem lógica de importância/uso
- Documentos marcados com ⭐ são especialmente importantes
- Documentos marcados com ⚠️ são críticos e devem ser priorizados

---

## 🔄 Atualizações

- **v3.0** (Data): Reorganização completa em estrutura de pastas categorizadas
  - Criação de 8 pastas principais
  - Movimentação de todos os arquivos para pastas apropriadas
  - Atualização do README.md com nova estrutura
  - Criação deste guia de estrutura

