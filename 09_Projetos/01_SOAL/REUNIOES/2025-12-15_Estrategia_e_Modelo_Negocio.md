# Estratégia e Modelo de Negócio SOAL - 15/12/2025

**Participantes:** Rodrigo Kugler, João Vitor Balzer
**Data:** 15 de dezembro de 2025
**Tópico:** Definição estratégica do projeto SOAL e modelo de negócio para escala.

---

## 1. Contexto e Oportunidade (SOAL)
*   **Abertura:** O projeto na Fazenda Santana do Iapó (SOAL) é visto como a porta de entrada para um mercado maior. Claudio Kugler, tio de Rodrigo, é agricultor influente e conselheiro da Castrolanda.
*   **Cenário Atual:** A fazenda tem ~2.000 ha de área útil (4.000 ha total) e ~60 funcionários. Já utilizam tecnologia (AgriWin), mas foi um desenvolvimento financiado que se tornou um produto de terceiro.
*   **Visão de Longo Prazo:** Validar o produto na SOAL e escalar para os outros 100+ cooperados da região.

## 2. Modelo de Negócio e Precificação
*   **Debate Equity vs. Serviço:** João explicou os riscos de ter o cliente como "investidor/sócio" (perda de controle/equity).
*   **Modelo Definido:** **SaaS B2B (Consultoria + Mensalidade)**.
    *   **Setup/Onboarding (Consultoria):** Cobrar um valor inicial para o "Discovery" e personalização/instalação. Estimativa inicial de R$ 10.000,00 para validar viabilidade.
    *   **Recurring (Mensalidade/MRR):** Cobrança recorrente para manutenção, infraestrutura e suporte. Estimativa de R$ 1.500,00 a R$ 2.500,00 mensais por cliente.
*   **Escalabilidade (Matemática):**
    *   Cenário Conservador: 100 clientes x R$ 1.500 = R$ 150k/mês de faturamento recorrente.
    *   Custo de Infraestrutura: Possibilidade de "Clusterizar" os clientes em máquinas compartilhadas para reduzir o custo (Ex: De R$ 300/cliente para R$ 100/cliente).

## 3. Estratégia Técnica (SaaS vs IoT)
*   **Abordagem Técnica:** Focar na ponta da **Inteligência e Visualização de Dados** (ETL + Dashboards + IA).
*   **Decisão sobre Hardware (IoT):**
    *   **Não fabricar/manter hardware:** João e Rodrigo concordaram que manutenção de hardware físico (sensores, chips de gado) traz muita dor de cabeça operacional.
    *   **Estratégia:** Integrar com o IoT que já existe na fazenda (John Deere, sensores de poço, etc.) ou fechar parcerias com empresas de hardware para apenas *consumir* os dados via API.
*   **Customização:** Criar um "Core" padrão (SaaS) mas permitir módulos personalizados (Premium) para necessidades específicas (ex: quem tem Gado vs. quem tem só Plantio).

## 4. Próximos Passos (Ação)
*   **Deep Discovery Presencial:** Rodrigo fará uma imersão ("Home Office") na fazenda em Castro.
*   **Objetivo da Visita:**
    *   Não "vender", mas sim entender.
    *   Mapear dores reais e processos manuais.
    *   Investigar a engenharia de dados atual (de onde vem o dado da colheitadeira? do gado?).
    *   Identificar o "Padrão" que pode ser replicado para outros cooperados.

## 5. Insights Importantes
*   *"Nichar é o segredo do sucesso."* - Foco total no Agro da região.
*   *"Sem ETL não existe nada."* - O trabalho pesado será conectar as pontas soltas de dados.
*   O produto deve ser vendido como uma solução de **Sucesso do Cliente** (resolver a dor dele), e não apenas tecnologia por tecnologia.
