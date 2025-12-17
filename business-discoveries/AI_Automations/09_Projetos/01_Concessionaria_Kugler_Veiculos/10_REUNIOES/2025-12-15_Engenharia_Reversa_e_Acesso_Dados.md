# Engenharia Reversa e Acesso a Dados - 15/12/2025

**Participantes:** Rodrigo Kugler, Daniel Arthur Kugler
**Data:** 15 de dezembro de 2025
**Tamanho das anotações:** Padrão

---

## Resumo
Rodrigo Kugler e Daniel Arthur Kugler discutiram a engenharia reversa do sistema NBS, que envolve a análise da documentação e APIs, e a necessidade de acesso ao banco de dados com credenciais de somente leitura, que Roberto usará para entender a origem dos dados que Daniel Arthur Kugler deseja visualizar e estimar o custo. As metodologias de serviço, que incluem um modelo foundation ou de taxa de manutenção, foram apresentadas, e Daniel Arthur Kugler se comprometeu a listar os dados de gestão que deseja incluir no relatório automatizado em tempo real. Além disso, eles conversaram sobre a ideia de um projeto de fazenda envolvendo Claudinho, que tem potencial de sucesso, com Rodrigo Kugler sugerindo um acompanhamento presencial para identificar oportunidades de dados gerados por maquinários modernos.

---

## Detalhes

### Engenharia Reversa e Acesso a Dados do NBS
Rodrigo Kugler destacou que o NBS é a fonte de dados e que eles já analisaram sua documentação e APIs, incluindo comandos para criar OS e registrar tempo, potencialmente úteis para uma ideia de "agente". O passo imediato necessário é realizar a engenharia reversa dos dados, o que envolve entender o que Daniel Arthur Kugler quer visualizar e rastrear a origem desses dados dentro do NBS. Rodrigo Kugler afirmou que o Roberto tem o conhecimento para acessar o banco de dados do NBS e que eles precisam do IP do servidor e entender a forma de acesso externo, provavelmente via VPN, conforme o método que Daniel Arthur Kugler confirmou que usam (00:01:08).

### Requisitos para Acesso e Definição de Serviço
Rodrigo Kugler solicitou que Daniel Arthur Kugler obtenha o IP do servidor e um usuário e senha com permissão de somente leitura de dados para a empresa, que será usado para a engenharia reversa dos dados (00:02:20). Eles também precisarão validar o acesso externo, o login, e se conseguem obter um token e a senha da API, além de testar um end point da API para retorno de dados, informações que Roberto saberá como proceder (00:03:18). Rodrigo Kugler explicou as duas metodologias de serviço: um tipo foundation, onde eles constroem a solução, fornecem treinamento e entregam para o cliente gerenciar; ou um modelo de taxa de manutenção para manter o sistema operacional, e eles precisam realizar a engenharia reversa para estimar o custo em horas (00:02:20).

### Visualização de Dados e Próximos Passos
Em relação à visualização, Daniel Arthur Kugler mencionou que a princípio é tranquilo, e Rodrigo Kugler sugeriu que ele liste todos os dados que deseja ver na gestão, como valor de peças, valor total de fechamento e valor de mão de obra. O objetivo é criar um relatório automatizado em tempo real para o computador de Daniel Arthur Kugler, sem a necessidade de intervenção. Daniel Arthur Kugler se comprometeu a tentar conversar com a pessoa responsável ainda hoje e solicitou que Rodrigo Kugler enviasse as anotações por escrito (00:04:30).

### Discussão sobre o Projeto da Fazenda
Rodrigo Kugler perguntou sobre a ideia de um projeto envolvendo Claudinho e a fazenda, que Daniel Arthur Kugler considerou que "dá uma grana legal" e que ele acredita que se eles fizerem um "produto tesão", terão potencial de sucesso (00:04:30). Eles concordaram que é necessário focar em um produto, e que o projeto de funilaria seria útil para adquirir experiência. Rodrigo Kugler mencionou que conversou com o tio, que está aberto a ajudar, e que talvez ele vá para a fazenda para fazer um acompanhamento presencial e descobrir oportunidades de dados. Eles especularam que a fazenda pode ter muitos dados gerados por maquinários modernos que não estão sendo utilizados e que a adição de inteligência artificial poderia mudar o cenário, como um chat para o produtor consultar informações de estoque (00:05:29).

---

## Próximas etapas sugeridas

- [ ] **Rodrigo Kugler:** Enviar a Daniel Arthur Kugler as anotações do que é preciso por escrito.
- [ ] **Daniel Arthur Kugler:** Falar com o Roberto para obter o IP do servidor e outros detalhes de acesso, incluindo a solicitação de criar um usuário e senha com permissão de somente leitura de dados.
- [ ] **Rodrigo Kugler:** Validar o acesso externo, login, a obtenção de um token/usuário/senha da API, e testar um end point da API retornando os dados.
