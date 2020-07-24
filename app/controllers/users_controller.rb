class UsersController < ApplicationController
  before_filter :authorize_admin, only: [:create, :index]
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :handle_params, only: [:create, :update]

  def index
    @users = User.all.order(last_name: :asc, first_name: :asc)
  end

  def new
    @representative = Representative.find_by(id: params[:representative_id])
    @user           = User.new

    @user.representatives << @representative if @representative.present?
  end

  def create
    @user = User.new(@user_params)

    if @user.save
      @user_params[:representative_ids].each do |rep_id|
        RepresentativesUser.find_or_create_by(user_id: @user.id, representative_id: rep_id)
      end

      flash[:success] = 'User Created!'
      redirect_to action: :index
    else
      flash[:danger] = "Error Creating User! #{@user.errors.full_messages.join('. ')}"
      render :new
    end
  end

  def edit
  end

  def update
    @user.assign_attributes(@user_params)

    if @user.save
      @user_params[:representative_ids].each do |rep_id|
        RepresentativesUser.find_or_create_by(user_id: @user.id, representative_id: rep_id)
      end

      flash[:success] = 'User Updated!'
      redirect_to action: :index
    else
      flash[:danger] = 'Something went wrong, please try again.'
      render :edit
    end
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
    params.require(:user).permit(:role, :first_name, :last_name, :email, :password, :password_confirmation, representative_ids: [])
  end

  def set_user
    @user = User.find_by(id: params[:id])

    redirect_to users_path, flash: { danger: 'Cannot Find User!' } unless @user.present?
  end

  def authorize_admin
    return if current_user.admin?
    redirect_to root_path, flash: { alert: 'Admins only!' }
  end

  def handle_params
    @user_params        = user_params
    @user_params[:role] = @user_params[:role]&.to_i unless @user_params[:role].blank?

    return @user_params unless @user.present?

    @user_params.delete(:password) if user_params[:password].blank? && @user.encrypted_password.present?
    @user_params.delete(:password_confirmation) if user_params[:password].blank? && @user.encrypted_password.present?
  end
end