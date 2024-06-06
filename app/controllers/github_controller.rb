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
    @file_content = fetch_file_content(@repository, @file_path)
  end

  def update_file
    @repository = params[:repo_id]
    @file_path = params[:file_path]
    update_repository_file(@repository, @file_path, params[:content])
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
    contents.is_a?(Array) ? contents : [contents]
  rescue Octokit::NotFound
    []
  end

  def fetch_file_content(repo, path)
    client = Octokit::Client.new(access_token: current_user.token)
    content = client.contents(repo, path: path)
    Base64.decode64(content.content)
  rescue Octokit::NotFound
    ''
  end

  def update_repository_file(repo, path, content)
    client = Octokit::Client.new(access_token: current_user.token)
    sha = client.contents(repo, path: path).sha
    client.update_contents(repo, path, "Updated #{path}", sha, content)
  end
end
