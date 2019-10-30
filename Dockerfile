FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev
RUN mkdir /instabug
WORKDIR /instabug
COPY ./ /instabug
RUN bundle install
