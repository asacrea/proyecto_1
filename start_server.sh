#!/bin/sh
bundle install
rake db:create
rake db:migrate
RAILS_ENV=development rails s -p 3000 -b '0.0.0.0'
