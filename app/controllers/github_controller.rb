# app/controllers/github_controller.rb
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
  end

  def update_file
    @repository = params[:repo_id]
    @file_path = params[:file_path]
    @file_extension = File.extname(@file_path)
    new_content = params[:content]

    full_path = ensure_extension(@repository, @file_path)

    Rails.logger.info "Updating file: #{@repository}/#{full_path}"

    original_content = fetch_file_content(@repository, full_path)

    Rails.logger.info "Full path after ensuring extension: #{full_path}"

    update_repository_file(@repository, full_path, new_content)

    create_snippet(original_content, new_content, full_path) unless new_content.blank?

    redirect_to repository_path(@repository), notice: 'File was successfully updated.'
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
    full_path = ensure_extension(repo, path)
    Rails.logger.info "Fetching file content for path #{full_path}"
    content = client.contents(repo, path: full_path)
    Rails.logger.info "Fetched file content for path #{full_path}"
    Base64.decode64(content.content)
  rescue Octokit::NotFound => e
    Rails.logger.error "File not found when fetching content: #{repo}/#{full_path} - #{e.message}"
    ''
  end

  def update_repository_file(repo, path, content)
    client = Octokit::Client.new(access_token: current_user.token)
    full_path = ensure_extension(repo, path)
    begin
      file = client.contents(repo, path: full_path)
      sha = file.sha
      Rails.logger.info "Updating file at path #{full_path} with sha #{sha}"
      client.update_contents(repo, full_path, "Updated #{full_path}", sha, content)
    rescue Octokit::NotFound => e
      Rails.logger.error "File not found: #{repo}/#{full_path} - #{e.message}"
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

  def ensure_extension(repo, path)
    dir = File.dirname(path)
    filename = File.basename(path)
    client = Octokit::Client.new(access_token: current_user.token)

    Rails.logger.info "Listing contents of directory: #{dir}"
    contents = client.contents(repo, path: dir)

    file = contents.find { |item| item.name.start_with?(filename) }

    if file
      Rails.logger.info "File found: #{file.name}"
      File.join(dir, file.name)
    else
      Rails.logger.error "File not found in directory listing: #{path}"
      path # return the original path if the file is not found
    end
  end
end
