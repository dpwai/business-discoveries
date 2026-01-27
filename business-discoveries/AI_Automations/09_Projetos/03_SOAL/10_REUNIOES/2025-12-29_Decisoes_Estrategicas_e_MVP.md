# Decisões Estratégicas e Definição de MVP - SOAL
**Data da Reunião:** 29 de dezembro de 2025 às 15:51 UTC  
**Participantes:** Rodrigo Kugler, João Vitor Balzer  
**Tipo:** Reunião de planejamento pós-discovery  
**Duração:** ~40 minutos

---

## 1. RESUMO EXECUTIVO - DECISÕES CRÍTICAS 🎯

**PAIN POINT VALIDADO #1 (P0 - CRÍTICO):**  
**Processo Manual de Notas Fiscais** - Valentina imprime nota fiscal, escaneia código de barras, AgriWin puxa dados. Processo **extremamente ineficiente** que pode ser automatizado com pasta rodando job ou app mobile.

**DECISÃO ESTRATÉGICA #1:**  
Usar **N8N** (low-code) para construir MVP - priorizar **regra de negócio** sobre código complexo. Migrar para código seguro depois.

**DECISÃO ESTRATÉGICA #2:**  
Entregas iniciais serão **dados brutos (CSV/TXT)**, não dashboards. Clientes já sabem cruzar dados. Visualização vem depois, baseada no Excel que cliente já usa.

**DECISÃO ESTRATÉGICA #3:**  
**Foco inicial: Agricultura APENAS** (não pecuária). Consolidar primeiro produto antes de expandir.

**DECISÃO ESTRATÉGICA #4:**  
Modelo de negócio: **SaaS + Consultoria + Metodologia** (não só software). Agregar valor ensinando processos de gestão.

**INSIGHT DE MERCADO:**  
AgriWin não integra com planilhas de gestão → **descentralização de dados = oportunidade de negócio**.

---

## 2. DESCOBERTAS - PROCESSOS MANUAIS 🔥

### 🔴 Pain Point #1: Notas Fiscais (P0 - CRÍTICO)

**Processo Atual (Valentina):**
1. Compra é feita → Nota fiscal chega (física ou digital)
2. **Imprime** nota fiscal
3. **Escaneia** código de barras com scanner
4. AgriWin **puxa dados** automaticamente do código de barras
5. Dados entram no sistema para gestão

**Problema Identificado por Rodrigo:**  
> _"Questionou a ineficiência desse processo, sugerindo a criação de uma pasta automatizada ou o uso de um aplicativo para escanear o código de barras com celular, o que facilitaria e mataria uma mão de obra considerável."_

**Soluções Propostas:**

#### Opção 1: Pasta Automatizada (N8N)
- Nota fiscal em PDF vai para pasta monitorada
- N8N lê PDF, extrai código de barras via OCR
- Envia dados para AgriWin (ou direto para Data Warehouse)

#### Opção 2: App Mobile
- Valentina usa celular para escanear código de barras
- App envia dados automaticamente
- Elimina impressão + scanner

#### Opção 3: Power Automate (se cliente tiver Microsoft)
- João sugeriu: se cliente já tem licença Microsoft, usar Power Automate
- Concorrente do N8N, mais integrado ao ecossistema
- Pode ser mais simples para cliente gerenciar

**Impacto:** Economia de **horas semanais** de trabalho manual da Valentina

---

### 🔴 Pain Point #2: Descentralização de Dados (P0)

**Citação (Rodrigo):**  
> _"O Agriwin não tem comunicação com as planilhas de gestão, o que descentraliza os dados e cria uma oportunidade de negócio para a equipe."_

**Realidade Atual:**
- AgriWin: Sistema operacional (compras, vendas, estoque)
- SharePoint Excel: Planejamento financeiro (contas a pagar/receber, orçamento)
- Castrolanda: Insumos e vendas
- **ZERO integração** entre os três

**Oportunidade:**  
Deepwork AI como **camada de integração** que unifica tudo

---

## 3. SETORES MAPEADOS DA SOAL

Rodrigo conseguiu mapear a empresa em **5 setores-chave:**

| Setor | Responsável | Foco | Próxima Ação |
|-------|-------------|------|--------------|
| **Administrativo** | Valentina | Notas fiscais, estoque, contas a pagar/receber | **Reunião marcada** para entender processo de notas e entradas de dados |
| **Maquinário** | Tiago | Gestão de frota, consumo, manutenção | **Reunião marcada** para mapear uso do sistema |
| **Agrícola** | Agrônomo (nome?) | Produção, plantio, colheita | - |
| **Agronomia** | Alessandro | Agroquímicos, sementes, receituário | **Reunião marcada** para mapear uso de defensivos |
| **Financeiro** | Claudio + Valentina | Contas, orçamento, projeções | Já mapeado no discovery |

**Observação Crítica (Rodrigo):**  
> _"Dificuldade em obter uma visualização clara do custo por cultura, um ponto crítico para o cliente."_

---

## 4. DECISÕES TÉCNICAS - MVP

### Stack Tecnológico Definido

#### ETL/Automação: N8N (Low-Code)
**Justificativa (João):**  
> _"Entendo Python e abstrair componentes complexos de codificação, permitindo o foco na regra de negócio. A regra consolidada no N8N poderá ser posteriormente migrada para código mais seguro."_

**Vantagens:**
- Prototipagem rápida
- Foco em regra de negócio (não em código)
- Fácil de demonstrar para cliente
- Migração para Python depois (produção)

**Uso Específico:**
- Leitura de notas fiscais (pasta monitorada)
- Extração de dados de múltiplas fontes
- Transformação e carga no Data Warehouse

---

#### Entrega Inicial: Dados Brutos (CSV/TXT)

**Decisão (João):**  
> _"Inicialmente entregar os dados brutos (CSV, TXT) aos clientes, pois eles já estão habituados e sabem como cruzar as informações, o que seria mais eficaz no início."_

**Motivo:**
- Cliente (Claudio) já usa Excel há 10+ anos
- Sabe cruzar dados manualmente
- **Quick Win:** Automatizar extração, entregar CSV consolidado
- Visualização vem depois

**Ressalva (Rodrigo):**  
Cliente **espera ter uma tela** (já tem AgriWin com dashboard). Não pode ser só CSV.

**Solução Híbrida:**
1. **Fase 1 (MVP):** CSV automatizado + Excel básico
2. **Fase 2:** Dashboard simples (Power BI ou Looker)
3. **Fase 3:** Dashboard customizado full-stack

---

#### Visualização: Power BI ou Looker (Inicial)

**Decisão:**  
Usar ferramentas existentes de BI ao invés de codar tela do zero

**Vantagens:**
- Rápido de implementar
- Cliente pode editar depois
- Foco em **dados corretos**, não em design

**Framework Final (Futuro):**
- React + D3.js (custom)
- Ou manter Power BI se cliente gostar

---

### IA e Análise de Dados: ChatGPT Plus + MCP

**Proposta Revolucionária (João):**  
Conectar SharePoint do cliente como **Motor de Conhecimento de Base (MCP)** dentro do ChatGPT Plus.

**Como Funciona:**
1. SharePoint com planilhas → Conectado via MCP no ChatGPT Plus
2. Cliente pergunta no chat: _"Quanto gastei com fertilizante em outubro?"_
3. ChatGPT lê SharePoint e responde instantaneamente
4. **SEM precisar codar interface** - usa interface do ChatGPT

**Benefícios:**
- Simplicidade extrema
- Cliente já conhece ChatGPT
- Análise natural de dados
- João mencionou: _"Aprendi a desenvolver um motor MCP"_

**Ação Pendente:**  
João vai ensinar Rodrigo a conectar MCP do SharePoint/Drive no "antigravidade"

---

## 5. MODELO DE NEGÓCIO - ALÉM DO SAAS

### Web 2.0 vs Web 3.0

**Web 2.0 (Modelo AgriWin):**  
- Vende software
- Manutenção básica
- Cliente se vira sozinho

**Web 3.0 (Modelo Deepwork AI - Proposta de João):**  
- **SaaS** (software)
- **Desenvolvimento** customizado
- **Manutenção** contínua
- **CONSULTORIA** - Metodologia de gestão

**Diferencial Crítico:**  
> _"A consultoria ensina novas metodologias, como o melhor jeito e mais eficiente de trabalhar no setor, um serviço que o Agroin não oferece."_

---

### Metodologia de Gestão como Produto

**Insight (Rodrigo):**  
> _"O tio já possui uma metodologia de gestão, planilhas de controle e armazena dados há muito tempo. A oferta não deve ser apenas SaaS, mas também uma metodologia de gestão para outros produtores, orientando sobre armazenamento e processos."_

**Estratégia:**
1. **Documentar** metodologia de Claudio (28 anos de dados, planilhas, processos)
2. **Empacotar** como "Metodologia SOAL de Gestão Agropecuária"
3. **Vender** consultoria para implementar em outros produtores
4. **Software** vem como ferramenta para executar a metodologia

**Exemplo Prático:**
- Producer novo: não sabe como organizar dados
- Deepwork: _"Use nossa metodologia SOAL + software para executar"_
- Valor agregado > concorrência

---

## 6. INSIGHTS DE MERCADO E COMPETITIVIDADE

### AgriWin: Forças e Fraquezas

**Fraquezas Identificadas:**

1. **Tentou abraçar muitas funcionalidades** (João):
   > _"O Agroin tentou abraçar muitas funcionalidades, sendo a simplificação uma vantagem competitiva."_

2. **Dashboard priori prioriza dados irrelevantes** (Rodrigo):
   > _"Dashboard do Agriwin priorizava informações menos relevantes, como meteorologia, em vez de dados de gestão."_
   
3. **Zero integração** com ferramentas do cliente (Excel, SharePoint)

4. **Não oferece consultoria** - só vende software

**Oportunidade Deepwork:**
- **Simplicidade** (foco em agricultura, não tudo)
- **Integração** (unifica AgriWin + Excel + Castrolanda)
- **Consultoria** (ensina metodologia)
- **Customização** (específico para dor do cliente)

---

### Realidade de Mercado (Validada)

**Rodrigo:**  
> _"Conversas com outros agricultores mostram que o mercado em geral carece de processos e dados organizados."_

**Exemplo - Bernardo (Isabela Lucera):**
- Usa AgriWin
- Tem dados de **apenas 2 anos**
- Antes: _"trabalhava pagando sem saber exatamente quanto devia"_

**Padrão do Produtor (Claudio):**
- Bom em plantar e colher
- **Fraco em gestão** (precisa de ajuda)

**Nicho Ideal:** Produtores médios/grandes que já têm tecnologia mas não extraem valor

---

## 7. CASE DE SUCESSO INTERNO - MAQUINÁRIO

**Insight de Tiago (compartilhado por Rodrigo):**  
Descobriram via **dados** que tratores de 210 cavalos eram desnecessários para certas atividades.

**Análise:**
- Trator 210cv: R$ X (caro, alto consumo, pneus caros)
- Trator 130cv ou 170cv: R$ Y (mais barato, mesmo resultado)
- **Economia:** Custos operacionais + compra

**Resultado:**  
Mudaram estratégia de compra baseado em **dados**, não "achismo"

**Aplicação:** Isso é exatamente o que o dashboard de custo pode entregar para todas as áreas (não só máquinas)

---

## 8. INTEGRAÇÃO CASTROLANDA - PRÓXIMOS PASSOS

### API Confirmada (Provavelmente Existe)

**Rodrigo:**  
> _"Acredita que a Castrolanda possui uma API que o Agriwin utiliza para leitura de dados."_

**Ação Definida:**  
João encorajou Rodrigo a **buscar contato técnico na Castrolanda** através do tio Claudio.

**Justificativa (João):**  
> _"Interesse deles em ajudar, já que o tio é um cliente que gera lucro."_

**Próximo Passo:**
1. Rodrigo pergunta para Claudio: _"Quem é o contato de TI na Castrolanda?"_
2. Solicita documentação da API (ou web services)
3. Valida se é REST, SOAP, ou outro protocolo

---

## 9. OPORTUNIDADES PARALELAS - DATA CENTER

### Contexto: Projeto Maringá

**João mencionou:**  
> _"Projeto de data center de **R$ 6 bilhões** em Maringá, usando fazenda eólica para autoconsumo de energia."_

**Insights:**
- Empresas estrangeiras investindo no Brasil (energia renovável)
- **Incentivos federais:** Isenção de impostos para data centers
- Energia limpa é requisito

---

### Proposta: SOAL + Data Center

**Oportunidades Identificadas:**

#### 1. Energia Solar (já existe infraestrutura)
- Claudio tem 200 placas solares
- Projeto original: 700 placas (rejeitado pela Copel)
- **Possibilidade:** Construir fazenda solar para data center

#### 2. Biodigestor + Pecuária
**João sugeriu:**  
> _"Construir biodigestor junto a data center em Castro, aproveitando esterco do avô de Rodrigo como fonte de energia limpa."_

**Benefícios:**
- Esterco → Biogás → Eletricidade (limpa)
- Resfriamento de máquinas com água não potável (processo de limpeza de água)
- Receita adicional (venda de energia ou hosting de data center)

#### 3. Modelo de Negócio
- Data center terceiro usa infraestrutura da SOAL
- SOAL fornece energia renovável (solar + biodigestor)
- **Localização:** Castro (próximo de centros urbanos, terra barata)

**Status:** Ideação (não é prioridade agora, mas vale mapear)

---

## 10. PRÓXIMOS PASSOS - AÇÕES DEFINIDAS

### ✅ Imediato (Esta Semana)

**Rodrigo:**
1. ✅ **Marcar reunião com Valentina (Administrativo)**
   - Entender processo completo de notas fiscais
   - Mapear entrada de dados de estoque
   - Validar outros processos manuais

2. ✅ **Marcar reunião com Agrônomo (Alessandro ou outro)**
   - Mapear uso de agroquímicos e sementes
   - Entender receituário e aplicação

3. ✅ **Marcar reunião com Tiago (Maquinário)**
   - Aprofundar em dados John Deere
   - Entender sistema de TAG de diesel

4. ✅ **Perguntar para Claudio:**
   - Tem ChatGPT Plus?
   - Contato técnico da Castrolanda (API)

**João:**
5. ✅ **Ensinar Rodrigo:**
   - Conectar MCP do SharePoint/Drive no Antigravity
   - Configurar .mmd dentro do ChatGPT

---

### 📚 Curto Prazo (2 Semanas)

6. ✅ **Terminar mapeamento de cada pilar**
   - Administrativo (notas, estoque)
   - Agronomia (defensivos, sementes)
   - Maquinário (John Deere, TAG)
   - Outras entradas: Secador, Sistema diesel

7. ✅ **Montar arquitetura de dados completa**
   - Fontes identificadas
   - Fluxo ETL desenhado
   - Tecnologias definidas

8. ✅ **Prototipar automação de notas fiscais (N8N)**
   - Pasta monitorada → Lê PDF → Extrai dados
   - Demonstrar para Valentina

---

### 🏗️ Médio Prazo (1 Mês)

9. ✅ **MVP - Dados Brutos:**
   - CSV consolidado de custos por cultura
   - Atualização semanal (job automático)
   - Entrega via e-mail ou pasta compartilhada

10. ✅ **Dashboard Inicial (Power BI ou Looker):**
    - Custo/ha por cultura
    - Comparativo com mercado
    - Projeção de margem

11. ✅ **Documentar Metodologia SOAL:**
    - Processos de gestão do Claudio
    - Template de planilhas
    - Guia de boas práticas

---

## 11. TECNOLOGIAS E FERRAMENTAS - DECISÕES FINAIS

| Função | Ferramenta Escolhida | Alternativa | Justificativa |
|--------|---------------------|-------------|---------------|
| **ETL/Automação** | **N8N** | Power Automate | Low-code, foco em regra de negócio, migra para Python depois |
| **Data Warehouse** | PostgreSQL (provável) | BigQuery, Snowflake | A definir (baixo custo inicial) |
| **BI/Visualização** | **Power BI** ou **Looker** | Custom (React+D3) | Rápido, cliente pode editar |
| **IA/Análise** | **ChatGPT Plus + MCP** | Custom chatbot | Simplicidade, cliente conhece |
| **Notas Fiscais** | N8N ou **Power Automate** | App mobile custom | Se cliente tem Microsoft, usar Power Automate |
| **Integração** | API Castrolanda | Scraping | Preferir API oficial |
| **Código (Futuro)** | Python | - | Produção após validação N8N |

---

## 12. RISCOS E MITIGAÇÕES

### 🟡 Risco #1: Cliente Espera Dashboard (Não Só CSV)

**Risco:**  
João propôs CSV, mas Rodrigo alertou que cliente espera tela.

**Mitigação:**  
- **Fase 1:** CSV + Excel básico (1-2 semanas)
- **Fase 2:** Dashboard simples Power BI (2-3 semanas depois)
- Gerenciar expectativa: _"Primeira entrega são dados corretos, segunda é visualização"_

---

### 🟡 Risco #2: Dependência de API Castrolanda

**Risco:**  
Se API não existir ou for fechada, integração falha.

**Mitigação:**
- **Plano A:** API oficial (solicitar via Claudio)
- **Plano B:** Scraping do portal Castrolanda
- **Plano C:** Upload manual de relatório (temporário)

---

### 🟢 Risco #3: Complexidade Técnica (N8N → Python)

**Não é Risco:**  
João confirmou que sabe fazer migração. N8N valida regra, Python produtiza.

---

## 13. INSIGHTS E APRENDIZADOS

### 💡 Descentralização = Oportunidade

**João (conceito Web 3.0):**  
> _"Focando na descentralização do controle dos dados."_

**Aplicação:**
- Cliente controla dados (não trancado em SaaS fechado)
- Deepwork facilita acesso e integração
- Modelo mais sustentável e escalável

---

### 💡 Simplicidade > Complexidade

**João:**  
> _"AgriWin tentou abraçar muitas funcionalidades. Simplificação é vantagem competitiva."_

**Estratégia Deepwork:**
- **Foco:** Agricultura (não pecuária inicialmente)
- **Foco:** Custo (não todas as métricas possíveis)
- **Foco:** Dados corretos (não dashboard bonito sem valor)

---

### 💡 Consultoria > Software

**Rodrigo + João:**  
Metodologia de gestão vale tanto ou mais que o software.

**Pitch Futuro:**
> _"Não vendemos só um sistema. Vendemos a metodologia que faz o Claudio Kugler gerir R$ 20M/ano em agricultura com apenas 2 pessoas no administrativo."_

---

## 14. CONCLUSÃO - NORTE DEFINIDO

### ✅ Temos Clareza Total

**O QUE construir:**
1. Automação de notas fiscais (Valentina)
2. Dashboard de custo por cultura (Claudio)
3. Integração AgriWin + Excel + Castrolanda

**COMO construir:**
- N8N (MVP rápido)
- CSV inicial, dashboard depois
- Consultoria + Metodologia (não só software)

**PARA QUEM:**
- SOAL (piloto)
- Produtores médios/grandes da região (escala)

**POR QUÊ vale a pena:**
- Mercado desorganizado (oportunidade)
- AgriWin limitado (espaço para competir)
- Metodologia é diferencial (não replicável)

---

### 🚀 Momentum Confirmado

- Concessionária (Daniel) vai gerar receita inicial
- SOAL é cliente ideal (dados, abertura, influência)
- João tem skill técnico (N8N, Python, MCP)
- Rodrigo tem skill de produto (mapeamento, comunicação)

**Próxima reunião:** Após mapeamento completo dos 5 setores + reuniões com stakeholders.

---

**FIM DO RELATÓRIO**  
*Gerado em: 29/12/2025*  
*Próximo Documento: Após reuniões com Valentina, Alessandro e Tiago*
