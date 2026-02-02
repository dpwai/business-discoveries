# Integrações Fiscais - SEFAZ e LCDPR

**Data:** 27/01/2026
**Escopo:** Documentação técnica para implementação no DPWAI

---

## 1. VISÃO GERAL DAS OBRIGAÇÕES FISCAIS DO PRODUTOR RURAL

### 1.1 Obrigações Principais

| Obrigação | Descrição | Obrigatório para |
|-----------|-----------|------------------|
| **NFe** | Nota Fiscal Eletrônica | Venda de produtos agrícolas |
| **NFe Resumida** | Notas recebidas de terceiros | Todos (para controle) |
| **MDFe** | Manifesto de transporte | Quem transporta produção |
| **LCDPR** | Livro Caixa Digital | Receita > R$ 4,8 milhões/ano |
| **DIRPF** | Imposto de Renda | Todos com atividade rural |

### 1.2 Cronograma Anual

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  CALENDÁRIO FISCAL DO PRODUTOR RURAL                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  JANEIRO-DEZEMBRO (Durante o ano)                                       │
│  ├── Emissão de NFe para vendas                                         │
│  ├── Recebimento de NFe de compras                                      │
│  ├── Lançamentos no Livro Caixa                                         │
│  └── Emissão de MDFe (se transportar)                                   │
│                                                                          │
│  JANEIRO-FEVEREIRO (Ano seguinte)                                       │
│  └── Organização e fechamento dos lançamentos                           │
│                                                                          │
│  MARÇO                                                                   │
│  └── Início do prazo para entrega IRPF                                  │
│                                                                          │
│  ABRIL (até dia 30)                                                     │
│  └── Prazo final LCDPR (receita > R$ 4,8 mi)                            │
│                                                                          │
│  MAIO (até dia 31)                                                      │
│  └── Prazo final DIRPF                                                  │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. INTEGRAÇÃO NFe (NOTA FISCAL ELETRÔNICA)

### 2.1 Arquitetura da SEFAZ

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      ARQUITETURA NFe BRASIL                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│                    ┌─────────────────────────┐                          │
│                    │    SEFAZ NACIONAL       │                          │
│                    │    (Ambiente Nacional)  │                          │
│                    └───────────┬─────────────┘                          │
│                                │                                         │
│          ┌─────────────────────┼─────────────────────┐                  │
│          │                     │                     │                  │
│          ▼                     ▼                     ▼                  │
│   ┌─────────────┐      ┌─────────────┐      ┌─────────────┐            │
│   │  SVAN       │      │  SVRS       │      │  SEFAZ      │            │
│   │ (Virtual    │      │ (Virtual    │      │ Própria     │            │
│   │  Nacional)  │      │  RS)        │      │ (SP, MG,    │            │
│   │             │      │             │      │  GO, etc)   │            │
│   │ AM, BA, CE, │      │ AC, AL, AP, │      │             │            │
│   │ MA, PA, PE, │      │ DF, ES, PB, │      │ SP, MG, GO, │            │
│   │ PI, RN      │      │ RJ, RO, RR, │      │ RS, PR, MT, │            │
│   │             │      │ SC, SE, TO  │      │ MS, BA      │            │
│   └─────────────┘      └─────────────┘      └─────────────┘            │
│                                                                          │
│   CONTINGÊNCIA:                                                         │
│   ├── SVC-AN (SEFAZ Virtual Contingência - Ambiente Nacional)           │
│   └── SVC-RS (SEFAZ Virtual Contingência - RS)                          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Webservices da NFe

| Serviço | Descrição | Endpoint (Produção) |
|---------|-----------|---------------------|
| NfeAutorizacao | Envio de lote de NFe | `nfe.fazenda.gov.br/NFeAutorizacao4` |
| NfeRetAutorizacao | Consulta resultado do lote | `nfe.fazenda.gov.br/NFeRetAutorizacao4` |
| NfeConsultaProtocolo | Consulta NFe por chave | `nfe.fazenda.gov.br/NFeConsultaProtocolo4` |
| NfeInutilizacao | Inutilização de numeração | `nfe.fazenda.gov.br/NFeInutilizacao4` |
| NfeRecepcaoEvento | Eventos (cancelamento, CCe) | `nfe.fazenda.gov.br/NFeRecepcaoEvento4` |
| NfeStatusServico | Status do serviço | `nfe.fazenda.gov.br/NFeStatusServico4` |
| NfeDistribuicaoDFe | Consulta NFe destinatário | `nfe.fazenda.gov.br/NFeDistribuicaoDFe` |

### 2.3 Fluxo de Emissão de NFe

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUXO DE EMISSÃO DE NFe                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. MONTAGEM DO XML                                                     │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │ - Dados do emitente (CNPJ, IE, endereço)                    │    │
│     │ - Dados do destinatário                                      │    │
│     │ - Produtos (NCM, CFOP, valores)                              │    │
│     │ - Impostos (ICMS, PIS, COFINS)                               │    │
│     │ - Totais                                                      │    │
│     │ - Transporte                                                  │    │
│     │ - Informações adicionais                                      │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                           │                                             │
│                           ▼                                             │
│  2. ASSINATURA DIGITAL                                                  │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │ - Carrega certificado A1 (.pfx)                             │    │
│     │ - Extrai chave privada                                       │    │
│     │ - Assina XML com SHA-256 + RSA                               │    │
│     │ - Adiciona assinatura ao XML                                 │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                           │                                             │
│                           ▼                                             │
│  3. ENVIO PARA SEFAZ                                                    │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │ - Identifica SEFAZ autorizadora (por UF)                    │    │
│     │ - Monta envelope SOAP                                        │    │
│     │ - Envia via HTTPS com certificado                            │    │
│     │ - Recebe número do recibo                                    │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                           │                                             │
│                           ▼                                             │
│  4. CONSULTA RESULTADO                                                  │
│     ┌─────────────────────────────────────────────────────────────┐    │
│     │ - Consulta NFeRetAutorizacao com recibo                     │    │
│     │ - Aguarda resposta (pode demorar alguns segundos)           │    │
│     │ - Recebe protocolo de autorização ou rejeição               │    │
│     └─────────────────────────────────────────────────────────────┘    │
│                           │                                             │
│             ┌─────────────┴─────────────┐                              │
│             │                           │                              │
│             ▼                           ▼                              │
│     ┌─────────────┐             ┌─────────────┐                        │
│     │ AUTORIZADA  │             │ REJEITADA   │                        │
│     │             │             │             │                        │
│     │ - Salva XML │             │ - Verifica  │                        │
│     │   autorizado│             │   motivo    │                        │
│     │ - Gera DANFE│             │ - Corrige   │                        │
│     │ - Armazena  │             │ - Reenvia   │                        │
│     └─────────────┘             └─────────────┘                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.4 Certificado Digital A1

| Característica | Descrição |
|----------------|-----------|
| **Tipo** | A1 (arquivo .pfx) |
| **Validade** | 1 ano |
| **Custo** | ~R$ 150-250/ano |
| **Armazenamento** | Arquivo no servidor |
| **Senha** | PIN para abrir o certificado |

```typescript
// Exemplo de uso do certificado A1 em Node.js
import { readFileSync } from 'fs';
import forge from 'node-forge';

function loadCertificate(pfxPath: string, password: string) {
  const pfxBuffer = readFileSync(pfxPath);
  const pfxBase64 = pfxBuffer.toString('base64');
  const pfxAsn1 = forge.asn1.fromDer(forge.util.decode64(pfxBase64));
  const pfx = forge.pkcs12.pkcs12FromAsn1(pfxAsn1, password);

  // Extrai certificado
  const certBag = pfx.getBags({ bagType: forge.pki.oids.certBag })[forge.pki.oids.certBag];
  const certificate = certBag[0].cert;

  // Extrai chave privada
  const keyBag = pfx.getBags({ bagType: forge.pki.oids.pkcs8ShroudedKeyBag })[forge.pki.oids.pkcs8ShroudedKeyBag];
  const privateKey = keyBag[0].key;

  return { certificate, privateKey };
}
```

### 2.5 Bibliotecas Recomendadas

**Para Node.js/TypeScript:**

| Biblioteca | Tipo | GitHub |
|------------|------|--------|
| **node-nfe** | Open Source | github.com/fazendajs/node-nfe |
| **sped-nfe** | Open Source | github.com/nfephp-org/sped-nfe (PHP) |
| **Focus NFe** | API SaaS | focusnfe.com.br |
| **NFe.io** | API SaaS | nfe.io |
| **Webmania** | API SaaS | webmania.com.br |

**Recomendação:** Para MVP, usar **Focus NFe** ou **NFe.io** (APIs prontas). Para produção em escala, implementar com biblioteca open source.

### 2.6 Exemplo de Integração com Focus NFe

```typescript
// lib/integrations/sefaz/focus-nfe.ts
const FOCUS_NFE_BASE = 'https://api.focusnfe.com.br/v2';
const FOCUS_NFE_TOKEN = process.env.FOCUS_NFE_TOKEN;

interface NFeData {
  natureza_operacao: string;
  forma_pagamento: string;
  tipo_documento: string;
  finalidade_emissao: string;
  cnpj_emitente: string;
  nome_emitente: string;
  // ... outros campos
}

export async function emitirNFe(nfe: NFeData): Promise<{ ref: string; status: string }> {
  const ref = `nfe-${Date.now()}`;

  const response = await fetch(`${FOCUS_NFE_BASE}/nfe?ref=${ref}`, {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${Buffer.from(FOCUS_NFE_TOKEN + ':').toString('base64')}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(nfe),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Erro ao emitir NFe: ${error.message}`);
  }

  return response.json();
}

export async function consultarNFe(ref: string): Promise<any> {
  const response = await fetch(`${FOCUS_NFE_BASE}/nfe/${ref}`, {
    headers: {
      'Authorization': `Basic ${Buffer.from(FOCUS_NFE_TOKEN + ':').toString('base64')}`,
    },
  });

  return response.json();
}

export async function baixarXml(ref: string): Promise<string> {
  const response = await fetch(`${FOCUS_NFE_BASE}/nfe/${ref}.xml`, {
    headers: {
      'Authorization': `Basic ${Buffer.from(FOCUS_NFE_TOKEN + ':').toString('base64')}`,
    },
  });

  return response.text();
}

export async function baixarDanfe(ref: string): Promise<Buffer> {
  const response = await fetch(`${FOCUS_NFE_BASE}/nfe/${ref}.pdf`, {
    headers: {
      'Authorization': `Basic ${Buffer.from(FOCUS_NFE_TOKEN + ':').toString('base64')}`,
    },
  });

  return Buffer.from(await response.arrayBuffer());
}
```

---

## 3. NFe RESUMIDA (DISTRIBUIÇÃO DFe)

### 3.1 O que é

A NFe Resumida permite que o produtor consulte todas as NFe que foram emitidas PARA ele (como destinatário), mesmo que ele não tenha recebido a nota fisicamente.

### 3.2 Webservice de Distribuição

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUXO NFe RESUMIDA                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  1. Fornecedor emite NFe para o produtor                                │
│     ┌──────────────────────────────────────────────────┐               │
│     │ Fornecedor (CNPJ) → NFe → Produtor (CPF/CNPJ)   │               │
│     └──────────────────────────────────────────────────┘               │
│                           │                                             │
│                           ▼                                             │
│  2. SEFAZ armazena na base de distribuição                              │
│     ┌──────────────────────────────────────────────────┐               │
│     │ Base DFe: NFe disponível para o destinatário    │               │
│     └──────────────────────────────────────────────────┘               │
│                           │                                             │
│                           ▼                                             │
│  3. Produtor consulta via webservice                                    │
│     ┌──────────────────────────────────────────────────┐               │
│     │ NFeDistribuicaoDFe (consulta por CNPJ/CPF)      │               │
│     │                                                  │               │
│     │ Parâmetros:                                      │               │
│     │ - ultNSU: Último NSU recebido (paginação)       │               │
│     │ - distNSU: NSU específico                        │               │
│     │ - consChNFe: Consulta por chave de acesso       │               │
│     └──────────────────────────────────────────────────┘               │
│                           │                                             │
│                           ▼                                             │
│  4. Retorna lista de documentos                                         │
│     ┌──────────────────────────────────────────────────┐               │
│     │ - resNFe: Resumo da NFe                          │               │
│     │ - resEvento: Eventos (cancelamento, etc)        │               │
│     │ - procNFe: XML completo (após manifestação)     │               │
│     └──────────────────────────────────────────────────┘               │
│                           │                                             │
│                           ▼                                             │
│  5. Produtor pode manifestar ciência                                    │
│     ┌──────────────────────────────────────────────────┐               │
│     │ Eventos de manifestação:                         │               │
│     │ - Ciência da Operação                            │               │
│     │ - Confirmação da Operação                        │               │
│     │ - Operação Não Realizada                         │               │
│     │ - Desconhecimento da Operação                    │               │
│     └──────────────────────────────────────────────────┘               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Exemplo de Consulta

```typescript
// lib/integrations/sefaz/distribuicao-dfe.ts
import { SignedXml } from 'xml-crypto';
import { readFileSync } from 'fs';

const DISTRIBUICAO_URL = 'https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx';

interface DistDFeRequest {
  cnpjCpf: string;
  ultNSU?: string;
}

export async function consultarNFeRecebidas(params: DistDFeRequest): Promise<any[]> {
  const xml = `
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
      <soap:Body>
        <nfeDistDFeInteresse xmlns="http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe">
          <nfeDadosMsg>
            <distDFeInt xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.01">
              <tpAmb>1</tpAmb>
              <cUFAutor>41</cUFAutor>
              <CNPJ>${params.cnpjCpf}</CNPJ>
              <distNSU>
                <ultNSU>${params.ultNSU || '000000000000000'}</ultNSU>
              </distNSU>
            </distDFeInt>
          </nfeDadosMsg>
        </nfeDistDFeInteresse>
      </soap:Body>
    </soap:Envelope>
  `;

  // Assinar XML e enviar...
  // (implementação completa requer certificado)

  return [];
}
```

---

## 4. LCDPR (LIVRO CAIXA DIGITAL DO PRODUTOR RURAL)

### 4.1 Obrigatoriedade

| Receita Bruta Anual | LCDPR Obrigatório |
|---------------------|-------------------|
| Até R$ 4,8 milhões | Não |
| Acima de R$ 4,8 milhões | **SIM** |

### 4.2 Prazo de Entrega

| Ano-calendário | Prazo de Entrega |
|----------------|------------------|
| 2024 | 30/04/2025 |
| 2025 | 30/04/2026 |

### 4.3 Estrutura do Arquivo

O LCDPR é um arquivo TXT com layout específico da Receita Federal.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    ESTRUTURA DO ARQUIVO LCDPR                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  BLOCO 0 - ABERTURA                                                     │
│  ├── 0000 - Abertura do arquivo                                         │
│  ├── 0010 - Dados do contribuinte                                       │
│  ├── 0030 - Dados cadastrais                                            │
│  ├── 0040 - Imóveis rurais                                              │
│  └── 0045 - Participantes do imóvel                                     │
│                                                                          │
│  BLOCO Q - DEMONSTRATIVO DO RESULTADO                                   │
│  ├── Q100 - Demonstrativo do resultado da atividade rural               │
│  └── Q200 - Resumo mensal                                               │
│                                                                          │
│  BLOCO 9 - CONTROLE E ENCERRAMENTO                                      │
│  └── 9999 - Encerramento do arquivo                                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.4 Registro Q100 (Principal)

| Campo | Descrição | Tamanho | Tipo |
|-------|-----------|---------|------|
| REG | Identificador (Q100) | 4 | C |
| DT_OPER | Data da operação | 8 | N |
| TP_OPER | Tipo (1=Receita, 2=Despesa) | 1 | N |
| NR_DOC | Número do documento | 20 | C |
| HIST | Histórico | 200 | C |
| VL_OPER | Valor da operação | 17 | N |
| CAD_IMV | Código do imóvel | 8 | C |
| COD_CONTA | Código da conta | 4 | C |
| CPF_CNPJ | CPF/CNPJ do participante | 14 | C |
| NM_PART | Nome do participante | 60 | C |

### 4.5 Tabela de Contas LCDPR

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    TABELA DE CONTAS LCDPR                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  RECEITAS (Tipo 1)                                                      │
│  ├── 1.1 - Venda de produtos agrícolas                                  │
│  ├── 1.2 - Venda de produtos pecuários                                  │
│  ├── 1.3 - Venda de produtos extrativos                                 │
│  ├── 1.4 - Prestação de serviços rurais                                 │
│  ├── 1.5 - Arrendamento rural                                           │
│  ├── 1.6 - Outras receitas                                              │
│  └── 1.7 - Financiamentos rurais recebidos                              │
│                                                                          │
│  DESPESAS (Tipo 2)                                                      │
│  ├── 2.1 - Mão de obra                                                  │
│  │   ├── 2.1.1 - Salários                                               │
│  │   ├── 2.1.2 - Encargos sociais                                       │
│  │   └── 2.1.3 - Diaristas                                              │
│  ├── 2.2 - Insumos                                                      │
│  │   ├── 2.2.1 - Sementes e mudas                                       │
│  │   ├── 2.2.2 - Fertilizantes                                          │
│  │   ├── 2.2.3 - Defensivos                                             │
│  │   └── 2.2.4 - Combustíveis                                           │
│  ├── 2.3 - Serviços de terceiros                                        │
│  ├── 2.4 - Manutenção de máquinas                                       │
│  ├── 2.5 - Depreciação                                                  │
│  ├── 2.6 - Arrendamento pago                                            │
│  ├── 2.7 - Juros e encargos financeiros                                 │
│  └── 2.8 - Outras despesas                                              │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 4.6 Exemplo de Geração do Arquivo

```typescript
// lib/fiscal/lcdpr-generator.ts

interface LcdprRegistro {
  data: Date;
  tipo: 'RECEITA' | 'DESPESA';
  numeroDocumento: string;
  historico: string;
  valor: number;
  codigoImovel: string;
  codigoConta: string;
  cpfCnpjParticipante: string;
  nomeParticipante: string;
}

interface DadosContribuinte {
  cpf: string;
  nome: string;
  imoveis: {
    codigo: string;
    nome: string;
    municipio: string;
    uf: string;
    area: number;
  }[];
}

export function gerarArquivoLCDPR(
  anoCalendario: number,
  contribuinte: DadosContribuinte,
  registros: LcdprRegistro[]
): string {
  const linhas: string[] = [];

  // BLOCO 0 - ABERTURA
  // 0000 - Abertura do arquivo
  linhas.push(`|0000|LCDPR|${anoCalendario}0101|${anoCalendario}1231|${contribuinte.cpf}|${contribuinte.nome}|`);

  // 0010 - Dados do contribuinte
  linhas.push(`|0010|${contribuinte.cpf}|${contribuinte.nome}|`);

  // 0040 - Imóveis rurais
  for (const imovel of contribuinte.imoveis) {
    linhas.push(`|0040|${imovel.codigo}|${imovel.nome}|${imovel.municipio}|${imovel.uf}|${formatNumber(imovel.area, 10, 2)}|`);
  }

  // BLOCO Q - DEMONSTRATIVO
  // Q100 - Lançamentos
  for (const reg of registros) {
    const tipoOper = reg.tipo === 'RECEITA' ? '1' : '2';
    const dataOper = formatDate(reg.data);
    const valor = formatNumber(reg.valor, 15, 2);

    linhas.push(`|Q100|${dataOper}|${tipoOper}|${reg.numeroDocumento.padEnd(20)}|${reg.historico.substring(0, 200)}|${valor}|${reg.codigoImovel}|${reg.codigoConta}|${reg.cpfCnpjParticipante}|${reg.nomeParticipante}|`);
  }

  // Q200 - Resumo mensal
  const resumoMensal = calcularResumoMensal(registros);
  for (const resumo of resumoMensal) {
    linhas.push(`|Q200|${resumo.mes}|${formatNumber(resumo.receitas, 15, 2)}|${formatNumber(resumo.despesas, 15, 2)}|${formatNumber(resumo.saldo, 15, 2)}|`);
  }

  // BLOCO 9 - ENCERRAMENTO
  linhas.push(`|9999|${linhas.length + 1}|`);

  return linhas.join('\n');
}

function formatDate(date: Date): string {
  const day = String(date.getDate()).padStart(2, '0');
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const year = date.getFullYear();
  return `${day}${month}${year}`;
}

function formatNumber(value: number, intDigits: number, decDigits: number): string {
  const [int, dec] = value.toFixed(decDigits).split('.');
  return int.padStart(intDigits, '0') + (dec || '');
}

function calcularResumoMensal(registros: LcdprRegistro[]) {
  const meses: { [key: string]: { receitas: number; despesas: number } } = {};

  for (const reg of registros) {
    const mes = `${reg.data.getMonth() + 1}`.padStart(2, '0') + reg.data.getFullYear();
    if (!meses[mes]) {
      meses[mes] = { receitas: 0, despesas: 0 };
    }
    if (reg.tipo === 'RECEITA') {
      meses[mes].receitas += reg.valor;
    } else {
      meses[mes].despesas += reg.valor;
    }
  }

  return Object.entries(meses).map(([mes, valores]) => ({
    mes,
    receitas: valores.receitas,
    despesas: valores.despesas,
    saldo: valores.receitas - valores.despesas,
  }));
}
```

### 4.7 Entrega do LCDPR

1. Gerar arquivo TXT conforme layout
2. Assinar com certificado digital (A1 ou A3)
3. Acessar e-CAC (Centro de Atendimento Virtual)
4. Menu: Declarações e Demonstrativos > LCDPR
5. Fazer upload do arquivo
6. Sistema valida e retorna protocolo

---

## 5. MDFe (MANIFESTO DE DOCUMENTOS FISCAIS)

### 5.1 Quando é Obrigatório

| Situação | MDFe Obrigatório |
|----------|------------------|
| Transporte interestadual | SIM |
| Transporte intermunicipal (PR, SP, MG, RS, SC) | SIM |
| Veículo próprio | SIM |
| Terceiro transportador | NÃO (ele emite) |

### 5.2 Estrutura Similar à NFe

O MDFe segue a mesma arquitetura da NFe:
- XML com estrutura definida
- Assinatura digital
- Envio para SEFAZ
- Eventos (encerramento, cancelamento)

---

## 6. PLANO DE IMPLEMENTAÇÃO PARA DPWAI

### 6.1 Fase 1: NFe Básica (2-3 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 1: NFe BÁSICA                                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Semana 1:                                                              │
│  ├── [ ] Integração com Focus NFe ou NFe.io (API)                      │
│  ├── [ ] Modelo de dados para NFe                                       │
│  ├── [ ] Upload e gestão de certificado A1                             │
│  └── [ ] API para emissão de NFe                                        │
│                                                                          │
│  Semana 2:                                                              │
│  ├── [ ] Interface de emissão de NFe                                    │
│  ├── [ ] Listagem de NFe emitidas                                       │
│  ├── [ ] Download de XML e DANFE                                        │
│  └── [ ] Cancelamento de NFe                                            │
│                                                                          │
│  Semana 3:                                                              │
│  ├── [ ] Testes de integração                                           │
│  ├── [ ] Tratamento de erros e rejeições                               │
│  └── [ ] Documentação                                                    │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Fase 2: NFe Resumida (1-2 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 2: NFe RESUMIDA                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ├── [ ] Consulta ao webservice NFeDistribuicaoDFe                     │
│  ├── [ ] Armazenamento de notas recebidas                               │
│  ├── [ ] Interface de listagem                                          │
│  ├── [ ] Manifestação do destinatário                                   │
│  └── [ ] Sincronização automática (cron job)                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 6.3 Fase 3: LCDPR (2-3 semanas)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 3: LCDPR                                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Semana 1:                                                              │
│  ├── [ ] Tabela de categorias de conta LCDPR                           │
│  ├── [ ] Vinculação de lançamentos com NFe                             │
│  └── [ ] Cadastro de imóveis rurais                                     │
│                                                                          │
│  Semana 2:                                                              │
│  ├── [ ] Gerador de arquivo TXT                                         │
│  ├── [ ] Validador de consistência                                      │
│  ├── [ ] Interface de revisão                                           │
│  └── [ ] Download do arquivo                                            │
│                                                                          │
│  Semana 3:                                                              │
│  ├── [ ] Assinatura digital do arquivo                                  │
│  ├── [ ] Testes com arquivo real                                        │
│  └── [ ] Documentação de uso                                            │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## FONTES E REFERÊNCIAS

- [Portal Nacional NFe](https://www.nfe.fazenda.gov.br/)
- [SPED - Receita Federal](http://sped.rfb.gov.br/)
- [LCDPR - Receita Federal](https://www.gov.br/receitafederal/pt-br/assuntos/orientacao-tributaria/declaracoes-e-demonstrativos/lcdpr-livro-caixa-digital-do-produtor-rural)
- [Focus NFe - Documentação](https://focusnfe.com.br/doc/)
- [NFe.io - Documentação](https://nfe.io/)
- [GitHub - sped-nfe](https://github.com/nfephp-org/sped-nfe)
- [TOTVS - LCDPR](https://www.totvs.com/blog/gestao-agricola/lcdpr/)
- [Aegro - IR e LCDPR 2025](https://aegro.com.br/blog/entrega-do-ir-e-livro-caixa-do-produtor-rural-2025/)

---

*Documentação técnica para implementação. Consulte sempre as fontes oficiais para informações atualizadas.*
