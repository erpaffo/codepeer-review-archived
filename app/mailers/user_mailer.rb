class UserMailer < ApplicationMailer
  def send_otp(email, otp)
    @otp = otp
    mail(to: email, subject: 'Your OTP Code')
  end
end
