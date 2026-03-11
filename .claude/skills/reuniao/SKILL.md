---
name: reuniao
description: Process a meeting transcription into a structured document in REUNIOES/ following the SOAL project pattern. Extracts decisions, action items, discoveries, and business rules.
disable-model-invocation: true
allowed-tools: Read, Write, Grep, Glob
argument-hint: "<transcription-path-or-paste> [meeting-type]"
context: fork
---

# Reuniao — Meeting Transcription Processor

Transform a raw meeting transcription into a structured markdown document, following the SOAL project conventions and the `audio-transcription-analyzer.agent.md` framework.

**Input:** `$ARGUMENTS` — path to transcription file, or the transcription will be pasted directly
**Meeting types:** discovery, tecnico, validacao, coleta, planejamento

---

## Step 0: Detect Meeting Type

Infer from participants and content:

| Type | Participants | Focus |
|------|-------------|-------|
| **discovery** | DeepWork + stakeholder (Tiago, Alessandro, Valentina, Josmar, Lucas) | Extract pain points, processes, data sources |
| **tecnico** | Joao + Rodrigo | Architecture decisions, task assignments, DDL changes |
| **validacao** | DeepWork + Claudio | Feature validation, priority decisions |
| **coleta** | DeepWork + data owner | CSV collection, data quality issues |
| **planejamento** | DeepWork + Alessandro/Lucas/Claudio | Safra planning, crop decisions |

---

## Step 1: Read Reference Material

Before processing, read the agent reference for analysis framework:
```
.github/agents/audio-transcription-analyzer.agent.md
```

Also scan recent reunioes for naming and format consistency:
```
09_Projetos/01_SOAL/REUNIOES/
```

---

## Step 2: Process Transcription

### Transcription Corrections (SOAL-specific)

| Likely Error | Correct Term |
|-------------|-------------|
| Castro Landa, castro linda | Castrolanda |
| Agri Win, Agro Win | AgriWin |
| UBG, ubg | UBG (Unidade de Beneficiamento de Graos) |
| talhao, talhão | talhao (no accent in system) |
| SOAL, soal | SOAL (Serra da Onca Agropecuaria) |
| Deep Work, deepwork | DeepWork AI Flows |

### People Name Resolution

| Name | Role | Context |
|------|------|---------|
| Claudio | Owner SOAL | Decision maker |
| Tiago | Gerente Maquinario | Maquinas, operacoes campo |
| Valentina | Administrativa | Contas, compras, contratos |
| Alessandro | Agronomo | Talhao_safra, operacoes, pulverizacao |
| Lucas | Agronomo/Consultor historico | Dados desde 1994, receituarios |
| Vanessa | Operadora Balanca UBG | Ticket_balanca, pesagem |
| Josmar | Operador UBG/Balanca | Secagem, qualidade, recebimento |
| Joao / JV | CTO DeepWork | DDL, ETL, infra |
| Rodrigo | CEO DeepWork | Produto, coleta, regras negocio |

---

## Step 3: Generate Structured Document

### File Naming

```
YYYY-MM-DD_[Type]_[Key_Topic].md
```

Examples:
- `2026-03-10_Discovery_Valentina_Financeiro.md`
- `2026-03-10_Tecnico_DDL_Pecuaria.md`
- `2026-03-10_Coleta_Dados_Lucas_Solo.md`

### Document Structure

```markdown
# [Meeting Type] — [Key Topic]

**Data:** DD de Meses de YYYY
**Duracao:** ~X minutos
**Participantes:** [Names + roles]
**Local:** [Presencial SOAL / Google Meet / WhatsApp]

---

## Resumo Executivo

[3-5 sentences capturing the most important outcomes]

---

## Descobertas Principais

### [Discovery 1 Title]
- **Contexto:** [what was discussed]
- **Insight:** [what we learned]
- **Impacto no projeto:** [how this affects SOAL DDL/data/workflow]
- **Quote:** "[direct quote if available]"

### [Discovery 2 Title]
...

---

## Decisoes Tomadas

| # | Decisao | Justificativa | Impacto |
|---|---------|--------------|---------|
| 1 | ... | ... | DDL / ETL / Workflow |

---

## Regras de Negocio Novas

[Only if new business rules were discovered — these should eventually go to CLAUDE.md §9]

| Regra | Descricao | Entidade(s) afetada(s) |
|-------|-----------|----------------------|

---

## Dados Coletados / Prometidos

| Dado | Formato | Responsavel | Prazo | Status |
|------|---------|-------------|-------|--------|
| [data item] | CSV/Excel/PDF | [person] | [date] | Pendente |

---

## Pain Points Identificados

### [Pain Point Name]
**Severidade:** Alta / Media / Baixa
**Descricao:** [details]
**Quote:** "[direct quote]"
**Solucao proposta:** [how DeepWork can solve]

---

## Validacoes

| Item | Status | Observacao |
|------|--------|-----------|
| [feature/concept] | Validado / Rejeitado / Parcial | [notes] |

---

## Proximos Passos

### Acoes DeepWork
1. [ ] [Action] — **Responsavel:** Joao/Rodrigo — **Prazo:** [date]

### Acoes Cliente
1. [ ] [Action] — **Responsavel:** [person] — **Prazo:** [date]

### Decisoes Pendentes
- [ ] [Decision needed — who decides, by when]

---

## Trechos Notaveis

### Sobre [Topic]
> **[Speaker]:** "[Quote]"

---

**Processado por:** DeepWork AI Flows
**Data do processamento:** [today]
```

---

## Step 4: Post-Processing

After creating the document:

1. **Save to:** `09_Projetos/01_SOAL/REUNIOES/[filename].md`
2. **Flag items for CLAUDE.md:** If new business rules were discovered, note them for future `/sync-docs`
3. **Flag items for DDL:** If schema changes were discussed, note them
4. **Flag items for MEMORY.md:** If significant project state changes occurred

---

## Quality Checklist

- [ ] All participants identified with correct roles
- [ ] Technical terms corrected (see table above)
- [ ] Business rules extracted and tagged
- [ ] Action items have owners and deadlines
- [ ] No emojis in the document
- [ ] File saved with correct naming convention
- [ ] Uncertain values marked with `[VERIFICAR]` or `[a confirmar]`
