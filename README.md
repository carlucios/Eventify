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
- [SolidQueue](https://github.com/solidusio/solidus_queue) 
- [ActiveJob](https://api.rubyonrails.org/classes/ActiveJob.html)  
- [ActiveSupport::Cache](https://api.rubyonrails.org/classes/ActiveSupport.html)  
- [ActiveSupport::Notification](https://api.rubyonrails.org/classes/ActiveSupport/Notifications.html)  
- [Stimulus](https://stimulus.hotwired.dev/)  
- [Hotwire (Turbo Frames)](https://turbo.hotwired.dev/)  
- [Rubocop](https://rubocop.org/)  
- [Reek](https://github.com/troessner/reek)  

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

### 1. Padrão MVC com Repository

O padrão MVC, nativo do Rails, foi mantido para preservar a separação de responsabilidades. Como o sistema tem porte pequeno, não foi necessário aplicar arquiteturas mais complexas.  
A inclusão do padrão **Repository** teve como objetivo isolar as regras de acesso a dados, facilitando os testes e permitindo futuras alterações no ORM.  
Toda a comunicação com os modelos `Event`, `Article` e `Follow` foi feita por meio de repositórios. A exceção foi o modelo `User`, cuja gestão ficou sob responsabilidade do Devise.

---

### 2. ActiveJob + SolidQueue + Callbacks

Jobs foram utilizados para agendamento e envio de notificações em segundo plano, melhorando a performance e a experiência do usuário. Duas filas principais foram implementadas:

- **Notificações de Follow/Unfollow:** Disparadas via *callbacks* do Rails.  
- **Notificações de eventos futuros:** Agendadas diariamente utilizando a fila recorrente do SolidQueue.

O `SolidQueue` foi escolhido por ser o backend de fila padrão do Rails 7.1+, leve, embutido e com excelente integração nativa. O adaptador de fila foi configurado para `:solid_queue` no `ActiveJob`.

---

### 3. Armazenamento Temporário com ActiveSupport::Cache

As notificações são armazenadas no cache da aplicação utilizando `ActiveSupport::Cache`, evitando a necessidade de persistência em banco de dados.  
Esse armazenamento temporário oferece leitura rápida e se beneficia do uso de SSDs, além de estar disponível por padrão no Rails moderno.

---

### 4. Observer Pattern com ActionCable + Redis

O `ActionCable` foi usado para implementar o padrão Observer (publicador/assinante), possibilitando um sistema desacoplado de eventos internos.  
Esse mecanismo permite que diferentes partes da aplicação ouçam e reajam a eventos, como a criação ou atualização de recursos, sem dependências diretas entre os componentes.

---

### 5. Middleware Personalizado para prevensão de ataques DDoS



---

### 6. Stimulus + Hotwire (Turbo)

As bibliotecas **Stimulus** e **Hotwire (Turbo)** foram utilizadas para criar uma interface moderna e responsiva, com comportamento de SPA (*Single Page Application*), sem abrir mão da simplicidade do stack Rails:

- **Stimulus:** Responsável pela adição de interatividade leve e controle de comportamento nos elementos da UI.  
- **Hotwire:** Permite atualizações em tempo real com Turbo Streams e renderizações dinâmicas com Turbo Frames, eliminando a necessidade de frameworks front-end como React ou Vue.  
  Também foi essencial para o recebimento em tempo real de notificações, substituindo a necessidade de configurar WebSockets manualmente.

---

### 7. RuboCop + Reek

Ferramentas de análise estática utilizadas para garantir a qualidade do código:

- **RuboCop:** Verifica aderência a padrões de estilo e boas práticas da comunidade Ruby.  
- **Reek:** Detecta *code smells* como métodos longos, classes grandes e responsabilidades duplicadas.

Essas ferramentas ajudam a manter o código limpo, sustentável e fácil de dar manutenção a longo prazo.

---

## 🚀 Teste de Performance: Follows/Unfollows

Para medir a performance da criação e remoção de follows em usuários, eventos e artigos, você pode usar a task Rake `performance:follows`.

### Como rodar

```bash

bundle exec rake performance:follows TOTAL=10000

```

## ✉️ Contato

Carlucio Luis dos Santos  
📧 [carlucios@gmail.com](mailto:carlucios@gmail.com)  
🔗 [https://github.com/carlucios](https://github.com/carlucios)