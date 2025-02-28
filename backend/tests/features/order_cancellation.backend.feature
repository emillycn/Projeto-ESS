Feature: Cancelamento de Pedidos.
As um usuário. 
I want to acessar os Pedidos e ter a possibilidade de solicitar o cancelamento de um pedido.
So that quando eu tiver algum contratempo ou mudar de ideia, eu possa cancelar o meu pedido.

Scenario: Cancelamento de pedido bem sucedido.
Given existe um usuário com id "3", com senha "senha_userId3", com nome "joao", email "joao@cin.ufpe.br", cpf "62238424490" e endereço "rua 1".
And um pedido com número "4", status "Pendente", tempo "02:00" e preço "50.00" está registrado nos pedidos do usuario de id "3".
When uma requisição de PUT com motivo "outros" e senha "senha_userId3" é enviada para "/clients/3/orders/4/cancellation". 
Then o status da resposta deve ser "200". 
And uma mensagem de "Pedido Cancelado" é retornada com id de pedido "4".

Scenario: Cancelamento mal sucedido (senha incorreta).
Given existe um usuário com id "1", com senha "senha_userId1", com nome "paulo", email "paulo@cin.ufpe.br", cpf "62238424490" e endereço "rua 10".
And um pedido com número "1", status "Pendente", tempo "03:00" e preço "24.90" está registrado nos pedidos do usuario de id "1".
When uma requisição de PUT com motivo "Pedi errado" e senha "###" é enviada para "/clients/1/orders/1/cancellation".
Then o status da resposta deve ser "401".
And uma mensagem de "Pedido não cancelado: senha incorreta!" é retornada com id de pedido "1".

Scenario: Cancelamento mal sucedido (pedido já cancelado).
Given existe um usuário com id "2", com senha "senha_userId2", com nome "luan", email "luan@cin.ufpe.br", cpf "03088762451" e endereço "CIn UFPE".
And um pedido com número "110320", status "Cancelado", tempo "04:00" e preço "190.00" está registrado nos pedidos do usuario de id "2".
When uma requisição de PUT com motivo "Surgiu um imprevisto" e senha "senha_userId2" é enviada para "/clients/2/orders/110320/cancellation".
Then o status da resposta deve ser "400".
And uma mensagem de "Pedido não cancelado: pedido já cancelado!" é retornada com id de pedido "110320".

Scenario: Cancelamento mal sucedido (pedido já aceito).
Given existe um usuário com id "1000", com senha "senha_userId1000", com nome "otavio", email "otavio@cin.ufpe.br", cpf "15160315470" e endereço "Arena Pernambuco".
And um pedido com número "2100", status "Aceito", tempo "03:21" e preço "51.44" está registrado nos pedidos do usuario de id "1000".
When uma requisição de PUT com motivo "Machuquei o ombro" e senha "senha_userId1000" é enviada para "/clients/1000/orders/2100/cancellation".
Then o status da resposta deve ser "400".
And uma mensagem de "Pedido não cancelado: pedido já foi aceito!" é retornada com id de pedido "2100".

Scenario: Cancelamento mal sucedido (cliente não existe).
Given existe um usuário com id "19", com senha "senha_userId19", com nome "carlos", email "carlos@cin.ufpe.br", cpf "32096524490" e endereço "Grad 04".
And um pedido com número "31302", status "Pendente", tempo "01:20" e preço "5.50" está registrado nos pedidos do usuario de id "19".
When uma requisição de PUT com motivo "Surgiu um imprevisto" e senha "senha_userId19" é enviada para "/clients/18/orders/31302/cancellation".
Then o status da resposta deve ser "404".
And uma mensagem de "Pedido não cancelado: cliente não existe!" é retornada com id de pedido "31302".

Scenario: Cancelamento mal sucedido (pedido não existe).
Given existe um usuário com id "112", com senha "senha_userId112", com nome "cleber", email "cleber@cin.ufpe.br", cpf "80081186444" e endereço "Mar das arábias".
And um pedido com número "111003221", status "Pendente", tempo "00:34" e preço "99.99" está registrado nos pedidos do usuario de id "112".
When uma requisição de PUT com motivo "Não quero mais" e senha "senha_userId112" é enviada para "/clients/112/orders/111003222/cancellation".
Then o status da resposta deve ser "404".
And uma mensagem de "Pedido não cancelado: pedido não existe!" é retornada com id de pedido "111003222".

Scenario: Cancelamento mal sucedido (tempo limite excedido).
Given existe um usuário com id "9090", com senha "senha_userId9090", com nome "caio", email "caio@cin.ufpe.br", cpf "48484186407" e endereço "São Januário".
And um pedido com número "1927", status "Pendente", tempo "05:34" e preço "100.01" está registrado nos pedidos do usuario de id "9090".
When uma requisição de PUT com motivo "Vasco perdeu" e senha "senha_userId9090" é enviada para "/clients/9090/orders/1927/cancellation".
Then o status da resposta deve ser "400".
And uma mensagem de "Pedido não cancelado: tempo limite excedido!" é retornada com id de pedido "1927".

Scenario: Carregamento pedidos bem sucedido.
Given existe um usuário com id "47", com senha "senha_userId47", com nome "hugo", email "hugo@cin.ufpe.br", cpf "46277441450" e endereço "CAC UFPE".
And um pedido com número "6578", status "Cancelado", tempo "03:40" e preço "9.99" está registrado nos pedidos do usuario de id "47".
And um pedido com número "8424", status "Aceito", tempo "04:20" e preço "56.77" está registrado nos pedidos do usuario de id "47".
When uma requisição de POST com senha "senha_userId47" é enviada para "/clients/47/orders".
Then o status da resposta deve ser "200".
And a mensagem possui número: "6578", status: "Cancelado", tempo "03:40" e preço "9.99". 
And a mensagem possui número: "8424", status: "Aceito", tempo "04:20" e preço "56.77".

Scenario: Carregamento pedidos mal sucedido (senha incorreta).
Given existe um usuário com id "10349", com senha "senha_userId10349", com nome "bigT", email "bigT@cin.ufpe.br", cpf "78558273405" e endereço "midori".
And um pedido com número "8657", status "Pendente", tempo "00:34" e preço "0.99" está registrado nos pedidos do usuario de id "10349".
And um pedido com número "4842", status "Aceito", tempo "02:42" e preço "1.90" está registrado nos pedidos do usuario de id "10349".
When uma requisição de POST com senha "senha_userId470" é enviada para "/clients/10349/orders".
Then o status da resposta deve ser "401".
And uma mensagem de "Acesso negado: senha incorreta!" é retornada com id de usuário "10349".

Scenario: Carregamento pedidos mal sucedido (cliente não existe).
Given existe um usuário com id "777", com senha "senha_userId777", com nome "paul", email "paul@cin.ufpe.br", cpf "62403319457" e endereço "abbey road".
And um pedido com número "11", status "Cancelado", tempo "00:59" e preço "4.50" está registrado nos pedidos do usuario de id "777".
And um pedido com número "4", status "Pendente", tempo "02:20" e preço "21.49" está registrado nos pedidos do usuario de id "777".
When uma requisição de POST com senha "senha_userId777" é enviada para "/clients/888/orders".
Then o status da resposta deve ser "404".
And uma mensagem de "Acesso negado: cliente não existe!" é retornada com id de usuário "888".