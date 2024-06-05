class GithubController < ApplicationController
  before_action :authenticate_user!

  def repositories
    @repositories = fetch_github_repositories
  end

  def show_repository
    @repository = params[:id]
    @files = fetch_repository_files(@repository)
  end

  def edit_file
    @repository = params[:repo_id]
    @file_path = params[:id]
    @file_content = fetch_file_content(@repository, @file_path)
  end

  def update_file
    @repository = params[:repo_id]
    @file_path = params[:id]
    update_repository_file(@repository, @file_path, params[:content])
    redirect_to repository_path(@repository), notice: 'File was successfully updated.'
  end

  private

  def fetch_github_repositories
    client = Octokit::Client.new(access_token: current_user.token)
    client.repositories
  end

  def fetch_repository_files(repo)
    client = Octokit::Client.new(access_token: current_user.token)
    client.contents(repo)
  end

  def fetch_file_content(repo, path)
    client = Octokit::Client.new(access_token: current_user.token)
    Base64.decode64(client.contents(repo, path: path).content)
  end

  def update_repository_file(repo, path, content)
    client = Octokit::Client.new(access_token: current_user.token)
    sha = client.contents(repo, path: path).sha
    client.update_contents(repo, path, "Updated #{path}", sha, content)
  end
end
