FROM ruby:2.6.5

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends build-essential apt-utils

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN apt-get install -y nodejs

# Install newest bundler
RUN gem install bundler -v '2.0.2'

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
