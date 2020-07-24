class SidekiqErrorNotifier

  def self.notify(exception, context_hash)
    ErrorMailer.notify_about_sidekiq_exception(exception, context_hash).deliver_later
  end
end
