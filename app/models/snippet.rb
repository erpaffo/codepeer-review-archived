class Snippet < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true
  validates :modifications, presence: true
  validates :file_path, presence: true
end
