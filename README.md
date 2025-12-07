# DeepWork AI Flows

Bem-vindo ao repositório oficial da **DeepWork AI Flows**.

Este repositório centraliza toda a inteligência do negócio, desde a estratégia e pesquisa de mercado até o código-fonte dos nossos "Funcionários Digitais".

## 📂 Estrutura do Repositório

- **`business-discoveries/AI_Automations/`**: O "Cérebro" do negócio. Contém toda a documentação, visão, pesquisa de mercado e definições de produto.
    - `01_Visao_Negocio`: Estratégia e posicionamento.
    - `02_Identidade_Marca`: Branding e tom de voz.
    - `10_Gestao_Tecnica`: Decisões técnicas e stack.
- **`backend/`**: API em Python (FastAPI) responsável pela lógica complexa e IA.
- **`frontend/`**: Dashboard do cliente em Next.js.
- **`n8n/`**: Arquivos e configurações para automação Low-Code.
- **`database/`**: Scripts e dados do PostgreSQL.
- **`docker-compose.yml`**: Orquestração de todo o ambiente.

## 🚀 Como Rodar o Projeto

Utilizamos **Docker** para garantir que tudo rode igual na sua máquina e em produção.

### Pré-requisitos
- Docker e Docker Compose instalados.

### Passo a Passo

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/balzer-and-kugler/business-discoveries.git
    cd business-discoveries
    ```

2.  **Suba o ambiente:**
    ```bash
    docker-compose up --build
    ```

3.  **Acesse os serviços:**
    - **Frontend (Dashboard):** [http://localhost:3000](http://localhost:3000)
    - **Backend (API):** [http://localhost:8000](http://localhost:8000)
    - **n8n (Automação):** [http://localhost:5678](http://localhost:5678)
    - **Banco de Dados:** `localhost:5432`

## 🛠️ Stack Tecnológica

Focamos em **simplicidade e ROI**.

- **Frontend:** Next.js (Web Responsivo).
- **Backend:** Python + FastAPI.
- **Automação:** n8n.
- **Banco de Dados:** PostgreSQL.
- **BI & Relatórios:** Usamos a infraestrutura do cliente (Google Looker Studio ou Power BI) para reduzir custos e fricção.

Para mais detalhes, veja [STACK_TECNOLOGICA.md](business-discoveries/AI_Automations/10_Gestao_Tecnica/STACK_TECNOLOGICA.md).

## 🤝 Contribuindo

1.  Crie uma branch para sua feature (`git checkout -b feature/nova-feature`).
2.  Siga o padrão de commit.
3.  Abra um Pull Request.
