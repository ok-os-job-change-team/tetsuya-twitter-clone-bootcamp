FROM ruby:3.2.2

RUN gem install rails

RUN apt-get update && \
  apt-get install -y nodejs && \
  apt-get install -y default-mysql-client
COPY Gemfile Gemfile.lock ./
RUN bundle install
