class ManualClassExport
  require 'csv'
  include Sidekiq::Worker

  sidekiq_options queue: :manual_class_export

  def perform(current_user_id, representative_id)
    @user = User.find(current_user_id)
    @representative = Representative.find(representative_id)
    @accounts = Account.where(representative_id: @representative.id)
    @policy_calculations = PolicyCalculation.where(account_id: @accounts)
    @manual_class_calculations = ManualClassCalculation.where(policy_calculation_id: @policy_calculations)

    attributes = ManualClassCalculation.column_names

    csv_string = CSV.generate(headers: true) do |csv|
      csv << attributes

      @manual_class_calculations.each do |account|
        csv << attributes.map{ |attr| account.send(attr) }
      end
      csv.close
    end

    ManualClassExportMailer.manual_class_export(@user, @representative, csv_string).deliver_later
  end
end
