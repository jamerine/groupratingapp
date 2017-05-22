class TestError
  include Sidekiq::Worker
  sidekiq_options queue: :import_file, retry: 1

  def perform(id)
    raise "exception which should trigger the custom error handler and send me an email..."
  end
end
