# Mapeamento Completo de Entidades - Projeto SOAL

**Data:** 04/02/2026
**Autor:** Rodrigo Kugler + Claude (DeepWork AI Flows)
**Versao:** 2.0
**Status:** Consolidado de 12+ reunioes

---

## Sumario

1. [Resumo Executivo](#1-resumo-executivo)
2. [Camada Sistema](#2-camada-sistema)
3. [Camada Estrutura Territorial](#3-camada-estrutura-territorial)
4. [Camada Operacoes de Graos](#4-camada-operacoes-de-graos)
5. [Camada Maquinario](#5-camada-maquinario)
6. [Camada Financeiro](#6-camada-financeiro)
7. [Camada Integracoes](#7-camada-integracoes)
8. [Camada Alertas](#8-camada-alertas)
9. [Camada Conectores Gold Layer](#9-camada-conectores-gold-layer)
10. [Camada Pecuaria Fase 2](#10-camada-pecuaria-fase-2)
11. [Formularios Padrao](#11-formularios-padrao)
12. [Matriz de Relacionamentos](#12-matriz-de-relacionamentos)
13. [Proximos Passos](#13-proximos-passos)

---

## 1. Resumo Executivo

Este documento consolida **todas as entidades** identificadas nas reunioes do projeto SOAL entre Dezembro/2025 e Fevereiro/2026.

### Fontes Consultadas

| Data | Reuniao | Principais Entidades Descobertas |
|------|---------|----------------------------------|
| 15/12/2025 | Estrategia e Modelo Negocio | Organizations, Users, Memberships |
| 22/12/2025 | Planejamento Tecnico DW | Medallion Architecture |
| 29/12/2025 | Decisoes Estrategicas MVP | Forms, Entries |
| XX/12/2025 | Discovery Presencial Claudio | Fazendas, Silos, Culturas |
| 16/01/2026 | Discovery Tiago Maquinario | Maquinas, Abastecimentos, Tabela DE-PARA |
| 19/01/2026 | Alinhamento Tecnico | Custom Forms, Operacoes Campo |
| 27/01/2026 | Design Plataforma | Areas, Roles, Permissoes |
| 28/01/2026 | Git Workflow e GCP | Secrets, Integracoes |
| 29/01/2026 | Design System e AI Cost | Alertas, Config_Alertas |
| 30/01/2026 | Product Definition | Conectores Gold Layer |
| 02/02/2026 | Apresentacao Mockups | Estoque Virtual vs Real, Software Leomar |
| 03/02/2026 | Alinhamento Joao/Rodrigo | Entidades Fortes/Fracas |
| 04/02/2026 | Diagrama ER Plataforma | Hierarquia Admins/Owners/Orgs |

### Totais

| Dominio | Quantidade |
|---------|------------|
| Sistema/Plataforma | 11 |
| Estrutura Territorial | 6 |
| Operacoes de Graos | 5 |
| Maquinario | 5 |
| Financeiro | 7 |
| Integracoes | 3 |
| Alertas | 2 |
| Conectores | 1 + 6 regras |
| Pecuaria (Fase 2) | 3 |
| Formularios | 10 tipos |
| **TOTAL** | **~53 entidades** |

---

## 2. Camada Sistema

**Responsavel:** Joao (CTO)
**Prioridade:** P0 - Base da plataforma

### 2.1 Admins

```
ADMINS
├── admin_id (PK, UUID)
├── email (VARCHAR, UNIQUE)
├── username (VARCHAR)
├── password_hash (VARCHAR)
├── status (ENUM: ativo/inativo)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Administradores da DeepWork. Podem criar Owners e Organizations.

### 2.2 Owners

```
OWNERS
├── owner_id (PK, UUID)
├── email (VARCHAR, UNIQUE)
├── username (VARCHAR)
├── password_hash (VARCHAR)
├── phone_number (VARCHAR)
├── status (ENUM: ativo/inativo)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Donos/Clientes pagantes. Podem ter multiplas Organizations.

### 2.3 Memberships

```
MEMBERSHIPS
├── membership_id (PK, UUID)
├── owner_id (FK -> OWNERS)
├── plano (ENUM: basic/consultoria/pro_ai)
├── valor_mensal (DECIMAL)
├── data_inicio (DATE)
├── data_fim (DATE)
├── status (ENUM: ativa/cancelada/suspensa)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Assinaturas dos clientes. Relaciona Owner com plano contratado.

### 2.4 Organizations

```
ORGANIZATIONS
├── organization_id (PK, UUID)
├── owner_id (FK -> OWNERS)
├── name (VARCHAR)
├── cnpj (VARCHAR)
├── endereco (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Fazendas ou empresas do cliente. Ex: "Fazenda SOAL", "Fazenda Sao Joao".

### 2.5 Users

```
USERS
├── user_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── username (VARCHAR)
├── email (VARCHAR)
├── password_hash (VARCHAR)
├── phone_number (VARCHAR)
├── tipo (ENUM: admin/gestor/operador)
├── status (ENUM: ativo/inativo)
├── created_at (TIMESTAMP)
├── updated_at (TIMESTAMP)
└── ultimo_acesso (TIMESTAMP)
```

**Descricao:** Usuarios da organizacao. Ex: Josmar, Tiago, Valentina.

### 2.6 Perfis

```
PERFIS
├── perfil_id (PK, UUID)
├── user_id (FK -> USERS, UNIQUE)
├── foto_url (VARCHAR)
├── cargo (VARCHAR)
├── preferencias_json (JSONB)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Dados complementares do usuario. Relacao 1:1 com Users.

### 2.7 Sessoes

```
SESSOES
├── sessao_id (PK, UUID)
├── user_id (FK -> USERS)
├── token (VARCHAR)
├── ip_address (VARCHAR)
├── user_agent (VARCHAR)
├── criado_em (TIMESTAMP)
├── expira_em (TIMESTAMP)
└── ativo (BOOLEAN)
```

**Descricao:** Sessoes de login ativas. Relacao 1:N com Users.

### 2.8 Departments (Areas)

```
DEPARTMENTS
├── department_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR)
├── descricao (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Departamentos/areas da organizacao. Ex: Financeiro, Maquinario, Graos.

### 2.9 Roles

```
ROLES
├── role_id (PK, UUID)
├── nome (VARCHAR)
├── codigo (VARCHAR, UNIQUE)
├── descricao (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Roles Padrao Definidas:**

| Codigo | Descricao |
|--------|-----------|
| ver_dashboard_custos | Visualizar dashboard de custos |
| ver_dashboard_estoque | Visualizar estoque de graos/silos |
| ver_dashboard_maquinario | Visualizar consumo de maquinas |
| editar_formularios | Preencher entradas de dados |
| criar_alertas | Configurar alertas personalizados |
| gerenciar_usuarios | Adicionar/remover usuarios |
| ver_relatorios_financeiros | Acesso a NF, contas a pagar/receber |
| exportar_dados | Baixar dados em CSV/Excel |
| configurar_integracoes | Gerenciar APIs externas |

### 2.10 Usuario_Roles

```
USUARIO_ROLES
├── user_id (PK, FK -> USERS)
├── role_id (PK, FK -> ROLES)
├── granted_at (TIMESTAMP)
└── granted_by (FK -> USERS)
```

**Descricao:** Tabela N:N entre Users e Roles.

### 2.11 Area_Usuarios

```
AREA_USUARIOS
├── department_id (PK, FK -> DEPARTMENTS)
├── user_id (PK, FK -> USERS)
├── atribuido_em (TIMESTAMP)
└── atribuido_por (FK -> USERS)
```

**Descricao:** Tabela N:N entre Departments e Users.

---

## 3. Camada Estrutura Territorial

**Responsavel:** Rodrigo (Mapeamento) + Joao (Implementacao)
**Prioridade:** P0

### 3.1 Fazendas

```
FAZENDAS
├── fazenda_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR)
├── area_hectares (DECIMAL)
├── localizacao (VARCHAR)
├── latitude (DECIMAL)
├── longitude (DECIMAL)
├── ativa (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Exemplos SOAL:** Santana do Iapo, Sao Joao

### 3.2 Talhoes

```
TALHOES
├── talhao_id (PK, UUID)
├── fazenda_id (FK -> FAZENDAS)
├── nome (VARCHAR)
├── nome_normalizado (VARCHAR)
├── area_hectares (DECIMAL)
├── tipo_solo (VARCHAR)
├── coordenadas (GEOMETRY)
├── observacoes (TEXT)
├── ativo (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Tabela DE-PARA (Descoberta 16/01 com Tiago):**

| Nome Original (John Deere) | Nome Normalizado |
|----------------------------|------------------|
| Bonim | Bonin |
| Boninho | Bonin |
| Bonin lado esquerdo | Bonin |
| Bonin lado direito | Bonin |

### 3.3 Silos

```
SILOS
├── silo_id (PK, UUID)
├── fazenda_id (FK -> FAZENDAS)
├── nome (VARCHAR)
├── capacidade_toneladas (DECIMAL)
├── tipo (ENUM: graneleiro/bag/armazem)
├── tem_aeracao (BOOLEAN)
├── tem_termometria (BOOLEAN)
├── ativo (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Quantidade SOAL:** 7-8 silos

### 3.4 Safras

```
SAFRAS
├── safra_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR)
├── data_inicio (DATE)
├── data_fim (DATE)
├── ativa (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Exemplo:** Safra 2025/26

### 3.5 Culturas

```
CULTURAS
├── cultura_id (PK, UUID)
├── nome (VARCHAR)
├── codigo (VARCHAR)
├── ciclo_dias (INTEGER)
├── epoca_plantio (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Culturas SOAL:** SOJA, MILHO, FEIJAO, TRIGO

### 3.6 Talhao_Safra

```
TALHAO_SAFRA
├── talhao_id (PK, FK -> TALHOES)
├── safra_id (PK, FK -> SAFRAS)
├── cultura_id (FK -> CULTURAS)
├── area_plantada (DECIMAL)
├── produtividade_estimada (DECIMAL)
├── produtividade_real (DECIMAL)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Descricao:** Tabela N:N que registra o que foi plantado em cada talhao por safra.

---

## 4. Camada Operacoes de Graos

**Responsavel:** Rodrigo (Mapeamento com Josmar)
**Prioridade:** P0 - CORE DO NEGOCIO

### 4.1 Entradas_Graos (ENTIDADE MAIS CRITICA)

```
ENTRADAS_GRAOS
├── entrada_id (PK, UUID)
├── data_hora (TIMESTAMP)
├── operador_id (FK -> USERS)
├── placa_caminhao (VARCHAR)
├── motorista (VARCHAR)
├── cultura_id (FK -> CULTURAS)
├── talhao_origem_id (FK -> TALHOES)
├── fazenda_origem_id (FK -> FAZENDAS)
├── peso_bruto_kg (DECIMAL)
├── umidade_percentual (DECIMAL)
├── impureza_percentual (DECIMAL)
├── peso_liquido_estimado_kg (DECIMAL)
├── silo_destino_id (FK -> SILOS)
├── is_semente_propria (BOOLEAN)
├── quantidade_semente_kg (DECIMAL)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Formula de Calculo:**
```
peso_liquido_estimado = peso_bruto
                        - (peso_bruto * umidade_percentual / 100)
                        - (peso_bruto * impureza_percentual / 100)
```

**Campos do Caderno do Josmar (a validar na visita):**
- Data e hora
- Placa do caminhao
- Nome do motorista
- De qual talhao veio
- Peso bruto (balanca)
- % umidade (analise)
- % sujeira/impureza (analise)
- Para qual silo vai
- Se e semente propria
- Observacoes

### 4.2 Saidas_Graos

```
SAIDAS_GRAOS
├── saida_id (PK, UUID)
├── data_hora (TIMESTAMP)
├── operador_id (FK -> USERS)
├── silo_origem_id (FK -> SILOS)
├── cultura_id (FK -> CULTURAS)
├── peso_kg (DECIMAL)
├── destino (VARCHAR)
├── tipo_saida (ENUM: venda/transferencia/consumo)
├── nota_fiscal (VARCHAR)
├── preco_por_saca (DECIMAL)
├── comprador (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 4.3 Estoque_Silos

```
ESTOQUE_SILOS
├── estoque_id (PK, UUID)
├── silo_id (FK -> SILOS)
├── cultura_id (FK -> CULTURAS)
├── data_posicao (DATE)
├── quantidade_virtual_kg (DECIMAL)
├── quantidade_real_kg (DECIMAL)
├── umidade_media (DECIMAL)
├── temperatura_media (DECIMAL)
├── ultima_atualizacao (TIMESTAMP)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Conceito Virtual vs Real (Descoberta 02/02):**
> "O que tem na planilha e um estoque virtual, sabe? Nao e o estoque real."
> - Claudio Kugler

O Leomar calcula com desconto MAIOR (margem seguranca) -> gera "sobra tecnica".

### 4.4 Quebras_Producao

```
QUEBRAS_PRODUCAO
├── quebra_id (PK, UUID)
├── safra_id (FK -> SAFRAS)
├── cultura_id (FK -> CULTURAS)
├── silo_id (FK -> SILOS)
├── data_apuracao (DATE)
├── peso_entrada_total_kg (DECIMAL)
├── peso_saida_total_kg (DECIMAL)
├── quebra_estimada_kg (DECIMAL)
├── quebra_real_kg (DECIMAL)
├── diferenca_kg (DECIMAL)
├── percentual_quebra (DECIMAL)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Oportunidade de Controle (Rodrigo 03/02):**
> "Quem que garante que o cara nao pega e descarrega 20 sacas de feijao e bota na quebra?"
> 20 sacas de feijao = R$ 3.000-4.000 de desvio potencial

### 4.5 Registros_Balanca

```
REGISTROS_BALANCA
├── registro_id (PK, UUID)
├── data_hora (TIMESTAMP)
├── placa_caminhao (VARCHAR)
├── peso_bruto_kg (DECIMAL)
├── peso_tara_kg (DECIMAL)
├── peso_liquido_kg (DECIMAL)
├── operador (VARCHAR)
├── observacoes (TEXT)
├── fonte (ENUM: planilha_drive/manual)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Fonte:** Planilha da Vanessa no Drive

---

## 5. Camada Maquinario

**Responsavel:** Rodrigo (Mapeamento com Tiago)
**Prioridade:** P1

### 5.1 Maquinas

```
MAQUINAS
├── maquina_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── tipo (ENUM: trator/colheitadeira/pulverizador/caminhao/patrola)
├── marca (VARCHAR)
├── modelo (VARCHAR)
├── ano (INTEGER)
├── potencia_cv (INTEGER)
├── numero_serie (VARCHAR)
├── tag_vestro (VARCHAR)
├── tag_john_deere (VARCHAR)
├── capacidade_tanque_litros (DECIMAL)
├── horimetro_atual (DECIMAL)
├── status (ENUM: ativa/manutencao/inativa)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Parque SOAL (Descoberta 16/01):**
- Tratores John Deere: 4 (2 com telemetria)
- Colheitadeiras: telemetria parcial
- Patrolas 1990: SEM telemetria
- Caminhoes: SEM telemetria

### 5.2 Operadores

```
OPERADORES
├── operador_id (PK, UUID)
├── user_id (FK -> USERS)
├── carteira_habilitacao (VARCHAR)
├── categoria_cnh (VARCHAR)
├── validade_cnh (DATE)
├── ativo (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 5.3 Abastecimentos

```
ABASTECIMENTOS
├── abastecimento_id (PK, UUID)
├── data_hora (TIMESTAMP)
├── maquina_id (FK -> MAQUINAS)
├── operador_id (FK -> USERS)
├── litros (DECIMAL)
├── horimetro_leitura (DECIMAL)
├── horimetro_anterior (DECIMAL)
├── consumo_litros_hora (DECIMAL)
├── fazenda_id (FK -> FAZENDAS)
├── cultura_id (FK -> CULTURAS)
├── tanque_origem (VARCHAR)
├── fonte (ENUM: vestro/manual)
├── vestro_sync_id (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Fluxo Atual Vestro (Problema Identificado 16/01):**
1. Operador abastece e lanca no App Vestro (as vezes erra horimetro)
2. Tiago exporta relatorio a cada 15/30 dias
3. Tiago CORRIGE LINHA POR LINHA no Excel
4. Tiago ADICIONA COLUNAS (fazenda, operacao)
5. Valentina DIGITA MANUALMENTE no AgriWin

**Solucao DeepWork:** N8N coleta API Vestro diariamente + regra corrige horimetros automaticamente.

### 5.4 Operacoes_Campo

```
OPERACOES_CAMPO
├── operacao_id (PK, UUID)
├── maquina_id (FK -> MAQUINAS)
├── operador_id (FK -> USERS)
├── talhao_id (FK -> TALHOES)
├── cultura_id (FK -> CULTURAS)
├── tipo_operacao (ENUM: plantio/pulverizacao/colheita/gradagem)
├── data_inicio (TIMESTAMP)
├── data_fim (TIMESTAMP)
├── area_trabalhada_ha (DECIMAL)
├── velocidade_media_kmh (DECIMAL)
├── combustivel_consumido_litros (DECIMAL)
├── dados_telemetria_json (JSONB)
├── fonte (ENUM: john_deere/manual)
├── john_deere_sync_id (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Fonte:** API John Deere Operations Center

### 5.5 Manutencoes

```
MANUTENCOES
├── manutencao_id (PK, UUID)
├── maquina_id (FK -> MAQUINAS)
├── data (DATE)
├── tipo (ENUM: preventiva/corretiva/troca_oleo)
├── descricao (TEXT)
├── horimetro (DECIMAL)
├── custo (DECIMAL)
├── pecas_utilizadas (TEXT)
├── responsavel (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 6. Camada Financeiro

**Responsavel:** Rodrigo (Mapeamento com Valentina e Claudio)
**Prioridade:** P1

### 6.1 Custos

```
CUSTOS
├── custo_id (PK, UUID)
├── safra_id (FK -> SAFRAS)
├── fazenda_id (FK -> FAZENDAS)
├── cultura_id (FK -> CULTURAS)
├── categoria (ENUM: insumos/diesel/mao_obra/manutencao/arrendamento)
├── subcategoria (VARCHAR)
├── descricao (VARCHAR)
├── valor (DECIMAL)
├── data (DATE)
├── nota_fiscal (VARCHAR)
├── fornecedor (VARCHAR)
├── rateio_tipo (ENUM: por_area/por_cultura/direto)
├── fonte (ENUM: castrolanda/manual/vestro)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Metodo de Rateio (Claudio 02/02):**
- DIESEL: Rateio proporcional por hectare de cultura plantada
- MAO DE OBRA: Rateio por area (simplificado)

### 6.2 Insumos_Castrolanda

```
INSUMOS_CASTROLANDA
├── insumo_id (PK, UUID)
├── data_compra (DATE)
├── nota_fiscal (VARCHAR)
├── produto (VARCHAR)
├── quantidade (DECIMAL)
├── unidade (VARCHAR)
├── valor_unitario (DECIMAL)
├── valor_total (DECIMAL)
├── cultura_destino_id (FK -> CULTURAS)
├── safra_id (FK -> SAFRAS)
├── castrolanda_sync_id (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Importancia (02/02):** "90% das notas de emissao sao pela Castrolanda."

### 6.3 Notas_Fiscais

```
NOTAS_FISCAIS
├── nota_id (PK, UUID)
├── numero (VARCHAR)
├── serie (VARCHAR)
├── data_emissao (DATE)
├── fornecedor_cnpj (VARCHAR)
├── fornecedor_nome (VARCHAR)
├── valor_total (DECIMAL)
├── chave_acesso (VARCHAR)
├── xml_path (VARCHAR)
├── status (ENUM: pendente/processada/cancelada)
├── processado_por_id (FK -> USERS)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Fonte:** Valentina / XML SEFAZ

### 6.4 Vendas_Graos

```
VENDAS_GRAOS
├── venda_id (PK, UUID)
├── safra_id (FK -> SAFRAS)
├── cultura_id (FK -> CULTURAS)
├── data_venda (DATE)
├── quantidade_sacas (DECIMAL)
├── preco_saca (DECIMAL)
├── valor_total (DECIMAL)
├── comprador (VARCHAR)
├── nota_fiscal (VARCHAR)
├── tipo (ENUM: spot/contrato_futuro/barter)
├── data_entrega (DATE)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 6.5 Projecao_Vendas

```
PROJECAO_VENDAS
├── projecao_id (PK, UUID)
├── safra_id (FK -> SAFRAS)
├── cultura_id (FK -> CULTURAS)
├── quantidade_sacas_prevista (DECIMAL)
├── preco_medio_esperado (DECIMAL)
├── data_previsao (DATE)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Fonte:** Planilha do Claudio com projecao ate 2032

### 6.6 Contas_Pagar

```
CONTAS_PAGAR
├── conta_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── descricao (VARCHAR)
├── fornecedor (VARCHAR)
├── valor (DECIMAL)
├── data_vencimento (DATE)
├── data_pagamento (DATE)
├── status (ENUM: pendente/paga/atrasada)
├── categoria (VARCHAR)
├── nota_fiscal_id (FK -> NOTAS_FISCAIS)
├── safra_id (FK -> SAFRAS)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 6.7 Contas_Receber

```
CONTAS_RECEBER
├── conta_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── descricao (VARCHAR)
├── cliente (VARCHAR)
├── valor (DECIMAL)
├── data_vencimento (DATE)
├── data_recebimento (DATE)
├── status (ENUM: pendente/recebida/atrasada)
├── venda_id (FK -> VENDAS_GRAOS)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 7. Camada Integracoes

**Responsavel:** Joao (CTO)
**Prioridade:** P1

### 7.1 Integracoes

```
INTEGRACOES
├── integracao_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── tipo (ENUM: john_deere/vestro/castrolanda/agriwin)
├── nome (VARCHAR)
├── api_key (VARCHAR, ENCRYPTED)
├── api_secret (VARCHAR, ENCRYPTED)
├── token (VARCHAR, ENCRYPTED)
├── token_expira_em (TIMESTAMP)
├── ultima_sincronizacao (TIMESTAMP)
├── status (ENUM: ativa/erro/inativa)
├── config_json (JSONB)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Seguranca (Joao 03/02):**
- Credenciais NUNCA em GitHub
- Uso de GCP Secret Manager
- Ambiente dev isolado em VM Hostinger

### 7.2 Secrets

```
SECRETS
├── secret_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── chave (VARCHAR)
├── valor_criptografado (VARCHAR)
├── tipo (ENUM: api_key/password/token)
├── expira_em (TIMESTAMP)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 7.3 Logs_Integracao

```
LOGS_INTEGRACAO
├── log_id (PK, UUID)
├── integracao_id (FK -> INTEGRACOES)
├── data_hora (TIMESTAMP)
├── tipo (ENUM: sucesso/erro/warning)
├── mensagem (TEXT)
├── registros_processados (INTEGER)
├── detalhes_json (JSONB)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 8. Camada Alertas

**Responsavel:** Joao (Implementacao)
**Prioridade:** P2

### 8.1 Alertas

```
ALERTAS
├── alerta_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── tipo (ENUM: estoque_baixo/manutencao/integracao_erro/consumo_anormal/resumo)
├── titulo (VARCHAR)
├── mensagem (TEXT)
├── severidade (ENUM: info/warning/error/critical)
├── entidade_tipo (VARCHAR)
├── entidade_id (UUID)
├── criado_em (TIMESTAMP)
├── lido_em (TIMESTAMP)
├── resolvido_em (TIMESTAMP)
├── resolvido_por_id (FK -> USERS)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Tipos de Alertas (Reuniao 30/01):**

| Tipo | Exemplo |
|------|---------|
| Acao/Reacao | "Se estoque glifosato < 100L, avise" |
| Resumo | "Resumo diario as 18h no WhatsApp" |
| Tecnico | "Falha integracao John Deere" |
| Anomalia | "Trator X consumiu 25L/h (media: 10L/h)" |

### 8.2 Config_Alertas

```
CONFIG_ALERTAS
├── config_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── user_id (FK -> USERS)
├── tipo_alerta (ENUM)
├── condicao_json (JSONB)
├── canais_notificacao (VARCHAR)
├── ativo (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Exemplo condicao_json:**
```json
{
  "campo": "estoque_litros",
  "operador": "<",
  "valor": 100,
  "entidade": "diesel"
}
```

---

## 9. Camada Conectores Gold Layer

**Responsavel:** Joao (Implementacao) + Rodrigo (Definicao de Regras)
**Prioridade:** P2

### 9.1 Conectores

```
CONECTORES
├── conector_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR)
├── fonte_a_tipo (VARCHAR)
├── fonte_a_campo (VARCHAR)
├── fonte_b_tipo (VARCHAR)
├── fonte_b_campo (VARCHAR)
├── chave_ligacao (VARCHAR)
├── janela_tempo_minutos (INTEGER)
├── regra_cruzamento_json (JSONB)
├── ativo (BOOLEAN)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 9.2 Conectores Identificados

| # | Nome | Fonte A | Fonte B | Chave | Resultado |
|---|------|---------|---------|-------|-----------|
| 1 | Entrada ↔ Balanca | ENTRADAS_GRAOS | REGISTROS_BALANCA | placa + tempo (30min) | Validacao peso |
| 2 | Abastecimento ↔ Operacao | ABASTECIMENTOS | OPERACOES_CAMPO | maquina + tempo | Custo diesel por operacao |
| 3 | Entrada ↔ Estoque | ENTRADAS_GRAOS | ESTOQUE_SILOS | silo + cultura + data | Reconciliacao virtual/real |
| 4 | Custo ↔ Area | CUSTOS | TALHAO_SAFRA | safra + cultura | R$/hectare |
| 5 | Insumo ↔ Aplicacao | INSUMOS_CASTROLANDA | OPERACOES_CAMPO | cultura + tempo + produto | Rastreabilidade |
| 6 | Venda ↔ Saida | VENDAS_GRAOS | SAIDAS_GRAOS | nota_fiscal OU (cultura + data + qtd) | Reconciliacao |

---

## 10. Camada Pecuaria Fase 2

**Responsavel:** Rodrigo (Mapeamento futuro)
**Prioridade:** P3

### 10.1 Animais

```
ANIMAIS
├── animal_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── identificacao (VARCHAR)
├── raca (VARCHAR)
├── sexo (ENUM: macho/femea)
├── data_nascimento (DATE)
├── peso_atual_kg (DECIMAL)
├── status (ENUM: ativo/vendido/morto)
├── lote (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 10.2 Manejos

```
MANEJOS
├── manejo_id (PK, UUID)
├── animal_id (FK -> ANIMAIS)
├── data (DATE)
├── tipo (ENUM: pesagem/vacinacao/vermifugo/outro)
├── peso_kg (DECIMAL)
├── produto (VARCHAR)
├── observacoes (TEXT)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 10.3 Vendas_Gado

```
VENDAS_GADO
├── venda_id (PK, UUID)
├── animal_id (FK -> ANIMAIS)
├── data_venda (DATE)
├── peso_venda_kg (DECIMAL)
├── preco_arroba (DECIMAL)
├── valor_total (DECIMAL)
├── comprador (VARCHAR)
├── nota_fiscal (VARCHAR)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

**Notas (02/02):**
- Rebanho estimado: ~1000 cabecas
- A mapear: tem brinco eletronico?
- Modulo separado dentro da mesma plataforma

---

## 11. Formularios Padrao

**Responsavel:** Rodrigo (Definicao) + Joao (Implementacao)
**Prioridade:** P0

### 11.1 Lista de Formularios

| Codigo | Nome | Entidade Alvo | Usuario |
|--------|------|---------------|---------|
| form_dryer | Entrada no Secador | ENTRADAS_GRAOS | Josmar |
| form_truck | Registro Caminhao/Balanca | REGISTROS_BALANCA | Vanessa |
| form_fuel | Abastecimento | ABASTECIMENTOS | Operadores |
| form_accounts_payable | Contas a Pagar | CONTAS_PAGAR | Valentina |
| form_accounts_receivable | Contas a Receber | CONTAS_RECEBER | Valentina |
| form_harvest | Safra/Planejamento | SAFRAS | Claudio |
| form_grain | Graos/Culturas | CULTURAS | Manual |
| form_machinery | Maquinario/Frota | MAQUINAS | Tiago |
| form_exit_grain | Saida de Graos | SAIDAS_GRAOS | Josmar |
| form_maintenance | Manutencao | MANUTENCOES | Tiago |

### 11.2 Custom Forms

```
CUSTOM_FORMS
├── form_id (PK, UUID)
├── organization_id (FK -> ORGANIZATIONS)
├── nome (VARCHAR)
├── descricao (TEXT)
├── campos_json (JSONB)
├── ativo (BOOLEAN)
├── criado_por_id (FK -> USERS)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

### 11.3 Form_Entries

```
FORM_ENTRIES
├── entry_id (PK, UUID)
├── form_id (FK -> CUSTOM_FORMS)
├── user_id (FK -> USERS)
├── dados_json (JSONB)
├── created_at (TIMESTAMP)
└── updated_at (TIMESTAMP)
```

---

## 12. Matriz de Relacionamentos

### 12.1 Cardinalidades

| Entidade A | Entidade B | Cardinalidade |
|------------|------------|---------------|
| ORGANIZATIONS | FAZENDAS | 1:N |
| ORGANIZATIONS | USERS | 1:N |
| ORGANIZATIONS | SAFRAS | 1:N |
| ORGANIZATIONS | INTEGRACOES | 1:N |
| ORGANIZATIONS | ALERTAS | 1:N |
| ORGANIZATIONS | DEPARTMENTS | 1:N |
| FAZENDAS | TALHOES | 1:N |
| FAZENDAS | SILOS | 1:N |
| USERS | PERFIS | 1:1 |
| USERS | SESSOES | 1:N |
| USERS | ROLES | N:N |
| USERS | DEPARTMENTS | N:N |
| TALHOES | SAFRAS | N:N |
| TALHOES | CULTURAS | N:N |
| TALHOES | ENTRADAS_GRAOS | 1:N |
| TALHOES | OPERACOES_CAMPO | 1:N |
| SILOS | ENTRADAS_GRAOS | 1:N |
| SILOS | SAIDAS_GRAOS | 1:N |
| SILOS | ESTOQUE_SILOS | 1:N |
| CULTURAS | ENTRADAS_GRAOS | 1:N |
| CULTURAS | SAIDAS_GRAOS | 1:N |
| CULTURAS | CUSTOS | 1:N |
| CULTURAS | VENDAS_GRAOS | 1:N |
| CULTURAS | ABASTECIMENTOS | 1:N |
| MAQUINAS | ABASTECIMENTOS | 1:N |
| MAQUINAS | OPERACOES_CAMPO | 1:N |
| MAQUINAS | MANUTENCOES | 1:N |
| SAFRAS | CUSTOS | 1:N |
| SAFRAS | VENDAS_GRAOS | 1:N |
| SAFRAS | PROJECAO_VENDAS | 1:N |
| SAFRAS | INSUMOS_CASTROLANDA | 1:N |
| INTEGRACOES | LOGS_INTEGRACAO | 1:N |
| NOTAS_FISCAIS | CONTAS_PAGAR | 1:N |
| VENDAS_GRAOS | CONTAS_RECEBER | 1:1 |
| ANIMAIS | MANEJOS | 1:N |
| ANIMAIS | VENDAS_GADO | 1:1 |

### 12.2 Entidades Fortes vs Fracas

| Classificacao | Entidades | Justificativa |
|---------------|-----------|---------------|
| **FORTE** | USERS, ENTRADAS_GRAOS, CUSTOS, NOTAS_FISCAIS, MAQUINAS, INTEGRACOES, VENDAS_GRAOS | Dados sensiveis/core do negocio |
| **FRACA** | ABASTECIMENTOS, OPERACOES_CAMPO, LOGS_INTEGRACAO, ALERTAS, ESTOQUE_SILOS, MANEJOS | Alto volume, dados de telemetria/auditoria |

**Insight Joao (03/02):**
> "Quanto mais forte entidade de negocio, mais dinheiro provavelmente ele ganha com aquela entidade."

---

## 13. Proximos Passos

### 13.1 Visita Fisica (Sabado)

- [ ] Fotografar caderno do Josmar
- [ ] Fotografar tela do software Leomar
- [ ] Coletar planilha de frota do Tiago
- [ ] Coletar planilha de projecao do Claudio ate 2032
- [ ] Testar Wi-Fi no secador
- [ ] Validar campos de cada formulario

### 13.2 Apos a Visita

- [ ] Atualizar este documento com dados reais
- [ ] Criar Diagrama ER visual no Miro
- [ ] Validar com Joao a modelagem tecnica
- [ ] Apresentar para Claudio para validacao
- [ ] Iniciar modelagem do banco PostgreSQL

### 13.3 Prioridades de Implementacao

| Fase | Entidades | Prazo |
|------|-----------|-------|
| MVP (P0) | ENTRADAS_GRAOS, ESTOQUE_SILOS, MAQUINAS, ABASTECIMENTOS, CUSTOS | Fev-Mar/2026 |
| Fase 1 (P1) | Integracao Vestro, John Deere, Notas Fiscais | Mar-Abr/2026 |
| Fase 2 (P2) | Conectores Gold Layer, Alertas | Abr-Mai/2026 |
| Fase 3 (P3) | Pecuaria | Jun/2026+ |

---

## Glossario

| Termo | Definicao |
|-------|-----------|
| **PK** | Primary Key (Chave Primaria) |
| **FK** | Foreign Key (Chave Estrangeira) |
| **UUID** | Universally Unique Identifier |
| **1:1** | Um para Um |
| **1:N** | Um para Muitos |
| **N:N** | Muitos para Muitos |
| **Bronze** | Camada de dados brutos |
| **Silver** | Camada de dados tratados |
| **Gold** | Camada de dados cruzados/agregados |
| **Entidade Forte** | Dados sensiveis/core do negocio |
| **Entidade Fraca** | Dados de volume/auditoria |

---

**Documento preparado por:** Rodrigo Kugler + Claude (DeepWork AI Flows)
**Data:** 04/02/2026
**Versao:** 2.0
**Diagrama Miro:** https://miro.com/app/board/uXjVGFydjCo=/

---

> "A plataforma e o front depende muito disso. Esse daqui que a gente precisa, com isso daqui e o ouro da nossa plataforma."
> -- Joao Balzer, CTO (03/02/2026)
