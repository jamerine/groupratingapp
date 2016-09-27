class AccountsController < ApplicationController
  def index
    @accounts = Account.all.paginate(page: params[:page], per_page: 100)
    @representatives = Representative
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
    @account = Account.find(params[:id])
    @statuses = Account.statuses
    @policy_calculation = @account.policy_calculation
    @representative = Representative.find(@account.representative_id)
    @new_payroll_calculation = PayrollCalculation.new
  end


  private

  def account_params
    params.require(:account).permit(:representative_id, :name, :policy_number_entered, :street_address, :street_address_2, :city, :state, :zip_code, :business_phone_number, :business_email_address, :website_url, :group_fees, :group_dues, :total_costs, :status, :federal_identification_number, :cycle_date, :request_date, :quarterly_request, :weekly_request)
  end



end
