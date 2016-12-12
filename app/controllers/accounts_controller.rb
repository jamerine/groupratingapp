class AccountsController < ApplicationController
  def index
    @accounts = Account.all
    @representatives = Representative.all
    if params[:search].present? && params[:representative_number].present?
      @representative = Representative.find_by(representative_number: params[:representative_number])
      @accounts = Account.includes(:group_rating_rejections).where(representative_id: @representative.id).search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:search].present?
      @accounts = Account.includes(:group_rating_rejections).search(params[:search]).paginate(page: params[:page], per_page: 50)
    elsif params[:representative_number].present?
      @representative = Representative.find_by(representative_number: params[:representative_number])
      @accounts = Account.includes(:group_rating_rejections).where(representative_id: @representative.id).paginate(page: params[:page], per_page: 50)
    else
      @accounts = Account.includes(:group_rating_rejections).all.paginate(page: params[:page], per_page: 50)
    end
  end

  def new
    @account = Account.new
    @representatives = Representative.all
    @statuses = Account.statuses
  end

  def create
    @account = Account.new(account_params)
    @representative = Representative.find(@account.representative_id)
    if @account.save
      @policy_calculation = PolicyCalculation.where(policy_number: @account.policy_number_entered).update_or_create(policy_number: @account.policy_number_entered, representative_id: @representative.id, representative_number: @representative.representative_number, account_id: @account.id)
      flash[:notice] = "Account was created successfully"
      redirect_to @account
    else
      flash[:alert] = "There was an error creating account. Please try again."
      render :new
    end
  end


  def edit
    @account = Account.find(params[:id])
    @representatives = Representative.all
    @representative = Representative.find(@account.representative_id)
    @policy_calculation = PolicyCalculation.find_by(account_id: @account.id)
    @statuses = Account.statuses

  end

  def update
    @account = Account.find(params[:id])
    @statuses = Account.statuses
    @account.assign_attributes(account_params)
    if @account.save
      @policy_calculation = PolicyCalculation.where(policy_number: @account.policy_number_entered).update_or_create(policy_number: @account.policy_number_entered, representative_id: @account.representative.id, representative_number: Representative.find(@account.representative.id).representative_number, account_id: @account.id)
      flash[:notice] = "Account was updated successfully"
      redirect_to @account
    else
      flash.now[:alert] = "Error saving account. Please try again."
      render :edit
    end
  end


  def show
    @account = Account.includes(:group_rating_rejections, :group_rating_exceptions).find(params[:id])
    @account_changes = @account.versions.map{|v| [v.created_at, v.changeset]}
    @statuses = Account.statuses
    @representative = Representative.find(@account.representative_id)
    @new_payroll_calculation = PayrollCalculation.new
    @policy_calculation = PolicyCalculation.find_by(account_id: @account.id)
    @affiliates = @account.affiliates
    @contacts = @account.contacts
  end


  def edit_group_rating
    @account = Account.find(params[:account_id])
    @policy_calculation = @account.policy_calculation
    @group_rating_qualifications = Account.group_rating_qualifications
    @group_rating_qualifications[:auto_run] = "3"
    @group_rating_tiers = BwcCodesIndustryGroupSavingsRatioCriterium.where(industry_group: @account.industry_group).pluck(:market_rate).uniq
  end

  def group_rating_calc
    args = params[:account]
    @account = Account.find(params[:account_id])
    if args[:group_rating_qualification] == "auto_run"
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

  def assign
    @account = Account.find(params[:account_id])
    @affiliate = Affiliate.find(params[:account][:id])
    @accounts_affiliate = AccountsAffiliate.create(affiliate_id: @affiliate.id, account_id: @account.id)
    redirect_to @account
  end

  # def group_rating
  #   @account = Account.find(params[:account_id])
  #   @account.group_ratings
  #     flash[:notice] = "Account's group rating calculation was successful."
  #     redirect_to @account
  # end


  private

  def account_params
    params.require(:account).permit(:representative_id, :name, :policy_number_entered, :street_address, :street_address_2, :city, :state, :zip_code, :business_phone_number, :business_email_address, :website_url, :group_rating_qualification, :group_rating_tier, :group_fees, :user_override, :industry_group, :group_dues, :total_costs, :status, :federal_identification_number, :cycle_date, :request_date, :quarterly_request, :weekly_request, :ac3_approval)
  end



end
