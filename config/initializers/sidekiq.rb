require 'sidekiq_calculations'
require 'csv'
require 'tempfile'
# require Rails.root + "lib/sidekiq_error_notifier"

Sidekiq.configure_client do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  config.redis = {
    url: ENV['REDISCLOUD_URL'],
    size: sidekiq_calculations.client_redis_size
  }
end

Sidekiq.configure_server do |config|
  sidekiq_calculations = SidekiqCalculations.new
  sidekiq_calculations.raise_error_for_env!

  config.options[:concurrency] = sidekiq_calculations.server_concurrency_size
  config.redis = {
    url: ENV['REDISCLOUD_URL']
  }

  # config.error_handlers << Proc.new {|exception, context_hash| SidekiqErrorNotifier.notify(exception, context_hash) }
end
