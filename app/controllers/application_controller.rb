class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_two_factor_authentication

  private

  def check_two_factor_authentication
    if user_signed_in? && current_user.two_factor_enabled && !session[:two_factor_verified]
      unless on_two_factor_verification_page?
        redirect_to two_factor_verification_path
      end
    end
  end

  def on_two_factor_verification_page?
    controller_name == 'two_factor_verifications' && action_name == 'show'
  end
end
