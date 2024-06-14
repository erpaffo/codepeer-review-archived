# app/models/project.rb
class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :files

  validates :name, presence: true
  validates :description, presence: true
  validate :acceptable_file_size

  def acceptable_file_size
    files.each do |file|
      if file.byte_size > 10.megabytes
        errors.add(:files, "is too big. Each file should be less than 10 MB")
      end
    end
  end
end
