# Fix: Lógica do Botão "Voltar" na Navegação

## Problema

O botão "← Voltar" está usando navegação por histórico do browser (`history.back()`) ao invés de navegar para a rota pai na hierarquia. Isso causa comportamento confuso:

**Fluxo atual (bugado):**
```
Home → Lista de Painéis → Painel X → [Voltar] → Lista de Painéis → [Voltar] → Painel X 🔄
```

**Fluxo esperado (correto):**
```
Home → Lista de Painéis → Painel X → [Voltar] → Lista de Painéis → [Voltar] → Home ✅
```

## Causa Raiz

O botão provavelmente usa:
```javascript
// ❌ ERRADO - usa histórico do browser
onClick={() => router.back()}
// ou
onClick={() => history.back()}
// ou
onClick={() => navigate(-1)}
```

## Solução

O botão "Voltar" deve navegar para a **rota pai hierárquica**, não para a página anterior no histórico.

```javascript
// ✅ CORRETO - navega para rota pai definida
onClick={() => router.push('/paineis')}  // de dentro de um painel
onClick={() => router.push('/')}          // da lista de painéis
```

### Implementação Sugerida

**Opção 1: Prop explícita de destino**
```tsx
interface BackButtonProps {
  to: string; // rota de destino explícita
  label?: string;
}

function BackButton({ to, label = "Voltar" }: BackButtonProps) {
  const router = useRouter();
  return (
    <button onClick={() => router.push(to)}>
      ← {label}
    </button>
  );
}

// Uso:
<BackButton to="/paineis" />        // dentro de um painel
<BackButton to="/" />               // na lista de painéis
```

**Opção 2: Inferir rota pai automaticamente**
```tsx
function BackButton() {
  const router = useRouter();
  const pathname = router.pathname;

  // Remove o último segmento da rota
  const parentPath = pathname.split('/').slice(0, -1).join('/') || '/';

  return (
    <button onClick={() => router.push(parentPath)}>
      ← Voltar
    </button>
  );
}
```

**Opção 3: Breadcrumb-based navigation**
```tsx
// Se já existe um sistema de breadcrumbs, usar o penúltimo item
const breadcrumbs = useBreadcrumbs();
const parentCrumb = breadcrumbs[breadcrumbs.length - 2];

<button onClick={() => router.push(parentCrumb.path)}>
  ← Voltar
</button>
```

## Hierarquia de Rotas Esperada

```
/                           → Home (não tem Voltar)
/paineis                    → Voltar vai para /
/paineis/agricolas          → Voltar vai para /paineis
/paineis/agricolas/[id]     → Voltar vai para /paineis/agricolas
/paineis/nativos            → Voltar vai para /paineis
/paineis/nativos/[id]       → Voltar vai para /paineis/nativos
```

## Checklist de Correção

- [ ] Identificar componente do botão Voltar (provavelmente em layout ou header)
- [ ] Substituir `history.back()` por navegação explícita
- [ ] Definir mapeamento de rotas pai para cada seção
- [ ] Testar fluxo completo de navegação
- [ ] Verificar se há outros lugares usando `history.back()` incorretamente

## Edge Cases

- **Acesso direto via URL:** Se o usuário acessa `/paineis/agricolas/custo-hectare` diretamente (sem histórico), o Voltar deve funcionar corretamente para `/paineis/agricolas`
- **Deep links:** Links compartilhados devem ter navegação funcional mesmo sem histórico prévio

## Prioridade

**Alta** - Afeta UX fundamental de navegação em todo o app.

---

**Criado em:** 2026-02-02
**Status:** Pendente
