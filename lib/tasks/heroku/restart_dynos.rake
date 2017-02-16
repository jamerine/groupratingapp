namespace :heroku do
  desc 'restarts all the heroku dynos so we can control when they restart'
  task :restart_dynos => :environment do
    curl -n -X DELETE https://api.heroku.com/apps/groupratingapp/dynos \
    -H "Content-Type: application/json" \
    -H "Accept: application/vnd.heroku+json; version=3"
  end
end
