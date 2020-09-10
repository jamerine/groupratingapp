namespace :db do
  task filter_accounts: :environment do
    require 'progress_bar/core_ext/enumerable_with_progress'

    policy_numbers = [2277, 104580, 308924, 326804, 372724, 388723, 1005236, 1258916, 1429570, 1498006, 1515271, 1602592, 1618085, 1643347, 1671711, 80019478, 80021431, 80023759, 80023759, 80035397, 80037049, 80042034, 80048134, 80048369, 80050230, 80051070, 80051425, 80052019, 80055667, 80055756, 80071107, 80071642, 80072633, 80074930]

    policy_numbers.each_with_progress do |policy_number|
      policies = PolicyCalculation.where(representative_number: 1740, policy_number: policy_number) #MATRIX

      next unless policies.count > 1
      policy_to_keep     = policies.order(created_at: :asc).first
      policies_to_remove = policies.where.not(id: policy_to_keep.id)

      policies_to_remove.each do |policy|
        policy.claim_calculations.each do |claim|
          policy_to_keep.claim_calculations << claim unless policy_to_keep.claim_calculations.where(claim_number: claim.claim_number).any?
        end

        policy.policy_coverage_status_histories.each do |history|
          policy_to_keep.policy_coverage_status_histories << history unless policy_to_keep.policy_coverage_status_histories.where(coverage_effective_date: history.coverage_effective_date, coverage_status: history.coverage_status).any?
        end

        policy.policy_program_histories.each do |program|
          policy_to_keep.policy_program_histories << program unless policy_to_keep.policy_program_histories.where(policy_year:              program.policy_year,
                                                                                                                  group_code:               program.group_code,
                                                                                                                  experience_modifier_rate: program.experience_modifier_rate,
                                                                                                                  group_type:               program.group_type,
                                                                                                                  deductible_level:         program.deductible_level).any?
        end

        policy_to_keep.save
        policy.destroy
        GroupRatingCalculate.perform_async(policy_to_keep.account_id)
      end
    end
  end
end