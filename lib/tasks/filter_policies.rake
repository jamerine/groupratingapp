namespace :db do
  task filter_policies: :environment do
    require 'progress_bar/core_ext/enumerable_with_progress'

    # policy_numbers = [2277, 104580, 308924, 326804, 372724, 388723, 1005236, 1258916, 1429570, 1498006, 1515271, 1602592, 1618085, 1643347, 1671711, 80019478, 80021431, 80023759, 80023759, 80035397, 80037049, 80042034, 80048134, 80048369, 80050230, 80051070, 80051425, 80052019, 80055667, 80055756, 80071107, 80071642, 80072633, 80074930]
    # policy_numbers = [0, 76996, 275065, 442253, 634498, 768676, 823657, 830243, 855826, 878653, 889482, 930448, 1014673, 1170697, 1179483, 1220574, 1262815, 1292501, 1292502, 1299046, 1300728, 1303987, 1310429, 1369901, 1396452, 1487625, 1496557, 1498012, 1525505, 1531660, 1551358, 1567744, 1613544, 1669164, 1669552, 1694611, 80023759, 80052019, 80055667, 80071107]
    policy_numbers = [457380, 616016, 646587, 948364, 1012925, 1033236, 1042645, 1232685, 1494121, 1569910, 1580128, 1666741, 1668099, 1710728, 1747004, 1752679, 80035397, 80037049, 80048134, 80048369, 80050230, 80051425, 80055756, 80071642, 80072633, 80074930]

    policy_numbers.each_with_progress do |policy_number|
      policies = PolicyCalculation.where(representative_number: 1740, policy_number: policy_number) #MATRIX

      next unless policies.count > 1
      policy_to_keep     = policies.order(created_at: :asc).first
      policies_to_remove = policies.where.not(id: policy_to_keep.id)

      policies_to_remove.each do |policy|
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
        policy_to_keep.account&.calculate
      end
    end
  end
end