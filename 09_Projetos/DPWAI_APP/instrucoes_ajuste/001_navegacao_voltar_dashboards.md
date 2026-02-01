# Ajuste: Navegacao do botao "Voltar" nos dashboards

**Data:** 2026-02-01
**Status:** Pendente
**Prioridade:** Alta

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
- [ ] Ajustar rota do botao "Voltar" nos dashboards nativos
- [ ] Definir `/dashboards/native` como tela inicial de "Paineis"
- [ ] Adicionar card "Contas a Receber" na listagem
- [ ] Testar navegacao em todos os 7 dashboards
