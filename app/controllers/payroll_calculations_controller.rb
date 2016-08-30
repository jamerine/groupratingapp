class PayrollCalculationsController < ApplicationController

  def new
    @manual_class_calculation = ManualClassCalculation.find(params[:id])
    @payroll_calculation = PayrollCalculation.new
  end


  def create
    @payroll_calculation = PayrollCalculation.new(payroll_calculation_params)
    @process_payroll = ProcessPayrollAllTransactionsBreakdownByManualClass.new(representative_number: @payroll_calculation.representative_number, policy_number: @payroll_calculation.policy_number, manual_number: @payroll_calculation.manual_number, manual_class_effective_date: @payroll_calculation.manual_class_effective_date, manual_class_payroll: @payroll_calculation.manual_class_payroll, payroll_origin: @payroll_calculation.payroll_origin, data_source: @payroll_calculation.data_source)
    @process_payroll.save!
    @payroll_calculation.process_payroll_all_transactions_breakdown_by_manual_class_id = @process_payroll.id
    if @payroll_calculation.save
      if @payroll_calculation.data_source != 'bwc'
        @manual_class_calculation = ManualClassCalculation.find_by(id: @payroll_calculation.manual_class_calculation_id)
        @manual_class_calculation.recalculate_experience
      end
      redirect_to manual_class_calculation_path(@payroll_calculation.manual_class_calculation_id), notice: "Payroll has been adjusted"
    else
      redirect_to manual_class_calculation_path(@payroll_calculation.manual_class_calculation_id), notice: "Payroll adjustment failed"
    end
  end

  def destroy
    @payroll_calculation = PayrollCalculation.find(params[:id])
    @manual_class_calculation = ManualClassCalculation.find(@payroll_calculation.manual_class_calculation_id)
    @process_payroll = ProcessPayrollAllTransactionsBreakdownByManualClass.find(@payroll_calculation.process_payroll_all_transactions_breakdown_by_manual_class_id)
    if @payroll_calculation.destroy
      @manual_class_calculation.recalculate_experience
      @process_payroll.delete
      flash[:notice] = "Import was deleted successfully."
      redirect_to @manual_class_calculation
    else
      @process_payroll.delete
      flash.now[:alert] = "There was an error deleting the import."
      redirect_to @manual_class_calculation
    end
  end

  private

  def payroll_calculation_params
    params.require(:payroll_calculation).permit(:representative_number, :policy_number, :manual_class_calculation_id, :manual_number, :manual_class_effective_date, :manual_class_payroll, :payroll_origin, :data_source)
  end

end
