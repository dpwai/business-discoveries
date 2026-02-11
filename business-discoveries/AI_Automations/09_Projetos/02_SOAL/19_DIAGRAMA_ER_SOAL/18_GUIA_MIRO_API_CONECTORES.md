# GUIA COMPLETO - Miro API para Conectores ER

**Data:** 10/02/2026
**Versao:** 1.0
**Objetivo:** Criar os 33 relacionamentos do Modulo Consumo e Estoque via Miro REST API
**Board:** https://miro.com/app/board/uXjVGE__XFQ=/

---

## PARTE 1: Configuracao (unica vez, ~10 minutos)

### Passo 1: Criar um App no Miro Developer

1. Abra: https://miro.com/app/settings/user-profile/apps
2. Clique **"Create new app"**
3. Preencha:
   - **App name:** `SOAL ER Connectors`
   - **Description:** `Automacao de conectores para diagrama ER`
4. Clique **"Create app"**

### Passo 2: Configurar Permissoes (Scopes)

Na pagina do app que acabou de criar, role ate a secao **"Permissions"** e marque:

- [x] `boards:read` — Para ler os items (entidades) do board
- [x] `boards:write` — Para criar os conectores

**IMPORTANTE:** Desmarque a opcao **"Expire user authorization token"** para gerar um token que nao expira. Para uso pessoal/interno, isso e seguro e evita ter que renovar.

### Passo 3: Instalar o App e Pegar o Token

1. Role ate o final da pagina do app
2. Clique **"Install app and get OAuth token"**
3. No dropdown **"Select a team"**, selecione o time onde esta o board CLAUDE_SOAL
4. Clique **"Install & authorize"**
5. **COPIE O TOKEN** que aparece — esse e seu `ACCESS_TOKEN`
6. Guarde em local seguro (nao coloque em repositorios publicos!)

### Passo 4: Confirmar que Funciona

Abra o terminal e rode:

```bash
curl -s -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  "https://api.miro.com/v2/boards/uXjVGE__XFQ%3D" | python3 -m json.tool
```

Voce deve ver o JSON do board com o nome `CLAUDE_SOAL`. Se der erro 401, o token esta errado. Se der 403, as permissoes estao incompletas.

> **Nota:** O `=` no final do board ID precisa ser encoded como `%3D` na URL.

---

## PARTE 2: Mapear IDs das Entidades (~15 minutos)

### Por que precisa disso?

A API do Miro cria conectores entre **IDs de items**. Precisamos descobrir o ID de cada entidade (shape/card) no board para poder conecta-las.

### Passo 5: Listar Todos os Items do Board

Crie um arquivo `01_listar_items.sh`:

```bash
#!/bin/bash
# =============================================================
# SCRIPT 1: Listar todos os items do board Miro
# Salva em miro_items.json para referencia
# =============================================================

TOKEN="SEU_TOKEN_AQUI"
BOARD_ID="uXjVGE__XFQ%3D"

echo "Buscando items do board..."

# Pagina 1 (ate 50 items por pagina)
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.miro.com/v2/boards/$BOARD_ID/items?limit=50" \
  > miro_items_page1.json

echo "Pagina 1 salva em miro_items_page1.json"

# Verificar se tem mais paginas
CURSOR=$(python3 -c "
import json
with open('miro_items_page1.json') as f:
    data = json.load(f)
    cursor = data.get('cursor', '')
    print(cursor)
    print(f'Total nesta pagina: {len(data.get(\"data\", []))}', file=__import__('sys').stderr)
")

if [ -n "$CURSOR" ]; then
    echo "Buscando pagina 2..."
    curl -s -H "Authorization: Bearer $TOKEN" \
      "https://api.miro.com/v2/boards/$BOARD_ID/items?limit=50&cursor=$CURSOR" \
      > miro_items_page2.json
    echo "Pagina 2 salva"
fi

echo ""
echo "Agora rode o Script 2 para filtrar as entidades."
```

### Passo 6: Filtrar e Identificar as Entidades

Crie um arquivo `02_filtrar_entidades.py`:

```python
#!/usr/bin/env python3
"""
SCRIPT 2: Filtra items do board e identifica as entidades do modulo.
Gera um mapa de nome -> ID para usar nos conectores.
"""

import json
import glob
import sys

# Carregar todos os arquivos de paginas
all_items = []
for filename in sorted(glob.glob("miro_items_page*.json")):
    with open(filename) as f:
        data = json.load(f)
        all_items.extend(data.get("data", []))

print(f"Total de items encontrados: {len(all_items)}")
print("=" * 70)

# Mostrar todos os items com seus tipos e conteudo
for item in all_items:
    item_id = item.get("id", "")
    item_type = item.get("type", "")

    # Extrair texto do item
    content = ""
    if "data" in item:
        content = item["data"].get("content", "")
        if not content:
            content = item["data"].get("title", "")
        if not content:
            content = item["data"].get("plainText", "")

    # Limpar HTML tags do content
    import re
    clean_content = re.sub(r'<[^>]+>', '', content).strip()

    if clean_content:
        print(f"ID: {item_id:20s} | Tipo: {item_type:12s} | Conteudo: {clean_content[:80]}")

print("\n" + "=" * 70)
print("\nPROXIMO PASSO:")
print("Copie os IDs das entidades abaixo e preencha no arquivo entity_map.json")
print("Procure por shapes/cards que contenham os nomes das entidades.")
print("As entidades que precisamos encontrar:")
print()

entities_needed = [
    # Modulo Consumo e Estoque (Frame 10)
    "PRODUTO_INSUMO",
    "COMPRA_INSUMO",
    "ESTOQUE_INSUMO",
    "MOVIMENTACAO_INSUMO",
    "APLICACAO_INSUMO",
    "RECEITUARIO_AGRONOMICO",
    # Entidades externas referenciadas
    "ORGANIZATIONS",
    "USERS",
    "NOTA_FISCAL_ITEM",
    "PARCEIRO_COMERCIAL",
    "SAFRAS",
    "CULTURAS",
    "CONTRATO_COMERCIAL",
    "FAZENDAS",
    "OPERACAO_CAMPO",
    "TALHAO_SAFRA",
    "MANEJO_SANITARIO",
    "MANUTENCOES",
    "CUSTO_OPERACAO",
    # Entidades reversas
    "PULVERIZACAO_DETALHE",
    "DRONE_DETALHE",
    "DIETA_INGREDIENTE",
]

for name in entities_needed:
    print(f"  - {name}")
```

### Passo 7: Criar o Mapa de Entidades

Depois de rodar os scripts acima e identificar os IDs, crie o arquivo `entity_map.json`:

```json
{
    "_INSTRUCOES": "Preencha cada ID com o valor encontrado no Script 2. Se a entidade ainda nao existe no board, deixe como string vazia e o Script 3 vai ignorar esse conector.",

    "PRODUTO_INSUMO": "",
    "COMPRA_INSUMO": "",
    "ESTOQUE_INSUMO": "",
    "MOVIMENTACAO_INSUMO": "",
    "APLICACAO_INSUMO": "",
    "RECEITUARIO_AGRONOMICO": "",

    "ORGANIZATIONS": "",
    "USERS": "",
    "NOTA_FISCAL_ITEM": "",
    "PARCEIRO_COMERCIAL": "",
    "SAFRAS": "",
    "CULTURAS": "",
    "CONTRATO_COMERCIAL": "",
    "FAZENDAS": "",
    "OPERACAO_CAMPO": "",
    "TALHAO_SAFRA": "",
    "MANEJO_SANITARIO": "",
    "MANUTENCOES": "",
    "CUSTO_OPERACAO": "",

    "PULVERIZACAO_DETALHE": "",
    "DRONE_DETALHE": "",
    "DIETA_INGREDIENTE": ""
}
```

> **DICA:** Se o board tem muitos items e fica dificil achar, tente filtrar pelo tipo `shape` ou `card` no Script 2, ou busque pelo conteudo de texto.

---

## PARTE 3: Criar os Conectores (~5 minutos de execucao)

### Passo 8: O Script Principal

Crie o arquivo `03_criar_conectores.py`:

```python
#!/usr/bin/env python3
"""
=============================================================
SCRIPT 3: Criar todos os 33 conectores do Modulo Consumo e Estoque
no board Miro via REST API.

Referencia: Doc 17 - RELACIONAMENTOS_CONSUMO_ESTOQUE.md
=============================================================
"""

import json
import requests
import time
import sys

# ─────────────────────────────────────────────────────────────
# CONFIGURACAO
# ─────────────────────────────────────────────────────────────

TOKEN = "SEU_TOKEN_AQUI"  # <-- SUBSTITUA pelo seu token
BOARD_ID = "uXjVGE__XFQ="  # ID do board CLAUDE_SOAL

API_BASE = f"https://api.miro.com/v2/boards/{BOARD_ID}/connectors"
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/json",
}

# Delay entre requests para respeitar rate limit (Level 2)
DELAY_SECONDS = 0.5

# ─────────────────────────────────────────────────────────────
# CARREGAR MAPA DE ENTIDADES
# ─────────────────────────────────────────────────────────────

with open("entity_map.json") as f:
    ENTITY_MAP = json.load(f)
    # Remover chaves de instrucao
    ENTITY_MAP.pop("_INSTRUCOES", None)


def get_id(entity_name):
    """Retorna o ID do Miro para uma entidade. Retorna None se nao mapeado."""
    item_id = ENTITY_MAP.get(entity_name, "")
    if not item_id:
        return None
    return str(item_id)


# ─────────────────────────────────────────────────────────────
# MAPEAMENTO DE CARDINALIDADE -> STROKE CAPS ERD
# ─────────────────────────────────────────────────────────────
#
# Crow's Foot Notation usando os caps nativos do Miro:
#
#   erd_only_one   ||    Exatamente um (obrigatorio)
#   erd_one        |     Um (generico)
#   erd_many       >     Muitos (crow's foot)
#   erd_one_or_many|>    Um ou muitos (obrigatorio)
#   erd_zero_or_one o|   Zero ou um (opcional)
#   erd_zero_or_many o>  Zero ou muitos (opcional)
#

# Mapeamento de cardinalidade:
# "1:N_obrig"  -> start=erd_only_one,  end=erd_one_or_many
# "1:N_opt"    -> start=erd_only_one,  end=erd_zero_or_many
# "1:1_obrig"  -> start=erd_only_one,  end=erd_only_one
# "1:1_opt"    -> start=erd_only_one,  end=erd_zero_or_one
# "N:1_obrig"  -> start=erd_one_or_many, end=erd_only_one
# "N:1_opt"    -> start=erd_zero_or_many, end=erd_only_one

CARDINALITY_MAP = {
    "1:N_obrig": ("erd_only_one", "erd_one_or_many"),
    "1:N_opt":   ("erd_only_one", "erd_zero_or_many"),
    "1:1_obrig": ("erd_only_one", "erd_only_one"),
    "1:1_opt":   ("erd_only_one", "erd_zero_or_one"),
    "N:1_obrig": ("erd_one_or_many", "erd_only_one"),
    "N:1_opt":   ("erd_zero_or_many", "erd_only_one"),
}


# ─────────────────────────────────────────────────────────────
# DEFINICAO DOS 33 RELACIONAMENTOS
# ─────────────────────────────────────────────────────────────
#
# Cada item segue:
# {
#   "code":   "R01",
#   "from":   "ENTITY_FROM",
#   "to":     "ENTITY_TO",
#   "card":   "1:N_obrig",     # Chave do CARDINALITY_MAP
#   "style":  "normal|dashed", # Tipo de linha
#   "color":  "#hex",          # Cor da linha
#   "width":  1-24,            # Espessura
#   "shape":  "curved|straight|elbowed",
#   "label":  "texto curto",   # Caption no conector (ou "" sem label)
# }

RELATIONSHIPS = [
    # ═══════════════════════════════════════════════════════════
    # FASE 1: INTERNOS (10 conectores - dentro do modulo)
    # Todos: linha solida, cor amarela (#FFD700)
    # ═══════════════════════════════════════════════════════════
    {
        "code": "R01", "from": "PRODUTO_INSUMO", "to": "COMPRA_INSUMO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 3, "shape": "curved", "label": "",
    },
    {
        "code": "R02", "from": "PRODUTO_INSUMO", "to": "ESTOQUE_INSUMO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 2, "shape": "curved", "label": "",
    },
    {
        "code": "R03", "from": "PRODUTO_INSUMO", "to": "APLICACAO_INSUMO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 2, "shape": "curved", "label": "",
    },
    {
        "code": "R04", "from": "PRODUTO_INSUMO", "to": "RECEITUARIO_AGRONOMICO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 2, "shape": "curved", "label": "",
    },
    {
        "code": "R05", "from": "COMPRA_INSUMO", "to": "MOVIMENTACAO_INSUMO",
        "card": "1:1_opt", "style": "normal", "color": "#FFD700",
        "width": 3, "shape": "curved", "label": "",
    },
    {
        "code": "R06", "from": "ESTOQUE_INSUMO", "to": "MOVIMENTACAO_INSUMO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 3, "shape": "curved", "label": "",
    },
    {
        "code": "R07", "from": "APLICACAO_INSUMO", "to": "MOVIMENTACAO_INSUMO",
        "card": "1:1_opt", "style": "normal", "color": "#FFD700",
        "width": 3, "shape": "curved", "label": "",
    },
    {
        "code": "R08", "from": "ESTOQUE_INSUMO", "to": "APLICACAO_INSUMO",
        "card": "1:N_obrig", "style": "normal", "color": "#FFD700",
        "width": 2, "shape": "curved", "label": "",
    },
    {
        "code": "R09", "from": "RECEITUARIO_AGRONOMICO", "to": "APLICACAO_INSUMO",
        "card": "1:N_opt", "style": "normal", "color": "#FFD700",
        "width": 2, "shape": "curved", "label": "",
    },
    {
        "code": "R10", "from": "MOVIMENTACAO_INSUMO", "to": "ESTOQUE_INSUMO",
        "card": "N:1_opt", "style": "dashed", "color": "#FFD700",
        "width": 1, "shape": "curved", "label": "transferencia",
    },

    # ═══════════════════════════════════════════════════════════
    # FASE 2: EXTERNOS CRITICOS (8 conectores)
    # Cores variam por camada destino
    # ═══════════════════════════════════════════════════════════

    # R21 - A RELACAO MAIS IMPORTANTE (intra-camada Agricola = amarela solida)
    {
        "code": "R21", "from": "APLICACAO_INSUMO", "to": "OPERACAO_CAMPO",
        "card": "N:1_opt", "style": "normal", "color": "#FFD700",
        "width": 3, "shape": "elbowed", "label": "operacao",
    },
    # R25 - Gera custo (Financeiro = laranja tracejada)
    {
        "code": "R25", "from": "APLICACAO_INSUMO", "to": "CUSTO_OPERACAO",
        "card": "1:1_obrig", "style": "dashed", "color": "#FF8C00",
        "width": 3, "shape": "elbowed", "label": "gera custo",
    },
    # R13 - NF (Financeiro = laranja tracejada)
    {
        "code": "R13", "from": "COMPRA_INSUMO", "to": "NOTA_FISCAL_ITEM",
        "card": "N:1_opt", "style": "dashed", "color": "#FF8C00",
        "width": 2, "shape": "elbowed", "label": "NF",
    },
    # R14 - Fornecedor (Territorial = verde tracejada)
    {
        "code": "R14", "from": "COMPRA_INSUMO", "to": "PARCEIRO_COMERCIAL",
        "card": "N:1_obrig", "style": "dashed", "color": "#2E8B57",
        "width": 2, "shape": "elbowed", "label": "fornecedor",
    },
    # R15 - Safra (Territorial = verde tracejada)
    {
        "code": "R15", "from": "COMPRA_INSUMO", "to": "SAFRAS",
        "card": "N:1_obrig", "style": "dashed", "color": "#2E8B57",
        "width": 2, "shape": "elbowed", "label": "safra",
    },
    # R19 - Fazenda (Territorial = verde tracejada)
    {
        "code": "R19", "from": "ESTOQUE_INSUMO", "to": "FAZENDAS",
        "card": "N:1_obrig", "style": "dashed", "color": "#2E8B57",
        "width": 2, "shape": "elbowed", "label": "onde esta",
    },
    # R22 - Talhao Safra (Territorial = verde tracejada)
    {
        "code": "R22", "from": "APLICACAO_INSUMO", "to": "TALHAO_SAFRA",
        "card": "N:1_opt", "style": "dashed", "color": "#2E8B57",
        "width": 2, "shape": "elbowed", "label": "onde aplicou",
    },
    # R28 - Cultura (Territorial = verde tracejada)
    {
        "code": "R28", "from": "RECEITUARIO_AGRONOMICO", "to": "CULTURAS",
        "card": "N:1_obrig", "style": "dashed", "color": "#2E8B57",
        "width": 2, "shape": "elbowed", "label": "cultura",
    },

    # ═══════════════════════════════════════════════════════════
    # FASE 3: EXTERNOS SECUNDARIOS (10 conectores)
    # ═══════════════════════════════════════════════════════════

    # Organization links (Sistema = azul tracejada)
    {
        "code": "R11", "from": "PRODUTO_INSUMO", "to": "ORGANIZATIONS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "org",
    },
    {
        "code": "R12", "from": "COMPRA_INSUMO", "to": "ORGANIZATIONS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "org",
    },
    {
        "code": "R18", "from": "ESTOQUE_INSUMO", "to": "ORGANIZATIONS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "org",
    },
    {
        "code": "R20", "from": "APLICACAO_INSUMO", "to": "ORGANIZATIONS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "org",
    },
    {
        "code": "R27", "from": "RECEITUARIO_AGRONOMICO", "to": "ORGANIZATIONS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "org",
    },
    # Cultura destino (verde fina)
    {
        "code": "R16", "from": "COMPRA_INSUMO", "to": "CULTURAS",
        "card": "N:1_opt", "style": "dashed", "color": "#2E8B57",
        "width": 1, "shape": "elbowed", "label": "cultura destino",
    },
    # Barter (laranja fina)
    {
        "code": "R17", "from": "COMPRA_INSUMO", "to": "CONTRATO_COMERCIAL",
        "card": "N:1_opt", "style": "dashed", "color": "#FF8C00",
        "width": 1, "shape": "elbowed", "label": "barter",
    },
    # Manejo sanitario (verde fina, cruza camadas)
    {
        "code": "R23", "from": "APLICACAO_INSUMO", "to": "MANEJO_SANITARIO",
        "card": "N:1_opt", "style": "dashed", "color": "#2E8B57",
        "width": 1, "shape": "elbowed", "label": "manejo",
    },
    # Manutencao (ciano)
    {
        "code": "R24", "from": "APLICACAO_INSUMO", "to": "MANUTENCOES",
        "card": "N:1_opt", "style": "dashed", "color": "#00CED1",
        "width": 1, "shape": "elbowed", "label": "manutencao",
    },
    # Users (azul fina)
    {
        "code": "R26", "from": "MOVIMENTACAO_INSUMO", "to": "USERS",
        "card": "N:1_obrig", "style": "dashed", "color": "#4169E1",
        "width": 1, "shape": "elbowed", "label": "quem",
    },

    # ═══════════════════════════════════════════════════════════
    # FASE 4: REVERSOS (5 conectores)
    # Entidades de outros modulos apontando para PRODUTO_INSUMO
    # ═══════════════════════════════════════════════════════════
    {
        "code": "R29", "from": "PULVERIZACAO_DETALHE", "to": "PRODUTO_INSUMO",
        "card": "N:1_obrig", "style": "normal", "color": "#FFD700",
        "width": 1, "shape": "elbowed", "label": "",
    },
    {
        "code": "R30", "from": "DRONE_DETALHE", "to": "PRODUTO_INSUMO",
        "card": "N:1_obrig", "style": "normal", "color": "#FFD700",
        "width": 1, "shape": "elbowed", "label": "",
    },
    {
        "code": "R31", "from": "DIETA_INGREDIENTE", "to": "PRODUTO_INSUMO",
        "card": "N:1_obrig", "style": "dashed", "color": "#2E8B57",
        "width": 1, "shape": "elbowed", "label": "",
    },
    {
        "code": "R32", "from": "NOTA_FISCAL_ITEM", "to": "PRODUTO_INSUMO",
        "card": "N:1_obrig", "style": "dashed", "color": "#FF8C00",
        "width": 1, "shape": "elbowed", "label": "",
    },
    {
        "code": "R33", "from": "CONTRATO_COMERCIAL", "to": "PRODUTO_INSUMO",
        "card": "N:1_opt", "style": "dashed", "color": "#FF8C00",
        "width": 1, "shape": "elbowed", "label": "",
    },
]


# ─────────────────────────────────────────────────────────────
# FUNCAO PARA CRIAR UM CONECTOR
# ─────────────────────────────────────────────────────────────

def create_connector(rel):
    """Cria um conector no Miro board baseado na definicao do relacionamento."""

    from_id = get_id(rel["from"])
    to_id = get_id(rel["to"])

    # Pular se alguma entidade nao foi mapeada
    if not from_id or not to_id:
        missing = []
        if not from_id:
            missing.append(rel["from"])
        if not to_id:
            missing.append(rel["to"])
        return {"status": "SKIP", "code": rel["code"], "reason": f"ID faltando: {', '.join(missing)}"}

    # Determinar stroke caps pela cardinalidade
    start_cap, end_cap = CARDINALITY_MAP[rel["card"]]

    # Montar o body do request
    body = {
        "startItem": {
            "id": from_id,
            "snapTo": "auto",
        },
        "endItem": {
            "id": to_id,
            "snapTo": "auto",
        },
        "shape": rel["shape"],
        "style": {
            "strokeColor": rel["color"],
            "strokeWidth": str(rel["width"]),
            "strokeStyle": rel["style"],
            "startStrokeCap": start_cap,
            "endStrokeCap": end_cap,
            "fontSize": "14",
            "textOrientation": "aligned",
        },
    }

    # Adicionar caption se tem label
    if rel.get("label"):
        body["captions"] = [
            {
                "content": rel["label"],
                "position": "0.5",
                "textAlignVertical": "middle",
            }
        ]

    # Fazer o request
    response = requests.post(API_BASE, headers=HEADERS, json=body)

    if response.status_code in (200, 201):
        connector_id = response.json().get("id", "?")
        return {"status": "OK", "code": rel["code"], "id": connector_id}
    else:
        return {
            "status": "ERROR",
            "code": rel["code"],
            "http": response.status_code,
            "error": response.text[:200],
        }


# ─────────────────────────────────────────────────────────────
# EXECUCAO PRINCIPAL
# ─────────────────────────────────────────────────────────────

def main():
    print("=" * 70)
    print("  MIRO CONNECTOR BUILDER - Modulo Consumo e Estoque")
    print("  33 Relacionamentos | Doc 17 Reference")
    print("=" * 70)
    print()

    # Verificar token
    if TOKEN == "SEU_TOKEN_AQUI":
        print("ERRO: Substitua SEU_TOKEN_AQUI pelo seu token Miro!")
        print("Veja Parte 1, Passo 3 do guia.")
        sys.exit(1)

    # Verificar entity_map
    unmapped = [name for name, item_id in ENTITY_MAP.items() if not item_id]
    if unmapped:
        print(f"AVISO: {len(unmapped)} entidades sem ID no entity_map.json:")
        for name in unmapped:
            print(f"  - {name}")
        print()
        proceed = input("Continuar mesmo assim? Conectores sem ID serao pulados. (s/n): ")
        if proceed.lower() != "s":
            sys.exit(0)

    # Contadores
    ok_count = 0
    skip_count = 0
    error_count = 0
    results = []

    # Processar cada relacionamento
    for i, rel in enumerate(RELATIONSHIPS, 1):
        phase = ""
        if i <= 10:
            phase = "INTERNO"
        elif i <= 18:
            phase = "EXT-CRITICO"
        elif i <= 28:
            phase = "EXT-SECUNDARIO"
        else:
            phase = "REVERSO"

        print(f"[{i:02d}/33] {rel['code']} | {phase:14s} | {rel['from']:25s} -> {rel['to']:25s}", end=" ")

        result = create_connector(rel)
        results.append(result)

        if result["status"] == "OK":
            print(f"  OK (id: {result['id']})")
            ok_count += 1
        elif result["status"] == "SKIP":
            print(f"  SKIP ({result['reason']})")
            skip_count += 1
        else:
            print(f"  ERROR {result['http']}: {result.get('error', '')[:60]}")
            error_count += 1

        # Rate limit delay (so para requests efetivos)
        if result["status"] == "OK":
            time.sleep(DELAY_SECONDS)

    # Resumo final
    print()
    print("=" * 70)
    print(f"  RESULTADO FINAL")
    print(f"  Criados:  {ok_count}")
    print(f"  Pulados:  {skip_count}")
    print(f"  Erros:    {error_count}")
    print("=" * 70)

    # Salvar log
    with open("connector_results.json", "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False)
    print("\nLog salvo em connector_results.json")

    if ok_count > 0:
        print(f"\nAbra o board: https://miro.com/app/board/uXjVGE__XFQ=/")
        print("Os conectores devem estar visiveis!")


if __name__ == "__main__":
    main()
```

---

## PARTE 4: Verificacao e Ajustes

### Passo 9: Verificar no Board

1. Abra https://miro.com/app/board/uXjVGE__XFQ=/
2. Navegue ate o frame **"Consumo e estoque"**
3. Verifique visualmente se os conectores estao corretos
4. Os conectores devem ter:
   - Crow's Foot notation nos terminais (|, ||, >, o|, o>)
   - Cores corretas por camada
   - Labels nos conectores externos
   - Espessuras corretas (grosso = critico, fino = secundario)

### Passo 10: Deletar Conectores (se precisar refazer)

Se algo saiu errado e voce quer apagar todos os conectores criados:

```bash
#!/bin/bash
# SCRIPT 4: Deletar conectores criados (usa o log de resultados)
# CUIDADO: isso apaga os conectores do board!

TOKEN="SEU_TOKEN_AQUI"
BOARD_ID="uXjVGE__XFQ%3D"

python3 -c "
import json
with open('connector_results.json') as f:
    results = json.load(f)
for r in results:
    if r['status'] == 'OK':
        print(r['id'])
" | while read CONNECTOR_ID; do
    echo "Deletando conector $CONNECTOR_ID..."
    curl -s -X DELETE \
      -H "Authorization: Bearer $TOKEN" \
      "https://api.miro.com/v2/boards/$BOARD_ID/connectors/$CONNECTOR_ID"
    sleep 0.3
done

echo "Conectores deletados."
```

### Passo 11: Listar Conectores Existentes

Para ver quais conectores ja existem no board:

```bash
curl -s -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  "https://api.miro.com/v2/boards/uXjVGE__XFQ%3D/connectors?limit=50" \
  | python3 -m json.tool
```

---

## RESUMO DO FLUXO COMPLETO

```
┌──────────────────────────────────────────────────────────────┐
│  PASSO 1-3: Criar app Miro + pegar token      (~10 min)     │
│  https://miro.com/app/settings/user-profile/apps             │
│  Scopes: boards:read + boards:write                          │
│  Token nao-expirante para uso pessoal                        │
├──────────────────────────────────────────────────────────────┤
│  PASSO 4: Testar token com curl                (~1 min)      │
│  curl -H "Authorization: Bearer TOKEN" .../boards/ID         │
├──────────────────────────────────────────────────────────────┤
│  PASSO 5-6: Listar items do board              (~5 min)      │
│  ./01_listar_items.sh                                        │
│  python3 02_filtrar_entidades.py                             │
├──────────────────────────────────────────────────────────────┤
│  PASSO 7: Preencher entity_map.json            (~10 min)     │
│  Mapear nome da entidade -> ID do Miro                       │
├──────────────────────────────────────────────────────────────┤
│  PASSO 8: Rodar o script de conectores         (~2 min)      │
│  python3 03_criar_conectores.py                              │
│  33 conectores criados automaticamente!                      │
├──────────────────────────────────────────────────────────────┤
│  PASSO 9-10: Verificar e ajustar no board      (~5 min)      │
│  Abrir Miro, revisar visualmente, ajustar se necessario      │
└──────────────────────────────────────────────────────────────┘

Tempo total estimado: ~35 minutos (primeira vez)
Tempo para refazer: ~5 minutos (so rodar script 3 de novo)
```

---

## REFERENCIA RAPIDA: Stroke Caps Miro para ER

| Cap Value | Visual | Significado ER |
|-----------|--------|----------------|
| `erd_only_one` | `\|\|` | Exatamente um (obrigatorio) |
| `erd_one` | `\|` | Um (generico) |
| `erd_many` | `>` | Muitos |
| `erd_one_or_many` | `\|>` | Um ou muitos (obrigatorio, crow's foot) |
| `erd_zero_or_one` | `o\|` | Zero ou um (opcional) |
| `erd_zero_or_many` | `o>` | Zero ou muitos (opcional, crow's foot) |
| `none` | ` ` | Sem terminal |

### Nosso Mapeamento:

| Cardinalidade Doc 17 | Start Cap | End Cap | Leitura |
|-----------------------|-----------|---------|---------|
| 1:N obrigatoria | `erd_only_one` | `erd_one_or_many` | "Exatamente um" -> "Um ou muitos" |
| 1:N opcional | `erd_only_one` | `erd_zero_or_many` | "Exatamente um" -> "Zero ou muitos" |
| 1:1 obrigatoria | `erd_only_one` | `erd_only_one` | "Exatamente um" -> "Exatamente um" |
| 1:1 condicional | `erd_only_one` | `erd_zero_or_one` | "Exatamente um" -> "Zero ou um" |
| N:1 obrigatoria | `erd_one_or_many` | `erd_only_one` | "Um ou muitos" -> "Exatamente um" |
| N:1 opcional | `erd_zero_or_many` | `erd_only_one` | "Zero ou muitos" -> "Exatamente um" |

---

## TROUBLESHOOTING

### Erro 401: Unauthorized
- Token invalido ou expirado
- Verifique se copiou o token completo (sem espacos extras)

### Erro 403: Forbidden
- Scopes insuficientes: precisa de `boards:read` E `boards:write`
- O app precisa estar instalado no time correto

### Erro 404: Not Found
- Board ID incorreto (lembre do encoding: `=` -> `%3D` em URLs)
- Item ID incorreto no entity_map.json

### Erro 429: Rate Limited
- Aumente o `DELAY_SECONDS` no script (tente 1.0 ou 2.0)

### Conector aparece mas sem Crow's Foot
- Verifique se os valores de `startStrokeCap` e `endStrokeCap` estao corretos
- Os caps `erd_*` so aparecem com zoom suficiente no Miro

### Conector conecta no lugar errado
- Use `snapTo` com valor especifico (`top`, `bottom`, `left`, `right`) em vez de `auto`
- Edite o connector body no script para a relacao especifica

---

*Documento gerado em 10/02/2026 - DeepWork AI Flows*
*Referencia: Doc 17 - RELACIONAMENTOS_CONSUMO_ESTOQUE.md*

**Sources:**
- [Miro: Create Connector API](https://developers.miro.com/reference/create-connector)
- [Miro: Work with Connectors](https://developers.miro.com/docs/work-with-connectors)
- [Miro: Get Items on Board](https://developers.miro.com/reference/get-items)
- [Miro: Connector Reference (Web SDK)](https://developers.miro.com/docs/websdk-reference-connector)
- [Miro: Getting Started with OAuth](https://developers.miro.com/docs/getting-started-with-oauth)
- [Miro: REST API Reference Guide](https://developers.miro.com/docs/rest-api-reference-guide)
