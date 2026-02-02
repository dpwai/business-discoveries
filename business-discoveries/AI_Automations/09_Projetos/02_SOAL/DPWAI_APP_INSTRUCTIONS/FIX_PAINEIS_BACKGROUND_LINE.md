# Fix: Linha Cinza Inconsistente na Tela de Painéis

## Problema

Na tela de Painéis (Dashboards), há uma linha horizontal cinza mais clara que aparece no fundo em uma posição que não faz sentido visualmente. Parece ser um artefato de CSS - possivelmente uma borda, divisor ou mudança de cor de background que não deveria estar visível.

## Screenshot de Referência

Observar a área de fundo da tela - existe uma linha/faixa horizontal cinza clara que:
- Não corresponde a nenhuma divisão lógica de conteúdo
- Quebra a continuidade visual do fundo escuro
- Parece ser um bug de CSS não intencional

## Possíveis Causas

1. **Border indesejada** em algum container pai
2. **Background-color diferente** em um elemento wrapper
3. **Box-shadow** ou **outline** vazando de algum componente
4. **Divisor/separator** renderizado incorretamente
5. **Grid/Flex gap** com cor de fundo diferente
6. **Elemento fantasma** com altura mínima e cor diferente

## Como Investigar

```javascript
// No DevTools, inspecionar elementos na área da linha:
// 1. Usar o seletor de elementos (Ctrl+Shift+C)
// 2. Clicar exatamente na linha cinza
// 3. Verificar qual elemento está selecionado
// 4. Checar as propriedades:
//    - border
//    - background
//    - box-shadow
//    - outline
//    - ::before / ::after pseudo-elements
```

## Solução Esperada

- O fundo da área de conteúdo deve ter uma cor sólida uniforme
- Sem linhas ou divisores que não correspondam a separações lógicas de seção
- Background consistente: `#0d1f22` ou similar (dark theme)

## Checklist de Investigação

- [ ] Abrir DevTools na tela de Painéis
- [ ] Localizar o elemento que causa a linha
- [ ] Identificar qual propriedade CSS está gerando o artefato
- [ ] Remover/corrigir a propriedade
- [ ] Verificar se a correção não quebra outras telas
- [ ] Testar em diferentes resoluções

## Contexto

- **Tela:** Painéis / Dashboards
- **Rota provável:** `/paineis` ou `/dashboards`
- **Componente:** Layout principal ou wrapper da grid de cards

## Prioridade

**Média** - Bug visual que afeta a qualidade percebida do produto.

---

**Criado em:** 2026-02-02
**Status:** Pendente
