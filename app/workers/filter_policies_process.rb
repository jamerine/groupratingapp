class FilterPoliciesProcess
  include Sidekiq::Worker

  sidekiq_options queue: :filter_policies_process, retry: 2

  def perform(group_rating_id, all_process = nil)
    @group_rating   = GroupRating.find_by(id: group_rating_id)
    @representative = Representative.find_by(id: @group_rating.representative_id)

    # Merge/Remove duplicate policies
    result                 = ActiveRecord::Base.connection.exec_query("SELECT DISTINCT policy_number
                                                       FROM policy_calculations
                                                       WHERE policy_number IN (
                                                          SELECT policy_number
                                                          FROM (
                                                            SELECT id, policy_number,
                                                            ROW_NUMBER() OVER(PARTITION BY policy_number ORDER BY policy_number asc) AS Row
                                                            FROM policy_calculations WHERE representative_number = #{@representative.representative_number}
                                                          ) dups
                                                          WHERE dups.Row > 1)
                                                          AND representative_number = #{@representative.representative_number}
                                                       ORDER BY policy_number")
    policy_numbers         = result.rows.flatten.map(&:to_i)
    policies_to_be_removed = []
    policy_numbers.each_with_progress do |policy_number|
      policies = PolicyCalculation.where(representative_number: @representative.representative_number, policy_number: policy_number) #MATRIX

      next unless policies.count > 1
      policy_to_keep     = policies.order(created_at: :asc).first
      policies_to_remove = policies.where.not(id: policy_to_keep.id)

      policies_to_remove.each do |policy|
        policy.claim_calculations.each do |claim|
          unless policy_to_keep.claim_calculations.where('claim_number LIKE ?', "%#{claim.claim_number.strip}%").any?
            claim.update_attribute(:policy_calculation_id, policy_to_keep.id)
          end
        end

        policy.policy_coverage_status_histories.each do |history|
          unless policy_to_keep.policy_coverage_status_histories.where(coverage_effective_date: history.coverage_effective_date, coverage_status: history.coverage_status).any?
            history.update_attribute(:policy_calculation_id, policy_to_keep.id)
          end
        end

        policy.policy_program_histories.each do |program|
          unless policy_to_keep.policy_program_histories.where(policy_year:              program.policy_year,
                                                               group_code:               program.group_code,
                                                               experience_modifier_rate: program.experience_modifier_rate,
                                                               group_type:               program.group_type,
                                                               deductible_level:         program.deductible_level).any?
            program.update_attribute(:policy_calculation_id, policy_to_keep.id)
          end
        end

        policy_to_keep.save
        policies_to_be_removed << policy
        policy_to_keep.account&.calculate
      end
    end

    policies_to_be_removed.each(&:destroy)

    FilterClaimsProcess.perform_async(group_rating_id, all_process)
  end
end
