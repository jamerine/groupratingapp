class PolicyExport

  include Sidekiq::Worker

  sidekiq_options queue: :policy_export

  def perform(current_user_id, representative_id)
    @user = User.find(current_user_id)
    @accounts = Account.where(representative_id: representative_id)
    @representative = Representative.find(representative_id)
    @policy_calculations = PolicyCalculation.where(account_id: @accounts)

    attributes = @policy_calculations.column_names


    csv_string = CSV.generate(headers: true) do |csv|
      csv << attributes

      @policy_calculations.each do |policy|
        csv << attributes.map{ |attr| policy.send(attr) }
      end

      csv.close
    end

    PolicyExportMailer.policy_export(@user, @representative, csv_string).deliver
  end
end
