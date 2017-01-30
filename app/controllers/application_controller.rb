class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :set_paper_trail_whodunnit
  before_action :find_representatives


  private

  def find_representatives
    if current_user
      @representatives_users = RepresentativesUser.where(user_id: current_user.id).pluck(:representative_id)
      @representatives = Representative.where(id: @representatives_users)
    end
  end


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
  end

end
