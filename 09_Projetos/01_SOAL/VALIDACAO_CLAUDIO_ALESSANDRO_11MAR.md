# Validacoes Pendentes — Claudio & Alessandro

> **Data:** 2026-03-11
> **Origem:** Reuniao tecnica Joao × Rodrigo (10/03/2026) + Doc 32 (Lifecycle) + Process Flow Planejamento Safra
> **Objetivo:** Consolidar TODAS as decisoes pendentes para validar com Claudio e Alessandro
> **Como usar:** Roteiro de conversa — ler pergunta, anotar resposta no campo `>>`

---

## BLOCO A — Kanban Lifecycle TALHAO_SAFRA

**Contexto:** O lifecycle do talhao-safra tem 9 estados: `rascunho` → `em_revisao` → `aprovado` → `preparando` → `plantado` → `em_desenvolvimento` → `colhendo` → `colhido` | `cancelado`. Precisamos validar as **regras de transicao** entre estados.

**Perguntar para:** Alessandro (workflow tecnico) + Claudio (aprovacoes)

---

### A1. Quem aprova o plano de safra?

O estado `em_revisao` → `aprovado` e a aprovacao final. Hoje o Process Flow preve 3 rodadas:
- 1a rodada: Alessandro preenche
- 2a rodada: Lucas revisa
- 3a rodada: Claudio aprova

**Pergunta:** So Claudio pode aprovar? Ou Alessandro tambem tem autonomia pra aprovar talhoes mais simples (ex: aveia preta de cobertura)?

>> Resposta:

---

### A2. O que e obrigatorio pra comecar a preparacao?

Transicao `aprovado` → `preparando` (1a operacao de solo/dessecacao).

**Pergunta:** A aprovacao e suficiente pra Tiago comecar? Ou precisa de algum dado extra alem do plano aprovado? (ex: insumos ja comprados, analise de solo atualizada)

>> Resposta:

---

### A3. Dados obrigatorios no registro de plantio

Transicao `preparando` → `plantado` (operacao tipo plantio registrada).

**Pergunta:** Quais dados o operador DEVE informar ao registrar plantio?
- Maquina + operador + data: isso e suficiente?
- Precisa registrar quantidade de semente (kg/ha)?
- Precisa registrar adubo de base (produto + dose)?
- Ou esses dados vem de outro lugar (nota fiscal, Alessandro)?

>> Resposta:

---

### A4. Quem confirma que o talhao entrou "em desenvolvimento"?

Transicao `plantado` → `em_desenvolvimento` (apos 1a operacao de manejo pos-plantio).

**Pergunta:** Isso e automatico quando Tiago registra a 1a pulverizacao/adubacao? Ou alguem precisa confirmar manualmente que o plantio "pegou" (emergencia confirmada)?

>> Resposta:

---

### A5. Quem decide que comecou a colheita?

Transicao `em_desenvolvimento` → `colhendo` (1o ticket de balanca chega).

**Pergunta:** E automatico quando Vanessa pesa o 1o caminhao? Ou Tiago/Alessandro precisam marcar "colheita iniciada" antes?

>> Resposta:

---

### A6. Quem decide que a colheita acabou?

Transicao `colhendo` → `colhido` (encerramento).

**Pergunta:** Quem confirma que nao tem mais grao pra colher naquele talhao?
- Tiago decide no campo?
- Alessandro valida depois?
- Ou e por tempo (X dias sem ticket = encerrado)?

>> Resposta:

---

### A7. Manejo minimo obrigatorio

**Pergunta:** E verdade que TODA safra tem ao menos 1 pulverizacao? Existe excecao? (ex: aveia preta de cobertura sem nenhum tratamento, ou milheto dessecado e pronto)

>> Resposta:

---

### A8. Templates de operacoes — offsets corretos?

Os templates geram operacoes automaticas com offset em dias a partir da data de plantio:

| Operacao | Soja | Milho | Feijao | Trigo | Cevada | Aveia Preta |
|----------|------|-------|--------|-------|--------|-------------|
| Dessecacao | -15d | -15d | -15d | — | — | — |
| Plantio | 0 | 0 | 0 | 0 | 0 | 0 |
| 1a Pulv | +15d | +20d | +10d | +20d | +20d | — |
| 2a Pulv | +30d | +40d | +25d | +40d | +40d | — |
| Adubacao cob | +25d | +30d | +20d | +30d | +30d | — |
| Colheita | +130d | +150d | +90d | +120d | +120d | +90d |

**Pergunta para Alessandro:** Esses numeros estao no ballpark? Quais estao errados? (nao precisa ser exato — e pra gerar sugestao, operador ajusta depois)

>> Resposta:

---

### A9. Campo "epoca" (safra vs safrinha)

O campo `epoca` em TALHAO_SAFRA diferencia safra de verao vs safrinha. Joao questionou se a data de plantio ja nao resolve isso sozinha.

**Pergunta:** Precisa do campo `epoca` explicitamente? Ou a data ja basta pra saber se e safra/safrinha?

>> Resposta:

---

### A10. Ervilha forrageira — template novo

Novidade prevista pra safra 26/27 (recomendacao Fundacao ABC, cobertura pre-milho).

**Pergunta para Alessandro:**
- Quantas operacoes a ervilha forrageira precisa? (plantio, alguma pulv, dessecacao?)
- Ciclo em dias? (plantio ate dessecacao/incorporacao)
- Quais offsets aproximados?

>> Resposta:

---

## BLOCO B — UBG / Ticket Balanca

**Contexto:** A UBG (secagem e armazenamento) e o ponto de transferencia entre agricultura e comercializacao. Precisamos detalhar o fluxo operacional.

**Perguntar para:** Claudio (geral) + Josmar (operacional, via Claudio ou direto)

---

### B1. Modelo da balanca

**Pergunta:** Qual marca, modelo e ano da balanca? Tem saida digital (serial/USB/rede) ou e 100% leitura manual do display?

>> Resposta:

---

### B2. Equipamento de medicao de umidade

**Pergunta:** Qual marca e modelo do medidor de umidade? Josmar usa o MESMO equipamento pra:
- Amostragem inicial (ticket balanca, quando o caminhao chega)
- Controle de secagem (leitura a cada 30 min)

Ou sao equipamentos diferentes?

>> Resposta:

---

### B3. Nomenclatura interna

**Pergunta:** Quando o caminhao chega e Josmar coleta a amostra, como eles chamam essa etapa? "Recebimento"? "Amostragem"? "Classificacao"? Outro nome?

>> Resposta:

---

### B4. Placa do veiculo — obrigatoriedade

Hoje Vanessa nem sempre preenche a placa. Se o sistema tornar obrigatorio:

**Pergunta:** Isso gera resistencia? Vanessa concorda? Tem caminhao que chega sem placa visivel (ex: carreta, trator com carreta)?

>> Resposta:

---

### B5. Campos do controle de secagem

Na planilha dummy, os campos a cada 30 min sao: temperatura grao, pressao P1/P2/P3, destino pos-secagem.

**Pergunta para Josmar:** Esses sao os campos que voce realmente anota? Tem mais algum? (ex: vazao de ar, pressao de gas, observacao visual)

>> Resposta:

---

### B6. Semente vs commodity na secagem

**Pergunta:** Confirmar:
- Semente SEMPRE vai pro silo pulmao (nunca usa secador convencional)?
- A temperatura de secagem de semente e mais baixa? Qual a maxima?
- O processo e mais lento por causa disso?

>> Resposta:

---

### B7. Rateio do custo de lenha

A UBG consome lenha pra aquecer o secador. Hoje Claudio faz esse calculo manualmente.

**Pergunta:** Como voce rateia o custo de lenha entre as culturas? Por tonelada recebida? Por area plantada? Por tempo de secagem? Outro criterio?

>> Resposta:

---

### B8. Percentual de quebra na secagem

**Pergunta:** Existe um percentual padrao de perda (quebra tecnica) por cultura na secagem?
- Ex: soja perde X%, milho perde Y%?
- Ou e calculado caso a caso pela diferenca peso entrada vs peso seco?

>> Resposta:

---

## BLOCO C — Custeio e Financeiro

**Perguntar para:** Claudio

---

### C1. Granularidade do custeio

**Pergunta:** O custeio (quanto gastou pra produzir) e sempre por TALHAO_SAFRA individual? Ou as vezes voce calcula por fazenda inteira ou por cultura?

>> Resposta:

---

### C2. Registro de compra de insumo

**Pergunta:** Quem registra a compra de insumo?
- Valentina (administrativo, nota fiscal)?
- Alessandro (quando prescreve)?
- Os dois em momentos diferentes?

E o que e mais importante no sistema: registrar a COMPRA (nota fiscal, preco, data) ou o CONSUMO/APLICACAO (quanto usou em cada talhao)?

>> Resposta:

---

### C3. Estoque fisico de insumos

**Pergunta:** Voces controlam ONDE cada insumo esta fisicamente guardado? (ex: barracoes por fazenda) Ou e tudo centralizado num deposito so e "quem precisa vai la e pega"?

>> Resposta:

---

## BLOCO D — Nomenclatura e UX

**Perguntar para:** Claudio

---

### D1. Gleba vs subtalhao

Na planilha de producao, talhoes como CAPINZAL tem subdivisoes: HERMATRIA, BANACK, URUGUAI. Na planilha esta como "gleba".

**Pergunta:** Como voce prefere chamar no sistema? "Gleba"? "Subtalhao"? "Area"? Outro?

>> Resposta:

---

### D2. Soja-semente vs soja-commodity

A SOAL produz semente certificada pra Castrolanda (soja-semente) alem de soja comum (commodity).

**Pergunta:** No dia a dia, voces tratam como culturas DIFERENTES (tipo "soja semente" e um nome separado) ou como MESMA cultura com uma flag/observacao? Como voce fala na pratica?

>> Resposta:

---

## BLOCO E — Workflow Real (gaps do Doc 32)

**Perguntar para:** Alessandro

---

### E1. Aprovacao formal vs informal

**Pergunta:** Hoje a aprovacao do plano de safra e formal (sentam os 3, revisam em reuniao, aprovam) ou informal (WhatsApp "beleza, pode plantar")? Tem as 3 rodadas certinho ou as vezes pula direto?

>> Resposta:

---

### E2. Operacao nao planejada

**Pergunta:** Com que frequencia acontece uma operacao emergencial nao prevista? (ex: pulverizacao por praga inesperada, replantio por geada)
- Como e decidido hoje? Alessandro liga pro Tiago?
- Precisa de aprovacao do Claudio?

>> Resposta:

---

### E3. Registro em tempo real vs fim do dia

**Pergunta:** Tiago registra as operacoes de campo em tempo real (durante a operacao) ou consolida no fim do dia/semana? Ele tem Starlink no campo pra fazer em tempo real?

>> Resposta:

---

## Resumo — Checklist de Itens

| # | Tema | Quem responde | Respondido? |
|---|------|--------------|-------------|
| A1 | Quem aprova plano safra | Claudio + Alessandro | [ ] |
| A2 | Pre-requisito pra preparacao | Claudio + Alessandro | [ ] |
| A3 | Dados obrigatorios plantio | Alessandro + Tiago | [ ] |
| A4 | Transicao em_desenvolvimento | Alessandro + Tiago | [ ] |
| A5 | Inicio da colheita | Alessandro + Tiago | [ ] |
| A6 | Fim da colheita | Claudio + Tiago | [ ] |
| A7 | Manejo minimo obrigatorio | Alessandro | [ ] |
| A8 | Templates offsets | Alessandro | [ ] |
| A9 | Campo epoca | Alessandro + Claudio | [ ] |
| A10 | Ervilha forrageira template | Alessandro | [ ] |
| B1 | Modelo balanca | Josmar/Claudio | [ ] |
| B2 | Medidor umidade | Josmar | [ ] |
| B3 | Nomenclatura etapa | Josmar/Vanessa | [ ] |
| B4 | Placa obrigatoria | Vanessa/Claudio | [ ] |
| B5 | Campos controle secagem | Josmar | [ ] |
| B6 | Semente vs commodity secagem | Josmar/Claudio | [ ] |
| B7 | Rateio custo lenha | Claudio | [ ] |
| B8 | Percentual quebra | Claudio/Josmar | [ ] |
| C1 | Granularidade custeio | Claudio | [ ] |
| C2 | Registro compra insumo | Claudio/Valentina | [ ] |
| C3 | Estoque fisico insumos | Claudio | [ ] |
| D1 | Gleba vs subtalhao | Claudio | [ ] |
| D2 | Soja-semente nomenclatura | Claudio | [ ] |
| E1 | Aprovacao formal vs informal | Alessandro | [ ] |
| E2 | Operacao nao planejada | Alessandro | [ ] |
| E3 | Registro tempo real vs batch | Tiago (via Alessandro) | [ ] |

**Total: 26 itens** | **Prioridade alta (bloqueiam dev):** A1-A6, B5-B6, C1 | **Prioridade media:** A7-A10, B1-B4, B7-B8, C2-C3, D1-D2 | **Prioridade baixa (nice to have):** E1-E3

---

*Gerado em 2026-03-11 | Fonte: Reuniao 10/03 + Doc 32 Lifecycle + Process Flow Planejamento Safra*
