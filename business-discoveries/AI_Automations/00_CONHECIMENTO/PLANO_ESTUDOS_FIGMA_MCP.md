# Plano de Estudos: Ferramentas Essenciais (Figma & MCP)

Este plano foi desenhado para acelerar seu aprendizado em duas frentes críticas para o projeto SOAL: **Visualização do Produto (Figma)** e **Inteligência de Dados (MCP)**.

---

## 🎨 Parte 1: Figma (Design & Prototipagem)

> **Por que aprender?** Para validar ideias com o Claudio *antes* de escrever uma linha de código. É mais barato errar no desenho do que no software.

### Nível 1: O Básico (Flyweight)
*   **Conceito:** Entenda a diferença entre "Design" (Visual) e "Prototipagem" (Comportamento/Clique).
*   **Ação:** Crie sua conta gratuita no Figma e desenhe a "Tela de Login" do nosso sistema.
*   **Tópicos para Estudar:**
    1.  **Frames:** A "folha de papel" do digital (iPhone 14, Desktop).
    2.  **Auto-Layout:** (Critical!) Como fazer botões que crescem sozinhos conforme o texto.
    3.  **Componentes:** Crie um botão uma vez e reuse em 50 telas.

### Nível 2: Aplicado ao SOAL (Middleweight)
*   **Desafio:** Criar o protótipo do **"Morning Briefing"**.
*   **O que desenhar:**
    *   Não um dashboard cheio de gráficos.
    *   Desenhe uma interface de "Chat" (tipo WhatsApp) onde o sistema manda o áudio.
    *   Desenhe um "Card" de alerta de segurança (Ex: "Máquina parada").
*   **Meta:** Levar isso na visita presencial no celular para o Claudio clicar. "Claudio, se o sistema fosse assim, você usaria?"

### Nível 3: Handoff (Heavyweight)
*   **Conceito:** Como passar o desenho para o código (CSS/React).
*   **Ferramenta:** "Dev Mode" do Figma (ou plugins gratuitos).
*   **Meta:** Aprender a ver o tamanho das fontes e cores exatas para não "inventar" na hora de programar.

---

## 🧠 Parte 2: MCP (Model Context Protocol)

> **Por que aprender?** Porque o ChatGPT sozinho é "burro" sobre a fazenda. O MCP é o "cabo" que conecta o cérebro da IA no banco de dados da SOAL.

### O que é MCP?
Imagine que o LLM (Claude/GPT) é um **Diretor Executivo** muito inteligente, mas que acabou de chegar na empresa e não tem a senha do computador.
*   O **MCP** é o estagiário que tem a senha.
*   O Diretor pergunta: "Quanto gastamos de diesel?"
*   O MCP vai no banco de dados, consulta, e responde: "R$ 50.000,00".
*   O Diretor conclui: "Isso é 10% a mais que o mês passado."

### Nível 1: Arquitetura Básica
*   **MCP Server:** O código que *nós* vamos escrever. Ele sabe falar com o AgriWin/John Deere.
*   **MCP Client:** A interface de IA (ex: Claude Desktop, Cursor).
*   **Resources:** Os dados que a gente expõe (ex: Tabela de `viagens_trator`).
*   **Prompts:** Comandos prontos que a gente cria (ex: "Analisar DRE da Safra").

### Nível 2: Aplicado ao SOAL
Onde o MCP brilha no nosso projeto:
1.  **Conexão Segura:** Não precisamos mandar o banco de dados inteiro para a OpenAI. O MCP roda local (ou em servidor controlado) e só manda para a IA o *resultado* da consulta.
2.  **AgriWin Adapter:** Vamos criar um "MCP Server" que conecta no banco SQL do AgriWin.
    *   *Usuário pergunta:* "Qual talhão deu prejuízo?"
    *   *IA chama MCP:* `get_profit_by_field()`
    *   *MCP roda SQL:* `SELECT * FROM costs WHERE...`
    *   *IA responde:* "O Talhão 4 deu prejuízo por excesso de defensivo."

### Nível 3: Como Começar
*   **Leitura Obrigatória:** Documentação oficial do Anthropic MCP (modelcontextprotocol.io).
*   **Exercício Prático:** Tentar rodar um "MCP Server" simples de sistema de arquivos (FileSystem) para deixar o Claude ler seus arquivos locais (o Cursor já faz algo parecido, mas é bom entender a mágica).

---

## 📚 Resumo do Plano de Ação

1.  **Semana 1 (Visual):** Fazer um curso rápido de Figma no YouTube (Canal "DesignCode" ou brasileiros como "Zander"). Focar em protótipo clicável.
2.  **Semana 2 (Lógica):** Ler a doc do MCP e desenhar (no papel) quais "Ferramentas" nosso MCP da SOAL precisa ter. (Ex: `ler_estoque`, `ler_combustivel`, `ler_humidade_solo`).
