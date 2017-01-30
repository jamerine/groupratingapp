class RepresentativesUsersController < ApplicationController

  def new
  end

  def create
    @user = User.find(params[:user_id])
    @representative = Representative.find(params[:representative_id])
    RepresentativesUser.create({user_id: @user.id, representative_id: @representative.id})
    redirect_to @representative, notice: "User added to Representative"

  end

  def show
  end

  def destroy
    @representative = Representative.find(params[:representative_id])
    @representatives_user = RepresentativesUser.find_by(user_id: params[:user_id], representative_id: params[:representative_id])
    if @representatives_user.destroy
      redirect_to representative_path(@representative), notice: "User removed from representative."
    else
      redirect_to representative_path(@representative), alert: "There was an error removing the user.  Please try again"
    end
  end
end
