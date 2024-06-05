class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :file, :update_file, :settings]

  def index
    @projects = current_user.projects
  end

  def show
    @files = Dir.entries(@project.file_path) - %w[. ..]
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build(project_params)
    if @project.save
      create_readme if params[:project][:readme] == '1'
      save_files if params[:project][:files].present?
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      save_files if params[:project][:files].present?
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    FileUtils.rm_rf(@project.file_path)
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  def file
    @file = params[:file]
    @content = File.read(File.join(@project.file_path, @file))
  end

  def update_file
    @file = params[:file]
    File.write(File.join(@project.file_path, @file), params[:content])
    redirect_to @project, notice: 'File was successfully updated.'
  end

  def settings
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :readme, files: [])
  end

  def create_readme
    readme_path = File.join(@project.file_path, 'README.md')
    File.write(readme_path, "# #{@project.name}\n\n#{@project.description}")
  end

  def save_files
    params[:project][:files].each do |file|
      path = File.join(@project.file_path, file.original_filename)
      File.open(path, 'wb') { |f| f.write(file.read) }
    end
  end
end
