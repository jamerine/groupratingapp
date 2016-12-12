class AffiliatesController < ApplicationController

  def new
    @account = Account.find(params[:account_id])
    @affiliate = Affiliate.new
    @roles = Affiliate.roles
  end

  def create
    @account = Account.find(params[:account_id])
    @affiliate = @account.affiliate.create(affiliate_params)
  end



  private

  def affiliate_params
    params.require(:affiliate).permit(:account_id, :first_name, :last_name, :role, :email)
  end
end
