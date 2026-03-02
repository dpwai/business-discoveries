# Estrutura de Formulário de Dados: Gestão de Lavagem v3 (Centralizado)

**Premissa Crítica:** Os lavadores NÃO tocam no sistema.
**Usuário Único:** Administrativo / Gerente de Pátio.
**Dispositivo:** PC (Principal) ou Celular (Andando pelo pátio).

---

## 🖥️ 1. O Painel de Controle (A "Prancheta Digital")
*O Admin substitui a prancheta de papel por essa tela.*

### A. Entrada de Veículo (Check-in Rápido)
*Apenas o essencial para colocar o carro na fila.*
1.  **Placa:** (Campo único - Digita ou Foto OCR)
2.  **Serviço:** [ ] Ducha | [ ] Completa | [ ] Estética
3.  **Localização Física:** Marcar onde o carro foi deixado (ex: "Fila Externa 1").

---

## 🖱️ 2. Atualização de Status (Drag & Drop)
*O Admin olha para o pátio e atualiza a tela.*

**Não existe formulário de "iniciar tarefa". Existe MUDANÇA DE ESTADO.**

*   **Cenário 1:** O Lavador 1 terminou a Hilux.
    *   *Ação do Admin:* Arrasta o card da "Pista de Lavagem" -> para "Fila Secagem".
    *   *Sistema:* Registra timestamp automático do fim da etapa 1.

*   **Cenário 2:** A equipe interna pegou o Corolla.
    *   *Ação do Admin:* Clica no carro e atribui: "Equipe Interna Iniciou".

*   **Cenário 3:** Carro Pronto.
    *   *Ação do Admin:* Marca como **PRONTO PARA ENTREGA**.

---

## ✅ 3. Checklist de Saída (O Admin Confere)
*Antes de chamar o cliente, o Admin faz a volta no carro.*

**Checklist Visual (Rápido):**
1.  Rodas OK?
2.  Secagem OK?
3.  Interior OK?

*Botão Grande:* **[ LIBERAR VEÍCULO ]**
*(Isso dispara o aviso para a recepção/vendas que o carro está disponível)*
