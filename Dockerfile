FROM ruby:3.2.2-alpine

WORKDIR /oyasumi
COPY . .
RUN apk update && apk add --update --no-cache \
  bash \
  tzdata \
  libpq-dev
RUN apk --update add --virtual build-dependencies \
    build-base ruby-dev libc-dev && \
    bundle install && \
    apk del build-dependencies

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
