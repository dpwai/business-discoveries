# Brainstorming: O Agente de Automação NBS

**Conceito Central:** Criar uma camada de inteligência (Agente) que opera o sistema legado (NBS) automaticamente, liberando humanos de tarefas repetitivas e propensas a erro.

**O Papel do João (Técnico):** Desenvolver os "braços" do robô (RPA/Integrações).
**Nosso Papel (Criativo/Funcional):** Definir o "cérebro" e a "voz" desse agente. O que ele deve fazer e como interagimos com ele.

---

## 1. O "Agente Invisível" (Backend)
Este agente atua nos bastidores, recebendo comandos simples de interfaces modernas e executando processos complexos no NBS.

### Capacidades Principais:

#### A. Abertura de O.S. Automática
*   **Entrada:** Consultor envia áudio no WhatsApp ou preenche formulário rápido no Tablet (Placa + Fotos + Relato).
*   **Ação do Agente:**
    1.  Loga no NBS.
    2.  Busca cliente/veículo.
    3.  Cria a O.S.
    4.  Preenche "Reclamação" (transcrita do áudio).
    5.  Anexa fotos (se o NBS permitir ou salva em drive linkado).
*   **Benefício:** Zero erro de digitação, padronização da entrada, agilidade no atendimento.

#### B. Gestão de Mão de Obra (Apontamento)
*   **Entrada:** Técnico clica "Iniciar" no Tablet ou passa crachá.
*   **Ação do Agente:**
    1.  Identifica o serviço no NBS.
    2.  Inicia a contagem de tempo (Time Tracking) no módulo de oficina do NBS.
    3.  Quando o técnico clica "Parar", o agente encerra o apontamento no NBS.
*   **Benefício:** Precisão absoluta no custo da mão de obra e pagamento justo. Fim do "chute" de horas.

#### C. Requisição de Peças
*   **Entrada:** Técnico solicita "Filtro de Óleo" via comando de voz ou clique no Tablet.
*   **Ação do Agente:**
    1.  Verifica estoque no NBS.
    2.  Se disponível, cria a requisição interna para o almoxarifado.
    3.  Se indisponível, alerta o setor de compras ou gera cotação automática.
*   **Benefício:** O técnico não sai da baia, o fluxo não para.

---

## 2. Interfaces de Interação (Frontend)
Como os humanos conversam com o Agente?

### A. Interface "Consultor" (Tablet/Mobile)
*   **Foco:** Agilidade e Experiência do Cliente.
*   **Funcionalidades:**
    *   Scanner de Placa (OCR).
    *   Checklist visual de entrada (marcar avarias).
    *   Botão "Gerar O.S." (aciona o Agente).

### B. Interface "Técnico" (Tablet na Baia ou WhatsApp)
*   **Foco:** Simplicidade e Mãos Livres.
*   **Funcionalidades:**
    *   Lista de tarefas do dia.
    *   Botão gigante Start/Stop.
    *   Botão "Pedir Peça".
    *   Botão "Chamar Supervisor" (para travas/dúvidas).

### C. Interface "Gestor" (WhatsApp/Dashboard)
*   **Foco:** Controle e Alertas.
*   **Funcionalidades:**
    *   Recebe alertas do Agente: "O.S. 1234 parada por falta de peça há 2h".
    *   Resumo do dia: "Hoje abrimos 15 O.S. e faturamos R$ 20k (estimado)".

---

## 3. Cenário de Exemplo: "A Jornada Sem Fricção"

1.  **Chegada:** Cliente chega. Consultor aponta Tablet. Agente identifica: "Olá Sr. João, revisão de 10k?"
2.  **Entrada:** Consultor confirma e tira fotos. Agente abre a O.S. no NBS em segundos.
3.  **Execução:** Carro vai pro box. Técnico vê a tarefa na tela. Clica "Iniciar". Agente marca o tempo no NBS.
4.  **Peças:** Técnico nota que precisa de uma pastilha extra. Fala no App. Agente requisita no almoxarifado. Peça chega na mão dele.
5.  **Fim:** Técnico clica "Finalizar". Agente fecha a O.S. de serviço, calcula o custo real e avisa o consultor: "Carro pronto".

---

## Próximos Passos
*   Definir quais desses fluxos são prioridade para o MVP (Produto Mínimo Viável).
*   Validar com o João quais "portas" do NBS estão abertas para essa automação.