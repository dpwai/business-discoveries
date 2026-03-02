# Estrutura do Repositório GitHub - AI Automations

## 🎯 Objetivo

GitHub como **hub de tudo**: código, docs, materiais.

---

## 📁 Estrutura de Pastas Proposta

```
AI_Automations/
├── README.md                          # Visão geral do projeto
├── docs/                              # Documentação geral
│   ├── visao/                         # Visão do negócio
│   │   ├── VISAO_NEGOCIO_CONSOLIDADA.md
│   │   └── CONTEXTO_NEGOCIO.md
│   ├── casos_de_uso/                  # Casos de uso por cliente
│   │   ├── cliente_001_concessionaria/
│   │   │   ├── relatorio_entrevista.md
│   │   │   ├── processos_mapeados.md
│   │   │   └── proposta_valor.md
│   │   └── cliente_002_contabilidade/
│   ├── requisitos/                    # Requisitos por cliente
│   │   ├── cliente_001/
│   │   │   ├── requisitos_funcionais.md
│   │   │   ├── requisitos_tecnicos.md
│   │   │   └── integracoes_necessarias.md
│   └── pesquisa_mercado/              # Pesquisa de mercado
│       ├── pesquisa_consorcios.md
│       ├── pesquisa_concessionarias.md
│       └── pesquisa_ramo_medico.md
│
├── agents/                            # Código/configuração dos agentes
│   ├── cliente_001_concessionaria/
│   │   ├── contadora_automation/
│   │   │   ├── config.yaml             # Configuração do agente
│   │   │   ├── flows/                  # Fluxos de automação
│   │   │   │   ├── processar_dados.yaml
│   │   │   │   └── preencher_sistema.yaml
│   │   │   ├── scripts/               # Scripts auxiliares
│   │   │   └── README.md              # Documentação específica
│   │   └── outro_processo/
│   └── cliente_002_contabilidade/
│
├── integrations/                      # Conectores, scripts, flows
│   ├── whatsapp/                      # Integração WhatsApp
│   │   ├── connector.py
│   │   └── README.md
│   ├── email/                         # Integração E-mail
│   ├── sistemas/                      # Integrações com sistemas específicos
│   │   ├── sistema_contabil/
│   │   ├── sistema_medico/
│   │   └── sistema_concessionaria/
│   ├── n8n/                           # Flows do n8n
│   │   ├── flow_template.json
│   │   └── flows_por_cliente/
│   └── scripts/                       # Scripts de automação
│
├── infra/                             # Infraestrutura
│   ├── docker/                        # Dockerfiles
│   ├── kubernetes/                    # Configs K8s (se usar)
│   ├── terraform/                     # IaC (se usar)
│   └── configs/                       # Configurações gerais
│
├── tests/                             # Testes
│   ├── unit/                          # Testes unitários
│   ├── integration/                   # Testes de integração
│   └── e2e/                           # Testes end-to-end
│
└── .github/                           # GitHub Actions, templates
    ├── workflows/                     # CI/CD
    └── ISSUE_TEMPLATE/                # Templates de issues
```

---

## 📋 Descrição das Pastas Principais

### `/docs`
**Documentação geral do projeto**

#### `/docs/visao`
- Visão do negócio consolidada
- Contexto do negócio
- Estratégia e posicionamento

#### `/docs/casos_de_uso`
- Um diretório por cliente
- Relatórios de entrevista
- Processos mapeados
- Propostas de valor

#### `/docs/requisitos`
- Requisitos funcionais e técnicos por cliente
- Integrações necessárias
- Especificações detalhadas

#### `/docs/pesquisa_mercado`
- Pesquisas de mercado por segmento
- Análise de concorrência
- Insights consolidados

### `/agents`
**Código e configuração dos agentes**

- Um diretório por cliente
- Dentro de cada cliente, um diretório por processo/automação
- Cada agente tem:
  - `config.yaml`: Configuração do agente
  - `flows/`: Fluxos de automação (n8n, etc.)
  - `scripts/`: Scripts auxiliares
  - `README.md`: Documentação específica

### `/integrations`
**Conectores e integrações**

- Integrações genéricas (WhatsApp, E-mail, etc.)
- Integrações com sistemas específicos
- Flows do n8n
- Scripts de automação reutilizáveis

---

## 🔧 Configuração Inicial

### 1. Criar Repositório no GitHub
- [ ] Criar repositório privado (ou público, conforme preferência)
- [ ] Adicionar Rodrigo e João como colaboradores
- [ ] Configurar branch protection (se necessário)

### 2. Estrutura Básica
- [ ] Criar estrutura de pastas conforme acima
- [ ] Adicionar `.gitignore` apropriado
- [ ] Criar `README.md` principal

### 3. Documentação Inicial
- [ ] Mover documentos existentes para `/docs/visao`
- [ ] Criar estrutura de casos de uso
- [ ] Organizar pesquisa de mercado

---

## 📝 Convenções de Nomenclatura

### Clientes
- Formato: `cliente_XXX_nome` (ex: `cliente_001_concessionaria`)
- XXX: Número sequencial
- nome: Nome descritivo do cliente/segmento

### Agentes/Processos
- Formato: `nome_processo` (ex: `contadora_automation`)
- Nome descritivo e claro
- Em português ou inglês (definir padrão)

### Arquivos de Configuração
- `config.yaml`: Configuração principal
- `README.md`: Documentação sempre em português
- Scripts: `.py`, `.js`, etc. conforme tecnologia

---

## 🔒 Segurança e Privacidade

### Dados Sensíveis
- [ ] **NUNCA** commitar credenciais, senhas, tokens
- [ ] Usar variáveis de ambiente ou secrets do GitHub
- [ ] Usar `.env.example` como template
- [ ] Adicionar `.env` ao `.gitignore`

### Informações de Clientes
- [ ] Dados sensíveis de clientes em repositório privado
- [ ] Considerar criptografia para dados muito sensíveis
- [ ] Política de acesso: apenas Rodrigo e João

---

## 🛠️ Ferramentas e Tecnologias

### Versionamento
- **GitHub**: Repositório principal
- **Git**: Controle de versão

### Desenvolvimento
- **Copilot/Cursor**: Possível uso (mencionado na reunião)
- **n8n**: Orquestrador de fluxos
- **GPT Agents**: Para agentes de IA

### Documentação
- **Markdown**: Formato padrão para docs
- **README.md**: Em cada diretório importante

---

## 📋 Checklist de Setup

### Para João Balzer (TI)
- [ ] Criar repositório no GitHub
- [ ] Configurar estrutura de pastas
- [ ] Adicionar `.gitignore` apropriado
- [ ] Criar `README.md` principal
- [ ] Mover documentos existentes para `/docs`
- [ ] Configurar acesso para Rodrigo
- [ ] Criar template de configuração de agente (`config.yaml`)
- [ ] Criar template de flow (n8n ou outro)
- [ ] Documentar stack técnica escolhida

### Para Rodrigo (Negócios)
- [ ] Ter acesso ao GitHub
- [ ] Saber usar Git básico (commit, push, pull)
- [ ] Adicionar documentos de negócio em `/docs`
- [ ] Criar casos de uso após entrevistas em `/docs/casos_de_uso`

---

## 🔄 Workflow de Trabalho

### Quando Rodrigo Faz Entrevista
1. Fazer entrevista usando `ROTEIRO_ENTREVISTA.md`
2. Preencher `TEMPLATE_RELATORIO_CLIENTE.md`
3. Criar diretório em `/docs/casos_de_uso/cliente_XXX_nome`
4. Adicionar relatório e documentos relacionados
5. Commit e push para GitHub

### Quando João Desenvolve Agente
1. Revisar requisitos em `/docs/casos_de_uso/cliente_XXX`
2. Criar diretório em `/agents/cliente_XXX_nome/processo_nome`
3. Desenvolver agente (config, flows, scripts)
4. Documentar em `README.md` do agente
5. Commit e push para GitHub

### Quando Precisam Colaborar
1. Criar branch para feature/issue
2. Desenvolver/testar
3. Pull request para revisão
4. Merge após aprovação

---

## 📚 Documentação por Agente

Cada agente deve ter um `README.md` com:

### Template de README de Agente

```markdown
# [Nome do Agente] - [Cliente]

## Descrição
[O que o agente faz]

## Processo Automatizado
[Descrição do processo passo a passo]

## Sistemas Integrados
- Sistema 1: [Nome] - [Como integra]
- Sistema 2: [Nome] - [Como integra]

## Configuração
[Como configurar o agente]

## Fluxo de Execução
1. [Passo 1]
2. [Passo 2]
3. [Passo 3]

## Supervisão Humana
[Onde o humano precisa revisar/assinar]

## Troubleshooting
[Problemas comuns e soluções]

## Manutenção
[Como manter e melhorar]
```

---

## 🎯 Próximos Passos

1. [ ] João: Criar repositório no GitHub
2. [ ] João: Configurar estrutura inicial
3. [ ] João: Criar templates (config.yaml, README.md)
4. [ ] Ambos: Mover documentos existentes
5. [ ] Rodrigo: Após primeira entrevista, criar caso de uso
6. [ ] João: Após receber requisitos, criar primeiro agente

---

## 📝 Notas

- GitHub é o **hub central** de tudo
- Documentação sempre atualizada
- Código versionado e organizado
- Fácil colaboração entre Rodrigo e João

---

## 🔄 Última Atualização

- **Data**: 2025-01-27
- **Baseado em**: Reunião de 18/11/2025 com João Balzer

