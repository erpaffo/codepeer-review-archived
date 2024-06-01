class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2, :github]

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
end
