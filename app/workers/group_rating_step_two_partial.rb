class GroupRatingStepTwoPartial
    include Sidekiq::Worker

    sidekiq_options queue: :group_rating_step_two_partial

  def perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)
    low_payroll_period = current_payroll_period_lower_date.to_date
    next_payroll_period = (low_payroll_period + 6.months).to_date
    high_payroll_period = (next_payroll_period + 6.months).to_date

    ProcessPayrollBreakdownByManualClass.where("manual_class_effective_date > :low_payroll_period and manual_class_effective_date < :next_payroll_period and payroll_origin = :payroll_origin", low_payroll_period: low_payroll_period, next_payroll_period: next_payroll_period, payroll_origin: 'payroll').each do |payroll|
      if payroll.manual_class_payroll > 0
        diff_ratio = ((payroll.manual_class_effective_date - low_payroll_period)/(next_payroll_period - payroll.manual_class_effective_date))
        added_payroll = (diff_ratio * payroll.manual_class_payroll).round(2)

        ProcessPayrollBreakdownByManualClass.create(
          representative_number: payroll.representative_number,
          policy_type: payroll.policy_type,
          policy_number: payroll.policy_number,
          manual_number: payroll.manual_number,
          manual_type: payroll.manual_type,
          manual_class_effective_date: payroll.manual_class_effective_date,
          manual_class_payroll: added_payroll,
          payroll_origin: 'partial_payroll',
          data_source: payroll.data_source )
        if !ProcessPayrollBreakdownByManualClass.where("policy_number = :policy_number and manual_number = :manual_number and manual_class_effective_date = :next_payroll_period and manual_class_payroll = :manual_class_payroll and manual_type = :manual_type", policy_number: payroll.policy_number, manual_number: payroll.manual_number, next_payroll_period: next_payroll_period, manual_class_payroll: 0, manual_type: payroll.manual_type).empty?
          total_payroll = (added_payroll + payroll.manual_class_payroll)
          ProcessPayrollBreakdownByManualClass.create(
            representative_number: payroll.representative_number,
            policy_type: payroll.policy_type,
            policy_number: payroll.policy_number,
            manual_number: payroll.manual_number,
            manual_type: payroll.manual_type,
            manual_class_effective_date: next_payroll_period,
            manual_class_payroll: total_payroll,
            payroll_origin: 'partial_payroll',
            data_source: payroll.data_source )
        end
      end
    end

    ProcessPayrollBreakdownByManualClass.where("manual_class_effective_date > :next_payroll_period and manual_class_effective_date < :high_payroll_period", next_payroll_period: next_payroll_period, high_payroll_period: high_payroll_period).each do |payroll|
      if payroll.manual_class_payroll > 0
        diff_ratio = ((payroll.manual_class_effective_date - next_payroll_period)/(high_payroll_period - payroll.manual_class_effective_date))
        added_payroll = (diff_ratio * payroll.manual_class_payroll).round(2)
        ProcessPayrollBreakdownByManualClass.create(
          representative_number: payroll.representative_number,
          policy_type: payroll.policy_type,
          policy_number: payroll.policy_number,
          manual_number: payroll.manual_number,
          manual_type: payroll.manual_type,
          manual_class_effective_date: payroll.manual_class_effective_date,
          manual_class_payroll: added_payroll,
          payroll_origin: 'partial_payroll',
          data_source: payroll.data_source)
          if !ProcessPayrollBreakdownByManualClass.where("policy_number = :policy_number and manual_number = :manual_number and manual_class_effective_date = :low_payroll_period and manual_class_payroll = :manual_class_payroll and manual_type = :manual_type", policy_number: payroll.policy_number, manual_number: payroll.manual_number, low_payroll_period: low_payroll_period, manual_class_payroll: 0, manual_type: payroll.manual_type).empty?
            total_payroll = (added_payroll + payroll.manual_class_payroll)
            ProcessPayrollBreakdownByManualClass.create(
              representative_number: payroll.representative_number,
              policy_type: payroll.policy_type,
              policy_number: payroll.policy_number,
              manual_number: payroll.manual_number,
              manual_type: payroll.manual_type,
              manual_class_effective_date: low_payroll_period,
              manual_class_payroll: total_payroll,
              payroll_origin: 'partial_payroll',
              data_source: payroll.data_source)
          end
      end
    end

    GroupRatingStepThreeA.perform_async("3_a", process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, group_rating_id)
  end

end
