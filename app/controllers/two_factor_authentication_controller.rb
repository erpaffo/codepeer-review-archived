require 'rotp'
require 'rqrcode'

class TwoFactorAuthenticationController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    totp = ROTP::TOTP.new(@user.otp_secret, issuer: "Codepeer Review")
    @qr_code = RQRCode::QRCode.new(totp.provisioning_uri(@user.email)).as_png(size: 200)
  end

  def enable
    @user = current_user

    if params[:otp_code] == ROTP::TOTP.new(@user.otp_secret).now
      @user.update(two_factor_enabled: true)
      redirect_to settings_path, notice: 'Two-factor authentication enabled'
    else
      redirect_to two_factor_authentication_path, alert: 'Invalid OTP code'
    end
  end

  def disable
    @user = current_user

    if params[:otp_code] == ROTP::TOTP.new(@user.otp_secret).now
      @user.update(two_factor_enabled: false)
      redirect_to settings_path, notice: 'Two-factor authentication disabled'
    else
      redirect_to two_factor_authentication_path, alert: 'Invalid OTP code'
    end
  end

  def send_otp_via_email
    current_user.send_otp_via_email
    redirect_to two_factor_authentication_path, notice: 'OTP sent via email'
  end

  def send_otp_via_sms
    current_user.send_otp_via_sms
    redirect_to two_factor_authentication_path, notice: 'OTP sent via SMS'
  end
end
