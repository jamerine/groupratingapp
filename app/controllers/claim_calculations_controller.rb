class ClaimCalculationsController < ApplicationController
  before_action :set_account_and_policy, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_claim, only: [:edit, :update, :destroy]

  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def new
    @claim_calculation = @policy_calculation.claim_calculations.new({
                                                                      representative_number: @policy_calculation.representative_number,
                                                                      policy_number:         @policy_calculation.policy_number,
                                                                      data_source:           'user'
                                                                    })
  end

  def create
    @claim_calculation = @policy_calculation.claim_calculations.new(claim_params)

    if @claim_calculation.save
      begin
        @claim_calculation.calculate_unlimited_limited_loss
        @claim_calculation.recalculate_experience(@policy_calculation.policy_maximum_claim_value)
        flash[:success] = 'Claim successfully added!'
        redirect_to policy_calculation_path(@policy_calculation)
      rescue
        flash[:error] = 'Claim Added, but something went wrong calculating the experience!'
        redirect_to edit_policy_calculation_claim_calculation_path(@policy_calculation, @claim_calculation)
      end
    else
      flash[:error] = 'Something went wrong, please try again!'
      render :new
    end

  end

  def edit
  end

  def update
    if @claim_calculation.update_attributes(claim_params)
      begin
        @claim_calculation.calculate_unlimited_limited_loss
        @claim_calculation.recalculate_experience(@policy_calculation.policy_maximum_claim_value)
        flash[:success] = 'Claim Successfully Updated!'
        redirect_to policy_calculation_path(@policy_calculation)
      rescue => e
        puts e
        flash[:error] = 'Claim updated, but something went wrong calculating the experience, please make sure the default values are in place in the form!'
        redirect_to edit_policy_calculation_claim_calculation_path(@policy_calculation, @claim_calculation)
      end
    else
      flash[:error] = 'Something went wrong, please try again!'
      render :new
    end
  end

  def destroy
    flash[:success] = 'Claim Successfully Deleted!' if @claim_calculation.destroy
    redirect_to policy_calculation_path(@policy_calculation)
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
    @claim_search_results = ClaimCalculation.includes(policy_calculation: [:account, :representative]).joins(policy_calculation: :account).where("claim_calculations.claim_number ILIKE :search_value OR REPLACE(claim_calculations.claim_number, '-', '') ILIKE :search_value OR claim_calculations.claimant_name ILIKE :search_value OR accounts.name ILIKE :search_value", search_value: "%#{@search_value}%").order('accounts.name ASC').order(:policy_number)

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

  def claim_params
    params.require(:claim_calculation).permit(:claim_activity_status, :claim_activity_status_effective_date, :claim_combined, :claim_group_multiplier, :claim_group_reduced_amount,
                                              :claim_handicap_percent, :claim_handicap_percent_effective_date, :claim_individual_multiplier, :claim_individual_reduced_amount,
                                              :claim_injury_date, :claim_manual_number, :claim_medical_paid, :claim_mira_indemnity_reserve_amount, :claim_mira_medical_reserve_amount,
                                              :claim_mira_ncci_injury_type, :claim_mira_non_reducible_indemnity_paid, :claim_mira_non_reducible_indemnity_paid_2, :claim_mira_reducible_indemnity_paid,
                                              :claim_modified_losses_group_reduced, :claim_modified_losses_individual_reduced, :claim_number, :claim_rating_plan_indicator,
                                              :claim_status, :claim_status_effective_date, :claim_subrogation_percent, :claim_total_subrogation_collected, :claim_type,
                                              :claim_unlimited_limited_loss, :claimant_date_of_birth, :claimant_date_of_death, :claimant_name, :combined_into_claim_number,
                                              :data_source, :enhanced_care_program_indicator, :indemnity_settlement_date, :maximum_medical_improvement_date,
                                              :medical_settlement_date, :policy_individual_maximum_claim_value, :policy_number,
                                              :policy_type, :representative_number, :settled_claim, :settlement_type, :created_at, :updated_at, :policy_calculation_id)
  end

  def address_params
    params.require(:claim_calculation).permit(:address_id, :address)
  end

  def set_account_and_policy
    @policy_calculation = PolicyCalculation.find_by(id: params[:policy_calculation_id])
    @account            = Account.find_by(id: @policy_calculation&.account_id)
    page_not_found unless @account.present?
  end

  def set_claim
    @claim_calculation = ClaimCalculation.find_by(policy_number: @policy_calculation.policy_number, id: params[:id])
    page_not_found unless @claim_calculation.present?
  end
end
