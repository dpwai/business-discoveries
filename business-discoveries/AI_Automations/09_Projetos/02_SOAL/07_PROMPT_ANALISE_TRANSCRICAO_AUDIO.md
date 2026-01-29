# Prompt para Análise de Transcrição de Áudio - Projeto SOAL

## Contexto do Projeto
Você está analisando uma transcrição de áudio de uma **visita de descoberta (Deep Discovery)** realizada na **Fazenda Santana do Iapó (SOAL)**, localizada em Piraí do Sul - PR. 

A SOAL é uma operação agropecuária de grande porte (~2.150 hectares de plantio, multi-cultura: soja, milho, feijão, aveia, trigo) com produção própria de sementes e gado de corte (~1000+ cabeças). A fazenda pertence a Claudio Kugler, conselheiro influente da Cooperativa Castrolanda.

**Objetivo do Projeto:** Desenvolver uma solução SaaS B2B de **Inteligência de Dados** (BI + IA + Dashboards + Automações) para resolver dores operacionais e financeiras da SOAL, validar o produto piloto, e posteriormente escalar para outros cooperados da região via Castrolanda.

---

## Limitações da Transcrição (IMPORTANTE)

### 1. Reconhecimento de Fala Imperfeito
- **Termos Técnicos do Agro:** Nomes de cultivares, defensivos, marcas de insumos e máquinas podem estar transcritos incorretamente.
  - Exemplo: "Soja BMX Turbo" pode aparecer como "soja bm x turbo" ou "soja be emis turbo"
  - Exemplo: "Castrolanda" pode aparecer como "Castro Landa" ou "castro linda"
- **Ação:** Se encontrar termos técnicos com grafia estranha, **infira o termo correto** com base no contexto e indique `[inferido: termo_correto]`.

### 2. Números e Métricas
- Valores numéricos (hectares, cabeças de gado, litros, toneladas, valores em R$) podem estar incorretos ou mal formatados.
  - Exemplo: "2000" pode ser "2.000" ou "dois mil"
  - Valores em Reais podem não ter vírgula/ponto: "1500" ao invés de "R$ 1.500,00"
- **Ação:** Sempre que possível, **normalizar** os valores numéricos e adicionar contexto. Se houver incerteza, marque como `[VERIFICAR: valor_aproximado]`.

### 3. Ambiguidade de Nomes Próprios
- Nomes de funcionários, fazendas/retiros, sistemas (softwares) e marcas podem estar incorretos.
  - Exemplo: "Tiago" (gerente de máquinas) pode aparecer como "Thiago" ou "Diego"
  - Exemplo: "AgriWin" (ERP) pode aparecer como "Agri Win", "Agro Win" ou "Agricwin"
- **Ação:** Manter coerência de nomes ao longo do documento. Se houver dúvida, usar a forma mais provável e marcar `[a confirmar]`.

### 4. Ruído de Ambiente Rural
- Sons de máquinas, animais, vento ou falas simultâneas podem causar **lacunas ou trechos ininteligíveis** na transcrição.
- **Ação:** Se houver trechos incompreensíveis, marque como `[trecho incompreensível - possível tema: X]`.

### 5. Vícios de Linguagem e Coloquialismos
- Expressões regionais, gírias do agro, "né?", "daí", "tipo assim" podem poluir o texto.
- **Ação:** **Ignorar** vícios de linguagem na extração de insights. Focar apenas no conteúdo informativo.

---

## Instruções de Análise

### 1. Extração de Informações Estruturadas
Você deve extrair e organizar as seguintes categorias de informação:

#### A) **Operação e Estrutura**
- Culturas plantadas (época, área, variedades)
- Área total de plantio e subdivisões (retiros/fazendas)
- Pecuária: número de cabeças de gado, raça, tipo (corte/leite)
- Estrutura física: silos, armazéns, oficina, outras instalações
- Número de funcionários (fixos e temporários por departamento)

#### B) **Tecnologia e Dados Existentes**
- **ERP/Software de Gestão:** Nome do sistema, módulos utilizados, nível de satisfação
- **Maquinário:** Marcas (John Deere, Case, etc.), ano, presença de telemetria/computador de bordo
- **Conectividade:** Qualidade da internet (sede, campo, tipo: Starlink, 4G, fibra)
- **Sistemas Atuais:** Mencionar qualquer portal da John Deere (Operations Center), sistemas da Castrolanda, ou outras integrações existentes

#### C) **Shadow IT e Processos Manuais** 🎯 **CRÍTICO**
Esta é a **informação mais valiosa** do projeto. Procure por:
- **Planilhas Paralelas:** Excel usado para controle de combustível, estoque, manutenção, custos, etc.
- **Apontamentos em Papel:** Cadernos de campo, anotações manuais, post-its com "macetes"
- **Processos Manuais Repetitivos:** Tarefas que consomem horas semanais (ex: "o gerente passa 3 horas sexta-feira digitando as notas da semana")
- **Uso:** Fotografias de quadros, monitores, planilhas mencionadas

**Ação Especial:** Se detectar menções a "planilha de X", "eu controlo em Excel", "anoto num cadernoço", **DESTACAR EM NEGRITO** e adicionar tag `[OPORTUNIDADE DE AUTOMAÇÃO]`.

#### D) **Dores e Pain Points** 🎯 **CRÍTICO**
Procure explicitamente por:
- **Perda Financeira:** Desperdício, quebra, roubo, subutilização de recursos
- **Falta de Informação em Tempo Real:** Decisões tomadas no "achismo" ou atraso de dados
- **Retrabalho:** Digitação duplicada, conversão manual de unidades, relatórios manuais
- **Gargalos de Comunicação:** Informações que "dormem" em gavetas, não chegam a quem precisa
- **A Pergunta de 1 Milhão:** Se houver menção a uma decisão cara tomada por falta de dado, **DESTACAR EM MAIÚSCULAS**.

**Formato de Saída:**
```
### Pain Point Identificado: [Nome do Pain]
**Severidade:** Alta / Média / Baixa
**Descrição:** [Detalhamento]
**Impacto Estimado:** [Horas/semana perdidas ou R$ impactados]
**Possível Solução:** [Como a Deepwork AI pode resolver]
```

#### E) **Objetivos e Visão de Futuro**
- O que o cliente considera um "sucesso" do projeto?
- Dashboards desejados, métricas específicas, alertas em tempo real
- Nível de apetite para investimento em IoT/sensores vs. apenas inteligência de dados

#### F) **Pessoas e Stakeholders**
- Criar um "mapa de stakeholders" com nome, cargo, responsabilidades e dores específicas
- Identificar quem seria o usuário final do sistema (quem vai abrir o dashboard todo dia)

---

### 2. Classificação de Prioridade
Para cada informação extraída, atribua uma tag de prioridade:
- `[P0 - CRÍTICO]` = Informação essencial para viabilidade do projeto
- `[P1 - ALTA]` = Importante para funcionalidades core
- `[P2 - MÉDIA]` = Nice-to-have ou feature futura
- `[P3 - BAIXA]` = Contextual, mas não blocante

---

### 3. Checklist de Validação Técnica
Ao final da análise, responda este checklist (com base na transcrição):

- [ ] **Qualidade da Origem de Dados:** Foi possível identificar COMO os dados entram no sistema atual? (Manual, automático, híbrido?)
- [ ] **API/Integração:** Há menção a APIs disponíveis (AgriWin, Castrolanda, John Deere)? Se sim, detalhar.
- [ ] **Quick Win Identificado:** Existe alguma "vitória rápida" óbvia? (Ex: Dashboard simples conectando dados já existentes)
- [ ] **Barreira Técnica:** Algum sistema foi descrito como "impossível de integrar" ou "muito fechado"?
- [ ] **Planilhas Cruciais Localizadas:** As planilhas paralelas foram identificadas e fotografadas (ou descritas)?

---

### 4. Formato de Saída do Relatório

```markdown
# Relatório de Análise - Transcrição de Áudio SOAL
**Data da Visita:** [inferir se disponível]
**Duração da Gravação:** [X minutos]
**Qualidade da Transcrição:** Boa / Média / Ruim (com ressalvas)

---

## 1. RESUMO EXECUTIVO
[Parágrafo de 5-7 linhas com os insights mais críticos]

## 2. OPERAÇÃO E ESTRUTURA
[Dados estruturados conforme item A]

## 3. TECNOLOGIA E SISTEMAS ATUAIS
[Dados estruturados conforme item B]

## 4. SHADOW IT E PROCESSOS MANUAIS 🎯
[Lista detalhada conforme item C - com destaque em negrito]

## 5. PAIN POINTS IDENTIFICADOS 🎯
[Lista de pain points no formato especificado no item D]

## 6. OBJETIVOS DO CLIENTE
[Dados conforme item E]

## 7. MAPA DE STAKEHOLDERS
| Nome | Cargo | Responsabilidades | Dores Específicas | Usuário Final? |
|------|-------|-------------------|-------------------|----------------|
| ... | ... | ... | ... | Sim/Não |

## 8. OPORTUNIDADES DE PRODUTO
[Lista de funcionalidades/módulos que fazem sentido desenvolver]

## 9. RISCOS E ALERTAS
[Qualquer red flag técnico, político ou de viabilidade]

## 10. CHECKLIST DE VALIDAÇÃO TÉCNICA
[Responder o checklist do item 3]

## 11. TRECHOS NOTÁVEIS DA TRANSCRIÇÃO
[Citações diretas relevantes - com timestamp se disponível]

## 12. PRÓXIMOS PASSOS SUGERIDOS
[Ações a tomar após esta análise]
```

---

## Princípios de Análise
1. **Assuma Boa Fé nas Limitações:** Se algo não faz sentido, provavelmente é erro de transcrição, não do entrevistado.
2. **Contexto é Rei:** Use o conhecimento de agropecuária e do projeto SOAL para "corrigir" erros óbvios.
3. **Foco em Ação:** Toda informação extraída deve levar a uma ação concreta (desenvolver funcionalidade X, validar API Y, perguntar Z na próxima reunião).
4. **Seja o "Advogado do Diabo":** Se algo soa "bom demais pra ser verdade" (ex: "temos API completa de tudo"), adicione uma nota de ceticismo `[VALIDAR TECNICAMENTE]`.

---

## Glossário de Termos Comuns (Para Correção)
| Termo Correto | Possíveis Erros de Transcrição |
|--------------|-------------------------------|
| Castrolanda | Castro Landa, castro linda, castrolandia |
| AgriWin | Agri Win, Agro Win, Agricwin |
| John Deere | John Deer, Jondir, jon deer |
| Operations Center | Operation Center, operational center |
| Hectare | Hectares, etare, eitare |
| Plantio Direto | plantio direto, plantiu direto |
| Semeadora | semeadeira, semiadeira |
| Colheitadeira | colheitadeira, colhedeira |
| Pulverizador | pulverizador, pulverisador |
| Defensivo | defensivo, defensivos, defensibo |
| Telemetria | telemetria, tele metria |

---

**IMPORTANTE:** Este prompt foi criado assumindo que a transcrição pode ter **até 30% de imprecisão** em termos técnicos e numéricos. Sempre **priorize o sentido sobre a forma literal**.
