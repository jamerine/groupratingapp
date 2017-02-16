namespace :heroku do
  desc 'restarts all the heroku dynos so we can control when they restart'
  task :restart_dynos => :environment do
    DELETE /apps/groupratingapp/dynos
  end
end
