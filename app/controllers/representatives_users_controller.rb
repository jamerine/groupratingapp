class RepresentativesUsersController < ApplicationController

  def new
  end

  def create
  end

  def destroy
    @representative = Representative.find(params[:representative_id])
    @representatives_user = RepresentativesUser.find_by(user_id: params[:user_id], representative_id: params[:representative_id])
    if @representatives_user.destroy
      redirect_to @representative, notice: "User removed from representative."
    else
      redirect_to @representaive, alert: "There was an error removing the user.  Please try again"
    end
  end
end
