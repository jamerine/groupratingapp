class AffiliatesController < ApplicationController
  before_action :set_account, except: :import_affiliate_process

  def new
    @account_affiliate = AccountsAffiliate.new(account_id: @account.id)
    @affiliate         = @account_affiliate.build_affiliate(representative_id: @account.representative_id)
  end

  def edit
    @account_affiliate = AccountsAffiliate.find_by(account_id: params[:account_id], affiliate_id: params[:id])
    @affiliate         = @account_affiliate.affiliate
  end

  def create
    @account_affiliate = AccountsAffiliate.new(account_affiliate_params)

    if @account_affiliate.save
      flash[:success] = 'Affiliates Saved Successfully!'
      redirect_to @account
    else
      flash[:error] = 'Something went wrong, please try again!'
      render :new
    end
  end

  def update
    @account_affiliate = AccountsAffiliate.find_by(account_id: params[:account_id], affiliate_id: params[:id])

    if @account_affiliate.update(account_affiliate_params)
      flash[:success] = 'Affiliates Saved Successfully!'
      redirect_to @account
    else
      flash[:error] = 'Something went wrong, please try again!'
      render :edit
    end
  end

  def destroy
    if AccountsAffiliate.find_by(account_id: params[:account_id], affiliate_id: params[:id])&.destroy
      flash[:success] = "Affiliate Has Been Removed Successfully!"
      redirect_to @account
    else
      flash[:error] = "Error Removing Affiliate!"
      redirect_to @account
    end
  end

  def import_affiliate_process

    # CSV.foreach(params[:file].path, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
    #   affiliate_hash = row.to_hash # exclude the price field
    #   AffiliateImport.perform_async(affiliate_hash)
    # end

    begin
      AffiliateImportProcess.perform_async(params[:file].path)
      redirect_to :back, notice: "Affiliates imported."
    rescue
      redirect_to :back, alert: "There was an error importing file.  Please ensure file columns and file type are correct"
    end
  end

  private

  def account_affiliate_params
    params.require(:accounts_affiliate).permit(:account_id, affiliate_attributes: [:first_name, :last_name, :representative_id, :role, :email_address, :company_name, :external_id, :internal_external, :salesforce_id])
  end

  def set_account
    @account    = Account.find(params[:account_id])
    @affiliates = Affiliate.by_representative(@account.representative_id)
    @roles      = Affiliate.roles
  end
end
