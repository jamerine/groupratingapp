class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.

  # For APIs, you may want to use :null_session instead.

  include Pundit
  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :set_paper_trail_whodunnit, except: :payroll_diff
  before_action :find_representatives
  before_action :check_process_progress

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def find_representatives
    if current_user
      @representatives = current_user.representatives
    end
  end

  def check_process_progress
    require 'sidekiq/api'
    stats               = Sidekiq::Stats.new.fetch_stats!
    @process_is_running = stats[:workers_size] > 0 || stats[:enqueued] > 0 || stats[:scheduled_size] > 0
  end

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :role])
  # end

end
