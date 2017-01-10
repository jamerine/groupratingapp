class AccountPolicyExport
  require 'csv'
  include Sidekiq::Worker

  sidekiq_options queue: :account_policy_export

  def perform(current_user_id, representative_id)
    @user = User.find(current_user_id)
    @representative = Representative.find(representative_id)
    @accounts = Account.joins(:policy_calculation).select("accounts.*, policy_calculations.*").where("accounts.representative_id = ?", representative_id)

    attributes = Account.column_names
    PolicyCalculation.column_names.each do |p|
      unless p == 'id' || p == 'representative_number' || p == 'policy_number' || p ==  'data_source' || p == 'created_at' || p == 'updated_at' || p == 'representative_id'|| p == 'account_id' || p == 'federal_identification_number'
        attributes << p
      end
    end

    csv_string = CSV.generate(headers: true) do |csv|
      csv << attributes

      @accounts.each do |account|
        csv << attributes.map{ |attr| account.send(attr) }
      end
      csv.close
    end

    PolicyExportMailer.policy_export(@user, @representative, csv_string).deliver
  end
end
