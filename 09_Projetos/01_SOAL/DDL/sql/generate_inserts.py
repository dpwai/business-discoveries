#!/usr/bin/env python3
"""
generate_inserts.py — Gera INSERT INTO SQL a partir dos CSVs em IMPORTS/
Output: 01_INSERT_SEEDS.sql + 02_INSERT_DADOS.sql
Rodar: python3 generate_inserts.py
"""
import csv, os, sys, re
from pathlib import Path
from datetime import datetime

REPO = Path(__file__).resolve().parent.parent.parent.parent.parent  # business-discoveries/
IMPORTS = REPO / "09_Projetos" / "01_SOAL" / "DATA" / "IMPORTS"
OUT_DIR = Path(__file__).resolve().parent  # DDL/sql/

# ─── Helpers ────────────────────────────────────────────────────────────────

def read_csv(relpath):
    """Read CSV from IMPORTS/, return list of dicts."""
    fp = IMPORTS / relpath
    if not fp.exists():
        print(f"  WARN: {fp} not found, skipping")
        return []
    with open(fp, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        return [row for row in reader]

def esc(val):
    """Escape a string value for SQL. Returns 'value' or NULL."""
    if val is None or val == "" or val == "None":
        return "NULL"
    s = str(val).replace("'", "''")
    return f"'{s}'"

def esc_num(val):
    """Numeric value or NULL."""
    if val is None or val == "" or val == "None":
        return "NULL"
    try:
        # Handle BR format: 1.234,56 -> not needed, CSVs use EN format
        return str(float(val))
    except ValueError:
        return "NULL"

def esc_int(val):
    """Integer value or NULL."""
    if val is None or val == "" or val == "None":
        return "NULL"
    try:
        return str(int(float(val)))
    except ValueError:
        return "NULL"

def esc_bool(val):
    """Boolean value."""
    if val is None or val == "":
        return "NULL"
    v = str(val).lower().strip()
    if v in ("true", "1", "yes", "sim"):
        return "TRUE"
    if v in ("false", "0", "no", "nao"):
        return "FALSE"
    return "NULL"

def esc_date(val):
    """Date value. Handles dd/mm/yyyy and yyyy-mm-dd."""
    if val is None or val == "" or val == "None":
        return "NULL"
    v = str(val).strip()
    # dd/mm/yyyy or dd/mm/yy
    m = re.match(r"(\d{1,2})/(\d{1,2})/(\d{2,4})", v)
    if m:
        d, mo, y = m.groups()
        if len(y) == 2:
            y = "20" + y if int(y) < 50 else "19" + y
        return f"'{y}-{mo.zfill(2)}-{d.zfill(2)}'"
    # yyyy-mm-dd
    m = re.match(r"(\d{4})-(\d{2})-(\d{2})", v)
    if m:
        return f"'{v}'"
    return "NULL"

def esc_ts(val):
    """Timestamp value."""
    if val is None or val == "" or val == "None":
        return "NULL"
    return esc_date(val)  # just date part, PG will add 00:00:00

def org_id():
    """Subquery for SOAL organization_id."""
    return "(SELECT organization_id FROM organizations WHERE name = 'Serra da Onça Agropecuária' LIMIT 1)"

def fazenda_id(name):
    """Subquery for fazenda_id by name."""
    n = name.replace("'", "''")
    return f"(SELECT fazenda_id FROM fazendas WHERE name = '{n}' LIMIT 1)"

def safra_id(code):
    """Subquery for safra_id by season_code."""
    c = str(code).strip().replace("'", "''")
    return f"(SELECT safra_id FROM safras WHERE season_code = '{c}' LIMIT 1)"

def cultura_id(name):
    """Subquery for cultura_id by name."""
    n = str(name).strip().lower().replace("'", "''")
    return f"(SELECT cultura_id FROM culturas WHERE name = '{n}' LIMIT 1)"

def maquina_id_by_code(code):
    """Subquery for maquina_id by code."""
    c = str(code).strip().replace("'", "''")
    return f"(SELECT maquina_id FROM maquinas WHERE codigo = '{c}' LIMIT 1)"

def colaborador_id_by_cpf(cpf):
    """Subquery for colaborador_id by cpf."""
    c = str(cpf).strip().replace("'", "''")
    return f"(SELECT colaborador_id FROM colaboradores WHERE cpf = '{c}' LIMIT 1)"

def header(title, note=""):
    """Section header."""
    lines = [f"\n-- {'='*70}", f"-- {title}", f"-- {'='*70}"]
    if note:
        lines.append(f"-- {note}")
    return "\n".join(lines) + "\n"

def batch_insert(table, columns, rows_sql, batch_size=500):
    """Generate batch INSERT statements."""
    lines = []
    for i in range(0, len(rows_sql), batch_size):
        batch = rows_sql[i:i+batch_size]
        cols = ", ".join(columns)
        vals = ",\n  ".join(batch)
        lines.append(f"INSERT INTO {table} ({cols}) VALUES\n  {vals};\n")
    return "\n".join(lines)


# ═══════════════════════════════════════════════════════════════════════════
# FILE 1: Seeds & Reference (Fases 0-2)
# ═══════════════════════════════════════════════════════════════════════════

def gen_seeds():
    parts = []
    parts.append(f"""-- ═══════════════════════════════════════════════════════════════════════
-- SOAL — 01_INSERT_SEEDS.sql
-- Seeds & Dados de Referência (Fases 0-2)
-- ═══════════════════════════════════════════════════════════════════════
-- Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M')}
-- Rodar APÓS: psql -f 00_DDL_COMPLETO_V0.sql
-- Ordem de dependência FK respeitada
-- ═══════════════════════════════════════════════════════════════════════

BEGIN;
""")

    # ─── 1. ADMINS ───
    parts.append(header("1. ADMINS (seed manual)"))
    parts.append("""INSERT INTO admins (name, email, status) VALUES
  ('System Admin', 'admin@deepwork.ai', 'active');
""")

    # ─── 2. OWNERS ───
    parts.append(header("2. OWNERS (seed manual)"))
    parts.append("""INSERT INTO owners (admin_id, name, email, cpf, phone, status) VALUES
  ((SELECT admin_id FROM admins WHERE email = 'admin@deepwork.ai'),
   'Claudio Kugler', NULL, NULL, NULL, 'active');
""")

    # ─── 3. ORGANIZATIONS ───
    parts.append(header("3. ORGANIZATIONS", "Fonte: fase_1_sistema/01_organizations.csv"))
    rows = read_csv("fase_1_sistema/01_organizations.csv")
    for r in rows:
        parts.append(f"""INSERT INTO organizations (
  owner_id, name, cnpj, razao_social, inscricao_estadual,
  email, phone, endereco, cidade, estado, cep, pais,
  cnae, regime_tributario, description, status
) VALUES (
  (SELECT owner_id FROM owners WHERE name = 'Claudio Kugler'),
  {esc(r.get('name'))}, {esc(r.get('cnpj'))}, {esc(r.get('razao_social'))}, {esc(r.get('inscricao_estadual'))},
  {esc(r.get('email'))}, {esc(r.get('phone'))},
  {esc((r.get('logradouro','') + ' ' + r.get('numero','')).strip())},
  {esc(r.get('city'))}, {esc(r.get('state'))}, {esc(r.get('cep'))}, {esc(r.get('country'))},
  {esc(r.get('cnae'))}, {esc(r.get('regime_tributario'))}, {esc(r.get('description'))}, 'active'
);
""")

    # ─── 4. USERS ───
    parts.append(header("4. USERS", "Fonte: fase_1_sistema/02_users.csv"))
    rows = read_csv("fase_1_sistema/02_users.csv")
    for r in rows:
        role = r.get('role', 'MEMBER').strip().upper()
        is_owner = esc_bool(r.get('is_owner', 'false'))
        parts.append(f"""INSERT INTO users (
  organization_id, email, username, first_name, last_name, phone, role, status
) VALUES (
  {org_id()},
  {esc(r.get('email'))}, {esc(r.get('username'))},
  {esc(r.get('first_name'))}, {esc(r.get('last_name'))},
  {esc(r.get('phone'))}, {esc(role)}, 'active'
);
""")

    # ─── 5. CULTURAS ───
    parts.append(header("5. CULTURAS", "Fonte: fase_0/01_culturas.csv"))
    rows = read_csv("fase_0/01_culturas.csv")
    vals = []
    for r in rows:
        grupo = r.get('group', 'graos')
        vals.append(f"({esc(r['name'])}, {esc(r.get('display_name'))}, {esc(grupo)}, {esc(r.get('harvest_unit','sc_60kg'))})")
    parts.append(batch_insert("culturas",
        ["name", "display_name", "grupo", "unidade_colheita"], vals))

    # ─── 6. SAFRAS ───
    parts.append(header("6. SAFRAS", "Fonte: fase_2/01_safras.csv"))
    rows = read_csv("fase_2/01_safras.csv")
    for r in rows:
        status_map = {"HISTORICAL": "encerrada", "ACTIVE": "em_andamento", "PLANNED": "planejamento"}
        status = status_map.get(r.get('status',''), 'planejamento')
        parts.append(f"""INSERT INTO safras (
  organization_id, season_code, display_name,
  data_inicio, data_fim, status, observacoes
) VALUES (
  {org_id()},
  {esc(r['season_code'])}, {esc(r.get('display_name'))},
  {esc_date(r.get('fiscal_year_start'))}, {esc_date(r.get('fiscal_year_end'))},
  '{status}', {esc(r.get('notes'))}
);
""")

    # ─── 7. FAZENDAS ───
    parts.append(header("7. FAZENDAS", "Fonte: fase_2/02_fazendas.csv (9 fazendas, 4.127,56 ha)"))
    rows = read_csv("fase_2/02_fazendas.csv")
    for r in rows:
        is_active = r.get('is_active', 'True')
        status = 'active' if str(is_active).lower() == 'true' else 'inactive'
        parts.append(f"""INSERT INTO fazendas (
  organization_id, name, cnpj, municipio, estado, area_total_ha, area_agricola_ha,
  car, ccir_incra, itr, status
) VALUES (
  {org_id()},
  {esc(r['name'])}, {esc(r.get('cnpj'))},
  {esc(r.get('municipality'))}, {esc(r.get('state'))},
  {esc_num(r.get('area_total_ha'))}, {esc_num(r.get('area_agricultura_ha'))},
  {esc(r.get('car'))}, {esc(r.get('ccir_incra'))}, {esc(r.get('itr'))}, '{status}'
);
""")

    # ─── 8. TALHOES ───
    parts.append(header("8. TALHOES", "Fonte: fase_2/03_talhoes.csv (71 registros)"))
    rows = read_csv("fase_2/03_talhoes.csv")
    for r in rows:
        faz = r.get('fazenda_name_lookup', '').strip()
        is_active = str(r.get('is_active', 'True')).lower() == 'true'
        parts.append(f"""INSERT INTO talhoes (
  organization_id, fazenda_id, name, area_ha, status
) VALUES (
  {org_id()},
  {fazenda_id(faz)},
  {esc(r['name'])}, {esc_num(r.get('area_ha'))},
  '{"active" if is_active else "inactive"}'
);
""")

    # ─── 9. MATRICULAS ───
    parts.append(header("9. MATRICULAS", "Fonte: fase_2/04_matriculas.csv (88 registros)"))
    rows = read_csv("fase_2/04_matriculas.csv")
    for r in rows:
        faz = r.get('fazenda_canonical', '').strip()
        parts.append(f"""INSERT INTO matriculas (
  fazenda_id, numero_matricula, area_ha, titular,
  descricao, data_aquisicao, proprietario_anterior,
  data_incorporacao_soal, ccir_incra, itr, car, observacoes, status
) VALUES (
  {fazenda_id(faz)},
  {esc(r.get('numero_matricula'))}, {esc_num(r.get('area_ha'))}, {esc(r.get('proprietario_atual'))},
  {esc(r.get('descricao'))}, {esc_date(r.get('data_aquisicao'))}, {esc(r.get('proprietario_anterior'))},
  {esc_date(r.get('data_incorporacao_soal'))}, {esc(r.get('ccir_incra'))}, {esc(r.get('itr'))},
  {esc(r.get('car'))}, {esc(r.get('observacoes'))}, 'active'
);
""")

    # ─── 10. SILOS ───
    parts.append(header("10. SILOS", "Fonte: fase_2_territorial/02_silos_ubg.csv (8 registros)"))
    rows = read_csv("fase_2_territorial/02_silos_ubg.csv")
    for r in rows:
        # Silos are at FAZENDA SANTANA DO IAPO (UBG location)
        tipo_map = {"CONVENCIONAL": "metalico", "SEMENTE": "metalico"}
        tipo = tipo_map.get(r.get('tipo',''), 'metalico')
        material = r.get('material', 'METALICO').lower()
        if material == 'madeira':
            tipo = 'tulha'
        parts.append(f"""INSERT INTO silos (
  organization_id, fazenda_id, nome, numero_silo, tipo,
  capacidade_toneladas, tem_aeracao, tem_termometria, status
) VALUES (
  {org_id()},
  {fazenda_id('FAZENDA SANTANA DO IAPO')},
  {esc(r.get('nome'))}, {esc_int(r.get('numero_silo'))}, '{tipo}',
  {esc_num(r.get('capacidade_toneladas'))},
  {esc_bool(r.get('tem_aeracao'))}, {esc_bool(r.get('tem_termometria'))}, 'active'
);
""")

    # ─── 11. UBGS ───
    parts.append(header("11. UBGS", "Fonte: fase_2_territorial/01_ubg.csv"))
    rows = read_csv("fase_2_territorial/01_ubg.csv")
    for r in rows:
        faz = r.get('fazenda_sede', '').strip()
        parts.append(f"""INSERT INTO ubgs (
  organization_id, fazenda_sede_id, nome,
  capacidade_recepcao_t_dia, capacidade_secagem_t_dia,
  tem_balanca, tem_tombador, tem_secador,
  software_ubg, responsavel_tecnico, crea_responsavel,
  latitude, longitude, status, observacoes
) VALUES (
  {org_id()},
  {fazenda_id(faz)},
  {esc(r.get('nome'))},
  {esc_num(r.get('capacidade_recepcao_t_dia'))}, {esc_num(r.get('capacidade_secagem_t_dia'))},
  {esc_bool(r.get('tem_balanca'))}, {esc_bool(r.get('tem_tombador'))}, {esc_bool(r.get('tem_secador'))},
  {esc(r.get('software_ubg'))}, {esc(r.get('responsavel_tecnico'))}, {esc(r.get('crea_responsavel'))},
  {esc_num(r.get('latitude'))}, {esc_num(r.get('longitude'))}, 'active',
  {esc(r.get('observacoes'))}
);
""")

    # ─── 12. TANQUES COMBUSTÍVEL ───
    parts.append(header("12. TANQUES_COMBUSTIVEL", "Fonte: fase_3/06_fuel_tanks.csv"))
    rows = read_csv("fase_3/06_fuel_tanks.csv")
    for r in rows:
        fuel_map = {"Diesel S10": "diesel_s10", "Gasolina": "gasolina"}
        fuel = fuel_map.get(r.get('fuel_type',''), 'diesel_s10')
        # fazenda_base_lookup has names like "C1: Murtinho" - not a fazenda name
        # tanques don't have a direct fazenda FK, just a name
        parts.append(f"""INSERT INTO tanques_combustivel (
  organization_id, nome, tipo_combustivel, capacidade_litros, status
) VALUES (
  {org_id()},
  {esc(r.get('name'))}, '{fuel}',
  {esc_num(r.get('capacity_liters'))}, 'active'
);
""")

    # ─── 13. PARCEIROS COMERCIAIS ───
    parts.append(header("13. PARCEIROS_COMERCIAIS", "Fonte: fase_2/06_parceiros_agriwin.csv (2.201 registros)"))
    rows = read_csv("fase_2/06_parceiros_agriwin.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo', '').strip().lower()
        if tipo == 'cliente':
            tipo_arr = "'{cliente}'"
        elif tipo == 'fornecedor':
            tipo_arr = "'{fornecedor}'"
        elif tipo:
            tipo_arr = f"'{{{tipo}}}'"
        else:
            tipo_arr = "'{}'"
        is_active = str(r.get('is_active', 'True')).lower() == 'true'
        status = 'active' if is_active else 'inactive'
        vals.append(f"({org_id()}, {esc(r.get('name'))}, {esc(r.get('razao_social'))}, {esc(r.get('nome_fantasia'))}, {esc(r.get('cpf_cnpj'))}, {tipo_arr}, {esc(r.get('telefone'))}, {esc(r.get('cidade'))}, {esc(r.get('uf'))}, '{status}')")
    parts.append(batch_insert("parceiros_comerciais",
        ["organization_id", "name", "razao_social", "nome_fantasia", "cpf_cnpj", "tipo", "telefone", "cidade", "estado", "status"],
        vals, batch_size=200))

    # ─── 14. PRODUTO_INSUMO ───
    parts.append(header("14. PRODUTO_INSUMO", "Fonte: fase_0/03_produto_insumo_agriwin.csv (18.499 registros)"))
    rows = read_csv("fase_0/03_produto_insumo_agriwin.csv")
    # Map CSV tipo to ENUM tipo_insumo
    tipo_map = {
        "ADJUVANTE": "adjuvante",
        "BIOLOGICO": "biologico",
        "BIOLÓGICO": "biologico",
        "FERTILIZANTE": "fertilizante",
        "FUNGICIDA": "fungicida",
        "HERBICIDA": "herbicida",
        "INSETICIDA": "inseticida",
        "SEMENTE": "semente",
        "ADUBO": "fertilizante",
        "OLEO MINERAL": "adjuvante",
        "INOCULANTE": "biologico",
    }
    grupo_map = {
        "agricola": "agricola",
        "geral": "geral",
        "pecuaria": "pecuaria",
        "ubg": "ubg",
    }
    vals = []
    for r in rows:
        tipo_csv = r.get('tipo', '').strip()
        tipo_sql = tipo_map.get(tipo_csv, 'outros')
        # The DDL ENUM might not have all values; use the closest match
        grupo_csv = r.get('grupo', 'agricola').strip().lower()
        grupo_sql = grupo_map.get(grupo_csv, 'agricola')
        is_active = esc_bool(r.get('is_active', 'True'))
        vals.append(f"({org_id()}, {esc(r.get('name'))}, {esc(r.get('display_name'))}, '{tipo_sql}', '{grupo_sql}', {esc(r.get('unidade_medida'))}, {esc_num(r.get('custo_medio'))}, {is_active})")

    parts.append(batch_insert("produto_insumo",
        ["organization_id", "name", "display_name", "tipo", "grupo", "unidade_medida", "custo_medio_unitario", "ativo"],
        vals, batch_size=200))

    # ─── 15. TALHAO_MAPPING ───
    parts.append(header("15. TALHAO_MAPPING", "Fonte: fase_2/03b_talhao_nome_mapping.csv (170 registros)"))
    rows = read_csv("fase_2/03b_talhao_nome_mapping.csv")
    vals = []
    for r in rows:
        vals.append(f"({esc(r.get('talhoes_csv_name'))}, {esc(r.get('plantio_2425_name'))}, {esc(r.get('plantio_2526_name'))}, {esc(r.get('canonical_name'))})")
    parts.append(batch_insert("talhao_mapping",
        ["nome_origem", "nome_plantio_2425", "nome_plantio_2526", "nome_canonico"],
        vals, batch_size=200))

    parts.append("""
COMMIT;

-- ═══════════════════════════════════════════════════════════════════════
-- FIM — 01_INSERT_SEEDS.sql
-- Próximo: psql -f 02_INSERT_DADOS.sql
-- ═══════════════════════════════════════════════════════════════════════
""")

    return "".join(parts)


# ═══════════════════════════════════════════════════════════════════════════
# FILE 2: Operational Data (Fases 3+)
# ═══════════════════════════════════════════════════════════════════════════

def gen_dados():
    parts = []
    parts.append(f"""-- ═══════════════════════════════════════════════════════════════════════
-- SOAL — 02_INSERT_DADOS.sql
-- Dados Operacionais (Fases 3-6)
-- ═══════════════════════════════════════════════════════════════════════
-- Gerado em: {datetime.now().strftime('%Y-%m-%d %H:%M')}
-- Rodar APÓS: psql -f 01_INSERT_SEEDS.sql
-- Ordem de dependência FK respeitada
-- ═══════════════════════════════════════════════════════════════════════

BEGIN;
""")

    # ─── 1. COLABORADORES ───
    parts.append(header("1. COLABORADORES", "Fonte: fase_3/07_colaboradores.csv (87 registros)"))
    rows = read_csv("fase_3/07_colaboradores.csv")
    vals = []
    for r in rows:
        setor = r.get('sector', '').strip().lower()
        setor_map = {"agricola": "agricola", "ubg": "ubg", "administrativo": "administrativo", "pecuaria": "pecuaria", "experiencia": "experiencia"}
        setor_sql = setor_map.get(setor, 'agricola')
        contrato = r.get('contract_type', 'clt').strip().lower()
        contrato_map = {"clt": "clt", "informal": "informal", "temporario": "temporario", "safrista": "safrista"}
        contrato_sql = contrato_map.get(contrato, 'clt')
        status = r.get('status', 'ativo').strip().lower()
        status_sql = 'active' if status == 'ativo' else 'inactive'
        vals.append(f"({org_id()}, {esc(r.get('name'))}, {esc(r.get('cpf'))}, '{setor_sql}', {esc(r.get('role'))}, '{contrato_sql}', {esc_date(r.get('hire_date'))}, {esc_date(r.get('last_date'))}, '{status_sql}')")
    parts.append(batch_insert("colaboradores",
        ["organization_id", "nome", "cpf", "setor", "cargo", "tipo_contrato", "data_admissao", "data_demissao", "status"],
        vals, batch_size=100))

    # ─── 2. OPERADORES ───
    parts.append(header("2. OPERADORES", "Fonte: fase_3/05_operadores.csv (15 registros curados)"))
    rows = read_csv("fase_3/05_operadores.csv")
    for r in rows:
        status = 'active' if r.get('status', 'ativo').strip().lower() == 'ativo' else 'inactive'
        parts.append(f"""INSERT INTO operadores (
  organization_id, nome, cpf, status
) VALUES (
  {org_id()},
  {esc(r.get('nome'))}, {esc(r.get('cpf'))}, '{status}'
);
""")

    # ─── 3. MAQUINAS (57 total: 52 ativo + 5 vendido) + IMPLEMENTOS (126 total: 103 ativo + 23 vendido) ───
    parts.append(header("3. MAQUINAS", "Fonte: fase_3/04_maquinas.csv (57 maquinas: 52 ativo + 5 vendido)"))

    tipo_map = {
        "COLHEITADEIRA": "colheitadeira", "TRATOR": "trator",
        "PULVERIZADOR": "pulverizador", "PLANTADEIRA": "plantadeira",
        "CAMINHAO": "caminhao", "UTILITARIO": "utilitario",
        "DRONE": "drone", "IMPLEMENTO": "outros",
        "VEICULO LEVE": "utilitario", "VEICULO PESADO": "caminhao",
        "INDUSTRIAL": "outros", "MOTOCICLETA": "utilitario",
        "MOTOBOMBA": "outros", "MOTOR ELETRICO": "outros",
        "REBOQUE": "outros", "RODOVIARIO": "outros",
        "ACESSORIO": "outros", "3 PONTOS": "outros",
        "PLATAFORMA": "outros", "SEMEADORA": "outros",
        "FIXOS": "outros", "DIVERSOS": "outros",
    }

    # 3a. Maquinas
    rows = read_csv("fase_3/04_maquinas.csv")
    for r in rows:
        subtype = r.get('subtype', '').strip().upper()
        tipo_sql = tipo_map.get(subtype, 'outros')

        parts.append(f"""INSERT INTO maquinas (
  organization_id, codigo, nome, categoria, tipo, marca, ano_fabricacao,
  chassi, numero_serie, numero_motor,
  valor_compra, data_compra, valor_atual, nota_fiscal_compra,
  trator_vinculado_id, status
) VALUES (
  {org_id()},
  {esc(r.get('code'))}, {esc(r.get('name'))}, 'maquina', '{tipo_sql}', {esc(r.get('brand'))},
  {esc_int(r.get('manufacture_year'))},
  {esc(r.get('chassis'))}, {esc(r.get('serial_renavam'))}, {esc(r.get('engine_number'))},
  {esc_num(r.get('purchase_value'))}, {esc_date(r.get('purchase_date'))},
  {esc_num(r.get('current_value'))}, {esc(r.get('invoice_number'))},
  NULL, '{r.get('status', 'ativo').strip()}'
);
""")

    # 3b. Implementos
    parts.append(header("3b. IMPLEMENTOS", "Fonte: fase_3/04_implementos.csv (126 implementos: 103 ativo + 23 vendido)"))
    rows = read_csv("fase_3/04_implementos.csv")
    for r in rows:
        subtype = r.get('subtype', '').strip().upper()
        tipo_sql = tipo_map.get(subtype, 'outros')

        linked = r.get('linked_to_machine_code', '').strip()
        if linked:
            linked_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo = {esc(linked)} LIMIT 1)"
        else:
            linked_sql = "NULL"

        parts.append(f"""INSERT INTO maquinas (
  organization_id, codigo, nome, categoria, tipo, marca, ano_fabricacao,
  chassi, numero_serie, numero_motor,
  valor_compra, data_compra, valor_atual, nota_fiscal_compra,
  trator_vinculado_id, status
) VALUES (
  {org_id()},
  {esc(r.get('code'))}, {esc(r.get('name'))}, 'implemento', '{tipo_sql}', {esc(r.get('brand'))},
  {esc_int(r.get('manufacture_year'))},
  {esc(r.get('chassis'))}, NULL, NULL,
  {esc_num(r.get('purchase_value'))}, {esc_date(r.get('purchase_date'))},
  {esc_num(r.get('current_value'))}, {esc(r.get('invoice_number'))},
  {linked_sql}, '{r.get('status', 'ativo').strip()}'
);
""")

    # ─── 4. TAGS VESTRO ───
    parts.append(header("4. TAGS_VESTRO", "Fonte: fase_3/05_tags_maquinas_vestro.csv (47 registros)"))
    rows = read_csv("fase_3/05_tags_maquinas_vestro.csv")
    for r in rows:
        maq_code = r.get('codigo_maquinas', '').strip()
        if maq_code:
            maq_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo = {esc(maq_code)} LIMIT 1)"
        else:
            maq_sql = "NULL"
        parts.append(f"""INSERT INTO tags_vestro (
  organization_id, maquina_id, codigo_vestro, codigo_maquina_ref,
  nome_vestro, tag_rfid, tipo_medicao, combustivel_padrao,
  tipo_proprietario, empresa_vestro, ativo, status
) VALUES (
  {org_id()},
  {maq_sql},
  {esc(r.get('codigo'))}, {esc(r.get('codigo_maquinas'))},
  {esc(r.get('nome_vestro'))}, {esc(r.get('tag_rfid'))},
  {esc(r.get('tipo_medicao'))}, {esc(r.get('combustivel'))},
  {esc(r.get('tipo_proprietario'))}, {esc(r.get('empresa_vestro'))},
  {esc_bool(r.get('ativo'))}, 'active'
);
""")

    # ─── 5. FOLHA_PAGAMENTO ───
    parts.append(header("5. FOLHA_PAGAMENTO", "Fonte: fase_3/08_folha_pagamento.csv (3.122 registros)"))
    rows = read_csv("fase_3/08_folha_pagamento.csv")
    vals = []
    for r in rows:
        tipo = r.get('payroll_type', 'regular').strip().lower()
        tipo_map = {"regular": "regular", "adiantamento": "adiantamento", "rescisao": "rescisao", "ferias": "férias", "decimo_terceiro": "décimo_terceiro"}
        tipo_sql = tipo_map.get(tipo, 'regular')
        cpf = r.get('cpf', '').strip()
        if cpf:
            colab_sql = colaborador_id_by_cpf(cpf)
        else:
            colab_sql = "NULL"
        vals.append(f"({org_id()}, {colab_sql}, {esc_date(r.get('year_month'))}, '{tipo_sql}', {esc_num(r.get('gross_salary'))}, {esc_num(r.get('vacation_pay'))}, {esc_num(r.get('thirteenth_salary'))}, {esc_num(r.get('overtime_pay'))}, {esc_num(r.get('deductions'))}, {esc_num(r.get('additions'))}, {esc_num(r.get('net_salary'))}, {esc(r.get('notes'))})")
    parts.append(batch_insert("folha_pagamento",
        ["organization_id", "colaborador_id", "competencia", "tipo", "salario_bruto", "ferias", "decimo_terceiro", "horas_extras", "descontos", "adicional", "salario_liquido", "observacoes"],
        vals, batch_size=200))

    # ─── 6. ABASTECIMENTOS ───
    parts.append(header("6. ABASTECIMENTOS", "Fonte: fase_6/10_abastecimentos_vestro.csv (1.200 registros)"))
    rows = read_csv("fase_6/10_abastecimentos_vestro.csv")
    vals = []
    for r in rows:
        maq_code = r.get('machine_code_lookup', '').strip()
        if maq_code:
            maq_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo = {esc(maq_code)} LIMIT 1)"
        else:
            maq_sql = "NULL"
        fuel = r.get('fuel_type', 'Diesel S10').strip()
        fuel_map = {"Diesel S10": "diesel_s10", "Diesel S500": "diesel_s500", "Gasolina": "gasolina", "Etanol": "etanol", "ARLA32": "arla32"}
        fuel_sql = fuel_map.get(fuel, 'diesel_s10')
        vals.append(f"({org_id()}, {maq_sql}, NULL, {esc_date(r.get('supply_date'))}, '{fuel_sql}', {esc_num(r.get('volume_liters'))}, {esc_num(r.get('total_value'))}, {esc_num(r.get('unit_price'))}, {esc_num(r.get('odometer_km'))}, {esc(r.get('operator_name_lookup'))})")
    parts.append(batch_insert("abastecimentos",
        ["organization_id", "maquina_id", "operador_id", "data_abastecimento", "tipo_combustivel", "volume_litros", "valor_total", "preco_unitario", "hodometro_km", "observacoes"],
        vals, batch_size=200))

    # ─── 7. EXTRATOS_COOPERATIVA ───
    parts.append(header("7. EXTRATOS_COOPERATIVA", "Fonte: fase_4/07_castrolanda_extrato.csv (8.211 registros)"))
    rows = read_csv("fase_4/07_castrolanda_extrato.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo_transacao', 'outro').strip()
        tipo_map = {"compra": "compra", "venda": "venda", "juros": "juros", "multa": "multa", "taxa": "taxa", "saldo_anterior": "outro", "transferencia": "outro", "transferencia_conta_movimento": "outro", "credito": "outro", "debito": "outro"}
        tipo_sql = tipo_map.get(tipo, 'outro')
        vals.append(f"({org_id()}, {esc(r.get('matricula'))}, {esc(r.get('cooperado'))}, {esc(r.get('conta_codigo'))}, {esc(r.get('conta'))}, {esc_date(r.get('data'))}, {esc(r.get('descricao'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('saldo'))}, '{tipo_sql}', {esc(r.get('nf_referencia'))}, {esc(r.get('safra_ref'))})")
    parts.append(batch_insert("extratos_cooperativa",
        ["organization_id", "matricula_cooperativa", "cooperado_nome", "conta_codigo", "conta_descricao", "data_transacao", "descricao", "valor_debito", "valor_credito", "saldo", "tipo_transacao", "nf_referencia", "safra_referencia"],
        vals, batch_size=200))

    # ─── 8. CC_COOPERATIVA ───
    parts.append(header("8. CC_COOPERATIVA", "Fonte: fase_4/09_castrolanda_cc_completo.csv (2.889 registros)"))
    rows = read_csv("fase_4/09_castrolanda_cc_completo.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo_transacao', 'outro').strip()
        tipo_map = {"credito": "credito", "debito": "debito", "taxa": "taxa", "saldo_anterior": "outro", "transferencia_conta_movimento": "outro", "outro": "outro"}
        tipo_sql = tipo_map.get(tipo, 'outro')
        vals.append(f"({org_id()}, {esc_date(r.get('data'))}, {esc(r.get('descricao'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('saldo'))}, '{tipo_sql}')")
    parts.append(batch_insert("cc_cooperativa",
        ["organization_id", "data_transacao", "descricao", "valor_debito", "valor_credito", "saldo", "tipo_transacao"],
        vals, batch_size=200))

    # ─── 9. CONTAS_CAPITAL ───
    parts.append(header("9. CONTAS_CAPITAL", "Fonte: fase_4/12_castrolanda_capital_html.csv (77 registros)"))
    rows = read_csv("fase_4/12_castrolanda_capital_html.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo_transacao', 'outro').strip()
        tipo_map = {"capitalizacao": "capital_integralizado", "retencao": "capital_integralizado", "juros": "juros", "capital_integralizado": "capital_integralizado", "capital_retirado": "capital_retirado"}
        tipo_sql = tipo_map.get(tipo, 'outro')
        vals.append(f"({org_id()}, {esc(r.get('cooperado'))}, {esc(r.get('conta_codigo'))}, {esc(r.get('conta_descricao'))}, {esc_date(r.get('data'))}, {esc(r.get('historico'))}, {esc(r.get('descricao'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('saldo'))}, '{tipo_sql}', {esc(r.get('nf_referencia'))})")
    parts.append(batch_insert("contas_capital",
        ["organization_id", "cooperado_nome", "conta_codigo", "conta_descricao", "data_transacao", "historico", "descricao", "valor_debito", "valor_credito", "saldo", "tipo_transacao", "nf_referencia"],
        vals, batch_size=100))

    # ─── 10. FINANCIAMENTOS_COOP ───
    parts.append(header("10. FINANCIAMENTOS_COOP", "Fonte: fase_4/11_castrolanda_financiamentos.csv (220 registros)"))
    rows = read_csv("fase_4/11_castrolanda_financiamentos.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo_financiamento', 'outro').strip().upper()
        tipo_map = {"CUSTEIO": "custeio", "INVESTIMENTO": "investimento", "CAPITAL DE GIRO": "capital_giro"}
        tipo_sql = tipo_map.get(tipo, 'outro')
        vals.append(f"({org_id()}, {esc(r.get('num_contrato'))}, '{tipo_sql}', {esc_date(r.get('data'))}, {esc(r.get('historico'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('saldo'))})")
    parts.append(batch_insert("financiamentos_coop",
        ["organization_id", "numero_contrato", "tipo_financiamento", "data_movimento", "historico", "valor_credito", "valor_debito", "saldo"],
        vals, batch_size=200))

    # ─── 11. VENDAS_GRAO (Castrolanda) ───
    parts.append(header("11. VENDAS_GRAO (via Castrolanda)", "Fonte: fase_4/13_castrolanda_vendas.csv (170 registros)"))
    rows = read_csv("fase_4/13_castrolanda_vendas.csv")
    vals = []
    for r in rows:
        cultura = r.get('cultura', '').strip().lower()
        safra_code = r.get('safra', '').strip()
        # Convert safra format: "24/24" -> "2024/2025" etc.
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"

        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc_date(r.get('data'))}, {esc(r.get('num_venda'))}, {esc(r.get('nota_fiscal'))}, {esc(r.get('produto_nome'))}, {esc_num(r.get('peso_kg'))}, {esc_num(r.get('preco_saca'))}, {esc_num(r.get('valor_bruto'))}, {esc_num(r.get('desconto_bordero'))}, {esc_num(r.get('valor_nota'))}, {esc_num(r.get('valor_credito'))}, {esc_date(r.get('data_credito'))}, {esc(r.get('contrato'))}, {esc(r.get('armazem'))}, {esc(r.get('filial'))})")
    parts.append(batch_insert("vendas_grao",
        ["organization_id", "safra_id", "cultura_id", "data_venda", "numero_venda", "nota_fiscal", "produto_nome", "peso_kg", "preco_saca", "valor_bruto", "desconto_bordero", "valor_nota", "valor_credito", "data_credito", "contrato_referencia", "armazem", "filial"],
        vals, batch_size=200))

    # ─── 12. VENDAS_DIRETAS ───
    parts.append(header("12. VENDAS_DIRETAS", "Fonte: fase_6_operacoes/05b_vendas_diretas.csv (73 registros)"))
    rows = read_csv("fase_6_operacoes/05b_vendas_diretas.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc_date(r.get('sale_date'))}, {esc(r.get('nfe_number'))}, {esc(r.get('buyer'))}, {esc(r.get('bean_type'))}, {esc_num(r.get('quantity_kg'))}, {esc_num(r.get('unit_price'))}, {esc_num(r.get('total_value'))}, {esc_num(r.get('senar_tax'))}, {esc_num(r.get('net_total'))}, {esc_date(r.get('payment_date'))}, {esc(r.get('notes'))})")
    parts.append(batch_insert("vendas_diretas",
        ["organization_id", "safra_id", "cultura_id", "data_venda", "nfe_numero", "comprador", "tipo_grao", "quantidade_kg", "preco_unitario", "valor_total", "imposto_senar", "valor_liquido", "data_pagamento", "observacoes"],
        vals, batch_size=100))

    # ─── 13. VENDAS_GRAO (Castrolanda via vendas_castrolanda CSV) ───
    parts.append(header("13. VENDAS_GRAO (via vendas_castrolanda agrícola)", "Fonte: fase_6_operacoes/05a_vendas_castrolanda.csv (13 registros)"))
    rows = read_csv("fase_6_operacoes/05a_vendas_castrolanda.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc_date(r.get('sale_date'))}, {esc(r.get('sale_number'))}, NULL, {esc(r.get('buyer'))}, {esc_num(r.get('weight_kg'))}, {esc_num(r.get('price_per_sack'))}, {esc_num(r.get('gross_value'))}, {esc_num(r.get('bordero_discount'))}, {esc_num(r.get('invoice_value'))}, {esc_num(r.get('credit_value'))}, {esc_date(r.get('credit_date'))}, {esc(r.get('contract'))}, {esc(r.get('warehouse'))}, {esc(r.get('branch'))})")
    if vals:
        parts.append(batch_insert("vendas_grao",
            ["organization_id", "safra_id", "cultura_id", "data_venda", "numero_venda", "nota_fiscal", "comprador", "peso_kg", "preco_saca", "valor_bruto", "desconto_bordero", "valor_nota", "valor_credito", "data_credito", "contrato_referencia", "armazem", "filial"],
            vals, batch_size=100))

    # ─── 14. CARGAS_A_CARGA ───
    parts.append(header("14. CARGAS_A_CARGA", "Fonte: fase_4/14_castrolanda_carga_a_carga.csv (1.337 registros)"))
    rows = read_csv("fase_4/14_castrolanda_carga_a_carga.csv")
    vals = []
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 7:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        qj = r.get('qualidade_json', '').strip()
        if qj:
            qj_sql = esc(qj)
        else:
            qj_sql = "NULL"
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc(r.get('produto_codigo'))}, {esc(r.get('produto_nome'))}, {esc(r.get('cultivar'))}, {esc(r.get('num_docto'))}, {esc(r.get('nota_fiscal'))}, {esc_date(r.get('data'))}, {esc_num(r.get('peso_bruto_kg'))}, {esc_num(r.get('peso_liquido_kg'))}, {esc(r.get('placa'))}, {esc(r.get('motorista'))}, {qj_sql})")
    parts.append(batch_insert("cargas_a_carga",
        ["organization_id", "safra_id", "cultura_id", "produto_codigo", "produto_nome", "cultivar", "numero_documento", "nota_fiscal", "data_carga", "peso_bruto_kg", "peso_liquido_kg", "placa_veiculo", "motorista", "qualidade_json"],
        vals, batch_size=200))

    # ─── 15. CUSTOS_INSUMO_COOP ───
    parts.append(header("15. CUSTOS_INSUMO_COOP", "Fonte: fase_6_operacoes/06_custo_insumos_castrolanda.csv (553 registros)"))
    rows = read_csv("fase_6_operacoes/06_custo_insumos_castrolanda.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc(r.get('category'))}, {esc(r.get('product_name'))}, {esc(r.get('product_code'))}, {esc(r.get('unit'))}, {esc_date(r.get('issue_date'))}, {esc(r.get('invoice_number'))}, {esc_num(r.get('quantity'))}, {esc_num(r.get('unit_price'))}, {esc_num(r.get('total_value'))})")
    parts.append(batch_insert("custos_insumo_coop",
        ["organization_id", "safra_id", "cultura_id", "categoria", "produto_nome", "produto_codigo", "unidade", "data_emissao", "nota_fiscal", "quantidade", "preco_unitario", "valor_total"],
        vals, batch_size=200))

    # ─── 16. FRETEIROS ───
    parts.append(header("16. FRETEIROS", "Fonte: fase_6_operacoes/07_freteiros.csv (116 registros)"))
    rows = read_csv("fase_6_operacoes/07_freteiros.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {esc(r.get('driver_name'))}, {esc_date(r.get('trip_date'))}, {esc(r.get('truck_plate'))}, {esc(r.get('product'))}, {esc(r.get('origin'))}, {esc(r.get('destination'))}, {esc_num(r.get('weight_kg'))}, {esc_num(r.get('rate_per_ton'))}, {esc_num(r.get('freight_value'))})")
    parts.append(batch_insert("freteiros",
        ["organization_id", "safra_id", "motorista", "data_viagem", "placa_veiculo", "produto", "origem", "destino", "peso_kg", "tarifa_por_ton", "valor_frete"],
        vals, batch_size=200))

    # ─── 17. PRODUCAO_UBG / TICKET_BALANCAS ───
    parts.append(header("17. TICKET_BALANCAS + PRODUCAO_UBG", "Fonte: fase_6/09_producao_ubg.csv (883 registros)"))
    rows = read_csv("fase_6/09_producao_ubg.csv")
    vals_ticket = []
    vals_produbg = []
    for r in rows:
        safra_code = r.get('season_code', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('culture_name_lookup', '').strip().lower()

        # TICKET_BALANCAS
        vals_ticket.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, NULL, NULL, {esc_date(r.get('weigh_date'))}, {esc(r.get('weigh_time'))}, {esc(r.get('talhao_name'))}, {esc(r.get('gleba'))}, {esc(r.get('destination'))}, {esc(r.get('ticket_variety'))}, {esc(r.get('driver_name'))}, {esc(r.get('truck_plate'))}, {esc_num(r.get('gross_weight_kg'))}, {esc_num(r.get('tare_weight_kg'))}, {esc_num(r.get('net_weight_kg'))}, {esc_num(r.get('moisture_pct'))}, {esc_num(r.get('ph'))}, {esc_num(r.get('impurity_pct'))}, {esc_num(r.get('charred_pct'))}, {esc_num(r.get('damaged_pct'))}, {esc_num(r.get('green_pct'))}, {esc_num(r.get('broken_pct'))}, {esc_num(r.get('discount_kg'))}, {esc_num(r.get('final_weight_kg'))}, 'entrada_producao', 'pesado')")

    parts.append(batch_insert("ticket_balancas",
        ["organization_id", "safra_id", "cultura_id", "talhao_safra_id", "silo_destino_id", "data_pesagem", "hora_pesagem", "talhao_nome_ref", "gleba", "destino", "variedade", "motorista", "placa_veiculo", "peso_bruto_kg", "tara_kg", "peso_liquido_kg", "umidade_pct", "ph", "impureza_pct", "ardidos_pct", "avariados_pct", "verdes_pct", "quebrados_pct", "desconto_kg", "peso_final_kg", "tipo", "status"],
        vals_ticket, batch_size=200))

    # ─── 18. PESAGENS_AGRICOLA ───
    parts.append(header("18. PESAGENS_AGRICOLA", "Fonte: fase_6_operacoes/04_pesagens_agricola.csv (806 registros)"))
    rows = read_csv("fase_6_operacoes/04_pesagens_agricola.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        flag_semente = esc_bool(r.get('flag_semente', 'False'))
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc(r.get('talhao_nome'))}, {esc_date(r.get('data'))}, {esc(r.get('hora'))}, {esc(r.get('gleba'))}, {esc(r.get('destino'))}, {esc(r.get('placa'))}, {esc(r.get('motorista'))}, {esc_num(r.get('bruto_kg'))}, {esc_num(r.get('tara_kg'))}, {esc_num(r.get('liquido_kg'))}, {esc_num(r.get('umidade_pct'))}, {esc_num(r.get('ph'))}, {esc_num(r.get('impureza_g'))}, {esc_num(r.get('ardidos_g'))}, {esc_num(r.get('avariado_g'))}, {esc_num(r.get('verdes_g'))}, {esc_num(r.get('quebrado_g'))}, {esc_num(r.get('desconto_kg'))}, {esc_num(r.get('peso_final_kg'))}, {esc(r.get('variedade'))}, {flag_semente})")
    parts.append(batch_insert("pesagens_agricola",
        ["organization_id", "safra_id", "cultura_id", "talhao_nome_ref", "data_pesagem", "hora_pesagem", "gleba", "destino", "placa_veiculo", "motorista", "peso_bruto_kg", "tara_kg", "peso_liquido_kg", "umidade_pct", "ph", "impureza_g", "ardidos_g", "avariados_g", "verdes_g", "quebrados_g", "desconto_kg", "peso_final_kg", "variedade", "flag_semente"],
        vals, batch_size=200))

    # ─── 19. SAIDAS_GRAO ───
    parts.append(header("19. SAIDAS_GRAO", "Fonte: fase_6_operacoes/08_saidas_producao.csv (542 registros)"))
    rows = read_csv("fase_6_operacoes/08_saidas_producao.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc(r.get('contract_code'))}, {esc(r.get('contract_description'))}, {esc_date(r.get('ship_date'))}, {esc(r.get('ship_time'))}, {esc(r.get('origin'))}, {esc(r.get('destination'))}, {esc(r.get('carrier'))}, {esc(r.get('driver'))}, {esc(r.get('plate'))}, {esc_num(r.get('gross_weight_kg'))}, {esc_num(r.get('tare_weight_kg'))}, {esc_num(r.get('net_weight_kg'))}, {esc_num(r.get('moisture_pct'))}, {esc_num(r.get('coop_discount_kg'))}, {esc_num(r.get('final_weight_kg'))})")
    parts.append(batch_insert("saidas_grao",
        ["organization_id", "safra_id", "cultura_id", "contrato_codigo", "contrato_descricao", "data_saida", "hora_saida", "origem", "destino", "transportadora", "motorista", "placa_veiculo", "peso_bruto_kg", "tara_kg", "peso_liquido_kg", "umidade_pct", "desconto_coop_kg", "peso_final_kg"],
        vals, batch_size=200))

    # ─── 20. UBG_CAIXA ───
    parts.append(header("20. UBG_CAIXA", "Fonte: fase_6/14_ubg_caixa.csv (19.325 registros)"))
    rows = read_csv("fase_6/14_ubg_caixa.csv")
    vals = []
    for r in rows:
        vals.append(f"({org_id()}, {esc(r.get('arquivo'))}, {esc_int(r.get('ano'))}, {esc_int(r.get('mes'))}, {esc_date(r.get('data'))}, {esc(r.get('produto'))}, {esc_num(r.get('qtde'))}, {esc(r.get('descricao'))}, {esc(r.get('comprador'))}, {esc(r.get('localidade'))}, {esc(r.get('forma_pgto'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('saldo'))}, {esc(r.get('tipo'))})")
    parts.append(batch_insert("ubg_caixa",
        ["organization_id", "arquivo_origem", "ano", "mes", "data", "produto", "quantidade", "descricao", "comprador", "localidade", "forma_pagamento", "credito", "debito", "saldo", "tipo"],
        vals, batch_size=500))

    parts.append("""
COMMIT;

-- ═══════════════════════════════════════════════════════════════════════
-- FIM — 02_INSERT_DADOS.sql
-- Total: ~37.000 registros inseridos
-- ═══════════════════════════════════════════════════════════════════════
""")

    return "".join(parts)


# ═══════════════════════════════════════════════════════════════════════════
# MAIN
# ═══════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    print("Gerando 01_INSERT_SEEDS.sql ...")
    sql1 = gen_seeds()
    out1 = OUT_DIR / "01_INSERT_SEEDS.sql"
    with open(out1, "w", encoding="utf-8") as f:
        f.write(sql1)
    lines1 = sql1.count('\n')
    print(f"  -> {out1} ({lines1} linhas)")

    print("Gerando 02_INSERT_DADOS.sql ...")
    sql2 = gen_dados()
    out2 = OUT_DIR / "02_INSERT_DADOS.sql"
    with open(out2, "w", encoding="utf-8") as f:
        f.write(sql2)
    lines2 = sql2.count('\n')
    print(f"  -> {out2} ({lines2} linhas)")

    print(f"\nTotal: {lines1 + lines2} linhas SQL geradas")
    print("Pronto! João pode rodar:")
    print("  psql -f 00_DDL_COMPLETO_V0.sql")
    print("  psql -f 01_INSERT_SEEDS.sql")
    print("  psql -f 02_INSERT_DADOS.sql")
