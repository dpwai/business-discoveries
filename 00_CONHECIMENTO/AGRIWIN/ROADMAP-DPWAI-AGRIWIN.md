# Roadmap: Implementar Features do Agriwin no DPWAI

**Data:** 27/01/2026
**Objetivo:** Paridade de funcionalidades com Agriwin + vantagens do DPWAI

---

## 1. COMPARATIVO COMPLETO

### 1.1 Funcionalidades por Categoria

| Categoria | Feature | Agriwin | DPWAI | Gap | Prioridade |
|-----------|---------|---------|-------|-----|------------|
| **NÚCLEO** | | | | | |
| | Multi-tenant (subdomínios) | ✅ | ✅ | - | - |
| | Autenticação CPF | ✅ | ❌ | **SIM** | P1 |
| | Seletor de Safra global | ✅ | ❌ | **SIM** | P0 |
| | Permissões por perfil | ✅ | ✅ | - | - |
| **CADASTROS** | | | | | |
| | Propriedades | ✅ | ❌ | **SIM** | P0 |
| | Talhões (divisões) | ✅ | ❌ | **SIM** | P0 |
| | Plantios por safra | ✅ | ❌ | **SIM** | P0 |
| | Safras | ✅ | ❌ | **SIM** | P0 |
| | Produtos/Insumos | ✅ | ❌ | **SIM** | P1 |
| | Categorias de Conta | ✅ | ❌ | **SIM** | P1 |
| | Imobilizados (máquinas) | ✅ | ❌ | **SIM** | P2 |
| | Seguros | ✅ | ❌ | **SIM** | P2 |
| **FISCAL** | | | | | |
| | NFe (emissão) | ✅ | ❌ | **SIM** | P0 |
| | NFe Resumida (recebimento) | ✅ | ❌ | **SIM** | P1 |
| | LCDPR | ✅ | ❌ | **SIM** | P0 |
| | MDFe | ✅ | ❌ | **SIM** | P2 |
| | Certificado Digital A1 | ✅ | ❌ | **SIM** | P0 |
| **FINANCEIRO** | | | | | |
| | Lançamentos | ✅ | Parcial | Expandir | P1 |
| | Contas a Pagar | ✅ | ❌ | **SIM** | P1 |
| | Contas a Receber | ✅ | ❌ | **SIM** | P1 |
| | Empréstimos | ✅ | ❌ | **SIM** | P2 |
| | Conciliação Bancária | ✅ | ❌ | **SIM** | P2 |
| **ESTOQUE** | | | | | |
| | Controle de Estoque | ✅ | ❌ | **SIM** | P1 |
| | Consumos | ✅ | ❌ | **SIM** | P1 |
| | Ajustes | ✅ | ❌ | **SIM** | P2 |
| | Etiquetas (coop) | ✅ | ❌ | **SIM** | P3 |
| **DASHBOARD** | | | | | |
| | Cards informativos | ✅ | Parcial | Expandir | P1 |
| | Gráficos financeiros | ✅ | ❌ | **SIM** | P1 |
| | Previsão do tempo | ✅ | ❌ | **SIM** | P2 |
| | Alertas (vencimentos) | ✅ | ❌ | **SIM** | P1 |
| **INTEGRAÇÃO** | | | | | |
| | Sync Cooperativa | ✅ | ❌ | **SIM** | P3 |
| | API SEFAZ | ✅ | ❌ | **SIM** | P0 |
| | API CPTEC (clima) | ✅ | ❌ | **SIM** | P2 |
| **VANTAGENS DPWAI** | | | | | |
| | Form Builder visual | ❌ | ✅ | Vantagem | - |
| | AI Assistant (Ralph) | ❌ | ✅ | Vantagem | - |
| | Dashboards customizáveis | ❌ | ✅ | Vantagem | - |
| | Webhooks | ❌ | ✅ | Vantagem | - |
| | API REST documentada | Parcial | ✅ | Vantagem | - |
| | Mobile-first | ❌ | ✅ | Vantagem | - |

### 1.2 Resumo de Gaps

| Prioridade | Qtd Features | Esforço Estimado |
|------------|--------------|------------------|
| P0 (Crítico) | 8 | 6-8 semanas |
| P1 (Alto) | 10 | 4-6 semanas |
| P2 (Médio) | 8 | 4-5 semanas |
| P3 (Baixo) | 2 | 2 semanas |
| **TOTAL** | **28** | **16-21 semanas** |

---

## 2. ROADMAP DETALHADO

### 2.1 FASE 1: Fundação Agrícola (6-8 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   FASE 1: FUNDAÇÃO AGRÍCOLA                                             │
│   Duração: 6-8 semanas                                                  │
│   Objetivo: Estrutura base para gestão de propriedades rurais           │
│                                                                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   SPRINT 1 (2 semanas): Modelo de Dados                                 │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Criar tabelas Prisma:                                       │ │
│   │       - Safra (id, nome, dataInicio, dataFim, ativa, tenantId)   │ │
│   │       - Propriedade (id, nome, inscricaoEstadual, nirf, area)    │ │
│   │       - Talhao (id, nome, area, propriedadeId)                    │ │
│   │       - Plantio (id, talhaoId, safraId, culturaId, area)         │ │
│   │       - Cultura (id, nome, tipo: GRAO|LEITE|PECUARIA)            │ │
│   │                                                                    │ │
│   │   [ ] Criar migrations                                            │ │
│   │   [ ] Seeds com dados de exemplo                                  │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 2 (2 semanas): CRUD e Interface                                │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] API Routes:                                                 │ │
│   │       - /api/agro/[tenant]/safras                                │ │
│   │       - /api/agro/[tenant]/propriedades                          │ │
│   │       - /api/agro/[tenant]/propriedades/[id]/talhoes            │ │
│   │       - /api/agro/[tenant]/plantios                              │ │
│   │                                                                    │ │
│   │   [ ] Páginas:                                                    │ │
│   │       - /[tenant]/agro/safras (listagem + CRUD)                  │ │
│   │       - /[tenant]/agro/propriedades (listagem + CRUD)            │ │
│   │       - /[tenant]/agro/propriedades/[id]/talhoes                 │ │
│   │       - /[tenant]/agro/plantios                                   │ │
│   │                                                                    │ │
│   │   [ ] Componente SelecionadorSafra (global, no header)           │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 3 (2 semanas): Fiscal Básico                                   │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Integração Focus NFe ou NFe.io                             │ │
│   │   [ ] Upload de certificado A1                                    │ │
│   │   [ ] Tabelas: CertificadoDigital, NFe                           │ │
│   │   [ ] API: /api/agro/[tenant]/nfe                                │ │
│   │   [ ] Página de emissão de NFe                                    │ │
│   │   [ ] Listagem de NFe emitidas                                    │ │
│   │   [ ] Download XML e DANFE                                        │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 4 (2 semanas): LCDPR                                           │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Tabela CategoriaConta (plano de contas LCDPR)              │ │
│   │   [ ] Vincular lançamentos com categorias LCDPR                  │ │
│   │   [ ] Gerador de arquivo TXT                                      │ │
│   │   [ ] Validador de consistência                                   │ │
│   │   [ ] Interface de revisão                                        │ │
│   │   [ ] Download do arquivo LCDPR                                   │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   ENTREGÁVEIS FASE 1:                                                   │
│   ✓ Gestão completa de Propriedades/Talhões/Safras/Plantios            │
│   ✓ Emissão de NFe integrada com SEFAZ                                  │
│   ✓ Geração de LCDPR para Receita Federal                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 FASE 2: Financeiro e Estoque (4-6 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   FASE 2: FINANCEIRO E ESTOQUE                                          │
│   Duração: 4-6 semanas                                                  │
│   Objetivo: Controle financeiro e de insumos completo                   │
│                                                                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   SPRINT 5 (2 semanas): Financeiro Expandido                            │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Expandir modelo de Lançamentos:                            │ │
│   │       - Vincular com NFe                                          │ │
│   │       - Vincular com Propriedade                                  │ │
│   │       - Vincular com Safra                                        │ │
│   │       - Status de pagamento                                        │ │
│   │                                                                    │ │
│   │   [ ] Contas a Pagar/Receber:                                    │ │
│   │       - Tabela ContaPagar (valor, vencimento, status)            │ │
│   │       - Tabela ContaReceber                                       │ │
│   │       - Dashboard com vencidos/hoje/a vencer                     │ │
│   │                                                                    │ │
│   │   [ ] Empréstimos:                                                │ │
│   │       - Tabela Emprestimo                                         │ │
│   │       - Cálculo de parcelas e juros                              │ │
│   │       - Cronograma de pagamentos                                  │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 6 (2 semanas): Estoque                                         │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Modelo de dados:                                            │ │
│   │       - Produto (insumos: sementes, fertilizantes, defensivos)   │ │
│   │       - Estoque (quantidade, lote, validade)                     │ │
│   │       - MovimentacaoEstoque (entrada/saída)                      │ │
│   │       - Consumo (vinculado a talhão e safra)                     │ │
│   │                                                                    │ │
│   │   [ ] Funcionalidades:                                            │ │
│   │       - Entrada de produtos (compra)                              │ │
│   │       - Saída de produtos (consumo)                               │ │
│   │       - Alerta de estoque mínimo                                  │ │
│   │       - Custo por hectare                                         │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 7 (2 semanas): NFe Resumida                                    │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Integração NFeDistribuicaoDFe                              │ │
│   │   [ ] Sincronização automática (cron)                            │ │
│   │   [ ] Manifestação do destinatário                               │ │
│   │   [ ] Vinculação NFe → Lançamento                                │ │
│   │   [ ] Import automático de compras                               │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   ENTREGÁVEIS FASE 2:                                                   │
│   ✓ Controle financeiro completo (pagar/receber/empréstimos)           │
│   ✓ Gestão de estoque de insumos                                        │
│   ✓ Import automático de notas fiscais recebidas                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.3 FASE 3: Dashboard e UX (3-4 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   FASE 3: DASHBOARD E UX                                                │
│   Duração: 3-4 semanas                                                  │
│   Objetivo: Interface rica e informativa                                │
│                                                                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   SPRINT 8 (2 semanas): Cards e Gráficos                                │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Dashboard Agrícola:                                         │ │
│   │       - Card: Área plantada por cultura                           │ │
│   │       - Card: Resultado da safra (receita - custo)               │ │
│   │       - Card: Produtividade (sacas/hectare)                      │ │
│   │       - Gráfico: Evolução de custos por mês                      │ │
│   │                                                                    │ │
│   │   [ ] Dashboard Financeiro:                                       │ │
│   │       - Card: Contas a pagar (vencidas/hoje/a vencer)            │ │
│   │       - Card: Contas a receber                                    │ │
│   │       - Card: Saldo de empréstimos                               │ │
│   │       - Gráfico: Fluxo de caixa                                  │ │
│   │                                                                    │ │
│   │   [ ] Widget Previsão do Tempo:                                  │ │
│   │       - Integração CPTEC/INMET                                    │ │
│   │       - 7 dias de previsão                                        │ │
│   │       - Por localização da propriedade                           │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 9 (2 semanas): Alertas e Relatórios                            │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Sistema de Alertas:                                         │ │
│   │       - Certificado digital vencendo                             │ │
│   │       - Seguros vencendo                                          │ │
│   │       - Manutenções pendentes                                     │ │
│   │       - Contas vencidas                                           │ │
│   │       - Estoque mínimo                                            │ │
│   │                                                                    │ │
│   │   [ ] Relatórios:                                                 │ │
│   │       - PDF: Resultado da safra                                   │ │
│   │       - PDF: Fluxo de caixa                                       │ │
│   │       - Excel: Lançamentos do período                            │ │
│   │       - Excel: Movimentação de estoque                           │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   ENTREGÁVEIS FASE 3:                                                   │
│   ✓ Dashboard rico com cards e gráficos                                 │
│   ✓ Previsão do tempo integrada                                         │
│   ✓ Sistema de alertas proativo                                         │
│   ✓ Relatórios PDF e Excel                                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.4 FASE 4: Imobilizado e Extras (3-4 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│   FASE 4: IMOBILIZADO E EXTRAS                                          │
│   Duração: 3-4 semanas                                                  │
│   Objetivo: Gestão de patrimônio e integrações extras                   │
│                                                                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│   SPRINT 10 (2 semanas): Imobilizados                                   │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] Modelo de dados:                                            │ │
│   │       - Imobilizado (tratores, colheitadeiras, veículos)         │ │
│   │       - TipoImobilizado / SubtipoImobilizado                     │ │
│   │       - Manutencao (preventiva/corretiva)                        │ │
│   │       - Seguro                                                    │ │
│   │                                                                    │ │
│   │   [ ] Funcionalidades:                                            │ │
│   │       - Cadastro de máquinas com depreciação                     │ │
│   │       - Agenda de manutenções                                     │ │
│   │       - Controle de seguros                                       │ │
│   │       - Horímetro/Odômetro                                        │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   SPRINT 11 (2 semanas): MDFe e Extras                                  │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │                                                                    │ │
│   │   [ ] MDFe (Manifesto):                                          │ │
│   │       - Emissão de MDFe                                           │ │
│   │       - Encerramento de MDFe                                      │ │
│   │       - Cancelamento                                              │ │
│   │                                                                    │ │
│   │   [ ] Extras:                                                     │ │
│   │       - Login por CPF                                             │ │
│   │       - Tutorial contextual                                       │ │
│   │       - Bloco de anotações                                        │ │
│   │                                                                    │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   ENTREGÁVEIS FASE 4:                                                   │
│   ✓ Gestão completa de máquinas e equipamentos                         │
│   ✓ Controle de manutenções e seguros                                  │
│   ✓ Emissão de MDFe para transporte                                    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. CRONOGRAMA VISUAL

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                          │
│   CRONOGRAMA DE IMPLEMENTAÇÃO                                                                           │
│                                                                                                          │
│   Semana    1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20              │
│             │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │   │              │
│   FASE 1    ████████████████████████████████                                                            │
│   Fundação  │ Sprint 1 │ Sprint 2 │ Sprint 3 │ Sprint 4 │                                              │
│   Agrícola  │ Modelo   │ CRUD UI  │ NFe      │ LCDPR    │                                              │
│                                                                                                          │
│   FASE 2                                    ████████████████████████                                    │
│   Financeiro                                │ Sprint 5 │ Sprint 6 │ Sprint 7 │                          │
│   e Estoque                                 │Financeiro│ Estoque  │ NFe Res. │                          │
│                                                                                                          │
│   FASE 3                                                            ████████████████                    │
│   Dashboard                                                         │ Sprint 8 │ Sprint 9 │              │
│   e UX                                                              │ Cards    │ Alertas  │              │
│                                                                                                          │
│   FASE 4                                                                            ████████████████    │
│   Imobilizado                                                                       │Sprint 10│Sprint 11││
│   e Extras                                                                          │Imobili. │ MDFe    ││
│                                                                                                          │
│   ─────────────────────────────────────────────────────────────────────────────────────────────────────  │
│                                                                                                          │
│   MARCOS PRINCIPAIS:                                                                                    │
│                                                                                                          │
│   Semana 8:  ★ MVP Agrícola (Propriedades + NFe + LCDPR)                                               │
│   Semana 14: ★ Gestão Financeira Completa                                                               │
│   Semana 16: ★ Dashboard Rico                                                                           │
│   Semana 20: ★ Paridade com Agriwin                                                                     │
│                                                                                                          │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. MODELO DE DADOS PRISMA (PROPOSTO)

```prisma
// schema.prisma - Adições para módulo agrícola

// Safra - contexto temporal
model Safra {
  id          String   @id @default(cuid())
  nome        String   // "2024/2025"
  dataInicio  DateTime
  dataFim     DateTime
  ativa       Boolean  @default(false)
  tenantId    String
  tenant      Tenant   @relation(fields: [tenantId], references: [id])
  plantios    Plantio[]
  lancamentos Lancamento[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  @@unique([tenantId, nome])
}

// Propriedade rural
model Propriedade {
  id               String   @id @default(cuid())
  nome             String
  inscricaoEstadual String?
  nirf             String?  // Número do Imóvel na Receita Federal
  car              String?  // Cadastro Ambiental Rural
  areaTotal        Float    // hectares
  endereco         Json?    // { logradouro, municipio, uf, cep }
  coordenadas      Json?    // { latitude, longitude }
  ativo            Boolean  @default(true)
  userId           String
  user             User     @relation(fields: [userId], references: [id])
  tenantId         String
  tenant           Tenant   @relation(fields: [tenantId], references: [id])
  talhoes          Talhao[]
  lancamentos      Lancamento[]
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}

// Talhão (divisão da propriedade)
model Talhao {
  id             String      @id @default(cuid())
  nome           String
  area           Float       // hectares
  soloTipo       String?
  coordenadas    Json?       // GeoJSON polygon
  ativo          Boolean     @default(true)
  propriedadeId  String
  propriedade    Propriedade @relation(fields: [propriedadeId], references: [id])
  plantios       Plantio[]
  consumos       Consumo[]
  createdAt      DateTime    @default(now())
  updatedAt      DateTime    @updatedAt
}

// Cultura (soja, milho, trigo, etc)
model Cultura {
  id        String    @id @default(cuid())
  nome      String
  tipo      String    // GRAO, LEITE, PECUARIA, HORTIFRUTI
  unidade   String    // saca, litro, kg, arroba
  tenantId  String
  tenant    Tenant    @relation(fields: [tenantId], references: [id])
  plantios  Plantio[]
}

// Plantio
model Plantio {
  id               String   @id @default(cuid())
  talhaoId         String
  talhao           Talhao   @relation(fields: [talhaoId], references: [id])
  safraId          String
  safra            Safra    @relation(fields: [safraId], references: [id])
  culturaId        String
  cultura          Cultura  @relation(fields: [culturaId], references: [id])
  area             Float    // hectares plantados
  dataPlantio      DateTime?
  dataColheita     DateTime?
  producaoEstimada Float?   // em unidade da cultura
  producaoReal     Float?
  observacoes      String?
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt
}

// Certificado Digital A1
model CertificadoDigital {
  id           String   @id @default(cuid())
  nome         String
  arquivo      Bytes    // .pfx criptografado
  senhaHash    String   // senha criptografada
  validade     DateTime
  tipo         String   @default("A1")
  ativo        Boolean  @default(true)
  userId       String
  user         User     @relation(fields: [userId], references: [id])
  tenantId     String
  tenant       Tenant   @relation(fields: [tenantId], references: [id])
  nfes         NFe[]
  createdAt    DateTime @default(now())
  updatedAt    DateTime @updatedAt
}

// Nota Fiscal Eletrônica
model NFe {
  id                  String              @id @default(cuid())
  numero              String
  serie               String
  chaveAcesso         String              @unique
  dataEmissao         DateTime
  valorTotal          Float
  status              String              // AUTORIZADA, CANCELADA, REJEITADA
  xml                 String?             @db.Text
  protocolo           String?
  motivoRejeicao      String?
  certificadoId       String
  certificado         CertificadoDigital  @relation(fields: [certificadoId], references: [id])
  tenantId            String
  tenant              Tenant              @relation(fields: [tenantId], references: [id])
  lancamentos         Lancamento[]
  createdAt           DateTime            @default(now())
  updatedAt           DateTime            @updatedAt
}

// NFe Resumida (recebidas de terceiros)
model NFeResumida {
  id              String   @id @default(cuid())
  chaveAcesso     String   @unique
  numero          String
  emitenteCnpj    String
  emitenteNome    String
  valorTotal      Float
  dataEmissao     DateTime
  xml             String?  @db.Text
  manifestacao    String?  // CIENCIA, CONFIRMADA, NAO_REALIZADA, DESCONHECIDA
  dataManifestacao DateTime?
  importada       Boolean  @default(false)
  tenantId        String
  tenant          Tenant   @relation(fields: [tenantId], references: [id])
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
}

// Categoria de Conta (plano de contas LCDPR)
model CategoriaConta {
  id          String   @id @default(cuid())
  codigo      String   // 1.1, 2.1.1, etc
  nome        String
  tipo        String   // RECEITA, DESPESA
  grupoLcdpr  String?  // Grupo para LCDPR
  ativo       Boolean  @default(true)
  tenantId    String
  tenant      Tenant   @relation(fields: [tenantId], references: [id])
  lancamentos Lancamento[]

  @@unique([tenantId, codigo])
}

// Produto/Insumo
model Produto {
  id            String   @id @default(cuid())
  codigo        String
  nome          String
  unidade       String   // kg, litro, saca, unidade
  ncm           String?
  tipo          String   // SEMENTE, FERTILIZANTE, DEFENSIVO, COMBUSTIVEL
  estoqueMinimo Float    @default(0)
  ativo         Boolean  @default(true)
  tenantId      String
  tenant        Tenant   @relation(fields: [tenantId], references: [id])
  estoques      Estoque[]
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  @@unique([tenantId, codigo])
}

// Estoque
model Estoque {
  id            String   @id @default(cuid())
  produtoId     String
  produto       Produto  @relation(fields: [produtoId], references: [id])
  quantidade    Float
  valorUnitario Float
  lote          String?
  validade      DateTime?
  local         String?  // Armazém, galpão, etc
  tenantId      String
  tenant        Tenant   @relation(fields: [tenantId], references: [id])
  consumos      Consumo[]
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt
}

// Consumo de insumos
model Consumo {
  id         String   @id @default(cuid())
  estoqueId  String
  estoque    Estoque  @relation(fields: [estoqueId], references: [id])
  talhaoId   String
  talhao     Talhao   @relation(fields: [talhaoId], references: [id])
  quantidade Float
  data       DateTime
  operador   String?
  observacao String?
  tenantId   String
  tenant     Tenant   @relation(fields: [tenantId], references: [id])
  createdAt  DateTime @default(now())
}

// Imobilizado (máquinas, veículos)
model Imobilizado {
  id              String       @id @default(cuid())
  codigo          String
  nome            String
  tipo            String       // TRATOR, COLHEITADEIRA, VEICULO, IMPLEMENTO
  subtipo         String?
  valorAquisicao  Float
  dataAquisicao   DateTime
  vidaUtilAnos    Int
  horasOuKm       Float        @default(0)
  ativo           Boolean      @default(true)
  tenantId        String
  tenant          Tenant       @relation(fields: [tenantId], references: [id])
  manutencoes     Manutencao[]
  seguros         Seguro[]
  createdAt       DateTime     @default(now())
  updatedAt       DateTime     @updatedAt

  @@unique([tenantId, codigo])
}

// Manutenção
model Manutencao {
  id            String      @id @default(cuid())
  imobilizadoId String
  imobilizado   Imobilizado @relation(fields: [imobilizadoId], references: [id])
  tipo          String      // PREVENTIVA, CORRETIVA
  dataPrevista  DateTime
  dataRealizada DateTime?
  custo         Float?
  descricao     String
  horasOuKm     Float?
  tenantId      String
  tenant        Tenant      @relation(fields: [tenantId], references: [id])
  createdAt     DateTime    @default(now())
  updatedAt     DateTime    @updatedAt
}

// Seguro
model Seguro {
  id             String      @id @default(cuid())
  imobilizadoId  String
  imobilizado    Imobilizado @relation(fields: [imobilizadoId], references: [id])
  seguradora     String
  apolice        String
  valorSegurado  Float
  premio         Float
  vigenciaInicio DateTime
  vigenciaFim    DateTime
  tenantId       String
  tenant         Tenant      @relation(fields: [tenantId], references: [id])
  createdAt      DateTime    @default(now())
  updatedAt      DateTime    @updatedAt
}
```

---

## 5. PRÓXIMOS PASSOS IMEDIATOS

### Hoje (Pode começar agora):

1. **Criar branch feature/agro-fundacao**
2. **Adicionar models Prisma** (Safra, Propriedade, Talhao, Plantio, Cultura)
3. **Rodar migration**
4. **Criar primeiro endpoint** `/api/agro/[tenant]/safras`

### Esta semana:

1. Completar CRUD de Safras
2. Completar CRUD de Propriedades
3. Criar componente SelecionadorSafra

### Próxima semana:

1. Pesquisar e escolher API de NFe (Focus NFe vs NFe.io)
2. Implementar upload de certificado A1
3. Primeiro teste de emissão de NFe em homologação

---

## FONTES

- [Agriwin](https://www.agriwin.com.br/)
- [Castrolanda](https://www.castrolanda.coop.br/)
- [Focus NFe](https://focusnfe.com.br/doc/)
- [NFe.io](https://nfe.io/)
- [Portal NFe](https://www.nfe.fazenda.gov.br/)
- [LCDPR - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/declaracoes-e-demonstrativos/lcdpr-livro-caixa-digital-do-produtor-rural)
- [CPTEC/INPE](http://servicos.cptec.inpe.br/)

---

*Roadmap criado com base na análise READ-ONLY do Agriwin.*
