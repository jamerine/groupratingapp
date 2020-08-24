class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.

  # For APIs, you may want to use :null_session instead.

  include Pundit
  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :set_paper_trail_whodunnit, except: :payroll_diff
  before_action :find_representatives

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def page_not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  private

  def user_not_authorized(exception)
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def find_representatives
    if current_user
      @representatives_users = RepresentativesUser.where(user_id: current_user.id).pluck(:representative_id)
      @representatives       = Representative.where(id: @representatives_users)
    end
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
  # end

end
