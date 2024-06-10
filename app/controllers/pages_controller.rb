# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  before_action :redirect_if_authenticated, only: [:landing]
  before_action :authenticate_user!, only: [:dashboard, :profile, :settings, :connect_account, :confirm_merge_account]

  def landing
  end

  def dashboard
  end

  def profile
  end

  def settings
  end

  def connect_account
    # Logica per la pagina di connessione degli account
  end

  def confirm_merge_account
    @pending_github_user = User.find(session[:pending_github_user_id])
  end

  def merge_accounts
    pending_github_user = User.find(params[:pending_github_user_id])
    if pending_github_user
      current_user.update(
        provider: pending_github_user.provider,
        uid: pending_github_user.uid,
        token: pending_github_user.token,
        refresh_token: pending_github_user.refresh_token
      )
      pending_github_user.destroy
      redirect_to connect_account_path, notice: 'Accounts merged successfully.'
    else
      redirect_to connect_account_path, alert: 'Unable to merge accounts.'
    end
  end

  private

  def redirect_if_authenticated
    redirect_to authenticated_root_path if user_signed_in?
  end
end
