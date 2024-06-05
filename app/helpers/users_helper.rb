# app/helpers/users_helper.rb
module UsersHelper
  def profile_image_for(user)
    if user.image.attached?
      url_for(user.image)
    else
      asset_path('default_profile_image.png')
    end
  end
end
