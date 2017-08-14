FROM ruby:2.4.1-stretch
RUN apt-get update -qq && apt-get install -y build-essential libmariadbclient-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
RUN chmod +x start_server.sh
