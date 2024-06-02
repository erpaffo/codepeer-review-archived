class TwoFactorVerificationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def verify
    @user = current_user
    if params[:otp_code] == @user.otp_code && @user.otp_sent_at > 10.minutes.ago
      session[:two_factor_verified] = true
      redirect_to authenticated_root_path
    else
      flash.now[:alert] = 'Invalid OTP code'
      render :show
    end
  end
end
