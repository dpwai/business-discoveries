# Figma Design Prompt: Gestão de Lavagem v3 (Central Administrativa)

## 🎯 Design Brief
**User:** **Administrativo da Lavagem (Gerente de Pátio).** Único usuário.
**Role:** Controlador de Tráfego Aéreo. Ele diz qual carro vai para qual lavador.
**Goal:** Maximizar a produção dos 5 funcionários (2 Ext + 3 Int) sem deixar carro parado.
**Visual Style:** Desktop Dashboard. High density information. "Kanban Master".

---

## 📐 Layout Structure

### 1. HEADER: Status de Pátio
- **Left:** "Painel de Controle - Lavagem"
- **Metrics:**
    - 🚿 **Externa (2 Vagas):** 🟢 Ocupadas (Corolla, Toro) | Próximo Libera: 10min.
    - 🧽 **Interna (3 Vagas):** 🟡 2/3 Ocupadas | 1 Livre.
    - 🏁 **Prontos Hoje:** 8 Carros.

### 2. MAIN BOARD: O Fluxo de Trabalho (Kanban Horizontal)
*O Admin move os cards da esquerda para a direita.*

#### Coluna 1: Fila de Chegada (Backlog)
- Lista de carros que chegaram.
- *Ação Admin:* Priorizar (Arrastar pra cima).

#### Coluna 2: 🚿 Lavagem Externa (Max 2 Cards)
*Representa os 2 Lavadores.*
- **Slot A:** [ Card: HRV - 15min restantes ]
- **Slot B:** [ Card: Golf - 05min restantes ]
- *Regra ux:* Se tentar colocar um 3º carro, o sistema bloqueia (Capacidade Max Atingida).

#### Coluna 3: 🚦 Pulmão (Aguardando Interna)
- Carros que saíram do banho e esperam vaga na secagem.
- *Visual:* Se ficar muito cheio, fica vermelho (Gargalo).

#### Coluna 4: 🧽 Interna & Acabamento (Max 3 Cards)
*Representa os 3 Funcionários de acabamento.*
- **Slot C:** [ Card: Compass ]
- **Slot D:** [ Card: Fusca ]
- **Slot E:** [ -- VAZIO -- ]

#### Coluna 5: ✅ Vistoria Final
- Carros prontos esperando o "OK" do Admin.
- *Botão:* "Checklist de Qualidade".

---

## 🖱️ Interaction Design (O Admin no Comando)
- **Drag & Drop:** A interação principal. O Admin arrasta o carro de "Fila" para "Lavagem Externa".
- **Timer Visual:** Ao soltar o card na coluna "Lavagem", inicia um timer progressivo (ex: uma barra enchendo em volta do card).
    - Isso ajuda o Admin a saber **quem está demorando** sem precisar perguntar.
- **Alertas:** Se o Slot A estourou o tempo (ex: >40min num banho), o card pisca em amarelo para o Admin ir lá ver o que houve.
