class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_two_factor_authentication

  private

  def check_two_factor_authentication
    if user_signed_in? && !session[:two_factor_verified]
      if current_user.two_factor_enabled
        redirect_to two_factor_verification_path unless on_two_factor_verification_page?
      end
    end
  end

  def on_two_factor_verification_page?
    controller_name == 'two_factor_verifications'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :terms_of_service])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password, :terms_of_service])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
