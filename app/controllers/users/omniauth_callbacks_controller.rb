# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth("Google")
  end

  def github
    handle_auth("GitHub")
  end

  def failure
    redirect_to unauthenticated_root_path
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      if user_signed_in?
        if @user.id != current_user.id
          session[:pending_github_user_id] = @user.id
          redirect_to confirm_merge_account_path, notice: "GitHub account is already connected to another account. Do you want to merge accounts?"
        else
          redirect_to connect_account_path, notice: "#{kind} account already connected."
        end
      else
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
        sign_in_and_redirect @user, event: :authentication
      end
    else
      session["devise.auth_data"] = request.env["omniauth.auth"].except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
