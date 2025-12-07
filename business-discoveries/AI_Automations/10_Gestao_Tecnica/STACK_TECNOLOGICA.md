# Stack Tecnológica & Arquitetura - DeepWork AI Flows

**Data de Definição:** 07/12/2025
**Status:** Definição Inicial para MVP

## 🎯 Princípios de Engenharia
1.  **Simplicidade > Complexidade:** "Boring is good". Usamos tecnologias consolidadas.
2.  **Velocidade de Entrega:** O objetivo é validar hipóteses de negócio, não escrever código perfeito.
3.  **Escalabilidade Vertical:** Começamos com uma máquina forte antes de distribuir sistemas (sem Kubernetes por enquanto).

---

## 🏗️ A Stack (O "Cinto de Utilidades")

### 1. Frontend (Interface do Cliente)
- **Tecnologia:** **Next.js** (React)
- **Objetivo:** Dashboard para o cliente visualizar métricas (economia gerada, leads processados) e configurar parâmetros básicos do agente.
- **Hospedagem:** Vercel (inicialmente) ou Container Docker.
- **Por que não App Mobile?** Foco em responsividade Web. O cliente acessa pelo navegador do celular. Evita custo de manter duas bases de código.

### 2. Backend (O "Cérebro")
- **Tecnologia:** **Python** + **FastAPI**
- **Objetivo:** Orquestrar a lógica complexa, gerenciar autenticação, e servir como API para o Frontend.
- **Bibliotecas Chave:**
    - `pandas` / `polars`: Manipulação de dados.
    - `pydantic`: Validação de dados.
    - `openai` / `langchain`: Integração com LLMs.

### 3. Automação Low-Code (A "Cola Rápida")
- **Tecnologia:** **n8n** (Self-hosted)
- **Objetivo:** Criar fluxos de integração rápidos (Webhooks, conexões com CRMs, disparos de e-mail) sem precisar escrever código boilerplate no backend.
- **Uso:**
    - Receber webhook do WhatsApp.
    - Salvar no Postgres.
    - Chamar API do Python para processamento pesado.
    - Devolver resposta.

### 4. Banco de Dados
- **Tecnologia:** **PostgreSQL**
- **Objetivo:** Armazenamento relacional robusto (Clientes, Transações, Logs).
- **Vetor Store (Futuro):** `pgvector` (extensão do Postgres) para memória de longo prazo da IA.

### 5. Business Intelligence (BI) & Relatórios
- **Estratégia:** **"Use o que o cliente já tem"** para reduzir fricção e custos.
- **Opção Preferencial (Custo Zero):** **Google Looker Studio**.
    - Conecta nativamente com Google Sheets ou Postgres.
    - Gratuito e fácil de compartilhar via link.
- **Opção Corporativa:** **Microsoft Power BI**.
    - Se o cliente já tiver licença Microsoft 365/Azure.
    - Não vamos vender licença, usamos a infraestrutura deles.

### 6. Infraestrutura
- **Containerização:** **Docker** & **Docker Compose**.
- **Orquestração:** Tudo roda em containers para garantir que o ambiente de dev seja igual ao de prod.

---

## 🔄 Fluxo de Dados Típico

1.  **Gatilho:** Cliente envia mensagem no WhatsApp.
2.  **Entrada:** **n8n** recebe o Webhook.
3.  **Processamento Rápido:** **n8n** verifica se é um usuário conhecido no **Postgres**.
4.  **Inteligência:** Se precisar de raciocínio, **n8n** chama a API **Python (FastAPI)**.
5.  **Ação:** **Python** processa, gera resposta e devolve pro **n8n**.
6.  **Saída:** **n8n** envia a resposta pro WhatsApp.
7.  **Visualização:** Cliente entra no **Next.js** e vê que o atendimento foi realizado.
