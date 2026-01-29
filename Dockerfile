FROM ruby:3.2.2-slim

WORKDIR /oyasumi
COPY . .
RUN apt-get update && apt-get install -y --no-install-recommends \
  bash \
  tzdata \
  libpq-dev \
  build-essential \
  ruby-dev \
  && rm -rf /var/lib/apt/lists/*

RUN bundle install

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
