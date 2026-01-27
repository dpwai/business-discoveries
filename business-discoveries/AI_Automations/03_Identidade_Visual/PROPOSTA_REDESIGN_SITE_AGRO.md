# Proposta de Redesign - Site DeepWork AI Flows
## Foco: Inteligência de Dados para o Agronegócio

**Data:** 2026-01-27
**Versão:** 1.0 - Estrutura e Arquitetura
**Status:** Aguardando aprovação

---

## 🎯 Posicionamento Estratégico

### Proposta de Valor Principal
**"Transformamos dados agrícolas dispersos em decisões lucrativas"**

### Público-Alvo Primário
- Proprietários de fazendas (50-20.000 hectares)
- Gestores de operações agrícolas
- Diretores administrativos do agronegócio
- Administradores de fazendas familiares em crescimento

### Diferencial Competitivo
Não vendemos software genérico. Desenvolvemos inteligência de dados personalizada que integra seus sistemas existentes (ERP, telemetria, planilhas, cadernos) em uma fonte única de verdade.

---

## 📐 Estrutura do Site - Arquitetura de Informação

### NAVEGAÇÃO PRINCIPAL (Header fixo)

```
Logo [DeepWork AI Flows]    |    Início    |    Problema    |    Solução    |    Como Funciona    |    [WhatsApp CTA]
```

**Sticky Header:** Sim, com backdrop blur
**Mobile:** Menu hamburger colapsável
**CTA permanente:** Botão WhatsApp verde sempre visível (top-right)

---

## 📄 ESTRUTURA DE SEÇÕES (Single Page + Ancoragem)

### **SEÇÃO 1: HERO / ABERTURA**
**Objetivo:** Capturar atenção imediata + estabelecer relevância

**Layout:**
- Full viewport height (100vh)
- Background: Imagem de fazenda moderna (trator com telemetria, campo organizado, tecnologia no campo)
- Overlay: Gradiente escuro (60% opacity) para legibilidade

**Conteúdo:**

**Headline (H1):**
```
Seus 20 anos de dados agrícolas
estão escondidos em 5 sistemas diferentes.

Nós conectamos tudo.
```

**Subheadline (H2):**
```
Inteligência de Dados para o Agronegócio
Veja custo por hectare em tempo real. Tome decisões com base em dados, não intuição.
```

**CTA Primário:**
```
[Botão grande] "Quero ver meus dados unificados" → WhatsApp
```

**CTA Secundário:**
```
[Link texto] "Entender como funciona" → Scroll para seção "Como Funciona"
```

**Indicador Visual:**
- Seta para baixo animada (incentiva scroll)
- Badge pequeno: "Especialistas em Agronegócio"

---

### **SEÇÃO 2: O PROBLEMA (Por que você precisa disso?)**
**Objetivo:** Identificação profunda com as dores do produtor

**Layout:**
- Fundo escuro sólido (#002633)
- Cards com glassmorphism em grid 2x2 (desktop) / 1 coluna (mobile)

**Título da Seção:**
```
Você reconhece esses problemas?
```

**4 Cards de Dor (cada um com ícone):**

**Card 1: 📊 Dados Dispersos**
```
Título: "5+ sistemas que não conversam"
Descrição: Seu ERP tem uma versão da verdade, suas planilhas têm outra, e seus cadernos de campo têm a realidade. Você não confia no sistema oficial porque ele não reflete o que acontece na prática.
```

**Card 2: 💰 Custo Invisível**
```
Título: "Sem visão de custo por hectare em tempo real"
Descrição: Você só descobre se a safra foi lucrativa 6 meses depois do plantio. Impossível corrigir rota no meio da temporada quando os custos disparam.
```

**Card 3: ⏱️ Processos Manuais**
```
Título: "Horas perdidas com lançamento manual"
Descrição: Notas fiscais impressas, digitadas manualmente, conferidas em planilhas. Seu tempo está indo para burocracia em vez de gestão estratégica.
```

**Card 4: 📱 Atrito no Campo**
```
Título: "Operadores com mãos sujas não usam apps complexos"
Descrição: Sistemas bonitos que ninguém alimenta. Dados críticos ficam em cadernos porque o aplicativo é lento, complexo ou não funciona offline.
```

**Call-to-Action da Seção:**
```
[Texto centralizado, bold]
"Se você se identificou com 2 ou mais desses problemas,
temos a solução que você precisa."

[Botão] "Falar com especialista" → WhatsApp
```

---

### **SEÇÃO 3: A SOLUÇÃO (O que fazemos)**
**Objetivo:** Apresentar a abordagem e diferencial metodológico

**Layout:**
- Fundo: Gradiente suave (teal para verde)
- Conteúdo centralizado com max-width
- Visual de diagrama/infográfico

**Título da Seção:**
```
Inteligência de Dados Agrícolas Sob Medida
```

**Subtítulo:**
```
Não vendemos software pronto. Desenvolvemos sua plataforma de dados personalizada
que integra TODOS os seus sistemas existentes.
```

**O que conectamos (lista visual com ícones):**

```
[Ícone ERP]        Seu ERP Agrícola (AgriWin, Siagri, etc.)
[Ícone Trator]     Telemetria de Máquinas (John Deere, Case, etc.)
[Ícone Excel]      Suas Planilhas de Controle (a fonte real de verdade)
[Ícone Caderno]    Cadernos de Campo e Processos Manuais
[Ícone Caminhão]   Sistemas de Insumos (cooperativas, fornecedores)
[Ícone Silo]       Controles de Estoque e Armazenagem
[Ícone +]          Qualquer outro sistema que você usa
```

**Resultado Final (visual de antes/depois):**

**ANTES:**
```
[Diagrama caótico]
ERP ← → Excel ← → Caderno ← → Fornecedor
     ↓         ↓          ↓
   Você tentando juntar tudo manualmente
```

**DEPOIS:**
```
[Diagrama organizado]
Todos os sistemas → [Data Warehouse] → Dashboards + Relatórios + Insights
                                              ↓
                                        Decisões baseadas em dados
```

**CTA:**
```
[Botão] "Quero unificar meus dados" → WhatsApp
```

---

### **SEÇÃO 4: COMO FUNCIONA (Metodologia em 3 Etapas)**
**Objetivo:** Transparência no processo + reduzir fricção de decisão

**Layout:**
- Fundo branco ou cinza claro (contraste com seções anteriores)
- Timeline horizontal (desktop) / vertical (mobile)
- Numeração grande e visual

**Título da Seção:**
```
Como Transformamos Seus Dados em 3 Etapas
```

**Etapa 1: 🔍 DESCOBERTA PROFUNDA (2-4 semanas)**

**Número grande:** `01`

**Título:** "Entendemos sua operação por dentro"

**O que fazemos:**
```
✓ Visitamos sua fazenda e conversamos com sua equipe
✓ Mapeamos TODOS os sistemas que você usa (oficiais e "da gaveta")
✓ Identificamos onde estão seus dados reais (ERP, Excel, cadernos)
✓ Coletamos amostras de dados de cada fonte
✓ Documentamos seus processos e regras de negócio

Resultado: Um mapa completo de onde seus dados estão e como se conectam.
```

**Visual sugerido:** Foto de reunião em fazenda, cadernos, telas de sistemas

---

**Etapa 2: 🔧 INTEGRAÇÃO E ORGANIZAÇÃO (4-8 semanas)**

**Número grande:** `02`

**Título:** "Conectamos tudo e organizamos seus dados"

**O que fazemos:**
```
✓ Construímos pipelines automáticos de extração de dados
✓ Criamos seu Data Warehouse agrícola (banco de dados unificado)
✓ Limpamos, validamos e organizamos os dados em camadas
✓ Integramos dados de todas as fontes (ERP + Excel + Cadernos + Telemetria)
✓ Aplicamos suas regras de cálculo (custo/ha, margem, produtividade)

Resultado: Uma base de dados única, confiável e sempre atualizada.
```

**Visual sugerido:** Diagrama de arquitetura de dados, pipelines, dashboard em construção

---

**Etapa 3: 📊 DASHBOARDS E AUTOMAÇÃO (2-4 semanas)**

**Número grande:** `03`

**Título:** "Você visualiza e age com base em dados reais"

**O que fazemos:**
```
✓ Criamos dashboards personalizados para suas necessidades
✓ Automatizamos processos manuais (lançamento de NFs, relatórios)
✓ Configuramos alertas inteligentes (custos acima do esperado, etc.)
✓ Desenvolvemos interfaces simples para operadores de campo
✓ Treinamos sua equipe para usar a plataforma

Resultado: Visão completa da sua operação em tempo real + horas economizadas.
```

**Visual sugerido:** Screenshots de dashboards agrícolas (custo/ha, safra vs previsão, etc.)

---

**Timeline Total:**
```
[Barra visual] 8-16 semanas da descoberta até dashboards em produção
```

**CTA da Seção:**
```
[Botão centralizado] "Começar minha descoberta" → WhatsApp
```

---

### **SEÇÃO 5: PACOTES DE SERVIÇO (Tiered Offering)**
**Objetivo:** Apresentar opções claras sem revelar preços

**Layout:**
- Fundo escuro (#003C46)
- 3 cards lado a lado (desktop) / empilhados (mobile)
- Card central destacado (recommended)

**Título da Seção:**
```
Soluções Sob Medida Para Sua Realidade
```

**Subtítulo:**
```
Escolha o nível de transformação que sua operação precisa agora.
Você pode começar simples e evoluir conforme os resultados aparecem.
```

---

**PACOTE 1: DESCOBERTA**

**Badge:** "Ponto de Partida"

**Título:** "Mapeamento Completo"

**Descrição:**
```
Ideal para quem quer entender onde estão seus dados
e quais oportunidades de automação existem.
```

**O que inclui:**
```
✓ Visita técnica na fazenda
✓ Mapeamento de todos os sistemas e processos
✓ Análise de qualidade de dados
✓ Relatório detalhado com oportunidades identificadas
✓ Roadmap de implementação personalizado
```

**Resultado:**
```
Clareza total sobre seus dados + plano de ação documentado
```

**CTA:** `[Botão outline] "Solicitar descoberta"`

---

**PACOTE 2: INTELIGÊNCIA DE DADOS** ⭐

**Badge:** "Mais Popular" (destaque visual)

**Título:** "Data Warehouse Agrícola"

**Descrição:**
```
A transformação completa: dados unificados + dashboards
+ automações essenciais.
```

**O que inclui:**
```
✓ Tudo do pacote Descoberta
✓ Integração de todos os seus sistemas
✓ Data Warehouse unificado (banco de dados exclusivo)
✓ Dashboards personalizados (custo/ha, safra, operacional)
✓ Automação de processos manuais críticos
✓ Treinamento da equipe
✓ Suporte por 3 meses
```

**Resultado:**
```
Visão 360° da sua operação + redução de 70% em trabalho manual
```

**CTA:** `[Botão filled, destaque] "Quero transformar meus dados"`

---

**PACOTE 3: AUTOMAÇÃO INTELIGENTE**

**Badge:** "Máxima Eficiência"

**Título:** "IA + Automação Avançada"

**Descrição:**
```
Para operações que querem ir além: IA que prevê,
sugere e automatiza decisões.
```

**O que inclui:**
```
✓ Tudo do pacote Inteligência de Dados
✓ Assistente de IA para consultas em linguagem natural
✓ Alertas preditivos (custos, clima, mercado)
✓ Automação de decisões rotineiras
✓ Interfaces mobile otimizadas para campo
✓ Integração com WhatsApp/Telegram
✓ Suporte e evolução contínua
```

**Resultado:**
```
Operação autônoma com IA trabalhando 24/7 + decisões data-driven
```

**CTA:** `[Botão outline] "Falar sobre IA"`

---

**Nota de Rodapé dos Pacotes:**
```
💬 Todos os projetos são personalizados. Entre em contato para
   entender qual solução faz mais sentido para sua operação.
```

**CTA centralizado final:**
```
[Botão grande verde] "Falar com especialista no WhatsApp" → Link WA
```

---

### **SEÇÃO 6: DIFERENCIAIS (Por que escolher DeepWork AI)**
**Objetivo:** Destacar metodologia única sem mencionar SOAL

**Layout:**
- Fundo gradiente suave
- Grid 2x2 de cards com ícones

**Título da Seção:**
```
O que nos torna diferentes
```

---

**Diferencial 1: 🎯 Especialização em Agro**
```
Não somos uma consultoria de TI genérica. Entendemos de safra,
custo por hectare, telemetria de máquinas e desafios do campo.
```

**Diferencial 2: 🔐 Seus Dados, Seu Controle**
```
Arquitetura "zero knowledge": processamos seus dados de forma criptografada.
Nem nós temos acesso ao conteúdo. Privacidade total.
```

**Diferencial 3: 🤝 Integração Real (não substituição)**
```
Não vendemos mais um sistema. Conectamos o que você JÁ usa
(incluindo suas planilhas e cadernos). Sem jogar fora investimentos anteriores.
```

**Diferencial 4: 📱 Feito para Operadores de Campo**
```
Interfaces simples, botões grandes, funciona offline.
Pensado para quem está com as mãos sujas de graxa ou terra.
```

**Diferencial 5: 📈 Melhoria Contínua**
```
Não entregamos e sumimos. Evoluímos sua plataforma conforme
sua operação cresce e novas necessidades surgem.
```

**Diferencial 6: 🧠 Metodologia Documentada**
```
Não apenas implementamos. Documentamos seus processos e
conhecimento acumulado em 20+ anos de operação.
```

---

### **SEÇÃO 7: PERGUNTAS FREQUENTES (FAQ)**
**Objetivo:** Eliminar objeções + qualificar leads

**Layout:**
- Fundo branco/cinza claro
- Accordion expand/collapse
- 6-8 perguntas estratégicas

**Título da Seção:**
```
Perguntas Frequentes
```

---

**FAQ 1: Preciso trocar meu ERP atual?**
```
Não. Nosso trabalho é INTEGRAR seus sistemas existentes, não substituí-los.
Conectamos seu ERP, suas planilhas, telemetria de máquinas e qualquer outra
fonte de dados que você já usa.
```

**FAQ 2: Quanto tempo leva para ver resultados?**
```
A fase de descoberta leva 2-4 semanas. Após isso, você já recebe um relatório
completo com insights sobre seus dados. Dashboards operacionais ficam prontos
em 6-8 semanas após o início da integração.
```

**FAQ 3: Meus dados ficam seguros?**
```
Sim. Usamos arquitetura de "conhecimento zero" (zero-knowledge), onde seus dados
são processados de forma criptografada. Além disso, você mantém controle total
sobre onde seus dados ficam armazenados.
```

**FAQ 4: Funciona para fazendas pequenas/médias?**
```
Sim. Trabalhamos com operações de 50 a 20.000+ hectares. O tamanho importa menos
do que a complexidade dos seus dados. Se você tem múltiplos sistemas que não
conversam, podemos ajudar.
```

**FAQ 5: Preciso de uma equipe técnica interna?**
```
Não. Desenvolvemos e mantemos toda a infraestrutura técnica. Você e sua equipe
apenas usam os dashboards e recebem os insights. Fornecemos treinamento completo.
```

**FAQ 6: E se eu só uso Excel e cadernos?**
```
Perfeito. Grande parte das fazendas opera assim, e é exatamente onde temos
mais impacto. Transformamos suas planilhas e processos manuais em pipelines
automáticos de dados.
```

**FAQ 7: Quanto custa?**
```
Cada projeto é personalizado baseado no tamanho da operação, quantidade de sistemas
a integrar e nível de automação desejado. Entre em contato para uma avaliação
sem compromisso.
```

**FAQ 8: Como funciona o suporte após a entrega?**
```
Todos os nossos projetos incluem período de suporte (3-6 meses dependendo do pacote).
Após isso, oferecemos contratos de manutenção e evolução contínua para manter sua
plataforma sempre atualizada.
```

---

### **SEÇÃO 8: CALL-TO-ACTION FINAL**
**Objetivo:** Último empurrão para conversão

**Layout:**
- Full-width
- Fundo verde vibrante (#14AA82) ou imagem de safra bem-sucedida
- Conteúdo centralizado

**Headline:**
```
Pronto para transformar seus dados em decisões lucrativas?
```

**Subheadline:**
```
Fale com nossa equipe e descubra como podemos unificar seus
sistemas agrícolas em uma única fonte de verdade.
```

**CTA Principal:**
```
[Botão grande branco com texto verde]
"Falar no WhatsApp Agora" → Link WhatsApp
```

**CTA Secundário:**
```
[Link texto branco]
"Ou envie um email: contato@dpwai.com.br"
```

**Trust Badge:**
```
✓ Resposta em até 24 horas
✓ Primeira consulta sem compromisso
✓ Atendimento 100% em português
```

---

### **FOOTER (Rodapé)**

**Layout:** Dark background (#002633), 3 colunas

**Coluna 1: Sobre**
```
Logo DeepWork AI Flows
Tagline: "Inteligência de Dados para o Agronegócio"

Breve descrição (2-3 linhas):
Consultoria especializada em unificar dados agrícolas dispersos
e criar dashboards personalizados para decisões data-driven.
```

**Coluna 2: Navegação Rápida**
```
→ Início
→ O Problema
→ Nossa Solução
→ Como Funciona
→ Pacotes
→ FAQ
```

**Coluna 3: Contato**
```
📱 WhatsApp: +55 42 9911-0955
📧 Email: contato@dpwai.com.br
🌐 Site: www.dpwai.com.br
```

**Coluna 4: Legal (opcional, rodapé inferior)**
```
© 2026 DeepWork AI Flows. Todos os direitos reservados.
Privacidade de Dados | Termos de Uso
```

---

## 📱 RESPONSIVIDADE - Breakpoints

### Desktop (>1200px)
- Hero full viewport
- Cards em grid 2x2 ou 3 colunas
- Timeline horizontal
- Navegação expandida

### Tablet (768px - 1200px)
- Cards em 2 colunas
- Timeline horizontal compacta
- Menu pode colapsar

### Mobile (<768px)
- Single column para todos os cards
- Timeline vertical
- Menu hamburger obrigatório
- Botões CTA full-width
- Texto hero reduzido (2.5rem → 1.8rem)

---

## 🎨 DIRETRIZES VISUAIS (Guidelines para Design)

### Paleta de Cores (manter identidade atual)
```
Primária Escura: #002633 (backgrounds escuros)
Primária Média: #003C46 (cards, overlays)
Accent Verde: #14AA82 (CTAs, highlights)
Verde Hover: #12997A (hover states)
Texto Light: #FFFFFF (títulos em fundos escuros)
Texto Secundário: #A0B4BA (descrições)
Fundos Claros: #F5F8F9 (alternância de seções)
```

### Tipografia (manter Montserrat)
```
Headings: Montserrat Bold/ExtraBold
Body: Montserrat Regular/Medium
Sizes Desktop:
  H1 Hero: 3.5-4rem
  H2 Section: 2.5-3rem
  H3 Cards: 1.5-2rem
  Body: 1.125rem
  Small: 0.875rem

Sizes Mobile:
  H1 Hero: 2-2.5rem
  H2 Section: 1.75-2rem
  H3 Cards: 1.25-1.5rem
  Body: 1rem
```

### Imagens e Visuais Sugeridos
**Hero:**
- Trator moderno em campo verde/plantação
- Agricultor usando tablet em campo
- Fazenda vista aérea com tecnologia

**Seção Problema:**
- Ícones minimalistas (dados dispersos, dinheiro, relógio, smartphone)
- Ilustrações de frustração/desorganização

**Seção Solução:**
- Diagrama limpo de integração de sistemas
- Mockup de dashboard agrícola
- Antes/depois visual

**Seção Como Funciona:**
- Foto de reunião em fazenda (descoberta)
- Diagrama técnico simplificado (integração)
- Screenshots de dashboards (entrega)

**Seção Pacotes:**
- Ícones diferenciados para cada tier
- Badges visuais (Popular, Recomendado)

### Efeitos e Interações
```
Glassmorphism: backdrop-filter: blur(10px), background: rgba(255,255,255,0.1)
Hover Cards: transform: translateY(-8px), box-shadow aumenta
Scroll Animations: Fade-in suave ao entrar no viewport
CTA Pulse: Animação sutil no botão principal
Smooth Scroll: behavior: smooth para navegação interna
```

---

## 🔄 FLUXO DO USUÁRIO (User Journey)

### Entrada: Google Search ou Indicação
```
↓
```

### 1. HERO - Identificação Imediata
```
"Esse site fala comigo?" → SIM (dados agrícolas dispersos)
Ação: Scroll ou clique "Entender como funciona"
↓
```

### 2. PROBLEMA - Identificação Profunda
```
"Eles entendem minha dor?" → SIM (2+ cards ressoam)
Ação: "Falar com especialista" OU continuar explorando
↓
```

### 3. SOLUÇÃO - Compreensão da Abordagem
```
"Como eles resolvem?" → Integração de sistemas existentes
Ação: Scroll para "Como Funciona"
↓
```

### 4. COMO FUNCIONA - Redução de Fricção
```
"É complicado? Demora?" → 3 etapas claras, 8-16 semanas
Ação: Scroll para "Pacotes"
↓
```

### 5. PACOTES - Decisão de Nível
```
"Qual faz sentido pra mim?" → Descoberta (low risk) ou Inteligência (transformação)
Ação: Clique CTA do pacote escolhido → WhatsApp
↓
```

### 6. FAQ (se ainda tiver dúvidas)
```
"E se...?" → Objeções respondidas
Ação: CTA final
↓
```

### 7. CONVERSÃO - WhatsApp
```
Conversa inicial com equipe DeepWork
```

---

## 📊 MÉTRICAS DE SUCESSO (para acompanhar pós-lançamento)

### Engajamento
- **Scroll depth:** % que chega em cada seção
- **Tempo na página:** Meta >2min para visitantes qualificados
- **Bounce rate:** Meta <50%

### Conversão
- **Click WhatsApp:** Taxa de cliques no CTA principal
- **Conversas iniciadas:** Quantas pessoas realmente mandam mensagem
- **Leads qualificados:** % de conversas que viram oportunidades reais

### Qualidade do Lead
- **Tamanho da operação:** Hectares (ideal: 500+)
- **Número de sistemas:** Quanto mais, melhor fit
- **Urgência:** "Quero agendar visita" vs "Só pesquisando"

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

### Fase 1: Estrutura e Conteúdo
- [ ] Aprovar estrutura de seções
- [ ] Escrever copy completo em português
- [ ] Selecionar/criar imagens e visuais
- [ ] Definir CTAs e links WhatsApp
- [ ] Revisar FAQ com objeções reais

### Fase 2: Design Visual
- [ ] Mockups desktop de cada seção
- [ ] Mockups mobile responsivos
- [ ] Definir animações e interações
- [ ] Criar biblioteca de componentes
- [ ] Validar acessibilidade (contraste, fontes)

### Fase 3: Desenvolvimento
- [ ] Setup Next.js / HTML estático
- [ ] Implementar seções uma a uma
- [ ] Integrar animações e scroll
- [ ] Configurar WhatsApp API links
- [ ] Testar responsividade
- [ ] Otimizar performance (imagens, load time)

### Fase 4: SEO e Analytics
- [ ] Meta tags (title, description) para agro
- [ ] Schema markup (LocalBusiness, Service)
- [ ] Google Analytics 4 setup
- [ ] Hotjar ou similar (heatmaps)
- [ ] Google Search Console

### Fase 5: Launch
- [ ] Testes de QA completos
- [ ] Deploy em produção
- [ ] Monitorar primeiras 48h
- [ ] Coletar feedback inicial
- [ ] Iterar baseado em dados

---

## 🚀 PRÓXIMOS PASSOS

1. **APROVAÇÃO DESTA ESTRUTURA**
   - Rodrigo revisa e aprova/ajusta seções
   - Definir prioridades se precisar simplificar

2. **DESENVOLVIMENTO DE COPY**
   - Escrever textos completos em português
   - Ajustar tom de voz para produtor rural
   - Validar termos técnicos do agro

3. **DESIGN VISUAL**
   - Criar mockups no Figma
   - Selecionar banco de imagens ou fotos próprias
   - Definir iconografia

4. **IMPLEMENTAÇÃO TÉCNICA**
   - Decidir: Next.js ou HTML estático?
   - Desenvolver frontend
   - Configurar domínio e hosting

5. **LANÇAMENTO E OTIMIZAÇÃO**
   - Soft launch para teste
   - Coletar métricas
   - Iterar baseado em conversões

---

## 💬 OBSERVAÇÕES FINAIS

### Pontos Fortes Desta Estrutura
✅ Foco laser em agronegócio (sem diluição)
✅ Linguagem direta para produtor rural
✅ Metodologia transparente sem revelar cliente
✅ Tiered offering claro (baixo risco → transformação)
✅ FAQ elimina objeções principais
✅ WhatsApp como único CTA (simplicidade)
✅ Sem mencionar equipe/preços (conforme solicitado)

### Considerações de Risco
⚠️ **Sem prova social:** Sem case SOAL nomeado, precisamos compensar com copy forte e demonstração de expertise técnica
⚠️ **Sem time visível:** Pode gerar dúvida sobre tamanho/credibilidade da empresa
⚠️ **Pricing oculto:** Pode atrair leads não-qualificados, mas ok se WhatsApp filtrar

### Mitigações Sugeridas (Futuras)
- Após SOAL MVP: Adicionar case study com métricas
- Considerar seção "Sobre" light (sem nomes, mas "15+ anos exp em dados")
- Blog futuro com conteúdo educativo agro (SEO)

---

**Documento preparado por:** Claude Code (Business Context Expert Agent)
**Baseado em:** Contexto completo do projeto business-discoveries
**Aguardando:** Feedback e aprovação para próxima fase (Copy + Design)
