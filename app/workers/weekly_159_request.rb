class Weekly159Request

  include Sidekiq::Worker

  sidekiq_options queue: :weekly_159_request

  def perform(current_user_id, representative_id)
    @user = User.find(current_user_id)
    @representative = Representative.find(representative_id)
    @accounts = @representative.accounts

    rep_num = "%06d" % @representative.representative_number + '-80'

    csv_string = CSV.generate(:col_sep => "\t") do |csv|
      @accounts.each do |account|
        policy_number = "%08d" % account.policy_number_entered + '-000'
        csv << ["159",policy_number, rep_num ]
        account.update_attributes(request_date: Time.now)
      end
      csv.close
    end

    Weekly159RequestExportMailer.policy_export(@user, @representative, csv_string).deliver

  end
end
