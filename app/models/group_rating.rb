class GroupRating < ActiveRecord::Base

  def self.step_1(process_representative, experience_period_lower_date, experience_period_upper_date, current_payroll_period_lower_date )

    time1 = Time.new
      result = ActiveRecord::Base.connection.execute("SELECT public.proc_step_1(#{process_representative}, '#{experience_period_lower_date }', '#{experience_period_upper_date }', '#{current_payroll_period_lower_date }')")
      result.clear
    time2 = Time.new

  end
end
