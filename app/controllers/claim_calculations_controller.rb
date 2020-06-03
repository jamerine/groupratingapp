class ClaimCalculationsController < ApplicationController
  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @claimant_name     = "Claim: #{@claim_calculation.claim_number} - #{@claim_calculation&.claimant_name&.titleize}"
    @account           = Account.find(@claim_calculation.policy_calculation&.account_id)
    @group_rating      = GroupRating.where(process_representative: @claim_calculation.representative_number).last
    @mira              = @claim_calculation.mira_detail_record
    @affiliates        = @account.affiliates.for_claims
  end

  def search
    @search_value         = params[:search_value]
    @claim_search_results = ClaimCalculation.where("claim_number ILIKE :search_value OR REPLACE(claim_number, '-', '') ILIKE :search_value OR claimant_name ILIKE :search_value", search_value: "%#{@search_value}%").order(:claim_number)

    render json: { matchingClaimsList: render_to_string('claim_calculations/_search-results', layout: false) }
  end

  def export
    @claim_calculation = ClaimCalculation.find(params[:claim_calculation_id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = ClaimCalculationInformation.new(@claim_calculation, view_context)

        send_data pdf.render, filename: "#{Date.current.to_s}_#{ @claim_calculation.claim_number }_claim_information.pdf",
                  type:                 "application/pdf",
                  disposition:          "inline"
      end
    end
  end

  def update_address
    @claim_calculation = ClaimCalculation.find(params[:id])
    @address           = ClaimAddress.find_by(id: address_params[:address_id]) ||
      ClaimAddress.new(claim_number:          @claim_calculation.claim_number,
                       policy_number:         @claim_calculation.policy_number,
                       representative_number: @claim_calculation.representative_number)
    @address.address   = address_params[:address]
    @address.save ? flash[:success] = 'Saved Address Successfully!' : flash[:error] = 'Something went wrong saving the address!'

    redirect_to action: :show, id: params[:id]
  end

  private

  def address_params
    params.require(:claim_calculation).permit(:address_id, :address)
  end
end
