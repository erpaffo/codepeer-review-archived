require 'rotp'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

  before_save :generate_otp_secret, if: :otp_secret_nil?

  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random_base32
  end

  def otp_secret_nil?
    otp_secret.nil?
  end

  def send_otp_via_email
    otp = ROTP::TOTP.new(self.otp_secret).now
    UserMailer.send_otp(self.email, otp).deliver_now
  end

  def send_otp_via_sms
    otp = ROTP::TOTP.new(self.otp_secret).now
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: self.phone_number,
      body: "Your OTP code is #{otp}"
    )
  end

  def send_otp_via_app
    ROTP::TOTP.new(self.otp_secret).provisioning_uri(self.email, issuer: "Codepeer Review")
  end
end
