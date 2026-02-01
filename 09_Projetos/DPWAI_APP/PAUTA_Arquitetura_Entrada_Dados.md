# Pauta: Arquitetura de Entrada de Dados DPWAI

**Data:** 2026-02-01
**Participantes:** Rodrigo (CEO/Produto) + Joao (CTO/Tecnico)
**Objetivo:** Alinhar estrategia de entrada de dados antes de implementar formularios

---

## Contexto

O app DPWAI precisa receber dados de multiplas fontes para alimentar os dashboards. Antes de construir os formularios, precisamos definir:
- O que sera entrada manual vs integracao automatica
- Quais APIs priorizar
- Como cada fonte alimenta cada dashboard

---

## 1. Mapeamento: Dashboard ← Fontes de Dados

| Dashboard | Dados Necessarios | Fonte Provavel | Tipo |
|-----------|-------------------|----------------|------|
| **Painel Operacional** | Visao geral consolidada | Agregacao de todas as fontes | Calculado |
| **Estoque de Graos** | Silos, armazens, cotacoes | Castrolanda API? + Manual | Hibrido |
| **Estoque de Insumos** | Fertilizantes, defensivos, sementes | Castrolanda + Manual | Hibrido |
| **Gestao de Maquinario** | Frota, combustivel, manutencoes | John Deere + Vestro + Manual | Hibrido |
| **Custos por Fazenda** | Orcado vs executado, custo/hectare | AgriWin + Excel shadow IT | Integracao |
| **Contas a Pagar** | Fluxo caixa, vencimentos | AgriWin API | Integracao |
| **Contas a Receber** | Recebiveis, previsoes | AgriWin API | Integracao |

---

## 2. Fontes de Dados Conhecidas (Projeto SOAL)

### APIs / Integracoes
| Sistema | Tipo | Dados | Complexidade | Prioridade? |
|---------|------|-------|--------------|-------------|
| **AgriWin** | ERP/Financeiro | Contas, custos, financeiro | Media-Alta | ? |
| **John Deere Operations Center** | Telemetria | Maquinas, horas, localizacao | Alta | ? |
| **Vestro** | Combustivel | Abastecimentos, consumo | Media | ? |
| **Castrolanda** | Cooperativa | Insumos, vendas graos | Media | ? |

### Entrada Manual
| Formulario | Frequencia | Responsavel | Observacoes |
|------------|------------|-------------|-------------|
| Registro de atividades | Diario | Operadores | UX campo (maos sujas) |
| Ajustes de estoque | Por evento | Administrativo | Correcoes manuais |
| Apontamentos extras | Por evento | Diversos | Dados nao captados por API |

### Shadow IT (Excel)
- Planilhas historicas do Claudio (28 anos de dados)
- Fonte de verdade atual para metodologia de custos
- Importacao unica ou recorrente?

---

## 3. Perguntas para Decisao

### Estrategia Geral
- [ ] **MVP primeiro:** Formularios manuais agora, integracoes depois?
- [ ] **Integracao primeiro:** Priorizar APIs e formularios so para gaps?
- [ ] **Hibrido:** Quais formularios manuais sao indispensaveis no MVP?

### Prioridade de Integracoes
- [ ] Qual API atacar primeiro? (menor esforco vs maior valor)
- [ ] AgriWin tem API documentada? Custo de integracao?
- [ ] John Deere: vale o esforco agora ou fase 2?

### UX de Entrada de Dados
- [ ] Tela unica com todos os formularios ou separado por contexto?
- [ ] Formularios devem indicar visualmente a fonte (manual vs API)?
- [ ] Como mostrar dados "pendentes de sincronizacao"?

### Arquitetura Tecnica
- [ ] N8N para orquestrar integracoes ou codigo custom?
- [ ] Frequencia de sync das APIs (tempo real, horario, diario)?
- [ ] Como tratar conflitos (dado manual vs dado API)?

---

## 4. Proposta de Abordagem MVP

**Fase 1 - Formularios Manuais Essenciais**
- Entrada de dados que NAO tem API disponivel
- UX otimizada para campo (Operator POV)
- Dados minimos para dashboards funcionarem

**Fase 2 - Primeira Integracao**
- Escolher 1 API de menor friccao
- Validar arquitetura de sync
- Aprender antes de escalar

**Fase 3 - Integracoes Adicionais**
- Expandir para outras APIs
- Reduzir entrada manual progressivamente
- Shadow IT → importacao estruturada

---

## 5. Proximos Passos

Apos discussao, definir:

1. [ ] Lista de formularios manuais para MVP
2. [ ] API prioritaria para primeira integracao
3. [ ] Responsavel por investigar documentacao das APIs
4. [ ] Timeline macro (sem datas, apenas sequencia)

---

## Anotacoes da Reuniao

_Espaco para registrar decisoes durante a conversa_

**Decisoes:**
-

**Duvidas pendentes:**
-

**Action items:**
- [ ]
- [ ]

---

**Arquivo:** `09_Projetos/DPWAI_APP/PAUTA_Arquitetura_Entrada_Dados.md`
