#!/usr/bin/env python3
import json, re, urllib.request

token = 'eyJtaXJvLm9yaWdpbiI6ImV1MDEifQ_jHHgzC0B0GtZA2ojyPPYKVpPaNo'
board = 'uXjVGE__XFQ%3D'

# Fetch ALL text items
req = urllib.request.Request(
    'https://api.miro.com/v2/boards/' + board + '/items?limit=50&type=text',
    headers={'Authorization': 'Bearer ' + token}
)
with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read())

print("=== TEXT ITEMS NEAR MAQUINARIO (x:12000-22000, y:17000-24000) ===")
for item in data['data']:
    x = item.get('position', {}).get('x', 0)
    y = item.get('position', {}).get('y', 0)
    raw = item.get('data', {}).get('content', '')
    content = re.sub(r'<[^>]+>', ' ', raw).strip()
    if 12000 < x < 22000 and 17000 < y < 24000:
        parent = item.get('parent', {}).get('id', 'none')
        print(f'  pos: ({int(x)},{int(y)}) | parent: {parent} | {content[:120]}')

# Also fetch ALL sticky notes
req2 = urllib.request.Request(
    'https://api.miro.com/v2/boards/' + board + '/items?limit=50&type=sticky_note',
    headers={'Authorization': 'Bearer ' + token}
)
with urllib.request.urlopen(req2) as resp2:
    data2 = json.loads(resp2.read())

print("\n=== STICKY NOTES NEAR MAQUINARIO ===")
for item in data2['data']:
    x = item.get('position', {}).get('x', 0)
    y = item.get('position', {}).get('y', 0)
    raw = item.get('data', {}).get('content', '')
    content = re.sub(r'<[^>]+>', ' ', raw).strip()
    if 12000 < x < 22000 and 17000 < y < 24000:
        print(f'  pos: ({int(x)},{int(y)}) | {content[:120]}')

# Fetch connectors to see existing relationships
req3 = urllib.request.Request(
    'https://api.miro.com/v2/boards/' + board + '/connectors?limit=50',
    headers={'Authorization': 'Bearer ' + token}
)
with urllib.request.urlopen(req3) as resp3:
    data3 = json.loads(resp3.read())

# Get shape IDs in maquinario frame
maq_shapes = ['3458764658641289787', '3458764658641289788', '3458764658641289789', '3458764658641289790']
print(f"\n=== CONNECTORS TOUCHING MAQUINARIO SHAPES (total connectors: {data3['total']}) ===")
for conn in data3['data']:
    start_id = conn.get('startItem', {}).get('id', '')
    end_id = conn.get('endItem', {}).get('id', '')
    if start_id in maq_shapes or end_id in maq_shapes:
        captions = conn.get('captions', [])
        cap_text = captions[0].get('content', '') if captions else ''
        style = conn.get('style', {})
        print(f'  {start_id} -> {end_id} | caption: {cap_text} | color: {style.get("color", "?")}')
