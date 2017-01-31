class UsersController < ApplicationController
  before_filter :authorize_admin, only: :create

  def new
    @representative = Representative.find(params[:representative_id])
    @user = User.new
    @roles = User.roles
  end

  def create
    @representative = Representative.find(params[:representative_id])
    @user = User.new(user_params)
    if @user.save
      @representatives_user = RepresentativesUser.create(user_id: @user.id, representative_id: @representative.id)
      redirect_to @representative, notice: "User Created"
    else
      redirect_to @representative, alert: "Error creating a user"
    end

  end

  private

  def user_params
    params.require(:user).permit( :role, :first_name, :last_name, :email, :password, :password_confirmation)
  end

  def authorize_admin
    return unless !current_user.admin?
    redirect_to root_path, alert: 'Admins only!'
  end
end
