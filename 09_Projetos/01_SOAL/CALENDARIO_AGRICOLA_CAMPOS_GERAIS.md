# Calendario Agricola — Campos Gerais / Castro / SOAL

> Referencia para planejamento de safra e defaults do campo `data_plantio_prevista`.
> Baseado em ZARC, CONAB, Secretaria Agricultura PR, Castrolanda, Fundacao ABC.
> Especifico para regiao de Castro/Campos Gerais, Parana (clima Cfb, ~1000m altitude).
>
> Data: 2026-03-06 | Autor: Rodrigo Kugler

---

## 1. Safra Principal (Verao) — Jul a Jun

| Cultura | Plantio | Colheita | Ciclo (dias) | Notas regiao |
|---------|---------|----------|--------------|--------------|
| **Soja** | Out (15) — Nov (30) | Fev — Abr | 110-130 | Janela ideal: 2a quinzena Out. ZARC fecha em Jan. |
| **Milho 1a safra** | Set — Out | Fev — Mar | 140-160 | Plantio Set-Out para melhor produtividade (Embrapa). |
| **Feijao 1a safra** | Ago — Set | Nov — Dez | 85-100 | Feijao de safra. Preparo solo 30d antes. |
| **Feijao 2a safra** | Jan — Fev | Abr — Mai | 85-100 | Feijao da seca. Apos colheita soja precoce. |

---

## 2. Safrinha (Inverno/2a safra)

| Cultura | Plantio | Colheita | Ciclo (dias) | Notas regiao |
|---------|---------|----------|--------------|--------------|
| **Milho safrinha** | Jan (15) — Fev (28) | Jun — Ago | 140-160 | ZARC fecha entre Fev-Mar dependendo municipio. Risco geada. |
| **Trigo** | Mai — Jun (30) | Set — Nov | 120-140 | Cultura de inverno principal. Plantio Mai ideal. |
| **Cevada** | Jun — Jul (15) | Out — Nov | 110-130 | Castrolanda/Maltaria CG. Plantio Jun-Jul. |
| **Aveia preta** | Abr — Mai | — (dessecada) | 80-100 | Cobertura de inverno. Nao colhe — rola/desseca antes do plantio verao. |

---

## 3. Sequencias Tipicas de Rotacao SOAL

```
SEQUENCIA 1 (mais comum — soja + trigo):
Abr-Mai: Plantio trigo
Set-Out: Colheita trigo
Out-Nov: Plantio soja
Fev-Mar: Colheita soja

SEQUENCIA 2 (milho + trigo):
Mai-Jun: Plantio trigo
Out-Nov: Colheita trigo
Set-Out: Plantio milho 1a safra
Fev-Mar: Colheita milho

SEQUENCIA 3 (soja precoce + milho safrinha):
Out: Plantio soja precoce (cultivar ciclo curto)
Jan: Colheita soja
Jan-Fev: Plantio milho safrinha
Jun-Jul: Colheita milho safrinha

SEQUENCIA 4 (feijao + soja):
Ago-Set: Plantio feijao 1a safra
Nov-Dez: Colheita feijao
Dez-Jan: Plantio soja tardia (ou aveia cobertura)

SEQUENCIA 5 (cevada + soja):
Jun-Jul: Plantio cevada
Out-Nov: Colheita cevada
Nov: Plantio soja
Mar-Abr: Colheita soja

SEQUENCIA 6 (aveia cobertura + soja):
Abr-Mai: Plantio aveia preta
Ago-Set: Dessecacao/rolagem aveia
Out: Plantio soja sobre palhada
```

---

## 4. Datas-Ancora para `data_plantio_prevista` (Defaults por Cultura)

Estes sao os valores sugeridos pelo sistema quando Alessandro seleciona uma cultura no planejamento.
Alessandro SEMPRE pode alterar para a data real prevista de cada talhao.

| Cultura | data_plantio_prevista sugerida | Justificativa |
|---------|-------------------------------|---------------|
| Soja (safra) | 15 de outubro | Inicio janela ideal Campos Gerais |
| Milho (1a safra) | 1 de outubro | Embrapa: Set-Out melhor produtividade |
| Milho (safrinha) | 5 de fevereiro | Apos colheita soja, antes do ZARC fechar |
| Feijao (1a safra) | 25 de agosto | Inicio safra feijao |
| Feijao (2a safra) | 15 de janeiro | Apos soja precoce |
| Trigo | 15 de maio | Meio da janela ideal inverno |
| Cevada | 20 de junho | Inicio inverno, antes da geada forte |
| Aveia preta | 15 de abril | Cobertura — plantio outono |

---

## 5. Regras de Rotacao SOAL

- **25-30% da area total em gramineas todo ano** (milho, trigo, aveia) para quebrar ciclo de doencas
- **Historico de patogenos por talhao** orienta decisao (ex: esclerotinia no LAGARTO, nao no MASSACRE)
- **Capinzal** = cultura unica (100% milho OU 100% soja) por distancia operacional
- **Ervilha forrageira** = novidade safra 26/27, recomendacao Fundacao ABC para cobertura pre-milho
- **Aveia preta** = semente multiplicada internamente, usada como cobertura inverno

---

## Fontes

- [Calendario Agricola 2026 — Alta Defensivos](https://altadefensivos.com.br/noticia/calendario-agricola/)
- [Safra 2025/2026 — Secretaria Agricultura PR](https://www.agricultura.pr.gov.br/Noticia/Safra-20252026-avanca-no-Parana-com-destaque-para-soja-milho-e-feijao)
- [ZARC Parana — Sistema FAEP](https://www.sistemafaep.org.br/mapa-divulga-zoneamento-agricola-parana/)
- [Zoneamento milho safrinha PR — FAEP](https://www.sistemafaep.org.br/zoneamento-do-milho-safrinha-e-prorrogado-para-100-municipios-do-parana/)
- [Cevada Campos Gerais — Revista Cultivar](https://revistacultivar.com.br/noticias/plantio-de-cevada-se-torna-alternativa-lucrativa-para-agricultores-dos-campos-gerais)
- [Castrolanda safra verao recorde — BNT](https://bntonline.com.br/castrolanda-estima-safra-de-verao-recorde-com-548-mil-toneladas-de-graos/)
- [Calendario de Safras — SIFRECA/ESALQ](https://sifreca.esalq.usp.br/calendario-de-safras)
- [CONAB Calendario 2026](https://www.gov.br/conab/pt-br/assuntos/noticias/confira-o-calendario-de-2026-de-levantamentos-das-safras-agricolas-e-do-mercado-hortigranjeiro)
- [Cevada Parana 334 mil ton — Governo PR](https://www.parana.pr.gov.br/aen/Noticia/Com-previsao-de-atingir-334-mil-toneladas-plantio-de-cevada-avanca-no-Parana)

---

*Criado: 2026-03-06 | DeepWork AI Flows*
