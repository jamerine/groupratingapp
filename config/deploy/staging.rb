# server "64.225.21.47", user: "deploy", roles: %w{app db web}
server "159.89.240.32", user: "deploy", roles: %w{app db web}
set :sidekiq_processes, 1
set :stage, :staging
set :rails_env, :staging
set :sidekiq_env, :staging
set :branch, ENV['branch'] || 'staging'

set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/var/www/#{fetch(:full_app_name)}"

append :linked_files, "config/database.yml", "config/environments/staging.rb"

# set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
# server '45.55.56.82', user: 'root', roles: %w{web app db}, primary: true
# #end things to edit
#
# set :unicorn_worker_count, 5
# set :unicorn_config_path, "#{fetch(:deploy_to)}/shared/config/unicorn.rb"
#
# set :enable_ssl, false
# set(:symlinks, [
#   {
#     source: "nginx.conf",
#     link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
#   },
#   {
#     source: "unicorn_init.sh",
#     link: "/etc/init.d/unicorn_#{fetch(:full_app_name)}"
#   }
# ])
#
# # before 'deploy', 'swagger:build_docs'
