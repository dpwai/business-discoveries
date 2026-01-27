# Relatório de Discovery Presencial - SOAL
**Data da Reunião:** Dezembro de 2025 (data exata a confirmar)  
**Participantes:** Rodrigo Kugler, Claudio Kugler  
**Local:** Fazenda Santana do Iapó - Piraí do Sul, PR  
**Duração:** ~90 minutos  
**Qualidade da Transcrição:** Média (transcrição de áudio com alguns erros)

---

## 1. RESUMO EXECUTIVO - DESCOBERTAS CRÍTICAS 🎯

**PAIN POINT VALIDADO (De 1 Milhão):** Claudio quer **visualizar em tempo real o custo da safra em andamento**. Hoje ele tem os dados fragmentados em 3 sistemas (Excel SharePoint, Castrolanda, AgriWin) e precisa gastar **meio dia** para compilar manualmente. Ele expressou MÚLTIPLAS VEZES: _"Eu queria estar olhando numa tela e dizendo: até agora o meu custo de soja tá assim"_.

**SOLUÇÃO CLARA IDENTIFICADA:** Dashboard de **Cost Accounting** (Contabilidade de Custo) em tempo real mostrando custo por hectare de soja/milho/feijão, comparado com preço de mercado e margem projetada.

**POTENCIAL VALIDADO:** Fazenda tem **28 anos de dados históricos** (desde 1996) - ouro para Machine Learning. Claudio confirmou que "não é todo produtor que tem isso".

**STAKEHOLDER CHAVE ADICIONAL:** Tiago (genro) - responsável por máquinas e tecnologia, já trabalhando com John Deere Operations Center. Claudio sugeriu começar por máquinas.

---

## 2. ESTRUTURA OPERACIONAL DA SOAL

### Setores da Fazenda (Visão de Claudio)
1. **Agricultura** - Soja, milho, feijão, trigo (~2.100 ha)
2. **UBG (Unidade Beneficiamento de Grãos)** - Secador (~R$ 20M investidos), armazenagem, sementes
3. **Pecuária de Corte** - Gado (~200 ha, gera R$ 2,3M/ano para liquidez mensal)
4. **Máquinas e Equipamentos** - Setor separado (~R$ 20M+ investidos)
5. **Energia Solar** - 200 placas (sustenta secador)

### Números Validados
- **Área Agrícola Total:** ~2.100 ha (safra 25/26)
  - Soja: 1.800 ha
  - Milho: 373 ha
  - Feijão: 177 ha
- **Funcionários:** Rodrigo + Valentina (administrativa) + equipes operacionais
- **Faturamento Agrícola 2024:** ~R$ 20M
- **Déficit de Caixa 2025:** R$ 6M (contexto: investimentos pesados + queda de preço pós-pandemia)
- **Compromissos 2026:** R$ 32M (custeio + arrendamentos + máquinas + terra)

---

## 3. SHADOW IT E FONTES DE DADOS CONFIRMADAS 🎯

### ✅ CONFIRMADO: 3 Fontes de Dados Principais

#### 1. **SharePoint (Excel na Nuvem)** - MANUAL
**Planilhas Identificadas:**
- `Contas a Pagar` (programação semanal de caixa)
- `Contas a Receber` 
- `Orçamento` (projeção anual de R$ 32M)
- `Mão-de-Obra` (folha de pagamento)

**Processo Manual Crítico (Valentina):**
- Vê saldo de contas diariamente
- Programa semanalmente pagamentos com Claudio
- Toda segunda-feira: "O que temos pra pagar de segunda a domingo?"
- Concentra: Banco, cooperativa, pagamentos, documentação contábil, ICMS, folha

#### 2. **Castrolanda (Cooperativa)** - AUTOMÁTICO via AgriWin API
**Dados Disponíveis:**
- Insumos comprados (fertilizantes, defensivos, sementes)
- Produção vendida
- Financiamentos/empréstimos
- Saldo devedor/credor
- **Extrato Completo** ("vida na Castrolanda")

**Exemplo Real Mostrado:**
- Saldo atual: +R$ 1,5M
- Insumos a retirar safra 25/26: -R$ 918k
- **Resultado líquido:** -R$ 200k (devendo)
- Dívida total cooperativa: **R$ 9M** (custeio soja + trigo)

#### 3. **AgriWin (ERP)** - MANUAL + API Castrolanda
**Funcionalidades Usadas:**
- Compras (histórico completo por fornecedor)
- Estoque
- Controle de máquinas (abastecimento via TAG agora, antes manual)
- Manutenção (avisa revisões)
- Movimento financeiro
- **Limitação Crítica:** Histórico de apenas **2 anos** (financiamentos antigos não aparecem)

---

## 4. PAIN POINTS VALIDADOS - PRIORIDADE ABSOLUTA 🔥

### Pain Point #1: CUSTO EM TEMPO REAL (CRÍTICO - P0)
**Severidade:** MÁXIMA  
**Citação Literal (Claudio - repetida 4x):**  
> _"Eu queria ver eu gostaria de enxergar assim com tudo que eu fiz até agora qual que é o custo desses 1800 ha de soja quanto que tá o custo hoje quanto que eu já gastei por hectare."_

> _"Eu queria estar enxergando a tela e dizer assim nós começamos a safra 25/26, como é que tá o gráfico, como que ela tá. Eu não consigo enxergar isso hoje, eu não não tenho."_

**Processo Atual (MANUAL):**
1. Pegar dados Castrolanda (R$ 6M em insumos soja)
2. Dividir por 1.800 ha = R$ 3.333/ha
3. Calcular sacas necessárias: R$ 3.333 ÷ R$ 140/saca = 24 sacas/ha
4. Margem: 75 sacas produzidas - 24 sacas custo = 51 sacas lucro
5. **Tempo gasto:** "Tenho que sentar e ficar meio dia aqui pra montar isso"
6. **Dados faltando:** Óleo diesel, mão-de-obra, manutenção, investimentos

**Impacto Financeiro:** Decisões estratégicas baseadas em "achismo" por falta de visão consolidada  
**Solução Proposta:** Dashboard com custo/ha atualizado automaticamente (diário/semanal)

---

### Pain Point #2: Fragmentação de Dados
**Severidade:** Alta  
**Citação:**  
> _"Eu tenho informação na Castrolanda, eu tenho informação na AgriWin, eu tenho informação do Excel. Como que eu faço pra poder juntar isso e conseguir ter as informações mais instantâneas?"_

**Impacto:** Claudinha precisa de 3 sistemas abertos simultaneamente para tomar decisões

---

### Pain Point #3: Almoxarifado Não Automatizado
**Severidade:** Média  
**Mencionado:** Tiago ainda não estruturou controle de peças por Machine Learning  
**Problema:** Peças críticas (ex: correias) quebram todo ano mas controle é manual/memória  
**Solução Futura:** ML para prever necessidade de estoque

---

### Pain Point #4: AgriWin Limitado para Gestão
**Severidade:** Alta  
**Citação:**  
> _"Ele não tá me ajudando na gestão. [...] Ele é uma empresa que montou um software, vende esse software, é legal pra ter informações mas ele não tá me ajudando na gestão."_

**Limitações Identificadas:**
- Histórico de apenas 2 anos
- Não integra com Excel (SharePoint)
- Bom para consultar, ruim para projetar

---

## 5. QUICK WINS IDENTIFICADOS ⚡

### Quick Win #1: Dashboard de Custo da Safra (P0)
**Entregas:**
1. Custo/ha por cultura (soja, milho, feijão) atualizado semanalmente
2. Comparativo: Custo vs. Preço de Mercado vs. Margem Projetada
3. Breakdown: Fertilizantes, defensivos, sementes, óleo diesel, mão-de-obra
4. Projeção de receita (baseado em produtividade média histórica)

**KPIs Principais:**
- Custo total atual (R$)
- Custo por hectare (R$/ha)
- Custo em sacas (sacas/ha necessárias para cobrir custo)
- Margem projetada (R$/ha e sacas/ha disponíveis)
- Progresso: % do custo total estimado já comprometido

---

### Quick Win #2: TV com Indicadores na Fazenda
**Sugestão do Claudio:**  
> _"Até você me deu uma ideia agora de eu jogar pro Roberto [segurança], eu tenho um monte de câmera na fazenda, botar uma televisão."_

**Implementação:** Dashboard em TV mostrando progresso de plantio, estoque, indicadores do dia

---

### Quick Win #3: Integração Automática SharePoint → Dashboard
**Tecnologia:** Conexão direta com Excel no SharePoint (mais simples que API AgriWin)  
**Vantagem:** Claudio/Valentina continuam usando Excel, mas dados refletem instantaneamente no dashboard

---

## 6. DADOS HISTÓRICOS - OURO PARA ML 💎

**DESCOBERTA CRÍTICA:** Fazenda tem dados desde **safra 1996** (28 anos!)

**Dados Disponíveis por Gleba:**
- Produtividade por safra (kg/ha ou sacas)
- Cultura plantada (rotação de culturas)
- Tipo de semente (transgênica, convencional, intacta)
- Histórico de problemas (ex: granizo 24/25 reduziu 99ha de 4.600 para 2.600 kg/ha)

**Exemplo Mostrado - Gleba Lagoa (24ha):**
- Safra 2016: 1.960 sacas
- Safra 2023/24: 1.615 sacas (seca prejudicou)
- **Potencial ML:** Prever produtividade com base em clima, solo, rotação

**Citação (Claudio):**  
> _"Isso é interessante também [...] pegar gleba por gleba ver o que foi plantado no ano, qual a produtividade da gleba."_

---

## 7. STAKEHOLDERS E PAPÉIS

| Nome | Cargo | Responsabilidades | Insights da Reunião |
|------|-------|-------------------|---------------------|
| **Claudio Kugler** | Diretor/Proprietário | Decisões estratégicas, relacionamento Castrolanda | **Principal usuário** do dashboard. Quer custo em tempo real. |
| **Valentina** | Administrativa | Contas a pagar/receber, banco, cooperativa, contabilidade, RH, ICMS | Usa Excel SharePoint, programa pagamentos semanalmente com Claudio |
| **Tiago** | Gerente de Máquinas (genro) | Tecnologia, manutenção, almoxarifado, otimização de frota | Já trabalha com John Deere Ops Center. **Claudio sugeriu começar com máquinas** |
| **Alessandro** | Agrônomo | Receituário agronômico, cuidado com planta, decisões de defensivos | Trouxe insight recente: fábrica biológicos 2x mais cara que mercado |
| **Leomar** | Armazenagem | Beneficiamento de grãos, padrão industrial, secador | Cuida do produto pós-colheita |
| **Camila** | Pecuária (usa AgriWin pecuário) | Gado de corte, vende 1 lote/mês (R$ 2,3M/ano) | Gera liquidez mensal para folha de pagamento |
| **Rafael** | Serviços de solo (empresa terceira) | Análise de solo, aplicação de calcário/gesso/nitrogênio | Faz coleta com trator/quadriciclo, manda para Fundação ABC |

---

## 8. DECISÕES TÉCNICAS E ESTRATÉGICAS

### Onde Começar? (Decisão do Claudio)
**Opção 1 (Preferida por Claudio):**  
> _"Eu quero começar pelas informações de custo. [...] Começar a entender, ver isso de uma forma mais instantânea."_

**Opção 2 (Sugerida por Rodrigo):**  
Máquinas (Tiago) - já tem estrutura de dados boa via John Deere

**DECISÃO:** Começar por **Custo** (Claudio) e explorar **Máquinas** (Tiago) em paralelo

---

### O Que EVITAR (Confirmado)
✅ **Área Financeira Básica:** Contas a pagar/receber (Valentina já gerencia bem no Excel)  
✅ **Feijão:** Direto para mercado externo, Castrolanda não participa  
✅ **Substituir AgriWin Completamente:** Claudio usa há anos, conhece bem  

---

### Integrações Necessárias

**P0 - Crítico:**
- [x] **Castrolanda** - API já existe (via AgriWin), usar mesma
- [x] **SharePoint Excel** - Conexão direta (mais simples)
- [ ] **AgriWin** - Validar se tem API própria ou só via Castrolanda

**P1 - Alta:**
- [ ] **John Deere Operations Center** - Conversar com Tiago (chaves de API)
- [ ] **Fundação ABC** - Análises de solo (validar formato de dados)

**P2 - Média:**
- [ ] **Dados Históricos 1996-2017** - Estão em pastas salvas, precisam migração

---

## 9. BENCHMARK - AGREWIN

### O Que AgriWin Faz Bem
✅ Integração automática Castrolanda  
✅ Consulta histórica de compras/vendas  
✅ Controle de máquinas (com TAG de abastecimento)  
✅ Relatórios por categoria  
✅ Alertas de manutenção  

### Limitações Críticas
❌ **Histórico:** Apenas 2 anos (financiamentos antigos somem)  
❌ **Gestão:** Não ajuda em projeções/decisões estratégicas  
❌ **Custo:** Não calcula custo/ha consolidado  
❌ **Excel:** Zero integração com planilhas  
❌ **Customização:** Software padrão, sem personalização  

### Precificação AgriWin
- **Custo:** ~R$ 400/mês (agrícola + pecuário)  
- **Modelo:** Valor fixo (não por hectare)  
- **Distribuição:** Via Castrolanda  
- **Histórico:** Fundador (Proença) era programador Fundação ABC (1997)

---

## 10. CONTEXTO DE NEGÓCIO - INSIGHTS

### Desafio Financeiro Atual
- **2021-2022 (Pandemia):** Soja R$ 100 → R$ 180 (lucro alto)
- **2023-2025:** Soja R$ 180 → R$ 120, mas insumos continuaram altos
- **Resultado:** Déficit de caixa de R$ 6M
- **Estratégia:** Investimentos pesados (secador R$ 20M, máquinas R$ 20M+, terra)

### Decisão Estratégica - Feijão
**Análise de Claudio:**
- Feijão: R$ 7.000/ha custo, R$ 9.000/ha faturamento = R$ 2.000/ha margem
- Soja: R$ 5.500/ha custo, R$ 10.500/ha faturamento = R$ 4.500/ha margem
- **Decisão:** Reduziu feijão de 400ha para 177ha (maior margem em soja, menor risco)

### Pecuária Como Liquidez
- **Camila** vende 1 lote/mês
- R$ 2,3M/ano em 200ha (vs. R$ 20M/ano em 2.000ha agrícola)
- **Uso:** Paga toda folha de pagamento (liquidez mensal garantida)

---

## 11. TECNOLOGIA E INOVAÇÃO NA SOAL

### John Deere - Partnership Estratégico
**Contexto:** Fazenda é **modelo de atuação** da John Deere na região

**Por quê?**  
> _"Normalmente o cara compra máquina de R$ 3 milhões, a máquina fornece um monte de informação, mas se eu não der acesso a John Deere, eles não sabem o que acontece. Muitos produtores não querem gastar tempo nisso. Quando eu destinei o Tiago [para tecnologia], os caras abraçaram ele."_

**Tecnologias Implementadas (Tiago):**
- **Pulverizadores:** 2 grandes com Starlink, se comunicam (um desliga onde outro já passou) → 0% desperdício
- **Plantadeiras:** Desligamento automático de sementes → **8% ganho em custo** (milho)
- **Abastecimento:** TAG automática (antes planilha manual semanal) → Agora instantâneo no AgriWin

---

### Energia Solar
- **Projeto Original:** 700 placas (500W cada) para hotel fazenda
- **Problema:** Copel não aprovou (rede local não suporta)
- **Implementado:** 200 placas sustentam secador
- **Inspiração:** Portugal tem fazendas solares inteiras

---

### Biológicos - Case de Decisão Data-Driven
**Situação:** Fazenda tinha fábrica de biológicos in-loco (multiplicação)  
**Insight Alessandro:** Produto 2x mais caro que mercado atual  
**Decisão Claudio:** Encerrar contrato, comprar pronto  
**Economia:** R$ 200-250k/ano  

**Citação:**  
> _"Ele teve essa visão, eu não tenho essa visão. [...] Ele chegou e falou: não tá valendo a pena."_

---

## 12. OPORTUNIDADES DE PRODUTO - DEEPWORK AI

### Produto Core: Cost Accounting Dashboard
**Objetivo:** Substituir "meio dia de trabalho manual" por visão em tempo real

**Funcionalidades (MVP):**
1. **Custo por Cultura**
   - Soja: R$ X/ha (atualizado automaticamente)
   - Milho: R$ Y/ha
   - Feijão: R$ Z/ha

2. **Breakdown de Custo**
   - Fertilizantes (Castrolanda)
   - Defensivos (Castrolanda)
   - Sementes (Castrolanda)
   - Óleo diesel (AgriWin)
   - Mão-de-obra (SharePoint)
   - Manutenção máquinas (AgriWin)
   - Arrendamentos (SharePoint)

3. **Comparativo Mercado**
   - Preço soja hoje: R$ 140/saca
   - Sacas necessárias para cobrir custo: 24/ha
   - Sacas disponíveis (margem): 51/ha
   - Margem R$: R$ 7.140/ha

4. **Projeção de Safra**
   - Produtividade média histórica: 4.700 kg/ha (soja)
   - Área plantada: 1.800 ha
   - Projeção faturamento: R$ 15,75M (se R$ 140/saca)

**Fontes de Dados:**
- Castrolanda (API via AgriWin)
- SharePoint (direct connect Excel)
- AgriWin (validar API ou scraping)

---

### Módulo Futuro: Machine Learning - Produtividade
**Objetivo:** Usar 28 anos de dados para prever safra

**Inputs:**
- Histórico de produtividade por gleba
- Rotação de culturas
- Análises de solo (Fundação ABC)
- Clima histórico
- Problemas (granizo, seca, praga)

**Output:**
- Previsão de sacas/ha por gleba
- Identificar glebas de baixa performance (focar energia em melhores áreas)

---

### Módulo Futuro: Almoxarifado Preditivo (Tiago)
**Objetivo:** ML para prever necessidade de peças

**Exemplo (Claudio):**  
> _"Tem uma correia que arrebenta todo ano, então tem um estoque."_

**Dados Necessários:**
- Histórico de quebras (AgriWin manutenção)
- Horas trabalhadas por máquina
- Condições de uso (cultura, terreno)

---

## 13. BARREIRAS E RISCOS

### Risco #1: Energia/Familiaridade com IA
**Observação:** Claudio é **aberto** a tecnologia mas reconhece limitação  
**Citação:**  
> _"Eu não tenho conhecimento pra fazer isso rodar com inteligência artificial. Se você me traz uma solução, a gente vai aplicar, assim como o Tiago tá aplicando."_

**Mitigação:** Interface muito simples, treinamento hands-on

---

### Risco #2: Cultura do Produtor (Geral)
**Citação (Claudio sobre outros produtores):**  
> _"O agricultor ele é muito bom em plantar e colher. Ele é muito fraco na gestão. [...] Porque realmente ele se dedicou de plantar e colher, cuidar da terra."_

**Case Negativo - Seu Henrique:**
- Melhor plantador de abóbora do Brasil
- Não confiava em ninguém, fazia tudo sozinho
- **Resultado:** Faliu (filhos também)

**Case Positivo - Bernardo (Isabela Lucera):**
- Usa AgriWin
- **Problema:** Tem dados de apenas 2 anos, antes "ia pagando sem saber exato quanto devia"

**Oport unidade:** Deepwork resolve isso com dados consolidados + histórico ilimitado

---

### Risco #3: Resistência a Compartilhar Dados
**Rodrigo:** _"Grande maioria fecha as portas: 'esse dado é segredo, é meu'"_  
**Claudio:** _"Dá pra fazer contratos de confidencialidade (NDA)"_

**Mitigação:** NDA + Governança de acesso clara

---

## 14. PRÓXIMOS PASSOS - VALIDADOS

### Imediato (Próximas 2 Semanas)
1. ✅ **Reunião com Tiago** - Entender dados John Deere, estrutura de máquinas
2. ✅ **Mapear APIs:**
   - Castrolanda (via AgriWin) - já existe
   - SharePoint - conectar Excel diretamente
   - AgriWin - validar se tem API própria
3. ✅ **Protótipo Dashboard Custo** - Mockup visual para validar com Claudio

### Curto Prazo (1 Mês)
4. ✅ **MVP Dashboard:**
   - Custo/ha soja, milho, feijão (dados Castrolanda + SharePoint)
   - Comparativo com preço mercado
   - Margem projetada
5. ✅ **Demonstração na Fazenda** - Validar usabilidade

### Médio Prazo (2-3 Meses)
6. ✅ **Histórico 1996-2024** - Migrar dados salvos para Data Warehouse
7. ✅ **Módulo Máquinas** - Integração John Deere (com Tiago)
8. ✅ **TV Dashboard** - Implementar tela na fazenda

---

## 15. CONCLUSÕES E INSIGHTS FINAIS

### ✅ Projeto SOAL é 100% VIÁVEL

**Evidências:**
1. **Dor Real e Urgente:** Claudio quer custo em tempo real (repetiu 4x)
2. **Dados Existem:** 28 anos de histórico + 3 fontes estruturadas
3. **Cliente Ideal:** Aberto a tecnologia, já investe em inovação (Tiago/John Deere)
4. **Quick Win Claro:** Dashboard de custo resolve problema imediato
5. **Potencial ML:** Dados históricos permitem previsões avançadas

---

### 🎯 Foco Inicial Confirmado

**Começar por:** Dashboard de Cost Accounting (Custo/ha por cultura)  
**Segundo módulo:** Máquinas (Tiago + John Deere)  
**Evitar:** Substituir AgriWin completamente (complementar, não substituir)

---

### 💡 Diferenciais Deepwork vs. AgriWin

| Critério | AgriWin | Deepwork AI |
|----------|---------|-------------|
| **Gestão Estratégica** | ❌ Consulta apenas | ✅ Decisões + Projeções |
| **Custo Consolidado** | ❌ Não calcula | ✅ Tempo real |
| **Histórico** | ❌ 2 anos | ✅ Ilimitado (desde 1996) |
| **Excel Integration** | ❌ Zero | ✅ Automático (SharePoint) |
| **Machine Learning** | ❌ Não tem | ✅ Previsões de safra |
| **Customização** | ❌ Padrão fixo | ✅ Personalizado por fazenda |
| **Preço** | R$ 400/mês | `[A DEFINIR: modelo SaaS]` |

---

### 🚀 Proposta de Valor (Pitch)

**NÃO vender:**  
"Sistema melhor que AgriWin"

**VENDER:**  
_"Claudio, você mesmo falou: hoje você gasta meio dia pra saber o custo da soja. E se toda segunda-feira, quando você se programa com a Valentina, você abrisse uma tela e já visse: 'Soja tá em R$ X/ha, preciso de Y sacas pra cobrir, tenho Z de margem'? A gente pega seus dados da Castrolanda, do Excel e transforma isso numa visão que você quer ter, mas que hoje não existe."_

---

**FIM DO RELATÓRIO DE DISCOVERY**  
*Próximo Documento Sugerido: `09_PROTOTIPO_DASHBOARD_CUSTO.md` ou `10_REUNIAO_TIAGO_MAQUINAS.md`*
