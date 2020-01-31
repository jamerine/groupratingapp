class ClaimCalculationsController < ApplicationController

  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @account           = Account.find(@claim_calculation.policy_calculation&.account_id)
    @group_rating      = GroupRating.where(process_representative: @claim_calculation.representative_number).last
    @mira              = @claim_calculation.mira_detail_record
  end

  def search
    @search_value         = params[:search_value]
    @claim_search_results = ClaimCalculation.where("claim_number ILIKE :search_value OR REPLACE(claim_number, '-', '') ILIKE :search_value OR claimant_name ILIKE :search_value", search_value: "%#{@search_value}%")

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
end
