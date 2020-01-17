class ClaimCalculationsController < ApplicationController

  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @account           = Account.find(@claim_calculation.policy_calculation.account_id)
    @group_rating      = GroupRating.where(process_representative: @claim_calculation.representative_number).last
  end

  def search
    @search_value         = params[:search_value]
    @claim_search_results = ClaimCalculation.where("claim_number ILIKE :search_value OR REPLACE(claim_number, '-', '') ILIKE :search_value OR claimant_name ILIKE :search_value", search_value: "%#{@search_value}%")

    render json: { matchingClaimsList: render_to_string('claim_calculations/_search-results', layout: false) }
  end
end
