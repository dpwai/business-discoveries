# UBG - Unidade de Beneficiamento de Graos

**Data:** 08/02/2026
**Versao:** 2.0
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=/?focusWidget=3458764658843912862

---

## Contexto

Apos visita de campo e analise das planilhas de controle da SOAL, foi mapeado o fluxo completo pos-colheita que passa pela UBG (Unidade de Beneficiamento de Graos).

### Estrutura Fisica SOAL
- **1 UBG** centralizada para toda organizacao
- **Localizacao:** Fazenda Santana do Iapo
- **8 Silos:** 1 especial para sementes + 7 convencionais
- **Atende:** Todas as fazendas da organizacao

### Contato Tecnico
- **Leomar** - Engenheiro que presta servicos para UBG
- Tem acesso ao software do secador e da UBG
- Pode fornecer dados importantes para automacao
- **Status:** TBC - agendar conversa para coleta de insights

---

## Fluxo Completo Pos-Colheita (4 Etapas)

```
┌─────────────────────────────────────────────────────────────────────┐
│                              UBG                                     │
│         Unidade de Beneficiamento de Graos - SOAL                   │
│         Fazenda Santana do Iapo - 8 Silos                           │
│         (7 convencionais + 1 sementes/madeira)                      │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                        ┌───────────┴───────────┐
                        │                       │
                        ▼                       ▼
              ┌─────────────────┐      ┌─────────────────┐
              │      SILOS      │      │  ETAPA 1        │
              │   (8 unidades)  │      │  BALANCA        │
              │                 │      │                 │
              │ tipo:           │      │ TICKET_BALANCA  │
              │ • convencional  │      │ • peso_bruto    │
              │ • sementes      │      │ • tara          │
              │                 │      │ • peso_liquido  │
              │ material:       │      │ • placa/motoris │
              │ • metalico      │      │ • origem_talhao │
              │ • madeira       │      └────────┬────────┘
              └─────────────────┘               │
                                               ▼
                                      ┌─────────────────┐
                                      │  ETAPA 2        │
                                      │  MOEGA/RECEPCAO │
                                      │                 │
                                      │ RECEBIMENTO     │
                                      │   _GRAOS        │
                                      │ • umidade %     │
                                      │ • PH            │
                                      │ • impureza_g    │
                                      │ • ardido_g      │
                                      │ • avariado_g    │
                                      │ • verde_g       │
                                      │ • quebrado_g    │
                                      │ • amostra 200g  │
                                      │ • descontos     │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │  ETAPA 3        │
                                      │  SECAGEM        │
                                      │                 │
                                      │ CONTROLE        │
                                      │   _SECAGEM      │
                                      │ • leitura 30min │
                                      │ • umidade ent/sa│
                                      │ • temp P1/P2/P3 │
                                      │ • temp grao     │
                                      │ • tipo (T/P/R)  │
                                      │ • lenha m³      │
                                      │ • operador turno│
                                      │ • I.N. 029/2011 │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │  ETAPA 4        │
                                      │  SILO           │
                                      │                 │
                                      │ ESTOQUE_SILOS   │
                                      │ • qtd_virtual   │
                                      │ • qtd_real      │
                                      │ • umidade_media │
                                      │ • temp_media    │
                                      │ • lote          │
                                      └────────┬────────┘
                                               │
              ┌────────────────────────────────┼────────────────────────────────┐
              │                                │                                │
              ▼                                ▼                                ▼
    ┌─────────────────┐              ┌─────────────────┐              ┌─────────────────┐
    │ MOVIMENTACAO    │              │  SAIDAS_GRAOS   │              │ QUEBRAS         │
    │   _SILO         │              │                 │              │   _PRODUCAO     │
    │                 │              │ tipo_saida:     │              │                 │
    │ tipo_movimento: │              │ • venda         │              │ • esperada_kg   │
    │ • transferencia │              │ • transferencia │              │ • real_kg       │
    │ • secagem       │              │ • consumo       │              │ • diferenca     │
    │ • aeracao       │              │                 │              │ • percentual    │
    │                 │              │ tipo_destino:   │              │                 │
    │ Entre silos     │              │ • commodities   │              │                 │
    │ 1↔2↔3↔4↔5↔6↔7↔8 │              │ • sementes      │              │                 │
    │                 │              │ • racao         │              │                 │
    │                 │              │ • plantio_int   │              │                 │
    │                 │              │                 │              │                 │
    │                 │              │ emitente_nf:    │              │                 │
    │                 │              │ • soal          │              │                 │
    │                 │              │ • cooperativa   │              │                 │
    │                 │              │ • interno       │              │                 │
    └─────────────────┘              └─────────────────┘              └─────────────────┘
```

---

## Entidades do Modulo UBG (9 Entidades)

### 1. UBG (Estrutura Fisica)

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| organization_id | UUID | FK -> ORGANIZATIONS |
| fazenda_sede_id | UUID | FK -> FAZENDAS |
| nome | VARCHAR(100) | Nome da UBG |
| capacidade_recepcao_t_dia | DECIMAL(10,2) | Capacidade recepcao t/dia |
| capacidade_secagem_t_dia | DECIMAL(10,2) | Capacidade secagem t/dia |
| tem_balanca | BOOLEAN | Possui balanca propria |
| tem_tombador | BOOLEAN | Possui tombador/moega |
| tem_secador | BOOLEAN | Possui secador |
| software_ubg | VARCHAR(100) | Nome do software utilizado |
| coordenadas | GEOMETRY | Localizacao GPS |
| responsavel_tecnico | VARCHAR(200) | Nome do engenheiro (Leomar) |
| crea_responsavel | VARCHAR(20) | CREA do responsavel |
| status | ENUM | ativa, inativa, manutencao |
| created_at | TIMESTAMP | Data criacao |
| updated_at | TIMESTAMP | Data atualizacao |

**Relacionamentos:**
- ORGANIZATIONS (N:1) - UBG pertence a organizacao
- SILOS (1:N) - UBG contem silos
- TICKET_BALANCA (1:N) - UBG recebe pesagens

---

### 2. SILOS

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| ubg_id | UUID | FK -> UBG |
| numero_silo | INTEGER | Numero do silo (1 a 8) |
| nome | VARCHAR(100) | Nome do silo |
| tipo | ENUM | convencional, sementes |
| capacidade_toneladas | DECIMAL(12,2) | Capacidade em toneladas |
| capacidade_m3 | DECIMAL(12,2) | Capacidade em m³ |
| material | ENUM | metalico, madeira, concreto |
| tem_aeracao | BOOLEAN | Possui sistema de aeracao |
| tem_termometria | BOOLEAN | Possui termometria |
| status | ENUM | ativo, inativo, manutencao |
| created_at | TIMESTAMP | Data criacao |
| updated_at | TIMESTAMP | Data atualizacao |

**Relacionamentos:**
- UBG (N:1) - Silo pertence a UBG
- ESTOQUE_SILOS (1:N) - Silo tem posicoes de estoque

---

### 3. TICKET_BALANCA (Etapa 1)

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| ubg_id | UUID | FK -> UBG |
| operacao_campo_id | UUID | FK -> OPERACAO_CAMPO (colheita) |
| numero_ticket | VARCHAR(20) | Numero sequencial |
| tipo | ENUM | entrada, saida, transferencia |
| data_hora | TIMESTAMP | Data/hora da pesagem |
| placa_veiculo | VARCHAR(10) | Placa do caminhao |
| motorista | VARCHAR(100) | Nome do motorista |
| transportadora | VARCHAR(100) | Empresa (se terceirizado) |
| origem_talhao | VARCHAR(200) | Talhao de origem |
| peso_bruto_kg | DECIMAL(12,2) | Peso bruto |
| tara_cadastrada_kg | DECIMAL(12,2) | Tara do veiculo |
| peso_liquido_kg | DECIMAL(12,2) | Peso liquido calculado |
| operador_id | UUID | FK -> OPERADORES |
| observacoes | TEXT | Notas |
| created_at | TIMESTAMP | Data criacao |

**Relacionamentos:**
- UBG (N:1) - Ticket gerado na UBG
- OPERACAO_CAMPO (N:1) - Vincula a colheita de origem
- RECEBIMENTO_GRAOS (1:1) - Cada ticket tem um recebimento

---

### 4. RECEBIMENTO_GRAOS (Etapa 2)

Baseado na Planilha de Recepcao de Graos.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| ubg_id | UUID | FK -> UBG |
| ticket_balanca_id | UUID | FK -> TICKET_BALANCA |
| talhao_safra_id | UUID | FK -> TALHAO_SAFRA |
| cultura_id | UUID | FK -> CULTURAS |
| data_recebimento | DATE | Data |
| hora_recebimento | TIME | Hora |
| umidade_percent | DECIMAL(5,2) | % umidade |
| peso_hectolitrico | DECIMAL(6,2) | PH |
| impureza_g | DECIMAL(6,2) | Gramas impureza (amostra) |
| ardido_g | DECIMAL(6,2) | Gramas ardidos (amostra) |
| avariado_g | DECIMAL(6,2) | Gramas avariados (amostra) |
| verde_g | DECIMAL(6,2) | Gramas verdes (amostra) |
| quebrado_g | DECIMAL(6,2) | Gramas quebrados (amostra) |
| amostra_total_g | DECIMAL(6,2) | Peso amostra (padrao 200g) |
| descontos_umidade_kg | DECIMAL(10,2) | Desconto por umidade |
| descontos_impureza_kg | DECIMAL(10,2) | Desconto por impureza |
| peso_liquido_final_kg | DECIMAL(12,2) | Peso apos descontos |
| responsavel_id | UUID | FK -> OPERADORES |
| observacoes | TEXT | Notas |
| created_at | TIMESTAMP | Data criacao |

**Relacionamentos:**
- UBG (N:1) - Recebimento na UBG
- TICKET_BALANCA (1:1) - Vinculado ao ticket
- TALHAO_SAFRA (N:1) - Origem do grao
- CULTURAS (N:1) - Tipo de cultura
- CONTROLE_SECAGEM (1:N) - Multiplas leituras de secagem

---

### 5. CONTROLE_SECAGEM (Etapa 3)

Baseado na Planilha de Monitoramento Diario da Secagem de Graos.
Cada registro = 1 leitura a cada 30 minutos.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| ubg_id | UUID | FK -> UBG |
| recebimento_id | UUID | FK -> RECEBIMENTO_GRAOS |
| secador_id | VARCHAR(50) | Identificacao do secador |
| data_secagem | DATE | Data |
| hora_leitura | TIME | Hora da leitura (30/30 min) |
| produto | VARCHAR(100) | Produto (Feijao, Soja, etc) |
| cultivar_hibrido | VARCHAR(100) | Cultivar/Hibrido |
| umidade_entrada_percent | DECIMAL(5,2) | Umidade entrada (% b.u.) |
| umidade_secagem_percent | DECIMAL(5,2) | Umidade durante secagem |
| temperatura_p1_c | DECIMAL(4,1) | Temperatura ponto 1 |
| temperatura_p2_c | DECIMAL(4,1) | Temperatura ponto 2 |
| temperatura_p3_c | DECIMAL(4,1) | Temperatura ponto 3 |
| temperatura_grao_c | DECIMAL(4,1) | Temperatura do grao |
| numero_secagem_seq | INTEGER | N. Secagem Sequencial |
| tipo_secagem | ENUM | total, parcial, ressecagem |
| tratamento_fitos_litros | DECIMAL(8,2) | Trat. Fitossanitario (L) |
| lenha_m3 | DECIMAL(6,2) | Consumo lenha (m³) |
| operador_turno | VARCHAR(100) | Operador do turno |
| created_at | TIMESTAMP | Data criacao |

**Atende I.N. 029/2011 - MAPA**

**Relacionamentos:**
- UBG (N:1) - Secagem na UBG
- RECEBIMENTO_GRAOS (N:1) - Lote sendo secado
- ESTOQUE_SILOS (N:1) - Armazena apos secagem

---

### 6. ESTOQUE_SILOS (Etapa 4)

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| silo_id | UUID | FK -> SILOS |
| cultura_id | UUID | FK -> CULTURAS |
| safra_id | UUID | FK -> SAFRAS |
| quantidade_virtual_kg | DECIMAL(14,2) | Quantidade teorica |
| quantidade_real_kg | DECIMAL(14,2) | Quantidade medida |
| umidade_media_percent | DECIMAL(5,2) | Umidade media |
| temperatura_media_c | DECIMAL(4,1) | Temperatura media |
| data_ultima_medicao | TIMESTAMP | Data ultima medicao |
| lote_identificador | VARCHAR(50) | Identificador do lote |
| observacoes | TEXT | Notas |
| created_at | TIMESTAMP | Data criacao |
| updated_at | TIMESTAMP | Data atualizacao |

**Relacionamentos:**
- SILOS (N:1) - Estoque pertence a um silo
- CULTURAS (N:1) - Tipo de cultura armazenada
- SAFRAS (N:1) - Safra de origem
- MOVIMENTACAO_SILO (1:N) - Movimentacoes
- SAIDAS_GRAOS (1:N) - Saidas
- QUEBRAS_PRODUCAO (1:N) - Quebras

---

### 7. MOVIMENTACAO_SILO

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| silo_origem_id | UUID | FK -> SILOS |
| silo_destino_id | UUID | FK -> SILOS |
| cultura_id | UUID | FK -> CULTURAS |
| tipo_movimento | ENUM | transferencia, secagem, aeracao |
| quantidade_kg | DECIMAL(12,2) | Quantidade movimentada |
| umidade_origem_percent | DECIMAL(5,2) | Umidade na origem |
| umidade_destino_percent | DECIMAL(5,2) | Umidade no destino |
| data_movimento | TIMESTAMP | Data/hora movimento |
| operador_id | UUID | FK -> OPERADORES |
| motivo | TEXT | Motivo da movimentacao |
| created_at | TIMESTAMP | Data criacao |

**Relacionamentos:**
- SILOS origem (N:1) - Silo de saida
- SILOS destino (N:1) - Silo de entrada
- ESTOQUE_SILOS (N:1) - Afeta estoque

---

### 8. SAIDAS_GRAOS

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| estoque_silo_id | UUID | FK -> ESTOQUE_SILOS |
| cultura_id | UUID | FK -> CULTURAS |
| tipo_saida | ENUM | venda, transferencia, consumo |
| tipo_destino | ENUM | commodities, sementes, racao, plantio_interno |
| quantidade_kg | DECIMAL(12,2) | Quantidade |
| umidade_percent | DECIMAL(5,2) | Umidade na saida |
| data_saida | TIMESTAMP | Data/hora |
| parceiro_id | UUID | FK -> PARCEIRO_COMERCIAL |
| preco_kg | DECIMAL(10,4) | Preco por kg |
| valor_total | DECIMAL(14,2) | Valor total |
| nota_fiscal_id | UUID | FK -> NOTA_FISCAL |
| emitente_nf | ENUM | soal, cooperativa, interno |
| placa_veiculo | VARCHAR(10) | Placa do caminhao |
| motorista | VARCHAR(100) | Nome do motorista |
| operador_id | UUID | FK -> OPERADORES |
| observacoes | TEXT | Notas |
| created_at | TIMESTAMP | Data criacao |

**ENUMs importantes:**
- **tipo_destino:** commodities (feijao direto, graos coop), sementes (Castrolanda bags), racao (pecuaria), plantio_interno
- **emitente_nf:** soal (feijao direto), cooperativa (Castrolanda), interno (sem NF comercial)

**Relacionamentos:**
- ESTOQUE_SILOS (N:1) - Saida de qual estoque
- PARCEIRO_COMERCIAL (N:1) - Para quem vai (Castrolanda, feijoeiros, etc)
- NOTA_FISCAL (N:1) - NF vinculada

---

### 9. QUEBRAS_PRODUCAO

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| estoque_silo_id | UUID | FK -> ESTOQUE_SILOS |
| safra_id | UUID | FK -> SAFRAS |
| cultura_id | UUID | FK -> CULTURAS |
| tipo_quebra | ENUM | secagem, armazenagem, transporte |
| quantidade_esperada_kg | DECIMAL(14,2) | Quantidade esperada |
| quantidade_real_kg | DECIMAL(14,2) | Quantidade real |
| diferenca_kg | DECIMAL(12,2) | Diferenca (perda) |
| percentual_quebra | DECIMAL(5,2) | % de quebra |
| data_apuracao | TIMESTAMP | Data da apuracao |
| motivo_provavel | TEXT | Motivo provavel |
| responsavel_id | UUID | FK -> OPERADORES |
| created_at | TIMESTAMP | Data criacao |

**Relacionamentos:**
- ESTOQUE_SILOS (N:1) - Quebra de qual estoque
- SAFRAS (N:1) - Safra afetada

---

---

## Diagrama de Relacionamentos

```
┌─────────────────────────────────────────────────────────────────┐
│                         ORGANIZATIONS                            │
└───────────────────────────────┬─────────────────────────────────┘
                                │ 1:N
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                             UBG                                  │
│                   (1 por organizacao)                            │
└───────────┬─────────────────────────────────────┬───────────────┘
            │ 1:N                                 │ 1:N
            ▼                                     ▼
┌───────────────────────┐               ┌───────────────────────┐
│        SILOS          │               │    TICKET_BALANCA     │
│      (8 total)        │               │      (Etapa 1)        │
└───────────┬───────────┘               └───────────┬───────────┘
            │ 1:N                                   │ 1:1
            ▼                                       ▼
┌───────────────────────┐               ┌───────────────────────┐
│    ESTOQUE_SILOS      │◄──────────────│   RECEBIMENTO_GRAOS   │
│      (Etapa 4)        │   armazena    │      (Etapa 2)        │
└───────────┬───────────┘               └───────────┬───────────┘
            │                                       │ 1:N
    ┌───────┼───────┐                               ▼
    │       │       │                   ┌───────────────────────┐
    ▼       ▼       ▼                   │   CONTROLE_SECAGEM    │
┌───────┐┌───────┐┌───────┐             │      (Etapa 3)        │
│MOVIM. ││SAIDAS ││QUEBRAS│             │    (leituras 30min)   │
│ _SILO ││_GRAOS ││_PROD. │             └───────────────────────┘
└───────┘└───────┘└───────┘
```

**Fluxo Linear:**
```
OPERACAO_CAMPO (colheita)
        │
        ▼
TICKET_BALANCA ──► RECEBIMENTO_GRAOS ──► CONTROLE_SECAGEM ──► ESTOQUE_SILOS
                                                                    │
                                            ┌───────────────────────┼───────────────────────┐
                                            │                       │                       │
                                            ▼                       ▼                       ▼
                                    MOVIMENTACAO_SILO        SAIDAS_GRAOS          QUEBRAS_PRODUCAO
```

---

## Compliance e Regulamentacao

- **I.N. 029/2011 - MAPA**: Sistema deve atender normativa
- **Responsavel Tecnico**: Engenheiro Agronomo com CREA registrado
- **Rastreabilidade**: Necessaria para sementes certificadas

---

## TBCs (A Confirmar com Leomar)

1. [ ] Duracao media do processo de secagem
2. [ ] Criterio exato para destinacao a racao
3. [ ] Rastreabilidade completa para sementes certificadas
4. [ ] Detalhes do processo de peneira/calculo de sementes
5. [ ] Software do secador - quais dados estao disponiveis
6. [ ] Software da UBG - integracao possivel?
7. [ ] Talhao multi-cultura: simultaneo ou sequencial?

---

## Proximos Passos

1. [x] Documentar estrutura completa UBG
2. [x] Criar diagrama ER no Miro
3. [ ] Conversar com Leomar sobre software e dados
4. [ ] Definir integracao com sistema existente
5. [ ] Mapear fluxo de NF (SOAL vs Cooperativa)
6. [ ] Conectar com modulo PECUARIA (racao)

---

*Documento gerado em 08/02/2026 - DeepWork AI Flows*
*Baseado em planilhas de controle e visita de campo*
