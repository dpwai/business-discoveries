# Preparação Estratégica: Concessionária Kugler (Funilaria e Pintura)

## 1. O Desafio (Perguntas Difíceis para a Deepwork)
*Antes de vender a solução, precisamos ter certeza que conseguimos entregar. Reflita sobre estes pontos:*

### Viabilidade Técnica (Integração NBS)
- **O "Elefante na Sala":** Como vamos extrair dados do NBS em *tempo real*?
    - O NBS tem API aberta?
    - Vamos precisar de acesso direto ao banco de dados (SQL)?
    - Se não tiver API nem acesso ao banco, vamos depender de relatórios exportados (CSV/Excel)? Isso mata o "tempo real".
    - *Risco:* Vender um dashboard "ao vivo" e entregar um dashboard que atualiza "ontem".

### Adoção Cultural (O Fator Humano)
- **O Mecânico vai usar?**
    - A solução depende que o funileiro/pintor pare o que está fazendo para clicar em "Iniciar/Pausar" em um tablet/celular.
    - Eles têm mãos sujas de graxa/tinta. O dispositivo aguenta?
    - Eles vão ver isso como "controle do patrão" e boicotar?
    - *Mitigação:* A interface precisa ser absurdamente simples (botões gigantes) e talvez precisemos de incentivos (gamificação?).

### Infraestrutura
- Tem Wi-Fi de qualidade na área da funilaria?
- Onde ficarão os dispositivos (tablets/telas)?

---

## 2. Perguntas para o Cliente (Diagnóstico Profundo)
*Perguntas desenhadas para expor a dor e criar urgência.*

### Sobre a "Caixa Preta" Operacional
1. "Daniel, se um cliente VIP ligar agora perguntando do carro dele, **quantos minutos e quantas pessoas** você precisa acionar para me dizer *exatamente* em que etapa o carro está e quando fica pronto?"
2. "Hoje, você saberia me dizer quem é seu funileiro mais eficiente e quem é o que mais gera retrabalho, com dados, ou é apenas 'feeling'?"

### Sobre o Custo da Ineficiência
3. "Quanto você estima que perde por mês com **horas ociosas** ou **gargalos** que você nem vê? (Ex: carro parado esperando peça enquanto o funileiro está sem serviço)"
4. "Como é feito o controle de materiais hoje? Se um pintor gastar 30% a mais de tinta que o necessário, você fica sabendo?"

### Sobre a Visão de Futuro
5. "Imagine que instalamos uma TV de 60 polegadas no meio da oficina. O que precisaria estar escrito nela para que a equipe trabalhasse sozinha, sem o gerente precisar gritar?"

---

## 3. Checklist de Levantamento Técnico (Para o João)
- [ ] Pedir documentação técnica do NBS (Dicionário de dados, Manual de API).
- [ ] Verificar infraestrutura de rede no local (Ping, cobertura Wi-Fi).
- [ ] Listar exatamente quais campos do "Relatório Gerencial" atual são úteis e quais são lixo.
- [ ] Entender o fluxo físico do carro (Entrada -> Orçamento -> Desmontagem -> Funilaria -> Preparação -> Pintura -> Montagem -> Polimento -> Entrega).
