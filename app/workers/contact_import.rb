class ContactImport
  include Sidekiq::Worker

  sidekiq_options queue: :import_file, retry: 1

  def perform(contact_hash)

    @representative = Representative.find_by(representative_number: contact_hash["representative_number"])
    @account = Account.find_by(representative_id: @representative.id, policy_number_entered: contact_hash["policy_number"] )

    if @account
      @contact = Contact.create!(contact_hash.except("representative_number", "policy_number"))
      AccountsContact.create!(contact_id: @contact.id, account_id: @account.id)
    end

  end
end
