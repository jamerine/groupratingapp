class GenerateQuoteProcess
  include Sidekiq::Worker

  sidekiq_options queue: :generate_quote_process

  def perform(representative_id, user_id, account_ids, ac_2, ac_26, contract, intro, invoice, questionnaire, quote)
    @representative = Representative.find(representative_id)
    @user = User.find(user_id)
    @current_date = Date.current

    account_ids.each do |account_id|
      GenerateQuote.perform_async(account_id, ac_2, ac_26, contract, intro, invoice, questionnaire, quote)
    end



      GenerateAllQuotePacket.perform_in(4.minutes, representative_id, user_id, account_ids)

  end
end
