#!/usr/bin/env python3
"""
=============================================================================
SOAL ER V0 - Full Board Builder
=============================================================================
Creates ALL ~90 entities + ALL connectors on a clean Miro board.
Source: soal-er-board-context.agent.md + Doc 17

Entities are created as shapes, grouped into 7 layer frames.
Connectors use native ERD Crow's Foot notation.
=============================================================================
"""

import json
import os
import requests
import time
import sys

# ─────────────────────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────────────────────

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

def load_env():
    env = {}
    with open(os.path.join(SCRIPT_DIR, ".env")) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, val = line.split("=", 1)
                env[key.strip()] = val.strip()
    return env

config = load_env()
TOKEN = config["MIRO_TOKEN"]
BOARD_ID = "uXjVGCOBuw4="  # New board: SOAL_ER_V0

API_BASE = f"https://api.miro.com/v2/boards/{BOARD_ID}"
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
    "Accept": "application/json",
}

DELAY = 0.35  # seconds between API calls (rate limit safety)

# ─────────────────────────────────────────────────────────────
# LAYER DEFINITIONS (colors + Y positions)
# ─────────────────────────────────────────────────────────────

LAYERS = {
    "sistema":        {"color": "#4169E1", "fill": "#c6dcff", "y": 0,     "label": "CAMADA SISTEMA"},
    "territorial":    {"color": "#2E8B57", "fill": "#dbfaad", "y": 3500,  "label": "CAMADA TERRITORIAL"},
    "agricola":       {"color": "#DAA520", "fill": "#fff6b6", "y": 7500,  "label": "CAMADA AGRICOLA"},
    "operacional":    {"color": "#008B8B", "fill": "#ccf4ff", "y": 14000, "label": "CAMADA OPERACIONAL"},
    "financeiro":     {"color": "#FF8C00", "fill": "#f8d3af", "y": 18000, "label": "CAMADA FINANCEIRO"},
    "pecuaria":       {"color": "#2E8B57", "fill": "#adf0c7", "y": 23000, "label": "CAMADA PECUARIA"},
    "infraestrutura": {"color": "#696969", "fill": "#e7e7e7", "y": 32000, "label": "CAMADA INFRAESTRUTURA"},
}

# Entity box dimensions
BOX_W = 340
BOX_H = 200
GAP_X = 420
GAP_Y = 280

# ─────────────────────────────────────────────────────────────
# ALL ENTITIES (~90) grouped by layer and sub-group
# Each entity: (name, sub_group, col, row) where col/row = grid position within layer
# ─────────────────────────────────────────────────────────────

ENTITIES = {
    # ═══════════════════════════════════════════════════════════
    # CAMADA SISTEMA (11 entities)
    # ═══════════════════════════════════════════════════════════
    "sistema": [
        # Core auth
        ("ADMINS",               "Auth",    0, 0),
        ("OWNERS",               "Auth",    1, 0),
        ("ORGANIZATIONS",        "Auth",    2, 0),
        ("ORGANIZATION_SETTINGS","Auth",    3, 0),
        ("USERS",                "Auth",    4, 0),
        # RBAC
        ("ROLES",                "RBAC",    0, 1),
        ("PERMISSIONS",          "RBAC",    1, 1),
        ("USER_ROLES",           "RBAC",    2, 1),
        ("ROLE_PERMISSIONS",     "RBAC",    3, 1),
        ("USER_PERMISSIONS",     "RBAC",    4, 1),
        ("INVITE_TOKENS",        "RBAC",    5, 1),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA TERRITORIAL (8 entities)
    # ═══════════════════════════════════════════════════════════
    "territorial": [
        ("FAZENDAS",             "Geo",     0, 0),
        ("TALHOES",              "Geo",     1, 0),
        ("SILOS",                "Geo",     2, 0),
        ("SAFRAS",               "Tempo",   0, 1),
        ("CULTURAS",             "Tempo",   1, 1),
        ("TALHAO_SAFRA",         "Tempo",   2, 1),
        ("PARCEIRO_COMERCIAL",   "Parceiro",3, 0),
        ("CONTRATO_ARRENDAMENTO","Parceiro",3, 1),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA AGRICOLA (22 entities)
    # Split into sub-groups: Producao, Insumos, Solo, UBG
    # ═══════════════════════════════════════════════════════════
    "agricola": [
        # Producao (campo)
        ("OPERACAO_CAMPO",       "Producao",0, 0),
        ("PLANTIO",              "Producao",1, 0),
        ("COLHEITA",             "Producao",2, 0),
        ("PLANTIO_DETALHE",      "Producao",1, 1),
        ("COLHEITA_DETALHE",     "Producao",2, 1),
        ("PULVERIZACAO_DETALHE", "Producao",3, 0),
        ("DRONE_DETALHE",        "Producao",3, 1),
        # Solo
        ("ANALISE_SOLO",         "Solo",    4, 0),
        ("RECOMENDACAO_ADUBACAO","Solo",    4, 1),
        # Consumo e Estoque
        ("PRODUTO_INSUMO",       "Insumos", 0, 2),
        ("COMPRA_INSUMO",        "Insumos", 1, 2),
        ("ESTOQUE_INSUMO",       "Insumos", 2, 2),
        ("MOVIMENTACAO_INSUMO",  "Insumos", 3, 2),
        ("APLICACAO_INSUMO",     "Insumos", 1, 3),
        ("RECEITUARIO_AGRONOMICO","Insumos",2, 3),
        # UBG (Pos-colheita)
        ("TICKET_BALANCA",       "UBG",     5, 0),
        ("ENTRADA_GRAO",         "UBG",     6, 0),
        ("CLASSIFICACAO_GRAO",   "UBG",     7, 0),
        ("ESTOQUE_SILO",         "UBG",     5, 1),
        ("MOVIMENTACAO_SILO",    "UBG",     6, 1),
        ("SAIDA_GRAO",           "UBG",     7, 1),
        # Forms
        ("CUSTOM_FORMS",         "Forms",   0, 4),
        ("FORM_ENTRIES",         "Forms",   1, 4),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA OPERACIONAL (7 entities)
    # ═══════════════════════════════════════════════════════════
    "operacional": [
        ("MAQUINAS",             "Maquinas",0, 0),
        ("OPERADORES",           "Maquinas",1, 0),
        ("ABASTECIMENTOS",       "Maquinas",2, 0),
        ("MANUTENCOES",          "Maquinas",3, 0),
        # RH
        ("TRABALHADOR_RURAL",    "RH",      0, 1),
        ("APONTAMENTO_MAO_OBRA", "RH",      1, 1),
        # Operational operations (links to OPERACAO_CAMPO in Agricola)
        ("OPERACOES_MAQUINA",    "Maquinas",4, 0),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA FINANCEIRO (11 entities)
    # ═══════════════════════════════════════════════════════════
    "financeiro": [
        ("NOTA_FISCAL",          "NF",      0, 0),
        ("NOTA_FISCAL_ITEM",     "NF",      1, 0),
        ("CONTA_PAGAR",          "Contas",  0, 1),
        ("CONTA_RECEBER",        "Contas",  1, 1),
        ("CENTRO_CUSTO",         "Custeio", 2, 0),
        ("CUSTO_OPERACAO",       "Custeio", 3, 0),
        ("CONTRATO_COMERCIAL",   "Contratos",2, 1),
        ("CONTRATO_ENTREGA",     "Contratos",3, 1),
        ("CPR_DOCUMENTO",        "Contratos",4, 1),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA PECUARIA (23 entities)
    # ═══════════════════════════════════════════════════════════
    "pecuaria": [
        # Cadastro
        ("RACA",                 "Cadastro",0, 0),
        ("ANIMAL",               "Cadastro",1, 0),
        ("LOTE_ANIMAL",          "Cadastro",2, 0),
        ("PESAGEM",              "Cadastro",3, 0),
        # Pasto
        ("PASTO",                "Pasto",   0, 1),
        ("PASTO_AVALIACAO",      "Pasto",   1, 1),
        ("MOVIMENTACAO_PASTO",   "Pasto",   2, 1),
        # Nutricao
        ("DIETA",                "Nutricao",0, 2),
        ("DIETA_INGREDIENTE",    "Nutricao",1, 2),
        ("TRATO_ALIMENTAR",      "Nutricao",2, 2),
        ("COCHO",                "Nutricao",3, 2),
        # Manejo
        ("CALENDARIO_SANITARIO", "Manejo",  4, 0),
        ("MANEJO_SANITARIO",     "Manejo",  5, 0),
        ("OCORRENCIA_SANITARIA", "Manejo",  4, 1),
        # Reproducao
        ("ESTACAO_MONTA",        "Reprod",  0, 3),
        ("PROTOCOLO_IATF",       "Reprod",  1, 3),
        ("COBERTURA",            "Reprod",  2, 3),
        ("DIAGNOSTICO_GESTACAO", "Reprod",  3, 3),
        ("PARTO",                "Reprod",  4, 3),
        # Comercial
        ("GTA",                  "Comercial",5, 1),
        ("GTA_ANIMAL",           "Comercial",5, 2),
        ("VENDA_ANIMAL",         "Comercial",5, 3),
        ("COMPRA_ANIMAL",        "Comercial",4, 2),
    ],

    # ═══════════════════════════════════════════════════════════
    # CAMADA INFRAESTRUTURA (5 entity groups)
    # ═══════════════════════════════════════════════════════════
    "infraestrutura": [
        ("INTEGRACOES",          "Infra",   0, 0),
        ("ALERTAS",              "Infra",   1, 0),
        ("AUDIT_LOG",            "Infra",   2, 0),
        ("NOTIFICACOES",         "Infra",   3, 0),
        ("CONFIGURACOES_SISTEMA","Infra",   4, 0),
    ],
}


# ─────────────────────────────────────────────────────────────
# RELATIONSHIPS - ALL known connections
# ─────────────────────────────────────────────────────────────
# Format: (from, to, cardinality, style, color, width, label)
# cardinality: "1:N", "N:1", "1:1", "N:N"
# style: "normal" (solid), "dashed"

RELATIONSHIPS = [
    # ─── SISTEMA internal ───
    ("OWNERS", "ORGANIZATIONS", "1:N", "normal", "#4169E1", 2, ""),
    ("ORGANIZATIONS", "USERS", "1:N", "normal", "#4169E1", 2, ""),
    ("ORGANIZATIONS", "ORGANIZATION_SETTINGS", "1:1", "normal", "#4169E1", 1, ""),
    ("USERS", "USER_ROLES", "1:N", "normal", "#4169E1", 1, ""),
    ("ROLES", "USER_ROLES", "1:N", "normal", "#4169E1", 1, ""),
    ("ROLES", "ROLE_PERMISSIONS", "1:N", "normal", "#4169E1", 1, ""),
    ("PERMISSIONS", "ROLE_PERMISSIONS", "1:N", "normal", "#4169E1", 1, ""),
    ("PERMISSIONS", "USER_PERMISSIONS", "1:N", "normal", "#4169E1", 1, ""),
    ("USERS", "USER_PERMISSIONS", "1:N", "normal", "#4169E1", 1, ""),
    ("ORGANIZATIONS", "INVITE_TOKENS", "1:N", "normal", "#4169E1", 1, ""),

    # ─── TERRITORIAL internal ───
    ("FAZENDAS", "TALHOES", "1:N", "normal", "#2E8B57", 2, ""),
    ("FAZENDAS", "SILOS", "1:N", "normal", "#2E8B57", 2, ""),
    ("TALHOES", "TALHAO_SAFRA", "1:N", "normal", "#2E8B57", 2, ""),
    ("SAFRAS", "TALHAO_SAFRA", "1:N", "normal", "#2E8B57", 2, ""),
    ("CULTURAS", "TALHAO_SAFRA", "1:N", "normal", "#2E8B57", 2, ""),
    ("PARCEIRO_COMERCIAL", "CONTRATO_ARRENDAMENTO", "1:N", "normal", "#2E8B57", 1, ""),
    ("TALHOES", "CONTRATO_ARRENDAMENTO", "1:N", "normal", "#2E8B57", 1, ""),

    # ─── SISTEMA -> TERRITORIAL ───
    ("ORGANIZATIONS", "FAZENDAS", "1:N", "dashed", "#4169E1", 2, "org"),
    ("ORGANIZATIONS", "PARCEIRO_COMERCIAL", "1:N", "dashed", "#4169E1", 1, "org"),
    ("ORGANIZATIONS", "SAFRAS", "1:N", "dashed", "#4169E1", 1, "org"),
    ("ORGANIZATIONS", "CULTURAS", "1:N", "dashed", "#4169E1", 1, "org"),

    # ─── AGRICOLA - Producao internal ───
    ("OPERACAO_CAMPO", "PLANTIO_DETALHE", "1:1", "normal", "#DAA520", 2, ""),
    ("OPERACAO_CAMPO", "COLHEITA_DETALHE", "1:1", "normal", "#DAA520", 2, ""),
    ("OPERACAO_CAMPO", "PULVERIZACAO_DETALHE", "1:1", "normal", "#DAA520", 2, ""),
    ("OPERACAO_CAMPO", "DRONE_DETALHE", "1:1", "normal", "#DAA520", 2, ""),
    ("ANALISE_SOLO", "RECOMENDACAO_ADUBACAO", "1:N", "normal", "#DAA520", 1, ""),

    # ─── AGRICOLA - Consumo e Estoque (Doc 17 R01-R10) ───
    ("PRODUTO_INSUMO", "COMPRA_INSUMO", "1:N", "normal", "#DAA520", 3, ""),
    ("PRODUTO_INSUMO", "ESTOQUE_INSUMO", "1:N", "normal", "#DAA520", 2, ""),
    ("PRODUTO_INSUMO", "APLICACAO_INSUMO", "1:N", "normal", "#DAA520", 2, ""),
    ("PRODUTO_INSUMO", "RECEITUARIO_AGRONOMICO", "1:N", "normal", "#DAA520", 2, ""),
    ("COMPRA_INSUMO", "MOVIMENTACAO_INSUMO", "1:1", "normal", "#DAA520", 3, ""),
    ("ESTOQUE_INSUMO", "MOVIMENTACAO_INSUMO", "1:N", "normal", "#DAA520", 3, ""),
    ("APLICACAO_INSUMO", "MOVIMENTACAO_INSUMO", "1:1", "normal", "#DAA520", 3, ""),
    ("ESTOQUE_INSUMO", "APLICACAO_INSUMO", "1:N", "normal", "#DAA520", 2, ""),
    ("RECEITUARIO_AGRONOMICO", "APLICACAO_INSUMO", "1:N", "normal", "#DAA520", 2, ""),

    # ─── AGRICOLA - UBG internal ───
    ("TICKET_BALANCA", "ENTRADA_GRAO", "1:1", "normal", "#DAA520", 2, ""),
    ("ENTRADA_GRAO", "CLASSIFICACAO_GRAO", "1:1", "normal", "#DAA520", 2, ""),
    ("ESTOQUE_SILO", "MOVIMENTACAO_SILO", "1:N", "normal", "#DAA520", 2, ""),
    ("CUSTOM_FORMS", "FORM_ENTRIES", "1:N", "normal", "#DAA520", 1, ""),

    # ─── TERRITORIAL -> AGRICOLA ───
    ("TALHAO_SAFRA", "OPERACAO_CAMPO", "1:N", "dashed", "#2E8B57", 2, "talhao_safra"),
    ("TALHAO_SAFRA", "PLANTIO", "1:N", "dashed", "#2E8B57", 2, ""),
    ("TALHAO_SAFRA", "COLHEITA", "1:N", "dashed", "#2E8B57", 2, ""),
    ("TALHAO_SAFRA", "ANALISE_SOLO", "1:N", "dashed", "#2E8B57", 1, ""),
    ("CULTURAS", "RECEITUARIO_AGRONOMICO", "1:N", "dashed", "#2E8B57", 2, "cultura"),
    ("SILOS", "ESTOQUE_SILO", "1:N", "dashed", "#2E8B57", 2, "silo"),
    ("FAZENDAS", "ESTOQUE_INSUMO", "1:N", "dashed", "#2E8B57", 2, "onde esta"),

    # ─── AGRICOLA cross-links ───
    ("OPERACAO_CAMPO", "APLICACAO_INSUMO", "1:N", "normal", "#DAA520", 3, "operacao"),
    ("COLHEITA", "ENTRADA_GRAO", "1:N", "normal", "#DAA520", 2, ""),
    ("PULVERIZACAO_DETALHE", "PRODUTO_INSUMO", "N:1", "normal", "#DAA520", 1, ""),
    ("DRONE_DETALHE", "PRODUTO_INSUMO", "N:1", "normal", "#DAA520", 1, ""),

    # ─── Doc 17 External relationships (R11-R28) ───
    ("PRODUTO_INSUMO", "ORGANIZATIONS", "N:1", "dashed", "#4169E1", 1, "org"),
    ("COMPRA_INSUMO", "ORGANIZATIONS", "N:1", "dashed", "#4169E1", 1, "org"),
    ("ESTOQUE_INSUMO", "ORGANIZATIONS", "N:1", "dashed", "#4169E1", 1, "org"),
    ("APLICACAO_INSUMO", "ORGANIZATIONS", "N:1", "dashed", "#4169E1", 1, "org"),
    ("RECEITUARIO_AGRONOMICO", "ORGANIZATIONS", "N:1", "dashed", "#4169E1", 1, "org"),
    ("COMPRA_INSUMO", "NOTA_FISCAL_ITEM", "N:1", "dashed", "#FF8C00", 2, "NF"),
    ("COMPRA_INSUMO", "PARCEIRO_COMERCIAL", "N:1", "dashed", "#2E8B57", 2, "fornecedor"),
    ("COMPRA_INSUMO", "SAFRAS", "N:1", "dashed", "#2E8B57", 2, "safra"),
    ("COMPRA_INSUMO", "CULTURAS", "N:1", "dashed", "#2E8B57", 1, "cultura destino"),
    ("COMPRA_INSUMO", "CONTRATO_COMERCIAL", "N:1", "dashed", "#FF8C00", 1, "barter"),
    ("APLICACAO_INSUMO", "TALHAO_SAFRA", "N:1", "dashed", "#2E8B57", 2, "onde aplicou"),
    ("APLICACAO_INSUMO", "MANEJO_SANITARIO", "N:1", "dashed", "#2E8B57", 1, "manejo"),
    ("APLICACAO_INSUMO", "MANUTENCOES", "N:1", "dashed", "#008B8B", 1, "manutencao"),
    ("APLICACAO_INSUMO", "CUSTO_OPERACAO", "1:1", "dashed", "#FF8C00", 3, "gera custo"),
    ("MOVIMENTACAO_INSUMO", "USERS", "N:1", "dashed", "#4169E1", 1, "quem"),

    # ─── OPERACIONAL internal ───
    ("MAQUINAS", "ABASTECIMENTOS", "1:N", "normal", "#008B8B", 2, ""),
    ("MAQUINAS", "MANUTENCOES", "1:N", "normal", "#008B8B", 2, ""),
    ("MAQUINAS", "OPERACOES_MAQUINA", "1:N", "normal", "#008B8B", 2, ""),
    ("OPERADORES", "OPERACOES_MAQUINA", "1:N", "normal", "#008B8B", 1, ""),
    ("TRABALHADOR_RURAL", "APONTAMENTO_MAO_OBRA", "1:N", "normal", "#008B8B", 2, ""),

    # ─── OPERACIONAL -> other layers ───
    ("ORGANIZATIONS", "MAQUINAS", "1:N", "dashed", "#4169E1", 1, "org"),
    ("ORGANIZATIONS", "TRABALHADOR_RURAL", "1:N", "dashed", "#4169E1", 1, "org"),
    ("APONTAMENTO_MAO_OBRA", "CENTRO_CUSTO", "N:1", "dashed", "#FF8C00", 1, "custo"),
    ("OPERACOES_MAQUINA", "OPERACAO_CAMPO", "N:1", "dashed", "#DAA520", 2, "operacao campo"),

    # ─── FINANCEIRO internal ───
    ("NOTA_FISCAL", "NOTA_FISCAL_ITEM", "1:N", "normal", "#FF8C00", 2, ""),
    ("NOTA_FISCAL", "CONTA_PAGAR", "1:N", "normal", "#FF8C00", 2, ""),
    ("NOTA_FISCAL", "CONTA_RECEBER", "1:N", "normal", "#FF8C00", 2, ""),
    ("CENTRO_CUSTO", "CUSTO_OPERACAO", "1:N", "normal", "#FF8C00", 2, ""),
    ("CONTRATO_COMERCIAL", "CONTRATO_ENTREGA", "1:N", "normal", "#FF8C00", 2, ""),
    ("CONTRATO_COMERCIAL", "CPR_DOCUMENTO", "1:1", "normal", "#FF8C00", 1, ""),
    ("CONTRATO_COMERCIAL", "CONTA_RECEBER", "1:N", "normal", "#FF8C00", 1, ""),

    # ─── FINANCEIRO -> other layers ───
    ("ORGANIZATIONS", "NOTA_FISCAL", "1:N", "dashed", "#4169E1", 1, "org"),
    ("ORGANIZATIONS", "CENTRO_CUSTO", "1:N", "dashed", "#4169E1", 1, "org"),
    ("PARCEIRO_COMERCIAL", "CONTRATO_COMERCIAL", "1:N", "dashed", "#2E8B57", 2, "parceiro"),
    ("PARCEIRO_COMERCIAL", "NOTA_FISCAL", "1:N", "dashed", "#2E8B57", 1, "parceiro"),
    ("NOTA_FISCAL_ITEM", "PRODUTO_INSUMO", "N:1", "dashed", "#FF8C00", 1, ""),
    ("CONTRATO_COMERCIAL", "PRODUTO_INSUMO", "N:1", "dashed", "#FF8C00", 1, "barter insumo"),
    ("SAIDA_GRAO", "CONTRATO_COMERCIAL", "N:1", "dashed", "#FF8C00", 1, "contrato"),

    # ─── PECUARIA internal ───
    ("RACA", "ANIMAL", "1:N", "normal", "#2E8B57", 2, ""),
    ("ANIMAL", "LOTE_ANIMAL", "N:1", "normal", "#2E8B57", 2, ""),
    ("ANIMAL", "PESAGEM", "1:N", "normal", "#2E8B57", 2, ""),
    ("LOTE_ANIMAL", "PASTO", "N:1", "normal", "#2E8B57", 2, ""),
    ("PASTO", "PASTO_AVALIACAO", "1:N", "normal", "#2E8B57", 1, ""),
    ("LOTE_ANIMAL", "MOVIMENTACAO_PASTO", "1:N", "normal", "#2E8B57", 1, ""),
    ("PASTO", "MOVIMENTACAO_PASTO", "1:N", "normal", "#2E8B57", 1, ""),
    ("LOTE_ANIMAL", "DIETA", "N:1", "normal", "#2E8B57", 2, ""),
    ("DIETA", "DIETA_INGREDIENTE", "1:N", "normal", "#2E8B57", 2, ""),
    ("LOTE_ANIMAL", "TRATO_ALIMENTAR", "1:N", "normal", "#2E8B57", 1, ""),
    ("DIETA", "TRATO_ALIMENTAR", "1:N", "normal", "#2E8B57", 1, ""),
    ("ANIMAL", "MANEJO_SANITARIO", "1:N", "normal", "#2E8B57", 2, ""),
    ("CALENDARIO_SANITARIO", "MANEJO_SANITARIO", "1:N", "normal", "#2E8B57", 1, ""),
    ("ANIMAL", "OCORRENCIA_SANITARIA", "1:N", "normal", "#2E8B57", 1, ""),
    ("ESTACAO_MONTA", "PROTOCOLO_IATF", "1:N", "normal", "#2E8B57", 1, ""),
    ("ESTACAO_MONTA", "COBERTURA", "1:N", "normal", "#2E8B57", 2, ""),
    ("ANIMAL", "COBERTURA", "1:N", "normal", "#2E8B57", 1, ""),
    ("COBERTURA", "DIAGNOSTICO_GESTACAO", "1:1", "normal", "#2E8B57", 1, ""),
    ("DIAGNOSTICO_GESTACAO", "PARTO", "1:1", "normal", "#2E8B57", 1, ""),
    ("ANIMAL", "GTA", "1:N", "normal", "#2E8B57", 1, ""),
    ("GTA", "GTA_ANIMAL", "1:N", "normal", "#2E8B57", 1, ""),
    ("ANIMAL", "VENDA_ANIMAL", "1:N", "normal", "#2E8B57", 1, ""),
    ("ANIMAL", "COMPRA_ANIMAL", "1:1", "normal", "#2E8B57", 1, ""),
    ("DIETA_INGREDIENTE", "PRODUTO_INSUMO", "N:1", "dashed", "#DAA520", 1, ""),

    # ─── PECUARIA -> other layers ───
    ("ORGANIZATIONS", "ANIMAL", "1:N", "dashed", "#4169E1", 1, "org"),
    ("FAZENDAS", "PASTO", "1:N", "dashed", "#2E8B57", 1, "fazenda"),
    ("VENDA_ANIMAL", "NOTA_FISCAL", "N:1", "dashed", "#FF8C00", 1, "NF venda"),
    ("GTA", "NOTA_FISCAL", "N:1", "dashed", "#FF8C00", 1, "NF transporte"),
    ("MANEJO_SANITARIO", "APLICACAO_INSUMO", "1:N", "dashed", "#DAA520", 1, "insumo usado"),
]


# ─────────────────────────────────────────────────────────────
# CARDINALITY -> ERD STROKE CAPS
# ─────────────────────────────────────────────────────────────

CARD_MAP = {
    "1:N": ("erd_only_one", "erd_one_or_many"),
    "N:1": ("erd_one_or_many", "erd_only_one"),
    "1:1": ("erd_only_one", "erd_only_one"),
    "N:N": ("erd_one_or_many", "erd_one_or_many"),
}


# ─────────────────────────────────────────────────────────────
# API HELPERS
# ─────────────────────────────────────────────────────────────

created_count = 0

def api_post(endpoint, body):
    global created_count
    resp = requests.post(f"{API_BASE}/{endpoint}", headers=HEADERS, json=body)
    created_count += 1
    time.sleep(DELAY)
    return resp

def create_frame(title, x, y, w, h, color):
    body = {
        "data": {"title": title, "type": "freeform"},
        "position": {"x": x, "y": y},
        "geometry": {"width": w, "height": h},
        "style": {"fillColor": color},
    }
    resp = api_post("frames", body)
    if resp.status_code in (200, 201):
        return resp.json()["id"]
    else:
        print(f"  FRAME ERROR: {resp.status_code} {resp.text[:100]}")
        return None

def create_shape(name, x, y, parent_id, border_color, fill_color):
    body = {
        "data": {
            "content": f"<p><strong>{name}</strong></p>",
            "shape": "round_rectangle",
        },
        "position": {"x": x, "y": y},
        "geometry": {"width": BOX_W, "height": BOX_H},
        "style": {
            "borderColor": border_color,
            "borderWidth": "2",
            "fillColor": fill_color,
            "fontFamily": "open_sans",
            "fontSize": "14",
            "textAlign": "center",
            "textAlignVertical": "middle",
        },
    }
    if parent_id:
        body["parent"] = {"id": parent_id}

    resp = api_post("shapes", body)
    if resp.status_code in (200, 201):
        return resp.json()["id"]
    else:
        print(f"  SHAPE ERROR {name}: {resp.status_code} {resp.text[:150]}")
        return None

def create_connector(start_id, end_id, card, style, color, width, label):
    start_cap, end_cap = CARD_MAP.get(card, ("none", "none"))

    body = {
        "startItem": {"id": start_id, "snapTo": "auto"},
        "endItem": {"id": end_id, "snapTo": "auto"},
        "shape": "elbowed",
        "style": {
            "strokeColor": color,
            "strokeWidth": str(width),
            "strokeStyle": style,
            "startStrokeCap": start_cap,
            "endStrokeCap": end_cap,
        },
    }
    if label:
        body["captions"] = [{"content": label, "position": "50%"}]

    resp = api_post("connectors", body)
    if resp.status_code in (200, 201):
        return resp.json()["id"]
    else:
        print(f"  CONNECTOR ERROR: {resp.status_code} {resp.text[:150]}")
        return None


# ─────────────────────────────────────────────────────────────
# MAIN EXECUTION
# ─────────────────────────────────────────────────────────────

def main():
    print("=" * 70)
    print("  SOAL ER V0 - Full Board Builder")
    print("  Board: SOAL_ER_V0")
    print("=" * 70)

    entity_ids = {}  # name -> miro_id
    frame_ids = {}   # layer_name -> miro_id

    # ─── PHASE 1: Create layer frames ───
    print("\n--- PHASE 1: Creating layer frames ---")
    total_entities = sum(len(ents) for ents in ENTITIES.values())
    print(f"Total entities to create: {total_entities}")

    for layer_name, layer_cfg in LAYERS.items():
        ents = ENTITIES.get(layer_name, [])
        if not ents:
            continue

        max_col = max(e[2] for e in ents) + 1
        max_row = max(e[3] for e in ents) + 1
        frame_w = max_col * GAP_X + 200
        frame_h = max_row * GAP_Y + 200

        frame_id = create_frame(
            layer_cfg["label"],
            x=0,
            y=layer_cfg["y"],
            w=frame_w,
            h=frame_h,
            color=layer_cfg["fill"],
        )
        frame_ids[layer_name] = frame_id
        print(f"  Frame: {layer_cfg['label']} (ID: {frame_id}) - {len(ents)} entities")

    # ─── PHASE 2: Create entity shapes ───
    print("\n--- PHASE 2: Creating entity shapes ---")

    for layer_name, ents in ENTITIES.items():
        layer_cfg = LAYERS[layer_name]
        frame_id = frame_ids.get(layer_name)

        for (name, sub, col, row) in ents:
            x = 100 + col * GAP_X + BOX_W // 2
            y = 100 + row * GAP_Y + BOX_H // 2

            shape_id = create_shape(
                name, x, y,
                parent_id=frame_id,
                border_color=layer_cfg["color"],
                fill_color=layer_cfg["fill"],
            )

            if shape_id:
                entity_ids[name] = shape_id
                print(f"  {name:30s} -> {shape_id}")
            else:
                print(f"  {name:30s} -> FAILED")

    print(f"\nEntities created: {len(entity_ids)}/{total_entities}")

    # Save entity map for reference
    map_path = os.path.join(SCRIPT_DIR, "entity_map_v0.json")
    with open(map_path, "w") as f:
        json.dump(entity_ids, f, indent=2)
    print(f"Entity map saved: {map_path}")

    # ─── PHASE 3: Create connectors ───
    print(f"\n--- PHASE 3: Creating {len(RELATIONSHIPS)} connectors ---")

    ok = 0
    skip = 0
    err = 0
    connector_ids = []

    for i, (frm, to, card, style, color, width, label) in enumerate(RELATIONSHIPS, 1):
        frm_id = entity_ids.get(frm)
        to_id = entity_ids.get(to)

        if not frm_id or not to_id:
            missing = []
            if not frm_id: missing.append(frm)
            if not to_id: missing.append(to)
            print(f"  [{i:03d}] SKIP {frm} -> {to} (missing: {', '.join(missing)})")
            skip += 1
            continue

        cid = create_connector(frm_id, to_id, card, style, color, width, label)
        if cid:
            connector_ids.append(cid)
            ok += 1
            lbl = f' "{label}"' if label else ""
            print(f"  [{i:03d}] OK   {frm:30s} -> {to:30s} {card}{lbl}")
        else:
            err += 1

    # Save connector IDs
    conn_path = os.path.join(SCRIPT_DIR, "connector_ids_v0.json")
    with open(conn_path, "w") as f:
        json.dump(connector_ids, f, indent=2)

    # ─── SUMMARY ───
    print("\n" + "=" * 70)
    print(f"  DONE!")
    print(f"  Entities: {len(entity_ids)}")
    print(f"  Connectors: {ok} OK / {skip} skipped / {err} errors")
    print(f"  Total API calls: {created_count}")
    print(f"  Board: https://miro.com/app/board/{BOARD_ID}/")
    print("=" * 70)


if __name__ == "__main__":
    main()
