FROM ruby:2.6.7-slim

WORKDIR /rails

ENV RAILS_ENV="production"

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      postgresql-client \
      libpq-dev \
      git \
      curl \
      tzdata && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
      apt-get install -y nodejs && \
      npm install -g npm@latest

RUN gem install bundler -v 2.4.13

COPY Gemfile Gemfile.lock ./
RUN bundle _2.4.13_ install --jobs 4 --retry 3

COPY package.json yarn.lock ./

RUN npm install

COPY . .

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["./bin/rails", "server"]
