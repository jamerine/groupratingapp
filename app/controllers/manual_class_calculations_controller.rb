class ManualClassCalculationsController < ApplicationController
  def index
    @manual_class_calculations = ManualClassCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @manual_class_calculation = ManualClassCalculation.find_by(id: params[:id])
    @policy_calculation = PolicyCalculation.find_by(id: @manual_class_calculation.policy_calculation_id)
  end

  def new
    @manual_class_calculation = ManualClassCalculation.new
  end

  def create_manual_class_objects
    Resque.enqueue(ManualClassUpdateCreate)
    redirect_to manual_class_calculations_path, notice: "Manual Classes are queued to update."
  end


 private

  def manual_class_calculation_params
    params.require(:manual_class_calculation).permit(:representative_number, :policy_number, :policy_group_number, :policy_status, :policy_total_four_year_payroll, :policy_credibility_group, :policy_maximum_claim_value, :policy_credibility_percent, :policy_total_expected_losses, :policy_total_limited_losses, :policy_total_claims_count, :policy_total_modified_losses_group_reduced, :policy_total_modified_losses_individual_reduced, :policy_group_ratio, :policy_individual_total_modifier, :policy_individual_experience_modified_rate, :group_rating_qualification, :group_rating_tier, :group_rating_group_number, :policy_total_current_payroll, :policy_total_standard_premium, :policy_total_individual_premium, :policy_total_group_premium, :policy_total_group_savings, :policy_group_fees, :policy_group_dues, :policy_total_costs, :data_source)
  end


end
