class GroupRating < ActiveRecord::Base

  def self.step_1(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date )

    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_1(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 1 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_2(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_2(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 2 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_3(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_3(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 3 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_4(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_4(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 4 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_5(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_5(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 5 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_6(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_6(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 6 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_7(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_7(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 7 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end

  def self.step_8(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date)
    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_8(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new
    puts 'Completed Group Rating Step 8 in: ' + ((time2 - time1).round(3)).to_s + ' seconds'
  end
end
