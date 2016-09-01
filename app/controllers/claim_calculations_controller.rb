class ClaimCalculationsController < ApplicationController
  def index
    @claim_calculations = ClaimCalculation.all.paginate(page: params[:page], per_page: 100)
  end

  def show
    @claim_calculation = ClaimCalculation.find_by(id: params[:id])
    @group_rating = GroupRating.where(process_representative: @claim_calculation.representative_number).last
  end


  def create_claim_objects
    Resque.enqueue(ClaimUpdateCreate)
    redirect_to claim_calculations_path, notice: "Claims are queued to update."
  end

end