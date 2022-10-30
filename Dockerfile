FROM ruby:2.7.6-slim

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev default-libmysqlclient-dev netcat
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app
EXPOSE 3001

ENTRYPOINT ["sh", "./config/docker/startup.sh"]