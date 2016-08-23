Resque.before_fork do
    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end

  Resque.after_fork do
    defined?(ActiveRecord::Base) and
      conn = ActiveRecord::Base.establish_connection
  end

  rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
  rails_env = ENV['RAILS_ENV'] || 'development'

  resque_config = YAML.load_file(rails_root + '/config/resque.yml')
  Resque.redis = resque_config[rails_env]

  
