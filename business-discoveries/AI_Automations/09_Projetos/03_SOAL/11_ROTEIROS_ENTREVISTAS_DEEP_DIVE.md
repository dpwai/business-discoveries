# Roteiros de Entrevistas - Deep Dive Operacional SOAL

**Objetivo Geral:** Mapear processos operacionais, uso do AgriWin, identificar gargalos e oportunidades de automação em cada área da fazenda.

**Contexto do Projeto:** Desenvolvimento de solução de Data Warehousing + BI + Automação para unificar dados fragmentados (AgriWin, Excel SharePoint, Castrolanda) e entregar visão consolidada de custo por cultura em tempo real.

**Metodologia de Entrevista:**
- Duração: 45-60 minutos por entrevista
- Formato: Presencial (quando possível) ou remoto
- Gravar áudio (pedir permissão) ou documentar imediatamente após
- Pedir para **mostrar na tela** os sistemas durante a entrevista (não só falar)
- Focar em **processo real**, não no processo "ideal"

---

## 📋 ROTEIRO #1: ADMINISTRATIVO (Valentina)

**Data Prevista:** A definir  
**Duração:** 60 minutos  
**Objetivos Específicos:**
1. Mapear processo completo de notas fiscais (compra e venda)
2. Entender gestão de contas a pagar/receber
3. Identificar todos os processos manuais
4. Mapear integrações (ou falta delas) entre sistemas

---

### PARTE 1: CONTEXTO E DIA A DIA (10 min)

**1.1 Rotina Geral**
- Descreva um dia típico seu no trabalho. Quais são suas principais atividades?
- Quais sistemas/ferramentas você usa diariamente? (AgriWin, Excel, outro?)
- Quanto tempo (%) você gasta em cada atividade principal?

**1.2 Time e Colaboração**
- Você trabalha sozinha ou tem ajuda? (Claudio mencionou que às vezes tem a Luane)
- Com quem você mais troca informações? (Claudio, Tiago, agrônomo?)
- Quais informações você passa para eles? Com que frequência?

---

### PARTE 2: NOTAS FISCAIS - PROCESSO COMPLETO (20 min) 🔥 **CRÍTICO**

#### 2.1 Notas Fiscais de COMPRA (Insumos, Peças, Serviços)

**Processo Atual (validar passo a passo):**
- **Passo 1:** Como a nota fiscal chega até você? (E-mail, física, WhatsApp, portal fornecedor?)
- **Passo 2:** Você imprime TODAS as notas ou só algumas? Por quê?
- **Passo 3:** Descreva o processo de scanner do código de barras:
  - Qual scanner vocês usam? (modelo, marca)
  - Onde você escaneia? (escritório, outro local?)
  - O que acontece após escanear? (AgriWin abre automaticamente?)
  
- **Passo 4:** Após o AgriWin puxar os dados:
  - Você precisa conferir/editar alguma informação?
  - Quais campos você preenche manualmente?
  - Já aconteceu do código de barras não funcionar? O que você faz?

- **Passo 5:** Onde a nota física vai depois? (arquivo, gaveta, contabilidade?)

**Volumetria:**
- Quantas notas de compra você processa por semana/mês? (média)
- Qual o tempo médio para processar uma nota do início ao fim?
- Em qual dia da semana/mês isso é mais intenso?

**Dores/Problemas:**
- Qual a parte mais chata/demorada desse processo?
- Já perdeu alguma nota? Como resolve?
- O scanner já deu problema? Com que frequência?
- Tem nota que você precisa digitar manualmente (sem código de barras)? Quais?

---

#### 2.2 Notas Fiscais de VENDA (Produção)

- Vocês emitem nota fiscal pela SOAL ou pela Castrolanda?
- Se emite pela SOAL, qual sistema usa? (AgriWin emite?)
- Processo é manual ou automático?
- Quantas notas de venda por mês?

---

### PARTE 3: AGRIWIN - USO E LIMITAÇÕES (15 min)

#### 3.1 Módulos que Você Usa

**Pergunte e PEÇA PARA MOSTRAR NA TELA:**
- Quais partes do AgriWin você usa no dia a dia?
  - [ ] Compras
  - [ ] Vendas
  - [ ] Estoque
  - [ ] Financeiro (contas a pagar/receber)
  - [ ] Relatórios
  - [ ] Outro: ___________

- Para cada módulo usado:
  - **Pergunta:** "Me mostra como você faz [tarefa X] no AgriWin"
  - Observar: Quantos cliques? Quanto tempo? Ele trava/demora?

#### 3.2 Integração AgriWin ↔ Castrolanda

- Você já viu os dados da Castrolanda aparecerem automaticamente no AgriWin?
- Com que frequência isso atualiza? (tempo real, diário, semanal?)
- Você confia nos dados que vêm da Castrolanda ou confere manualmente?
- Já teve divergência entre AgriWin e relatório da Castrolanda? Como resolve?

#### 3.3 O Que o AgriWin NÃO Faz (mas você precisa)

- Tem alguma informação que você gostaria que o AgriWin mostrasse mas não mostra?
- Tem algum relatório que você precisa fazer "na mão" porque o sistema não gera?
- Se você pudesse mudar UMA coisa no AgriWin, o que seria?

---

### PARTE 4: EXCEL/SHAREPOINT - PLANILHAS PARALELAS (10 min) 🔥 **CRÍTICO**

#### 4.1 Planilhas que Você Mantém

**Já sabemos que existem (validar detalhes):**
1. **Contas a Pagar**
2. **Contas a Receber**
3. **Orçamento**
4. **Mão-de-Obra (Folha)**

**Para CADA planilha, perguntar:**

- **Frequência de Atualização:** Você atualiza diariamente? Semanalmente? Mensal?
- **Fonte dos Dados:** De onde vêm os dados que você coloca? (AgriWin, nota fiscal, banco?)
- **Processo de Preenchimento:** É copy/paste? Digitação manual? Fórmulas automáticas?
- **Tempo Gasto:** Quanto tempo você leva para atualizar essa planilha?
- **Compartilhamento:** Quem mais acessa/edita essa planilha? (Claudio, contador?)

#### 4.2 Programação Semanal de Pagamentos (Rotina com Claudio)

**Claudio mencionou que toda segunda-feira vocês se programam. Detalhe esse processo:**

- **Segunda-feira de manhã:**
  - Você prepara o quê antes da reunião com Claudio?
  - Quais planilhas você abre?
  - Você consulta saldo bancário? Onde? (internet banking, AgriWin?)

- **Durante a conversa:**
  - Vocês decidem o quê exatamente? (prioridade de pagamentos?)
  - Como vocês veem o "fluxo de caixa" da semana? (planilha, relatório?)
  - Já aconteceu de descobrir uma conta surpresa? Como?

- **Após a reunião:**
  - O que você faz com as decisões? (anota onde? agenda pagamentos?)
  - Usa alguma ferramenta de lembrete/alarme?

---

### PARTE 5: OUTROS PROCESSOS (5 min)

#### 5.1 Integrações com Terceiros

- **Contabilidade (Escritório Externo):**
  - O que você envia para eles? (notas em PDF, planilhas, extrato AgriWin?)
  - Com que frequência? (mensal, trimestral?)
  - Qual o processo? (e-mail, pasta compartilhada, físico?)

- **Banco:**
  - Você faz pagamentos/transferências manualmente ou tem integração?
  - Usa boleto? PIX? Transferência?
  - Depois do pagamento, você registra onde? (AgriWin, Excel, ambos?)

#### 5.2 Recuperação de ICMS

- Claudio mencionou "recuperação de ICMS". Você cuida disso?
- O que precisa fazer? (separar notas específicas?)
- É processo manual ou AgriWin ajuda?

---

### PARTE 6: VISUALIZAÇÃO DE DADOS E DASHBOARDS (5 min)

#### 6.1 Relatórios que Você Gera

- Quais relatórios você tira do AgriWin regularmente?
- Para quem você manda esses relatórios? (Claudio, contador?)
- Formato: PDF, Excel, impresso?

#### 6.2 Informações que Você Gostaria de Ver (Desejos)

**Pergunta aberta:**  
_"Se você pudesse ter uma tela aqui no seu computador que mostrasse QUALQUER informação em tempo real, o que você gostaria de ver?"_

Exemplos para estimular se ela não souber responder:
- Saldo bancário atualizado?
- Contas a pagar dos próximos 7 dias?
- Resumo de notas fiscais do mês?
- Comparativo: previsto vs. realizado?

---

### PARTE 7: DORES E OPORTUNIDADES (5 min) 🎯

**Perguntas de Pain Point (A Pergunta de 1 Milhão):**

1. **Tempo Perdido:**  
   _"Qual atividade você faz que consome mais tempo e você acha que poderia ser mais rápida/automática?"_

2. **Retrabalho:**  
   _"Tem alguma informação que você precisa digitar/copiar mais de uma vez em lugares diferentes?"_

3. **Erro/Esquecimento:**  
   _"Já aconteceu de esquecer de pagar uma conta ou de lançar uma nota? Como evita isso hoje?"_

4. **Estresse/Frustração:**  
   _"Qual parte do seu trabalho te deixa mais frustrada ou estressada?"_

5. **Sonho:**  
   _"Se você tivesse uma varinha mágica e pudesse automatizar UM processo do seu dia a dia, qual seria?"_

---

### CHECKLIST DE OBSERVAÇÕES (anotar durante a entrevista)

Durante a entrevista, **observar e anotar:**

- [ ] Quantas abas/janelas ela mantém abertas simultaneamente?
- [ ] Ela alterna muito entre sistemas? (AgriWin → Excel → Banco?)
- [ ] Tem post-its ou anotações coladas no monitor?
- [ ] Tem alguma "cola" (papel com senha, processo escrito à mão)?
- [ ] Ela parece confortável com tecnologia ou tem dificuldade?
- [ ] Qual sistema ela reclama mais? (AgriWin, Excel, Banco?)

---

### ENCERRAMENTO E PRÓXIMOS PASSOS

**Agradecer:**  
_"Muito obrigado pelo seu tempo, Valentina. Essas informações são muito valiosas."_

**Validar:**  
_"Posso voltar a te procurar se tiver alguma dúvida ou quiser te mostrar algo que estamos desenvolvendo?"_

**Deixar Abertura:**  
_"Se você lembrar de mais alguma coisa ou tiver alguma ideia, pode me mandar mensagem."_

---
---

## 🌾 ROTEIRO #2: AGRONOMIA (Alessandro ou Agrônomo Responsável)

**Data Prevista:** A definir  
**Duração:** 45-60 minutos  
**Objetivos Específicos:**
1. Mapear uso de agroquímicos e sementes (compra, aplicação, controle)
2. Entender processo de receituário agronômico
3. Identificar dados coletados no campo e como chegam ao sistema
4. Mapear análises de solo e recomendações

---

### PARTE 1: CONTEXTO E RESPONSABILIDADES (10 min)

**1.1 Papel na Fazenda**
- Qual sua função principal aqui na SOAL?
- Há quanto tempo trabalha aqui?
- Você trabalha exclusivamente para SOAL ou atende outras fazendas também?

**1.2 Safra Atual**
- Estamos em qual fase da safra agora? (plantio, desenvolvimento, colheita?)
- Quais culturas você está acompanhando neste momento?
- Quantas glebas você monitora regularmente?

---

### PARTE 2: RECEITUÁRIO E PLANEJAMENTO (15 min)

#### 2.1 Processo de Receituário Agronômico

**Início da Safra:**
- Como você decide qual defensivo/fertilizante vai usar em cada gleba?
- Você usa dados históricos? De onde vêm esses dados? (AgriWin, caderno, planilha?)
- Análise de solo influencia? (Rafael/Camila fornecem esses dados?)

**Durante a Safra:**
- Como você monitora a saúde das plantas? (visita campo, relatórios, drones?)
- Com que frequência você visita cada gleba?
- Quando percebe um problema (praga, doença), qual o processo?
  1. Identifica no campo
  2. Faz receita (onde? papel, sistema?)
  3. Passa para quem? (Valentina comprar? Operador aplicar?)

#### 2.2 Compra de Insumos (Defensivos, Fertilizantes, Sementes)

- Quem faz a compra efetiva? (você faz a lista e Valentina compra?)
- Você participa da negociação com fornecedores?
- Como você sabe o que tem em estoque antes de pedir mais?
- Já aconteceu de faltar insumo crítico na hora H? Como evita?

---

### PARTE 3: APLICAÇÃO E CONTROLE DE CAMPO (15 min)

#### 3.1 Aplicação de Defensivos/Fertilizantes

- Quem aplica os produtos? (operador de pulverizador?)
- Como você passa a informação do que aplicar?
  - Verbal? WhatsApp? Papel? Sistema?
- Você acompanha a aplicação (vai junto) ou confia no operador?

**Registro da Aplicação:**
- Depois que foi aplicado, como você registra?
- Você anota: Data, produto, dose, gleba, operador?
- Onde registra? (caderno, planilha, AgriWin?)

#### 3.2 Rastreabilidade

- Se o Claudio perguntar: _"Quanto de defensivo X foi aplicado na gleba Y?"_, você consegue responder rápido?
- De onde você tira essa informação?
- E se a pergunta for: _"Qual foi o custo total de defensivos da soja até agora?"_

---

### PARTE 4: AGRIWIN - USO ESPECÍFICO AGRONOMIA (10 min)

#### 4.1 Módulos que Você Usa

**PEDIR PARA MOSTRAR NA TELA:**
- Você usa o AgriWin? Quais partes?
  - [ ] Cadastro de produtos (defensivos, sementes)
  - [ ] Recomendação/Receituário
  - [ ] Estoque de insumos
  - [ ] Histórico de aplicação
  - [ ] Relatórios de produtividade por gleba
  - [ ] Outro: ___________

- Para cada módulo:
  - É fácil de usar?
  - Você confia nos dados que aparecem lá?
  - Tem algo que deveria ter mas não tem?

#### 4.2 Dados Históricos

- Claudio mencionou que tem dados desde 1996. Você usa esses dados históricos?
- Consegue ver facilmente: _"O que foi plantado na gleba X nos últimos 5 anos?"_
- E: _"Qual foi a produtividade da gleba Y na última safra?"_
- Se não consegue ver fácil, como você faz para ter essas informações?

---

### PARTE 5: ANÁLISES E DECISÕES (10 min)

#### 5.1 Análise de Solo (Rafael/Fundação ABC)

- Rafael coleta as amostras. Você recebe os laudos?
- Em que formato? (PDF, papel, sistema?)
- Você guarda esses laudos em algum lugar organizado? (pasta, planilha, AgriWin?)
- Como você usa esses dados para decidir fertilização?

#### 5.2 Biológicos (Case Alessandro)

**Claudio mencionou que você identificou que a fábrica de biológicos estava 2x mais cara. Como você descobriu isso?**
- Foi comparação manual de preços?
- Você tem planilha de custos?
- Essa análise foi pontual ou você faz regularmente?

#### 5.3 Tomada de Decisão Baseada em Dados

**Perguntas estratégicas:**
- Você sente que tem todos os dados que precisa para tomar boas decisões?
- Tem alguma informação que você gostaria de ter mas não tem hoje?
- Exemplo: _"Gostaria de saber o custo de defensivos por hectare em tempo real?"_

---

### PARTE 6: PROCESSOS MANUAIS E PLANILHAS (5 min)

**6.1 Controles Paralelos**
- Você mantém alguma planilha própria? (fora do AgriWin)
- Caderno de campo? Anotações no celular?
- Se sim, por que usa isso ao invés do sistema?

**6.2 Comunicação com Time**
- Como você passa informações para:
  - Valentina (compras)?
  - Tiago (máquinas - quando precisa de pulverizador)?
  - Claudio (decisões estratégicas)?
- WhatsApp? E-mail? Reunião presencial? Sistema?

---

### PARTE 7: DORES E OPORTUNIDADES (5 min) 🎯

**Perguntas de Pain Point:**

1. **Tempo Perdido:**  
   _"Qual atividade consome mais tempo e poderia ser mais rápida?"_

2. **Informação Difícil de Achar:**  
   _"Tem alguma informação que você precisa mas é difícil/demorado de conseguir?"_

3. **Decisão no Escuro:**  
   _"Já teve que tomar alguma decisão técnica sem ter um dado importante na mão? Qual?"_

4. **Tecnologia:**  
   _"Se você pudesse ter um aplicativo no celular que fizesse UMA coisa para te ajudar no dia a dia, o que seria?"_  
   (Exemplos: consultar estoque de defensivo, ver histórico de gleba, registrar aplicação no campo)

---

### ENCERRAMENTO

**Agradecer e validar:**  
_"Suas informações foram muito importantes para entendermos a parte agronômica. Podemos voltar a conversar se precisarmos de mais detalhes?"_

---
---

## 🚜 ROTEIRO #3: MAQUINÁRIO (Tiago)

**Data Prevista:** A definir  
**Duração:** 60 minutos  
**Objetivos Específicos:**
1. Mapear integração John Deere Operations Center
2. Entender sistema de TAG de abastecimento
3. Identificar dados de manutenção e como são registrados
4. Mapear análise de desempenho de máquinas (case trator 170cv)

---

### PARTE 1: CONTEXTO E RESPONSABILIDADES (10 min)

**1.1 Papel e Estrutura**
- Qual sua função aqui na SOAL?
- Há quanto tempo você está nessa posição?
- Quantas máquinas/equipamentos você gerencia? (total)
  - Tratores: ___
  - Colheitadeiras: ___
  - Plantadeiras: ___
  - Pulverizadores: ___
  - Outros: ___

**1.2 Time**
- Você tem uma equipe? (mecânicos, operadores?)
- Quem reporta para você?
- Com quem você mais interage? (Claudio, fornecedores John Deere?)

---

### PARTE 2: JOHN DEERE OPERATIONS CENTER (20 min) 🔥 **CRÍTICO**

#### 2.1 Uso Atual do Sistema

**Claudio mencionou que a SOAL é "modelo de atuação" da John Deere. Conte-me sobre isso:**
- Como começou essa parceria com a John Deere?
- Você fez algum treinamento específico?
- Eles vêm aqui regularmente? Para quê?

**PEDIR PARA MOSTRAR O SISTEMA NA TELA:**
- Você acessa o John Deere Operations Center diariamente?
- Me mostra o que você mais usa lá.

**Observar e perguntar:**
- [ ] Mapas de colheita (produtividade por área)
- [ ] Mapas de plantio (densidade de sementes)
- [ ] Mapas de pulverização (cobertura)
- [ ] Consumo de combustível por máquina
- [ ] Horas trabalhadas
- [ ] Manutenções programadas
- [ ] Telemetria em tempo real
- [ ] Outro: ___________

#### 2.2 Dados que o Sistema Fornece

**Para cada tipo de dado acima, perguntar:**
- Com que frequência atualiza? (tempo real, diário?)
- Você confia nesses dados ou confere manualmente?
- Você **exporta** esses dados para algum lugar? (Excel, relatório?)
- Você **compartilha** com alguém? (Claudio, agrônomo?)

#### 2.3 API e Acesso Técnico

**Perguntas técnicas (importantes para integração):**
- Você sabe se a John Deere tem uma API para acessar esses dados programaticamente?
- Quem é seu contato técnico na John Deere? (nome, e-mail - se possível)
- Eles já mencionaram possibilidade de integração com outros sistemas?
- Você teria como conseguir documentação técnica da plataforma? (para desenvolvedores)

---

### PARTE 3: SISTEMA DE TAG DE ABASTECIMENTO (15 min) 🔥 **CRÍTICO**

#### 3.1 Processo Antes e Depois

**Claudio mencionou que antes era manual (papel) e agora é TAG automática.**

**ANTES (processo antigo):**
- Como funcionava?
  1. Operador abastecia
  2. Anotava em papel
  3. Fim de semana ia para Vanessa (quem é Vanessa?)
  4. Vanessa digitava no AgriWin na semana seguinte

**AGORA (processo novo com TAG):**
- Como funciona hoje?
- Que tipo de TAG vocês usam? (RFID, código de barras, outro?)
- Onde está a TAG? (na máquina? no cartão do operador?)
- Como é o processo físico de abastecimento agora?

**PEDIR PARA MOSTRAR (se possível):**
- A TAG física
- O sistema que registra o abastecimento
- Como os dados aparecem no AgriWin

#### 3.2 Dados Capturados

**O que o sistema de TAG registra automaticamente?**
- [ ] Máquina que abasteceu
- [ ] Operador que abasteceu
- [ ] Quantidade de litros
- [ ] Data/hora
- [ ] Local? (GPS?)
- [ ] Km/horas da máquina?
- [ ] Outro: ___________

#### 3.3 Integração

- Os dados da TAG vão direto pro AgriWin ou tem algum sistema intermediário?
- Você consegue ver em tempo real ou tem delay?
- Já teve erro/falha no sistema de TAG? Como resolve?

---

### PARTE 4: MANUTENÇÃO E ALMOXARIFADO (10 min)

#### 4.1 Manutenção Preventiva vs. Corretiva

- Como você sabe quando uma máquina precisa de manutenção?
  - Horas trabalhadas? (John Deere avisa?)
  - Calendário fixo?
  - Quando quebra? (reativa)

- AgriWin ajuda nisso? (Claudio mostrou que tem alertas de revisão)

**PEDIR PARA MOSTRAR:**
- Onde você vê as manutenções programadas
- Histórico de manutenção de uma máquina específica

#### 4.2 Controle de Peças (Almoxarifado)

**Claudio mencionou que almoxarifado ainda não está automatizado.**

- Como você controla estoque de peças hoje?
- Planilha? Caderno? AgriWin? Outro sistema?
- Como você sabe quando uma peça crítica está acabando?

**Machine Learning - Peças Recorrentes:**
- Tem peças que quebram com frequência previsível? (ex: correia todo ano)
- Como você sabe disso? (experiência, anotação?)
- Você mantém registro histórico de quebras? Onde?

---

### PARTE 5: ANÁLISE DE DESEMPENHO E DECISÕES (10 min)

#### 5.1 Case do Trator 170cv (Claudio mencionou)

**Claudio disse que você descobriu que trator 170cv é mais eficiente que 210cv para certas atividades.**

- Como você chegou nessa conclusão?
- Que dados você usou? (consumo, custo, produtividade?)
- Foi análise manual (planilha) ou sistema ajudou?
- Quantos tratores você analisou para chegar nessa conclusão?

**PEDIR PARA MOSTRAR (se tiver):**
- Planilha ou relatório que você usou para essa análise
- Onde estão esses dados hoje? (AgriWin, John Deere, Excel?)

#### 5.2 Decisões de Compra/Venda

- Quando precisa recomendar compra de máquina, que critérios você usa?
  - Horas trabalhadas da máquina atual?
  - Custo de manutenção?
  - Idade?
  - Tecnologia disponível na nova?

- Você tem um "dashboard" mental ou tem dados concretos?

---

### PARTE 6: INTEGRAÇÃO MÁQUINAS ↔ OPERAÇÃO (5 min)

#### 6.1 Pulverizadores Inteligentes (Starlink)

**Claudio mencionou que 2 pulverizadores se comunicam via Starlink.**

- Como isso funciona na prática?
- Você configura isso ou é automático?
- Já teve falha? Starlink é confiável?
- Isso reduziu desperdício? Tem dados?

#### 6.2 Plantadeiras (Desligamento Automático de Sementes)

**Claudio disse que tiveram 8% de economia em semente de milho.**

- Essa economia foi medida como? (comparação safra anterior?)
- Os dados dessa economia estão onde? (John Deere, AgriWin, cálculo manual?)
- Todas as plantadeiras têm essa tecnologia agora?

---

### PARTE 7: AGRIWIN - USO ESPECÍFICO MAQUINÁRIO (5 min)

**PEDIR PARA MOSTRAR:**
- Onde você vê:
  - Consumo de combustível por máquina
  - Custo de manutenção por máquina
  - Horas trabalhadas
  - Histórico de abastecimento

- O AgriWin te dá todas as informações que você precisa?
- Tem algo que você gostaria de ver mas não tem?

---

### PARTE 8: DORES E OPORTUNIDADES (5 min) 🎯

**Perguntas de Pain Point:**

1. **Tempo Perdido:**  
   _"Qual atividade administrativa (não mecânica) consome mais tempo e poderia ser automatizada?"_

2. **Informação Difícil:**  
   _"Tem alguma informação sobre as máquinas que é difícil de conseguir mas você precisa regularmente?"_

3. **Decisão Baseada em Dados:**  
   _"Quando você recomenda compra de máquina pro Claudio, você sente que tem todos os dados necessários ou vai muito no 'feeling'?"_

4. **Integração:**  
   _"Se você pudesse conectar o John Deere Operations Center com outro sistema (AgriWin, Excel, outro), o que facilitaria no seu dia a dia?"_

5. **Sonho:**  
   _"Se você tivesse um painel/tela que mostrasse em tempo real QUALQUER informação das máquinas, o que você gostaria de ver?"_

---

### ENCERRAMENTO

**Agradecer:**  
_"Muito obrigado, Tiago. Essas informações técnicas são essenciais para o que estamos desenvolvendo."_

**Solicitar Contato John Deere (se possível):**  
_"Você teria como me passar o contato do técnico da John Deere que trabalha com vocês? Seria importante conversarmos sobre integração de dados."_

---
---

## 📊 ANÁLISE PÓS-ENTREVISTAS

### Checklist Geral (Após as 3 Entrevistas)

**Antes de partir para desenvolvimento, validar se você tem:**

#### Dados Mapeados
- [ ] **Fontes identificadas:** AgriWin, Excel, Castrolanda, John Deere, TAG, Fundação ABC, outras?
- [ ] **Formato dos dados:** Onde estão (banco, arquivo, API)? Em que formato (CSV, PDF, SQL)?
- [ ] **Frequência de atualização:** Tempo real, diário, semanal, mensal?
- [ ] **Volumetria:** Quantas notas/mês, transações/dia, máquinas ativas, glebas monitoradas?

#### Processos Manuais Identificados
- [ ] **Nota fiscal:** Impressão + scanner → Oportunidade automação P0
- [ ] **Planilhas Excel:** Quais são atualizadas manualmente? Com que esforço?
- [ ] **Relatórios:** Quais são gerados manualmente cruzando sistemas?
- [ ] **Almoxarifado:** Controle de peças é manual?

#### Pain Points Priorizados
- [ ] **P0 (Crítico):** Processos que consomem mais tempo ou geram mais frustração
- [ ] **P1 (Alto):** Informações difíceis de conseguir mas importantes
- [ ] **P2 (Médio):** "Nice to have" mas não bloqueantes

#### Integrações Possíveis
- [ ] **API Castrolanda:** Contato técnico obtido? Documentação disponível?
- [ ] **API John Deere:** Contato obtido? Chaves de desenvolvedor solicitadas?
- [ ] **SharePoint:** Acesso concedido para integração?
- [ ] **AgriWin:** Tem API? Ou só import/export manual?

#### Dashboards Desejados (Validado com Usuários)
- [ ] **Valentina quer ver:** ___________
- [ ] **Alessandro quer ver:** ___________
- [ ] **Tiago quer ver:** ___________
- [ ] **Claudio quer ver:** Custo/ha por cultura (já sabemos)

---

## 🎯 PRÓXIMOS PASSOS APÓS ENTREVISTAS

### 1. Consolidar Descobertas
- Criar documento: `12_MAPEAMENTO_COMPLETO_PROCESSOS.md`
- Incluir fluxogramas de processos atuais
- Listar TODAS as fontes de dados identificadas

### 2. Priorizar Quick Wins
- Qual automação entrega valor mais rápido? (provavelmente notas fiscais)
- Qual dashboard é mais crítico? (provavelmente custo/ha)

### 3. Definir Arquitetura Técnica
- Desenhar diagrama de integração
- Definir stack completo (N8N, PostgreSQL, Power BI, etc.)
- Estimar esforço de cada módulo

### 4. Prototipar MVP
- Automação de notas (N8N + OCR)
- CSV consolidado de custos
- Dashboard básico (Power BI)

### 5. Documentar Metodologia
- Processos do Claudio que funcionam bem
- Template de planilhas
- Guia para outros produtores

---

**BOA SORTE NAS ENTREVISTAS! 🚀**

*Lembre-se: Escute mais do que fala. Peça para MOSTRAR, não só CONTAR. Observe o que não é dito (frustrações, workarounds, gambiarras).*
