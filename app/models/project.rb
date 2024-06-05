class Project < ApplicationRecord
  belongs_to :user
  has_many :snippets

  after_create :create_project_directory

  def file_path
    Rails.root.join('projects', user_id.to_s, id.to_s)
  end

  private

  def create_project_directory
    FileUtils.mkdir_p(file_path) unless Dir.exist?(file_path)
  end
end
