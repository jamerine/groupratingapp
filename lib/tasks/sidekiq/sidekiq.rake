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

  task reset: :environment do
    require 'sidekiq'

    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
    Sidekiq::Stats.new.reset
    Sidekiq::DeadSet.new.clear
    Sidekiq::Stats.new.queues&.each { |queue| Sidekiq::Queue.new(queue[0]).clear }

    puts Sidekiq::Stats.new.fetch_stats!
  end
end
