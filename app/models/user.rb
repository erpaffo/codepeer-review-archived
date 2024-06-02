require 'rotp'

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github]

  attr_accessor :terms_of_service
  before_create :generate_otp_secret
  before_save :generate_otp_secret, if: :otp_secret_nil?

  # Validations
  validates :terms_of_service, acceptance: true, on: :create

  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random_base32
  end

  def otp_secret_nil?
    otp_secret.nil?
  end

  def send_otp_via_email
    otp_code = generate_otp
    self.update(otp_code: otp_code, otp_sent_at: Time.current)
    UserMailer.send_otp(self, otp_code).deliver_now
  end

  def send_otp_via_sms
    otp_code = generate_otp
    self.update(otp_code: otp_code, otp_sent_at: Time.current)
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: self.phone_number,
      body: "Your OTP code is #{otp_code}"
    )
  end

  def send_otp_via_app
    ROTP::TOTP.new(self.otp_secret).provisioning_uri(self.email, issuer: "Codepeer Review")
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.surname = auth.info.last_name # assuming the user model has a surname
      user.nickname = auth.info.nickname # assuming the user model has a nickname
      user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!      # don't require email confirmation
    end.tap do |user|
      user.update(
        name: auth.info.name,
        surname: auth.info.last_name,
        nickname: auth.info.nickname,
        image: auth.info.image,
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token
      )
    end
  end

  def generate_otp
    ROTP::TOTP.new(self.otp_secret).now
  end
end
