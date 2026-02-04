# Relatório de Análise Técnica - Reunião João & Rodrigo

**Data da Reunião:** 03 de fevereiro de 2026
**Duração da Gravação:** 53 minutos 28 segundos
**Qualidade da Transcrição:** Média (última parte é conversa informal - ignorada)
**Participantes:** João Vitor Balzer (CTO), Rodrigo Kugler (CEO)
**Tipo:** Alinhamento técnico interno pós-reunião com cliente

---

## 1. RESUMO EXECUTIVO

Reunião de alinhamento técnico após apresentação bem-sucedida ao cliente SOAL. João detalhou a **arquitetura de segurança** do ambiente de desenvolvimento (bot rodando em VM isolada na Hostinger), explicou conceitos críticos de **modelagem de dados** (Diagrama ER, entidades fortes/fracas, relações 1:1, 1:N, N:N), e definiu a **entrega prioritária** para Rodrigo: criar o **Diagrama de Entidade-Relacionamento** da fazenda durante a visita física de sábado. Discutiram também a necessidade do **agente de IA no MVP** como diferencial competitivo, modelo de **precificação** (R$ 2.000-3.000/mês), e estratégia de **integração com Castrolanda** via autorização dos diretores.

---

## 2. ARQUITETURA DE SEGURANÇA E AMBIENTE DE DESENVOLVIMENTO

### 2.1 Classificação de Dados Sensíveis `[P0 - CRÍTICO]`

João explicou a hierarquia de sensibilidade de dados:

| Tipo | Exemplos | Sensibilidade | Pode estar no GitHub? |
|------|----------|---------------|----------------------|
| **Dados de Singularidade** | CPF, Nome, Endereço, RG, Telefone | **ALTA** | **NÃO** |
| **Credenciais** | Senhas, API Keys, Tokens | **ALTA** | **NÃO** |
| **Dados de Negócio Macro** | Faturamento ~R$ 20M, Área ~2.150 ha | Baixa | Sim (hipotético) |
| **Dados Públicos** | Endpoints públicos de APIs | Nenhuma | Sim |

**Citação (João):**
> "Dados que dão singularidade à pessoa. Basicamente consegue colocar isso na mente? Dados macros. Ah, mais ou menos 20 milhões, não é? Sabe um mês exato que ele fatura não tem isso que eu tô falando."

### 2.2 Ambiente Isolado do Bot `[P1 - ALTA]`

**Arquitetura de Segurança Atual:**

```
┌─────────────────────────────────────────────────────┐
│                    HOSTINGER VPS                     │
│  ┌─────────────────────────────────────────────┐    │
│  │              MÁQUINA VIRTUAL (KVM2)          │    │
│  │  ┌─────────────┐    ┌──────────────────┐   │    │
│  │  │   BOT IA    │───▶│  GitHub Org      │   │    │
│  │  │ (Anthropic) │    │  (código apenas) │   │    │
│  │  └─────────────┘    └──────────────────┘   │    │
│  │         │                                   │    │
│  │         ▼                                   │    │
│  │  ┌─────────────┐                           │    │
│  │  │  Banco Dev  │ ◀── Dados fictícios       │    │
│  │  │ (PostgreSQL)│                           │    │
│  │  └─────────────┘                           │    │
│  └─────────────────────────────────────────────┘    │
│                                                      │
│  Acesso: SSH com certificado (apenas máquinas João) │
│  Kill switch: Desligar VM = mata bot                │
└─────────────────────────────────────────────────────┘
```

**Controles de Segurança Implementados:**

| Controle | Implementação | Status |
|----------|---------------|--------|
| Isolamento | VM dedicada na Hostinger | Ativo |
| Acesso SSH | Certificado apenas máquinas João | Ativo |
| Chave Anthropic | Chave pessoal do João | Ativo |
| GitHub | Conta separada, João detém senha/email | Ativo |
| Dados no banco | 100% fictícios/hipotéticos | Ativo |
| Kill switch | Desligar VM = encerra bot | Disponível |

**Citação (João):**
> "Cara, se eu quiser matar ele, eu só venho ali, cara, desligo a máquina dele, acabou. [...] Ele tá aqui, ó. É só fazer assim, ó. Pum, configurações, acabou, já era, morreu."

### 2.3 Riscos Identificados com Bots de IA `[P1 - ALTA]`

João explicou os riscos que **evitou**:

| Risco | Descrição | Mitigação Aplicada |
|-------|-----------|-------------------|
| **Exposição de Porta** | Bot expor porta/IP na internet permite invasão | Bot não expõe portas públicas |
| **Contexto Amplo** | Bot com acesso a arquivos pessoais (Drive, chaveiro) | Bot roda em VM isolada |
| **API sem Autenticação** | Exemplo de amigo: API POST aberta para arquivos | Não aplicável (ainda não há API pública) |
| **Instalação Local** | Instalar bot no Mac pessoal = risco de vazamento | Bot roda em VM remota |

**Citação (João):**
> "Um brother meu, ele fez uma API que dá direto pra máquina virtual deles que ele tem os arquivos de todos os clientes dele. [...] Ele não sei, entendeu o problema do bote? Porque esse coda, mas cara, ele não coda autenticação."

---

## 3. MODELAGEM DE DADOS - DIAGRAMA ER `[P0 - CRÍTICO]`

### 3.1 Conceitos Explicados por João

**Diagrama de Entidade-Relacionamento (ER):**
- Modelagem do banco de dados sem pensar em telas
- Define quais dados salvar e como se relacionam
- Base para construção de APIs e dashboards

**Tipos de Relacionamento:**

| Relação | Símbolo | Exemplo na Plataforma |
|---------|---------|----------------------|
| Um para Um (1:1) | 1 ── 1 | Pessoa → Perfil |
| Um para Muitos (1:N) | 1 ── ∞ | Pessoa → Alertas |
| Muitos para Muitos (N:N) | ∞ ── ∞ | Valores financeiros cruzados |

**Citação (João):**
> "Uma pessoa pode criar infinitos alertas. Concorda? [...] Agora uma pessoa só pode ter um perfil na plataforma. Sacou?"

### 3.2 Entidades Fortes vs. Fracas `[P0 - CRÍTICO]`

| Tipo | Definição | Exemplo | Implicação |
|------|-----------|---------|------------|
| **Entidade Forte** | Relação 1:1, dados únicos/sensíveis | Cadastro RH (CPF, nome) | Requer proteção especial |
| **Entidade Fraca** | Relação 1:N, dados replicáveis | Lista de usuários | Menos sensível |

**Insight de Negócio (João):**
> "Quanto mais forte entidade de negócio, mais dinheiro provavelmente ele ganha com aquela entidade. [...] Se você tem que a entidade do secador é muito forte com a entidade do caminhão, cara, provavelmente tem muito dinheiro envolvido."

### 3.3 Modelo ER Atual da Plataforma

```
┌─────────────┐     1:1      ┌─────────────┐
│   PESSOAS   │─────────────▶│   PERFIS    │
│  - id       │              │  - id       │
│  - nome     │              │  - pessoa_id│
│  - email    │              │  - ...      │
│  - senha    │              └──────┬──────┘
│  - tipo     │                     │ 1:1
└──────┬──────┘              ┌──────▼──────┐
       │ 1:N                 │ CONTADORES  │
       │                     │  - id       │
┌──────▼──────┐              │  - perfil_id│
│   ALERTAS   │              └─────────────┘
│  - id       │
│  - pessoa_id│
│  - ...      │
└─────────────┘

┌─────────────┐     1:N      ┌─────────────┐
│   SESSÕES   │◀─────────────│   PESSOAS   │
│  - id       │              │             │
│  - pessoa_id│              │             │
│  - ...      │              │             │
└─────────────┘              └─────────────┘
```

### 3.4 Estrutura de Organograma/Permissões

```
ORGANIZAÇÃO (1)
     │
     │ 1:N
     ▼
   ÁREAS (N)
     │
     │ N:N
     ▼
 USUÁRIOS (N) ◀──── ROLES/PAPÉIS
                    - ver_dashboards_financeiros
                    - criar_paineis
                    - editar_dados
                    - ...
```

**Citação (João):**
> "São permissões que você dá para aquela pessoa. Então, por exemplo, quando uma pessoa é alocada numa área, ela já ganha os papéis daquela área."

---

## 4. ENTREGA PRIORITÁRIA: DIAGRAMA ER DA FAZENDA `[P0 - CRÍTICO]`

### 4.1 Tarefa para Rodrigo

**O que fazer na visita de sábado:**

1. **Mapear cada formulário** (secador, balança, gado, administrativo)
2. **Listar todas as colunas/campos** de cada formulário
3. **Identificar relacionamentos** entre formulários
4. **Documentar chaves de conexão** (ex: peso conecta entrada com saída)

**Citação (João):**
> "Começa pela ponta, começa isso, pega um formulário, beleza? Daí como que esse formulário se conecta com esse formulário? Ah, é pelo peso. Ah, é por isso. Beleza."

### 4.2 Exemplo de Mapeamento Esperado

```markdown
## FORMULÁRIO: Entrada Secador

### Campos:
- id_entrada (PK)
- data_hora
- placa_caminhao
- peso_bruto
- umidade_percentual
- sujeira_percentual
- cultura (FK → Culturas)
- talhao_origem (FK → Talhoes)
- silo_destino (FK → Silos)
- peso_liquido_estimado (calculado)
- flag_semente_propria

### Relacionamentos:
- 1 Entrada → 1 Cultura (1:1)
- 1 Entrada → 1 Talhão (1:1)
- 1 Entrada → 1 Silo (1:1)
- N Entradas → 1 Operador (N:1)
```

### 4.3 Fluxo de Trabalho Proposto

```
Visita Física (Rodrigo)
         │
         ▼
┌─────────────────────┐
│ Mapear formulários  │
│ e colunas de dados  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Identificar relações│
│ entre entidades     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Criar Diagrama ER   │
│ (Miro ou similar)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ João modela APIs    │
│ e banco de dados    │
└─────────────────────┘
```

**Citação (João):**
> "A plataforma e o front depende muito disso, entendeu? [...] Esse daqui que a gente precisa, com isso daqui é o ouro da nossa plataforma."

---

## 5. DECISÕES TÉCNICAS E ARQUITETURAIS

### 5.1 MVP Precisa do Agente de IA `[P0 - CRÍTICO]`

**Decisão:** O agente conversacional (chat) **deve estar no MVP**.

**Citação (João):**
> "Vou te falar, P, eu não queria e eu vou dar um jeito. Nosso MVP tem que ter o agente, P. Não tem, tem que ter."

**Justificativa:**
- Diferencial competitivo (ninguém no mercado tem)
- Validado com cliente na reunião anterior
- Core da proposta de valor da DeepWork

### 5.2 Transição de Desenvolvimento com Bot

**Fase Atual:** Refinamento manual após aceleração com bot

| Fase | Uso do Bot | Foco |
|------|------------|------|
| Discovery | Alto | Gerar telas, fluxos, ideias |
| Refinamento | Médio | Contextos pequenos, correções pontuais |
| Produção | Baixo/Nenhum | Código manual, sem dados sensíveis |

**Citação (João):**
> "Chegou um momento agora que não dá mais. Ela vai começar cada vez errar mais. [...] Trabalha nessa parada que tá errada aqui, tipo contexto pequeno. Antes eu tava dando contextos enormes."

### 5.3 Notas Fiscais e Pagamentos

**Descoberta:** Emissão de NF pode ser terceirizada.

| Opção | Descrição | Custo |
|-------|-----------|-------|
| Terceirização NF | Empresa emite NF por nós | Por nota emitida |
| Pagamento fora do app | Evitar taxa Apple (10%) / Google (5%) | Sem taxa |

**Citação (João):**
> "Existem algumas empresas que terceirizam isso para nós. [...] Eles ficam 100% responsável pela emissão da nota e a gente só paga eles por nota."

---

## 6. STATUS DO DESENVOLVIMENTO

### 6.1 Bugs Identificados na Reunião

| Bug | Descrição | Responsável | Status |
|-----|-----------|-------------|--------|
| Menu lateral | "Painéis" dentro de "Dados" (confuso) | João | A corrigir |
| Formulários = Dados | Botões levam ao mesmo lugar | João | A corrigir |
| Integrações | Tela não carrega (timeout baixo) | João | Investigando |
| Alertas | Não apareceu na demo | João | A corrigir |

### 6.2 Features Implementadas

| Feature | Status | Observação |
|---------|--------|------------|
| Tela de Login | Funcional | - |
| Dashboard Home | Funcional | 4 botões principais |
| Formulários | Parcial | Rota errada |
| Integrações | Parcial | Timeout |
| Alertas | Parcial | Não apareceu na demo |
| Minhas Chaves | Novo | Para gerenciar API keys |
| Organograma | Bugado | Estrutura de áreas/usuários |
| Relatórios | Conceito | Pré-setados para cliente |
| Chat IA | Pendente | Prioridade para MVP |

---

## 7. MODELO DE NEGÓCIO E PRECIFICAÇÃO

### 7.1 Estratégia de Preços Discutida

| Fase | Mensalidade | Observação |
|------|-------------|------------|
| Primeiros 10 clientes | R$ 2.000/mês | Preço de entrada |
| Próximos clientes | R$ 3.000/mês | Ajuste conforme aceitação |
| Custo de infra | ~R$ 725/mês | PostgreSQL + VPS + manutenção |
| Margem | ~R$ 1.275-2.275/mês | Por cliente |

**Citação (Rodrigo):**
> "Estamos pensando em cobrar dois conto de saída dos 10 primeiros e depois nos próximos já aumentar para três."

### 7.2 Proposta de Valor Core

**Citação (João):**
> "Nosso modelo de negócio é basicamente trazer controle e segurança. [...] A gente tá numa fase de desenvolvimento e a gente usou bastante a IA porque, cara, isso acelera."

---

## 8. INTEGRAÇÃO CASTROLANDA

### 8.1 Status e Próximos Passos

| Passo | Responsável | Status |
|-------|-------------|--------|
| Claudio falar com diretores | Claudio | Pendente |
| Autorização para acessar TI | Diretoria Castrolanda | Pendente |
| Solicitar acesso à API | DeepWork | Aguardando autorização |
| Apresentar produto | Rodrigo + João | Após produto mais maduro |

**Citação (Rodrigo):**
> "Daí ele falou que vai atrás dos diretor lá, que tem três caras que são cabeça, e vai falar, vai contar da ideia, vai contar o case."

### 8.2 Importância Estratégica

**90% das notas fiscais** da SOAL passam pela Castrolanda.

**Citação (Rodrigo):**
> "Pelo que eu tô entendendo, as notas de emissão, as emissões de nota, 90% delas são pela Castrolanda."

---

## 9. OPORTUNIDADE IDENTIFICADA: QUEBRA DE PRODUÇÃO `[P1 - ALTA]`

### 9.1 Problema de Controle

**Fluxo atual sem visibilidade:**

```
Campo → Balança (peso bruto) → Secador → Beneficiamento → Silo (peso líquido)
                                              │
                                              ▼
                                    Quebra = ? (estimativa)
```

**Risco identificado por Rodrigo:**
- Diferença entre peso bruto e líquido é estimada
- Sem controle preciso, possível desvio de produção
- Exemplo: 20 sacas "na quebra" = R$ 3.000-4.000 de desvio

**Citação (Rodrigo):**
> "Quem que garante que o cara não pega e descarrega, sei lá, 10, 20 sacas de feijão, tira ali, bota na quebra? [...] E beleza, esses 20 sacos de feijão eu vendo aqui fora por, sei lá, 150 conto cada um, faço R$ 3, 4000."

### 9.2 Oportunidade de Produto

**Funcionalidade proposta:** Controle de quebra real vs. estimada

| Métrica | Fonte | Cálculo |
|---------|-------|---------|
| Peso Bruto | Balança entrada | Medido |
| % Umidade | Análise | Medido |
| % Sujeira | Análise | Medido |
| Peso Líquido Estimado | Fórmula | Bruto - (Bruto x %umidade) - (Bruto x %sujeira) |
| Peso Líquido Real | Silo | Medido (software Leomar) |
| **Quebra Real** | Comparação | Estimado - Real |

---

## 10. CHECKLIST TÉCNICO

- [x] **Ambiente de desenvolvimento seguro:** Bot em VM isolada, sem dados sensíveis
- [x] **Classificação de dados:** Definida (singularidade = sensível)
- [ ] **Diagrama ER da fazenda:** Rodrigo vai mapear no sábado
- [ ] **Agente de IA no MVP:** Prioridade confirmada, implementação pendente
- [ ] **Integração Castrolanda:** Aguardando autorização dos diretores
- [ ] **Correção de bugs:** Menu lateral, rotas, timeout
- [x] **Modelo de precificação:** R$ 2.000-3.000/mês definido

---

## 11. PRÓXIMOS PASSOS

### Para Rodrigo (Visita Sábado)

1. **Mapear todos os formulários** da fazenda (secador, balança, gado, administrativo)
2. **Listar campos/colunas** de cada formulário
3. **Identificar relações** entre entidades (1:1, 1:N)
4. **Documentar chaves de conexão** (ex: cultura, talhão, silo)
5. **Criar Diagrama ER** no Miro ou Antigravidade
6. **Investigar software do Leomar** para controle de silos

### Para João

1. **Corrigir bugs** identificados (menu, rotas, timeout)
2. **Organizar código** após fase de aceleração com bot
3. **Criar branches** para desenvolvimento organizado
4. **Implementar agente de IA** no MVP
5. **Aguardar Diagrama ER** para modelar banco e APIs

### Decisões Pendentes

- [ ] Definir formato final do Diagrama ER
- [ ] Confirmar data de apresentação na Castrolanda
- [ ] Decidir terceirização de NF ou implementação própria

---

**Análise preparada por:** DeepWork AI Flows (Perspectiva CTO)
**Data:** 03/02/2026
