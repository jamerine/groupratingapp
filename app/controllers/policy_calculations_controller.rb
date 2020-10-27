class PolicyCalculationsController < ApplicationController

  def index
    @policy_calculations = PolicyCalculation.all
    @representatives     = Representative.all
    if params[:search].present? && params[:representative_number].present?
      @policy_calculations = PolicyCalculation.where(representative_number: params[:representative_number]).search(params[:search]).paginate(page: params[:page], per_page: 100)
    elsif params[:search].present?
      @policy_calculations = PolicyCalculation.search(params[:search]).paginate(page: params[:page], per_page: 100)
    elsif params[:representative_number].present?
      @policy_calculations = PolicyCalculation.where(representative_number: params[:representative_number]).paginate(page: params[:page], per_page: 100)
    else
      @policy_calculations = PolicyCalculation.all.paginate(page: params[:page], per_page: 100)
    end
  end

  def show
    @policy_calculation = PolicyCalculation.find_by(id: params[:id])
    redirect_to page_not_found_path and return unless @policy_calculation.present?

    @account = Account.find_by(id: @policy_calculation.account_id)
    redirect_to page_not_found_path and return unless @account.present? && @policy_calculation.account.present?

    @policy_demographics       = FinalEmployerDemographicsInformation.find_by(policy_number: @policy_calculation.policy_number)
    @manual_class_calculations = @policy_calculation.manual_class_calculations
    @page                      = params[:page]
    @claim_calculations        = @policy_calculation.claim_calculations.order(claim_injury_date: :desc)
    @representative            = Representative.find(@policy_calculation.representative_id)
    @new_payroll_calculation   = PayrollCalculation.new
    @policy_number             = "Policy: #{@policy_calculation.policy_number} - #{@policy_calculation.account.name.titleize}"
  end

  def new
    @policy_calculation = PolicyCalculation.new
    @representatives    = Representative.all
  end

  def edit

  end

  def update
  end

  def search
    @search_value          = params[:search_value]
    @policy_search_results = PolicyCalculation.joins(:account)
                             .includes(:account, :representative)
                             .where("accounts.representative_id IN (?)", current_user.representatives_users.pluck(:representative_id).compact)
                             .where("policy_calculations.policy_number::text ILIKE :search_value OR REPLACE(policy_calculations.policy_number::text, '-', '') ILIKE :search_value OR accounts.name ILIKE :search_value OR accounts.business_contact_name ILIKE :search_value OR REPLACE(accounts.business_contact_name::text, '$', ' ') ILIKE :search_value", search_value: "%#{@search_value}%")
                             .uniq
                             .order("policy_calculations.policy_number ASC")

    render json: { matchingPoliciesList: render_to_string('policy_calculations/_search-results', layout: false) }
  end

  private

  def policy_calculation_params
    params.require(:policy_calculation).permit(:representative_number, :policy_number, :policy_group_number, :policy_status, :policy_total_four_year_payroll, :policy_credibility_group, :policy_maximum_claim_value, :policy_credibility_percent, :policy_total_expected_losses, :policy_total_limited_losses, :policy_total_claims_count, :policy_total_modified_losses_group_reduced, :policy_total_modified_losses_individual_reduced, :policy_group_ratio, :policy_individual_total_modifier, :policy_individual_experience_modified_rate, :group_rating_qualification, :group_rating_tier, :group_rating_group_number, :policy_total_current_payroll, :policy_total_standard_premium, :policy_total_individual_premium, :policy_total_group_premium, :policy_total_group_savings, :policy_group_fees, :policy_group_dues, :policy_total_costs, :data_source, :representative_id)
  end


end
