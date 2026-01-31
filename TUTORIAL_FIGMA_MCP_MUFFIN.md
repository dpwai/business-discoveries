# 🎨 Como Conectar seu Figma com o Muffin (Bot de IA)

> **Para:** Rodrigo Kugler  
> **De:** Muffin 🤖 (o bot do João)  
> **O que é isso:** Um tutorial pra você me dar acesso aos seus designs do Figma

---

## 🤔 Por que fazer isso?

Quando você me conectar ao Figma, eu vou conseguir:
- ✅ Ver seus designs diretamente (cores, fontes, tamanhos, espaçamentos)
- ✅ Implementar componentes no código com muito mais precisão
- ✅ Você só cola um link do Figma e eu já entendo tudo

**Antes:** Você descreve o design em texto → eu tento adivinhar → pode sair errado  
**Depois:** Você cola o link → eu vejo exatamente o que você fez → código perfeito

---

## 📋 Tutorial Passo a Passo

### PASSO 1: Abrir as Configurações do Figma

1. Abra o **Figma** no navegador: [figma.com](https://www.figma.com)
2. Faça login na sua conta
3. Olhe no **canto superior esquerdo** - tem seu avatar/foto
4. **Clique no seu avatar**
5. No menu que abrir, clique em **"Settings"**

![Onde clicar](https://help.figma.com/hc/article_attachments/4404157507351)

---

### PASSO 2: Ir na Aba de Segurança

1. Na página de Settings, olhe o **menu lateral esquerdo**
2. Procure e clique em **"Security"** (Segurança)

---

### PASSO 3: Criar o Token de Acesso

1. Role a página para baixo até achar **"Personal access tokens"**
2. Clique no botão **"Generate new token"** (botão azul)

---

### PASSO 4: Configurar o Token

Uma janela vai abrir pedindo informações:

**Token name (nome):**
```
Muffin Bot
```

**Expiration (validade):**
- Escolha **"No expiration"** (sem validade) - mais prático
- Ou escolha uma data se preferir renovar depois

**Scopes (permissões):**
Marque APENAS estas duas opções:

| Permissão | Configuração |
|-----------|--------------|
| ✅ **File content** | Selecione **"Read-only"** |
| ✅ **Dev resources** | Selecione **"Read-only"** |

> ⚠️ **Importante:** Só precisa dessas duas! Não marque "Write" em nada.

---

### PASSO 5: Gerar e Copiar o Token

1. Clique no botão **"Generate token"**
2. **ATENÇÃO:** O token vai aparecer NA TELA - **COPIE AGORA!**
3. Ele só aparece **UMA VEZ**. Se fechar sem copiar, tem que fazer de novo.

O token parece com isso:
```
figd_AbCdEfGhIjKlMnOpQrStUvWxYz1234567890abcdef
```

---

### PASSO 6: Me Enviar o Token

Manda o token pro João pelo WhatsApp (privado ou no grupo):

**Mensagem:**
```
João, token do Figma pro Muffin:
figd_XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

> 🔐 **Sobre segurança:** Esse token só dá permissão de LEITURA. Eu não consigo editar nem deletar nada no seu Figma - só ver.

---

## ✅ Pronto! E agora?

Depois que o João configurar o token no meu servidor, você pode:

### Como me pedir pra implementar um design:

1. **No Figma:** 
   - Clique com o **botão direito** no frame/componente que quer
   - Vá em **"Copy/Paste as"**
   - Clique em **"Copy link to selection"**

2. **No WhatsApp:**
   - Cola o link e me pede pra implementar

**Exemplo de mensagem:**
```
Muffin, implementa esse dashboard:
https://www.figma.com/file/abc123xyz/SOAL?node-id=123-456
```

E eu vou conseguir ver exatamente:
- As cores que você usou
- Os tamanhos das fontes
- Os espaçamentos
- A estrutura dos componentes
- Tudo!

---

## ❓ Dúvidas Frequentes

### "Perdi o token, e agora?"
Sem problema! Só gerar um novo seguindo o tutorial de novo. O antigo para de funcionar automaticamente.

### "Precisa pagar alguma coisa?"
Não! É tudo grátis. O Figma já tem essa funcionalidade de tokens.

### "É seguro?"
Sim! O token só dá acesso de leitura. Ninguém consegue editar ou deletar seus arquivos com ele.

### "Funciona com qualquer arquivo?"
Funciona com arquivos que você tem acesso. Se o arquivo for de um time/organização, o token precisa ter acesso a esse time.

---

## 🆘 Problemas?

Manda mensagem pro João ou diretamente pra mim no grupo que a gente resolve!

---

*Tutorial criado pelo Muffin 🤖 em 31/01/2026*
