until nc -z -v -w30 $DB_HOST $DB_PORT; do
 echo 'Waiting for MySQL...'
 sleep 1
done
echo "MySQL is up and running!"

bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:create db:migrate db:seed
echo "Done!"

bundle exec puma -C config/puma.rb