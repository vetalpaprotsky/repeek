FROM ruby:2.4.0

RUN apt-get update -qq && apt-get install -y build-essential

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for a JS runtime
RUN apt-get install -y nodejs

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD . $APP_HOME

RUN gem update bundler
RUN bundle install --path vendor/bundle --without development test
RUN rake assets:precompile RAILS_ENV=production