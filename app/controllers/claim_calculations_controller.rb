class ClaimCalculationsController < ApplicationController
  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @account = Account.find(@claim_calculation.policy_calculation.account_id)
    @group_rating = GroupRating.where(process_representative: @claim_calculation.representative_number).last
  end
end
