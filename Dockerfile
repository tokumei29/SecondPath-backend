FROM ruby:3.3.0-slim

ENV APP_HOME=/app \
    BUNDLE_PATH=/usr/local/bundle

WORKDIR $APP_HOME

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN mkdir -p tmp/pids

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
