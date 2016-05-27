class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception
  include SessionsHelper
  # after_action :verify_authorized
  # before_action :authenticate_user!

  # def after_sign_in_path_for(resource)
  #   wikis_path
  # end
  #
  # def after_sign_out_path_for(resource)
  #   root_path
  # end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :current_password) }
  end

  private

  def require_sign_in
    unless current_user
      flash[:alert] = 'You must be logged in to do that'
      redirect_to new_user_session_path
    end
  end
end
