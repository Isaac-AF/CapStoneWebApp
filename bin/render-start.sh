 #!/usr/bin/env bash
 set -o errexit

 # tell Rails we’re in production
 export RAILS_ENV=production

  echo "=== DB URL: $DATABASE_URL"
  bundle exec rails runner 'pp ActiveRecord::Base.connection_db_config.url'


 # run migrations + seed once (on every deploy/start)
 bundle exec rake db:migrate --trace
 bundle exec rake db:seed --trace

 # now start the web server and bind to the port Render provides
 exec bundle exec puma -C config/puma.rb
