#!/usr/bin/env python3
"""
Draw ER V2 — UBG (Doc 22) + DPWAI (Doc 23) on Miro board uXjVGEph3hM=
DeepWork AI Flows — 25/02/2026
"""

import json, urllib.request, urllib.error, time

TOKEN = 'eyJtaXJvLm9yaWdpbiI6ImV1MDEifQ_jHHgzC0B0GtZA2ojyPPYKVpPaNo'
BOARD = 'uXjVGEph3hM%3D'
BASE  = f'https://api.miro.com/v2/boards/{BOARD}'

# ── Colors ───────────────────────────────────────────────────────────────────
COLORS = {
    'ubg'      : ('#fff3e0', '#e65100'),   # orange
    'system'   : ('#e8f5e9', '#2e7d32'),   # green
    'external' : ('#f5f5f5', '#616161'),   # gray
    'dpwai'    : ('#e3f2fd', '#1565c0'),   # blue
    'junction' : ('#f3e5f5', '#7b1fa2'),   # purple
}

# ── HTTP helpers ──────────────────────────────────────────────────────────────
def _call(method, path, body=None):
    url  = f'{BASE}{path}'
    data = json.dumps(body).encode() if body else None
    req  = urllib.request.Request(
        url, data=data,
        headers={'Authorization': f'Bearer {TOKEN}', 'Content-Type': 'application/json'},
        method=method
    )
    try:
        with urllib.request.urlopen(req) as r:
            raw = r.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        print(f'  ERR {method} {path}: {e.code} — {e.read().decode()[:300]}')
        return None

def GET(path):          return _call('GET',    path)
def POST(path, body):   time.sleep(0.3); return _call('POST',   path, body)
def DELETE(path):       time.sleep(0.1); return _call('DELETE', path)


# ── Creators ──────────────────────────────────────────────────────────────────
def make_frame(title, cx, cy, w, h):
    r = POST('/frames', {
        'data'    : {'title': title, 'format': 'custom', 'showContent': True},
        'position': {'x': cx, 'y': cy, 'origin': 'center'},
        'geometry': {'width': w, 'height': h},
        'style'   : {'fillColor': '#ffffff'},
    })
    fid = r['id'] if r else None
    print(f'  Frame "{title}" → {fid}')
    return fid


def make_shape(content, cx, cy, w, h, kind, parent_id=None):
    fill, border = COLORS[kind]
    body = {
        'data'    : {'shape': 'rectangle', 'content': content},
        'style'   : {
            'fillColor'         : fill,
            'borderColor'       : border,
            'borderWidth'       : '2',
            'fontFamily'        : 'open_sans',
            'fontSize'          : '11',
            'textAlign'         : 'left',
            'textAlignVertical' : 'top',
            'color'             : '#1a1a1a',
        },
        'position': {'x': cx, 'y': cy, 'origin': 'center'},
        'geometry': {'width': w, 'height': h},
    }
    if parent_id:
        body['parent'] = {'id': parent_id}
    r = POST('/shapes', body)
    return r['id'] if r else None


def make_text(content, cx, cy, parent_id=None):
    body = {
        'data'    : {'content': content},
        'style'   : {'color': '#555555', 'fontFamily': 'open_sans', 'fontSize': '13', 'fontWeight': 'bold'},
        'position': {'x': cx, 'y': cy, 'origin': 'center'},
        'geometry': {'width': 400, 'height': 40},
    }
    if parent_id:
        body['parent'] = {'id': parent_id}
    r = POST('/texts', body)
    return r['id'] if r else None


def connect(start, end, label='', dashed=False, color='#333333'):
    body = {
        'startItem': {'id': start},
        'endItem'  : {'id': end},
        'style'    : {
            'strokeStyle'   : 'dashed' if dashed else 'normal',
            'strokeWidth'   : '2',
            'color'         : color,
            'startStrokeCap': 'none',
            'endStrokeCap'  : 'arrow',
        },
    }
    if label:
        body['captions'] = [{'content': f'<p>{label}</p>', 'position': '50%'}]
    r = POST('/connectors', body)
    return r['id'] if r else None


# ── Clean up existing board content ──────────────────────────────────────────
def cleanup():
    print('\n=== CLEANUP ===')

    # Delete all connectors
    data = GET('/connectors?limit=50')
    if data:
        for c in data.get('data', []):
            DELETE(f'/connectors/{c["id"]}')
            print(f'  deleted connector {c["id"]}')

    # Delete children of existing UBG frame, then frame itself
    old_children = [
        '3458764661178697496', '3458764661178697497', '3458764661178697499',
        '3458764661178697501', '3458764661178697503', '3458764661178697505',
        '3458764661178697507', '3458764661178697509', '3458764661178697510',
        '3458764661178697512', '3458764661178697515', '3458764661178697516',
        '3458764661178697517', '3458764661178697518', '3458764661178697519',
        '3458764661178697521', '3458764661178697522', '3458764661178697523',
    ]
    for iid in old_children:
        res = DELETE(f'/items/{iid}')
        print(f'  deleted item {iid}')

    # Delete old frame
    DELETE(f'/frames/3458764661178697495')
    print('  deleted old UBG frame')


# ── Entity content strings ────────────────────────────────────────────────────
def E(name, *fields):
    lines = [f'<p><strong>{name}</strong></p>', '<p>────────────────────</p>']
    for f in fields:
        lines.append(f'<p>{f}</p>')
    return ''.join(lines)


ENTITIES = {
    # ─── UBG Internal ────────────────────────────────────────────────────────
    'UBG': E('UBG',
        'PK  ubg_id           UUID',
        'FK  fazenda_sede_id  UUID',
        '    nome             VARCHAR',
        '    cap_secagem_ton  DECIMAL',
        '    responsavel      VARCHAR',
        '    status           VARCHAR',
    ),
    'SILOS': E('SILOS',
        'PK  silo_id        UUID',
        'FK  ubg_id         UUID',
        '    numero         VARCHAR',
        '    tipo           ENUM',
        '    capacidade_m3  DECIMAL',
        '    status         VARCHAR',
    ),
    'TICKET_BALANCA': E('TICKET_BALANCA',
        'PK  ticket_id          UUID',
        'FK  ubg_id             UUID',
        'FK  operacao_campo_id  UUID',
        'FK  operador_id        UUID',
        '    placa              VARCHAR',
        '    peso_bruto_kg      DECIMAL',
        '    tara_kg            DECIMAL',
        '    peso_liquido_kg    DECIMAL',
        '    data_entrada       TIMESTAMP',
    ),
    'RECEBIMENTO_GRAO': E('RECEBIMENTO_GRAO',
        'PK  recebimento_id    UUID',
        'FK  ticket_id         UUID (1:1)',
        'FK  talhao_safra_id   UUID',
        '    umidade_pct       DECIMAL',
        '    ph                DECIMAL',
        '    impureza_pct      DECIMAL',
        '    desc_umid_pct     DECIMAL',
        '    peso_liq_final_kg DECIMAL',
    ),
    'CONTROLE_SECAGEM': E('CONTROLE_SECAGEM',
        'PK  secagem_id       UUID',
        'FK  recebimento_id   UUID',
        '    tipo_secagem     ENUM',
        '    temp_entrada_C   DECIMAL',
        '    temp_saida_C     DECIMAL',
        '    umid_entrada_pct DECIMAL',
        '    umid_saida_pct   DECIMAL',
        '    lenha_m3         DECIMAL',
        '    leitura_at       TIMESTAMP',
    ),
    'ESTOQUE_SILO': E('ESTOQUE_SILO',
        'PK  estoque_id       UUID',
        'FK  silo_id          UUID',
        'FK  cultura_id       UUID',
        'FK  safra_id         UUID',
        '    qtd_virtual_kg   DECIMAL',
        '    qtd_real_kg      DECIMAL',
        '    umidade_atual    DECIMAL',
        '    lote             VARCHAR',
        '    data_entrada     DATE',
    ),
    'SAIDA_GRAO': E('SAIDA_GRAO',
        'PK  saida_id         UUID',
        'FK  estoque_silo_id  UUID',
        'FK  parceiro_id      UUID',
        'FK  nota_fiscal_id   UUID',
        'FK  operador_id      UUID',
        '    tipo_destino     ENUM',
        '    qtd_kg           DECIMAL',
        '    saida_at         TIMESTAMP',
    ),
    'MOVIMENTACAO_SILO': E('MOVIMENTACAO_SILO',
        'PK  movim_id         UUID',
        'FK  silo_origem_id   UUID',
        'FK  silo_destino_id  UUID',
        'FK  operador_id      UUID',
        '    tipo             ENUM',
        '    qtd_kg           DECIMAL',
        '    movim_at         TIMESTAMP',
    ),
    'QUEBRA_PRODUCAO': E('QUEBRA_PRODUCAO',
        'PK  quebra_id        UUID',
        'FK  estoque_silo_id  UUID',
        '    tipo             ENUM',
        '    qtd_virtual_kg   DECIMAL',
        '    qtd_real_kg      DECIMAL',
        '    delta_kg         DECIMAL',
        '    delta_pct        DECIMAL',
        '    apurado_at       TIMESTAMP',
    ),
    'CUSTOM_FORMS': E('CUSTOM_FORMS',
        'PK  form_id          UUID',
        'FK  organization_id  UUID',
        '    nome             VARCHAR',
        '    tipo             ENUM',
        '    schema           JSONB',
        '    status           VARCHAR',
    ),
    'FORM_ENTRIES': E('FORM_ENTRIES',
        'PK  entry_id     UUID',
        'FK  form_id      UUID',
        'FK  user_id      UUID',
        '    data         JSONB',
        '    submitted_at TIMESTAMP',
    ),
    # ─── UBG External refs ───────────────────────────────────────────────────
    'FAZENDAS': E('FAZENDAS',
        'PK  fazenda_id      UUID',
        'FK  organization_id UUID',
        '    nome            VARCHAR',
        '    area_ha         DECIMAL',
        '    municipio       VARCHAR',
    ),
    'OPERADORES': E('OPERADORES',
        'PK  operador_id     UUID',
        'FK  organization_id UUID',
        '    nome            VARCHAR',
        '    cargo           VARCHAR',
        '    status          VARCHAR',
    ),
    'OPERACAO_CAMPO': E('OPERACAO_CAMPO',
        'PK  operacao_id      UUID',
        'FK  talhao_safra_id  UUID',
        '    tipo             ENUM',
        '    data_inicio      TIMESTAMP',
        '    data_fim         TIMESTAMP',
    ),
    'TALHAO_SAFRA': E('TALHAO_SAFRA',
        'PK  talhao_safra_id  UUID',
        'FK  talhao_id        UUID',
        'FK  safra_id         UUID',
        'FK  cultura_id       UUID',
        '    area_plantada_ha DECIMAL',
    ),
    'CULTURAS': E('CULTURAS',
        'PK  cultura_id       UUID',
        '    nome             VARCHAR',
        '    tipo             ENUM',
        '    umidade_max_pct  DECIMAL',
    ),
    'SAFRAS': E('SAFRAS',
        'PK  safra_id         UUID',
        'FK  organization_id  UUID',
        '    ano_inicio       INTEGER',
        '    ano_fim          INTEGER',
        '    status           ENUM',
    ),
    'PARCEIRO_COMERCIAL': E('PARCEIRO_COMERCIAL',
        'PK  parceiro_id     UUID',
        'FK  organization_id UUID',
        '    nome            VARCHAR',
        '    tipo            ENUM',
        '    cnpj            VARCHAR',
    ),
    'NOTA_FISCAL': E('NOTA_FISCAL',
        'PK  nota_id         UUID',
        'FK  organization_id UUID',
        '    numero          VARCHAR',
        '    emissao         DATE',
        '    valor           DECIMAL',
        '    tipo            ENUM',
    ),
    # ─── DPWAI / Sistema ─────────────────────────────────────────────────────
    'ADMINS': E('ADMINS',
        'PK  admin_id  UUID',
        '    email     VARCHAR',
        '    nome      VARCHAR',
        '    status    VARCHAR',
    ),
    'OWNERS': E('OWNERS',
        'PK  owner_id  UUID',
        '    email     VARCHAR',
        '    nome      VARCHAR',
        '    plano     ENUM',
        '    status    VARCHAR',
    ),
    'ORGANIZATIONS': E('ORGANIZATIONS',
        'PK  organization_id UUID',
        'FK  owner_id        UUID',
        '    nome            VARCHAR',
        '    tipo            ENUM',
        '    status          VARCHAR',
    ),
    'ORGANIZATION_SETTINGS': E('ORGANIZATION_SETTINGS',
        'PK  setting_id       UUID',
        'FK  organization_id  UUID (1:1)',
        '    moeda            VARCHAR',
        '    fuso_horario     VARCHAR',
        '    feature_flags    JSONB',
        '    preferencias     JSONB',
    ),
    'USERS': E('USERS',
        'PK  user_id          UUID',
        'FK  organization_id  UUID',
        '    email            VARCHAR',
        '    nome             VARCHAR',
        '    cargo            VARCHAR',
        '    status           VARCHAR',
    ),
    'ROLES': E('ROLES',
        'PK  role_id      UUID',
        '    nome          VARCHAR',
        '    descricao     TEXT',
        '    is_system     BOOLEAN',
    ),
    'PERMISSIONS': E('PERMISSIONS',
        'PK  permission_id  UUID',
        '    recurso        VARCHAR',
        '    acao           VARCHAR',
        '    descricao      TEXT',
    ),
    'USER_ROLES': E('USER_ROLES  (N:N)',
        'FK  user_id     UUID',
        'FK  role_id     UUID',
        '    granted_at  TIMESTAMP',
        '    granted_by  UUID',
    ),
    'ROLE_PERMISSIONS': E('ROLE_PERMISSIONS  (N:N)',
        'FK  role_id        UUID',
        'FK  permission_id  UUID',
        '    granted_at     TIMESTAMP',
    ),
    'USER_PERMISSIONS': E('USER_PERMISSIONS  (N:N)',
        'FK  user_id        UUID',
        'FK  permission_id  UUID',
        '    granted_at     TIMESTAMP',
        '    granted_by     UUID',
    ),
    'INVITE_TOKENS': E('INVITE_TOKENS',
        'PK  token_id         UUID',
        'FK  organization_id  UUID',
        'FK  criado_por_id    UUID',
        '    token            VARCHAR',
        '    email_convidado  VARCHAR',
        '    status           ENUM',
        '    expira_em        TIMESTAMP',
    ),
}


# ── Positions inside each frame (all are CENTER coords relative to frame TL) ─
#  UBG frame: 9000 x 5800  DPWAI frame: 6000 x 3800

UBG_POS = {
    # internal zone (x 100–4300)
    'UBG'               : (2200,  450, 380, 210, 'ubg'),
    'SILOS'             : ( 950, 1100, 370, 210, 'ubg'),
    'TICKET_BALANCA'    : (3300, 1100, 380, 260, 'ubg'),
    'ESTOQUE_SILO'      : ( 950, 2000, 380, 260, 'ubg'),
    'RECEBIMENTO_GRAO'  : (3300, 1900, 380, 240, 'ubg'),
    'CONTROLE_SECAGEM'  : (3300, 2700, 380, 260, 'ubg'),
    'SAIDA_GRAO'        : ( 500, 2950, 380, 240, 'ubg'),
    'MOVIMENTACAO_SILO' : (1400, 2950, 380, 220, 'ubg'),
    'QUEBRA_PRODUCAO'   : (2200, 2950, 380, 240, 'ubg'),
    'CUSTOM_FORMS'      : ( 600, 3800, 370, 220, 'system'),
    'FORM_ENTRIES'      : (1550, 3800, 370, 200, 'system'),
    # external ref zone (x 4700–8700)
    'FAZENDAS'          : (5200,  450, 340, 200, 'external'),
    'OPERADORES'        : (5200, 1050, 340, 180, 'external'),
    'OPERACAO_CAMPO'    : (6300, 1050, 340, 200, 'external'),
    'TALHAO_SAFRA'      : (5200, 1700, 340, 200, 'external'),
    'CULTURAS'          : (5200, 2300, 340, 180, 'external'),
    'SAFRAS'            : (6300, 2300, 340, 180, 'external'),
    'PARCEIRO_COMERCIAL': (5300, 2900, 360, 180, 'external'),
    'NOTA_FISCAL'       : (6400, 2900, 340, 200, 'external'),
}

DPWAI_POS = {
    'ADMINS'                : ( 500,  400, 320, 180, 'dpwai'),
    'OWNERS'                : (1200,  400, 320, 180, 'dpwai'),
    'ORGANIZATIONS'         : (2200,  400, 380, 210, 'dpwai'),
    'ORGANIZATION_SETTINGS' : (3400,  400, 400, 220, 'dpwai'),
    'USERS'                 : (2200, 1100, 370, 210, 'dpwai'),
    'INVITE_TOKENS'         : (3400, 1100, 380, 240, 'dpwai'),
    'ROLES'                 : ( 700, 1100, 320, 180, 'dpwai'),
    'PERMISSIONS'           : (1500, 1100, 340, 180, 'dpwai'),
    'USER_ROLES'            : ( 700, 1900, 360, 180, 'junction'),
    'ROLE_PERMISSIONS'      : (1600, 1900, 380, 180, 'junction'),
    'USER_PERMISSIONS'      : (2800, 1900, 400, 180, 'junction'),
}


# ── MAIN ──────────────────────────────────────────────────────────────────────
def main():
    cleanup()

    # ── Create UBG Frame ─────────────────────────────────────────────────────
    print('\n=== UBG FRAME ===')
    # Center at (15000, 3000) on board; size 9000 x 5800
    ubg_frame = make_frame('MODULO UBG — v2 (Doc 22)', 15000, 3000, 9000, 5800)

    # Zone labels inside frame
    make_text('<p><strong>◀ ENTIDADES INTERNAS</strong></p>',     2200,  80, ubg_frame)
    make_text('<p><strong>▶ ENTIDADES EXTERNAS (refs)</strong></p>', 5800, 80, ubg_frame)

    # Create entity shapes
    ubg = {}
    for name, (cx, cy, w, h, kind) in UBG_POS.items():
        sid = make_shape(ENTITIES[name], cx, cy, w, h, kind, ubg_frame)
        ubg[name] = sid
        print(f'  {name} → {sid}')

    # ── Create DPWAI Frame ────────────────────────────────────────────────────
    print('\n=== DPWAI FRAME ===')
    # Center at (15000, 10500) on board; size 5500 x 3200
    dpwai_frame = make_frame('MODULO DPWAI/SISTEMA — v2 (Doc 23)', 15000, 10500, 5500, 3200)

    dpwai = {}
    for name, (cx, cy, w, h, kind) in DPWAI_POS.items():
        sid = make_shape(ENTITIES[name], cx, cy, w, h, kind, dpwai_frame)
        dpwai[name] = sid
        print(f'  {name} → {sid}')

    # ── UBG Relationships (Doc 22) ────────────────────────────────────────────
    print('\n=== UBG CONNECTORS ===')
    def uc(a, b, label='', dashed=False, color='#333333'):
        src = ubg.get(a) or dpwai.get(a)
        dst = ubg.get(b) or dpwai.get(b)
        if not src or not dst:
            print(f'  SKIP {a} → {b} (missing id)')
            return
        cid = connect(src, dst, label, dashed, color)
        print(f'  {a} → {b} "{label}" → {cid}')

    # ─ Internal solid connectors ─────────────────────────────────────────────
    uc('UBG',              'SILOS',              'contem')         # U01
    uc('UBG',              'TICKET_BALANCA',     'recebe')         # U02
    uc('TICKET_BALANCA',   'RECEBIMENTO_GRAO',   'classifica')     # U03 1:1
    uc('RECEBIMENTO_GRAO', 'CONTROLE_SECAGEM',   'seca')           # U04
    uc('SILOS',            'ESTOQUE_SILO',        'estoque')       # U11
    uc('CONTROLE_SECAGEM', 'ESTOQUE_SILO',        'armazena')      # U14 (implicit)
    uc('ESTOQUE_SILO',     'SAIDA_GRAO',          'sai')           # U05
    uc('ESTOQUE_SILO',     'MOVIMENTACAO_SILO',   'move')          # U06 (redesenhar)
    uc('ESTOQUE_SILO',     'QUEBRA_PRODUCAO',     'apura')         # U07
    uc('MOVIMENTACAO_SILO','SILOS',               'silo_origem')   # U08
    # U09 silo_destino — second connection MOVIM → SILOS with different label
    cid = connect(ubg['MOVIMENTACAO_SILO'], ubg['SILOS'], 'silo_destino')
    print(f'  MOVIMENTACAO_SILO → SILOS "silo_destino" → {cid}')

    uc('CUSTOM_FORMS',     'FORM_ENTRIES',        'preenche')       # U10

    # ─ External dashed connectors ────────────────────────────────────────────
    GREEN  = '#2e7d32'
    YELLOW = '#f9a825'
    CYAN   = '#00838f'
    ORANGE = '#e65100'

    uc('UBG',              'FAZENDAS',            'sede',          True, GREEN)   # U15
    uc('TICKET_BALANCA',   'OPERACAO_CAMPO',       'colheita_orig', True, YELLOW) # U16
    uc('TICKET_BALANCA',   'OPERADORES',           'operador',      True, CYAN)   # U17
    uc('RECEBIMENTO_GRAO', 'TALHAO_SAFRA',         'talhao+safra',  True, GREEN)  # U18
    uc('ESTOQUE_SILO',     'CULTURAS',             'cultura',       True, GREEN)  # U12
    uc('ESTOQUE_SILO',     'SAFRAS',               'safra',         True, GREEN)  # U13
    uc('SAIDA_GRAO',       'PARCEIRO_COMERCIAL',   'comprador',     True, GREEN)  # U19
    uc('SAIDA_GRAO',       'NOTA_FISCAL',          'nf_saida',      True, ORANGE) # U20
    uc('SAIDA_GRAO',       'OPERADORES',           'operador',      True, CYAN)   # U21
    uc('MOVIMENTACAO_SILO','OPERADORES',            'operador',      True, CYAN)   # U22

    # ── DPWAI Relationships (Doc 23) ──────────────────────────────────────────
    print('\n=== DPWAI CONNECTORS ===')
    def dc(a, b, label='', dashed=False, color='#1565c0'):
        src = dpwai.get(a) or ubg.get(a)
        dst = dpwai.get(b) or ubg.get(b)
        if not src or not dst:
            print(f'  SKIP {a} → {b} (missing id)')
            return
        cid = connect(src, dst, label, dashed, color)
        print(f'  {a} → {b} "{label}" → {cid}')

    BLUE_D = '#1565c0'

    dc('ORGANIZATIONS',          'OWNERS',              'owner')      # D01
    dc('ORGANIZATION_SETTINGS',  'ORGANIZATIONS',       'config')     # D02 1:1
    dc('USERS',                  'ORGANIZATIONS',       'org')        # D03
    dc('USER_ROLES',             'USERS',               'usuario')    # D04
    dc('USER_ROLES',             'ROLES',               'papel')      # D05
    dc('ROLE_PERMISSIONS',       'ROLES',               'papel')      # D06
    dc('ROLE_PERMISSIONS',       'PERMISSIONS',         'permissao')  # D07
    dc('USER_PERMISSIONS',       'USERS',               'usuario')    # D08
    dc('USER_PERMISSIONS',       'PERMISSIONS',         'permissao')  # D09
    dc('INVITE_TOKENS',          'ORGANIZATIONS',       'org')        # D10
    dc('INVITE_TOKENS',          'USERS',               'criador')    # D11
    # D12: cross-frame FORM_ENTRIES (UBG) → USERS (DPWAI)
    cid = connect(ubg['FORM_ENTRIES'], dpwai['USERS'], 'submitter', True, '#7b1fa2')
    print(f'  FORM_ENTRIES → USERS "submitter" (cross-frame) → {cid}')
    # D13: FAZENDAS (UBG external ref) → ORGANIZATIONS (DPWAI)
    cid = connect(ubg['FAZENDAS'], dpwai['ORGANIZATIONS'], 'org', True, '#2e7d32')
    print(f'  FAZENDAS → ORGANIZATIONS "org" (cross-frame) → {cid}')

    # ── Org_id sticky note ────────────────────────────────────────────────────
    print('\n=== ORG_ID NOTE ===')
    note_body = {
        'data'    : {'content': '<p><strong>Nota: organization_id</strong></p><p>Todas as entidades carregam organization_id → ORGANIZATIONS para multi-tenancy. Não desenhado nos conectores.</p>'},
        'style'   : {'fillColor': '#fff9c4'},
        'position': {'x': 15000, 'y': 14500, 'origin': 'center'},
        'geometry': {'width': 500, 'height': 120},
    }
    r = POST('/sticky_notes', note_body)
    print(f'  org_id sticky note → {r["id"] if r else None}')

    print('\n✅ Done! Board: https://miro.com/app/board/uXjVGEph3hM=/')


if __name__ == '__main__':
    main()
