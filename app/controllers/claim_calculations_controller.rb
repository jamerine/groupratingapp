class ClaimCalculationsController < ApplicationController
  before_action :claim_search_results, only: %w[search]

  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @account = Account.find(@claim_calculation.policy_calculation.account_id)
    @group_rating = GroupRating.where(process_representative: @claim_calculation.representative_number).last
  end

  def search
    render json: { matchingClaimsLis: @claim_search_results }
  end

  private

  def search_value
    params[:search_value]
  end

  def claim_search_results
    claim_search_results = matching_claim_calculations.each.with_object([]) do |matching_claim_calculation, matching_li_collection|
      matching_li_collection << "<a href='#{claim_calculation_path(matching_claim_calculation)}'><li><div class='claim-number'>#{matching_claim_calculation.claim_number.strip}</div><span class='claimant-name'>#{matching_claim_calculation.claimant_name.strip}</span></li></a>"
    end

    @claim_search_results =  claim_search_results.length.zero? ? no_matching_results_for_search_value : claim_search_results.join('')
  end

  def matching_claim_calculations
    ClaimCalculation.where("claim_number ILIKE :search_value OR REPLACE(claim_number, '-', '') ILIKE :search_value OR claimant_name ILIKE :search_value", search_value: "%#{search_value}%")
  end

  def no_matching_results_for_search_value
    "<li>No matching results for: #{search_value}</li>"
  end

  def does_result_value_ends_with_search_value(result_value)
    result_value_length = result_value.length

    result_value[(result_value_length - search_value.length)..(result_value_length - 1)] == search_value
  end
end
