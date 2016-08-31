web: bundle exec puma -C config/puma.rb
resque: env TERM_CHILD=1 bundle exec rake resque:work
heroku ps:scale resque=2 --app groupratingapp
