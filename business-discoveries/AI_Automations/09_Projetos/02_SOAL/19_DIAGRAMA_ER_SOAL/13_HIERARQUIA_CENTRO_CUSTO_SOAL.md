# HIERARQUIA DE CENTRO DE CUSTO - SOAL

**Data:** 08/02/2026
**Versao:** 1.0
**Status:** Draft para Validacao
**Responsavel Validacao:** Claudio Kugler

---

## 1. Visao Geral

### 1.1 Conceito

O Centro de Custo e uma estrutura hierarquica que permite alocar, rastrear e analisar custos em diferentes niveis de detalhe. A hierarquia permite:

- **Drill-down**: Ver custos do nivel mais alto (Organizacao) ate o mais granular (Talhao)
- **Roll-up**: Consolidar custos dos niveis inferiores para os superiores
- **Comparacao**: Comparar custos entre fazendas, safras, culturas e talhoes
- **Orcamento**: Definir orcamentos em qualquer nivel

### 1.2 Estrutura de 6 Niveis

```
NIVEL 1: ORGANIZACAO (SOAL)
    │
    └── NIVEL 2: FAZENDA
            │
            ├── NIVEL 3A: SAFRA (producao agricola)
            │       │
            │       └── NIVEL 4: CULTURA
            │               │
            │               └── NIVEL 5: TALHAO
            │
            ├── NIVEL 3B: DEPARTAMENTO (apoio)
            │       │
            │       └── NIVEL 4: SUBDEPARTAMENTO
            │
            └── NIVEL 3C: PECUARIA
                    │
                    └── NIVEL 4: CATEGORIA ANIMAL
```

---

## 2. Codigo de Centro de Custo

### 2.1 Formato do Codigo

```
XX.YY.ZZZ.WW.NNN

Onde:
XX    = Organizacao (01-99)
YY    = Fazenda ou Area (01-99)
ZZZ   = Safra ou Departamento (001-999)
WW    = Cultura ou Subdepartamento (01-99)
NNN   = Talhao ou Detalhe (001-999)
```

### 2.2 Exemplos

| Codigo | Descricao |
|--------|-----------|
| 01 | SOAL (Organizacao) |
| 01.01 | Fazenda Santana do Iapo |
| 01.01.026 | Safra 2025/26 na Santana do Iapo |
| 01.01.026.01 | Soja - Safra 25/26 - Santana |
| 01.01.026.01.001 | Talhao Bonin - Soja - Safra 25/26 |

---

## 3. Hierarquia Completa SOAL

### 3.1 Arvore Visual

```
01 - SOAL (Organizacao)
│
├── 01.01 - FAZENDA SANTANA DO IAPO
│   │
│   ├── 01.01.025 - SAFRA 2024/25 (encerrada)
│   │   ├── 01.01.025.01 - Soja
│   │   │   ├── 01.01.025.01.001 - Talhao Bonin
│   │   │   ├── 01.01.025.01.002 - Talhao Sede
│   │   │   ├── 01.01.025.01.003 - Talhao Mangueira
│   │   │   └── ...
│   │   ├── 01.01.025.02 - Milho
│   │   ├── 01.01.025.03 - Feijao
│   │   └── 01.01.025.04 - Trigo
│   │
│   ├── 01.01.026 - SAFRA 2025/26 (ativa)
│   │   ├── 01.01.026.01 - Soja
│   │   │   ├── 01.01.026.01.001 - Talhao Bonin
│   │   │   ├── 01.01.026.01.002 - Talhao Sede
│   │   │   ├── 01.01.026.01.003 - Talhao Mangueira
│   │   │   ├── 01.01.026.01.004 - Talhao Capao
│   │   │   ├── 01.01.026.01.005 - Talhao Lagoa
│   │   │   └── 01.01.026.01.XXX - (outros talhoes)
│   │   │
│   │   ├── 01.01.026.02 - Milho
│   │   │   ├── 01.01.026.02.001 - Talhao Várzea
│   │   │   ├── 01.01.026.02.002 - Talhao Fundos
│   │   │   └── 01.01.026.02.XXX - (outros talhoes)
│   │   │
│   │   ├── 01.01.026.03 - Feijao
│   │   │   ├── 01.01.026.03.001 - Talhao Irrigado 1
│   │   │   ├── 01.01.026.03.002 - Talhao Irrigado 2
│   │   │   └── 01.01.026.03.XXX - (outros talhoes)
│   │   │
│   │   └── 01.01.026.04 - Trigo
│   │       ├── 01.01.026.04.001 - Talhao Cerrado
│   │       └── 01.01.026.04.XXX - (outros talhoes)
│   │
│   ├── 01.01.027 - SAFRA 2026/27 (planejamento)
│   │   └── (a definir)
│   │
│   ├── 01.01.800 - MECANIZACAO
│   │   ├── 01.01.800.01 - Tratores
│   │   │   ├── 01.01.800.01.001 - Trator John Deere 6175J
│   │   │   ├── 01.01.800.01.002 - Trator John Deere 6145J
│   │   │   ├── 01.01.800.01.003 - Trator John Deere 6110J
│   │   │   └── 01.01.800.01.004 - Trator New Holland
│   │   │
│   │   ├── 01.01.800.02 - Colheitadeiras
│   │   │   ├── 01.01.800.02.001 - Colheitadeira S680
│   │   │   └── 01.01.800.02.002 - Colheitadeira S670
│   │   │
│   │   ├── 01.01.800.03 - Pulverizadores
│   │   │   ├── 01.01.800.03.001 - Pulverizador Jacto
│   │   │   └── 01.01.800.03.002 - Pulverizador John Deere
│   │   │
│   │   ├── 01.01.800.04 - Implementos
│   │   │   ├── 01.01.800.04.001 - Plantadeira 24 linhas
│   │   │   ├── 01.01.800.04.002 - Grade Pesada
│   │   │   ├── 01.01.800.04.003 - Grade Niveladora
│   │   │   ├── 01.01.800.04.004 - Distribuidor Calcario
│   │   │   └── 01.01.800.04.005 - Subsolador
│   │   │
│   │   ├── 01.01.800.05 - Caminhoes
│   │   │   ├── 01.01.800.05.001 - Caminhao Graneleiro 1
│   │   │   ├── 01.01.800.05.002 - Caminhao Graneleiro 2
│   │   │   └── 01.01.800.05.003 - Caminhao Pipa
│   │   │
│   │   └── 01.01.800.06 - Drones
│   │       └── 01.01.800.06.001 - Drone Pulverizador DJI
│   │
│   ├── 01.01.810 - UBG (Unidade Beneficiamento Graos)
│   │   ├── 01.01.810.01 - Recepcao/Balanca
│   │   ├── 01.01.810.02 - Secagem
│   │   │   ├── 01.01.810.02.001 - Secador 1
│   │   │   └── 01.01.810.02.002 - Secador 2
│   │   ├── 01.01.810.03 - Armazenagem
│   │   │   ├── 01.01.810.03.001 - Silo 1 (convencional)
│   │   │   ├── 01.01.810.03.002 - Silo 2 (convencional)
│   │   │   ├── 01.01.810.03.003 - Silo 3 (convencional)
│   │   │   ├── 01.01.810.03.004 - Silo 4 (convencional)
│   │   │   ├── 01.01.810.03.005 - Silo 5 (convencional)
│   │   │   ├── 01.01.810.03.006 - Silo 6 (convencional)
│   │   │   ├── 01.01.810.03.007 - Silo 7 (convencional)
│   │   │   └── 01.01.810.03.008 - Silo 8 (sementes/madeira)
│   │   └── 01.01.810.04 - Beneficiamento
│   │
│   └── 01.01.820 - INFRAESTRUTURA
│       ├── 01.01.820.01 - Galpoes
│       ├── 01.01.820.02 - Oficina
│       ├── 01.01.820.03 - Tanque Combustivel
│       └── 01.01.820.04 - Sistema Irrigacao
│
├── 01.02 - FAZENDA SAO JOAO
│   │
│   ├── 01.02.026 - SAFRA 2025/26
│   │   ├── 01.02.026.01 - Soja
│   │   │   ├── 01.02.026.01.001 - Talhao A
│   │   │   ├── 01.02.026.01.002 - Talhao B
│   │   │   └── ...
│   │   ├── 01.02.026.02 - Milho
│   │   └── 01.02.026.03 - Feijao
│   │
│   ├── 01.02.800 - MECANIZACAO
│   │   └── (estrutura similar a Santana)
│   │
│   └── 01.02.820 - INFRAESTRUTURA
│       └── ...
│
├── 01.03 - FAZENDA [OUTRA] (se houver)
│   └── ...
│
├── 01.50 - PECUARIA
│   │
│   ├── 01.50.001 - BOVINOS CORTE
│   │   ├── 01.50.001.01 - Cria
│   │   │   ├── 01.50.001.01.001 - Matrizes
│   │   │   ├── 01.50.001.01.002 - Bezerros(as)
│   │   │   └── 01.50.001.01.003 - Touros
│   │   │
│   │   ├── 01.50.001.02 - Recria
│   │   │   ├── 01.50.001.02.001 - Novilhas
│   │   │   └── 01.50.001.02.002 - Garrotes
│   │   │
│   │   ├── 01.50.001.03 - Engorda
│   │   │   ├── 01.50.001.03.001 - Confinamento
│   │   │   └── 01.50.001.03.002 - Pasto
│   │   │
│   │   └── 01.50.001.04 - Reproducao
│   │       ├── 01.50.001.04.001 - IATF
│   │       └── 01.50.001.04.002 - Monta Natural
│   │
│   ├── 01.50.100 - PASTOS
│   │   ├── 01.50.100.01 - Pasto 1 - Sede
│   │   ├── 01.50.100.02 - Pasto 2 - Lagoa
│   │   ├── 01.50.100.03 - Pasto 3 - Fundos
│   │   └── ...
│   │
│   └── 01.50.200 - INSTALACOES PECUARIA
│       ├── 01.50.200.01 - Curral
│       ├── 01.50.200.02 - Tronco/Brete
│       └── 01.50.200.03 - Balanca Gado
│
├── 01.90 - ADMINISTRATIVO
│   │
│   ├── 01.90.001 - ESCRITORIO
│   │   ├── 01.90.001.01 - Pessoal Administrativo
│   │   ├── 01.90.001.02 - Material de Escritorio
│   │   ├── 01.90.001.03 - Telefone/Internet
│   │   └── 01.90.001.04 - Energia
│   │
│   ├── 01.90.002 - RECURSOS HUMANOS
│   │   ├── 01.90.002.01 - Folha de Pagamento
│   │   ├── 01.90.002.02 - Encargos Sociais
│   │   ├── 01.90.002.03 - Beneficios
│   │   └── 01.90.002.04 - Treinamentos
│   │
│   ├── 01.90.003 - CONTABILIDADE/FISCAL
│   │   ├── 01.90.003.01 - Honorarios Contabeis
│   │   ├── 01.90.003.02 - Impostos
│   │   └── 01.90.003.03 - Taxas e Licencas
│   │
│   ├── 01.90.004 - JURIDICO
│   │   ├── 01.90.004.01 - Honorarios Advocaticios
│   │   └── 01.90.004.02 - Custas Processuais
│   │
│   ├── 01.90.005 - SEGUROS
│   │   ├── 01.90.005.01 - Seguro Agricola
│   │   ├── 01.90.005.02 - Seguro Maquinas
│   │   ├── 01.90.005.03 - Seguro Predial
│   │   └── 01.90.005.04 - Seguro Gado
│   │
│   └── 01.90.006 - TECNOLOGIA
│       ├── 01.90.006.01 - Software/Licencas
│       ├── 01.90.006.02 - Equipamentos TI
│       └── 01.90.006.03 - Consultoria TI
│
└── 01.95 - FINANCEIRO
    │
    ├── 01.95.001 - CUSTOS FINANCEIROS
    │   ├── 01.95.001.01 - Juros Emprestimos
    │   ├── 01.95.001.02 - Tarifas Bancarias
    │   └── 01.95.001.03 - IOF
    │
    ├── 01.95.002 - ARRENDAMENTOS
    │   ├── 01.95.002.01 - Arrendamento Fazenda X
    │   ├── 01.95.002.02 - Arrendamento Fazenda Y
    │   └── ...
    │
    └── 01.95.003 - DEPRECIACAO
        ├── 01.95.003.01 - Depreciacao Maquinas
        ├── 01.95.003.02 - Depreciacao Edificacoes
        └── 01.95.003.03 - Depreciacao Benfeitorias
```

---

## 4. Tabela Completa de Centros de Custo

### 4.1 Nivel 1 - Organizacao

| Codigo | Nome | Tipo | Permite Lancamento |
|--------|------|------|-------------------|
| 01 | SOAL | organizacao | Nao |

### 4.2 Nivel 2 - Fazendas e Areas

| Codigo | Nome | Tipo | Parent | Permite Lancamento |
|--------|------|------|--------|-------------------|
| 01.01 | Fazenda Santana do Iapo | fazenda | 01 | Nao |
| 01.02 | Fazenda Sao Joao | fazenda | 01 | Nao |
| 01.50 | Pecuaria | departamento | 01 | Nao |
| 01.90 | Administrativo | departamento | 01 | Nao |
| 01.95 | Financeiro | departamento | 01 | Nao |

### 4.3 Nivel 3 - Safras e Departamentos

| Codigo | Nome | Tipo | Parent | Permite Lancamento |
|--------|------|------|--------|-------------------|
| 01.01.025 | Safra 2024/25 | safra | 01.01 | Nao |
| 01.01.026 | Safra 2025/26 | safra | 01.01 | Nao |
| 01.01.027 | Safra 2026/27 | safra | 01.01 | Nao |
| 01.01.800 | Mecanizacao | departamento | 01.01 | Nao |
| 01.01.810 | UBG | departamento | 01.01 | Nao |
| 01.01.820 | Infraestrutura | departamento | 01.01 | Nao |
| 01.02.026 | Safra 2025/26 | safra | 01.02 | Nao |
| 01.02.800 | Mecanizacao | departamento | 01.02 | Nao |
| 01.50.001 | Bovinos Corte | categoria | 01.50 | Nao |
| 01.50.100 | Pastos | categoria | 01.50 | Nao |
| 01.50.200 | Instalacoes Pecuaria | categoria | 01.50 | Nao |
| 01.90.001 | Escritorio | subdepartamento | 01.90 | Nao |
| 01.90.002 | Recursos Humanos | subdepartamento | 01.90 | Nao |
| 01.90.003 | Contabilidade/Fiscal | subdepartamento | 01.90 | Nao |
| 01.90.004 | Juridico | subdepartamento | 01.90 | Nao |
| 01.90.005 | Seguros | subdepartamento | 01.90 | Nao |
| 01.90.006 | Tecnologia | subdepartamento | 01.90 | Nao |
| 01.95.001 | Custos Financeiros | subdepartamento | 01.95 | Nao |
| 01.95.002 | Arrendamentos | subdepartamento | 01.95 | Nao |
| 01.95.003 | Depreciacao | subdepartamento | 01.95 | Nao |

### 4.4 Nivel 4 - Culturas e Subdivisoes

| Codigo | Nome | Tipo | Parent | Permite Lancamento |
|--------|------|------|--------|-------------------|
| 01.01.026.01 | Soja | cultura | 01.01.026 | Sim |
| 01.01.026.02 | Milho | cultura | 01.01.026 | Sim |
| 01.01.026.03 | Feijao | cultura | 01.01.026 | Sim |
| 01.01.026.04 | Trigo | cultura | 01.01.026 | Sim |
| 01.01.800.01 | Tratores | equipamento | 01.01.800 | Sim |
| 01.01.800.02 | Colheitadeiras | equipamento | 01.01.800 | Sim |
| 01.01.800.03 | Pulverizadores | equipamento | 01.01.800 | Sim |
| 01.01.800.04 | Implementos | equipamento | 01.01.800 | Sim |
| 01.01.800.05 | Caminhoes | equipamento | 01.01.800 | Sim |
| 01.01.800.06 | Drones | equipamento | 01.01.800 | Sim |
| 01.01.810.01 | Recepcao/Balanca | operacao | 01.01.810 | Sim |
| 01.01.810.02 | Secagem | operacao | 01.01.810 | Sim |
| 01.01.810.03 | Armazenagem | operacao | 01.01.810 | Sim |
| 01.01.810.04 | Beneficiamento | operacao | 01.01.810 | Sim |
| 01.50.001.01 | Cria | categoria_animal | 01.50.001 | Sim |
| 01.50.001.02 | Recria | categoria_animal | 01.50.001 | Sim |
| 01.50.001.03 | Engorda | categoria_animal | 01.50.001 | Sim |
| 01.50.001.04 | Reproducao | categoria_animal | 01.50.001 | Sim |

### 4.5 Nivel 5 - Talhoes e Detalhes

| Codigo | Nome | Tipo | Parent | Area (ha) | Permite Lancamento |
|--------|------|------|--------|-----------|-------------------|
| 01.01.026.01.001 | Talhao Bonin | talhao | 01.01.026.01 | 85,5 | Sim |
| 01.01.026.01.002 | Talhao Sede | talhao | 01.01.026.01 | 120,0 | Sim |
| 01.01.026.01.003 | Talhao Mangueira | talhao | 01.01.026.01 | 45,2 | Sim |
| 01.01.026.01.004 | Talhao Capao | talhao | 01.01.026.01 | 72,8 | Sim |
| 01.01.026.01.005 | Talhao Lagoa | talhao | 01.01.026.01 | 98,3 | Sim |
| 01.01.026.02.001 | Talhao Varzea | talhao | 01.01.026.02 | 65,0 | Sim |
| 01.01.026.02.002 | Talhao Fundos | talhao | 01.01.026.02 | 55,5 | Sim |
| 01.01.026.03.001 | Talhao Irrigado 1 | talhao | 01.01.026.03 | 30,0 | Sim |
| 01.01.026.03.002 | Talhao Irrigado 2 | talhao | 01.01.026.03 | 25,0 | Sim |
| 01.01.800.01.001 | JD 6175J (Placa XXX) | maquina | 01.01.800.01 | - | Sim |
| 01.01.800.01.002 | JD 6145J (Placa YYY) | maquina | 01.01.800.01 | - | Sim |
| 01.01.810.03.001 | Silo 1 | silo | 01.01.810.03 | - | Sim |
| 01.01.810.03.002 | Silo 2 | silo | 01.01.810.03 | - | Sim |
| 01.01.810.03.008 | Silo 8 (sementes) | silo | 01.01.810.03 | - | Sim |

---

## 5. Tipos de Centro de Custo

### 5.1 Classificacao por Tipo

| Tipo | Descricao | Nivel Tipico | Permite Lancamento |
|------|-----------|--------------|-------------------|
| organizacao | Nivel raiz da empresa | 1 | Nao |
| fazenda | Unidade produtiva | 2 | Nao |
| safra | Ano agricola | 3 | Nao |
| cultura | Cultura plantada | 4 | Sim |
| talhao | Area especifica | 5 | Sim |
| departamento | Area de apoio | 2-3 | Nao |
| subdepartamento | Subdivisao de departamento | 4 | Nao |
| equipamento | Categoria de equipamento | 4 | Sim |
| maquina | Maquina especifica | 5 | Sim |
| operacao | Tipo de operacao | 4 | Sim |
| silo | Silo especifico | 5 | Sim |
| categoria_animal | Categoria de gado | 4 | Sim |

### 5.2 Classificacao por Natureza

| Natureza | Descricao | Exemplos |
|----------|-----------|----------|
| producao | Gera receita diretamente | Culturas, Talhoes, Pecuaria |
| apoio | Suporta a producao | Mecanizacao, UBG |
| administrativo | Gestao geral | Escritorio, RH, TI |
| financeiro | Custos financeiros | Juros, Arrendamentos |

---

## 6. Regras de Negocio

### 6.1 Regras de Lancamento

```
1. LANCAMENTOS DIRETOS
   - So podem ser feitos em centros que "Permite Lancamento = Sim"
   - Tipicamente niveis 4 e 5
   - Exemplo: Custo de semente vai para 01.01.026.01.001 (Talhao Bonin - Soja)

2. CONSOLIDACAO AUTOMATICA
   - Custos dos niveis inferiores sobem automaticamente
   - 01.01.026.01.001 → 01.01.026.01 → 01.01.026 → 01.01 → 01
   - Talhao → Cultura → Safra → Fazenda → Organizacao

3. RATEIO
   - Custos de niveis superiores podem ser rateados para inferiores
   - Diesel sem cultura definida → rateio por area
   - Custo administrativo → rateio por fazenda/safra
```

### 6.2 Regras de Rateio

| Custo | Metodo de Rateio | Base |
|-------|------------------|------|
| Diesel (sem cultura) | Proporcional | Area plantada por cultura |
| Mao de obra geral | Proporcional | Area plantada por cultura |
| Arrendamento | Direto | Talhoes arrendados |
| Administrativo | Proporcional | Receita ou area por fazenda |
| Depreciacao maquinas | Proporcional | Horas trabalhadas por cultura |
| Secagem | Direto | Cultura que passou pelo secador |

### 6.3 Exemplos de Alocacao

**Exemplo 1: Compra de Semente de Soja**
```
Destino: 01.01.026.01 (Soja - Safra 25/26 - Santana)
Tipo: Lancamento direto
Valor: R$ 150.000
Resultado: Aparece no custo de Soja e sobe para Safra, Fazenda, Org
```

**Exemplo 2: Abastecimento de Trator (cultura definida)**
```
Destino: 01.01.026.01.002 (Talhao Sede - Soja)
Tipo: Lancamento direto
Valor: R$ 2.500
Resultado: Custo vai para talhao especifico
```

**Exemplo 3: Abastecimento de Trator (cultura NAO definida)**
```
Destino: 01.01.800.01.001 (Trator JD 6175J)
Tipo: Rateio posterior
Valor: R$ 2.500
Rateio: Proporcional por area (Soja 60%, Milho 25%, Feijao 15%)
Resultado:
  - 01.01.026.01: R$ 1.500 (Soja)
  - 01.01.026.02: R$ 625 (Milho)
  - 01.01.026.03: R$ 375 (Feijao)
```

**Exemplo 4: Custo de Escritorio**
```
Destino: 01.90.001.01 (Pessoal Administrativo)
Tipo: Permanece no centro administrativo OU rateio
Valor: R$ 15.000/mes
Opcao A: Fica em 01.90 como custo fixo
Opcao B: Rateio por fazenda/safra baseado em receita
```

---

## 7. Integracao com Entidade CENTRO_CUSTO

### 7.1 Estrutura da Tabela

```sql
CREATE TABLE centro_custo (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id       UUID NOT NULL REFERENCES organizations(id),
    parent_id             UUID REFERENCES centro_custo(id),
    codigo                VARCHAR(20) NOT NULL UNIQUE,
    nome                  VARCHAR(100) NOT NULL,
    nivel                 INTEGER NOT NULL CHECK (nivel BETWEEN 1 AND 6),
    tipo                  VARCHAR(30) NOT NULL,
    natureza              VARCHAR(20) NOT NULL CHECK (natureza IN ('producao', 'apoio', 'administrativo', 'financeiro')),
    permite_lancamento    BOOLEAN DEFAULT false,
    orcamento_anual       DECIMAL(14,2),
    orcamento_mensal      DECIMAL(14,2),

    -- Referencias opcionais (vinculo com outras entidades)
    fazenda_id            UUID REFERENCES fazendas(id),
    safra_id              UUID REFERENCES safras(id),
    cultura_id            UUID REFERENCES culturas(id),
    talhao_id             UUID REFERENCES talhoes(id),
    maquina_id            UUID REFERENCES maquinas(id),
    silo_id               UUID REFERENCES silos(id),

    -- Controle
    ativo                 BOOLEAN DEFAULT true,
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index para busca hierarquica
CREATE INDEX idx_centro_custo_parent ON centro_custo(parent_id);
CREATE INDEX idx_centro_custo_codigo ON centro_custo(codigo);
CREATE INDEX idx_centro_custo_nivel ON centro_custo(nivel);
```

### 7.2 View para Hierarquia Completa

```sql
CREATE VIEW vw_centro_custo_hierarquia AS
WITH RECURSIVE hierarquia AS (
    -- Nivel raiz
    SELECT
        id,
        codigo,
        nome,
        nivel,
        tipo,
        parent_id,
        codigo as caminho,
        nome as caminho_nome,
        1 as profundidade
    FROM centro_custo
    WHERE parent_id IS NULL

    UNION ALL

    -- Niveis filhos
    SELECT
        cc.id,
        cc.codigo,
        cc.nome,
        cc.nivel,
        cc.tipo,
        cc.parent_id,
        h.caminho || ' > ' || cc.codigo,
        h.caminho_nome || ' > ' || cc.nome,
        h.profundidade + 1
    FROM centro_custo cc
    JOIN hierarquia h ON cc.parent_id = h.id
)
SELECT * FROM hierarquia
ORDER BY caminho;
```

### 7.3 Funcao para Calcular Custo Acumulado

```sql
CREATE FUNCTION fn_custo_acumulado(p_centro_custo_id UUID, p_data_inicio DATE, p_data_fim DATE)
RETURNS DECIMAL(14,2) AS $$
DECLARE
    v_total DECIMAL(14,2);
BEGIN
    WITH RECURSIVE descendentes AS (
        SELECT id FROM centro_custo WHERE id = p_centro_custo_id
        UNION ALL
        SELECT cc.id
        FROM centro_custo cc
        JOIN descendentes d ON cc.parent_id = d.id
    )
    SELECT COALESCE(SUM(co.valor_total), 0)
    INTO v_total
    FROM custo_operacao co
    WHERE co.centro_custo_id IN (SELECT id FROM descendentes)
      AND co.data_custo BETWEEN p_data_inicio AND p_data_fim;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;
```

---

## 8. Relatorios por Centro de Custo

### 8.1 Relatorio: Custo por Nivel

```
┌─────────────────────────────────────────────────────────────────────────────┐
│           RELATORIO DE CUSTOS POR NIVEL - SAFRA 2025/26                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ NIVEL 1: ORGANIZACAO                                                        │
│ └── 01 SOAL                                    TOTAL: R$ 12.500.000         │
│                                                                             │
│ NIVEL 2: FAZENDAS                                                           │
│ ├── 01.01 Santana do Iapo                              R$ 9.800.000 (78%)  │
│ └── 01.02 Sao Joao                                     R$ 2.700.000 (22%)  │
│                                                                             │
│ NIVEL 3: SAFRAS (Santana do Iapo)                                          │
│ └── 01.01.026 Safra 2025/26                            R$ 8.500.000        │
│     ├── 01.01.800 Mecanizacao                          R$ 1.100.000        │
│     └── 01.01.810 UBG                                  R$   200.000        │
│                                                                             │
│ NIVEL 4: CULTURAS (Safra 2025/26)                                          │
│ ├── 01.01.026.01 Soja                                  R$ 4.200.000 (49%)  │
│ ├── 01.01.026.02 Milho                                 R$ 2.100.000 (25%)  │
│ ├── 01.01.026.03 Feijao                                R$ 1.800.000 (21%)  │
│ └── 01.01.026.04 Trigo                                 R$   400.000 (5%)   │
│                                                                             │
│ NIVEL 5: TALHOES (Soja)                                                    │
│ ├── 01.01.026.01.001 Bonin      85,5 ha   R$ 445.000    R$ 5.205/ha       │
│ ├── 01.01.026.01.002 Sede      120,0 ha   R$ 624.000    R$ 5.200/ha       │
│ ├── 01.01.026.01.003 Mangueira  45,2 ha   R$ 235.000    R$ 5.199/ha       │
│ ├── 01.01.026.01.004 Capao      72,8 ha   R$ 379.000    R$ 5.206/ha       │
│ └── 01.01.026.01.005 Lagoa      98,3 ha   R$ 511.000    R$ 5.198/ha       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 8.2 Relatorio: Comparativo de Culturas

```
┌─────────────────────────────────────────────────────────────────────────────┐
│         COMPARATIVO DE CULTURAS - SAFRA 2025/26 - SANTANA DO IAPO           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ CULTURA      │ AREA (ha) │ CUSTO TOTAL  │ CUSTO/HA  │ RECEITA/HA │ MARGEM  │
│ ─────────────┼───────────┼──────────────┼───────────┼────────────┼─────────│
│ Soja         │   421,8   │ R$ 2.194.000 │ R$ 5.202  │ R$ 7.500   │ +44,2%  │
│ Milho        │   185,5   │ R$   760.000 │ R$ 4.098  │ R$ 5.440   │ +32,7%  │
│ Feijao       │    85,0   │ R$   663.000 │ R$ 7.800  │ R$ 11.200  │ +43,6%  │
│ Trigo        │   120,0   │ R$   420.000 │ R$ 3.500  │ R$ 3.300   │ -5,7%   │
│ ─────────────┼───────────┼──────────────┼───────────┼────────────┼─────────│
│ TOTAL        │   812,3   │ R$ 4.037.000 │ R$ 4.970  │ R$ 6.860   │ +38,0%  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 9. Proximos Passos

### 9.1 Validacoes Necessarias

| # | Item | Responsavel | Status |
|---|------|-------------|--------|
| 1 | Lista completa de fazendas da SOAL | Claudio | [ ] |
| 2 | Lista completa de talhoes por fazenda | Tiago | [ ] |
| 3 | Estrutura atual no AgriWin (se houver) | Valentina | [ ] |
| 4 | Definir codigos oficiais dos centros | Claudio | [ ] |
| 5 | Validar categorias de pecuaria | Claudio | [ ] |
| 6 | Definir regras de rateio | Claudio | [ ] |

### 9.2 TBCs

1. [ ] Quantas fazendas existem alem de Santana do Iapo e Sao Joao?
2. [ ] Quais sao todos os talhoes por fazenda?
3. [ ] A numeracao de safra segue qual padrao? (025 = 2024/25?)
4. [ ] Existem maquinas compartilhadas entre fazendas?
5. [ ] Como e a estrutura atual de categorias no AgriWin?
6. [ ] Pecuaria esta em qual fazenda? Ou e separada?

---

## 10. Anexo: Tabela DE-PARA AgriWin

*A ser preenchido apos conversa com Valentina*

| Codigo AgriWin | Descricao AgriWin | Codigo SOAL | Descricao SOAL |
|----------------|-------------------|-------------|----------------|
| | | | |
| | | | |
| | | | |

---

*Documento gerado em 08/02/2026 - DeepWork AI Flows*
*Para validacao com Claudio Kugler e equipe*
