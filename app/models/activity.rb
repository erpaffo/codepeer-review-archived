# app/models/activity.rb
class Activity < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
end
