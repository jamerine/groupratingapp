Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      conn = ActiveRecord::Base.establish_connection
  end


  namespace :resque do
    task :setup do
      require 'resque'
      ENV['QUEUE'] = '*'

      Resque.redis = 'localhost:6379' unless Rails.env == 'production'
    end
  end


  desc "Alias for resque:work (To run workers on Heroku)"
  task "jobs:work" => "resque:work"
