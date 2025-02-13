# Usando a imagem oficial do Ruby 2.6.7
FROM ruby:2.6.7-slim

# Definir diretório de trabalho
WORKDIR /rails

ENV RAILS_ENV="production"

# Instalar dependências do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential libpq-dev git curl nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Instalar versão correta do Bundler
RUN gem install bundler -v 2.4.10

# Copiar arquivos do Gemfile e instalar gems
COPY Gemfile Gemfile.lock ./
RUN bundle _2.4.10_ install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ /usr/local/bundle/cache

# Copiar arquivos do package.json e instalar dependências do frontend
COPY package.json yarn.lock ./
RUN npm install -g yarn && yarn install --frozen-lockfile

# Copiar todo o código do app
COPY . .

# Precompilar os assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Definir usuário Rails
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Configurar o entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expor a porta do servidor Rails
EXPOSE 3000

# Comando padrão para iniciar a aplicação
CMD ["./bin/rails", "server"]
