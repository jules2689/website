FROM ruby:2.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN bundle exec rake assets:precompile RAILS_ENV=production SKIP_EJSON=true

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
