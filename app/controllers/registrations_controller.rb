class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    edit_user_registration_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def build_resource(hash = {})
    hash[:email] = params[:email] if params[:email]
    super
  end
end
