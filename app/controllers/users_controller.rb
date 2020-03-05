class UsersController < ApplicationController
  before_filter :authorize_admin, only: [:create, :index]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(last_name: :asc, first_name: :asc)
  end

  def new
    @representative = Representative.find_by(id: params[:representative_id]) || Representative.first
    @user           = User.new
    @roles          = User.roles
  end

  def create
    @representative = Representative.find(params[:representative_id])
    @user           = User.new(user_params)

    if @user.save
      @representatives_user = RepresentativesUser.create(user_id: @user.id, representative_id: @representative.id)
      redirect_to @representative, flash: { notice: "User Created" }
    else
      redirect_to @representative, flash: { alert: "Error creating a user" }
    end
  end

  def edit

  end

  def update

  end

  def destroy
    if @user.destroy
      redirect_to users_path, flash: { success: 'User successfully deleted!' }
    else
      redirect_to users_path, flash: { danger: 'Something went wrong, please try again.' }
    end
  end

  private

  def user_params
    params.require(:user).permit(:role, :first_name, :last_name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(id: params[:id])

    redirect_to users_path, flash: { danger: 'Cannot Find User!' } unless @user.present?
  end

  def authorize_admin
    return if current_user.admin?
    redirect_to root_path, flash: { alert: 'Admins only!' }
  end
end