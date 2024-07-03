class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :files

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
