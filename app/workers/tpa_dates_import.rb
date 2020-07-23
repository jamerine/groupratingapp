class TPADatesImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file

  def perform(tpa_hash, representative_id)
    tpa_hash        = tpa_hash.with_indifferent_access
    @representative = Representative.find_by(id: representative_id)
    @account         = Account.find_by(representative_id: representative_id, policy_number_entered: tpa_hash[:policy_number])

    if @account.present?
      @account.tpa_start_date = tpa_hash[:tpa_start_date]
      @account.tpa_end_date   = tpa_hash[:tpa_end_date]
      @account.save
    end
  end
end


