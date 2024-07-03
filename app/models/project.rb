class Project < ApplicationRecord
  belongs_to :user
  has_many_attached :files, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
