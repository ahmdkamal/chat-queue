FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential default-libmysqlclient-dev
RUN mkdir /instabug
WORKDIR /instabug
COPY ./ /instabug
RUN gem update --system
RUN gem install bundler
RUN bundle install
