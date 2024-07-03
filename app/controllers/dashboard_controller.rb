class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def my_projects
    @projects = current_user.projects
  end
end
