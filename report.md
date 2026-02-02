# Relatório de Análise - Agriwin (Castrolanda)

**Data da Análise:** 26/01/2026
**Plataforma:** https://castrolanda.agriwin.com.br
**Tipo de Análise:** READ-ONLY (sem manipulação de dados)
**Credenciais:** <USERNAME> / <PASSWORD>

---

## 1. Executive Summary (10 Insights Principais)

1. **Sistema ERP Agrícola Completo**: Agriwin é um sistema de gestão agropecuária robusto, integrado com a cooperativa Castrolanda, cobrindo desde cadastros básicos até gestão fiscal completa.

2. **Foco em LCDPR**: O sistema tem forte ênfase na geração do Livro Caixa Digital do Produtor Rural (LCDPR), obrigação fiscal brasileira.

3. **Integração Fiscal Profunda**: Módulos completos de NFe, MDFe e NFeResumida com sincronização automática da Sefaz.

4. **Dashboard Rico**: Homepage com cards informativos (previsão do tempo, contas a pagar/receber, histórico de safra, manutenções, seguros).

5. **Gestão de Propriedades**: Sistema hierárquico completo (Propriedade > Talhão > Plantio) com dados georreferenciados.

6. **Controle Financeiro**: Módulos de lançamentos, empréstimos, contas a pagar/receber com 2.594+ registros de lançamentos.

7. **Gestão de Imobilizados**: Controle de 266 imobilizados (barracões, máquinas) com planos de manutenção e seguros.

8. **Estoque Avançado**: Controle de estoque com etiquetas por produtor, ajustes e consumos rastreados.

9. **Interface Desktop-First**: UI claramente otimizada para desktop, mobile funcional mas não prioritário.

10. **Integração Cooperativa**: Sistema white-label integrado especificamente com Castrolanda para dados de produtores.

---

## 2. Mapa de Telas e Rotas

### 2.1 Autenticação
| Rota | Nome | Descrição |
|------|------|-----------|
| `/usuario/login` | Login | Autenticação via CPF/E-mail + Senha |
| `/usuario/configuracoes` | Config. Usuário | Configurações de conta (404 no teste) |

### 2.2 Dashboard / Home
| Rota | Nome | Descrição |
|------|------|-----------|
| `/` | Home | Dashboard principal com cards e gráficos |

**Cards Observados no Dashboard:**
- Próximas Manutenções (imobilizados)
- Contas a Pagar (vencidas, vence hoje, a vencer)
- Contas a Receber (vencidas, vence hoje, a vencer)
- Histórico de Safra
- Produtos em Estoque Mínimo
- Seguros de Imobilizados
- Previsão do Tempo (integração CPTEC)
- Atualizações do Sistema
- Resultados da Safra por Período
- Custos por Manutenção

### 2.3 Módulo Fiscal
| Rota | Nome | Descrição |
|------|------|-----------|
| `/LCDPR/list` | LCDPR | Livro Caixa Digital do Produtor Rural |
| `/NFe/list` | NFe | Notas Fiscais Eletrônicas |
| `/MDFe/list` | MDFe | Manifesto Eletrônico de Documentos Fiscais |
| `/NFeResumida/list` | NFeResumida | NFe Resumidas (sincronização Sefaz) |

### 2.4 Módulo Cadastros
| Rota | Nome | Descrição |
|------|------|-----------|
| `/propriedade/list` | Propriedades | Cadastro de fazendas/propriedades |
| `/talhao/list` | Talhões | Divisões das propriedades |
| `/plantio/list` | Plantios | Registro de plantios por safra |
| `/categoriaConta/list` | Categorias de Conta | Plano de contas |
| `/orcamentoAgricola/list` | Orçamentos | Orçamentos agrícolas |
| `/pessoaProdutor/list` | Produtores | Cadastro de produtores |
| `/produto/list` | Produtos | Cadastro de insumos/produtos |
| `/imobilizado/list` | Imobilizados | Máquinas, veículos, benfeitorias |
| `/imobilizadoSubTipo/list` | SubTipos Imobilizado | Classificação de imobilizados |
| `/descontoTabela/list` | Tabelas de Desconto | Tabelas de desconto aplicáveis |
| `/pontoArmazenamento/list` | Pontos de Armazenamento | Silos, armazéns |
| `/pontoEstoque/list` | Pontos de Estoque | Locais de estoque |
| `/postoDeColeta/list` | Postos de Coleta | Pontos de coleta de produção |
| `/safra/list` | Safras | Cadastro de safras (2024/2025, etc.) |
| `/seguro/list` | Seguros | Apólices de seguro |
| `/operacaoTipo/list` | Tipos de Operação | Classificação de operações |
| `/pessoaTipo/list` | Tipos de Pessoa | Classificação de pessoas |

### 2.5 Módulo Gerenciamento
| Rota | Nome | Descrição |
|------|------|-----------|
| `/compra/list` | Compras | Registro de compras |
| `/estoque/list` | Estoque | Controle de estoque |
| `/ajusteEstoque/list` | Ajustes de Estoque | Correções de estoque |
| `/consumo/list` | Consumos | Registro de consumos |
| `/lancamento/list` | Lançamentos | Movimentações financeiras |
| `/emprestimo/list` | Empréstimos | Controle de empréstimos |
| `/producao/list` | Produções | Registro de produção |

### 2.6 Módulos Não Acessíveis (404)
- `/relatorio/list`
- `/financeiro/list`
- `/contasPagar/list`
- `/contasReceber/list`
- `/usuario/configuracoes`

---

## 3. Mapa de APIs/Endpoints Observados

### 3.1 APIs de Dashboard (Cards)
```
POST /cards/carregarManutencaoImobilizado
POST /cards/carregarHistoricoPrecoProduto
POST /cards/carregarProdutosEmEstoqueMinimo
POST /cards/carregarSegurosImobilizado
POST /cards/carregarAtualizacoes
POST /cards/carregarPrevisaoTempo
POST /cards/carregarResultadosSafraPeriodo
POST /cards/carregarCustosPorManutencao
POST /cards/carregarAreaPlantio
POST /cards/carregarDadosClimaticos
```

### 3.2 APIs de Gráficos
```
POST /graficoContasPagar/carregarSomatorioContasAPagarAVencer
POST /graficoContasPagar/carregarSomatorioContasAPagarVencidas
POST /graficoContasPagar/carregarSomatorioContasAPagarVenceHoje
POST /graficoContasPagar/carregarGrafico
POST /graficoContasReceber/carregarSomatorioContasAReceberAVencer
POST /graficoContasReceber/carregarSomatorioContasAReceberVencidas
POST /graficoContasReceber/carregarSomatorioContasAReceberVenceHoje
POST /graficoContasReceber/carregarGrafico
```

### 3.3 APIs de CRUD (Listagem)
```
GET /NFe/listNFes
GET /MDFe/listMDFes
GET /NFeResumida/listNFeResumidas
GET /propriedade/listPropriedades
GET /talhao/listTalhaos
GET /plantio/listPlantios
GET /orcamentoAgricola/listOrcamentoAgricola
GET /pessoaProdutor/listPessoaProdutors
GET /produto/listProdutos
GET /imobilizado/listImobilizados
GET /safra/listSafras
GET /seguro/listSeguros
GET /compra/listCompras
GET /lancamento/listLancamentos
GET /emprestimo/listEmprestimos
GET /producao/listProducaos
```

### 3.4 APIs de Sistema
```
POST /index/consultarPermissao
POST /index/getSafraList
POST /index/renderizarBotoes
POST /index/obterIdsRegistrosBloqueados
POST /index/obterQuantidadeInstanciasParaTutorial
POST /index/carregarModalVideoYoutube
POST /index/carregarAtualizacoesImportantes
GET /index/obterAlertCertificadoVencendoOuVencido
POST /blocoAnotacao/consultarBlocoAnotacao
GET /blocoAnotacao/create
```

### 3.5 Estatísticas de Tráfego
- **Total de requisições capturadas:** 960
- **Endpoints únicos:** 77
- **Endpoints mais chamados:**
  - `GET /config` - 124 chamadas
  - `POST /g/collect` (Google Analytics) - 48 chamadas
  - `POST /blocoAnotacao/consultarBlocoAnotacao` - 31 chamadas
  - `POST /index/obterQuantidadeInstanciasParaTutorial` - 23 chamadas

---

## 4. Análise de UX/UI

### 4.1 Desktop (Pontos Fortes)
- **Sidebar Completa:** Menu lateral bem organizado com ícones e expansão
- **Breadcrumb Visual:** Header mostra contexto do usuário e safra atual
- **Tabelas Funcionais:** DataTables com filtros por coluna, paginação, ordenação
- **Botões de Ação:** Padrão consistente (+ Novo, Importar, Simular)
- **Tutorial Integrado:** Modal "Deseja ver o tutorial?" ao acessar páginas novas
- **Indicadores Visuais:** Badges coloridos (Sim/Não, status)
- **Notificações:** Sistema de alertas (certificados vencendo, seguros, etc.)

### 4.2 Desktop (Pontos Fracos)
- **Densidade Alta:** Muita informação por tela, pode sobrecarregar
- **Modal de Vídeo:** Auto-play de vídeo YouTube no dashboard é intrusivo
- **Erros 404:** Algumas rotas retornam 404 sem tratamento elegante
- **Formulários Densos:** Muitos campos por tela em cadastros

### 4.3 Mobile
- **Menu Hamburger:** Funcional mas não otimizado
- **Tabelas:** Não são responsivas, requerem scroll horizontal
- **Touch Targets:** Botões pequenos para interação touch
- **Dashboard:** Cards empilham verticalmente, funciona razoavelmente

### 4.4 Componentes para Copiar no DPWAI
1. **Cards de Dashboard:** Layout de métricas com ícone, valor, label, trend
2. **Gráficos de Donut:** Para distribuição de valores
3. **Timeline de Atualizações:** Lista cronológica de mudanças
4. **Tabela com Filtros por Coluna:** Cada coluna tem seu dropdown de filtro
5. **Modal de Tutorial:** Onboarding contextual por página
6. **Widget de Previsão do Tempo:** Integração meteorológica
7. **Bloco de Anotações:** Notepad flutuante para usuário

---

## 5. Performance Observada

### 5.1 Tempos de Carregamento
- **Login → Dashboard:** ~3-4 segundos
- **Navegação entre páginas:** ~1-2 segundos
- **Carregamento de listas grandes:** ~2-3 segundos (2.594 lançamentos)

### 5.2 Pontos de Lentidão
- **Dashboard inicial:** Muitas requisições paralelas para cards (15+ APIs)
- **Embed de YouTube:** Adiciona latência e peso ao carregamento
- **Sincronização Sefaz:** NFeResumida tem botão de sync que indica processo demorado

### 5.3 Otimizações Observadas
- **Paginação:** Listas carregam 10 itens por vez
- **Lazy Loading:** Cards carregam sob demanda
- **Cache:** Dados climáticos armazenados em localStorage

---

## 6. Observações de Segurança

### 6.1 Headers de Segurança
| Header | Status |
|--------|--------|
| X-Frame-Options | **NÃO CONFIGURADO** |
| Content-Security-Policy | **NÃO CONFIGURADO** |
| Strict-Transport-Security | **NÃO CONFIGURADO** |
| X-Content-Type-Options | **NÃO CONFIGURADO** |

### 6.2 Cookies
| Cookie | Secure | HttpOnly | SameSite |
|--------|--------|----------|----------|
| JSESSIONID | **Não** | Sim | Lax |
| autenticacaoUsuario | Sim | Sim | Lax |
| customizacaoUsuario | Sim | Sim | Lax |
| _ga (Analytics) | Não | Não | Lax |

### 6.3 Comportamento de Sessão
- **Proteção de Rotas:** OK - todas as rotas protegidas redirecionam para login
- **Session ID em URL:** Não exposto na URL
- **HTTPS:** Sim, forçado
- **Timeout de Sessão:** ~1 hora (observado durante crawl mobile)

### 6.4 Riscos Identificados (Observação Apenas)
1. **Clickjacking:** Sem X-Frame-Options, vulnerável a iframes maliciosos
2. **Cookie JSESSIONID não-secure:** Pode ser transmitido em HTTP
3. **Ausência de CSP:** Sem proteção contra XSS via headers
4. **Ausência de HSTS:** Sem forçar HTTPS via header

### 6.5 Pontos Positivos
- Autenticação via cookie HttpOnly
- Proteção adequada de rotas
- Redirecionamento consistente para login
- SameSite=Lax previne CSRF básico

---

## 7. Comparativo com DPWAI

### 7.1 Funcionalidades Presentes no Agriwin, Ausentes no DPWAI

| Funcionalidade | Agriwin | DPWAI | Prioridade |
|----------------|---------|-------|------------|
| LCDPR | Sim | **Não** | P0 |
| NFe/MDFe/NFe Resumida | Sim | **Não** | P0 |
| Gestão de Propriedades | Sim | **Não** | P0 |
| Gestão de Talhões | Sim | **Não** | P0 |
| Gestão de Plantios | Sim | **Não** | P1 |
| Safras | Sim | **Não** | P0 |
| Imobilizados | Sim | **Não** | P1 |
| Estoque | Sim | **Não** | P1 |
| Lançamentos Financeiros | Sim | Parcial | P1 |
| Contas a Pagar/Receber | Sim | **Não** | P1 |
| Empréstimos | Sim | **Não** | P2 |
| Integração Sefaz | Sim | **Não** | P0 |
| Previsão do Tempo | Sim | **Não** | P2 |
| Seguros | Sim | **Não** | P2 |
| Manutenção de Máquinas | Sim | **Não** | P2 |
| Orçamentos Agrícolas | Sim | **Não** | P1 |

### 7.2 Funcionalidades Presentes no DPWAI, Ausentes no Agriwin

| Funcionalidade | DPWAI | Agriwin |
|----------------|-------|---------|
| Form Builder Visual | Sim | Não |
| AI Assistant (Ralph) | Sim | Não |
| Dashboards Personalizáveis | Sim | Não |
| Email Templates | Sim | Não |
| Webhooks | Sim | Não |
| Multi-tenant | Sim | Limitado |
| Audit Log | Sim | Limitado |
| API Moderna (REST) | Sim | Parcial |

### 7.3 Recomendações de Integração

1. **Prioridade Máxima (P0):**
   - Implementar módulo de LCDPR
   - Criar cadastros de Propriedade/Talhão/Safra
   - Integrar NFe via API Sefaz

2. **Alta Prioridade (P1):**
   - Dashboard com cards informativos estilo Agriwin
   - Módulo de Lançamentos Financeiros expandido
   - Gestão de Estoque

3. **Média Prioridade (P2):**
   - Integração meteorológica (CPTEC/INMET)
   - Módulo de Imobilizados
   - Gestão de Seguros

---

## 8. Backlog Sugerido

### P0 - Crítico (Paridade de Funcionalidade Core)
- [ ] Criar modelo de dados para Propriedade/Talhão/Plantio
- [ ] Implementar módulo LCDPR com geração de arquivo
- [ ] Integrar API Sefaz para NFe/MDFe
- [ ] Cadastro de Safras com seletor global
- [ ] Dashboard com cards de métricas agrícolas

### P1 - Alta (Funcionalidades Essenciais)
- [ ] Módulo de Lançamentos Financeiros completo
- [ ] Gestão de Estoque com movimentações
- [ ] Orçamentos Agrícolas por safra
- [ ] Contas a Pagar/Receber com vencimentos
- [ ] Cadastro de Produtos/Insumos agrícolas

### P2 - Média (Diferenciação)
- [ ] Widget de Previsão do Tempo
- [ ] Gestão de Imobilizados com manutenção
- [ ] Controle de Seguros com alertas
- [ ] Empréstimos agrícolas
- [ ] Tutorial contextual por página

### P3 - Baixa (Nice to Have)
- [ ] Importação de XMLs de NFe
- [ ] Sincronização automática Sefaz
- [ ] Relatórios PDF/Excel
- [ ] App mobile dedicado

---

## Anexos

### Artefatos Gerados
- `/artifacts/screenshots/mobile/` - 34 screenshots mobile
- `/artifacts/screenshots/desktop/` - 34 screenshots desktop
- `/artifacts/routes/mobile_routes.json` - Mapa de rotas mobile
- `/artifacts/routes/desktop_routes.json` - Mapa de rotas desktop
- `/artifacts/network/network.jsonl` - 960 requisições capturadas
- `/artifacts/network/endpoints_summary.json` - 77 endpoints únicos
- `/artifacts/summary/security_observations.json` - Análise de segurança

### Metodologia
- **Ferramentas:** Playwright (Chromium)
- **Dispositivos:** Desktop (1920x1080), Mobile (iPhone 12 Pro emulado)
- **Modo:** READ-ONLY (nenhuma ação de escrita executada)
- **Duração:** ~15 minutos de crawl automatizado

---

*Relatório gerado automaticamente via análise READ-ONLY. Nenhum dado foi criado, modificado ou excluído durante esta análise.*
