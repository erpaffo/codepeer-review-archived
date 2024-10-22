class TwoFactorAuthenticationController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @enabled_methods = enabled_two_factor_methods
    @available_methods = available_two_factor_methods

    if @enabled_methods.include?('app')
      totp = ROTP::TOTP.new(@user.otp_secret, issuer: "Codepeer Review")
      @qr_code = RQRCode::QRCode.new(totp.provisioning_uri(@user.email)).as_png(size: 200).to_data_url
    end
  end

  def send_otp
    @user = current_user
    method = params[:two_factor_method]

    case method
    when 'email'
      @user.send_otp_via_email
      flash[:notice] = 'OTP sent via email successfully'
      redirect_to verify_otp_two_factor_authentication_form_path(two_factor_method: method)
    when 'sms'
      phone_number = params[:phone_number]
      if phone_number.present? && valid_phone_number?(phone_number)
        @user.update(phone_number: phone_number)
        @user.send_otp_via_sms
        flash[:notice] = 'OTP sent via SMS successfully'
        redirect_to verify_otp_two_factor_authentication_form_path(two_factor_method: method)
      else
        flash[:alert] = 'Invalid phone number'
        redirect_to two_factor_authentication_path
      end
    when 'app'
      totp = ROTP::TOTP.new(@user.otp_secret, issuer: "Codepeer Review")
      @qr_code = RQRCode::QRCode.new(totp.provisioning_uri(@user.email)).as_png(size: 200).to_data_url
      flash[:notice] = 'Scan the QR code with your Authenticator app'
      redirect_to qr_code_two_factor_authentication_path(qr_code: @qr_code)
    end
  end

  def qr_code
    @qr_code = params[:qr_code]
  end

  def verify_otp_form
    @two_factor_method = params[:two_factor_method]
  end

  def verify_otp
    @user = current_user
    method = params[:two_factor_method]
    totp = ROTP::TOTP.new(@user.otp_secret)

    if totp.verify(params[:otp_code], drift_behind: 15, drift_ahead: 15)
      @user.update(two_factor_enabled: true, two_factor_method: method)
      session[:two_factor_verified] = true
      flash[:notice] = 'Two-factor authentication enabled successfully'
      redirect_to authenticated_root_path
    else
      flash[:alert] = 'Invalid OTP code'
      redirect_to qr_code_two_factor_authentication_path
    end
  end

  def resend_otp
    send_otp
  end

  def disable
    @user = current_user
    method = params[:two_factor_method]

    if method == 'email' || method == 'sms'
      @user.update(two_factor_enabled: false, two_factor_method: nil)
      flash[:notice] = "Two-factor authentication via #{method} disabled successfully"
    elsif method == 'app'
      @user.update(two_factor_enabled: false, two_factor_method: nil, otp_secret: nil)
      flash[:notice] = 'Two-factor authentication via Authenticator app disabled successfully'
    end

    redirect_to two_factor_authentication_path
  end

  private

  def valid_phone_number?(phone_number)
    phone_number.match?(/\A\+?[1-9]\d{1,14}\z/)
  end

  def enabled_two_factor_methods
    methods = []
    methods << 'email' if current_user.two_factor_method == 'email'
    methods << 'sms' if current_user.two_factor_method == 'sms'
    methods << 'app' if current_user.two_factor_method == 'app'
    methods
  end

  def available_two_factor_methods
    ['email', 'sms', 'app'] - enabled_two_factor_methods
  end
end
