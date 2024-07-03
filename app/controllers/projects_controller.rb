class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def show
    @project = current_user.projects.find(params[:id])
  end

  def index
    @projects = current_user.projects
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, files: [])
  end
end
