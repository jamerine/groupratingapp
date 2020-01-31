namespace :sidekiq do
  task :monitor do
    # https://github.com/mperham/sidekiq/wiki/Monitoring
    require 'sidekiq/web'
    app = Sidekiq::Web
    app.set :environment, :production
    app.set :bind, '0.0.0.0'
    app.set :port, 9000
    app.run!
  end
end
