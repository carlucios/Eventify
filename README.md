# Eventify

**Aluno:** Carlucio Luis dos Santos  
**Email:** carlucios@gmail.com  

Eventify é um sistema web de gerenciamento de eventos e artigos, com funcionalidades voltadas tanto para usuários comuns quanto para promotores e autores. A aplicação permite cadastro e login seguros via JWT, criação e visualização de eventos e artigos, além de um dashboard com notificações em tempo real.

Desenvolvido com Ruby on Rails 8.0.2, o projeto aplica conceitos modernos de arquitetura, filas de background e componentes reativos com Hotwire. Foi projetado para ser simples de usar, mas com uma estrutura sólida e escalável, servindo como base para projetos mais robustos ou aplicações reais.

---

## 📦 Tecnologias Utilizadas

- [Ruby](https://www.ruby-lang.org/pt/) 3.4.3  
- [Ruby on Rails](https://rubyonrails.org/) 8.0.2 
- [PostgreSQL](https://www.postgresql.org/)  
- [Devise + JWT](https://github.com/waiting-for-dev/devise-jwt) para autenticação  

---

## 🚀 Como rodar o projeto localmente

```bash
# Clone o repositório
git clone https://github.com/carlucios/Eventify.git
cd Eventify

# Inicie o projeto dentro do Dev Container no VSCode

# Após isso, instale as dependências:
bundle install

# Configure o banco de dados
rails db:setup

# Inicie os serviços
rails server
```

---

## ✅ Funcionalidades Implementadas

- **Autenticação com JWT:** Cadastro e login seguros com Devise + JWT.  
- **CRUD de eventos e artigos:** Gerenciamento completo para promotores e autores.  
- **Dashboard dinâmico:** Painel com visão geral para estudantes e profissionais.  
- **Notificações automáticas:** Alertas sobre eventos e autores de interesse via jobs em background.  
- **Notificações em tempo real:** Atualizações ao vivo com Turbo Streams (Hotwire).  

---

## 🧠 Conceitos Aplicados

### 1. Padrão MVC com Repositories

O padrão MVC é nativo do Rails e, por ser um sistema de pequeno porte, foi mantido para facilitar a separação de responsabilidades. A inclusão do padrão Repository serviu para isolar as regras de acesso a dados, facilitando os testes e permitindo futuras mudanças no ORM. Toda a comunicação com os modelos `Event`, `Article` e `Follow` foi feita por meio de repositórios. A exceção foi o modelo `User`, cuja gestão ficou sob responsabilidade do Devise.

### 2. ActiveJob + Callbacks, SolidQueue + Sidekiq e ActiveCache

A fila de jobs foi utilizada para que tarefas de agendamento de notificações fossem processadas em background. Foram implementadas duas filas:

- **Follow/Unfollow:** Utilizando callbacks do Rails para disparar notificações.  
- **Eventos futuros:** Utilizando a fila recorrente do SolidQueue para envio diário de notificações sobre eventos próximos.

As notificações são armazenadas no ActiveCache, evitando persistência no banco e aproveitando a velocidade de leitura dos SSDs.

### 3. Observer Pattern com ActiveSupport::Notification

O `ActiveSupport::Notification` foi usado para implementar um padrão de publicação/assinatura desacoplado entre eventos do sistema e consumidores, permitindo envio e consumo de notificações em tempo real de forma personalizada.

### 4. Middleware Personalizado com Métricas

Um middleware customizado verifica a saúde da aplicação e exibe essas informações no rodapé da interface, útil para detectar falhas em serviços essenciais como banco de dados ou filas.

### 5. Stimulus + Hotwire

Tecnologias que permitem criar uma interface reativa, moderna e com comportamento de SPA:

- **Stimulus:** Para adicionar dinamismo às interações.  
- **Hotwire:** Para renderizações parciais, Turbo Frames e notificações em tempo real sem necessidade de WebSocket manual.

### 6. Rubocop + Reek

Ferramentas para análise estáica de código, garantindo legibilidade, limpeza e conformidade com boas práticas de Ruby e Rails.

---

## ✉️ Contato

Carlucio Luis dos Santos — [carlucios@gmail.com](mailto:carlucios@gmail.com)  
[https://github.com/carlucios](https://github.com/carlucios)
