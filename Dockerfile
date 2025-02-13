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
      nodejs \
      tzdata \
      && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Instalar Bundler
RUN gem install bundler -v 2.4.13

COPY Gemfile Gemfile.lock ./
RUN bundle _2.4.13_ install --jobs 4 --retry 3

COPY . .

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails

USER rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["./bin/rails", "server"]
