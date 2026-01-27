# Design System - DeepWork AI Flows Agronegócio
## Moderno, Impactante, Simples e Intuitivo

**Data:** 2026-01-27
**Versão:** 2.0 - Alinhado com Logo Atual + Foco Agro
**Status:** Pronto para Implementação

---

## 🎨 IDENTIDADE VISUAL

### Logo Atual (Manter)
```
SVG com gradiente azul:
- Gradiente: #00C2FF → #0066FF
- Formas: Linhas/flows abstratos
- Texto: "DEEPWORK" + "AI FLOWS"
- Família: Montserrat Bold/Medium
```

**Uso:**
- Header: Versão horizontal completa
- Mobile: Ícone (só símbolo) + texto compacto
- Footer: Versão menor monocromática branca

---

## 🎨 PALETA DE CORES

### Cores Primárias (Logo Existente)
```css
--logo-blue-light: #00C2FF;    /* Gradiente início */
--logo-blue-dark: #0066FF;     /* Gradiente fim */
--primary-dark: #0A2540;       /* Azul escuro corporativo */
```

### Cores Agronegócio (Novos Accents)
```css
/* Verde Agro - CTA e Elementos Positivos */
--agro-green: #2ECC71;         /* Verde vibrante agro */
--agro-green-dark: #27AE60;    /* Verde escuro hover */
--agro-green-light: #A8E6CF;   /* Verde claro backgrounds */

/* Tons Terrosos - Agricultura */
--earth-brown: #8B6F47;        /* Marrom terra */
--earth-gold: #DAA520;         /* Dourado safra */
--field-green: #4A7C59;        /* Verde campo */
```

### Cores Neutras (Base)
```css
/* Backgrounds */
--bg-white: #FFFFFF;
--bg-light: #F8F9FA;           /* Cinza muito claro */
--bg-alt: #F0F4F3;             /* Cinza esverdeado suave */
--bg-dark: #0A2540;            /* Azul escuro para footers */

/* Textos */
--text-primary: #1A1A1A;       /* Preto suave */
--text-secondary: #4A5568;     /* Cinza médio */
--text-light: #718096;         /* Cinza claro */
--text-white: #FFFFFF;

/* Bordas e Divisões */
--border-light: #E2E8F0;
--border-medium: #CBD5E0;
```

### Aplicação de Cores por Contexto

**CTAs Principais:**
```css
background: var(--agro-green);
hover: var(--agro-green-dark);
```

**Logo e Branding:**
```css
Manter gradiente azul original (#00C2FF → #0066FF)
```

**Backgrounds de Seções:**
```css
Alternância:
- Branco (#FFFFFF)
- Cinza claro (#F8F9FA)
- Verde muito claro (#F0F4F3) para seções especiais
```

**Cards e Elementos:**
```css
background: #FFFFFF;
border-top: 4px solid var(--agro-green);
hover: leve elevação + verde mais visível
```

---

## 📝 TIPOGRAFIA

### Família Tipográfica (Manter Montserrat)
```
Font Family: 'Montserrat', sans-serif
Weights: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)
```

### Hierarquia e Tamanhos

**Desktop:**
```css
/* Headlines */
--h1-size: 3.5rem;        /* 56px - Hero principal */
--h1-weight: 700;
--h1-line-height: 1.1;
--h1-letter-spacing: -0.02em;

--h2-size: 2.5rem;        /* 40px - Títulos de seção */
--h2-weight: 700;
--h2-line-height: 1.2;

--h3-size: 1.75rem;       /* 28px - Subtítulos */
--h3-weight: 600;
--h3-line-height: 1.3;

--h4-size: 1.25rem;       /* 20px - Cards */
--h4-weight: 600;

/* Body Text */
--body-large: 1.25rem;    /* 20px - Lead paragraphs */
--body-regular: 1.125rem; /* 18px - Texto principal */
--body-small: 1rem;       /* 16px - Texto secundário */
--body-tiny: 0.875rem;    /* 14px - Captions */
```

**Mobile (< 768px):**
```css
--h1-size-mobile: 2.25rem;    /* 36px */
--h2-size-mobile: 1.875rem;   /* 30px */
--h3-size-mobile: 1.5rem;     /* 24px */
--body-regular-mobile: 1rem;  /* 16px */
```

**Aplicação por Contexto:**

**Hero:**
```css
h1: 3.5rem (desktop) / 2.25rem (mobile)
Subheadline: 1.25rem (desktop) / 1rem (mobile)
Peso: 700 para H1, 500 para subheadline
```

**Seções:**
```css
Título seção (h2): 2.5rem, centrado, peso 700
Descrição seção: 1.125rem, peso 400, cor text-secondary
```

**Cards:**
```css
Título card: 1.25rem, peso 600
Texto card: 1rem, peso 400, cor text-secondary
```

---

## 🧱 COMPONENTES UI

### Botões

**Primário (WhatsApp CTA):**
```css
background: var(--agro-green);
color: white;
padding: 1rem 2rem;
border-radius: 8px;
font-size: 1.125rem;
font-weight: 600;
box-shadow: 0 4px 12px rgba(46, 204, 113, 0.3);
transition: all 0.3s ease;

hover:
  background: var(--agro-green-dark);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(46, 204, 113, 0.4);
```

**Secundário (Outline):**
```css
background: transparent;
border: 2px solid var(--agro-green);
color: var(--agro-green);
padding: 1rem 2rem;
border-radius: 8px;
font-size: 1.125rem;
font-weight: 600;

hover:
  background: var(--agro-green);
  color: white;
```

**Terciário (Link):**
```css
color: var(--agro-green);
text-decoration: underline;
font-weight: 600;

hover:
  color: var(--agro-green-dark);
```

---

### Cards

**Card Padrão:**
```css
background: white;
padding: 2.5rem;
border-radius: 12px;
border-top: 4px solid var(--agro-green);
box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
transition: all 0.3s ease;

hover:
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  border-top-color: var(--agro-green-dark);
```

**Card com Ícone:**
```css
Ícone no topo: 64x64px, cor verde (#2ECC71)
Título: h3 style
Descrição: body regular, text-secondary
Espaçamento: 1.5rem entre elementos
```

---

### Header / Navegação

**Layout:**
```
┌─────────────────────────────────────────────────────────┐
│  [Logo]          Nav Links (desktop)      [WhatsApp]    │
└─────────────────────────────────────────────────────────┘
```

**Estilo:**
```css
position: fixed;
top: 0;
width: 100%;
background: rgba(255, 255, 255, 0.95);
backdrop-filter: blur(10px);
box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
padding: 1rem 0;
z-index: 1000;

Logo: height 50px
Nav links: font-size 1rem, weight 600, color text-primary
          hover: color agro-green

WhatsApp button: sempre visível (sticky)
```

**Mobile:**
```css
Menu hamburger: ícone 24x24px
Drawer menu: slide from right
Logo: versão compacta (ícone + texto menor)
```

---

### Hero Section

**Layout Desktop:**
```
┌─────────────────────────────────────────────────┐
│                                                 │
│  Background: Imagem campo/fazenda com overlay  │
│                                                 │
│         ┌─────────────────────┐                │
│         │   Headline H1       │                │
│         │   Subheadline       │                │
│         │   [CTA Button]      │                │
│         └─────────────────────┘                │
│                                                 │
└─────────────────────────────────────────────────┘
```

**Estilo:**
```css
min-height: 100vh;
background: url(hero-image.jpg);
background-size: cover;
background-position: center;
position: relative;

Overlay:
  background: linear-gradient(135deg,
    rgba(10, 37, 64, 0.7) 0%,
    rgba(10, 37, 64, 0.4) 100%);

Conteúdo:
  position: absolute;
  z-index: 2;
  text-align: center;
  color: white;
  max-width: 800px;
  margin: 0 auto;
```

---

### Seções de Conteúdo

**Alternância de Backgrounds:**
```
Seção 1 (Hero): Imagem com overlay
Seção 2 (Desafios): Branco (#FFFFFF)
Seção 3 (Solução): Cinza claro (#F8F9FA)
Seção 4 (Metodologia): Branco
Seção 5 (Pacotes): Verde muito claro (#F0F4F3)
Seção 6 (Diferenciais): Branco
Seção 7 (FAQ): Cinza claro
Seção 8 (CTA Final): Verde com imagem de fundo
Footer: Azul escuro (#0A2540)
```

**Padding:**
```css
Desktop: 6rem 0 (top/bottom)
Mobile: 4rem 0
```

---

### Grid Layouts

**2 Colunas (Desktop):**
```css
display: grid;
grid-template-columns: repeat(2, 1fr);
gap: 2.5rem;

@media (max-width: 768px) {
  grid-template-columns: 1fr;
  gap: 1.5rem;
}
```

**3 Colunas (Desktop):**
```css
grid-template-columns: repeat(3, 1fr);
gap: 2rem;

@media (max-width: 1024px) {
  grid-template-columns: repeat(2, 1fr);
}

@media (max-width: 768px) {
  grid-template-columns: 1fr;
}
```

---

### Ícones

**Estilo:**
```css
Tamanho padrão: 48x48px (cards)
Tamanho grande: 64x64px (destaques)
Tamanho pequeno: 24x24px (inline)

Cor: var(--agro-green)
Estilo: Outline stroke (não filled)
Stroke-width: 2px
```

**Fornecimento:**
- Usar ícones das imagens geradas no Banana Pro
- Fallback: Heroicons ou Lucide (outline style)

---

### Imagens e Mídia

**Hero Background:**
```css
width: 100%;
height: 100vh;
object-fit: cover;
position: absolute;
z-index: 1;
filter: brightness(0.8) contrast(1.1);
```

**Imagens de Seção:**
```css
max-width: 100%;
height: auto;
border-radius: 12px;
box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
```

**Mockups/Screenshots:**
```css
border: 1px solid var(--border-light);
border-radius: 8px;
box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
```

---

### FAQ Accordion

**Estilo:**
```css
.faq-item {
  border-bottom: 1px solid var(--border-light);
  padding: 1.5rem 0;
}

.faq-question {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  font-weight: 600;
  font-size: 1.125rem;
  color: var(--text-primary);
  transition: color 0.2s;
}

.faq-question:hover {
  color: var(--agro-green);
}

.faq-icon {
  width: 24px;
  height: 24px;
  color: var(--agro-green);
  transition: transform 0.3s;
}

.faq-item.active .faq-icon {
  transform: rotate(180deg);
}

.faq-answer {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
  color: var(--text-secondary);
  padding-top: 0;
}

.faq-item.active .faq-answer {
  max-height: 500px;
  padding-top: 1rem;
}
```

---

### Timeline / Steps (Metodologia)

**Layout:**
```
┌──────────────────────────────────────────────────┐
│  01        02        03                          │
│  ●─────────●─────────●                           │
│  │         │         │                           │
│  Etapa 1  Etapa 2  Etapa 3                      │
└──────────────────────────────────────────────────┘
```

**Estilo:**
```css
Número grande:
  font-size: 5rem;
  font-weight: 700;
  color: rgba(46, 204, 113, 0.15); /* Verde muito claro */
  position: absolute;
  z-index: 0;

Conteúdo:
  position: relative;
  z-index: 1;
  padding-left: 3rem;

Linha conectora (desktop):
  border-top: 3px dashed var(--agro-green-light);
  width: 100%;
```

---

## 🎯 EFEITOS E ANIMAÇÕES

### Hover States

**Cards:**
```css
transform: translateY(-8px);
box-shadow: aumenta suavemente;
transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
```

**Botões:**
```css
transform: translateY(-2px);
box-shadow: aumenta e fica mais verde;
transition: all 0.2s ease;
```

**Links:**
```css
color shift para agro-green;
text-decoration-thickness aumenta;
```

---

### Scroll Animations

**Fade In Up (ao entrar no viewport):**
```css
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in-up {
  animation: fadeInUp 0.6s ease-out;
}
```

**Aplicar em:**
- Cards ao aparecer
- Títulos de seção
- Imagens grandes

---

### Loading States

**Skeleton Loading (se necessário):**
```css
background: linear-gradient(90deg,
  #f0f0f0 25%,
  #e0e0e0 50%,
  #f0f0f0 75%);
background-size: 200% 100%;
animation: loading 1.5s infinite;

@keyframes loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

## 📱 RESPONSIVIDADE

### Breakpoints
```css
/* Mobile first approach */
--mobile: 0px;
--tablet: 768px;
--desktop: 1024px;
--wide: 1440px;

@media (min-width: 768px) { /* Tablet */ }
@media (min-width: 1024px) { /* Desktop */ }
@media (min-width: 1440px) { /* Wide */ }
```

### Container Widths
```css
Mobile: 100% - 2rem padding (cada lado)
Tablet: 90%
Desktop: max-width 1200px
Wide: max-width 1400px
```

### Ajustes Mobile Críticos

**Hero:**
- H1: 2.25rem
- Padding top: 100px (espaço para header fixo)
- Botão: full-width ou quase

**Cards:**
- Grid 3-col → 1-col
- Padding reduzido: 1.5rem

**Timeline:**
- Horizontal → Vertical
- Linha conectora: vertical à esquerda

**Header:**
- Logo menor
- Menu hamburger
- WhatsApp sempre visível (ícone apenas)

---

## 🌟 ELEMENTOS ESPECIAIS

### Badges
```css
.badge {
  display: inline-block;
  padding: 0.5rem 1rem;
  background: var(--agro-green-light);
  color: var(--agro-green-dark);
  border-radius: 20px;
  font-size: 0.875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.badge-primary {
  background: var(--agro-green);
  color: white;
}
```

**Uso:** "Mais Popular", "Recomendado", etc.

---

### Destaques / Callouts
```css
.callout {
  background: var(--bg-alt);
  border-left: 4px solid var(--agro-green);
  padding: 1.5rem;
  border-radius: 8px;
  margin: 2rem 0;
}

.callout-icon {
  color: var(--agro-green);
  width: 24px;
  height: 24px;
  display: inline-block;
  vertical-align: middle;
  margin-right: 0.5rem;
}
```

**Uso:** Notas importantes, CTAs secundários

---

### Divisores de Seção
```css
.section-divider {
  height: 1px;
  background: linear-gradient(90deg,
    transparent 0%,
    var(--border-light) 50%,
    transparent 100%);
  margin: 4rem 0;
}
```

---

## ✅ CHECKLIST DE CONSISTÊNCIA

### Ao criar cada seção, garantir:

- [ ] Padding vertical consistente (6rem desktop, 4rem mobile)
- [ ] Título da seção h2, centrado, 2.5rem
- [ ] Espaçamento entre título e conteúdo: 3rem
- [ ] Cards com border-top verde (4px)
- [ ] Hover states em todos elementos interativos
- [ ] Ícones 48px, cor verde
- [ ] Botões com padding 1rem 2rem, border-radius 8px
- [ ] Transições suaves (0.3s ease)
- [ ] Responsividade testada
- [ ] Contraste de cor acessível (WCAG AA mínimo)

---

## 🎨 MOOD BOARD / REFERÊNCIAS DE ESTILO

**Inspirações:**
- Stripe (simplicidade, clareza)
- Linear (modernidade, animações suaves)
- Notion (hierarquia clara, tipografia)
- Agricolors (paleta terrosa agricultura)

**Evitar:**
- Gradientes exagerados
- Animações muito chamativas
- Cores muito saturadas
- Tipografia condensada demais
- Clutter visual

**Buscar:**
- Espaçamento generoso (whitespace)
- Hierarquia visual clara
- Cores naturais + tech
- Confiança + modernidade
- Simplicidade profissional

---

## 📦 ASSETS ORGANIZADOS

### Estrutura de Pastas
```
site-assets/
├── hero/
│   ├── hero-background-main.png
│   ├── hero-background-mobile.png
│   └── hero-overlay-gradient.png
├── desafios/
│   ├── icon-dados-dispersos.png
│   ├── icon-custo-invisivel.png
│   ├── icon-processos-manuais.png
│   └── icon-complexidade-campo.png
├── solucao/
│   ├── diagrama-antes-caos.png
│   ├── diagrama-depois-organizado.png
│   └── mockup-dashboard-agricola.png
├── metodologia/
│   ├── foto-descoberta-reuniao.png
│   ├── diagrama-integracao-tecnica.png
│   └── foto-dashboard-em-uso.png
├── diferenciais/
│   ├── icon-especializacao-agro.png
│   ├── icon-seguranca-dados.png
│   ├── icon-integracao-natural.png
│   ├── icon-interface-simples.png
│   ├── icon-melhoria-continua.png
│   └── icon-metodologia-documentada.png
└── logos/
    ├── logo-full-color.svg (atual)
    └── logo-white.svg (footer)
```

---

## 🚀 IMPLEMENTAÇÃO

### Tecnologia
```
Frontend: HTML5 + CSS3 (Vanilla ou Next.js)
Responsividade: Mobile-first approach
Performance: Lazy loading de imagens
Acessibilidade: Semantic HTML + ARIA labels
SEO: Meta tags otimizadas para agro
```

### Ordem de Implementação
1. Setup base (reset CSS, variáveis, tipografia)
2. Header + navegação
3. Hero section (validação visual)
4. Seção por seção com validações
5. Footer
6. Interações (FAQ, smooth scroll)
7. Responsividade
8. Performance optimization
9. Testes cross-browser

---

**Documento criado por:** Claude Code + Business Context Expert
**Baseado em:** Logo existente + Foco agronegócio + Copy refinado
**Status:** Pronto para codificação
**Próximo passo:** Wireframes detalhados → Implementação HTML/CSS
