# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim AS base

# Definir diretório da aplicação
WORKDIR /rails

# Variáveis de ambiente da aplicação
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# Instalar Node.js e Yarn (sem nvm)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl gnupg2 build-essential libpq-dev libvips pkg-config git \
      ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Fase de build
FROM base AS build

# Copiar Gemfile e instalar gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache

# Copiar todo o código da aplicação
COPY . .

# Pré-compilar bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# Pré-compilar assets com dummy key
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Fase final (runtime)
FROM base

# Instalar pacotes de runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Criar usuário seguro para rodar o Rails
RUN useradd rails --create-home --shell /bin/bash

# Copiar arquivos da fase de build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Dar permissão para pastas necessárias
RUN chown -R rails:rails /rails/db /rails/log /rails/tmp /rails/storage

USER rails

# Entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Porta padrão do Rails
EXPOSE 3000

# Comando padrão
CMD ["./bin/rails", "server"]
