class AccountProgramImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(hash)

    @representative = Representative.find_by(representative_number: hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: hash["policy_number"] )

    if @account
      @account_program = AccountProgram.new(hash.except("representative_number", "policy_number"))
      @account_program.assign_attributes(account_id: @account.id)
      @account_program.save
    end

  end
end
