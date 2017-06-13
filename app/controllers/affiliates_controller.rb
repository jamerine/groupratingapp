class AffiliatesController < ApplicationController

  def new
    @account = Account.find(params[:account_id])
    @affiliate = Affiliate.new
    @affiliates = Affiliate.all
    @roles = Affiliate.roles
  end

  def create
    @account = Account.find(params[:affiliate][:account_id])
    @affiliate = @account.affiliates.create(affiliate_params)
    redirect_to @account
  end



  def destroy
    @affiliate = Affiliate.find(params[:id])
    @account = Account.find(params[:account_id])
    @accounts_affiliate = AccountsAffiliate.find_by(account_id: @account, affiliate_id: @affiliate)
    if @accounts_affiliate.destroy
        redirect_to @account, notice: "Affiliate has been removed"
    else
        redirect_to @account, alert: "Error removing affiliate"
    end

  end

  def import_affiliate_process

    CSV.foreach(params[:file].path, headers: true, encoding: 'iso-8859-1:utf-8') do |row|
      affiliate_hash = row.to_hash # exclude the price field
      AffiliateImport.perform_async(affiliate_hash)
    end

    redirect_to root_url, notice: "Affiliates imported."
  end




  private

  def affiliate_params
    params.require(:affiliate).permit(:first_name, :last_name, :role, :email_address, :company_name, :external_id, :internal_external, :salesforce_id)
  end
end
