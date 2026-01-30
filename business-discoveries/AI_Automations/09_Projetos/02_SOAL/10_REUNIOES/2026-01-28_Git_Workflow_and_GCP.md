# Relatório de Análise - Reunião Tech & Infra (GCP/Git)
**Data da Reunião:** 28/01/2026
**Participantes:** João Vitor Balzer (Tech Lead), Rodrigo Kugler (Business/Discovery)
**Foco:** Workflow de Desenvolvimento (Git/VS Code), Migração para GCP (Free Tier) e Refinamento do App.

---

## 1. RESUMO EXECUTIVO

Esta reunião marcou uma mudança estratégica na infraestrutura do projeto. João apresentou a decisão de utilizar o **Google Cloud Platform (GCP)** para o backend de dados (Storage, BigQuery, Cloud Run) aproveitando o generoso *free tier*, enquanto o frontend permanece na Vercel pela facilidade de deploy.

Houve também um treinamento prático ("hand-holding") de Git para Rodrigo, estabelecendo o fluxo de branches, commits e pull requests para evitar conflitos no código. A separação entre os repositórios `app` (produto) e `landing-page` (site institucional) foi formalizada.

---

## 2. INFRAESTRUTURA E ARQUITETURA (GCP + VERCEL)

### A. Adoção do Google Cloud Platform (GCP)
- **Motivação:** Custo. O *free tier* do GCP é extremamente generoso para startups.
- **Componentes Selecionados:**
    - **Cloud Storage:** 5GB grátis para armazenar arquivos (notas fiscais, CSVs, imagens). Custo excedente irrisório ($0.02/GB).
    - **BigQuery:** 1TB de processamento de dados/mês grátis. Ideal para o Data Warehouse.
    - **Cloud Run:** 2 milhões de invocações/mês grátis. Será usado para rodar scripts Python (crawlers, automações).
    - **Speech-to-Text:** 60 min/mês grátis (para transcrição de áudios curtos do bot).
    - **Secret Manager:** Para gestão segura de credenciais.
- **Estratégia Híbrida:** Frontend na **Vercel** (Experiência de Dev/Deploy) + Backend de Dados no **GCP** (Robustez e Custo).

### B. Separando os Repositórios
1.  **`app.dpy.com.br`:** Código do produto SaaS. Área restrita ("Melhor Rodrigo não mexer muito no design agora").
2.  **`dpy.com.br` (Landing Page):** Site institucional. Rodrigo tem liberdade total para editar, testar copy e design.

---

## 3. WORKFLOW DE DESENVOLVIMENTO (GIT)

João instruiu Rodrigo no uso do Git via VS Code (interface gráfica):
1.  **Clone:** Clonar repositórios separados para pastas locais distintas.
2.  **Branches:** Nunca trabalhar na `main`. Criar sempre uma nova branch (ex: `feature-novo-design`) para cada tarefa.
3.  **Sync:** Usar o botão de "Sync Changes" (Pull/Push) da interface do VS Code.
4.  **Pull Request:** Abrir PR no GitHub para mergear alterações da branch para a `main` (Code Review).
5.  **GitHub Actions:** Monitorar a aba "Actions" para verificar falhas de deploy.

---

## 4. DESIGN E PRODUTO

### A. UX App
- **Animações:** "Tratorzinho 8-bit" no loading. Feedback positivo do Rodrigo ("Dá sensação de rapidez").
- **Organização vs Fazenda:** Reforço do conceito de que o usuário pode ter múltiplas organizações.
- **Filtros e Visualização:** Opção de arquivar dashboards e filtrar por tipo (Financeiro, Operacional).

### B. Inteligência Artificial (Roadmap)
- **Vector Database:** Menção ao uso de bancos vetoriais para dar "memória" à IA sobre os documentos do cliente.
- **Personalização do Agente:** Ideia de permitir que o usuário "batize" a IA (ex: dar o nome de um gerente antigo) e configure o tom de voz.
- **Preço:** Rodrigo sugere cobrar extra pelo módulo de IA ("Se o cara quiser IA, a mensalidade dobra"), em vez de pedir a chave de API do cliente.

---

## 5. AÇÕES IMEDIATAS (Next Steps)

1.  **Infra GCP:** João configurar o projeto no GCP e os buckets de Storage.
2.  **Git:** Rodrigo praticar o fluxo de branch/commit na Landing Page.
3.  **Vercel:** Rodrigo criar conta e aceitar convite para visualizar deploys.
4.  **Landing Page:** Rodrigo atualizar o conteúdo da LP no novo repositório clonado.

---

**Análise gerada pela Inteligência Híbrida SOAL**
*Focando na viabilidade técnica (GCP Free Tier) e na autonomia do time (Git Workflow).*
