class FinalPolicyCalculationsController < ApplicationController

  def index
    @final_policy_calculations = FinalPolicyCalculation.all
  end

  def show
    @final_policy_calculation = FinalPolicyCalculation.find(params[:id])
  end

  def new
    @final_policy_calculation = FinalPolicyCalculation.new
  end

  def create_policy_objects
    FinalPolicyExperienceCalculation.find_each do |policy_exp|
        FinalPolicyCalculation.where(policy_number: policy_exp.policy_number).update_or_create(
        representative_number: policy_exp.representative_number, 
        policy_group_number: policy_exp.policy_group_number,
        policy_status: policy_exp.policy_status,
        policy_total_four_year_payroll: policy_exp.policy_total_four_year_payroll,
        policy_credibility_group: policy_exp.policy_credibility_group,
        policy_maximum_claim_value: policy_exp.policy_maximum_claim_value,
        policy_credibility_percent: policy_exp.policy_credibility_percent,
        policy_total_expected_losses: policy_exp.policy_total_expected_losses,
        policy_total_limited_losses: policy_exp.policy_total_limited_losses,
        policy_total_claims_count: policy_exp.policy_total_claims_count,
        policy_total_modified_losses_group_reduced: policy_exp.policy_total_modified_losses_group_reduced,
        policy_total_modified_losses_individual_reduced: policy_exp.policy_total_modified_losses_individual_reduced,
        policy_group_ratio: policy_exp.policy_group_ratio,
        policy_individual_total_modifier: policy_exp.policy_individual_total_modifier,
        policy_individual_experience_modified_rate: policy_exp.policy_individual_experience_modified_rate,
        data_source: policy_exp.data_source)
    end
    redirect_to final_policy_calculations_path, notice: "All Policies checked for updates."
  end

 private

  def final_policy_calculation_params
  params.require(:final_policy_calculation).permit(:representative_number, :policy_number, :policy_group_number, :policy_status, :policy_total_four_year_payroll, :policy_credibility_group, :policy_maximum_claim_value, :policy_credibility_percent, :policy_total_expected_losses, :policy_total_limited_losses, :policy_total_claims_count, :policy_total_modified_losses_group_reduced, :policy_total_modified_losses_individual_reduced, :policy_group_ratio, :policy_individual_total_modifier, :policy_individual_experience_modified_rate, :group_rating_qualification, :group_rating_tier, :group_rating_group_number, :policy_total_current_payroll, :policy_total_standard_premium, :policy_total_individual_premium, :policy_total_group_premium, :policy_total_group_savings, :policy_group_fees, :policy_group_dues, :policy_total_costs, :data_source)
  end


end
