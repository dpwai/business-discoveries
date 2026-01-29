# Resultado da Pesquisa de Mercado: O Gap AgTech

Este documento consolida a pesquisa sobre as dores reais do setor, focando no "abismo" entre a alta tecnologia de campo e a gestão financeira/operacional.

## 📊 Tabela de Dores vs. Oportunidades (A Matriz do "Silent Killer")

| Dimensão | O "Silent Killer" (A Dor Real) | Impacto Financeiro | Oportunidade (Nossa Solução) |
| :--- | :--- | :--- | :--- |
| **Integração (Field-to-ERP)** | **O "Dado Órfão" de Combustível:** A máquina sabe quanto gastou, a nota fiscal diz quanto comprou, mas o ERP não cruza os dois. O roubo/desvio e a ineficiência vivem nesse gap. | 🔴 **ALTO** (Desvios de 5-10% no diesel são comuns) | **Cruzamento Automático:** Robô que lê o XML da NFe de compra e cruza com a telemetria da JD em tempo real. Alerta de discrepância. |
| **Shadow IT (Planilhas)** | **Custo Real da Safra (Feito à Mão):** O custo por talhão é calculado em Excel meses após a colheita. O produtor vende a safra sem saber a margem exata de cada pedaço de terra. | 🔴 **ALTO** (Venda com margem negativa sem saber) | **DRE por Talhão em Tempo Real:** Alocar custos de insumos e máquinas automaticamente para cada geometria de talhão. |
| **Cooperativa (Castrolanda)** | **A "Conta Corrente" Obscura:** O cooperado não tem um extrato unificado e em tempo real de quanto ele "deve" de insumos vs. quanto ele "tem" de grãos depositados. | 🟡 **MÉDIO** (Surpresas no fechamento mensal) | **"Open Banking" da Cooperativa:** Crawler/API que loga no portal da Castrolanda e traz o extrato para o celular do produtor diariamente. |
| **Fadiga de Dashboard** | **"Mais Telas, Menos Decisão":** O produtor não entra no sistema. Ele quer a resposta, não o gráfico. | 🟡 **MÉDIO** (Churn/Cancelamento do software) | **Zero-UI (Sem Interface):** Relatórios em Áudio (WhatsApp) e Push Notifications. "Claudio, o trator X parou." (Ação ativa). |
| **Manutenção** | **Preventiva que vira Corretiva:** A máquina avisa o código de erro, mas ninguém avisa a oficina/estoque de peças. A peça falta, a máquina para. | 🔴 **ALTO** (Máquina parada na colheita custa R$ milh/hora) | **Integração JD -> Estoque:** Código de erro amarelo na JD gera infra de requisição de peça no ERP automaticamente. |

---

## 🔍 Deep Dive: O Que Aprendemos

### 1. O Mito da Conectividade
*   **Realidade:** A internet na sede é boa, no campo é ruim.
*   **Ação:** Nossa solução deve ser "Store & Forward". Se o dado da máquina não chega agora, o do ERP (sede) chega. O cruzamento pode ter delay, mas deve ser automático assim que houver sinal.

### 2. Por que as Startups Falham?
*   **Motivo:** Criam soluções para problemas que *elas acham* que existem, não para o que o produtor *sente*.
*   **Exemplo:** Apps de "Caderno de Campo Digital" falham porque o operador não quer digitar no celular com a mão suja de graxa.
*   **Nossa Vacina:** Focar em dados passivos (que a máquina gera sozinha) e dados fiscais (que o administrativo é obrigado a lançar). Minimizar o input manual do campo.

### 3. As Planilhas "Imortais"
Identificamos que as planilhas mais vitais (e visadas para substituição) são:
1.  **Controle de Estoque Físico de Grãos** (Silo próprio vs. Cooperativa).
2.  **Fluxo de Caixa Real** (O que entrou na conta vs. o que é permuta/barter).
3.  **Manutenção de Frota** (Peças, pneus e óleo).

---

## 🚀 Próximos Passos (Validar na Visita)

1.  **Teste do Diesel:** Pedir para ver a planilha de controle de diesel e comparar com um relatório do MyJohnDeere na hora. Se der diferença, achamos ouro.
2.  **Teste da Cooperativa:** Pedir para ver como ele confere o saldo dele na Castrolanda. É um papel? Um site ruim?
3.  **Teste da Peça:** Perguntar: "Quando quebra uma correia, como a oficina sabe que precisa comprar outra para repor o estoque?"
