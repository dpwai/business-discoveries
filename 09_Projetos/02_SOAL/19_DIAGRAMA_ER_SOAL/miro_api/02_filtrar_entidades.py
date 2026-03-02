#!/usr/bin/env python3
"""
SCRIPT 2: Filter board items and identify entity shapes.
Matches shapes by text content to known entity names.
"""

import json
import os
import re

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))

# Load all items
with open(os.path.join(SCRIPT_DIR, "miro_all_items.json")) as f:
    all_items = json.load(f)

# Entities we need to find
ENTITIES_NEEDED = [
    "PRODUTO_INSUMO",
    "COMPRA_INSUMO",
    "ESTOQUE_INSUMO",
    "MOVIMENTACAO_INSUMO",
    "APLICACAO_INSUMO",
    "RECEITUARIO_AGRONOMICO",
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
    "PULVERIZACAO_DETALHE",
    "DRONE_DETALHE",
    "DIETA_INGREDIENTE",
]

def clean_html(text):
    if not text:
        return ""
    text = re.sub(r'<[^>]+>', ' ', text)
    text = re.sub(r'&[a-zA-Z]+;', ' ', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def normalize_name(text):
    text = text.upper().strip()
    text = re.sub(r'[^A-Z0-9_]', '_', text)
    text = re.sub(r'_+', '_', text)
    text = text.strip('_')
    return text

print("=" * 80)
print("  ENTITY FINDER - Matching shapes to entity names")
print("=" * 80)

shapes = []
for item in all_items:
    if item.get("type") in ("shape", "card"):
        content = ""
        data = item.get("data", {})
        content = data.get("content", "") or data.get("title", "") or data.get("plainText", "") or ""
        clean = clean_html(content)
        if clean:
            shapes.append({
                "id": item["id"],
                "type": item["type"],
                "content": clean,
                "content_norm": normalize_name(clean),
                "parent": item.get("parent", {}).get("id", ""),
                "position": item.get("position", {}),
            })

print(f"\nTotal shapes/cards with text: {len(shapes)}")

frames = {}
for item in all_items:
    if item.get("type") == "frame":
        data = item.get("data", {})
        title = data.get("title", "") or clean_html(data.get("content", ""))
        frames[item["id"]] = title

print(f"Frames found: {len(frames)}")
for fid, fname in frames.items():
    print(f"  Frame {fid}: {fname}")

print("\n" + "=" * 80)
print("  MATCHING RESULTS")
print("=" * 80)

entity_map = {}
unmatched = []

for entity_name in ENTITIES_NEEDED:
    found = []
    entity_norm = normalize_name(entity_name)

    for shape in shapes:
        content_norm = shape["content_norm"]

        if content_norm == entity_norm:
            found.append({"shape": shape, "match": "EXACT"})
            continue
        if content_norm.startswith(entity_norm):
            found.append({"shape": shape, "match": "STARTS_WITH"})
            continue
        if entity_norm in content_norm:
            found.append({"shape": shape, "match": "CONTAINS"})
            continue
        entity_words = entity_name.split("_")
        content_upper = shape["content"].upper()
        if all(word in content_upper for word in entity_words):
            found.append({"shape": shape, "match": "WORDS"})

    if found:
        priority = {"EXACT": 0, "STARTS_WITH": 1, "CONTAINS": 2, "WORDS": 3}
        found.sort(key=lambda x: priority[x["match"]])
        best = found[0]
        entity_map[entity_name] = best["shape"]["id"]
        frame_name = frames.get(best["shape"]["parent"], "no frame")
        print(f"  {entity_name:30s} -> ID: {best['shape']['id']:20s} [{best['match']:10s}] (frame: {frame_name})")
        if len(found) > 1:
            print(f"    WARNING: {len(found)} matches found. Using best match.")
            for alt in found[1:]:
                print(f"      alt: {alt['shape']['id']} [{alt['match']}] content: {alt['shape']['content'][:50]}")
    else:
        unmatched.append(entity_name)
        print(f"  {entity_name:30s} -> NOT FOUND")

print("\n" + "=" * 80)
print(f"  SUMMARY: {len(entity_map)} matched, {len(unmatched)} not found")
print("=" * 80)

if unmatched:
    print("\nNot found (connectors to these will be skipped):")
    for name in unmatched:
        print(f"  - {name}")

map_path = os.path.join(SCRIPT_DIR, "entity_map.json")
with open(map_path, "w") as f:
    json.dump(entity_map, f, indent=4, ensure_ascii=False)

print(f"\nEntity map saved to: {map_path}")
print(f"Total mapped: {len(entity_map)}/{len(ENTITIES_NEEDED)}")

print("\n" + "=" * 80)
print("  ALL SHAPES (for manual review if entities were missed)")
print("=" * 80)
matched_ids = set(entity_map.values())
for shape in sorted(shapes, key=lambda x: x.get("parent", "")):
    marker = " *" if shape["id"] in matched_ids else "  "
    frame_name = frames.get(shape["parent"], "?")
    print(f"{marker} ID: {shape['id']:20s} | Frame: {frame_name:30s} | {shape['content'][:60]}")
