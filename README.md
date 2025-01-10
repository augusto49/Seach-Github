# petize

**O APK do projeto esta na pasta raiz, nome Teste-Petize.apk**

**Aplicação de Busca de Desenvolvedores GitHub:**

Esta aplicação Flutter foi desenvolvida como parte de um teste técnico, com o objetivo de demonstrar habilidades em desenvolvimento mobile e conhecimentos sobre a API do GitHub. Os principais aspectos abordados foram:

**Funcionalidades Principais:**

*   **Busca de Usuários:**
    *   Permite pesquisar perfis de desenvolvedores do GitHub através do nome de usuário.
    *   Exibe os dados do usuário, como nome, avatar, bio, número de seguidores/seguindo, empresa, localização e links (e-mail, site e Twitter).
    *   Possui um loading enquanto a pesquisa é feita.
*   **Listagem de Repositórios:**
    *   Exibe a lista de repositórios do usuário pesquisado, com informações como nome, descrição, número de estrelas e data da última atualização.
    *   Possui scroll infinito para carregar mais repositórios quando necessário, com paginação de 10 itens por requisição.
     * Os repositórios possuem um link para o repositório original no GitHub.
    *  O usuário pode ordenar a lista de repositórios por nome, data de criação, atualização ou envio.
*   **Sugestões de Pesquisa:**
    *   Salva as últimas 5 pesquisas de nome de usuário em um armazenamento local seguro.
    *   Exibe as pesquisas salvas como sugestões abaixo do campo de pesquisa.
    *   As sugestões são filtradas em tempo real enquanto o usuário digita, exibindo apenas aquelas que começam com o texto digitado.
*   **Links Externos:**
    *   Abre os links do perfil do usuário (e-mail, site e Twitter) em uma WebView dentro do app.
    *  Possui loading enquanto a página na webview está carregando.
*  **Responsividade:**
    *  As telas são totalmente responsivas utilizando `MediaQuery` e widgets do tipo `Flex` como `Row`, `Column`, `Expanded` e `Flexible`.
    *  Adaptação da tela para layout mobile e desktop, onde a tela de perfil possui um layout lateral com as informações do usuário e os repositórios em tela cheia no layout desktop e para o layout mobile as informações e os repositórios são mostradas na mesma coluna.
*  **Gerenciamento de Estado:**
    * O app utiliza `Bloc` para gerenciamento do estado.
*   **Testes Unitários:**
    *   Possui testes unitários para os serviços de listagem de usuário e listagem de repositórios.

**Requisitos Técnicos Atendidos:**

*   Utilização do Flutter Modular para gerenciamento de dependências e rotas.
*   Uso de `MediaQuery` e `Flex` widgets para a responsividade.
*   Implementação de duas rotas nomeadas: "home" (busca) e "profile" (perfil).
*   Abertura de links externos em uma WebView.
*   Consumo da API do GitHub com o pacote `http`.
*   Utilização de `Bloc` para gerenciamento de estado.
*   Armazenamento local seguro das últimas pesquisas.
*   Geração de APK em versão de release com chave de assinatura.

*   O projeto foi desenvolvido com foco em atender os requisitos solicitados, onde foi explorado o conhecimento em conceitos básicos do Flutter com um desafio real.

