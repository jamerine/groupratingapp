class ManualClassCalculationsController < ApplicationController
  def index
    @manual_class_calculations = ManualClassCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @manual_class_calculation = ManualClassCalculation.find_by(id: params[:id])
    @group_rating = GroupRating.where(process_representative: @manual_class_calculation.representative_number).last
    @policy_calculation = PolicyCalculation.find_by(id: @manual_class_calculation.policy_calculation_id)
    @payroll_calculations = PayrollCalculation.where(manual_class_calculation_id: @manual_class_calculation.id )
    @new_payroll_calculation = PayrollCalculation.new
  end


  def create_manual_class_objects
    Resque.enqueue(ManualClassUpdateCreate)
    redirect_to manual_class_calculations_path, notice: "Manual Classes are queued to update."
  end




 private


end
