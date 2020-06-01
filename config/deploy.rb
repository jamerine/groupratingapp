# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "groupratingapp"
set :repo_url, "git@bitbucket.org:switchbox/arm-group-rating.git"

# Default branch is :master
set :branch, ENV['branch'] || 'master'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/environments/production.rb"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

# Default value for default_env is {}
set :default_env, { path: "/home/deploy/.gem/ruby/2.3.0/bin:$PATH" }

namespace :deploy do
  after :restart, 'sidekiq:restart'
end

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure