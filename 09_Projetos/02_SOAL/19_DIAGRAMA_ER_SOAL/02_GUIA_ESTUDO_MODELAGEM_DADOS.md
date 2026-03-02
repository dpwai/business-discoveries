# Guia de Estudo: Modelagem de Dados e Diagrama ER

**Objetivo:** Capacitar Rodrigo Kugler a criar Diagramas de Entidade-Relacionamento (ER) com maestria, entendendo os conceitos fundamentais de modelagem de dados para bancos relacionais.

**Autor:** DeepWork AI Flows
**Data:** 03/02/2026
**Nível:** Do zero ao intermediário

---

## 1. POR QUE ISSO É IMPORTANTE?

### O Problema que Resolve

Imagine que você quer construir uma casa. Você não começa colocando tijolos - você precisa de uma planta. O Diagrama ER é a "planta" do banco de dados.

**Sem Diagrama ER:**
- Desenvolvedores criam tabelas "no feeling"
- Dados ficam duplicados ou inconsistentes
- Integrações falham por falta de padronização
- Relatórios mostram números errados
- Retrabalho constante

**Com Diagrama ER:**
- Estrutura clara e documentada
- Todos falam a mesma língua
- APIs são geradas automaticamente
- Dashboards funcionam de primeira
- Escala sem dor de cabeça

### Citação do João (03/02/2026)

> "A plataforma e o front depende muito disso. Esse daqui que a gente precisa, com isso daqui é o ouro da nossa plataforma."

> "O dia que você aprender pra valer isso aqui, p***, até qualquer empresa, Exon, essas daí que você vai chegar, p***, os caras ficam de cara com isso aqui, porque é uma parada que todo mundo tem preguiça de fazer."

---

## 2. CONCEITOS FUNDAMENTAIS

### 2.1 O que é uma Entidade?

**Entidade** = Qualquer "coisa" sobre a qual você quer guardar informações.

No mundo real, entidades são:
- Pessoas (usuários, clientes, funcionários)
- Objetos (máquinas, produtos, silos)
- Eventos (vendas, abastecimentos, manutenções)
- Conceitos (safras, culturas, permissões)

**Regra de ouro:** Se você consegue fazer uma lista de "coisas" desse tipo, provavelmente é uma entidade.

**Exemplos no SOAL:**
| Entidade | O que representa |
|----------|------------------|
| USUARIOS | Pessoas que acessam a plataforma |
| MAQUINAS | Tratores, colheitadeiras, etc. |
| ABASTECIMENTOS | Cada vez que uma máquina é abastecida |
| SAFRAS | Ciclos de produção (2025/26, 2026/27) |

---

### 2.2 O que é um Atributo?

**Atributo** = Uma característica/propriedade de uma entidade.

Se a entidade fosse uma planilha Excel, os atributos seriam as colunas.

**Exemplo - Entidade MAQUINAS:**

| Atributo | O que guarda | Exemplo |
|----------|--------------|---------|
| id | Identificador único | "abc-123-xyz" |
| marca | Fabricante | "John Deere" |
| modelo | Modelo específico | "8R 410" |
| ano | Ano de fabricação | 2023 |
| potencia_cv | Potência em cavalos | 410 |

---

### 2.3 O que é um Relacionamento?

**Relacionamento** = Como duas entidades se conectam.

Perguntas para identificar relacionamentos:
- "Um X pode ter quantos Y?"
- "Um Y pertence a quantos X?"

**Tipos de relacionamento:**

#### 1:1 (Um para Um)
Um X tem exatamente um Y, e vice-versa.

```
USUARIO (1) ────────── (1) PERFIL

"Um usuário tem um perfil, e um perfil pertence a um usuário."
```

**Exemplos reais:**
- Pessoa → CPF
- Carro → Placa
- País → Capital

---

#### 1:N (Um para Muitos)
Um X pode ter vários Y, mas cada Y pertence a apenas um X.

```
FAZENDA (1) ────────── (N) TALHOES

"Uma fazenda tem vários talhões, mas cada talhão pertence a uma fazenda."
```

**Exemplos reais:**
- Mãe → Filhos
- Empresa → Funcionários
- Silo → Entradas de grãos

**Este é o tipo mais comum!**

---

#### N:N (Muitos para Muitos)
Um X pode ter vários Y, e um Y pode pertencer a vários X.

```
USUARIOS (N) ────────── (N) ROLES

"Um usuário pode ter várias permissões, e uma permissão pode ser de vários usuários."
```

**Exemplos reais:**
- Alunos ↔ Disciplinas
- Atores ↔ Filmes
- Produtos ↔ Pedidos

**Importante:** Relacionamentos N:N geralmente precisam de uma **tabela intermediária**.

```
USUARIOS ──── USUARIO_ROLES ──── ROLES
```

---

### 2.4 O que é uma Chave?

#### Chave Primária (PK - Primary Key)
O campo que identifica **unicamente** cada registro.

Regras:
- Nunca se repete
- Nunca é nulo
- Nunca muda

**Boas práticas:**
- Use UUID (identificador universal único)
- Evite usar dados de negócio como PK (CPF muda, placa muda)

```
USUARIOS
─────────
id (PK)      ← Este é a chave primária
nome
email
```

---

#### Chave Estrangeira (FK - Foreign Key)
O campo que **referencia** a chave primária de outra tabela.

É o que cria o relacionamento entre entidades.

```
TALHOES
─────────
id (PK)
fazenda_id (FK) ← Aponta para FAZENDAS.id
nome
area_hectares
```

**Leia assim:** "O talhão X pertence à fazenda Y"

---

### 2.5 Entidades Fortes vs. Fracas

#### Entidade Forte
- Existe independentemente de outras
- Tem significado próprio no negócio
- Geralmente contém dados sensíveis ou valiosos

**Exemplos:**
- USUARIOS (tem CPF, senha - dados sensíveis)
- MAQUINAS (são ativos de R$ milhões)
- NOTAS_FISCAIS (documentos fiscais)

---

#### Entidade Fraca
- Depende de outra entidade para existir
- Geralmente são "muitos" em relacionamentos 1:N
- Alto volume de registros

**Exemplos:**
- ABASTECIMENTOS (só existe se tiver máquina)
- LOGS (só existem se tiver sistema)
- ALERTAS (derivam de outras entidades)

---

### 2.6 Insight de Negócio (João)

> "Quanto mais forte entidade de negócio, mais dinheiro provavelmente ele ganha com aquela entidade. Se você tem que a entidade do secador é muito forte com a entidade do caminhão, cara, provavelmente tem muito dinheiro envolvido."

**Tradução prática:**
- Entidades com muitas relações fortes = core do negócio
- Onde há mais conexões = onde há mais valor
- Mapeie isso para entender o cliente

---

## 3. NOTAÇÃO DO DIAGRAMA ER

### 3.1 Símbolos Básicos

```
┌─────────────┐
│  ENTIDADE   │  ← Retângulo representa uma entidade (tabela)
│─────────────│
│ atributo1   │  ← Lista de atributos (colunas)
│ atributo2   │
│ atributo3   │
└─────────────┘
```

### 3.2 Notação de Cardinalidade (Crow's Foot)

```
───────────  Linha simples = relacionamento

────┤       "Um" (exatamente um)

────<       "Muitos" (zero ou mais)

────○       "Zero" (opcional)

────│       "Um" (obrigatório)
```

### 3.3 Exemplos Visuais

#### Um para Um (1:1)
```
┌──────────┐         ┌──────────┐
│ USUARIO  │────┼────│  PERFIL  │
└──────────┘         └──────────┘

"Um usuário tem exatamente um perfil"
```

#### Um para Muitos (1:N)
```
┌──────────┐         ┌──────────┐
│ FAZENDA  │────┼──<─│  TALHAO  │
└──────────┘         └──────────┘

"Uma fazenda tem muitos talhões"
"Um talhão pertence a uma fazenda"
```

#### Muitos para Muitos (N:N)
```
┌──────────┐         ┌──────────────┐         ┌──────────┐
│ USUARIO  │──<──────│ USUARIO_ROLE │──────>──│   ROLE   │
└──────────┘         └──────────────┘         └──────────┘

"Usuários têm muitas roles"
"Roles pertencem a muitos usuários"
"Tabela intermediária conecta os dois"
```

---

## 4. PROCESSO DE MODELAGEM

### 4.1 Passo a Passo

```
┌─────────────────────────────────────────────────────────────────┐
│                    PROCESSO DE MODELAGEM                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. IDENTIFICAR ENTIDADES                                       │
│     "Sobre o que precisamos guardar informação?"                │
│                           │                                      │
│                           ▼                                      │
│  2. DEFINIR ATRIBUTOS                                           │
│     "Quais características de cada entidade?"                   │
│                           │                                      │
│                           ▼                                      │
│  3. IDENTIFICAR RELACIONAMENTOS                                 │
│     "Como as entidades se conectam?"                            │
│                           │                                      │
│                           ▼                                      │
│  4. DEFINIR CARDINALIDADES                                      │
│     "Um para um? Um para muitos? Muitos para muitos?"           │
│                           │                                      │
│                           ▼                                      │
│  5. IDENTIFICAR CHAVES                                          │
│     "Qual campo identifica unicamente cada registro?"           │
│                           │                                      │
│                           ▼                                      │
│  6. VALIDAR E REFINAR                                           │
│     "Faz sentido? Cobre todos os casos?"                        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Perguntas para Cada Entidade

1. **Identificação:**
   - Qual o nome da entidade? (substantivo, singular)
   - O que ela representa no mundo real?
   - Quem/o quê é responsável por ela?

2. **Atributos:**
   - Quais informações preciso guardar?
   - Qual o tipo de cada dado? (texto, número, data)
   - Quais são obrigatórios?
   - Algum atributo pode se repetir?

3. **Relacionamentos:**
   - Essa entidade se conecta com quais outras?
   - Um X pode ter quantos Y?
   - Um Y pertence a quantos X?
   - A conexão é obrigatória ou opcional?

4. **Classificação:**
   - É uma entidade forte ou fraca?
   - Contém dados sensíveis?
   - Qual o volume esperado de registros?

---

## 5. EXEMPLO PRÁTICO COMPLETO

### Cenário: Sistema de Biblioteca

Vamos modelar um sistema simples de biblioteca.

#### Passo 1: Identificar Entidades

Pergunte: "Sobre o que preciso guardar informação?"

- LIVROS (os livros da biblioteca)
- USUARIOS (quem pode pegar emprestado)
- EMPRESTIMOS (cada vez que alguém pega um livro)
- CATEGORIAS (ficção, técnico, etc.)

#### Passo 2: Definir Atributos

**LIVROS:**
- id (PK)
- titulo
- autor
- isbn
- ano_publicacao
- categoria_id (FK)
- disponivel

**USUARIOS:**
- id (PK)
- nome
- email
- cpf
- telefone
- data_cadastro

**EMPRESTIMOS:**
- id (PK)
- livro_id (FK)
- usuario_id (FK)
- data_emprestimo
- data_devolucao_prevista
- data_devolucao_real
- status (em_aberto, devolvido, atrasado)

**CATEGORIAS:**
- id (PK)
- nome
- descricao

#### Passo 3: Identificar Relacionamentos

- CATEGORIAS → LIVROS: Uma categoria tem muitos livros (1:N)
- LIVROS → EMPRESTIMOS: Um livro pode ter muitos empréstimos (1:N)
- USUARIOS → EMPRESTIMOS: Um usuário pode ter muitos empréstimos (1:N)

#### Passo 4: Desenhar o Diagrama

```
┌────────────────┐
│   CATEGORIAS   │
│────────────────│
│ id (PK)        │
│ nome           │
│ descricao      │
└───────┬────────┘
        │ 1:N
        ▼
┌────────────────┐        ┌────────────────┐
│    LIVROS      │        │   USUARIOS     │
│────────────────│        │────────────────│
│ id (PK)        │        │ id (PK)        │
│ titulo         │        │ nome           │
│ autor          │        │ email          │
│ isbn           │        │ cpf            │
│ ano_publicacao │        │ telefone       │
│ categoria_id(FK)│       │ data_cadastro  │
│ disponivel     │        └───────┬────────┘
└───────┬────────┘                │
        │ 1:N                     │ 1:N
        │      ┌──────────────────┘
        ▼      ▼
┌────────────────────────┐
│     EMPRESTIMOS        │
│────────────────────────│
│ id (PK)                │
│ livro_id (FK)          │
│ usuario_id (FK)        │
│ data_emprestimo        │
│ data_devolucao_prevista│
│ data_devolucao_real    │
│ status                 │
└────────────────────────┘
```

#### Passo 5: Classificar Entidades

| Entidade | Classificação | Justificativa |
|----------|---------------|---------------|
| USUARIOS | **Forte** | Dados pessoais (CPF, email) |
| LIVROS | **Forte** | Ativos da biblioteca |
| EMPRESTIMOS | Fraca | Depende de livro e usuário |
| CATEGORIAS | Fraca | Dados de configuração |

---

## 6. FERRAMENTAS PARA CRIAR DIAGRAMAS

### 6.1 Ferramentas Gratuitas

#### Miro (Recomendado)
- **URL:** miro.com
- **Vantagens:** Colaborativo, fácil de usar, templates prontos
- **Como usar:** Criar quadro → Usar shapes para entidades → Conectar com linhas

#### Draw.io (diagrams.net)
- **URL:** diagrams.net
- **Vantagens:** Gratuito, exporta em vários formatos
- **Como usar:** Usar shapes de "Entity Relation" na barra lateral

#### Lucidchart
- **URL:** lucidchart.com
- **Vantagens:** Bonito, profissional
- **Limitação:** Versão gratuita limitada

#### dbdiagram.io (Técnico)
- **URL:** dbdiagram.io
- **Vantagens:** Gera código SQL automaticamente
- **Como usar:** Escreve em linguagem própria, ele desenha

Exemplo de código dbdiagram:
```
Table usuarios {
  id uuid [pk]
  nome varchar
  email varchar
}

Table maquinas {
  id uuid [pk]
  marca varchar
  modelo varchar
}

Table abastecimentos {
  id uuid [pk]
  maquina_id uuid [ref: > maquinas.id]
  litros decimal
  data datetime
}
```

### 6.2 Método Manual (Papel/Quadro)

Para a visita de campo, papel e caneta funcionam muito bem:

1. Um post-it por entidade
2. Escreva os atributos dentro
3. Desenhe linhas conectando
4. Anote a cardinalidade nas linhas

---

## 7. ARMADILHAS COMUNS (E COMO EVITAR)

### 7.1 Duplicação de Dados

**Errado:**
```
ABASTECIMENTOS
- maquina_marca     ← Duplicando dado da máquina!
- maquina_modelo    ← Duplicando dado da máquina!
- litros
```

**Certo:**
```
ABASTECIMENTOS
- maquina_id (FK)   ← Referencia a tabela MAQUINAS
- litros
```

**Regra:** Se o dado pertence a outra entidade, use FK, não copie.

---

### 7.2 Atributos Multivalorados

**Errado:**
```
MAQUINAS
- telefones_manutencao: "11-9999, 11-8888, 11-7777"
```

**Certo:**
Criar uma entidade separada:
```
TELEFONES_MANUTENCAO
- id
- maquina_id (FK)
- telefone
- tipo (emergencia, geral, etc.)
```

---

### 7.3 Entidades Muito Grandes

**Errado:**
```
TUDO
- usuario_nome
- usuario_email
- maquina_marca
- abastecimento_litros
- ...100 campos...
```

**Certo:**
Separar em entidades coesas, cada uma com sua responsabilidade.

---

### 7.4 Relacionamentos N:N sem Tabela Intermediária

**Errado:**
```
USUARIOS
- roles: [1, 2, 3]    ← Array dentro do campo
```

**Certo:**
```
USUARIO_ROLES
- usuario_id (FK)
- role_id (FK)
```

---

### 7.5 Usar Dados de Negócio como PK

**Errado:**
```
MAQUINAS
- placa (PK)    ← Placas mudam!
```

**Certo:**
```
MAQUINAS
- id (PK)       ← UUID gerado pelo sistema
- placa         ← Campo normal
```

---

## 8. EXERCÍCIOS PRÁTICOS

### Exercício 1: Identificar Entidades

Leia o cenário e liste as entidades:

> "Na fazenda, temos várias máquinas que precisam ser abastecidas. Cada abastecimento é feito por um operador e registrado com a quantidade de litros e o horímetro. As máquinas pertencem a fazendas diferentes e são usadas em talhões específicos."

**Resposta esperada:**
- MAQUINAS
- ABASTECIMENTOS
- OPERADORES (ou USUARIOS)
- FAZENDAS
- TALHOES

---

### Exercício 2: Definir Relacionamentos

Para cada par, defina a cardinalidade:

1. FAZENDA ↔ MAQUINA
2. MAQUINA ↔ ABASTECIMENTO
3. OPERADOR ↔ ABASTECIMENTO
4. TALHAO ↔ FAZENDA

**Respostas:**
1. 1:N (uma fazenda tem muitas máquinas)
2. 1:N (uma máquina tem muitos abastecimentos)
3. 1:N (um operador faz muitos abastecimentos)
4. N:1 (muitos talhões pertencem a uma fazenda)

---

### Exercício 3: Desenhar Diagrama

Com base nos exercícios anteriores, desenhe o diagrama ER no papel.

---

### Exercício 4: Caso Real - Entrada de Grãos

Modele a entidade ENTRADAS_GRAOS com base neste cenário:

> "Quando um caminhão chega no secador, o Josmar anota: placa, nome do motorista, tipo de grão (soja, milho, feijão), de qual talhão veio, peso bruto na balança, umidade medida, impureza estimada, e para qual silo vai. Ele também marca se é para semente própria."

**Sua tarefa:**
1. Liste todos os atributos
2. Identifique quais são FK (referências a outras entidades)
3. Quais atributos são obrigatórios?
4. Qual seria calculado automaticamente?

---

## 9. CHECKLIST DE QUALIDADE

Antes de considerar seu diagrama pronto, valide:

### Entidades
- [ ] Cada entidade tem nome no singular
- [ ] Cada entidade tem propósito claro
- [ ] Não há entidades duplicadas
- [ ] Entidades fortes identificadas

### Atributos
- [ ] Cada entidade tem PK definida
- [ ] Tipos de dados definidos
- [ ] Obrigatoriedade definida
- [ ] Sem atributos duplicados entre entidades
- [ ] Sem atributos multivalorados

### Relacionamentos
- [ ] Todas as conexões têm cardinalidade definida
- [ ] FKs apontam para PKs existentes
- [ ] Relacionamentos N:N têm tabela intermediária
- [ ] Não há relacionamentos circulares desnecessários

### Negócio
- [ ] Cobre todos os casos de uso conhecidos
- [ ] Stakeholders validaram as entidades principais
- [ ] Nomenclatura usa linguagem do cliente

---

## 10. RECURSOS PARA ESTUDO APROFUNDADO

### Vídeos (YouTube)

1. **"Modelagem de Dados - Introdução"** - Procure por canais de banco de dados em português
2. **"Entity Relationship Diagram Tutorial"** - Lucidchart oficial
3. **"Database Design Course"** - freeCodeCamp (inglês, mas completo)

### Artigos

1. **"Database Normalization Explained"** - Medium/Dev.to
2. **"ER Diagram Symbols and Meaning"** - Visual Paradigm

### Prática

1. **SQLBolt** (sqlbolt.com) - Exercícios interativos de SQL
2. **dbdiagram.io** - Praticar desenhando diagramas

---

## 11. GLOSSÁRIO RÁPIDO

| Termo | Significado |
|-------|-------------|
| **Entidade** | "Coisa" sobre a qual guardamos dados (tabela) |
| **Atributo** | Característica de uma entidade (coluna) |
| **Relacionamento** | Conexão entre entidades |
| **Cardinalidade** | Quantos de um lado se conectam com o outro (1:1, 1:N, N:N) |
| **PK** | Primary Key - identificador único |
| **FK** | Foreign Key - referência para outra tabela |
| **Entidade Forte** | Existe independente, dados sensíveis |
| **Entidade Fraca** | Depende de outra para existir |
| **Normalização** | Processo de organizar dados para evitar redundância |
| **Schema** | Estrutura completa do banco de dados |

---

## 12. PRÓXIMOS PASSOS

### Imediato (Antes da Visita)
1. [ ] Ler este documento completamente
2. [ ] Fazer os exercícios práticos
3. [ ] Revisar o documento de preparação de mapeamento
4. [ ] Praticar desenhando no Miro ou papel

### Durante a Visita
1. [ ] Usar o checklist de perguntas
2. [ ] Anotar entidades e atributos em tempo real
3. [ ] Fotografar cadernos e planilhas
4. [ ] Validar relacionamentos com os stakeholders

### Após a Visita
1. [ ] Consolidar anotações em diagrama digital
2. [ ] Validar com João (técnico)
3. [ ] Apresentar para Claudio (negócio)
4. [ ] Iterar e refinar

---

**Lembre-se:** Modelagem de dados é uma habilidade que melhora com prática. Seu primeiro diagrama não será perfeito, e tudo bem. O importante é capturar a essência do negócio e iterar.

---

**Documento preparado por:** DeepWork AI Flows
**Data:** 03/02/2026
**Versão:** 1.0
