class AccountPolicyExport
  require 'csv'
  include Sidekiq::Worker

  sidekiq_options queue: :account_policy_export

  def perform(representative_id)

    @accounts = Account.includes(:policy_calculation).where(representative_id: 1)
    
    attributes = self.column_names

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |account|
        csv << attributes.map{ |attr| account.send(attr) }
      end
    end



  end
end
