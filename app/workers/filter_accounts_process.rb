class FilterAccountsProcess
  include Sidekiq::Worker

  sidekiq_options queue: :filter_accounts_process, retry: 2

  def perform(group_rating_id, all_process = nil)
    @group_rating   = GroupRating.find_by(id: group_rating_id)
    @representative = Representative.find_by(id: @group_rating.representative_id)
    @accounts       = @representative.accounts.includes(:policy_calculation).map { |account| account if account.policy_calculation.nil? }.compact

    @accounts.each do |account|
      actual_account = Account.find_by_rep_and_policy(@representative.id, account.policy_number_entered)

      if actual_account.present?
        account.notes.each { |note| actual_account.notes << note } if account.notes.any?
        account.accounts_affiliates.each { |affiliate| actual_account.accounts_affiliates << affiliate } if account.accounts_affiliates.any?
        account.accounts_contacts.each { |contact| actual_account.accounts_contacts << contact } if account.accounts_contacts.any?
        account.group_rating_exceptions.each { |exception| actual_account.group_rating_exceptions << exception } if account.group_rating_exceptions.any?
        account.group_rating_rejections.each { |rejection| actual_account.group_rating_rejections << rejection } if account.group_rating_rejections.any?
        account.quotes.each { |quote| actual_account.quotes << quote } if account.quotes.any?
      end

      account.destroy
    end

    GroupRatingMarkComplete.perform_async(group_rating_id, all_process)
  end
end
