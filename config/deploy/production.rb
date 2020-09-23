server "64.225.21.47", user: "deploy", roles: %w{app db web}
set :sidekiq_processes, 5
# set :slack_url, ENV['WEBHOOK_URL']
# set :slack_channel, ['#arm-errors']
# set :slack_username, 'groupratingapp'
