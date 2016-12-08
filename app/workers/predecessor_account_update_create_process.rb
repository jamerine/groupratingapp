class PredecessorAccountUpdateCreateProcess
  include Sidekiq::Worker

  sidekiq_options queue: :predecessor_account_update_create_process

  def perform(group_rating_id)
    @group_rating = GroupRating.find(group_rating_id)
    @representative = Representative.find(@group_rating.representative_id)
    ExceptionTablePolicyCombinedRequestPayrollInfo.find_each do |predecessor|
      @account = Account.where(representative_id: @representative.id, policy_number_entered: predecessor.predecessor_policy_number).update_or_create(representative_id: @representative.id, policy_number_entered: predecessor.predecessor_policy_number, status: 3, name: "Predecessor Account for #{predecessor.successor_policy_number}")

      PolicyCalculation.where(representative_id: @representative.id, policy_number: predecessor.predecessor_policy_number, account_id: @account.id).update_or_create(policy_number: predecessor.predecessor_policy_number, representative_id: @representative.id, representative_number: @representative.representative_number, account_id: @account.id, current_coverage_status: 'COMB', business_name: "Predecessor Policy for #{predecessor.successor_policy_number}", mailing_address_line_1: 'Unknown mailing_address_1', mailing_address_line_2: 'Unknown mailing_address_line_2', mailing_city: 'unknown mailing_city' )
    end

    FinalEmployerDemographicsInformation.where(valid_policy_number: 'N').find_each do |invalid_policy|
      @account = Account.where(representative_id: @representative.id, policy_number_entered: invalid_policy.policy_number).update_or_create(representative_id: @representative.id, policy_number_entered: invalid_policy.policy_number, status: 2, name: "Invalid Policy Number Account for #{invalid_policy.policy_number}")

      PolicyCalculation.where(representative_id: @representative.id, policy_number: invalid_policy.policy_number, valid_policy_number: 'N', account_id: @account.id).update_or_create(policy_number: invalid_policy.policy_number, representative_id: @representative.id, representative_number: @representative.representative_number, account_id: @account.id, current_coverage_status: 'INVALID', business_name: "Invalid Policy Number Account for #{invalid_policy.policy_number}")
    end
  end
end
