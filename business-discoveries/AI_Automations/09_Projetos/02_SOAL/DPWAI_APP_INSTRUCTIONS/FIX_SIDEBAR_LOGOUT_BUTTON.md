# Fix: Botão de Logout na Sidebar Colapsada

## Problema

O botão de logout (vermelho) no canto inferior esquerdo da sidebar está com visual quebrado quando a sidebar está reduzida/colapsada. Ele aparece cortado, desalinhado e fora do padrão visual do restante da interface.

## Screenshot de Referência

Observar o canto inferior esquerdo - o botão vermelho está:
- Cortado/truncado horizontalmente
- Desalinhado com os outros itens da sidebar
- Sem padding adequado
- Visualmente inconsistente com o design system

## Solução Esperada

### 1. Comportamento com Sidebar Expandida
- Mostrar ícone + texto "Sair" ou "Logout"
- Alinhado com os outros itens do menu
- Padding consistente com os demais itens

### 2. Comportamento com Sidebar Colapsada
- Mostrar APENAS o ícone (sem texto)
- Centralizado horizontalmente na sidebar
- Mesmo tamanho e estilo dos outros ícones da navegação
- Tooltip on hover mostrando "Sair"

### 3. Estilo Visual
- Manter a cor de destaque (vermelho/danger) para indicar ação destrutiva
- Mas integrar melhor com o design system:
  - Mesmo border-radius dos outros itens
  - Mesmo tamanho de ícone (provavelmente 20-24px)
  - Transição suave ao colapsar/expandir sidebar

## Padrão CSS Sugerido

```css
/* Botão de logout base */
.sidebar-logout {
  display: flex;
  align-items: center;
  justify-content: center; /* Centraliza quando colapsado */
  gap: 0.75rem;
  padding: 0.75rem;
  border-radius: 8px;
  color: #ef4444; /* red-500 */
  transition: all 0.2s ease;
  width: 100%;
}

.sidebar-logout:hover {
  background: rgba(239, 68, 68, 0.1); /* red com opacity */
}

/* Sidebar expandida */
.sidebar.expanded .sidebar-logout {
  justify-content: flex-start;
  padding: 0.75rem 1rem;
}

/* Sidebar colapsada - esconde texto */
.sidebar.collapsed .sidebar-logout span {
  display: none;
}

/* Ícone consistente */
.sidebar-logout svg {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}
```

## Checklist de Implementação

- [ ] Identificar o componente/arquivo que renderiza a sidebar
- [ ] Localizar o botão de logout atual
- [ ] Aplicar classes condicionais baseadas no estado da sidebar (expanded/collapsed)
- [ ] Garantir que o ícone fique centralizado quando colapsado
- [ ] Esconder o texto do botão quando colapsado
- [ ] Adicionar tooltip para acessibilidade quando colapsado
- [ ] Testar transição entre estados
- [ ] Verificar em diferentes resoluções

## Prioridade

**Alta** - Afeta a experiência visual em todas as páginas do app.

## Contexto Técnico

Este é o app DPWAI/SOAL - verificar qual framework está sendo usado (provavelmente React/Next.js) e seguir os padrões de componentes já estabelecidos no projeto.

---

**Criado em:** 2026-02-02
**Status:** Pendente
