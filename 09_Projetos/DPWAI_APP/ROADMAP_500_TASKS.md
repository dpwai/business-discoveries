# DPWAI Platform - Roadmap 500 Tasks

> Documento criado em 02/02/2026 pelo João Balzer
> Organizado pelo Muffin 🤖

## Visão Geral

500 tasks para implementar 100% das áreas:
- **Alertas** (sistema de 2 passos: Ação + Reação)
- **Meus Dados** (catálogo unificado de entradas)
- **Integrações/Chaves** (vault seguro)
- **Permissões/Herança** (Google-like)

---

## 0) Regras/Entidades-base — Tasks 001–040

| # | Task | Status |
|---|------|--------|
| 001 | Definir entidade OrgMaster (topo) e SubOrg (filhas) com vínculo obrigatório | ⏳ |
| 002 | Definir entidade OrganizationArea dentro de cada SubOrg e também na OrgMaster | ⏳ |
| 003 | Definir entidade UserOrgMembership (user ↔ org) com role e status | ⏳ |
| 004 | Definir entidade UserAreaMembership (user ↔ area) com role local | ⏳ |
| 005 | Definir enum de roles globais: SUPER_ADMIN, SUPER_ADMIN_WORKER, ORG_MASTER, ORG_OWNER, ORG_ADMIN, ORG_USER, VIEWER | ⏳ |
| 006 | Definir regra: somente SUPER_ADMIN e SUPER_ADMIN_WORKER criam OrgMaster/SubOrg | ⏳ |
| 007 | Definir regra: ORG_MASTER/ORG_OWNER não cria org/suborg, só gerencia dentro da org | ⏳ |
| 008 | Criar entidade Contract que define OrgMaster, SubOrgs, owners iniciais e escopo | ⏳ |
| 009 | Validar fluxo: contrato exige listar owners e quais orgs cada owner pertence | ⏳ |
| 010 | Implementar auditoria: created_by, created_at, updated_by, updated_at em tudo | ⏳ |
| 011 | Implementar soft-delete padronizado (is_active, deleted_at) nas entidades governadas | ⏳ |
| 012 | Definir entidade ResourceACL genérica para Forms/Dash/Alerts/MeusDados views | ⏳ |
| 013 | Definir visibility_scope: AREA, PERSON, PUBLIC | ⏳ |
| 014 | Definir permission_level: READ, EDIT | ⏳ |
| 015 | Definir herança Google-like: AREA dá acesso para todos da área | ⏳ |
| 016 | Exceção: PERSON concede acesso específico mesmo fora da área | ⏳ |
| 017 | Precedência: PERSON > AREA > PUBLIC | ⏳ |
| 018 | Se PUBLIC ativo: acesso sem login via token público rotacionável | ⏳ |
| 019 | Implementar token público com TTL opcional e revogação | ⏳ |
| 020 | Implementar logs de permissão: cada grant/revoke gera evento | ⏳ |
| 021 | Criar entidade AreaTag e tags obrigatórias em resources (pra agregação) | ⏳ |
| 022 | Criar regra de agregação: OrgMaster enxerga tudo das SubOrgs "tagueado" | ⏳ |
| 023 | Definir "source" unificado pra Meus Dados: FORM_CUSTOM, FORM_FARM, FILE, INTEGRATION | ⏳ |
| 024 | Definir classificação: RELATIONAL vs NON_RELATIONAL | ⏳ |
| 025 | Definir que arquivo (PDF etc) é NON_RELATIONAL | ⏳ |
| 026 | Definir que CSV listado em entradas é FILE e pode virar dataset relacional opcional | ⏳ |
| 027 | Definir que integração pode gerar ambos tipos | ⏳ |
| 028 | Definir entidade DataEntry (registro atômico do "que entrou") | ⏳ |
| 029 | Definir que formulário custom relacional vira linhas em tabela associada | ⏳ |
| 030 | Definir que formulário fazenda é relacional e tem schema governado por template | ⏳ |
| 031 | Definir entidade DataSource (fonte) representando "tabelas", "arquivos", "conectores" | ⏳ |
| 032 | Definir entidade AlertRule com action e reaction | ⏳ |
| 033 | Definir que cada alert tem exatamente 2 passos: ação e reação (com condições) | ⏳ |
| 034 | Definir que "ação" representa trigger/evento/cron/estado | ⏳ |
| 035 | Definir que "reação" representa entrega (relatório, envio, export, notificação) | ⏳ |
| 036 | Definir entidade AlertRun com status e outputs | ⏳ |
| 037 | Definir entidade AlertDelivery por canal (email, webhook etc) | ⏳ |
| 038 | Definir entidade AlertTemplate (modelos) por domínio (agro) | ⏳ |
| 039 | Definir entidade KeyVaultItem (chaves) com tipo, campos, rotação | ⏳ |
| 040 | Definir criptografia: chaves sempre encrypted-at-rest + masked na UI | ⏳ |

---

## 1) "Meus Dados" — Tasks 041–150

| # | Task | Status |
|---|------|--------|
| 041 | Criar tela Meus Dados com visão "catálogo" de tudo que entrou na plataforma | ⏳ |
| 042 | Implementar filtros por: Org, Área, Tipo (relacional/não), Fonte, Data, Criado por | ⏳ |
| 043 | Implementar busca global por nome, tags, metadados, ids | ⏳ |
| 044 | Implementar agrupamento por: Formulários, Arquivos, Integrações, Templates | ⏳ |
| 045 | Criar aba "Resumo" com cards: total entradas, total fontes, últimos 7 dias, erros | ⏳ |
| 046 | Criar aba "Entradas" listando DataEntry como linha única | ⏳ |
| 047 | Criar coluna: entry_type, source_name, org, area, created_at, owner | ⏳ |
| 048 | Criar coluna: classification (RELATIONAL/NON_RELATIONAL) | ⏳ |
| 049 | Criar coluna: schema_version (quando relacional) | ⏳ |
| 050 | Criar coluna: files_count (quando existir anexo) | ⏳ |
| 051 | Criar coluna: status (OK/FAILED/PARTIAL) | ⏳ |
| 052 | Implementar detalhe da entrada (drawer) com metadados e lineage | ⏳ |
| 053 | Mostrar "de onde veio": form X, integration Y, file Z | ⏳ |
| 054 | Mostrar "pra onde foi": tabela destino / storage path / dataset | ⏳ |
| 055 | Implementar "ver linhas" quando entrada for relacional (preview paginado) | ⏳ |
| 056 | Implementar "download" quando entrada for arquivo (com permissão) | ⏳ |
| 057 | Implementar "ver arquivo" (PDF viewer) com controle de acesso | ⏳ |
| 058 | Implementar "ver histórico" (versões) de uma entrada | ⏳ |
| 059 | Implementar reprocessamento manual de uma entrada com fila | ⏳ |
| 060 | Implementar validação de qualidade: contagem, campos obrigatórios, schema drift | ⏳ |
| 061-150 | ... (90 tasks de Meus Dados) | ⏳ |

---

## 2) Integrações + "Chaves" — Tasks 151–240

| # | Task | Status |
|---|------|--------|
| 151 | Criar seção "Integrações" separando: conectores, chaves, runs, logs | ⏳ |
| 152 | Criar aba "Chaves" com UI de vault (área segura) | ⏳ |
| 153 | Exigir reautenticação (senha/OTP) para abrir "Chaves" | ⏳ |
| 154 | Exigir role mínima para ver "Chaves" (ORG_MASTER/ORG_OWNER/ADMIN) | ⏳ |
| 155 | Mascarar valores sempre (mostrar só últimos 4) | ⏳ |
| 156-240 | ... (85 tasks de Integrações/Chaves) | ⏳ |

---

## 3) Permissões/Herança — Tasks 241–320

| # | Task | Status |
|---|------|--------|
| 241 | Implementar ACL padrão ao criar Form: escolher Área + opcional Pessoa + nível (read/edit) | ⏳ |
| 242 | Implementar ACL padrão ao criar Dashboard: escolher Área + opcional Pessoa + nível | ⏳ |
| 243 | Implementar UI de "Compartilhar" estilo Google: lista de pessoas + área + público | ⏳ |
| 244-320 | ... (77 tasks de Permissões) | ⏳ |

---

## 4) Alertas — Tasks 321–470

| # | Task | Status |
|---|------|--------|
| 321 | Criar menu "Alertas" no sanduíche | ⏳ |
| 322 | Criar tela "Meus Alertas" com lista e estados | ⏳ |
| 323 | Implementar criar alerta com wizard 2 passos: Ação → Reação | ⏳ |
| 324 | Passo Ação: escolher tipo SCHEDULE, EVENT, CONDITION | ⏳ |
| 325-470 | ... (146 tasks de Alertas) | ⏳ |

---

## 5) Usuários + Hierarquia — Tasks 471–500

| # | Task | Status |
|---|------|--------|
| 471 | Expandir "Meus Usuários": mostrar OrgMaster/SubOrg membership | ⏳ |
| 472 | Mostrar quais Áreas o user faz parte | ⏳ |
| 473-500 | ... (28 tasks de Usuários) | ⏳ |

---

## Progresso

- **Total**: 500 tasks
- **Concluídas**: 0
- **Em progresso**: 0
- **Pendentes**: 500

---

*Documento vivo - atualizado conforme progresso*
