FROM ruby:2.3.0-alpine

RUN apk update && apk add tzdata \
  && cp -r -f /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apk add --update --no-cache \
      build-base \
      nodejs \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev
RUN bundle config build.nokogiri --use-system-libraries


RUN mkdir /app
WORKDIR /app

COPY Gemfile* ./
RUN bundle install --binstubs

COPY . .

#CMD ["bin/rails", "server", "-b", "0.0.0.0"]
CMD ["puma", "-C", "config/puma.rb"]

