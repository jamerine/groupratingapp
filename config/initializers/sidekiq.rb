require 'sidekiq_calculations'
require 'csv'
require 'tempfile'
require 'sidekiq_error_notifier'

Sidekiq.configure_client do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  # env_num = Rails.env.production? ? 0 : 1
  # Redis.new(db: env_num) # existing DB is selected if already present

  config.redis = {
    url:       ENV['REDISCLOUD_URL'],
    size:      sidekiq_calculations.client_redis_size
  }
end

Sidekiq.configure_server do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  # env_num = Rails.env.production? ? 0 : 1
  # Redis.new(db: env_num) # existing DB is selected if already present

  config.options[:concurrency] = sidekiq_calculations.server_concurrency_size
  config.redis                 = {
    url:       ENV['REDISCLOUD_URL']
  }


  config.logger.level = ::Logger::INFO

  Rails.logger              = Sidekiq::Logging.logger
  ActiveRecord::Base.logger = Sidekiq::Logging.logger

  config.error_handlers << Proc.new { |exception, context_hash| SidekiqErrorNotifier.notify(exception, context_hash) }
end
