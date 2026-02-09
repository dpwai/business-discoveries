# MODULO INSUMOS E ESTOQUE - Estrutura ER + Plano Miro

**Data:** 09/02/2026
**Versao:** 1.0
**Status:** Pronto para implementar no Miro
**Board Miro:** https://miro.com/app/board/uXjVGE__XFQ=

---

## 1. Resumo da Situacao

### O Que Existe Hoje no Diagrama

| Entidade | Doc Origem | Posicao Miro | Status |
|----------|-----------|--------------|--------|
| INSUMO | doc 08 | x=-6000, y=2000 | SUBSTITUIR por PRODUTO_INSUMO |
| INSUMOS_CASTROLANDA | doc 05 | nao posicionado | SUBSTITUIR por COMPRA_INSUMO |
| APLICACAO_INSUMO | doc 08 | x=-6000, y=2000 | REFATORAR (expandir campos, vincular estoque) |
| RECEITUARIO_AGRONOMICO | doc 08 | x=-6000, y=2000 | MANTER (ajustar FK para PRODUTO_INSUMO) |

### O Que Precisa Ser Criado

| Entidade | Tipo Acao | Funcao |
|----------|-----------|--------|
| PRODUTO_INSUMO | NOVA (substitui INSUMO) | Catalogo de produtos |
| COMPRA_INSUMO | NOVA (substitui INSUMOS_CASTROLANDA) | Registro de compras |
| ESTOQUE_INSUMO | NOVA | Saldo atual por produto/local |
| MOVIMENTACAO_INSUMO | NOVA | Historico de entradas e saidas |
| APLICACAO_INSUMO | REFATORAR | Uso no campo (expandir) |

---

## 2. Entidades Detalhadas

### 2.1 PRODUTO_INSUMO (Catalogo)

**Substitui:** INSUMO do doc 08
**Funcao:** Cadastro de todos os produtos que a SOAL compra e consome. Nao tem preco, nao tem saldo. E o "dicionario".

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | Identificador unico |
| organization_id | UUID | FK → ORGANIZATIONS | Organizacao dona |
| codigo | VARCHAR(50) | Sim | Codigo interno ou Castrolanda |
| nome | VARCHAR(200) | Sim | Nome comercial do produto |
| principio_ativo | VARCHAR(200) | Nao | Principio ativo (defensivos) |
| tipo | ENUM | Sim | Ver tabela de tipos abaixo |
| grupo | ENUM | Sim | agricola, pecuario, geral |
| unidade_medida | VARCHAR(20) | Sim | kg, L, sacas, doses, m3, un |
| unidade_embalagem | VARCHAR(50) | Nao | "Saco 40kg", "Galao 20L", "Big Bag 1000kg" |
| fabricante | VARCHAR(200) | Nao | Nome do fabricante |
| registro_mapa | VARCHAR(50) | Nao | Numero registro MAPA (defensivos) |
| classe_toxicologica | ENUM | Nao | I, II, III, IV, nao_classificado |
| classe_ambiental | ENUM | Nao | I, II, III, IV |
| carencia_dias | INTEGER | Nao | Periodo de carencia em dias |
| dose_recomendada_min | DECIMAL(10,4) | Nao | Dose minima por ha |
| dose_recomendada_max | DECIMAL(10,4) | Nao | Dose maxima por ha |
| ativo | BOOLEAN | Sim | Produto ativo no cadastro |
| created_at | TIMESTAMP | Sim | Data criacao |
| updated_at | TIMESTAMP | Sim | Data atualizacao |

**Tipos de Insumo (ENUM):**

| Tipo | Grupo | Exemplos SOAL |
|------|-------|---------------|
| semente | agricola | Soja TMG, Milho Pioneer, Feijao Perola |
| fertilizante | agricola | MAP 08-40-00, KCl, Ureia, Sulfato de Amonio |
| herbicida | agricola | Roundup, Glifosato, 2,4-D, Atrazina |
| inseticida | agricola | Engeo Pleno, Connect, Belt |
| fungicida | agricola | Fox, Elatus, Opera |
| adjuvante | agricola | Oleo mineral, espalhante adesivo |
| corretivo | agricola | Calcario dolomitico, Gesso agricola |
| inoculante | agricola | Bradyrhizobium (soja), Azospirillum |
| tratamento_semente | agricola | Cruiser, Maxim, Standak |
| adubo_foliar | agricola | Micronutrientes, MAP foliar |
| medicamento_vet | pecuario | Ivermectina, Aftosa, Carbunculo |
| suplemento_mineral | pecuario | Sal mineral, sal proteinado |
| racao | pecuario | Racao engorda, concentrado |
| combustivel | geral | Diesel S10, Diesel S500, Gasolina |
| lubrificante | geral | Oleo motor, oleo hidraulico, graxa |
| peca_reposicao | geral | Filtros, correias, rolamentos |
| material_manutencao | geral | Solda, parafusos, ferramentas |
| lenha | geral | Lenha para secador (m3) |
| embalagem | geral | Big bags, sacaria |
| epi | geral | Luvas, mascara, oculos |
| outros | geral | Qualquer nao categorizado |

**Relacionamentos:**
- COMPRA_INSUMO (1:N) - Produto aparece em varias compras
- ESTOQUE_INSUMO (1:N) - Produto pode estar em varios locais
- APLICACAO_INSUMO (1:N) - Produto e aplicado varias vezes
- RECEITUARIO_AGRONOMICO (1:N) - Produto referenciado em receituarios
- DIETA_INGREDIENTE (1:N) - Produto usado em dietas pecuarias
- PULVERIZACAO_DETALHE (1:N) - FK insumo_id ja existente
- DRONE_DETALHE (1:N) - FK insumo_id ja existente

---

### 2.2 COMPRA_INSUMO (Registro de Compra)

**Substitui:** INSUMOS_CASTROLANDA do doc 05
**Funcao:** Registra cada compra de insumo, independente do fornecedor.

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | Identificador unico |
| organization_id | UUID | FK → ORGANIZATIONS | Organizacao |
| produto_insumo_id | UUID | FK → PRODUTO_INSUMO | Qual produto comprou |
| nota_fiscal_item_id | UUID | FK → NOTA_FISCAL_ITEM | Item da NF (se houver) |
| parceiro_id | UUID | FK → PARCEIRO_COMERCIAL | Fornecedor |
| safra_id | UUID | FK → SAFRAS | Safra destino |
| fonte | ENUM | Sim | castrolanda, revenda, direto_fabrica, barter, producao_propria, outros |
| data_compra | DATE | Sim | Data da compra |
| quantidade | DECIMAL(12,4) | Sim | Quantidade comprada |
| unidade | VARCHAR(20) | Sim | Unidade |
| valor_unitario | DECIMAL(12,4) | Sim | Preco unitario |
| valor_total | DECIMAL(14,2) | Sim | Valor total |
| lote_fabricante | VARCHAR(50) | Nao | Lote do fabricante |
| data_fabricacao | DATE | Nao | Data de fabricacao |
| data_validade | DATE | Nao | Validade do produto |
| cultura_destino_id | UUID | FK → CULTURAS | Cultura destino (se ja sabe) |
| numero_pedido | VARCHAR(50) | Nao | Numero do pedido Castrolanda/outro |
| castrolanda_sync_id | VARCHAR(50) | Nao | ID integracao Castrolanda |
| contrato_barter_id | UUID | FK → CONTRATO_COMERCIAL | Se veio de barter |
| status | ENUM | Sim | recebido, parcial, pendente, cancelado |
| observacoes | TEXT | Nao | Notas |
| created_at | TIMESTAMP | Sim | |
| updated_at | TIMESTAMP | Sim | |

**Relacionamentos:**
- PRODUTO_INSUMO (N:1) - Qual produto
- NOTA_FISCAL_ITEM (N:1) - Vinculo com NF
- PARCEIRO_COMERCIAL (N:1) - De quem comprou
- SAFRAS (N:1) - Para qual safra
- CULTURAS (N:1) - Para qual cultura (opcional)
- CONTRATO_COMERCIAL (N:1) - Se barter
- MOVIMENTACAO_INSUMO (1:1) - Gera entrada no estoque

---

### 2.3 ESTOQUE_INSUMO (Posicao Atual)

**Entidade nova.**
**Funcao:** Saldo atual de cada produto em cada local de armazenamento. Uma linha por combinacao produto + local.

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | Identificador unico |
| organization_id | UUID | FK → ORGANIZATIONS | Organizacao |
| produto_insumo_id | UUID | FK → PRODUTO_INSUMO | Qual produto |
| fazenda_id | UUID | FK → FAZENDAS | Em qual fazenda esta armazenado |
| local_armazenamento | VARCHAR(100) | Sim | "Galpao Principal", "Deposito Defensivos", "Tanque Diesel" |
| quantidade_atual | DECIMAL(12,4) | Sim | Saldo atual |
| unidade | VARCHAR(20) | Sim | Unidade de medida |
| custo_medio_unitario | DECIMAL(12,4) | Sim | Custo medio ponderado atual |
| valor_total_estoque | DECIMAL(14,2) | Sim | quantidade_atual x custo_medio |
| quantidade_minima | DECIMAL(12,4) | Nao | Ponto de reposicao (gera alerta) |
| quantidade_maxima | DECIMAL(12,4) | Nao | Capacidade maxima do local |
| lote_mais_antigo | VARCHAR(50) | Nao | FIFO - lote mais velho |
| validade_mais_proxima | DATE | Nao | Validade mais proxima (alerta) |
| data_ultimo_inventario | DATE | Nao | Ultima contagem fisica |
| status | ENUM | Sim | ativo, zerado, bloqueado |
| created_at | TIMESTAMP | Sim | |
| updated_at | TIMESTAMP | Sim | |

**Regra de Negocio - Custo Medio Ponderado:**
```
Ao receber compra:
  novo_custo_medio = (saldo_atual x custo_medio_atual + qtd_compra x custo_compra)
                     / (saldo_atual + qtd_compra)

Ao dar saida:
  custo da saida = quantidade_saida x custo_medio_atual
  (custo medio NAO muda na saida)
```

**Relacionamentos:**
- PRODUTO_INSUMO (N:1) - Qual produto
- FAZENDAS (N:1) - Onde esta
- MOVIMENTACAO_INSUMO (1:N) - Historico de movimentacoes

---

### 2.4 MOVIMENTACAO_INSUMO (Historico)

**Entidade nova.**
**Funcao:** Cada entrada, saida ou ajuste no estoque de insumos. Rastreabilidade completa.

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | Identificador unico |
| estoque_insumo_id | UUID | FK → ESTOQUE_INSUMO | Qual estoque afetado |
| tipo | ENUM | Sim | Ver tabela de tipos abaixo |
| data_movimento | TIMESTAMP | Sim | Data/hora da movimentacao |
| quantidade | DECIMAL(12,4) | Sim | Quantidade movimentada (sempre positivo) |
| custo_unitario | DECIMAL(12,4) | Sim | Custo unitario neste movimento |
| valor_total | DECIMAL(14,2) | Sim | Valor total do movimento |
| saldo_anterior | DECIMAL(12,4) | Sim | Saldo antes do movimento |
| saldo_posterior | DECIMAL(12,4) | Sim | Saldo apos o movimento |
| custo_medio_anterior | DECIMAL(12,4) | Sim | Custo medio antes |
| custo_medio_posterior | DECIMAL(12,4) | Sim | Custo medio depois |
| compra_insumo_id | UUID | FK → COMPRA_INSUMO | Se tipo = entrada_compra |
| aplicacao_insumo_id | UUID | FK → APLICACAO_INSUMO | Se tipo = saida_aplicacao |
| transferencia_destino_id | UUID | FK → ESTOQUE_INSUMO | Se tipo = saida_transferencia |
| responsavel_id | UUID | FK → USERS | Quem registrou |
| documento_referencia | VARCHAR(50) | Nao | NF, requisicao, ordem servico |
| observacoes | TEXT | Nao | Notas |
| created_at | TIMESTAMP | Sim | |

**Tipos de Movimentacao (ENUM):**

| Tipo | Direcao | Quando Acontece |
|------|---------|-----------------|
| entrada_compra | + | Castrolanda entrega insumo |
| entrada_barter | + | Recebe insumo via troca por grao |
| entrada_producao | + | Semente propria, lenha propria |
| entrada_devolucao | + | Campo devolveu sobra |
| entrada_ajuste | + | Inventario encontrou mais do que sistema |
| saida_aplicacao | - | Aplicou no campo (vincula APLICACAO_INSUMO) |
| saida_pecuaria | - | Usou na pecuaria (medicamento, racao, sal) |
| saida_manutencao | - | Usou em manutencao (peca, oleo, filtro) |
| saida_ubg | - | Usou na UBG (lenha secador, energia) |
| saida_transferencia | - | Transferiu para outro local/fazenda |
| saida_perda | - | Produto venceu, estragou, roubado |
| saida_ajuste | - | Inventario encontrou menos do que sistema |

**Relacionamentos:**
- ESTOQUE_INSUMO (N:1) - Qual estoque afetou
- COMPRA_INSUMO (N:1) - Origem da entrada (se compra)
- APLICACAO_INSUMO (N:1) - Destino da saida (se aplicacao)

---

### 2.5 APLICACAO_INSUMO (Refatorada)

**Refatora:** APLICACAO_INSUMO do doc 08
**Funcao:** Cada uso de insumo no campo, vinculado a operacao, estoque e custo.

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | Identificador unico |
| organization_id | UUID | FK → ORGANIZATIONS | Organizacao |
| produto_insumo_id | UUID | FK → PRODUTO_INSUMO | Qual produto |
| estoque_insumo_id | UUID | FK → ESTOQUE_INSUMO | De qual estoque saiu |
| operacao_campo_id | UUID | FK → OPERACAO_CAMPO | Operacao vinculada (se agricola) |
| talhao_safra_id | UUID | FK → TALHAO_SAFRA | Onde aplicou |
| manejo_sanitario_id | UUID | FK → MANEJO_SANITARIO | Se uso pecuario |
| manutencao_id | UUID | FK → MANUTENCOES | Se uso em manutencao |
| receituario_id | UUID | FK → RECEITUARIO_AGRONOMICO | Receita (se defensivo) |
| data_aplicacao | DATE | Sim | Data da aplicacao |
| dose_por_ha | DECIMAL(10,4) | Nao | Dose aplicada por hectare |
| area_aplicada_ha | DECIMAL(10,4) | Nao | Area efetivamente aplicada |
| quantidade_total | DECIMAL(12,4) | Sim | Quantidade total consumida |
| unidade | VARCHAR(20) | Sim | Unidade |
| custo_unitario | DECIMAL(12,4) | Sim | Custo medio na data (do estoque) |
| custo_total | DECIMAL(14,2) | Sim | quantidade x custo_unitario |
| metodo_aplicacao | ENUM | Nao | plantadeira, pulverizador, distribuidor, drone, manual, cocho, seringa |
| contexto | ENUM | Sim | agricola, pecuario, manutencao, ubg |
| observacoes | TEXT | Nao | Notas |
| created_at | TIMESTAMP | Sim | |
| updated_at | TIMESTAMP | Sim | |

**Regra: Uma OPERACAO_CAMPO pode ter N aplicacoes de insumo.**
```
Exemplo: Plantio de Soja no Talhao Bonin
  OPERACAO_CAMPO (tipo=plantio, talhao_safra=Bonin-Soja-25/26)
      │
      ├── APLICACAO_INSUMO #1: Semente TMG 4185 → 75kg/ha x 85,5ha = 6.412kg
      ├── APLICACAO_INSUMO #2: Inoculante Nitragin → 2 doses/ha x 85,5ha = 171 doses
      ├── APLICACAO_INSUMO #3: MAP 08-40-00 → 250kg/ha x 85,5ha = 21.375kg
      └── APLICACAO_INSUMO #4: Tratamento Standak → 200ml/ha x 85,5ha = 17,1L

Exemplo: Pulverizacao Fungicida
  OPERACAO_CAMPO (tipo=pulverizacao_fungicida, talhao_safra=Bonin-Soja-25/26)
      │
      ├── PULVERIZACAO_DETALHE (dados tecnicos: pressao 3 bar, vazao 150 L/ha)
      ├── APLICACAO_INSUMO #1: Fox Xpro → 0,4 L/ha x 85,5ha = 34,2L
      └── APLICACAO_INSUMO #2: Oleo mineral → 0,5 L/ha x 85,5ha = 42,75L
```

**Relacionamentos:**
- PRODUTO_INSUMO (N:1) - Qual produto
- ESTOQUE_INSUMO (N:1) - De onde saiu
- OPERACAO_CAMPO (N:1) - Operacao agricola vinculada
- TALHAO_SAFRA (N:1) - Onde aplicou
- MANEJO_SANITARIO (N:1) - Se aplicacao pecuaria
- MANUTENCOES (N:1) - Se uso em manutencao
- RECEITUARIO_AGRONOMICO (N:1) - Receita agronomica
- MOVIMENTACAO_INSUMO (1:1) - Gera saida no estoque
- CUSTO_OPERACAO (1:1) - Gera lancamento de custo

---

### 2.6 RECEITUARIO_AGRONOMICO (Mantido, ajustado)

**Status:** Manter. Apenas atualizar FK de `insumo_id` para `produto_insumo_id`.

| Coluna | Tipo | Obrigatorio | Descricao |
|--------|------|-------------|-----------|
| id | UUID | PK | |
| organization_id | UUID | FK → ORGANIZATIONS | |
| produto_insumo_id | UUID | FK → PRODUTO_INSUMO | Produto prescrito |
| numero_receita | VARCHAR(50) | Sim | Numero da receita |
| numero_art | VARCHAR(50) | Sim | ART do agronomo |
| responsavel_tecnico | VARCHAR(200) | Sim | Nome do agronomo |
| crea | VARCHAR(20) | Sim | CREA do agronomo |
| cultura_id | UUID | FK → CULTURAS | Cultura alvo |
| praga_alvo | VARCHAR(200) | Nao | Praga/doenca/daninha alvo |
| dose_prescrita | DECIMAL(10,4) | Sim | Dose prescrita |
| unidade_dose | VARCHAR(20) | Sim | L/ha, kg/ha, mL/ha |
| intervalo_seguranca_dias | INTEGER | Sim | Carencia antes colheita |
| data_emissao | DATE | Sim | Data da receita |
| data_validade | DATE | Sim | Validade da receita |
| observacoes | TEXT | Nao | |
| arquivo_url | VARCHAR(500) | Nao | PDF da receita |
| created_at | TIMESTAMP | Sim | |
| updated_at | TIMESTAMP | Sim | |

---

## 3. Diagrama de Relacionamentos Completo

### 3.1 Fluxo Principal

```
                                     PARCEIRO_COMERCIAL
                                            │
                                            │ fornecedor
                                            ▼
PRODUTO_INSUMO ────────────────────► COMPRA_INSUMO
(catalogo)                          (registro compra)
     │                                      │
     │                                      │ vinculo NF
     │                                      ├──────────────► NOTA_FISCAL_ITEM
     │                                      │
     │                                      │ gera entrada
     │                                      ▼
     │                              MOVIMENTACAO_INSUMO
     │                              (tipo: entrada_compra)
     │                                      │
     │                                      │ atualiza saldo
     │                                      ▼
     ├─────────────────────────────► ESTOQUE_INSUMO
     │                              (saldo atual)
     │                                      │
     │                                      │ gera saida
     │                                      ▼
     │                              MOVIMENTACAO_INSUMO
     │                              (tipo: saida_aplicacao)
     │                                      │
     │                                      │ referencia
     │                                      ▼
     ├─────────────────────────────► APLICACAO_INSUMO ◄──── RECEITUARIO_AGRONOMICO
     │                              (uso no campo)                (se defensivo)
     │                                      │
     │                                      │ vincula operacao
     │                                      ├──────────────► OPERACAO_CAMPO
     │                                      │                    │
     │                                      │                    ├── PLANTIO_DETALHE
     │                                      │                    ├── PULVERIZACAO_DETALHE
     │                                      │                    └── DRONE_DETALHE
     │                                      │
     │                                      │ vincula talhao
     │                                      ├──────────────► TALHAO_SAFRA
     │                                      │
     │                                      │ gera custo
     │                                      ▼
     │                              CUSTO_OPERACAO
     │                              (tipo: insumo)
     │                                      │
     │                                      ▼
     │                              CENTRO_CUSTO
     │                              (hierarquia)
     │
     │ (pecuaria)
     ├─────────────────────────────► DIETA_INGREDIENTE
     │                                      │
     │                                      ▼
     │                              TRATO_ALIMENTAR
     │
     │ (pecuaria sanitario)
     └─────────────────────────────► MANEJO_SANITARIO
```

### 3.2 Conexoes com Entidades Existentes

| Entidade Nova | Conecta Com | Tipo | FK Fica Em |
|---------------|-------------|------|-----------|
| PRODUTO_INSUMO | ORGANIZATIONS | N:1 | produto_insumo.organization_id |
| PRODUTO_INSUMO | COMPRA_INSUMO | 1:N | compra_insumo.produto_insumo_id |
| PRODUTO_INSUMO | ESTOQUE_INSUMO | 1:N | estoque_insumo.produto_insumo_id |
| PRODUTO_INSUMO | APLICACAO_INSUMO | 1:N | aplicacao_insumo.produto_insumo_id |
| PRODUTO_INSUMO | RECEITUARIO_AGRONOMICO | 1:N | receituario.produto_insumo_id |
| PRODUTO_INSUMO | PULVERIZACAO_DETALHE | 1:N | pulverizacao_detalhe.insumo_id (renomear) |
| PRODUTO_INSUMO | DRONE_DETALHE | 1:N | drone_detalhe.insumo_id (renomear) |
| PRODUTO_INSUMO | DIETA_INGREDIENTE | 1:N | dieta_ingrediente.insumo_id (renomear) |
| COMPRA_INSUMO | NOTA_FISCAL_ITEM | N:1 | compra_insumo.nota_fiscal_item_id |
| COMPRA_INSUMO | PARCEIRO_COMERCIAL | N:1 | compra_insumo.parceiro_id |
| COMPRA_INSUMO | SAFRAS | N:1 | compra_insumo.safra_id |
| COMPRA_INSUMO | CULTURAS | N:1 | compra_insumo.cultura_destino_id |
| COMPRA_INSUMO | CONTRATO_COMERCIAL | N:1 | compra_insumo.contrato_barter_id |
| ESTOQUE_INSUMO | FAZENDAS | N:1 | estoque_insumo.fazenda_id |
| MOVIMENTACAO_INSUMO | ESTOQUE_INSUMO | N:1 | movimentacao.estoque_insumo_id |
| MOVIMENTACAO_INSUMO | COMPRA_INSUMO | N:1 | movimentacao.compra_insumo_id |
| MOVIMENTACAO_INSUMO | APLICACAO_INSUMO | N:1 | movimentacao.aplicacao_insumo_id |
| APLICACAO_INSUMO | OPERACAO_CAMPO | N:1 | aplicacao_insumo.operacao_campo_id |
| APLICACAO_INSUMO | TALHAO_SAFRA | N:1 | aplicacao_insumo.talhao_safra_id |
| APLICACAO_INSUMO | ESTOQUE_INSUMO | N:1 | aplicacao_insumo.estoque_insumo_id |
| APLICACAO_INSUMO | MANEJO_SANITARIO | N:1 | aplicacao_insumo.manejo_sanitario_id |
| APLICACAO_INSUMO | MANUTENCOES | N:1 | aplicacao_insumo.manutencao_id |
| APLICACAO_INSUMO | CUSTO_OPERACAO | 1:1 | custo_operacao.aplicacao_insumo_id (ja existe) |

---

## 4. FKs a Renomear em Entidades Existentes

Entidades que hoje referenciam `INSUMO` e precisam apontar para `PRODUTO_INSUMO`:

| Entidade | Campo Atual | Renomear Para |
|----------|-------------|---------------|
| PULVERIZACAO_DETALHE | insumo_id | produto_insumo_id |
| DRONE_DETALHE | insumo_id | produto_insumo_id |
| DIETA_INGREDIENTE | insumo_id | produto_insumo_id |
| NOTA_FISCAL_ITEM | insumo_id | produto_insumo_id |
| CONTRATO_COMERCIAL | barter_insumo_id | barter_produto_insumo_id |

---

## 5. Plano de Acao no Miro

### 5.1 Posicionamento no Board

O modulo de Insumos fica na **Camada Agricola (y=2000-5000)**, posicao x=-4000, entre Operacoes de Campo (x=-8000) e o bloco de Solo (x=-6000, y=5000).

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    CAMADA AGRICOLA (y=2000-5000) - Amarelo                        │
│                                                                                  │
│  x=-10000      x=-8000       x=-5000       x=-2000       x=0                    │
│  ┌────────┐   ┌────────────┐ ┌────────────┐ ┌──────────┐ ┌──────────┐           │
│  │TALHAO  │   │ OPERACAO   │ │★ MODULO    │ │ ANALISE  │ │          │           │
│  │_SAFRA  │──►│ _CAMPO     │ │  INSUMOS   │ │  SOLO    │ │          │           │
│  │        │   │            │ │            │ │          │ │          │           │
│  └────────┘   │ PLANTIO_D  │ │ PRODUTO_I  │ │RECOMEND. │ │          │           │
│               │ COLHEITA_D │ │     │       │ │ ADUBACAO │ │          │           │
│  y=2000       │ PULVERIZ_D │ │ COMPRA_I   │ │          │ │          │           │
│               │ DRONE_D    │ │     │       │ └──────────┘ │          │           │
│               │ TRANSP_D   │ │ ESTOQUE_I  │               │          │           │
│               │            │ │     │       │               │          │           │
│               │APLICACAO_I◄├─┤ MOVIMENT_I │               │          │           │
│               │            │ │            │               │          │           │
│               │RECEITUARIO │ │            │               │          │           │
│  y=5000       └────────────┘ └────────────┘               └──────────┘           │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### 5.2 Coordenadas Exatas das Entidades no Miro

| Entidade | X | Y | Cor | Acao |
|----------|---|---|-----|------|
| PRODUTO_INSUMO | -5000 | 2000 | Amarelo (#fff6b6) | CRIAR (substitui INSUMO) |
| COMPRA_INSUMO | -5000 | 3000 | Amarelo (#fff6b6) | CRIAR (substitui INSUMOS_CASTROLANDA) |
| ESTOQUE_INSUMO | -5000 | 4000 | Amarelo (#fff6b6) | CRIAR |
| MOVIMENTACAO_INSUMO | -3500 | 4000 | Amarelo (#fff6b6) | CRIAR |
| APLICACAO_INSUMO | -7000 | 3500 | Amarelo (#fff6b6) | REFATORAR (mover do x=-6000 y=2000) |
| RECEITUARIO_AGRONOMICO | -7000 | 4500 | Amarelo (#fff6b6) | MANTER (mover do x=-6000 y=2000) |
| ~~INSUMO~~ | ~~-6000~~ | ~~2000~~ | ~~Amarelo~~ | REMOVER (substituido por PRODUTO_INSUMO) |

### 5.3 Passo a Passo no Miro

```
FASE 1: LIMPAR (5 min)
──────────────────────
[ ] Ir na posicao x=-6000, y=2000 (bloco "Insumos" atual)
[ ] Mover a entidade INSUMO para o lado com nota "DEPRECATED → PRODUTO_INSUMO"
[ ] Mover APLICACAO_INSUMO para x=-7000, y=3500
[ ] Mover RECEITUARIO_AGRONOMICO para x=-7000, y=4500
[ ] Apagar conectores antigos dessas entidades

FASE 2: CRIAR ENTIDADES (20 min)
─────────────────────────────────
[ ] Criar frame "MODULO INSUMOS E ESTOQUE" na posicao x=-5500, y=1500
    Tamanho: 3000 x 4000
    Cor de fundo: #fff6b6 (amarelo claro)

[ ] Criar tabela PRODUTO_INSUMO em x=-5000, y=2000
    - Campos: id, organization_id, codigo, nome, principio_ativo,
      tipo (ENUM longa), grupo, unidade_medida, fabricante,
      registro_mapa, classe_toxicologica, carencia_dias,
      dose_recomendada_min, dose_recomendada_max, ativo,
      created_at, updated_at
    - PK amarelo, FKs azul

[ ] Criar tabela COMPRA_INSUMO em x=-5000, y=3000
    - Campos: id, organization_id, produto_insumo_id, nota_fiscal_item_id,
      parceiro_id, safra_id, fonte (ENUM), data_compra, quantidade,
      unidade, valor_unitario, valor_total, lote_fabricante, data_validade,
      cultura_destino_id, castrolanda_sync_id, contrato_barter_id,
      status, created_at, updated_at
    - PK amarelo, FKs azul

[ ] Criar tabela ESTOQUE_INSUMO em x=-5000, y=4000
    - Campos: id, organization_id, produto_insumo_id, fazenda_id,
      local_armazenamento, quantidade_atual, unidade,
      custo_medio_unitario, valor_total_estoque, quantidade_minima,
      validade_mais_proxima, status, created_at, updated_at
    - PK amarelo, FKs azul

[ ] Criar tabela MOVIMENTACAO_INSUMO em x=-3500, y=4000
    - Campos: id, estoque_insumo_id, tipo (ENUM), data_movimento,
      quantidade, custo_unitario, valor_total, saldo_anterior,
      saldo_posterior, custo_medio_anterior, custo_medio_posterior,
      compra_insumo_id, aplicacao_insumo_id, transferencia_destino_id,
      responsavel_id, created_at
    - PK amarelo, FKs azul

FASE 3: ATUALIZAR APLICACAO_INSUMO (10 min)
────────────────────────────────────────────
[ ] Na entidade APLICACAO_INSUMO (agora em x=-7000, y=3500):
    - Remover campo antigo: insumo_id, talhao_id
    - Adicionar campos: produto_insumo_id, estoque_insumo_id,
      operacao_campo_id, talhao_safra_id, manejo_sanitario_id,
      manutencao_id, receituario_id, data_aplicacao, dose_por_ha,
      area_aplicada_ha, quantidade_total, unidade, custo_unitario,
      custo_total, metodo_aplicacao (ENUM), contexto (ENUM)

[ ] Na entidade RECEITUARIO_AGRONOMICO (agora em x=-7000, y=4500):
    - Renomear insumo_id → produto_insumo_id
    - Adicionar campos: numero_art, cultura_id, dose_prescrita,
      intervalo_seguranca_dias, arquivo_url

FASE 4: DESENHAR CONECTORES (15 min)
─────────────────────────────────────
Dentro do modulo:
[ ] PRODUTO_INSUMO ──|────<── COMPRA_INSUMO (1:N)
[ ] PRODUTO_INSUMO ──|────<── ESTOQUE_INSUMO (1:N)
[ ] PRODUTO_INSUMO ──|────<── APLICACAO_INSUMO (1:N)
[ ] PRODUTO_INSUMO ──|────<── RECEITUARIO_AGRONOMICO (1:N)
[ ] COMPRA_INSUMO ──|────|── MOVIMENTACAO_INSUMO (1:1 gera entrada)
[ ] ESTOQUE_INSUMO ──|────<── MOVIMENTACAO_INSUMO (1:N)
[ ] APLICACAO_INSUMO ──|────|── MOVIMENTACAO_INSUMO (1:1 gera saida)

Conectores EXTERNOS (para outras camadas):
[ ] COMPRA_INSUMO ────► NOTA_FISCAL_ITEM (Financeiro, y=8000)
    Linha tracejada laranja
[ ] COMPRA_INSUMO ────► PARCEIRO_COMERCIAL (Territorial, y=-2000)
    Linha tracejada verde
[ ] COMPRA_INSUMO ────► SAFRAS (Territorial, y=-2000)
    Linha tracejada verde
[ ] ESTOQUE_INSUMO ────► FAZENDAS (Territorial, y=-2000)
    Linha tracejada verde
[ ] APLICACAO_INSUMO ────► OPERACAO_CAMPO (Agricola, x=-8000)
    Linha solida amarela
[ ] APLICACAO_INSUMO ────► TALHAO_SAFRA (Territorial, y=-2000)
    Linha tracejada verde
[ ] APLICACAO_INSUMO ────► CUSTO_OPERACAO (Financeiro, y=8000)
    Linha tracejada laranja

FASE 5: ATUALIZAR ENTIDADES EXISTENTES (10 min)
────────────────────────────────────────────────
[ ] PULVERIZACAO_DETALHE: renomear insumo_id → produto_insumo_id
    Adicionar nota: "Para detalhes de consumo, ver APLICACAO_INSUMO"
[ ] DRONE_DETALHE: renomear insumo_id → produto_insumo_id
    Adicionar nota: "Para detalhes de consumo, ver APLICACAO_INSUMO"
[ ] DIETA_INGREDIENTE: renomear insumo_id → produto_insumo_id
[ ] NOTA_FISCAL_ITEM: renomear insumo_id → produto_insumo_id

FASE 6: ADICIONAR NOTAS E LEGENDA (5 min)
──────────────────────────────────────────
[ ] Sticky note no frame do modulo:
    "CICLO DE VIDA DO INSUMO:
     Compra → Estoque → Aplicacao → Custo
     Custeio: Custo Medio Ponderado"

[ ] Sticky note com regra de negocio:
    "1 OPERACAO_CAMPO pode ter N APLICACAO_INSUMO
     Ex: Plantio = semente + inoculante + adubo base
     Ex: Pulverizacao = fungicida + adjuvante"

[ ] Sticky note sobre PULVERIZACAO_DETALHE:
    "PULVERIZACAO_DETALHE = dados TECNICOS (pressao, vazao, clima)
     APLICACAO_INSUMO = dados de PRODUTO (qual, quanto, custo)
     Nao sao redundantes - complementam"

[ ] Adicionar nota na entidade INSUMO antiga:
    "DEPRECATED - Substituido por PRODUTO_INSUMO (doc 15)
     Nao usar mais esta entidade"
```

---

## 6. Impacto na Contagem Total de Entidades

| Camada | Antes | Depois | Diferenca |
|--------|-------|--------|-----------|
| Sistema | 11 | 11 | 0 |
| Territorial | 8 | 8 | 0 |
| Agricola | 14 | 16 | +2 (ESTOQUE_INSUMO, MOVIMENTACAO_INSUMO) |
| Operacional | 7 | 7 | 0 |
| Financeiro | 11 | 11 | 0 |
| Pecuaria | 26 | 26 | 0 (DIETA_INGREDIENTE so renomeia FK) |
| Infraestrutura | 11 | 11 | 0 |
| **TOTAL** | **~88** | **~90** | **+2 novas, 2 substituidas, 1 refatorada** |

**Resumo:**
- 2 entidades NOVAS: ESTOQUE_INSUMO, MOVIMENTACAO_INSUMO
- 2 entidades SUBSTITUIDAS: INSUMO → PRODUTO_INSUMO, INSUMOS_CASTROLANDA → COMPRA_INSUMO
- 1 entidade REFATORADA: APLICACAO_INSUMO (expandida)
- 1 entidade MANTIDA: RECEITUARIO_AGRONOMICO (ajuste de FK)
- 5 entidades com FK RENOMEADA: PULVERIZACAO_DETALHE, DRONE_DETALHE, DIETA_INGREDIENTE, NOTA_FISCAL_ITEM, CONTRATO_COMERCIAL

---

## 7. Queries de Validacao

### 7.1 Saldo de Estoque por Produto

```sql
SELECT
    pi.nome as produto,
    pi.tipo,
    ei.local_armazenamento,
    ei.quantidade_atual,
    ei.unidade,
    ei.custo_medio_unitario,
    ei.valor_total_estoque,
    ei.quantidade_minima,
    CASE
        WHEN ei.quantidade_atual <= ei.quantidade_minima THEN 'REPOR'
        WHEN ei.quantidade_atual <= ei.quantidade_minima * 1.5 THEN 'ATENCAO'
        ELSE 'OK'
    END as status_reposicao
FROM estoque_insumo ei
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.id
WHERE ei.organization_id = :org_id
  AND ei.status = 'ativo'
ORDER BY pi.tipo, pi.nome;
```

### 7.2 Consumo de Insumos por Cultura na Safra

```sql
SELECT
    c.nome as cultura,
    pi.tipo as tipo_insumo,
    pi.nome as produto,
    SUM(ai.quantidade_total) as quantidade_consumida,
    ai.unidade,
    SUM(ai.custo_total) as custo_total,
    SUM(ai.custo_total) / SUM(ai.area_aplicada_ha) as custo_por_ha
FROM aplicacao_insumo ai
JOIN produto_insumo pi ON ai.produto_insumo_id = pi.id
JOIN talhao_safra ts ON ai.talhao_safra_id = ts.id
JOIN culturas c ON ts.cultura_id = c.id
WHERE ts.safra_id = :safra_id
GROUP BY c.nome, pi.tipo, pi.nome, ai.unidade
ORDER BY c.nome, custo_total DESC;
```

### 7.3 Compras por Fornecedor na Safra

```sql
SELECT
    pc.razao_social as fornecedor,
    ci.fonte,
    COUNT(*) as qtd_compras,
    SUM(ci.valor_total) as valor_total_compras,
    COUNT(DISTINCT ci.produto_insumo_id) as produtos_diferentes
FROM compra_insumo ci
JOIN parceiro_comercial pc ON ci.parceiro_id = pc.id
WHERE ci.safra_id = :safra_id
GROUP BY pc.razao_social, ci.fonte
ORDER BY valor_total_compras DESC;
```

### 7.4 Movimentacoes do Mes (Auditoria)

```sql
SELECT
    pi.nome as produto,
    mi.tipo as tipo_movimento,
    mi.data_movimento,
    mi.quantidade,
    mi.custo_unitario,
    mi.valor_total,
    mi.saldo_anterior,
    mi.saldo_posterior,
    u.nome as responsavel
FROM movimentacao_insumo mi
JOIN estoque_insumo ei ON mi.estoque_insumo_id = ei.id
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.id
LEFT JOIN users u ON mi.responsavel_id = u.id
WHERE mi.data_movimento BETWEEN :inicio AND :fim
ORDER BY mi.data_movimento;
```

### 7.5 Produtos Proximos do Vencimento

```sql
SELECT
    pi.nome as produto,
    pi.tipo,
    ei.local_armazenamento,
    ei.quantidade_atual,
    ei.validade_mais_proxima,
    ei.validade_mais_proxima - CURRENT_DATE as dias_para_vencer
FROM estoque_insumo ei
JOIN produto_insumo pi ON ei.produto_insumo_id = pi.id
WHERE ei.validade_mais_proxima IS NOT NULL
  AND ei.validade_mais_proxima <= CURRENT_DATE + INTERVAL '90 days'
  AND ei.quantidade_atual > 0
ORDER BY ei.validade_mais_proxima;
```

---

## 8. Proximos Passos

| # | Acao | Tempo Estimado | Responsavel |
|---|------|----------------|-------------|
| 1 | Implementar no Miro (Fases 1-6 acima) | 1h | Rodrigo |
| 2 | Revisar conectores com entidades existentes | 30min | Rodrigo |
| 3 | Validar tipos de PRODUTO_INSUMO com Claudio | Na reuniao | Rodrigo + Claudio |
| 4 | Confirmar locais de armazenamento reais | Na reuniao | Claudio |
| 5 | Mapear produtos Castrolanda existentes | Pos-reuniao | Valentina |
| 6 | Revisar viabilidade tecnica com Joao | Pos-Miro | Joao |
| 7 | Gerar DDL SQL completo | Apos validacao | Claude |

---

## 9. Perguntas para Claudio (Especificas de Insumos)

| # | Pergunta | Por Que |
|---|----------|---------|
| 1 | Onde ficam armazenados os insumos? Galpao? Deposito separado para defensivos? | Definir locais de estoque |
| 2 | Existe controle de estoque hoje? Planilha? Caderno? Nada? | Entender baseline |
| 3 | Quem controla a entrada de insumos quando Castrolanda entrega? | Definir responsavel |
| 4 | O Alessandro (agronomo) emite receituario para todas as aplicacoes? | Compliance MAPA |
| 5 | Compra insumos de outros fornecedores alem da Castrolanda? Quais? | Fonte da COMPRA_INSUMO |
| 6 | Usa semente propria (guardada da safra) ou sempre compra certificada? | Tipo entrada_producao |
| 7 | Tem produtos que vencem no deposito? Perde insumo com frequencia? | Alerta de validade |
| 8 | A lenha do secador e comprada ou produzida na fazenda? | Fluxo de entrada |

---

*Documento gerado em 09/02/2026 - DeepWork AI Flows*
*Plano de acao para implementacao no Miro + documentacao ER*
