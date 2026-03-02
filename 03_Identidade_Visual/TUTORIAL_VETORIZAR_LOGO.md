# 🎨 Como Vetorizar o Logo da DPWAI

> **Para:** Rodrigo Kugler  
> **Objetivo:** Transformar o logo PNG em SVG vetorial de alta qualidade

---

## 🤔 Por que vetorizar?

**PNG (atual):** Imagem pixelada, perde qualidade quando aumenta  
**SVG (queremos):** Vetor, qualidade infinita em qualquer tamanho

Com SVG você pode:
- ✅ Usar em qualquer tamanho sem perder qualidade
- ✅ Mudar cores facilmente
- ✅ Usar no site, app, impressão, onde quiser

---

## 🛠️ Método 1: Vectorizer.AI (RECOMENDADO - Mais Fácil)

### Passo 1: Acessar o site
Abra: **https://vectorizer.ai/**

### Passo 2: Fazer upload do logo
1. Clique em **"Pick Image to Vectorize"**
2. Selecione o arquivo: `assets/img/logo_mark.png` (da landing page)
3. Ou arraste o arquivo pra página

### Passo 3: Aguardar processamento
- O site usa IA pra vetorizar
- Demora alguns segundos

### Passo 4: Baixar o SVG
1. Quando terminar, clique em **"Download"**
2. Escolha formato **"SVG"**
3. Salve o arquivo

### Passo 5: Testar
Abra o SVG no navegador pra ver se ficou bom!

---

## 🛠️ Método 2: Adobe Express (Grátis)

### Passo 1: Acessar
Abra: **https://www.adobe.com/express/feature/image/convert/svg**

### Passo 2: Upload
1. Clique em **"Upload your image"**
2. Selecione o logo PNG

### Passo 3: Converter
1. Clique em **"Convert to SVG"**
2. Baixe o resultado

---

## 🛠️ Método 3: Figma (Se você já usa)

### Passo 1: Importar o PNG
1. Abra o Figma
2. Arraste o `logo_mark.png` pra um frame

### Passo 2: Usar plugin de vetorização
1. Vá em **Plugins** → **Browse plugins**
2. Procure **"Image Tracer"** ou **"Vectorize"**
3. Instale e execute no logo

### Passo 3: Exportar
1. Selecione o vetor gerado
2. **Export** → Formato **SVG**

---

## 📁 Onde salvar o SVG final?

Depois de vetorizar, salve em:
```
dpwai-landingpage/assets/logo_dpwai.svg
```

E me avise que eu atualizo nos repos:
- dpwai-app
- dpwai-landingpage
- business-discoveries

---

## ✅ Checklist do Logo Vetorizado

Quando tiver o SVG, verifique:

- [ ] Abre corretamente no navegador
- [ ] Cores estão corretas (gradiente verde #14AA82)
- [ ] Linhas estão limpas (sem serrilhado)
- [ ] Funciona em fundo claro E escuro
- [ ] Tamanho pequeno (favicon) fica legível

---

## 🎨 Versões que precisamos

Idealmente, ter estas versões:

| Arquivo | Uso |
|---------|-----|
| `logo_dpwai.svg` | Logo completo colorido |
| `logo_dpwai_white.svg` | Versão branca (pra fundo escuro) |
| `logo_dpwai_icon.svg` | Só o símbolo (pra favicon, ícones) |
| `logo_dpwai_horizontal.svg` | Logo + texto "DPWAI" do lado |

---

## 🆘 Problemas?

### "Ficou com bordas serrilhadas"
- Tente aumentar a qualidade nas configurações do vectorizer
- Ou use o Vectorizer.AI que tem melhor qualidade

### "Cores ficaram diferentes"
- Edite o SVG (abre como texto) e ajuste os códigos de cor
- Cor principal DPWAI: `#14AA82` (verde)

### "Arquivo muito pesado"
- Use o SVGOMG pra otimizar: https://jakearchibald.github.io/svgomg/

---

## 📞 Precisa de ajuda?

Manda o PNG original pra mim que eu tento vetorizar por outros meios!

---

*Tutorial criado pelo Muffin 🤖 em 31/01/2026*
