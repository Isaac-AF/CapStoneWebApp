#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean

 # print out which ENV and database URL we’ve got
 echo ">>> RAILS_ENV is [${RAILS_ENV:-not set}]"
 echo ">>> DATABASE_URL is [$DATABASE_URL]"

 # run migrations in production with trace
 bundle exec rake db:migrate RAILS_ENV=production --trace


bundle exec rake db:migrate
