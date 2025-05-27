 #!/usr/bin/env bash
 set -o errexit

 # tell Rails we’re in production
 export RAILS_ENV=production

 # run migrations + seed once (on every deploy/start)
 bundle exec rake db:migrate --trace
 bundle exec rake db:seed --trace

 # now start the web server and bind to the port Render provides
 exec bundle exec puma -C config/puma.rb
