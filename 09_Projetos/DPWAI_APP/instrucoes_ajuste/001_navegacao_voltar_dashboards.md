# Ajuste: Navegacao do botao "Voltar" nos dashboards

**Data:** 2026-02-01
**Status:** ✅ Concluído
**Prioridade:** Alta
**Implementado em:** e146d49 (feature/secret-manager-87)

---

## O que esta acontecendo
Quando estou em um dashboard especifico (ex: `/dashboards/native/graos`) e clico no botao "Voltar", sou levado para uma tela que mostra apenas 2 dashboards personalizados — nao e a tela correta.

## O que deveria acontecer
O botao "Voltar" deve levar para a tela de **Dashboards Agricolas** (`/dashboards/native`), que exibe os 7 paineis nativos:
- Painel Operacional
- Estoque de Graos
- Estoque de Insumos
- Gestao de Maquinario
- Custos por Fazenda
- Contas a Pagar
- Contas a Receber

Essa tela tambem deve ser a **tela inicial** quando o usuario clica em "Paineis" no menu.

## Onde
- **Fluxo:** Dashboard especifico → Botao Voltar → Tela de listagem
- **Rota atual (errada):** mostra dashboards personalizados
- **Rota esperada:** `/dashboards/native` (Dashboards Agricolas)
- **URL de referencia:** https://app.dpwai.com.br/dpwai/demo_farm_dc4096d5/dashboards/native

## Contexto adicional
A tela de Dashboards Agricolas tem o layout ideal: cards com icones coloridos, descricoes claras, secao "Dashboards Nativos DPWAI" no rodape. Essa deve ser a experiencia padrao ao acessar Paineis.

---

## Checklist de implementacao
- [x] Ajustar rota do botao "Voltar" nos dashboards nativos
- [x] Definir `/dashboards/native` como tela inicial de "Paineis"
- [x] Adicionar card "Contas a Receber" na listagem (já existia!)
- [x] Testar navegacao em todos os 7 dashboards (todos já apontavam correto)

### Arquivos modificados:
- `dpwaiagro/app/dpwai/[tenant_snake]/layout.tsx` - Menu lateral
- `dpwaiagro/app/dpwai/[tenant_snake]/page.tsx` - Home page
- `dpwaiagro/app/dpwai/[tenant_snake]/dashboard/page.tsx` - Redirect
- `dpwaiagro/app/dpwai/[tenant_snake]/dashboards/native/operacional/page.tsx` - Botão voltar
- `dpwaiagro/components/PremiumWelcome.tsx` - Card de boas-vindas
