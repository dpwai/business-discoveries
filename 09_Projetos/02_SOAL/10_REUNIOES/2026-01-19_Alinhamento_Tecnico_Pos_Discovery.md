# Análise Técnica: Alinhamento Pós-Discovery (Rodrigo & João)
**Data da Reunião:** 19 de janeiro de 2026
**Participantes:** Rodrigo Kugler, João Vitor Balzer
**Foco:** Definição da Arquitetura Técnica, Vestro, Coleta Manual e Próximos Passos (Visita)

---

## 1. 🎯 Resumo Executivo (TL;DR)

**Objetivo:** Converter os insights do Discovery com Tiago em decisões de arquitetura e planejar a visita presencial.

**Vibe/Sentimento:**
*   **Otimismo Técnico:** João "matou" as dúvidas rapidamente (ex: Vestro via planilha, CAN via OBD, Coleta via Custom Forms).
*   **Clareza de Escopo:** O MVP não precisa ser complexo. O valor está em *centralizar* e *simplificar* a entrada de dados.
*   **Modelo de Parceria:** O cliente (SOAL) entende que está co-criando o produto. Isso dá margem para testes.

**Principais Vitórias (Decisões):**
*   **Vestro = Extração de Planilha:** Não perder tempo com API no início. Crawler/Script para puxar o Excel do portal Vestro resolve.
*   **Entrada Manual = Custom Forms (No Login):** Solução genial para Josmar (Secador). Formulário web simplificado (tipo AppSheet) sem senha complexa.
*   **Maquinário Legado = OBD/CAN:** Identificada a rota técnica para conectar tratores velhos sem telemetria nativa (hardware OBD).

---

## 2. 🔍 Mapeamento e Decisões de Fontes de Dados

| Sistema / Processo | Fonte (Bronze) | Decisão Técnica de Ingestão | Pain Point Resolvido |
|---|---|---|---|
| **Vestro (Abastecimento)** | Portal Web (Excel) | **Script de Extração Cíclica:** Robô baixa a planilha periodicamente. | Elimina "Tiago corrige Excel na mão -> Valentina digita". O dado entra direto no DW. |
| **Balança** | Planilha Excel no Drive | **API Google Drive/OneDrive:** N8N monitora pasta e ingere novos arquivos. | Automação 100%. A operadora continua usando o Excel que já sabe, mas o dado vai pro Banco. |
| **Secador (Josmar)** | Caderno de Papel | **Custom Form (Web App Simples):** Tela com botões grandes, poucos campos, sem login complexo. | Elimina digitação posterior de 15 dias. Visibilidade de estoque (quase) em tempo real. |
| **John Deere (Legado)** | Sem conectividade | **Hardware OBD/CAN:** Investigar instalação de módulos para leitura do barramento CAN. | Traz visibilidade para máquinas antigas que hoje são "pontos cegos". |

---

## 3. 🏗️ Arquitetura do Sistema (MVP)

João desenhou uma estrutura de aplicação em **3 Abas** para o cliente:

1.  **Entradas Manuais (Input):**
    *   Formulários customizados para Josmar/Operadores.
    *   Interface de correção (Tiago vê o dado que entrou e pode editar/validar).
2.  **Entradas Automatizadas (Logs):**
    *   Tela de "saúde do sistema". Mostra: "John Deere: OK (última carga 10min atrás)", "Vestro: OK".
    *   Botão "Atualizar Agora" para forçar ingestão.
3.  **Meus Painéis (Output):**
    *   **Dashboard Embedado:** Looker ou Power BI rodando dentro da aplicação.
    *   Cliente pode editar filtros e visualizações (self-service BI limitado).

---

## 4. 💡 Insights Técnicos Profundos

### A "Sutileza" do CAN Bus
João explicou:
*   **CAN** é o *protocolo* (a linguagem).
*   **OBD** é o *hardware* (o conector).
*   **Oportunidade:** Existe um mercado de hardware proprietário aqui. Se instalarmos módulos OBD genéricos que mandam dados pra nossa nuvem, "quebramos" a dependência da John Deere.

### Simplificação Extrema (UX)
Rodrigo alertou sobre a dificuldade dos operadores (analfabetismo funcional ou tecnológico).
*   **Solução:** Dropdowns com nomes pré-definidos (Gleba Bonim 01). Nada de digitar texto livre.
*   **Login:** Autenticação via SMS ou link único por WhatsApp, sem e-mail/senha.

---

## 5. 📅 Plano de Ação Imediato (Pós-Reunião)

| Responsável | Ação | Status |
|---|---|---|
| **Rodrigo** | **Visita Presencial (Sexta):** Focar em *Ver* e *Fotografar*. Foto da balança (modelo), foto do caderno do Josmar, foto do painel das máquinas velhas. | 🚨 **CRÍTICO** |
| **Rodrigo** | **Pedir Acessos:** User "Leitor" no Vestro e Planilhas exemplo do Tiago. | Pendente |
| **Rodrigo** | **Estudar:** CAN Bus over Wifi/3G (para argumentar com Tiago sobre o hardware futuro). | Em andamento |
| **João** | **Arquitetura Vestro:** Desenhar o script de extração da planilha. | Backlog |

---

## ⚠️ Pontos de Atenção
*   **Expectativa vs Realidade (Histórico):** Cliente quer histórico de 10 anos. João alertou que limpar histórico é um projeto à parte (Fase 2). Focar no "daqui pra frente" primeiro.
*   **Hardware:** Não prometer o módulo OBD agora. É complexo e envolve compra de equipamento. Manter como "R&D" (Pesquisa e Desenvolvimento).

---
**Conclusão:** O caminho técnico está limpo. Não precisamos de APIs complexas agora (Vestro sai por planilha). O maior desafio será a **UX do Josmar (Secador)**: o formulário tem que ser à prova de falhas. A visita de sexta é crucial para validar isso.
