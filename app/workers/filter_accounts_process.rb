class FilterAccountsProcess
  include Sidekiq::Worker

  sidekiq_options queue: :filter_accounts_process, retry: 2

  def perform(group_rating_id, all_process = nil)
    @group_rating   = GroupRating.find_by(id: group_rating_id)
    @representative = Representative.find_by(id: @group_rating.representative_id)
    @accounts       = @representative.accounts.includes(:policy_calculation).map { |account| account if account.policy_calculation.nil? }.compact

    @accounts.each do |account|
      if account.notes.any?
        actual_account = Account.find_by_rep_and_policy(@representative.representative_number, account.policy_number_entered)
        account.notes.each { |note| actual_account.notes << note } if actual_account.present?
      end

      account.destroy
    end

    GroupRatingMarkComplete.perform_async(group_rating_id, all_process)
  end
end
