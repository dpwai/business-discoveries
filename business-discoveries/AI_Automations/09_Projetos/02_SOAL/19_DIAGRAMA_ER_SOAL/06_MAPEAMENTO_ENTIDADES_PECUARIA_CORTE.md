# Mapeamento de Entidades - Pecuaria de Corte

**Data:** 04/02/2026
**Projeto:** SOAL - Extensao Pecuaria
**Miro Board:** https://miro.com/app/board/uXjVGFydjCo=/

---

## Sumario Executivo

Este documento mapeia todas as entidades necessarias para um modulo de **Pecuaria de Corte** integrado a plataforma SOAL. O modelo suporta:

- Gestao individual de animais com rastreabilidade SISBOV
- Manejo de pastos com pastejo rotacionado
- Controle de pesagens e ganho de peso (GMD)
- Calendario sanitario completo
- Reproducao com IATF e monta natural
- Comercializacao e abate com classificacao de carcaca

---

## 1. Dominio: Cadastros Base

### 1.1 Animal
**Entidade central do sistema - cada animal eh rastreado individualmente**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| fazenda_id | UUID | FK -> Fazenda |
| raca_id | UUID | FK -> Raca |
| categoria_id | UUID | FK -> Categoria_Animal |
| lote_id | UUID | FK -> Lote (nullable) |
| mae_id | UUID | FK -> Animal (nullable) |
| pai_id | UUID | FK -> Animal (nullable) |
| codigo_brinco | VARCHAR(50) | Identificacao visual |
| codigo_sisbov | VARCHAR(20) | Rastreabilidade oficial |
| nome | VARCHAR(100) | Nome do animal (opcional) |
| sexo | ENUM | MACHO, FEMEA |
| data_nascimento | DATE | |
| peso_nascimento_kg | DECIMAL(6,2) | |
| peso_atual_kg | DECIMAL(8,2) | Ultima pesagem |
| data_ultima_pesagem | DATE | |
| pelagem | VARCHAR(50) | Cor/padrao |
| origem | ENUM | NASCIMENTO, COMPRA, TRANSFERENCIA |
| data_entrada | DATE | Data entrada na fazenda |
| status | ENUM | ATIVO, VENDIDO, MORTO, TRANSFERIDO |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 1.2 Raca
**Catalogo de racas bovinas**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| nome | VARCHAR(100) | Ex: Nelore, Angus, Brahman |
| nome_cientifico | VARCHAR(200) | |
| tipo | ENUM | CORTE, LEITE, DUPLA_APTIDAO |
| origem_pais | VARCHAR(50) | Pais de origem |
| caracteristicas | TEXT | Descricao da raca |
| created_at | TIMESTAMP | |

### 1.3 Categoria_Animal
**Classificacao por idade/sexo**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| nome | VARCHAR(50) | Ex: Bezerro, Garrote, Novilho, Boi, Vaca, Touro |
| descricao | TEXT | |
| idade_min_meses | INTEGER | |
| idade_max_meses | INTEGER | |
| sexo | ENUM | MACHO, FEMEA, AMBOS |
| created_at | TIMESTAMP | |

### 1.4 Lote
**Agrupamento de animais para manejo**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| fazenda_id | UUID | FK -> Fazenda |
| piquete_id | UUID | FK -> Piquete (nullable) |
| nome | VARCHAR(100) | |
| codigo | VARCHAR(50) | |
| tipo | ENUM | CRIA, RECRIA, ENGORDA, REPRODUCAO |
| quantidade_animais | INTEGER | |
| peso_medio_kg | DECIMAL(8,2) | |
| data_formacao | DATE | |
| data_encerramento | DATE | Quando lote foi dissolvido |
| status | ENUM | ATIVO, ENCERRADO |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

---

## 2. Dominio: Estrutura de Pasto

### 2.1 Pasto
**Area de pastagem**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| fazenda_id | UUID | FK -> Fazenda |
| nome | VARCHAR(100) | |
| codigo | VARCHAR(50) | |
| area_ha | DECIMAL(10,2) | |
| tipo_capim | VARCHAR(100) | Ex: Brachiaria, Panicum |
| capacidade_ua | DECIMAL(8,2) | Unidades Animal |
| sistema_pastejo | ENUM | ROTACIONADO, CONTINUO, DIFERIDO |
| coordenadas_polygon | POLYGON | Geometria GIS |
| status | ENUM | ATIVO, REFORMA, INATIVO |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 2.2 Piquete
**Subdivisao do pasto para rotacao**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| pasto_id | UUID | FK -> Pasto |
| nome | VARCHAR(100) | |
| codigo | VARCHAR(50) | |
| area_ha | DECIMAL(10,2) | |
| capacidade_ua | DECIMAL(8,2) | |
| dias_ocupacao | INTEGER | Dias padrao de ocupacao |
| dias_descanso | INTEGER | Dias padrao de descanso |
| data_ultima_ocupacao | DATE | |
| status | ENUM | OCUPADO, DESCANSO, MANUTENCAO |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 2.3 Movimentacao_Pasto
**Registro de rotacao entre piquetes**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| lote_id | UUID | FK -> Lote |
| piquete_origem_id | UUID | FK -> Piquete |
| piquete_destino_id | UUID | FK -> Piquete |
| responsavel_id | UUID | FK -> User |
| data_movimentacao | TIMESTAMP | |
| quantidade_animais | INTEGER | |
| motivo | TEXT | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 2.4 Avaliacao_Pasto
**Monitoramento de qualidade da pastagem**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| piquete_id | UUID | FK -> Piquete |
| avaliador_id | UUID | FK -> User |
| data_avaliacao | DATE | |
| altura_capim_cm | DECIMAL(5,2) | |
| cobertura_percent | DECIMAL(5,2) | % de cobertura |
| massa_forragem_kg_ha | DECIMAL(10,2) | Materia seca |
| qualidade_score | INTEGER | 1-5 |
| pragas_detectadas | BOOLEAN | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

---

## 3. Dominio: Manejo e Pesagem

### 3.1 Pesagem
**Registro de pesagens com calculo de GMD**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| lote_id | UUID | FK -> Lote |
| responsavel_id | UUID | FK -> User |
| data_pesagem | DATE | |
| peso_kg | DECIMAL(8,2) | |
| peso_anterior_kg | DECIMAL(8,2) | Calculado |
| ganho_periodo_kg | DECIMAL(6,2) | Calculado |
| dias_periodo | INTEGER | Dias desde ultima pesagem |
| gmd_kg | DECIMAL(6,3) | Ganho Medio Diario |
| escore_corporal | INTEGER | 1-9 |
| tipo_pesagem | ENUM | ROTINA, COMPRA, VENDA, APARTACAO |
| equipamento | VARCHAR(100) | Balanca utilizada |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 3.2 Movimentacao_Animal
**Transferencia entre lotes**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| lote_origem_id | UUID | FK -> Lote |
| lote_destino_id | UUID | FK -> Lote |
| responsavel_id | UUID | FK -> User |
| data_movimentacao | TIMESTAMP | |
| tipo | ENUM | TRANSFERENCIA, APARTACAO, MANEJO |
| motivo | TEXT | |
| peso_momento_kg | DECIMAL(8,2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 3.3 Apartacao
**Separacao de animais por criterio**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| lote_origem_id | UUID | FK -> Lote |
| responsavel_id | UUID | FK -> User |
| data_apartacao | DATE | |
| criterio | ENUM | PESO, SEXO, IDADE, ESCORE |
| quantidade_apartada | INTEGER | |
| peso_minimo_kg | DECIMAL(8,2) | |
| peso_maximo_kg | DECIMAL(8,2) | |
| destino | ENUM | VENDA, OUTRO_LOTE, REPRODUCAO |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 3.4 Morte
**Registro de perdas**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| responsavel_id | UUID | FK -> User |
| data_morte | DATE | |
| causa | ENUM | DOENCA, ACIDENTE, PREDADOR, RAIO, PARTO, DESCONHECIDA |
| causa_detalhada | TEXT | |
| peso_estimado_kg | DECIMAL(8,2) | |
| laudo_veterinario | BOOLEAN | |
| arquivo_laudo_url | VARCHAR(500) | |
| valor_perda | DECIMAL(12,2) | Prejuizo estimado |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

---

## 4. Dominio: Sanidade

### 4.1 Evento_Sanitario
**Vacinas, vermifugos, tratamentos**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal (nullable para lote) |
| lote_id | UUID | FK -> Lote (nullable para individual) |
| protocolo_id | UUID | FK -> Protocolo_Sanitario |
| responsavel_id | UUID | FK -> User |
| data_evento | DATE | |
| tipo | ENUM | VACINA, VERMIFUGO, ANTIBIOTICO, VITAMINA, HORMONIO, OUTRO |
| produto_nome | VARCHAR(200) | |
| produto_fabricante | VARCHAR(100) | |
| lote_produto | VARCHAR(50) | |
| validade_produto | DATE | |
| dosagem | DECIMAL(10,3) | |
| unidade_dosagem | VARCHAR(20) | ml, mg, etc |
| via_aplicacao | ENUM | INTRAMUSCULAR, SUBCUTANEA, ORAL, POUR_ON |
| carencia_dias | INTEGER | Dias de carencia |
| custo_unitario | DECIMAL(10,2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 4.2 Protocolo_Sanitario
**Templates de tratamentos**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| organization_id | UUID | FK -> Organization |
| nome | VARCHAR(200) | |
| tipo | ENUM | VACINACAO, VERMIFUGACAO, TRATAMENTO |
| descricao | TEXT | |
| periodicidade_dias | INTEGER | Intervalo de aplicacao |
| categoria_alvo | VARCHAR(100) | Categorias que recebem |
| obrigatorio | BOOLEAN | Exigido por lei |
| status | ENUM | ATIVO, INATIVO |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 4.3 Calendario_Sanitario
**Agenda de eventos sanitarios**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| protocolo_id | UUID | FK -> Protocolo_Sanitario |
| fazenda_id | UUID | FK -> Fazenda |
| mes_execucao | INTEGER | 1-12 |
| ano_execucao | INTEGER | |
| data_prevista | DATE | |
| data_executada | DATE | |
| status | ENUM | PENDENTE, EXECUTADO, ATRASADO |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 4.4 Exame_Laboratorial
**Exames de brucelose, tuberculose, etc**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| solicitante_id | UUID | FK -> User |
| data_coleta | DATE | |
| tipo_exame | ENUM | BRUCELOSE, TUBERCULOSE, HEMOGRAMA, OUTRO |
| laboratorio | VARCHAR(200) | |
| numero_protocolo | VARCHAR(50) | |
| data_resultado | DATE | |
| resultado | ENUM | NEGATIVO, POSITIVO, INCONCLUSIVO |
| valores | JSONB | Valores detalhados |
| arquivo_laudo_url | VARCHAR(500) | |
| custo | DECIMAL(10,2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

---

## 5. Dominio: Reproducao

### 5.1 Reproducao
**Registro de coberturas/inseminacoes**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| matriz_id | UUID | FK -> Animal (vaca) |
| reprodutor_id | UUID | FK -> Animal (touro, nullable) |
| protocolo_id | UUID | FK -> Protocolo_IATF (nullable) |
| responsavel_id | UUID | FK -> User |
| data_cobertura | DATE | |
| tipo | ENUM | MONTA_NATURAL, IATF, IA_CONVENCIONAL, TE |
| semen_touro | VARCHAR(100) | Nome do touro (se IA) |
| central_semen | VARCHAR(100) | Central de semen |
| partida_semen | VARCHAR(50) | Lote do semen |
| data_diagnostico | DATE | |
| resultado_diagnostico | ENUM | PRENHE, VAZIA, PENDENTE |
| data_parto_prevista | DATE | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### 5.2 Nascimento
**Registro de partos**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| cria_id | UUID | FK -> Animal (bezerro) |
| matriz_id | UUID | FK -> Animal (vaca) |
| reproducao_id | UUID | FK -> Reproducao |
| responsavel_id | UUID | FK -> User |
| data_nascimento | DATE | |
| hora_nascimento | TIME | |
| tipo_parto | ENUM | NORMAL, DISTOCICO, CESARIANA |
| apresentacao | ENUM | ANTERIOR, POSTERIOR |
| assistencia | ENUM | SEM_ASSISTENCIA, LEVE, MECANICA, VETERINARIA |
| peso_nascimento_kg | DECIMAL(6,2) | |
| sexo | ENUM | MACHO, FEMEA |
| vigor_score | INTEGER | 1-3 |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 5.3 Protocolo_IATF
**Protocolos de inseminacao em tempo fixo**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| organization_id | UUID | FK -> Organization |
| nome | VARCHAR(200) | Ex: "Ovsynch", "Co-Synch" |
| descricao | TEXT | |
| dia_0_produto | VARCHAR(200) | Dispositivo + BE |
| dia_8_produto | VARCHAR(200) | PGF2a + EC |
| dia_9_produto | VARCHAR(200) | GnRH |
| dia_10_produto | VARCHAR(200) | IA |
| custo_estimado | DECIMAL(10,2) | |
| taxa_prenhez_media | DECIMAL(5,2) | % historico |
| status | ENUM | ATIVO, INATIVO |
| created_at | TIMESTAMP | |

### 5.4 Estacao_Monta
**Periodo reprodutivo**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| fazenda_id | UUID | FK -> Fazenda |
| nome | VARCHAR(100) | |
| ano | INTEGER | |
| data_inicio | DATE | |
| data_fim | DATE | |
| tipo | ENUM | MONTA_NATURAL, IATF, MISTA |
| touros_quantidade | INTEGER | |
| matrizes_quantidade | INTEGER | |
| relacao_touro_vaca | VARCHAR(10) | Ex: "1:25" |
| taxa_prenhez | DECIMAL(5,2) | % final |
| status | ENUM | PLANEJADA, EM_ANDAMENTO, ENCERRADA |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

---

## 6. Dominio: Comercial

### 6.1 Compra_Animal
**Aquisicao de animais**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| fornecedor_id | UUID | FK -> Fornecedor |
| nota_fiscal_id | UUID | FK -> Nota_Fiscal |
| responsavel_id | UUID | FK -> User |
| data_compra | DATE | |
| quantidade | INTEGER | |
| peso_total_kg | DECIMAL(10,2) | |
| peso_medio_kg | DECIMAL(8,2) | |
| valor_arroba | DECIMAL(10,2) | |
| valor_unitario | DECIMAL(10,2) | |
| valor_total | DECIMAL(15,2) | |
| frete | DECIMAL(10,2) | |
| gta_numero | VARCHAR(50) | Guia de Transito Animal |
| origem_fazenda | VARCHAR(200) | |
| origem_cidade | VARCHAR(100) | |
| origem_uf | VARCHAR(2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 6.2 Venda_Animal
**Venda de animais**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| comprador_id | UUID | FK -> Destino |
| nota_fiscal_id | UUID | FK -> Nota_Fiscal |
| responsavel_id | UUID | FK -> User |
| data_venda | DATE | |
| quantidade | INTEGER | |
| peso_total_kg | DECIMAL(10,2) | |
| peso_medio_kg | DECIMAL(8,2) | |
| rendimento_carcaca | DECIMAL(5,2) | % estimado |
| valor_arroba | DECIMAL(10,2) | |
| valor_unitario | DECIMAL(10,2) | |
| valor_total | DECIMAL(15,2) | |
| tipo_venda | ENUM | FRIGORIFICO, FAZENDA, LEILAO, EXPORTACAO |
| gta_numero | VARCHAR(50) | |
| destino_fazenda | VARCHAR(200) | |
| destino_cidade | VARCHAR(100) | |
| destino_uf | VARCHAR(2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 6.3 Abate
**Informacoes de abate e carcaca**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| animal_id | UUID | FK -> Animal |
| venda_id | UUID | FK -> Venda_Animal |
| frigorifico_id | UUID | FK -> Frigorifico |
| data_abate | DATE | |
| peso_vivo_kg | DECIMAL(8,2) | |
| peso_carcaca_kg | DECIMAL(8,2) | |
| rendimento_percent | DECIMAL(5,2) | |
| classificacao_carcaca | VARCHAR(50) | Ex: "B", "R", "A" |
| acabamento | INTEGER | 1-5 (gordura) |
| conformacao | VARCHAR(10) | C, SC, S, E |
| maturidade | VARCHAR(10) | D0, D2, D4, D6, D8 |
| valor_arroba_carcaca | DECIMAL(10,2) | |
| valor_total | DECIMAL(15,2) | |
| bonificacoes | DECIMAL(10,2) | |
| descontos | DECIMAL(10,2) | |
| observacoes | TEXT | |
| created_at | TIMESTAMP | |

### 6.4 Frigorifico
**Cadastro de frigorificos**

| Campo | Tipo | Descricao |
|-------|------|-----------|
| id | UUID | PK |
| organization_id | UUID | FK -> Organization |
| razao_social | VARCHAR(200) | |
| nome_fantasia | VARCHAR(200) | |
| cnpj | VARCHAR(18) | |
| sif | VARCHAR(20) | Servico de Inspecao Federal |
| endereco | TEXT | |
| cidade | VARCHAR(100) | |
| estado | VARCHAR(2) | |
| telefone | VARCHAR(20) | |
| email | VARCHAR(255) | |
| contato | VARCHAR(100) | |
| status | ENUM | ATIVO, INATIVO |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

---

## 7. Integracao com SOAL

### Entidades Compartilhadas
O modulo de Pecuaria reutiliza entidades do SOAL:

| Entidade SOAL | Uso na Pecuaria |
|---------------|-----------------|
| Organization | Multi-tenant |
| User | Responsaveis |
| Fazenda | Localizacao dos rebanhos |
| Fornecedor | Compra de animais |
| Destino | Venda de animais |
| Nota_Fiscal | Documentacao fiscal |
| Safra | Periodo para custos |

### Conectores Especificos (Gold Layer)

| Conector | Origem | Destino | Regra |
|----------|--------|---------|-------|
| Animal_Custo | Animal | Custo_Producao | Custos por cabeca |
| Lote_Pasto | Lote | Piquete | Ocupacao de pasto |
| Reprodutor_Producao | Animal | Nascimento | Metricas de touro |

---

## 8. Metricas e KPIs

### Indicadores Zootecnicos
- **GMD** (Ganho Medio Diario): Pesagem
- **Taxa de Prenhez**: Reproducao
- **Taxa de Desmame**: Nascimento
- **Mortalidade**: Morte
- **Lotacao (UA/ha)**: Piquete + Lote

### Indicadores Economicos
- **Custo por @**: Custo_Producao / Pesagem
- **Margem por cabeca**: Venda - Custos
- **ROI Reproducao**: Valor crias / Custo IATF

---

## 9. Resumo de Entidades

| Dominio | Entidades | Total |
|---------|-----------|-------|
| Cadastros Base | Animal, Raca, Categoria_Animal, Lote | 4 |
| Estrutura Pasto | Pasto, Piquete, Movimentacao_Pasto, Avaliacao_Pasto | 4 |
| Manejo | Pesagem, Movimentacao_Animal, Apartacao, Morte | 4 |
| Sanidade | Evento_Sanitario, Protocolo_Sanitario, Calendario_Sanitario, Exame_Laboratorial | 4 |
| Reproducao | Reproducao, Nascimento, Protocolo_IATF, Estacao_Monta | 4 |
| Comercial | Compra_Animal, Venda_Animal, Abate, Frigorifico | 4 |
| **TOTAL** | | **24** |

---

*Documento gerado em 04/02/2026 - Complementa o mapeamento agricola do SOAL*
