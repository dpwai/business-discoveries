# Design System & UX: Coleta de Dados SOAL (Pocket Form) 📱🚜

> **Documento de Especificação de Interface e Experiência do Usuário**
> **Objetivo:** Demonstrar visualmente como transformaremos a coleta manual em algo simples, intuitivo e à prova de erro.
> **Público:** Operadores (Josmar), Gestores (Tiago) e Diretores (Claudio).

---

## 1. 🎨 A Filosofia Visual: "DeepWork Field Ops"

O design deve transmitir **robustez** e **simplicidade**. Não estamos fazendo um app de rede social; estamos fazendo uma ferramenta de trabalho, como uma chave inglesa digital.

### Paleta de Cores (Adaptada para Alto Contraste/Sol)
*   **Fundo (Background):** `#121212` (Preto Profundo - Economia de bateria OLED).
*   **Superfícies (Cards):** `#1E1E1E` (Cinza Escuro - Separação visual).
*   **Ação Primária (Botões):** `#00C896` (DeepWork Teal) - Para confirmar/avançar.
*   **Alerta/Erro:** `#FF5252` (Vermelho Vivo) - Apenas para erros críticos.
*   **Texto:** `#FFFFFF` (Branco Puro - Leitura máxima).

### Tipografia
*   **Fonte:** *Inter* ou *Roboto*.
*   **Tamanho Mínimo de Botão:** 60px de altura (fácil de acertar andando ou no trator).

---

## 2. 📱 O Fluxo do "Pocket Form" (PWA)

A ideia é um **Web App Progressivo (PWA)** que roda direto no navegador do celular, sem precisar baixar na loja, e funciona offline.

### Tela 1: Identificação (Login sem Senha)
*   **Conceito:** "Quem é você?"
*   **Visual:** Uma grade com 4 botões grandes, cada um com a foto ou ícone do operador.
*   **Ação:** Josmar clica na foto dele.

### Tela 2: O Contexto (O que vamos fazer?)
*   **Conceito:** Menos opções é mais velocidade.
*   **Botões:**
    1.  🚛 **Recebimento de Grãos**
    2.  📤 **Expedição/Venda**
    3.  ⛽ **Abastecimento**

### Tela 3: O Input (A Coleta)
*   **Cenário: Recebimento de Grãos**
*   **Campos:**
    *   *Placa:* (Reconhecimento via câmera ou Dropdown das 10 placas mais recentes).
    *   *Peso:* Teclado numérico gigante (popped up).
    *   *Umidade:* Slider ou Teclado numérico.
*   **Botão Final:** "SALVAR REGISTRO" (Verde Neon, ocupando toda a largura).

---

## 3. 🖼️ Prompts para Geração de Mockups (Banana Pro / Midjourney)

Use estes prompts para gerar imagens que venderão a ideia na apresentação. Eles mostram o app "no mundo real".

### Prompt 1: O Operador no Secador (Contexto Real)
> **Prompt:** A realistic photo shot from a first-person perspective (POV) of a farm worker's hand holding a smartphone in front of a massive grain silo structure. The smartphone screen displays a modern, high-contrast dark mode mobile app interface with large, bright teal green buttons and clear white text. The app shows a "CONFIRM WEIGHT" screen. The background is a sunny agricultural setting, with dust particles in the air, conveying a rugged, industrial farm atmosphere. Cinematic lighting, 8k resolution, highly detailed. --ar 16:9

![Operador usando o App no Campo](./images/operator_pov_app.png)

### Prompt 2: Close-up da Interface (UI Design)
> **Prompt:** UI design concepts for a mobile agricultural app, dark mode theme. The screen shows a clean dashboard card with localized harvest data: "Umidade: 13%", "Peso: 32.500 kg". The color palette is deep charcoal gray background with vibrant teal green accents (`#00C896`). Modern typography, rounded corners, glassmorphism effect on the cards. High fidelity UI mockup, professional dribbble style. --ar 9:16

![Interface Mobile UI](./images/ui_input_card_mockup.png)

### Prompt 3: O Dashboard do Gestor (Tablet na Caminhonete)
> **Prompt:** A photo of a rugged tablet mounted on the dashboard of a pickup truck interior, overlooking a soy field at sunset. The tablet screen displays a sophisticated business intelligence dashboard with dark background, showing real-time line charts and data widgets in neon green and white. The dashboard is titled "SOAL - CUSTO EM TEMPO REAL". The aesthetic is premium, futuristic yet practical. --ar 16:9

![Dashboard no Tablet na Caminhonete](./images/tablet_dashboard_truck.png)

---

## 4. ✏️ Guia para Esboço no Figma (Wireframes)

Se for montar no Figma para a reunião, siga esta estrutura simplificada:

### Componente: Card de Input
*   **Frame:** iPhone 13/14 Pro.
*   **Header:** Logo DeepWork pequena no topo (centralizada).
*   **Input Field:**
    *   Height: 64px.
    *   Background: `#2C2C2C`.
    *   Radius: 12px.
    *   Text Size: 24px (Grande!).
*   **Botão de Ação (FAB ou Bottom):**
    *   Height: 56px.
    *   Background: Gradiente linear (`#00C896` a `#00A876`).
    *   Text: "ENVIAR" (Bold, Uppercase).

### Componente: Feedback de Sucesso
*   Após enviar, a tela deve piscar verde sutilmente e mostrar um "Check" gigante animado com a mensagem: **"Salvo! (Sincronização Pendente)"**. Isso acalma a ansiedade do operador sobre a internet.

---

## 5. 💡 Argumento de Venda (O "Porquê" do Design)
*   *"Claudio, o design não é só estética. É **usabilidade**. Botão grande significa menos erro de digitação. Fundo escuro significa que o Josmar consegue ler a tela mesmo no sol do meio-dia. Login por foto significa que ele não vai colar a senha no monitor com post-it."*
