class PayrollCalculationsController < ApplicationController

  def new
    @payroll_calculation = PayrollCalculation.new
  end


  def payroll_calculation_params
    params.require(:payroll_calculation).permit(:representative_number, :policy_number, :manual_number, :manual_class_effective_date, :manual_class_payroll, :payroll_origin, :data_source)
  end
end
