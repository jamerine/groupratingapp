class RepresentativesController < ApplicationController

  def index
    @representatives = Representative.all
  end


  def show
    @representative = Representative.find(params[:id])
    @policy_calculations = @representative.policy_calculations
    @manual_class_calculations = @representative.manual_class_calculations
    @group_ratings = @representative.group_ratings
    # @newest_group_rating = @group_ratings.last
    # @import = Import.find_by(group_rating_id: @newest_group_rating.id)

    respond_to do |format|
      format.html
      format.csv { send_data @policy_calculations.to_csv, filename: "#{@representative.abbreviated_name}_policies_#{Date.today}.csv" }
    end

  end

  def export_accounts
    @representative = Representative.find(params[:representative_id])
    @accounts = @representative.accounts

    respond_to do |format|
      format.html
      format.csv { send_data @accounts.to_csv, filename: "#{@representative.abbreviated_name}_accounts_#{Date.today}.csv" }
    end

  end


  def export_manual_classes
    @representative = Representative.find(params[:representative_id])
    @manual_class_calculations = @representative.manual_class_calculations

    respond_to do |format|
      format.html
      format.csv { send_data @manual_class_calculations.to_csv, filename: "#{@representative.abbreviated_name}_manual_classes_#{Date.today}.csv" }
    end
  end

  def export_159_request
    @representative = Representative.find(params[:representative_id])
    @accounts = @representative.accounts.where("status in (0,2,3)")

    respond_to do |format|
      format.html
      format.csv { send_data @accounts.to_request(@representative.representative_number), filename: "#{@representative.abbreviated_name}_159_request_#{Date.today}.csv" }
    end
  end



  def edit
    @representative = Representative.find(params[:id])
  end

  def fee_calculations
    @representative = Representative.find(params[:representative_id])
    @policy_calculations = PolicyCalculation.where(representative_id: @representative.id )
    flash.now[:alert] = "All of #{@representative.abbreviated_name} policies are beginning to update."
    @policy_calculations.each do |policy|
      policy.fee_calculation
    end
    flash[:notice] = "All of #{@representative.abbreviated_name} policies group fees are now updated."
    redirect_to representatives_path
  end






end
