class AccountProgramImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(hash)
    @representative = Representative.find_by(representative_number: hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: hash["policy_number"] )

    if @account
      fees_amount = hash["fees_amount"].gsub(/[^\d^\.]/, '').to_f
      program_type = hash["program_type"].to_s
      group_code = hash["group_code"].to_s
      quote_tier = hash["quote_tier"].to_f
      effective_start_date = hash["effective_start_date"].to_date
      effective_end_date = hash["effective_end_date"].to_date
      @account_program = AccountProgram.new(quote_tier: quote_tier, fees_amount: fees_amount, program_type: program_type, group_code: group_code, effective_end_date: effective_end_date, effective_start_date: effective_start_date, account_id: @account.id)
      @account_program.save
    end

  end
end
