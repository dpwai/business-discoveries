# Documento Preparatório: Reunião Kugler Veículos
**Objetivo:** Finalizar a coleta de requerimentos para precificação e orçamentação dos produtos Deepwork.

---

## 1. Contexto Geral
A Deepwork AI Flows apresenta soluções para transformar a operação de Funilaria e Pintura da Kugler Veículos. O foco mudou de "construção de site" para **soluções de inteligência de negócios e automação**.
**Meta da Reunião:** Sair com dados suficientes para estimar horas de desenvolvimento e custos de infraestrutura para os 3 produtos abaixo.

---

## 2. Produto 1: Deepwork BI (Plataforma EBI)
*Conceito: Torre de Controle visual para gestão em tempo real.*

### 🎯 Objetivo do Produto
Centralizar dados do NBS e do chão de fábrica em dashboards visuais para tomada de decisão rápida.

### 📋 Checklist de Levantamento Técnico (Precificação)
1.  **Infraestrutura de Visualização:**
    *   [ ] **TV:** Qual o modelo da TV existente? É Smart? Tem browser? (Se não, orçar Stick PC/Chromecast).
    *   [ ] **Rede:** O sinal Wi-Fi chega forte no local da TV? Precisamos de repetidor ou cabo?
    *   [ ] **Dispositivos Móveis:** Os gestores usarão Tablets ou Celulares próprios? Precisamos prever layout mobile-first?

2.  **Dados & Integração (Complexidade):**
    *   [ ] **Acesso aos Dados:** O NBS tem API? Se não, temos acesso direto ao Banco (SQL)? Ou precisaremos de exportação de relatórios via RPA?
    *   [ ] **Definição de Status:** Mapear TODOS os status de serviço existentes no NBS hoje. (Ex: Aguardando Peça, Funilaria, Pintura, Polimento, Pronto).
    *   [ ] **Atualização Manual:** Se o técnico não atualizar no sistema, quem atualiza? (Precisamos criar uma interface simplificada para o técnico apontar na oficina?)

3.  **Métricas Chave (KPIs) para o Dashboard:**
    *   *Confirmar se estas são as métricas vitais:*
        *   Carros no Pátio (Total vs Meta)
        *   Faturamento Projetado (Baseado nas OS abertas)
        *   Eficiência da Equipe (Horas vendidas vs Horas trabalhadas)
        *   Gargalos (Carros parados há > X horas)

4.  **Confiabilidade & Sustentação (SLA):**
    *   [ ] **Confiabilidade das Fontes:** Podemos confiar 100% nos dados do NBS hoje? Existe risco de inconsistência (lixo entra, lixo sai)?
    *   [ ] **Frequência de Atualização (CRON):** Qual a necessidade real?
        *   ( ) Tempo Real (Streaming - Mais caro/complexo)
        *   ( ) 1x por dia (D-1)
        *   ( ) A cada turno (Manhã/Tarde)
    *   [ ] **Monitoria:** Quando o dashboard falhar ou o dado estiver errado, quem deve ser avisado?
    *   [ ] **SLA de Erro:** Qual o tempo máximo aceitável para o sistema ficar fora do ar? (Crítico para definir suporte).

---

## 3. Produto 2: Agente NBS (Automação Inteligente)
*Conceito: Agente de IA que opera o NBS para reduzir trabalho manual.*

### 🎯 Objetivo do Produto
Automatizar a abertura de O.S., apontamentos e requisições, eliminando erros e "preguiça" de registro.

### 📋 Checklist de Levantamento Técnico (Precificação)
1.  **Escopo da Automação:**
    *   [ ] **Volume:** Quantas O.S. são abertas por dia/mês?
    *   [ ] **Processo Atual:** Alguém digita manualmente a partir de um papel? Quanto tempo isso leva?
    *   [ ] **Input:** O Agente receberá os dados como? (Foto de orçamento, Áudio no WhatsApp, Texto simples?)

2.  **Viabilidade Técnica (RPA vs API):**
    *   [ ] **Ambiente NBS:** É Desktop (Windows) ou Web? Se Desktop, precisamos de uma máquina virtual (VM) rodando 24/7 para o robô acessar?
    *   [ ] **Segurança do Robô:** O Agente terá um usuário próprio no NBS? ("Robô Deepwork").

3.  **Regras de Negócio Críticas:**
    *   [ ] **Exceções:** Existem clientes (Seguradoras) que exigem campos específicos que travam o processo se não preenchidos?
    *   [ ] **Erro Humano:** O que acontece hoje se uma O.S. é aberta errada? O Agente precisa saber corrigir?

---

## 4. Produto 3: Consultoria de Segurança de Dados
*Conceito: Blindagem da operação contra perda de dados e ataques.*

### 🎯 Objetivo do Produto
Garantir que a operação não pare por vírus (Ransomware) e que os dados dos clientes estejam seguros (LGPD).

### 📋 Checklist de Levantamento (Diagnóstico Rápido)
1.  **Inventário de Risco:**
    *   [ ] **Equipamentos:** Quantos computadores existem na rede? Sistemas operacionais antigos (Win 7/8)?
    *   [ ] **Acesso Remoto:** Usam TeamViewer/AnyDesk livremente? (Porta de entrada para hackers).
    *   [ ] **Antivírus:** Existe padrão corporativo ou cada um usa um gratuito?

2.  **Backup & Recuperação (Plano de Ação):**
    *   [ ] **Backup Atual:** É feito em HD externo plugado no servidor? (Risco altíssimo: Ransomware criptografa o backup junto).
    *   [ ] **Nuvem:** Existe cópia fora da empresa (Off-site)?
    *   [ ] **Tempo de Parada:** Se o servidor queimar hoje, em quanto tempo a oficina volta a operar? (RTO).

3.  **Entregável:**
    *   [ ] A entrega será um **Relatório de Vulnerabilidades** + **Plano de Correção** + **Execução da Blindagem**?

4.  **Governança & Compliance (LGPD):**
    *   [ ] **Lifecycle (Ciclo de Vida):** Por quanto tempo *somos obrigados* a manter os dados? (5 anos, 10 anos, eterno?).
    *   [ ] **Roles (Permissões):** Quem pode ver o quê? Precisamos criar níveis de acesso restritos (Ex: pintor não vê faturamento)?
    *   [ ] **NDA & Confidencialidade:** Qual o nível de sensibilidade dos dados? (Dados pessoais de clientes, margem de lucro, etc). Precisamos de NDAs assinados?

---

## 📊 Resumo para Orçamento
Para fechar o preço, precisamos preencher a tabela de esforço estimado:

| Produto | Complexidade (1-5) | Horas Estimadas (Dev/Setup) | Custo Recorrente (Ferramentas) |
| :--- | :---: | :---: | :---: |
| **BI Completo** | _(Definir após checar dados)_ | _(Ex: 40h)_ | _(Ex: PowerBI/Streamlit Cloud)_ |
| **Agente NBS** | _(Definir após checar API)_ | _(Ex: 60h)_ | _(Ex: LLM Tokens + VM)_ |
| **Segurança** | _(Definir após inventário)_ | _(Ex: 20h)_ | _(Ex: Licenças Backup/AV)_ |

---

## 📝 Próximos Passos (Na Reunião)
1.  **Validar Prioridade:** Qual dos 3 dói mais HOJE? (Provavelmente o BI para controle visual).
2.  **Pedir Acesso:** Conseguimos acesso de leitura ao Banco de Dados ou um relatório de teste HOJE?
3.  **Agendar Técnica:** Validar com o TI atual (se houver) as questões de servidor/rede.
