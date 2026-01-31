# 🤖 Guia Completo: IA, Agentes, Skills e MCP

> **Para:** Rodrigo Kugler  
> **De:** Muffin 🤖 (bot do João)  
> **Objetivo:** Entender 100% como funcionam os agentes de IA e já começar a usar

---

## 📚 PARTE 1: Entendendo os Conceitos

### 🤖 O que é um AGENTE de IA?

**Analogia:** Pense num **estagiário super inteligente** que:
- Entende o que você pede em português normal
- Sabe usar várias ferramentas (computador, internet, programas)
- Pode trabalhar sozinho em tarefas complexas
- Pede ajuda quando não sabe algo

**Eu (Muffin) sou um agente!** O João me configurou pra:
- Ler e escrever código
- Acessar repositórios do GitHub
- Mandar mensagens no WhatsApp
- Criar arquivos e documentos
- E muito mais...

**Diferença de um ChatGPT normal:**
| ChatGPT Normal | Agente (como eu) |
|----------------|------------------|
| Só conversa | Conversa + FAZ coisas |
| Não lembra de você | Tem memória persistente |
| Não acessa seus arquivos | Acessa arquivos, código, APIs |
| Responde e acabou | Pode executar tarefas longas |

---

### 🛠️ O que são SKILLS (Habilidades)?

**Analogia:** São como **cursos rápidos** que um agente pode fazer.

Exemplo: Eu tenho uma skill de GitHub que me ensina:
- Como criar repositórios
- Como fazer commits
- Como abrir Pull Requests
- Quais comandos usar

**Skills são arquivos de texto** que ensinam o agente a fazer algo específico. Quando o João me pede algo relacionado a GitHub, eu automaticamente "leio" minha skill de GitHub pra saber como fazer.

**Exemplos de Skills:**
- Skill de Email → Saber ler/enviar emails
- Skill de Figma → Saber interpretar designs
- Skill de Código → Saber programar em linguagens específicas

---

### 🔌 O que é MCP (Model Context Protocol)?

**Analogia:** MCP é como um **cabo USB universal** que conecta a IA a qualquer ferramenta.

Antes do MCP:
```
IA ←→ Código customizado ←→ Figma
IA ←→ Outro código ←→ Google Drive
IA ←→ Mais código ←→ GitHub
(cada conexão precisava de código diferente)
```

Com MCP:
```
IA ←→ MCP ←→ Figma
          ←→ Google Drive
          ←→ GitHub
          ←→ Qualquer coisa
(uma única forma de conectar tudo)
```

**Em termos simples:**
- MCP é um **padrão** que permite que IAs acessem ferramentas externas
- Alguém cria um "servidor MCP" pro Figma, outro pro Google Drive, etc.
- A IA usa esses servidores pra acessar as ferramentas
- Você só precisa configurar UMA VEZ e funciona

---

### 🎯 Resumo Visual

```
┌─────────────────────────────────────────────────────┐
│                    VOCÊ (Rodrigo)                    │
│              "Implementa esse dashboard"             │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│                  AGENTE (Muffin)                     │
│    • Entende o pedido                               │
│    • Usa SKILLS pra saber como fazer                │
│    • Conecta via MCP nas ferramentas                │
└─────────────────────┬───────────────────────────────┘
                      │
         ┌────────────┼────────────┐
         │            │            │
         ▼            ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │  Figma  │  │ GitHub  │  │ G.Drive │
    │  (MCP)  │  │  (MCP)  │  │  (MCP)  │
    └─────────┘  └─────────┘  └─────────┘
```

---

## 📋 PARTE 2: Tutoriais Práticos

### 🎨 TUTORIAL 1: Conectar Figma (Framelink MCP)

**O que isso permite:** Você cola um link do Figma e eu vejo todo o design (cores, fontes, espaçamentos).

#### Passo 1: Gerar Token no Figma

1. Abra **figma.com** e faça login
2. Clique no seu **avatar** (canto superior esquerdo)
3. Clique em **Settings**
4. No menu lateral, clique em **Security**
5. Role até **Personal access tokens**
6. Clique em **Generate new token**
7. Configure:
   - **Nome:** `Muffin Bot`
   - **Expiration:** No expiration
   - **File content:** ✅ Read-only
   - **Dev resources:** ✅ Read-only
8. Clique em **Generate token**
9. **COPIE O TOKEN** (só aparece uma vez!)

#### Passo 2: Me enviar o token

Manda no WhatsApp (privado pro João ou no grupo):
```
Token Figma: figd_XXXXXXXXXXXXXXXXXX
```

#### Passo 3: Usar

Depois que o João configurar:
1. No Figma: botão direito no frame → **Copy link to selection**
2. No WhatsApp: "Muffin, implementa: [cola o link]"

---

### 📁 TUTORIAL 2: Conectar Google Drive (MCP)

**O que isso permite:** Eu acesso seus arquivos do Drive direto (reuniões do Meet, documentos, etc.) sem você precisar fazer upload.

#### Passo 1: Criar projeto no Google Cloud

1. Acesse: **https://console.cloud.google.com/**
2. Faça login com sua conta Google (a mesma do Drive)
3. Clique em **Select a project** (topo da tela)
4. Clique em **New Project**
5. Nome: `Muffin MCP`
6. Clique em **Create**

#### Passo 2: Ativar a API do Google Drive

1. No menu lateral, vá em **APIs & Services** → **Library**
2. Pesquise por **Google Drive API**
3. Clique nela e depois em **Enable**

#### Passo 3: Configurar tela de consentimento OAuth

1. Vá em **APIs & Services** → **OAuth consent screen**
2. Escolha **External** (ou Internal se for G Suite)
3. Clique em **Create**
4. Preencha:
   - **App name:** `Muffin MCP`
   - **User support email:** seu email
   - **Developer contact:** seu email
5. Clique em **Save and Continue**
6. Em **Scopes**, clique em **Add or Remove Scopes**
7. Procure e marque: `https://www.googleapis.com/auth/drive.readonly`
8. Clique em **Update** e depois **Save and Continue**
9. Em **Test users**, adicione seu email
10. Clique em **Save and Continue**

#### Passo 4: Criar credenciais OAuth

1. Vá em **APIs & Services** → **Credentials**
2. Clique em **Create Credentials** → **OAuth client ID**
3. **Application type:** Desktop app
4. **Name:** `Muffin MCP`
5. Clique em **Create**
6. **BAIXE O JSON** (botão de download)
7. Renomeie o arquivo para `gcp-oauth.keys.json`

#### Passo 5: Me enviar o arquivo

Manda o arquivo `gcp-oauth.keys.json` pro João pelo WhatsApp ou email.

#### Passo 6: Autorizar acesso

O João vai te mandar um link. Clique nele, faça login e autorize o acesso.

#### Pronto!

Depois disso, você pode pedir:
- "Muffin, lista os arquivos na pasta X do Drive"
- "Muffin, lê a transcrição da reunião de ontem"
- "Muffin, busca no Drive por 'SOAL dashboard'"

---

### 💻 TUTORIAL 3: Acessar o Repositório business-discoveries

**Esse já funciona!** Eu já tenho acesso ao repo via GitHub.

Você pode pedir coisas como:
- "Muffin, lista os dashboards do projeto SOAL"
- "Muffin, lê o arquivo FIGMA_PROMPT_Dashboard_01.md"
- "Muffin, cria um novo documento no repo"

O João me configurou com uma conta GitHub própria (`muffin-o-bot`).

---

## 🎯 PARTE 3: Como Usar na Prática

### Fluxo de Trabalho com Dashboards

```
1. VOCÊ desenha no Figma
   ↓
2. VOCÊ copia o link do frame
   ↓
3. VOCÊ manda: "Muffin, implementa esse dashboard: [link]"
   ↓
4. EU leio o design via MCP Figma
   ↓
5. EU leio as specs do repo (business-discoveries)
   ↓
6. EU implemento o código no dpwai-app
   ↓
7. EU faço commit no GitHub
   ↓
8. VOCÊ revisa e aprova
```

### Fluxo com Reuniões do Meet

```
1. VOCÊ faz a reunião no Meet (grava)
   ↓
2. Google salva a transcrição no Drive
   ↓
3. VOCÊ pede: "Muffin, resume a reunião de hoje sobre SOAL"
   ↓
4. EU acesso o Drive via MCP
   ↓
5. EU leio a transcrição
   ↓
6. EU faço um resumo com action items
   ↓
7. VOCÊ usa o resumo pra próximos passos
```

---

## ❓ FAQ - Perguntas Frequentes

### "É seguro dar esses acessos?"

**Sim!** Todos os tokens são de **somente leitura** (read-only). Eu não consigo:
- Deletar seus arquivos
- Editar seus designs no Figma
- Apagar coisas do Drive

Só consigo **ver** pra poder ajudar.

### "Preciso pagar algo?"

**Não!** Todos esses serviços (Figma API, Google Cloud, GitHub) têm planos gratuitos que são suficientes pro nosso uso.

### "E se eu quiser revogar o acesso?"

É só deletar o token:
- **Figma:** Settings → Security → Personal access tokens → Delete
- **Google:** console.cloud.google.com → Credentials → Delete

### "Quanto tempo leva pra configurar?"

- Figma MCP: ~5 minutos
- Google Drive MCP: ~15 minutos
- GitHub: Já configurado!

### "Funciona com qualquer arquivo do Figma/Drive?"

Funciona com arquivos que **você tem acesso**. Se for de um time/organização, você precisa ter permissão de visualização.

---

## 🚀 Próximos Passos

### Para Você (Rodrigo):

1. **Agora:** Configure o token do Figma (Tutorial 1 - 5 min)
2. **Depois:** Configure o Google Drive (Tutorial 2 - 15 min)
3. **Manda** os tokens/arquivos pro João

### Para Mim (Muffin):

1. Assim que receber os tokens, eu configuro tudo
2. Te aviso quando estiver pronto
3. A gente testa juntos!

---

## 📞 Dúvidas?

Manda mensagem no grupo ou diretamente pro João. Estou aqui pra ajudar! 🤖

---

*Guia criado pelo Muffin em 31/01/2026*
*Última atualização: 31/01/2026*
