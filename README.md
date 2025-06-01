# Eventify

**Aluno:** Carlucio Luis dos Santos  
**Email:** carlucios@gmail.com  

Eventify é um sistema web de gerenciamento de eventos e artigos, com funcionalidades voltadas tanto para usuários comuns quanto para promotores e autores. A aplicação permite o cadastro e login seguro via JWT, criação e visualização de eventos/artigos, além de um dashboard com notificações em tempo real.

Desenvolvido com Ruby on Rails 8, o projeto aplica conceitos modernos de arquitetura, filas de background, e componentes reativos com Hotwire. Foi projetado para ser simples de usar, mas com estrutura sólida e escalável, servindo como base para projetos mais robustos ou aplicações reais.

---

## 📦 Tecnologias Utilizadas

- [Ruby](https://www.ruby-lang.org/pt/) 3.2.2
- [Ruby on Rails](https://rubyonrails.org/) 7.1.3
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

## ✅ Funcionalidades implementadas

- Autenticação com JWT: Cadastro e login seguro com Devise + JWT.
- CRUD de eventos e artigos: Gerenciamento completo para promotores e autores.
- Dashboard dinâmico: Painel com visão geral para estudantes e profissionais.
- Notificações automáticas: Alertas quanto a eventos/autores de interesse via background jobs.
- Notificações em tempo real: Atualizações ao vivo com Turbo Streams (Hotwire).

## 🧠 Conceitos aplicados

Abaixo estão os conceitos aprendidos e aplicados neste projeto, junto com a justificativa de sua utilização:

### 1. **Padrao MVC com Repositories**

O padrão MVC é padrão do Rails e como esse é um sistema pequeno, foi mantido, pra facilitar a separação de responsabilidades. A inclusão do padrão Repository serve para isolar regras de acesso a dados, facilitando testes e permitindo futuras mudanças no ORM. Toda a comunicacao dos ORMs Event/Article/Follow foi feita através de repositories.

### 2. **ActiveJob + Callbacks e ActiveQueue + Sidekiq**

A fila de jobs foi usada para que as tarefas de agendamento de notificações fossem processadas em background, com vistas a melhora da performance da aplicação. Foram feitas duas filas de notificações, notificaçao de follow/unfollow, o qual usou  callbacks para disparar as notificaçoes, e notificaçao de upcoming event, o qual utiliza a fila recurrent do AciveQueue.
SolidQueue foi escolhido por ser uma fila moderna, local e bem integrada ao Rails 8.

### 3. **Design Pattern Observer com ActiveSupport::Notification**

O ActiveSupport::Notification permite um publicar/subscrever desacoplado entre os eventos do sistema e os consumidores de notificação. Ele foi usado a fim de permitir o envio de notificaçoes em tempo real por parte do sistema e consumo dessas notificaçoes por parte dos usuários de forma personalizada.

### 4. **Middleware personalizado com métricas do webservice**

Um middleware customizado foi adicionado para verificar a saúde da aplicação e exibir no rodapé da interface. Isso pode ser útil para detectar rapidamente se há falhas de conexão com serviços essenciais como banco de dados ou fila de jobs, durante o uso da aplicação.

### 5. **Stimulus + Hotwire**

Essas tecnologias permitem a criação de uma UI moderna, reativa e com comportamento de SPA, sem a complexidade de front-ends como React ou Vue.
Stimulus foi utilizado para dar dinamicidade e responsividade às interações com componentes do frontend.
Hotwire é ideal para manter a produtividade do Rails, com renderizações parciais, atualizações automáticas via Turbo Frames. Além dele ter sido essencial pra implementar o frontend SPA, sem ele, teria sido necessário a instalaçao do Websockets a fim de implementar o recebimento em tempo real das notificações.

### 6. **Rubocop + Reek**

Essas ferramentas automatizam a verificação de padrões de código e detectam smells (como métodos longos ou classes grandes). Com isso, o código permanece limpo, legível e dentro das boas práticas de Ruby e Rails, garantindo a manutenção do projeto a longo prazo.