# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, "groupratingapp"
set :slack_channel, '#arm'
set :slack_username, 'Deploybot'
set :slack_emoji, ':trollface:'
set :slack_user, local_user.strip
set :slack_url, ENV['SLACK_URL']
set :slack_text, -> {
  elapsed = Integer(fetch(:time_finished) - fetch(:time_started))
  "Revision #{fetch(:current_revision, fetch(:branch))} of " \
  "#{fetch(:application)} deployed to #{fetch(:stage)} by #{fetch(:slack_user)} " \
  "in #{elapsed} seconds. \nURL: #{fetch(:url)}"
}
set :slack_deploy_starting_text, -> {
  "*#{fetch(:stage)}* deploy starting with revision/branch `#{fetch(:current_revision, fetch(:branch))}` for #{fetch(:application)}"
}
set :slack_deploy_failed_text, -> {
  "#{fetch(:stage)} deploy of #{fetch(:application)} with revision/branch `#{fetch(:current_revision, fetch(:branch))}` failed"
}

set :repo_url, "git@bitbucket.org:switchbox/arm-group-rating.git"

# Default branch is :master
set :branch, ENV['branch'] || 'master'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

# Default value for default_env is {}
set :default_env, { path: "/home/deploy/.gem/ruby/2.3.0/bin:$PATH" }

namespace :deploy do
  after :restart, 'sidekiq:restart'
end

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure