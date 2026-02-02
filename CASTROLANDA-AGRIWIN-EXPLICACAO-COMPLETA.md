# Entendendo a Castrolanda e o Agriwin - Explicação Completa

**Data:** 27/01/2026
**Autor:** Análise técnica via Claude Code

---

## PARTE 1: O QUE É A CASTROLANDA?

### 1.1 História e Origem

A **Castrolanda** é uma **cooperativa agroindustrial** fundada em **1951** por imigrantes holandeses que vieram ao Brasil após a Segunda Guerra Mundial.

**Por que "Castrolanda"?**
- **Castro** = Cidade de Castro, no Paraná
- **landa** = "terra" em holandês (como em Holanda, Finlândia)
- Significado: **"Terra de Castro"** ou **"A Holanda em Castro"**

É uma homenagem à cidade que os acolheu + referência à origem holandesa.

### 1.2 Números da Castrolanda (2024)

| Métrica | Valor |
|---------|-------|
| Fundação | 1951 (73 anos) |
| Cooperados | ~1.100 famílias |
| Colaboradores | ~3.400 |
| Faturamento anual | R$ 3,5 bilhões |
| Lucro líquido (2024) | R$ 273 milhões (recorde histórico) |
| Ranking Paraná | 15ª maior empresa |
| Ranking Brasil (coops) | Top 10 |

### 1.3 Áreas de Atuação

A Castrolanda não é "só NF" - é um conglomerado agroindustrial completo:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CASTROLANDA - UNIDADES DE NEGÓCIO                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  OPERAÇÕES                          INDÚSTRIA                           │
│  ├── Agrícola (grãos)               ├── Laticínios                      │
│  │   ├── Soja                       │   ├── Naturalle                   │
│  │   ├── Milho                      │   ├── Colônia Holandesa           │
│  │   ├── Trigo                      │   └── Colaso                      │
│  │   └── Feijão                     │                                   │
│  │                                  ├── Carnes (Alegra)                 │
│  ├── Leite                          │   └── Suínos                      │
│  │   └── Castro é o MAIOR           │                                   │
│  │       produtor de leite          └── Batata                          │
│  │       do Brasil!                     └── Processamento               │
│  │                                                                       │
│  ├── Pecuária de Corte                                                  │
│  │                                                                       │
│  └── Batata                                                             │
│                                                                          │
│  SERVIÇOS AOS COOPERADOS                                                │
│  ├── Postos de Coleta (entrega de grãos)                                │
│  ├── Armazenagem (silos)                                                │
│  ├── Assistência Técnica                                                │
│  ├── Insumos (sementes, fertilizantes, defensivos)                      │
│  ├── Financiamento agrícola                                             │
│  └── Software de Gestão (AGRIWIN)  ← É AQUI QUE ENTRA!                 │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.4 Intercooperação - UNIUM

A Castrolanda faz parte de um grupo de 3 cooperativas holandesas que trabalham juntas:

| Cooperativa | Cidade | Especialidade |
|-------------|--------|---------------|
| **Castrolanda** | Castro | Líder em carnes e leite |
| **Frísia** (ex-Batavo) | Carambeí | Líder em trigo/farinhas |
| **Capal** | Arapoti | Parceira em todos |

Juntas, formaram a **UNIUM** (união + um), uma holding que:
- Fatura R$ 1,8 bilhões/ano
- Representa 5.000 famílias
- Possui marcas como **Alegra** (carnes) e **Naturalle** (laticínios)

---

## PARTE 2: O QUE É O AGRIWIN?

### 2.1 Visão Geral

O **Agriwin** é um **ERP (sistema de gestão) agrícola** desenvolvido especificamente para produtores rurais brasileiros.

**Origem:** Surgiu da demanda de uma cooperativa (provavelmente a própria Castrolanda) em ter um software prático e integrado com seu ERP interno.

**Modelo de negócio:** SaaS (Software as a Service) - mensalidade

### 2.2 Por que castrolanda.agriwin.com.br?

O Agriwin usa um modelo **white-label multi-tenant**:

```
                    ┌─────────────────────────────────────────┐
                    │           AGRIWIN (Plataforma)          │
                    │                                          │
                    │  Domínio principal: agriwin.com.br      │
                    │  Sistema: sistema.agriwin.com.br        │
                    │                                          │
                    └────────────────┬────────────────────────┘
                                     │
           ┌─────────────────────────┼─────────────────────────┐
           │                         │                         │
           ▼                         ▼                         ▼
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│   CASTROLANDA    │    │    FRÍSIA        │    │   SICREDI        │
│                  │    │                  │    │                  │
│ castrolanda.     │    │ frisia.          │    │ sicredi.         │
│ agriwin.com.br   │    │ agriwin.com.br   │    │ agriwin.com.br   │
│                  │    │                  │    │                  │
│ ~1.100 produtores│    │ ~800 produtores  │    │ Piloto com 15    │
│                  │    │                  │    │ famílias         │
└──────────────────┘    └──────────────────┘    └──────────────────┘
```

**Cada cooperativa tem:**
- Subdomínio próprio
- Dados isolados (multi-tenancy)
- Customização visual (logo, cores)
- Integração com ERP da cooperativa

### 2.3 Funcionalidades do Agriwin

| Módulo | Funcionalidade | Descrição |
|--------|----------------|-----------|
| **Financeiro** | Lançamentos | Entradas/saídas, contas a pagar/receber |
| | Conciliação bancária | Importação de extratos |
| | Empréstimos | Custeio de safra, financiamentos |
| **Fiscal** | NFe | Emissão de notas fiscais |
| | NFe Resumida | Notas que terceiros emitiram pro produtor |
| | LCDPR | Livro Caixa Digital do Produtor Rural |
| | MDFe | Manifesto de transporte |
| **Agrícola** | Propriedades | Cadastro de fazendas |
| | Talhões | Divisões da propriedade |
| | Plantios | Registro por safra |
| | Safras | Controle temporal (2024/2025) |
| **Estoque** | Insumos | Sementes, fertilizantes, defensivos |
| | Produção | Grãos colhidos |
| | Etiquetas | Lotes na cooperativa |
| **Patrimônio** | Imobilizados | Máquinas, veículos, benfeitorias |
| | Manutenções | Agenda de manutenção preventiva |
| | Seguros | Controle de apólices |
| **Pecuária** | Rebanho | Controle de animais |
| | Dieta | Alimentação por lote |
| | Custos | Custo por cabeça |

---

## PARTE 3: COMO FUNCIONA A INTEGRAÇÃO CASTROLANDA ↔ AGRIWIN

### 3.1 Modelo B2B2C

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MODELO DE NEGÓCIO                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   B2B (Business to Business)           B2C (Business to Consumer)       │
│                                                                          │
│   ┌─────────────┐                      ┌─────────────┐                  │
│   │   AGRIWIN   │ ───vende para───▶   │ CASTROLANDA │                  │
│   │  (empresa)  │                      │(cooperativa)│                  │
│   └─────────────┘                      └──────┬──────┘                  │
│                                               │                          │
│                                               │ oferece como             │
│                                               │ benefício/serviço        │
│                                               │                          │
│                                               ▼                          │
│                                        ┌─────────────┐                  │
│                                        │  PRODUTOR   │                  │
│                                        │   RURAL     │                  │
│                                        │ (cooperado) │                  │
│                                        └─────────────┘                  │
│                                                                          │
│   Quem paga: COOPERATIVA (ou repassa parte ao produtor)                 │
│   Quem usa: PRODUTOR RURAL                                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Fluxo de Dados

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUXO DE DADOS COOPERATIVA → AGRIWIN                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                  CASTROLANDA (ERP Central)                        │   │
│  │                                                                    │   │
│  │  Dados que a cooperativa FORNECE para o Agriwin:                 │   │
│  │                                                                    │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │   │
│  │  │ Cadastro do     │  │ Postos de       │  │ Tabelas de      │   │   │
│  │  │ Cooperado       │  │ Coleta          │  │ Desconto        │   │   │
│  │  │                 │  │                 │  │                 │   │   │
│  │  │ - CPF/CNPJ      │  │ - Localização   │  │ - Umidade       │   │   │
│  │  │ - Nome          │  │ - Horários      │  │ - Impurezas     │   │   │
│  │  │ - Propriedades  │  │ - Produtos      │  │ - Por produto   │   │   │
│  │  │ - Inscrição Est.│  │   aceitos       │  │                 │   │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘   │   │
│  │                                                                    │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │   │
│  │  │ Cotações /      │  │ Etiquetas de    │  │ Orçamentos      │   │   │
│  │  │ Preços          │  │ Estoque         │  │ Agrícolas       │   │   │
│  │  │                 │  │                 │  │                 │   │   │
│  │  │ - Soja R$/saca  │  │ - Lotes no silo │  │ - Recomendação  │   │   │
│  │  │ - Milho R$/saca │  │ - Qualidade     │  │   técnica       │   │   │
│  │  │ - Trigo R$/saca │  │ - Peso líquido  │  │ - Insumos       │   │   │
│  │  │ - Leite R$/litro│  │                 │  │ - Dosagens      │   │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘   │   │
│  │                                                                    │   │
│  └───────────────────────────────┬──────────────────────────────────┘   │
│                                  │                                       │
│                                  │ API de Sincronização                 │
│                                  │ (provavelmente REST ou SOAP)         │
│                                  │                                       │
│                                  ▼                                       │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    AGRIWIN (ERP do Produtor)                      │   │
│  │                    castrolanda.agriwin.com.br                     │   │
│  │                                                                    │   │
│  │  Dados que o PRODUTOR gerencia no Agriwin:                       │   │
│  │                                                                    │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │   │
│  │  │ Finanças        │  │ Notas Fiscais   │  │ Produção        │   │   │
│  │  │ Pessoais        │  │ Próprias        │  │ Própria         │   │   │
│  │  │                 │  │                 │  │                 │   │   │
│  │  │ - Lançamentos   │  │ - NFe emitidas  │  │ - Colheitas     │   │   │
│  │  │ - Empréstimos   │  │ - NFe recebidas │  │ - Consumos      │   │   │
│  │  │ - Contas        │  │ - LCDPR         │  │ - Custos        │   │   │
│  │  │                 │  │ - MDFe          │  │                 │   │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘   │   │
│  │                                                                    │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐   │   │
│  │  │ Talhões e       │  │ Máquinas e      │  │ Rebanho         │   │   │
│  │  │ Plantios        │  │ Implementos     │  │ (se tiver)      │   │   │
│  │  │                 │  │                 │  │                 │   │   │
│  │  │ - Áreas         │  │ - Tratores      │  │ - Animais       │   │   │
│  │  │ - Culturas      │  │ - Colheitadeiras│  │ - Dieta         │   │   │
│  │  │ - Safras        │  │ - Manutenções   │  │ - Custos        │   │   │
│  │  │                 │  │ - Seguros       │  │                 │   │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘   │   │
│  │                                                                    │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Endpoints Identificados (Cooperativa → Agriwin)

| Endpoint | Método | Dados |
|----------|--------|-------|
| `/postoDeColeta/listPostoDeColeta` | GET | Postos para entrega de grãos |
| `/descontoTabela/listDescontoTabelas` | GET | Tabelas de desconto (umidade/impureza) |
| `/pessoaProdutor/listPessoaProdutors` | GET | Cadastro de cooperados |
| `/estoque/obterListaDeEtiquetasProdutor` | POST | Lotes armazenados na cooperativa |
| `/consumo/carregarTabelaConsumoProposto` | POST | Recomendação técnica de insumos |
| `/orcamentoAgricola/listOrcamentoAgricola` | GET | Orçamentos agrícolas |

### 3.4 Autenticação

O login é feito por **CPF** (ou email), vinculado ao cadastro na cooperativa:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUXO DE AUTENTICAÇÃO                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   1. Produtor acessa: castrolanda.agriwin.com.br                        │
│                                                                          │
│   2. Sistema identifica o tenant pelo subdomínio                        │
│      → tenant = "castrolanda"                                            │
│                                                                          │
│   3. Produtor digita CPF: 710.392.879-72                                │
│                                                                          │
│   4. Sistema verifica se CPF está cadastrado na Castrolanda             │
│      → SELECT * FROM cooperados WHERE cpf = '71039287972'               │
│        AND cooperativa = 'castrolanda'                                   │
│                                                                          │
│   5. Se sim, verifica senha                                             │
│                                                                          │
│   6. Gera sessão com cookies:                                           │
│      - JSESSIONID (sessão)                                               │
│      - autenticacaoUsuario (dados do usuário)                           │
│      - customizacaoUsuario (preferências)                                │
│                                                                          │
│   7. Carrega dados sincronizados da cooperativa                         │
│      - Propriedades do produtor                                          │
│      - Safra atual selecionada                                           │
│      - Permissões                                                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## PARTE 4: NÃO É SÓ NF!

A integração com a Castrolanda **vai muito além de NF**:

### 4.1 O que vem da Cooperativa (dados pré-populados)

| Dado | Como ajuda o produtor |
|------|----------------------|
| **Cadastro do cooperado** | Não precisa digitar nome, CPF, propriedades |
| **Postos de coleta** | Sabe onde entregar a produção |
| **Tabelas de desconto** | Sabe quanto vai perder por umidade/impureza |
| **Cotações** | Sabe o preço atual da soja, milho, etc. |
| **Etiquetas de estoque** | Vê quanto tem armazenado no silo da cooperativa |
| **Orçamentos técnicos** | Recebe recomendação do agrônomo da cooperativa |
| **Previsão do tempo** | Planejamento de plantio/colheita |

### 4.2 O que o Produtor gerencia (dados próprios)

| Dado | O que faz |
|------|-----------|
| **Lançamentos financeiros** | Controla entradas e saídas |
| **NFe próprias** | Emite notas quando vende |
| **NFe recebidas** | Importa notas de compras |
| **LCDPR** | Gera livro caixa para Receita Federal |
| **Plantios** | Registra o que plantou em cada talhão |
| **Consumos** | Registra uso de insumos |
| **Máquinas** | Controla manutenções e seguros |

### 4.3 Exemplo Prático: Ciclo de uma Safra

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  EXEMPLO: SAFRA DE SOJA 2024/2025                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  SETEMBRO/2024 - PLANEJAMENTO                                           │
│  ┌────────────────────────────────────────────────────────────────┐     │
│  │ 1. Produtor acessa Agriwin                                      │     │
│  │ 2. Cria safra "2024/2025" e plantio em "Talhão A" (50 ha)      │     │
│  │ 3. Sistema mostra orçamento da cooperativa:                     │     │
│  │    - Semente: TMG 7063 IPRO - 50 sacas                         │     │
│  │    - Fertilizante: MAP - 2.500 kg                               │     │
│  │    - Defensivo: Roundup - 100 litros                            │     │
│  │ 4. Produtor aceita orçamento → Gera pedido na cooperativa      │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                          │
│  OUTUBRO/2024 - PLANTIO                                                  │
│  ┌────────────────────────────────────────────────────────────────┐     │
│  │ 1. Cooperativa entrega insumos                                  │     │
│  │ 2. NF de compra aparece automaticamente no Agriwin             │     │
│  │    (sincronizada da SEFAZ via NFe Resumida)                    │     │
│  │ 3. Produtor registra consumo: "Aplicação de fertilizante"      │     │
│  │ 4. Sistema baixa estoque e calcula custo/hectare               │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                          │
│  FEVEREIRO/2025 - COLHEITA                                              │
│  ┌────────────────────────────────────────────────────────────────┐     │
│  │ 1. Produtor colhe e entrega no Posto de Coleta                 │     │
│  │ 2. Cooperativa classifica: Umidade 14%, Impurezas 1%           │     │
│  │ 3. Sistema aplica tabela de desconto:                          │     │
│  │    - Peso bruto: 3.000 sacas                                    │     │
│  │    - Desconto umidade: -2%                                      │     │
│  │    - Desconto impureza: -0.5%                                   │     │
│  │    - Peso líquido: 2.925 sacas                                  │     │
│  │ 4. Etiqueta aparece no Agriwin (estoque na cooperativa)        │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                          │
│  MARÇO/2025 - VENDA                                                      │
│  ┌────────────────────────────────────────────────────────────────┐     │
│  │ 1. Produtor vende 2.925 sacas a R$ 130/saca                    │     │
│  │ 2. Emite NFe pelo Agriwin (integração SEFAZ)                   │     │
│  │ 3. Registra entrada financeira: R$ 380.250,00                  │     │
│  │ 4. Sistema calcula resultado da safra:                          │     │
│  │    - Receita: R$ 380.250                                        │     │
│  │    - Custos: R$ 185.000                                         │     │
│  │    - Lucro: R$ 195.250 (R$ 3.905/ha)                           │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                          │
│  ABRIL/2025 - FISCAL                                                     │
│  ┌────────────────────────────────────────────────────────────────┐     │
│  │ 1. Sistema gera LCDPR automaticamente                          │     │
│  │ 2. Produtor exporta arquivo TXT                                 │     │
│  │ 3. Transmite para Receita Federal via e-CAC                    │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## PARTE 5: ARQUITETURA TÉCNICA

### 5.1 Stack Tecnológica (Observado)

| Camada | Tecnologia |
|--------|------------|
| **Frontend** | JSP + jQuery + DataTables + Bootstrap |
| **Backend** | Java (Spring Framework) |
| **Banco de dados** | PostgreSQL ou MySQL |
| **Servidor** | Tomcat / JBoss |
| **Infraestrutura** | AWS ou on-premise |
| **Analytics** | Google Analytics + Amplitude |

### 5.2 Arquitetura Multi-Tenant

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         ARQUITETURA AGRIWIN                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                              INTERNET                                    │
│                                  │                                       │
│                    ┌─────────────┴─────────────┐                        │
│                    │       LOAD BALANCER       │                        │
│                    │    (AWS ALB ou Nginx)     │                        │
│                    └─────────────┬─────────────┘                        │
│                                  │                                       │
│            ┌─────────────────────┼─────────────────────┐                │
│            │                     │                     │                │
│            ▼                     ▼                     ▼                │
│   ┌────────────────┐   ┌────────────────┐   ┌────────────────┐         │
│   │  castrolanda.  │   │   frisia.      │   │   sicredi.     │         │
│   │  agriwin.com.br│   │  agriwin.com.br│   │  agriwin.com.br│         │
│   └────────┬───────┘   └────────┬───────┘   └────────┬───────┘         │
│            │                     │                     │                │
│            └─────────────────────┼─────────────────────┘                │
│                                  │                                       │
│                                  ▼                                       │
│                    ┌─────────────────────────┐                          │
│                    │    AGRIWIN BACKEND      │                          │
│                    │    (Java/Spring)        │                          │
│                    │                         │                          │
│                    │  Identificação tenant   │                          │
│                    │  pelo Host header       │                          │
│                    └─────────────┬───────────┘                          │
│                                  │                                       │
│          ┌───────────────────────┼───────────────────────┐              │
│          │                       │                       │              │
│          ▼                       ▼                       ▼              │
│   ┌─────────────┐         ┌─────────────┐         ┌─────────────┐      │
│   │ Schema:     │         │ Schema:     │         │ Schema:     │      │
│   │ castrolanda │         │ frisia      │         │ sicredi     │      │
│   │             │         │             │         │             │      │
│   │ - users     │         │ - users     │         │ - users     │      │
│   │ - forms     │         │ - forms     │         │ - forms     │      │
│   │ - nfe       │         │ - nfe       │         │ - nfe       │      │
│   │ - lanctos   │         │ - lanctos   │         │ - lanctos   │      │
│   └─────────────┘         └─────────────┘         └─────────────┘      │
│                                                                          │
│                           DATABASE SERVER                                │
│                         (PostgreSQL/MySQL)                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.3 Integrações Externas

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      INTEGRAÇÕES DO AGRIWIN                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                         ┌─────────────────┐                             │
│                         │    AGRIWIN      │                             │
│                         │    BACKEND      │                             │
│                         └────────┬────────┘                             │
│                                  │                                       │
│    ┌─────────────────────────────┼─────────────────────────────┐        │
│    │                             │                             │        │
│    ▼                             ▼                             ▼        │
│ ┌─────────┐               ┌─────────────┐              ┌─────────────┐  │
│ │  SEFAZ  │               │ COOPERATIVA │              │  CPTEC/     │  │
│ │         │               │   (ERP)     │              │  INMET      │  │
│ │ NFe     │               │             │              │             │  │
│ │ MDFe    │               │ Cadastros   │              │ Previsão    │  │
│ │ NFe Res.│               │ Etiquetas   │              │ do tempo    │  │
│ │         │               │ Cotações    │              │             │  │
│ │ SOAP    │               │ REST/SOAP   │              │ REST/XML    │  │
│ └─────────┘               └─────────────┘              └─────────────┘  │
│                                                                          │
│    ┌─────────────────────────────┼─────────────────────────────┐        │
│    │                             │                             │        │
│    ▼                             ▼                             ▼        │
│ ┌─────────┐               ┌─────────────┐              ┌─────────────┐  │
│ │ GOOGLE  │               │  AMPLITUDE  │              │  YOUTUBE    │  │
│ │ ANALYT. │               │             │              │             │  │
│ │         │               │ Session     │              │ Vídeos de   │  │
│ │ Tracking│               │ Replay      │              │ tutorial    │  │
│ │ eventos │               │ Analytics   │              │             │  │
│ │         │               │             │              │             │  │
│ │ JS SDK  │               │ JS SDK      │              │ iframe      │  │
│ └─────────┘               └─────────────┘              └─────────────┘  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## PARTE 6: COMPARATIVO AGRIWIN vs DPWAI

### 6.1 Funcionalidades

| Funcionalidade | Agriwin | DPWAI | Gap |
|----------------|---------|-------|-----|
| Multi-tenant (subdomínios) | ✅ | ✅ | - |
| Autenticação | CPF/Email + Senha | Email + Senha | Adicionar CPF |
| NFe (emissão) | ✅ | ❌ | **Implementar** |
| NFe Resumida (recebimento) | ✅ | ❌ | **Implementar** |
| LCDPR | ✅ | ❌ | **Implementar** |
| MDFe | ✅ | ❌ | Prioridade 2 |
| Propriedades/Talhões | ✅ | ❌ | **Implementar** |
| Safras | ✅ | ❌ | **Implementar** |
| Plantios | ✅ | ❌ | **Implementar** |
| Lançamentos financeiros | ✅ | Parcial | Expandir |
| Imobilizados | ✅ | ❌ | Prioridade 2 |
| Estoque | ✅ | ❌ | **Implementar** |
| Dashboard com cards | ✅ | Parcial | Expandir |
| Previsão do tempo | ✅ | ❌ | Fácil de adicionar |
| Form Builder | ❌ | ✅ | Vantagem DPWAI |
| AI Assistant | ❌ | ✅ | Vantagem DPWAI |
| Webhooks | ❌ | ✅ | Vantagem DPWAI |
| API REST moderna | Parcial | ✅ | Vantagem DPWAI |

### 6.2 Roadmap Sugerido para DPWAI

**Fase 1 - Estrutura Base (2-4 semanas)**
- [ ] Modelo de dados para Propriedade, Talhão, Safra, Plantio
- [ ] CRUD completo com UI
- [ ] Seletor global de safra

**Fase 2 - Fiscal Básico (4-6 semanas)**
- [ ] Integração SEFAZ para NFe
- [ ] NFe Resumida (consulta automática)
- [ ] Módulo LCDPR com geração de arquivo

**Fase 3 - Estoque e Financeiro (2-4 semanas)**
- [ ] Controle de estoque (insumos e produção)
- [ ] Lançamentos financeiros expandidos
- [ ] Contas a pagar/receber

**Fase 4 - Dashboard e UX (2-3 semanas)**
- [ ] Cards informativos (clima, contas, safra)
- [ ] Gráficos financeiros
- [ ] Alertas de vencimentos

---

## FONTES E REFERÊNCIAS

- [Castrolanda - Site Oficial](https://www.castrolanda.coop.br/)
- [Castrolanda - Wikipedia](https://pt.wikipedia.org/wiki/Castrolanda_Cooperativa_Agroindustrial)
- [Agriwin - Site Oficial](https://www.agriwin.com.br/)
- [UNIUM - Intercooperação](https://paranacooperativo.coop.br/ppc/index.php/sistema-ocepar/comunicacao/2011-12-07-11-06-29/ultimas-noticias/121753-unium-ii-por-dentro-da-marca-institucional-das-cooperativas-castrolanda-capal-e-frisia)
- [Gazeta do Povo - UNIUM](https://www.gazetadopovo.com.br/agronegocio/por-dentro-da-unium-a-cooperativa-das-cooperativas-castrolanda-capal-e-frisia-96n8ja2ked33jp7lsjreuk326/)
- [SEFAZ - Portal NFe](https://www.nfe.fazenda.gov.br/)
- [CPTEC/INPE - Previsão](http://servicos.cptec.inpe.br/)

---

*Documentação criada via análise READ-ONLY. Nenhum dado foi modificado.*
