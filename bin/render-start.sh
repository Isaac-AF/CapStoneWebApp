#!/usr/bin/env bash set -o errexit

export RAILS_ENV=production

bundle exec rake db:migrate bundle exec rake db:seed

exec bundle exec puma -C config/puma.rb
