class PayrollCalculationsController < ApplicationController

  def new
    @manual_class_calculation = ManualClassCalculation.find(params[:id])
    @payroll_calculation      = PayrollCalculation.new
  end

  def create
    @payroll_calculation = PayrollCalculation.new(payroll_calculation_params)
    authorize @payroll_calculation
    @process_payroll = ProcessPayrollAllTransactionsBreakdownByManualClass.new(representative_number: @payroll_calculation.representative_number, policy_number: @payroll_calculation.policy_number, manual_number: @payroll_calculation.manual_number, manual_class_type: @payroll_calculation.manual_class_type, reporting_period_start_date: @payroll_calculation.reporting_period_start_date, reporting_period_end_date: @payroll_calculation.reporting_period_end_date, manual_class_payroll: @payroll_calculation.manual_class_payroll, payroll_origin: @payroll_calculation.payroll_origin, data_source: @payroll_calculation.data_source)

    @process_payroll.save!
    @payroll_calculation.process_payroll_all_transactions_breakdown_by_manual_class_id = @process_payroll.id
    if @payroll_calculation.save
      if @payroll_calculation.data_source != 'bwc'
        @manual_class_calculation = @payroll_calculation.manual_class_calculation
        @policy_calculation       = @manual_class_calculation.policy_calculation
        @policy_calculation.calculate_experience
        @policy_calculation.calculate_premium
        @policy_calculation.account.group_rating
      end
      @message = "Payroll was added."
      redirect_to manual_class_calculation_path(@payroll_calculation.manual_class_calculation_id), notice: "Payroll has been adjusted"
    else
      @message = "Payroll couldn't be added. Try again."
      redirect_to manual_class_calculation_path(@payroll_calculation.manual_class_calculation_id), alert: "Payroll adjustment failed"
    end
  end

  def create_form_2
    @payroll_calculation = PayrollCalculation.new(payroll_calculation_params)
    authorize @policy_calculation
    @process_payroll = ProcessPayrollAllTransactionsBreakdownByManualClass.new(representative_number: @payroll_calculation.representative_number, policy_number: @payroll_calculation.policy_number, manual_number: @payroll_calculation.manual_number, manual_class_type: @payroll_calculation.manual_class_type, reporting_period_start_date: @payroll_calculation.reporting_period_start_date, reporting_period_end_date: @payroll_calculation.reporting_period_end_date, manual_class_payroll: @payroll_calculation.manual_class_payroll, payroll_origin: @payroll_calculation.payroll_origin, data_source: @payroll_calculation.data_source)

    @process_payroll.save!
    @payroll_calculation.process_payroll_all_transactions_breakdown_by_manual_class_id = @process_payroll.id
    if @payroll_calculation.save
      if @payroll_calculation.data_source != 'bwc'
        @manual_class_calculation = @payroll_calculation.manual_class_calculation
        @policy_calculation       = @manual_class_calculation.policy_calculation
        @policy_calculation.calculate_experience
        @policy_calculation.calculate_premium
        @policy_calculation.account.group_rating
      end
      @message = "Payroll was added."
      redirect_to policy_calculation_path(@policy_calculation.id), notice: "Payroll has been adjusted"
    else
      @message = "Payroll couldn't be added. Try again."
      redirect_to manual_class_calculation_path(@payroll_calculation.manual_class_calculation_id), alert: "Payroll adjustment failed"
    end

  end

  def destroy
    @payroll_calculation = PayrollCalculation.find(params[:id])
    authorize @payroll_calculation
    @manual_class_calculation = @payroll_calculation.manual_class_calculation
    @policy_calculation       = @manual_class_calculation.policy_calculation
    @process_payroll          = ProcessPayrollAllTransactionsBreakdownByManualClass.find(@payroll_calculation.process_payroll_all_transactions_breakdown_by_manual_class_id)
    if @payroll_calculation.destroy
      @policy_calculation.calculate_experience
      @policy_calculation.calculate_premium
      @policy_calculation.account.group_rating
      @process_payroll.delete
      @message              = "Payroll was deleted."
      @payroll_calculations = PayrollCalculation.where(manual_class_calculation_id: @manual_class_calculation.id, representative_number: @manual_class_calculation.representative_number, policy_number: @manual_class_calculation.policy_number)
      redirect_to @manual_class_calculation, notice: "Payroll has been deleted"
    else
      message               = "Payroll couldn't be deleted. Try again."
      @payroll_calculations = PayrollCalculation.where(manual_class_calculation_id: @manual_class_calculation.id, representative_number: @manual_class_calculation.representative_number, policy_number: @manual_class_calculation.policy_number)
      redirect_to @manual_class_calculation, alert: "Payroll adjustment failed"
    end

    # respond_to do |format|
    #   format.html { result ? flash[:notice] = @message : flash[:alert] = @message }
    #   format.js
    # end

  end

  private

  def payroll_calculation_params
    params.require(:payroll_calculation).permit(:representative_number, :policy_number, :manual_class_calculation_id, :manual_number, :manual_class_type, :reporting_period_start_date, :reporting_period_end_date, :manual_class_payroll, :payroll_origin, :reporting_type, :data_source)
  end

end
