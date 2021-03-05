class AccountsController < ApplicationController
  include ClaimLossConcern
  before_action :set_account, except: [:index, :new, :create, :import_account_process, :autocomplete_policy_number_entered]
  before_action :set_common_details, only: [:index, :new, :edit, :update, :create, :show, :retention]
  before_action :get_details, only: [:show, :retention]
  claim_loss

  def index

    @accounts = Account.where(representative_id: @representatives).includes(:representative, :policy_calculation)

    if params[:search].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts       = @accounts.where(representative_id: @representative.id).search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_name].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts       = @accounts.where(representative_id: @representative.id).search_name(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:search].present?
      @accounts = @accounts.search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_name].present?
      @accounts = @accounts.search_name(params[:search_name]).paginate(page: params[:page], per_page: 50)
    elsif params[:search_affiliate].present?
      @accounts = @accounts.search_affiliate(params[:search_affiliate]).paginate(page: params[:page], per_page: 50)
    elsif params[:employer_type].present? && params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts       = @representative.accounts.search_employer_type(params[:employer_type]).paginate(page: params[:page], per_page: 50)
    elsif params[:employer_type].present?
      @accounts = @accounts.search_employer_type(params[:employer_type]).paginate(page: params[:page], per_page: 50)
    elsif params[:representative_number].present?
      @representative = @representatives.find_by(representative_number: params[:representative_number])
      @accounts       = @representative.accounts.paginate(page: params[:page], per_page: 50)
    else
      @accounts = @accounts.all.paginate(page: params[:page], per_page: 50)
    end

    @accounts = @accounts.status(params[:status]) if params["status"].present?
    @accounts = @accounts.by_policy_status(params[:policy_status]) if params["policy_status"].present?

    respond_to do |format|
      format.html
      format.js
    end

  end

  def new
    @account      = Account.new
    @accounts_mco = AccountsMco.new
    authorize @account
  end

  def create
    @account = Account.new(account_params)
    authorize @account

    @representative = Representative.find(@account.representative_id)

    if @account.save
      @policy_calculation = @representative.policy_calculations
                            .where(policy_number: @account.policy_number_entered)
                            .update_or_create(policy_number:         @account.policy_number_entered,
                                              representative_id:     @representative.id,
                                              representative_number: @representative.representative_number,
                                              account_id:            @account.id)
      flash[:notice]      = "Account was created successfully"
      redirect_to @account
    else
      flash[:alert] = "There was an error creating account. Please try again."
      render :new
    end
  end

  def autocomplete_policy_number_entered
    representative_id = params[:representative_id].to_i
    policy_number     = params[:policy_number].to_i
    existing_account  = Account.find_by_rep_and_policy(representative_id, policy_number)

    render json: { success: false, message: 'An account already exists for that policy number!' } and return if existing_account.present?

    employer_demographic = EmployerDemographic.where(policy_number: policy_number).order(updated_at: :desc).first

    render json: { success: false, message: 'Something went wrong, please try again!' } and return unless employer_demographic.present?

    render json: {
      success:                true,
      name:                   employer_demographic.primary_name,
      email:                  employer_demographic.primary_contact_email,
      street_address:         employer_demographic.business_street_address_1,
      street_address_2:       employer_demographic.business_street_address_2,
      city:                   employer_demographic.business_city,
      state:                  employer_demographic.business_state_code,
      zip_code:               employer_demographic.business_zip_code,
      contact_name:           employer_demographic.business_contact_name,
      phone_number:           employer_demographic.business_phone,
      phone_number_extension: employer_demographic.business_extension,
      fax_number:             employer_demographic.business_fax,
      mco_id:                 employer_demographic.mco&.id,
      mco_start_date:         employer_demographic.mco_relationship_beginning_date&.to_date&.to_s
    }
  end

  def edit
    authorize @account
    @accounts_mco       = @account.accounts_mco || AccountsMco.new
    @policy_calculation = PolicyCalculation.find_by(account_id: @account.id, representative_number: @account.representative_number, policy_number: @account.policy_number_entered)
  end

  def update
    authorize @account

    if @account.update_attributes(account_params)
      flash[:notice] = "Account was updated successfully"
      redirect_to @account
    else
      flash.now[:alert] = "Error saving account. Please try again."
      render :edit
    end
  end

  def show
    @account_name = "Account #{@account.name&.titleize}"
  end

  def edit_group_rating
    @policy_calculation                     = @account.policy_calculation
    @group_rating_qualifications            = Account.group_rating_qualifications
    @group_rating_qualifications[:auto_run] = "3"
    @group_rating_tiers                     = BwcCodesIndustryGroupSavingsRatioCriterium.where(industry_group: @account.industry_group).pluck(:market_rate)
  end

  def edit_group_retro
    authorize @account

    @policy_calculation                    = @account.policy_calculation
    @group_retro_qualifications            = Account.group_rating_qualifications
    @group_retro_qualifications[:auto_run] = "3"
    @group_retro_tier                      = BwcCodesGroupRetroTier.find_for_account(@account)&.discount_tier
    @group_retro_tiers                     = ["#{@group_retro_tier}"]
  end

  def group_rating_calc
    args = params[:account]

    if args[:group_rating_qualification] == "auto_run"
      @account.policy_calculation.calculate_experience
      @account.policy_calculation.calculate_premium
      @account.group_rating
      @account.update_attributes(fee_override: args[:fee_override])
      @account.group_rating(user_override: true)
      flash[:notice] = "Account's automatic group rating calculation was successful."
      redirect_to @account
    else
      args[:user_override] = true
      @account.group_rating_calc(args)
      flash[:notice] = "Account's group rating calculation was successful."
      redirect_to @account
    end
  end

  def group_retro_calc
    args = params[:account]

    test_account = Account.new(@account.attributes)
    test_account.assign_attributes(group_retro_tier: args[:group_retro_tier], industry_group: args[:industry_group], fee_override: args[:fee_override])

    unless test_account.valid?
      flash[:error] = test_account.errors.full_messages.join('. ')
      redirect_to account_edit_group_retro_path(@account) and return
    end

    if args[:group_retro_qualification] == "auto_run"
      @account.policy_calculation.calculate_experience
      @account.policy_calculation.calculate_premium
      @account.group_retro
      @account.update_attributes(fee_override: args[:fee_override], user_override: false)
      flash[:notice] = "Account's automatic group retro calculation was successful."
      redirect_to @account
    else
      args[:user_override] = true
      @account.group_retro_calc(args)
      flash[:notice] = "Account's group retro calculation was successful."
      redirect_to @account
    end
  end

  def group_rating_calculation
    @account.calculate

    flash[:notice] = "Account Group Rating Calculation Completed."
    redirect_to @account
  end

  def assign
    account_params[:affiliate_ids].each { |affiliate_id| AccountsAffiliate.find_or_create_by(affiliate_id: affiliate_id, account_id: @account.id) }
    flash[:success] = 'Affiliates Saved!'
    redirect_to @account
  end

  def assign_address
    puts params[:address_type]
    redirect_to @account
  end

  def import_account_process
    begin
      AccountImportProcess.perform_async(params[:file].path)
      redirect_to :back, notice: "Accounts imported."
    rescue
      redirect_to :back, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end

  end

  def new_risk_report
    @group_rating   = GroupRating.find(params[:group_rating_id])
    @representative = @account.representative
  end

  def retention
  end

  def risk_report
    @group_rating  = GroupRating.find(params[:account][:group_rating_id])
    @report_params = params[:account]

    respond_to do |format|
      format.html
      format.pdf do

        pdf = RiskReport.new(@account, @account.policy_calculation, @group_rating, @report_params, view_context)

        send_data pdf.render, filename: "#{ @account.policy_number_entered }_risk_report.pdf",
                  type:                 "application/pdf",
                  disposition:          "inline"
      end
    end
  end

  def group_retro_quote
    @group_rating = GroupRating.find(params[:group_rating_id])
    @quote        = @account.quotes.where(program_type: 1).last
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ArmGroupRetroAssessment.new(@quote, @account, @account.policy_calculation, view_context)

        send_data pdf.render, filename: "#{ @account.policy_number_entered }_risk_report.pdf",
                  type:                 "application/pdf",
                  disposition:          "inline"
      end
    end

  end

  def roc_report
    @group_rating = GroupRating.find(params[:group_rating_id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = RocReport.new(@account, @account.policy_calculation, @group_rating, view_context)

        send_data pdf.render, filename: "#{ @account.policy_number_entered }_roc_report.pdf",
                  type:                 "application/pdf",
                  disposition:          "inline"
      end
    end
  end

  private

  def set_account
    @account = Account.includes(:group_rating_exceptions, :policy_calculation, :affiliates).find_by(id: params[:id] || params[:account_id])
    redirect_to page_not_found_path unless @account.present?
  end

  def set_common_details
    @statuses        = Account.statuses
    @policy_statuses = PolicyCalculation.current_coverage_statuses
    @employer_types  = PolicyCalculation.employer_types
    @representatives = Representative.all
    @account_types   = Account.account_types
    @policy_numbers  = EmployerDemographic.pluck(:policy_number)
  end

  def get_details
    @account_changes         = @account.versions.includes(:item).map { |v| [v.created_at, v.changeset] }
    @representative          = Representative.find(@account.representative_id)
    @group_rating            = GroupRating.find_by(representative_id: @representative.id)
    @new_payroll_calculation = PayrollCalculation.new
    @group_rating_rejections = @account.group_rating_rejections.where(program_type: 'group_rating')
    @group_retro_rejections  = @account.group_rating_rejections.where(program_type: 'group_retro')

    redirect_to page_not_found_path unless @account.policy_calculation.present?
  end

  def account_params
    params.require(:account).permit(:representative_id, :name, :policy_number_entered, :street_address, :street_address_2, :city, :state, :zip_code,
                                    :business_contact_name, :business_phone_number, :business_phone_extension, :business_email_address, :website_url, :group_rating_qualification, :tpa_start_date, :tpa_end_date,
                                    :group_rating_tier, :group_fees, :user_override, :industry_group, :group_dues, :total_costs, :status, :federal_identification_number,
                                    :cycle_date, :request_date, :quarterly_request, :weekly_request, :ac3_approval, :fee_override, :account_type, :fax_number,
                                    affiliate_ids: [], accounts_mco_attributes: [:mco_id, :account_id, :relationship_start_date])
  end
end
