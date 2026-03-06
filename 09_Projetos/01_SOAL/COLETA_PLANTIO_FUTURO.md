# Diagnostico de Coleta de Plantio — Do Passado ao Futuro

> **Versao:** 1.0
> **Data:** 2026-03-05
> **Autor:** DeepWork AI Flows
> **Fontes:** ETL plantio historico (152 registros), Reuniao Alessandro (2026-03-04), DDL V0, Plano de Coleta V0

---

## 1. Contexto

O plantio e a unica operacao de campo que nunca teve um ponto de controle fisico obrigatorio. A colheita tem o ticket de balanca (806 pesagens com data, placa, motorista, peso). O abastecimento tem o Vestro (1.200 registros automaticos). Mas o plantio? A plantadeira sai pro campo e volta — sem registro.

O que existe hoje sao fragmentos: orcamentos agregados (20/21), planejamentos parciais (22/23), planilhas de colheita usadas como evidencia inversa (23/24), e finalmente planilhas de plantio direto com cultivar e origem (24/25 e 25/26). A qualidade melhora a cada safra, mas campos operacionais criticos — data de plantio, maquina, operador — nunca foram capturados.

Este documento transforma essa analise em um plano concreto: o que coletar, quem coleta, como coleta, e quando comecar.

---

## 2. Diagnostico Historico — O Que Temos Hoje

### 2.1 Evolucao da qualidade por safra (152 registros, 6 safras)

| Safra | Registros | Fonte | Fazenda | Talhao | Gleba | Cultivar | Area | Data plantio | Origem semente |
|-------|-----------|-------|---------|--------|-------|----------|------|-------------|----------------|
| 20/21 | 6 | orcamento | 50% | 0% | 0% | 50% | 100% | 50% | 0% |
| 21/22 | 10 | orcamento | 40% | 0% | 0% | 40% | 100% | 40% | 0% |
| 22/23 | 26 | planejamento | 0% | 50% | 0% | 35% | 50% | 0% | 35% |
| 23/24 | 48 | colheita_derivado | 0% | 100% | 0% | 0% | 0% | 0% | 0% |
| 24/25 | 12 | plantio_direto | 58% | 0% | 0% | 100% | 100% | 0% | 100% |
| 25/26 | 50 | plantio_direto | 90% | 0% | 86% | 90% | 100% | 4% | 86% |

**Tendencia:** Cada safra traz mais detalhe. Mas os campos operacionais (data, maquina, operador) ficam em zero porque ninguem os registra de forma estruturada.

### 2.2 Completeness geral (todos os 152 registros)

| Campo | Preenchido | Percentual |
|-------|-----------|------------|
| safra | 152/152 | 100% |
| cultura | 152/152 | 100% |
| epoca | 152/152 | 100% |
| area_plantada_ha | 91/152 | 60% |
| fazenda | 59/152 | 39% |
| cultivar | 73/152 | 48% |
| origem_semente | 64/152 | 42% |
| talhao | 61/152 | 40% |
| gleba | 43/152 | 28% |
| data_plantio | 9/152 | 6% |
| tratamento_sementes | 0/152 | 0% |
| adubo_base | 0/152 | 0% |
| quantidade_adubo_kg_ha | 0/152 | 0% |
| maquina | — | nunca coletado |
| operador | — | nunca coletado |

### 2.3 O gap critico: prescricao vs execucao

O workflow real descoberto na reuniao com Alessandro:

```
Alessandro (agronomo) prescreve  -->  Claudio + Lucas + Alessandro planejam safra
    -->  Tiago (gerente maquinario) executa  -->  2 operadores plantam
        -->  Ninguem registra a execucao de forma estruturada
```

A prescricao existe na apostila do Alessandro. A execucao acontece coordenada pelo Tiago. Mas a **ponte entre plano e execucao nunca foi digitalizada**.

Contraste com colheita: o ticket de balanca e um ponto de controle fisico obrigatorio — todo caminhao que chega na UBG e pesado. Nao existe equivalente para plantio.

---

## 3. Matriz Campo x Fonte x Responsavel x Metodo

Para cada campo do DDL (TALHAO_SAFRA + OPERACAO_CAMPO + PLANTIO_DETALHE), mapeamos: historico real, quem tem o dado, como coletar no futuro, e prioridade.

### 3.1 Campos de TALHAO_SAFRA (entidade central)

| Campo DDL | Tipo | Historico (%) | Quem tem o dado | Metodo futuro | Prioridade | Notas |
|-----------|------|--------------|-----------------|---------------|------------|-------|
| talhao_id | UUID FK | 40% | Alessandro (planejamento) | Form: dropdown de talhoes por fazenda | P0 | Nomes inconsistentes entre fontes — talhao_mapping pendente |
| safra_id | UUID FK | 100% | Sistema | Auto: safra ativa no contexto | P0 | Derivado do calendario fiscal (jul-jun) |
| cultura_id | UUID FK | 100% | Alessandro (planejamento) | Form: pre-populado do planejamento safra | P0 | 126 culturas no seed, filtrar por grupo relevante |
| epoca | ENUM | 100% | Alessandro | Form: selecao (safra/safrinha/terceira_safra) | P0 | Mesmo talhao pode ter safra + safrinha no mesmo ano |
| area_plantada_ha | NUMERIC | 60% | Alessandro / cadastro talhao | Auto: area do talhao (default) + override manual | P0 | Pode ser < area total se plantado parcialmente |
| cultivar | VARCHAR(200) | 48% | Alessandro (prescricao) | Form: texto ou selecao de cultivares usados | P0 | Essencial para rastreabilidade de sementes |
| data_plantio_prevista | DATE | 0% | Alessandro (planejamento) | Form: date picker com default regional por cultura | P0 | Ancora para gerar calendario SAFRA_ACAO. Defaults em CALENDARIO_AGRICOLA_CAMPOS_GERAIS.md |
| data_plantio | DATE | 6% | Tiago / operador (no dia) | Form mobile: data do dia (default hoje) | P0 | GAP CRITICO — nunca coletado de forma sistematica |
| data_colheita | DATE | — | Sistema / Josmar | Auto: derivado do ticket de balanca (primeira pesagem do talhao) | P1 | Ja temos 806 pesagens com data |
| produtividade_sc_ha | NUMERIC | — | Sistema | Auto: calculado = peso total colhido / area | E | Derivado de TICKET_BALANCA + area |
| observacoes | TEXT | — | Alessandro | Form: campo livre ou audio | P2 | — |

### 3.2 Campos de OPERACAO_CAMPO (hub de operacoes)

| Campo DDL | Tipo | Historico (%) | Quem tem o dado | Metodo futuro | Prioridade | Notas |
|-----------|------|--------------|-----------------|---------------|------------|-------|
| talhao_safra_id | UUID FK | — | Sistema | Auto: selecionado a partir do talhao no form | P0 | Lookup: talhao + safra ativa + cultura → talhao_safra_id |
| tipo | ENUM | — | Sistema | Auto: 'plantio' (fixo para este fluxo) | P0 | 20+ tipos no ENUM, neste contexto sempre 'plantio' |
| status | ENUM | — | Sistema / Tiago | Auto: 'concluida' (default) ou form se planejada | P0 | planejada → em_andamento → concluida |
| data_inicio | DATE | 6% | Tiago / operador | Form mobile: data do dia | P0 | = data_plantio de TALHAO_SAFRA |
| data_fim | DATE | — | Tiago / operador | Form: mesmo dia (default) ou dia seguinte | P1 | Plantio pode durar >1 dia em talhoes grandes |
| maquina_id | UUID FK | 0% | Tiago | Form: dropdown de maquinas tipo TRATOR ou PLANTADEIRA | P1 | 57 maquinas no cadastro, filtrar por tipo |
| operador_id | UUID FK | 0% | Tiago | Form: dropdown de operadores ativos | P1 | 15 operadores curados |
| fazenda_id | UUID FK | 39% | Sistema | Auto: derivado do talhao selecionado (DENORM) | P0 | 3 hops: talhao_safra → talhao → fazenda |
| area_trabalhada_ha | DECIMAL | 60% | Alessandro / sistema | Auto: = area_plantada_ha do talhao_safra | P1 | Override manual se parcial |
| horimetro_inicio | DECIMAL | 0% | Operador | Form: input numerico | P2 | Util para calculo de custo/hora |
| horimetro_fim | DECIMAL | 0% | Operador | Form: input numerico | P2 | — |
| combustivel_litros | DECIMAL | 0% | Sistema / Vestro | Auto: derivado de abastecimentos Vestro no periodo | P2 | Ja temos ETL Vestro com 1.200 registros |
| implemento_codigo | VARCHAR | 0% | Tiago | Form: dropdown de implementos | P2 | 126 implementos no cadastro |
| observacoes | TEXT | — | Tiago / operador | Form: texto livre ou audio | P3 | — |
| geojson_trajeto | JSONB | 0% | Maquina (GPS) | Auto: telemetria JD | Fora V0 | Depende de integracao John Deere |
| custo_operacao | DECIMAL | — | Sistema | Auto: trigger calcula baseado em insumos + combustivel + mao de obra | E | Fase 7 auto-calculado |

### 3.3 Campos de PLANTIO_DETALHE (subformulario)

| Campo DDL | Tipo | Historico (%) | Quem tem o dado | Metodo futuro | Prioridade | Notas |
|-----------|------|--------------|-----------------|---------------|------------|-------|
| operacao_campo_id | UUID FK | — | Sistema | Auto: criado junto com OPERACAO_CAMPO | P0 | 1:1 com operacao tipo 'plantio' |
| variedade | VARCHAR(100) | 48% | Alessandro | Form: pre-populado do cultivar em TALHAO_SAFRA | P0 | Redundante com talhao_safra.cultivar — manter para especificidade |
| populacao_sementes_ha | INTEGER | 0% | Alessandro (prescricao) | Form: numerico (tipico: 250-350 mil/ha soja, 60-80 mil/ha milho) | P2 | Na apostila do Alessandro, nunca em planilha |
| espacamento_cm | DECIMAL | 0% | Alessandro (prescricao) | Form: numerico (tipico: 45-50cm soja, 70-80cm milho) | P2 | Padrao por cultura, raramente varia |
| profundidade_cm | DECIMAL | 0% | Operador | Form ou audio: numerico simples | P3 | Depende do operador no campo |
| tratamento_sementes | VARCHAR(200) | 0% | Alessandro (receituario) | Form: texto ou selecao de tratamentos comuns | P2 | Informacao existe no receituario, nunca digitalizada |
| adubo_base | VARCHAR(200) | 0% | Alessandro (prescricao) | Form: selecao de produto_insumo tipo FERTILIZANTE | P2 | Na apostila, nunca em planilha |
| quantidade_adubo_kg_ha | DECIMAL | 0% | Alessandro (prescricao) | Form: numerico | P2 | — |
| umidade_solo_percent | DECIMAL | 0% | Operador / Alessandro | Form ou audio | P3 | Raramente medido formalmente |

---

## 4. Workflow de Coleta Proposto — 3 Momentos

### Momento 1: Pre-safra (Mai-Jun) — Planejamento

**Quem:** Alessandro + Lucas + Claudio
**Input:** Rotacao de culturas, escolha de cultivares, areas
**Metodo:** Form web ou import de planilha (Alessandro ja produz planilha)
**O que cria:** TALHAO_SAFRA com status "planejado" (via OPERACAO_CAMPO status 'planejada')

**Campos preenchidos neste momento:**

| Campo | Fonte | Metodo |
|-------|-------|--------|
| talhao_id | Alessandro seleciona | Form: dropdown por fazenda |
| safra_id | Sistema | Auto: proxima safra |
| cultura_id | Alessandro | Form: selecao filtrada |
| epoca | Alessandro | Form: safra / safrinha |
| area_plantada_ha | Cadastro talhao (default) | Auto com override |
| cultivar | Alessandro | Form: texto livre |
| origem_semente | Alessandro | Form: selecao (Castrolanda / Fazenda / FSI / outro) |
| data_plantio_prevista | Sistema (default regional) / Alessandro (override) | Date picker — ancora para gerar SAFRA_ACAO |

**Alternativa rapida:** Import da planilha que Alessandro ja produz (confirmado na reuniao — ele faz planejamento em xlsx com Lucas e Claudio). Nao exige mudanca de workflow dele.

### Momento 2: Execucao (Set-Nov) — Plantio no campo

**Quem:** Tiago (confirma) + operador (executa)
**Input:** Confirmacao de que o plantio foi executado
**Metodo:** Form mobile simples — botao grande, 3 toques max, audio para 2 funcionarios

**Fluxo do operador/Tiago:**

```
1. Abrir app → ver lista de talhoes planejados para hoje
2. Tocar no talhao → tela com dados pre-populados do planejamento
3. Confirmar: "Plantei" → registra data + hora automaticamente
   (opcional: selecionar maquina, operador)
```

**O que atualiza:** OPERACAO_CAMPO status 'concluida' + PLANTIO_DETALHE criado

**Campos preenchidos neste momento:**

| Campo | Fonte | Metodo |
|-------|-------|--------|
| data_inicio (= data_plantio) | Sistema | Auto: hoje (com override) |
| maquina_id | Tiago | Form: dropdown filtrado (tipo TRATOR/PLANTADEIRA) |
| operador_id | Tiago | Form: dropdown (15 operadores) |
| data_fim | Tiago | Form: hoje (default) |
| horimetro_inicio/fim | Operador | Form: input numerico (opcional) |

**Restricoes de UX (descobertas na reuniao):**

- **Audio obrigatorio** para 2 funcionarios com limitacao leitura/escrita
- **3 toques maximo** para registrar (Operator POV — maos sujas, tablet)
- **Offline-first:** Starlink cobre ~50% das plantadeiras — app deve funcionar sem internet e sincronizar depois
- **Pre-popular do planejamento:** Se TALHAO_SAFRA existe com status planejado, o form ja vem com cultura/cultivar/area preenchidos — operador so confirma

### Momento 3: Pos-plantio — Verificacao

**Quem:** Alessandro (visita de campo)
**Input:** Ajustes e complementos apos verificacao
**Metodo:** Form web ou mobile

**Campos preenchidos neste momento:**

| Campo | Fonte | Metodo |
|-------|-------|--------|
| populacao_sementes_ha | Alessandro (verificacao) | Form: numerico |
| tratamento_sementes | Alessandro | Form: texto |
| adubo_base | Alessandro | Form: selecao de insumo |
| quantidade_adubo_kg_ha | Alessandro | Form: numerico |
| observacoes | Alessandro | Form: texto ou audio |

---

## 5. Regras de Negocio para Formularios

Baseado nas descobertas das reunioes e no DDL:

### 5.1 Validacoes obrigatorias

| Regra | Logica | Fonte |
|-------|--------|-------|
| Capinzal = cultura unica | Se fazenda = FAZENDA SANTO ANTONIO DO CAPINZAL, nao permitir fracionamento (100% milho OU 100% soja) | Reuniao Alessandro |
| Epoca por calendario | safra = set-mar, safrinha = fev-jul, inverno = abr-set | Regra negocio SOAL |
| Area <= area_talhao | area_plantada_ha nao pode exceder area total do talhao | DDL constraint |
| Unique constraint | Mesmo talhao + safra + cultura + epoca nao pode duplicar | DDL: uq_talhao_safra |
| Rotacao gramineas | 25-30% da area total deve ser graminea (milho, trigo, aveia) — alerta se < 20% | Reuniao Alessandro |
| Horimetro crescente | horimetro_fim >= horimetro_inicio | DDL: chk_operacao_horimetro |

### 5.2 Pre-populacao inteligente

| Situacao | Comportamento |
|----------|---------------|
| Talhao com TALHAO_SAFRA planejado | Form pre-preenche: cultura, cultivar, area, origem_semente |
| Operador logado | operador_id automatico |
| Data | Default: hoje, hora atual |
| Fazenda | Derivada do talhao selecionado |
| Safra | Safra ativa no sistema |

### 5.3 Entrada por audio

Para os 2 funcionarios com limitacao de leitura/escrita e qualquer operador que prefira:

**Input minimo por audio:** "Plantei [talhao] hoje com a [maquina]"
**Transcricao IA extrai:** talhao, data (hoje), maquina (fuzzy match)
**Revisao:** Tiago ou Alessandro valida antes de subir ao sistema (camada de revisao — validada na reuniao)

**Desafio tecnico:** Ruido de maquinario no campo. Testar modelos STT com vocabulario agricola (nomes de talhoes, cultivares, produtos).

---

## 6. Prioridades de Implementacao

### P0 — Dia 1 (Quick wins imediatos)

| Acao | Esforco | Impacto | Responsavel |
|------|---------|---------|-------------|
| Import planejamento safra via planilha xlsx | Baixo — Alessandro ja produz a planilha | Cria TALHAO_SAFRA com cultivar, area, origem | Rodrigo coleta, Joao importa |
| Form mobile basico: Tiago confirma plantio (data + talhao + OK) | Medio — form simples, 3 campos | Captura data_plantio pela primeira vez (campo com 6% historico) | Joao implementa |
| Pre-popular TALHAO_SAFRA 25/26 a partir do CSV ja existente | Baixo — ETL ja pronto | 50 registros com fazenda, gleba, cultivar, area, origem | Joao roda script |

### P1 — Safra 25/26 (proximas semanas)

| Acao | Esforco | Impacto | Responsavel |
|------|---------|---------|-------------|
| Adicionar maquina e operador ao form de confirmacao | Baixo — 2 dropdowns extras | Captura dados com 0% historico pela primeira vez | Joao |
| Derivar data_colheita do ticket de balanca | Baixo — query SQL | Primeira pesagem de cada talhao_safra = data colheita | Joao |
| Validacao Capinzal cultura unica | Baixo — 1 regra no form | Evita erro de negocio | Joao |

### P2 — Safra 26/27 (investimento)

| Acao | Esforco | Impacto | Responsavel |
|------|---------|---------|-------------|
| Workflow completo: prescricao → execucao → verificacao (3 momentos) | Alto | Fluxo end-to-end digitalizado | Joao + Rodrigo |
| Audio input para operadores de campo | Alto — STT + NLP + revisao | Resolve limitacao 2 funcionarios, reduz friccao 100% equipe | Joao |
| Formulario pos-plantio (Alessandro): populacao, tratamento, adubo | Medio | Captura dados agronomicos com 0% historico | Joao |
| Calendario/timeline safra por talhao | Medio | "E agenda da gente" — substituiria anotacoes papel (validado Alessandro) | Joao |

### P3 / Fora V0

| Acao | Motivo |
|------|--------|
| Profundidade de semeadura, umidade solo | Raramente medidos formalmente |
| Geojson trajeto (GPS maquina) | Depende integracao John Deere — fora V0 |
| Velocidade operacao (auto) | Telemetria JD |
| Custo operacao (auto) | Trigger — implementar na Fase 7 |

---

## 7. Comparacao com Colheita (benchmark interno)

A colheita ja tem dados operacionais ricos porque o ticket de balanca e um ponto de controle fisico. Usar como referencia do que e possivel:

| Dado | Colheita (806 pesagens) | Plantio (152 registros) | Gap |
|------|------------------------|------------------------|-----|
| Data da operacao | 100% | 6% | Critico |
| Talhao | 100% | 40% | Alto |
| Cultura | 100% | 100% | OK |
| Area | via talhao | 60% | Medio |
| Maquina (placa) | 100% (caminhao) | 0% | Critico |
| Operador (motorista) | 100% | 0% | Critico |
| Peso/quantidade | 100% (peso liquido) | 0% (populacao) | Critico |
| Qualidade (umidade, impureza) | 100% | 0% (umidade solo) | N/A diferente |

**Licao:** O ticket de balanca funciona porque e **obrigatorio e no fluxo** — o caminhao nao pode sair sem ser pesado. O formulario de plantio precisa ser igualmente inevitavel: o Tiago so "fecha" a operacao no sistema quando confirma que o plantio aconteceu.

---

## 8. Dependencias e Pre-requisitos

Para o workflow de coleta de plantio funcionar, estas entidades ja devem existir:

| Entidade | Status | Acao pendente |
|----------|--------|---------------|
| FAZENDAS | OK — 9 fazendas curadas | — |
| TALHOES | OK — 71 talhoes curados | Nomes inconsistentes entre fontes |
| SAFRAS | OK — seeds prontos | — |
| CULTURAS | OK — 126 culturas no seed | — |
| MAQUINAS | OK — 57 maquinas + 126 implementos | Validar com Tiago detalhamento |
| OPERADORES | OK — 15 operadores curados | — |
| TALHAO_SAFRA | PARCIAL — historico via colheita, 25/26 no CSV | Importar CSV 25/26 como "planejado" |
| talhao_mapping | PENDENTE — tabela existe no DDL sem dados | Gerar mapping quando necessario |

---

## 9. Resumo de Decisoes

| Decisao | Justificativa |
|---------|---------------|
| Priorizar data_plantio como primeiro campo novo | 6% historico — maior gap relativo, e o campo mais basico de uma operacao |
| Import de planilha antes de form completo | Quick win — Alessandro ja produz xlsx, zero mudanca de workflow |
| Audio como opcao desde P2 (nao P0) | Precisa testar STT com ruido rural primeiro — form simples e suficiente para Tiago no P0 |
| Nao coletar profundidade/umidade solo no P0-P1 | 0% historico e Alessandro indicou que tipo de solo nao influencia manejo na SOAL |
| Receituario fora do scope de coleta plantio | Alessandro: "nem sempre o que ta no receituario e o que a gente vai estar fazendo" |
| Form de 3 toques para operador | Operator POV: maos sujas, sol, pressa — quanto menos toques, mais adesao |

---

## 10. Verificacao

- [x] Documento cobre TODOS os campos do DDL para as 3 entidades (TALHAO_SAFRA: 10 campos, OPERACAO_CAMPO: 15 campos, PLANTIO_DETALHE: 9 campos)
- [x] Cada campo tem: historico %, responsavel, metodo proposto, prioridade
- [x] Workflow proposto e consistente com descobertas da reuniao Alessandro (prescricao → execucao → verificacao)
- [x] Quick wins sao realmente quick (import planilha existente, form 3 campos)
- [x] Respeita restricoes: offline-first, audio, 3 toques, Capinzal unica cultura
- [x] Comparacao com colheita como benchmark interno

---

*Preparado por: DeepWork AI Flows | 2026-03-05*
