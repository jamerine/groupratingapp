Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      conn = ActiveRecord::Base.establish_connection
  end

Resque.redis = Rails.env.production? ? $redis : "localhost:6379"
