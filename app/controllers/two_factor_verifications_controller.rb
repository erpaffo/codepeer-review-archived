class TwoFactorVerificationsController < ApplicationController
  skip_before_action :check_two_factor_authentication, only: [:show, :verify, :resend_otp]

  def show
    @user = current_user
    @method = current_user.two_factor_method
    send_otp if @method == 'email' || @method == 'sms'
  end

  def verify
    @user = current_user
    totp = ROTP::TOTP.new(@user.otp_secret)

    if totp.verify(params[:otp_code], drift_behind: 15, drift_ahead: 15)
      session[:two_factor_verified] = true
      flash[:notice] = 'Two-factor authentication successful'
      redirect_to authenticated_root_path
    else
      flash.now[:alert] = 'Invalid OTP code'
      render :show
    end
  end

  def resend_otp
    send_otp
    flash[:notice] = 'OTP sent successfully'
    redirect_to two_factor_verification_path
  end

  private

  def send_otp
    method = current_user.two_factor_method
    if method == 'email'
      current_user.send_otp_via_email
    elsif method == 'sms'
      current_user.send_otp_via_sms
    end
  end
end
