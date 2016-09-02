class PolicyCalculationsController < ApplicationController

  def index
    @policy_calculations = PolicyCalculation.all
    @representatives = Representative.all
    if params[:search].present?
      @policy_calculations = PolicyCalculation.search(params[:search]).paginate(page: params[:page], per_page: 100)
    else
      @policy_calculations = PolicyCalculation.all.paginate(page: params[:page], per_page: 100)
    end
    @representatives = Representative.all
  end

  def show
    @policy_calculation = PolicyCalculation.find(params[:id])
    @policy_demographics = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_calculation.policy_number)
    @manual_class_calculations = ManualClassCalculation.where(policy_calculation_id: @policy_calculation.id)
    @representative = Representative.find(@policy_calculation.representative_id)
  end

  def new
    @policy_calculation = PolicyCalculation.new
    @representatives = Representatives.all
  end

  def update_or_create_policy


  end




 private

  def policy_calculation_params
  params.require(:policy_calculation).permit(:representative_number, :policy_number, :policy_group_number, :policy_status, :policy_total_four_year_payroll, :policy_credibility_group, :policy_maximum_claim_value, :policy_credibility_percent, :policy_total_expected_losses, :policy_total_limited_losses, :policy_total_claims_count, :policy_total_modified_losses_group_reduced, :policy_total_modified_losses_individual_reduced, :policy_group_ratio, :policy_individual_total_modifier, :policy_individual_experience_modified_rate, :group_rating_qualification, :group_rating_tier, :group_rating_group_number, :policy_total_current_payroll, :policy_total_standard_premium, :policy_total_individual_premium, :policy_total_group_premium, :policy_total_group_savings, :policy_group_fees, :policy_group_dues, :policy_total_costs, :data_source, :representative_id)
  end


end
