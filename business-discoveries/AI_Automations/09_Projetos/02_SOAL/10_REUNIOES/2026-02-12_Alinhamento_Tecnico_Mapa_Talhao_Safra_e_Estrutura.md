# Relatório de Análise - Alinhamento Técnico Interno

**Data da Reunião:** 12 de Fevereiro de 2026
**Duração da Gravação:** 01:22:27
**Qualidade da Transcrição:** Boa
**Participantes:** João Vitor Balzer (CTO), Rodrigo Kugler (CEO)

---

## 1. RESUMO EXECUTIVO
Reunião focada na definição da arquitetura de dados e visualização da plataforma SOAL. A principal decisão foi centralizar a experiência do usuário em um **mapa interativo** (inspirado em *Farming Simulator*), onde entidades como Talhões, Silos e UBG são plotadas via coordenadas geográficas. Definiu-se a entidade **"Talhão Safra"** como o coração do sistema para controle de custos e rastreabilidade, conectando o local físico (Talhão) ao tempo (Safra) e eventos (Operações de Campo). Também houve alinhamento sobre a estrutura organizacional: Máquinas pertencem à Organização (não à Fazenda), e UBG é uma entidade operada centralmente.

---

## 2. DECISÕES TÉCNICAS E ARQUITETURAIS

### Visualização Via Mapa
**Decisão:** O front-end priorizará uma interface de mapa interativo (Google Maps).
**Justificativa:** Facilita a compreensão espacial para o produtor. O usuário poderá desenhar polígonos ou importar arquivos KML/KMZ (padrão de georreferenciamento governamental - CAR) para definir talhões e áreas.
**Implicações:** Todas as entidades de estrutura (Silos, UBG, Sedes) devem possuir coordenadas geográficas (lat/long).

### Entidade "Talhão Safra"
**Decisão:** Criação da entidade `Talhao_Safra` como tabela de transição central.
**Definição:** Combinação de **Lugar** (Talhão) + **Tempo** (Safra/Calendário) + **Cultura** (Milho/Soja).
**Justificativa:** Permite rastrear custos e operações por ciclo produtivo específico. Um talhão físico pode ser subdividido em múltiplos `Talhao_Safra` se houver culturas diferentes plantadas em partes distintas no mesmo ciclo.
**Regra de Negócio:** O ciclo de vida do `Talhao_Safra` começa no **Orçamento/Planejamento** e termina na **Colheita/Saída do Grão**.

### Estrutura Organizacional e Máquinas
**Decisão:** Máquinas pertencem à entidade `Organizacao` (SOAL), não à `Fazenda`.
**Justificativa:** O maquinário é um recurso compartilhado que rotaciona entre diferentes propriedades. O custo é rateado via apontamento de operações nos talhões.

### UBG (Unidade de Beneficiamento de Grãos)
**Decisão:** UBG é uma entidade independente que presta serviço para a Agricultura.
**Justificativa:** Embora geograficamente localizada em uma fazenda, ela centraliza o recebimento de todas as propriedades. Tem custos próprios (energia, lenha) que são separados do custo agronômico da lavoura.

### Activity Rural vs. Departamento
**Decisão:** Fazendas possuem "Atividades Rurais" (Agricultura, Pecuária, etc.) conforme classificação fiscal/CAR, ao invés de "Departamentos" genéricos.
**Justificativa:** Alinhamento com a estrutura fiscal e legal do produtor rural.

---

## 3. TECNOLOGIA E SISTEMAS ATUAIS

| Sistema | Função | Status | Observação |
|---|---|---|---|
| **Google Maps API** | Visualização geoespacial | Em implementação | Substituindo biblioteca pública anterior; conta empresarial permite uso. |
| **KML/KMZ Files** | Georreferenciamento | Integração planejada | Arquivos oficiais do CAR serão importados para desenhar perímetros automaticamente. |
| **Castrolanda** | Cooperativa/Fornecedor | Integração futura | Planejado conectar via API para puxar "Programação/Lista de Compras" de insumos. |

---

## 4. OPORTUNIDADES DE PRODUTO

| Prioridade | Funcionalidade | Status | Observação |
|---|---|---|---|
| **P0 - CRÍTICO** | **Mapa Interativo de Talhões** | Em Andamento | Visualização de polígonos e pontos (silos, sedes) no mapa. |
| **P0 - CRÍTICO** | **Cadastro de "Talhão Safra"** | Conceito | Usuário define o recorte do talhão para o ciclo atual (ex: metade soja, metade milho). |
| **P1 - ALTA** | **Importador KML/KMZ** | Pendente | Facilitar o cadastro inicial usando arquivos do governo. |
| **P1 - ALTA** | **Crop Calendar (Visual)** | Conceito | Linha do tempo visual das culturas (inspirado em Farming Simulator/Windows Vista). |
| **P2 - MÉDIA** | **Programação de Compras (Carrinho)** | Conceito | Lista de insumos planejados para a safra (integração Castrolanda). |

---

## 5. TRECHOS NOTÁVEIS DA TRANSCRIÇÃO

### Sobre a Importância do Mapa (00:03:56)
> **João:** "Em vez de eu ter aqui [...] nome, código... ter um mapa mostrando, ó: aqui tem a fazenda São João... Daí eu clico pá, Talhão, ele vai desenhar todos os talhões aqui no mapa. [...] Porque aí o cara consegue ter uma visão f***** da propriedade dele."

### Sobre "Talhão Safra" (00:32:07)
> **João:** "Na verdade, Talhão Safra é uma das entidades mais f****** da plataforma... essa entidade que vai ser em 90% dos relatórios. [...] É a gente vai saber onde que o maquinário foi. [...] É um dado que a gente vai tipo colocar toda vez na plataforma."

### Sobre Inspiração Visual (00:37:16)
> **João:** "Olha a brisa que eu fiquei estudando tudo no jogo. Isso é mecânica do jogo... Farming Simulator. [...] Aquele 'Crop Calendar'... para mim abriu muito minha mente isso aí. [...] Você consegue saber exatamente numa linha do tempo... quando vai colher, quando vai plantar."

### Sobre Background e UI (01:21:02)
> **Rodrigo:** "Que que eu pensei... de fazer essa caixa menorzinha... transparente... passava tipo escurecido... Dá para ver a conexão."
> **João:** "Tipo Windows Vista, tá ligado?"

---

## 6. PRÓXIMOS PASSOS

### Ações DeepWork (João - Técnico)
1. Implementar visualização de mapa com Google Maps API.
2. Criar estrutura de banco para `Talhão_Safra` conectando Talhão, Safra e Cultura.
3. Desenvolver lógica de "eventos" para máquinas (Operações de Campo).
4. Ajustar UI das caixas (estilo "Windows Vista"/transparente) para o dashboard.

### Ações DeepWork (Rodrigo - Produto/Dados)
1. Coletar dados cadastrais estáticos (Máquinas, Talhões, Culturas, Operadores) para popular o banco.
2. Enviar imagem do "Capão de Mato" para background (Já realizado/gerado).
3. Validar com Claudio (tio) a questão da tara dos caminhões na balança.

### Decisões Pendentes
- [ ] Definir se "Manutenção de Terceiros" entra na V1 ou V2 (tendência para V1 simplificada).
- [ ] Definir como tratar "Estoque e Movimentação de Silos" na V1.

---

**Análise preparada por:** DeepWork AI Flows (Audio Transcription Analyzer Agent)
**Data:** 12 de Fevereiro de 2026
