class WeeklyRequest

  include Sidekiq::Worker

  sidekiq_options queue: :weekly_request

  def perform(current_user_id, representative_id, statuses, weekly_request)
    @user = User.find(current_user_id)
    @representative = Representative.find(representative_id)
    if weekly_request.nil?
      @accounts = @representative.accounts.all
    else
      @accounts = @representative.accounts.where("weekly_request = ?", weekly_request)
    end

    @accounts = @accounts.where("(status in (?)) or request_date is null", statuses)

    rep_num = "%06d" % @representative.representative_number + '-80'

    csv_string = CSV.generate(:col_sep => "\t") do |csv|
      @accounts.each do |account|
        policy_number = "%08d" % account.policy_number_entered + '-000'
        csv << ["159",policy_number, rep_num ]
      end
      @accounts.update_all(request_date: Time.now)
      csv.close
    end

    WeeklyRequestExportMailer.weekly_request_export(@user, @representative, csv_string).deliver

  end
end
