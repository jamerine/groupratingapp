class RepresentativesController < ApplicationController

  def index
    @representatives = Representative.all
  end


  def show
    @representative = Representative.find(params[:id])
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
