class PolicyCalculationsController < ApplicationController

  def index
    @policy_calculations = PolicyCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @policy_calculation = PolicyCalculation.find(params[:id])
    @policy_demographics = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_calculation.policy_number)
    @manual_class_calculations = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id)
  end

  def new
    @policy_calculation = PolicyCalculation.new
  end

  def create_policy_objects
    Resque.enqueue(PolicyUpdateCreate)
    redirect_to policy_calculations_path, notice: "Policies are queued to update."
  end


 private

  def policy_calculation_params
  params.require(:final_policy_calculation).permit(:representative_number, :policy_number, :policy_group_number, :policy_status, :policy_total_four_year_payroll, :policy_credibility_group, :policy_maximum_claim_value, :policy_credibility_percent, :policy_total_expected_losses, :policy_total_limited_losses, :policy_total_claims_count, :policy_total_modified_losses_group_reduced, :policy_total_modified_losses_individual_reduced, :policy_group_ratio, :policy_individual_total_modifier, :policy_individual_experience_modified_rate, :group_rating_qualification, :group_rating_tier, :group_rating_group_number, :policy_total_current_payroll, :policy_total_standard_premium, :policy_total_individual_premium, :policy_total_group_premium, :policy_total_group_savings, :policy_group_fees, :policy_group_dues, :policy_total_costs, :data_source)
  end


end