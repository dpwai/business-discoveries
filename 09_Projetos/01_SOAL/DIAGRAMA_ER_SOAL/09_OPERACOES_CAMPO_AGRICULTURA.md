# OPERACOES DE CAMPO - Estrutura ER

**Data:** 08/02/2026
**Versao:** 2.0
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=/?focusWidget=3458764658846843567

---

## Contexto

Apos visita de campo, foi identificada a necessidade de reestruturar as operacoes agricolas. A abordagem escolhida foi uma **estrutura hibrida** com:

1. **Entidade PAI (OPERACAO_CAMPO)**: Centraliza campos comuns a todas as operacoes
2. **Entidades FILHAS (Detalhes)**: Apenas para tipos que precisam de campos especificos

### Vantagens dessa abordagem:
- Query simples para listar todas operacoes de um talhao
- Timeline unificada de operacoes
- Relatorios consolidados faceis
- Flexibilidade para novos tipos (so adiciona no ENUM)
- Menos repeticao de campos

---

## Hierarquia de Entidades

```
TALHAO_SAFRA
     │
     │ 1:N
     ▼
OPERACAO_CAMPO (entidade PAI)
     │
     ├── tipo = plantio ──────────► PLANTIO_DETALHE
     ├── tipo = colheita ─────────► COLHEITA_DETALHE
     ├── tipo = pulverizacao_* ───► PULVERIZACAO_DETALHE
     ├── tipo = aplicacao_drone ──► DRONE_DETALHE
     │
     └── tipos simples (so campos comuns):
         ├── gradagem_pesada, gradagem_niveladora
         ├── subsolagem, escarificacao, aracao
         ├── dessecacao_pre_plantio, dessecacao_pre_colheita
         ├── calagem, gessagem, adubacao_cobertura
         ├── irrigacao, monitoramento, transporte_interno
         └── terraceamento, replantio
```

---

## Tipos de Operacoes (ENUM)

### Preparo de Solo
| Tipo | Descricao |
|------|-----------|
| aracao | Revolvimento profundo do solo |
| gradagem_pesada | Quebra de torroes, incorporacao de restos |
| gradagem_niveladora | Nivelamento final da superficie |
| subsolagem | Descompactacao profunda (>30cm) |
| escarificacao | Descompactacao superficial |
| terraceamento | Construcao/manutencao de terracos |

### Manejo Pre-Plantio
| Tipo | Descricao |
|------|-----------|
| dessecacao_pre_plantio | Aplicacao de herbicida pre-plantio |
| calagem | Aplicacao de calcario |
| gessagem | Aplicacao de gesso agricola |

### Plantio
| Tipo | Descricao |
|------|-----------|
| plantio | Semeadura com plantadeira |
| replantio | Correcao de falhas |

### Tratos Culturais
| Tipo | Descricao |
|------|-----------|
| pulverizacao_herbicida | Controle de plantas daninhas |
| pulverizacao_inseticida | Controle de pragas |
| pulverizacao_fungicida | Controle de doencas |
| pulverizacao_foliar | Adubacao foliar |
| aplicacao_drone | Aplicacao aerea com drone |
| adubacao_cobertura | Aplicacao de adubo em cobertura |
| irrigacao | Aplicacao de agua |

### Colheita
| Tipo | Descricao |
|------|-----------|
| colheita | Colheita mecanica |
| dessecacao_pre_colheita | Antecipacao de maturacao |

### Outras
| Tipo | Descricao |
|------|-----------|
| monitoramento | Amostragem de pragas e doencas (scouting) |
| transporte_interno | Campo para UBG/Silo |

---

## Entidades

### 1. OPERACAO_CAMPO (Entidade Principal)

Centraliza todos os campos comuns a qualquer operacao de campo.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| talhao_safra_id | UUID | FK -> TALHAO_SAFRA |
| maquina_id | UUID | FK -> MAQUINAS |
| operador_id | UUID | FK -> OPERADORES |
| fazenda_id | UUID | FK -> FAZENDAS |
| tipo | ENUM | Tipo da operacao (lista completa acima) |
| status | ENUM | planejada, em_andamento, concluida, cancelada |
| data_inicio | TIMESTAMP | Inicio da operacao |
| data_fim | TIMESTAMP | Fim da operacao |
| area_trabalhada_ha | DECIMAL(10,4) | Area efetivamente trabalhada |
| horimetro_inicio | DECIMAL(12,2) | Leitura inicial do horimetro |
| horimetro_fim | DECIMAL(12,2) | Leitura final do horimetro |
| combustivel_litros | DECIMAL(10,2) | Consumo de combustivel |
| custo_operacao | DECIMAL(12,2) | Custo total da operacao |
| observacoes | TEXT | Observacoes gerais |
| geojson_trajeto | JSONB | Trajeto GPS da operacao |
| created_at | TIMESTAMP | Data criacao |
| updated_at | TIMESTAMP | Data atualizacao |

**Relacionamentos:**
- TALHAO_SAFRA (N:1) - Cada operacao pertence a um talhao/safra
- MAQUINAS (N:1) - Cada operacao usa uma maquina
- OPERADORES (N:1) - Cada operacao tem um operador responsavel

---

### 2. PLANTIO_DETALHE

Campos especificos para operacoes do tipo `plantio` e `replantio`.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| operacao_id | UUID | FK -> OPERACAO_CAMPO |
| variedade | VARCHAR(100) | Variedade/cultivar plantada |
| populacao_sementes_ha | INTEGER | Populacao de sementes por hectare |
| espacamento_cm | DECIMAL(6,2) | Espacamento entre linhas (cm) |
| profundidade_cm | DECIMAL(4,2) | Profundidade de plantio (cm) |
| tratamento_sementes | VARCHAR(200) | Produtos usados no tratamento |
| adubo_base | VARCHAR(200) | Formulacao do adubo de base |
| quantidade_adubo_kg_ha | DECIMAL(8,2) | Quantidade de adubo kg/ha |
| umidade_solo_percent | DECIMAL(5,2) | Umidade do solo no momento |
| created_at | TIMESTAMP | Data criacao |

**Relacionamento:** OPERACAO_CAMPO (1:1) onde tipo IN ('plantio', 'replantio')

---

### 3. COLHEITA_DETALHE

Campos especificos para operacoes do tipo `colheita`.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| operacao_id | UUID | FK -> OPERACAO_CAMPO |
| producao_total_kg | DECIMAL(12,2) | Producao total em kg |
| produtividade_kg_ha | DECIMAL(10,2) | Produtividade em kg/ha |
| produtividade_sacas_ha | DECIMAL(10,2) | Produtividade em sacas/ha |
| umidade_media_percent | DECIMAL(5,2) | Umidade media dos graos |
| perdas_estimadas_percent | DECIMAL(5,2) | Percentual estimado de perdas |
| velocidade_media_kmh | DECIMAL(6,2) | Velocidade media da colheitadeira |
| condicoes_climaticas | JSONB | Temperatura, umidade ar, etc |
| created_at | TIMESTAMP | Data criacao |

**Relacionamento:** OPERACAO_CAMPO (1:1) onde tipo = 'colheita'

---

### 4. PULVERIZACAO_DETALHE

Campos especificos para operacoes de pulverizacao terrestre.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| operacao_id | UUID | FK -> OPERACAO_CAMPO |
| insumo_id | UUID | FK -> INSUMO (produto aplicado) |
| receituario_id | UUID | FK -> RECEITUARIO_AGRONOMICO |
| alvo | VARCHAR(200) | Praga, doenca ou daninha alvo |
| dose_ha | DECIMAL(10,4) | Dose do produto por hectare |
| volume_calda_ha | DECIMAL(8,2) | Volume de calda L/ha |
| vazao_bico | DECIMAL(8,4) | Vazao por bico L/min |
| pressao_bar | DECIMAL(6,2) | Pressao de trabalho |
| temperatura_c | DECIMAL(4,1) | Temperatura ambiente |
| umidade_relativa | DECIMAL(5,2) | Umidade relativa do ar |
| velocidade_vento_kmh | DECIMAL(5,2) | Velocidade do vento |
| created_at | TIMESTAMP | Data criacao |

**Relacionamento:** OPERACAO_CAMPO (1:1) onde tipo LIKE 'pulverizacao_%'

**Nota:** Condicoes climaticas sao criticas para eficacia da aplicacao:
- Temperatura ideal: 20-30C
- Umidade relativa: >55%
- Vento: <10 km/h

---

### 5. DRONE_DETALHE

Campos especificos para operacoes com drone (aplicacao aerea).

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| operacao_id | UUID | FK -> OPERACAO_CAMPO |
| insumo_id | UUID | FK -> INSUMO (produto aplicado) |
| modelo_drone | VARCHAR(100) | Modelo/marca do drone |
| altitude_voo_m | DECIMAL(6,2) | Altitude de voo em metros |
| velocidade_voo_ms | DECIMAL(6,2) | Velocidade de voo m/s |
| largura_faixa_m | DECIMAL(6,2) | Largura da faixa de aplicacao |
| volume_calda_ha | DECIMAL(8,2) | Volume de calda L/ha |
| autonomia_bateria_min | INTEGER | Autonomia da bateria em minutos |
| numero_voos | INTEGER | Quantidade de voos realizados |
| created_at | TIMESTAMP | Data criacao |

**Relacionamento:** OPERACAO_CAMPO (1:1) onde tipo = 'aplicacao_drone'

---

### 6. TRANSPORTE_COLHEITA_DETALHE

Campos especificos para operacoes do tipo `transporte_interno` quando vinculado a colheita.

| Coluna | Tipo | Descricao |
|--------|------|-----------|
| id | UUID | PK |
| operacao_id | UUID | FK -> OPERACAO_CAMPO (transporte_interno) |
| colheita_origem_id | UUID | FK -> OPERACAO_CAMPO (colheita de origem) |
| ticket_balanca_id | UUID | FK -> TICKET_BALANCA (chegada na UBG) |
| numero_viagem | INTEGER | Numero da viagem (1, 2, 3...) |
| placa_veiculo | VARCHAR(10) | Placa do caminhao |
| motorista | VARCHAR(100) | Nome do motorista |
| tipo_transporte | ENUM | proprio, terceiro |
| transportadora | VARCHAR(100) | Nome da transportadora (se terceiro) |
| hora_saida_campo | TIMESTAMP | Hora que saiu do campo |
| hora_chegada_ubg | TIMESTAMP | Hora que chegou na UBG |
| peso_estimado_kg | DECIMAL(12,2) | Peso estimado na saida |
| distancia_km | DECIMAL(8,2) | Distancia campo ate UBG |
| created_at | TIMESTAMP | Data criacao |

**Relacionamento:** OPERACAO_CAMPO (1:1) onde tipo = 'transporte_interno'

**Conexoes:**
- OPERACAO_CAMPO colheita (N:1) - De qual colheita veio
- TICKET_BALANCA (1:1) - Chegada na UBG

---

## Diagrama de Relacionamentos

```
┌─────────────────┐
│  TALHAO_SAFRA   │
└────────┬────────┘
         │ 1:N
         ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            OPERACAO_CAMPO                                    │
│     (tipo, status, data_inicio, data_fim, area_trabalhada_ha,               │
│      maquina_id, operador_id, horimetro, combustivel, custo)                │
└──────┬──────────────┬──────────────┬──────────────┬──────────────┬──────────┘
       │              │              │              │              │
       │ 1:0..1       │ 1:0..1       │ 1:0..1       │ 1:0..1       │ 1:0..1
       ▼              ▼              ▼              ▼              ▼
┌────────────┐ ┌────────────┐ ┌────────────┐ ┌────────────┐ ┌─────────────────┐
│  PLANTIO   │ │  COLHEITA  │ │PULVERIZACAO│ │   DRONE    │ │   TRANSPORTE    │
│  DETALHE   │ │  DETALHE   │ │  DETALHE   │ │  DETALHE   │ │COLHEITA_DETALHE │
│            │ │            │ │            │ │            │ │                 │
│ variedade  │ │ producao_kg│ │ insumo_id  │ │modelo_drone│ │colheita_origem  │
│ populacao  │ │produtivid. │ │ alvo       │ │ altitude   │ │ticket_balanca_id│
│ espacamento│ │ umidade    │ │ dose_ha    │ │ velocidade │ │numero_viagem    │
│profundidade│ │ perdas     │ │volume_calda│ │largura_faix│ │tipo_transporte  │
│ adubo_base │ │ velocidade │ │ pressao    │ │numero_voos │ │hora_saida/cheg. │
└────────────┘ └─────┬──────┘ └────────────┘ └────────────┘ └────────┬────────┘
                     │                                               │
                     │ origem da carga                               │
                     └───────────────────────────────────────────────┘
```

### Conexao com UBG

```
OPERACAO_CAMPO (colheita)
        │
        │ colheita_origem_id
        ▼
OPERACAO_CAMPO (transporte_interno)
        │
        └──► TRANSPORTE_COLHEITA_DETALHE
                     │
                     │ ticket_balanca_id
                     ▼
              TICKET_BALANCA (UBG)
                     │
                     ▼
              RECEBIMENTO_GRAOS
                     │
                     ▼
              ...resto do fluxo UBG...
```

---

## Fluxo de Operacoes na Safra

```
SAFRA INICIA (Jul)
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ PREPARO DE SOLO                                         │
│ aracao → gradagem_pesada → subsolagem → gradagem_niv    │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ CORRECAO DE SOLO                                        │
│ calagem → gessagem                                      │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ PRE-PLANTIO                                             │
│ dessecacao_pre_plantio                                  │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ PLANTIO                                                 │
│ plantio (+ PLANTIO_DETALHE)                            │
│ replantio (se necessario)                               │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ TRATOS CULTURAIS (ciclo da cultura)                     │
│ pulverizacao_herbicida                                  │
│ pulverizacao_inseticida                                 │
│ pulverizacao_fungicida                                  │
│ pulverizacao_foliar                                     │
│ aplicacao_drone (+ DRONE_DETALHE)                       │
│ adubacao_cobertura                                      │
│ monitoramento (scouting)                                │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ PRE-COLHEITA                                            │
│ dessecacao_pre_colheita (opcional)                      │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ COLHEITA                                                │
│ colheita (+ COLHEITA_DETALHE)                          │
└─────────────────────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────────────────────┐
│ POS-COLHEITA                                            │
│ transporte_interno → UBG → SILO                         │
└─────────────────────────────────────────────────────────┘
      │
      ▼
SAFRA ENCERRA (Jun)
```

---

## Queries Uteis

### Listar todas operacoes de um talhao na safra
```sql
SELECT oc.*, ts.area_plantada, c.nome as cultura
FROM operacao_campo oc
JOIN talhao_safra ts ON oc.talhao_safra_id = ts.id
JOIN culturas c ON ts.cultura_id = c.id
WHERE ts.talhao_id = :talhao_id
  AND ts.safra_id = :safra_id
ORDER BY oc.data_inicio;
```

### Custo total por tipo de operacao na safra
```sql
SELECT oc.tipo,
       COUNT(*) as qtd_operacoes,
       SUM(oc.area_trabalhada_ha) as area_total,
       SUM(oc.custo_operacao) as custo_total
FROM operacao_campo oc
JOIN talhao_safra ts ON oc.talhao_safra_id = ts.id
WHERE ts.safra_id = :safra_id
GROUP BY oc.tipo
ORDER BY custo_total DESC;
```

### Operacoes com detalhes de plantio
```sql
SELECT oc.*, pd.*
FROM operacao_campo oc
JOIN plantio_detalhe pd ON pd.operacao_id = oc.id
WHERE oc.tipo IN ('plantio', 'replantio')
  AND oc.fazenda_id = :fazenda_id;
```

### Timeline de operacoes por talhao
```sql
SELECT t.nome as talhao,
       oc.tipo,
       oc.data_inicio,
       oc.data_fim,
       oc.area_trabalhada_ha,
       oc.status
FROM operacao_campo oc
JOIN talhao_safra ts ON oc.talhao_safra_id = ts.id
JOIN talhoes t ON ts.talhao_id = t.id
WHERE ts.safra_id = :safra_id
ORDER BY t.nome, oc.data_inicio;
```

---

## Proximos Passos

1. [ ] Criar entidade UBG (Unidade de Beneficiamento de Graos)
2. [ ] Vincular COLHEITA → transporte_interno → UBG → SILO
3. [ ] Definir maquinarios especificos por tipo de operacao
4. [ ] Adicionar entidade PREPARO_SOLO_DETALHE se necessario
5. [ ] Revisar campos de INSUMO para suportar todos os tipos

---

*Documento gerado em 08/02/2026 - DeepWork AI Flows*
*Baseado em visita de campo e requisitos levantados*
