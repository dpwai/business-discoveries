# Contexto para Kanban Playgrounds — Agricultura + UBG

> Documento de handoff para desenvolvimento dos playgrounds HTML de Kanban vertical.
> Criado: 2026-03-11 | Fonte: Reuniao Joao 2026-03-10 + Doc 32 Lifecycle

---

## Skills Disponiveis

### Skills de sistema (ja ativas)

| Skill | Comando | Uso |
|-------|---------|-----|
| **frontend-design** | `/frontend-design` | Design direcionado com escolhas esteticas ousadas, tipografia, paleta, animacoes |
| **playground** | `/playground` | Gera playgrounds HTML self-contained (single file, inline CSS/JS) |

### Skills instaladas nesta sessao

| Skill | Comando | Uso |
|-------|---------|-----|
| **frontend-ui** | `/frontend-ui` | Anti "AI slop" — 4 dimensoes de design (tipografia, cor, motion, backgrounds). Baseado no cookbook de estetica da Anthropic |
| **ui-ux-audit** | `/ui-ux-audit` | Audit obrigatorio antes de mudancas UI/UX — redundancia check, gaps genuinos, filosofia clean |

### Skills descartadas (nao uteis para playgrounds HTML)

| Skill | Motivo |
|-------|--------|
| artifacts-builder (ComposioHQ) | Focado em React+bundling para claude.ai artifacts, nao HTML self-contained |
| theme-factory (ComposioHQ) | Focado em slides/PDFs, nao web |
| Vibe Kanban | Ferramenta de gestao, nao skill instalavel |
| Claude Task Viewer | Referencia visual, nao skill instalavel |

---

## O Que Construir

### Kanban 1: Agricultura (TALHAO_SAFRA lifecycle)

**Layout:** Vertical (scroll down), mobile-first, 82+ cards
**Colunas = etapas do lifecycle (9 estados):**

| # | Estado | Cor sugerida | Trigger de transicao | Dados obrigatorios (PENDENTE validacao) |
|---|--------|-------------|---------------------|----------------------------------------|
| 1 | rascunho | `--fg3` (gray) | Alessandro cria planejamento | talhao, cultura, epoca, area |
| 2 | em_revisao | `--yellow` | Alessandro marca "pronto pra revisao" | snapshot v1 completo |
| 3 | aprovado | `--accent` (blue) | Claudio aprova | aprovado_por, data_aprovacao |
| 4 | preparando | `--orange` | 1a SAFRA_ACAO iniciada (dessecacao/preparo) | safra_acao.data_inicio |
| 5 | plantado | `--green` | OPERACAO_CAMPO tipo='plantio' concluida | data_plantio, maquina, operador |
| 6 | em_desenvolvimento | `--cyan` | 1a operacao manejo confirmada | ao menos 1 pulverizacao |
| 7 | colhendo | `--purple` | 1o ticket_balanca para este talhao_safra | data_pesagem |
| 8 | colhido | `--green` (bold) | Ultimo ticket + fechamento | produtividade_sc_ha calculada |
| 9 | cancelado | `--red` | Cancelamento manual (qualquer pre-plantado) | motivo (observacoes) |

**Card = 1 TALHAO_SAFRA** contendo:
- Talhao (nome + fazenda)
- Cultura + cultivar
- Epoca (safra/safrinha)
- Area plantada (ha)
- Data plantio prevista
- Progresso (checklist dados obrigatorios)
- Custo acumulado (hub de custeio)

**Modelo "videogame":** dados obrigatorios por etapa bloqueiam avanco.

### Kanban 2: UBG (fluxo pos-colheita)

**Etapas reais (5, sem fantasma):**

| # | Etapa | Entidade DDL | Responsavel | Dados chave |
|---|-------|-------------|-------------|-------------|
| 1 | Ticket Balanca | TICKET_BALANCA | Vanessa | placa (OBRIGATORIA), motorista, peso bruto/tara/liquido |
| 2 | Amostragem/Recebimento | RECEBIMENTO_GRAO | Josmar | umidade, impureza, ardidos (caneca 200g antes de descarregar) |
| 3 | Secagem | CONTROLE_SECAGEM + LEITURA_SECAGEM | Josmar | leituras 30/30 min, temperatura, umidade saida |
| 4 | Alocacao Silo | ESTOQUE_SILO | Josmar | silo destino, quantidade, tipo (commodity/semente) |
| 5 | Saida Grao | SAIDA_GRAO | Vanessa | destino, contrato, transportadora, peso embarque |

**Regras criticas:**
- **Pre-limpeza e recepacao separada NAO existem** — remover etapas fantasma
- **Moega mistura talhoes:** apos moega, rastreamento muda talhao → cultura
- **Semente vs Commodity:** semente nunca mistura, secagem diferente, silo pulmao exclusivo
- **Custo secagem:** rateado por cultura e area (lenha, energia)

### Handoff Agricultura → UBG

- Quando colheita termina no Kanban Agricultura → registro aparece pendente no Kanban UBG
- Pessoas diferentes: Tiago (agricultura) vs Vanessa/Josmar (UBG)
- Uma operacao_campo de colheita gera ~10 ticket_balanca

---

## Design System dos Playgrounds Existentes (reutilizar)

### CSS Variables (do `soal-process-flow-playground.html`)

```css
:root{
  --bg:#0d1117;--bg2:#161b22;--bg3:#21262d;--bg4:#30363d;
  --fg:#e6edf3;--fg2:#8b949e;--fg3:#484f58;
  --accent:#58a6ff;--green:#3fb950;--yellow:#d29922;--red:#f85149;
  --orange:#db6d28;--purple:#8957e5;--pink:#f778ba;--cyan:#39d2c0;
  --radius:8px;--shadow:0 2px 8px rgba(0,0,0,.4);
  --font:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen,sans-serif;
  --mono:'SF Mono','Fira Code','Cascadia Code',monospace;
}
```

### Padroes reutilizaveis

| Padrao | Playground de referencia | Descricao |
|--------|--------------------------|-----------|
| Dark theme | Todos | `--bg` como fundo, `--fg` como texto |
| Cards com badges | Process Flow | `.pill-completo`, `.pill-parcial`, `.pill-pendente` |
| Timeline vertical | Process Flow | `.timeline::before` (linha vertical), `.phase-dot` |
| Entity grid | Process Flow | `.entity-grid`, `.entity-mini` cards |
| Keyboard shortcuts | Process Flow | `0-7` toggle, `A` all, `C` collapse, `Esc` reset |
| Filtros | Process Flow | Search input + selects com `.filter-input` |
| Summary cards | Process Flow | `.summary` grid com `.card-value` + `.card-bar` |
| Mobile responsive | Todos | `@media(max-width:700px)` breakpoint |
| Collapsible sections | Process Flow | `.phase-header` click → `.phase-body` toggle |
| Silo visual | Alocacao | SVG silos com fill level |
| Touch controls | Secagem | Botoes grandes para mobile |

### 6 Playgrounds existentes

| Playground | Arquivo |
|-----------|---------|
| Process Flow | `DDL/soal-process-flow-playground.html` |
| Secagem | `DDL/soal-secagem-playground.html` |
| Alocacao | `DDL/soal-alocacao-playground.html` |
| DDL Dashboard | `DDL/soal-ddl-playground.html` |
| ER Diagram | `DDL/soal-er-playground.html` |
| Financeiro | `DDL/soal-financeiro-playground.html` |

---

## Dados Mock para o Playground

### Agricultura — 82+ cards distribuidos

Usar dados reais de `IMPORTS/fase_5/03_talhao_safra.csv` se disponivel, senao mock:

```javascript
// Distribuicao tipica por etapa (safra 25/26)
const MOCK_DISTRIBUTION = {
  rascunho: 5,        // planejamento safrinha
  em_revisao: 3,      // aguardando Claudio
  aprovado: 8,        // aprovados, nao iniciaram preparo
  preparando: 12,     // dessecacao/preparo em andamento
  plantado: 15,       // plantio concluido, aguardando manejo
  em_desenvolvimento: 20, // em manejo (pulverizacoes)
  colhendo: 10,       // colheita ativa
  colhido: 8,         // ciclo fechado
  cancelado: 1        // ex: talhao inundou
};

// Fazendas SOAL (9)
const FAZENDAS = [
  'Serra da Onca', 'Jaguariaiva', 'Lajeadinho',
  'Santo Andre', 'Santa Rita', 'Santana',
  'Sao Francisco', 'Capinzal', 'Massacre'
];

// Culturas principais V0
const CULTURAS = ['Soja', 'Milho', 'Feijao', 'Trigo', 'Aveia', 'Cevada', 'Milheto'];
```

### UBG — Fluxo de tickets

```javascript
// Tickets em cada etapa (dia tipico de colheita)
const UBG_MOCK = {
  ticket_balanca: 4,       // aguardando pesagem
  amostragem: 3,           // coletando amostra
  secagem: 2,              // no secador (cada leva ~8h)
  alocacao_silo: 1,        // decidindo silo destino
  saida_grao: 2            // embarque programado
};

// 8 silos UBG
const SILOS = [
  { nome: 'S1', capacidade: 1800, tipo: 'convencional' },
  { nome: 'S2', capacidade: 1800, tipo: 'convencional' },
  { nome: 'S3', capacidade: 1500, tipo: 'convencional' },
  { nome: 'S4', capacidade: 1500, tipo: 'convencional' },
  { nome: 'S5', capacidade: 1500, tipo: 'convencional' },
  { nome: 'S6', capacidade: 1500, tipo: 'convencional' },
  { nome: 'SP', capacidade: 700, tipo: 'pulmao_plano' },     // semente
  { nome: 'SE', capacidade: 460, tipo: 'pulmao_elevado' }     // sem termometria
];
```

---

## Approach Recomendado

1. **Usar `/frontend-design`** para gerar direcao visual dos 2 Kanbans
2. **Usar `/playground`** para scaffolding do HTML self-contained
3. **Aplicar `/frontend-ui`** para evitar AI slop (tipografia, motion, backgrounds)
4. **Reutilizar CSS variables** e dark theme dos playgrounds existentes
5. **Referencia principal:** `soal-process-flow-playground.html` (ja tem timeline vertical)
6. **Revisar com `/ui-ux-audit`** antes de finalizar

### Ordem de construcao

1. **Kanban Agricultura primeiro** (mais complexo, 9 estados, 82+ cards)
2. **Kanban UBG segundo** (5 etapas, menos cards, mas handoff critico)
3. **Integrar handoff** (colheita → ticket_balanca)

---

## Decisoes Pendentes (perguntar Alessandro/Claudio)

- [ ] Dados obrigatorios por etapa do Kanban (condicionais de passagem)
- [ ] Nomenclatura: gleba vs subtalhao
- [ ] Como tratar subtipo de cultura (semente vs commodity) — flag no TALHAO_SAFRA ou subtipo na CULTURA
- [ ] Se epoca (safra/safrinha) e redundante ou necessario no formulario

---

*Gerado por: DeepWork AI Flows | 2026-03-11*
