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
    return "(SELECT organization_id FROM organizations WHERE nome = 'Serra da Onça Agropecuária' LIMIT 1)"

def fazenda_id(name):
    """Subquery for fazenda_id by nome."""
    n = name.replace("'", "''")
    return f"(SELECT fazenda_id FROM fazendas WHERE nome = '{n}' LIMIT 1)"

def safra_id(code):
    """Subquery for safra_id by ano_agricola."""
    c = str(code).strip().replace("'", "''")
    return f"(SELECT safra_id FROM safras WHERE ano_agricola = '{c}' LIMIT 1)"

def cultura_id(name):
    """Subquery for cultura_id by nome."""
    n = str(name).strip().lower().replace("'", "''")
    return f"(SELECT cultura_id FROM culturas WHERE nome = '{n}' LIMIT 1)"

def maquina_id_by_code(code):
    """Subquery for maquina_id by codigo_interno."""
    c = str(code).strip().replace("'", "''")
    return f"(SELECT maquina_id FROM maquinas WHERE codigo_interno = '{c}' LIMIT 1)"

def colaborador_id_by_cpf(cpf):
    """Subquery for colaborador_id by cpf."""
    c = str(cpf).strip().replace("'", "''")
    return f"(SELECT colaborador_id FROM colaboradores WHERE cpf = '{c}' LIMIT 1)"

def operador_id_by_nome(nome):
    """Subquery for operador_id by nome."""
    n = str(nome).strip().replace("'", "''")
    return f"(SELECT operador_id FROM operadores WHERE UPPER(nome) = UPPER('{n}') LIMIT 1)"

def silo_id_by_codigo(codigo):
    """Subquery for silo_id by codigo (S1, S2, etc.)."""
    c = str(codigo).strip().replace("'", "''")
    return f"(SELECT silo_id FROM silos WHERE codigo = '{c}' LIMIT 1)"

def talhao_id_by_nome(nome):
    """Subquery for talhao_id by nome."""
    n = str(nome).strip().replace("'", "''")
    return f"(SELECT talhao_id FROM talhoes WHERE UPPER(nome) = UPPER('{n}') LIMIT 1)"

def talhao_safra_id_sub(safra_code, talhao_nome, cultura_nome, epoca='safra', gleba=None):
    """Subquery for talhao_safra_id by composite key (safra+talhao+cultura+epoca+gleba)."""
    sc = str(safra_code).strip().replace("'", "''")
    tn = str(talhao_nome).strip().replace("'", "''")
    cn = str(cultura_nome).strip().lower().replace("'", "''")
    ep = str(epoca).strip().replace("'", "''")
    gleba_clause = ""
    if gleba and gleba.strip():
        g = gleba.strip().replace("'", "''")
        gleba_clause = f" AND UPPER(ts.gleba) = UPPER('{g}')"
    else:
        gleba_clause = " AND ts.gleba IS NULL"
    return (f"(SELECT ts.talhao_safra_id FROM talhao_safras ts"
            f" JOIN safras s ON ts.safra_id = s.safra_id"
            f" JOIN talhoes t ON ts.talhao_id = t.talhao_id"
            f" JOIN culturas c ON ts.cultura_id = c.cultura_id"
            f" WHERE s.ano_agricola = '{sc}'"
            f" AND UPPER(t.nome) = UPPER('{tn}')"
            f" AND LOWER(c.nome) = '{cn}'"
            f" AND ts.epoca = '{ep}'"
            f"{gleba_clause}"
            f" LIMIT 1)")

def safra_acao_id_sub(safra_code, talhao_nome, cultura_nome, epoca, tipo, titulo):
    """Subquery for safra_acao_id by composite key within a talhao_safra."""
    sc = str(safra_code).strip().replace("'", "''")
    tn = str(talhao_nome).strip().replace("'", "''")
    cn = str(cultura_nome).strip().lower().replace("'", "''")
    ep = str(epoca).strip().replace("'", "''")
    tp = str(tipo).strip().replace("'", "''")
    tt = str(titulo).strip().replace("'", "''")
    return (f"(SELECT sa.safra_acao_id FROM safra_acoes sa"
            f" JOIN talhao_safras ts ON sa.talhao_safra_id = ts.talhao_safra_id"
            f" JOIN safras s ON ts.safra_id = s.safra_id"
            f" JOIN talhoes t ON ts.talhao_id = t.talhao_id"
            f" JOIN culturas c ON ts.cultura_id = c.cultura_id"
            f" WHERE s.ano_agricola = '{sc}'"
            f" AND UPPER(t.nome) = UPPER('{tn}')"
            f" AND LOWER(c.nome) = '{cn}'"
            f" AND ts.epoca = '{ep}'"
            f" AND sa.tipo = '{tp}'"
            f" AND sa.titulo = '{tt}'"
            f" LIMIT 1)")

def normalize_safra_code(safra_code):
    """Normalize safra code: '25/26' stays as-is (seeds use this format)."""
    sc = str(safra_code).strip()
    # CSVs use short format like '25/26' which matches safras.ano_agricola
    return sc

def produto_insumo_id_by_nome(nome):
    """Subquery for produto_insumo_id by nome."""
    n = str(nome).strip().replace("'", "''")
    return f"(SELECT produto_insumo_id FROM produto_insumo WHERE UPPER(nome) = UPPER('{n}') LIMIT 1)"

def header(title, note=""):
    """Section header."""
    lines = [f"\n-- {'='*70}", f"-- {title}", f"-- {'='*70}"]
    if note:
        lines.append(f"-- {note}")
    return "\n".join(lines) + "\n"

def batch_insert(table, columns, rows_sql, batch_size=500, on_conflict=""):
    """Generate batch INSERT statements. on_conflict adds ON CONFLICT clause."""
    lines = []
    conflict_clause = f"\n  {on_conflict}" if on_conflict else ""
    for i in range(0, len(rows_sql), batch_size):
        batch = rows_sql[i:i+batch_size]
        cols = ", ".join(columns)
        vals = ",\n  ".join(batch)
        lines.append(f"INSERT INTO {table} ({cols}) VALUES\n  {vals}{conflict_clause};\n")
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
    parts.append("""INSERT INTO admins (nome, email, status) VALUES
  ('System Admin', 'admin@deepwork.ai', 'active');
""")

    # ─── 2. OWNERS ───
    parts.append(header("2. OWNERS (seed manual)"))
    parts.append("""INSERT INTO owners (admin_id, nome, email, cpf, telefone, status) VALUES
  ((SELECT admin_id FROM admins WHERE email = 'admin@deepwork.ai'),
   'Claudio Kugler', NULL, NULL, NULL, 'active');
""")

    # ─── 3. ORGANIZATIONS ───
    parts.append(header("3. ORGANIZATIONS", "Fonte: fase_1_sistema/01_organizations.csv"))
    rows = read_csv("fase_1_sistema/01_organizations.csv")
    for r in rows:
        parts.append(f"""INSERT INTO organizations (
  owner_id, nome, nome_fantasia, cnpj, inscricao_estadual,
  endereco, municipio, uf, telefone, status
) VALUES (
  (SELECT owner_id FROM owners WHERE nome = 'Claudio Kugler'),
  {esc(r.get('name'))}, {esc(r.get('razao_social'))}, {esc(r.get('cnpj'))}, {esc(r.get('inscricao_estadual'))},
  {esc((r.get('logradouro','') + ' ' + r.get('numero','')).strip())},
  {esc(r.get('city'))}, {esc(r.get('state'))}, {esc(r.get('phone'))}, 'active'
);
""")

    # ─── 4. USERS ───
    parts.append(header("4. USERS", "Fonte: fase_1_sistema/02_users.csv"))
    rows = read_csv("fase_1_sistema/02_users.csv")
    for r in rows:
        role = r.get('role', 'MEMBER').strip().upper()
        nome = f"{r.get('first_name', '')} {r.get('last_name', '')}".strip()
        parts.append(f"""INSERT INTO users (
  organization_id, nome, email, cargo, telefone, status
) VALUES (
  {org_id()},
  {esc(nome)}, {esc(r.get('email'))},
  {esc(role)}, {esc(r.get('phone'))}, 'active'
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
        ["nome", "nome_exibicao", "grupo", "unidade_colheita"], vals))

    # ─── 6. SAFRAS ───
    parts.append(header("6. SAFRAS", "Fonte: fase_2/01_safras.csv"))
    rows = read_csv("fase_2/01_safras.csv")
    for r in rows:
        status_map = {"HISTORICAL": "encerrada", "ACTIVE": "em_andamento", "PLANNED": "planejamento"}
        status = status_map.get(r.get('status',''), 'planejamento')
        parts.append(f"""INSERT INTO safras (
  organization_id, ano_agricola, descricao,
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
  organization_id, nome, cnpj, municipio, uf, area_total_ha, area_agricola_ha,
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
  organization_id, fazenda_id, nome, area_ha, status
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
  fazenda_id, numero_matricula, descricao, area_ha, titular,
  data_aquisicao, proprietario_anterior,
  data_incorporacao_soal, observacoes, status
) VALUES (
  {fazenda_id(faz)},
  {esc(r.get('numero_matricula'))}, {esc(r.get('descricao'))}, {esc_num(r.get('area_ha'))}, {esc(r.get('proprietario_atual'))},
  {esc_date(r.get('data_aquisicao'))}, {esc(r.get('proprietario_anterior'))},
  {esc_date(r.get('data_incorporacao_soal'))}, {esc(r.get('observacoes'))}, 'active'
);
""")

    # ─── 10. SILOS ───
    parts.append(header("10. SILOS", "Fonte: fase_2_territorial/02_silos_ubg.csv (8 registros)"))
    rows = read_csv("fase_2_territorial/02_silos_ubg.csv")
    for r in rows:
        # Silos are at FAZENDA SANTANA DO IAPO (UBG location)
        tipo_map = {"CONVENCIONAL": "metalico", "PULMAO": "pulmao"}
        tipo = tipo_map.get(r.get('tipo',''), 'metalico')
        parts.append(f"""INSERT INTO silos (
  organization_id, fazenda_id, nome, codigo, tipo,
  capacidade_ton, formato_fundo, elevado, status
) VALUES (
  {org_id()},
  {fazenda_id('FAZENDA SANTANA DO IAPO')},
  {esc(r.get('nome'))}, {esc(str(r.get('numero_silo','')))}, '{tipo}',
  {esc_num(r.get('capacidade_toneladas'))}, {esc(r.get('formato_fundo'))}, {esc_bool(r.get('elevado'))}, 'active'
);
""")

    # ─── 11. UBGS ───
    parts.append(header("11. UBGS", "Fonte: fase_2_territorial/01_ubg.csv"))
    rows = read_csv("fase_2_territorial/01_ubg.csv")
    for r in rows:
        faz = r.get('fazenda_sede', '').strip()
        parts.append(f"""INSERT INTO ubgs (
  organization_id, fazenda_sede_id, nome,
  capacidade_recepcao_t_h, capacidade_secagem_t_h,
  tem_balanca, tem_tombador, tem_secador,
  software_ubg, responsavel_tecnico, crea_responsavel,
  latitude, longitude, status, observacoes
) VALUES (
  {org_id()},
  {fazenda_id(faz)},
  {esc(r.get('nome'))},
  {esc_num(r.get('capacidade_recepcao_t_h'))}, {esc_num(r.get('capacidade_secagem_t_h'))},
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
        # tipo already comes as Postgres array literal from ETL: {fornecedor}, {fornecedor,cliente}, {} etc.
        tipo_raw = r.get('tipo', '').strip()
        tipo_arr = f"'{tipo_raw}'" if tipo_raw else "'{}'"
        tipo_doc = r.get('tipo_documento', '').strip()
        is_active = str(r.get('is_active', 'True')).lower() == 'true'
        status = 'active' if is_active else 'inactive'
        vals.append(f"({org_id()}, {esc(r.get('razao_social'))}, {esc(r.get('nome_fantasia'))}, {esc(r.get('cpf_cnpj'))}, {esc(tipo_doc) if tipo_doc else 'NULL'}, {tipo_arr}, {esc(r.get('telefone'))}, {esc(r.get('municipio'))}, {esc(r.get('uf'))}, '{status}')")
    parts.append(batch_insert("parceiros_comerciais",
        ["organization_id", "razao_social", "nome_fantasia", "cpf_cnpj", "tipo_documento", "tipo", "telefone", "municipio", "uf", "status"],
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
        vals.append(f"({org_id()}, {esc(r.get('name'))}, '{tipo_sql}', '{grupo_sql}', {esc(r.get('unidade_medida'))}, {is_active})")

    parts.append(batch_insert("produto_insumo",
        ["organization_id", "nome", "tipo", "grupo", "unidade_medida", "ativo"],
        vals, batch_size=200))

    # ─── 14b. PRODUTO_INSUMO (Castrolanda) ───
    parts.append(header("14b. PRODUTO_INSUMO (Castrolanda)", "Fonte: fase_0/03_produto_insumo_castrolanda.csv (395 registros)"))
    rows_cast = read_csv("fase_0/03_produto_insumo_castrolanda.csv")
    # Map CSV tipo to ENUM tipo_insumo
    tipo_map_cast = {
        "fungicida": "fungicida",
        "semente": "semente",
        "herbicida": "herbicida",
        "inseticida": "inseticida",
        "adubo_foliar": "fertilizante",
        "fertilizante": "fertilizante",
        "adjuvante": "adjuvante",
        "inoculante": "biologico",
        "embalagem": "outros",
        "outros": "outros",
    }
    vals_cast = []
    for r in rows_cast:
        tipo_csv = r.get('tipo', '').strip()
        tipo_sql = tipo_map_cast.get(tipo_csv, 'outros')
        grupo_sql = r.get('grupo', 'agricola').strip().lower()
        is_active = esc_bool(r.get('ativo', 'True'))
        vals_cast.append(f"({org_id()}, {esc(r.get('codigo'))}, {esc(r.get('nome'))}, '{tipo_sql}', '{grupo_sql}', {esc(r.get('unidade_medida'))}, {is_active})")

    parts.append(batch_insert("produto_insumo",
        ["organization_id", "codigo", "nome", "tipo", "grupo", "unidade_medida", "ativo"],
        vals_cast, batch_size=200))

    # ─── 15. TEMPLATE_CULTURA_OPERACOES (Doc 32) ───
    parts.append(header("15. TEMPLATE_CULTURA_OPERACOES (Doc 32)", "Fonte: fase_5/02_template_operacoes_cultura.csv (42 templates, 6 culturas)"))
    rows = read_csv("fase_5/02_template_operacoes_cultura.csv")
    cultura_name_map = {
        'soja': 'Soja', 'milho': 'Milho', 'feijao': 'Feijão', 'trigo': 'Trigo',
        'cevada': 'Cevada', 'aveia_preta': 'Aveia Preta',
    }
    vals = []
    for r in rows:
        cultura_csv = r.get('cultura', '').strip()
        cultura_nome = cultura_name_map.get(cultura_csv, cultura_csv)
        cultura_sub = f"(SELECT cultura_id FROM culturas WHERE nome = '{cultura_nome}' LIMIT 1)"
        vals.append(f"({org_id()}, {cultura_sub}, '{r['tipo_operacao']}', {esc(r['nome_operacao'])}, {esc(r.get('fase'))}, {esc_int(r['dias_offset_inicio'])}, {esc_int(r['duracao_dias'])}, {esc_int(r['sequencia'])}, {esc_bool(r['obrigatoria'])})")
    parts.append(batch_insert("template_cultura_operacoes",
        ["organization_id", "cultura_id", "tipo_operacao", "nome_operacao", "fase", "dias_offset_inicio", "duracao_dias", "sequencia", "obrigatoria"],
        vals))

    # ─── 16. RBAC: ROLES ───
    parts.append(header("16. RBAC: ROLES", "5 roles para V0"))
    parts.append(f"""INSERT INTO roles (organization_id, nome, descricao) VALUES
  ({org_id()}, 'admin', 'Acesso total ao sistema (DeepWork AI)'),
  ({org_id()}, 'agronomo', 'Planejamento safra, operações campo, receituários'),
  ({org_id()}, 'operador_campo', 'Execução operações, abastecimentos, maquinário'),
  ({org_id()}, 'operador_ubg', 'Balança, secagem, silos, saídas'),
  ({org_id()}, 'administrativo', 'Financeiro, NFs, contas a pagar/receber');
""")

    # ─── 17. RBAC: PERMISSIONS ───
    parts.append(header("17. RBAC: PERMISSIONS", "CRUD para módulos principais"))
    modules = ['safra', 'operacao_campo', 'insumo', 'maquina', 'ubg', 'financeiro', 'usuario', 'relatorio']
    actions = ['criar', 'ler', 'editar', 'deletar']
    perm_vals = []
    for mod in modules:
        for act in actions:
            perm_vals.append(f"('{mod}', '{act}')")
    parts.append(batch_insert("permissions", ["recurso", "acao"], perm_vals,
        on_conflict="ON CONFLICT (recurso, acao) DO NOTHING"))

    # ─── 18. RBAC: ROLE_PERMISSIONS ───
    parts.append(header("18. RBAC: ROLE_PERMISSIONS", "admin=tudo, outros=módulos específicos"))

    def role_sub(nome):
        return f"(SELECT role_id FROM roles WHERE nome = '{nome}' AND organization_id = {org_id()} LIMIT 1)"
    def perm_sub(recurso, acao):
        return f"(SELECT permission_id FROM permissions WHERE recurso = '{recurso}' AND acao = '{acao}' LIMIT 1)"

    # admin gets all permissions
    rp_vals = []
    for mod in modules:
        for act in actions:
            rp_vals.append(f"({role_sub('admin')}, {perm_sub(mod, act)})")

    # agronomo: safra, operacao_campo, insumo, relatorio (all CRUD)
    for mod in ['safra', 'operacao_campo', 'insumo', 'relatorio']:
        for act in actions:
            rp_vals.append(f"({role_sub('agronomo')}, {perm_sub(mod, act)})")

    # operador_campo: operacao_campo CRUD, maquina ler/editar, relatorio ler
    for act in actions:
        rp_vals.append(f"({role_sub('operador_campo')}, {perm_sub('operacao_campo', act)})")
    for act in ['ler', 'editar']:
        rp_vals.append(f"({role_sub('operador_campo')}, {perm_sub('maquina', act)})")
    rp_vals.append(f"({role_sub('operador_campo')}, {perm_sub('relatorio', 'ler')})")

    # operador_ubg: ubg CRUD, relatorio ler
    for act in actions:
        rp_vals.append(f"({role_sub('operador_ubg')}, {perm_sub('ubg', act)})")
    rp_vals.append(f"({role_sub('operador_ubg')}, {perm_sub('relatorio', 'ler')})")

    # administrativo: financeiro CRUD, relatorio CRUD, usuario ler
    for act in actions:
        rp_vals.append(f"({role_sub('administrativo')}, {perm_sub('financeiro', act)})")
        rp_vals.append(f"({role_sub('administrativo')}, {perm_sub('relatorio', act)})")
    rp_vals.append(f"({role_sub('administrativo')}, {perm_sub('usuario', 'ler')})")

    parts.append(batch_insert("role_permissions", ["role_id", "permission_id"], rp_vals,
        on_conflict="ON CONFLICT (role_id, permission_id) DO NOTHING"))

    # ─── 19. RBAC: USER_ROLES ───
    parts.append(header("19. RBAC: USER_ROLES", "Vincular 8 users aos roles corretos"))

    def user_sub(nome_like):
        return f"(SELECT user_id FROM users WHERE nome ILIKE '%{nome_like}%' LIMIT 1)"

    ur_vals = [
        f"({user_sub('Rodrigo')}, {role_sub('admin')})",
        f"({user_sub('João Vitor')}, {role_sub('admin')})",
        f"({user_sub('Claudio')}, {role_sub('admin')})",
        f"({user_sub('Tiago')}, {role_sub('operador_campo')})",
        f"({user_sub('Alessandro')}, {role_sub('agronomo')})",
        f"({user_sub('Josmar')}, {role_sub('operador_ubg')})",
        f"({user_sub('Vanessa')}, {role_sub('operador_ubg')})",
        f"({user_sub('Valentina')}, {role_sub('administrativo')})",
    ]
    parts.append(batch_insert("user_roles", ["user_id", "role_id"], ur_vals,
        on_conflict="ON CONFLICT (user_id, role_id) DO NOTHING"))

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
    parts.append(header("1. COLABORADORES", "Fonte: fase_3/07_colaboradores.csv (82 registros)"))
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
        ["organization_id", "nome", "cpf", "setor", "funcao", "tipo_contrato", "data_admissao", "data_desligamento", "status"],
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
  organization_id, codigo_interno, nome, categoria, tipo, marca, ano_fabricacao,
  chassi, numero_serie,
  valor_compra, data_compra, valor_atual, nota_fiscal_compra,
  trator_vinculado_id, status
) VALUES (
  {org_id()},
  {esc(r.get('code'))}, {esc(r.get('name'))}, 'maquina', '{tipo_sql}', {esc(r.get('brand'))},
  {esc_int(r.get('manufacture_year'))},
  {esc(r.get('chassis'))}, {esc(r.get('serial_renavam'))},
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
            linked_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo_interno = {esc(linked)} LIMIT 1)"
        else:
            linked_sql = "NULL"

        parts.append(f"""INSERT INTO maquinas (
  organization_id, codigo_interno, nome, categoria, tipo, marca, ano_fabricacao,
  chassi, numero_serie,
  valor_compra, data_compra, valor_atual, nota_fiscal_compra,
  trator_vinculado_id, status
) VALUES (
  {org_id()},
  {esc(r.get('code'))}, {esc(r.get('name'))}, 'implemento', '{tipo_sql}', {esc(r.get('brand'))},
  {esc_int(r.get('manufacture_year'))},
  {esc(r.get('chassis'))}, NULL,
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
            maq_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo_interno = {esc(maq_code)} LIMIT 1)"
        else:
            maq_sql = "NULL"
        parts.append(f"""INSERT INTO tags_vestro (
  organization_id, maquina_id, codigo, codigo_maquinas,
  nome_vestro, tag_rfid, tipo_medicao, combustivel,
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
        ["organization_id", "colaborador_id", "ano_mes", "tipo_folha", "salario_bruto", "ferias_pf", "decimo_terceiro", "horas_extras", "descontos", "acrescimos", "total_liquido", "observacoes"],
        vals, batch_size=200))

    # ─── 6. ABASTECIMENTOS ───
    parts.append(header("6. ABASTECIMENTOS", "Fonte: fase_6/10_abastecimentos_vestro.csv (1.200 registros)"))
    rows = read_csv("fase_6/10_abastecimentos_vestro.csv")
    vals = []
    for r in rows:
        maq_code = r.get('machine_code_lookup', '').strip()
        if maq_code:
            maq_sql = f"(SELECT maquina_id FROM maquinas WHERE codigo_interno = {esc(maq_code)} LIMIT 1)"
        else:
            maq_sql = "NULL"
        fuel = r.get('fuel_type', 'Diesel S10').strip()
        fuel_map = {"Diesel S10": "diesel_s10", "Diesel S500": "diesel_s500", "Gasolina": "gasolina", "Etanol": "etanol", "ARLA32": "arla32"}
        fuel_sql = fuel_map.get(fuel, 'diesel_s10')
        vals.append(f"({org_id()}, {maq_sql}, NULL, {esc_date(r.get('supply_date'))}, '{fuel_sql}', {esc_num(r.get('volume_liters'))}, {esc_num(r.get('total_value'))}, {esc_num(r.get('unit_price'))}, {esc_num(r.get('odometer_km'))}, {esc(r.get('operator_name_lookup'))})")
    parts.append(batch_insert("abastecimentos",
        ["organization_id", "maquina_id", "operador_id", "data_hora", "tipo_combustivel", "quantidade_litros", "valor_total", "preco_unitario", "odometro_momento", "observacoes"],
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
        ["organization_id", "matricula", "cooperado", "conta_codigo", "conta_descricao", "data_movimento", "descricao", "debito", "credito", "saldo", "tipo_transacao", "nf_referencia", "safra_ref"],
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
        ["organization_id", "data_movimento", "descricao", "debito", "credito", "saldo", "tipo_transacao"],
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
        ["organization_id", "cooperado", "conta_codigo", "conta_descricao", "data_movimento", "historico", "descricao", "debito", "credito", "saldo", "tipo_transacao", "nf_referencia"],
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
        ["organization_id", "num_contrato", "tipo_financiamento", "data_movimento", "historico", "credito", "debito", "saldo"],
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

        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc_date(r.get('data'))}, {esc(r.get('num_venda'))}, {esc_num(r.get('peso_kg'))}, {esc_num(r.get('preco_saca'))}, {esc_num(r.get('valor_bruto'))}, {esc_num(r.get('desconto_bordero'))}, {esc_num(r.get('valor_nota'))}, {esc_num(r.get('valor_credito'))}, {esc_date(r.get('data_credito'))}, {esc(r.get('contrato'))}, {esc(r.get('armazem'))}, {esc(r.get('filial'))})")
    parts.append(batch_insert("vendas_grao",
        ["organization_id", "safra_id", "cultura_id", "data_venda", "numero_venda", "peso_kg", "preco_por_saca", "valor_bruto", "desconto_bordero", "valor_nota_fiscal", "valor_credito", "data_credito", "contrato", "armazem", "filial"],
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
        ["organization_id", "safra_id", "cultura_id", "data_venda", "numero_nfe", "comprador", "tipo_feijao", "quantidade_kg", "preco_unitario", "valor_total", "imposto_senar", "valor_liquido", "data_pagamento", "observacoes"],
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
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, {esc_date(r.get('sale_date'))}, {esc(r.get('sale_number'))}, {esc(r.get('buyer'))}, {esc_num(r.get('weight_kg'))}, {esc_num(r.get('price_per_sack'))}, {esc_num(r.get('gross_value'))}, {esc_num(r.get('bordero_discount'))}, {esc_num(r.get('invoice_value'))}, {esc_num(r.get('credit_value'))}, {esc_date(r.get('credit_date'))}, {esc(r.get('contract'))}, {esc(r.get('warehouse'))}, {esc(r.get('branch'))})")
    if vals:
        parts.append(batch_insert("vendas_grao",
            ["organization_id", "safra_id", "cultura_id", "data_venda", "numero_venda", "comprador", "peso_kg", "preco_por_saca", "valor_bruto", "desconto_bordero", "valor_nota_fiscal", "valor_credito", "data_credito", "contrato", "armazem", "filial"],
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
        ["organization_id", "safra_id", "cultura_id", "produto_codigo", "produto_nome", "cultivar", "num_docto", "nota_fiscal", "data_entrega", "peso_bruto_kg", "peso_liquido_kg", "placa", "motorista", "qualidade_json"],
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
        ["organization_id", "safra_id", "cultura_id", "categoria", "nome_produto", "codigo_produto", "unidade", "data_emissao", "numero_nf", "quantidade", "preco_unitario", "valor_total"],
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
        ["organization_id", "safra_id", "nome_motorista", "data_viagem", "placa", "produto", "origem", "destino", "peso_kg", "tarifa_por_ton", "valor_frete"],
        vals, batch_size=200))

    # ─── 17. TICKET_BALANCAS (fase 6) ───
    parts.append(header("17. TICKET_BALANCAS", "Fonte: fase_6/15_ticket_balancas.csv (883 registros, peso only)"))
    rows = read_csv("fase_6/15_ticket_balancas.csv")
    vals_ticket = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()

        vals_ticket.append(f"({org_id()}, {safra_id(safra_code)}, {cultura_id(cultura)}, NULL, NULL, {esc_date(r.get('data_pesagem'))}, {esc(r.get('hora_pesagem'))}, {esc(r.get('talhao_nome'))}, {esc(r.get('gleba'))}, {esc(r.get('destino'))}, {esc(r.get('variedade'))}, {esc(r.get('motorista'))}, {esc(r.get('placa_veiculo'))}, {esc_num(r.get('peso_bruto_kg'))}, {esc_num(r.get('peso_tara_kg'))}, {esc_num(r.get('peso_liquido_kg'))}, 'entrada_producao', 'pesado')")

    parts.append(batch_insert("ticket_balancas",
        ["organization_id", "safra_id", "cultura_id", "talhao_safra_id", "silo_destino_id", "data_pesagem", "hora_pesagem", "talhao_nome", "gleba", "destino", "variedade", "motorista", "placa_veiculo", "peso_bruto_kg", "peso_tara_kg", "peso_liquido_kg", "tipo", "status"],
        vals_ticket, batch_size=200))

    # ─── 17b. RECEBIMENTOS_GRAO (fase 6) ───
    parts.append(header("17b. RECEBIMENTOS_GRAO", "Fonte: fase_6/16_recebimentos_grao.csv (875 registros — qualidade pre-secagem)"))
    rows = read_csv("fase_6/16_recebimentos_grao.csv")
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if '/' in safra_code and len(safra_code) <= 5:
            p = safra_code.split('/')
            s1 = '20' + p[0] if len(p[0]) == 2 else p[0]
            s2 = '20' + p[1] if len(p[1]) == 2 else p[1]
            safra_code = f"{s1}/{s2}"
        cultura = r.get('cultura', '').strip().lower()

        # FK resolution: find ticket_balanca_id by matching (data_pesagem, hora_pesagem, placa_veiculo, peso_bruto_kg)
        date_val = esc_date(r.get('data_pesagem'))
        time_val = esc(r.get('hora_pesagem'))
        plate_val = esc(r.get('placa_veiculo'))
        bruto_val = esc_num(r.get('peso_bruto_kg'))

        # Handle NULL placa: use IS NULL instead of = NULL
        plate_raw = r.get('placa_veiculo', '').strip()
        if plate_raw:
            plate_clause = f"AND placa_veiculo = {plate_val}"
        else:
            plate_clause = "AND placa_veiculo IS NULL"

        ticket_sub = f"""(SELECT ticket_balanca_id FROM ticket_balancas
          WHERE data_pesagem = {date_val}
          AND hora_pesagem = {time_val}::TIME
          {plate_clause}
          AND peso_bruto_kg = {bruto_val}
          LIMIT 1)"""

        parts.append(f"""INSERT INTO recebimentos_grao (
  organization_id, ticket_balanca_id, safra_id, cultura_id,
  umidade_pct, ph, impureza_g, ardidos_g, avariado_g, verdes_g, quebrado_g,
  desconto_total_kg, peso_recebido_kg
) VALUES (
  {org_id()}, {ticket_sub}, {safra_id(safra_code)}, {cultura_id(cultura)},
  {esc_num(r.get('umidade_pct'))}, {esc_num(r.get('ph'))}, {esc_num(r.get('impureza_g'))},
  {esc_num(r.get('ardidos_g'))}, {esc_num(r.get('avariado_g'))},
  {esc_num(r.get('verdes_g'))}, {esc_num(r.get('quebrado_g'))},
  {esc_num(r.get('desconto_total_kg'))}, {esc_num(r.get('peso_recebido_kg'))}
);
""")

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
        ["organization_id", "safra_id", "cultura_id", "talhao_nome", "data_pesagem", "hora_pesagem", "gleba", "destino", "placa", "motorista", "peso_bruto_kg", "peso_tara_kg", "peso_liquido_kg", "umidade_pct", "ph", "impureza_g", "ardidos_g", "avariado_g", "verdes_g", "quebrado_g", "desconto_kg", "peso_final_kg", "variedade", "flag_semente"],
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
        ["organization_id", "safra_id", "cultura_id", "contrato_codigo", "contrato_descricao", "data_embarque", "hora_embarque", "origem", "destino", "transportadora", "motorista", "placa", "peso_bruto_kg", "peso_tara_kg", "peso_liquido_kg", "umidade_pct", "desconto_coop_kg", "peso_final_kg"],
        vals, batch_size=200))

    # ─── 20. UBG_CAIXA ───
    parts.append(header("20. UBG_CAIXA", "Fonte: fase_6/14_ubg_caixa.csv (19.325 registros)"))
    rows = read_csv("fase_6/14_ubg_caixa.csv")
    vals = []
    for r in rows:
        vals.append(f"({org_id()}, {esc(r.get('arquivo'))}, {esc_int(r.get('ano'))}, {esc_int(r.get('mes'))}, {esc_date(r.get('data'))}, {esc(r.get('produto'))}, {esc_num(r.get('qtde'))}, {esc(r.get('descricao'))}, {esc(r.get('comprador'))}, {esc(r.get('localidade'))}, {esc(r.get('forma_pgto'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('saldo'))}, {esc(r.get('tipo'))})")
    parts.append(batch_insert("ubg_caixa",
        ["organization_id", "arquivo", "ano", "mes", "data", "produto", "qtde", "descricao", "comprador", "localidade", "forma_pgto", "credito", "debito", "saldo", "tipo"],
        vals, batch_size=500))

    # ─── 21. COMPRA_INSUMO ───
    parts.append(header("21. COMPRA_INSUMO", "Fonte: fase_4/11_compra_insumo_castrolanda.csv (6.331 registros)"))
    rows = read_csv("fase_4/11_compra_insumo_castrolanda.csv")
    # Map CSV status to ENUM status_compra
    status_map_compra = {
        "recebido": "recebido",
        "cancelado": "cancelado",
        "pendente": "pendente",
        "parcial": "parcial",
    }
    vals = []
    for r in rows:
        status_csv = r.get('status', 'recebido').strip().lower()
        status_sql = status_map_compra.get(status_csv, 'recebido')
        # produto_insumo_id via subquery on codigo (Castrolanda catálogo)
        codigo = r.get('codigo_produto', '').replace("'", "''")
        produto_sub = f"(SELECT produto_insumo_id FROM produto_insumo WHERE codigo = '{codigo}' LIMIT 1)"
        # parceiro_id: Castrolanda is the supplier
        parceiro_sub = "(SELECT parceiro_comercial_id FROM parceiros_comerciais WHERE razao_social ILIKE '%castrolanda%' LIMIT 1)"
        # cultura_destino_id: FK to culturas — map culture name to UUID
        cultura_nome = r.get('cultura_destino', '').replace("'", "''")
        cultura_sub = f"(SELECT cultura_id FROM culturas WHERE UPPER(nome) = '{cultura_nome}' LIMIT 1)" if cultura_nome else "NULL"
        # observacoes: include tipo_operacao + cultura_destino for traceability
        obs = f"{r.get('tipo_operacao', '')} | cultura: {r.get('cultura_destino', '')}"
        vals.append(f"({org_id()}, {produto_sub}, {parceiro_sub}, 'castrolanda', {esc_date(r.get('data_compra'))}, {esc_num(r.get('quantidade'))}, {esc(r.get('unidade'))}, {esc_num(r.get('valor_unitario'))}, {esc_num(r.get('valor_total'))}, {cultura_sub}, {esc(r.get('numero_nota'))}, {esc(codigo)}, '{status_sql}', {esc(obs)})")

    parts.append(batch_insert("compra_insumo",
        ["organization_id", "produto_insumo_id", "parceiro_id", "fonte", "data_compra", "quantidade", "unidade", "valor_unitario", "valor_total", "cultura_destino_id", "numero_pedido", "castrolanda_sync_id", "status", "observacoes"],
        vals, batch_size=200))

    # ─── 22. FLUXO_CAIXA_FSI ───
    parts.append(header("22. FLUXO_CAIXA_FSI", "Fonte: fase_4/15_fluxo_caixa_fsi.csv (10.119 registros)"))
    rows = read_csv("fase_4/15_fluxo_caixa_fsi.csv")
    vals = []
    for r in rows:
        tipo = r.get('tipo_registro', 'diversos').strip().lower()
        tipo_map = {"debito": "debito", "credito": "credito", "operacional": "operacional", "diversos": "diversos"}
        tipo_sql = tipo_map.get(tipo, 'diversos')
        vals.append(f"({org_id()}, {esc_date(r.get('data'))}, {esc_int(r.get('ano'))}, {esc_int(r.get('mes'))}, {esc(r.get('descricao'))}, {esc(r.get('setor'))}, {esc(r.get('conta_bancaria'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('credito'))}, '{tipo_sql}', {esc_int(r.get('ano_sheet'))})")
    parts.append(batch_insert("fluxo_caixa_fsi",
        ["organization_id", "data", "ano", "mes", "descricao", "setor", "conta_bancaria", "debito", "credito", "tipo_registro", "ano_sheet"],
        vals, batch_size=500))

    # ─── 23. CAIXA_ESCRITORIO_FSI ───
    parts.append(header("23. CAIXA_ESCRITORIO_FSI", "Fonte: fase_4/16_caixa_escritorio_fsi.csv (1.185 registros)"))
    rows = read_csv("fase_4/16_caixa_escritorio_fsi.csv")
    vals = []
    for r in rows:
        vals.append(f"({org_id()}, {esc_date(r.get('data'))}, {esc(r.get('descricao'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('saldo'))}, {esc(r.get('visto'))})")
    parts.append(batch_insert("caixa_escritorio_fsi",
        ["organization_id", "data", "descricao", "credito", "debito", "saldo", "visto"],
        vals, batch_size=500))

    # ─── 24. KUGLER_X_FSI ───
    parts.append(header("24. KUGLER_X_FSI", "Fonte: fase_4/17_kugler_x_fsi.csv (1.499 registros)"))
    rows = read_csv("fase_4/17_kugler_x_fsi.csv")
    vals = []
    for r in rows:
        vals.append(f"({org_id()}, {esc_date(r.get('data'))}, {esc(r.get('descricao'))}, {esc_num(r.get('debito'))}, {esc_num(r.get('credito'))}, {esc_num(r.get('saldo'))})")
    parts.append(batch_insert("kugler_x_fsi",
        ["organization_id", "data", "descricao", "debito", "credito", "saldo"],
        vals, batch_size=500))

    # ─── 25. CONSORCIOS_FSI ───
    parts.append(header("25. CONSORCIOS_FSI", "Fonte: fase_4/18_consorcios_fsi.csv (20 registros)"))
    rows = read_csv("fase_4/18_consorcios_fsi.csv")
    for r in rows:
        parts.append(f"""INSERT INTO consorcios_fsi (
  organization_id, data_inicio, consorciado, origem, grupo, cota,
  prazo_meses, tx_adm, fun_res, descricao, situacao,
  data_contemplacao, pagamento, valor_bem, parcela_mensal, aquisicao, observacao
) VALUES (
  {org_id()}, {esc_date(r.get('data_inicio'))}, {esc(r.get('consorciado'))}, {esc(r.get('origem'))},
  {esc(r.get('grupo'))}, {esc(r.get('cota'))},
  {esc_int(r.get('prazo_meses'))}, {esc_num(r.get('tx_adm'))}, {esc_num(r.get('fun_res'))},
  {esc(r.get('descricao'))}, {esc(r.get('situacao'))},
  {esc_date(r.get('data_contemplacao'))}, {esc_num(r.get('pagamento'))},
  {esc_num(r.get('valor_bem'))}, {esc_num(r.get('parcela_mensal'))},
  {esc(r.get('aquisicao'))}, {esc(r.get('observacao'))}
);
""")

    # ═══════════════════════════════════════════════════════════════════════
    # FASE 5: Lifecycle TALHAO_SAFRA (cadeia FK completa)
    # Ordem: talhao_safra → safra_acoes → operacoes_campo → aplicacao_insumo → ticket_balanca
    # ═══════════════════════════════════════════════════════════════════════

    # Cultura name mapping (CSV lowercase → culturas.nome)
    cultura_name_map = {
        'soja': 'Soja', 'milho': 'Milho', 'feijao': 'Feijão', 'trigo': 'Trigo',
        'aveia_branca': 'Aveia Branca', 'aveia_preta': 'Aveia Preta',
        'azevem': 'Azevém', 'milho_silagem': 'Milho Silagem',
        'cevada': 'Cevada', 'cobertura': 'Cobertura Verde',
    }

    # ─── 26. TALHAO_SAFRAS (fase 5 — planejamento completo 25/26) ───
    parts.append(header("26. TALHAO_SAFRAS (fase 5 — planejamento)", "Fonte: fase_5/03_talhao_safra.csv (50 registros, safra 25/26 com planning data)"))
    rows = read_csv("fase_5/03_talhao_safra.csv")
    vals = []
    for r in rows:
        safra_code = normalize_safra_code(r.get('safra', ''))
        if not safra_code:
            continue
        talhao_nome = r.get('talhao', '').strip()
        cultura_raw = r.get('cultura', '').strip().lower()
        cultura_nome = cultura_name_map.get(cultura_raw, cultura_raw)
        epoca = r.get('epoca', 'safra').strip() or 'safra'
        gleba = r.get('gleba', '').strip()

        # Map status_planejamento from CSV to enum
        status_plan = r.get('status_planejamento', 'rascunho').strip().lower()
        valid_status = {'rascunho', 'em_revisao', 'aprovado', 'preparando', 'plantado',
                       'em_desenvolvimento', 'colheita', 'colhido', 'encerrado'}
        if status_plan not in valid_status:
            status_plan = 'rascunho'

        vals.append(f"({org_id()}, {talhao_id_by_nome(talhao_nome)}, {safra_id(safra_code)}, "
                   f"{cultura_id(cultura_nome)}, '{epoca}', {esc_num(r.get('area_plantada_ha'))}, "
                   f"{esc(r.get('cultivar'))}, {esc(gleba) if gleba else 'NULL'}, {esc(r.get('origem_semente'))}, "
                   f"{esc_date(r.get('data_plantio_prevista'))}, {esc_date(r.get('data_plantio'))}, {esc_date(r.get('data_colheita'))}, "
                   f"{esc_num(r.get('produtividade_sc_ha'))}, {esc(r.get('observacoes'))}, "
                   f"'{status_plan}', {esc_num(r.get('meta_produtividade_sc_ha'))}, "
                   f"{esc(r.get('atribuido_por'))}, {esc(r.get('aprovado_por'))}, {esc_date(r.get('data_aprovacao'))})")

    if vals:
        parts.append(batch_insert("talhao_safras",
            ["organization_id", "talhao_id", "safra_id", "cultura_id", "epoca", "area_plantada_ha",
             "cultivar", "gleba", "origem_semente",
             "data_plantio_prevista", "data_plantio", "data_colheita",
             "produtividade_sc_ha", "observacoes",
             "status_planejamento", "meta_produtividade_sc_ha",
             "atribuido_por", "aprovado_por", "data_aprovacao"],
            vals, batch_size=200,
            on_conflict="ON CONFLICT (talhao_id, safra_id, cultura_id, epoca, gleba) DO NOTHING"))

    # ─── 27. SAFRA_ACOES (fase 5) ───
    parts.append(header("27. SAFRA_ACOES (fase 5)", "Fonte: fase_5/04_safra_acoes.csv (9 registros)"))
    rows = read_csv("fase_5/04_safra_acoes.csv")
    vals = []
    for r in rows:
        safra_code = normalize_safra_code(r.get('safra', ''))
        if not safra_code:
            continue
        talhao_nome = r.get('talhao', '').strip()
        cultura_raw = r.get('cultura', '').strip().lower()
        cultura_nome = cultura_name_map.get(cultura_raw, cultura_raw)
        epoca = r.get('epoca', 'safra').strip() or 'safra'

        ts_sub = talhao_safra_id_sub(safra_code, talhao_nome, cultura_nome, epoca)

        # template_id: lookup by cultura + tipo_operacao
        template_cultura = r.get('template_cultura', '').strip().lower()
        tipo = r.get('tipo', '').strip()
        template_nome = cultura_name_map.get(template_cultura, template_cultura)
        gerado = esc_bool(r.get('gerado_automaticamente', 'false'))
        if template_cultura and tipo:
            template_sub = (f"(SELECT template_id FROM template_cultura_operacoes tco"
                          f" JOIN culturas c ON tco.cultura_id = c.cultura_id"
                          f" WHERE LOWER(c.nome) = LOWER('{template_nome}')"
                          f" AND tco.tipo_operacao = '{tipo}'"
                          f" LIMIT 1)")
        else:
            template_sub = "NULL"

        # responsavel_id: lookup user by name
        responsavel = r.get('responsavel', '').strip()
        if responsavel:
            resp_esc = responsavel.replace("'", "''")
            responsavel_sub = f"(SELECT user_id FROM users WHERE nome ILIKE '%{resp_esc}%' LIMIT 1)"
        else:
            responsavel_sub = "NULL"

        status = r.get('status', 'planejada').strip().lower()

        vals.append(f"({org_id()}, {ts_sub}, {safra_id(safra_code)}, "
                   f"{esc(tipo)}, {esc(r.get('titulo'))}, "
                   f"{esc_date(r.get('data_inicio'))}, {esc_date(r.get('data_fim'))}, "
                   f"'{status}', {responsavel_sub}, "
                   f"{esc_num(r.get('custo_estimado'))}, {esc_num(r.get('custo_real'))}, "
                   f"{esc_num(r.get('area_ha'))}, {template_sub}, {gerado})")

    if vals:
        parts.append(batch_insert("safra_acoes",
            ["organization_id", "talhao_safra_id", "safra_id",
             "tipo", "titulo",
             "data_inicio", "data_fim",
             "status", "responsavel_id",
             "custo_estimado", "custo_real",
             "area_ha", "template_id", "gerado_automaticamente"],
            vals, batch_size=200))

    # ─── 28. OPERACOES_CAMPO (fase 5) ───
    parts.append(header("28. OPERACOES_CAMPO (fase 5)", "Fonte: fase_5/05_operacoes_campo.csv (7 registros)"))
    rows = read_csv("fase_5/05_operacoes_campo.csv")
    for r in rows:
        safra_code = normalize_safra_code(r.get('safra', ''))
        if not safra_code:
            continue
        talhao_nome = r.get('talhao', '').strip()
        cultura_raw = r.get('cultura', '').strip().lower()
        cultura_nome = cultura_name_map.get(cultura_raw, cultura_raw)
        epoca = r.get('epoca', 'safra').strip() or 'safra'
        tipo = r.get('tipo', '').strip()
        fazenda_nome = r.get('fazenda', '').strip()

        ts_sub = talhao_safra_id_sub(safra_code, talhao_nome, cultura_nome, epoca)

        # safra_acao_id: lookup by titulo within talhao_safra
        safra_acao_titulo = r.get('safra_acao_titulo', '').strip()
        if safra_acao_titulo:
            sa_sub = safra_acao_id_sub(safra_code, talhao_nome, cultura_nome, epoca, tipo, safra_acao_titulo)
        else:
            sa_sub = "NULL"

        # maquina_id: lookup by codigo
        maq_code = r.get('maquina_codigo', '').strip()
        maq_sub = maquina_id_by_code(maq_code) if maq_code else "NULL"

        # operador_id: lookup by nome
        op_nome = r.get('operador_nome', '').strip()
        op_sub = operador_id_by_nome(op_nome) if op_nome else "NULL"

        status = r.get('status', 'concluida').strip().lower()

        parts.append(f"""INSERT INTO operacoes_campo (
  organization_id, talhao_safra_id, maquina_id, operador_id, fazenda_id,
  tipo, status, data_inicio, data_fim,
  area_trabalhada_ha, horimetro_inicio, horimetro_fim,
  combustivel_litros, custo_operacao,
  safra_acao_id, implemento_codigo, observacoes
) VALUES (
  {org_id()}, {ts_sub}, {maq_sub}, {op_sub}, {fazenda_id(fazenda_nome)},
  '{tipo}', '{status}', {esc_date(r.get('data_inicio'))}, {esc_date(r.get('data_fim'))},
  {esc_num(r.get('area_trabalhada_ha'))}, {esc_num(r.get('horimetro_inicio'))}, {esc_num(r.get('horimetro_fim'))},
  {esc_num(r.get('combustivel_litros'))}, {esc_num(r.get('custo_operacao'))},
  {sa_sub}, {esc(r.get('implemento_codigo'))}, {esc(r.get('observacoes'))}
);
""")

    # ─── 29. APLICACAO_INSUMO (fase 5) ───
    parts.append(header("29. APLICACAO_INSUMO (fase 5)", "Fonte: fase_5/06_aplicacao_insumo.csv (11 registros)"))
    rows = read_csv("fase_5/06_aplicacao_insumo.csv")

    # Map CSV metodo_aplicacao to DDL enum
    metodo_map = {
        'pulverizacao_tratorizada': 'pulverizador',
        'plantio_mecanizado': 'plantadeira',
        'distribuicao_mecanizada': 'distribuidor',
        'aplicacao_drone': 'drone',
        'manual': 'manual',
    }

    for r in rows:
        safra_code = normalize_safra_code(r.get('safra', ''))
        if not safra_code:
            continue
        talhao_nome = r.get('talhao', '').strip()
        cultura_raw = r.get('cultura', '').strip().lower()
        cultura_nome = cultura_name_map.get(cultura_raw, cultura_raw)
        epoca = r.get('epoca', 'safra').strip() or 'safra'

        ts_sub = talhao_safra_id_sub(safra_code, talhao_nome, cultura_nome, epoca)

        # operacao_campo_id: lookup by tipo + data_inicio within talhao_safra
        operacao_tipo = r.get('operacao_tipo', '').strip()
        data_aplicacao = r.get('data_aplicacao', '').strip()
        if operacao_tipo and data_aplicacao:
            data_sql = esc_date(data_aplicacao).strip("'")
            op_tipo_esc = operacao_tipo.replace("'", "''")
            oc_sub = (f"(SELECT oc.operacao_campo_id FROM operacoes_campo oc"
                     f" WHERE oc.talhao_safra_id = {ts_sub}"
                     f" AND oc.tipo = '{op_tipo_esc}'"
                     f" AND oc.data_inicio <= '{data_sql}'"
                     f" AND (oc.data_fim IS NULL OR oc.data_fim >= '{data_sql}')"
                     f" LIMIT 1)")
        else:
            oc_sub = "NULL"

        # produto_insumo_id
        produto_nome = r.get('produto_insumo_nome', '').strip()
        prod_sub = produto_insumo_id_by_nome(produto_nome) if produto_nome else "NULL"

        # metodo_aplicacao mapping
        metodo_csv = r.get('metodo_aplicacao', '').strip().lower()
        metodo_sql = metodo_map.get(metodo_csv, metodo_csv)
        # Validate against enum
        valid_metodos = {'plantadeira', 'pulverizador', 'distribuidor', 'drone', 'manual', 'cocho', 'seringa'}
        metodo_clause = f"'{metodo_sql}'" if metodo_sql in valid_metodos else "NULL"

        contexto = r.get('contexto', 'agricola').strip().lower()
        valid_contextos = {'agricola', 'pecuario', 'manutencao', 'ubg'}
        if contexto not in valid_contextos:
            contexto = 'agricola'

        parts.append(f"""INSERT INTO aplicacao_insumo (
  organization_id, produto_insumo_id, operacao_campo_id, talhao_safra_id,
  data_aplicacao, dose_por_ha, area_aplicada_ha, quantidade_total, unidade,
  custo_unitario, custo_total, metodo_aplicacao, contexto, observacoes
) VALUES (
  {org_id()}, {prod_sub}, {oc_sub}, {ts_sub},
  {esc_date(data_aplicacao)}, {esc_num(r.get('dose_por_ha'))}, {esc_num(r.get('area_aplicada_ha'))},
  {esc_num(r.get('quantidade_total'))}, {esc(r.get('unidade'))},
  {esc_num(r.get('custo_unitario'))}, {esc_num(r.get('custo_total'))},
  {metodo_clause}, '{contexto}', {esc(r.get('observacoes'))}
);
""")

    # ─── 30. PLANTIO HISTORICO (renumerado — seções 30/30b fase_5 removidas, CSVs arquivados) ───
    # ─── 31. PLANTIO HISTORICO → TALHAO_SAFRAS (gleba + origem_semente) ───
    parts.append(header("31. PLANTIO HISTORICO", "Fonte: fase_6_operacoes/12_plantio_historico.csv (152 registros, 6 safras). ON CONFLICT DO NOTHING — fase 5 data takes priority."))
    rows = read_csv("fase_6_operacoes/12_plantio_historico.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        if not safra_code:
            continue
        fazenda_nome = r.get('fazenda', '').strip()
        talhao_nome = r.get('talhao', '').strip()
        gleba = r.get('gleba', '').strip()
        cultura_raw = r.get('cultura', '').strip()
        cultura_nome = cultura_name_map.get(cultura_raw, cultura_raw)
        cultura_sub = f"(SELECT cultura_id FROM culturas WHERE UPPER(nome) = UPPER('{cultura_nome}') LIMIT 1)"
        # talhao_id: try to match by nome (talhao or gleba or fazenda-based)
        talhao_for_lookup = talhao_nome or gleba or ''
        talhao_sub = f"(SELECT talhao_id FROM talhoes WHERE UPPER(nome) ILIKE '%{talhao_for_lookup.upper().replace(chr(39), chr(39)+chr(39))}%' LIMIT 1)" if talhao_for_lookup else "NULL"
        epoca = r.get('epoca', 'safra').strip() or 'safra'

        vals.append(f"({org_id()}, {talhao_sub}, {safra_id(safra_code)}, {cultura_sub}, '{epoca}', {esc_num(r.get('area_plantada_ha'))}, {esc(r.get('cultivar'))}, {esc(gleba)}, {esc(r.get('origem_semente'))}, {esc_date(r.get('data_plantio'))}, {esc(r.get('notas'))})")

    parts.append(batch_insert("talhao_safras",
        ["organization_id", "talhao_id", "safra_id", "cultura_id", "epoca", "area_plantada_ha", "cultivar", "gleba", "origem_semente", "data_plantio", "observacoes"],
        vals, batch_size=200,
        on_conflict="ON CONFLICT (talhao_id, safra_id, cultura_id, epoca, gleba) DO NOTHING"))

    # ─── 32. UPDATE status_planejamento TALHAO_SAFRA (Doc 32) ───
    parts.append(header("32. UPDATE status_planejamento TALHAO_SAFRA (Doc 32)", "Reconstrucao retroativa — registros 25/26 com talhao → aprovado, historicos → colhido"))
    parts.append("""-- Registros 25/26 com talhao_id (plantio direto) → status 'aprovado' (se ainda rascunho — fase 5 pode ter setado outro)
UPDATE talhao_safras ts
SET status_planejamento = 'aprovado'
FROM safras s
WHERE ts.safra_id = s.safra_id
  AND s.ano_agricola = '25/26'
  AND ts.talhao_id IS NOT NULL
  AND ts.status_planejamento = 'rascunho';

-- Registros historicos sem talhao_id (agregados por cultivar) → status 'colhido'
UPDATE talhao_safras ts
SET status_planejamento = 'colhido'
FROM safras s
WHERE ts.safra_id = s.safra_id
  AND s.ano_agricola IN ('20/21', '21/22', '22/23', '23/24', '24/25')
  AND ts.status_planejamento = 'rascunho';
""")

    # ─── 33. CONTROLES_SECAGEM ───
    parts.append(header("33. CONTROLES_SECAGEM", "⚠️ DEMO — dados fictícios. Fonte: fase_6/17_controles_secagem.csv (5 registros). Soja 24/25, 5 dias colheita Mar/2025. Substituir por dados reais."))
    rows = read_csv("fase_6/17_controles_secagem.csv")
    for r in rows:
        safra_code = r.get('safra', '').strip()
        cultura_nome = r.get('cultura', '').strip().lower()
        silo_cod = r.get('silo_codigo', '').strip()

        # FK recebimento_grao_id — match by date+hora+placa+bruto (only seq 1 has match data)
        match_date = r.get('recebimento_match_date', '').strip()
        match_hora = r.get('recebimento_match_hora', '').strip()
        match_placa = r.get('recebimento_match_placa', '').strip()
        match_bruto = r.get('recebimento_match_bruto', '').strip()
        if match_date and match_hora and match_placa and match_bruto:
            receb_sub = (f"(SELECT recebimento_grao_id FROM recebimentos_grao"
                         f" WHERE data_pesagem = '{match_date}'"
                         f" AND hora_pesagem = '{match_hora}'"
                         f" AND placa_veiculo = '{match_placa}'"
                         f" AND peso_bruto_kg = {match_bruto}"
                         f" LIMIT 1)")
        else:
            receb_sub = "NULL"

        parts.append(f"""INSERT INTO controles_secagem (
  organization_id, recebimento_grao_id, safra_id, cultura_id, silo_id,
  data_inicio, data_fim, hora_inicio, hora_fim,
  n_secagem_sequencial, secador_identificacao, cultivar,
  operador_turno_1, operador_turno_2,
  umidade_entrada_pct, umidade_saida_pct, temperatura_c,
  peso_entrada_kg, peso_saida_kg, perda_secagem_kg,
  total_horas_secagem, lenha_m3, energia_kwh,
  custo_lenha, custo_energia, custo_total_secagem,
  observacoes
) VALUES (
  {org_id()}, {receb_sub}, {safra_id(safra_code)}, {cultura_id(cultura_nome)}, {silo_id_by_codigo(silo_cod)},
  {esc_date(r.get('data_inicio'))}, {esc_date(r.get('data_fim'))}, {esc(r.get('hora_inicio'))}, {esc(r.get('hora_fim'))},
  {esc_int(r.get('n_secagem_sequencial'))}, {esc(r.get('secador_identificacao'))}, {esc(r.get('cultivar'))},
  {esc(r.get('operador_turno_1'))}, {esc(r.get('operador_turno_2'))},
  {esc_num(r.get('umidade_entrada_pct'))}, {esc_num(r.get('umidade_saida_pct'))}, {esc_num(r.get('temperatura_c'))},
  {esc_num(r.get('peso_entrada_kg'))}, {esc_num(r.get('peso_saida_kg'))}, {esc_num(r.get('perda_secagem_kg'))},
  {esc_num(r.get('total_horas_secagem'))}, {esc_num(r.get('lenha_m3'))}, {esc_num(r.get('energia_kwh'))},
  {esc_num(r.get('custo_lenha'))}, {esc_num(r.get('custo_energia'))}, {esc_num(r.get('custo_total_secagem'))},
  {esc(r.get('observacoes'))}
);
""")

    # ─── 34. LEITURAS_SECAGEM ───
    parts.append(header("34. LEITURAS_SECAGEM", "⚠️ DEMO — dados fictícios. Fonte: fase_6/18_leituras_secagem.csv (25 registros). 5 leituras/controle, a cada 30 min (I.N. 029/2011). Substituir por dados reais."))
    rows = read_csv("fase_6/18_leituras_secagem.csv")
    for r in rows:
        seq = r.get('secagem_seq', '').strip()
        sec_date = r.get('secagem_data', '').strip()
        # FK controle_secagem_id via n_secagem_sequencial + data_inicio
        cs_sub = (f"(SELECT controle_secagem_id FROM controles_secagem"
                  f" WHERE n_secagem_sequencial = {seq}"
                  f" AND data_inicio = '{sec_date}'"
                  f" LIMIT 1)")

        parts.append(f"""INSERT INTO leituras_secagem (
  controle_secagem_id, hora_leitura,
  umidade_entrada_pct, umidade_secagem_pct,
  temp_p1_c, temp_p2_c, temp_p3_c, temp_grao_c,
  n_secagem_sequencial, destino_produto,
  trat_fitossanitario_l, tipo_secagem, lenha_m3
) VALUES (
  {cs_sub}, {esc(r.get('hora_leitura'))},
  {esc_num(r.get('umidade_entrada_pct'))}, {esc_num(r.get('umidade_secagem_pct'))},
  {esc_num(r.get('temp_p1_c'))}, {esc_num(r.get('temp_p2_c'))}, {esc_num(r.get('temp_p3_c'))}, {esc_num(r.get('temp_grao_c'))},
  {esc_int(r.get('n_secagem_sequencial'))}, {esc(r.get('destino_produto'))},
  {esc_num(r.get('trat_fitossanitario_l'))}, {esc(r.get('tipo_secagem'))}, {esc_num(r.get('lenha_m3'))}
);
""")

    # ─── 35. ALOCACOES_SILO ───
    parts.append(header("35. ALOCACOES_SILO", "⚠️ DEMO — dados fictícios. Fonte: fase_6/19_alocacoes_silo.csv (8 registros). Entradas pos-secagem + transferencias + ajuste. Substituir por dados reais."))
    rows = read_csv("fase_6/19_alocacoes_silo.csv")
    for r in rows:
        safra_code = r.get('safra', '').strip()
        cultura_nome = r.get('cultura', '').strip().lower()
        tipo = r.get('tipo', '').strip()

        silo_orig = r.get('silo_origem_codigo', '').strip()
        silo_dest = r.get('silo_destino_codigo', '').strip()
        silo_orig_sub = silo_id_by_codigo(silo_orig) if silo_orig else "NULL"
        silo_dest_sub = silo_id_by_codigo(silo_dest) if silo_dest else "NULL"

        # FK controle_secagem_id — only for entrada_secagem type
        sec_seq = r.get('secagem_match_seq', '').strip()
        sec_date = r.get('secagem_match_data', '').strip()
        if sec_seq and sec_date:
            cs_sub = (f"(SELECT controle_secagem_id FROM controles_secagem"
                      f" WHERE n_secagem_sequencial = {sec_seq}"
                      f" AND data_inicio = '{sec_date}'"
                      f" LIMIT 1)")
        else:
            cs_sub = "NULL"

        parts.append(f"""INSERT INTO alocacoes_silo (
  organization_id, safra_id, cultura_id, tipo, quantidade_kg,
  silo_origem_id, silo_destino_id,
  data_alocacao, hora_alocacao,
  executado_por, aprovado_por,
  controle_secagem_id, umidade_pct, observacoes
) VALUES (
  {org_id()}, {safra_id(safra_code)}, {cultura_id(cultura_nome)}, '{tipo}', {esc_num(r.get('quantidade_kg'))},
  {silo_orig_sub}, {silo_dest_sub},
  {esc_date(r.get('data_alocacao'))}, {esc(r.get('hora_alocacao'))},
  {esc(r.get('executado_por'))}, {esc(r.get('aprovado_por'))},
  {cs_sub}, {esc_num(r.get('umidade_pct'))}, {esc(r.get('observacoes'))}
);
""")

    # ─── 36. ESTOQUES_SILO ───
    parts.append(header("36. ESTOQUES_SILO", "⚠️ DEMO — dados fictícios. Fonte: fase_6/20_estoques_silo.csv (10 registros). Snapshots fim-de-dia S1+S2, 5 dias. Substituir por dados reais."))
    rows = read_csv("fase_6/20_estoques_silo.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        cultura_nome = r.get('cultura', '').strip().lower()
        silo_cod = r.get('silo_codigo', '').strip()
        status_est = r.get('status_estoque', 'ativo').strip()

        vals.append(
            f"({org_id()}, {silo_id_by_codigo(silo_cod)}, {safra_id(safra_code)}, {cultura_id(cultura_nome)}, "
            f"'{status_est}', {esc_date(r.get('data_referencia'))}, "
            f"{esc_num(r.get('quantidade_kg'))}, {esc_num(r.get('capacidade_restante_kg'))}, "
            f"{esc_num(r.get('umidade_media_pct'))}, "
            f"{esc_num(r.get('total_entradas_kg'))}, {esc_num(r.get('total_saidas_kg'))}, {esc_num(r.get('total_perda_secagem_kg'))})"
        )

    parts.append(batch_insert("estoques_silo",
        ["organization_id", "silo_id", "safra_id", "cultura_id",
         "status_estoque", "data_referencia",
         "quantidade_kg", "capacidade_restante_kg",
         "umidade_media_pct",
         "total_entradas_kg", "total_saidas_kg", "total_perda_secagem_kg"],
        vals, batch_size=100,
        on_conflict="ON CONFLICT (silo_id, safra_id, cultura_id, data_referencia) DO NOTHING"))

    # ─── 37. CONSUMO_AGRIWIN (staging Bronze) ───
    parts.append(header("37. CONSUMO_AGRIWIN (staging Bronze)", "Fonte: fase_6_operacoes/12_consumo_agriwin.csv (21.162 registros, R$99.2M, 8 safras)"))
    rows = read_csv("fase_6_operacoes/12_consumo_agriwin.csv")
    vals = []
    for r in rows:
        safra_code = r.get('safra', '').strip()
        vals.append(f"({org_id()}, {safra_id(safra_code)}, {esc_date(r.get('data_aplicacao'))}, {esc(r.get('tipo_rateio'))}, {esc(r.get('rateio_detalhe'))}, {esc(r.get('tipo_operacao'))}, {esc(r.get('responsavel'))}, {esc(r.get('imobilizados'))}, {esc(r.get('produto_nome'))}, {esc(r.get('produto_unidade'))}, {esc_num(r.get('valor_total_operacao'))}, {esc_int(r.get('num_produtos_operacao'))}, {esc(r.get('arquivo_origem'))})")
    parts.append(batch_insert("consumo_agriwin",
        ["organization_id", "safra_id", "data_aplicacao", "tipo_rateio", "rateio_detalhe", "tipo_operacao", "responsavel", "imobilizados", "produto_nome", "produto_unidade", "valor_total_operacao", "num_produtos_operacao", "arquivo_origem"],
        vals, batch_size=500))

    parts.append("""
COMMIT;

-- ═══════════════════════════════════════════════════════════════════════
-- FIM — 02_INSERT_DADOS.sql
-- Total: ~77.000 registros inseridos (inclui 12.823 FSI + fase 5 lifecycle + UBG secagem/silos + 21.162 consumo_agriwin)
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
