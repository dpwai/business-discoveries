# Relatório de Análise - Reunião Tech & Design (DPY)
**Data da Reunião:** 27/01/2026
**Participantes:** João Vitor Balzer (Tech Lead), Rodrigo Kugler (Business/Discovery)
**Foco:** Review de UX/UI do App, Arquitetura de "Organização", Deploy Vercel e Repositórios.

---

## 1. RESUMO EXECUTIVO

Reunião de alinhamento técnico e visual. João apresentou avanços significativos no front-end do app (mobile first), introduzindo uma mudança estrutural importante: **substituir o conceito de "Fazenda" por "Organização"**. O objetivo é permitir que a plataforma DPY escale para outros nichos (concessionárias, indústrias) no futuro, usando templates modulares. Rodrigo validou a ideia, mas alertou para manter o foco inicial no Agro para não confundir o usuário atual.

Também foram discutidos aspectos de infraestrutura (Vercel, Neon, Resend) e a transferência de propriedade dos repositórios GitHub para a organização oficial da DPY.

---

## 2. DECISÕES DE PRODUTO E DESIGN

### A. Conceito de "Organização" (Scalability)
- **Decisão:** A entidade topo da hierarquia não será mais "Fazenda", mas sim "Organização".
- **Lente João (Engenharia):** Permite reutilizar o código para outros verticais (SaaS modular). Um usuário pode ter múltiplas organizações.
- **Lente Rodrigo (Negócio):** Aprovado, desde que a interface para o produtor rural (primeiro cliente) seja clara. Sugestão de ter uma "landing page" ou área específica "DPY Agro" para gerar identificação.

### B. Funcionalidade de Dashboards
- **Proposta João:** Permitir que o usuário crie/edite dashboards e faça *embed* de ferramentas externas (Google, AgriWin Web, Power BI) dentro do app DPY.
- **Feedback Rodrigo:** **Ceticismo.** O perfil do produtor rural (SOAL) **não** vai construir dashboards. "Eles querem o dashboard pronto".
- **Veredito Híbrido:** A funcionalidade de *builder* e *embed* deve existir no backend/admin para a equipe da DeepWork usar na implantação, mas deve ficar oculta ou bloqueada para o usuário final (role access) para evitar quebram e complexidade desnecessária.

### C. UX Mobile
- **Navegação:** Inclusão de seta "Voltar" no canto superior esquerdo (padrão nativo).
- **Personalização:** Funcionalidade de "Personalizar Tela Inicial" foi descartada por gerar confusão. "A inicial deve ser sempre a mesma".
- **Menus:** Simplificação do rodapé e uso de "Safe Zone".
- **Nomenclatura:** Ajuste de termos técnicos em inglês para português e termos agro (ex: "Propriedade Atual").

---

## 3. TECNOLOGIA E INFRAESTRUTURA (STACK)

| Componente | Tecnologia | Decisão/Status |
|------------|------------|----------------|
| **Front/Back** | Next.js (Cloud Code) | Renderizado via Vercel (Serverless). |
| **Deploy** | Vercel | Uso de arquitetura Serverless (escalabilidade automática, "se cair uma máquina, outra assume"). |
| **Banco de Dados** | Neon (Postgres) | Banco serverless, integrado na Vercel. Mencionada necessidade de "limpar dados bugados". |
| **Email** | Resend | Escolhido para transactional emails (reset de senha, convites). Custo de SMS (Twilio?) considerado alto (~R$ 100/mês), mantendo apenas e-mail por enquanto. |
| **Gestão de Código**| GitHub | Transferência de repositórios pessoais para a organização `DPY`. |

---

## 4. PONTOS DE ATENÇÃO (RISCOS)

### 1. Complexidade vs. Simplicidade (O Dilema do Produtor)
- **Risco:** O desejo de fazer uma "Plataforma de Automação de Negócios" genérica pode assustar o usuário agro que quer apenas ver "quanto custou minha soja".
- **Mitigação:** Criar uma "máscara" ou configuração padrão que, para o cliente SOAL, o sistema pareça 100% focado em agro, escondendo a complexidade abstrata de "organizações" e "módulos genéricos".

### 2. Embed de Terceiros
- **Risco:** João sugeriu embedar sites externos para "centralizar tudo". Isso pode gerar problemas de segurança (CORS, iframes bloqueados) e experiência ruim (login duplo dentro do iframe).
- **Ação:** Validar tecnicamente quais ferramentas aceitam embed amigável antes de vender isso como feature.

### 3. Autenticação apenas por E-mail
- **Contexto:** Produtores e operadores de campo muitas vezes não usam e-mail com frequência.
- **Risco:** Dificuldade de recuperação de senha ou login.
- **Futuro:** Considerar login social (Google/Apple) ou WhatsApp OTP no futuro, apesar do custo.

---

## 5. AÇÕES IMEDIATAS (Next Steps)

1.  **GitHub:** Rodrigo deve clonar o novo repositório da `landing-page` (já transferido para DPY) e atualizar o código localmente.
2.  **Vercel Team:** Rodrigo criar conta na Vercel para ser adicionado ao time e visualizar deploys/analytics.
3.  **Refinamento UX:** João remover a personalização da home e ajustar o botão de voltar.
4.  **Limpeza de DB:** João limpar dados órfãos no banco Neon que estão quebrando a visualização de dashboards.
5.  **Domínios:** Configurar subdomínios (app.dpy.com.br, agro.dpy.com.br) na Vercel.

---

**Análise gerada pela Inteligência Híbrida SOAL**
*Combinando visão de Produto (Escalabilidade) com Realidade de Campo (Simplicidade).*
