# BRIEFING - Reunião de Discovery com Tiago e Claudio
**Data:** 16 de janeiro de 2026  
**Hora:** 10:30 (horário atual)  
**Participantes:** Rodrigo Kugler, Tiago (Maquinário), Claudio Kugler (Diretor)  
**Duração Prevista:** 60-90 minutos  
**Tipo:** Discovery presencial - Deep dive maquinário + validação com Claudio

---

## 🎯 OBJETIVOS DA REUNIÃO

### Objetivo Primário (Tiago):
Mapear **integração John Deere Operations Center** e entender **sistema de TAG de abastecimento** para identificar oportunidades de automação e integração de dados.

### Objetivo Secundário (Claudio):
Validar descobertas anteriores e obter **buy-in** para próximos passos do projeto.

---

## 📊 CONTEXTO COMPLETO DO PROJETO (Recap Rápido)

### O Que Já Foi Mapeado (Reuniões Anteriores):

**15/12/2025 - Estratégia e Modelo de Negócio:**
- ✅ SaaS B2B: R$ 10k setup + R$ 1,5k-2,5k/mês
- ✅ Foco: Data Intelligence (ETL + Dashboards + IA)
- ✅ **EVITAR:** Hardware/IoT
- ✅ Escala: SOAL → 100+ cooperados Castrolanda

**22/12/2025 - Planejamento Técnico (com João):**
- ✅ **Field-to-ERP** = foco principal
- ✅ Metodologia: Kimball Data Warehousing
- ✅ Ferramenta: N8N para discovery
- ✅ **EVITAR:** Área financeira sensível

**Dezembro (data exata desconhecida) - Discovery com Claudio:**
- ✅ **Pain Point P0:** Dashboard de custo/ha em tempo real
- ✅ 3 fontes de dados: AgriWin, Excel SharePoint, Castrolanda
- ✅ 28 anos de dados históricos (desde 1996)
- ✅ 5 setores: Administrativo, Maquinário, Agrícola, Agronomia, Financeiro
- ✅ Claudio quer: _"Ver custo de soja/milho/feijão até agora, quanto gastei por hectare"_

**29/12/2025 - Decisões Estratégicas (com João):**
- ✅ **Pain Point Validado:** Processo manual de notas fiscais (Valentina)
- ✅ Stack: N8N + Power BI + ChatGPT MCP + PostgreSQL
- ✅ Entrega inicial: **CSV + Dashboard simples**
- ✅ Modelo: **SaaS + Consultoria + Metodologia**
- ✅ Reuniões marcadas: Valentina, Alessandro, **Tiago**

---

## 🔥 O QUE VOCÊ JÁ SABE SOBRE TIAGO E MAQUINÁRIO

### Papel de Tiago na SOAL:
- **Função:** Gerente de Máquinas (genro do Claudio)
- **Responsabilidades:** Tecnologia, manutenção, almoxarifado, otimização de frota
- **Contexto John Deere:** SOAL é **"modelo de atuação"** da John Deere na região
- **Relação com JD:** John Deere "abraçou" Tiago, vem regularmente, fornece treinamento

### Cases de Sucesso de Tiago (Mencionados por Claudio):

**1. Trator 170cv vs. 210cv:**
- Descobriu via **dados** que trator 170cv é mais eficiente para certas atividades
- Economia: Custos operacionais + pneus + compra
- **Decisão baseada em dados, não achismo**

**2. Pulverizadores Inteligentes (Starlink):**
- 2 pulverizadores se comunicam
- Um desliga automaticamente onde outro já passou
- **Zero desperdício**
- Investimento: R$ 1,8M

**3. Plantadeiras (Desligamento Automático):**
- Economia de **8% em sementes de milho**
- Tecnologia: Plantadeira detecta área já plantada e desliga

**4. Sistema de TAG de Abastecimento:**
- **ANTES:** Operador anotava em papel → Fim de semana ia para Vanessa → Digitava no AgriWin
- **AGORA:** TAG automática → Dados instantâneos no AgriWin
- **Impacto:** Eliminou trabalho manual, dados em tempo real

---

## 📋 ROTEIRO DETALHADO - PARTE 1: TIAGO (60 min)

### PARTE 1: CONTEXTO E ESTRUTURA (10 min)

**Perguntas-Chave:**
1. _"Quantas máquinas você gerencia no total?"_ (Tratores, colheitadeiras, plantadeiras, pulverizadores)
2. _"Você tem uma equipe? Quantos mecânicos/operadores?"_
3. _"Como é sua rotina típica? Quanto tempo passa no campo vs. escritório vs. sistemas?"_

**Observar:**
- Nível de conforto com tecnologia
- Como ele se comunica (técnico, prático, visual)

---

### PARTE 2: JOHN DEERE OPERATIONS CENTER (20 min) 🔥 **CRÍTICO**

**🎯 OBJETIVO:** Entender EXATAMENTE quais dados existem, como ele usa, e possibilidade de API.

#### 2.1 Parceria John Deere
- _"Claudio disse que vocês são modelo da John Deere. Como isso começou?"_
- _"Eles vêm aqui regularmente? Para quê?"_
- _"Você fez treinamento? Foi bom?"_

#### 2.2 **PEDIR PARA MOSTRAR NA TELA (Essencial!):**
_"Me mostra como você usa o Operations Center no dia a dia."_

**Enquanto ele mostra, perguntar sobre cada tipo de dado:**

- **Mapas de Colheita:**
  - Frequência: Atualiza em tempo real ou depois?
  - Uso: Você usa esses mapas para decisões? Compartilha com agrônomo?

- **Consumo de Combustível:**
  - Consegue ver por máquina? Por período?
  - Exporta esses dados para Excel ou fica só no sistema?

- **Horas Trabalhadas:**
  - Usa para planejar manutenção?
  - AgriWin também tem? Há divergência?

- **Manutenções Programadas:**
  - Sistema avisa automaticamente?
  - Como você age quando recebe alerta?

#### 2.3 API e Integração (CRÍTICO para o Projeto) 🔥

**Perguntas Essenciais:**
1. _"Você sabe se a John Deere tem uma API para acessar esses dados programaticamente?"_
   - Se não souber: _"Posso falar com seu contato técnico da JD para entender?"_

2. _"Quem é seu contato principal na John Deere? (nome, e-mail, telefone)"_
   - **Anotar:** Nome completo, cargo, contato

3. _"Eles já mencionaram possibilidade de integrar dados do Operations Center com outros sistemas?"_

4. _"Você exporta dados do JD Operations Center? Em que formato?"_
   - CSV? Excel? Relatório PDF?

**Possível Resistência:**
- Se ele disser _"Não sei, nunca pensei nisso"_
- **Responder:** _"Sem problema! A ideia é justamente facilitar sua vida. Se conseguíssemos trazer esses dados do John Deere automaticamente para um dashboard junto com custos, seria útil pra você?"_

---

### PARTE 3: SISTEMA DE TAG DE ABASTECIMENTO (15 min) 🔥

**🎯 OBJETIVO:** Entender tecnologia, dados capturados, e integração com AgriWin.

#### 3.1 Como Funciona Hoje

**Claudio disse que mudou de manual (papel) para TAG. Detalhes:**
1. _"Que tipo de TAG vocês usam? (RFID, código de barras?)"_
2. _"Onde fica a TAG? (na máquina, no cartão do operador?)"_
3. **PEDIR PARA VER:** _"Posso ver uma TAG física? E o sistema?"_
4. _"Como é o processo de abastecimento agora?"_
   - Operador faz o quê?
   - Sistema registra automaticamente?

#### 3.2 Dados Capturados

_"O sistema de TAG registra o quê exatamente?"_
- [ ] Máquina que abasteceu
- [ ] Operador
- [ ] Quantidade de litros
- [ ] Data/hora
- [ ] Local? (GPS?)
- [ ] Odômetro/horímetro?

#### 3.3 Integração

**Perguntas Críticas:**
1. _"Os dados da TAG vão direto pro AgriWin ou tem sistema intermediário?"_
2. _"É em tempo real ou tem delay?"_
3. _"Já teve erro/falha? Como resolve?"_
4. _"Você consegue gerar relatório de consumo por máquina? Me mostra?"_

---

### PARTE 4: MANUTENÇÃO E ALMOXARIFADO (10 min)

#### 4.1 Manutenção Preventiva

_"Como você sabe quando fazer manutenção?"_
- Horas trabalhadas (JD avisa)?
- Calendário fixo?
- Quando quebra? (reativa)

**AgriWin:**
- _"Claudio me mostrou que tem alerta de revisão. Você usa isso?"_
- **PEDIR PARA VER:** Histórico de manutenção de uma máquina

#### 4.2 Almoxarifado (Oportunidade ML)

**Claudio disse que almoxarifado NÃO está automatizado ainda.**

1. _"Como você controla estoque de peças hoje?"_
   - Planilha? Caderno? Sistema?

2. _"Tem peças que quebram com frequência?"_ (ex: correia todo ano)
   - Como você sabe? (experiência ou tem registro?)

3. _"Você mantém histórico de quebras?"_
   - **Se SIM:** Onde? (Excel, papel, AgriWin?)
   - **Se NÃO:** _"Seria útil ter isso para prever e evitar paradas?"_

---

### PARTE 5: ANÁLISE DE DESEMPENHO (10 min) - CASE 170cv

**🎯 OBJETIVO:** Entender COMO ele chegou na decisão do trator 170cv (processo analítico).

_"Claudio me contou que você descobriu que o trator 170cv é mais eficiente que o 210cv. Conta essa história:"_

1. _"Como você chegou nessa conclusão?"_
2. _"Que dados você usou?"_ (consumo, custo, horas, produtividade?)
3. _"Foi análise manual em planilha ou algum sistema ajudou?"_
4. **PEDIR PARA VER:** Planilha/relatório se tiver

**Perguntas de Decisão:**
- _"Quando precisa recomendar compra de máquina pro Claudio, você tem dados concretos ou vai muito no 'feeling'?"_
- _"Que informações te faltam hoje para tomar essas decisões?"_

---

### PARTE 6: PULVERIZADORES E PLANTADEIRAS (5 min)

#### Pulverizadores Starlink
- _"Como funciona isso dos dois pulverizadores se comunicando?"_
- _"Você configura ou é automático?"_
- _"Tem dados de quanto reduziu desperdício?"_

#### Plantadeiras (8% economia sementes)
- _"Como vocês mediram a economia de 8%?"_ (comparação safra anterior?)
- _"Onde estão esses dados?"_ (JD, AgriWin, cálculo manual?)

---

### PARTE 7: AGRIWIN - USO MAQUINÁRIO (5 min)

**PEDIR PARA MOSTRAR:**
- _"Me mostra no AgriWin onde você vê:"_
  - Consumo de combustível por máquina
  - Custo de manutenção
  - Horas trabalhadas
  - Histórico de abastecimento

_"O AgriWin te dá tudo que você precisa ou falta algo?"_

---

### PARTE 8: DORES E SONHOS (5 min) 🎯

**Perguntas de Pain Point:**

1. **Tempo Perdido:**  
   _"Qual atividade administrativa (não mecânica) consome mais tempo e poderia ser automatizada?"_

2. **Informação Difícil:**  
   _"Tem alguma informação sobre as máquinas que é difícil de conseguir mas você precisa regularmente?"_

3. **Decisão no Escuro:**  
   _"Quando recomenda compra de máquina pro Claudio, sente que tem todos os dados ou vai muito no 'feeling'?"_

4. **Integração Sonhada:**  
   _"Se pudesse conectar o John Deere Operations Center com AgriWin ou Excel, o que facilitaria no seu dia a dia?"_

5. **Dashboard dos Sonhos:**  
   _"Se tivesse uma tela/painel que mostrasse QUALQUER informação das máquinas em tempo real, o que você gostaria de ver?"_

---

## 📋 ROTEIRO PARTE 2: CLAUDIO (30 min)

**🎯 OBJETIVO:** Validar descobertas, obter buy-in, definir próximos passos.

### 1. Validação Rápida (10 min)

_"Claudio, conversei com o João e mapeamos algumas coisas. Quero validar com você:"_

**Pain Point Principal:**
- _"Você ainda quer ver custo/ha de soja, milho, feijão em tempo real, certo?"_
- _"Hoje você gasta quanto tempo para montar isso manualmente?"_ (confirmar "meio dia")

**Valentina e Notas Fiscais:**
- _"A Valentina ainda faz aquele processo de imprimir e escanear nota fiscal?"_
- _"Quanto tempo isso toma dela por semana/mês?"_
- _"Seria útil automatizar isso?"_

### 2. Apresentar Proposta Inicial (10 min)

_"Baseado no que conversamos, a ideia é:"_

**Fase 1 - Quick Wins (1-2 meses):**
1. **Automação de Notas Fiscais** (Valentina)
   - Pasta monitorada → Sistema lê PDF → Extrai dados automaticamente
   - **Benefício:** Economia de X horas/semana

2. **Dashboard de Custo** (você)
   - Integra AgriWin + Excel + Castrolanda
   - Mostra custo/ha por cultura **atualizado automaticamente**
   - **Benefício:** Ver em 5 min o que hoje leva meio dia

**Fase 2 - Integração John Deere (2-3 meses):**
3. **Dados de Maquinário**
   - Integrar John Deere Operations Center
   - Unificar consumo, horas, manutenção em um só lugar
   - **Benefício:** Tiago toma decisões mais rápidas e baseadas em dados

### 3. Pedidos Específicos (5 min)

**Contatos Técnicos:**
1. _"Você tem contato de TI na Castrolanda?"_
   - Para API de insumos/vendas

2. _"Você tem ChatGPT Plus?"_
   - Se SIM: Posso conectar suas planilhas do SharePoint para consultas por IA
   - Se NÃO: Não tem problema, vou te mostrar depois

**Acesso aos Dados:**
3. _"Posso ter acesso ao SharePoint para ver estrutura das planilhas?"_
4. _"Posso acompanhar Valentina e Tiago alguns dias para entender processos?"_

### 4. Expectativa e Timeline (5 min)

_"Pra gente fazer isso direito, o processo é:"_

1. **Esta semana:** Reuniões com Valentina e Alessandro (agronomia)
2. **Próxima semana:** Mapear todas as fontes de dados
3. **2-3 semanas:** Protótipo do dashboard de custo (Power BI inicial)
4. **1 mês:** Primeira automação funcionando (notas fiscais)

_"Faz sentido pra você? Tem alguma urgência/prioridade diferente?"_

---

## ✅ CHECKLIST DE ENTREGA DA REUNIÃO

**Após a reunião, você DEVE ter:**

### Informações Técnicas:
- [ ] Nome/contato técnico John Deere (para API)
- [ ] Tipo de TAG usada no abastecimento
- [ ] Como JD Operations Center e AgriWin integram (se integram)
- [ ] Formatos de export de dados (CSV, Excel, API?)
- [ ] Acesso concedido ao SharePoint
- [ ] Contato TI Castrolanda

### Validações:
- [ ] **Pain Point Claudio confirmado:** Dashboard custo/ha em tempo real
- [ ] **Pain Point Tiago identificado:** (a descobrir na reunião)
- [ ] **Processos manuais mapeados:** TAG, manutenção, almoxarifado
- [ ] **Dados históricos:** Onde estão? (AgriWin, JD, Excel?)

### Próximos Passos:
- [ ] Datas confirmadas: Reunião Valentina
- [ ] Datas confirmadas: Reunião Alessandro
- [ ] Permissão para gravar/documentar processos
- [ ] Buy-in do Claudio para seguir com projeto

---

## 🎯 PERGUNTAS OBRIGATÓRIAS (NÃO SAIR SEM RESPONDER)

**Para Tiago:**
1. ✅ Contato técnico John Deere (nome + e-mail)
2. ✅ John Deere tem API? Ou só export manual?
3. ✅ Sistema de TAG: tipo, fornecedor, como funciona
4. ✅ Onde estão dados de consumo/manutenção? (JD, AgriWin, Excel?)
5. ✅ Um pain point claro (tempo perdido ou informação difícil de conseguir)

**Para Claudio:**
1. ✅ Confirmar pain point: Dashboard custo/ha
2. ✅ Quanto tempo gasta hoje pra ter essas informações?
3. ✅ Contato TI Castrolanda (API insumos/vendas)
4. ✅ Aprovação para conversar com Valentina e Alessandro
5. ✅ Timeline aceita? (1 mês para primeiro MVP)

---

## 💡 DICAS PARA A REUNIÃO

### Postura:
- 🎧 **Escute 70%, fale 30%**
- 👀 **Peça para MOSTRAR** (não só falar)
- 📝 **Anote tudo** (especialmente números, nomes, contatos)
- 🤔 **Faça perguntas "burras"** (não assuma nada)
- 😊 **Tom colaborativo** (não audit auditoria)

### Frases Úteis:
- _"Me mostra como você faz isso?"_
- _"Quanto tempo isso toma?"_
- _"Já teve problema com isso?"_
- _"O que facilitaria seu dia a dia?"_
- _"Posso tirar foto/anotar isso?"_

### O Que Observar (Além das Respostas):
- Workarounds (gambiarras que fazem funcionar)
- Frustrações (tom de voz, expressões)
- Post-its, cadernos, "colas"
- Quantas vezes alterna entre sistemas
- O que ele faz manualmente que poderia ser automático

---

## 📸 DOCUMENTAÇÃO

### Durante a Reunião:
- [ ] Gravar áudio (pedir permissão)
- [ ] Tirar fotos de telas/sistemas (com permissão)
- [ ] Anotar em caderno (backup se não gravar)

### Imediatamente Após:
- [ ] Documentar descobertas em `13_DISCOVERY_TIAGO_16-01-2026.md`
- [ ] Listar ações imediatas (contatos, acessos)
- [ ] Aplicar prompt de análise de transcrição (se gravou)

---

## 🚀 SUCESSO DA REUNIÃO = 

**Você sai com:**
1. ✅ Contato John Deere (API)
2. ✅ Entendimento completo do Tiago (dados, processos, dores)
3. ✅ Validação do Claudio (pain point, timeline, aprovação)
4. ✅ Próximas reuniões marcadas (Valentina, Alessandro)
5. ✅ Pelo menos **1 pain point claro por pessoa** que você pode resolver

---

**BOA SORTE NA REUNIÃO! 🎯**

*Lembre-se: Você está lá para ENTENDER, não para VENDER. Escute, observe, anote. O produto sai naturalmente das dores que você descobrir.*
