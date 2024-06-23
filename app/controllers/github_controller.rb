class GithubController < ApplicationController
  before_action :authenticate_user!

  def repositories
    @repositories = fetch_github_repositories
  end

  def show_repository
    @repository = params[:id]
    @path = params[:path] || ''
    @contents = fetch_repository_contents(@repository, @path)
  end

  def edit_file
    @repository = params[:repo_id]
    @file_path = params[:file_path]
    @file_extension = File.extname(@file_path)
    Rails.logger.info "Editing file at path: #{@file_path}"
    @file_content = fetch_file_content(@repository, @file_path)
    @contents = fetch_repository_contents(@repository, '') # Fetch root contents for sidebar

    if @file_content.nil? || @file_content.empty?
      flash[:alert] = "File content is missing."
    end
  end

  def update_file
    @repository = params[:repo_id]
    @file_path = params[:file_path]
    new_content = params[:content]
    file_extension = params[:file_extension]

    # Ensure the file path includes the extension
    @file_path = ensure_full_path(@file_path, file_extension)

    Rails.logger.info "Updating file: #{@repository}/#{@file_path}"

    original_content = fetch_file_content(@repository, @file_path)

    begin
      update_repository_file(@repository, @file_path, new_content)
      create_snippet(original_content, new_content, @file_path) unless new_content.blank?

      Activity.create(user: current_user, description: "Modified file #{@file_path} in repository #{@repository}")

      redirect_to repository_path(@repository), notice: 'File was successfully updated.'
    rescue => e
      Rails.logger.error "Error updating file: #{e.message}"
      flash[:alert] = "Failed to update file. #{e.message}"
      redirect_to edit_file_path(repo_id: @repository, file_path: @file_path)
    end
  end

  private

  def fetch_github_repositories
    client = Octokit::Client.new(access_token: current_user.token)
    repositories = client.repositories
    Rails.logger.info "Fetched Repositories: #{repositories.map(&:full_name)}"
    repositories
  rescue Octokit::Unauthorized
    Rails.logger.error "GitHub Authorization Failed"
    []
  end

  def fetch_repository_contents(repo, path)
    client = Octokit::Client.new(access_token: current_user.token)
    contents = client.contents(repo, path: path)
    Rails.logger.info "Fetched contents for path #{path}: #{contents}"
    contents.is_a?(Array) ? contents : [contents]
  rescue Octokit::NotFound
    []
  end

  def fetch_file_content(repo, path)
    client = Octokit::Client.new(access_token: current_user.token)
    content = client.contents(repo, path: path)
    Rails.logger.info "Fetched file content for path #{path}"
    Base64.decode64(content.content)
  rescue Octokit::NotFound => e
    Rails.logger.error "File not found when fetching content: #{repo}/#{path} - #{e.message}"
    ''
  end

  def update_repository_file(repo, path, content)
    client = Octokit::Client.new(access_token: current_user.token)
    begin
      file = client.contents(repo, path: path)
      sha = file.sha
      Rails.logger.info "Updating file at path #{path} with sha #{sha}"
      client.update_contents(repo, path, "Updated #{path}", sha, content)
    rescue Octokit::NotFound => e
      Rails.logger.error "File not found: #{repo}/#{path} - #{e.message}"
      raise e
    rescue Octokit::Unauthorized => e
      Rails.logger.error "Unauthorized access: #{e.message}"
      raise e
    rescue => e
      Rails.logger.error "Unknown error: #{e.message}"
      raise e
    end
  end

  def create_snippet(original_content, new_content, file_path)
    return if new_content.blank?

    modifications = Diffy::Diff.new(original_content, new_content, context: 1).to_s(:html)
    current_user.snippets.create!(
      title: "Changes to #{file_path}",
      content: new_content,
      modifications: modifications,
      file_path: file_path
    )
  end

  def ensure_full_path(path, extension)
    if extension.present? && !path.end_with?(extension)
      path += extension
    end
    path
  end
end
