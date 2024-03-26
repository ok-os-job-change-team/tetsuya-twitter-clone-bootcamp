FROM ruby:3.3

RUN gem install rails

RUN apt-get update && \
  apt-get install -y nodejs