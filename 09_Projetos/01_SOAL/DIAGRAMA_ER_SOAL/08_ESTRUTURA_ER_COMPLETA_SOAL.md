# ESTRUTURA ER COMPLETA - SOAL

**Data:** 06/02/2026 (atualizado 09/02/2026)
**Versao:** 1.1 - Modulo Insumos e Estoque incorporado (doc 15)
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## Visao Geral

Este documento apresenta a estrutura completa do modelo ER (Entity-Relationship) do sistema SOAL, organizado em 7 camadas funcionais com aproximadamente 88 entidades.

---

## CAMADA SISTEMA (y=-6000)

**Cor:** Azul (#c6dcff)

### Sistema RBAC (x=-6000)

```
ADMINS
   │
   ▼
OWNERS
   │
   ▼
ORGANIZATIONS
   │
   ├──► ORGANIZATION_SETTINGS
   │
   ▼
USERS
   │
   ├──► ROLES ◄──► PERMISSIONS
   │       │
   │       ▼
   └──► USER_ROLES
```

**Entidades:**
| Entidade | Descricao |
|----------|-----------|
| ADMINS | Administradores do sistema (nivel mais alto) |
| OWNERS | Proprietarios de organizacoes |
| ORGANIZATIONS | Organizacoes/empresas clientes |
| ORGANIZATION_SETTINGS | Configuracoes por organizacao |
| USERS | Usuarios do sistema |
| ROLES | Papeis de acesso |
| PERMISSIONS | Permissoes granulares |
| USER_ROLES | Associacao usuario-papel |
| ROLE_PERMISSIONS | Associacao papel-permissao |
| USER_PERMISSIONS | Permissoes diretas do usuario |
| INVITE_TOKENS | Tokens de convite |

### Formularios (x=2000)

```
CUSTOM_FORMS
   │
   ▼
FORM_ENTRIES
```

**Entidades:**
| Entidade | Descricao |
|----------|-----------|
| CUSTOM_FORMS | Definicao de formularios customizados |
| FORM_ENTRIES | Respostas/entradas dos formularios |

---

## CAMADA TERRITORIAL (y=-2000)

**Cor:** Verde Limao (#dbfaad)

### Cadastros Territoriais (x=-4000)

```
FAZENDAS
   │
   ├──► TALHOES ◄──► TALHAO_SAFRA ◄──► SAFRAS
   │                                      │
   ├──► SILOS                             │
   │                                      │
   └──────────────────────────────────────┘
                                          │
CULTURAS ◄────────────────────────────────┘
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| FAZENDAS | nome, cnpj, inscricao_estadual, car, area_total_ha, geojson |
| TALHOES | codigo, nome, area_ha, tipo_solo, geojson |
| SILOS | codigo, capacidade_ton, tipo, localizacao |
| SAFRAS | ano_agricola, data_inicio, data_fim |
| CULTURAS | nome, codigo, ciclo_dias |
| TALHAO_SAFRA | talhao_id, safra_id, cultura_id, epoca, area_plantada_ha, cultivar, gleba, origem_semente, data_plantio_prevista, data_plantio, data_colheita, produtividade_sc_ha, status_planejamento, meta_produtividade_sc_ha |

### Contratos Terra (x=4000)

```
PARCEIRO_COMERCIAL (fornecedor + cliente + arrendador)
   │
   ▼
CONTRATO_ARRENDAMENTO
   │
   └──► Vincula TALHOES
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| PARCEIRO_COMERCIAL | razao_social, cnpj_cpf, tipo (fornecedor/cliente/arrendador/transportador) |
| CONTRATO_ARRENDAMENTO | numero, data_inicio, data_fim, valor_ha, forma_pagamento |

---

## CAMADA AGRICOLA (y=2000-5000)

**Cor:** Amarelo (#fff6b6)

### Ciclo Produtivo (x=-10000, y=2000)

```
PLANTIO ──────────────────────────► COLHEITA
   │                                    │
   └──► TALHAO_SAFRA ◄──────────────────┘
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| PLANTIO | data_plantio, populacao_sementes, espacamento, profundidade |
| COLHEITA | data_colheita, peso_bruto, peso_liquido, umidade, produtividade_sc_ha |

### Silos e Estoque (x=-10000, y=5000)

```
TICKET_BALANCA
   │
   ▼
ENTRADA_GRAO ──────► CLASSIFICACAO_GRAO
   │
   ▼
ESTOQUE_SILO ◄───── MOVIMENTACAO_SILO (tipo: entrada/saida/transferencia/quebra)
   │
   ▼
SAIDA_GRAO
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| TICKET_BALANCA | numero, peso_bruto, peso_tara, peso_liquido, placa_veiculo |
| ENTRADA_GRAO | quantidade_kg, umidade, impurezas, origem |
| CLASSIFICACAO_GRAO | tipo_grao, ph, ardidos, quebrados, mofados |
| ESTOQUE_SILO | silo_id, cultura_id, quantidade_atual_kg, safra_id |
| MOVIMENTACAO_SILO | tipo (entrada/saida/transferencia/quebra), quantidade_kg |
| SAIDA_GRAO | quantidade_kg, destino, nota_fiscal_id |

### Modulo Insumos e Estoque (x=-5000, y=2000-4500) [doc 15]

```
PRODUTO_INSUMO (catalogo: semente, fertilizante, defensivo, adjuvante, etc.)
   │
   ├──► COMPRA_INSUMO (registro compra: Castrolanda, revenda, barter, etc.)
   │       │
   │       └──► MOVIMENTACAO_INSUMO (tipo: entrada_compra)
   │                   │
   │                   ▼
   ├──► ESTOQUE_INSUMO (saldo por produto + local, custo medio ponderado)
   │       │
   │       └──► MOVIMENTACAO_INSUMO (tipo: saida_aplicacao)
   │                   │
   │                   ▼
   ├──► APLICACAO_INSUMO (uso no campo/pecuaria/manutencao)
   │       │
   │       └──► CUSTO_OPERACAO (tipo: insumo)
   │
   └──► RECEITUARIO_AGRONOMICO (Compliance MAPA)
```

**Entidades:**
| Entidade | Campos Chave | Status |
|----------|--------------|--------|
| PRODUTO_INSUMO | codigo, nome, principio_ativo, tipo (21 ENUMs), grupo (agricola/pecuario/geral), unidade_medida, fabricante, registro_mapa, classe_toxicologica, carencia_dias, dose_recomendada_min/max | NOVA (substitui INSUMO) |
| COMPRA_INSUMO | produto_insumo_id, nota_fiscal_item_id, parceiro_id, safra_id, fonte (ENUM), data_compra, quantidade, valor_unitario, valor_total, lote_fabricante, data_validade, castrolanda_sync_id, contrato_barter_id, status | NOVA (substitui INSUMOS_CASTROLANDA) |
| ESTOQUE_INSUMO | produto_insumo_id, fazenda_id, local_armazenamento, quantidade_atual, custo_medio_unitario, valor_total_estoque, quantidade_minima, validade_mais_proxima, status | NOVA |
| MOVIMENTACAO_INSUMO | estoque_insumo_id, tipo (12 ENUMs), quantidade, custo_unitario, saldo_anterior/posterior, custo_medio_anterior/posterior, compra_insumo_id, aplicacao_insumo_id | NOVA |
| APLICACAO_INSUMO | produto_insumo_id, estoque_insumo_id, operacao_campo_id, talhao_safra_id, manejo_sanitario_id, manutencao_id, receituario_id, dose_por_ha, area_aplicada_ha, quantidade_total, custo_unitario, custo_total, metodo_aplicacao (ENUM), contexto (ENUM) | REFATORADA |
| RECEITUARIO_AGRONOMICO | produto_insumo_id, numero_receita, numero_art, responsavel_tecnico, crea, cultura_id, dose_prescrita, intervalo_seguranca_dias, arquivo_url | AJUSTADA (FK renomeada) |

**Ciclo de Vida do Insumo:** Compra → Estoque → Aplicacao → Custo
**Custeio:** Custo Medio Ponderado

**Regra:** 1 OPERACAO_CAMPO pode ter N APLICACAO_INSUMO
- Ex: Plantio = semente + inoculante + adubo base + tratamento semente
- Ex: Pulverizacao = fungicida + adjuvante

**Nota:** PULVERIZACAO_DETALHE = dados TECNICOS (pressao, vazao, clima)
         APLICACAO_INSUMO = dados de PRODUTO (qual, quanto, custo) — Complementam, nao duplicam.

### Solo (x=-6000, y=5000)

```
ANALISE_SOLO
   │
   ▼
RECOMENDACAO_ADUBACAO
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| ANALISE_SOLO | talhao_id, data_coleta, ph, materia_organica, P, K, Ca, Mg, Al, CTC, V |
| RECOMENDACAO_ADUBACAO | analise_id, cultura_id, N_kg_ha, P2O5_kg_ha, K2O_kg_ha, calagem_t_ha |

---

## CAMADA OPERACIONAL (y=2000-5000)

**Cor:** Ciano (#ccf4ff)

### Maquinario (x=6000, y=2000)

```
MAQUINAS ◄────────────────────────────────────┐
   │                                           │
   ├──► ABASTECIMENTOS ◄──── OPERADORES ──────┤
   │                              │            │
   ├──► MANUTENCOES ◄─────────────┤            │
   │                              │            │
   └──► OPERACOES_CAMPO ◄─────────┴────────────┘
           │
           └──► geojson_trajeto, rendimento_ha_hora
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| MAQUINAS | codigo_interno, tipo, marca, modelo, placa, horimetro_atual, hodometro_atual |
| OPERADORES | nome, cpf, cnh_numero, cnh_categoria, cnh_validade |
| ABASTECIMENTOS | maquina_id, tipo_combustivel, quantidade_litros, horimetro_momento |
| MANUTENCOES | maquina_id, tipo (preventiva/corretiva/preditiva), custo_total |
| OPERACOES_CAMPO | maquina_id, operador_id, tipo_operacao, area_trabalhada_ha, geojson_trajeto |

### Mao de Obra (x=6000, y=5000)

```
TRABALHADOR_RURAL (CLT, safrista, diarista)
   │
   ▼
APONTAMENTO_MAO_OBRA
   │
   └──► centro_custo_id, producao_realizada
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| TRABALHADOR_RURAL | nome, cpf, cargo, setor, tipo_contrato (clt/diarista/safrista), salario_base |
| APONTAMENTO_MAO_OBRA | trabalhador_id, data_trabalho, horas_trabalhadas, tipo_atividade, centro_custo_id |

---

## CAMADA FINANCEIRO (y=8000)

**Cor:** Laranja (#f8d3af)

### Custos (x=-6000)

```
CENTRO_CUSTO (hierarquico via parent_id)
   │
   ▼
CUSTO_OPERACAO
   │
   └──► tipo: insumo, mao_obra, mecanizacao, servico, depreciacao
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| CENTRO_CUSTO | codigo, nome, tipo, nivel, parent_id, orcamento_anual |
| CUSTO_OPERACAO | centro_custo_id, tipo, valor_total, custo_por_ha, rateio_area_ha |

### Notas e Contas (x=0)

```
NOTA_FISCAL
   │
   ├──► NOTA_FISCAL_ITEM
   │
   ├──► CONTA_PAGAR ◄───── CENTRO_CUSTO
   │
   └──► CONTA_RECEBER ◄─── CONTRATO_COMERCIAL
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| NOTA_FISCAL | numero, serie, chave_nfe, cfop, valor_total, xml_url, pdf_url |
| NOTA_FISCAL_ITEM | nota_fiscal_id, descricao, ncm, quantidade, valor_unitario |
| CONTA_PAGAR | documento, data_vencimento, valor_original, valor_pago, status |
| CONTA_RECEBER | documento, data_vencimento, valor_original, valor_recebido, status |

### Contratos Comerciais (x=6000)

```
CONTRATO_COMERCIAL (venda_antecipada, barter, fixacao, CPR)
   │
   ├──► CONTRATO_ENTREGA
   │       │
   │       └──► ticket_balanca_id, nota_fiscal_id
   │
   └──► CPR_DOCUMENTO
           │
           └──► cartorio_registro, garantias
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| CONTRATO_COMERCIAL | numero, tipo (venda_antecipada/barter/fixacao/cpr), quantidade_sacas, preco_saca, moeda |
| CONTRATO_ENTREGA | contrato_id, data_entrega, quantidade_sacas, peso_liquido_kg, umidade |
| CPR_DOCUMENTO | numero_cpr, tipo_cpr (fisica/financeira), valor_face, cartorio_registro, garantias |

---

## CAMADA PECUARIA (y=12000)

**Cor:** Verde (#adf0c7)

### Cadastros Base (x=-10000)

```
RACA
   │
   ▼
ANIMAL (sisbov, brinco_visual, brinco_eletronico)
   │
   ├──► mae_id, pai_id (genealogia)
   │
   ├──► LOTE_ANIMAL
   │
   └──► PESAGEM (GMD calculado)
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| RACA | nome, codigo_abcz, especie, aptidao_principal |
| ANIMAL | sisbov, brinco_visual, brinco_eletronico, sexo, data_nascimento, categoria, peso_atual |
| LOTE_ANIMAL | codigo, nome, categoria (cria/recria/engorda/reproducao), qtd_atual |
| PESAGEM | animal_id, data_pesagem, peso_kg, gmd_kg, tipo |

### Pasto (x=-6000)

```
PASTO
   │
   ├──► PASTO_AVALIACAO (altura_forragem, disponibilidade_ms)
   │
   └──► MOVIMENTACAO_PASTO (origem/destino)
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| PASTO | codigo, area_ha, tipo_forragem, capacidade_ua, lotacao_atual_ua |
| PASTO_AVALIACAO | pasto_id, altura_entrada_cm, altura_saida_cm, disponibilidade_ms_kg_ha |
| MOVIMENTACAO_PASTO | lote_id, pasto_origem_id, pasto_destino_id, qtd_animais |

### Sanidade (x=-2000)

```
CALENDARIO_SANITARIO
   │
   ▼
MANEJO_SANITARIO (vacinacao, vermifugacao, carrapaticida)
   │
   └──► carencia_dias, data_fim_carencia

OCORRENCIA_SANITARIA (doenca, acidente, morte)
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| CALENDARIO_SANITARIO | nome_programa, tipo_manejo, produto, mes_aplicacao, categoria_animal |
| MANEJO_SANITARIO | tipo, produto, dosagem, via_aplicacao, carencia_dias, crmv |
| OCORRENCIA_SANITARIA | tipo (doenca/acidente/morte/aborto), diagnostico, tratamento, resultado |

### Reproducao (x=2000)

```
ESTACAO_MONTA
   │
   ├──► PROTOCOLO_IATF (dia_0, dia_8, dia_9, dia_10)
   │       │
   │       ▼
   └──► COBERTURA
           │
           ├──► DIAGNOSTICO_GESTACAO
           │
           └──► PARTO
                   │
                   └──► cria_id → ANIMAL
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| ESTACAO_MONTA | nome, tipo (monta_natural/iatf/ia/te/fiv), data_inicio, data_fim, taxa_prenhez |
| PROTOCOLO_IATF | nome_protocolo, dia_0_produto, dia_8_produto, dia_9_produto |
| COBERTURA | femea_id, touro_id, data_cobertura, tipo, semen_partida |
| DIAGNOSTICO_GESTACAO | femea_id, data_diagnostico, resultado, metodo, sexo_feto |
| PARTO | femea_id, data_parto, tipo_parto, peso_cria_kg, cria_id |

### Nutricao (x=6000)

```
DIETA
   │
   ├──► DIETA_INGREDIENTE (% materia seca)
   │
   └──► TRATO_ALIMENTAR
           │
           └──► COCHO
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| DIETA | nome, categoria_destino, objetivo, ms_kg_animal_dia, custo_kg_ms, gmd_esperado |
| DIETA_INGREDIENTE | dieta_id, produto_insumo_id *(renomeado de insumo_id)*, percentual_ms, kg_por_animal_dia |
| TRATO_ALIMENTAR | lote_id, dieta_id, data_trato, quantidade_total_kg, consumo_por_animal |
| COCHO | codigo, tipo (volumoso/concentrado/sal/agua), capacidade_kg |

### Comercial Pecuaria (x=10000)

```
GTA (Guia de Transito Animal)
   │
   ├──► GTA_ANIMAL (lista de animais)
   │
   ├──► VENDA_ANIMAL (arroba_preco, valor_cabeca)
   │
   └──► COMPRA_ANIMAL
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| GTA | numero_gta, finalidade, qtd_animais, uf_origem, uf_destino, veterinario_oficial |
| GTA_ANIMAL | gta_id, animal_id, sisbov, peso_kg |
| VENDA_ANIMAL | animal_id, data_venda, tipo_venda, peso_venda_kg, arroba_preco, valor_total |
| COMPRA_ANIMAL | animal_id, data_compra, tipo_compra, peso_compra_kg, valor_total |

---

## CAMADA INFRAESTRUTURA (y=16000)

**Cor:** Cinza (#e7e7e7) / Vermelho para Alertas (#ffc6c6)

### Integracoes (x=-6000)

```
INTEGRACAO (api, webhook, ftp, erp)
   │
   └──► INTEGRACAO_LOG

WEBHOOK_CONFIG
   │
   └──► WEBHOOK_DELIVERY
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| INTEGRACAO | nome, tipo, provider, endpoint_url, auth_type, status, frequencia_sync |
| INTEGRACAO_LOG | integracao_id, direcao, status_code, sucesso, duracao_ms |
| WEBHOOK_CONFIG | nome, evento_trigger, url_destino, secret_key |
| WEBHOOK_DELIVERY | webhook_id, evento, payload, response_status, sucesso |

### Alertas (x=0)

```
ALERTA_CONFIGURACAO
   │
   └──► ALERTA_DISPARO
           │
           └──► NOTIFICACAO (email, push, sms, whatsapp, in_app)
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| ALERTA_CONFIGURACAO | nome, tipo, entidade_monitorada, condicao, severidade, canais_notificacao |
| ALERTA_DISPARO | alerta_config_id, data_disparo, mensagem, status |
| NOTIFICACAO | user_id, canal, titulo, corpo, status |

### Auditoria (x=6000)

```
AUDIT_LOG
   │
   └──► DATA_CHANGE_LOG (campo, valor_antigo, valor_novo)

SESSION_LOG
   │
   └──► ERROR_LOG
```

**Entidades:**
| Entidade | Campos Chave |
|----------|--------------|
| AUDIT_LOG | user_id, entidade, acao (create/read/update/delete), dados_antes, dados_depois |
| DATA_CHANGE_LOG | audit_log_id, campo, valor_antigo, valor_novo |
| SESSION_LOG | user_id, session_token, ip_address, data_inicio, data_fim |
| ERROR_LOG | nivel, codigo_erro, mensagem, stack_trace |

---

## RESUMO QUANTITATIVO

| Camada | Entidades | Cor | Coordenada Y |
|--------|-----------|-----|--------------|
| Sistema | 11 | Azul (#c6dcff) | -6000 |
| Territorial | 8 | Verde Limao (#dbfaad) | -2000 |
| Agricola | 16 | Amarelo (#fff6b6) | 2000-5000 |
| Operacional | 7 | Ciano (#ccf4ff) | 2000-5000 |
| Financeiro | 11 | Laranja (#f8d3af) | 8000 |
| Pecuaria | 26 | Verde (#adf0c7) | 12000 |
| Infraestrutura | 11 | Cinza/Vermelho (#e7e7e7/#ffc6c6) | 16000 |
| **TOTAL** | **~90** | - | - |

> **Nota v1.1 (09/02/2026):** Camada Agricola atualizada de 14→16 entidades.
> INSUMO substituido por PRODUTO_INSUMO. INSUMOS_CASTROLANDA substituido por COMPRA_INSUMO.
> Novas: ESTOQUE_INSUMO, MOVIMENTACAO_INSUMO. Refatorada: APLICACAO_INSUMO. Detalhes em doc 15.

---

## FLUXOS PRINCIPAIS

### Fluxo de Graos (atualizado v1.1)

```
┌──────────────────────────────────────────────────────────────────────────┐
│  PLANTIO → COLHEITA → ENTRADA_GRAO → ESTOQUE_SILO → SAIDA_GRAO          │
│     ↓           ↓           ↓              ↓            ↓                │
│ APLICACAO   TICKET     CLASSIFICACAO   MOVIMENTACAO   CONTRATO           │
│ _INSUMO     BALANCA                    _SILO          COMERCIAL          │
│     ↓                                                     ↓              │
│ PRODUTO_INSUMO ← COMPRA_INSUMO ← NOTA_FISCAL_ITEM → NOTA_FISCAL        │
│     ↓                   ↓                                                │
│ RECEITUARIO      ESTOQUE_INSUMO ← MOVIMENTACAO_INSUMO                   │
│ AGRONOMICO       (custo medio ponderado)                                 │
└──────────────────────────────────────────────────────────────────────────┘
```

### Fluxo de Pecuaria

```
┌─────────────────────────────────────────────────────────────────┐
│  ANIMAL → LOTE → PASTO → MANEJO_SANITARIO → REPRODUCAO → VENDA  │
│     ↓       ↓       ↓           ↓               ↓          ↓     │
│  PESAGEM  DIETA  AVALIACAO   CALENDARIO      PARTO       GTA    │
│     ↓       ↓                                   ↓          ↓     │
│   GMD    TRATO                              ANIMAL     NF_SAIDA │
│         ALIMENTAR                           (cria)              │
└─────────────────────────────────────────────────────────────────┘
```

### Fluxo Financeiro (atualizado v1.1)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  NOTA_FISCAL → CONTA_PAGAR/RECEBER → CENTRO_CUSTO → CUSTO_OPERACAO      │
│       ↓                ↓                   ↓             ↓               │
│ NF_ITEM           PAGAMENTO           ORCAMENTO      RATEIO             │
│       ↓                ↓                                ↓                │
│ COMPRA_INSUMO     PARCEIRO_           TALHAO_SAFRA    $/HA              │
│       ↓           COMERCIAL                                              │
│ PRODUTO_INSUMO                                                           │
│       ↓                                                                  │
│ ESTOQUE_INSUMO → MOVIMENTACAO → APLICACAO_INSUMO → CUSTO_OPERACAO       │
│ (custo medio)     _INSUMO        (tipo: insumo)                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## CONVENCOES UTILIZADAS

### Nomenclatura
- **Entidades:** Singular, UPPER_SNAKE_CASE
- **Tabelas:** Plural, lower_snake_case (na implementacao)
- **PKs:** UUID (nunca auto-increment)
- **Timestamps:** created_at, updated_at em todas as entidades

### Tipos de Dados
- **UUID:** Identificadores unicos
- **VARCHAR:** Textos com limite definido
- **TEXT:** Textos longos sem limite
- **DECIMAL:** Valores monetarios e medidas precisas
- **ENUM:** Valores fixos e conhecidos
- **JSONB:** Dados flexiveis e configuracoes
- **GEOMETRY:** Dados geoespaciais (GeoJSON)
- **TIMESTAMP:** Datas e horas com timezone

### Relacionamentos
- **1:1** - Um para um (raro)
- **1:N** - Um para muitos (mais comum)
- **N:N** - Muitos para muitos (via tabela associativa)

---

## PROXIMOS PASSOS

1. [ ] Revisar cardinalidades no Miro
2. [ ] Adicionar indices recomendados
3. [ ] Gerar DDL SQL
4. [ ] Criar diagrama de dependencias
5. [ ] Documentar regras de negocio por entidade

---

*Documento gerado em 06/02/2026 - DeepWork AI Flows*
*Atualizado em 09/02/2026 - Modulo Insumos e Estoque (doc 15) incorporado, contagem atualizada para ~90 entidades*
