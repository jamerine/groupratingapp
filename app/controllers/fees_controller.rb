class FeesController < ApplicationController

  def index
    @representative = Representative.includes(accounts: [:account_programs] ).find(params[:representative_id])
    @statuses = Account.statuses
    @group_rating_tiers = BwcCodesIndustryGroupSavingsRatioCriterium.all.order(market_rate: :asc).pluck(:market_rate).uniq
    @accounts = @representative.accounts.includes(:account_programs).paginate(page: params[:page], per_page: 100)
    @accounts = @accounts.status(params[:status]).paginate(page: params[:page], per_page: 100) if params[:status].present?
    @accounts = @accounts.group_rating_tier(params[:group_rating_tier]).paginate(page: params[:page], per_page: 100) if params[:group_rating_tier].present?
    @percent_change = (params[:fee_change_percent].to_f / 100) if params[:fee_change_percent].present?
    @accounts = @accounts.fee_change_percent(@percent_change).paginate(page: params[:page], per_page: 100) if params[:fee_change_percent].present?

    @parameters = {}
    @parameters[:representative_id] = params[:representative_id] if params[:representative_id].present?
    @parameters[:status] = params[:status] if params[:status].present?
    @parameters[:group_rating_tier] = params[:group_rating_tier] if params[:group_rating_tier].present?
    @parameters[:group_retro_tier] = params[:group_retro_tier] if params[:group_retro_tier].present?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def fee_accounts
    if !params[:account_ids].nil?
      redirect_to edit_individual_fees_path(account_ids: params[:account_ids], representative_id: params[:representative_id])
    else
      redirect_to fees_path(representative_id: params[:representative_id]), alert: "Please select accounts to change fees!"
    end
  end

  def edit_individual
    @representative = Representative.find(params[:representative_id])
    if params[:account_ids].present?
      @accounts = Account.find(params[:account_ids])
    elsif params[:parameters].present?
      @parameters = params[:parameters]
      @representative = Representative.find(@parameters["representative_id"])
      @status = Account.statuses.key(@parameters["status"].to_i) if @parameters["status"].present?
      @group_rating_tier = @parameters["group_rating_tier"]
      @accounts = Account.where(representative_id: @parameters["representative_id"])
      @accounts = @accounts.status(@parameters["status"]) if @parameters["status"].present?
      @accounts = @accounts.group_rating_tier(@parameters["group_rating_tier"]) if @parameters["group_rating_tier"].present?
    end

  end

  def update_individual
    @representative = Representative.find(params[:representative_id])
    @accounts = Account.update(params[:accounts].keys, params[:accounts].values).reject { |p| p.errors.empty? }
    if @accounts.empty?
      redirect_to fees_path(representative_id: @representative.id), notice: "Accounts updated."
    else
      render :action => "edit_individual"
    end
  end

end
