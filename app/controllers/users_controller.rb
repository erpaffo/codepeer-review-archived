class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    # Profile logic here
  end

  def connect_account
    # Logic for connecting accounts (GitHub, GitLab) here
  end

  def enable_two_factor
    current_user.update!(otp_required_for_login: true)
    current_user.update!(otp_secret: User.generate_otp_secret)
    redirect_to user_two_factor_setup_path, notice: '2FA enabled. Scan the QR code with your 2FA app.'
  end

  def disable_two_factor
    current_user.update!(otp_required_for_login: false)
    redirect_to user_two_factor_setup_path, notice: '2FA disabled.'
  end
end
