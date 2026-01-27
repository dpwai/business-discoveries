# Análise Técnica: Discovery com Tiago Kwasnieski (Maquinário)
**Data da Reunião:** 16 de janeiro de 2026  
**Participantes:** Rodrigo Kugler, Tiago Kwasnieski, Claudio Kugler  
**Foco:** Mapeamento de Maquinário, Combustível e Recepção de Grãos

---

## 1. 🎯 Resumo Executivo (TL;DR)

**Objetivo:** Entender o fluxo de dados do maquinário e identificar oportunidades imediatas de automação para o Data Warehouse.

**Sentimento:**
*   **Tiago é um "Inovador Interno" ("Inventa Moda"):** É o champion ideal. Já implementou sistema digital (Vestro) e sofre com a desorganização dos dados. Ele entende perfeitamente a proposta de valor ("centralizar para não sofrer").
*   **Abertura Total:** Tiago ofereceu acesso irrestrito às planilhas, sistemas e convidou Rodrigo para ver a operação física na próxima sexta-feira.

**Quick Win Identificado:**
*   **Integração Vestro (Combustível):** O sistema já é digital (Android), mas o processo atual envolve exportar Excel -> Tiago corrigir manualmente -> Valentina digitar no AgriWin. **Automação via API do Vestro economizaria dias de trabalho.**

---

## 2. 🔍 Mapeamento de Fontes de Dados

| Sistema / Processo | Fonte (Bronze) | Quem Opera? | Pain Point (Dor) | Oportunidade Técnica (Solução) |
|---|---|---|---|---|
| **Vestro (Abastecimento)** | App Android / Totem na bomba | Operadores (30+) | Erro humano na digitação de horímetro (ponto vs vírgula). Tiago corrige excel manual. Valentina redigita no AgriWin. | **Conector API Vestro** -> Tratamento automático (Silver) -> Carga no AgriWin/DW. |
| **John Deere Ops Center** | Telemetria Máquina | Operadores | Só 2 de 4 tratores de plantio conectados. Parque misto (caminhões/patrolas não têm). Dados de "Talhão" vêm sujos (nomes duplicados). | Ingestão via API JD. Tratamento pesado na camada Silver para normalizar nomes de Talhões. |
| **Recepção de Grãos** | **Caderno de Papel** (Josmar) | Josmar (Secador) | Dados de umidade/peso anotados à mão. Risco de perda, sem histórico fácil, digitação posterior. | **OCR (Visão Computacional)** para ler o caderno OU App simples de entrada (tipo AppSheet) para o Josmar. |
| **Frota Legada** | Manual / Verbal | Operadores | Patrolas 1990 e Caminhões não têm telemetria. Controle 100% manual. | Manter entrada manual simplificada (App) ou integrar via Vestro (abastecimento como proxy de uso). |

---

## 3. 🚧 Gargalos e Processos Manuais (Deep Dive)

### O Pesadelo do "Vestro -> Excel -> AgriWin"
**Fluxo Atual:**
1.  Operador abastece e lança no App Vestro (às vezes erra o horímetro).
2.  Tiago exporta relatório a cada 15/30 dias.
3.  Tiago **abre o Excel e corrige linha por linha** (ex: muda 540.00 para 5400.0).
4.  Tiago **adiciona colunas manuais** que o Vestro não tem (Qual fazenda? Qual operação?).
5.  Tiago envia planilha para Valentina.
6.  Valentina **digita manualmente** note por nota no AgriWin para o custo.

**Solução Data Warehouse:**
*   N8N coleta dados da API Vestro diariamente.
*   Regra de negócio (Python) corrige horímetros absurdos automaticamente.
*   Cross-reference com escala de trabalho (se existir) para preencher "Operação".
*   Gera arquivo pronto para importação AgriWin ou insere direto no Banco de Dados.

### A "Sujeira" do John Deere
Tiago mostrou na tela: **"Bonim", "Boninho", "Bonin lado esquerdo"**.
*   É o mesmo talhão escrito de 5 jeitos diferentes pelos operadores.
*   Isso impede análise histórica (Ex: "Como foi a produtividade do Bonim em 5 anos?").
*   **Ação Crítica:** A camada **Silver** do Data Warehouse precisará de uma tabela "De-Para" robusta para normalizar esses nomes.

---

## 4. 💡 Insights Futuros (O Sonho)

**Visão do Tiago:**
> *"Eu quero saber o histórico de Fósforo do solo de uma gleba nos últimos 10 anos."*
Para saber: "Eu extraí muito nutriente? Preciso repor mais este ano?"

**Necessidade de Correlação:**
Cruzar:
1.  Amostragem de Solo (PDFs Fundação ABC/Laboratório)
2.  Adubação realizada (Histórico de Aplicação AgriWin/JD)
3.  Produtividade final (Mapa de Colheita JD/Recepção Grãos)

Isso valida 100% a tese do Data Warehouse. O AgriWin sozinho não faz esse cruzamento histórico complexo.

---

## 5. 📅 Plano de Ação Imediato

| Responsável | Ação | Prazo | Status |
|---|---|---|---|
| **Rodrigo** | **Visita Técnica Presencial:** Ir à fazenda ver o "Caderno do Josmar" e a Balança. | Sexta-feira (23/01) | **Marcado** |
| **Rodrigo** | **Busca de APIs:** Contatar suporte John Deere, Castrolanda e Vestro para documentação. | Imediato | Pendente |
| **Tiago** | **Envio de Exemplos:** Enviar planilha Vestro (correção manual) e planilha de Entrada de Grãos. | Até Sexta | Pendente |
| **Rodrigo** | **Desenho Técnico:** Mapear arquitetura da ingestão Vestro (Quick Win). | Pós-visita | Pendente |

---

## ⚠️ Pontos de Atenção (Riscos)
1.  **Parque Misto:** Não vamos conseguir conectar tudo via John Deere. Precisamos de soluções para as máquinas velhas (provavelmente focar no dado de abastecimento como principal indicador de custo para estas).
2.  **CNPJ/Contrato:** Rodrigo precisa formalizar a PJ para assinar NDAs e contratos com os fornecedores de software se necessário.
3.  **Complexidade de Entrada:** Tiago alertou que "adicionar mais campos para o operador preencher" gera erro. A solução tem que ser **automática** (sensor/GPS) ou muito simples (1 clique).

---
**Conclusão:** O Discovery foi um sucesso absoluto. Tiago é um aliado técnico forte. Temos caminho livre para o MVP usando dados da Vestro e resolvendo a dor da digitação manual da Valentina/Tiago.
