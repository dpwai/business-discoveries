#!/usr/bin/env python3
import json, re, urllib.request

token = 'eyJtaXJvLm9yaWdpbiI6ImV1MDEifQ_jHHgzC0B0GtZA2ojyPPYKVpPaNo'
board = 'uXjVGE__XFQ%3D'

def fetch(url):
    req = urllib.request.Request(url, headers={'Authorization': 'Bearer ' + token})
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())

# 1. Get all frames to find Financeiro + Contratos
frames = fetch(f'https://api.miro.com/v2/boards/{board}/items?limit=50&type=frame')
print("=== ALL FRAMES ===")
fin_ids = []
for f in frames['data']:
    title = f.get('data', {}).get('title', '?')
    fid = f['id']
    x = int(f.get('position', {}).get('x', 0))
    y = int(f.get('position', {}).get('y', 0))
    w = int(f.get('geometry', {}).get('width', 0))
    h = int(f.get('geometry', {}).get('height', 0))
    print(f'  {title} | id: {fid} | pos: ({x},{y}) | size: {w}x{h}')
    if 'financeiro' in title.lower() or 'contrato' in title.lower():
        fin_ids.append((fid, title, x, y, w, h))

# 2. For each financeiro-related frame, get child items
for fid, title, fx, fy, fw, fh in fin_ids:
    children = fetch(f'https://api.miro.com/v2/boards/{board}/items?limit=50&parent_item_id={fid}')
    print(f'\n=== ITEMS IN "{title}" (id: {fid}) ===')
    shape_ids = []
    for item in children['data']:
        itype = item['type']
        iid = item['id']
        supported = item.get('isSupported', True)
        x = int(item.get('position', {}).get('x', 0))
        y = int(item.get('position', {}).get('y', 0))
        content = ''
        if itype == 'text':
            raw = item.get('data', {}).get('content', '')
            content = re.sub(r'<[^>]+>', ' ', raw).strip()
        elif itype == 'sticky_note':
            raw = item.get('data', {}).get('content', '')
            content = re.sub(r'<[^>]+>', ' ', raw).strip()
        elif itype == 'shape':
            raw = item.get('data', {}).get('content', '')
            content = re.sub(r'<[^>]+>', ' ', raw).strip() if raw else '(unsupported shape)'
            shape_ids.append(iid)
        print(f'  {itype} | id: {iid} | pos: ({x},{y}) | supported: {supported} | {content[:120]}')

    # 3. Fetch connectors touching these shapes
    if shape_ids:
        # Fetch ALL connectors (paginated)
        all_connectors = []
        cursor = ''
        while True:
            url = f'https://api.miro.com/v2/boards/{board}/connectors?limit=50'
            if cursor:
                url += f'&cursor={cursor}'
            cdata = fetch(url)
            all_connectors.extend(cdata.get('data', []))
            cursor = cdata.get('cursor', '')
            if not cursor or len(all_connectors) >= cdata.get('total', 0):
                break

        print(f'\n=== CONNECTORS TOUCHING "{title}" SHAPES (total: {len(all_connectors)}) ===')
        for conn in all_connectors:
            start_id = conn.get('startItem', {}).get('id', '')
            end_id = conn.get('endItem', {}).get('id', '')
            if start_id in shape_ids or end_id in shape_ids:
                captions = conn.get('captions', [])
                cap_text = captions[0].get('content', '') if captions else ''
                cap_text = re.sub(r'<[^>]+>', ' ', cap_text).strip()
                style = conn.get('style', {})
                stroke = style.get('strokeStyle', '?')
                color = style.get('color', '?')
                direction = 'INTERNAL' if (start_id in shape_ids and end_id in shape_ids) else 'EXTERNAL'
                print(f'  {start_id} -> {end_id} | "{cap_text}" | {stroke} | {color} | {direction}')
