require 'sidekiq_calculations'
require 'csv'
require 'tempfile'
require 'sidekiq_error_notifier'

Sidekiq.configure_client do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  config.redis = {
    url:       ENV['REDISCLOUD_URL'],
    size:      sidekiq_calculations.client_redis_size,
    namespace: "groupratingapp_#{Rails.env}"
  }
end

Sidekiq.configure_server do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  config.options[:concurrency] = sidekiq_calculations.server_concurrency_size
  config.redis                 = {
    url:       ENV['REDISCLOUD_URL'],
    namespace: "groupratingapp_#{Rails.env}"
  }

  config.logger.level = ::Logger::INFO

  Rails.logger              = Sidekiq::Logging.logger
  ActiveRecord::Base.logger = Sidekiq::Logging.logger

  config.error_handlers << Proc.new { |exception, context_hash| SidekiqErrorNotifier.notify(exception, context_hash) }
end
