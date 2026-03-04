# Reunião Claudio — 02/Mar/2026

## Objetivo: Coleta de dados + Alinhamento de próximos passos

**Participantes:** Rodrigo + Claudio
**Contexto:** Estamos na fase de coleta de dados (Bronze layer). Temos os ETL scripts prontos, temos CSVs de importação gerados para 8 das 10 fases, mas precisamos completar dados que só os stakeholders têm.

---

## PARTE 1 — Dados da Organização ✅ RESOLVIDO

> CNPJ encontrado online — dados preenchidos automaticamente.

| Dado                 | Valor                                                                                | Status   |
| -------------------- | ------------------------------------------------------------------------------------ | -------- |
| CNPJ                 | **31.561.869/0001-39**                                                         | ✅       |
| Razão Social        | Serra da Onca Agropecuaria Ltda.                                                     | ✅       |
| Endereço            | Fazenda Santana do Iapo, S/N, Jararaca                                               | ✅       |
| Município           | **Piraí do Sul** / PR                                                         | ✅       |
| CEP                  | 84.240-000                                                                           | ✅       |
| CNAE Principal       | 0115-6 — Cultivo de soja                                                            | ✅       |
| Porte                | Micro                                                                                | ✅       |
| Capital Social       | R$ 8.400.000,00                                                                      | ✅       |
| Data Abertura        | 20/09/2018                                                                           | ✅       |
| Situação           | ATIVA                                                                                | ✅       |
| Sócios              | Claudio H. Kugler, Claudio Kugler, Elsa Maria Kugler, Erich R. Kugler, Silvia Kugler | ✅       |
| Inscrição Estadual | ❌ confirmar com Valentina                                                           | pendente |
| Regime Tributário   | ❌ confirmar com Valentina                                                           | pendente |

**CNAEs secundários:** Bovinos corte (0151-2-01), Milho (0111-3-02), Trigo (0111-3-03), Feijão (0119-9-05), Outros cereais (0111-3-99), Pinus (0210-1-03), Eucalipto (0210-1-01), Ovinos (0153-9-02), Frangos (0155-5-01)

> **Nota:** Município registrado é Piraí do Sul, não Castro. Verificar com Claudio se correto.

---

## ~~PARTE 2 — Cadastro de Usuários~~ → DEFINIR DEPOIS

> Já temos os 8 usuários mapeados (Claudio, Tiago, Valentina, Alessandro, Josmar, Vanessa + Rodrigo/João). Detalhes de contato serão coletados mais pra frente quando formos configurar o sistema.

---

## PARTE 3 — UBG e Silos: Fluxo do Grão (FOCO DA REUNIÃO)

> A UBG é o coração operacional pós-colheita. Sabemos como o grão CHEGA (Ticket Balança), mas precisamos entender como ele se MOVE dentro da UBG e como SAI.

### 3.1 — Fluxo de entrada no silo

Hoje sabemos que o grão chega na UBG e o Josmar registra o Ticket Balança (peso, umidade, cultura, talhão). **Mas o que acontece depois?**

**Perguntas para Claudio/Josmar:**

1. **Como decide em qual silo vai o grão?** Critério fixo (silo 1 = soja, silo 2 = milho) ou varia por safra/necessidade?
2. **Existe registro histórico de qual grão foi para qual silo?** Ou só controla o total?
3. **A secagem acontece ANTES de ir pro silo ou o silo tem secador embutido?** (fluxo: moega → secador → silo? ou moega → silo com aeração?)
4. **Quantos silos exatamente?** Estimamos 8 — confirmar quantidade, nome/número de cada um
5. **Tem silo específico para sementes?** (sementes certificadas Castrolanda são separadas?)

### 3.2 — CNPJ e Personalidade Jurídica da UBG

6. **A UBG tem CNPJ próprio ou opera sob o CNPJ da SOAL?** (31.561.869/0001-39)
7. **Se tem CNPJ separado, qual é?** Isso muda como NFs são emitidas
8. **As NFs de venda para Castrolanda saem em nome de quem?** SOAL ou UBG?

### 3.3 — Repasse interno: UBG → Organização

> Ponto crítico: a UBG processa grãos, mas parte do output volta para uso interno da própria SOAL.

9. **Sementes:** Quando a UBG beneficia sementes para a própria SOAL usar no plantio, como registra essa saída? Existe NF interna? Transferência formal? Ou é "anotação no caderno"?
10. **Alimento para pecuária:** Quando grão/subproduto (silagem, farelo, quirera) sai da UBG para alimentar o gado, como é registrado hoje? Tem controle de quantidade?
11. **Existe um "preço interno" ou "custo de transferência"?** Ex: soja que a UBG beneficiou e "devolveu" para a agricultura — a UBG cobra algum custo? Ou é custo direto?
12. **Subprodutos comercializados:** Feno, quirera, milho, aveia, pré-secado — são vendidos a terceiros? Como controla essa receita separada?

### 3.4 — Pesagem pública (receita UBG)

13. **A balança da UBG faz pesagem para terceiros?** (bovinos, suínos, eucalipto, pinus)
14. **Qual o valor cobrado por pesagem externa?** (tinha R$2,50 — ainda vale?)
15. **Como registra hoje?** Caderno separado? Mesma planilha dos tickets?
16. **A comissão do Josmar (0,01% receita + R$2,50/pesagem) ainda vale?** Regras mudaram?

### 3.5 — Dados técnicos UBG (para Josmar)

| Dado                          | O que precisa                                               | Quem sabe |
| ----------------------------- | ----------------------------------------------------------- | --------- |
| Fazenda sede da UBG           | Qual fazenda/propriedade?                                   | Claudio   |
| Capacidade recepção (t/dia) | Pico de safra                                               | Josmar    |
| Capacidade secagem (t/dia)    | Capacidade total                                            | Josmar    |
| Software atual                | Usa algum software? Ou 100% manual?                         | Josmar    |
| Responsável técnico         | Quem é o RT? Tem CREA?                                     | Claudio   |
| Lista completa de silos       | Nome, capacidade, material, aeração, termometria por silo | Josmar    |

**Ação Claudio:** Essas perguntas podem ser respondidas parte com Claudio hoje, parte com Josmar em separado. As perguntas de CNPJ e repasse interno são decisões estratégicas do Claudio.

---

## PARTE 3B — Validação Estrutura Territorial: Fazendas → Talhões

> Dados extraídos do AgriWin. Claudio precisa confirmar se está tudo correto.

### Resumo por fazenda

| # | Fazenda                                     | Talhões     | Área total          | Controle    |
| - | ------------------------------------------- | ------------ | -------------------- | ----------- |
| 1 | **FAZENDA SANTANA DO IAPO**           | 23           | 419,0 ha             | COOPERATIVA |
| 2 | **FAZENDA SANTO ANDRE**               | 19           | 575,8 ha             | COOPERATIVA |
| 3 | **FAZENDA SANTO ANTONIO DO CAPINZAL** | 15           | 293,1 ha             | COOPERATIVA |
| 4 | **FAZENDA LAJEADO DO SAO JOAO**       | 5            | 482,1 ha             | COOPERATIVA |
| 5 | **FAZENDA SAO FRANCISCO**             | 4            | 161,5 ha             | COOPERATIVA |
| 6 | **FAZENDA SANTA RITA**                | 3            | 73,5 ha              | COOPERATIVA |
| 7 | **FAZENDINHA DO CAPINZAL**            | 2            | 46,5 ha              | COOPERATIVA |
|   | **TOTAL**                             | **71** | **2.051,6 ha** |             |

### Perguntas para Claudio:

**A — Fazendas:**

1. **São 7 fazendas corretas?** Falta alguma? Sobra alguma?
2. **Fazenda São Francisco:** Tem duas entradas — "FAZENDA SÃO FRANCISCO" (inativa) e "FAZENDA SAO FRANCISCO" (ativa). São a mesma? A inativa pode ser removida?
3. **"FAZENDINHA DO CAPINZAL" vs "FAZENDA SANTO ANTONIO DO CAPINZAL"** — são fazendas DIFERENTES ou a Fazendinha é parte do Capinzal?

**B — Propriedades sem talhões (existem no cadastro mas sem terra mapeada):**

| Propriedade            | Status  | Atividade            | O que é?                                                                                                                                                        |
| ---------------------- | ------- | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SANTANA DO IAPO        | ATIVA   | LEITE (erro AgriWin) | Duplicata da Fazenda Santana do Iapo? SOAL**não tem pecuária de leite** — dado incorreto no AgriWin. Remover ou unificar com a Fazenda Santana do Iapo? |
| UBG                    | ATIVA   | AGRÍCOLA            | A UBG é uma "propriedade" ou deveria ser uma entidade separada?                                                                                                 |
| FLORESTA               | ATIVA   | AGRÍCOLA            | O que é? Fazenda separada? Área de reserva?                                                                                                                    |
| PECUARIA               | ATIVA   | AGRÍCOLA            | Setor de pecuária? Área separada?                                                                                                                              |
| FAZENDA SÃO FRANCISCO | INATIVA | —                   | Entrada antiga da São Francisco ativa? Pode apagar?                                                                                                             |

**C — Talhões específicos:**
4. **"AREAS ARRENDADAS" (Lajeado, 162 ha)** — isso é UM talhão ou é um agrupamento de áreas arrendadas de terceiros? Quantos talhões reais são?
5. **"PAILO DIREITO SAFRINHA" (Sto Andre, 25,17 ha)** — tem o mesmo talhão "132 PAILO DIREITO" com mesma área. É duplicata para controle de safrinha?
6. **Talhão "10 PINUS" (Santana, 37,76 ha)** — é área de plantio de pinus (reflorestamento)? Entra no controle de safra ou é separado?
7. **Talhões muito pequenos** (<3 ha: 71 IRNO 2,23 / 81 LAGARTO 1,76 / 82 LAGARTO 1,99 / 133 ABOBORA 1,05 / 70 LAJEADO 0,98) — esses são realmente plantados? Ou são cantinhos de pasto/infraestrutura?

### Detalhe por fazenda (para conferência visual com Claudio)

**FAZENDA SANTANA DO IAPO (23 talhões — 419 ha):**

```
10 PINUS          37,76    40 SEDE           23,74    60 IRNO           11,96
20-21 SERRA       43,71    41 SEDE CASA       6,02    62 IRNO           62,69
22 SERRA           5,15    42 SEDE NOVO       6,22    65 IRNO           17,57
23 MANGUEIRA      16,58    50 TANQUE         52,83    70 IRNO            9,98
27 S. PEDRO       10,93    51 TANQUE          2,29    71 IRNO            2,23
30 A IAPO         10,06    72 MASAKI         19,45    80 LAGARTO        17,32
30 B IAPO         23,57    81 LAGARTO         1,76    90 LAGOA          23,82
LAGO DO DIRCEU    11,40    82 LAGARTO         1,99
```

**FAZENDA SANTO ANDRE (19 talhões — 575,8 ha):**

```
130 PAILO ESQ     36,02    160 CAQUI         26,43    190 CINCO         40,13
131 SAO ROQUE      9,20    170 KUGIMA        15,56    200 GRANDE       159,74
132 PAILO DIR     25,17    171 KUGIMA        24,88    210 IGREJINHA     26,24
133 ABOBORA        1,05    172 KUGIMA        37,32    220 14 ALQ        34,32
134 ABOBORA        5,63    180 BONIN         31,13    PAILO DIR SAFR   25,17
140 ABOBORA       20,20    181 BONIN          6,69
150 CAPISTRIANO   40,05    182 RIVA          10,91
```

**FAZENDA SANTO ANTONIO DO CAPINZAL (15 talhões — 293,1 ha):**

```
05-20             13,94    40 BANACK         18,00    90 HERMATRIA      21,49
10-11-12 SEDE     58,76    50-70 BANACK      16,25    100 VEINHA        15,56
13 CAPELA          9,86    60 BASTIAO        11,92    110 FORNO         40,95
14-30 SEDE        30,25    80 URUGUAI        14,10    BANACH NOVO        6,35
15 JABUTICABEIRA  13,74    81 CAMPINHO        3,32    DESTOCA JABUT     18,59
```

**FAZENDA LAJEADO DO SAO JOAO (5 talhões — 482,1 ha):**

```
10.20              96,19    70                 0,98    AREAS ARRENDADAS 162,05
40                141,31    90                81,59
```

* [ ] **FAZENDA SAO FRANCISCO (4 talhões — 161,5 ha):**

```
FURA BUCHO 120    29,51    NARITA            41,43
PIALADO           31,42    TANAKA 110        59,12
```

**FAZENDA SANTA RITA (3 talhões — 73,5 ha):**

```
230               48,98    240               18,77    241                5,78
```

**FAZENDINHA DO CAPINZAL (2 talhões — 46,5 ha):**

```
120 GRAMADINHO    30,52    130 FAZENDINHA    15,98
```

---

## PARTE 3C — Lista Completa de Funcionários / Trabalhadores

> Precisamos da lista completa de todas as pessoas que trabalham na SOAL — não só os que vão usar o sistema, mas TODOS. Isso alimenta a entidade TRABALHADOR_RURAL e é essencial para vincular operações de campo, abastecimentos e manutenções a pessoas reais.

**O que já temos (6 pessoas identificadas como stakeholders):**

| Nome          | Função conhecida                                              |
| ------------- | --------------------------------------------------------------- |
| Tiago         | Gerente de Maquinário                                          |
| Valentina     | Administrativa                                                  |
| Alessandro    | Agrônomo                                                       |
| Josmar        | Operador UBG / Balança                                         |
| Vanessa       | Operadora Balança                                              |
| Osvaldo Bueno | Responsável caminhão VP-01 (aparece na planilha de máquinas) |

**O que precisamos do Claudio:**

1. **Lista completa de funcionários** com: nome completo, função/cargo, setor (agricultura, maquinário, UBG, pecuária, administrativo)
2. **Operadores de máquina** — quem opera quais equipamentos? (crucial para vincular operações de campo)
3. **Trabalhadores terceirizados/temporários?** — Tem diaristas de safra? Prestadores de serviço fixos? (KB Precisão, Benedito Lopes aparecem no Vestro)
4. **Quem são os motoristas/operadores no sistema Vestro?** — O Vestro tem IDs numéricos (1 a 34) para operadores, precisamos saber quem é quem

**Formato ideal:** Planilha simples ou lista no WhatsApp com:

```
Nome completo | Cargo/Função | Setor | Opera quais máquinas?
```

**Ação Claudio:** Pedir pro Tiago ou Valentina montar essa lista (eles sabem quem é quem no dia a dia).

---

## PARTE 4 — Dados financeiros pendentes (Valentina)

### 4.1 Arquivos que precisamos re-obter

> Alguns arquivos de dados foram perdidos e precisamos re-exportar das fontes.

| Dado                                     | Fonte                      | Quem re-exporta    | Urgência |
| ---------------------------------------- | -------------------------- | ------------------ | --------- |
| Parceiros/Fornecedores (2.201 registros) | AgriWin                    | Valentina ou João | Alta      |
| Insumos catálogo (18.499 registros)     | AgriWin                    | Valentina ou João | Alta      |
| Ticket Balança 23/24 (3 xlsx)           | Planilha da Vanessa/Josmar | Josmar             | Alta      |
| Abastecimentos Vestro (1.172 registros)  | Portal Vestro              | João              | Média    |

**Pergunta para Claudio:** O AgriWin ainda está acessível para exportar? O João ou Valentina conseguem entrar e exportar novamente?

### 4.2 Castrolanda — já temos fonte, precisa re-processar

| Dado                                     | Registros | Fonte disponível?            |
| ---------------------------------------- | --------- | ----------------------------- |
| Capital (retenções + capitalizações) | 119       | ✅ 15 arquivos em ~/Documents |
| Extrato conta corrente                   | 8.211     | ❓ Re-baixar do portal        |
| Conta corrente detalhada                 | 2.889     | ❓ Re-baixar do portal        |
| Vendas                                   | 170       | ❓ Re-baixar do portal        |
| Carga-a-Carga                            | 1.337     | ❓ Re-baixar do portal        |
| Financiamentos                           | 220       | ❓ Re-baixar do portal        |

**Pergunta para Claudio:** Quem tem login no portal da Castrolanda? O Rodrigo consegue re-baixar ou precisa pedir para Valentina?

---

## PARTE 5 — Reunião com Tiago (agendar esta semana)

> Documento completo preparado: `VALIDACAO_TIAGO_MAQUINAS.md` (9 seções) + `README_REUNIAO_TIAGO_OPERACOES.md` (16 perguntas)

### Resumo do que tratar com Tiago:

**Bloco A — Maquinário (bloqueadores de importação):**

1. Código para 2 máquinas ativas sem código
2. Padrão de código para 37 implementos sem código
3. Responsável para 19 máquinas sem responsável definido
4. Confirmar 5 vendas + 11 vínculos implemento→trator

**Bloco B — Vestro (dados de combustível):**
5. Identificar TQMOVEL, TQCAPINZAL, MEPEL (54 abastecimentos sem destino)
6. Relatório Vestro com preço real por litro (PPU=1 em 100%)
7. Significado do campo M.Mot.
8. Incluir abastecimentos de terceiros no sistema?

**Bloco C — Operações de campo (histórico):**
9. Quantas colheitadeiras? Qual colheu qual cultura?
10. Datas aproximadas de plantio por cultura
11. Quantas plantadeiras? Operadores fixos?
12. Registro de pulverizações existe? (caderno, planilha)
13. Quem decide o que aplicar — Alessandro ou Tiago?

**Ação Claudio:** Pode agendar 1h com Tiago nos próximos dias? Rodrigo participa.

---

## PARTE 6 — Alessandro (agendar separado)

| Dado                             | Urgência | Notas                                     |
| -------------------------------- | --------- | ----------------------------------------- |
| Análise de solo por talhão     | Média    | Alessandro tem os laudos? Em que formato? |
| Recomendação de adubação     | Média    | Prescreve para TODOS os talhões?         |
| Receituário de defensivos       | Média    | Tem histórico ou só faz no momento?     |
| Espaçamento/população padrão | Baixa     | Padrão por cultura                       |

**Ação Claudio:** Verificar disponibilidade do Alessandro para uma call de 30min.

---

## PARTE 7 — Resumo: O que cada pessoa precisa fazer

### Claudio (hoje):

- [X] ~~CNPJ~~ → ✅ Encontrado online: **31.561.869/0001-39** (Piraí do S	ul/PR)
- [X] **Confirmar município:** Registro diz Piraí do Sul — correto ou é Castro? Correto Piraí do Sul
- [ ] **Validar fazendas + talhões** (Parte 3B — 7 perguntas)
- [ ] **UBG CNPJ:** A UBG tem CNPJ próprio ou opera sob o mesmo?
- [ ] **Repasse interno:** Como funciona UBG→agricultura (sementes) e UBG→pecuária (alimento)?
- [ ] **Lista de funcionários:** Pedir pro Tiago ou Valentina montar lista completa

### Tiago (reunião esta semana):

- [ ] Validar máquinas (9 seções — ~45min)
- [ ] Responder 16 perguntas sobre operações de campo (~30min)
- [ ] Repassar dados de colheita 23/24 e plantio 24/25

### Valentina (esta semana):

### Josmar (esta semana):

- [ ] Lista completa de silos (nome, capacidade, material, aeração, termometria)
- [ ] Dados UBG (capacidade recepção/secagem, software, RT)
- [ ] Re-enviar 3 xlsx Ticket Balança 23/24 (soja, milho, feijão)
- [ ] Contatos (sobrenome, email, telefone) dele e da Vanessa
- [ ] Alessandro (próxima semana):

- [ ] Laudos de análise de solo (formato?)
- [ ] Recomendações de adubação
- [ ] Receituários de defensivos

### João (DeepWork):


Re-exportar Parceiros do AgriWin (xlsx)

Re-exportar Insumos do AgriWin (xlsx)

- [ ] Re-exportar dados Vestro portal
- [ ] Verificar se AgriWin roda para re-exportar
- [ ] Backup dos xlsx de Maquinário Histórico (11 arquivos)

---

## STATUS GERAL — O que já temos pronto

| O que                        | Registros | Status                |
| ---------------------------- | --------- | --------------------- |
| 9 culturas mapeadas          | 9         | ✅                    |
| 12 fazendas/propriedades     | 12        | ✅                    |
| 74 talhões                  | 74        | ✅                    |
| 170 mapeamentos nome talhão | 170       | ✅                    |
| 9 safras históricas         | 9         | ✅                    |
| 183 máquinas/implementos    | 183       | ✅                    |
| 5 tanques de combustível    | 5         | ✅                    |
| 63 talhão-safra 24/25       | 63        | ✅                    |
| 54 talhão-safra 25/26       | 54        | ✅                    |
| 1 organização              | 1         | ✅ CNPJ preenchido    |
| 8 usuários (parcial)        | 8         | ⚠ falta contatos     |
| 1 UBG (template)             | 1         | ⚠ falta dados Josmar |
| 8 silos (template)           | 8         | ⚠ falta dados Josmar |
| 12 ETL scripts recuperados   | —        | ✅ prontos para rodar |
| 6 documentos técnicos       | —        | ✅                    |

**Total registros prontos: ~580+**
**Total registros pendente re-processamento: ~86.000** (ETLs prontos, falta xlsx fonte)

---

*Preparado por: Rodrigo Kugler — DeepWork AI Flows*
*Data: 02/03/2026*
