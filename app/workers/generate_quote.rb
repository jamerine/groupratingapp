class GenerateQuote
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote

  def perform(hash)
    
  end
end
