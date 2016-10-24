class PredecessorAccountUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :predecessor_account_update_create_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find(group_rating_id)
    @representative = Representative.find(@group_rating.representative_id)
    ExceptionTablePolicyCombinedRequestPayrollInfo.find_each do |predecessor|
      @account = Account.where(representative_id: @representative.id, policy_number_entered: predecessor.predecessor_policy_number).update_or_create(representative_id: @representative.id, policy_number_entered: predecessor.predecessor_policy_number, status: 2, name: "Predecessor Account for #{predecessor.successor_policy_number}")

      PolicyCalculation.where(representative_id: @representative.id, policy_number: predecessor.predecessor_policy_number, account_id: @account.id).update_or_create(policy_number: predecessor.predecessor_policy_number, policy_type: predecessor.predecessor_policy_type, representative_id: @representative.id, representative_number: @representative.representative_number, account_id: @account.id, policy_status: 'COMB', business_name: "Predecessor Policy for #{predecessor.successor_policy_number}", address_1: 'Unknown address_1', address_2: 'Unknown address_2', city: 'unknown city' )

    end
  end
end
