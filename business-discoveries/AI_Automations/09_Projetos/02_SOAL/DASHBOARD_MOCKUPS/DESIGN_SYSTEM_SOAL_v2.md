# Design System SOAL v2.0 - "Neutral Modern"

**Plataforma:** app.dpwai.com.br
**Versão:** 2.0 (Light Mode Profissional)
**Data:** 31 de Janeiro de 2026
**Autor:** Rodrigo Kugler

---

## 1. Filosofia de Design

### 1.1 Princípios Fundamentais

| Princípio | Descrição |
|-----------|-----------|
| **Clareza** | Informação legível à primeira vista. Sem ruído visual. |
| **Profissionalismo** | Estética de software empresarial moderno, não de game/terminal. |
| **Respiração** | Espaço em branco generoso. Cards não colados. |
| **Hierarquia** | O que é importante se destaca naturalmente. |
| **Consistência** | Mesmos padrões em todas as telas. |

### 1.2 Referências Visuais

- **Linear.app** - Simplicidade e elegância
- **Vercel Dashboard** - Tipografia e espaçamento
- **Notion** - Hierarquia de informação
- **Stripe Dashboard** - Dados financeiros bem apresentados

### 1.3 Anti-Padrões (O que evitar)

- Dark mode pesado (#09090b) - Cansativo para uso prolongado
- Cores neon/saturadas demais - Parecem alarmes constantes
- Cards colados sem respiro - Sensação de aperto
- Fontes muito pequenas - Dificulta leitura rápida
- Gradientes excessivos - Distrai do conteúdo

---

## 2. Paleta de Cores

### 2.1 Cores de Base (Neutros)

```css
/* Background - A base de tudo */
--bg-page:        #F8FAFC;   /* Fundo da página (slate-50) */
--bg-card:        #FFFFFF;   /* Fundo dos cards */
--bg-hover:       #F1F5F9;   /* Hover em elementos (slate-100) */
--bg-active:      #E2E8F0;   /* Estado ativo/selecionado (slate-200) */
--bg-muted:       #F1F5F9;   /* Áreas secundárias */

/* Bordas */
--border-light:   #E2E8F0;   /* Bordas suaves (slate-200) */
--border-default: #CBD5E1;   /* Bordas padrão (slate-300) */
--border-strong:  #94A3B8;   /* Bordas com destaque (slate-400) */

/* Texto */
--text-primary:   #0F172A;   /* Texto principal (slate-900) */
--text-secondary: #475569;   /* Texto secundário (slate-600) */
--text-muted:     #94A3B8;   /* Texto desabilitado/hint (slate-400) */
--text-inverse:   #FFFFFF;   /* Texto em fundos escuros */
```

### 2.2 Cores Semânticas (Ações e Status)

```css
/* Verde - Cor Core da SOAL (Sucesso, Lucro, Positivo) */
--green-50:       #ECFDF5;   /* Background sutil */
--green-100:      #D1FAE5;   /* Background leve */
--green-500:      #10B981;   /* Ícones, textos */
--green-600:      #059669;   /* Cor principal (botões, destaques) */
--green-700:      #047857;   /* Hover em botões */
--green-900:      #064E3B;   /* Texto em fundo verde claro */

/* Vermelho - Erro, Despesa, Negativo */
--red-50:         #FEF2F2;
--red-100:        #FEE2E2;
--red-500:        #EF4444;
--red-600:        #DC2626;   /* Cor principal */
--red-700:        #B91C1C;

/* Âmbar - Atenção, Pendente, Alerta */
--amber-50:       #FFFBEB;
--amber-100:      #FEF3C7;
--amber-500:      #F59E0B;
--amber-600:      #D97706;   /* Cor principal */
--amber-700:      #B45309;

/* Azul - Informação, Links, Ações Neutras */
--blue-50:        #EFF6FF;
--blue-100:       #DBEAFE;
--blue-500:       #3B82F6;
--blue-600:       #2563EB;   /* Cor principal */
--blue-700:       #1D4ED8;

/* Violeta - Categorias especiais (Defensivos, Pedidos) */
--violet-50:      #F5F3FF;
--violet-100:     #EDE9FE;
--violet-500:     #8B5CF6;
--violet-600:     #7C3AED;
```

### 2.3 Cores de Dados (Gráficos e Visualizações)

```css
/* Grãos */
--grain-soy:      #EAB308;   /* Soja - Amarelo (yellow-500) */
--grain-corn:     #F97316;   /* Milho - Laranja (orange-500) */

/* Categorias de Custo */
--cost-fertilizer: #2563EB;  /* Fertilizantes - Azul */
--cost-seeds:      #059669;  /* Sementes - Verde */
--cost-pesticide:  #7C3AED;  /* Defensivos - Violeta */
--cost-fuel:       #D97706;  /* Combustível - Âmbar */
--cost-labor:      #0891B2;  /* Mão de Obra - Cyan */
--cost-maintenance:#EA580C;  /* Manutenção - Laranja escuro */
--cost-other:      #64748B;  /* Outros - Slate */

/* Fabricantes (Máquinas) */
--brand-john-deere: #367C2B; /* Verde John Deere */
--brand-case-ih:    #AF1E2D; /* Vermelho Case */
--brand-new-holland:#0033A0; /* Azul New Holland */
--brand-massey:     #CC0000; /* Vermelho Massey */
```

### 2.4 Aplicação Visual da Paleta

```
┌─────────────────────────────────────────────────────────────────────┐
│  PÁGINA (bg-page: #F8FAFC)                                          │
│                                                                     │
│    ┌─────────────────────────────────────────────────────────────┐  │
│    │  CARD (bg-card: #FFFFFF)                                    │  │
│    │  border: 1px solid #E2E8F0                                  │  │
│    │  shadow: 0 1px 3px rgba(0,0,0,0.1)                          │  │
│    │                                                             │  │
│    │  Título (text-primary: #0F172A)                             │  │
│    │  Subtítulo (text-secondary: #475569)                        │  │
│    │                                                             │  │
│    │  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │  │
│    │  │ R$ 450K  │  │ R$ 120K  │  │ R$ 80K   │                   │  │
│    │  │ (green)  │  │  (red)   │  │ (amber)  │                   │  │
│    │  └──────────┘  └──────────┘  └──────────┘                   │  │
│    │                                                             │  │
│    └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Tipografia

### 3.1 Família de Fontes

```css
/* Font Stack Principal */
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* Font Stack Mono (para números, códigos) */
--font-mono: 'JetBrains Mono', 'SF Mono', 'Fira Code', monospace;
```

### 3.2 Escala Tipográfica

| Token | Tamanho | Peso | Line Height | Uso |
|-------|---------|------|-------------|-----|
| `display-xl` | 36px | 700 (Bold) | 40px | Números grandes (KPIs hero) |
| `display-lg` | 30px | 700 (Bold) | 36px | Títulos de página |
| `heading-lg` | 20px | 600 (Semibold) | 28px | Títulos de seção/card |
| `heading-md` | 16px | 600 (Semibold) | 24px | Subtítulos |
| `heading-sm` | 14px | 600 (Semibold) | 20px | Labels de destaque |
| `body-lg` | 16px | 400 (Regular) | 24px | Texto corrido longo |
| `body-md` | 14px | 400 (Regular) | 20px | Texto padrão |
| `body-sm` | 12px | 400 (Regular) | 16px | Texto auxiliar |
| `caption` | 11px | 500 (Medium) | 14px | Legendas, timestamps |
| `number-xl` | 32px | 700 (Bold) | 40px | Valores monetários grandes |
| `number-lg` | 24px | 600 (Semibold) | 32px | Valores monetários médios |
| `number-md` | 16px | 600 (Semibold) | 24px | Valores em tabelas |
| `mono-sm` | 12px | 400 (Regular) | 16px | Códigos, IDs, Lotes |

### 3.3 Hierarquia de Texto

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  Visão Executiva                         ← display-lg (#0F172A) │
│  Executive Overview Dashboard            ← body-sm (#94A3B8)    │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                         │   │
│  │  Saldo de Caixa                   ← heading-lg (#0F172A)│   │
│  │  Projeção para os próximos 30 dias ← body-sm (#64748B)  │   │
│  │                                                         │   │
│  │  R$ 2.450.000                     ← number-xl (#059669) │   │
│  │  +12% vs mês anterior             ← body-sm (#059669)   │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Espaçamento

### 4.1 Escala de Espaçamento (Base 4px)

```css
--space-1:   4px;    /* Micro ajustes */
--space-2:   8px;    /* Entre elementos inline */
--space-3:   12px;   /* Padding interno pequeno */
--space-4:   16px;   /* Padding padrão */
--space-5:   20px;   /* Gap entre cards */
--space-6:   24px;   /* Padding de cards */
--space-8:   32px;   /* Separação de seções */
--space-10:  40px;   /* Margens de página */
--space-12:  48px;   /* Separação grande */
--space-16:  64px;   /* Separação de blocos */
```

### 4.2 Layout de Página

```css
/* Container Principal */
--page-max-width:    1440px;
--page-padding:      40px;     /* Desktop */
--page-padding-mobile: 16px;   /* Mobile */

/* Grid de Cards */
--card-gap:          20px;
--card-padding:      24px;
--card-radius:       12px;

/* Header da Página */
--header-height:     72px;
--header-padding:    24px 40px;
```

### 4.3 Anatomia de Card

```
┌─────────────────────────────────────────────────────────────────┐
│ ← 24px padding                                                  │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  HEADER                                                 │   │
│   │  Title                              Action Button       │   │
│   └─────────────────────────────────────────────────────────┘   │
│                          ↑ 16px gap                             │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  CONTENT                                                │   │
│   │                                                         │   │
│   │  ...                                                    │   │
│   │                                                         │   │
│   └─────────────────────────────────────────────────────────┘   │
│                          ↑ 16px gap                             │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │  FOOTER (opcional)                                      │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│                                           24px padding →        │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Componentes

### 5.1 Cards

#### Card Padrão
```css
.card {
  background: #FFFFFF;
  border: 1px solid #E2E8F0;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1),
              0 1px 2px rgba(0, 0, 0, 0.06);
}

.card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1),
              0 2px 4px rgba(0, 0, 0, 0.06);
}
```

#### Card de KPI
```
┌─────────────────────────────────────────┐
│  ┌────┐                                 │
│  │ 📊 │  Contas a Receber               │  ← Ícone + Label
│  └────┘  Próximos 30 dias               │  ← Sublabel
│                                         │
│  R$ 1.245.000                           │  ← Valor (number-xl)
│                                         │
│  ┌─────────────────────────────┐        │
│  │ ↑ 12%  vs mês anterior      │        │  ← Badge de variação
│  └─────────────────────────────┘        │
│                                         │
└─────────────────────────────────────────┘
```

**Especificações:**
- Tamanho mínimo: 240px × 140px
- Ícone: 40×40px, background circular com cor semântica (10% opacity)
- Valor: `number-xl` (32px, bold)
- Variação positiva: texto `green-600`, badge `green-50` background
- Variação negativa: texto `red-600`, badge `red-50` background

### 5.2 Botões

#### Hierarquia de Botões

| Tipo | Uso | Estilo |
|------|-----|--------|
| **Primary** | Ação principal (1 por tela) | Background `green-600`, texto branco |
| **Secondary** | Ações secundárias | Background `white`, border `slate-300`, texto `slate-700` |
| **Ghost** | Ações terciárias | Background transparente, texto `slate-600` |
| **Danger** | Ações destrutivas | Background `red-600`, texto branco |

#### Especificações

```css
/* Botão Base */
.btn {
  height: 40px;
  padding: 0 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.15s ease;
}

/* Primary */
.btn-primary {
  background: #059669;
  color: white;
  border: none;
}
.btn-primary:hover {
  background: #047857;
}

/* Secondary */
.btn-secondary {
  background: white;
  color: #334155;
  border: 1px solid #CBD5E1;
}
.btn-secondary:hover {
  background: #F1F5F9;
  border-color: #94A3B8;
}
```

#### Tamanhos

| Size | Height | Padding | Font |
|------|--------|---------|------|
| `sm` | 32px | 0 12px | 12px |
| `md` | 40px | 0 16px | 14px |
| `lg` | 48px | 0 24px | 16px |

### 5.3 Tabelas

```
┌─────────────────────────────────────────────────────────────────────┐
│  HEADER (bg: #F8FAFC, border-bottom: 2px solid #E2E8F0)             │
├──────────────┬────────────┬────────────┬────────────┬───────────────┤
│  Cliente     │  Contrato  │  Vencimento│   Valor    │    Status     │
│  (left)      │  (left)    │  (left)    │  (right)   │   (center)    │
├──────────────┼────────────┼────────────┼────────────┼───────────────┤
│  Cooperativa │  #SOJ-042  │  15/02/26  │ R$ 450.000 │  ● Em Aberto  │  ← Row (bg: white)
│  COOAGRI     │            │            │            │    (green)    │
├──────────────┼────────────┼────────────┼────────────┼───────────────┤
│  Bunge       │  #SOJ-038  │  10/02/26  │ R$ 320.000 │  ● Atrasado   │  ← Row (bg: #F8FAFC)
│  Alimentos   │            │            │            │    (red)      │
├──────────────┼────────────┼────────────┼────────────┼───────────────┤
│  Cargill     │  #MIL-015  │  28/02/26  │ R$ 180.000 │  ● Pago       │  ← Row (bg: white)
│  Agrícola    │            │            │            │    (slate)    │
└──────────────┴────────────┴────────────┴────────────┴───────────────┘
```

**Especificações:**
- Header: `bg-muted`, texto `text-secondary`, font `heading-sm`
- Rows: Alternando `white` e `bg-page`
- Row height: 56px mínimo
- Cell padding: 16px horizontal
- Hover: `bg-hover` (#F1F5F9)
- Números/valores: Alinhados à direita, font `number-md`

### 5.4 Badges de Status

| Status | Background | Texto | Border |
|--------|------------|-------|--------|
| **Sucesso** | `green-50` | `green-700` | `green-200` |
| **Erro** | `red-50` | `red-700` | `red-200` |
| **Alerta** | `amber-50` | `amber-700` | `amber-200` |
| **Info** | `blue-50` | `blue-700` | `blue-200` |
| **Neutro** | `slate-100` | `slate-600` | `slate-200` |

```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
}

/* Com dot indicator */
.badge::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: currentColor;
}
```

### 5.5 Gráficos

#### Cores de Gráficos (em ordem de uso)

```css
--chart-1: #059669;  /* Verde - Primário */
--chart-2: #2563EB;  /* Azul */
--chart-3: #D97706;  /* Âmbar */
--chart-4: #7C3AED;  /* Violeta */
--chart-5: #DC2626;  /* Vermelho */
--chart-6: #0891B2;  /* Cyan */
--chart-7: #EA580C;  /* Laranja */
--chart-8: #64748B;  /* Slate */
```

#### Estilo de Gráficos

```css
/* Grid Lines */
--grid-color: #E2E8F0;
--grid-opacity: 0.5;

/* Axis Labels */
--axis-color: #94A3B8;
--axis-font-size: 11px;

/* Tooltip */
.chart-tooltip {
  background: #0F172A;
  color: white;
  padding: 8px 12px;
  border-radius: 6px;
  font-size: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
```

---

## 6. Ícones

### 6.1 Biblioteca

**Recomendada:** Lucide Icons (https://lucide.dev)
- Consistente com o estilo
- Tamanhos padronizados
- Licença MIT

### 6.2 Tamanhos

| Contexto | Tamanho | Exemplo |
|----------|---------|---------|
| Inline com texto | 16px | Botões, links |
| Em cards/KPIs | 20px | Ícones de categoria |
| Destaque | 24px | Headers de seção |
| Hero | 32-40px | Ícones em cards de status |

### 6.3 Cores de Ícones

- **Em texto:** Herda cor do texto (`currentColor`)
- **Em fundos coloridos:** Branco
- **Decorativos:** `text-muted` (#94A3B8)
- **Semânticos:** Cor correspondente ao status

---

## 7. Layout de Dashboard

### 7.1 Estrutura de Página

```
┌─────────────────────────────────────────────────────────────────────┐
│  HEADER                                                             │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Logo    │  Navegação Principal    │  User Menu             │   │
│  └─────────────────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  PAGE HEADER                                                        │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Título da Página                    │  Filtros │  Ações   │   │
│  │  Subtítulo/Descrição                 │          │          │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  KPI STRIP (opcional)                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │   KPI 1  │  │   KPI 2  │  │   KPI 3  │  │   KPI 4  │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                                                                     │
│  MAIN CONTENT                                                       │
│  ┌────────────────────────────┐  ┌────────────────────────────┐   │
│  │                            │  │                            │   │
│  │      Card Principal        │  │      Card Secundário       │   │
│  │      (60-70% width)        │  │      (30-40% width)        │   │
│  │                            │  │                            │   │
│  └────────────────────────────┘  └────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 7.2 Grid System

```css
/* Container */
.dashboard-container {
  max-width: 1440px;
  margin: 0 auto;
  padding: 0 40px;
}

/* Grid de KPIs */
.kpi-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

/* Grid 2 colunas (60/40) */
.content-grid-60-40 {
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  gap: 24px;
}

/* Grid 2 colunas (50/50) */
.content-grid-50-50 {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

/* Responsivo */
@media (max-width: 1024px) {
  .kpi-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .content-grid-60-40,
  .content-grid-50-50 {
    grid-template-columns: 1fr;
  }
}
```

---

## 8. Exemplos de Aplicação

### 8.1 Card de Contas a Pagar (Antes vs Depois)

**ANTES (Dark Mode Pesado):**
```
Background: #09090b
Card: #18181b
Texto: #f4f4f5
Muito contraste, cansativo
```

**DEPOIS (Neutral Modern):**
```
┌─────────────────────────────────────────────────────────────────┐
│  bg: #FFFFFF, border: #E2E8F0, shadow: soft                     │
│                                                                 │
│  ┌────┐                                                         │
│  │ 💰 │  Total Vencendo Hoje                    ← #0F172A       │
│  └────┘  8 contas pendentes                     ← #64748B       │
│  (bg: #FEF2F2)                                                  │
│                                                                 │
│  R$ 487.500                                     ← #DC2626       │
│                                                                 │
│  ┌───────────────────────────────────────────┐                  │
│  │  Autorizar Pagamentos →                   │  ← btn-danger    │
│  └───────────────────────────────────────────┘                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 8.2 Tabela de Recebíveis (Depois)

```
┌─────────────────────────────────────────────────────────────────────┐
│  bg: #FFFFFF                                                        │
│                                                                     │
│  Contas a Receber                                    Exportar ↓    │
│  42 contratos ativos                                               │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Cliente          Contrato    Vencimento    Valor    Status │   │
│  │  (bg: #F8FAFC)                                              │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │  Cooperativa      #SOJ-042    15/02/26    R$ 450K   ● Aberto│   │
│  │  COOAGRI                                             (green)│   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │  Bunge            #SOJ-038    10/02/26    R$ 320K   ●Atrasado│   │
│  │  Alimentos                                  (red border-left)│   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  Mostrando 1-10 de 42          ◀  1  2  3  4  5  ▶                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 9. Prompt para Geração no Figma

### 9.1 Prompt Master (Copie e use)

```
DESIGN SYSTEM: SOAL Platform v2.0 - "Neutral Modern"

CONTEXT:
Agricultural management platform for a Brazilian farm operation.
Users: Farm owner (Claudio), Operations manager (Tiago), Admin (Valentina).
Usage: Daily financial and operational dashboards.

VISUAL STYLE:
- Light mode, professional, clean
- References: Linear.app, Vercel Dashboard, Stripe
- NO dark terminals, NO neon colors, NO heavy shadows

COLOR PALETTE:
- Page Background: #F8FAFC (light gray)
- Card Background: #FFFFFF (white)
- Primary Text: #0F172A (almost black)
- Secondary Text: #475569 (gray)
- Muted Text: #94A3B8 (light gray)
- Border: #E2E8F0 (subtle)

SEMANTIC COLORS:
- Success/Profit: #059669 (dark green) - PRIMARY BRAND COLOR
- Error/Expense: #DC2626 (red)
- Warning/Pending: #D97706 (amber)
- Info/Links: #2563EB (blue)

TYPOGRAPHY:
- Font: Inter
- Page Title: 30px Bold
- Card Title: 20px Semibold
- Body: 14px Regular
- Numbers: 32px Bold (for KPIs), 16px Semibold (for tables)

SPACING:
- Page padding: 40px
- Card padding: 24px
- Card gap: 20px
- Card border-radius: 12px

COMPONENTS:
- Cards: White with subtle shadow (0 1px 3px rgba(0,0,0,0.1))
- Buttons: 40px height, 8px radius, green-600 for primary
- Tables: Alternating rows (#FFFFFF, #F8FAFC)
- Badges: Rounded (6px), colored backgrounds at 10% opacity

LAYOUT:
- Frame: 1440px × 900px (Desktop)
- Max content width: 1440px
- KPI strip: 4 cards in row
- Main content: 60/40 or 50/50 split
```

### 9.2 Prompt de Correção (Para dashboards existentes)

```
TASK: Update existing SOAL dashboard to new Design System v2.0

CHANGES TO APPLY:

1. BACKGROUND:
   - Change page background from #09090b to #F8FAFC
   - Change card background from #18181b to #FFFFFF

2. TEXT COLORS:
   - Primary text: Change from #f4f4f5 to #0F172A
   - Secondary text: Change from #a1a1aa to #475569
   - Muted text: Change from #52525b to #94A3B8

3. BORDERS & SHADOWS:
   - Add border: 1px solid #E2E8F0 to all cards
   - Add shadow: 0 1px 3px rgba(0,0,0,0.1) to cards
   - Remove any dark borders

4. SEMANTIC COLORS (keep but adjust):
   - Green: Use #059669 instead of #10b981
   - Red: Use #DC2626 instead of #ef4444
   - Amber: Use #D97706 instead of #f59e0b

5. TABLES:
   - Header: #F8FAFC background
   - Rows: Alternate #FFFFFF and #F8FAFC
   - Remove dark backgrounds

6. CHARTS:
   - Grid lines: #E2E8F0
   - Keep data colors but ensure readability on light background

MAINTAIN:
- Overall layout structure
- Component placement
- Information hierarchy
- Icon usage
```

---

## 10. Checklist de Implementação

### Para cada Dashboard:

- [ ] Background da página: `#F8FAFC`
- [ ] Cards com fundo branco e borda sutil
- [ ] Texto principal em `#0F172A`
- [ ] Verde core: `#059669` (não `#10b981`)
- [ ] Sombras suaves (não pesadas)
- [ ] Espaçamento consistente (24px padding em cards)
- [ ] Tipografia Inter
- [ ] Tabelas com rows alternados
- [ ] Badges com backgrounds sutis (10% opacity)
- [ ] Gráficos legíveis no fundo claro

### Ordem de Atualização Sugerida:

1. **Dashboard 01** - Executive Overview (piloto)
2. **Dashboard 03** - Accounts Payable (financeiro)
3. **Dashboard 02** - Accounts Receivable (financeiro)
4. **Dashboard 04** - Machinery & Diesel (operacional)
5. Demais dashboards

---

## Changelog

| Versão | Data | Alteração |
|--------|------|-----------|
| 1.0 | Jan/2026 | Design System original (Dark Mode #09090b) |
| 2.0 | 31/01/2026 | **Neutral Modern** - Light mode profissional, nova paleta, componentes atualizados |

---

**Documento preparado por:** Rodrigo Kugler
**Data:** 31 de Janeiro de 2026
**Para uso em:** app.dpwai.com.br (Plataforma SOAL)
