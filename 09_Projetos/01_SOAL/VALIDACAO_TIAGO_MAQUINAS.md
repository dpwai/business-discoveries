# Validação com Tiago — Maquinário & Abastecimentos
**Data:** 2026-02-27
**Responsável:** Rodrigo Kugler
**Objetivo:** Validar e completar os dados de maquinário antes da importação no sistema

> Levar este documento para a reunião. Preencher as respostas do Tiago in loco ou por WhatsApp.
> Cada item tem uma decisão clara a tomar ou dado a coletar.

---

## SEÇÃO 1 — Lista de Máquinas (Máquinas ativas sem código formal)

Encontramos **2 máquinas ativas** sem código cadastrado. Precisamos de código antes de importar.

| Nome | Categoria | Responsável | Código proposto |
|------|-----------|-------------|-----------------|
| VEICULO S10 LTZ /25 (AKV 6B13) | VEICULO LEVE | Alessandro | S10-2025 ? |
| MISTURADOR DE SEMENTES TMS1000 TREVISAN /20 | MOTOR ELETRICO | — | ME-02 ? |

**Pergunta:** Qual código o Tiago quer usar para esses dois equipamentos?

---

## SEÇÃO 2 — Máquinas vendidas (confirmar status)

As máquinas abaixo estão registradas como VENDIDO na planilha. Confirmar com Tiago:

| Código | Nome | Status atual |
|--------|------|--------------|
| C-13 | Colh. JD STS9670 /13 | VENDIDO ✓? |
| I-04 | EMPILHADEIRA FG25 /11 | VENDIDO ✓? |
| T-04 | TRATOR JD 6110J /13 | VENDIDO ✓? |
| VL-03 | VEICULO S10 LTZ BC /23 (AKV 5C25) | VENDIDO ✓? |
| VL-05 | VEICULO MONTANA LS VM /19 (BCM 6J35) | VENDIDO ✓? |

**Pergunta:** Alguma dessas foi recomprada ou está errada?

---

## SEÇÃO 3 — Responsáveis ausentes em máquinas ativas

As máquinas abaixo estão ATIVAS mas sem responsável definido. Quem é o operador/responsável principal de cada uma?

| Código | Nome |
|--------|------|
| I-05 | CARREGADEIRA SEM 618D /19 |
| I-06 | ESCAVADEIRA XCMG XE150BR /20 |
| I-08 | MANIPULADOR JCB /22 |
| P-03 | PULV. JD M4030 /25 |
| T-06 | TRATOR JD 6170J /20 |
| T-07 | TRATOR NH TL 5.80PS /20 |
| T-11 | TRATOR NH TL 5.80C /22 |
| T-12 | TRATOR JD 6150J /23 |
| MT-01 | MOTO POP100I VM /18 (BCI 5373) |
| MT-02 | MOTO BROS BC /22 (SDP 2D72) |
| MT-03 | MOTO BROS VM /22 (RHU 4A77) |
| VP-03 | CAMINHAO GMC 15-190 /97 (AHJ 2949) |
| VP-05 | CAMINHAO VW 13.190 CRM /14 (BAG 1B72) |
| VP-06 | CAMINHAO MB2730 ATEGO BC /20 (AKV 6C62) |
| VP-07 | CAMINHAO MB2730 ATEGO CZ /21 (AKV 2C26) |
| VP-08 | CAMINHAO IVECO DAILY 65-170CD /21 (AKV 2C17) |
| ME-01 | MISTURADOR DE DEJETOS 7.5CV TRIFASICO IR3 |
| MB-01 | MOTOBOMBA TANQUE PULVERIZACAO |
| MB-02 | MOTOBOMBA KAWASHIMA 2POL |

**Pergunta:** Responsável principal de cada uma (ou "sem operador fixo")?

---

## SEÇÃO 4 — Implementos sem código (37 itens)

Os implementos abaixo são ATIVOS mas **não têm código** cadastrado. O sistema precisa de um código único para rastrear uso/manutenção.

Tiago define os códigos ou quer que a gente proponha um padrão?

| Nome do Implemento |
|--------------------|
| ROCADEIRA DE ARRASTO |
| ROLO AMASSADOR |
| CARRETA GRANELEIRA STARA (UBG) |
| CARRETA 4 RODAS (UBG) |
| CARRETA LENHA (UBG) |
| CARRETA GRANELEIRA STARA (CAPINZAL) |
| GRADE NIVELADORA TATU 42 DISCOS |
| GRADE NIVELADORA BALDAN 20 DISCOS |
| CARRETA 2 RODAS |
| CARRETINHA 2 RODAS PEQUENA (MURTINHO) |
| MUNCK VW BAG |
| ESPALHADOR DE ISCA DAL PONTE |
| DISTRIBUIDOR DE SEMENTES (PECUARIA) |
| DISTRIBUIDOR DE SEMENTES TRIOLIET MULLOS |
| PLATAFORMA TERCEIRO PONTO (PECUARIA) |
| ROCADEIRA HIDRAULICA |
| CACAMBA CARREGADEIRA (LOADALL JCB) |
| GUINCHO P/BAG (LOADALL JCB) |
| PEGADOR DE FARDOS MARISPAN (LOADALL JCB) |
| GARFO PALETEIRO (SEM) |
| PEGADOR DE FARDOS TANCO (SEM) |
| GUINCHO P/BAG (SEM) |
| CACAMBA CARREGADEIRA (SEM) |
| CONCHA TRASEIRA LARGA (310K) |
| CONCHA TRASEIRA ESTREITA (310K) |
| CONCHA TRASEIRA FURADA (310K) |
| CACAMBA CARREGADEIRA (310K) |
| GUINCHO P/BAG STARA (MF96) |
| CACAMBA CARREGADEIRA (MF96) |
| CONCHA TRASEIRA (MF96) |
| CACAMBA CARREGADEIRA (3CX JCB) |
| CONCHA TRASEIRA (3CX JCB) |
| CONCHA ESCAVADEIRA (XCMG) |
| CESTO AEREO P/MUNCK |
| CONJUNTO AUTOM. IRRIGACAO IRRIGABRASIL /19 |
| BALANCA JUNDIAI |
| PONTE ROLANTE OMIS BRASIL /21 |

**Pergunta:** Quer que a gente proponha um padrão de código (ex: `ACC-001`, `ACC-002`) ou tem uma lógica própria?
Esses itens precisam de código antes da importação.

---

## SEÇÃO 5 — Vínculos Implemento → Trator (confirmar)

A planilha registra qual implemento fica vinculado a qual trator, mas de forma informal.
Precisamos confirmar se esses vínculos estão corretos:

| Implemento (código) | Nome | Trator (referência) | Trator real (código) |
|---------------------|------|---------------------|----------------------|
| 341 | PLATAFORMA DRAPER JD730DA /23 | S660-01 | C-01? |
| 454 | PLATAFORMA DE CORTE JD630 /16 | S660-01 | C-01? |
| 285 | PLATAFORMA DRAPER JD730DA /19 | S660-02 | C-02? |
| 429 | PLATAFORMA DE MILHO NH /21 (429) | S660-02 | C-02? |
| 888 | PLATAFORMA DRAPER MACDON FD235 /23 | CR7 | C-03? |
| 392 | PLATAFORMA DE MILHO NH /21 (392) | CR7 | C-03? |
| 744 | PLANTADEIRA JD 1113 /22 (744) | T-09 | T-09 ✓ |
| 922 | PLANTADEIRA JD 1113 /22 (922) | T-10 | T-10 ✓ |
| 162 | SEMEADORA STARA GUAPITA 33 /25 | T-09 | T-09 ✓ |
| 233 | SEMEADORA STARA PRIMA 4590 /19 | 7200-10 | T-10? |
| 247 | SEMEADORA STARA PRIMA 4590 /20 | MF7415 | T-03? |

**Pergunta:** Os vínculos "S660-01 → C-01", "CR7 → C-03", "MF7415 → T-03", "7200-10 → T-10" estão corretos?

---

## SEÇÃO 6 — Vestro: Códigos de veículos desconhecidos

Nos registros de abastecimento do Vestro aparecem **3 códigos de equipamentos** que não existem na lista de máquinas da SOAL:

| Código Vestro | Abastecimentos | O que é? | Cadastrar no sistema? |
|---------------|---------------|----------|-----------------------|
| TQMOVEL | 42 | Tanque móvel de combustível? | SIM / NÃO |
| TQCAPINZAL | 7 | Tanque fixo em Capinzal? | SIM / NÃO |
| MEPEL | 5 | Máquina/equipamento Mepel? | SIM / NÃO |

**Pergunta:**
1. O que é cada um desses equipamentos?
2. Eles devem ser cadastrados como máquinas da SOAL?
3. Se sim, qual código usar?

---

## SEÇÃO 7 — Vestro: Preço do combustível ausente

**Problema crítico:** No relatório do Vestro, o campo PPU (Preço Por Unidade) está igual a **1** em 100% dos registros. Isso significa que `Valor Total = Volume em litros` — o custo real do combustível **não está registrado**.

Exemplo: 176,4 L de Diesel → Valor = R$ 176,40 (errado, deveria ser ~R$ 1.058)

**Pergunta:**
1. Existe outro relatório no Vestro que traz o preço real por litro?
2. Ou o preço é registrado em outro sistema (AgriWin, planilha)?
3. Sem esse dado, o custo de combustível por operação **não pode ser calculado**.

---

## SEÇÃO 8 — Vestro: Campo "M.Mot." (Motorista/Operador)

No relatório do Vestro existe um campo `M.Mot.` com valores numéricos pequenos (1 a 34). Atualmente estamos interpretando como **ID do operador no Vestro** (não como horímetro).

| Valor | Exemplo de uso |
|-------|---------------|
| 16 | Aparece em abastecimentos do DEJETOS/MB-03 |
| 1 | Aparece em abastecimentos de tractors |

**Pergunta:** O campo `M.Mot.` no Vestro é:
- [ ] ID do motorista/operador cadastrado no Vestro
- [ ] Horímetro do equipamento
- [ ] Outra coisa: _______________

---

## SEÇÃO 9 — Registros de terceiros no Vestro

Existem **144 abastecimentos** para veículos de terceiros (prestadores de serviço) registrados no sistema Vestro da SOAL:

| Empresa | Qtd abast. | Incluir no sistema SOAL? |
|---------|-----------|--------------------------|
| TERCEIROS (genérico) | 77 | ? |
| KB PRECISÃO (KBPREST) | 53 | ? |
| BENEDITO LOPES (BLOPES) | 14 | ? |

**Pergunta:** Esses abastecimentos de terceiros devem ser registrados no sistema SOAL ou são apenas para controle interno do Vestro?

---

## Resumo das decisões pendentes

| # | Decisão | Urgência |
|---|---------|----------|
| 1 | Código para 2 máquinas sem código | Alta — bloqueia importação |
| 2 | Confirmar 5 máquinas vendidas | Média |
| 3 | Responsável para 19 máquinas sem responsável | Média |
| 4 | Padrão de código para 37 implementos sem código | Alta — bloqueia importação |
| 5 | Confirmar 11 vínculos implemento→trator | Média |
| 6 | Identificar TQMOVEL, TQCAPINZAL, MEPEL | Alta — 54 abastecimentos sem destino |
| 7 | Encontrar relatório Vestro com PPU real | Alta — sem isso custo de combustível é inválido |
| 8 | Confirmar significado do campo M.Mot. | Média |
| 9 | Decidir sobre abastecimentos de terceiros | Baixa |

---

*Gerado por: DeepWork AI Flows | Rodrigo Kugler*
*Fontes: Lista_Maquinas_Consolidado.csv (183 registros) + Vestro_Abastecimentos_Clean.csv (1.172 registros)*
