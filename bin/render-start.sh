 #!/usr/bin/env bash
 set -o errexit

 # tell Rails we’re in production
 export RAILS_ENV=production

# DEBUG: print the DATABASE_URL
echo "=== DB URL: $DATABASE_URL"

# DEBUG: list existing tables
bundle exec rails runner 'pp ActiveRecord::Base.connection.tables'

# DEBUG: list applied migration versions
bundle exec rails runner 'pp ActiveRecord::SchemaMigration.all.map(&:version)'

 # run migrations + seed once (on every deploy/start)
 bundle exec rake db:migrate --trace
 bundle exec rake db:seed --trace

 # now start the web server and bind to the port Render provides
 exec bundle exec puma -C config/puma.rb
