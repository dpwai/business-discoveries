#!/usr/bin/env python3
import json, re, urllib.request

token = 'eyJtaXJvLm9yaWdpbiI6ImV1MDEifQ_jHHgzC0B0GtZA2ojyPPYKVpPaNo'
board = 'uXjVGCOBuw4%3D'

def fetch(url):
    req = urllib.request.Request(url, headers={'Authorization': 'Bearer ' + token})
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())

# 1. Get all frames
frames = fetch(f'https://api.miro.com/v2/boards/{board}/items?limit=50&type=frame')
print("=== ALL FRAMES ===")
for f in frames['data']:
    title = f.get('data', {}).get('title', '?')
    fid = f['id']
    x = int(f.get('position', {}).get('x', 0))
    y = int(f.get('position', {}).get('y', 0))
    w = int(f.get('geometry', {}).get('width', 0))
    h = int(f.get('geometry', {}).get('height', 0))
    print(f'  {title} | id: {fid} | pos: ({x},{y}) | size: {w}x{h}')

# 2. Get ALL items on the board (paginated)
all_items = []
cursor = ''
page = 0
while True:
    url = f'https://api.miro.com/v2/boards/{board}/items?limit=50'
    if cursor:
        url += f'&cursor={cursor}'
    data = fetch(url)
    all_items.extend(data.get('data', []))
    cursor = data.get('cursor', '')
    page += 1
    if not cursor or page > 10:
        break

print(f'\n=== ALL ITEMS ({len(all_items)} total) ===')
shape_ids = []
for item in all_items:
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
        content = re.sub(r'<[^>]+>', ' ', raw).strip() if raw else '(unsupported)'
        shape_ids.append(iid)
    parent = item.get('parent', {}).get('id', 'none')
    print(f'  {itype} | id: {iid} | pos: ({x},{y}) | parent: {parent} | sup: {supported} | {content[:140]}')

# 3. Fetch ALL connectors (paginated)
all_connectors = []
cursor = ''
page = 0
while True:
    url = f'https://api.miro.com/v2/boards/{board}/connectors?limit=50'
    if cursor:
        url += f'&cursor={cursor}'
    cdata = fetch(url)
    all_connectors.extend(cdata.get('data', []))
    cursor = cdata.get('cursor', '')
    page += 1
    if not cursor or page > 10:
        break

print(f'\n=== ALL CONNECTORS ({len(all_connectors)} total) ===')
for conn in all_connectors:
    start_id = conn.get('startItem', {}).get('id', '')
    end_id = conn.get('endItem', {}).get('id', '')
    captions = conn.get('captions', [])
    cap_text = captions[0].get('content', '') if captions else ''
    cap_text = re.sub(r'<[^>]+>', ' ', cap_text).strip()
    style = conn.get('style', {})
    stroke = style.get('strokeStyle', '?')
    color = style.get('color', '?')
    print(f'  {start_id} -> {end_id} | "{cap_text}" | {stroke} | {color}')
