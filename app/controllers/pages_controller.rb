class PagesController < ApplicationController
  before_action :redirect_if_authenticated, only: [:landing]
  def landing
  end

  def dashboard
  end

  def profile
  end

  def settings
  end

  private

  def redirect_if_authenticated
    redirect_to authenticated_root_path if user_signed_in?
  end
  
end
