# Guia de Orçamento e Precificação de BI - Deepwork AI Flows

Este guia destina-se a orientar a precificação de projetos de **Business Intelligence (BI)**, alinhando as práticas de mercado com a visão de negócio da **Deepwork** e os padrões técnicos definidos.

---

## 1. Visão Estratégica: BI como Ferramenta de Performance

A Deepwork não vende "horas de dashboard", vende **controle**.

*   **O Cliente não quer:** Um gráfico de pizza bonito.
*   **O Cliente quer:** Saber onde está perdendo dinheiro e onde pode ganhar mais.
*   **Argumento Matador:** *"Um dashboard simples começa na faixa de X horas, mas o custo real depende do número de fontes e da complexidade do dado. O valor está na estrutura de dados segura e atualizada que alimenta o dashboard."*

---

## 2. Padrão Deepwork de Orçamento (Tabela Base)

Use esta tabela como referência para compor os orçamentos.

### A. Custos de Setup (Únicos)

| Item | Descrição | Estimativa (Horas) |
| :--- | :--- | :--- |
| **Descoberta & Mapeamento** | Entendimento do negócio, levantamento de fontes, métricas, lifecycle, segurança. | **6 – 8h** |
| **ETL – Fonte 1** | Extração + Transformação + Carga (Primeira fonte de dados). | **6 – 10h** |
| **ETL – Fonte 2+** | Extração + Transformação + Carga (Para cada fonte adicional). | **4 – 8h** |
| **BI – Dashboard Operacional** | Até 10 métricas, filtros básicos, foco no dia-a-dia. | **6 – 8h** |
| **BI – Dashboard Gestão** | Consolidação, cruzamento de dados, KPIs executivos. | **8 – 12h** |

> **Regra de Ouro:** Cada fonte nova de dados = nova linha de orçamento de ETL.

---

### B. Custos Recorrentes (Mensal)

Estes são os custos reais de infraestrutura para manter a inteligência rodando.

| Item | Valor (Estimado) | Notas |
| :--- | :--- | :--- |
| **PostgreSQL Gerenciado** | ~US$ 15,00 / mês | DigitalOcean (Banco de dados seguro). |
| **VPS n8n** | ~US$ 6,00 - 12,00 / mês | Servidor de automação (isolada ou rateada). |
| **Backup** | Incluso | Geralmente incluso no serviço gerenciado. |
| **Manutenção Técnica** | 2 - 6h / mês | Opcional (mas recomendado para ajustes/evolução). |

---

## 3. Taxa Horária e Mercado

Valores de referência para multiplicar pelas horas estimadas acima.

### Taxa Deepwork (Referência Prática)
Escolha uma faixa baseada na complexidade e mantenha. **Evite negociar hora a hora.**

*   **Pleno:** R$ 120 – R$ 180 / hora
*   **Sênior:** R$ 180 – R$ 300 / hora

### Comparativo de Mercado (Brasil)
*   **Freelancer Jr:** R$ 50 - R$ 80/h (Risco alto de entrega).
*   **Consultor Sr:** R$ 150 - R$ 250/h (Média de mercado para sênior).
*   **Agências:** R$ 300+/h (Custo de estrutura alto).

---

## 4. Exemplo Real: Concessionária (NBS / Oficina)

Exemplo prático de como aplicar a tabela acima.

**Cenário:**
1.  **Fonte 1 (NBS):** Sistema de oficina (Banco/API). Conteúdo: veículo_id, status, datas, etapa.
2.  **Fonte 2 (Planilha):** Controle manual de SLA. Conteúdo: motivos de atraso, observações.

**Cálculo de Esforço:**

| Etapa | Detalhe | Estimativa |
| :--- | :--- | :--- |
| **ETL 1 (NBS)** | Conexão API/Banco + Tratamento | 8 – 10h |
| **ETL 2 (Planilha)** | Tratamento + Carga | 4 – 6h |
| **Dashboards** | Operacional (Status, Carros parados) + Gestão (SLA, Gargalos) | 14 – 18h |
| **TOTAL** | | **~26 – 34h** |

*Valor aproximado (Taxa Pleno R$ 150/h):* **R$ 3.900 – R$ 5.100 (Setup)** + Recorrência.

---

## 5. Regras para Evitar Dor de Cabeça

1.  **Descoberta é Paga:** O tempo gasto para entender o problema já é consultoria.
2.  **Escopo Fechado = Preço Fechado:** Se o cliente quer preço fixo, o escopo não muda.
3.  **Aditivos:** Nova fonte de dados ou métrica complexa não prevista = Custo Adicional.
4.  **Segurança:** Banco de Dados (Postgres) sempre gerenciado e separado do orquestrador (n8n).
5.  **Propriedade:** O BI é uma visão dos dados. A inteligência (ETL/Estrutura) é o ativo valioso.

---

## 6. Modelos de Contratação

### Modelo 1: Setup + "Data as a Service" (Recomendado)
*   **Setup:** Valor fechado das horas de implementação (Tabela Base).
*   **Fee Mensal:** Custos de Infra (USD) + Pacote de Manutenção (ex: 4h/mês) + Lucro.
*   *Vantagem:* Cria recorrência e mantém o cliente próximo para upgrades (Agentes AI).

### Modelo 2: Projeto Turnkey (Entregou, Tchau)
*   **Preço:** (Total de Horas x Valor Hora) + 30% Margem de Risco.
*   *Desvantagem:* Perde a continuidade e a venda de futuros agentes.

---

## 7. Como Calcular (Resumo)

1.  **Liste as Fontes:** Quantos sistemas/planilhas diferentes?
2.  **Aplique a Tabela Padrão:** (X fontes * horas ETL) + (horas Dash).
3.  **Adicione Margem:** +10-20% de segurança.
4.  **Some a Infra:** Calcule o custo mensal em Dólar e converta.
5.  **Apresente:** Setup (Investimento Único) + Mensalidade (Manutenção e Infra).
