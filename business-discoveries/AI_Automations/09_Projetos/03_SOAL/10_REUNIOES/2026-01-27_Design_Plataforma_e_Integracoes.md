# Registro de Reunião: Design da Plataforma e Integrações
**Data:** 27/01/2026
**Participantes:** João Vitor Balzer, Rodrigo Kugler
**Projeto:** SOAL (DeepWork AI)

---

## 1. Resumo Executivo
Reunião focada na definição da arquitetura de informação e design da plataforma. Decidiu-se por uma estrutura hierárquica baseada em **"Organizações"** para garantir granularidade e isolamento de dados (superando limitações do AGwin).
O foco do produto foi reafirmado como **Business Intelligence & Data Warehousing**, evitando transformar a solução em um "ERP Fiscal" emissor de notas (NF/MDF-e) neste momento, dado o risco e complexidade.

---

## 2. Decisões de Arquitetura e Design
### Diagrama de Entidades (Granularidade)
*   **Estrutura:** Proprietário -> Organizações (Múltiplas) -> Usuários / Formulários / Integrações / Dashboards.
*   **Justificativa:** Diferente do modelo simples de "Propriedade", o conceito de "Organização" permite um diagrama de entidades mais robusto, onde cada unidade de negócio tem seus próprios dados e acessos.

### UX/UI e Dashboards
*   **Master Panel:** Visão customizável ("o que preciso ver hoje").
*   **Painéis de Gestão (Navegação):**
    1.  Contas a Pagar
    2.  Contas a Receber
    3.  Maquinário
    4.  Estoque
    5.  Portfólio de Venda
*   **Chat de Dados:** Implementação de interface de chat (texto/áudio) para consultas rápidas ("Qual o total a pagar hoje?"), abstraindo a necessidade de navegar por telas complexas.
*   **Crítica ao Legado:** O concorrente (AGwin) possui interface confusa e dados irrelevantes (ex: clima em destaque desnecessário). A DeepWork deve focar em "Actionable Insights".

---

## 3. Regras de Negócio e Modelo Comercial
### Onboarding e Integrações
*   **Estratégia:** O Onboarding não é apenas setup, é um serviço de consultoria de dados.
*   **Customização:** Dashboards e workers de coleta (Python) serão 100% personalizados para a realidade do cliente.
*   **Monetização:** O setup inicial cobre a construção dos workers atuais. Novas integrações futuras (ex: adquirir uma nova marca de trator) serão cobradas como serviço extra.

### Coleta de Dados
*   **Camadas:** Raw (Bruto) -> Bronze (Refinado) -> Diamante (Business Intelligence).
*   **Engenharia Reversa:** O processo de desenvolvimento partirá do "Dashboard Desejado" para trás, mapeando quais dados precisam ser coletados (Balança, Secador, John Deere, Planilhas) para alimentar aquela visão.
*   **Flexibilidade:** Entrada de dados via API, Scrapers ou até upload de CSV/Planilhas (mantendo padrão de pastas).

---

## 4. Pauta Fiscal (Risco e Escopo)
*   **Decisão:** Não priorizar a emissão de Nota Fiscal (NF/MDF-e) na V1.
*   **Motivo:** Risco fiscal elevado e desvio do core business (Inteligência de Dados).
*   **Mitigação:** Se o cliente exigir, buscar parceiro integrador via API ou tratar como funcionalidade de V2. O valor da DeepWork está na *análise* do dado, não na *burocracia* da emissão.

---

## 5. Próximos Passos
1.  **Validação Fiscal (Rodrigo):** Confirmar com o cliente SOAL a real dependência da emissão de NF pela plataforma ou se processos atuais podem ser mantidos.
2.  **Design (Figma):** Iniciar prototipação das telas do Master Panel e Contas a Pagar (usando IA/Cloud Code para acelerar).
3.  **Mapeamento de Dados:** Listar fontes de dados do piloto (Balança/Secador) para desenhar os primeiros workers.
