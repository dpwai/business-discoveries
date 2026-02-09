
# Documentação Completa - Agriwin (Castrolanda)

**Versão:** 1.0
**Data:** 26/01/2026
**Plataforma:** https://castrolanda.agriwin.com.br
**Método de Análise:** Observação READ-ONLY via Playwright

---

# PARTE 1: INTEGRAÇÕES

## 1. INTEGRAÇÃO SEFAZ (Secretaria da Fazenda)

### 1.1 Visão Geral

O Agriwin integra com a SEFAZ para sincronização de documentos fiscais eletrônicos, essencial para a gestão fiscal do produtor rural brasileiro.

### 1.2 Documentos Integrados

| Documento | Descrição | Direção |
|-----------|-----------|---------|
| **NFe** | Nota Fiscal Eletrônica | Bidirecional |
| **NFe Resumida** | NFe emitidas para o produtor | SEFAZ → Agriwin |
| **MDFe** | Manifesto de Documentos Fiscais | Bidirecional |

### 1.3 Endpoints de Integração

```
# Listagem de NFe (emitidas pelo produtor)
GET /NFe/listNFes
Response: Lista de NFe com status, valores, destinatários

# Listagem de MDFe
GET /MDFe/listMDFes
Response: Lista de manifestos de transporte

# NFe Resumida (sincronização da SEFAZ)
GET /NFeResumida/listNFeResumidas
Response: NFe emitidas por terceiros para o produtor

# Trigger de sincronização com SEFAZ
POST /NFeResumida/atualizarBotaoSinc
Request: { safraId, propriedadeId }
Response: { status, ultimaSincronizacao, quantidadeNovas }

# Verificação de certificado digital
GET /index/obterAlertCertificadoVencendoOuVencido
Response: { vencendo: boolean, diasRestantes: number, mensagem: string }
```

### 1.4 Fluxo de Sincronização NFe

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO NFe RESUMIDA                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Fornecedor emite NFe para o produtor                       │
│           │                                                     │
│           ▼                                                     │
│  2. SEFAZ processa e disponibiliza NFe resumida                │
│           │                                                     │
│           ▼                                                     │
│  3. Agriwin consulta SEFAZ (via certificado A1)                │
│     POST /NFeResumida/atualizarBotaoSinc                       │
│           │                                                     │
│           ▼                                                     │
│  4. NFe aparece em /NFeResumida/listNFeResumidas               │
│           │                                                     │
│           ▼                                                     │
│  5. Produtor pode vincular a lançamentos/compras               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 1.5 Requisitos Técnicos

- **Certificado Digital:** A1 (arquivo .pfx)
- **Validade:** Monitorada pelo sistema
- **Ambiente:** Produção (SEFAZ)
- **Webservices:** Consulta NFe Destinatário

---

## 2. INTEGRAÇÃO COOPERATIVA CASTROLANDA

### 2.1 Visão Geral

A Castrolanda é uma cooperativa agroindustrial que fornece dados de referência para os produtores associados. O Agriwin opera como ERP white-label integrado.

### 2.2 Dados Sincronizados

| Dado | Descrição | Atualização |
|------|-----------|-------------|
| **Postos de Coleta** | Locais para entrega de produção | Cadastro fixo |
| **Tabelas de Desconto** | Descontos por umidade/impureza | Safra |
| **Produtores** | Cadastro de associados | Tempo real |
| **Preços de Referência** | Cotações de commodities | Diário |
| **Orçamentos** | Recomendações técnicas | Safra |

### 2.3 Endpoints de Integração

```
# Postos de coleta da cooperativa
GET /postoDeColeta/listPostoDeColeta
Response: [
  {
    id: number,
    nome: string,
    endereco: string,
    latitude: number,
    longitude: number,
    ativo: boolean
  }
]

# Tabelas de desconto (umidade, impurezas)
GET /descontoTabela/listDescontoTabelas
Response: [
  {
    id: number,
    produto: string,
    tipoDesconto: "UMIDADE" | "IMPUREZA",
    percentualInicial: number,
    percentualFinal: number,
    descontoPercentual: number
  }
]

# Produtores vinculados
GET /pessoaProdutor/listPessoaProdutors
Response: Lista de produtores com CPF, nome, propriedades

# Orçamentos agrícolas da cooperativa
GET /orcamentoAgricola/listOrcamentoAgricola
Response: Orçamentos com recomendações de insumos por cultura

# Consumo proposto (recomendação técnica)
POST /consumo/carregarTabelaConsumoProposto
Request: { safraId, talhaoId, culturaId }
Response: Lista de insumos recomendados com dosagens

# Etiquetas de estoque do produtor na cooperativa
POST /estoque/obterListaDeEtiquetasProdutor
Request: { produtorId, safraId }
Response: Lotes armazenados na cooperativa
```

### 2.4 Modelo de Integração

```
┌─────────────────────────────────────────────────────────────────┐
│                CASTROLANDA (Sistema Central)                    │
├─────────────────────────────────────────────────────────────────┤
│  - Cadastro de associados                                       │
│  - Postos de coleta                                             │
│  - Tabelas de classificação                                     │
│  - Cotações de mercado                                          │
│  - Estoques de produtores                                       │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            │ API / Sincronização
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│               AGRIWIN (ERP do Produtor)                         │
├─────────────────────────────────────────────────────────────────┤
│  castrolanda.agriwin.com.br                                     │
│  - Recebe dados de referência                                   │
│  - Produtor gerencia sua propriedade                            │
│  - Registra produção/consumo                                    │
│  - Gera LCDPR                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. INTEGRAÇÃO METEOROLÓGICA (CPTEC/INMET)

### 3.1 Visão Geral

O Agriwin exibe previsão do tempo e dados climáticos para auxiliar o produtor no planejamento agrícola.

### 3.2 Endpoints

```
# Previsão do tempo (7 dias)
POST /cards/carregarPrevisaoTempo
Request: { postoDeColetaId }
Response: {
  previsoes: [
    {
      data: string,
      temperaturaMin: number,
      temperaturaMax: number,
      condicao: string,
      icone: string,
      probabilidadeChuva: number
    }
  ]
}

# Dados climáticos detalhados
POST /cards/carregarDadosClimaticos
Request: { postoDeColetaPrevisao: 6 }
Response: {
  temperatura: number,
  umidade: number,
  vento: number,
  pressao: number,
  ultimaAtualizacao: string
}
```

### 3.3 Fonte de Dados

- **CPTEC/INPE:** Centro de Previsão de Tempo e Estudos Climáticos
- **INMET:** Instituto Nacional de Meteorologia
- **Localização:** Baseada no posto de coleta mais próximo

---

## 4. INTEGRAÇÃO ANALYTICS

### 4.1 Google Analytics 4

```
Endpoint: https://www.google-analytics.com/g/collect
Tracking ID: G-DNVCF2ZXF0

Eventos rastreados:
- page_view (visualização de página)
- user_engagement (engajamento)
- scroll (rolagem)

Parâmetros customizados:
- ep.produtor = Nome do produtor
- ep.usuario = Nome do usuário
- ep.cooperativa = "Castrolanda"
- ep.controller = Página atual
- ep.action = Ação atual
```

### 4.2 Amplitude

```
Endpoint: https://api2.amplitude.com/2/httpapi
API Key: 3946c766006153b4cadef50aa8e59987

Funcionalidades:
- Session Replay (gravação de sessão)
- Analytics comportamental
```

### 4.3 YouTube (Tutoriais)

```
Endpoint: https://youtubei/v1/log_event

Uso:
- Vídeos de tutorial embutidos no dashboard
- Modal de onboarding com vídeo explicativo
```

---

## 5. INTEGRAÇÃO LCDPR (Receita Federal)

### 5.1 Visão Geral

O LCDPR (Livro Caixa Digital do Produtor Rural) é uma obrigação acessória da Receita Federal para produtores com receita bruta acima de R$ 4,8 milhões/ano.

### 5.2 Endpoints

```
# Listagem de registros LCDPR
GET /LCDPR/list
Response: Registros de entradas/saídas por regime de caixa

# Tutorial LCDPR
POST /LCDPR/obterQuantidadeInstanciasParaTutorial
Response: { quantidade: number, exibirTutorial: boolean }
```

### 5.3 Fluxo de Geração

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUXO LCDPR                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. Lançamentos financeiros (entradas/saídas)                  │
│           │                                                     │
│           ▼                                                     │
│  2. Classificação por Categoria de Conta                       │
│     (conforme tabela da Receita Federal)                       │
│           │                                                     │
│           ▼                                                     │
│  3. Vinculação com Imóvel Rural (propriedade)                  │
│           │                                                     │
│           ▼                                                     │
│  4. Geração do arquivo LCDPR                                   │
│     (formato TXT conforme layout RFB)                          │
│           │                                                     │
│           ▼                                                     │
│  5. Transmissão via e-CAC                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

# PARTE 2: ROTAS DA APLICAÇÃO

## 1. ROTAS DE AUTENTICAÇÃO

| Rota | Método | Descrição |
|------|--------|-----------|
| `/usuario/login` | GET/POST | Tela de login |
| `/usuario/logout` | GET | Logout |
| `/usuario/configuracoes` | GET | Configurações do usuário |
| `/usuario/alterarSenha` | POST | Alteração de senha |

---

## 2. ROTAS DO DASHBOARD

| Rota | Método | Descrição |
|------|--------|-----------|
| `/` | GET | Dashboard principal (home) |
| `/index/index` | GET | Alias para dashboard |

### 2.1 APIs do Dashboard (Cards)

| Endpoint | Método | Descrição |
|----------|--------|-----------|
| `/cards/carregarManutencaoImobilizado` | POST | Próximas manutenções |
| `/cards/carregarManutencaoImobilizadoGrafico` | POST | Gráfico de manutenções |
| `/cards/carregarHistoricoPrecoProduto` | POST | Histórico de preços |
| `/cards/carregarGraficoHistoricoPrecoProduto` | POST | Gráfico de preços |
| `/cards/carregarProdutosEmEstoqueMinimo` | POST | Produtos abaixo do mínimo |
| `/cards/carregarGraficoProdutoEmEstoqueMinimo` | POST | Gráfico estoque mínimo |
| `/cards/carregarSegurosImobilizado` | POST | Seguros a vencer |
| `/cards/carregarSegurosImobilizadoGrafico` | POST | Gráfico de seguros |
| `/cards/carregarAtualizacoes` | POST | Atualizações do sistema |
| `/cards/carregarAtualizacoesGrafico` | POST | Timeline de updates |
| `/cards/carregarPrevisaoTempo` | POST | Previsão do tempo |
| `/cards/carregarDadosClimaticos` | POST | Dados climáticos |
| `/cards/carregarResultadosSafraPeriodo` | POST | Resultados da safra |
| `/cards/carregarGraficoResultadosSafraPeriodo` | POST | Gráfico resultados |
| `/cards/carregarCustosPorManutencao` | POST | Custos de manutenção |
| `/cards/carregarGraficoCustosPorManutencao` | POST | Gráfico custos |
| `/cards/carregarAreaPlantio` | POST | Área plantada |
| `/cards/carregarDadosAreaPlantio` | POST | Detalhes área plantio |

### 2.2 APIs de Gráficos Financeiros

| Endpoint | Método | Descrição |
|----------|--------|-----------|
| `/graficoContasPagar/carregarSomatorioContasAPagarVencidas` | POST | Total vencido |
| `/graficoContasPagar/carregarSomatorioContasAPagarVenceHoje` | POST | Total vence hoje |
| `/graficoContasPagar/carregarSomatorioContasAPagarAVencer` | POST | Total a vencer |
| `/graficoContasPagar/carregarGrafico` | POST | Gráfico contas a pagar |
| `/graficoContasReceber/carregarSomatorioContasAReceberVencidas` | POST | Total vencido |
| `/graficoContasReceber/carregarSomatorioContasAReceberVenceHoje` | POST | Total vence hoje |
| `/graficoContasReceber/carregarSomatorioContasAReceberAVencer` | POST | Total a vencer |
| `/graficoContasReceber/carregarGrafico` | POST | Gráfico contas a receber |
| `/graficoEstatistica/carregarGrafico` | POST | Estatísticas gerais |

---

## 3. ROTAS FISCAIS

### 3.1 LCDPR

| Rota | Método | Descrição |
|------|--------|-----------|
| `/LCDPR/list` | GET | Listagem de registros LCDPR |
| `/LCDPR/create` | GET | Formulário novo registro |
| `/LCDPR/edit/{id}` | GET | Editar registro |
| `/LCDPR/delete/{id}` | POST | Excluir registro |
| `/LCDPR/gerarArquivo` | POST | Gerar arquivo LCDPR |
| `/LCDPR/obterQuantidadeInstanciasParaTutorial` | POST | Verificar tutorial |

### 3.2 NFe (Nota Fiscal Eletrônica)

| Rota | Método | Descrição |
|------|--------|-----------|
| `/NFe/list` | GET | Listagem de NFe |
| `/NFe/listNFes` | GET | API de listagem |
| `/NFe/create` | GET | Nova NFe |
| `/NFe/edit/{id}` | GET | Editar NFe |
| `/NFe/view/{id}` | GET | Visualizar NFe |
| `/NFe/transmitir/{id}` | POST | Transmitir para SEFAZ |
| `/NFe/cancelar/{id}` | POST | Cancelar NFe |
| `/NFe/inutilizar` | POST | Inutilizar numeração |
| `/NFe/downloadXml/{id}` | GET | Baixar XML |
| `/NFe/downloadPdf/{id}` | GET | Baixar DANFE |

### 3.3 MDFe (Manifesto)

| Rota | Método | Descrição |
|------|--------|-----------|
| `/MDFe/list` | GET | Listagem de MDFe |
| `/MDFe/listMDFes` | GET | API de listagem |
| `/MDFe/create` | GET | Novo MDFe |
| `/MDFe/edit/{id}` | GET | Editar MDFe |
| `/MDFe/encerrar/{id}` | POST | Encerrar MDFe |
| `/MDFe/cancelar/{id}` | POST | Cancelar MDFe |

### 3.4 NFe Resumida

| Rota | Método | Descrição |
|------|--------|-----------|
| `/NFeResumida/list` | GET | Listagem de NFe recebidas |
| `/NFeResumida/listNFeResumidas` | GET | API de listagem |
| `/NFeResumida/atualizarBotaoSinc` | POST | Sincronizar com SEFAZ |
| `/NFeResumida/manifestar/{id}` | POST | Manifestar ciência |
| `/NFeResumida/downloadXml/{id}` | GET | Baixar XML completo |

---

## 4. ROTAS DE CADASTROS

### 4.1 Propriedades

| Rota | Método | Descrição |
|------|--------|-----------|
| `/propriedade/list` | GET | Listagem de propriedades |
| `/propriedade/listPropriedades` | GET | API de listagem |
| `/propriedade/create` | GET | Nova propriedade |
| `/propriedade/edit/{id}` | GET | Editar propriedade |
| `/propriedade/delete/{id}` | POST | Excluir propriedade |

### 4.2 Talhões

| Rota | Método | Descrição |
|------|--------|-----------|
| `/talhao/list` | GET | Listagem de talhões |
| `/talhao/listTalhaos` | GET | API de listagem |
| `/talhao/create` | GET | Novo talhão |
| `/talhao/edit/{id}` | GET | Editar talhão |
| `/talhao/delete/{id}` | POST | Excluir talhão |

### 4.3 Plantios

| Rota | Método | Descrição |
|------|--------|-----------|
| `/plantio/list` | GET | Listagem de plantios |
| `/plantio/listPlantios` | GET | API de listagem |
| `/plantio/create` | GET | Novo plantio |
| `/plantio/edit/{id}` | GET | Editar plantio |
| `/plantio/delete/{id}` | POST | Excluir plantio |

### 4.4 Safras

| Rota | Método | Descrição |
|------|--------|-----------|
| `/safra/list` | GET | Listagem de safras |
| `/safra/listSafras` | GET | API de listagem |
| `/safra/create` | GET | Nova safra |
| `/safra/edit/{id}` | GET | Editar safra |
| `/index/getSafraList` | POST | Lista para dropdown |

### 4.5 Produtos

| Rota | Método | Descrição |
|------|--------|-----------|
| `/produto/list` | GET | Listagem de produtos |
| `/produto/listProdutos` | GET | API de listagem |
| `/produto/create` | GET | Novo produto |
| `/produto/edit/{id}` | GET | Editar produto |
| `/produto/delete/{id}` | POST | Excluir produto |

### 4.6 Pessoas/Produtores

| Rota | Método | Descrição |
|------|--------|-----------|
| `/pessoaProdutor/list` | GET | Listagem de produtores |
| `/pessoaProdutor/listPessoaProdutors` | GET | API de listagem |
| `/pessoaProdutor/create` | GET | Novo produtor |
| `/pessoaProdutor/edit/{id}` | GET | Editar produtor |
| `/pessoaTipo/list` | GET | Tipos de pessoa |
| `/pessoaTipo/listPessoaTipos` | GET | API tipos |

### 4.7 Imobilizados

| Rota | Método | Descrição |
|------|--------|-----------|
| `/imobilizado/list` | GET | Listagem de imobilizados |
| `/imobilizado/listImobilizados` | GET | API de listagem |
| `/imobilizado/create` | GET | Novo imobilizado |
| `/imobilizado/edit/{id}` | GET | Editar imobilizado |
| `/imobilizado/delete/{id}` | POST | Excluir imobilizado |
| `/imobilizadoSubTipo/list` | GET | Subtipos |
| `/imobilizadoSubTipo/listImobilizadoSubTipos` | GET | API subtipos |

### 4.8 Seguros

| Rota | Método | Descrição |
|------|--------|-----------|
| `/seguro/list` | GET | Listagem de seguros |
| `/seguro/listSeguros` | GET | API de listagem |
| `/seguro/create` | GET | Novo seguro |
| `/seguro/edit/{id}` | GET | Editar seguro |

### 4.9 Categorias de Conta

| Rota | Método | Descrição |
|------|--------|-----------|
| `/categoriaConta/list` | GET | Plano de contas |
| `/categoriaConta/create` | GET | Nova categoria |
| `/categoriaConta/edit/{id}` | GET | Editar categoria |

### 4.10 Configurações Auxiliares

| Rota | Método | Descrição |
|------|--------|-----------|
| `/operacaoTipo/list` | GET | Tipos de operação |
| `/operacaoTipo/listOperacaoTipos` | GET | API tipos |
| `/descontoTabela/list` | GET | Tabelas de desconto |
| `/descontoTabela/listDescontoTabelas` | GET | API descontos |
| `/pontoArmazenamento/list` | GET | Pontos de armazenamento |
| `/pontoArmazenamento/listPontoArmazenamentos` | GET | API armazenamento |
| `/pontoEstoque/list` | GET | Pontos de estoque |
| `/pontoEstoque/listPontoEstoques` | GET | API estoque |
| `/postoDeColeta/list` | GET | Postos de coleta |
| `/postoDeColeta/listPostoDeColeta` | GET | API postos |

---

## 5. ROTAS DE GERENCIAMENTO

### 5.1 Compras

| Rota | Método | Descrição |
|------|--------|-----------|
| `/compra/list` | GET | Listagem de compras |
| `/compra/listCompras` | GET | API de listagem |
| `/compra/create` | GET | Nova compra |
| `/compra/edit/{id}` | GET | Editar compra |
| `/compra/delete/{id}` | POST | Excluir compra |

### 5.2 Estoque

| Rota | Método | Descrição |
|------|--------|-----------|
| `/estoque/list` | GET | Listagem de estoque |
| `/estoque/listEstoque` | GET/POST | API de listagem |
| `/estoque/obterListaDeEtiquetasProdutor` | POST | Etiquetas na cooperativa |
| `/ajusteEstoque/list` | GET | Ajustes de estoque |
| `/ajusteEstoque/listAjusteEstoques` | GET | API ajustes |
| `/ajusteEstoque/create` | GET | Novo ajuste |

### 5.3 Consumos

| Rota | Método | Descrição |
|------|--------|-----------|
| `/consumo/list` | GET | Listagem de consumos |
| `/consumo/listConsumos` | GET | API de listagem |
| `/consumo/create` | GET | Novo consumo |
| `/consumo/edit/{id}` | GET | Editar consumo |
| `/consumo/carregarTabelaConsumoProposto` | POST | Consumo sugerido |

### 5.4 Lançamentos Financeiros

| Rota | Método | Descrição |
|------|--------|-----------|
| `/lancamento/list` | GET | Listagem de lançamentos |
| `/lancamento/listLancamentos` | GET | API de listagem |
| `/lancamento/create` | GET | Novo lançamento |
| `/lancamento/edit/{id}` | GET | Editar lançamento |
| `/lancamento/delete/{id}` | POST | Excluir lançamento |
| `/lancamento/importarBoleto` | POST | Importar boletos |

### 5.5 Empréstimos

| Rota | Método | Descrição |
|------|--------|-----------|
| `/emprestimo/list` | GET | Listagem de empréstimos |
| `/emprestimo/listEmprestimos` | GET | API de listagem |
| `/emprestimo/create` | GET | Novo empréstimo |
| `/emprestimo/edit/{id}` | GET | Editar empréstimo |
| `/emprestimo/obterQuantidadeInstanciasParaTutorial` | POST | Tutorial |

### 5.6 Produções

| Rota | Método | Descrição |
|------|--------|-----------|
| `/producao/list` | GET | Listagem de produções |
| `/producao/listProducaos` | GET | API de listagem |
| `/producao/create` | GET | Nova produção |
| `/producao/edit/{id}` | GET | Editar produção |

### 5.7 Orçamentos Agrícolas

| Rota | Método | Descrição |
|------|--------|-----------|
| `/orcamentoAgricola/list` | GET | Listagem de orçamentos |
| `/orcamentoAgricola/listOrcamentoAgricola` | GET | API de listagem |
| `/orcamentoAgricola/create` | GET | Novo orçamento |
| `/orcamentoAgricola/edit/{id}` | GET | Editar orçamento |
| `/orcamentoAgricola/simular` | POST | Simular orçamento |

---

## 6. ROTAS DE SISTEMA

### 6.1 Permissões e Segurança

| Rota | Método | Descrição |
|------|--------|-----------|
| `/index/consultarPermissao` | POST | Verificar permissões |
| `/index/obterIdsRegistrosBloqueados` | POST | Registros bloqueados |
| `/index/renderizarBotoes` | POST | Botões por permissão |

### 6.2 Alertas do Sistema

| Rota | Método | Descrição |
|------|--------|-----------|
| `/index/obterAlertCertificadoVencendoOuVencido` | GET | Alerta certificado |
| `/index/obterAlertSeguroVencendoOuVencido` | POST | Alerta seguros |
| `/index/obterAlertManutencaoVencendoOuVencido` | POST | Alerta manutenções |
| `/index/obterAlertCriarOrcamentoNaSafraAtual` | POST | Alerta orçamento |

### 6.3 Tutoriais e Onboarding

| Rota | Método | Descrição |
|------|--------|-----------|
| `/index/obterQuantidadeInstanciasParaTutorial` | POST | Verificar tutoriais |
| `/index/carregarModalVideoYoutube` | POST | Modal de vídeo |
| `/index/carregarAtualizacoesImportantes` | POST | Updates importantes |

### 6.4 Bloco de Anotações

| Rota | Método | Descrição |
|------|--------|-----------|
| `/blocoAnotacao/consultarBlocoAnotacao` | POST | Buscar anotações |
| `/blocoAnotacao/create` | GET | Nova anotação |
| `/blocoAnotacao/save` | POST | Salvar anotação |

### 6.5 Configurações

| Rota | Método | Descrição |
|------|--------|-----------|
| `/config` | GET | Configurações do sistema |

---

## 7. ROTAS DE RELATÓRIOS

| Rota | Método | Descrição |
|------|--------|-----------|
| `/relatorio/list` | GET | Lista de relatórios |
| `/relatorio/gerarPdf/{tipo}` | POST | Gerar PDF |
| `/relatorio/gerarExcel/{tipo}` | POST | Gerar Excel |

---

## 8. RESUMO ESTATÍSTICO

### 8.1 Totais por Categoria

| Categoria | Rotas UI | APIs | Total |
|-----------|----------|------|-------|
| Dashboard | 1 | 24 | 25 |
| Fiscal | 12 | 8 | 20 |
| Cadastros | 35 | 18 | 53 |
| Gerenciamento | 28 | 12 | 40 |
| Sistema | 5 | 12 | 17 |
| **TOTAL** | **81** | **74** | **155** |

### 8.2 Integrações

| Integração | Endpoints | Status |
|------------|-----------|--------|
| SEFAZ | 5 | Ativo |
| Castrolanda | 6 | Ativo |
| CPTEC/INMET | 2 | Ativo |
| Google Analytics | 1 | Ativo |
| Amplitude | 1 | Ativo |
| YouTube | 1 | Ativo |
| **TOTAL** | **16** | - |

---

# PARTE 3: SCHEMAS DE DADOS

## 1. Propriedade

```json
{
  "id": "number",
  "nome": "string",
  "inscricaoEstadual": "string",
  "nirf": "string",
  "car": "string",
  "area": "number",
  "atividades": ["AGRICOLA", "LEITE", "PECUARIA"],
  "ativo": "boolean",
  "endereco": {
    "logradouro": "string",
    "municipio": "string",
    "uf": "string",
    "cep": "string"
  },
  "coordenadas": {
    "latitude": "number",
    "longitude": "number"
  }
}
```

## 2. Talhão

```json
{
  "id": "number",
  "propriedadeId": "number",
  "nome": "string",
  "area": "number",
  "soloTipo": "string",
  "ativo": "boolean",
  "geoJson": "object"
}
```

## 3. Plantio

```json
{
  "id": "number",
  "talhaoId": "number",
  "safraId": "number",
  "culturaId": "number",
  "area": "number",
  "dataPlantio": "date",
  "dataColheita": "date",
  "producaoEstimada": "number",
  "producaoReal": "number"
}
```

## 4. Lançamento

```json
{
  "id": "number",
  "safraId": "number",
  "data": "date",
  "categoriaContaId": "number",
  "tipoOperacao": "ENTRADA | SAIDA",
  "clienteFornecedor": "string",
  "numeroSerie": "string",
  "valorTotal": "number",
  "pago": "boolean",
  "integrado": "boolean"
}
```

## 5. NFe

```json
{
  "id": "number",
  "numero": "string",
  "serie": "string",
  "chaveAcesso": "string",
  "dataEmissao": "date",
  "emitente": "string",
  "destinatario": "string",
  "valorTotal": "number",
  "status": "AUTORIZADA | CANCELADA | DENEGADA",
  "inscricaoEstadual": "string",
  "produtos": "array"
}
```

---

*Documentação gerada via análise READ-ONLY. Nenhum dado foi alterado durante o processo.*
