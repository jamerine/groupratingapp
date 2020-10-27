class ErrorsController < ApplicationController
  protect_from_forgery with: :null_session

  def page_not_found
  end

  def internal_server_error
  end
end