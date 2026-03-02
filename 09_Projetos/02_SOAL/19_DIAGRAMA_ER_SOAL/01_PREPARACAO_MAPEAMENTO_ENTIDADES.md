# Preparação para Mapeamento de Entidades - Projeto SOAL

**Objetivo:** Guia completo para coleta de dados na visita física e construção do Diagrama de Entidade-Relacionamento (ER) da plataforma DeepWork para a SOAL.

**Autor:** Rodrigo Kugler
**Data:** 03/02/2026
**Status:** Em preparação para visita de campo

---

## 1. CONTEXTO E IMPORTÂNCIA

### Por que o Diagrama ER é o "Ouro da Plataforma"

O Diagrama de Entidade-Relacionamento é a **fundação técnica** de toda a aplicação. Sem ele:
- Não é possível modelar o banco de dados corretamente
- Não é possível criar APIs consistentes
- Os dashboards não terão dados estruturados para consumir
- As integrações não saberão como conectar os dados

**Citação do João (03/02/2026):**
> "A plataforma e o front depende muito disso. Esse daqui que a gente precisa, com isso daqui é o ouro da nossa plataforma."

### Entregável Esperado

Ao final da visita física e do trabalho de mapeamento, você deve entregar:

1. **Lista completa de entidades** (tabelas do banco)
2. **Atributos de cada entidade** (colunas/campos)
3. **Relacionamentos entre entidades** (1:1, 1:N, N:N)
4. **Chaves de conexão** (como os dados se ligam)
5. **Classificação de entidades** (fortes vs. fracas)

---

## 2. MAPA DE DOMÍNIOS DO NEGÓCIO

### Visão Geral dos Domínios

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PLATAFORMA DEEPWORK SOAL                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │   USUÁRIOS   │  │  PERMISSÕES  │  │    ALERTAS   │              │
│  │  & ACESSOS   │  │   & ROLES    │  │              │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    OPERAÇÕES AGRÍCOLAS                       │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │  SECADOR   │  │   SILOS    │  │  BALANÇA   │             │   │
│  │  │  (Josmar)  │  │  (Leomar)  │  │            │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  │                                                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │  TALHÕES   │  │  CULTURAS  │  │  FAZENDAS  │             │   │
│  │  │            │  │            │  │            │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                       MAQUINÁRIO                             │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │  MÁQUINAS  │  │ABASTECIMENTO│ │ MANUTENÇÃO │             │   │
│  │  │ (Jn Deere) │  │  (Vestro)  │  │            │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      FINANCEIRO                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │   CUSTOS   │  │NOTAS FISCAIS│ │   VENDAS   │             │   │
│  │  │            │  │ (Valentina)│  │            │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  │                                                              │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │  INSUMOS   │  │CONTAS PAGAR│  │CONTAS RECEBER│           │   │
│  │  │(Castrolanda)│ │            │  │            │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     PECUÁRIA (Futuro)                        │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │   REBANHO  │  │  MANEJO    │  │   VENDAS   │             │   │
│  │  │            │  │            │  │   GADO     │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      INTEGRAÇÕES                             │   │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐             │   │
│  │  │ JOHN DEERE │  │   VESTRO   │  │CASTROLANDA │             │   │
│  │  │    API     │  │    API     │  │    API     │             │   │
│  │  └────────────┘  └────────────┘  └────────────┘             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. ENTIDADES IDENTIFICADAS - DETALHAMENTO

### 3.1 DOMÍNIO: Usuários e Acessos

#### Entidade: ORGANIZACOES
**Descrição:** Representa uma fazenda/empresa cliente da plataforma
**Fonte de dados:** Cadastro manual

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| nome | String | Sim | Nome da organização (ex: "SOAL") |
| cnpj | String | Não | CNPJ da empresa |
| endereco | String | Não | Endereço completo |
| area_total_hectares | Decimal | Não | Área total da operação |
| created_at | DateTime | Sim | Data de criação |
| updated_at | DateTime | Sim | Última atualização |

**Relacionamentos:**
- 1 Organização → N Fazendas
- 1 Organização → N Usuários
- 1 Organização → N Áreas (departamentos)

---

#### Entidade: USUARIOS
**Descrição:** Pessoas que acessam a plataforma
**Fonte de dados:** Cadastro manual

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização a que pertence |
| nome | String | Sim | Nome completo |
| email | String | Sim | E-mail (login) |
| senha_hash | String | Sim | Senha criptografada |
| telefone | String | Não | Telefone/WhatsApp |
| tipo | Enum | Sim | admin, gestor, operador |
| ativo | Boolean | Sim | Se está ativo |
| created_at | DateTime | Sim | Data de criação |
| ultimo_acesso | DateTime | Não | Último login |

**Relacionamentos:**
- N Usuários → 1 Organização
- N Usuários → N Áreas (departamentos)
- 1 Usuário → N Sessões
- 1 Usuário → 1 Perfil

**Entidade FORTE** - Contém dados sensíveis (email, senha)

---

#### Entidade: PERFIS
**Descrição:** Informações adicionais do usuário
**Fonte de dados:** Cadastro manual

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| usuario_id | UUID (FK) | Sim | Usuário associado |
| foto_url | String | Não | URL da foto de perfil |
| cargo | String | Não | Cargo na empresa |
| preferencias_json | JSON | Não | Preferências de interface |

**Relacionamentos:**
- 1 Perfil → 1 Usuário (1:1)

---

#### Entidade: AREAS
**Descrição:** Departamentos/setores da organização
**Fonte de dados:** Cadastro manual

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| nome | String | Sim | Nome da área (Administrativo, Campo, etc.) |
| descricao | String | Não | Descrição |

**Relacionamentos:**
- N Áreas → 1 Organização
- N Áreas → N Usuários
- 1 Área → N Roles (permissões padrão)

---

#### Entidade: ROLES (Papéis/Permissões)
**Descrição:** Permissões de acesso na plataforma
**Fonte de dados:** Configuração do sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| nome | String | Sim | Nome da permissão |
| codigo | String | Sim | Código único (ver_dashboards_financeiros) |
| descricao | String | Não | Descrição |

**Permissões a mapear:**
- `ver_dashboard_custos`
- `ver_dashboard_estoque`
- `ver_dashboard_maquinario`
- `editar_formularios`
- `criar_alertas`
- `gerenciar_usuarios`
- `ver_relatorios_financeiros`
- `exportar_dados`

---

#### Entidade: USUARIO_ROLES
**Descrição:** Tabela de junção usuário-permissões
**Tipo:** Tabela associativa (N:N)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| usuario_id | UUID (FK) | Sim | Usuário |
| role_id | UUID (FK) | Sim | Permissão |
| granted_at | DateTime | Sim | Quando foi concedida |
| granted_by | UUID (FK) | Não | Quem concedeu |

---

### 3.2 DOMÍNIO: Estrutura da Fazenda

#### Entidade: FAZENDAS
**Descrição:** Propriedades/unidades da organização
**Fonte de dados:** Cadastro manual + Claudio

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| nome | String | Sim | Nome da fazenda (Santana do Iapó, etc.) |
| area_hectares | Decimal | Não | Área total |
| localizacao | String | Não | Município/região |
| latitude | Decimal | Não | Coordenada |
| longitude | Decimal | Não | Coordenada |
| ativa | Boolean | Sim | Se está em operação |

**Perguntas para a visita:**
- Quantas fazendas/propriedades existem?
- Quais os nomes de cada uma?
- Qual a área de cada uma?

---

#### Entidade: TALHOES
**Descrição:** Subdivisões das fazendas para gestão agrícola
**Fonte de dados:** Cadastro manual + John Deere

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| fazenda_id | UUID (FK) | Sim | Fazenda |
| nome | String | Sim | Nome do talhão |
| nome_normalizado | String | Sim | Nome padronizado (DE-PARA) |
| area_hectares | Decimal | Não | Área do talhão |
| tipo_solo | String | Não | Característica do solo |
| observacoes | String | Não | Notas |

**IMPORTANTE - Tabela DE-PARA:**
O mesmo talhão pode aparecer como "Bonim", "Boninho", "Bonin lado esquerdo".
Precisamos criar um mapeamento de normalização.

| Nome Original (John Deere) | Nome Normalizado |
|---------------------------|------------------|
| Bonim | Bonin |
| Boninho | Bonin |
| Bonin lado esquerdo | Bonin |
| ... | ... |

**Perguntas para a visita:**
- Quais são todos os talhões?
- Como eles aparecem no John Deere?
- Qual a área de cada um?

---

#### Entidade: SILOS
**Descrição:** Unidades de armazenamento de grãos
**Fonte de dados:** Cadastro manual + Software Leomar

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| fazenda_id | UUID (FK) | Sim | Fazenda |
| nome | String | Sim | Identificação (Silo 1, Silo A, etc.) |
| capacidade_toneladas | Decimal | Sim | Capacidade máxima |
| tipo | Enum | Não | graneleiro, bag, armazem |
| tem_aeracao | Boolean | Não | Se tem sistema de aeração |
| tem_termometria | Boolean | Não | Se tem sensores de temperatura |

**Perguntas para a visita:**
- Quantos silos existem? (Claudio mencionou 7-8)
- Qual a capacidade de cada um?
- Quais têm aeração/termometria?
- Como são identificados?

---

#### Entidade: CULTURAS
**Descrição:** Tipos de culturas plantadas
**Fonte de dados:** Cadastro fixo + Claudio

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| nome | String | Sim | Nome da cultura |
| codigo | String | Sim | Código curto (SOJA, MILHO, FEIJAO) |
| ciclo_dias | Integer | Não | Duração média do ciclo |
| epoca_plantio | String | Não | Época típica |

**Culturas conhecidas:**
- Soja (1.800 ha)
- Milho (373 ha)
- Feijão (177 ha)
- Aveia
- Trigo

---

### 3.3 DOMÍNIO: Secador e Recepção de Grãos

#### Entidade: ENTRADAS_GRAOS
**Descrição:** Registro de entrada de cargas no secador
**Fonte de dados:** Formulário Josmar (tablet) - SUBSTITUIR CADERNO

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| data_hora | DateTime | Sim | Momento da entrada |
| operador_id | UUID (FK) | Sim | Quem registrou (Josmar) |
| placa_caminhao | String | Não | Placa do veículo |
| motorista | String | Não | Nome do motorista |
| cultura_id | UUID (FK) | Sim | Tipo de grão |
| talhao_origem_id | UUID (FK) | Não | De onde veio |
| fazenda_origem_id | UUID (FK) | Sim | Fazenda de origem |
| peso_bruto_kg | Decimal | Sim | Peso na balança |
| umidade_percentual | Decimal | Sim | % de umidade medida |
| impureza_percentual | Decimal | Sim | % de sujeira/mato |
| peso_liquido_estimado_kg | Decimal | Sim | Calculado automaticamente |
| silo_destino_id | UUID (FK) | Sim | Para qual silo vai |
| is_semente_propria | Boolean | Sim | Se vai para beneficiamento |
| quantidade_semente_kg | Decimal | Não | Se for semente, quanto |
| observacoes | String | Não | Notas adicionais |

**Cálculo automático:**
```
peso_liquido_estimado = peso_bruto - (peso_bruto * umidade%) - (peso_bruto * impureza%)
```

**Entidade FORTE** - Core do negócio, dados de produção

**Perguntas para a visita (Josmar):**
- Quais campos você anota no caderno?
- Em que ordem você anota?
- Como você identifica o talhão de origem?
- Como decide para qual silo vai?
- Qual % de desconto você aplica normalmente?

---

#### Entidade: SAIDAS_GRAOS
**Descrição:** Registro de saída/venda de grãos
**Fonte de dados:** Formulário (tablet ou Vanessa)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| data_hora | DateTime | Sim | Momento da saída |
| operador_id | UUID (FK) | Sim | Quem registrou |
| silo_origem_id | UUID (FK) | Sim | De qual silo saiu |
| cultura_id | UUID (FK) | Sim | Tipo de grão |
| peso_kg | Decimal | Sim | Peso da carga |
| destino | String | Sim | Para onde foi |
| tipo_saida | Enum | Sim | venda, transferencia, consumo_interno |
| nota_fiscal | String | Não | Número da NF |
| preco_por_saca | Decimal | Não | Se for venda |
| comprador | String | Não | Nome do comprador |

---

#### Entidade: ESTOQUE_SILOS
**Descrição:** Posição atual de estoque por silo
**Fonte de dados:** Calculado (entradas - saídas) + Software Leomar

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| silo_id | UUID (FK) | Sim | Qual silo |
| cultura_id | UUID (FK) | Sim | Tipo de grão |
| data_posicao | Date | Sim | Data da posição |
| quantidade_virtual_kg | Decimal | Sim | Calculado pelo sistema |
| quantidade_real_kg | Decimal | Não | Do software Leomar |
| umidade_media | Decimal | Não | Umidade atual |
| temperatura_media | Decimal | Não | Se tiver termometria |
| ultima_atualizacao | DateTime | Sim | Quando foi atualizado |

**Perguntas para a visita (Leomar):**
- Como funciona o software de controle dos silos?
- Quais dados ele mostra?
- Tem exportação de dados?
- Tem API?

---

### 3.4 DOMÍNIO: Maquinário

#### Entidade: MAQUINAS
**Descrição:** Cadastro de tratores, colheitadeiras, etc.
**Fonte de dados:** Planilha Tiago + John Deere

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| tipo | Enum | Sim | trator, colheitadeira, pulverizador, etc. |
| marca | String | Sim | John Deere, Case, etc. |
| modelo | String | Sim | Modelo específico |
| ano | Integer | Não | Ano de fabricação |
| potencia_cv | Integer | Não | Potência em CV |
| numero_serie | String | Não | Número de série |
| tag_vestro | String | Não | Identificação no Vestro |
| tag_john_deere | String | Não | ID no Operations Center |
| capacidade_tanque_litros | Decimal | Não | Capacidade do tanque |
| horimetro_atual | Decimal | Não | Última leitura |
| status | Enum | Sim | ativa, manutencao, inativa |

**Perguntas para a visita (Tiago):**
- Quantas máquinas existem?
- Como são identificadas?
- Quais têm telemetria John Deere?
- Quais usam Vestro?

---

#### Entidade: ABASTECIMENTOS
**Descrição:** Registro de abastecimento de combustível
**Fonte de dados:** Vestro API + Formulário

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| data_hora | DateTime | Sim | Momento do abastecimento |
| maquina_id | UUID (FK) | Sim | Qual máquina |
| operador_id | UUID (FK) | Não | Quem abasteceu |
| litros | Decimal | Sim | Quantidade abastecida |
| horimetro_leitura | Decimal | Sim | Leitura do horímetro |
| horimetro_anterior | Decimal | Não | Leitura anterior |
| consumo_calculado | Decimal | Não | L/hora calculado |
| fazenda_id | UUID (FK) | Não | Em qual fazenda |
| cultura_id | UUID (FK) | Não | Para qual cultura (novo Vestro) |
| tanque_origem | String | Não | De qual tanque saiu |
| fonte | Enum | Sim | vestro, manual |

**Validação automática (regra do Tiago):**
Se `consumo_calculado` estiver fora do padrão histórico da máquina, gerar alerta.

---

#### Entidade: OPERACOES_CAMPO
**Descrição:** Operações realizadas pelas máquinas
**Fonte de dados:** John Deere Operations Center API

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| maquina_id | UUID (FK) | Sim | Qual máquina |
| operador_id | UUID (FK) | Não | Quem operou |
| talhao_id | UUID (FK) | Não | Onde operou |
| cultura_id | UUID (FK) | Não | Qual cultura |
| tipo_operacao | Enum | Sim | plantio, pulverizacao, colheita, etc. |
| data_inicio | DateTime | Sim | Início da operação |
| data_fim | DateTime | Não | Fim da operação |
| area_trabalhada_ha | Decimal | Não | Área coberta |
| velocidade_media | Decimal | Não | km/h |
| combustivel_consumido | Decimal | Não | Litros |
| dados_json | JSON | Não | Dados extras da telemetria |

---

#### Entidade: MANUTENCOES
**Descrição:** Registro de manutenções de máquinas
**Fonte de dados:** Planilha Tiago + Formulário

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| maquina_id | UUID (FK) | Sim | Qual máquina |
| data | Date | Sim | Data da manutenção |
| tipo | Enum | Sim | preventiva, corretiva, troca_oleo, etc. |
| descricao | String | Sim | O que foi feito |
| horimetro | Decimal | Não | Horímetro no momento |
| custo | Decimal | Não | Valor gasto |
| pecas_utilizadas | String | Não | Lista de peças |
| responsavel | String | Não | Quem executou |

---

### 3.5 DOMÍNIO: Financeiro

#### Entidade: SAFRAS
**Descrição:** Ciclos de produção agrícola
**Fonte de dados:** Cadastro manual

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| nome | String | Sim | Ex: "Safra 2025/26" |
| data_inicio | Date | Sim | Início do ciclo |
| data_fim | Date | Não | Fim do ciclo |
| ativa | Boolean | Sim | Se é a safra atual |

---

#### Entidade: CUSTOS
**Descrição:** Registro de custos da operação
**Fonte de dados:** Notas fiscais + Castrolanda + Formulários

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| safra_id | UUID (FK) | Sim | Qual safra |
| fazenda_id | UUID (FK) | Não | Qual fazenda |
| cultura_id | UUID (FK) | Não | Qual cultura |
| categoria | Enum | Sim | insumos, diesel, mao_obra, manutencao, etc. |
| subcategoria | String | Não | Detalhamento |
| descricao | String | Sim | Descrição do custo |
| valor | Decimal | Sim | Valor em R$ |
| data | Date | Sim | Data do custo |
| nota_fiscal | String | Não | Número da NF |
| fornecedor | String | Não | De quem comprou |
| rateio_tipo | Enum | Não | por_area, por_cultura, direto |
| fonte | Enum | Sim | castrolanda, manual, vestro |

**Categorias de custo:**
- Insumos (sementes, fertilizantes, defensivos)
- Diesel
- Mão de obra
- Manutenção de máquinas
- Arrendamento
- Energia
- Outros

---

#### Entidade: INSUMOS_CASTROLANDA
**Descrição:** Compras de insumos via Castrolanda
**Fonte de dados:** API Castrolanda (a validar)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| data_compra | Date | Sim | Data da compra |
| nota_fiscal | String | Sim | Número da NF |
| produto | String | Sim | Nome do produto |
| quantidade | Decimal | Sim | Quantidade |
| unidade | String | Sim | kg, L, unidade |
| valor_unitario | Decimal | Sim | Preço unitário |
| valor_total | Decimal | Sim | Valor total |
| cultura_destino_id | UUID (FK) | Não | Para qual cultura |
| safra_id | UUID (FK) | Sim | Qual safra |

---

#### Entidade: NOTAS_FISCAIS
**Descrição:** Registro de notas fiscais de entrada
**Fonte de dados:** Formulário Valentina + XML

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| numero | String | Sim | Número da NF |
| serie | String | Não | Série |
| data_emissao | Date | Sim | Data de emissão |
| fornecedor_cnpj | String | Sim | CNPJ do fornecedor |
| fornecedor_nome | String | Sim | Nome do fornecedor |
| valor_total | Decimal | Sim | Valor total |
| chave_acesso | String | Não | Chave de acesso NFe |
| xml_path | String | Não | Caminho do arquivo XML |
| status | Enum | Sim | pendente, processada, cancelada |
| processado_por_id | UUID (FK) | Não | Quem processou |

---

#### Entidade: VENDAS_GRAOS
**Descrição:** Registro de vendas de produção
**Fonte de dados:** Castrolanda + Formulário

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| safra_id | UUID (FK) | Sim | Qual safra |
| cultura_id | UUID (FK) | Sim | Tipo de grão |
| data_venda | Date | Sim | Data da venda |
| quantidade_sacas | Decimal | Sim | Quantidade vendida |
| preco_saca | Decimal | Sim | Preço por saca |
| valor_total | Decimal | Sim | Valor total |
| comprador | String | Sim | Quem comprou |
| nota_fiscal | String | Não | Número da NF |
| tipo | Enum | Sim | spot, contrato_futuro, barter |
| data_entrega | Date | Não | Quando será entregue |

---

#### Entidade: PROJECAO_VENDAS
**Descrição:** Planejamento de vendas futuras
**Fonte de dados:** Planilha Claudio (até 2032)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| safra_id | UUID (FK) | Sim | Qual safra |
| cultura_id | UUID (FK) | Sim | Tipo de grão |
| quantidade_sacas_prevista | Decimal | Sim | Previsão de venda |
| preco_medio_esperado | Decimal | Não | Preço esperado |
| data_previsao | Date | Sim | Quando foi feita a previsão |
| observacoes | String | Não | Notas |

---

#### Entidade: CONTAS_PAGAR
**Descrição:** Compromissos financeiros
**Fonte de dados:** Planilha SharePoint Valentina

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| descricao | String | Sim | Descrição da conta |
| fornecedor | String | Sim | Credor |
| valor | Decimal | Sim | Valor |
| data_vencimento | Date | Sim | Vencimento |
| data_pagamento | Date | Não | Quando foi paga |
| status | Enum | Sim | pendente, paga, atrasada |
| categoria | String | Não | Categoria do gasto |
| nota_fiscal_id | UUID (FK) | Não | NF relacionada |

---

#### Entidade: CONTAS_RECEBER
**Descrição:** Valores a receber
**Fonte de dados:** Planilha SharePoint

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| descricao | String | Sim | Descrição |
| cliente | String | Sim | Devedor |
| valor | Decimal | Sim | Valor |
| data_vencimento | Date | Sim | Vencimento |
| data_recebimento | Date | Não | Quando recebeu |
| status | Enum | Sim | pendente, recebida, atrasada |
| venda_id | UUID (FK) | Não | Venda relacionada |

---

### 3.6 DOMÍNIO: Pecuária (Futuro)

#### Entidade: ANIMAIS
**Descrição:** Cadastro do rebanho
**Fonte de dados:** A definir

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| identificacao | String | Sim | Brinco/número |
| raca | String | Não | Raça |
| sexo | Enum | Sim | macho, femea |
| data_nascimento | Date | Não | Data de nascimento |
| peso_atual | Decimal | Não | Último peso |
| status | Enum | Sim | ativo, vendido, morto |
| lote | String | Não | Lote/piquete |

**Perguntas para a visita:**
- Como é feito o controle do gado hoje?
- Tem brinco eletrônico?
- Qual o tamanho do rebanho (~1000 cabeças)?

---

### 3.7 DOMÍNIO: Integrações

#### Entidade: INTEGRACOES
**Descrição:** Configurações de integrações externas
**Fonte de dados:** Configuração do sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| tipo | Enum | Sim | john_deere, vestro, castrolanda |
| nome | String | Sim | Nome da integração |
| api_key | String (encrypted) | Não | Chave de API |
| api_secret | String (encrypted) | Não | Secret |
| token | String (encrypted) | Não | Token de acesso |
| token_expira_em | DateTime | Não | Expiração do token |
| ultima_sincronizacao | DateTime | Não | Última sync |
| status | Enum | Sim | ativa, erro, inativa |
| config_json | JSON | Não | Configurações extras |

---

#### Entidade: LOGS_INTEGRACAO
**Descrição:** Histórico de sincronizações
**Fonte de dados:** Sistema

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| integracao_id | UUID (FK) | Sim | Qual integração |
| data_hora | DateTime | Sim | Momento |
| tipo | Enum | Sim | sucesso, erro, warning |
| mensagem | String | Sim | Descrição |
| registros_processados | Integer | Não | Quantidade |
| detalhes_json | JSON | Não | Detalhes técnicos |

---

### 3.8 DOMÍNIO: Alertas e Notificações

#### Entidade: ALERTAS
**Descrição:** Alertas gerados pelo sistema
**Fonte de dados:** Sistema automático

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| id | UUID | Sim | Identificador único |
| organizacao_id | UUID (FK) | Sim | Organização |
| tipo | Enum | Sim | estoque_baixo, manutencao, integracao_erro, etc. |
| titulo | String | Sim | Título do alerta |
| mensagem | String | Sim | Descrição completa |
| severidade | Enum | Sim | info, warning, error, critical |
| entidade_tipo | String | Não | Tipo da entidade relacionada |
| entidade_id | UUID | Não | ID da entidade relacionada |
| criado_em | DateTime | Sim | Quando foi gerado |
| lido_em | DateTime | Não | Quando foi visualizado |
| resolvido_em | DateTime | Não | Quando foi resolvido |
| resolvido_por_id | UUID (FK) | Não | Quem resolveu |

**Tipos de alerta a implementar:**
- Estoque de insumo baixo
- Estoque de diesel baixo
- Máquina com consumo anormal
- Erro de integração
- Conta a pagar vencendo
- Manutenção preventiva próxima

---

## 4. DIAGRAMA DE RELACIONAMENTOS

### 4.1 Relacionamentos Principais

```
ORGANIZACOES (1) ──────────────────────────────────────────────────────┐
     │                                                                  │
     │ 1:N                                                             │
     ▼                                                                  │
FAZENDAS (N) ◄──────────────────────────────────────────────────────┐ │
     │                                                               │ │
     │ 1:N                                                          │ │
     ▼                                                               │ │
TALHOES (N)                                                          │ │
     │                                                               │ │
     │ N:1                                                           │ │
     ▼                                                               │ │
ENTRADAS_GRAOS (N) ──► CULTURAS (1)                                 │ │
     │                      │                                        │ │
     │ N:1                  │ 1:N                                    │ │
     ▼                      ▼                                        │ │
SILOS (N) ◄────────── ESTOQUE_SILOS (N)                             │ │
                                                                     │ │
MAQUINAS (N) ◄──────────────────────────────────────────────────────┤ │
     │                                                               │ │
     │ 1:N                                                           │ │
     ▼                                                               │ │
ABASTECIMENTOS (N)                                                   │ │
     │                                                               │ │
     │ N:1                                                           │ │
     ▼                                                               │ │
OPERACOES_CAMPO (N) ───► TALHOES (1)                                │ │
                                                                     │ │
SAFRAS (N) ◄────────────────────────────────────────────────────────┤ │
     │                                                               │ │
     │ 1:N                                                           │ │
     ▼                                                               │ │
CUSTOS (N) ───► CULTURAS (1)                                        │ │
     │              │                                                │ │
     │ N:1          │ 1:N                                            │ │
     ▼              ▼                                                │ │
NOTAS_FISCAIS (N)  VENDAS_GRAOS (N)                                 │ │
                                                                     │ │
USUARIOS (N) ◄───────────────────────────────────────────────────────┘ │
     │                                                                  │
     │ N:N                                                             │
     ▼                                                                  │
ROLES (N) ◄─────────────────────────────────────────────────────────────┘
```

### 4.2 Entidades Fortes vs. Fracas

| Entidade | Classificação | Justificativa |
|----------|---------------|---------------|
| USUARIOS | **FORTE** | Dados sensíveis (email, senha) |
| ENTRADAS_GRAOS | **FORTE** | Core do negócio, dados de produção |
| CUSTOS | **FORTE** | Dados financeiros críticos |
| NOTAS_FISCAIS | **FORTE** | Documentos fiscais |
| MAQUINAS | **FORTE** | Ativos valiosos |
| ABASTECIMENTOS | Fraca | Muitos registros por máquina |
| OPERACOES_CAMPO | Fraca | Dados de telemetria em volume |
| LOGS_INTEGRACAO | Fraca | Dados de auditoria |
| ALERTAS | Fraca | Muitos alertas por organização |

---

## 5. CHECKLIST PARA VISITA FÍSICA

### 5.1 Materiais para Levar

- [ ] Notebook/tablet para anotações
- [ ] Este documento impresso
- [ ] Câmera/celular para fotos
- [ ] Gravador de áudio (pedir permissão)
- [ ] Caneta e papel backup

### 5.2 Pessoas para Entrevistar

| Pessoa | Foco | Perguntas Principais |
|--------|------|---------------------|
| **Josmar** | Secador | Campos do caderno, fluxo de entrada, decisão de silo |
| **Leomar** | Silos | Software de controle, dados disponíveis, exportação |
| **Tiago** | Maquinário | Planilha de frota, Vestro, manutenções |
| **Valentina** | Financeiro | Notas fiscais, contas a pagar/receber, fluxo |
| **Claudio** | Geral | Planilha de vendas, visão estratégica, prioridades |

### 5.3 Perguntas por Área

#### Secador (Josmar)
- [ ] Quais campos você anota em cada entrada?
- [ ] Em que ordem você anota?
- [ ] Como você calcula o desconto de umidade/sujeira?
- [ ] Como decide para qual silo vai?
- [ ] Quanto tempo leva para registrar uma carga?
- [ ] Tem Wi-Fi no secador?
- [ ] Consegue usar tablet/celular?

#### Silos (Leomar)
- [ ] Como funciona o software de controle?
- [ ] Quais dados ele mostra (temperatura, umidade)?
- [ ] Tem exportação de dados ou API?
- [ ] Como vocês sabem o estoque real de cada silo?
- [ ] Posso ver a tela do sistema?

#### Maquinário (Tiago)
- [ ] Posso ver a planilha mestre de frota?
- [ ] Quantas máquinas têm telemetria John Deere?
- [ ] Como funciona o Vestro na prática?
- [ ] Quais máquinas mais consomem?
- [ ] Como é o controle de manutenção?

#### Financeiro (Valentina)
- [ ] Posso ver o fluxo de entrada de NF?
- [ ] Como está organizada a planilha de contas a pagar?
- [ ] Quanto tempo gasta por semana digitando dados?
- [ ] O que é mais repetitivo no seu trabalho?

#### Visão Geral (Claudio)
- [ ] Posso ver a planilha de projeção até 2032?
- [ ] Quais relatórios você mais usa?
- [ ] O que te faria sentir no controle do negócio?
- [ ] Qual dado você mais sente falta hoje?

### 5.4 Documentos/Planilhas para Coletar

- [ ] Caderno do Josmar (fotografar páginas)
- [ ] Planilha de frota do Tiago
- [ ] Planilha de contas a pagar/receber
- [ ] Planilha de projeção de vendas
- [ ] Print do software do Leomar
- [ ] Exemplo de exportação do Vestro
- [ ] Estrutura do John Deere Operations Center

---

## 6. TEMPLATE PARA ANOTAÇÕES NA VISITA

Use este template para cada entidade que mapear:

```markdown
## Entidade: [NOME]

**Fonte de dados:** [Onde vem o dado]
**Responsável:** [Quem preenche/mantém]
**Frequência:** [Quantos registros por dia/semana/mês]

### Campos Identificados:
1. [campo_1] - [tipo] - [obrigatório?] - [descrição]
2. [campo_2] - [tipo] - [obrigatório?] - [descrição]
...

### Relacionamentos:
- Conecta com [ENTIDADE_X] via [campo_chave]
- ...

### Observações:
- [Notas sobre o processo]
- [Dificuldades identificadas]
- [Oportunidades de melhoria]

### Fotos/Evidências:
- [ ] Foto do formulário/tela
- [ ] Foto do caderno/planilha
```

---

## 7. PRÓXIMOS PASSOS PÓS-VISITA

1. **Consolidar anotações** em documento digital
2. **Criar Diagrama ER visual** no Miro ou similar
3. **Validar com João** a modelagem técnica
4. **Apresentar para Claudio** para validação de negócio
5. **Iniciar modelagem do banco** PostgreSQL

---

**Documento preparado por:** DeepWork AI Flows
**Data:** 03/02/2026
**Versão:** 1.0
