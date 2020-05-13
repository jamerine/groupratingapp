class AffiliatesController < ApplicationController
  before_action :set_account, except: :import_affiliate_process

  def new
    @account_affiliate = AccountsAffiliate.new(account_id: @account.id)
    @affiliate         = @account_affiliate.build_affiliate(representative_id: @account.representative_id)
  end

  def create
    # @affiliate         = Affiliate.new(account_affiliate_params[:affiliate])
    # @account_affiliate = AccountsAffiliate.new(account_id: params[:account_id], affiliate: @affiliate)
    @account_affiliate = AccountsAffiliate.new(account_affiliate_params)

    if @account_affiliate.save
      flash[:success] = 'Affiliates Saved Successfully!'
      redirect_to @account
    else
      flash[:error] = 'Something went wrong, please try again!'
      render :new
    end
  end

  def destroy
    @affiliate          = Affiliate.find(params[:id])
    @accounts_affiliate = AccountsAffiliate.find_by(account_id: @account, affiliate_id: @affiliate)
    if @accounts_affiliate.destroy
      redirect_to @account, notice: "Affiliate has been removed"
    else
      redirect_to @account, alert: "Error removing affiliate"
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
