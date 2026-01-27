# Wireframes Detalhados - Site DeepWork AI Agronegócio
## Estrutura Visual Completa (8 Seções)

**Data:** 2026-01-27
**Versão:** 1.0
**Para Aprovação**

---

## 📐 NAVEGAÇÃO PRINCIPAL

### Header (Fixo no topo)

```
Desktop (>1024px):
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│  [Logo DeepWork]    Início  Desafios  Solução  Como Funciona      │
│                                             [WhatsApp: Fale Agora] │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

```
Mobile (<768px):
┌─────────────────────────────────────────┐
│  [Logo]              [☰] [WhatsApp]    │
└─────────────────────────────────────────┘
```

**Notas:**
- Header com `backdrop-filter: blur(10px)` + transparência
- Scroll down: sombra aumenta
- Logo clicável volta ao topo
- WhatsApp button verde sempre visível

---

## SEÇÃO 1: HERO (Abertura)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│         [IMAGEM DE FUNDO: Campo/Fazenda com overlay escuro]         │
│                                                                      │
│                                                                      │
│                  ┌─────────────────────────────┐                    │
│                  │                             │                    │
│                  │   Construída por            │                    │
│                  │   agricultores              │                    │
│                  │   para agricultores.        │                    │
│                  │                             │                    │
│                  │   Inteligência de dados     │                    │
│                  │   que cresce com sua        │                    │
│                  │   operação agrícola.        │                    │
│                  │                             │                    │
│                  │   ┌──────────────────────┐  │                    │
│                  │   │ Conhecer a solução  │  │                    │
│                  │   └──────────────────────┘  │                    │
│                  │                             │                    │
│                  │   Ver como funciona ↓       │                    │
│                  │                             │                    │
│                  └─────────────────────────────┘                    │
│                                                                      │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
                              Scroll ↓
```

**Especificações:**
- Altura: 100vh (tela cheia)
- Background: hero-background-main.png + gradient overlay
- Texto: Branco, centralizado
- H1: "Construída por agricultores para agricultores."
- Subheadline: "Inteligência de dados que cresce com sua operação agrícola."
- CTA verde: "Conhecer a solução"
- Link secundário: "Ver como funciona"

---

### Mobile

```
┌─────────────────────────┐
│                         │
│   [IMG: Campo mobile]   │
│                         │
│   Construída por        │
│   agricultores para     │
│   agricultores.         │
│                         │
│   Inteligência de       │
│   dados que cresce      │
│   com sua operação.     │
│                         │
│   ┌──────────────────┐  │
│   │ Conhecer        │  │
│   │ a solução       │  │
│   └──────────────────┘  │
│                         │
│   Ver como funciona ↓   │
│                         │
└─────────────────────────┘
```

---

## SEÇÃO 2: DESAFIOS COMUNS (Fundo Branco)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                    Desafios comuns no agronegócio moderno            │
│                                                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │  [Ícone Dados]  │  │ [Ícone Custos]  │  │  [Ícone Tempo]  │    │
│  │                 │  │                 │  │                 │    │
│  │  Múltiplos      │  │  Da análise     │  │  Mais tempo     │    │
│  │  sistemas,      │  │  reativa à      │  │  para gestão    │    │
│  │  uma única      │  │  gestão         │  │  estratégica    │    │
│  │  operação       │  │  proativa       │  │                 │    │
│  │                 │  │                 │  │                 │    │
│  │  Sua operação   │  │  Hoje, muitas   │  │  Lançamento de  │    │
│  │  utiliza        │  │  decisões...    │  │  notas fiscais  │    │
│  │  diversas       │  │  (descrição)    │  │  consolidação   │    │
│  │  ferramentas... │  │                 │  │  de relatórios  │    │
│  │                 │  │                 │  │  (descrição)    │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  [Ícone Campo]                                              │    │
│  │                                                             │    │
│  │  Interfaces projetadas para a realidade do campo           │    │
│  │                                                             │    │
│  │  Operadores no campo precisam de ferramentas que           │    │
│  │  funcionem em suas condições reais de trabalho...          │    │
│  │                                                             │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                      │
│                Esses desafios são oportunidades de ganho            │
│                        de eficiência.                               │
│                                                                      │
│                  ┌────────────────────────────┐                     │
│                  │  Falar com especialista    │                     │
│                  └────────────────────────────┘                     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- 4 cards em grid 2x2 (desktop) / 1 coluna (mobile)
- Cada card: branco, borda-top verde 4px, sombra sutil
- Ícone 48px verde no topo
- Título card: h3 (1.25rem)
- Descrição: texto secundário
- CTA ao final: verde, centralizado

---

## SEÇÃO 3: A SOLUÇÃO (Fundo Cinza Claro)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│            Inteligência de Dados Agrícolas Personalizada             │
│                                                                      │
│          Desenvolvemos sua plataforma de dados sob medida,           │
│        integrando todos os sistemas que você já utiliza - sem        │
│                          substituições.                              │
│                                                                      │
│              Conectamos suas fontes de dados existentes:             │
│                                                                      │
│   ✓ Sistemas ERP Agrícolas (AgriWin, Siagri, e outros)             │
│   ✓ Telemetria de Máquinas (John Deere, Case IH, New Holland)      │
│   ✓ Planilhas de Controle e Gestão                                 │
│   ✓ Cadernos de Campo e Registros Manuais                          │
│   ✓ Plataformas de Fornecedores (cooperativas, distribuidoras)     │
│   ✓ Sistemas de Armazenagem e Secagem                              │
│   ✓ Qualquer outra fonte de dados da sua operação                  │
│                                                                      │
│              ┌─────────────────────────────────────┐                │
│              │  💡 Respeitamos e aproveitamos o   │                │
│              │  conhecimento acumulado em cada     │                │
│              │  sistema, planilha e caderno.       │                │
│              │  Nada é descartado, tudo é          │                │
│              │  integrado.                         │                │
│              └─────────────────────────────────────┘                │
│                                                                      │
│           De múltiplas fontes para decisões unificadas               │
│                                                                      │
│  ┌──────────────────────────┐  ┌──────────────────────────┐        │
│  │  ANTES                   │  │  DEPOIS                  │        │
│  │                          │  │                          │        │
│  │  [Diagrama caótico]      │  │  [Diagrama organizado]   │        │
│  │  Sistemas dispersos      │  │  Todos os sistemas →     │        │
│  │  sem integração          │  │  Data Warehouse →        │        │
│  │                          │  │  Dashboards + Insights   │        │
│  └──────────────────────────┘  └──────────────────────────┘        │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │                                                              │   │
│  │        [MOCKUP: Dashboard Agrícola - Tela grande]           │   │
│  │                                                              │   │
│  │  Gráficos: Custo/ha, Yield, Financial Summary, Map          │   │
│  │                                                              │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│                  ┌────────────────────────────┐                     │
│                  │  Quero unificar minha      │                     │
│                  │  operação                  │                     │
│                  └────────────────────────────┘                     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Fundo: #F8F9FA (cinza claro)
- Lista com checkmarks verdes
- Callout destacado (borda verde à esquerda)
- 2 diagramas lado a lado (Antes/Depois)
- Mockup de dashboard grande e visível
- CTA verde ao final

---

## SEÇÃO 4: METODOLOGIA (Fundo Branco)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                  Nossa metodologia de transformação                  │
│                                                                      │
│        Um processo estruturado e transparente, desenvolvido          │
│           especificamente para operações agrícolas.                  │
│                                                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │                 │  │                 │  │                 │    │
│  │       01        │  │       02        │  │       03        │    │
│  │  ●─────────────●│─────────●──────────│──────────●        │    │
│  │                 │  │                 │  │                 │    │
│  │  Mapeamento e  │  │  Construção do  │  │  Visualização   │    │
│  │  Entendimento  │  │  Data Warehouse │  │  e Automação    │    │
│  │  Completo      │  │  Agrícola       │  │                 │    │
│  │                 │  │                 │  │                 │    │
│  │  2-4 semanas    │  │  4-8 semanas    │  │  2-4 semanas    │    │
│  │                 │  │                 │  │                 │    │
│  │  O que fazemos: │  │  O que fazemos: │  │  O que fazemos: │    │
│  │  ✓ Visita       │  │  ✓ Construção  │  │  ✓ Dashboards   │    │
│  │  ✓ Entrevistas  │  │  ✓ Integração  │  │  ✓ Automação    │    │
│  │  ✓ Mapeamento   │  │  ✓ Validação   │  │  ✓ Treinamento  │    │
│  │  ...            │  │  ...            │  │  ...            │    │
│  │                 │  │                 │  │                 │    │
│  │  Entregável:    │  │  Entregável:    │  │  Entregável:    │    │
│  │  → Relatório    │  │  → Data         │  │  → Plataforma   │    │
│  │  → Roadmap      │  │    Warehouse    │  │    completa     │    │
│  │                 │  │  → Docs         │  │  → Suporte      │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│                                                                      │
│              ┌────────────────────────────────────────┐              │
│              │  8 a 16 semanas da descoberta até      │              │
│              │  plataforma completa em produção       │              │
│              └────────────────────────────────────────┘              │
│                                                                      │
│              💡 Trabalhamos em sprints iterativos: você vê          │
│              resultados parciais desde a primeira etapa             │
│                                                                      │
│                  ┌────────────────────────────┐                     │
│                  │  Iniciar mapeamento da     │                     │
│                  │  minha operação            │                     │
│                  └────────────────────────────┘                     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Timeline horizontal com 3 etapas
- Números grandes (01, 02, 03) em background suave
- Linha conectora com bullets verdes
- Cada etapa: duração, descrição, entregável
- Timeline total destacado
- Nota sobre iteração
- CTA ao final

---

## SEÇÃO 5: PACOTES (Fundo Verde Claro)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                Soluções sob medida para cada estágio                 │
│                                                                      │
│      Você pode começar com mapeamento e evoluir conforme os          │
│             resultados aparecem, ou já iniciar a                     │
│                   transformação completa.                            │
│                                                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │  Ponto de Partida│  │  ⭐ POPULAR ⭐  │  │ Máxima Eficiência│    │
│  ├─────────────────┤  ├─────────────────┤  ├─────────────────┤    │
│  │                 │  │                 │  │                 │    │
│  │  Mapeamento     │  │  Plataforma de  │  │  Inteligência   │    │
│  │  Estratégico    │  │  Inteligência   │  │  Aumentada      │    │
│  │                 │  │  Agrícola       │  │  com IA         │    │
│  │  Para quem:     │  │                 │  │                 │    │
│  │  Operações que  │  │  Para quem:     │  │  Para quem:     │    │
│  │  querem         │  │  Operações      │  │  Operações de   │    │
│  │  entender seu   │  │  prontas para   │  │  grande porte   │    │
│  │  potencial...   │  │  transformar... │  │  que querem...  │    │
│  │                 │  │                 │  │                 │    │
│  │  O que inclui:  │  │  O que inclui:  │  │  O que inclui:  │    │
│  │  ✓ Visita       │  │  ✓ Tudo do      │  │  ✓ Tudo do      │    │
│  │  ✓ Mapeamento   │  │    pacote 1     │  │    pacote 2     │    │
│  │  ✓ Análise      │  │  ✓ Data         │  │  ✓ Assistente   │    │
│  │  ✓ Roadmap      │  │    Warehouse    │  │    de IA        │    │
│  │  ...            │  │  ✓ Dashboards   │  │  ✓ Alertas      │    │
│  │                 │  │  ✓ Automação    │  │    preditivos   │    │
│  │  Ideal para:    │  │  ...            │  │  ...            │    │
│  │  → Validar      │  │                 │  │                 │    │
│  │  → Entender     │  │  Ideal para:    │  │  Ideal para:    │    │
│  │  → Planejar     │  │  → 500+ ha      │  │  → 2.000+ ha    │    │
│  │                 │  │  → Múltiplos    │  │  → IA           │    │
│  │                 │  │    sistemas     │  │    preditiva    │    │
│  │                 │  │  ...            │  │  ...            │    │
│  │  ┌────────────┐ │  │  ┌────────────┐ │  │  ┌────────────┐ │    │
│  │  │Solicitar   │ │  │  │Transformar │ │  │  │Conhecer IA │ │    │
│  │  │diagnóstico │ │  │  │completa    │ │  │  │Agrícola    │ │    │
│  │  └────────────┘ │  │  └────────────┘ │  │  └────────────┘ │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│                                                                      │
│     💬 Cada projeto é desenvolvido sob medida. Os pacotes acima     │
│     são pontos de partida - personalizamos conforme sua             │
│     realidade e objetivos.                                          │
│                                                                      │
│                  ┌────────────────────────────┐                     │
│                  │  Falar com especialista    │                     │
│                  │  no WhatsApp               │                     │
│                  └────────────────────────────┘                     │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Fundo: #F0F4F3 (verde muito claro)
- 3 cards lado a lado
- Card central destacado (maior, badge "Popular", borda verde mais grossa)
- Cada card: título, para quem, o que inclui, ideal para, CTA
- Nota de rodapé sobre personalização
- CTA principal verde grande ao final

---

## SEÇÃO 6: DIFERENCIAIS (Fundo Branco)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│              Por que produtores escolhem DeepWork AI                 │
│                                                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │  [Ícone Agro]   │  │  [Ícone Lock]   │  │  [Ícone Link]   │    │
│  │                 │  │                 │  │                 │    │
│  │  Especialização │  │  Seus dados,    │  │  Aproveitamos   │    │
│  │  profunda em    │  │  sua            │  │  seus           │    │
│  │  agronegócio    │  │  propriedade    │  │  investimentos  │    │
│  │                 │  │                 │  │  existentes     │    │
│  │  Não somos uma  │  │  Utilizamos     │  │  Não vendemos   │    │
│  │  consultoria de │  │  arquitetura de │  │  substituição   │    │
│  │  TI genérica... │  │  conhecimento   │  │  de sistemas... │    │
│  │  (descrição)    │  │  zero...        │  │  (descrição)    │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│                                                                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐    │
│  │  [Ícone Mobile] │  │ [Ícone Growth]  │  │  [Ícone Docs]   │    │
│  │                 │  │                 │  │                 │    │
│  │  Interfaces     │  │  Melhoria       │  │  Documentação   │    │
│  │  projetadas     │  │  contínua       │  │  da sua         │    │
│  │  para campo     │  │                 │  │  expertise      │    │
│  │                 │  │  Não            │  │                 │    │
│  │  Desenvolvemos  │  │  implementamos  │  │  Durante o      │    │
│  │  interfaces...  │  │  e              │  │  projeto...     │    │
│  │  (descrição)    │  │  desaparecemos  │  │  (descrição)    │    │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘    │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Grid 3 colunas (desktop) / 1 coluna (mobile)
- 6 cards totais (2 linhas de 3)
- Cada card: ícone verde 48px, título h3, descrição
- Cards brancos com borda-top verde
- Hover: elevação sutil

---

## SEÇÃO 7: FAQ (Fundo Cinza Claro)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│                      Perguntas Frequentes                            │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Preciso substituir meu ERP ou outros sistemas atuais?  [+] │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Quanto tempo leva até ter resultados práticos?         [+] │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Como garantem a segurança dos meus dados?               [-] │   │
│  ├──────────────────────────────────────────────────────────────┤   │
│  │  Segurança em múltiplas camadas:                            │   │
│  │  • Arquitetura "zero-knowledge" - processamento             │   │
│  │    criptografado...                                         │   │
│  │  (resposta expandida)                                       │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Funciona para operações de pequeno e médio porte?      [+] │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ... (mais 4 perguntas)                                             │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Fundo: #F8F9FA (cinza claro)
- Max-width: 800px centralizado
- 8 perguntas em accordion
- Pergunta: bold, clicável, [+]/[-] indicador
- Resposta: expande suavemente com animação
- Borda inferior entre items

---

## SEÇÃO 8: CTA FINAL (Fundo Verde com Imagem)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│         [IMAGEM DE FUNDO: Safra bem-sucedida com overlay]           │
│                                                                      │
│                                                                      │
│              Pronto para transformar dados em                        │
│                  vantagem competitiva?                               │
│                                                                      │
│            Converse com nossa equipe sobre como podemos              │
│         desenvolver a solução de inteligência de dados ideal         │
│                      para sua operação.                              │
│                                                                      │
│                  ┌────────────────────────────┐                     │
│                  │  [WhatsApp Icon]           │                     │
│                  │  Falar com especialista    │                     │
│                  │  agora                     │                     │
│                  └────────────────────────────┘                     │
│                                                                      │
│               Prefere email? contato@dpwai.com.br                   │
│                                                                      │
│            ✓ Primeira consulta sem compromisso                      │
│            ✓ Resposta em até 24 horas                               │
│            ✓ Atendimento 100% em português                          │
│            ✓ Especialistas em agronegócio                           │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Background: imagem de safra + overlay verde (#2ECC71 com 70% opacity)
- Texto: branco, centralizado
- Botão: branco com texto verde (inversão do padrão)
- Trust elements: checkmarks brancos
- Email link: branco underline

---

## FOOTER (Azul Escuro)

### Desktop

```
┌──────────────────────────────────────────────────────────────────────┐
│                        [Logo Branco]                                 │
│                                                                      │
│              Inteligência de Dados para o Agronegócio                │
│                                                                      │
│     Consultoria especializada em unificar dados agrícolas            │
│     dispersos e transformá-los em plataformas de decisão             │
│                      estratégica.                                    │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌─────────────────────┐       │
│  │  NAVEGAÇÃO   │  │  CONTATO     │  │  LEGAL              │       │
│  │              │  │              │  │                     │       │
│  │  Início      │  │  📱 WhatsApp │  │  © 2026 DeepWork    │       │
│  │  Desafios    │  │  +55 42 ...  │  │  AI Flows           │       │
│  │  Solução     │  │              │  │                     │       │
│  │  Metodologia │  │  📧 Email    │  │  Privacidade        │       │
│  │  Pacotes     │  │  contato@... │  │  de Dados           │       │
│  │  FAQ         │  │              │  │                     │       │
│  │              │  │  🌐 Web      │  │  Termos de Uso      │       │
│  │              │  │  dpwai.com.br│  │                     │       │
│  └──────────────┘  └──────────────┘  └─────────────────────┘       │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Especificações:**
- Background: #0A2540 (azul escuro)
- Texto: branco/cinza claro
- Logo: versão branca do gradiente
- 3 colunas: Navegação, Contato, Legal
- Links: hover verde claro
- Social icons: opcional, cor branca com hover verde

---

## 📱 ADAPTAÇÕES MOBILE

### Principais Mudanças Mobile (<768px):

1. **Hero:** Texto menor, botão full-width, padding reduzido
2. **Desafios:** Cards empilhados (1 coluna)
3. **Solução:** Diagramas empilhados verticalmente
4. **Metodologia:** Timeline vertical, não horizontal
5. **Pacotes:** Cards empilhados, card popular primeiro
6. **Diferenciais:** 1 coluna
7. **FAQ:** Mesma estrutura, texto menor
8. **Footer:** 1 coluna empilhada

---

## ✅ APROVAÇÃO NECESSÁRIA

Antes de implementar, confirme:

1. **Estrutura geral das 8 seções:** OK?
2. **Headline Hero ("Construída por agricultores..."):** Aprovada?
3. **Ordem dos pacotes:** Descoberta → Inteligência → IA está clara?
4. **Diferenciais (6 cards):** Suficiente ou adicionar/remover?
5. **FAQ (8 perguntas):** Completo ou faltou alguma objeção importante?

**Aguardando seu OK para começar implementação HTML/CSS!**

---

**Próximo passo após aprovação:**
Implementar seção por seção com HTML/CSS, começando por Hero e validando cada uma antes de prosseguir.
