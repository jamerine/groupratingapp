class GroupRatingStepThreeB1
  include Sidekiq::Worker

  sidekiq_options queue: :group_rating_step_three_b

  def perform(step, process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date, current_payroll_period_upper_date, group_rating_id, all_process = nil)


    @all_pcomb_records = PcombDetailRecord.where("transfer_type = 'FC' or transfer_type = 'BF'").order(transfer_creation_date: :asc)

    pcomb_array = @all_pcomb_records.pluck(:predecessor_policy_number, :successor_policy_number).uniq

    pcomb_array.each do |pcomb_array|
      pred_payroll_array        = ProcessPayrollAllTransactionsBreakdownByManualClass.where(policy_number: pcomb_array[0])
      transferred_payroll_array = []

      pred_payroll_array.each do |payroll|
        #create positive transfer payroll to successor
        new_positive_transferred_payroll = payroll.dup
        new_positive_transferred_payroll = new_positive_transferred_payroll.attributes.except("id")

        new_positive_transferred_payroll["policy_number"]            = pcomb_array[1]
        new_positive_transferred_payroll["reporting_type"]           = 'A'
        new_positive_transferred_payroll["payroll_origin"]           = 'full_transfer'
        new_positive_transferred_payroll["policy_transferred"]       = pcomb_array[0]
        new_positive_transferred_payroll["manual_class_transferred"] = payroll.manual_number

        # TODO: When the account policy status is dead or the last policy coverage history date is before the payroll period end date, set the payroll amount to 0


        #insert positive transfer payroll to array
        transferred_payroll_array << new_positive_transferred_payroll

        #create negative transfer payroll to successor
        new_negative_transferred_payroll                             = payroll.dup
        new_negative_transferred_payroll                             = new_negative_transferred_payroll.attributes.except("id")
        new_negative_transferred_payroll["manual_class_payroll"]     = -(payroll.manual_class_payroll || 0)
        new_negative_transferred_payroll["reporting_type"]           = 'A'
        new_negative_transferred_payroll["payroll_origin"]           = 'full_transfer'
        new_negative_transferred_payroll["policy_transferred"]       = pcomb_array[1]
        new_negative_transferred_payroll["manual_class_transferred"] = payroll.manual_number

        #insert negative transfer payroll into array
        transferred_payroll_array << new_negative_transferred_payroll
      end
      ProcessPayrollAllTransactionsBreakdownByManualClass.create(transferred_payroll_array)
    end

    result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_301b(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }', '#{current_payroll_period_upper_date }')")

    result.clear
    @group_rating = GroupRating.find_by(id: group_rating_id)

    if @group_rating.present?
      @group_rating.status = "Step #{step} Completed"
      @group_rating.save

      GroupRatingStepThreeC.perform_async("3_c", @group_rating.process_representative, @group_rating.experience_period_lower_date, @group_rating.experience_period_upper_date, @group_rating.current_payroll_period_lower_date, @group_rating.current_payroll_period_upper_date, @group_rating.id, all_process)
      # GroupRatingStepThreeC.perform_async("3_c",219406, "2012-07-01", "2016-06-30", "2015-07-01", "2016-06-30", 1,)
    end
  end
end
