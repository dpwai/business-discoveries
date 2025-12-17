# Evolução e Primeiro Produto - 09/12/2024

**Participantes:** João Vitor Balzer, Rodrigo Kugler
**Tamanho das anotações:** Padrão

---

## Evolução e Primeiro Produto
João Vitor Balzer e Rodrigo Kugler conversaram sobre a evolução da empresa, com João Vitor Balzer expressando clareza na precificação do dashboard. Rodrigo Kugler afirmou que a obtenção do primeiro produto é uma questão de tempo e mencionou que sentaria para estudar o N8N, que João Vitor Balzer confirmou ser a tecnologia padrão para o MVP (00:00:00).

## Precificação e Fontes de Dados
João Vitor Balzer compartilhou suas ideias sobre a precificação do dashboard, ressaltando que o mapeamento das fontes de dados é crucial, pois influencia o custo de cada extração. Eles também discutiram a necessidade de mapear as fontes de dados para estimar os custos de extração (00:06:54).

## Orçamento de Infraestrutura em Nuvem
João Vitor Balzer detalhou os custos de infraestrutura em nuvem para o dashboard. Ele mencionou um custo de $12 mensais para uma máquina capaz de suportar cerca de 10 extrações simultâneas, permitindo rodar o N8N e um front básico, e propôs ambientes isolados para maior segurança e evitar concorrência entre aplicações (00:07:58).

## Custos de Infraestrutura e Banco de Dados
João Vitor Balzer calculou o custo total da infraestrutura, sugerindo adicionar $15 por mês para um banco de dados autogerenciável para simplificar a manutenção, backups, segurança e atualizações. O custo total da infraestrutura, incluindo máquina e banco de dados, seria de $27 (00:09:15).

## Custos de Backup e Licença
João Vitor Balzer estimou que o custo mensal de backup diário do banco de dados e da aplicação N8N seria de cerca de $200 para a infraestrutura cloud. Ele também mencionou o custo da licença da DPY, de R$73 por usuário, caso o cliente queira um usuário para mexer no dashboard (00:10:12).

## Custos de Manutenção e Total Mensal Estimado
João Vitor Balzer estimou o custo de manutenção em R$500 mensais para que ele e Rodrigo Kugler monitorem diariamente a execução dos jobs de extração (00:11:12). O custo mensal total para manter tudo funcionando foi estimado em R$1250, incluindo os $200 de infraestrutura em dólar, mais a manutenção e uma licença do Google Sheets (00:12:01).

## Modelo de Cobrança: Taxa de Manutenção
Rodrigo Kugler perguntou se o modelo de negócio da concorrência é baseado em assinatura, e João Vitor Balzer esclareceu que o modelo seria uma taxa de manutenção em vez de uma assinatura (00:12:51). João Vitor Balzer enfatizou que a taxa de infraestrutura é inevitável, pois exige uma máquina e um banco de dados para segurança (00:13:41).

## Estratégia de Preços e Concorrência
João Vitor Balzer sugeriu que a taxa de manutenção poderia incluir pequenas melhorias e que eles deveriam considerar os preços da concorrência (00:14:23). Ele estimou um valor inicial de R$3K para a criação da extração de dados, do MVP e do dashboard para o irmão de Rodrigo Kugler, cobrindo também o custo de manutenção do primeiro mês (00:15:12).

## Cobrança por Features e Risco de Barateamento
João Vitor Balzer comentou que a taxa de manutenção de R$1K para um dashboard pode ser alta, sugerindo que ela pode ser introduzida à medida que a complexidade do sistema aumenta ou que a cobrança pode ser feita por features (00:15:12). Ele advertiu que baratear o custo da infraestrutura (por exemplo, usando uma máquina de $6) seria uma "economia burra", pois poderia causar gargalos e concorrência entre o banco de dados e o N8N (00:16:09).

## Hospedagem Local vs Nuvem
Rodrigo Kugler questionou a necessidade da infraestrutura robusta para apenas dois jobs diários e se seria possível sediar o serviço localmente (on-premise). João Vitor Balzer desaconselhou a hospedagem on-premise devido a problemas de disponibilidade, exposição na web e dependência de fatores como energia elétrica, o que poderia levar a atrasos nas informações (00:16:47).

## Frequência de Extração de Dados
Rodrigo Kugler informou que a extração de dados duas vezes ao dia seria suficiente (00:18:47). João Vitor Balzer ressaltou a importância de definir os horários ideais para agendar os jobs, alinhados ao momento em que os dados mais atualizados das fontes estão disponíveis, reforçando a necessidade de conhecer a "engenharia reversa" das fontes (00:19:47).

## Fontes de Dados e API do NBS
Rodrigo Kugler confirmou que a única fonte de dados é o NBS. João Vitor Balzer explicou que a API do NBS é o mecanismo para buscar dados sem a necessidade de usuário e senha, por meio de uma chave de API (00:20:38). João Vitor Balzer também destacou que a DPY já possui o PowerBI e o Google Workspace (00:21:19).

## Convergência de Orçamentos e Estratégia Comercial
João Vitor Balzer observou que seus custos estimados convergiam com o que Rodrigo Kugler havia pesquisado. Rodrigo Kugler valorizou a troca de informações entre o lado comercial e técnico para elaborar uma proposta cuidadosa para o primeiro produto, especialmente por ser para uma empresa familiar (00:22:25).

## Vantagens e Margem de Lucro da Infraestrutura em Nuvem
João Vitor Balzer enfatizou que a infraestrutura em cloud é mais segura, disponível e economicamente vantajosa a longo prazo, funcionando como um aluguel de computador e rede (00:23:13). Rodrigo Kugler concordou e sugeriu que isso representa uma oportunidade de aplicar uma margem de lucro sobre os custos (00:24:05).

## Configuração da Máquina em Nuvem e Docker
João Vitor Balzer explicou a Rodrigo Kugler que o custo de $6 se refere à máquina "crua" e que o preço final inclui o trabalho de configuração, instalação de pacotes (como Python) e o uso de tecnologias como Docker para automatizar a instalação (00:24:53). Ele está desenvolvendo um repositório padrão com Docker para simplificar a configuração em futuros clientes (00:26:21).

## Infraestrutura Elástica e Descentralização por Cliente
João Vitor Balzer destacou que a infraestrutura em cloud é elástica, permitindo o aumento de recursos sob demanda (00:27:18). Ele defendeu a descentralização das máquinas por cliente para atender a requisitos específicos (como domínio da empresa) e isolar a infraestrutura, além de evitar gargalos e comprometer o processamento (00:26:21).

## Infraestrutura Serverless e Cobrança
João Vitor Balzer explicou o conceito de serverless, onde a máquina só liga no momento da execução do job, resultando em cobrança on-demand. No entanto, para um projeto pequeno, ele sugeriu que é mais vantajoso ter uma máquina disponível 24 horas por dia, 7 dias por semana, embora o desligamento após o job possa ser configurado (00:29:14).

## Tipos de Cobrança e Foundation
Rodrigo Kugler demonstrou interesse em perguntar a seu tio, que trabalha no setor, sobre a forma de cobrança do serviço de BI que ele contratou (00:30:26). João Vitor Balzer descreveu três principais formas de obter receita: desenvolvimento, infraestrutura e mensalidade/manutenção (00:32:07). Ele também mencionou a "consultoria" e o modelo de "foundation," que implica a entrega do projeto para que o cliente realize a manutenção (00:31:11).

## Modelos de Serviço e Contratos de Manutenção
João Vitor Balzer discutiu a possibilidade de criar um contrato de "foundation" em que a DPY desenvolve e entrega a solução para a empresa manter, ou um contrato de mensalidade que cobre manutenção e desenvolvimento contínuo de novas features (00:31:11) (00:33:04). Ele também mencionou o modelo de manutenção on-demand para serviços não essenciais, que acarreta menos custo, ao contrário dos dados sensíveis, como os financeiros (00:35:10).

## Escalabilidade da Infraestrutura e Novos Produtos
Rodrigo Kugler perguntou se o mesmo computador poderia ser usado para um segundo produto, como o "robô" do agente. João Vitor Balzer confirmou que a infraestrutura é elástica e pode ser usada, desde que o novo job não exija um processamento computacional elevado (00:37:40).

## Status e Monitoramento da Máquina em Nuvem
João Vitor Balzer mostrou a tela do Digital Ocean, exibindo que a máquina está rodando com 2 GB de memória, 50 GB de armazenamento, e a CPU em apenas 3%, reforçando que o monitoramento da "saúde do produto" é parte do custo de manutenção (00:39:22).

## Expansão do Projeto e Mapeamento de Fontes
João Vitor Balzer explicou que, se o cliente quiser expandir o produto para outras áreas (como vendas de carros novos), seria necessária uma nova fase de discovery, incluindo o mapeamento de novas fontes de dados (00:40:11). Ele enfatizou que entender a engenharia reversa dos dados é crucial (00:41:03).

## Integração com o NBS e Discovery
João Vitor Balzer ressaltou que a fase de discovery deve incluir a identificação da burocracia para obter uma conta do NBS para exploração e entender a viabilidade da integração através da API. Ele explicou que o processo de integração e data stores (como a frequência de leitura de dados) faz parte do produto a ser desenvolvido (00:41:44) (00:49:03).

## Desenvolvimento com N8N e Escalabilidade
João Vitor Balzer sugeriu o N8N para o MVP, por ser uma ferramenta no-code que permite desenvolver rapidamente. Ele alertou que o N8N não é escalável e que a fase dois envolveria avaliar a necessidade de infraestrutura ou tecnologias adicionais para acomodar novos jobs sem comprometer o processamento (00:43:19).

## Arquitetura de Dados (Medalhão) e BI
João Vitor Balzer discutiu a arquitetura de dados "Medalhão" (Bronze, Silver e Gold), que visa tratar o dado em estágios, tornando-o pronto para o BI, eliminando a necessidade de o BI criar regras de negócio (00:44:08). Ele questionou se o cliente aceitaria apenas o recebimento de arquivos CSV, mas Rodrigo Kugler confirmou que o cliente busca o monitoramento visual ao vivo da oficina (00:45:15).

## Estrutura da API do NBS
João Vitor Balzer analisou a documentação da API do NBS, notando que, apesar de parecer desatualizada, ela utiliza operações CRUD (Create, Read, Update, Delete) (00:51:40). Ele destacou que o foco principal será nos comandos "GET" para buscar os dados (00:58:18).

## Entendimento e Autenticação de Endpoints
João Vitor Balzer e Rodrigo Kugler discutiram a necessidade de mapear os endpoints da API para determinar o que será integrado (clientes, agendamento, orçamento) e, consequentemente, o custo de horas do projeto. João Vitor Balzer destacou que precisava entender o método de autenticação da API (usuário e senha ou chave da API) na documentação para avançar (00:59:17) (01:01:38).

## Mapeamento e Futuros Projetos
João Vitor Balzer mencionou que o mapeamento consiste em entender o que será integrado e que, idealmente, em projetos futuros, Rodrigo Kugler deveria trazer esse mapeamento pronto. Eles reconheceram que APIs terceiras, possivelmente para seguradoras, também poderiam ser relevantes e que a ausência de uma API dificultaria o desenvolvimento (01:00:07).

## Levantamento de Custos e Escopo de Integração
A dupla concordou que, com a existência da API, o próximo passo era levantar o custo de desenvolvimento do projeto e a mensalidade. João Vitor Balzer enfatizou que só conseguiria calcular o custo se Rodrigo Kugler trouxesse o escopo de integração mais detalhado, para evitar integrar APIs desnecessárias (01:00:49).

## Qualidade dos Dados e Validação
João Vitor Balzer sugeriu incluir no orçamento uma etapa de validação dos dados com o auxílio do irmão de Rodrigo Kugler, após a extração e antes da construção do BI. Isso garantiria a qualidade dos dados, verificando se a informação extraída da API NBS batia com o que estava no sistema NBS (01:02:34).

## Descoberta da Documentação da API NBS
João Vitor Balzer expressou frustração com a documentação da API do NBS, classificando-a como "muito ruim" e difícil de encontrar informações de autenticação (01:01:38) (01:03:25). Ele localizou os plugins fábrica e evolutivo da API, notando que ambos visam permitir que softwares de terceiros se integrem com o sistema NBS, o que é o objetivo do projeto (01:04:27).

## Uso de ChatGPT e Autenticação
João Vitor Balzer sugeriu que Rodrigo Kugler usasse o ChatGPT para ler a documentação e os endpoints, o que auxiliaria bastante no levantamento de informações. Eles concordaram que a autenticação era a próxima informação crucial a ser encontrada, e que poderia ser necessário verificar com o suporte do NBS (01:04:27).

## Dicas de Comunicação sobre Autenticação
João Vitor Balzer aconselhou Rodrigo Kugler a falar com pessoas "não técnicas" do cliente sobre a autenticação, pois o pessoal de TI poderia, por diversos motivos, tentar sabotar ou dificultar o processo, e quanto menos envolvimento do time de tecnologia, melhor (01:05:34). Ele também sugeriu que a autenticação poderia ser via chave da API, que o irmão de Rodrigo Kugler poderia gerar no sistema NBS (01:07:06).

## Estrutura da API e Carga de Dados
João Vitor Balzer explicou que a API contém diversos dados úteis, como informações de veículos, serviços e produtos, e que o desafio de Rodrigo Kugler seria abstrair o que precisa ser consumido para evitar perda de tempo (01:07:06). Eles definiram que a estratégia seria realizar uma carga histórica dos dados, percorrendo todos os gets da API e salvando no banco de dados, e depois fazer extrações semanais para manter os dados atualizados (01:08:29).

## Firewall e Próximos Passos para Orçamento
João Vitor Balzer levantou a possibilidade de regras de firewall serem necessárias, já que o NBS está hospedado na empresa do cliente, o que é um detalhe que pode ser resolvido (01:09:26). O ponto mais importante, no momento, é descobrir como autenticar na API para prosseguir com o orçamento e dar andamento ao negócio (01:10:25) (01:14:45).

## Estratégia de Integração e Ferramentas
João Vitor Balzer detalhou que a API é a fonte de dados e que o N8N (um orquestrador) seria usado para ler a API, processar os dados e inseri-los no banco de dados (01:12:53). Ele defendeu o uso do N8N por ser uma ferramenta que não exige codificação para extrações leves (01:11:57).

## Visualização de Dados com Looker Studio
Eles discutiram a ferramenta de visualização de dados, com João Vitor Balzer sugerindo o Looker Studio, já que é de graça (entre aspas) e funcional (01:13:59). Ele demonstrou como criar um relatório e conectar-se a um banco de dados Postgres no Looker Studio, completando o ciclo de integração e visualização (01:14:45) (01:16:25).

## Discussão sobre Consultoria de Segurança (DevSecOps)
Rodrigo Kugler perguntou sobre o terceiro produto (consultoria de segurança), e João Vitor Balzer explicou que se trata de DevSecOps, focado em compliance com LGPD e infraestrutura (01:16:25). João Vitor Balzer considerou que essa área pode ser mais complexa e dar mais "dor de cabeça" do que a integração (o produto mais simples) (01:17:28).

## Estratégia de Expansão para Segurança
João Vitor Balzer sugeriu que seria mais interessante explorar a área de segurança (DevSecOps) após a empresa já estar bem estabelecida com o cliente, como no caso de um relacionamento de longo prazo com a concessionária (01:18:22). Eles concordaram que a entrega nesse tipo de consultoria seria um Technical Design Document (TDD) com um plano de ação (01:18:59).

## Foco em Produtos Palpáveis e Alocação de Recursos
João Vitor Balzer argumentou que, por estarem começando, é melhor focar em um produto palpável como a integração. Ele levantou a ideia de a empresa se tornar uma "consultoria de TI alocando recursos", onde a empresa atua como intermediária, vendendo insumo humano e ganhando pela diferença entre o custo do recurso alocado e o valor cobrado do cliente (01:20:53) (01:23:38).

## Debate sobre o Modelo de Negócio
Rodrigo Kugler considerou a ideia de alocação de recursos como um plano para o futuro, defendendo que o foco atual deveria ser fechar o primeiro produto para aprender com o processo (01:21:57). João Vitor Balzer insistiu que a tecnologia escala rápido e que mirar em um modelo de ponte entre empresas e recursos humanos, em vez de desenvolvimento tecnológico puro, seria mais benéfico a longo prazo (01:24:22).

## Responsabilidade e Margem
Rodrigo Kugler discordou da ideia de se eximir da responsabilidade do produto no modelo de alocação de recursos, pois a responsabilidade seria sempre da empresa que está vendendo o serviço (01:25:37). Ele também alertou que a alocação de recursos poderia "comer a margem" da empresa e que o foco deve ser no primeiro produto (01:27:26).

## Próximos Passos e Oportunidades
Eles reafirmaram que o próximo passo é buscar as informações pendentes (autenticação) para definir o orçamento. João Vitor Balzer mencionou a possibilidade de vender o produto NBS dashboard diretamente para a NBS ou para outras concessionárias com o mesmo sistema (01:31:14).

## Alerta sobre CRM
João Vitor Balzer alertou veementemente contra o desenvolvimento de um CRM (Customer Relationship Management) ou um concorrente do NBS, devido à complexidade e às dores de cabeça inerentes a essa área (01:33:00).

## Situação Financeira e Custos de Infraestrutura
Eles concordaram que a receita inicial deve ser usada para cobrir custos operacionais (como domínios) e para a empresa ganhar saúde financeira antes de distribuir lucros. João Vitor Balzer alertou que o custo de computação em nuvem pode ser alto quando o projeto escala (01:34:34).
