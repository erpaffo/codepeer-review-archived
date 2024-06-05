class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @snippets = @user.snippets
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_profile_path, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:nickname, :bio, :profile_picture)
  end
end
