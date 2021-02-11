# server "64.225.21.47", user: "deploy", roles: %w{app db web}
server "134.209.171.76", user: "deploy", roles: %w{app db web}
set :sidekiq_processes, 2
set :sidekiq_env, :production
# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/environments/production.rb"
# set :slack_url, ENV['WEBHOOK_URL']
# set :slack_channel, ['#arm-errors']
# set :slack_username, 'groupratingapp'
