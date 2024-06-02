class TwoFactorVerificationsController < ApplicationController
  skip_before_action :check_two_factor_authentication

  def show
    @user = current_user
    @method = current_user.two_factor_method
    send_otp if @method == 'email' || @method == 'sms'
  end

  def verify
    @user = current_user
    if @user.otp_code == params[:otp_code] && @user.otp_sent_at > 10.minutes.ago
      session[:two_factor_verified] = true
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
