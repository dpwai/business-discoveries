# Preparacao para Reuniao com Claudio e Leomar
**Data:** 25 de fevereiro de 2026
**Participantes:** Rodrigo Kugler, Claudio Kugler, Leomar (Eng. UBG)
**Objetivo:** Validar o diagrama ER do modulo UBG e sair com o modelo confirmado ou com as correcoes necessarias

---

## O que ja temos modelado

O diagrama atual parte das seguintes hipoteses. A reuniao existe para confirmar ou corrigir cada uma delas.

**Fluxo principal mapeado:**

```
OPERACAO_CAMPO (colheita)
        |
        v
TICKET_BALANCA --> RECEBIMENTO_GRAO --> CONTROLE_SECAGEM --> ESTOQUE_SILO
                                                                    |
                                   MOVIMENTACAO_SILO / SAIDA_GRAO / QUEBRA_PRODUCAO
```

**9 entidades mapeadas no modulo UBG:**
UBG, SILOS (8 total: 7 convencionais + 1 madeira sementes), TICKET_BALANCA, RECEBIMENTO_GRAO, CONTROLE_SECAGEM, ESTOQUE_SILO, MOVIMENTACAO_SILO, SAIDA_GRAO, QUEBRA_PRODUCAO

**4 tipos de saida mapeados:**
Commodities (Castrolanda/feijoeiros), Sementes (bags certificadas), Racao (pecuaria interna), Plantio interno

**Ponto de corte de responsabilidade:** o grao muda de dominio "lavoura" para dominio "UBG" no momento do ticket balanca.

---

## Perguntas por bloco

---

### Bloco 1 - Fluxo Geral e Responsabilidades

Essas perguntas sao para Claudio e Leomar juntos, pois envolvem a logica de negocio e a operacao.

1. O grao de todas as fazendas passa obrigatoriamente pela UBG antes de qualquer saida? Existe alguma excecao onde o grao vai direto do campo para o comprador sem passar pela balanca da UBG?

2. A UBG recebe grao de terceiros, ou e uso exclusivo da SOAL?

3. No ticket da balanca, a tara do veiculo e registrada naquele momento (pesagem do caminhao vazio) ou ja existe uma tara cadastrada para cada caminhao? Como isso funciona na pratica?

4. Quem opera a balanca fisicamente? E o mesmo Leomar ou tem um operador especifico?

5. O ponto de corte entre a responsabilidade da lavoura e a responsabilidade da UBG e de fato o ticket da balanca? Ou existe algum evento antes ou depois disso que seria mais adequado para essa divisao?

---

### Bloco 2 - Recebimento e Classificacao (RECEBIMENTO_GRAO)

Essas perguntas sao especificamente para Leomar.

6. Na recepcao do grao na moega, quais dados sao registrados hoje? Temos mapeado: umidade, peso hectolitrico (PH), impureza em gramas, ardido, avariado, verde, quebrado - todos em amostra de 200g. Isso esta correto ou faltam campos?

7. Os descontos por umidade e impureza sao calculados automaticamente com base em tabelas fixas (CONAB ou cooperativa) ou Leomar faz o calculo manualmente por lote?

8. Existe um criterio de rejeicao? Se o grao chega com umidade ou impureza acima de certo limite, ele nao e recebido ou e recebido com penalizacao maior?

9. O talhao de origem e registrado no momento da recepcao ou apenas o ticket da balanca captura de onde veio o caminhao?

---

### Bloco 3 - Secagem (nucleo do Leomar)

Esse bloco e o mais critico para a plataforma. Leomar e o responsavel tecnico pela secagem e e aqui que esta a maior parte das informacoes nao documentadas.

10. Hoje, a cada 30 minutos, Leomar ou um operador registra as leituras do secador. Onde isso vai: em planilha, no software do secador, em papel? Como esta esse registro hoje?

11. O que e registrado exatamente a cada leitura? Temos: umidade de entrada, umidade durante a secagem, temperaturas P1, P2, P3, temperatura do grao, consumo de lenha em m3, operador do turno. Esta completo?

12. Quantos ciclos de secagem um lote pode ter? Existe ressecagem (o grao volta ao secador depois de ja ter passado uma vez)?

13. A meta de umidade de saida e sempre a mesma para todas as culturas ou varia? Qual e a umidade alvo para soja, milho, feijao?

14. O CONTROLE_SECAGEM atende a I.N. 029/2011 do MAPA. Quais campos especificos dessa normativa precisam estar no registro que ainda nao temos mapeados?

15. Leomar tem acesso ao software do secador. Esse software exporta dados? Em que formato? Seria possivel integrar automaticamente em vez de digitar manualmente?

---

### Bloco 4 - Armazenagem e Silos (ESTOQUE_SILO)

16. Os 8 silos sao numerados de 1 a 8? Como eles sao identificados na operacao?

17. E possivel ter graos de culturas diferentes no mesmo silo? Por exemplo, soja e feijao ao mesmo tempo no Silo 3?

18. E possivel ter graos da mesma cultura mas de safras diferentes no mesmo silo?

19. O silo de madeira e exclusivo para sementes ou e multipurpose? Existe alguma restricao de uso?

20. A medicao fisica do estoque (quantidade real vs virtual) e feita com que frequencia? Quem faz e como?

21. Existe sistema de termometria e aeracao nos silos? Se sim, esses dados sao registrados hoje ou so monitorados visualmente?

---

### Bloco 5 - Lenha e Custos da Secagem

Esse bloco e fundamental para fechar o custo da UBG.

22. O consumo de lenha e medido por ciclo de secagem, por dia, ou de outra forma? A unidade e m3 mesmo?

23. A lenha vem de floresta propria (eucalipto) ou e comprada de terceiros? Existe algum controle de estoque de lenha hoje?

24. Como o custo da lenha entra no calculo do Leomar? Ele usa um preco de referencia por m3?

25. Alem da lenha, quais outros custos diretos a UBG tem que Leomar controla? Energia eletrica, mao de obra do turno, manutencao do secador?

26. A energia eletrica da UBG e medida separadamente das outras instalacoes da fazenda (casa sede, galpoes, etc.) ou esta tudo no mesmo medidor?

---

### Bloco 6 - Rateio e Calculo de Custo (o que o Leomar faz hoje)

Esse bloco e o mais estrategico da reuniao. A logica do Leomar precisa virar algoritmo na plataforma.

27. Leomar faz o rateio dos custos da UBG por lote processado. Qual e a base de rateio hoje: tonelada recebida, tonelada seca, por cultura, por fazenda de origem, ou uma combinacao?

28. Como ele separa o custo de secagem de um lote de soja do custo de um lote de feijao que passou pelo secador no mesmo dia?

29. O custo de armazenagem (energia da aeracao, depreciacao do silo) como entra no calculo? E alocado por kg/mes de permanencia no silo?

30. No final do processo, o que Leomar entrega para Claudio? Um relatorio por lote, por safra, por cultura? Em que formato isso existe hoje?

31. Tem planilha de controle que Leomar usa hoje? Se sim, e possivel compartilhar para a gente mapear os campos?

---

### Bloco 7 - Saidas e Destinos (SAIDA_GRAO)

32. No momento da venda de commodities para a Castrolanda ou feijoeiros, quem emite a nota fiscal: a SOAL ou a propria cooperativa?

33. Para transferencias internas (grao para racao, grao para plantio interno), ha emissao de nota fiscal? Qual documento registra essa saida hoje?

34. O processo de carregamento do caminhao na saida usa a mesma balanca do recebimento? O ticket de saida tem os mesmos campos do ticket de entrada?

35. Quando o grao sai para sementes (Castrolanda), existe um processo de classificacao adicional? O grao para semente passa por algum processo diferente dentro da UBG antes de sair?

---

### Bloco 8 - Racao e Conexao com Pecuaria

36. O grao que sai do silo para virar racao passa por algum processo na UBG (moagem, mistura) antes de ir para a pecuaria, ou sai do silo e vai direto?

37. Existe uma fabrica de racao estruturada ou o processo e mais simples (mistura no cocho)?

38. Quem define a quantidade de grao que vai para racao: Claudio, o responsavel da pecuaria, ou Leomar?

---

### Bloco 9 - Software e Integracao

39. Leomar mencionou que tem acesso ao software do secador e da UBG. Qual e o nome desse software?

40. Esse software gera relatorios ou exporta dados em algum formato (planilha, PDF, CSV)?

41. Existe alguma outra ferramenta ou planilha que Leomar usa hoje para controle que nao seja o software do secador?

---

## O que precisamos sair dessa reuniao com

**Obrigatorio - sem isso o diagrama nao pode ser finalizado:**
- Confirmacao (ou correcao) do fluxo de 4 etapas: balanca → recepcao → secagem → silo
- Como o rateio funciona: base de calculo e o que e entregue no final
- Lista completa de campos do recebimento e da secagem que Leomar usa hoje
- Se existe software integravel ou se o dado e manual

**Muito importante - define entidades do diagrama:**
- Confirmacao sobre o silo de madeira: exclusivo sementes ou multipurpose
- Como o grao vira racao: tem processamento ou vai direto
- Como funciona a saida para sementes: tem processo diferente ou nao

**A confirmar com Claudio especificamente:**
- O grao de todas as fazendas passa pela UBG ou existem excecoes
- Quem tem autoridade para liberar dados historicos e acesso ao software
- Aprovacao ou correcao do ponto de corte de responsabilidade no ticket balanca

---

## Como conduzir a reuniao

Chegue com o diagrama aberto no Miro ou em uma impressao. Apresente o fluxo em 3 minutos: "esse e o modelo que construimos com base nas reunioes anteriores. Hoje precisamos que o Leomar confirme ou corrija cada parte."

Deixe o Leomar falar sobre o processo de secagem sem interromper. Ele vai revelar detalhes que as perguntas nao conseguem capturar.

Para o rateio, peca para ele mostrar ou descrever o que entrega para Claudio ao final de um ciclo. Se tiver planilha, peca o arquivo ainda na reuniao.

Se ele mencionar algum campo ou dado que nao esta no diagrama, anote e adicione na lista de questoes abertas. Nao tente resolver tudo na hora.

---

**Tempo estimado:** 1h30 a 2h
**Proximos passos pos-reuniao:** atualizar o Doc 22 com as correcoes, abrir os conectores faltantes no Miro, agendar revisao com Joao
