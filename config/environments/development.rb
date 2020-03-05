Rails.application.configure do
  require 'sidekiq/testing/inline'

  config.cache_classes                         = false
  config.eager_load                            = false
  config.consider_all_requests_local           = true
  config.action_controller.perform_caching     = false
  config.active_support.deprecation            = :log
  config.active_record.migration_error         = :page_load
  config.assets.debug                          = false
  config.assets.digest                         = true
  config.assets.raise_runtime_errors           = true
  config.assets.quiet                          = true
  config.action_mailer.default_url_options     = { host: 'localhost', port: 3000 }
  config.action_controller.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.asset_host              = 'http://localhost:3000'
  config.action_controller.asset_host          = 'http://localhost:3000'
  config.action_mailer.delivery_method         = :letter_opener
  config.action_mailer.raise_delivery_errors   = true
  config.action_mailer.perform_deliveries      = true
  config.action_controller.include_all_helpers = true
end
