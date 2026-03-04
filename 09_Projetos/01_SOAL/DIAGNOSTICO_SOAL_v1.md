# RELATÓRIO DIAGNÓSTICO

**Serra da Onça Agropecuária LTDA (SOAL)**

---

**Data Intelligence e Transformação Operacional**

Preparado por: DeepWork AI Flows
Data: 29/01/2026
Versão: 1.0

---

*"Transformando intuição em precisão"*

---

## Sumário Executivo

### Contexto

A Serra da Onça Agropecuária (SOAL) opera aproximadamente 2.150 hectares de produção de grãos na região de Piraí do Sul, Paraná. A operação combina agricultura (soja, milho, feijão), beneficiamento de grãos, pecuária de corte e gestão de frota mecanizada. O faturamento agrícola anual gira em torno de R$ 20 milhões, com compromissos financeiros de R$ 32 milhões para a safra 2025/26.

### Desafio Central

A operação gera dados valiosos em múltiplas fontes (John Deere Operations Center, Vestro, Balança e Planilhas de Controle). A oportunidade é criar uma camada de integração que conecte essas fontes — incluindo os controles desenvolvidos pela equipe — em um Data Warehouse que reflita a realidade operacional. Os processos e planilhas já consolidados pela equipe passarão a alimentar uma infraestrutura centralizada, elevando controles que já funcionam bem para um novo patamar de visibilidade.

### Principais Descobertas

- A equipe desenvolveu controles próprios em Excel que complementam o ERP (AgriWin), demonstrando capacidade de adaptação e rigor na gestão. Esses controles paralelos representam conhecimento valioso que pode ser integrado em uma visão consolidada.

- O processo de abastecimento de combustível passa por múltiplas etapas de validação: operador lança no app Vestro, Tiago exporta e enriquece os dados com contexto operacional, e Valentina consolida no AgriWin. Existe oportunidade de automatizar esse fluxo, liberando tempo da equipe para atividades de maior valor.

- Os dados de telemetria do John Deere contêm informações ricas de campo. A padronização dos nomes de talhões (hoje com variações como "Bonim", "Boninho", "Bonin lado esquerdo") permitirá análises históricas que hoje exigiriam consolidação manual.

- A recepção de grãos no secador é controlada de forma consistente por Josmar através de anotações em caderno. A digitalização desse processo preservaria esse conhecimento e facilitaria consultas futuras.

- A fazenda possui 28 anos de dados históricos (desde 1996), um ativo valioso que pode ser estruturado para análises preditivas e tomada de decisão.

### Direção Recomendada

Construir um Ecossistema de Dados que integre as fontes existentes (Vestro, Máquinas, controles da equipe) em uma visão consolidada. Implementar arquitetura Medallion (Bronze/Silver/Gold) preservando as regras de validação e enriquecimento que a equipe já aplica. O novo sistema será a camada de integração que conecta os investimentos já realizados, oferecendo visibilidade de custo por hectare e eficiência operacional.

### Resultado Esperado

Em 90 dias, a operação terá visibilidade em tempo real do custo por hectare por cultura, eliminação do retrabalho manual de correção e digitação de dados de combustível, e uma base estruturada para escalar a integração com outras fontes de dados.

---

## Análise do Estado Atual

### Contexto Operacional

A SOAL é uma operação agrícola de referência na região. A empresa investiu de forma consistente em equipamentos de ponta (mais de R$ 20 milhões em maquinário John Deere, R$ 20 milhões no secador) e foi reconhecida como "modelo de atuação" pela John Deere devido ao uso avançado de telemetria.

O próximo passo natural dessa evolução é conectar os dados gerados por esses investimentos em uma visão unificada, permitindo que a gestão financeira e operacional acompanhe o nível de sofisticação já alcançado no campo.

**Escala da Operação**

| Métrica | Valor |
|---------|-------|
| Área agrícola total | 2.150 ha |
| Soja | 1.800 ha |
| Milho | 373 ha |
| Feijão | 177 ha |
| Faturamento agrícola 2024 | R$ 20M |
| Compromissos safra 25/26 | R$ 32M |
| Investimento em maquinário | R$ 20M+ |
| Investimento em secador | R$ 20M |
| Dados históricos disponíveis | 28 anos (desde 1996) |

**Stakeholders Mapeados**

| Nome | Função | Responsabilidades | Relevância para o Projeto |
|------|--------|-------------------|--------------------------|
| Claudio Kugler | Diretor/Proprietário | Decisões estratégicas, relacionamento Castrolanda | Principal usuário do dashboard. Quer custo em tempo real. |
| Claudio Kugler | Diretor/Proprietário | Decisões estratégicas, relacionamento Castrolanda | Principal usuário do dashboard. Quer custo em tempo real. |
| Valentina | Administrativa | Contas pagar/receber, banco, **Entrada de Notas Fiscais** | Usuária-chave. O input de notas é seu maior gargalo manual. |
| Vanessa | Operacional | Balança, Consolidação de Cadernos de campo (máquinas) | Responsável pelas entradas de dados físicos da operação. |
| Tiago Kwasnieski | Gerente de Máquinas | Tecnologia, manutenção, otimização de frota | Champion técnico interno. Mantém planilha mestre de frota. |
| Alessandro | Agrônomo | Receituário agronômico, defensivos | Fonte de dados de insumos e aplicações. |
| Josmar | Operador Secador | Recepção física de grãos | Opera o secador. Os dados do caderno são geridos pela Vanessa. |

### Sistemas e Paisagem de Dados

| Sistema | Função | Qualidade dos Dados | Status de Integração | Observações |
|---------|--------|---------------------|---------------------|-------------|
| AgriWin | ERP financeiro e operacional | Média | Isolado | Sistema oficial para registro. Histórico acessível de 2 anos. |
| SharePoint (Excel) | Planejamento financeiro | Alta | Isolado | Fonte de verdade para contas pagar/receber e orçamento. |
| Castrolanda | Insumos e vendas | Alta | Via AgriWin (API existe) | Dados de insumos, financiamentos, saldo cooperativa. |
| John Deere Operations Center | Telemetria de máquinas | Alta (operacional) | Isolado | Dados de campo ricos. Oportunidade de padronizar nomenclatura de talhões. |
| Vestro | Abastecimento combustível | Média | Manual (Excel) | App funciona, mas dados precisam correção manual. |
| Caderno Josmar | Recepção de grãos | Alta (consistência) | Manual | Controle confiável mantido por Josmar. Oportunidade de digitalização. |

### Mapeamento de Processos-Chave

**Processo 1: Cálculo de Custo por Hectare**

- **Fluxo Atual:** Claudio acessa Castrolanda para ver insumos, abre AgriWin para diesel e manutenção, consulta Excel para mão-de-obra e arrendamentos. Manualmente divide valores por área plantada. Calcula sacas necessárias para cobrir custo. Compara com preço de mercado para estimar margem.

- **Oportunidade de Melhoria:** Os dados existem em três sistemas. Uma visão consolidada permitiria que o cálculo — hoje feito manualmente em "meio dia" — estivesse disponível instantaneamente.

- **Processo Atual:** Claudio realiza o cálculo quando a agenda permite, geralmente antes de reuniões com banco ou cooperativa.

- **Benefício Potencial:** Decisões de compra de insumos, venda de produção e planejamento de safra poderiam contar com visibilidade contínua do custo real.

**Processo 2: Gestão de Notas Fiscais (Valentina)**

- **Fluxo Atual:** Valentina recebe notas (físicas/digitais), confere e lança manualmente no AgriWin e planilhas. Processo repetitivo e crítico para o financeiro.
- **Oportunidade:** Automação via leitura de XML/OCR em pasta monitorada.
- **Benefício:** Valentina foca em conferência e análise financeira, não em digitação.

**Processo 3: Gestão de Dados de Campo (Vanessa)**

- **Fluxo Atual:** Vanessa consolida os apontamentos físicos (cadernetas de maquinário e caderno da balança/secador) para os controles digitais.
- **Oportunidade:** Aplicação mobile simples para coleta na fonte ou digitalização direta, eliminando a "digitação do papel".
- **Benefício:** Dado disponível em tempo real e fim do acúmulo de papel para digitar no fim do mês.

**Processo 2: Fluxo Vestro para AgriWin (Combustível)**

- **Fluxo Atual:** Operador abastece e lança no app Vestro. Tiago exporta Excel a cada 15-30 dias, revisa os dados, enriquece com informações contextuais (fazenda, operação) que o Vestro não captura nativamente, e envia para Valentina. Valentina consolida no AgriWin para custeio.

- **Oportunidade de Melhoria:** O processo de validação e enriquecimento que Tiago faz manualmente pode ser automatizado, mantendo as mesmas regras de negócio que ele já aplica. Isso liberaria tempo de Tiago e Valentina.

- **Conhecimento Valioso:** Tiago desenvolveu expertise em identificar inconsistências de horímetro pelo padrão. Essa lógica pode ser codificada em regras automáticas de validação.

- **Benefício Potencial:** O custo de combustível por máquina, hoje disponível com algumas semanas de atraso, poderia estar atualizado diariamente.

**Processo 3: Recepção de Grãos no Secador**

- **Fluxo Atual:** Caminhão chega com carga. Josmar pesa na balança. Anota em caderno: placa, peso, umidade, origem (talhão). No fim do dia ou semana, dados são passados para sistema (ou não).

- **Oportunidade de Melhoria:** O registro em caderno funciona de forma confiável. A digitalização preservaria esse controle e adicionaria consulta em tempo real e histórico facilmente acessível.

- **Método Consolidado:** Josmar mantém o caderno organizado com uma lógica própria consistente. Qualquer solução digital deve respeitar essa ordem de campos que já funciona.

- **Benefício Potencial:** Claudio teria visibilidade em tempo real do que entrou no secador, e a reconciliação com notas fiscais seria facilitada.

### Controles Desenvolvidos pela Equipe

Uma das descobertas mais valiosas do processo de discovery foi identificar os controles que a equipe desenvolveu ao longo dos anos para gestão do dia-a-dia:

**Planilha Mestre do Tiago**

Tiago desenvolveu uma planilha Excel robusta para gestão de frota. Esta planilha contém:
- Consumo validado por máquina
- Histórico de manutenções
- Análise comparativa de eficiência entre tratores

Foi através desta planilha que Tiago identificou que tratores de 170cv são mais eficientes que os de 210cv para certas operações — uma descoberta que gerou economia significativa na estratégia de compra. Este tipo de análise demonstra o valor dos controles que a equipe já mantém.

**Planilhas do SharePoint (Valentina/Claudio)**

O planejamento financeiro da operação é gerido através de Excel no SharePoint:
- Contas a pagar (programação semanal)
- Contas a receber
- Orçamento anual (R$ 32M em compromissos)
- Folha de pagamento

Este controle estruturado, desenvolvido pela equipe, representa uma base sólida que pode ser integrada ao Data Warehouse.

**Caderno do Josmar**

A entrada de grãos no secador é registrada de forma consistente por Josmar em caderno físico. Este registro:
- É a fonte primária de dados de recepção
- Segue uma metodologia própria e organizada
- Representa conhecimento operacional que pode ser preservado e ampliado através de digitalização

---

## Oportunidades Identificadas

### Oportunidade 1: Visão Consolidada de Custos

**Contexto:** A operação gera dados valiosos em cinco sistemas diferentes. Cada sistema foi adquirido para atender uma necessidade específica (ERP, combustível, telemetria) e cumpre bem sua função individual.

**Necessidade Expressa:** Citação direta de Claudio Kugler: "Eu queria estar olhando numa tela e dizendo: até agora o meu custo de soja tá assim. Eu não consigo enxergar isso hoje, eu não tenho." Esta frase foi repetida quatro vezes durante a sessão de discovery.

**Contexto Técnico:** Os sistemas atuais foram implementados em momentos diferentes, cada um resolvendo uma necessidade imediata. A oportunidade agora é criar uma camada de integração que conecte esses investimentos já realizados.

**Valor para o Negócio:** Com visão consolidada, decisões de compra de insumos, venda de produção e planejamento de caixa teriam base completa de informação. O cálculo de custo por hectare, hoje feito pontualmente em "meio dia de trabalho", estaria disponível instantaneamente.

**Prioridade:** Alta

---

### Oportunidade 2: Automação do Fluxo de Combustível

**Contexto:** O processo de registro de abastecimento passa por múltiplas etapas de validação e enriquecimento, garantindo qualidade dos dados.

**Processo Atual:** Tiago exporta Excel do Vestro, revisa os dados aplicando seu conhecimento (identifica valores de horímetro inconsistentes), enriquece com informações contextuais (fazenda, operação), e Valentina consolida no AgriWin. Este fluxo garante dados confiáveis.

**Conhecimento a Preservar:** Tiago desenvolveu critérios de validação baseados em sua experiência — por exemplo, identificar horímetros fora do padrão esperado. Essas regras são valiosas e podem ser codificadas.

**Valor para o Negócio:** Automatizar esse fluxo, mantendo as mesmas validações que Tiago aplica, liberaria horas mensais de Tiago e Valentina para atividades de maior valor. O custo de combustível por operação estaria disponível com atualização diária em vez de semanas.

**Prioridade:** Alta

---

### Oportunidade 3: Padronização de Nomenclatura para Análise Histórica

**Contexto:** Os dados de operações de campo no John Deere Operations Center são ricos em informação. A nomenclatura de talhões varia porque o sistema permite entrada livre de texto e os operadores registram de formas diferentes.

**Situação Atual:** Tiago identificou que o mesmo talhão pode aparecer como "Bonim", "Boninho", "Bonin lado esquerdo" e outras variações — algo natural quando múltiplos operadores registram informações em campo.

**Solução Proposta:** Criar uma tabela DE-PARA que normalize essas variações automaticamente. Assim, perguntas como "qual foi a produtividade do talhão Bonim nos últimos 5 anos?" poderão ser respondidas sem trabalho manual.

**Valor para o Negócio:** O investimento em telemetria avançada (R$ 20M+ em maquinário) poderá gerar análises históricas que hoje exigiriam consolidação manual extensiva.

**Prioridade:** Alta

---

### Oportunidade 4: Digitalização da Recepção de Grãos

**Contexto:** A entrada de grãos no secador é controlada de forma consistente por Josmar através de anotações em caderno — um processo que funciona de forma confiável.

**Processo Atual:** Josmar registra: placa do caminhão, peso, umidade, origem (talhão). Este registro manual segue uma metodologia própria e organizada que ele desenvolveu ao longo do tempo.

**Valor do Processo Existente:** O método de Josmar funciona. Qualquer solução digital deve preservar a lógica e a ordem de campos que ele já utiliza, facilitando a adoção.

**Valor para o Negócio:** A digitalização adicionaria consulta em tempo real do que entrou no secador, histórico facilmente acessível, e reconciliação automática com notas fiscais — sem mudar a forma como Josmar trabalha.

**Prioridade:** Média

---

### Oportunidade 5: Valorização dos 28 Anos de Dados Históricos

**Contexto:** A fazenda possui registros de produtividade, rotação de culturas e resultados por gleba desde 1996 — um ativo raro no setor.

**Diferencial:** Como Claudio observou: "Isso não é todo produtor que tem." Exemplo: Gleba Lagoa (24ha) tem registros de produção desde 2016, permitindo análise de tendência.

**Situação Atual:** Os dados estão preservados em formatos diversos (pastas, planilhas) acumulados ao longo de 28 anos de operação cuidadosa.

**Valor para o Negócio:** Estruturar esses dados em um Data Lake abriria possibilidades de modelos preditivos de produtividade, otimização de rotação de cultura e alocação de insumos. Este histórico representa uma vantagem competitiva significativa.

**Prioridade:** Oportunidade estratégica

---

### Visão da Arquitetura de Dados

**Estado Atual: Múltiplas Fontes Especializadas**

![Landscape de Dados Atual](./assets/fragmented_data_landscape.png)

**Estado Proposto: Integração via Data Warehouse**

![Ecossistema de Dados Unificado](./assets/unified_data_ecosystem.png)

### Mapa de Oportunidades

| Oportunidade | Processo Atual | Evolução Proposta | Valor Agregado |
|--------------|----------------|-------------------|----------------|
| Dashboard Custo/ha | Cálculo manual consolidado | Atualização automática diária | 20+ horas/mês liberadas |
| Automação Vestro | Validação manual por Tiago | Validação automática com mesmas regras | 15+ horas/mês liberadas |
| Normalização John Deere | Nomenclatura variada | Tabela DE-PARA automática | Análise histórica por talhão |
| Digitalização Secador | Caderno organizado por Josmar | App que preserve o mesmo fluxo | Consulta em tempo real + histórico |
| Análise Histórica 28 anos | Dados preservados em arquivos | Data Lake estruturado | Modelos preditivos de produtividade |
| Automação Notas (Valentina) | Input manual repetitivo | Leitura automática de XML/OCR | Redução de erro e ganho de tempo |
| Balança e Cadernetas (Vanessa) | Consolidação de cadernos físicos | Digitalização direta ou app | Dado disponível em tempo real |

### Inventário de Entradas de Dados (Data Input Inventory)

Para garantir a integridade do Data Warehouse, mapeamos todas as fontes que alimentarão o sistema:

**Entradas Automáticas (Integrações)**
1.  **John Deere Operations:** Telemetria, mapas de colheita/plantio (API).
2.  **Castrolanda:** Compras de insumos, vendas de grãos (API/Portal).
3.  **Vestro:** Abastecimentos de combustível, horímetros (API/Scraper).

**Entradas Manuais (Atuais -> Futuras)**
1.  **Notas Fiscais de Entrada:**
    *   *Hoje:* Digitação manual (**Valentina**).
    *   *Futuro:* Leitura de XML/OCR automática em pasta monitorada.
2.  **Balança (Recepção de Grãos):**
    *   *Hoje:* Caderno físico (Vanessa/Josmar).
    *   *Futuro:* App tablet na balança ou digitação web simplificada.
3.  **Cadernetas de Maquinário (Apontamentos):**
    *   *Hoje:* Papel -> Planilha (**Vanessa**).
    *   *Futuro:* App mobile "Operador POV" (simplificado).
4.  **Planilha Mestre de Frota (Tiago):**
    *   *Hoje:* Excel com regras de negócio.
    *   *Futuro:* Regras migradas para o banco, input apenas de exceções.
5.  **Financeiro Macro (Valentina):**
    *   *Hoje:* Excel/SharePoint.
    *   *Futuro:* Conexão direta ou input estruturado no sistema.

*Nota: Campos específicos de cada entrada manual serão validados na Fase 1.*

---

## Solução Proposta

### Abordagem Estratégica

A transformação será conduzida através da metodologia de 4 Dimensões, que garante que a solução técnica esteja alinhada com a realidade operacional:

**1. Dimensão Humana**

Respeitar os processos que a equipe já desenvolveu e desenhar interfaces que sigam o fluxo mental dos usuários. O app de entrada de dados deve seguir a ordem que Josmar já usa no caderno. A automação deve liberar tempo, não criar novos passos.

**2. Dimensão Física**

Considerar as condições de campo: conectividade variável (Starlink em áreas remotas), dispositivos de diferentes gerações (celular do operador vs tablet da empresa), ambiente hostil (poeira, graxa, vibração).

**3. Dimensão de Engenharia de Dados**

Construir pipeline ETL robusto preparado para a realidade do campo: variações de conectividade e dados que precisam de validação. Estratégia offline-first para coleta em campo. Validações automáticas na camada Silver aplicando as mesmas regras que a equipe já utiliza.

**4. Dimensão de Lógica de Negócio**

Documentar e codificar as "regras de ouro" do Claudio: como ratear diesel, como alocar custo fixo, regime de caixa vs competência. Essas regras são o "segredo do molho" que torna os dados úteis.

### Implementação em Fases

**Fase 1: Fundação (MVP)**

Escopo:
- Integração automatizada do Vestro com correção de horímetro
- Dashboard de custo por hectare consolidando Castrolanda + SharePoint + Vestro
- Tabela DE-PARA para normalização de nomes de talhões

Entregáveis:
- Pipeline N8N coletando dados diariamente
- PostgreSQL com camadas Bronze e Silver
- Dashboard Power BI com custo/ha por cultura
- Comparativo com preço de mercado e margem projetada

Critérios de Sucesso:
- Claudio acessa custo atualizado em menos de 5 minutos
- Tiago tem tempo liberado da correção manual de planilha Vestro
- Valentina tem tempo liberado da digitação de dados de combustível

**Fase 2: Expansão**

Escopo:
- Integração completa John Deere Operations Center
- Digitalização da recepção de grãos (app ou OCR do caderno)
- Automação de notas fiscais (pasta monitorada + OCR)

Entregáveis:
- API John Deere conectada ao Data Warehouse
- App mobile para Josmar (entrada de grãos)
- Automação de leitura de PDF de notas fiscais

**Fase 3: Inteligência**

Escopo:
- Migração dos 28 anos de dados históricos
- Modelos preditivos de produtividade por gleba
- ChatGPT MCP para consultas em linguagem natural
- Alertas proativos via WhatsApp

Entregáveis:
- Data Lake com histórico completo desde 1996
- Modelo de previsão de safra por gleba
- Interface conversacional para consulta de dados
- "Morning Briefing" automático via áudio WhatsApp

### Arquitetura Técnica

Tecnologias selecionadas:

| Função | Ferramenta | Justificativa |
|--------|------------|---------------|
| ETL/Automação | N8N | Prototipagem rápida, foco em regra de negócio, migrável para Python |
| Banco de Dados | PostgreSQL | Baixo custo, robusto, suporta arquitetura Medallion |
| BI/Visualização | Power BI | Cliente já conhece, rápido de implementar |
| IA/Consultas | ChatGPT Plus + MCP | Interface natural, sem necessidade de treinamento |
| Coleta Campo | App PWA ou AppSheet | Funciona offline, interface simples |

---

## Esforço e Investimento

### Detalhamento do Esforço da Equipe de Discovery

| Atividade | Descrição | Horas Estimadas |
|-----------|-----------|-----------------|
| Discovery e Mapeamento | Entendimento do negócio, levantamento de fontes, definição de métricas, requisitos de segurança | 6 - 8h |
| ETL - Vestro (Combustível) | Conexão com portal, tratamento de horímetro, carga automática | 6 - 10h |
| ETL - Castrolanda/AgriWin | Integração via API existente, mapeamento de campos | 6 - 10h |
| ETL - SharePoint (Excel) | Conexão direta, monitoramento de alterações | 4 - 8h |
| ETL - John Deere | API de telemetria, normalização de talhões | 6 - 10h |
| Dashboard Operacional | Custo/ha por cultura, comparativo mercado, até 10 métricas | 6 - 8h |
| Dashboard Operacional | Custo/ha por cultura, comparativo mercado, até 10 métricas | 6 - 8h |
| Dashboard Gestão | Consolidação executiva, KPIs estratégicos, drill-down | 8 - 12h |
| Mapeamento Notas (Valentina) | Detalhar fluxo de XML e processo de aprovação | 3 - 5h |
| Mapeamento Campo (Vanessa) | Detalhar fluxo Balança e Cadernos | 3 - 5h |

### Estimativa do Projeto SOAL - Fase 1 (MVP)

| Componente | Horas (Range) | Investimento (R$) |
|------------|---------------|-------------------|
| Discovery e Mapeamento | 6 - 8h | R$ 900 - R$ 1.440 |
| ETL Vestro | 8 - 10h | R$ 1.200 - R$ 1.800 |
| ETL Castrolanda/AgriWin | 6 - 8h | R$ 900 - R$ 1.440 |
| ETL SharePoint | 4 - 6h | R$ 600 - R$ 1.080 |
| Dashboard Custo/ha | 8 - 10h | R$ 1.200 - R$ 1.800 |
| **Total Setup Fase 1** | **32 - 42h** | **R$ 4.800 - R$ 7.560** |

*Cálculo baseado em taxa de R$ 150/hora (faixa Pleno)*

### Custos Recorrentes

| Item | Custo Mensal | Observações |
|------|--------------|-------------|
| PostgreSQL Gerenciado | ~US$ 15 (~R$ 75) | DigitalOcean, instância dedicada |
| VPS para N8N | ~US$ 10 (~R$ 50) | Servidor de automação |
| Manutenção Técnica | 4h/mês (~R$ 600) | Ajustes, monitoramento, evolução |
| **Total Mensal** | **~R$ 725** | Infraestrutura + manutenção básica |

### Referência de Taxas Horárias

| Nível | Taxa (R$/hora) |
|-------|----------------|
| Pleno | R$ 120 - R$ 180 |
| Sênior | R$ 180 - R$ 300 |

---

## Proposta de Valor

### Benefícios Quantificados

| Benefício | Processo Atual | Com Automação | Tempo Liberado |
|-----------|----------------|---------------|----------------|
| Cálculo de Custo/ha | Consolidação manual (~4h) | 5 minutos | ~16h/mês (4 cálculos) |
| Validação Vestro | Revisão manual por Tiago | Automático com mesmas regras | ~12h/mês |
| Consolidação AgriWin | Digitação por Valentina | Integração direta | ~8h/mês |
| Reconciliação de dados | Consulta em múltiplos sistemas | Visão unificada | ~8h/mês |
| Input Notas Fiscais (Valentina) | Digitação manual e conferência | Leitura automática | *A confirmar (Alto impacto)* |
| Input Cadernetas (Vanessa) | Transcrição papel -> sistema | Digitalização na fonte | *A confirmar* |
| **Total Horas Liberadas** | | | **~44h + Valentina + Vanessa** |

**Valor das Horas Liberadas:** 44h x R$ 50/hora (custo interno estimado) = **R$ 2.200/mês**

### Análise de ROI

- **Investimento Setup Fase 1:** R$ 6.000 (média do range)
- **Custo Mensal:** R$ 725
- **Economia Mensal:** R$ 2.200
- **Economia Líquida Mensal:** R$ 1.475
- **Payback:** 4.1 meses
- **Valor Líquido em 12 meses:** R$ 11.700

### Benefícios Intangíveis

**Velocidade de Decisão**

Hoje Claudio precisa "ter tempo" para calcular custo. Com o dashboard, a informação está disponível instantaneamente, permitindo decisões mais frequentes e melhor fundamentadas.

**Consistência Ampliada**

A validação automática de horímetro (usando as regras que Tiago já aplica) e a integração direta entre sistemas ampliam a consistência dos dados ao longo de todo o fluxo.

**Escalabilidade**

A metodologia e infraestrutura desenvolvidas para a SOAL podem ser replicadas para outros produtores da região, transformando o projeto em um produto comercializável.

**Preservação de Conhecimento**

Os 28 anos de metodologia do Claudio serão documentados e codificados, transformando conhecimento tácito em ativo da empresa.

**Vantagem Competitiva**

Poucos produtores da região têm capacidade de análise em tempo real. A SOAL poderá tomar decisões mais rápidas e precisas que a concorrência.

---

## Considerações e Planos de Contingência

| Consideração | Probabilidade | Impacto | Estratégia |
|-------|---------------|---------|-------------------------|
| Acesso à API Castrolanda | Média | Alto | Alternativa A: integração via portal. Alternativa B: upload de relatório exportado. |
| Curva de adaptação a novo sistema | Média | Médio | Interface que preserva fluxo mental atual. Treinamento hands-on. Resultados visíveis rapidamente. |
| Casos de horímetro fora do padrão da regra | Baixa | Médio | Regra de validação com threshold baseada no conhecimento do Tiago. Alertas para revisão quando necessário. |
| Variação de conectividade em campo | Alta | Baixo | Arquitetura offline-first. Sincronização automática quando conexão disponível. |
| Dados históricos em formatos diversos | Média | Médio | Fase de migração dedicada. Validação com Claudio dos dados prioritários. |

---

## Próximos Passos

### Ações Imediatas (Cliente)

1. **Claudio:** Fornecer contato técnico da Castrolanda para validação de API
2. **Tiago:** Enviar amostra da planilha Vestro corrigida e planilha de entrada de grãos
3. **Tiago:** Criar usuário convidado no portal Vestro para testes
4. **Claudio:** Confirmar se possui assinatura ChatGPT Plus para fase de IA

### Ações Imediatas (DeepWork)

1. Visita técnica presencial para documentar processo do Josmar e fotografar hardware da balança
2. Contato com suporte John Deere para documentação de API
3. Protótipo de dashboard de custo para validação visual com Claudio
4. Desenho técnico do pipeline Vestro (quick win)

### Pontos de Decisão

- [ ] Aprovar escopo e investimento da Fase 1
- [ ] Confirmar prioridade: Vestro primeiro ou Dashboard primeiro
- [ ] Agendar reunião de kickoff com stakeholders
- [ ] Definir frequência de atualização desejada (diária/semanal)
- [ ] Fornecer acessos aos sistemas (Vestro, SharePoint, AgriWin)

---

## Apêndices

### A. Stakeholders Entrevistados

| Data | Participante | Foco | Duração |
|------|--------------|------|---------|
| Dez/2025 | Claudio Kugler | Discovery geral, pain points, sistemas | 90 min |
| 29/12/2025 | Rodrigo + João (interno) | Decisões estratégicas, stack técnico | 40 min |
| 16/01/2026 | Tiago Kwasnieski + Claudio | Maquinário, Vestro, John Deere | 60 min |

### B. Sistemas com Acesso Necessário

| Sistema | Tipo de Acesso | Status |
|---------|---------------|--------|
| Vestro | Usuário + senha ou API | Pendente |
| John Deere Operations Center | Developer API keys | Pendente |
| Castrolanda | Validar API existente | Pendente |
| SharePoint | Acesso de leitura | Pendente |
| AgriWin | Validar se tem API ou apenas ODBC | Pendente |

### C. Glossário de Termos

| Termo | Definição |
|-------|-----------|
| Talhão | Unidade de área dentro da fazenda, usada para gestão agrícola |
| Horímetro | Contador de horas de funcionamento de uma máquina |
| Safra | Ciclo de produção agrícola, geralmente identificado pelo ano (ex: 25/26) |
| Custeio | Financiamento de curto prazo para insumos da safra |
| Romaneio | Documento de pesagem e classificação de grãos |
| UBG | Unidade de Beneficiamento de Grãos (secador e armazenagem) |
| Controles Complementares | Sistemas desenvolvidos pela equipe (planilhas, cadernos) que complementam os sistemas oficiais |
| Medallion | Arquitetura de Data Warehouse em camadas (Bronze/Silver/Gold) |

---

**Documento preparado por DeepWork AI Flows**

*Contato: Rodrigo Kugler | João Vitor Balzer*

---
