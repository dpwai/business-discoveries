# Alinhamento Tecnico — Kanban Safra + Fluxo UBG + Custeio por Talhao Safra

**Data:** 10 de Marco de 2026
**Duracao:** ~86 minutos
**Participantes:** Joao Vitor Balzer (CTO), Rodrigo Kugler (CEO)
**Local:** Google Meet
**Qualidade da Transcricao:** Media (conexao Wi-Fi instavel, trechos cortados)

---

## Resumo Executivo

Reuniao de alinhamento tecnico focada em tres temas centrais: (1) a adocao do modelo Kanban vertical para gestao do lifecycle TALHAO_SAFRA, com cards passando por etapas condicionadas a coleta de dados obrigatorios; (2) o mapeamento completo do fluxo pos-colheita na UBG (ticket balanca, amostragem, secagem, alocacao silo, saida grao), confirmando que agricultura e UBG sao telas separadas com usuarios diferentes; (3) a consolidacao de TALHAO_SAFRA como hub central de custeio, onde todas as operacoes de campo, insumos e custos sao alocados. Joao propoe tratar o lifecycle como um "videogame" — o usuario so avanca de etapa ao preencher dados obrigatorios, garantindo coleta completa. Rodrigo vai ligar para Claudio/Alessandro para validar condicionais de cada etapa e coletar dados sobre equipamentos UBG.

---

## Descobertas Principais

### 1. Kanban Vertical como modelo de UI para Safra

- **Contexto:** Joao propoe usar abstracoes de metodo agil (sprint/Kanban) para representar o lifecycle da safra na plataforma
- **Insight:** Cada TALHAO_SAFRA e tratado como um "card" que passa por etapas verticais (planejamento, preparo, plantio, manejo, colheita). Layout vertical (scroll para baixo) e preferivel ao horizontal para 82+ talhoes, especialmente no mobile
- **Impacto no projeto:** Define a arquitetura de UI principal da tela de safras. Cada coluna vertical = uma etapa do lifecycle. Cards descem conforme avancam
- **Quote:** "Pense isso como se fosse um sprint [...] se a gente pensasse isso como se fosse um sprint?" — Joao

### 2. Condicionais de passagem de etapa ("Videogame")

- **Contexto:** Para garantir coleta de dados, cada transicao de etapa exige dados obrigatorios
- **Insight:** O sistema bloqueia a passagem se dados nao foram preenchidos. Exemplos: para sair de preparo, informar insumos gastos; para sair de manejo, ter ao menos 1 pulverizacao registrada; para colheita, registrar maquina e dados basicos
- **Impacto no projeto:** Cria um "mapa de coleta de dados" gamificado. Precisa definir com Alessandro/Claudio quais dados sao obrigatorios em cada etapa
- **Quote:** "Imagine que e um videogame, o cara tem que passar as etapas e as etapas sao os dados." — Joao

### 3. Gantt como complemento (nao substituto)

- **Contexto:** Dados historicos nao tem granularidade de tempo (quantos dias em cada etapa), entao Gantt fica vazio sem dados futuros
- **Insight:** O Gantt funciona como linha do tempo de um card especifico — mostra planejado vs real por TALHAO_SAFRA. Mas so tera valor quando o sistema coletar dados de transicao de etapa. Para dados historicos, nao faz sentido
- **Impacto no projeto:** Gantt e tela separada, tipo "resumo/timeline" de um TALHAO_SAFRA individual. Kanban e a tela principal de operacao

### 4. Separacao definitiva: Agricultura vs UBG

- **Contexto:** Rodrigo explica que sao pessoas diferentes que operam cada tela
- **Insight:** Quando colheita termina no Kanban de safras, gera automaticamente registros esperando na tela da UBG. A equipe de agricultura nao trabalha mais naquele card. Vanessa/Josmar assumem na UBG
- **Impacto no projeto:** Confirma 2 telas separadas. A transicao colheita->ticket balanca e o "handoff" entre as duas equipes
- **Quote:** "Nao, porque sao pessoas diferentes que vao usar." — Rodrigo

### 5. Fluxo UBG simplificado

- **Contexto:** Joao tinha etapas extras (pre-limpeza, recepacao separada de amostragem) que nao existem
- **Insight:** O fluxo real e: Ticket Balanca (pesagem + placa + motorista) -> Amostragem/Recebimento Grao (umidade, impureza, ardidos — feito com caneca 200g antes de descarregar) -> Controle Secagem (leituras 30/30 min) -> Alocacao Silo -> Saida Grao. Pre-limpeza e recepacao como etapas separadas nao existem — amostragem e recebimento acontecem simultaneamente
- **Impacto no projeto:** Remover etapas desnecessarias na tela UBG (pre-limpeza, recepacao separada)

### 6. Moega mistura talhoes — rastreamento muda

- **Contexto:** Apos descarregar na moega, graos de diferentes talhoes se misturam
- **Insight:** A partir da moega, rastreamento deixa de ser por TALHAO_SAFRA e passa a ser por CULTURA. Todos os ticket balanca de soja viram "soja" no secador/silo. Mas a vinculacao ticket_balanca->talhao_safra preserva a rastreabilidade retroativa
- **Impacto no projeto:** No Kanban UBG, quando graos entram em secagem, cards de mesma cultura se unificam. Custos de secagem (lenha, energia) sao rateados por cultura e area

### 7. Semente vs Commodity — dois fluxos de secagem

- **Contexto:** Rodrigo lembra que semente certificada tem processo de secagem diferente
- **Insight:** Semente nao mistura com commodity. Processo de secagem diferente, maquina diferente, vai para silo pulmao (exclusivo semente). Ja vem definido no planejamento da safra (TALHAO_SAFRA ja sabe se e semente)
- **Impacto no projeto:** Precisa de subtipo de cultura (ex: soja_commodity vs soja_semente) ou flag no TALHAO_SAFRA. Na hora de alocar silo, sistema sabe que semente vai para silo pulmao automaticamente

### 8. TALHAO_SAFRA como hub central de custeio — confirmado

- **Contexto:** Joao questiona como funciona centro de custo
- **Insight:** Todo custo operacional (insumos, combustivel, mao de obra, operacoes campo) e alocado por TALHAO_SAFRA, nao por safra. Safra = temporal (25/26). TALHAO_SAFRA = espacial + temporal (talhao X + safra 25/26 + cultura Y). A soma de todos TALHAO_SAFRA de uma safra = custo total da safra
- **Impacto no projeto:** Confirma Doc 32 — TALHAO_SAFRA e o hub. Compra de insumo nao precisa ser mapeada ao TALHAO_SAFRA, mas o USO do insumo sim
- **Quote:** "Talhao safra e o hub central de custo e e o melhor lugar para alocar." — Rodrigo

---

## Decisoes Tomadas

| # | Decisao | Justificativa | Impacto |
|---|---------|---------------|---------|
| 1 | Kanban vertical para lifecycle TALHAO_SAFRA | Mobile-first, 82+ cards nao cabem horizontal | UI principal da tela safras |
| 2 | Gantt como tela separada (timeline de um card) | So tem valor com dados de transicao, nao historicos | Tela secundaria, nao MVP |
| 3 | Etapas condicionais com dados obrigatorios | Garante coleta de dados como "videogame" | Precisa definir condicionais por etapa |
| 4 | Telas de agricultura e UBG separadas | Usuarios diferentes (equipe campo vs Vanessa/Josmar) | 2 Kanbans independentes |
| 5 | Rastreamento muda de talhao para cultura na moega | Graos misturam fisicamente na moega | Kanban UBG agrupa por cultura apos secagem |
| 6 | TALHAO_SAFRA = hub central de custeio | Todo custo operacional alocado nesta entidade | Custo por talhao, nao por safra generica |
| 7 | Remover etapas fantasma da UBG (pre-limpeza, recepacao separada) | Nao existem no processo real | Simplifica tela UBG |
| 8 | Compra de maquina/venda de maquina fora do MVP | Nao agrega valor no V0, cara se vira | Menos telas para construir |
| 9 | Compra de insumo DENTRO do MVP | Necessario para saber custo unitario e alocar por talhao | Tela de estoque/compras |

---

## Regras de Negocio Novas

| Regra | Descricao | Entidade(s) afetada(s) |
|-------|-----------|----------------------|
| Condicional de etapa | Usuario so avanca no Kanban se preencher dados obrigatorios da etapa atual | TALHAO_SAFRA (status/etapa) |
| Unificacao por cultura na moega | Apos descarregar na moega, rastreamento muda de talhao_safra para cultura | CONTROLE_SECAGEM, ESTOQUE_SILO |
| Semente nunca mistura com commodity | Processo de secagem diferente, silo pulmao exclusivo | TALHAO_SAFRA (flag semente), ALOCACAO_SILO |
| Subtipo de cultura | Mesma cultura pode ser commodity ou semente — afeta fluxo UBG | CULTURA ou TALHAO_SAFRA |
| Colheita gera N tickets balanca | Uma operacao_campo de colheita gera multiplos ticket_balanca (media ~10 por talhao) | OPERACAO_CAMPO, TICKET_BALANCA |
| Placa obrigatoria no ticket balanca | Sistema deve bloquear ticket sem placa (hoje planilha permite omitir) | TICKET_BALANCA |
| Manejo exige ao menos 1 pulverizacao | Nao existe safra sem pulverizacao — condicional minima | APLICACAO_INSUMO |
| Custo de secagem rateado por cultura e area | Lenha/energia dividida proporcionalmente, nao por talhao individual | CONTROLE_SECAGEM, centro de custo |

---

## Decisoes Tecnicas e Arquiteturais

### Kanban Vertical vs Horizontal

**Decisao:** Layout vertical (scroll para baixo) para o Kanban de safras
**Justificativa:** 82+ talhoes nao cabem horizontalmente, mobile-first, mais intuitivo
**Alternativas Descartadas:** Kanban horizontal tradicional (Trello-style)
**Implicacoes:** Cada "coluna" vira uma "secao" vertical. Cards descem ao avancar de etapa

### Planejado vs Real (Dicionario de Dados)

**Decisao:** Joao propoe armazenar planejado e real como estruturas separadas por TALHAO_SAFRA
**Justificativa:** Permite comparacao automatica (atraso, desvio de planejamento)
**Implicacoes:** Cada etapa tem: data_planejada_inicio, data_planejada_fim, data_real_inicio, data_real_fim. Ja existe parcialmente via `dias_offset` no template + `data_plantio_prevista`. Joao quer explicitar isso no card

### Handoff Colheita -> UBG

**Decisao:** Quando operacao_campo de colheita e finalizada, registros aparecem automaticamente na tela UBG como tickets pendentes
**Justificativa:** Equipes diferentes, nao faz sentido forcar transicao manual cross-tela
**Implicacoes:** Precisa de evento/trigger que cria expectativa na UBG quando colheita inicia

---

## Pain Points Identificados

### Dados historicos sem granularidade temporal

**Severidade:** Media
**Descricao:** Dados historicos nao registram quantos dias durou cada etapa (plantio, colheita, manejo). Cadernetas de maquinario existem mas nao serao digitalizadas no V0
**Quote:** "Ele nao tem la no campo quanto tempo a maquina levou." — Rodrigo
**Solucao proposta:** A partir do V0 com Kanban, dados de transicao de etapa serao capturados automaticamente. Historico fica sem essa informacao

### Vanessa omite placas no ticket balanca

**Severidade:** Alta
**Descricao:** Na planilha atual, campo de placa frequentemente fica vazio. Impacta rastreabilidade e rateio de custos de transporte
**Quote:** "E veja bem ainda, ela pega aqui e nao poe as placas." — Rodrigo
**Solucao proposta:** Sistema bloqueia ticket sem placa (campo obrigatorio)

### Digitacao manual de pesagem

**Severidade:** Media
**Descricao:** Vanessa digita manualmente todos os dados de pesagem. Joao identifica que sensores de peso conectados a internet custariam ~R$100 e eliminariam digitacao
**Quote:** "Tem alguem digitando essa p****. Uns 100 pila no maximo [para um sensor]." — Joao
**Solucao proposta:** Futuro (V2+) — integrar balanca com sensor IoT. Para V0, formulario digital ja melhora

---

## Dados Coletados / Prometidos

| Dado | Formato | Responsavel | Prazo | Status |
|------|---------|-------------|-------|--------|
| Condicionais por etapa do Kanban (dados obrigatorios) | Verbal/WhatsApp | Rodrigo (perguntar a Alessandro/Claudio) | 11/03/2026 | Pendente |
| Modelo da balanca UBG | Texto | Rodrigo (perguntar a Claudio) | 11/03/2026 | Pendente |
| Equipamento de medicao de umidade (marca/modelo) | Texto | Rodrigo (perguntar a Josmar) | 11/03/2026 | Pendente |

---

## Validacoes

| Item | Status | Observacao |
|------|--------|-----------|
| Kanban como modelo visual do lifecycle | Validado | Ambos concordam, Joao vai implementar |
| Layout vertical (nao horizontal) | Validado | Rodrigo insiste, Joao aceita |
| Gantt como tela secundaria | Validado | Complemento, nao substituto do Kanban |
| Telas separadas agricultura/UBG | Validado | Usuarios diferentes |
| TALHAO_SAFRA como hub de custeio | Validado | Ambos alinhados |
| Compra/venda maquina fora do MVP | Validado | "O cara se vira la" — Joao |
| Sensor IoT na balanca | Adiado para V2+ | Rodrigo pede foco no MVP primeiro |
| Controle de estoque de insumos no MVP | Validado | Necessario para custeio por talhao |

---

## STATUS DO DESENVOLVIMENTO

### Tela de Safras (DPWAI App)

- Joao mostrou prototipo na call com etapas horizontais (Kanban)
- Falta botao "criar planejamento" para gerar card
- Falta implementar layout vertical
- Precisa vincular com template de operacoes (offsets)
- Tela de UBG ja tem estrutura basica (colhido -> transporte -> recepacao -> secagem)

### Skills Claude Code

- Rodrigo instalou skills: validate-csv, ddl-consistency, reuniao, gap-update, er-validate, prisma-expert, sql-expert
- Rodrigo criou skill customizada de sync-docs para manter MEMORY.md atualizado
- Falta configurar CLI do Claude Code

---

## Proximos Passos

### Acoes DeepWork

1. [ ] Joao: Implementar Kanban vertical na tela de safras — **Responsavel:** Joao
2. [ ] Joao: Criar botao "criar planejamento" que gera card com dados de TALHAO_SAFRA — **Responsavel:** Joao
3. [ ] Joao: Simplificar tela UBG (remover pre-limpeza, unificar recepacao/amostragem) — **Responsavel:** Joao
4. [ ] Joao: Implementar logica de bloqueio de etapa (condicionais) — **Responsavel:** Joao
5. [ ] Rodrigo: Definir dados obrigatorios por etapa com Alessandro/Claudio — **Responsavel:** Rodrigo — **Prazo:** 11/03/2026
6. [ ] Rodrigo: Coletar modelo da balanca e equipamento de umidade — **Responsavel:** Rodrigo — **Prazo:** 11/03/2026

### Acoes Cliente

1. [ ] Claudio: Informar modelo da balanca da UBG — **Responsavel:** Claudio — **Prazo:** a confirmar
2. [ ] Josmar/Vanessa: Informar equipamento de medicao de umidade (marca/modelo) — **Responsavel:** Josmar — **Prazo:** a confirmar

### Decisoes Pendentes

- [ ] Nomenclatura: gleba vs subtalhao — perguntar ao Claudio o que prefere
- [ ] Quais dados sao obrigatorios em cada etapa do Kanban (condicional de passagem)
- [ ] Se epoca (safra/safrinha) e redundante ou necessario no formulario de planejamento
- [ ] Como tratar subtipo de cultura (semente vs commodity) — flag no TALHAO_SAFRA ou subtipo na CULTURA

---

## Trechos Notaveis

### Sobre Kanban como abstracoes de agile (07:39)
> **Joao:** "Eu tive esse insight ontem porque tivemos um sprint. Se a gente for parar para pensar, da pra gente abstrair. Planning, daily, review, que seria o pos-colheita, e entregue."

### Sobre condicional de dados como videogame (31:50)
> **Joao:** "Imagine que e um videogame. O cara tem que passar as etapas e as etapas sao os dados. E isso ai e tipo meio de um mapa de coleta de dados."

### Sobre separacao agricultura/UBG (38:22)
> **Rodrigo:** "Nao, porque sao pessoas diferentes que vao usar."

### Sobre TALHAO_SAFRA como hub de custo (19:56)
> **Joao:** "Tente pensar a parte do financeiro por talhao safra. Mapear sempre o talhao safra."
> **Rodrigo:** "Talhao safra e o hub central de custo e e o melhor lugar para alocar."

### Sobre placa obrigatoria (53:17)
> **Rodrigo:** "E veja bem ainda, ela pega aqui e nao poe as placas."
> **Joao:** "Ai e bem errado. A gente tem que bloquear. Porque daí a gente consegue ter ate um pouco do rateio ai."

### Sobre sensor de balanca (52:25)
> **Joao:** "Tem alguem digitando essa p****. Porque assim, voce sabe quanto que seria um sensor para so para fazer essa m**** e mandar pro nosso sistema? Uns 100 pila no maximo."

### Sobre foco no MVP (59:54)
> **Rodrigo:** "Voce nao acha mais que essas automacoes de processo do jeito que eles trabalham hoje deveria vir numa nao no MVP, no V0?"
> **Joao:** "Nao, eu concordo. Mas eu ja quero ter uma ideia."

---

**Processado por:** DeepWork AI Flows
**Data do processamento:** 2026-03-10
