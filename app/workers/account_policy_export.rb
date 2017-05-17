class AccountPolicyExport
  require 'csv'
  include Sidekiq::Worker

  sidekiq_options queue: :account_policy_export

  def perform(current_user_id, representative_id)
    @user = User.find(current_user_id)
    @representative = Representative.find(representative_id)
    @accounts = Account.joins(:policy_calculation, :group_rating_rejections).select("accounts.*, policy_calculations.*, string_agg(group_rating_rejections.reject_reason, ' | ') as reject_reason").where("accounts.representative_id = ? and group_rating_rejections.program_type = ?", representative_id, 'group_rating').group("accounts.id, policy_calculations.id")

    attributes = Account.column_names
    PolicyCalculation.column_names.each do |p|
      unless p == 'id' || p == 'representative_number' || p == 'policy_number' || p ==  'data_source' || p == 'created_at' || p == 'updated_at' || p == 'representative_id'|| p == 'account_id' || p == 'federal_identification_number'
        attributes << p
      end
    end
    attributes << 'reject_reason'

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
