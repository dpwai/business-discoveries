# Questionário de Levantamento para Precificação (Orçamento)

**Objetivo:** Coletar dados técnicos e volumetria para estruturar a proposta comercial dos 3 produtos da Deepwork para a Kugler Veículos.

---

## 📦 Produto 1: Deepwork BI (Torre de Controle & Gestão)
*Escopo: Torre de Controle (TV), Dashboard Executivo e Treinamento.*

1.  **Infraestrutura da Torre:**
    *   Já existe uma Smart TV no local (chão de fábrica)? Se sim, qual modelo/sistema?
    *   Existe ponto de rede/Wi-Fi estável onde a TV ficará?
    *   Precisaremos fornecer um Mini-PC (Stick) para rodar o dashboard ou a TV tem browser compatível?
2.  **Camada de Dados Externa:**
    *   Quantos status de serviço diferentes existem hoje no fluxo ideal? (Ex: Aguardando, Desmontagem, Funilaria, Pintura, Montagem, Polimento, Lavagem, Pronto).
    *   Onde esses status serão atualizados manualmente caso a automação falhe? (Tablet, Celular, Computador Central?)
3.  **Treinamento:**
    *   Quantas pessoas precisarão ser treinadas para operar/ler os dashboards? (Gestores vs Operacional).
    *   Qual a disponibilidade de tempo da equipe para o treinamento inicial?

---

## 🤖 Produto 2: Deepwork Agent (Automação NBS)
*Escopo: Agente para automatizar movimentos no NBS (Abertura de OS, Apontamento, Requisição).*

1.  **Volumetria:**
    *   Qual a média mensal de Ordens de Serviço (O.S.) abertas?
    *   Quantos técnicos (funileiros/pintores) farão apontamento de horas diariamente?
2.  **Acesso ao NBS (Crítico):**
    *   O NBS roda em servidor local ou na nuvem?
    *   Temos acesso direto ao banco de dados (SQL) ou precisaremos usar RPA (Robô que clica na tela)?
    *   Existe alguma API disponível do NBS?
3.  **Regras de Negócio:**
    *   Existem exceções complexas na abertura de O.S. (ex: clientes de seguradora vs particular tem fluxos muito diferentes)?
    *   Quais são os campos *obrigatórios* que não podem faltar de jeito nenhum?

---

## 🛡️ Produto 3: Consultoria de Governança & Segurança (Blindagem)
*Escopo: Avaliação de dados, governança e plano de ação contra hackers.*

1.  **Estrutura Atual:**
    *   Quantos computadores/servidores existem na rede da concessionária?
    *   Qual o sistema operacional predominante? (Windows 10/11, Server 2019, Linux?)
2.  **Backup & Recuperação:**
    *   Como é feito o backup hoje? (Físico, Nuvem, Híbrido?)
    *   Qual a frequência? Existe teste de restore?
3.  **Acessos:**
    *   Existe controle de nível de acesso (quem pode ver o que)?
    *   O acesso remoto (VPN/TeamViewer) é utilizado? Como é controlado?
4.  **Histórico:**
    *   Já sofreram alguma tentativa de ataque ou perda de dados recente?

---

## 💰 Expectativa de Investimento (Budget)
*   Existe um orçamento pré-aprovado para inovação/tecnologia este ano?
*   A preferência é por um modelo de **Projeto Fechado (Setup)** + **Mensalidade (SaaS)** ou apenas **Projeto Pontual**?
