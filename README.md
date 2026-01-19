# 🔍 Search GitHub

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Bloc](https://img.shields.io/badge/Bloc-State_Management-blue?style=for-the-badge)
![Modular](https://img.shields.io/badge/Modular-Dependency_Injection-orange?style=for-the-badge)

Aplicativo moderno para busca de perfis e repositórios do GitHub, desenvolvido em Flutter com foco em arquitetura limpa, responsividade e experiência do usuário.

## ✨ Funcionalidades

### 👤 Busca de Usuários

- **Pesquisa Inteligente:** Encontre qualquer desenvolvedor pelo nome de usuário.
- **Histórico e Autocomplete:**
  - Suas últimas 5 pesquisas ficam salvas.
  - Sugestões aparecem enquanto você digita (estilo dropdown flutuante).
  - Ícones intuitivos para histórico e seleção.
- **Design Premium:** Interface moderna com gradientes, sombras suaves e animações.

### 📄 Perfil Detalhado

- **Cartão de Informações:** Visualize nome, bio, seguidores, seguindo, e links sociais.
- **Layout Responsivo:**
  - **Mobile:** Design vertical otimizado para o toque.
  - **Desktop/Tablet:** Layout em duas colunas para aproveitar telas grandes.
- **Ações Rápidas:** Botões para abrir e-mail, site e Twitter diretamente.

### 📦 Repositórios

- **Listagem Completa:** Veja todos os projetos do usuário.
- **Filtros Avançados:** Ordene por Nome, Data de Criação, Última Atualização ou Pushed.
- **Paginação Infinita:** Scroll suave que carrega mais repositórios automaticamente.
- **WebView Integrada:** Abra os repositórios sem sair do app, com barra de progresso e controle de atualização.
- **Visualização em Cards:** Cards flutuantes com destaque para estrelas ⭐ e data 📅.

### 🛠️ Aspectos Técnicos

- **Arquitetura:** Modular + BLoC (Separação clara entre UI, Lógica e Dados).
- **Gerenciamento de Estado:** `flutter_bloc` para controle previsível e reativo.
- **Injeção de Dependência:** `flutter_modular`.
- **Responsividade:** Uso de `FittedBox`, `Wrap`, `Flexible` e `MediaQuery` para adaptação total (de celulares pequenos a monitores 4K).
- **Feedback Visual:** Skeleton loading (shimmer) e indicadores de progresso reais.

---

## 🚀 Como Instalar

### Opção 1: APK (Android)

O arquivo APK pronto para instalação está na raiz deste projeto:
**`app-release.apk`**

Transfira para seu celular e instale (habilite "Fontes Desconhecidas" se necessário).

### Opção 2: Código Fonte

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/seu-usuario/seach-github.git
    cd Seach-Github
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Execute o projeto:**
    ```bash
    flutter run
    ```

---

## 📱 Previews

_(Screenshots do app aqui)_

---

Desenvolvido com 💙 e Flutter.
