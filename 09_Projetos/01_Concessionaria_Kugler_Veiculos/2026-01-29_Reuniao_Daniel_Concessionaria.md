29 de jan. de 2026
Reunião em 29 de jan. de 2026 às 13:44 UTC - Transcrição
00:00:00
 
Rodrigo Kugler: É coisa boa, pelo menos, né? Bastante
Daniel Arthur Kugler: É, não tem a gente não consegue,
Rodrigo Kugler: serviço.
Daniel Arthur Kugler: não estamos conseguindo ajustar a agenda, cronograma, isso que tá como
Rodrigo Kugler: Ah, então tá. Eu tenho novidade para você, né, nesse nesse sentido aí,
Daniel Arthur Kugler: se
Rodrigo Kugler: porque acho que vai isso aqui que eu tô aqui que a gente tá montando, vou até mostrar rapidão aqui, cara. Eh, pera aí, cara. Tô me acostumando ainda com esse negócio de Mac, velho. É bem diferente, né?
Daniel Arthur Kugler: Ah, a gente tá tá rodando, sabe? Pecando em pequenos detalhes
Rodrigo Kugler: Pois é.
Daniel Arthur Kugler: aí.
Rodrigo Kugler: Deixa eu pegar isso aqui, passar para outra tela aqui. Eh, tem até um comentário para você, um feedback que eles foram lavar meu carro na pressa semana passada,
Daniel Arthur Kugler: Hum.
Rodrigo Kugler: né? e passaram um pano sujo na porta e tal, ficou uma grande bosta.
Daniel Arthur Kugler: Não era nem para ter lavado.
Rodrigo Kugler: É,
Daniel Arthur Kugler: Já falei para eles.
Rodrigo Kugler: se não dá, não faça, né?
 
 
00:01:06
 
Daniel Arthur Kugler: Não, eu já falei.
Rodrigo Kugler: Não tem problema não.
Daniel Arthur Kugler: Você nem sabia disso aí. Eu vou puxar a orelha do Fabiano disso daí.
Rodrigo Kugler: Mas eu nem eu nem comentei com ninguém comentando com
Daniel Arthur Kugler: Não, não. Mas eu já falei para eles assim:
Rodrigo Kugler: você.
Daniel Arthur Kugler: "Olha, se não tem agenda para lavar, nãoem.
Rodrigo Kugler: Não agrada, não precisa agradar,
Daniel Arthur Kugler: se entrar num negócio mal feito por
Rodrigo Kugler: tá?
Daniel Arthur Kugler: idiot.
Rodrigo Kugler: Eh, vou compartilhar a tela aqui e eu vou começar. Bom, deixa eu explicar primeiro um pouco do contexto, né? Porque depois que a gente conversou, a gente tava, o que que acontece? a gente tava com uma ideia, né, de desenvolver essa solução, né, que o que que é basicamente aquele processo que eu te falei, que é o que a gente tá fazendo para você, que é de extrair, transformar e daí eh mandar os dados para um outro lugar, né, load, né? Então, ETL,
Daniel Arthur Kugler: Ага.
Rodrigo Kugler: quando eu conversei com o Claudinho e tal e a gente chegou, tipo, chegamos a olhar as coisas da fazenda, a gente teve um estalo e falamos: "Cara, se o Claudinho, que é um excelente agricultor, ainda não tem esse sistema, muito que provável que os demais também não têm, né?
 
 
00:02:18
 
Rodrigo Kugler: A grande maioria, pelo menos, né? Ou se tiver, talvez não tenha no nível que a gente tá imaginando, sabe? Porque o que a gente montou é uma solução que o quê? Que faz exatamente isso. A gente extrai os dados, transforma os dados e daí consegue ter essa visualização clara do que que o negócio, como que o negócio tá, sabe? E daí quando a gente olhou pro mercado de concessionária,
Daniel Arthur Kugler: Tá.
Rodrigo Kugler: a gente a gente acha que talvez não seja tão promissor igual ao mercado agrícola, né?
Daniel Arthur Kugler: É, esse é mais complicado, né?
Rodrigo Kugler: Porque no agrícola eles são mais fechados, mas eu acho que tem mais potencial. Acho que na na talvez nas concessionárias esteja mais já esse tipo de coisa, já esse tipo de serviço. Ou não, não sei. Mas aí por isso que a gente decidiu se dedicar mais ao dar um foco pro agrícola,
Daniel Arthur Kugler: Гри
Rodrigo Kugler: porém a gente não deixou de lado, porque a ideia é que essa solução seja meio modular assim, sabe? a gente poder ajustar e tal, conforme diversas necessidades, porque se tem agricultores que têm leite, tem outros que não têm. Se tem agricultores que têm eh produção de semente, outros que não têm, etc., né?
 
 
00:03:32
 
Daniel Arthur Kugler: Certo.
Rodrigo Kugler: Então, tipo, o que que o que que começou a acontecer? A gente começou a montar o projeto e estruturar ele, né? Eu vou compartilhar a tela aqui para você ver.
Daniel Arthur Kugler: Só deixa eu atender esse cara aqui.
Rodrigo Kugler: M.
Daniel Arthur Kugler: Fala, bom João. Bom dia. Tudo bem? Bom, bom, bom. Viu? A aquele só para lembrar, me passa os dados para nota lá para você lá. Tá, Júlia, a gente passou aquele ordamento do vídeo de pant
 
 
A sessão foi encerrada após 00:04:04
 
00:05:33
 
Rodrigo Kugler: Hum. Tá aí. O que que acontece? A gente tá construindo uma solução que faz esse processo, né, que eu tentei explicar, tipo, e eu entendo que é um pouco difícil as pessoas entender. E eu demorei para entender porque a engenharia de dados não é uma coisa comum no dia a dia, né, das pessoas pensar nisso,
Daniel Arthur Kugler: Não.
Rodrigo Kugler: né? Então, quando a gente sentou conversar com ele, a conversa começou a evoluir muito rápido, tá entendendo? Então, tipo, a gente chegou em um ponto aqui, então, tipo, vou comentar com você até para você me dar teu feedback, achar, porque ainda não apresentei isso pro Claud, sabe?
 
 
00:06:09
 
Rodrigo Kugler: Eu vou mostrar isso para ele amanhã, eu acho, e tal, esse esboço que a gente tá, mas a gente tá indo para um caminho bom. Mas basicamente assim, ó, na parte da SOAL aqui, ó. Ah, cadê aquele aquela pasta aqui? Ah, essa aqui, tá? Eh, consegue ver?
Daniel Arthur Kugler: emoções.
Rodrigo Kugler: Eu te mostrei essa imagem, né? Basicamente a gente vai pegar todos os dados dele e jogar dentro de uma camada bronze,
Daniel Arthur Kugler: Uhum.
Rodrigo Kugler: né? Aonde fica tudo aquele negócio, tudo poluído, tudo diferente. Por exemplo, trator P03. e P traço 03, coisas que hoje ele tá tendo problema no no Agruin para visualizar o custo exato dele, né? Então o que que acontece hoje? O o sistema que eles usam não existe essa parte de refino do dado como tá aqui. Porque o que que acontece? Quando a gente pega o material bruto, sujo, a gente precisa passar por por processos de engenharia de dado para limpar esse dado, beneficiar esse dado e trazer ele paraa camada mais requintada que tá aqui na ponta, né? E isso aqui que daí alimenta os dashboards, tá?
 
 
00:07:32
 
Rodrigo Kugler: O caso da concessionária, hoje você tem um um ERP, né? E o que eu tô criando para ele é também um ERP, que também vai tudo aqui para dentro, né? que vai substituir o agrein dele no futuro. O que que acontece no caso da concessionária? É mais fácil. Você tem basicamente quase tudo que você tem, você tem, não tem John Deere, você não tem maquinário, você, tipo, você é eh você não tem estoque de produção, por exemplo, você tem tudo dentro do NBS, tá? E o quando o Roberto passou acesso pra gente, cara, ele não filtrou o que ele passou pra gente, ele veio tudo, tá? Então o o Roberto puxou o o João Víor puxou tudo para dentro aqui, né? E eh já tá meio que Agora o que que acontece? A gente tá construindo esse mecanismo aqui, essa máquina aqui, ó, que você tá vendo aqui, a gente tá construindo ela agora, que vai fazer isso aqui também, né? que vai fazer os dashboard na ponta. Aí como a gente já tava pensando de de ter uma solução um pouco mais modular, mais simples de usar, né? Aqui são outras imagens da reunião também de visualizações, de como que a gente pode gerar as visualizações para ele, mas mais para dar uma ideia, tá?
 
 
00:08:51
 
Rodrigo Kugler: Aí o que que acontece? Deixa eu abrir aqui uma outra janela, trazer para cá. Cara, é confuso às vezes para mim por que é tão chato de fechar uma J. Questão de costume, eu acho. Que daí a que que a gente fez, Dani? A gente começou a desenhar um app que atendesse essa essa necessidade, né?
Daniel Arthur Kugler: É Deus bem carro aí, mas assim em questão da limpeza mesmo, sabe? Eh, entre os bancos aqui,
Rodrigo Kugler: Então, nessa tela inicial aqui,
Daniel Arthur Kugler: ainda
Rodrigo Kugler: a gente tem aqui a apresentação, não sei o quê, onde o cara vai botar o e-mail e a senha, né?
Daniel Arthur Kugler: uma coisa você não gostei mesmo.
Rodrigo Kugler: Aí quando a gente der um entrar aqui, a gente entra numa tela inicial.
Daniel Arthur Kugler: Não que eu não gostei.
Rodrigo Kugler: Dá para você pôr um fone ou não sei?
Daniel Arthur Kugler: Eh, chegando em casa,
Rodrigo Kugler: Tô escutando ela falar alto.
Daniel Arthur Kugler: faz uma Juliane,
Rodrigo Kugler: Вот.
Daniel Arthur Kugler: obrigado pelo teu feedback, tá? Faz o seguinte, vai viajar curta tuas férias, depois que você voltar atrás o carro aqui, tá? Que a gente vai fazer essa limpeza para você.
 
 
00:10:02
 
Rodrigo Kugler: Bom, vou esperar você falar com ele.
Daniel Arthur Kugler: Não, não é comigo não.
Rodrigo Kugler: Aí eu já não é com você. Ô, bom, a próxima vez é que a gente for fazer uma uma conversa, vá na sala de reunião para não te atrapalhar aí também. Eh, mas, ó, ele entra nesse painel aqui,
Daniel Arthur Kugler: Ah.
Rodrigo Kugler: tá? Eh, aí você vai ter o teu usuário, né, a tua organização, né, né? Se você quiser pôr outras fazendas, isso aqui é tudo dado teste, não é os dados dele ainda, tá? Aí a gente vai ter bem simples, uma tela de painéis, uma tela de entrada de dados e formulário, né? E o chat de a os usuários que podem usar que que vão usar a aplicação e uma tela de configurações, tá? Isso aqui tudo a gente ainda vai passar por redesign e colocar então por a intenção ainda aqui era mais eh montar o esqueleto da aplicação antes de de trabalhar com design, tá? para deixar ele bonito e tal, mas se eu clicar em em em painéis, aqui tem uma tela com aonde a gente vai poder colocar vários dashboards, né? Então, a gente vai customizar cada visualização de dados com os dados que ele tem e colocar dentro aqui dessa dessa tela.
 
 
00:11:19
 
Rodrigo Kugler: Então, veja bem, ah, vamos supor, eu quero ter um sumário aqui com contas a pagar, quantas a receber, sei lá, qualquer outro tipo de cenário. E por que que eu tô te falando isso? Porque eu acho que o app que a gente vai entregar para você, vamos fazer aqui dentro também. Eu era o que eu tava pensando, mas eu vou te mostrar mais coisas ainda, porque a gente adapta algumas coisas e coloca pro teu dia a dia, entendeu? Mas aqui, ó, eh, a gente tem os painéis, tá? Aí, nesse chatzinho aqui vai ter um LLM de A, né, aonde você pode fazer perguntas sobre seus dados e ele vai fazer as as análises, os relatórios e vai trazer para você, tá? Exemplo, me fale sobre a produtividade do talhão A em comparação ao talhão B. Me fale do consumo de diesel do trator X contra o trator Y. me fale sobre os efeitos da minha aplicação de fósforo no ano passado, na produtividade desse ano, no talhão tal, entendeu? Então, tipo, ele vai fazer essas perguntas e aí, ah, é um chat GPT normal que a gente compra e coloca por detrás aqui, só que conectado nos teus dados,
Daniel Arthur Kugler: produto ver
Rodrigo Kugler: no backend dessa aplicação.
 
 
00:12:38
 
Rodrigo Kugler: Mas é basicamente você abrir o chat dessa maneira aqui.
Daniel Arthur Kugler: elas
Rodrigo Kugler: Você abre o chat, só que o chat tá aqui, entendeu?
Daniel Arthur Kugler: tá
Rodrigo Kugler: E as tuas conversas ficam aqui com tudo que você já gerou de material, de conteúdo e tal.
Daniel Arthur Kugler: Esse
Rodrigo Kugler: Ponto.
Daniel Arthur Kugler: c
Rodrigo Kugler: Ele volta pra tela inicial aqui. Quer falar com ele aí? Não tem problema.
Daniel Arthur Kugler: não, não é, já saiu. M.
Rodrigo Kugler: Aí tem uma tela onde a gente vai fazer as integrações com os sistemas. No caso aqui a gente colocaria integração do NBS, tá? E a gente tem uma tela de entrada de dados, tá? Então essa aqui é a sacada, porque isso aqui encaixa no que você precisa hoje, né? Lembra que a gente tava falando, ah, vamos fazer um formulário, não sei o que e tal? Cara, acabou que a gente chegou nisso nisso aqui como ideia final, porque aqui, vamos dizer, você vai ter o relatório da guria que faz lá o controle da do giro da oficina. você, ela vai ter um um acesso dela para entrar dentro da aplicação, aonde ela não vai ter acesso às outras informações que você tem lá nos seus painéis.
 
 
00:13:51
 
Rodrigo Kugler: Aí ela vai falar: "Ah,
Daniel Arthur Kugler: Так.
Rodrigo Kugler: eh, eu vou fazer uma entrada de dado, tá? E vou colocar agora aqui as mãos de obra e a gente monta uma planilha igual a tua lá, igual a que ela usa. E ela vai entrar dentro do app e vai preencher isso dentro do app, tá? Aí ela, isso pode ser aqui direto nesse link, tá? Ou a gente vai ter uma versão mobile também, tá? Tem já.
Daniel Arthur Kugler: Так.
Rodrigo Kugler: Aí ela pode entrar na versão mobile, no celular dela, digitar os dados, tá? Só que o que que é o ponto? Quando chegar aqui nessa parte, quando chegar aqui nessa parte, quem que é o responsável por fazer a revisão dos dados e entrar? É o gerente, é você. Então, ela vai fazer e você vai acompanhar o trabalho dela. Só que você só vai bater o olho e vai falar: "Ah, tá OK, pode ir." Pum. Aí a gente roda isso aqui uma, duas vezes por dia, né? E isso aqui, esses dois formulários que a gente pensou inicialmente aqui, que seria um de controle das mãos de obra e do fluxo da tua oficina, né?
 
 
00:15:03
 
Rodrigo Kugler: E dois, você tinha pedido também o fluxo de lavagem de veículos, né, a agenda com as capacidades e tal. Então, eu acho que dá pra gente fazer esses dois já aqui de cara, tá? Quando a gente terminar,
Daniel Arthur Kugler: Так.
Rodrigo Kugler: a gente vai botar o NBS, vamos montar os dois formulários e botar para rodar, tá? E assim, eh, fazer uma pausa aqui. Eh, tem alguma pergunta? Ficou claro essa explicação que eu que eu dei sobre o
Daniel Arthur Kugler: É um pouco um pouquinho mais complexo porque tá como tá fazendo,
Rodrigo Kugler: oum.
Daniel Arthur Kugler: então eu não consegui entender direito a eu entendi o negócio, mas assim é que como é um pouquinho diferente o esboço, né, por exemplo, Assim, igual tu falei, eu preciso de um de uma tela onde eu vejo todos os carros que eu tenho
Rodrigo Kugler: Aqui você vai clicar, você vai clicar aqui, tá? Aí quando você clicar em visualizar aqui, ó, ele vai abrir o teu dashboard na tela. Isso aqui é só um exemplo, tá? Mas o que que eu vou fazer? Eu vou linkar esse dashboard aqui, essa esse esse app aqui. Linkar. Ai, cadê, cara?
 
 
00:16:29
 
Rodrigo Kugler: Eh, Figma, Figma, Figma, só um pouco nesse dashboard aqui, entendeu? Porque daí você vai ter o teu fluxo aqui.
Daniel Arthur Kugler: Tá.
Rodrigo Kugler: Acho que tá meio com o zoom meio grande aqui demais. Como que dá zoom out no no Mac, você sabe?
Daniel Arthur Kugler: Ah, não me lembro. Não é no próprio no mouse pedra ali, só diminuir.
Rodrigo Kugler: Pera aí, deixa eu ver aqui. Control option. control menos, cara, não tô conseguindo diminuir aqui a tela, mas enfim. Você lembra desse dashboard que a gente montou aqui, né? E daí a gente tem aqui as partes de ah aqui na parte de baixo a gente tem desmontagem,
Daniel Arthur Kugler: Ага.
Rodrigo Kugler: funilaria, daí pintura, montagem com o fluxo, né? Aí a gente combinou que a gente definiria essas etapas aqui. Eu não sei se você já pensou sobre isso. Como que você vai querer cada
Daniel Arthur Kugler: É mais ou menos essa mesmo.
Rodrigo Kugler: categoria?
Daniel Arthur Kugler: Desmontagem, montagem, funilaria, preparação, pintura,
Rodrigo Kugler: Lembra que a gente,
Daniel Arthur Kugler: polimento.
 
 
00:18:09
 
Rodrigo Kugler: eu também falei da questão de deixar ele mais objetivo pra gente não ter necessidade de tantas atualizações, lembra?
Daniel Arthur Kugler: Pois é, mas é que cada um desses é um processo, é uma pessoa diferente,
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: entendeu? Desmontagem é um,
Rodrigo Kugler: E aqui
Daniel Arthur Kugler: funilaria é outro, preparação é outro,
Rodrigo Kugler: você tá
Daniel Arthur Kugler: pintura é outro, polimento é outro,
Rodrigo Kugler: a gente então tá vamos então falar desmontagem,
Daniel Arthur Kugler: não é um técnico é desmontagem e montagem é o mesmo,
Rodrigo Kugler: funilaria,
Daniel Arthur Kugler: né? É o mesmo técnico.
Rodrigo Kugler: não é? Porque um é Sim,
Daniel Arthur Kugler: Desmontagem ou montagem.
Rodrigo Kugler: mas um é no começo do processo e outro é no final,
Daniel Arthur Kugler: aqui no final,
Rodrigo Kugler: tá?
Daniel Arthur Kugler: desmontagem, funilaria, preparação, pintura.
Rodrigo Kugler: Preparação e pintura não é mesmo eh não dá para botar no
Daniel Arthur Kugler: Não, não, que não é o mesmo técnico.
Rodrigo Kugler: mesmo.
Daniel Arthur Kugler: A gente tem os preparadores que fazem a parte de lixamento e deixar pronto e um cara só para pintar.
Rodrigo Kugler: Uhum.
 
 
00:19:09
 
Rodrigo Kugler: Tá.
Daniel Arthur Kugler: Pintura polimento.
Rodrigo Kugler: pintura, montagem e polimento.
Daniel Arthur Kugler: É, nem sempre é o nem sempre o polimento é antes da montagem, de vez em quando é depois.
Rodrigo Kugler: Nem sempre dá para botar então eh no fim
Daniel Arthur Kugler: Hum.
Rodrigo Kugler: pintura barra polimento ou montagem barra
Daniel Arthur Kugler: Dá para fazer,
Rodrigo Kugler: polimento,
Daniel Arthur Kugler: não sei como que fica ali.
Rodrigo Kugler: que apesar de você ter os dois eh os dois funcionários junto aqui,
Daniel Arthur Kugler: Consegue
Rodrigo Kugler: não acho que não seja o que vai, né? Mas não sei.
Daniel Arthur Kugler: as outras e a
Rodrigo Kugler: E isso aqui ficaria na televisão daí, né?
Daniel Arthur Kugler: Aham. Essa aí pode ficar com as duas notas vai
Rodrigo Kugler: Aqui, ó. Aqui, ó. Aqui, ó. Aqui, ó. Desculpa.
Daniel Arthur Kugler: sair. Mas como que ela se mandou?
Rodrigo Kugler: Então,
Daniel Arthur Kugler: Como que ela? Desmontagem,
Rodrigo Kugler: tá.
Daniel Arthur Kugler: funilaria, pintura, montagem. É,
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: só faltou a preparação,
 
 
00:20:10
 
Rodrigo Kugler: Aí eu vou fazer o seguinte, eu vou diminuir essas colunas aqui,
Daniel Arthur Kugler: né?
Rodrigo Kugler: ó. Eu vou fazer um negócio que encaixe melhor aqui, fica um pouco melhor visualmente e alguma coisa que aproveite esse espaço aqui que tá vazio aqui, ó.
Daniel Arthur Kugler: É. Ou talvez aqui,
Rodrigo Kugler: Tá.
Daniel Arthur Kugler: ó, em vez daquela barra verde ali, colocar tipo quanto tempo tá ali, entendeu? A hora que dá o start ali, sei lá, ficar o contando timer, sei lá.
Rodrigo Kugler: Você acha que isso é é uma é interessante para
Daniel Arthur Kugler: É,
Rodrigo Kugler: você?
Daniel Arthur Kugler: você consegue ter uma noção quanto tempo esse carro tá em tal de departamento,
Rodrigo Kugler: Ah, aí eu te pergunto,
Daniel Arthur Kugler: entendeu?
Rodrigo Kugler: você vai conseguir cobrar ela para ela tá atualizando tudo em tempo real assim?
Daniel Arthur Kugler: Então, esse
Rodrigo Kugler: Porque isso isso vai ser diretamente proporcional à qualidade da visualização que você tem aqui, vai ser diretamente proporcional ao a exatidão que ela injetar o o o dado aqui. Porque se ela falar: "Ah, eu vou botar as horas só no fim do dia e a gente botar um contador", não faz sentido, né?
Daniel Arthur Kugler: Ah.
 
 
00:21:11
 
Rodrigo Kugler: Ela vai fazer em tempo real. Esse é um ponto, né? Mas não se preocupe com isso, isso são ajustes que vão vir no caminho, né? Aí eu voltando aqui, ó, eu tenho uma outra dashboard aqui. Essa era de comando. E eu lembro que tinha uma digestão aqui, mas acho que não tá aqui nesse. Deixa eu ver se tá aqui. Não, mas e aí a outra dashboard, né, que a gente tava conversando, era uma da parte de gestão com os seus resultados, né, despesas. E daí é isso que eu preciso de você, saber o que que você quer olhar nesse relatório gerencial teu,
Daniel Arthur Kugler: Uhum.
Rodrigo Kugler: tá? O que que o que que você quer ver no teu relatório eh tipo de fechamento e tal,
Daniel Arthur Kugler: Tá.
Rodrigo Kugler: o teu relatório de resultado?
Daniel Arthur Kugler: Despesas, né? O que foi o insumo, os meus insumos que eu gastei? Eh, questão de p***
Rodrigo Kugler: Ah,
Daniel Arthur Kugler: que pariu, como que eu ia falar?
Rodrigo Kugler: mão de obra.
Daniel Arthur Kugler: Mão de obra, venda,
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: né?
 
 
00:22:23
 
Daniel Arthur Kugler: A venda semanal. E eu, cara, o que eu tenho que ficar, eu ter uma visualização rápida é o que que eu tenho para entregar ou como que é meu cronograma, entendeu? Eh,
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: os carros tem que ter,
Rodrigo Kugler: agenda. Tá. Não, não,
Daniel Arthur Kugler: é isso aí.
Rodrigo Kugler: mas calma, isso é isso é outra coisa. Mas gerencial,
Daniel Arthur Kugler: financeiro,
Rodrigo Kugler: financeiro,
Daniel Arthur Kugler: financeiro eu não me preocupo muito, né? Esse eu só a minha venda bruta e a minha despesa bruta, que isso eu restante daí é por conta da do financeiro mesmo,
Rodrigo Kugler: tá?
Daniel Arthur Kugler: né?
Rodrigo Kugler: Uhum. Você cons você conseguiu configurar teu NBS aí para para
Daniel Arthur Kugler: É só para mim ter uma noção.
Rodrigo Kugler: usar,
Daniel Arthur Kugler: Consegui, mas o Roberto não passou minha senha ainda. Mas eu vou passar para eu vou pedir para ele logo,
Rodrigo Kugler: tá?
Daniel Arthur Kugler: depois eu
Rodrigo Kugler: Depois que você eh eh depois do almoço,
Daniel Arthur Kugler: almoço,
Rodrigo Kugler: a hora que você vê lá o teu relatório, cara, olha, deu uma olhada nas planilhas.
 
 
00:23:13
 
Rodrigo Kugler: Eu queria que você talvez você me ligue de novo de tarde aí. Daí o que que a gente faz?
Daniel Arthur Kugler: tá?
Rodrigo Kugler: você abre o NBS e eu começa a anotar o nome das colunas que eu acho que ia ficar interessante para você, tá? Porque o que que tipo olha olha o olha o que que a gente tá gerando aqui nesse produto aqui, no caso, para fazenda e para você também tentar abrir a cabeça para para pensar como aplicar isso no teu, tá? Eh, quando a gente fala aqui do app, a gente tem essa tela inicial, né? Pensa a mesma coisa, tá? Mesma estrutura. Aí eu vou clicar em painéis e métricas e aqui vai ter uma lista de dashboards que você pode colocar aqui, ó. Eu, ah, eu quero saber minha agenda. Vamos supor teu caso financeiro, tá? lavador, tá? Você pode colocar aqui agenda da oficina, agenda do lavador, você pode fazer várias coisas aqui, entendeu? Relatório financeiro, relatório operacional, relatório de produtividade por eh por eh colaborador. Então você vai poder visualizar tudo que cada um produziu em tempo real. Aí você vai poder também colocar os eh, cara, sei lá, é é meio que tipo, você tem que olhar paraas suas planilhas e e o teu sistema e decidir o que que você quer colocar aqui.
 
 
00:24:43
 
Rodrigo Kugler: Aí você vai ter essa lista aqui.
Daniel Arthur Kugler: Tá.
Rodrigo Kugler: Vamos supor o que que eu estou desenhando pro cloudin, tá? Pro pro cloud e da fazenda. Eu pensei um Ah,
Daniel Arthur Kugler: Parabéns.
Rodrigo Kugler: deixa eu voltar aqui porque acho que os primeiros, porque essa ferramenta é paga. Eu fiz só tem três, né? Daí eu fiz três em cada e-mail para poder fazer de graça, mas eu vou ter que comprar esse negócio aqui, não vai ter o que fazer. Eh, esse aqui é o Hotmail. Esse aqui é o DPW. Pera aí, deixa eu voltar. Tá. Ah, achei o outro dashboard aqui que eu que eu montei para você aquela outra vez. Só um pouco aí. O seguinte. Ah, aqui, ó, foi esse aqui, ó. Ó, receita, custo, ticket médio, tempo de permanência na oficina. Foi essa uma parada que eu falei para você que era importante você prestar atenção. Cronograma de serviço, né? Alguma coisa de estoque de peça aqui. Você pode eh criar um registro do que que tá faltando também. A gente pode olhar para isso aqui também, tá?
 
 
00:26:17
 
Rodrigo Kugler: E é isso, cara. Não acho que precise complicar muito mais que isso aqui,
Daniel Arthur Kugler: Não, não, não, não.
Rodrigo Kugler: né?
Daniel Arthur Kugler: É mais ou menos isso. Eu quero um troço simples pra gente começar,
Rodrigo Kugler: E se você se você quiser, daí você te tipo: "Ah, eu quero uma planilha do que eu tô olhando." Você vem aqui no cantinho,
Daniel Arthur Kugler: entendeu?
Rodrigo Kugler: clica em três pontinhos, tirar a planilha, entendeu? Mas você não vai botar a mão mais para ficar fazendo cont C, conttrl V, mais entendeu? Vai sair tudo automático em tempo real.
Daniel Arthur Kugler: Viu? Eu tem uma aí em Curitiba do seu Jorge Metrul.
Rodrigo Kugler: Угуm.
Daniel Arthur Kugler: Eles estão implantaram um sistema novo de funilaria lá na na funilaria deles e é muito grande a funilaria deles aí. E aí eu falei com Elso agora pra gente marcar um dia para ir ver como que eles estão usando o
Rodrigo Kugler: Угуm.
Daniel Arthur Kugler: sistema deles só para olhar, ver o que que aparece para eles,
Rodrigo Kugler: Угу.
Daniel Arthur Kugler: né? Porque assim, a gente tá criando um negócio novo, né, cara?
 
 
00:27:11
 
Daniel Arthur Kugler: Não, não tem ninguém assim que a gente olha,
Rodrigo Kugler: Угуm.
Daniel Arthur Kugler: ah, tem um cara focado no funilari que usa tal sistema. Existe alguns sistemas que vendem pronto para funilaria, só que não tem esse link entre NBS e Neó. Por isso que para mim não funcionando. Daí eu vou ter que alimentar dois,
Rodrigo Kugler: Não,
Daniel Arthur Kugler: né?
Rodrigo Kugler: aí a gente alimenta um e acabou. Entendeu?
Daniel Arthur Kugler: É por isso, por isso que tô falando,
Rodrigo Kugler: Você entendeu a sacada do negócio do João e da nossa empresa.
Daniel Arthur Kugler: é, não é bem bem bem mais
Rodrigo Kugler: É essa que é a pira. É essa que é a pira.
Daniel Arthur Kugler: interessante.
Rodrigo Kugler: E essa pira que você acabou de falar é o silo que eu te mostrei ali,
Daniel Arthur Kugler: Eh,
Rodrigo Kugler: tá ligado?
Daniel Arthur Kugler: eu
Rodrigo Kugler: Porque o silo a gente coloca coisa,
Daniel Arthur Kugler: quero
Rodrigo Kugler: se a gente colocar tudo sujo, tudo refinado, sem refinar, não adianta nada. Então, tipo, cara, e tem falar que capaz que mesmo nessa oficina grande que tem,
Daniel Arthur Kugler: é,
 
 
00:28:00
 
Rodrigo Kugler: é capaz que eles não tm uma coisa assim, é capaz,
Daniel Arthur Kugler: eu quero, não,
Rodrigo Kugler: tá?
Daniel Arthur Kugler: eu acho que não tem. Por isso que eu quero marcar essa reunião com eles lá e daí numa dessas eu dou um pulinho em Curitiba e vamos eu e você lá dar uma olhada, sabe? Só porque, cara,
Rodrigo Kugler: B
Daniel Arthur Kugler: lá a estrutura é a estrutura em si, estrutura deles de funilaria é impressionante. Os caras estão indo para 200 carro mês, entendeu? Então, e não é um espaço físico tão maior que o nosso,
Rodrigo Kugler: Ó,
Daniel Arthur Kugler: não.
Rodrigo Kugler: dá para dá para crescer, né?
Daniel Arthur Kugler: É, só que eu tô me, eu tô me batendo só na na organização.
Rodrigo Kugler: Não, não vai, entendeu?
Rodrigo Kugler: Ó,
Daniel Arthur Kugler: é, Dani, se você não te Isso aqui é importante porque isso aqui que te dá visibilidade, que te dá, tipo, você sabe o jeito que a tua oficina tá sem nem ir ali, entendeu? Você sabe o jeito que as coisas estão funcionando. Isso aqui é assim,
Daniel Arthur Kugler: Так.
Rodrigo Kugler: você tem que ter, vai ter que ter uma firmeza para pedir pra pessoa levar a sério as atualizações, senão não adianta nada.
 
 
00:28:54
 
Rodrigo Kugler: É igual aquelas CRM que foi colocado de vendas e que as os vendedores não usam, cara, não adianta, velho.
Daniel Arthur Kugler: Não levam não.
Rodrigo Kugler: Entendeu?
Daniel Arthur Kugler: Eles não estão nem aí. Estão c****** aqui
Rodrigo Kugler: É. E ó, o da fazenda assim, ó, a gente foi, a gente é um esboço ainda também, mas isso aqui tudo vai ficar dentro lá, tá? Ó, rentabilidade, receita, subsídio, custo, custo operacional, lucro líquido, eh processo de safra, eh quantos por cento que tá andando. Só que isso tudo vai depender também da quantidade de dado que ele vai imputar, tá? Então, fluxo de caixa, tá? Então, cada formulário que eu te mostrei dentro do da do aplicativo aqui, se eu for te mostrar o aplicativo de novo,
Daniel Arthur Kugler: É,
Rodrigo Kugler: ó,
Daniel Arthur Kugler: não tem enfermidade,
Rodrigo Kugler: a aqui é tudo teste, ó. É tudo teste, tá? Isso aqui é só fake,
Daniel Arthur Kugler: né?
Rodrigo Kugler: não tem nada aqui dentro. Mas cada um desses aqui, ó, esse aqui, exemplo, vai alimentar esse aqui. Esse aqui vai, exemplo, só vai alimentar esse aqui, entendeu?
 
 
00:29:58
 
Daniel Arthur Kugler: A única coisa que vai ser lançada no meu manual vai ser o lavagem, né?
Rodrigo Kugler: Uhum. Então, bota a guria que faz o negócio da da oficina, bota ela para controlar a lavagem também. você bota uma pessoa só, entendeu? Aí o que que acontece? A gente tem isso aqui, é tipo um overview, tá? Um uma visão geral do andamento da e como que tá as coisas, tá? Uma visão geral, tá? Aí ferramentas específicas que ele precisa, tá? Contas a apagar, tá? Ele clica lá dentro do app dele, vai sair aqui,
Daniel Arthur Kugler: Só um segundo,
Rodrigo Kugler: ó.
Daniel Arthur Kugler: viu aquele vinho para embora agora? Não, Luiz. É, eu acho que tem algum detalhe para fazer naquela traca a gente vai fazer da batida traseira para ele ver. Ah, martelinho não vai ficar o dia todo aí, tá? Beleza.
Rodrigo Kugler: Aí, cotas a pagar, que que tem vencendo hoje? Que que vai, que que vence na semana? Qual que é o saldo projetado para daqui 30 dias? Eh, qual que as despesas, as categorias das despesas que eu tenho paraa semana 1, 2, 3 e 4 desse mês, tá?
 
 
00:31:17
 
Rodrigo Kugler: Qual que é a fila de pagamentos? O que que eu tenho que fazer hoje? O que que eu tenho que fazer essa semana? Que que eu tenho que fazer no próximo mês? Você tá entendendo? Projeção do saldo bancário, tá? a pagar. Tá, agora volta. Isso tudo vai ficar linkcado dentro da plataforma aí.
Daniel Arthur Kugler: É, tem um monte
Rodrigo Kugler: Cotas a pagar, cotas a receber, tá? Olha que animal, ó. Total a receber da safra atual, total a receber de safras passadas inadimplência próximos de 30 dias. Janeiro, tenho que receber desse cara, cooperativa, não sei o quê, tanto desse cara, tanto, desse cara, tanto. Ó, uma visão do ano, ó, aqui, ó.
Daniel Arthur Kugler: O quê?
Rodrigo Kugler: Tá aí, aqui, ó, uma visão detalhada de recebíveis por cliente, entendeu? por cliente,
Daniel Arthur Kugler: Aham.
Rodrigo Kugler: tá?
Daniel Arthur Kugler: Ya,
Rodrigo Kugler: Daí volta isso aqui.
Daniel Arthur Kugler: esse tesão para frente.
Rodrigo Kugler: Você pode pensar, Dani, o que que eu tô, por que que eu tô falando isso para você?
 
 
00:32:21
 
Rodrigo Kugler: Por que que eu tô falando isso para você? Porque eu acho que com o NBS inteiro ali deveria você começar pela pela pela funilaria e oficina e demonstrar que isso funciona e trazer isso pro âmbito total da concessionária depois, entendeu? Porque ter um monte de papel eh impresso lá de relatório e não saber não adianta, não adianta, entendeu? Se a gente mostrar para eles que isso aqui é um caminho mais fácil ainda para eles, p****, isso aqui vai ser uma coisa fantástica,
Daniel Arthur Kugler: Não tem nem o que
Rodrigo Kugler: entendeu? Não tem, tipo, é é muito bom.
Daniel Arthur Kugler: falar.
Rodrigo Kugler: Agora, por exemplo, outras coisas que eu quero que porque eu quero convidar você a olhar paraa concessionária como um todo, olhar não só para para lataria e funilaria, mas olhar para peças,
Daniel Arthur Kugler: Eu
Rodrigo Kugler: olhar para outros departamentos, olhar para vendas, olhar para administrativo, olhar para tudo, entendeu? E começar a
Daniel Arthur Kugler: eu quero viu,
Rodrigo Kugler: pensar
Daniel Arthur Kugler: depois do almoço eu vou te ligar e vou te contar um negócio agora. Até não posso falar, né?
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: Mas eh te dá uma explanação do que o que tá acontecendo, né?
 
 
00:33:27
 
Rodrigo Kugler: Tá,
Daniel Arthur Kugler: Só você só para você ter uma noção depois.
Rodrigo Kugler: depois depois a gente conversa.
Daniel Arthur Kugler: Isso.
Rodrigo Kugler: Ó, outro exemplo top top. Para mim esse aqui foi um dos dashboard que eu achei mais pesão, velho. Olha a dashboard do silo, velho. Olha isso, velho. Olha que coisa linda, velho. Olha, olha o silo aqui, ó. Cilo um, silo dois, silo três, silo 4. Total de capacidade, total o que que tem, tá? A gente tem 18, 12 toneladas de 12.000 toneladas de soja para vender, 5600 toneladas de milho. Tá no silo B, tá no silo A, tá? Que que tá carregando, entendeu? Só que é óbvio que isso aqui provavelmente ele não vai querer pôr, porque isso aqui vai exigir ter funcionário botando dado toda hora. Então tudo você tem que relevar qual que é o nível de granularidade e o que que é importante você ver dentro do teus relatórios, tá? Voltando aqui, ó. Ó, estoque de insumo. Que que eu tenho que tá acabando?
 
 
00:34:37
 
Rodrigo Kugler: Estoque baixo. p***, vai acabar isso aqui. Eu preciso ficar atento, pedir mais, entendeu? Setar os dados, ó. Alerta de estoque crítico, glifosato 480 g por litro. Tá acabando. Ver todos os alertas. Vê aqui, ó. Qual que é defensivo, sementes, qual que é o o valor do meu do meu estoque? Você não tem hoje uma visibilidade assim, que que eu tenho de óleo para vender?
Daniel Arthur Kugler: No.
Rodrigo Kugler: Que que eu tenho de não sei o que para vender? Que que eu tenho de peça para vender? O que que tá velho dentro do meu estoque? Tá entendendo?
Daniel Arthur Kugler: É tesão. Isso aí a gente vai ter que fazer com calma e fazer para as peças
Rodrigo Kugler: Isso tudo isso tem que não com pressa não tem.
Daniel Arthur Kugler: também.
Rodrigo Kugler: É, é um trabalho de formiguinha, entendeu? Só que como o NBS tá tudo dentro já, já tá bem mais fácil, velho.
Daniel Arthur Kugler: Mais
Rodrigo Kugler: Muito bem mais muito mais fácil.
Daniel Arthur Kugler: fácil.
Rodrigo Kugler: Entenda que que lá na fazenda a gente vai ter que fazer formulário para tudas essas coisas aqui.
 
 
00:35:28
 
Daniel Arthur Kugler: Aham.
Rodrigo Kugler: E tem formulário que a gente vai automatizar através de áudio no WhatsApp. Tem formulário que a gente vai, por exemplo, a gente tá com a ideia de fazer um formulário no com o agente de A, que o Alessandro tá na lavoura, manda um áudio no Whats aplicando glifosato, tal, tantas, tanta quantidade no talhão, tal, pum, aquilo já faz o rateio, já faz as paradas, já joga e gera contabilidade de custo, que é o seguinte, é o próximo dashboard, que a contabilidade de custo, ah, tem uma parte de eh Eh, e de eficiência operacional aqui também, ó. Gestão de maquinário. Quantas máquinas aqui, ó, um gráfico, litros de consumo aqui, horas de utilização. Então, se ele tá aqui, ó, verde, ó, massa e Ferguson, ó, tá de boa. Só que tá vendo esse ponto vermelho aqui, ó, esse John Deer tá gastando demais.
Daniel Arthur Kugler: Ja.
Rodrigo Kugler: Que será que aconteceu? Será que ele tá com algum problema? Tá entendendo o valor que isso gera? Se ele achar um problema na máquina e a máquina tá gastando, vamos dizer, 10, 15 L de diesel a mais por dia, cara, grana, dinheiro, entendeu?
 
 
00:36:45
 
Rodrigo Kugler: Olha, olha a lista do maquinário,
Daniel Arthur Kugler: É, fica bem joia.
Rodrigo Kugler: tá? Eh, e o último, só para não tomar mais muito teu tempo aí, porque eu queria ter o feedback, porque eu não mostrei isso para ele. Quero saber se faz sentido ou
Daniel Arthur Kugler: Não, ficando mal. F mal.
Rodrigo Kugler: não.
Daniel Arthur Kugler: Agora como que vai ser feito o preenchimento? É diferente, né?
Rodrigo Kugler: Exatamente. Ó, esse dashboard aqui, muito importante também.
Daniel Arthur Kugler: Já vou subir.
Rodrigo Kugler: E essa dashboard aqui, cara,
Daniel Arthur Kugler: Pede para ela descer aqui.
Rodrigo Kugler: olha isso. Isso aqui é contabilidade de custo, tá?
Daniel Arthur Kugler: Desligou.
Rodrigo Kugler: Para ele saber aqui, ó, distribuição de custos por fazenda, tá? Custo total da safra, custo por hectare médio, desvio de orçamento. Por exemplo, fiz um orçamento que ia gastar tanto, tô gastando 3.2% a mais. ou sei que tô gastando 10% a menos, entendeu?
Daniel Arthur Kugler: Ele tá para você descer aqui
Rodrigo Kugler: Fertilizantes, custo de por alquere forçado versus
 
 
00:37:50
 
Daniel Arthur Kugler: baixo. Não,
Rodrigo Kugler: executado.
Daniel Arthur Kugler: mal ficou bem completo.
Rodrigo Kugler: f***, né?
Daniel Arthur Kugler: O detalhe é só como que preenche,
Rodrigo Kugler: Uhum.
Daniel Arthur Kugler: né?
Rodrigo Kugler: Então, eh, é esse é o caminho que a gente tá buscando assim, sabe,
Daniel Arthur Kugler: Não,
Rodrigo Kugler: de entregar esse tipo de valor pro cliente.
Daniel Arthur Kugler: esse programa aí vai ficar bem legal pra agricultura,
Rodrigo Kugler: Eu acho que sim. E eu acho que,
Daniel Arthur Kugler: viu?
Rodrigo Kugler: cara, eu acho que é meio que inédito assim, cara. Eu acho que ninguém tem esse nível de detalhe assim, sabe? Eu eu eu olhei o agriwin,
Daniel Arthur Kugler: Não,
Rodrigo Kugler: lá, é uma porcaria aquele sistema, velho.
Daniel Arthur Kugler: eh, bem, ficou bem completo mesmo, bem joia.
Rodrigo Kugler: E ele e não tá confuso, tá fácil de entender, né?
Daniel Arthur Kugler: Tá, tá bem
Rodrigo Kugler: Mas é isso, P. Eu queria te mostrar. Quero que você entre aí e agora e veja,
Daniel Arthur Kugler: bem.
Rodrigo Kugler: entre no NBS, me mande tua planilha do Excel aí. E a gente já constrói a planilha que a guria vai usar para fazer o controle, já construi uma planilha de de gestão de de lavador, tá?
 
 
00:38:51
 
Rodrigo Kugler: E é isso, lenha, tá? Depois daí a gente também tem que conversar sobre o quanto que é o custo disso, tá? Porque eu vou eu vou falar com o João, porque do jeito que a gente tava pensando, a gente tava pensando de vender um um treco para você, vender uma aplicação e depois deixar na mão do Roberto pro Roberto tocar, sabe? Só que se for para jogar nesse sistema que a gente tá trabalhando,
Daniel Arthur Kugler: Tá.
Rodrigo Kugler: isso não vai dar certo se eu falar pro Roberto administrar ali, entendeu? Então acho que é melhor você ficar com a gente, entendeu?
Daniel Arthur Kugler: É, se você me dê uma um um um número,
Rodrigo Kugler: E
Daniel Arthur Kugler: eu falo assim, ó, vai custar X, vai fazer tanto,
Rodrigo Kugler: tá,
Daniel Arthur Kugler: a gente senta e conversa,
Rodrigo Kugler: eu vou eu vou te explicar o que que eu fiz pro Claudinho,
Daniel Arthur Kugler: entendeu?
Rodrigo Kugler: tá? Ou você quer que eu te explique à tarde?
Daniel Arthur Kugler: Me explica, tá? Porque daí você vai ver o que eu preciso. Eu vou vou almoçar, na volta, vou abrir o NBS, vou pegar o que eu preciso do NBS, vou printar e vou mandar para você. Fechou?
 
 
A transcrição foi encerrada após 00:39:55

Esta transcrição editável foi gerada por computador e pode conter erros. As pessoas também podem alterar o texto depois que ele for criado.
