# Relatório de Análise - Definição de Produto e Modelo de Negócio
**Data da Reunião:** 30/01/2026
**Participantes:** João Vitor Balzer (Tech Lead), Rodrigo Kugler (Business/Discovery)
**Foco:** Refinamento de Nomenclatura, Arquitetura de Dados (ETL Visual), Conectores e Estratégia de Precificação (Tiers).

---

## 1. RESUMO EXECUTIVO

A reunião de 30/01 foi crucial para a **maturidade do produto**. O time refinou a nomenclatura da plataforma para torná-la mais amigável ao usuário final (ex: "Formulários" vira "Entradas de Dados").

O maior desafio técnico identificado foi o **cruzamento de dados (Gold Layer)**. A solução proposta é criar "Conectores" onde o usuário define como um dado se liga ao outro (ex: Placa do Caminhão no Formulário de Balança conecta com Placa no Formulário de Secador).

Estrategicamente, definiu-se o *Core Business* da DPY como uma **"Plataforma treinadora de agentes com seus dados"**. O modelo de negócio foi esboçado em 3 níveis (Basic, Consultoria, Pro/AI) para incentivar a venda do serviço de inteligência agregada.

---

## 2. REFINAMENTO DE PRODUTO (UX/UI)

### A. Terminologia e Navegação
- **Entradas de Dados:** Nova nomenclatura para "Formulários". Foco na ação do usuário.
- **Minha Conta / Organizações:** Substitui "Integrações" no menu principal. O usuário comum não precisa ver "Integrações", apenas o dono.
- **Chat:** Substitui o nome "Ralf" para evitar confusão.
- **Modais:** Uso de janelas modais para configurações rápidas sem perder o contexto da tela de fundo.

### B. Funcionalidades Novas
- **Alertas Inteligentes:**
    - *Ação/Reação:* "Se estoque de glifosato < 100L, avise."
    - *Resumo:* "Resumo diário da operação no WhatsApp às 18h."
    - *Técnico:* "Falha na integração com John Deere."
- **Segredos (Secrets):** Interface segura para o cliente imputar usuários/senhas de sistemas legados (AgriWin, John Deere) que serão usados pelos crawlers.

---

## 3. ARQUITETURA DE DADOS (ETL & CONECTORES)

### A. O Desafio da "Gold Layer"
- **Problema:** Ingerir dados (Bronze) e limpar (Silver) é "fácil". O valor real está no cruzamento (Gold). Ex: Saber que o caminhão X que pesou na balança é o mesmo que descarregou no secador 10 min depois.
- **Solução (Conectores):** Criar uma interface onde o usuário (ou o consultor DPY na fase de setup) cria "Conectores".
    - *Input:* Seleciona Formulário A (Secador) e Formulário B (Balança).
    - *Chave:* Define o campo de ligação (ex: Placa + Janela de Tempo).
- **Visualização:** Rodrigo deve criar **Diagramas de Blocos Visuais** do fluxo de dados para o Discovery. O cliente precisa *ver* o caminho do dado para entender a complexidade e valor.

### B. "Cloud Bot" (Crawler Agents)
- Evolução da ideia de integração. Agentes rodando em containers (Cloud Run/VPS) que agem como "funcionários virtuais": logann no sistema legado do cliente (AgriWin), navegam, copiam dados e lançam na plataforma DPY.

---

## 4. MODELO DE NEGÓCIO E PRECIFICAÇÃO (DRAFT)

### Definição do Negócio
*"Uma plataforma que treina o seu próprio agente com seus dados para trazer insights de negócio, rapidez na decisão e corte de custos."*

### Estrutura de Planos (Sugestão)
1.  **Plano Basic (~R$ 100):** "O produto esquecido". Dashboards padrão, sem personalização. Serve de âncora de preço.
2.  **Plano Consultoria (~R$ 430):** Inclui o serviço de Discovery, construção de dashboards personalizados e configuração de conectores.
3.  **Plano Pro/AI (~R$ 500+):** Inclui o acesso aos Agentes LLM (Vertex AI/Gemini) para interagir com os dados (chat). É onde está a margem e o diferencial competitivo.

---

## 5. AÇÕES IMEDIATAS (Next Steps)

1.  **Mapeamento de Regras de Cruzamento:** Rodrigo precisa definir *exatamente* como os dados da SOAL se cruzam (quais são as chaves únicas?) para que João possa programar a lógica.
2.  **Diagramas de ETL:** Criar representações visuais do fluxo de dados para usar na apresentação comercial/Discovery.
3.  **Desenvolvimento:** João implementar a tela de "Gerenciar Meus Dados" e a lógica dos Conectores.
4.  **Comercial:** Preparar para apresentar os Dashboards e o conceito de "Cloud Bot" para o cliente principal (Tio do Rodrigo).

---

**Análise gerada pela Inteligência Híbrida SOAL**
*Focando na estruturação do Core Business e na lógica complexa de cruzamento de dados.*
